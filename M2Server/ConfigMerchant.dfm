object frmConfigMerchant: TfrmConfigMerchant
  Left = 477
  Top = 119
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #20132#26131'NPC'#37197#32622
  ClientHeight = 491
  ClientWidth = 825
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBoxNPC: TGroupBox
    Left = 8
    Top = 8
    Width = 377
    Height = 445
    Caption = #30456#20851#35774#32622
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 348
      Width = 54
      Height = 12
      Caption = #33050#26412#21517#31216':'
    end
    object Label3: TLabel
      Left = 192
      Top = 348
      Width = 54
      Height = 12
      Caption = #22320#22270#21517#31216':'
    end
    object Label4: TLabel
      Left = 8
      Top = 372
      Width = 36
      Height = 12
      Caption = #24231#26631'X:'
    end
    object Label5: TLabel
      Left = 120
      Top = 372
      Width = 12
      Height = 12
      Caption = 'Y:'
    end
    object Label6: TLabel
      Left = 8
      Top = 396
      Width = 54
      Height = 12
      Caption = #26174#31034#21517#31216':'
    end
    object Label7: TLabel
      Left = 192
      Top = 396
      Width = 30
      Height = 12
      Caption = #26041#21521':'
    end
    object Label8: TLabel
      Left = 288
      Top = 396
      Width = 30
      Height = 12
      Caption = #22806#24418':'
    end
    object Label10: TLabel
      Left = 192
      Top = 372
      Width = 54
      Height = 12
      Caption = #22320#22270#25551#36848':'
    end
    object Label11: TLabel
      Left = 264
      Top = 420
      Width = 54
      Height = 12
      Caption = #31227#21160#38388#38548':'
    end
    object EditScriptName: TEdit
      Left = 64
      Top = 344
      Width = 121
      Height = 20
      Hint = #33050#26412#25991#20214#21517#31216#12290#25991#20214#21517#31216#20197#27492#21517#23383#21152#22320#22270#21517#32452#21512#20026#23454#38469#25991#20214#21517#12290
      TabOrder = 0
      OnChange = EditScriptNameChange
    end
    object EditMapName: TEdit
      Left = 248
      Top = 344
      Width = 121
      Height = 20
      Hint = #22320#22270#21517#31216#12290
      TabOrder = 1
      OnChange = EditMapNameChange
    end
    object EditShowName: TEdit
      Left = 64
      Top = 392
      Width = 121
      Height = 20
      TabOrder = 2
      OnChange = EditShowNameChange
    end
    object CheckBoxOfCastle: TCheckBox
      Left = 64
      Top = 418
      Width = 81
      Height = 17
      Hint = #25351#23450#27492'NPC'#23646#20110#22478#22561#31649#29702#65292#24403#25915#22478#26102'NPC'#23558#20572#27490#33829#19994#12290
      Caption = #23646#20110#22478#22561
      TabOrder = 3
      OnClick = CheckBoxOfCastleClick
    end
    object ComboBoxDir: TComboBox
      Left = 224
      Top = 392
      Width = 49
      Height = 20
      Hint = #40664#35748#31449#31435#26041#21521#12290
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 4
      OnChange = ComboBoxDirChange
    end
    object EditImageIdx: TSpinEdit
      Left = 320
      Top = 391
      Width = 49
      Height = 21
      Hint = #22806#35266#22270#24418#12290
      EditorEnabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 5
      Value = 0
      OnChange = EditImageIdxChange
    end
    object EditX: TSpinEdit
      Left = 64
      Top = 367
      Width = 49
      Height = 21
      Hint = #24403#21069#24231#26631'X'#12290
      EditorEnabled = False
      MaxValue = 1000
      MinValue = 1
      TabOrder = 6
      Value = 1
      OnChange = EditXChange
    end
    object EditY: TSpinEdit
      Left = 136
      Top = 367
      Width = 49
      Height = 21
      Hint = #24403#21069#24231#26631'Y'#12290
      EditorEnabled = False
      MaxValue = 1000
      MinValue = 1
      TabOrder = 7
      Value = 1
      OnChange = EditYChange
    end
    object EditMapDesc: TEdit
      Left = 248
      Top = 368
      Width = 121
      Height = 20
      Enabled = False
      ReadOnly = True
      TabOrder = 8
    end
    object CheckBoxAutoMove: TCheckBox
      Left = 192
      Top = 418
      Width = 65
      Height = 17
      Hint = 'NPC'#20250#22312#22320#22270#36827#34892#38543#35201#31227#21160
      Caption = #33258#21160#31227#21160
      TabOrder = 9
      OnClick = CheckBoxAutoMoveClick
    end
    object EditMoveTime: TSpinEdit
      Left = 320
      Top = 415
      Width = 49
      Height = 21
      Hint = #38543#26426#31227#21160#38388#38548#26102#38388#31186
      EditorEnabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 10
      Value = 0
      OnChange = EditMoveTimeChange
    end
    object ListBoxMerChant: TListBox
      Left = 8
      Top = 16
      Width = 361
      Height = 321
      ItemHeight = 12
      TabOrder = 11
      OnClick = ListBoxMerChantClick
    end
  end
  object GroupBoxScript: TGroupBox
    Left = 392
    Top = 8
    Width = 425
    Height = 445
    Caption = #33050#26412#32534#36753
    Enabled = False
    TabOrder = 1
    object Label9: TLabel
      Left = 260
      Top = 416
      Width = 54
      Height = 12
      Caption = #20132#26131#25240#25187':'
    end
    object MemoScript: TMemo
      Left = 8
      Top = 16
      Width = 409
      Height = 353
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = MemoScriptChange
    end
    object EditPriceRate: TSpinEdit
      Left = 324
      Top = 412
      Width = 49
      Height = 21
      Hint = 'NPC'#20132#26131#26102#25240#25187#65292'80'#20026'80%'
      EditorEnabled = False
      MaxValue = 500
      MinValue = 60
      TabOrder = 1
      Value = 60
      OnChange = EditPriceRateChange
    end
    object CheckBoxUpgradenow: TCheckBox
      Left = 156
      Top = 376
      Width = 73
      Height = 17
      Caption = #21319#32423#27494#22120
      TabOrder = 2
      OnClick = CheckBoxUpgradenowClick
    end
    object CheckBoxStorage: TCheckBox
      Left = 76
      Top = 392
      Width = 65
      Height = 17
      Caption = #21462#20179#24211
      TabOrder = 3
      OnClick = CheckBoxStorageClick
    end
    object CheckBoxSendMsg: TCheckBox
      Left = 324
      Top = 392
      Width = 73
      Height = 17
      Caption = #31069#31119#35821
      TabOrder = 4
      OnClick = CheckBoxSendMsgClick
    end
    object CheckBoxSell: TCheckBox
      Left = 12
      Top = 392
      Width = 33
      Height = 17
      Caption = #21334
      TabOrder = 5
      OnClick = CheckBoxSellClick
    end
    object CheckBoxS_repair: TCheckBox
      Left = 244
      Top = 392
      Width = 73
      Height = 17
      Caption = #29305#27530#20462#29702
      TabOrder = 6
      OnClick = CheckBoxS_repairClick
    end
    object CheckBoxRepair: TCheckBox
      Left = 244
      Top = 376
      Width = 73
      Height = 17
      Caption = #20462#29702#29289#21697
      TabOrder = 7
      OnClick = CheckBoxRepairClick
    end
    object CheckBoxMakedrug: TCheckBox
      Left = 324
      Top = 376
      Width = 73
      Height = 17
      Caption = #21512#25104#29289#21697
      TabOrder = 8
      OnClick = CheckBoxMakedrugClick
    end
    object CheckBoxGetbackupgnow: TCheckBox
      Left = 156
      Top = 392
      Width = 73
      Height = 17
      Caption = #21462#22238#21319#32423
      TabOrder = 9
      OnClick = CheckBoxGetbackupgnowClick
    end
    object CheckBoxGetback: TCheckBox
      Left = 76
      Top = 376
      Width = 65
      Height = 17
      Caption = #23384#20179#24211
      TabOrder = 10
      OnClick = CheckBoxGetbackClick
    end
    object CheckBoxBuy: TCheckBox
      Left = 12
      Top = 376
      Width = 33
      Height = 17
      Caption = #20080
      TabOrder = 11
      OnClick = CheckBoxBuyClick
    end
  end
  object ButtonSave: TButton
    Left = 320
    Top = 460
    Width = 57
    Height = 23
    Hint = #20445#23384#20132#26131'NPC'#35774#32622
    Caption = #20445#23384
    TabOrder = 2
    OnClick = ButtonSaveClick
  end
  object CheckBoxDenyRefStatus: TCheckBox
    Left = 14
    Top = 464
    Width = 67
    Height = 17
    Hint = #20351#29992#27492#26041#27861#65292#21487#20197#21047#26032'NPC'#22312#28216#25103#20013#30340#25968#25454#12290#25171#24320#27492#36873#39033#20960#31186#21518#20877#20851#38381#65292'NPC'#26356#25913#30340#21442#25968#23601#20250#22312#28216#25103#20013#21047#26032#12290
    Caption = #31105#27490#21047#26032#29366#24577
    TabOrder = 3
    Visible = False
    OnClick = CheckBoxDenyRefStatusClick
  end
  object ButtonClearTempData: TButton
    Left = 232
    Top = 460
    Width = 81
    Height = 23
    Hint = #28165#38500#25152#26377'NPC'#30340#20020#26102#25991#20214#65292#21253#25324#20020#26102#20215#26684#34920#21450#20132#26131#29289#21697#24211#23384#65292#22312'NPC'#20080#21334#29289#21697#26377#38382#39064#26102#21487#20351#29992#27492#21151#33021#28165#29702#12290
    Caption = #28165#38500#25968#25454
    TabOrder = 4
    OnClick = ButtonClearTempDataClick
  end
  object ButtonScriptSave: TButton
    Left = 664
    Top = 461
    Width = 57
    Height = 23
    Hint = #20445#23384#33050#26412#25991#20214#12290
    Caption = #20445#23384
    TabOrder = 5
    OnClick = ButtonScriptSaveClick
  end
  object ButtonReLoadNpc: TButton
    Left = 728
    Top = 461
    Width = 81
    Height = 23
    Hint = #37325#26032#21152#36733'NPC'#33050#26412#12290
    Caption = #37325#26032#21152#36733
    Enabled = False
    TabOrder = 6
    OnClick = ButtonReLoadNpcClick
  end
  object Button1: TButton
    Left = 88
    Top = 460
    Width = 41
    Height = 23
    Caption = 'Turn'
    TabOrder = 7
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 460
    Width = 33
    Height = 23
    Caption = 'Hit'
    TabOrder = 8
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 176
    Top = 460
    Width = 49
    Height = 23
    Caption = 'DigUp'
    TabOrder = 9
    OnClick = Button3Click
  end
end
