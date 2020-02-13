unit Awesomium;

interface
uses
  Windows, Classes, Controls, SysUtils, HGE;

const
  ASYNC_RENDER              = True;
  SUPER_QUALITY             = 0;

type
  TLogLevel =
    (
    LOG_NONE,                           // No log is created
    LOG_NORMAL,                         // Logs only errors
    LOG_VERBOSE                         // Logs everything
    );

  TPixelFormat =
    (
    PF_BGRA,                            // BGRA byte ordering [Blue, Green, Red, Alpha]
    PF_RGBA                             // RGBA byte ordering [Red, Green, Blue, Alpha]
    );

  TWebNavigationPolicy = (
    WebNavigationPolicyIgnore,
    WebNavigationPolicyDownload,
    WebNavigationPolicyCurrentTab,
    WebNavigationPolicyNewBackgroundTab,
    WebNavigationPolicyNewForegroundTab,
    WebNavigationPolicyNewWindow,
    WebNavigationPolicyNewPopup
    );

  TWebNavigationType = (
    WebNavigationTypeLinkClicked,
    WebNavigationTypeFormSubmitted,
    WebNavigationTypeBackForward,
    WebNavigationTypeReload,
    WebNavigationTypeFormResubmitted,
    WebNavigationTypeOther
    );

  TVariantType = (
    Type_NULL,
    Type_BOOLEAN,
    Type_INTEGER,
    Type_DOUBLE,
    Type_STRING
    );

  TJSValueList = class;

  TWebViewListener = class
  public
    (**
    * This event is fired when a WebView begins navigating to a new URL.
    *
    * @param	url		The URL that is being navigated to.
    *
    * @param	frameName	The name of the frame that this event originated from.
    *)
    procedure onBeginNavigation(const url: PAnsiChar; const urllen: Integer; const frameName: PWideChar; const frameNamelen: Integer); virtual; cdecl; abstract;

    (**
    * This event is fired when a WebView begins to actually receive data from a server.
    *
    * @param	url		The URL of the frame that is being loaded.
    *
    * @param	frameName	The name of the frame that this event originated from.
    *
    * @param	statusCode	The HTTP status code returned by the server.
    *
    * @param	mimeType	The mime-type of the content that is being loaded.
    *)
    procedure onBeginLoading(const url: PAnsiChar; const urllen: Integer; const frameName: PWideChar; const frameNamelen: Integer; statusCode: Integer; const mimeType: PWideChar); virtual; cdecl; abstract;

    (**
    * This event is fired when all loads have finished for a WebView.
    *)
    procedure onFinishLoading(); virtual; cdecl; abstract;

    (*
    * This event is fired when a Client callback has been invoked via Javascript from a page.
    *
    * @param	name	The name of the client callback that was invoked (specifically, "Client._this_name_here_(...)").
    *
    * @param	args	The arguments passed to the callback.
    *)
    procedure onCallback(const name: PAnsiChar; const namelen: Integer; const args: TJSValueList); virtual; cdecl; abstract;

    (**
    * This event is fired when a page title is received.
    *
    * @param	title	The page title.
    *
    * @param	frameName	The name of the frame that this event originated from.
    *)
    procedure onReceiveTitle(const title: PWideChar; const titlelen: Integer; const frameName: PWideChar; const frameNamelen: Integer); virtual; cdecl; abstract;

    (**
    * This event is fired when a tooltip has changed state.
    *
    * @param	tooltip		The tooltip text (or, is an empty string when the tooltip should disappear).
    *)
    procedure onChangeTooltip(const tooltip: PWideChar; const tooltiplen: Integer); virtual; cdecl; abstract;

    (**
    * This event is fired when a cursor has changed state. [Windows-only]
    *
    * @param	cursor	The cursor handle/type.
    *)
    procedure onChangeCursor(const cursor: PLongWord); virtual; cdecl; abstract;

    (**
    * This event is fired when keyboard focus has changed.
    *
    * @param	isFocused	Whether or not the keyboard is currently focused.
    *)
    procedure onChangeKeyboardFocus(isFocused: Boolean); virtual; cdecl; abstract;

    (**
    * This event is fired when the target URL has changed. This is usually the result of
    * hovering over a link on the page.
    *
    * @param	url	The updated target URL (or empty if the target URL is cleared).
    *)
    procedure onChangeTargetURL(const url: PAnsiChar; const urllen: Integer); virtual; cdecl; abstract;

    function onNavigationAction(const url: PWideChar; const urllen: Integer; const frameName: PWideChar; const frameNamelen: Integer;
      const otype: TWebNavigationType;
      const default_policy: TWebNavigationPolicy;
      const is_redirect: Boolean): TWebNavigationPolicy; virtual; cdecl; abstract;

    procedure onRunJavaScriptAlert(const sframeName: PWideChar; const frameNamelen: Integer;
      const smessage: PWideChar; const smessagelen: Integer); virtual; cdecl; abstract;

    function onRunJavaScriptConfirm(const sframeName: PWideChar; const frameNamelen: Integer;
      const smessage: PWideChar; const smessagelen: Integer): Boolean; virtual; cdecl; abstract;

    function onRunJavaScriptPrompt(const sframeName: PWideChar; const frameNamelen: Integer;
      const smessage: PWideChar; const smessagelen: Integer;
      const default_value: PWideChar; const default_valuelen: Integer;
      const oresult: PWideChar; const len: PInteger): Boolean; virtual; cdecl; abstract;

    function onRunBeforeUnloadConfirm(const sframeName: PWideChar; const frameNamelen: Integer;
      const smessage: PWideChar; const smessagelen: Integer): Boolean; virtual; cdecl; abstract;

    procedure onCreateWebView(const sOpenUrl: PChar; const nOpenUrllen: Integer;
      const creatorurl: PChar; const creator_urllen: Integer;
      gesture: Boolean); virtual; cdecl; abstract;

  end;

  TCWebView = class
  public
    (**
    * Explicitly destroys this WebView instance. If you neglect to call this, the WebCore singleton
    * will automatically destroy all lingering WebView instances at shutdown.
    *
    * @note	This should NEVER be called directly from one of the notifications of WebViewListener.
    *)
    procedure Destroy(); virtual; cdecl; abstract;
    //WebView
   (**
   * Sets a global 'Client' property that can be accessed via Javascript from
   * within all pages loaded into this web-view.
   *
   * @param	name	The name of the property.
   * @param	value	The javascript-value of the property.
   *
   * @note	You can access all properties you set via the 'Client' object using Javascript. For example,
   *		if you set the property with a name of 'color' and a value of 'blue', you could access
   *		this from the page using Javascript: document.write("The color is " + Client.color);
   *)
    procedure SetProperty(name: PAnsiChar; value: PAnsiChar); overload; virtual; cdecl; abstract;
    procedure SetProperty(name: PAnsiChar; var value: Integer); overload; virtual; cdecl; abstract;
    procedure SetProperty(name: PAnsiChar; var value: Double); overload; virtual; cdecl; abstract;
    procedure SetProperty(name: PAnsiChar; var value: Boolean); overload; virtual; cdecl; abstract;

    (**
    * Registers a global 'Client' callback that can be invoked via Javascript from
    * within all pages loaded into this view. You will need to register a WebViewListener
    * (WebView::setListener) to receieve notification of callbacks (WebViewListener::onCallback).
    *
    * @param	name	The name of the callback. You can invoke the callback in Javascript
    *					as: Client.your_name_here(arg1, arg2, ...);
    *
    * @note	In the future, it won't be necessary to register the callback name in advance.
    *)
    procedure SetCallback(name: PAnsiChar); virtual; cdecl; abstract;

    (**
    * Registers a WebViewListener to call upon various events (such as load completions, callbacks, title receptions,
    * cursor changes, etc).
    *
    * @param	listener	The WebViewListener to register. Or, you can pass '0' to undo any current registrations.
    *)
    procedure SetListener(listener: TWebViewListener); virtual; cdecl; abstract;

    (**
    * Retrieves the current WebViewListener.
    *
    * @return	If a WebViewListener is registered, returns a pointer to the instance, otherwise returns 0.
    *)
    function GetListener(): TWebViewListener; virtual; cdecl; abstract;

    (**
    * Retrieves the content of the current page as plain text.
    *
    * @param	result	The wide string to store the retrieved text in.
    *
    * @param	maxChars	The maximum number of characters to retrieve.
    *
    * @note	Warning: The performance of this function depends upon the number of retrieved characters
    *		and the complexity of the page.
    *)
    procedure GetContentAsText(result: PWideChar; maxChars: Integer); virtual; cdecl; abstract;

    (**
             procedure LoadURL(url:PAnsiChar; frameName:PWideChar = nil;username:PAnsiChar = nil;password:PAnsiChar= nil); virtual; cdecl;
    * Loads a URL into the WebView asynchronously.
    *
    * @param	url	The URL to load.
    *
    * @param	frameName	Optional, the name of the frame to load the URL in; leave this blank to load in the main frame.
    *
    * @param	username	Optional, if the URL requires authentication, the username to authorize as.
    *
    * @param	password	Optional, if the URL requires authentication, the password to use.
    *)
    procedure LoadURL(url: PAnsiChar; frameName: PWideChar; username: PAnsiChar; password: PAnsiChar; reload: Boolean); virtual; cdecl; abstract;

    (**  procedure LoadHTML(html:PAnsiChar; frameName :PWideChar =nil); virtual; cdecl; abstract;
    * Loads a string of HTML into the WebView asynchronously.
    *
    * @param	html	The HTML string to load.
    *
    * @param	frameName	Optional, the name of the frame to load the HTML in; leave this blank to load in the main frame.
    *
    * @note	The base directory (specified via WebCore::setBaseDirectory) will be used to resolve
    *		relative URL's/resources (such as images, links, etc).
    *)
    procedure LoadHTML(html: PAnsiChar; frameName: PWideChar); virtual; cdecl; abstract;

    (**  procedure LoadFile(sfile:PAnsiChar;frameName:PWideChar = nil); virtual; cdecl; abstract;
    * Loads a local file into the WebView asynchronously.
    *
    * @param	file	The file to load.
    *
    * @param	frameName	Optional, the name of the frame to load the file in; leave this blank to load in the main frame.
    *
    * @note	The file should exist within the base directory (specified via WebCore::setBaseDirectory).
    *)
    procedure LoadFile(sfile: PAnsiChar; frameName: PWideChar); virtual; cdecl; abstract;

    (**
    * Navigates back/forward in history via a relative offset.
    *
    * @note
    *	For example, to go back one page:
    *		myView->goToHistoryOffset(-1);
    *	Or, to go forward one page:
    *		myView->goToHistoryOffset(1);
    *
    * @param	offset	The relative offset in history to navigate to.
    *)
    procedure GoToHistoryOffset(offset: Integer); virtual; cdecl; abstract;

    (**
    * Refresh the current page.
    *)
    procedure Refresh(); virtual; cdecl; abstract;

    (**
     procedure ExecuteJavascript(javascript:PAnsiChar;frameName:PWideChar = nil); virtual; cdecl; abstract;
    * Executes a string of Javascript in the context of the current page asynchronously.
    *
    * @param	javascript	The string of Javascript to execute.
    *
    * @param	frameName	Optional, the name of the frame to execute in; leave this blank to execute in the main frame.
    *)
    procedure ExecuteJavascript(javascript: PAnsiChar; frameName: PWideChar); virtual; cdecl; abstract;

    //virtual Awesomium::FutureJSValue _cdecl ExecuteJavascriptWithResult(const std::string& javascript, const std::wstring& frameName = L"");

    (**
    * Returns whether or not the current web-view is dirty and needs to be re-rendered.
    *
    * @return	If the web-view is dirty, returns true, otherwise returns false.
    *)
    function IsDirty(): Boolean; virtual; cdecl; abstract;

    (**
    * Renders the WebView to an off-screen buffer.
    *
    * @param	destination	The buffer to render to, its width and height should match the WebView's.
    *
    * @param	destRowSpan	The row-span of the destination buffer (number of bytes per row).
    *
    * @param	destDepth	The depth (bytes per pixel) of the destination buffer. Valid options
    *						include 3 (BGR/RGB) or 4 (BGRA/RGBA).
    *
    * @param	renderedRect	Optional (pass 0 to ignore); if asynchronous rendering is not enabled,
    *							you can provide a pointer to a Rect to store the dimensions of the
    *							rendered area, or rather, the dimensions of the area that actually
    *							changed since the last render.
    *)
    procedure Render(destination: PByte; destRowSpan, destDepth: Integer; renderedRect: PRect = nil); virtual; cdecl; abstract;

    (**
    * Injects a mouse-move event in local coordinates.
    *
    * @param	x	The absolute x-coordinate of the mouse (localized to the WebView).
    * @param	y	The absolute y-coordinate of the mouse (localized to the WebView).
    *)
    procedure InjectMouseMove(x, y: Integer); virtual; cdecl; abstract;

    (**
    * Injects a mouse-down event.
    *
    * @param	button	The button that was pressed.
    *)
    procedure InjectMouseDown(button: TMouseButton); virtual; cdecl; abstract;

    (**
    * Injects a mouse-up event.
    *
    * @param	button	The button that was released.
    *)
    procedure InjectMouseUp(button: TMouseButton); virtual; cdecl; abstract;

    (**
    * Injects a mouse-wheel event.
    *
    * @param	scrollAmountY	The amount of pixels to scroll by in the Y axis.
    * @param	scrollAmountX	The amount of pixels to scroll by in the X axis.
    *)
    procedure InjectMouseWheelXY(scrollAmountX, scrollAmountY: Integer); virtual; cdecl; abstract;

    (**
    * Injects a mouse-wheel event. Calls injectMouseWheelXY(0, scrollAmountY).
    *
    * @param	scrollAmountY	The amount of pixels to scroll by in the Y axis.
    *)
    procedure InjectMouseWheel(scrollAmountY: Integer); virtual; cdecl; abstract;

    (**
    * Injects a mouse-wheel event.
    *
    * @param	press	True if this is a keypress event, false if this is a release event.
    * @param	modifiers	The bitwise or of appropriate KeyModifier flags for this event.
    * @param	windowsCode	The windows VK_ code for the actual key pressed.
    * @param	nativeCode	Any platform-dependent scancode, or 0 if not available.
    * @param	isSystem	True
    *
    * @see http://www.w3.org/TR/DOM-Level-3-Events/events.html#Events-KeyboardEvent
    *)
    procedure InjectKeyEvent(press: Boolean; modifiers, windowsCode: Integer; nativeCode: Integer = 0); virtual; cdecl; abstract;

    (**
    * Injects a mouse-wheel event.
    *
    * @param	text	Text encoded as UTF-32. These should correspond to WM_*CHAR messages, and
    *					should be surrounded Key events unless generated by an IME.
    *)
    procedure InjectTextEvent(text: pwidestring); virtual; cdecl; abstract;

    (**
    * Injects a keyboard event. [Windows]
    *
    * @note	The native Windows keyboard message should be passed, valid message types include:
    *		- WM_KEYDOWN
    *		- WM_KEYUP
    *		- WM_SYSKEYDOWN
    *		- WM_SYSKEYUP
    *		- WM_CHAR
    *		- WM_IMECHAR
    *		- WM_SYSCHAR
    *)
    procedure InjectKeyboardEvent(hwnd: hwnd; message: UINT; wwparam: WPARAM; llparam: LPARAM); virtual; cdecl; abstract;

    (**
    * Invokes a 'cut' action using the system clipboard.
    *)
    procedure Cut(); virtual; cdecl; abstract;
    (**
    * Invokes a 'copy' action using the system clipboard.
    *)
    procedure Copy(); virtual; cdecl; abstract;
    (**
    * Invokes a 'paste' action using the system clipboard.
    *)
    procedure Paste(); virtual; cdecl; abstract;
    (**
    * Selects all items on the current page.
    *)
    procedure SelectAll(); virtual; cdecl; abstract;

    (**
    * De-selects all items on the current page.
    *)
    procedure DeselectAll(); virtual; cdecl; abstract;

    (**
    * Zooms into the page, enlarging by 20%.
    *)
    procedure ZoomIn(); virtual; cdecl; abstract;

    (**
    * Zooms out of the page, reducing by 20%.
    *)
    procedure ZoomOut(); virtual; cdecl; abstract;

    (**
    * Resets the zoom level.
    *)
    procedure ResetZoom(); virtual; cdecl; abstract;

    (**
    * Resizes this WebView to certain dimensions.
    *
    * @param	width	The width to resize to.
    * @param	height	The height to resize to.
    *)
    procedure Resize(width, height: Integer); virtual; cdecl; abstract;

    (**
    * Notifies the current page that it has lost focus.
    *)
    procedure Unfocus(); virtual; cdecl; abstract;

    (**
    * Notifies the current page that is has gained focus.
    *)
    procedure Focus(); virtual; cdecl; abstract;

    (**
    * Sets whether or not pages should be rendered with a transparent background-color.
    *
    * @param	isTransparent	Whether or not to force the background-color as transparent.
    *)
    procedure SetTransparent(isTransparent: Boolean); virtual; cdecl; abstract;
  end;

  TCWebCore = class
  public
    procedure Destroy(); virtual; cdecl; abstract;
    function CreateWebView(nwidth, nheight: Integer; isTransparent: Boolean = False; enableAsyncRendering: Boolean = False; maxAsyncRenderPerSec: Integer = 0): TCWebView; virtual; cdecl; abstract;
    //WebCore
    (**
    * Sets the base directory.
    *
    * @param	baseDirectory	The absolute path to your base directory. The base directory is a
    *							location that holds all of your local assets. It will be used for
    *							WebView::loadFile and WebView::loadHTML (to resolve relative URL's).
    *)
    procedure SetBaseDirectory(baseDirectory: PAnsiChar); virtual; cdecl; abstract;

    (**
    * Sets a custom response page to use when a WebView encounters a certain
    * HTML status code from the server (such as '404 - File not found').
    *
    * @param	statusCode	The status code this response page should be associated with.
    *						See <http://en.wikipedia.org/wiki/List_of_HTTP_status_codes>
    *
    * @param	filePath	The local page to load as a response, should be a path relative to the base directory.
    *)
    procedure SetCustomResponsePage(statusCode: Integer; filePath: PAnsiChar); virtual; cdecl; abstract;
    (**
    * Updates the WebCore and allows it to conduct various operations such as the propagation
    * of bound JS callbacks and the invocation of any queued listener events.
    *)
    procedure Update(); virtual; cdecl; abstract;

    (**
    * Retrieves the base directory.
    *
    * @return	Returns the current base directory.
    *)
    function GetBaseDirectory(): string; virtual; cdecl; abstract;

    (**
    * Retrieves the pixel format being used.
    *)
    function GetPixelFormat(): TPixelFormat; virtual; cdecl; abstract;

    (**
    * Returns whether or not plugins are enabled.
    *)
    function ArePluginsEnabled(): Boolean; virtual; cdecl; abstract;

    (**
    * Pauses the internal thread of the Awesomium WebCore.
    *
    * @note	The pause and resume functions were added as
    *		a temporary workaround for threading issues with
    *		Flash plugins on the Mac OSX platform. You should
    *		call WebCore::pause right before handling the
    *		message loop in your main thread (usually via
    *		SDL_PollEvents) and immediately call resume after.
    *)
    procedure Pause(); virtual; cdecl; abstract;

    (**
    * Resumes the internal thread of the Awesomium WebCore.
    *
    * @note	See WebCore::pause.
    *)
    procedure Resume(); virtual; cdecl; abstract;
  end;

  TJSValue = class
  public
    function Gettype(): TVariantType; virtual; cdecl; abstract;
    function ToString(var len): PChar; virtual; cdecl; abstract;
    function ToInteger(): Integer; virtual; cdecl; abstract;
    function ToDouble(): Double; virtual; cdecl; abstract;
    function ToBoolean(): Boolean; virtual; cdecl; abstract;
  end;

  TJSValueList = class
  public
    function Count(): Integer; virtual; cdecl; abstract;
    function GetJSValue(const Idex: Integer): TJSValue; virtual; cdecl; abstract;
  end;

  TWebCore = class
  private
    FHGE: IHGE;
    FWebCore: TCWebCore;
    FBaseDirectory: string;
    FLogLevel: TLogLevel;
    FenablePlugins: Boolean;
    FpixelFormat: TPixelFormat;
    FInit: Boolean;
    FTimer: Single;
    class function InterfaceGet: TWebCore;
  protected
    procedure SetBaseDirectory(const value: string);
  public
    constructor Create();
    destructor Destroy; override;
    procedure Initialize();
    procedure SetCustomResponsePage(statusCode: Integer; filePath: PAnsiChar);
    function Update: Boolean;
    procedure Pause();
    procedure Resume();
    function CreateWebView(nwidth, nheight: Integer; isTransparent: Boolean = False; enableAsyncRendering: Boolean = False; maxAsyncRenderPerSec: Integer = 0): TCWebView;
  published
    property baseDirectory: string read FBaseDirectory write SetBaseDirectory;
    property LogLevel: TLogLevel read FLogLevel write FLogLevel;
    property EnablePlugins: Boolean read FenablePlugins write FenablePlugins;
    property PixelFormat: TPixelFormat read FpixelFormat write FpixelFormat;
    property WebCore: TCWebCore read FWebCore;
  end;

function WebCoreCreate(): TWebCore;

implementation

type
  (**
  * Creates a new TCWebCtrl.
  *
  * @return	Returns a pointer to the created TCWebCtrl.
  *)
  TfnPYCreateWebCore = function(level: TLogLevel = LOG_NORMAL; EnablePlugins: Boolean = True; PixelFormat: TPixelFormat = PF_RGBA): TCWebCore; cdecl;

var
  DllHandle                 : THandle = 0;
  PYCreateWebCore           : TfnPYCreateWebCore = nil;
  PHGEWebCore               : TWebCore = nil;

function WebCoreCreate(): TWebCore;
begin
  result := TWebCore.InterfaceGet
end;

class function TWebCore.InterfaceGet: TWebCore;
begin
  if (PHGEWebCore = nil) then
    PHGEWebCore := TWebCore.Create;
  result := PHGEWebCore;
end;

{ THGEWebCore }

constructor TWebCore.Create();
begin
  inherited Create();
  FHGE := HGECreate(HGE_VERSION);
  FLogLevel := LOG_NORMAL;
  FenablePlugins := True;
  FpixelFormat := PF_BGRA;
  FInit := False;
  FWebCore := nil;
  FTimer := 0;
end;

destructor TWebCore.Destroy;
begin
  if FWebCore <> nil then
    FWebCore.Destroy;
  FWebCore := nil;
  if PHGEWebCore = Self then
    PHGEWebCore := nil;
  inherited Destroy;
end;

function TWebCore.CreateWebView(nwidth, nheight: Integer; isTransparent, enableAsyncRendering: Boolean;
  maxAsyncRenderPerSec: Integer): TCWebView;
begin
  result := nil;
  Initialize();
  if FWebCore <> nil then begin
    result := FWebCore.CreateWebView(nwidth, nheight, isTransparent, enableAsyncRendering, maxAsyncRenderPerSec);
  end;
end;

procedure TWebCore.Initialize;
begin
  if FInit then Exit;
  FInit := True;
  if Assigned(PYCreateWebCore) then
    FWebCore := PYCreateWebCore(FLogLevel, FenablePlugins, FpixelFormat);
  if FBaseDirectory <> '' then begin
    if FWebCore <> nil then
      FWebCore.SetBaseDirectory(PChar(FBaseDirectory));
  end;
end;

procedure TWebCore.Pause;
begin
  if FWebCore <> nil then
    FWebCore.Pause;
end;

procedure TWebCore.Resume;
begin
  if FWebCore <> nil then
    FWebCore.Resume;
end;

procedure TWebCore.SetBaseDirectory(const value: string);
begin
  if FBaseDirectory <> value then begin
    FBaseDirectory := value;
    if FWebCore <> nil then
      FWebCore.SetBaseDirectory(PChar(FBaseDirectory));
  end;
end;

procedure TWebCore.SetCustomResponsePage(statusCode: Integer; filePath: PAnsiChar);
begin
  if FWebCore <> nil then
    FWebCore.SetCustomResponsePage(statusCode, filePath);
end;

function TWebCore.Update: Boolean;
var
  sTimer                    : Single;
begin
  if FWebCore <> nil then begin
    sTimer := FHGE.Timer_GetTime();
    if sTimer <> FTimer then begin
      FTimer := sTimer;
      FWebCore.Update;
    end;
  end;
end;

procedure LoadDLL;
var
  s                         : string;
  sDir                      : string;
begin
  {if DllHandle <> 0 then Exit;
  s := ExtractFilePath(ParamStr(0));
  if s = '' then Exit;
  if s[Length(s)] <> '\' then s := s + '\';
  //检查 LSWebCtrl.dll 在那个目录
  if FileExists(s + 'LSWebCtrl.dll') then
    sDir := s                           //DLL 文件在当前目录
  else begin                            //DLL 文件在上层目录
    Delete(s, Length(s), 1);
    sDir := ExtractFilePath(s);
  end;
  if sDir = '' then Exit;
  if sDir[Length(sDir)] <> '\' then sDir := sDir + '\';
  s := GetCurrentDir;                   //保存一下当前目录
  ChDir(sDir);                          //改变目录为当前目录
  DllHandle := LoadLibrary(PChar(sDir + 'LSWebCtrl.dll'));
  if DllHandle = 0 then begin

  end else begin
    LoadLibrary(PChar(sDir + 'avcodec-52.dll'));
    LoadLibrary(PChar(sDir + 'avformat-52.dll'));
    LoadLibrary(PChar(sDir + 'avutil-50.dll'));
  end;
  if (DllHandle <> 0) then begin
    PYCreateWebCore := TfnPYCreateWebCore(GetProcAddress(DllHandle, 'PYCreateWebCore'));
  end;
  if s[Length(s)] <> '\' then s := s + '\';
  ChDir(s);                             //原原改变目录为保存的目录}


  if DllHandle <> 0 then Exit;
  DllHandle := LoadLibrary('.\LSWebCtrl.dll');
  if DllHandle <> 0 then begin
    LoadLibrary('.\avcodec-52.dll');
    LoadLibrary('.\avformat-52.dll');
    LoadLibrary('.\avutil-50.dll');
    PYCreateWebCore := TfnPYCreateWebCore(GetProcAddress(DllHandle, 'PYCreateWebCore'));
  end;
end;

procedure FreeLoadDLL();
begin
  if DllHandle <> 0 then
    FreeLibrary(DllHandle);
end;

initialization
  LoadDLL;

finalization
  if PHGEWebCore <> nil then
    PHGEWebCore.Free;
  FreeLoadDLL;

end.

