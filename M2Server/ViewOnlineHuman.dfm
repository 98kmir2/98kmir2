object frmViewOnlineHuman: TfrmViewOnlineHuman
  Left = 326
  Top = 120
  Width = 1007
  Height = 628
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #22312#32447#20154#29289
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object PanelStatus: TPanel
    Left = 0
    Top = 65
    Width = 999
    Height = 532
    Align = alClient
    Caption = #27491#22312#35835#21462#25968#25454'...'
    TabOrder = 0
    object GridHuman: TStringGrid
      Left = 1
      Top = 1
      Width = 997
      Height = 530
      Align = alClient
      ColCount = 15
      DefaultRowHeight = 18
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnDblClick = GridHumanDblClick
      ColWidths = (
        33
        78
        33
        46
        73
        39
        47
        74
        90
        34
        152
        62
        57
        57
        81)
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 999
    Height = 65
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 30
      Height = 12
      Caption = #25490#24207':'
    end
    object Label2: TLabel
      Left = 775
      Top = 14
      Width = 138
      Height = 12
      Caption = #20154#29289#31561#32423#8805'           '#8804
    end
    object Label3: TLabel
      Left = 775
      Top = 38
      Width = 54
      Height = 12
      Caption = #21517#23383#21253#21547':'
    end
    object ButtonRefGrid: TButton
      Left = 470
      Top = 34
      Width = 67
      Height = 21
      Caption = #21047#26032'(&R)'
      TabOrder = 0
      Visible = False
      OnClick = ButtonRefGridClick
    end
    object ButtonView: TButton
      Left = 352
      Top = 10
      Width = 113
      Height = 21
      Caption = #20154#29289'/'#33521#38596#20449#24687'(&I)'
      TabOrder = 1
      OnClick = ButtonViewClick
    end
    object ButtonSearch: TButton
      Left = 272
      Top = 10
      Width = 73
      Height = 21
      Caption = #25628#32034'(&S)'
      TabOrder = 2
      OnClick = ButtonSearchClick
    end
    object EditSearchName: TEdit
      Left = 160
      Top = 11
      Width = 105
      Height = 20
      TabOrder = 3
      OnKeyPress = EditSearchNameKeyPress
    end
    object ComboBoxSort: TComboBox
      Left = 40
      Top = 11
      Width = 113
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 4
      OnClick = ComboBoxSortClick
      Items.Strings = (
        #21517#31216
        #24615#21035
        #32844#19994
        #31561#32423
        #22320#22270
        #65321#65328
        #26435#38480
        #25152#22312#22320#21306)
    end
    object ButtonKickOffLinPlayer: TButton
      Left = 663
      Top = 10
      Width = 105
      Height = 20
      Caption = #36386#33073#26426#20154#29289'(&K)->'
      TabOrder = 5
      OnClick = ButtonKickOffLinPlayerClick
    end
    object EditLevelMIN: TSpinEdit
      Left = 837
      Top = 10
      Width = 67
      Height = 21
      MaxValue = 65535
      MinValue = 1
      TabOrder = 6
      Value = 1
      OnChange = EditLevelMINChange
      OnEnter = EditLevelMINEnter
    end
    object EditLevelMAX: TSpinEdit
      Left = 917
      Top = 10
      Width = 67
      Height = 21
      MaxValue = 65535
      MinValue = 1
      TabOrder = 7
      Value = 65535
      OnChange = EditLevelMAXChange
      OnEnter = EditLevelMAXEnter
    end
    object CheckBoxHero: TCheckBox
      Left = 473
      Top = 12
      Width = 96
      Height = 17
      Caption = #26597#30475#22312#32447#33521#38596
      TabOrder = 8
      OnClick = CheckBoxHeroClick
    end
    object ButtonKickSpecPlayer: TButton
      Left = 663
      Top = 34
      Width = 105
      Height = 20
      Caption = #36386#25351#23450#20154#29289'(&K)->'
      TabOrder = 9
      OnClick = ButtonKickSpecPlayerClick
    end
    object EditSpecCharName: TEdit
      Left = 837
      Top = 35
      Width = 147
      Height = 20
      MaxLength = 14
      TabOrder = 10
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 328
    Top = 432
  end
end
