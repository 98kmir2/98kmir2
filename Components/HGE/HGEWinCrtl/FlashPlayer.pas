unit FlashPlayer;

interface
uses
  Windows, Messages, SysUtils, Classes, ActiveX, ComObj, Stdvcl, ShockwaveFlash, InZLibEx, Graphics;

type
  // FLASH 播放状态
  TFLASHSTATE = (STATE_IDLE,
    STATE_PLAYING,
    STATE_STOPPED
    );
  // FLASH 播放品质
  TFLASHQUALITY = (QUALITY_LOW,
    QUALITY_MEDIUM,
    QUALITY_HIGH
    );

  TFlashPlayer = class;

  { TFlashSink }
  TFlashSink = class(TObject, IShockwaveFlashEvents)
  private
    m_ConnectionPoint: IConnectionPoint;
    m_dwCookie: Longint;
    m_pFlashWidget: TFlashPlayer;
    m_nRefCount: Longint;
  protected

  public
    constructor Create;
    destructor Destroy; override;
    function Init(theFlashWidget: TFlashPlayer): HRESULT;
    function Shutdown(): HRESULT;
    {IInterface}
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IDispatch }
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HRESULT; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HRESULT; stdcall;
    function GetTypeInfoCount(out Count: Integer): HRESULT; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HRESULT; stdcall;
    { IShockwaveFlashEvents }
    function OnReadyStateChange(newState: Integer): HRESULT; safecall;
    function OnProgress(percentDone: Integer): HRESULT; safecall;
    function FSCommand(const command: WideString; const args: WideString): HRESULT; safecall;
  end;

  { TControlSite }

  TControlSite = class(TObject, IOleInPlaceSiteWindowless, IOleClientSite)
  private
    m_pFlashWidget: TFlashPlayer;
    m_nRefCount: Longint;
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Init(theFlashWidget: TFlashPlayer);
    {IInterface}
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IOleClientSite }
    function SaveObject: HRESULT; stdcall;
    function GetMoniker(dwAssign: Longint; dwWhichMoniker: Longint;
      out mk: IMoniker): HRESULT; stdcall;
    function GetContainer(out container: IOleContainer): HRESULT; stdcall;
    function ShowObject: HRESULT; stdcall;
    function OnShowWindow(fShow: BOOL): HRESULT; stdcall;
    function RequestNewObjectLayout: HRESULT; stdcall;

    {IOleInPlaceSiteWindowless}
    function CanWindowlessActivate: HRESULT; stdcall;
    function GetCapture: HRESULT; stdcall;
    function SetCapture(fCapture: BOOL): HRESULT; stdcall;
    function GetFocus: HRESULT; stdcall;
    function SetFocus(fFocus: BOOL): HRESULT; stdcall;
    function GetDC(var Rect: TRect; qrfFlags: DWORD;
      var hDC: hDC): HRESULT; stdcall;
    function ReleaseDC(hDC: hDC): HRESULT; stdcall;
    function InvalidateRect(var Rect: TRect; fErase: BOOL): HRESULT; stdcall;
    function InvalidateRgn(hRGN: hRGN; fErase: BOOL): HRESULT; stdcall;
    function ScrollRect(dx, dy: Integer; var RectScroll: TRect;
      var RectClip: TRect): HRESULT; stdcall;
    function AdjustRect(var rc: TRect): HRESULT; stdcall;
    function OnDefWindowMessage(msg: LongWord; wParam: wParam;
      lParam: lParam; var LResult: LResult): HRESULT; stdcall;

    {IOleInPlaceSiteEx}
    function OnInPlaceActivateEx(fNoRedraw: PBOOL;
      dwFlags: DWORD): HRESULT; stdcall;
    function OnInPlaceDeActivateEx(fNoRedraw: BOOL): HRESULT; stdcall;
    function RequestUIActivate: HRESULT; stdcall;

    {IOleInPlaceSite}
    function CanInPlaceActivate: HRESULT; stdcall;
    function OnInPlaceActivate: HRESULT; stdcall;
    function OnUIActivate: HRESULT; stdcall;
    function GetWindowContext(out frame: IOleInPlaceFrame;
      out doc: IOleInPlaceUIWindow; out rcPosRect: TRect;
      out rcClipRect: TRect; out frameInfo: TOleInPlaceFrameInfo): HRESULT;
      stdcall;
    function Scroll(scrollExtent: TPoint): HRESULT; stdcall;
    function OnUIDeactivate(fUndoable: BOOL): HRESULT; stdcall;
    function OnInPlaceDeactivate: HRESULT; stdcall;
    function DiscardUndoState: HRESULT; stdcall;
    function DeactivateAndUndo: HRESULT; stdcall;
    function OnPosRectChange(const rcPosRect: TRect): HRESULT; stdcall;

    {IOleWindow}
    function GetWindow(out wnd: HWnd): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
  end;

  { TFlashListener }

  TFlashListener = class(TObject)
  private
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure FlashAnimEnded(); virtual;
    procedure FlashCommand(const theCommand: WideString; const theParam: WideString); virtual;
  end;

  { TFlashPlayer }
  TFlashPlayer = class(TFlashListener)
  private
    m_State: TFLASHSTATE;
    m_hFlashLibHandle: HMODULE;         //flash.ocx
    m_pControlSite: TControlSite;       //控制台
    m_pFlashSink: TFlashSink;           //事件接收器
    m_pFlashInterface: IShockwaveFlash; //flash接口
    m_pOleObject: IOleObject;           //OLE对象指针
    m_pWindowlessObject: IOleInPlaceObjectWindowless; //
    m_nCOMCount: Integer;               //COM计数器
    m_nPauseCount: Integer;
    m_bFlashDirty: Boolean;
    m_rcFlashDirty: TRect;
    m_nWidth: Longint;
    m_nHeight: Longint;
    m_hWnd: HWnd;
    m_hFlashDC: hDC;
    m_hBitmap: HBITMAP;
    m_pFrameBuffer: Pointer;
    m_nLastFrame: Integer;
    FBrush: TBrush;
    procedure CleanupBuffer();
    procedure RebuildBuffer();
    function GetTransparent: Boolean;
    procedure SetTransparent(const Value: Boolean);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;

    function StartAnimation(const theFileName: WideString; nWidth, nHeight: Longint; HWnd: HWnd): Boolean;
    function LoadFromStream(Src: TStream; nWidth, nHeight: Longint; HWnd: HWnd): Boolean;
    procedure SetQuality(theQuality: TFLASHQUALITY);

    function IsPlaying(): Boolean;
    procedure Pause();
    procedure Unpause();
    procedure Back();
    procedure Rewind();
    procedure forward();
    procedure GotoFrame(theFrameNum: Integer);

    function GetCurrentFrame(): Integer;
    function GetTotalFrames(): Integer;
    function GetCurrentLabel(const theTimeline: WideString): WideString;

    function GetBackgroundColor(): Longint;
    procedure SetBackgroundColor(theColor: Longint);

    function GetLoopPlay(): Boolean;
    procedure SetLoopPlay(bLoop: Boolean);

    procedure CallFrame(const theTimeline: WideString; theFrameNum: Integer);
    procedure CallLabel(const theTimeline: WideString; const theLabel: WideString);

    function GetVariable(const theName: WideString): WideString;
    procedure SetVariable(const theName, theValue: WideString);

    function Update(): Boolean;
    function Render(): Boolean; overload;
    function Render(hDC: hDC): Boolean; overload;

    procedure MouseMove(x, y: Integer);
    procedure MouseLButtonDown(x, y: Integer);
    procedure MouseLButtonUp(x, y: Integer);
    procedure KeyPress(var Key: Char);
    procedure KeyDown(var Key: Word; Shift: TShiftState);
    procedure KeyUp(var Key: Word; Shift: TShiftState);
    procedure SaveFlashBitmapBufferToStream(Writer: TStream);
    procedure SaveFlashBitmapBufferToFile(fName: string);
    function GetWidth(): Longint;
    function GetHeight(): Longint;
    function GetFlashDC(): hDC;
    function GetFlashBitmap(): HBITMAP;
    function GetFlashFrameBuffer(): Pointer;
    property Transparent: Boolean read GetTransparent write SetTransparent;
    class function GetFlashVersion(): Double;
  end;

