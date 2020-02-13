object FrmSrvMsg: TFrmSrvMsg
  Left = 629
  Top = 261
  Width = 193
  Height = 117
  Caption = 'FrmSrvMsg'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MsgServer: TServerSocket
    Active = False
    Address = '0.0.0.0'
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = MsgServerClientConnect
    OnClientDisconnect = MsgServerClientDisconnect
    OnClientRead = MsgServerClientRead
    OnClientError = MsgServerClientError
    Left = 27
    Top = 16
  end
end
