object frmDBTool: TfrmDBTool
  Left = 469
  Top = 224
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25968#25454#31649#29702#24037#20855
  ClientHeight = 273
  ClientWidth = 570
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 554
    Height = 257
    ActivePage = TabSheet3
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #25968#25454#24211#20449#24687
      object GroupBox1: TGroupBox
        Left = 5
        Top = 4
        Width = 265
        Height = 221
        Caption = #20154#29289#20449#24687#25968#25454#24211'(Mir.DB)'
        TabOrder = 0
        object GridMirDBInfo: TStringGrid
          Left = 8
          Top = 16
          Width = 249
          Height = 193
          ColCount = 2
          DefaultRowHeight = 18
          RowCount = 10
          TabOrder = 0
          ColWidths = (
            64
            181)
        end
      end
      object GroupBox2: TGroupBox
        Left = 277
        Top = 4
        Width = 265
        Height = 221
        Caption = #20154#29289#25968#25454#24211'(Hum.DB)'
        TabOrder = 1
        object GridHumDBInfo: TStringGrid
          Left = 8
          Top = 16
          Width = 249
          Height = 193
          ColCount = 2
          DefaultRowHeight = 18
          RowCount = 10
          TabOrder = 0
          ColWidths = (
            64
            181)
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #25968#25454#24211#37325#24314
      ImageIndex = 1
      object LabelProcess: TLabel
        Left = 73
        Top = 151
        Width = 18
        Height = 12
        Caption = '...'
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 9
        Top = 151
        Width = 54
        Height = 12
        Caption = #37325#24314#36827#24230':'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object LabelProcessPercent: TLabel
        Left = 523
        Top = 151
        Width = 12
        Height = 12
        Alignment = taRightJustify
        Caption = '0%'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 8
        Top = 208
        Width = 120
        Height = 12
        Caption = #26410#23436#25104#65292#35831#19981#35201#20351#29992#12290
        Font.Charset = GB2312_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object ButtonStartRebuild: TButton
        Left = 440
        Top = 198
        Width = 99
        Height = 25
        Caption = #24320#22987'(&S)'
        TabOrder = 0
        OnClick = ButtonStartRebuildClick
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 529
        Height = 137
        Caption = #37325#24314#36873#39033
        TabOrder = 1
        object CheckBoxDelDenyChr: TCheckBox
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = #21024#38500#24050#31105#29992#30340#35282#33394
          TabOrder = 0
          OnClick = CheckBoxDelDenyChrClick
        end
        object CheckBoxDelAllItem: TCheckBox
          Left = 16
          Top = 56
          Width = 113
          Height = 17
          Caption = #21024#38500#20154#29289#29289#21697
          TabOrder = 1
          OnClick = CheckBoxDelAllItemClick
        end
        object CheckBoxDelAllSkill: TCheckBox
          Left = 16
          Top = 72
          Width = 113
          Height = 17
          Caption = #21024#38500#20154#29289#25216#33021
          TabOrder = 2
          OnClick = CheckBoxDelAllSkillClick
        end
        object CheckBoxDelBonusAbil: TCheckBox
          Left = 16
          Top = 88
          Width = 113
          Height = 17
          Caption = #21024#38500#20154#29289#23646#24615#28857
          TabOrder = 3
          OnClick = CheckBoxDelBonusAbilClick
        end
        object CheckBoxDelLevel: TCheckBox
          Left = 16
          Top = 40
          Width = 153
          Height = 17
          Caption = #21024#38500#20154#29289#31561#32423#21450#30456#20851#20449#24687
          TabOrder = 4
          OnClick = CheckBoxDelLevelClick
        end
      end
      object ProgressBar: TProgressBar
        Left = 8
        Top = 168
        Width = 529
        Height = 17
        Smooth = True
        TabOrder = 2
      end
    end
    object TabSheet3: TTabSheet
      Caption = #33258#21160#30331#38470#25968#25454
      ImageIndex = 2
      object GroupBox4: TGroupBox
        Left = 11
        Top = 11
        Width = 526
        Height = 54
        Caption = #36873#39033
        TabOrder = 0
        object Label6: TLabel
          Left = 8
          Top = 20
          Width = 198
          Height = 12
          Caption = #31561#32423#8805'          '#8804'           '#20043#38388
        end
        object Label3: TLabel
          Left = 232
          Top = 20
          Width = 30
          Height = 12
          Caption = #25968#37327':'
        end
        object EditLevelMin: TSpinEdit
          Left = 46
          Top = 17
          Width = 58
          Height = 21
          MaxValue = 65535
          MinValue = 1
          TabOrder = 0
          Value = 1
          OnChange = EditLevelMinChange
        end
        object EditLevelMax: TSpinEdit
          Left = 118
          Top = 17
          Width = 59
          Height = 21
          MaxValue = 65535
          MinValue = 0
          TabOrder = 1
          Value = 60
          OnChange = EditLevelMaxChange
        end
        object EditHumanCount: TSpinEdit
          Left = 268
          Top = 17
          Width = 67
          Height = 21
          MaxValue = 65535
          MinValue = 1
          TabOrder = 2
          Value = 200
        end
        object ButtonExportData: TButton
          Left = 421
          Top = 15
          Width = 89
          Height = 25
          Caption = #23548#20986#25968#25454'(&E)'
          TabOrder = 3
          OnClick = ButtonExportDataClick
        end
      end
    end
  end
  object TimerShowInfo: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerShowInfoTimer
    Left = 248
    Top = 224
  end
end