var
  aTrans                    : string = 'Transparent'; //Opaque';//'Transparent';  //
  transColor                : DWORD = $080808;

implementation

{ TFlashSink }

constructor TFlashSink.Create;
begin
  m_dwCookie := 0;
  m_nRefCount := 0;
  m_ConnectionPoint := nil;
  m_pFlashWidget := nil;
end;

destructor TFlashSink.Destroy;
begin
  m_ConnectionPoint := nil;
  m_pFlashWidget := nil;
  inherited;
end;

function TFlashSink.Init(theFlashWidget: TFlashPlayer): HRESULT;
var
  aResult                   : HRESULT;
  aConnectionPoint          : IConnectionPointContainer;
  aDispatch                 : IDispatch;
begin
  m_pFlashWidget := theFlashWidget;
  Inc(m_pFlashWidget.m_nCOMCount);
  aResult := NOERROR;
  aConnectionPoint := nil;
  if m_pFlashWidget.m_pFlashInterface.QueryInterface(IConnectionPointContainer, aConnectionPoint) = S_OK then begin
    if (aConnectionPoint.FindConnectionPoint(_IShockwaveFlashEvents, m_ConnectionPoint) = S_OK) then begin
      aDispatch := nil;
      QueryInterface(IDispatch, aDispatch);
      if (aDispatch <> nil) then begin
        aResult := m_ConnectionPoint.Advise(aDispatch, m_dwCookie);
        //aDispatch._Release();
        aDispatch := nil;
      end;
    end;
  end;
  //	if (aConnectionPoint <> nil) then
  //		aConnectionPoint._Release();
  aConnectionPoint := nil;
  Result := aResult;
end;

function TFlashSink.Shutdown: HRESULT;
var
  aResult                   : HRESULT;
begin
  aResult := S_OK;
  if (m_ConnectionPoint <> nil) then begin
    if (m_dwCookie <> 0) then begin
      aResult := m_ConnectionPoint.Unadvise(m_dwCookie);
      m_dwCookie := 0;
    end;
    //		m_ConnectionPoint._Release();
    m_ConnectionPoint := nil;
  end;
  Result := aResult;
end;

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

