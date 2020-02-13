object frmViewKernelInfo: TfrmViewKernelInfo
  Left = 628
  Top = 218
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #20869#26680#25968#25454#26597#30475
  ClientHeight = 368
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object SysInfo_PageControl: TPageControl
    Left = 6
    Top = 6
    Width = 385
    Height = 355
    ActivePage = TabSheet3
    TabOrder = 0
    object TabSheet3: TTabSheet
      Caption = #20840#23616#21464#37327
      ImageIndex = 2
      object ListViewGlobalVal: TListView
        Left = 8
        Top = 8
        Width = 361
        Height = 146
        Columns = <
          item
            Caption = #24207#21495
          end
          item
            Caption = #24403#21069#25968#20540
            Width = 100
          end>
        GridLines = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object ButtonRefGlobalVal: TButton
        Left = 288
        Top = 302
        Width = 83
        Height = 23
        Caption = #21047#26032'(&R)'
        TabOrder = 2
        OnClick = ButtonRefGlobalValClick
      end
      object ListViewGlobaStrVal: TListView
        Left = 8
        Top = 160
        Width = 361
        Height = 137
        Columns = <
          item
            Caption = #24207#21495
          end
          item
            Caption = #24403#21069#23383#31526#20018
            Width = 500
          end>
        GridLines = True
        TabOrder = 1
        ViewStyle = vsReport
      end
      object ButtonClearSval: TButton
        Left = 71
        Top = 303
        Width = 58
        Height = 23
        Caption = #28165#31354'&S'
        TabOrder = 3
        OnClick = ButtonClearSvalClick
      end
      object ButtonClearGval: TButton
        Left = 8
        Top = 303
        Width = 57
        Height = 23
        Caption = #28165#31354'&G'
        TabOrder = 4
        OnClick = ButtonClearGvalClick
      end
      object Button1: TButton
        Left = 135
        Top = 303
        Width = 58
        Height = 23
        Caption = #28165#31354'&I'
        TabOrder = 5
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 199
        Top = 303
        Width = 58
        Height = 23
        Caption = #28165#31354'&H'
        TabOrder = 6
        OnClick = Button2Click
      end
    end
    object TabSheet1: TTabSheet
      Caption = #28216#25103#25968#25454
      object GroupBox1: TGroupBox
        Left = 8
        Top = 4
        Width = 169
        Height = 125
        Caption = #28216#25103#25968#25454#24211
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 20
          Width = 78
          Height = 12
          Caption = #35835#21462#35831#27714#27425#25968':'
        end
        object Label2: TLabel
          Left = 8
          Top = 44
          Width = 78
          Height = 12
          Caption = #35835#21462#22833#36133#27425#25968':'
        end
        object Label3: TLabel
          Left = 8
          Top = 68
          Width = 78
          Height = 12
          Caption = #20445#23384#35831#27714#27425#25968':'
        end
        object Label4: TLabel
          Left = 8
          Top = 92
          Width = 78
          Height = 12
          Caption = #35831#27714#26631#35782#25968#23383':'
        end
        object EditLoadHumanDBCount: TEdit
          Left = 88
          Top = 16
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditLoadHumanDBErrorCoun: TEdit
          Left = 88
          Top = 40
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
        object EditSaveHumanDBCount: TEdit
          Left = 88
          Top = 64
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 2
        end
        object EditHumanDBQueryID: TEdit
          Left = 88
          Top = 88
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 3
        end
      end
      object GroupBox4: TGroupBox
        Left = 184
        Top = 4
        Width = 185
        Height = 125
        Caption = #29289#21697#31995#21015#21495
        TabOrder = 1
        object Label7: TLabel
          Left = 8
          Top = 20
          Width = 78
          Height = 12
          Caption = #24618#29289#25481#33853#29289#21697':'
        end
        object Label8: TLabel
          Left = 8
          Top = 44
          Width = 78
          Height = 12
          Caption = #21629#20196#21046#36896#29289#21697':'
        end
        object EditItemNumber: TEdit
          Left = 88
          Top = 16
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditItemNumberEx: TEdit
          Left = 88
          Top = 40
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
      end
      object GroupBox2: TGroupBox
        Left = 184
        Top = 148
        Width = 185
        Height = 173
        Caption = #20013#22870#25968#37327
        TabOrder = 3
        object Label5: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #20013#22870#24635#25968':'
        end
        object Label6: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #26410#20013#22870#25968':'
        end
        object EditWinLotteryCount: TEdit
          Left = 90
          Top = 16
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditNoWinLotteryCount: TEdit
          Left = 90
          Top = 40
          Width = 81
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 148
        Width = 169
        Height = 173
        Caption = #20013#22870#27604#20363
        TabOrder = 2
        object Label9: TLabel
          Left = 8
          Top = 20
          Width = 42
          Height = 12
          Caption = #19968#31561#22870':'
        end
        object Label10: TLabel
          Left = 8
          Top = 44
          Width = 42
          Height = 12
          Caption = #20108#31561#22870':'
        end
        object Label11: TLabel
          Left = 8
          Top = 68
          Width = 42
          Height = 12
          Caption = #19977#31561#22870':'
        end
        object Label12: TLabel
          Left = 8
          Top = 92
          Width = 42
          Height = 12
          Caption = #22235#31561#22870':'
        end
        object Label13: TLabel
          Left = 8
          Top = 116
          Width = 42
          Height = 12
          Caption = #20116#31561#22870':'
        end
        object Label14: TLabel
          Left = 8
          Top = 140
          Width = 42
          Height = 12
          Caption = #20845#31561#22870':'
        end
        object EditWinLotteryLevel1: TEdit
          Left = 88
          Top = 16
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditWinLotteryLevel2: TEdit
          Left = 88
          Top = 40
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
        object EditWinLotteryLevel3: TEdit
          Left = 88
          Top = 64
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 2
        end
        object EditWinLotteryLevel4: TEdit
          Left = 88
          Top = 88
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 3
        end
        object EditWinLotteryLevel5: TEdit
          Left = 88
          Top = 112
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 4
        end
        object EditWinLotteryLevel6: TEdit
          Left = 88
          Top = 136
          Width = 65
          Height = 20
          ReadOnly = True
          TabOrder = 5
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #24037#20316#32447#31243
      ImageIndex = 4
      object GroupBox7: TGroupBox
        Left = 8
        Top = 4
        Width = 361
        Height = 317
        Caption = #32447#31243#29366#24577
        TabOrder = 0
        object GridThread: TStringGrid
          Left = 8
          Top = 18
          Width = 345
          Height = 291
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 14
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
          TabOrder = 0
          ColWidths = (
            52
            50
            49
            113
            73)
        end
      end
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 280
    Top = 280
  end
  object MainMenu: TMainMenu
    Left = 226
    Top = 293
    object VIEW_IINFO: TMenuItem
      Caption = #26597#30475'(&V)'
      object VIEW_IINFO_CHGREFINTER: TMenuItem
        Caption = #26356#26032#36895#24230'(&U)'
        object VIEW_IINFO_CHGREFINTER_H: TMenuItem
          Caption = #39640'(&H)'
          OnClick = VIEW_IINFO_CHGREFINTER_HClick
        end
        object VIEW_IINFO_CHGREFINTER_N: TMenuItem
          Caption = #26631#20934'(&N)'
          Checked = True
          OnClick = VIEW_IINFO_CHGREFINTER_NClick
        end
        object VIEW_IINFO_CHGREFINTER_L: TMenuItem
          Caption = #20302'(&L)'
          OnClick = VIEW_IINFO_CHGREFINTER_LClick
        end
      end
    end
    object A1: TMenuItem
      Caption = #20851#20110'(&A)'
      OnClick = A1Click
    end
  end
end
