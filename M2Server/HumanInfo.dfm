object frmHumanInfo: TfrmHumanInfo
  Left = 582
  Top = 225
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #20154#29289#23646#24615
  ClientHeight = 358
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 633
    Height = 343
    ActivePage = TabSheet5
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #20154#29289#20449#24687
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 209
        Height = 241
        Caption = #26597#30475#20449#24687
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 19
          Width = 54
          Height = 12
          Caption = #20154#29289#21517#31216':'
        end
        object Label2: TLabel
          Left = 8
          Top = 43
          Width = 54
          Height = 12
          Caption = #25152#22312#22320#22270':'
        end
        object Label3: TLabel
          Left = 8
          Top = 67
          Width = 54
          Height = 12
          Caption = #25152#22312#24231#26631':'
        end
        object Label4: TLabel
          Left = 8
          Top = 91
          Width = 54
          Height = 12
          Caption = #30331#24405#24080#21495':'
        end
        object Label5: TLabel
          Left = 8
          Top = 115
          Width = 42
          Height = 12
          Caption = #30331#24405'IP:'
        end
        object Label6: TLabel
          Left = 8
          Top = 139
          Width = 54
          Height = 12
          Caption = #30331#24405#26102#38388':'
        end
        object Label7: TLabel
          Left = 8
          Top = 163
          Width = 54
          Height = 12
          Caption = #22312#32447#26102#38271':'
        end
        object Label20: TLabel
          Left = 8
          Top = 187
          Width = 54
          Height = 12
          Caption = #33521#38596#21517#23383':'
        end
        object Label22: TLabel
          Left = 8
          Top = 211
          Width = 54
          Height = 12
          Caption = #25152#22312#21306#22495':'
        end
        object EditName: TEdit
          Left = 64
          Top = 16
          Width = 129
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditMap: TEdit
          Left = 64
          Top = 40
          Width = 129
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
        object EditXY: TEdit
          Left = 64
          Top = 64
          Width = 129
          Height = 20
          ReadOnly = True
          TabOrder = 2
        end
        object EditAccount: TEdit
          Left = 64
          Top = 88
          Width = 129
          Height = 20
          ReadOnly = True
          TabOrder = 3
        end
        object EditIPaddr: TEdit
          Left = 64
          Top = 112
          Width = 129
          Height = 20
          ReadOnly = True
          TabOrder = 4
        end
        object EditLogonTime: TEdit
          Left = 64
          Top = 136
          Width = 129
          Height = 20
          ReadOnly = True
          TabOrder = 5
        end
        object EditLogonLong: TEdit
          Left = 64
          Top = 160
          Width = 129
          Height = 20
          ReadOnly = True
          TabOrder = 6
        end
        object EditHeroName: TEdit
          Left = 64
          Top = 184
          Width = 129
          Height = 20
          ReadOnly = True
          TabOrder = 7
        end
        object EditIPLocal: TEdit
          Left = 64
          Top = 208
          Width = 129
          Height = 20
          ReadOnly = True
          TabOrder = 8
        end
      end
      object GroupBox3: TGroupBox
        Left = 224
        Top = 8
        Width = 153
        Height = 241
        Caption = #20154#29289#23646#24615
        TabOrder = 1
        object Label11: TLabel
          Left = 8
          Top = 67
          Width = 30
          Height = 12
          Caption = #38450#24481':'
        end
        object Label13: TLabel
          Left = 8
          Top = 91
          Width = 30
          Height = 12
          Caption = #39764#38450':'
        end
        object Label14: TLabel
          Left = 8
          Top = 115
          Width = 42
          Height = 12
          Caption = #25915#20987#21147':'
        end
        object Label15: TLabel
          Left = 8
          Top = 139
          Width = 30
          Height = 12
          Caption = #39764#27861':'
        end
        object Label16: TLabel
          Left = 8
          Top = 163
          Width = 30
          Height = 12
          Caption = #36947#26415':'
        end
        object Label17: TLabel
          Left = 8
          Top = 187
          Width = 42
          Height = 12
          Caption = #29983#21629#20540':'
        end
        object Label18: TLabel
          Left = 8
          Top = 211
          Width = 42
          Height = 12
          Caption = #39764#27861#20540':'
        end
        object Label23: TLabel
          Left = 8
          Top = 19
          Width = 30
          Height = 12
          Caption = #31561#32423':'
        end
        object Label24: TLabel
          Left = 8
          Top = 43
          Width = 42
          Height = 12
          Caption = #38656#32463#39564':'
        end
        object EditAC: TEdit
          Left = 56
          Top = 64
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditMAC: TEdit
          Left = 56
          Top = 88
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
        object EditDC: TEdit
          Left = 56
          Top = 112
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 2
        end
        object EditMC: TEdit
          Left = 56
          Top = 136
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 3
        end
        object EditSC: TEdit
          Left = 56
          Top = 160
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 4
        end
        object EditHP: TEdit
          Left = 56
          Top = 184
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 5
        end
        object EditMP: TEdit
          Left = 56
          Top = 208
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 6
        end
        object EditLevelShow: TEdit
          Left = 56
          Top = 16
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 7
        end
        object EditMaxExpShow: TEdit
          Left = 56
          Top = 40
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 8
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #26222#36890#25968#25454
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 193
        Height = 241
        Caption = #21487#35843#23646#24615
        TabOrder = 0
        object Label12: TLabel
          Left = 8
          Top = 18
          Width = 30
          Height = 12
          Caption = #31561#32423':'
        end
        object Label8: TLabel
          Left = 8
          Top = 42
          Width = 42
          Height = 12
          Caption = #37329#24065#25968':'
        end
        object Label9: TLabel
          Left = 8
          Top = 66
          Width = 42
          Height = 12
          Caption = 'PK'#28857#25968':'
        end
        object Label10: TLabel
          Left = 8
          Top = 90
          Width = 54
          Height = 12
          Caption = #32463#39564#28857#25968':'
        end
        object Label29: TLabel
          Left = 8
          Top = 186
          Width = 54
          Height = 12
          Caption = #23646#24615#28857#19968':'
        end
        object Label28: TLabel
          Left = 8
          Top = 162
          Width = 42
          Height = 12
          Caption = #22768#26395#28857':'
        end
        object Label27: TLabel
          Left = 8
          Top = 138
          Width = 42
          Height = 12
          Caption = #28216#25103#28857':'
        end
        object Label26: TLabel
          Left = 8
          Top = 114
          Width = 42
          Height = 12
          Caption = #28216#25103#24065':'
        end
        object Label19: TLabel
          Left = 8
          Top = 210
          Width = 54
          Height = 12
          Hint = #24050#20998#37197#23646#24615#28857#25968#12290
          Caption = #23646#24615#28857#20108':'
        end
        object EditLevel: TSpinEdit
          Left = 68
          Top = 15
          Width = 117
          Height = 21
          MaxValue = 65535
          MinValue = 1
          TabOrder = 0
          Value = 10
        end
        object EditGold: TSpinEdit
          Left = 68
          Top = 39
          Width = 117
          Height = 21
          Increment = 1000
          MaxValue = 2000000000
          MinValue = 0
          TabOrder = 1
          Value = 10
        end
        object EditPKPoint: TSpinEdit
          Left = 68
          Top = 63
          Width = 117
          Height = 21
          Increment = 50
          MaxValue = 20000
          MinValue = 0
          TabOrder = 2
          Value = 10
        end
        object EditExp: TSpinEdit
          Left = 68
          Top = 87
          Width = 117
          Height = 21
          EditorEnabled = False
          Enabled = False
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 10
        end
        object EditGamePoint: TSpinEdit
          Left = 68
          Top = 135
          Width = 117
          Height = 21
          MaxValue = 200000000
          MinValue = 0
          TabOrder = 4
          Value = 10
        end
        object EditGameGold: TSpinEdit
          Left = 68
          Top = 111
          Width = 117
          Height = 21
          MaxValue = 2000000000
          MinValue = 0
          TabOrder = 5
          Value = 10
        end
        object EditEditBonusPointUsed: TSpinEdit
          Left = 68
          Top = 207
          Width = 117
          Height = 21
          Hint = #26410#20998#37197#23646#24615#28857
          EditorEnabled = False
          Enabled = False
          MaxValue = 0
          MinValue = 0
          TabOrder = 6
          Value = 10
        end
        object EditCreditPoint: TSpinEdit
          Left = 68
          Top = 159
          Width = 117
          Height = 21
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 10
        end
        object EditBonusPoint: TSpinEdit
          Left = 68
          Top = 183
          Width = 117
          Height = 21
          Hint = #26410#20998#37197#23646#24615#28857
          MaxValue = 2000000
          MinValue = 0
          TabOrder = 8
          Value = 10
        end
      end
      object GroupBox6: TGroupBox
        Left = 207
        Top = 8
        Width = 97
        Height = 73
        Caption = #20154#29289#29366#24577
        TabOrder = 1
        object CheckBoxGameMaster: TCheckBox
          Left = 8
          Top = 16
          Width = 73
          Height = 17
          Caption = 'GM '#27169#24335
          TabOrder = 0
        end
        object CheckBoxSuperMan: TCheckBox
          Left = 8
          Top = 32
          Width = 73
          Height = 17
          Caption = #26080#25932#27169#24335
          TabOrder = 1
        end
        object CheckBoxObserver: TCheckBox
          Left = 8
          Top = 48
          Width = 73
          Height = 17
          Caption = #38544#36523#27169#24335
          TabOrder = 2
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #36523#19978#35013#22791
      ImageIndex = 3
      object GroupBox7: TGroupBox
        Left = 8
        Top = 8
        Width = 609
        Height = 241
        Caption = #35013#22791#21015#34920
        TabOrder = 0
        object GridUserItem: TStringGrid
          Left = 2
          Top = 14
          Width = 605
          Height = 225
          Align = alClient
          ColCount = 10
          DefaultColWidth = 55
          DefaultRowHeight = 15
          RowCount = 14
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
          TabOrder = 0
          ColWidths = (
            55
            67
            63
            68
            45
            45
            44
            43
            46
            218)
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #32972#21253#29289#21697
      ImageIndex = 4
      object GroupBox8: TGroupBox
        Left = 8
        Top = 8
        Width = 609
        Height = 241
        Caption = #35013#22791#21015#34920
        TabOrder = 0
        object GridBagItem: TStringGrid
          Left = 2
          Top = 14
          Width = 605
          Height = 225
          Align = alClient
          ColCount = 10
          DefaultColWidth = 55
          DefaultRowHeight = 15
          RowCount = 14
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
          TabOrder = 0
          ColWidths = (
            55
            67
            63
            68
            45
            45
            44
            43
            46
            218)
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = #20179#24211#29289#21697
      ImageIndex = 5
      object GroupBox10: TGroupBox
        Left = 8
        Top = 8
        Width = 609
        Height = 241
        Caption = #35013#22791#21015#34920
        TabOrder = 0
        object GridStorageItem: TStringGrid
          Left = 2
          Top = 14
          Width = 605
          Height = 225
          Align = alClient
          ColCount = 10
          DefaultColWidth = 55
          DefaultRowHeight = 15
          FixedCols = 0
          RowCount = 14
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
          TabOrder = 0
          ColWidths = (
            55
            67
            63
            67
            45
            45
            44
            43
            46
            211)
        end
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 20
    Top = 289
    Width = 609
    Height = 49
    Caption = #25511#21046
    TabOrder = 1
    object Label21: TLabel
      Left = 8
      Top = 23
      Width = 60
      Height = 12
      Caption = #24403#21069#29366#24577#65306
    end
    object CheckBoxMonitor: TCheckBox
      Left = 192
      Top = 20
      Width = 73
      Height = 17
      Caption = #23454#26102#30417#25511
      TabOrder = 0
      OnClick = CheckBoxMonitorClick
    end
    object ButtonKick: TButton
      Left = 429
      Top = 15
      Width = 81
      Height = 25
      Caption = #36386#19979#32447
      TabOrder = 1
      OnClick = ButtonKickClick
    end
    object EditHumanStatus: TEdit
      Left = 69
      Top = 19
      Width = 105
      Height = 20
      ReadOnly = True
      TabOrder = 2
    end
    object ButtonSave: TButton
      Left = 517
      Top = 15
      Width = 81
      Height = 25
      Caption = #20462#25913#25968#25454
      TabOrder = 3
      OnClick = ButtonSaveClick
    end
    object btnRefresh: TButton
      Left = 344
      Top = 15
      Width = 75
      Height = 25
      Caption = #21047#26032
      TabOrder = 4
      OnClick = btnRefreshClick
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 424
    Top = 200
  end
end
