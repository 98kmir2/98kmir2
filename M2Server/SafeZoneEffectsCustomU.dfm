object ftmSafeZoneEffectsCustom: TftmSafeZoneEffectsCustom
  Left = 398
  Top = 278
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #33258#23450#20041#23433#20840#21306#20809#29615#29305#25928
  ClientHeight = 399
  ClientWidth = 625
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object lbl: TLabel
    Left = 24
    Top = 14
    Width = 48
    Height = 12
    Caption = #20809#22280#20195#30721
    ParentShowHint = False
    ShowHint = False
  end
  object lbl1: TLabel
    Left = 274
    Top = 13
    Width = 48
    Height = 14
    Caption = #29305#25928#25991#20214
  end
  object lbl2: TLabel
    Left = 36
    Top = 42
    Width = 36
    Height = 12
    Caption = #36215#22987#24103
  end
  object lbl3: TLabel
    Left = 274
    Top = 42
    Width = 48
    Height = 12
    Caption = #25773#25918#24103#25968
  end
  object lbl4: TLabel
    Left = 24
    Top = 70
    Width = 48
    Height = 12
    Caption = #25773#25918#36895#24230
  end
  object lbl5: TLabel
    Left = 226
    Top = 70
    Width = 24
    Height = 12
    Caption = #27627#31186
  end
  object BtnAdd: TButton
    Left = 521
    Top = 10
    Width = 77
    Height = 23
    Caption = #22686#21152
    TabOrder = 6
    OnClick = BtnAddClick
  end
  object btnDel: TButton
    Left = 521
    Top = 34
    Width = 77
    Height = 23
    Caption = #21024#38500
    TabOrder = 7
    OnClick = btnDelClick
  end
  object btnSave: TButton
    Left = 521
    Top = 58
    Width = 77
    Height = 23
    Caption = #20445#23384
    TabOrder = 8
    OnClick = btnSaveClick
  end
  object EdtEffectsTypeID: TSpinEdit
    Left = 78
    Top = 10
    Width = 144
    Height = 21
    Hint = 
      #20809#22280#20195#30721#21462#20540#33539#22260#20026'100..199,'#23545#24212'StartPoint.txt'#20013#30340#20809#22280#20195#30721#13#10#13#10#22320#22270#32534#21495'  '#22352#26631'X  '#22352#26631'Y  '#31105#27490#35828#35805 +
      '  '#33539#22260'  '#20809#22280#20195#30721'  '#39044#30041'1  '#39044#30041'2'#13#10'3              270     270  0             ' +
      ' 10    100          0        0|'#25903#25345#30340#33258#23450#20041#29305#25928#31867#22411#20026'100..199'
    MaxValue = 199
    MinValue = 100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Value = 100
  end
  object comboEffectFileIndex: TComboBox
    Left = 328
    Top = 9
    Width = 144
    Height = 22
    Hint = #21462#20540#26469#28304#33258#23450#20041#36164#28304#25991#20214#21015#34920
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object EdtEffectsStartOffSet: TSpinEdit
    Left = 78
    Top = 38
    Width = 144
    Height = 21
    Hint = #36215#22987#36126#32034#24341#20540#20026'0..65535'
    MaxValue = 65535
    MinValue = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Value = 0
  end
  object EdtEffectsCountOffSet: TSpinEdit
    Left = 328
    Top = 38
    Width = 144
    Height = 21
    Hint = #25773#25918#36126#25968#33539#22260#20026'1..65535'
    MaxValue = 65535
    MinValue = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Value = 1
  end
  object chkEffectsBlendDraw: TCheckBox
    Left = 328
    Top = 68
    Width = 101
    Height = 17
    Caption = #26159#21542#36879#26126#32472#21046
    TabOrder = 5
  end
  object EdtEffectsSpeed: TSpinEdit
    Left = 78
    Top = 66
    Width = 144
    Height = 21
    Hint = #25773#25918#36895#24230'('#27627#31186')'#33539#22260#20026'1..999999999'
    MaxValue = 999999999
    MinValue = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Value = 20
  end
  object lvSafeZoneEffectsCustom: TListView
    Left = 25
    Top = 98
    Width = 568
    Height = 287
    Columns = <
      item
        Caption = #29305#25928#31867#22411
        Width = 60
      end
      item
        Caption = #25991#20214#32034#24341
        Width = 60
      end
      item
        Caption = #25991#20214#21517#31216
        Width = 100
      end
      item
        Caption = #36215#22987#36126#32034#24341
        Width = 80
      end
      item
        Caption = #25773#25918#36126#25968
        Width = 60
      end
      item
        Caption = #36879#26126#32472#21046
        Width = 60
      end
      item
        Caption = #25773#25918#36895#24230
        Width = 60
      end>
    GridLines = True
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 9
    ViewStyle = vsReport
    OnClick = lvSafeZoneEffectsCustomClick
  end
end
