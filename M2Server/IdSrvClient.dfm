object FrmIDSoc: TFrmIDSoc
  Left = 837
  Top = 470
  Width = 187
  Height = 119
  Caption = 'FrmIDSoc'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object IDSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = IDSocketConnect
    OnDisconnect = IDSocketDisconnect
    OnRead = IDSocketRead
    OnError = IDSocketError
    Left = 56
    Top = 36
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 104
    Top = 36
  end
end
