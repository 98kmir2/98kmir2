unit WebControl;

interface
uses
  Windows, Messages, Controls, SysUtils, ActiveX, Graphics, SHDocVw, MSHTML, OleCtrls, Variants;

type
  { TWEBClientSite }

  TWEBClientSite = class(TObject, IUnknown, IOleClientSite, IOleInPlaceFrame, IOleInPlaceSite)
  private
    FRefCount: Integer;
    FhWindow: HWND;
  protected

  public
    constructor Create; overload;
    constructor Create(wnd: HWND); overload;
    destructor Destroy; override;

    {IUnknown}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    { IOleClientSite }
    function SaveObject: HResult; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      out mk: IMoniker): HResult; stdcall;
    function GetContainer(out container: IOleContainer): HResult; stdcall;
    function ShowObject: HResult; stdcall;
    function OnShowWindow(fShow: BOOL): HResult; stdcall;
    function RequestNewObjectLayout: HResult; stdcall;

    {IOleWindow}
    function GetWindow(out wnd: HWND): HResult; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HResult; stdcall;

    {IOleInPlaceUIWindow}
    function GetBorder(out rectBorder: TRect): HResult; stdcall;
    function RequestBorderSpace(const borderwidths: TRect): HResult; stdcall;
    function SetBorderSpace(pborderwidths: PRect): HResult; stdcall;
    function SetActiveObject(const activeObject: IOleInPlaceActiveObject;
      pszObjName: POleStr): HResult; stdcall;

    {IOleInPlaceFrame}
    function InsertMenus(hmenuShared: HMenu;
      var menuWidths: TOleMenuGroupWidths): HResult; stdcall;
    function SetMenu(hmenuShared: HMenu; holemenu: HMenu;
      hwndActiveObject: HWND): HResult; stdcall;
    function RemoveMenus(hmenuShared: HMenu): HResult; stdcall;
    function SetStatusText(pszStatusText: POleStr): HResult; stdcall;
    function EnableModeless(fEnable: BOOL): HResult; stdcall;
    function TranslateAccelerator(var msg: TMsg; wID: Word): HResult; stdcall;

    {IOleInPlaceSite}
    function CanInPlaceActivate: HResult; stdcall;
    function OnInPlaceActivate: HResult; stdcall;
    function OnUIActivate: HResult; stdcall;
    function GetWindowContext(out frame: IOleInPlaceFrame;
      out doc: IOleInPlaceUIWindow; out rcPosRect: TRect;
      out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HResult;
      stdcall;
    function Scroll(scrollExtent: TPoint): HResult; stdcall;
    function OnUIDeactivate(fUndoable: BOOL): HResult; stdcall;
    function OnInPlaceDeactivate: HResult; stdcall;
    function DiscardUndoState: HResult; stdcall;
    function DeactivateAndUndo: HResult; stdcall;
    function OnPosRectChange(const rcPosRect: TRect): HResult; stdcall;
  published
  end;

  { TWEBStorage }
  TWEBStorage = class(TObject, IUnknown, IStorage)
  private
    FRefCount: Integer;
  protected

  public
    constructor Create;
    destructor Destroy; override;

    {IUnknown}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    {IStorage}
    function CreateStream(pwcsName: POleStr; grfMode: Longint; reserved1: Longint;
      reserved2: Longint; out stm: IStream): HResult; stdcall;
    function OpenStream(pwcsName: POleStr; reserved1: Pointer; grfMode: Longint;
      reserved2: Longint; out stm: IStream): HResult; stdcall;
    function CreateStorage(pwcsName: POleStr; grfMode: Longint;
      dwStgFmt: Longint; reserved2: Longint; out stg: IStorage): HResult;
      stdcall;
    function OpenStorage(pwcsName: POleStr; const stgPriority: IStorage;
      grfMode: Longint; snbExclude: TSNB; reserved: Longint;
      out stg: IStorage): HResult; stdcall;
    function CopyTo(ciidExclude: Longint; rgiidExclude: PIID;
      snbExclude: TSNB; const stgDest: IStorage): HResult; stdcall;
    function MoveElementTo(pwcsName: POleStr; const stgDest: IStorage;
      pwcsNewName: POleStr; grfFlags: Longint): HResult; stdcall;
    function Commit(grfCommitFlags: Longint): HResult; stdcall;
    function Revert: HResult; stdcall;
    function EnumElements(reserved1: Longint; reserved2: Pointer; reserved3: Longint;
      out enm: IEnumStatStg): HResult; stdcall;
    function DestroyElement(pwcsName: POleStr): HResult; stdcall;
    function RenameElement(pwcsOldName: POleStr;
      pwcsNewName: POleStr): HResult; stdcall;
    function SetElementTimes(pwcsName: POleStr; const ctime: TFileTime;
      const atime: TFileTime; const mtime: TFileTime): HResult;
      stdcall;
    function SetClass(const clsid: TCLSID): HResult; stdcall;
    function SetStateBits(grfStateBits: Longint; grfMask: Longint): HResult;
      stdcall;
    function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult;
      stdcall;
  published
  end;

  { TCWebBrowser }
  TCWebBrowser = class(TObject)
  private
    FOleObject: IOleObject;
    FWebInterface: IWebBrowser2;
    FOleInPlaceObject: IOleInPlaceObject;
    FOleInPlaceActiveObject: IOleInPlaceActiveObject;

    FWebHwnd: HWND;
    FURL: string;

    m_hWebDC: HDC;
    m_hBitmap: HBITMAP;
    m_pFrameBuffer: Pointer;
    m_nLastFrame: Integer;
    m_Brush: TBrush;
    m_nWidth: Longint;
    m_nHeight: Longint;
  protected
    function GetDefaultInterface: IWebBrowser2;
    procedure UnEmbedBrowserObject();
    function EmbedBrowserObject(): Longint;
    procedure CleanupBuffer();
    procedure RebuildBuffer();
    procedure SetURL(const Value: string);
    procedure SendWebMessage(msg: UINT; wParam: wParam; lParam: lParam);
    function Click(nX, nY: Integer): Boolean;

  public
    constructor Create();
    destructor Destroy; override;
    function Init(wnd: HWND; nWidth, nHeight: Longint): HResult;
    function GetElementAtPos(nX, nY: Integer): IHTMLElement;
    function Update: Boolean;
    function Render(): Boolean;

    procedure SetSize(AWidth, AHeight: Integer);
    function GetFlashFrameBuffer(): Pointer;
    property Buffer: Pointer read GetFlashFrameBuffer;

    procedure MouseMove(X, Y: Integer);
    procedure MouseLButtonDown(X, Y: Integer);
    procedure MouseLButtonUp(X, Y: Integer);

    // procedure KeyPress (var Key: Char);
    // procedure KeyDown(var Key: Word; Shift: TShiftState);
    // procedure KeyUp(var Key: Word; Shift: TShiftState);

    function getDocumentHWND(): HWND;
  published
    property DefaultInterface: IWebBrowser2 read GetDefaultInterface;
    property URL: string read FURL write SetURL;
    property BITMAP: HBITMAP read m_hBitmap;
    property Handle: HDC read m_hWebDC;

  end;

implementation

function CheckGUID(IID1, IID2: TGUID): Boolean;
var
  I                         : Integer;
begin
  Result := True;
  if (IID1.D1 = IID2.D1) and (IID1.D2 = IID2.D2) and (IID1.D3 = IID2.D3) then begin
    for I := 0 to 7 do begin
      if IID1.D4[I] <> IID2.D4[I] then begin
        Result := False;
        Break;
      end;
    end;
  end else
    Result := False;
end;

{ TWEBClientSite }

constructor TWEBClientSite.Create;
begin
  FRefCount := 0;
end;

constructor TWEBClientSite.Create(wnd: HWND);
begin
  FRefCount := 0;
  FhWindow := wnd;
end;

destructor TWEBClientSite.Destroy;
begin
  inherited;
end;

//==============={IUnknown}======================

function TWEBClientSite.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Pointer(Obj) := nil;
  Result := E_NOINTERFACE;
  if CheckGUID(IID, IUnknown) then begin
    IUnknown(Obj) := IUnknown(Self);
    Result := S_OK;
  end else if CheckGUID(IID, IOleClientSite) then begin
    IOleClientSite(Obj) := IOleClientSite(Self);
    Result := S_OK;
  end else if CheckGUID(IID, IOleInPlaceSite) then begin
    IOleInPlaceSite(Obj) := IOleInPlaceSite(Self);
    Result := S_OK;
  end else if CheckGUID(IID, IOleInPlaceFrame) then begin
    IOleInPlaceFrame(Obj) := IOleInPlaceFrame(Self);
    Result := S_OK;
  end else
    if GetInterface(IID, Obj) then
      Result := S_OK;
end;

function TWEBClientSite._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TWEBClientSite._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

//========== { IOleClientSite }==============

function TWEBClientSite.SaveObject: HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.GetMoniker(dwAssign, dwWhichMoniker: Integer; out mk: IMoniker): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.GetContainer(out container: IOleContainer): HResult;
begin
  container := nil;
  Result := E_NOINTERFACE;
end;

function TWEBClientSite.ShowObject: HResult;
begin
  Result := NOERROR;
end;

function TWEBClientSite.OnShowWindow(fShow: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.RequestNewObjectLayout: HResult;
begin
  Result := E_NOTIMPL;
end;

//============ IOleWindow =============

function TWEBClientSite.GetWindow(out wnd: HWND): HResult;
begin
  wnd := FhWindow;
  Result := S_OK;
end;

function TWEBClientSite.ContextSensitiveHelp(fEnterMode: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

//==============={IOleInPlaceUIWindow}=============

function TWEBClientSite.GetBorder(out rectBorder: TRect): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.RequestBorderSpace(const borderwidths: TRect): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.SetBorderSpace(pborderwidths: PRect): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.SetActiveObject(const activeObject: IOleInPlaceActiveObject;
  pszObjName: POleStr): HResult;
begin
  Result := S_OK;
end;

//================  {IOleInPlaceFrame} ==============

function TWEBClientSite.InsertMenus(hmenuShared: HMenu;
  var menuWidths: TOleMenuGroupWidths): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.SetMenu(hmenuShared: HMenu; holemenu: HMenu;
  hwndActiveObject: HWND): HResult;
begin
  Result := S_OK;
end;

function TWEBClientSite.RemoveMenus(hmenuShared: HMenu): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.SetStatusText(pszStatusText: POleStr): HResult;
begin
  Result := S_OK;
end;

function TWEBClientSite.EnableModeless(fEnable: BOOL): HResult;
begin
  Result := S_OK;
end;

function TWEBClientSite.TranslateAccelerator(var msg: TMsg; wID: Word): HResult;
begin
  Result := E_NOTIMPL;
end;

// ========={IOleInPlaceSite}==============

function TWEBClientSite.CanInPlaceActivate: HResult;
begin
  Result := S_OK;
end;

function TWEBClientSite.OnInPlaceActivate: HResult;
begin
  Result := S_OK;
end;

function TWEBClientSite.OnUIActivate: HResult;
begin
  Result := S_OK;
end;

function TWEBClientSite.GetWindowContext(out frame: IOleInPlaceFrame;
  out doc: IOleInPlaceUIWindow; out rcPosRect: TRect;
  out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HResult;
begin
  frame := IOleInPlaceFrame(Self);      // maybe incorrect
  // We have no OLEINPLACEUIWINDOW
  doc := nil;

  // Fill in some other info for the browser
  frameInfo.fMDIApp := False;
  frameInfo.hwndFrame := FhWindow;      // maybe incorrect
  frameInfo.haccel := 0;
  frameInfo.cAccelEntries := 0;

  // Give the browser the dimensions of where it can draw. We give it our entire window to fill
  GetClientRect(frameInfo.hwndFrame, rcPosRect);
  GetClientRect(frameInfo.hwndFrame, rcClipRect);

  Result := S_OK;
end;

function TWEBClientSite.Scroll(scrollExtent: TPoint): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.OnUIDeactivate(fUndoable: BOOL): HResult;
begin
  Result := S_OK;
end;

function TWEBClientSite.OnInPlaceDeactivate: HResult;
begin
  Result := S_OK;
end;

function TWEBClientSite.DiscardUndoState: HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.DeactivateAndUndo: HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBClientSite.OnPosRectChange(const rcPosRect: TRect): HResult;
begin
  Result := S_OK;
end;

{ TWEBStorage }

constructor TWEBStorage.Create;
begin
end;

destructor TWEBStorage.Destroy;
begin
  inherited;
end;

function TWEBStorage.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TWEBStorage._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TWEBStorage._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

//===========  {IStorage}======

function TWEBStorage.CreateStream(pwcsName: POleStr; grfMode: Longint; reserved1: Longint;
  reserved2: Longint; out stm: IStream): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.OpenStream(pwcsName: POleStr; reserved1: Pointer; grfMode: Longint;
  reserved2: Longint; out stm: IStream): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.CreateStorage(pwcsName: POleStr; grfMode: Longint;
  dwStgFmt: Longint; reserved2: Longint; out stg: IStorage): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.OpenStorage(pwcsName: POleStr; const stgPriority: IStorage;
  grfMode: Longint; snbExclude: TSNB; reserved: Longint;
  out stg: IStorage): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.CopyTo(ciidExclude: Longint; rgiidExclude: PIID;
  snbExclude: TSNB; const stgDest: IStorage): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.MoveElementTo(pwcsName: POleStr; const stgDest: IStorage;
  pwcsNewName: POleStr; grfFlags: Longint): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.Commit(grfCommitFlags: Longint): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.Revert: HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.EnumElements(reserved1: Longint; reserved2: Pointer; reserved3: Longint;
  out enm: IEnumStatStg): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.DestroyElement(pwcsName: POleStr): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.RenameElement(pwcsOldName: POleStr;
  pwcsNewName: POleStr): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.SetElementTimes(pwcsName: POleStr; const ctime: TFileTime;
  const atime: TFileTime; const mtime: TFileTime): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.SetClass(const clsid: TCLSID): HResult;
begin
  Result := S_OK;
end;

function TWEBStorage.SetStateBits(grfStateBits: Longint; grfMask: Longint): HResult;
begin
  Result := E_NOTIMPL;
end;

function TWEBStorage.Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult;
begin
  Result := E_NOTIMPL;
end;

{ TCWebBrowser }

constructor TCWebBrowser.Create();
begin
  FOleObject := nil;
  FWebInterface := nil;
  FOleInPlaceObject := nil;
  FOleInPlaceActiveObject := nil;
  m_nWidth := 30;
  m_nHeight := 50;
  m_hWebDC := 0;
  m_hBitmap := 0;
  m_pFrameBuffer := nil;
  m_Brush := TBrush.Create;
  m_Brush.Color := $080808;
  ;
  m_Brush.Style := bsSolid;
end;

destructor TCWebBrowser.Destroy;
begin
  DestroyWindow(FWebHwnd);
  FWebHwnd := 0;
  UnEmbedBrowserObject();
  CleanupBuffer();
  m_Brush.Free;
  FOleObject := nil;
  FWebInterface := nil;
  FOleInPlaceObject := nil;
  FOleInPlaceActiveObject := nil;

  inherited;
end;

function TCWebBrowser.Init(wnd: HWND; nWidth, nHeight: Longint): HResult;
const
  WINDOW_CLASS_NAME         = 'static';
begin
  m_nWidth := nWidth;
  m_nHeight := nHeight;
  FWebHwnd := CreateWindowEx(0, WINDOW_CLASS_NAME, 'Webbrowser', WS_POPUPWINDOW, 0, 0, m_nWidth, m_nHeight, wnd, 0, hInstance, nil);
  EmbedBrowserObject();
  RebuildBuffer();
end;

function TCWebBrowser.GetDefaultInterface: IWebBrowser2;
begin
  Assert(FWebInterface <> nil);
  Result := FWebInterface;
end;

function TCWebBrowser.EmbedBrowserObject: Longint;
var
  rect                      : TRect;
  Storage                   : TWEBStorage;
  pClientSite               : TWEBClientSite;
  pDoc                      : IDispatch;
begin
  Result := -2;
  pClientSite := TWEBClientSite.Create(FWebHwnd);
  try
    Storage := TWEBStorage.Create;
    try
      if OleCreate(CLASS_WebBrowser, IOleObject, OLERENDER_DRAW, 0,
        pClientSite, Storage, FOleObject) = S_OK then begin
        FOleObject.SetHostNames('My Host Name', 0);
        FOleObject.QueryInterface(IOleInPlaceObject, FOleInPlaceObject);
        FOleObject.QueryInterface(IOleInPlaceActiveObject, FOleInPlaceActiveObject);
        GetClientRect(FWebHwnd, rect);
        if (OleSetContainedObject(IUnknown(FOleObject), True)) = S_OK then begin
          if (FOleObject.DoVerb(OLEIVERB_INPLACEACTIVATE, nil, IOleClientSite(pClientSite), 0, FWebHwnd, rect)) = S_OK then begin
            if (FOleObject.QueryInterface(IID_IWebBrowser2, FWebInterface)) = S_OK then begin
              FWebInterface.Set_Left(0);
              FWebInterface.Set_Top(0);
              FWebInterface.Set_Width(rect.Right);
              FWebInterface.Set_Height(rect.Bottom);
              Result := 0;
              Exit;
            end;
          end;
        end;
      end;
    finally
      Storage.Free;
    end;
  except
    pClientSite.Free;
    UnEmbedBrowserObject();
    Result := -3;
  end;
end;

procedure TCWebBrowser.UnEmbedBrowserObject;
begin
  if (FOleObject <> nil) then begin
    FOleObject.Close(OLECLOSE_NOSAVE);
    FOleObject.SetClientSite(nil);
    FOleObject := nil;
  end;
end;

function TCWebBrowser.Click(nX, nY: Integer): Boolean;
var
  pElement                  : IHTMLElement;
begin
  pElement := GetElementAtPos(nX, nY);
  if pElement <> nil then pElement.Click;
end;

function TCWebBrowser.getDocumentHWND(): HWND;
var
  docDispatch               : IDispatch;
  doc                       : IHTMLDocument2;
  docWindow                 : IOleWindow;
  wnd                       : HWND;
begin
  Result := 0;
  if (FWebInterface = nil) then Exit;
  docDispatch := nil;
  docDispatch := FWebInterface.get_Document();
  if docDispatch = nil then Exit;
  doc := nil;
  docDispatch.QueryInterface(IID_IHTMLDocument2, doc);
  if doc = nil then Exit;
  docWindow := nil;
  if FAILED(doc.QueryInterface(IOleWindow, docWindow)) then Exit;
  wnd := 0;
  docWindow.GetWindow(wnd);
  Result := wnd;
end;

procedure TCWebBrowser.MouseMove(X, Y: Integer);
begin
  SendWebMessage(WM_MOUSEMOVE, 0, MAKELPARAM(X - 1, Y - 1));
end;

procedure TCWebBrowser.MouseLButtonDown(X, Y: Integer);
begin
  //Click(X, Y);
  //SendWebMessage(WM_LBUTTONDOWN,MK_LBUTTON,MAKELPARAM( x, y ) );
  //SendWebMessage(WM_LBUTTONUP,MK_LBUTTON,MAKELPARAM( x, y ) );
end;

procedure TCWebBrowser.MouseLButtonUp(X, Y: Integer);
begin
  Click(X - 1, Y - 1);
  //SendWebMessage(WM_LBUTTONUP,MK_LBUTTON,MAKELPARAM( x, y ) );
 // SetWindowPos(FWebHwnd, nil, x, y, 0, 0, SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOSIZE);
end;

procedure TCWebBrowser.SendWebMessage(msg: UINT; wParam: wParam; lParam: lParam);
var
  wnd                       : HWND;
begin
  wnd := getDocumentHWND();
  //SendMessage( wnd, WM_MOUSEACTIVATE, FWebHwnd, MAKELPARAM( HTCLIENT, WM_LBUTTONDOWN ) );
  PostMessage(wnd, msg, wParam, lParam);
  //SendMessage( wnd, WM_MOUSEACTIVATE, FWebHwnd, MAKELPARAM( HTCLIENT, WM_LBUTTONDOWN ) );
  //PostMessage( wnd, WM_MOUSEMOVE, 0, MAKELPARAM( x, y ) );
  //PostMessage( wnd, WM_LBUTTONDOWN, MK_LBUTTON, MAKELPARAM( x, y ) );
  //PostMessage( wnd, WM_LBUTTONUP, MK_LBUTTON, MAKELPARAM( x, y ) );
end;

procedure TCWebBrowser.RebuildBuffer;
var
  desktop_dc                : HDC;
  bmpinfo                   : TBITMAPINFO;
  DevMode                   : TDevMode;
begin
  CleanupBuffer();
  DevMode.dmFields := DevMode.dmFields or DM_BITSPERPEL;
  if EnumDisplaySettings(nil, 0, DevMode) then begin
    DevMode.dmBitsPerPel := 32;
    desktop_dc := CreateDC(nil, nil, nil, @DevMode);
  end else desktop_dc := GetDC(FWebHwnd);
  m_hWebDC := CreateCompatibleDC(desktop_dc);

  FillChar(bmpinfo, sizeof(TBITMAPINFO), 0);
  bmpinfo.bmiHeader.biSize := sizeof(bmpinfo);
  bmpinfo.bmiHeader.biPlanes := 1;
  bmpinfo.bmiHeader.biBitCount := 32;
  bmpinfo.bmiHeader.biCompression := BI_RGB;
  bmpinfo.bmiHeader.biWidth := m_nWidth;
  bmpinfo.bmiHeader.biHeight := -m_nHeight;

  m_hBitmap := CreateDIBSection(m_hWebDC, bmpinfo, DIB_RGB_COLORS, m_pFrameBuffer, 0, 0);
  SelectObject(m_hWebDC, m_hBitmap);
  // vietdoor's code start here
  SetMapMode(m_hWebDC, MM_TEXT);
  // vietdoor's code end here
  SetBkMode(m_hWebDC, Windows.TRANSPARENT);
  SetBkColor(m_hWebDC, 0);
end;

procedure TCWebBrowser.CleanupBuffer;
begin
  if (m_hBitmap <> 0) then
    DeleteObject(m_hBitmap);
  if (m_hWebDC <> 0) then
    DeleteDC(m_hWebDC);
  m_pFrameBuffer := nil;
end;

function TCWebBrowser.GetElementAtPos(nX, nY: Integer): IHTMLElement;
var
  pDoc                      : IDispatch;
  pHTMLDoc                  : IHTMLDocument2;
  pDispatch                 : IDispatch;
  hr                        : HResult;
  s                         : string;
  v                         : Variant;
  sty                       : IHTMLStyle;
begin
  Result := nil;
  if (FWebInterface <> nil) then begin
    pDoc := nil;
    pDoc := FWebInterface.get_Document();
    if (pDoc <> nil) then begin
      pHTMLDoc := nil;
      pDispatch := nil;
      hr := pDoc.QueryInterface(IID_IHTMLDocument2, pHTMLDoc);
      hr := hr + pDoc.QueryInterface(IDispatch, pDispatch);
      if SUCCEEDED(hr) and (pHTMLDoc <> nil) then begin
        Result := pHTMLDoc.elementFromPoint(nX, nY);
        //        if Result<>nil then begin
        //          if (Result is IHTMLLinkElement) then
        //          else Result:=nil
        //        end;
      end;
    end;
  end;
  pDispatch := nil;
  pHTMLDoc := nil;
  pDoc := nil;
end;

function TCWebBrowser.GetFlashFrameBuffer: Pointer;
begin
  Result := m_pFrameBuffer;
end;

procedure TCWebBrowser.SetURL(const Value: string);
var
  vFlag                     : Variant;
begin
  if (FWebInterface <> nil) and (Value <> '') then begin
    FWebInterface.Navigate2(Value, vFlag, vFlag, vFlag, vFlag);
  end;
end;

procedure TCWebBrowser.SetSize(AWidth, AHeight: Integer);
begin
  if (m_nWidth <> AWidth) or (m_nHeight <> AHeight) then begin
    if MoveWindow(FWebHwnd, 0, 0, AWidth, AHeight, True) = True then begin
      m_nWidth := AWidth;
      m_nHeight := AHeight;
      RebuildBuffer();
      if FWebInterface <> nil then begin
        FWebInterface.Set_Width(m_nWidth);
        FWebInterface.Set_Height(m_nHeight);
      end;
    end;
  end;
end;

function TCWebBrowser.Update: Boolean;
begin

end;

function TCWebBrowser.Render: Boolean;
var
  aRect                     : TRect;
  aResult                   : HResult;
begin
  Result := False;
  if FWebInterface <> nil then begin
    aRect.Left := 0;
    aRect.Top := 0;
    aRect.Right := m_nWidth;
    aRect.Bottom := m_nHeight;
    aResult := OleDraw(FWebInterface, DVASPECT_CONTENT, m_hWebDC, aRect);
    Result := aResult = S_OK;
  end;
end;

initialization
  OleInitialize(nil);

finalization
  OleUninitialize();

end.

