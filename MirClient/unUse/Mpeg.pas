unit Mpeg;

interface

uses
  Windows, DShow, ActiveX, Controls;

type
  TMPEG = class
  private
    boInit: Boolean;
    boPlay: Boolean;
    sFileName: string;
    MovieWindow: TWinControl;
    function Init(): Boolean;
    procedure Close();
    { Private declarations }
  public
    MediaEvent: IMediaEventEx;
    g_pGraphBuilder: IGraphBuilder;
    g_pMediaControl: IMediaControl;     // 播放狀態設置.
    g_pMediaSeeking: IMediaSeeking;     // 播放位置.
    g_pAudioControl: IBasicAudio;       // 音量/平衡設置.
    g_pVideoWindow: IVideoWindow;       //設置播放表單.
    constructor Create(PlayWindow: TWinControl);
    destructor Destroy; override;
    function Play(sFileName: string): Boolean;
    function Resume(): Boolean;
    procedure Pause();
    procedure Stop();
    { Public declarations }
  published
    property InitMusic: Boolean read boInit write boInit default False;
  end;

implementation

{ TMPEG }

uses ClMain;

procedure TMPEG.Close;
begin
  if Assigned(g_pMediaControl) then g_pMediaControl.Stop; // 釋放所有用到的介面。
  if Assigned(g_pAudioControl) then begin
    //g_pAudioControl._Release;
    g_pAudioControl := nil
  end;
  if Assigned(g_pMediaSeeking) then begin
    //g_pMediaSeeking._Release;
    g_pMediaSeeking := nil;
  end;
  if Assigned(g_pMediaControl) then begin
    //g_pMediaControl._Release;
    g_pMediaControl := nil;
  end;
  if Assigned(g_pVideoWindow) then begin
    //g_pVideoWindow._Release;
    g_pVideoWindow := nil;
  end;
  if Assigned(g_pGraphBuilder) then begin
    //g_pGraphBuilder._Release;
    g_pGraphBuilder := nil;
  end;
  {if Assigned(MediaEvent) then begin
    //MediaEvent._Release;
    MediaEvent := nil;
  end;}

  CoUninitialize;
  boInit := False;
end;

constructor TMPEG.Create(PlayWindow: TWinControl);
begin
  MovieWindow := PlayWindow;
  g_pGraphBuilder := nil;
  g_pMediaControl := nil;
  g_pMediaSeeking := nil;
  g_pAudioControl := nil;
  g_pVideoWindow := nil;
  MediaEvent := nil;
  //boInit:=Init();
  boInit := False;
end;

destructor TMPEG.Destroy;
begin
  Close();
  inherited;
end;

function TMPEG.Init: Boolean;
begin
  Result := False;                      // 初始化COM介面
  if failed(CoInitialize(nil)) then Exit; // 創建DirectShow Graph
  if failed(CoCreateInstance(TGUID(CLSID_FilterGraph), nil, CLSCTX_INPROC, TGUID(IID_IGraphBuilder), g_pGraphBuilder)) then Exit; // 獲取IMediaControl 介面
  if failed(g_pGraphBuilder.QueryInterface(IID_IMediaControl, g_pMediaControl)) then Exit; // 獲取IMediaSeeking 介面
  if failed(g_pGraphBuilder.QueryInterface(IID_IMediaSeeking, g_pMediaSeeking)) then Exit; // 獲取IBasicAudio 介面
  if failed(g_pGraphBuilder.QueryInterface(IID_IBasicAudio, g_pAudioControl)) then Exit; // 獲取IVideowindow 介面
  if failed(g_pGraphBuilder.QueryInterface(IID_IVideoWindow, g_pVideoWindow)) then Exit; // 所有介面獲取成功 R
  if failed(g_pGraphBuilder.QueryInterface(IID_IMediaEventEx, MediaEvent)) then Exit;
  if failed(MediaEvent.SetNotifyWindow(frmMain.Handle, WM_GraphNotify, 0)) then exit;

  Result := True;
end;

procedure TMPEG.Pause;
begin
  //if not boInit then Exit;
  //g_pMediaControl.Pause;
  //Close();
  g_pMediaControl.Pause;
end;

function TMPEG.Play(sFileName: string): Boolean;
var
  _hr                       : Hresult;
  wFile                     : array[0..(MAX_PATH * 2) - 1] of Char;
begin
  Result := False;
  boInit := Init();
  MultiByteToWideChar(CP_ACP, 0, PChar(sFileName), -1, @wFile, MAX_PATH); //轉換格式
  _hr := g_pGraphBuilder.renderfile(@wFile, nil);
  if failed(_hr) then Exit;
  if MovieWindow <> nil then begin
    g_pVideoWindow.put_Owner(MovieWindow.Handle);
    g_pVideoWindow.put_windowstyle(WS_CHILD or WS_Clipsiblings);
    g_pVideoWindow.SetWindowposition(0, 0, MovieWindow.Width, MovieWindow.Height); //播放的圖像爲整個panel1的ClientRect//
  end;
  //g_pVideoWindow.SetWindowposition(0, 0, MovieWindow.Width, MovieWindow.Handle); //播放的圖像爲整個panel1的ClientRect//
  //g_pAudioControl.put_Volume(VOLUME_FULL);//設置爲最大音量
  g_pMediaControl.Run;
  boPlay := True;
end;

function TMPEG.Resume(): Boolean;
var
  _hr                       : Hresult;
  wFile                     : array[0..(MAX_PATH * 2) - 1] of Char;
begin
  Result := False;
  if not boInit then Exit;
  g_pMediaControl.Run;
  Result := True;
  boPlay := True;
end;

procedure TMPEG.Stop;
begin
  if not boInit then Exit;
  g_pMediaControl.Stop;
  Close();
end;

end.

