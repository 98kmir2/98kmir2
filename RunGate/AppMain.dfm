object FormMain: TFormMain
  Left = 527
  Top = 281
  Width = 348
  Height = 355
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
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object StatusBar: TStatusBar
    Left = 0
    Top = 276
    Width = 332
    Height = 20
    Panels = <
      item
        Alignment = taCenter
        Text = 'Online: 0/0'
        Width = 129
      end>
  end
  object GridSocketInfo: TStringGrid
    Left = 0
    Top = 129
    Width = 332
    Height = 147
    Align = alBottom
    Ctl3D = True
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 33
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnDrawCell = GridSocketInfoDrawCell
    ColWidths = (
      103
      41
      54
      64
      63)
  end
  object MemoLog: TMemo
    Left = 0
    Top = 0
    Width = 332
    Height = 129
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
    ScrollBars = ssVertical
    TabOrder = 2
    OnDblClick = MemoLogDblClick
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
      object MENU_CONTROL_LINE1: TMenuItem
        Caption = '-'
      end
      object MENU_CONTROL_CDBroadCastMsg: TMenuItem
        Caption = #24191#25773#21152#23494#21253'(&B)'
      end
      object MENU_CONTROL_CDUnload: TMenuItem
        Caption = #21368#36733#21453#22806#25346#27169#22359'(&U)'
      end
      object MENU_CONTROL_CDReload: TMenuItem
        Caption = #37325#26032#21152#36733#21453#22806#25346#27169#22359'(&R)'
        OnClick = MENU_CONTROL_CDReloadClick
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
