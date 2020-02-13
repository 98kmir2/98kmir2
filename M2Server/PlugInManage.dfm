object ftmPlugInManage: TftmPlugInManage
  Left = 404
  Top = 331
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #24341#25806#25554#20214#21015#34920
  ClientHeight = 226
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object ListBoxPlugin: TListBox
    Left = 8
    Top = 8
    Width = 329
    Height = 209
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ItemHeight = 12
    ParentFont = False
    TabOrder = 0
    OnClick = ListBoxPluginClick
    OnDblClick = ListBoxPluginDblClick
  end
  object ButtonPluginConfig: TButton
    Left = 352
    Top = 8
    Width = 77
    Height = 23
    Caption = #37197#32622'(&C)'
    Enabled = False
    TabOrder = 1
    OnClick = ButtonPluginConfigClick
  end
  object btnUnLoad: TButton
    Left = 352
    Top = 40
    Width = 77
    Height = 23
    Caption = #21368#36733'(&U)'
    Enabled = False
    TabOrder = 2
  end
  object btnClose: TButton
    Left = 352
    Top = 72
    Width = 77
    Height = 23
    Caption = #20851#38381'(&X)'
    TabOrder = 3
    OnClick = btnCloseClick
  end
end
