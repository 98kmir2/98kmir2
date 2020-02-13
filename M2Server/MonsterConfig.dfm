object frmMonsterConfig: TfrmMonsterConfig
  Left = 769
  Top = 303
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #24618#29289#35774#32622
  ClientHeight = 314
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 473
    Height = 297
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #22522#26412#21442#25968
      object GroupBox1: TGroupBox
        Left = 8
        Top = 5
        Width = 449
        Height = 257
        TabOrder = 0
        object GroupBox8: TGroupBox
          Left = 8
          Top = 16
          Width = 161
          Height = 49
          Caption = #29190#29289#21697#35774#32622
          TabOrder = 0
          object Label23: TLabel
            Left = 11
            Top = 20
            Width = 42
            Height = 12
            Caption = #37329#24065#22534':'
          end
          object EditMonOneDropGoldCount: TSpinEdit
            Left = 60
            Top = 16
            Width = 93
            Height = 21
            MaxValue = 99999999
            MinValue = 1
            TabOrder = 0
            Value = 10
            OnChange = EditMonOneDropGoldCountChange
          end
        end
        object ButtonGeneralSave: TButton
          Left = 360
          Top = 221
          Width = 73
          Height = 25
          Caption = #20445#23384'(&S)'
          TabOrder = 1
          OnClick = ButtonGeneralSaveClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #24618#29289#31867#22411
      ImageIndex = 1
    end
  end
end