function TFlashSink.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  Pointer(Obj) := nil;
  if CheckGUID(IID, IUnknown) then begin
    IUnknown(Obj) := IUnknown(IDispatch(IShockwaveFlashEvents(Self)));
    //_AddRef();
    Result := S_OK;
    Exit;
  end else if CheckGUID(IID, IDispatch) then begin
    IDispatch(Obj) := IDispatch(IShockwaveFlashEvents(Self));
    //_AddRef();
    Result := S_OK;
    Exit;
  end else if CheckGUID(IID, IShockwaveFlashEvents) then begin
    IShockwaveFlashEvents(Obj) := IShockwaveFlashEvents(Self);
    //_AddRef();
    Result := S_OK;
    Exit;
  end else begin
    Result := E_NOTIMPL;
    Exit;
  end;
end;

function TFlashSink._AddRef: Integer;
begin
  Inc(m_nRefCount);
  Result := m_nRefCount;
end;

function TFlashSink._Release: Integer;
var
  aRefCount                 : Integer;
begin
  Dec(m_nRefCount);
  aRefCount := m_nRefCount;
  //if (aRefCount = 0) then	Free;
  Result := aRefCount;
end;

function TFlashSink.OnReadyStateChange(newState: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TFlashSink.OnProgress(percentDone: Integer): HRESULT;
begin
  Result := S_OK;
end;

function TFlashSink.FSCommand(const command, args: WideString): HRESULT;
begin
  if (m_pFlashWidget <> nil) then
    m_pFlashWidget.FlashCommand(command, args);
  Result := S_OK;
end;

function TFlashSink.GetIDsOfNames(const IID: TGUID; Names: Pointer; NameCount,
  LocaleID: Integer; DispIDs: Pointer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TFlashSink.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TFlashSink.GetTypeInfoCount(out Count: Integer): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TFlashSink.Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
  Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HRESULT;
begin
  case DispID of
    $7A6: ;
    $96: begin
        if ((TDispParams(Params).cArgs = 2) and
          (TDispParams(Params).rgvarg[0].vt = VT_BSTR) and
          (TDispParams(Params).rgvarg[1].vt = VT_BSTR)) then
          FSCommand(TDispParams(Params).rgvarg[1].bstrVal, TDispParams(Params).rgvarg[0].bstrVal);
      end;
    DISPID_READYSTATECHANGE: ;
  else begin
      Result := DISP_E_MEMBERNOTFOUND;
      Exit;
    end;

  end;
  Result := NOERROR;
end;

{ TControlSite }

constructor TControlSite.Create;
begin
  m_pFlashWidget := nil;
  m_nRefCount := 0;
end;

destructor TControlSite.Destroy;
begin
  if (m_pFlashWidget <> nil) then
    Dec(m_pFlashWidget.m_nCOMCount);
  inherited;
end;

procedure TControlSite.Init(theFlashWidget: TFlashPlayer);
begin
  m_pFlashWidget := theFlashWidget;
  Inc(m_pFlashWidget.m_nCOMCount);
end;

function TControlSite.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  Pointer(Obj) := nil;
  if CheckGUID(IID, IUnknown) then begin
    IUnknown(Obj) := IUnknown(IOleClientSite(Self));
    //_AddRef();
    Result := S_OK;
  end else if CheckGUID(IID, IOleWindow) then begin
    IOleWindow(Obj) := IOleWindow(IOleInPlaceSite(IOleInPlaceSiteEx(IOleInPlaceSiteWindowless(Self))));
    //_AddRef();
    Result := S_OK;
  end else if CheckGUID(IID, IOleInPlaceSite) then begin
    IOleInPlaceSite(Obj) := IOleInPlaceSite(IOleInPlaceSiteEx(IOleInPlaceSiteWindowless(Self)));
    //_AddRef();
    Result := S_OK;
  end
  else if CheckGUID(IID, IOleInPlaceSiteEx) then begin
    IOleInPlaceSiteEx(Obj) := IOleInPlaceSiteEx(IOleInPlaceSiteWindowless(Self));
    //_AddRef();
    Result := S_OK;
  end
  else if CheckGUID(IID, IOleInPlaceSiteWindowless) then begin
    IOleInPlaceSiteWindowless(Obj) := IOleInPlaceSiteWindowless(Self);
    //_AddRef();
    Result := S_OK;
  end
  else if CheckGUID(IID, IOleClientSite) then begin
    IOleClientSite(Obj) := IOleClientSite(Self);
    //_AddRef();
    Result := S_OK;
  end
  else if CheckGUID(IID, IShockwaveFlashEvents) then begin
    Pointer(Obj) := Self;
    //_AddRef();
    Result := S_OK;
  end
  else
    Result := E_NOTIMPL;
end;

function TControlSite._AddRef: Integer;
begin
  Inc(m_nRefCount);
  Result := m_nRefCount;
end;

function TControlSite._Release: Integer;
var
  aRefCount                 : Integer;
begin
  Dec(m_nRefCount);
  aRefCount := m_nRefCount;
  Result := aRefCount;
end;

function TControlSite.AdjustRect(var rc: TRect): HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.CanInPlaceActivate: HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.CanWindowlessActivate: HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.ContextSensitiveHelp(fEnterMode: BOOL): HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.DeactivateAndUndo: HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.DiscardUndoState: HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.GetCapture: HRESULT;
begin
  Result := S_FALSE;
end;

function TControlSite.GetContainer(out container: IOleContainer): HRESULT;
begin
  Result := E_NOINTERFACE;
end;

function TControlSite.GetDC(var Rect: TRect; qrfFlags: DWORD;
  var hDC: hDC): HRESULT;
begin
  Result := E_INVALIDARG;
end;

function TControlSite.GetFocus: HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.GetMoniker(dwAssign, dwWhichMoniker: Integer;
  out mk: IMoniker): HRESULT;
begin
  mk := nil;
  Result := E_NOTIMPL;
end;

function TControlSite.GetWindow(out wnd: HWnd): HRESULT;
begin
  Result := E_FAIL;
end;

function TControlSite.GetWindowContext(out frame: IOleInPlaceFrame;
  out doc: IOleInPlaceUIWindow; out rcPosRect, rcClipRect: TRect;
  out frameInfo: TOleInPlaceFrameInfo): HRESULT;
var
  aRect                     : TRect;
begin
  aRect := m_pFlashWidget.m_rcFlashDirty;
  rcPosRect := aRect;
  rcClipRect := aRect;
  frame := nil;
  QueryInterface(IOleInPlaceFrame, frame);
  doc := nil;
  frameInfo.fMDIApp := False;
  frameInfo.hwndFrame := 0;
  frameInfo.haccel := 0;
  frameInfo.cAccelEntries := 0;
  Result := S_OK;
end;

function TControlSite.InvalidateRect(var Rect: TRect; fErase: BOOL): HRESULT;
begin
  if (not m_pFlashWidget.m_bFlashDirty) then begin
    m_pFlashWidget.m_bFlashDirty := True;
  end else begin

  end;
  Result := S_OK;
end;

function TControlSite.InvalidateRgn(hRGN: hRGN; fErase: BOOL): HRESULT;
begin
  m_pFlashWidget.m_bFlashDirty := True;
  Result := S_OK;
end;

function TControlSite.OnDefWindowMessage(msg: LongWord; wParam: wParam;
  lParam: lParam; var LResult: LResult): HRESULT;
begin
  Result := S_FALSE;
end;

function TControlSite.OnInPlaceActivate: HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.OnInPlaceActivateEx(fNoRedraw: PBOOL;
  dwFlags: DWORD): HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.OnInPlaceDeactivate: HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.OnInPlaceDeActivateEx(fNoRedraw: BOOL): HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.OnPosRectChange(const rcPosRect: TRect): HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.OnShowWindow(fShow: BOOL): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TControlSite.OnUIActivate: HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.OnUIDeactivate(fUndoable: BOOL): HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.ReleaseDC(hDC: hDC): HRESULT;
begin
  Result := E_INVALIDARG;
end;

function TControlSite.RequestNewObjectLayout: HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TControlSite.RequestUIActivate: HRESULT;
begin
  Result := S_FALSE;
end;

function TControlSite.SaveObject: HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.Scroll(scrollExtent: TPoint): HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.ScrollRect(dx, dy: Integer; var RectScroll,
  RectClip: TRect): HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.SetCapture(fCapture: BOOL): HRESULT;
begin
  Result := S_FALSE;
end;

function TControlSite.SetFocus(fFocus: BOOL): HRESULT;
begin
  Result := S_OK;
end;

function TControlSite.ShowObject: HRESULT;
begin
  Result := E_NOTIMPL;
end;

{ TFlashListener }

constructor TFlashListener.Create;
begin
end;

destructor TFlashListener.Destroy;
begin
  inherited;
end;

procedure TFlashListener.FlashAnimEnded;
begin
end;

procedure TFlashListener.FlashCommand(const theCommand, theParam: WideString);
begin
end;

{ TFlashPlayer }

constructor TFlashPlayer.Create;
var
  aResult                   : HRESULT;
  aClassFactory             : IClassFactory;
  aDllGetClassObjectFunc    : TDLLGetClassObject;
  aClientSite               : IOleClientSite;
  posRect                   : TRect;
begin
  inherited;
  m_State := STATE_IDLE;
  m_hFlashLibHandle := 0;
  m_pControlSite := nil;
  m_pFlashSink := nil;
  m_pFlashInterface := nil;
  m_pOleObject := nil;
  m_pWindowlessObject := nil;
  m_nCOMCount := 0;
  m_nPauseCount := 0;
  m_bFlashDirty := True;
  m_nWidth := 0;
  m_nHeight := 0;
  m_hFlashDC := 0;
  m_hBitmap := 0;
  m_pFrameBuffer := nil;
  FBrush := TBrush.Create;
  FBrush.Color := transColor;
  FBrush.Style := bsSolid;

  CoInitialize(nil);

  m_pControlSite := TControlSite.Create();
  //m_pControlSite._AddRef();
  m_pControlSite.Init(Self);

  CoCreateInstance(CLASS_ShockwaveFlash, nil, CLSCTX_INPROC_SERVER, IOleObject, m_pOleObject);
  if m_pOleObject = nil then begin
    m_hFlashLibHandle := LoadLibraryA('Flash.ocx');
    if (m_hFlashLibHandle <> 0) then begin
      aClassFactory := nil;
      aDllGetClassObjectFunc := GetProcAddress(m_hFlashLibHandle, 'DllGetClassObject');
      aResult := aDllGetClassObjectFunc(CLASS_ShockwaveFlash, IClassFactory, aClassFactory);
      aClassFactory.CreateInstance(nil, IOleObject, m_pOleObject);
      aClassFactory := nil;
    end;
  end;

  if m_pOleObject = nil then Exit;

  m_pControlSite.QueryInterface(IOleClientSite, aClientSite);
  m_pOleObject.SetClientSite(aClientSite);

  m_pOleObject.QueryInterface(IShockwaveFlash, m_pFlashInterface);
  m_pFlashInterface.WMode := aTrans;
  FillChar(posRect, SizeOf(TRect), 0);
  aResult := m_pOleObject.DoVerb(OLEIVERB_INPLACEACTIVATE, nil, aClientSite, 0, 0, posRect);
  //	aClientSite._Release();
  aClientSite := nil;

  m_pOleObject.QueryInterface(IOleInPlaceObjectWindowless, m_pWindowlessObject);

  m_pFlashSink := TFlashSink.Create();
  //	m_pFlashSink._AddRef();
  m_pFlashSink.Init(Self);
end;

destructor TFlashPlayer.Destroy;
begin
  CleanupBuffer();

  //	if (m_pWindowlessObject <> nil) then
  //		m_pWindowlessObject._Release();
  m_pWindowlessObject := nil;
  //	if (m_pFlashInterface <> nil) then
  //		m_pFlashInterface._Release();
  m_pFlashInterface := nil;

  if (m_pFlashSink <> nil) then begin
    if m_pFlashSink.Shutdown() = 0 then m_pFlashSink.free;
  end;
  m_pFlashSink := nil;

  m_pOleObject.Close(OLECLOSE_NOSAVE);

  //	if (m_pOleObject <> nil) then
  //		m_pOleObject._Release();
  m_pOleObject := nil;

  if (m_pControlSite <> nil) then
    if m_pControlSite._Release() <= 0 then m_pControlSite.free;
  m_pControlSite := nil;

  // Make sure all our COM objects were actually destroyed
  //DBG_ASSERTE(m_nCOMCount == 0);

  if (m_hFlashLibHandle <> 0) then
    FreeLibrary(m_hFlashLibHandle);
  FBrush.free;
  inherited;
end;

procedure TFlashPlayer.Back;
begin
  if (m_pFlashInterface <> nil) then begin
    m_pFlashInterface.Back();
    m_pFlashInterface.Play();
  end;
end;

procedure TFlashPlayer.CallFrame(const theTimeline: WideString; theFrameNum: Integer);
begin
  if (m_pFlashInterface <> nil) then
    m_pFlashInterface.TCallFrame(theTimeline, theFrameNum);
end;

procedure TFlashPlayer.CallLabel(const theTimeline, theLabel: WideString);
begin
  if (m_pFlashInterface <> nil) then
    m_pFlashInterface.TCallLabel(theTimeline, theLabel);
end;

procedure TFlashPlayer.CleanupBuffer;
begin
  if (m_hBitmap <> 0) then
    DeleteObject(m_hBitmap);
  if (m_hFlashDC <> 0) then
    DeleteDC(m_hFlashDC);
end;

procedure TFlashPlayer.Forward;
begin
  if (m_pFlashInterface <> nil) then begin
    m_pFlashInterface.Forward();
    m_pFlashInterface.Play();
  end;
end;

function TFlashPlayer.GetBackgroundColor: Longint;
begin
  Result := 0;
  if (m_pFlashInterface <> nil) then
    Result := m_pFlashInterface.get_BackgroundColor();
end;

function TFlashPlayer.GetCurrentFrame: Integer;
begin
  Result := -1;
  if (m_pFlashInterface <> nil) then
    Result := m_pFlashInterface.CurrentFrame();
end;

function TFlashPlayer.GetCurrentLabel(const theTimeline: WideString): WideString;
begin
  Result := '';
  if (m_pFlashInterface <> nil) then
    Result := m_pFlashInterface.TCurrentLabel(theTimeline);
end;

function TFlashPlayer.GetFlashBitmap: HBITMAP;
begin
  Result := m_hBitmap;
end;

function TFlashPlayer.GetFlashDC: hDC;
begin
  Result := m_hFlashDC;
end;

function TFlashPlayer.GetFlashFrameBuffer: Pointer;
begin
  Result := m_pFrameBuffer;
end;

class function TFlashPlayer.GetFlashVersion: Double;
var
  anOleObject               : IOleObject;
  aFlashInterface           : IShockwaveFlash;
  aVersion                  : Longint;
begin
  CoInitialize(nil);
  anOleObject := nil;
  if (FAILED(CoCreateInstance(CLASS_ShockwaveFlash, nil, CLSCTX_INPROC_SERVER, IOleObject, anOleObject))) then begin
    Result := 0.0;
    Exit;
  end;

  aFlashInterface := nil;
  if (FAILED(anOleObject.QueryInterface(IShockwaveFlash, aFlashInterface))) then begin
    Result := 0.0;
    Exit;
  end;

  aVersion := aFlashInterface.FlashVersion();

  //	aFlashInterface._Release();
  aFlashInterface := nil;
  //	anOleObject._Release();
  anOleObject := nil;

  Result := aVersion / 65536.0;
end;

function TFlashPlayer.GetHeight: Longint;
begin
  Result := m_nHeight;
end;

function TFlashPlayer.GetLoopPlay: Boolean;
begin
  Result := False;
  if (m_pFlashInterface <> nil) then
    Result := m_pFlashInterface.get_Loop();
end;

function TFlashPlayer.GetTotalFrames: Integer;
begin
  Result := -1;
  if (m_pFlashInterface <> nil) then
    Result := m_pFlashInterface.get_TotalFrames();
end;

function TFlashPlayer.GetTransparent: Boolean;
begin
  Result := False;
  if m_pFlashInterface <> nil then
    Result := m_pFlashInterface.WMode = 'Transparent';
end;

function TFlashPlayer.GetVariable(const theName: WideString): WideString;
begin
  Result := '';
  if (m_pFlashInterface <> nil) then
    m_pFlashInterface.GetVariable(theName);
end;

function TFlashPlayer.GetWidth: Longint;
begin
  Result := m_nWidth;
  ;
end;

procedure TFlashPlayer.GotoFrame(theFrameNum: Integer);
begin
  if (m_pFlashInterface <> nil) then begin
    m_pFlashInterface.GotoFrame(theFrameNum);
    m_pFlashInterface.Play();
  end;
end;

function TFlashPlayer.IsPlaying: Boolean;
begin
  Result := False;
  if (m_pFlashInterface <> nil) then
    Result := m_pFlashInterface.IsPlaying();
end;

function ShiftToByte(Shift: TShiftState): Byte;
begin
  Result := 0;
  if ssShift in Shift then Result := Result or MK_SHIFT;
  if ssCtrl in Shift then Result := Result or MK_CONTROL;
  if ssLeft in Shift then Result := Result or MK_LBUTTON;
  if ssRight in Shift then Result := Result or MK_RBUTTON;
  if ssMiddle in Shift then Result := Result or MK_MBUTTON;
  if ssAlt in Shift then Result := Result or VK_MENU;
end;

procedure TFlashPlayer.KeyDown(var Key: Word; Shift: TShiftState);
var
  aResult                   : Integer;
begin
  if m_pWindowlessObject <> nil then begin
    m_pWindowlessObject.OnWindowMessage(WM_KEYDOWN, Key, ShiftToByte(Shift), aResult);
  end;
end;

procedure TFlashPlayer.KeyPress(var Key: Char);
var
  aResult                   : Integer;
begin
  if m_pWindowlessObject <> nil then
    m_pWindowlessObject.OnWindowMessage(WM_CHAR, Integer(Key), 0, aResult);
end;

procedure TFlashPlayer.KeyUp(var Key: Word; Shift: TShiftState);
var
  aResult                   : Integer;
begin
  if m_pWindowlessObject <> nil then
    m_pWindowlessObject.OnWindowMessage(WM_KEYUP, Key, ShiftToByte(Shift), aResult);

end;

function TFlashPlayer.LoadFromStream(Src: TStream; nWidth, nHeight: Longint; HWnd: HWnd): Boolean;
var
  unCompress                : TStream;
  Mem, Mem2                 : TMemoryStream;
  SRCSize                   : Longint;
  PersistStream             : IPersistStreamInit;
  SAdapt                    : TStreamAdapter;
  ISize                     : int64;
  B                         : Byte;
  ASign                     : array[0..2] of Char;
  isCompress                : Boolean;
  ZStream                   : TZDecompressionStream;
  anInPlaceObject           : IOleInPlaceObject;
begin
  m_hWnd := HWnd;
  // prepare src movie
  Src.Read(ASign, 3);
  isCompress := ASign = 'CWS';
  if isCompress then begin
    unCompress := TMemoryStream.Create;
    ASign := 'FWS';
    unCompress.Write(ASign, 3);
    unCompress.CopyFrom(Src, 1);        // version
    Src.Read(SRCSize, 4);
    unCompress.Write(SRCSize, 4);
    ZStream := TZDecompressionStream.Create(Src);
    try
      unCompress.CopyFrom(ZStream, SRCSize - 8);
    finally
      ZStream.free;
    end;
    unCompress.Position := 0;
  end else begin
    Src.Position := Src.Position - 3;
    SRCSize := Src.Size - Src.Position;
    unCompress := Src;
  end;
  // store "template"
  PersistStream := nil;
  m_pOleObject.QueryInterface(IPersistStreamInit, PersistStream);
  PersistStream.GetSizeMax(ISize);
  Mem := TMemoryStream.Create;
  Mem.SetSize(ISize);
  SAdapt := TStreamAdapter.Create(Mem);
  PersistStream.Save(SAdapt, True);
  SAdapt.free;

  // insetr movie to "template"
  Mem.Position := 1;
  Mem2 := TMemoryStream.Create;
  B := $66;                             // magic flag: "f" - embed swf; "g" - without swf;
  Mem2.Write(B, 1);
  Mem2.CopyFrom(Mem, 3);
  Mem2.Write(SRCSize, 4);
  Mem2.CopyFrom(unCompress, SRCSize);
  Mem2.CopyFrom(Mem, Mem.Size - Mem.Position);

  // load activeX data
  Mem2.Position := 0;
  SAdapt := TStreamAdapter.Create(Mem2);
  PersistStream.Load(SAdapt);
  SAdapt.free;

  // free all
  Mem2.free;
  Mem.free;
  PersistStream := nil;
  if isCompress then unCompress.free;

  m_nWidth := nWidth;
  m_nHeight := nHeight;
  SetRect(m_rcFlashDirty, 0, 0, m_nWidth, m_nHeight);
  RebuildBuffer();
  anInPlaceObject := nil;
  m_pOleObject.QueryInterface(IOleInPlaceObject, anInPlaceObject);
  if (anInPlaceObject <> nil) then begin
    anInPlaceObject.SetObjectRects(m_rcFlashDirty, m_rcFlashDirty);
  end;
  anInPlaceObject := nil;
  m_State := STATE_PLAYING;
  m_nLastFrame := -1;
  Result := True;
end;

procedure TFlashPlayer.MouseLButtonDown(x, y: Integer);
var
  aResult                   : LResult;
begin
  if m_pWindowlessObject <> nil then
    m_pWindowlessObject.OnWindowMessage(WM_LBUTTONDOWN, MK_LBUTTON, MAKELPARAM(x, y), aResult);
end;

procedure TFlashPlayer.MouseLButtonUp(x, y: Integer);
var
  aResult                   : LResult;
begin
  if m_pWindowlessObject <> nil then
    m_pWindowlessObject.OnWindowMessage(WM_LBUTTONUP, 0, MAKELPARAM(x, y), aResult);
end;

procedure TFlashPlayer.MouseMove(x, y: Integer);
var
  aResult                   : LResult;
begin
  if m_pWindowlessObject <> nil then
    m_pWindowlessObject.OnWindowMessage(WM_MOUSEMOVE, 0, MAKELPARAM(x, y), aResult);
end;

procedure TFlashPlayer.Pause;
begin
  Inc(m_nPauseCount);
  if (m_State <> STATE_STOPPED) then
    m_State := STATE_IDLE;

  if ((m_nPauseCount = 1) and (m_pFlashInterface <> nil) and (m_State <> STATE_STOPPED)) then
    m_pFlashInterface.StopPlay();
end;

procedure TFlashPlayer.RebuildBuffer;
var
  desktop_dc                : hDC;
  bmpinfo                   : TBITMAPINFO;
  DevMode                   : TDevMode;
begin
  CleanupBuffer();
  DevMode.dmFields := DevMode.dmFields or DM_BITSPERPEL;
  if EnumDisplaySettings(nil, 0, DevMode) then begin
    DevMode.dmBitsPerPel := 32;
    desktop_dc := CreateDC(nil, nil, nil, @DevMode);
  end else desktop_dc := GetDC(m_hWnd);
  m_hFlashDC := CreateCompatibleDC(desktop_dc);

  FillChar(bmpinfo, SizeOf(TBITMAPINFO), 0);
  bmpinfo.bmiHeader.biSize := SizeOf(bmpinfo);
  bmpinfo.bmiHeader.biPlanes := 1;
  bmpinfo.bmiHeader.biBitCount := 32;
  bmpinfo.bmiHeader.biCompression := BI_RGB;
  bmpinfo.bmiHeader.biWidth := m_nWidth;
  bmpinfo.bmiHeader.biHeight := -m_nHeight;

  m_hBitmap := CreateDIBSection(m_hFlashDC, bmpinfo, DIB_RGB_COLORS, m_pFrameBuffer, 0, 0);
  SelectObject(m_hFlashDC, m_hBitmap);

  // vietdoor's code start here
  SetMapMode(m_hFlashDC, MM_TEXT);
  // vietdoor's code end here
  SetBkMode(m_hFlashDC, Windows.Transparent);
  SetBkColor(m_hFlashDC, 0);
  //SetBackgroundColor($0);
end;

function TFlashPlayer.Render: Boolean;
begin
  if (m_bFlashDirty and Render(m_hFlashDC)) then begin
    m_bFlashDirty := False;
    Result := True;
    Exit;
  end;
  Result := False;
end;

function TFlashPlayer.Render(hDC: hDC): Boolean;
var
  aViewObject               : IViewObject;
  aFill                     : TRect;
  aRect                     : TRect;
  aResult                   : HRESULT;
begin

  Result := False;
  aViewObject := nil;
  m_pFlashInterface.QueryInterface(IViewObject, aViewObject);
  if (aViewObject <> nil) then begin
    aFill.Left := 0;                    // {0, 0, m_nWidth, m_nHeight};
    aFill.Top := 0;
    aFill.Right := m_nWidth;
    aFill.Bottom := m_nHeight;
    FillRect(m_hFlashDC, aFill, FBrush.Handle); //GetStockObject(WHITE_BRUSH));//
    aRect.Left := 0;                    // {0, 0, m_nWidth, m_nHeight};
    aRect.Top := 0;
    aRect.Right := m_nWidth;
    aRect.Bottom := m_nHeight;
    aResult := aViewObject.Draw(DVASPECT_CONTENT, 1, nil, nil, 0, hDC, @aRect, nil, nil, 0);

    //		aViewObject._Release();
    aViewObject := nil;
    Result := aResult = S_OK;
  end;
end;

procedure TFlashPlayer.Rewind;
begin
  if (m_pFlashInterface <> nil) then begin
    m_pFlashInterface.Rewind();
    m_pFlashInterface.Play();
  end;
end;

procedure TFlashPlayer.SaveFlashBitmapBufferToFile(fName: string);
var
  Stream                    : TFileStream;
begin
  Stream := TFileStream.Create(fName, fmCreate);
  try
    SaveFlashBitmapBufferToStream(Stream);
  finally
    Stream.free;
  end;
end;

procedure TFlashPlayer.SaveFlashBitmapBufferToStream(Writer: TStream);
var
  Size                      : Integer;
  fhsize                    : Integer;
  biSize                    : Integer;
  bmfh                      : BITMAPFILEHEADER;
  info                      : BITMAPINFOHEADER;
  pBitmapFlashBuffer        : PByte;
begin
  if (m_pFrameBuffer = nil) then Exit;

  Size := 32 div 8 * m_nWidth * m_nHeight;

  fhsize := SizeOf(BITMAPFILEHEADER);
  biSize := SizeOf(BITMAPINFOHEADER);

  FillChar(bmfh, SizeOf(BITMAPFILEHEADER), 0);
  FillChar(info, SizeOf(BITMAPINFOHEADER), 0);

  // First we fill the file header with data
  bmfh.bfType := $4D42;                 // 0x4d42 = 'BM'
  bmfh.bfReserved1 := 0;
  bmfh.bfReserved2 := 0;
  bmfh.bfSize := SizeOf(BITMAPFILEHEADER) + SizeOf(BITMAPINFOHEADER) + Size;
  bmfh.bfOffBits := $36;                // (54) size of headers

  info.biSize := SizeOf(BITMAPINFOHEADER);
  info.biWidth := m_nWidth;
  info.biHeight := -m_nHeight;
  info.biPlanes := 1;
  info.biBitCount := 32;
  info.biCompression := BI_RGB;
  info.biSizeImage := 0;
  info.biXPelsPerMeter := $0EC4;
  info.biYPelsPerMeter := $0EC4;
  info.biClrUsed := 0;
  info.biClrImportant := 0;

  pBitmapFlashBuffer := GetMemory(fhsize + biSize + Size); // new BYTE[fhsize + bisize + size];
  if (pBitmapFlashBuffer <> nil) then begin
    CopyMemory(pBitmapFlashBuffer, @bmfh, fhsize); //memcpy(pBitmapFlashBuffer, &bmfh, fhsize);
    CopyMemory(Pointer(Integer(pBitmapFlashBuffer) + fhsize), @info, biSize); //memcpy(pBitmapFlashBuffer + fhsize, &info, bisize);
    CopyMemory(Pointer(Integer(pBitmapFlashBuffer) + fhsize + biSize), m_pFrameBuffer, Size); // memcpy(pBitmapFlashBuffer + fhsize + bisize, m_pFrameBuffer, size);
    if (Writer <> nil) then begin
      Writer.Position := 0;
      Writer.WriteBuffer(pBitmapFlashBuffer^, fhsize + biSize + Size);
      Writer.Position := 0;
    end;
    FreeMemory(pBitmapFlashBuffer)
  end;
end;

procedure TFlashPlayer.SetBackgroundColor(theColor: Integer);
begin
  if (m_pFlashInterface <> nil) then
    m_pFlashInterface.Set_BackgroundColor(theColor);
end;

procedure TFlashPlayer.SetLoopPlay(bLoop: Boolean);
begin
  if (m_pFlashInterface <> nil) then
    m_pFlashInterface.Set_Loop(bLoop);
end;

var
  aQualityNames             : array[QUALITY_LOW..QUALITY_HIGH] of WideString = ('Low', 'Medium', 'High');

procedure TFlashPlayer.SetQuality(theQuality: TFLASHQUALITY);
begin
  if (m_pFlashInterface <> nil) then
    m_pFlashInterface.Set_Quality2(aQualityNames[theQuality]);
end;

procedure TFlashPlayer.SetTransparent(const Value: Boolean);
begin
  if m_pFlashInterface <> nil then begin
    if Value then
      m_pFlashInterface.WMode := 'Transparent'
    else
      m_pFlashInterface.WMode := 'Opaque';
  end;
end;

procedure TFlashPlayer.SetVariable(const theName, theValue: WideString);
begin
  if (m_pFlashInterface <> nil) then
    m_pFlashInterface.SetVariable(theName, theValue);
end;

function TFlashPlayer.StartAnimation(const theFileName: WideString; nWidth, nHeight: Integer; HWnd: HWnd): Boolean;
var
  aFullPath                 : WideString;
  bstr                      : WideString;
  anInPlaceObject           : IOleInPlaceObject;
begin
  //std::string aFullPath = GetFullPath(theFileName);
  aFullPath := theFileName;
  m_hWnd := HWnd;
  bstr := aFullPath;

  m_pFlashInterface.Set_Movie(bstr);    // you have to change the path here
  m_pFlashInterface.Play();

  m_nWidth := nWidth;
  m_nHeight := nHeight;

  SetRect(m_rcFlashDirty, 0, 0, m_nWidth, m_nHeight);
  RebuildBuffer();

  anInPlaceObject := nil;
  m_pOleObject.QueryInterface(IOleInPlaceObject, anInPlaceObject);

  if (anInPlaceObject <> nil) then begin
    anInPlaceObject.SetObjectRects(m_rcFlashDirty, m_rcFlashDirty);
    //		anInPlaceObject._Release();
  end;
  anInPlaceObject := nil;

  m_State := STATE_PLAYING;
  m_nLastFrame := -1;
  Result := True;
end;

procedure TFlashPlayer.Unpause;
begin
  Dec(m_nPauseCount);
  if ((m_nPauseCount = 0) and (m_pFlashInterface <> nil) and (m_State <> STATE_STOPPED)) then begin
    m_State := STATE_PLAYING;
    m_pFlashInterface.Play();
  end;
end;

function TFlashPlayer.Update: Boolean;
var
  boPlaying                 : WordBool;
begin
  if (m_State = STATE_PLAYING) then begin
    boPlaying := m_pFlashInterface.IsPlaying();
    if (not IsPlaying) then begin
      m_State := STATE_STOPPED;
      if (m_nPauseCount = 0) then
        FlashAnimEnded();
    end;
  end;
  Result := True;
end;

end.

