object FormMain: TFormMain
  Left = 463
  Top = 341
  Width = 345
  Height = 277
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'FormMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter: TSplitter
    Left = 0
    Top = 140
    Width = 312
    Height = 1
    Cursor = crVSplit
    Align = alBottom
    Color = clBtnFace
    ParentColor = False
  end
  object Label1: TLabel
    Left = 136
    Top = 128
    Width = 36
    Height = 12
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 0
    Top = 141
    Width = 312
    Height = 12
    Align = alBottom
    Alignment = taRightJustify
  end
  object GridSocketInfo: TStringGrid
    Left = 0
    Top = 153
    Width = 312
    Height = 83
    Align = alBottom
    ColCount = 4
    Ctl3D = True
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 9
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = GridSocketInfoDrawCell
    ColWidths = (
      107
      42
      53
      105)
  end
  object MemoLog: TMemo
    Left = 0
    Top = 0
    Width = 312
    Height = 140
    Align = alClient
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    OnDblClick = MemoLogDblClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 236
    Width = 312
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Width = 50
      end>
  end
  object MainMenu: TMainMenu
    Left = 224
    Top = 8
    object MENU_CONTROL: TMenuItem
      Caption = #25511#21046'(&C)'
      object MENU_CONTROL_START: TMenuItem
        Caption = #21551#21160#26381#21153'(&S)'
        OnClick = MENU_CONTROL_STARTClick
      end
      object MENU_CONTROL_STOP: TMenuItem
        Caption = #20572#27490#26381#21153'(&T)'
        OnClick = MENU_CONTROL_STOPClick
      end
      object MENU_CONTROL_LINE2: TMenuItem
        Caption = '-'
      end
      object MENU_CONTROL_RELOADCONFIG: TMenuItem
        Caption = #37325#21152#36733#37197#32622'(&C)'
        OnClick = MENU_CONTROL_RELOADCONFIGClick
      end
      object MENU_CONTROL_CLEAELOG: TMenuItem
        Caption = #28165#38500#26085#24535'(&C)'
        OnClick = MENU_CONTROL_CLEAELOGClick
      end
      object MENU_CONTROL_EXIT: TMenuItem
        Caption = #36864#20986'(&E)'
        OnClick = MENU_CONTROL_EXITClick
      end
    end
    object MENU_OPTION: TMenuItem
      Caption = #36873#39033'(&O)'
      object MENU_OPTION_GENERAL: TMenuItem
        Caption = #22522#26412#21442#25968'(&G)'
        OnClick = MENU_OPTION_GENERALClick
      end
      object MENU_OPTION_IPFILTER: TMenuItem
        Caption = #23433#20840#36807#28388'(&S)'
        OnClick = MENU_OPTION_IPFILTERClick
      end
    end
    object MENU_VIEW_HELP: TMenuItem
      Caption = #24110#21161'(&H)'
      object MENU_VIEW_HELP_ABOUT: TMenuItem
        Caption = #20851#20110'(&A)'
        OnClick = MENU_VIEW_HELP_ABOUTClick
      end
    end
  end
end
