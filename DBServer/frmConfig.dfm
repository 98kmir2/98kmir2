object frmSetup: TfrmSetup
  Left = 744
  Top = 261
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21442#25968#35774#32622
  ClientHeight = 282
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Icon.Data = {
    0000010001002020040001000400E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000001111100000000000000000000000000011111000000000000000
    00000000000011111000000000000000000000000353B8700000000000000000
    000000000353B8700000000000000700000000000353B8700000000000007B30
    000077000353B87070000000000007B3000330460353B876007000000000007B
    3000B6660353B8766607000000000007B306BB860353B8766660700000000000
    7B76BBB80353B876666607000000000077BBBBBB0353B8766666600000000000
    07BBBBBB0353B8766666660000000000066BBB8B0353B8766666660000000000
    6666BB860353B876666666070000007066666B660353B8766666666000000070
    666666660353B8766B86666000000006666666660353B8766BB6666000000006
    666666660353B87B6BB8666000000070666666660353B87BBBBB866000000070
    666666660353B87BBBBBB86000000000666666660353B878BBB8BB0700000000
    666666010353B8778BB68B3700000007066660011333B711188666B300000000
    06666660011373310686603B30000000706666666001110666660073B7000000
    0706666666600666666000073B70000000706666666666666600000003B70000
    0007006666666666600000000000000000000700466666000700000000070000
    000000070000007700000000000000000000000000000000000000000000FFC0
    07FFFFC007FFFFC007FFFFF01FFFFFF01FFF3FF01FFF1E0007FF8E0001FFC600
    00FFE000007FF000003FF000003FF000001FE000001FE000000FC000000FC000
    000FC000000FC000000FC000000FC000000FE000000FE000000FE000000FF000
    0007F0000003F8000061FC0000F8FE0001FCFF8003FEFFE00FFFFFFFFFFF}
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 425
    Height = 235
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #22522#26412#21442#25968
      object Label1: TLabel
        Left = 334
        Top = 65
        Width = 36
        Height = 12
        Caption = #32423#35282#33394
      end
      object CheckBoxAllowGetBackDelChr: TCheckBox
        Left = 17
        Top = 16
        Width = 168
        Height = 17
        Caption = #20801#35768#25214#22238#20154#29289#35282#33394
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = CheckBoxAllowGetBackDelChrClick
      end
      object CheckBoxgUseSpecChar: TCheckBox
        Left = 17
        Top = 39
        Width = 168
        Height = 16
        Caption = #20801#35768#20154#29289#35282#33394#20351#29992#29305#27530#23383#31526
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = CheckBoxgUseSpecCharClick
      end
      object CheckBoxAllowClientDelChr: TCheckBox
        Left = 17
        Top = 61
        Width = 176
        Height = 17
        Caption = #20801#35768#23458#25143#31471#21024#38500#35282#33394#31561#32423#21306#38388
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = CheckBoxAllowClientDelChrClick
      end
      object SpinEditAllowDelChrLvl: TSpinEdit
        Left = 199
        Top = 60
        Width = 57
        Height = 21
        MaxValue = 65535
        MinValue = 0
        TabOrder = 3
        Value = 1
        OnChange = SpinEditAllowDelChrLvlChange
      end
      object CheckBoxAllowCreateCharOpt1: TCheckBox
        Left = 17
        Top = 83
        Width = 224
        Height = 17
        Caption = #20801#35768#20351#29992'E'#25991#23383#27597#21644#25968#23383#27880#20876#35282#33394
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = CheckBoxAllowCreateCharOpt1Click
      end
      object CheckBoxOpenHRSystem: TCheckBox
        Left = 17
        Top = 106
        Width = 376
        Height = 17
        Caption = #20801#35768#20351#29992#25490#21517#31995#32479','#19978#27036#31561#32423'           '#37325#36733#25968#25454'          '#20998#38047
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = CheckBoxOpenHRSystemClick
      end
      object CheckBoxMultiChr: TCheckBox
        Left = 17
        Top = 129
        Width = 156
        Height = 17
        Caption = #20801#35768#21457#36865#23458#25143#31471#19977#35282#33394
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = CheckBoxAllowClientDelChrClick
      end
      object seRenewLRTime: TSpinEdit
        Left = 299
        Top = 105
        Width = 56
        Height = 21
        EditorEnabled = False
        MaxValue = 65535
        MinValue = 1
        TabOrder = 7
        Value = 1
        OnChange = seRenewLRTimeChange
      end
      object speRankLevel: TSpinEdit
        Left = 186
        Top = 105
        Width = 57
        Height = 21
        EditorEnabled = False
        MaxValue = 65535
        MinValue = 1
        TabOrder = 8
        Value = 1
        OnChange = seRenewLRTimeChange
      end
      object seLvMax: TSpinEdit
        Left = 268
        Top = 60
        Width = 57
        Height = 21
        MaxValue = 65535
        MinValue = 1
        TabOrder = 9
        Value = 1
        OnChange = seLvMaxChange
      end
    end
    object TabSheet2: TTabSheet
      Caption = #21015#34920#20449#24687
      ImageIndex = 1
      object Label7: TLabel
        Left = 16
        Top = 16
        Width = 102
        Height = 12
        Caption = #35282#33394#23383#31526#36807#28388#21015#34920':'
      end
      object ListBoxFilterText: TListBox
        Left = 16
        Top = 32
        Width = 149
        Height = 137
        Hint = #35282#33394#23383#31526#36807#28388#21015#34920','#27880#20876#35282#33394#19981#33021#21253#21547#20197#19979#23383#31526
        ItemHeight = 12
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 0
        OnClick = ListBoxFilterTextClick
        OnDblClick = ListBoxFilterTextDblClick
      end
      object ButtonAdd: TButton
        Left = 16
        Top = 175
        Width = 49
        Height = 21
        Caption = #22686#21152'(&A)'
        TabOrder = 1
        OnClick = ButtonAddClick
      end
      object ButtonMod: TButton
        Left = 65
        Top = 175
        Width = 49
        Height = 21
        Caption = #20462#25913'(&M)'
        TabOrder = 2
        OnClick = ButtonModClick
      end
      object ButtonDel: TButton
        Left = 116
        Top = 175
        Width = 49
        Height = 21
        Caption = #21024#38500'(&D)'
        TabOrder = 3
        OnClick = ButtonDelClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = #33521#38596#35774#32622
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 7
        Top = 11
        Width = 294
        Height = 70
        Caption = #22810#33521#38596#36873#39033
        TabOrder = 0
        object cbGetChrAsHero: TCheckBox
          Left = 9
          Top = 16
          Width = 200
          Height = 17
          Caption = #20801#35768'['#26410#21024#38500#20154#29289']'#34987#21484#21796#20026#33521#38596
          Enabled = False
          TabOrder = 0
          OnClick = CheckBoxAllowGetBackDelChrClick
        end
        object cbGetDelChrAsHero: TCheckBox
          Left = 9
          Top = 32
          Width = 200
          Height = 17
          Caption = #20801#35768'['#24050#21024#38500#20154#29289']'#34987#21484#21796#20026#33521#38596
          Enabled = False
          TabOrder = 1
          OnClick = CheckBoxAllowGetBackDelChrClick
        end
        object cbGetAllHeros: TCheckBox
          Left = 9
          Top = 48
          Width = 216
          Height = 17
          Caption = #20801#35768'['#38750#26412#20154#29289#30340#33521#38596']'#34987#21484#21796#20026#33521#38596
          TabOrder = 2
          OnClick = CheckBoxAllowGetBackDelChrClick
        end
      end
      object cbMutiHero: TCheckBox
        Left = 16
        Top = 9
        Width = 107
        Height = 17
        Caption = #24320#25918#22810#33521#38596#31995#32479
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = CheckBoxAllowGetBackDelChrClick
      end
    end
    object TabSheet4: TTabSheet
      Caption = #31995#32479#35774#32622
      ImageIndex = 3
      object cbCloseSelGate: TCheckBox
        Left = 16
        Top = 15
        Width = 225
        Height = 17
        Caption = #20851#38381#35282#33394#32593#20851#65292#38388#38548'           '#23567#26102
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = CheckBoxOpenHRSystemClick
      end
      object seCloseSelGateTime: TSpinEdit
        Left = 145
        Top = 13
        Width = 57
        Height = 21
        EditorEnabled = False
        MaxValue = 450
        MinValue = 1
        TabOrder = 1
        Value = 1
        OnChange = seRenewLRTimeChange
      end
    end
  end
  object btnGSave: TButton
    Left = 354
    Top = 249
    Width = 75
    Height = 25
    Caption = #20445#23384'(&S)'
    TabOrder = 1
    OnClick = btnGSaveClick
  end
end
