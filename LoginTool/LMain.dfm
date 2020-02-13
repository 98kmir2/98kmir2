object FrmMain: TFrmMain
  Left = 686
  Top = 231
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  Caption = '98K'#20256#22855#30331#38470#22120
  ClientHeight = 899
  ClientWidth = 1183
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnLookup = ClientSocketLookup
    OnConnecting = ClientSocketConnecting
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 343
    Top = 144
  end
  object TimerLoginFun: TTimer
    Interval = 50
    OnTimer = TimerLoginFunTimer
    Left = 319
    Top = 192
  end
  object TimerUpgrate: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerUpgrateTimer
    Left = 231
    Top = 200
  end
  object IdAntiFreeze: TIdAntiFreeze
    OnlyWhenIdle = False
    Left = 232
    Top = 120
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    Left = 144
    Top = 200
  end
  object ClientSocket2: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnRead = ClientSocket2Read
    OnError = ClientSocket2Error
    Left = 416
    Top = 192
  end
  object ServerSocket: TServerSocket
    Active = False
    Address = '127.0.0.1'
    Port = 6692
    ServerType = stNonBlocking
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 464
    Top = 120
  end
  object TimerFindDir: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerFindDirTimer
    Left = 479
    Top = 192
  end
  object VCLUnZip: TVCLUnZip
    OnPromptForOverwrite = VCLUnZipPromptForOverwrite
    OnUnZipComplete = VCLUnZipUnZipComplete
    Left = 544
    Top = 192
  end
  object TimerPacket: TTimer
    Interval = 10
    OnTimer = TimerPacketTimer
    Left = 160
    Top = 128
  end
  object TimerWebBroswer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerWebBroswerTimer
    Left = 311
    Top = 232
  end
  object VCLUnZip1: TVCLUnZip
    Left = 576
    Top = 240
  end
  object VCLUnZip2: TVCLUnZip
    OnPromptForOverwrite = VCLUnZipPromptForOverwrite
    OnUnZipComplete = VCLUnZipUnZipComplete
    Left = 608
    Top = 192
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 680
    Top = 48
  end
  object Timer2: TTimer
    Interval = 10
    Left = 560
    Top = 32
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocket1Connect
    OnRead = ClientSocket1Read
    Left = 751
    Top = 200
  end
  object Timer3: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer3Timer
    Left = 752
    Top = 240
  end
  object ShowBackFrmTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = ShowBackFrmTimerTimer
    Left = 312
    Top = 32
  end
  object BringTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = BringTimerTimer
    Left = 400
    Top = 352
  end
  object IdHTTPUpdate: TIdHTTP
    OnWork = IdHTTPUpdateWork
    OnWorkBegin = IdHTTPUpdateWorkBegin
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 256
    Top = 328
  end
end
