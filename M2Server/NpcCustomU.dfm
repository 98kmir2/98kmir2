object ftmNpcCustom: TftmNpcCustom
  Left = 551
  Top = 233
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #33258#23450#20041'NPC'
  ClientHeight = 473
  ClientWidth = 884
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
    Left = 25
    Top = 11
    Width = 80
    Height = 12
    AutoSize = False
    Caption = 'NPC'#20195#30721
  end
  object lbl1: TLabel
    Left = 24
    Top = 36
    Width = 80
    Height = 12
    AutoSize = False
    Caption = 'NPC'#36164#28304#25991#20214
  end
  object lbl4: TLabel
    Left = 17
    Top = 82
    Width = 91
    Height = 12
    AutoSize = False
    Caption = #25773#25918#36895#24230'('#27627#31186')'
  end
  object lbl5: TLabel
    Left = 25
    Top = 60
    Width = 54
    Height = 12
    AutoSize = False
    Caption = 'NPC'#26041#21521
  end
  object BtnAdd: TButton
    Left = 778
    Top = 8
    Width = 36
    Height = 25
    Caption = #26032#22686
    TabOrder = 0
    OnClick = BtnAddClick
  end
  object btnDel: TButton
    Left = 789
    Top = 34
    Width = 77
    Height = 23
    Caption = #21333#26465#21024#38500
    TabOrder = 1
    OnClick = btnDelClick
  end
  object btnSave: TButton
    Left = 789
    Top = 82
    Width = 77
    Height = 23
    Caption = #20445#23384
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object EdtNpcCode: TSpinEdit
    Left = 105
    Top = 7
    Width = 144
    Height = 21
    Hint = #25903#25345#30340#33258#23450#20041'NPC'#20195#30721#20026'500..999|'#25903#25345#30340#33258#23450#20041#29305#25928#31867#22411#20026'100..199'
    MaxValue = 999
    MinValue = 500
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Value = 500
  end
  object comboResourceFileIndex: TComboBox
    Left = 104
    Top = 31
    Width = 145
    Height = 22
    Hint = #21462#20540#26469#28304#33258#23450#20041#36164#28304#25991#20214#21015#34920
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object EdtPlaySpeed: TSpinEdit
    Left = 105
    Top = 78
    Width = 144
    Height = 21
    Hint = #25773#25918#36895#24230'('#27627#31186')'#33539#22260#20026'1..999999999'
    MaxValue = 999999999
    MinValue = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Value = 20
  end
  object ComboNPCDir: TComboBox
    Left = 104
    Top = 55
    Width = 145
    Height = 22
    Hint = 'NPC'#26041#21521#20026'8'#21521'0..7,0'#20026#38754#26397#19978#26041',2'#20026#38754#26397#21491#26041#65292'4'#20026#38754#26397#19979#26041',6'#20026#38754#26397#24038#26041
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = '0'
    Items.Strings = (
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7')
  end
  object grp1: TGroupBox
    Left = 8
    Top = 105
    Width = 214
    Height = 346
    Caption = 'NPC'#20195#30721#31579#36873#27719#24635
    TabOrder = 7
    object lstNpcCode: TListBox
      Left = 4
      Top = 13
      Width = 205
      Height = 329
      ItemHeight = 12
      TabOrder = 0
      OnClick = lstNpcCodeClick
    end
  end
  object grp2: TGroupBox
    Left = 224
    Top = 288
    Width = 638
    Height = 169
    Caption = #25152#26377#33258#23450#20041'NPC'#35760#24405'('#20379#26597#30475')'
    TabOrder = 8
    Visible = False
    object lvNpcCustom: TListView
      Left = 1
      Top = 14
      Width = 633
      Height = 151
      Columns = <
        item
          Caption = 'NPC'#20195#30721
          Width = 60
        end
        item
          Caption = #36164#28304#25991#20214#32034#24341
          Width = 85
        end
        item
          Caption = #36164#28304#25991#20214#21517#31216
          Width = 85
        end
        item
          Caption = 'NPC'#26041#21521
          Width = 60
        end
        item
          Caption = #25773#25918#36895#24230
          Width = 60
        end
        item
          Caption = #31449#31435#26412#20307#36215#22987#24103
          Width = 100
        end
        item
          Caption = #21551#29992#31449#31435#29305#25928
          Width = 85
        end
        item
          Caption = #31449#31435#29305#25928#36215#22987#24103
          Width = 100
        end
        item
          Caption = #31449#31435#25773#25918#24103#25968
          Width = 85
        end
        item
          Caption = #21160#20316#26412#20307#36215#22987#24103
          Width = 100
        end
        item
          Caption = #21551#29992#21160#20316#29305#25928
          Width = 85
        end
        item
          Caption = #21160#20316#29305#25928#36215#22987#24103
          Width = 100
        end
        item
          Caption = #21160#20316#25773#25918#24103#25968
          Width = 85
        end>
      GridLines = True
      ReadOnly = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object grp3: TGroupBox
    Left = 225
    Top = 286
    Width = 638
    Height = 169
    Caption = #24403#21069#31579#36873#33258#23450#20041'NPC'#35760#24405'('#25353'SHIFT'#38190#25110'CTRL'#38190#21487#20197#36873#25321#22810#26465#35760#24405')'
    TabOrder = 9
    object lvFilterNpcCustom: TListView
      Left = 5
      Top = 14
      Width = 629
      Height = 151
      Columns = <
        item
          Caption = 'NPC'#20195#30721
          Width = 60
        end
        item
          Caption = #36164#28304#25991#20214#32034#24341
          Width = 85
        end
        item
          Caption = #36164#28304#25991#20214#21517#31216
          Width = 85
        end
        item
          Caption = 'NPC'#26041#21521
          Width = 60
        end
        item
          Caption = #25773#25918#36895#24230
          Width = 60
        end
        item
          Caption = #31449#31435#36215#22987#24103
          Width = 75
        end
        item
          Caption = #21551#29992#31449#31435#29305#25928
          Width = 85
        end
        item
          Caption = #31449#31435#29305#25928#36215#22987#24103
          Width = 100
        end
        item
          Caption = #31449#31435#25773#25918#24103#25968
          Width = 85
        end
        item
          Caption = #21160#20316#36215#22987#24103
          Width = 75
        end
        item
          Caption = #21551#29992#21160#20316#29305#25928
          Width = 85
        end
        item
          Caption = #21160#20316#29305#25928#36215#22987#24103
          Width = 100
        end
        item
          Caption = #21160#20316#25773#25918#24103#25968
          Width = 85
        end>
      GridLines = True
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lvFilterNpcCustomClick
    end
  end
  object grp4: TGroupBox
    Left = 256
    Top = 0
    Width = 249
    Height = 105
    Caption = #31449#31435#21160#30011
    TabOrder = 10
    object lbl2: TLabel
      Left = 9
      Top = 18
      Width = 89
      Height = 12
      AutoSize = False
      Caption = #31449#31435#36215#22987#24103
    end
    object lbl3: TLabel
      Left = 9
      Top = 42
      Width = 80
      Height = 12
      AutoSize = False
      Caption = #25773#25918#24103#24635#25968
    end
    object lbl6: TLabel
      Left = 9
      Top = 64
      Width = 89
      Height = 12
      AutoSize = False
      Caption = #29305#25928#36215#22987#24103
    end
    object EdtStandStartOffset: TSpinEdit
      Left = 97
      Top = 14
      Width = 144
      Height = 21
      Hint = #31449#31435#26412#20307#36215#22987#24103#20026'0..65535'
      MaxValue = 65535
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Value = 0
    end
    object EdtStandPlayCount: TSpinEdit
      Left = 97
      Top = 38
      Width = 144
      Height = 21
      Hint = #31449#31435#25773#25918#24103#25968#33539#22260#20026'1..65535'
      MaxValue = 65535
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Value = 1
    end
    object chkStandUseEffect: TCheckBox
      Left = 96
      Top = 83
      Width = 113
      Height = 17
      Caption = #21551#29992#31449#31435#29305#25928
      TabOrder = 2
    end
    object EdtStandEffectStartOffset: TSpinEdit
      Left = 97
      Top = 59
      Width = 144
      Height = 21
      Hint = #31449#31435#29305#25928#36215#22987#24103#20026'0..65535'
      MaxValue = 65535
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Value = 0
    end
  end
  object grp5: TGroupBox
    Left = 512
    Top = 0
    Width = 265
    Height = 106
    Caption = #21160#20316#21160#30011
    TabOrder = 11
    object lbl7: TLabel
      Left = 16
      Top = 18
      Width = 89
      Height = 12
      AutoSize = False
      Caption = #21160#20316#36215#22987#24103
    end
    object lbl8: TLabel
      Left = 16
      Top = 64
      Width = 89
      Height = 12
      AutoSize = False
      Caption = #29305#25928#36215#22987#24103
    end
    object lbl9: TLabel
      Left = 17
      Top = 41
      Width = 80
      Height = 12
      AutoSize = False
      Caption = #25773#25918#24103#24635#25968
    end
    object ChkHitUseEffect: TCheckBox
      Left = 105
      Top = 83
      Width = 129
      Height = 17
      Caption = #21551#29992#21160#20316#29305#25928
      TabOrder = 0
    end
    object EdtHitStartOffset: TSpinEdit
      Left = 105
      Top = 14
      Width = 144
      Height = 21
      Hint = #21160#20316#26412#20307#36215#22987#24103#20026'0..65535'
      MaxValue = 65535
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Value = 0
    end
    object EdtHitEffectStartOffset: TSpinEdit
      Left = 104
      Top = 60
      Width = 144
      Height = 21
      Hint = #21160#20316#29305#25928#36215#22987#24103#20026'0..65535'
      MaxValue = 65535
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Value = 0
    end
    object EdtHitPlayCount: TSpinEdit
      Left = 105
      Top = 37
      Width = 144
      Height = 21
      Hint = #21160#20316#25773#25918#24103#25968#33539#22260#20026'1..65535'
      MaxValue = 65535
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Value = 1
    end
  end
  object btnUpdate: TButton
    Left = 789
    Top = 58
    Width = 77
    Height = 23
    Caption = #21333#26465#20462#25913
    TabOrder = 12
    OnClick = btnUpdateClick
  end
  object grp6: TGroupBox
    Left = 225
    Top = 105
    Width = 376
    Height = 176
    Caption = #25209#37327#21151#33021
    TabOrder = 13
    object lbl10: TLabel
      Left = 134
      Top = 18
      Width = 80
      Height = 12
      AutoSize = False
      Caption = 'NPC'#36164#28304#25991#20214
    end
    object lbl11: TLabel
      Left = 133
      Top = 40
      Width = 91
      Height = 12
      AutoSize = False
      Caption = #25773#25918#36895#24230'('#27627#31186')'
    end
    object lbl12: TLabel
      Left = 134
      Top = 64
      Width = 80
      Height = 12
      AutoSize = False
      Caption = #21551#29992#31449#31435#29305#25928
    end
    object lbl13: TLabel
      Left = 134
      Top = 88
      Width = 80
      Height = 12
      AutoSize = False
      Caption = #21551#29992#21160#20316#29305#25928
    end
    object lbl14: TLabel
      Left = 133
      Top = 111
      Width = 91
      Height = 12
      AutoSize = False
      Caption = #31449#31435#25773#25918#24103#24635#25968
    end
    object lbl15: TLabel
      Left = 132
      Top = 134
      Width = 91
      Height = 12
      AutoSize = False
      Caption = #21160#20316#25773#25918#24103#24635#25968
    end
    object btnBatchUpdate: TButton
      Left = 150
      Top = 150
      Width = 73
      Height = 23
      Caption = #25209#37327#20462#25913
      TabOrder = 0
      OnClick = btnBatchUpdateClick
    end
    object chkBatchUpdateResource: TCheckBox
      Left = 9
      Top = 17
      Width = 122
      Height = 17
      Caption = #25209#37327#20462#25913#36164#28304#25991#20214
      TabOrder = 1
      OnClick = chkBatchUpdateResourceClick
    end
    object comboResourceFileIndexBatch: TComboBox
      Left = 220
      Top = 11
      Width = 145
      Height = 22
      Hint = #21462#20540#26469#28304#33258#23450#20041#36164#28304#25991#20214#21015#34920
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object chkBatchUpdatePlaySpeed: TCheckBox
      Left = 9
      Top = 39
      Width = 119
      Height = 17
      Caption = #25209#37327#20462#25913#25773#25918#36895#24230
      TabOrder = 3
      OnClick = chkBatchUpdatePlaySpeedClick
    end
    object comboPlaySpeedBatch: TSpinEdit
      Left = 221
      Top = 35
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
    object chkBatchUpdateStandEffect: TCheckBox
      Left = 9
      Top = 63
      Width = 122
      Height = 17
      Caption = #25209#37327#20462#25913#31449#31435#29305#25928
      TabOrder = 5
      OnClick = chkBatchUpdateStandEffectClick
    end
    object comboStandEffect: TComboBox
      Left = 220
      Top = 58
      Width = 145
      Height = 22
      Hint = '0.'#20851#38381#13#10'1.'#21551#29992
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Text = '0'
      Items.Strings = (
        '0'
        '1')
    end
    object chkBatchUpdateHitEffect: TCheckBox
      Left = 9
      Top = 87
      Width = 122
      Height = 17
      Caption = #25209#37327#20462#25913#21160#20316#29305#25928
      TabOrder = 7
      OnClick = chkBatchUpdateHitEffectClick
    end
    object comboHitEffect: TComboBox
      Left = 220
      Top = 82
      Width = 145
      Height = 22
      Hint = '0.'#20851#38381#13#10'1.'#21551#29992
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Text = '0'
      Items.Strings = (
        '0'
        '1')
    end
    object chkBatchUpdateStandCount: TCheckBox
      Left = 9
      Top = 110
      Width = 119
      Height = 17
      Caption = #25209#37327#20462#25913#31449#31435#24103#25968
      TabOrder = 9
      OnClick = chkBatchUpdateStandCountClick
    end
    object EdtStandPlayCountBatch: TSpinEdit
      Left = 220
      Top = 106
      Width = 145
      Height = 21
      Hint = #25773#25918#24103#25968#33539#22260#20026'1..65535'
      MaxValue = 65535
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      Value = 1
    end
    object chkBatchUpdateHitCount: TCheckBox
      Left = 8
      Top = 133
      Width = 119
      Height = 17
      Caption = #25209#37327#20462#25913#21160#20316#24103#25968
      TabOrder = 11
      OnClick = chkBatchUpdateHitCountClick
    end
    object EdtHitPlayCountBatch: TSpinEdit
      Left = 220
      Top = 129
      Width = 145
      Height = 21
      Hint = #25773#25918#24103#25968#33539#22260#20026'1..65535'
      MaxValue = 65535
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      Value = 1
    end
  end
  object grp7: TGroupBox
    Left = 608
    Top = 106
    Width = 254
    Height = 175
    Caption = #26234#33021#21151#33021
    TabOrder = 14
    object lbl16: TLabel
      Left = 9
      Top = 43
      Width = 89
      Height = 12
      AutoSize = False
      Caption = #31449#31435#31354#30333#24103#25968
    end
    object lbl17: TLabel
      Left = 9
      Top = 67
      Width = 89
      Height = 12
      AutoSize = False
      Caption = #31449#31435#29305#25928#31354#30333#24103
    end
    object lbl18: TLabel
      Left = 9
      Top = 91
      Width = 89
      Height = 12
      AutoSize = False
      Caption = #21160#20316#31354#30333#24103#25968
    end
    object lbl19: TLabel
      Left = 9
      Top = 115
      Width = 89
      Height = 12
      AutoSize = False
      Caption = #21160#20316#29305#25928#31354#30333#24103
    end
    object lbl20: TLabel
      Left = 9
      Top = 18
      Width = 81
      Height = 12
      AutoSize = False
      Caption = #21442#32771#22522#20934#26041#21521
    end
    object btnAutoFill: TButton
      Left = 36
      Top = 136
      Width = 182
      Height = 34
      Caption = #25353#22522#20934#26041#21521#20026#21442#32771','#25209#37327#35745#31639#26356#26032#20854#23427#26041#21521'('#31449#31435'/'#21160#20316')'#24103#25968#25454
      TabOrder = 0
      WordWrap = True
      OnClick = btnAutoFillClick
    end
    object EdtStandBlankCount: TSpinEdit
      Left = 97
      Top = 39
      Width = 144
      Height = 21
      Hint = #24103#25968#33539#22260#20026'0..65535'
      MaxValue = 65535
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Value = 0
    end
    object EdtStandEffectBlankCount: TSpinEdit
      Left = 97
      Top = 63
      Width = 144
      Height = 21
      Hint = #24103#25968#33539#22260#20026'0..65535'
      MaxValue = 65535
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Value = 0
    end
    object EdtHitBlankCount: TSpinEdit
      Left = 97
      Top = 87
      Width = 144
      Height = 21
      Hint = #24103#25968#33539#22260#20026'0..65535'
      MaxValue = 65535
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Value = 0
    end
    object EdtHitEffectBlankCount: TSpinEdit
      Left = 97
      Top = 111
      Width = 144
      Height = 21
      Hint = #24103#25968#33539#22260#20026'0..65535'
      MaxValue = 65535
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Value = 0
    end
    object comboBaseDir: TComboBox
      Left = 96
      Top = 13
      Width = 145
      Height = 22
      Hint = 'NPC'#26041#21521#20026'8'#21521'0..7,0'#20026#38754#26397#19978#26041',2'#20026#38754#26397#21491#26041#65292'4'#20026#38754#26397#19979#26041',6'#20026#38754#26397#24038#26041
      Style = csOwnerDrawFixed
      ItemHeight = 16
      ItemIndex = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '0'
      Items.Strings = (
        '0')
    end
  end
  object btnBatchAdd: TButton
    Left = 816
    Top = 8
    Width = 65
    Height = 25
    Caption = #20840#26041#21521#26032#22686
    TabOrder = 15
    OnClick = btnBatchAddClick
  end
end
