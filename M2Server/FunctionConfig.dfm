object frmFunctionConfig: TfrmFunctionConfig
  Left = 940
  Top = 401
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21151#33021#35774#32622
  ClientHeight = 375
  ClientWidth = 472
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
  object Label14: TLabel
    Left = 8
    Top = 356
    Width = 432
    Height = 12
    Caption = #35843#25972#30340#21442#25968#31435#21363#29983#25928#65292#22312#32447#26102#35831#30830#35748#27492#21442#25968#30340#20316#29992#20877#35843#25972#65292#20081#35843#25972#23558#23548#33268#28216#25103#28151#20081
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object FunctionConfigControl: TPageControl
    Left = 8
    Top = 8
    Width = 457
    Height = 345
    ActivePage = TabSheetGeneral
    MultiLine = True
    TabOrder = 0
    OnChanging = FunctionConfigControlChanging
    object TabSheetGeneral: TTabSheet
      Caption = #22522#26412#21151#33021
      ImageIndex = 3
      object GroupBox7: TGroupBox
        Left = 8
        Top = 176
        Width = 128
        Height = 117
        Caption = #33021#37327#25511#21046
        TabOrder = 0
        object CheckBoxHungerSystem: TCheckBox
          Left = 9
          Top = 23
          Width = 113
          Height = 17
          Hint = #21551#29992#27492#21151#33021#21518#65292#20154#29289#24517#39035#23450#26102#21507#39135#29289#20197#20445#25345#33021#37327#65292#22914#26524#38271#26102#38388#26410#21507#39135#29289#65292#20154#29289#23558#34987#39295#27515#12290
          Caption = #21551#29992#33021#37327#25511#21046#31995#32479
          TabOrder = 0
          OnClick = CheckBoxHungerSystemClick
        end
        object GroupBoxHunger: TGroupBox
          Left = 9
          Top = 53
          Width = 111
          Height = 56
          Caption = #33021#37327#19981#22815#26102
          TabOrder = 1
          object CheckBoxHungerDecPower: TCheckBox
            Left = 6
            Top = 33
            Width = 93
            Height = 17
            Hint = #20154#29289#30340#25915#20987#21147#65292#19982#20154#29289#30340#33021#37327#30456#20851#65292#33021#37327#19981#22815#26102#20154#29289#30340#25915#20987#21147#23558#38543#20043#19979#38477#12290
            Caption = #33258#21160#20943#25915#20987#21147
            TabOrder = 0
            OnClick = CheckBoxHungerDecPowerClick
          end
          object CheckBoxHungerDecHP: TCheckBox
            Left = 6
            Top = 15
            Width = 67
            Height = 17
            Hint = #24403#20154#29289#38271#26102#38388#27809#21507#39135#29289#21518#33021#37327#38477#21040'0'#21518#65292#23558#24320#22987#33258#21160#20943#23569'HP'#20540#65292#38477#21040'0'#21518#65292#20154#29289#27515#20129#12290
            Caption = #33258#21160#20943'HP'
            TabOrder = 1
            OnClick = CheckBoxHungerDecHPClick
          end
        end
      end
      object ButtonGeneralSave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonGeneralSaveClick
      end
      object GroupBox34: TGroupBox
        Left = 8
        Top = 8
        Width = 128
        Height = 165
        Caption = #21517#23383#26174#31034#39068#33394
        TabOrder = 2
        object Label85: TLabel
          Left = 11
          Top = 20
          Width = 54
          Height = 12
          Caption = #25915#20987#29366#24577':'
        end
        object LabelPKFlagNameColor: TLabel
          Left = 112
          Top = 18
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label87: TLabel
          Left = 11
          Top = 44
          Width = 54
          Height = 12
          Caption = #40644#21517#29366#24577':'
        end
        object LabelPKLevel1NameColor: TLabel
          Left = 112
          Top = 42
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label89: TLabel
          Left = 11
          Top = 68
          Width = 54
          Height = 12
          Caption = #32418#21517#29366#24577':'
        end
        object LabelPKLevel2NameColor: TLabel
          Left = 112
          Top = 66
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label91: TLabel
          Left = 11
          Top = 92
          Width = 54
          Height = 12
          Caption = #32852#30431#25112#20105':'
        end
        object LabelAllyAndGuildNameColor: TLabel
          Left = 112
          Top = 90
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label93: TLabel
          Left = 11
          Top = 116
          Width = 54
          Height = 12
          Caption = #25932#23545#25112#20105':'
        end
        object LabelWarGuildNameColor: TLabel
          Left = 112
          Top = 114
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label95: TLabel
          Left = 11
          Top = 140
          Width = 54
          Height = 12
          Caption = #25112#20105#21306#22495':'
        end
        object LabelInFreePKAreaNameColor: TLabel
          Left = 112
          Top = 138
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditPKFlagNameColor: TSpinEdit
          Left = 64
          Top = 16
          Width = 41
          Height = 21
          Hint = #24403#20154#29289#25915#20987#20854#20182#20154#29289#26102#21517#23383#39068#33394#65292#40664#35748#20026'47'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditPKFlagNameColorChange
        end
        object EditPKLevel1NameColor: TSpinEdit
          Left = 64
          Top = 40
          Width = 41
          Height = 21
          Hint = #24403#20154#29289'PK'#28857#36229#36807'100'#28857#26102#21517#23383#39068#33394#65292#40664#35748#20026'251'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditPKLevel1NameColorChange
        end
        object EditPKLevel2NameColor: TSpinEdit
          Left = 64
          Top = 64
          Width = 41
          Height = 21
          Hint = #24403#20154#29289'PK'#28857#36229#36807'200'#28857#26102#21517#23383#39068#33394#65292#40664#35748#20026'249'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditPKLevel2NameColorChange
        end
        object EditAllyAndGuildNameColor: TSpinEdit
          Left = 64
          Top = 88
          Width = 41
          Height = 21
          Hint = #24403#20154#29289#22312#34892#20250#25112#20105#26102#65292#26412#34892#20250#21450#32852#30431#34892#20250#20154#29289#21517#23383#39068#33394#65292#40664#35748#20026'180'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditAllyAndGuildNameColorChange
        end
        object EditWarGuildNameColor: TSpinEdit
          Left = 64
          Top = 112
          Width = 41
          Height = 21
          Hint = #24403#20154#29289#22312#34892#20250#25112#20105#26102#65292#25932#23545#34892#20250#20154#29289#21517#23383#39068#33394#65292#40664#35748#20026'69'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditWarGuildNameColorChange
        end
        object EditInFreePKAreaNameColor: TSpinEdit
          Left = 64
          Top = 136
          Width = 41
          Height = 21
          Hint = #24403#20154#29289#22312#34892#20250#25112#20105#21306#22495#26102#20154#29289#21517#23383#39068#33394#65292#40664#35748#20026'221'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditInFreePKAreaNameColorChange
        end
      end
      object GroupBox63: TGroupBox
        Left = 151
        Top = 311
        Width = 289
        Height = 165
        Caption = #27668#34880#30707'/'#39764#34880#30707#35774#32622
        TabOrder = 3
        object Label128: TLabel
          Left = 8
          Top = 20
          Width = 252
          Height = 12
          Caption = #24403'HP <        % '#24320#21551#27668#34880#30707','#38388#38548':        '#31186
        end
        object Label129: TLabel
          Left = 8
          Top = 92
          Width = 252
          Height = 12
          Caption = #24403'MP <        % '#24320#21551#39764#34880#30707','#38388#38548':        '#31186
        end
        object Label130: TLabel
          Left = 8
          Top = 44
          Width = 192
          Height = 12
          Caption = #22686#21152'HP'#20026#27668#34880#30707#24635#25345#20037#30340'         %'
        end
        object Label131: TLabel
          Left = 8
          Top = 116
          Width = 192
          Height = 12
          Caption = #22686#21152'MP'#20026#39764#34880#30707#24635#25345#20037#30340'         %'
        end
        object Label132: TLabel
          Left = 8
          Top = 68
          Width = 198
          Height = 12
          Caption = #27599#27425#27668#34880#30707#20943#23569#30340#25345#20037#20540'         '#28857
        end
        object Label133: TLabel
          Left = 8
          Top = 140
          Width = 198
          Height = 12
          Caption = #27599#27425#39764#34880#30707#20943#23569#30340#25345#20037#20540'         '#28857
        end
        object EditHPStoneStart: TSpinEdit
          Left = 48
          Top = 16
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 100
          OnChange = EditHPStoneStartChange
        end
        object EditMPStoneStart: TSpinEdit
          Left = 48
          Top = 88
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 1
          Value = 100
          OnChange = EditMPStoneStartChange
        end
        object EditHPStoneTime: TSpinEdit
          Left = 200
          Top = 16
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 2
          Value = 100
          OnChange = EditHPStoneTimeChange
        end
        object EditMPStoneTime: TSpinEdit
          Left = 200
          Top = 88
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 3
          Value = 100
          OnChange = EditMPStoneTimeChange
        end
        object EditHPStoneAddPoint: TSpinEdit
          Left = 144
          Top = 40
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 4
          Value = 100
          OnChange = EditHPStoneAddPointChange
        end
        object EditMPStoneAddPoint: TSpinEdit
          Left = 144
          Top = 112
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 5
          Value = 100
          OnChange = EditMPStoneAddPointChange
        end
        object EditHPStoneDecDura: TSpinEdit
          Left = 144
          Top = 64
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 1
          TabOrder = 6
          Value = 100
          OnChange = EditHPStoneDecDuraChange
        end
        object EditMPStoneDecDura: TSpinEdit
          Left = 144
          Top = 136
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 1
          TabOrder = 7
          Value = 100
          OnChange = EditMPStoneDecDuraChange
        end
      end
      object GroupBox77: TGroupBox
        Left = 142
        Top = 9
        Width = 299
        Height = 257
        Caption = #21151#33021#35774#32622
        TabOrder = 4
        object Label167: TLabel
          Left = 145
          Top = 18
          Width = 144
          Height = 12
          Caption = #32858#28789#29664#21560#25910#32463#39564':        %'
        end
        object Label169: TLabel
          Left = 145
          Top = 39
          Width = 144
          Height = 12
          Caption = #20869#21151#25915#20987#22686#30410':          %'
        end
        object Label170: TLabel
          Left = 145
          Top = 81
          Width = 144
          Height = 12
          Caption = #20869#21151#25216#33021#22686#30410':          %'
        end
        object Label162: TLabel
          Left = 145
          Top = 101
          Width = 78
          Height = 12
          Caption = #34917#20914'HPMP'#36895#29575':'
        end
        object Label166: TLabel
          Left = 145
          Top = 122
          Width = 78
          Height = 12
          Caption = #21507#33647#26102#38388#38388#38548':'
        end
        object Label211: TLabel
          Left = 145
          Top = 60
          Width = 144
          Height = 12
          Caption = #20869#21151#38450#24481#22686#30410':          %'
        end
        object SpinEditGatherExpRate: TSpinEdit
          Left = 239
          Top = 14
          Width = 41
          Height = 21
          Hint = #32858#28789#29664#33719#21462#32463#39564#30340#30334#20998#27604
          MaxValue = 9999
          MinValue = 1
          TabOrder = 0
          Value = 100
          OnChange = SpinEditGatherExpRateChange
        end
        object CheckBoxMonSayMsg: TCheckBox
          Left = 9
          Top = 17
          Width = 123
          Height = 17
          Caption = #24320#21551#24618#29289#35828#35805
          TabOrder = 1
          OnClick = CheckBoxMonSayMsgClick
        end
        object CheckBoxStorageEX: TCheckBox
          Left = 9
          Top = 33
          Width = 123
          Height = 17
          Caption = #24320#21551#26080#38480#20179#24211#21151#33021
          Enabled = False
          TabOrder = 2
          OnClick = CheckBoxStorageEXClick
        end
        object CheckBoxShowShieldEffect: TCheckBox
          Left = 9
          Top = 49
          Width = 123
          Height = 17
          Hint = #21435#25481#27492#25928#26524#65292#21487#20197#20943#23569#22240#22823#22411'PK'#24341#36215#36807#21345#38382#39064#12290
          Caption = #26174#31034#25252#20307#31070#30462#25928#26524
          TabOrder = 3
          OnClick = CheckBoxShowShieldEffectClick
        end
        object CheckBoxAutoOpenShield: TCheckBox
          Left = 9
          Top = 65
          Width = 123
          Height = 17
          Caption = #33258#21160#24320#21551#25252#20307#31070#30462
          TabOrder = 4
          OnClick = CheckBoxAutoOpenShieldClick
        end
        object CheckBoxEnableMapEvent: TCheckBox
          Left = 9
          Top = 81
          Width = 123
          Height = 17
          Caption = #24320#21551#22320#22270#20107#20214#35302#21457
          TabOrder = 5
          OnClick = CheckBoxEnableMapEventClick
        end
        object CheckBoxFireBurnEventOff: TCheckBox
          Left = 9
          Top = 97
          Width = 123
          Height = 17
          Caption = #24320#21551#28779#22681#33258#21160#28040#22833
          TabOrder = 6
          OnClick = CheckBoxFireBurnEventOffClick
        end
        object SpinEditInternalPowerRate: TSpinEdit
          Left = 239
          Top = 35
          Width = 41
          Height = 21
          Hint = #20869#21151#31561#32423'1,'#22686#30410'100%'#26102','#22686#21152'1%'#30340#25915#38450#13#24403#22686#30410'200%'#26102#21363#22686#21152#25915#38450'2%,'#40664#35748'100'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 7
          Value = 100
          OnChange = SpinEditGatherExpRateChange
        end
        object SpinEditInternalPowerSkillRate: TSpinEdit
          Left = 239
          Top = 77
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 1
          TabOrder = 8
          Value = 100
          OnChange = SpinEditGatherExpRateChange
        end
        object EditCordialAddHPMax: TSpinEdit
          Left = 239
          Top = 98
          Width = 41
          Height = 21
          Hint = #35774#32622#20351#29992#26222#36890#33647#21697#12289#27668#34880#30707#31867#12289#36947#22763#27835#24840#25216#33021#30340#21152'HP/MP'#36895#29575#65292#25968#23383#36234#22823#65292#34917#20805'HP/MP'#36895#29575#36234#24555#65292#40664#35748#20026'5'#12290
          EditorEnabled = False
          MaxValue = 999
          MinValue = 1
          TabOrder = 9
          Value = 99
          OnChange = EditCordialAddHPMaxChange
        end
        object speEatItemsTime: TSpinEdit
          Left = 239
          Top = 119
          Width = 41
          Height = 21
          Hint = #21507#33647#26102#38388#38388#38548','#21333#20301#27627#31186'.'
          EditorEnabled = False
          MaxValue = 60000
          MinValue = 1
          TabOrder = 10
          Value = 200
          OnChange = speEatItemsTimeChange
        end
        object cbEffectHeroDropRate: TCheckBox
          Left = 9
          Top = 114
          Width = 123
          Height = 17
          Hint = #38057#36873#27492#39033#65292#33521#38596#27515#20129#26102#30340#26292#29575#23558#21463#23545#26041'[PK'#30446#26631#29190#29575']'#30340#24433#21709#12290
          Caption = 'PK'#30446#26631#29190#29575'('#33521#38596')'
          TabOrder = 11
          OnClick = CheckBoxFireBurnEventOffClick
        end
        object GroupBox83: TGroupBox
          Left = 9
          Top = 141
          Width = 281
          Height = 107
          Caption = #23458#25143#31471#25511#21046
          TabOrder = 12
          object CheckBoxClientAP: TCheckBox
            Left = 5
            Top = 15
            Width = 85
            Height = 17
            Hint = #38057#36873#27492#36873#39033#65292#23558#20801#35768#23458#25143#31471#20351#29992#20869#25346#20013#30340'['#33258#21160#25346#26426']'#21151#33021#12290
            Caption = #33258#21160#25346#26426
            TabOrder = 0
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object cbClientAdjustSpeed: TCheckBox
            Left = 5
            Top = 32
            Width = 85
            Height = 17
            Hint = #38057#36873#27492#36873#39033#65292#23558#20801#35768#23458#25143#31471#20351#29992#20869#25346#20013#30340'['#36895#24230#35843#33410']'#21151#33021#12290
            Caption = #36895#24230#35843#25972
            TabOrder = 1
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object cbClientNoFog: TCheckBox
            Left = 5
            Top = 66
            Width = 46
            Height = 17
            Hint = #38057#36873#27492#36873#39033#65292#23558#20801#35768#23458#25143#31471#19981#38656#35201#20351#29992#34593#28891#25110#28779#25226#21435#29031#26126#12290
            Caption = #20813#34593
            TabOrder = 2
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object cbStallSystem: TCheckBox
            Left = 5
            Top = 83
            Width = 132
            Height = 17
            Caption = #24320#21551#25670#25674' '#31561#32423#38480#21046#8805
            TabOrder = 3
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object seSetShopNeedLevel: TSpinEdit
            Left = 141
            Top = 81
            Width = 49
            Height = 21
            Hint = #29609#23478#25670#28393#25152#38656#30340#26368#23569#31561#32423
            EditorEnabled = False
            MaxValue = 65000
            MinValue = 1
            TabOrder = 4
            Value = 200
            OnChange = speEatItemsTimeChange
          end
          object cbRecallHeroCtrl: TCheckBox
            Left = 80
            Top = 15
            Width = 126
            Height = 17
            Caption = #25511#21046#22806#25346#25910#25918#33521#38596
            TabOrder = 5
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object cbClientAutoLongAttack: TCheckBox
            Left = 5
            Top = 49
            Width = 85
            Height = 17
            Hint = #38057#36873#27492#36873#39033#65292#23558#20801#35768#23458#25143#31471#20351#29992#20869#25346#20013#30340'['#38548#20301#21050#26432']'#21151#33021#12290
            Caption = #38548#20301#21050#26432
            TabOrder = 6
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object cbHeroSys: TCheckBox
            Left = 80
            Top = 32
            Width = 89
            Height = 17
            Hint = #20851#38381#21518#23458#25143#31471#19981#20986#29616#33521#38596#25353#38062
            Caption = #24320#25918#33521#38596#31995#32479
            TabOrder = 7
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object cbCliAutoSay: TCheckBox
            Left = 80
            Top = 49
            Width = 89
            Height = 17
            Hint = #20851#38381#21518#23458#25143#31471#19981#20986#33258#21160#21898#35805#25353#38062
            Caption = #24320#25918#33258#21160#21898#35805
            TabOrder = 8
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object cbMutiHero: TCheckBox
            Left = 80
            Top = 63
            Width = 105
            Height = 17
            Caption = #24320#25918#22810#33521#38596#36873#25321
            TabOrder = 9
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object chkJointStrikeUI: TCheckBox
            Left = 184
            Top = 34
            Width = 97
            Height = 17
            Caption = #20351#29992#20845#26684#30028#38754
            TabOrder = 10
            OnClick = CheckBoxFireBurnEventOffClick
          end
          object chkOpenFindPathMyMap: TCheckBox
            Left = 184
            Top = 51
            Width = 97
            Height = 17
            Hint = #21246#36873#21518#24320#21551#23547#36335#22823#22320#22270
            Caption = #23547#36335#22823#22320#22270
            TabOrder = 11
            OnClick = CheckBoxFireBurnEventOffClick
          end
        end
        object SpinEditInternalPowerRate2: TSpinEdit
          Left = 239
          Top = 56
          Width = 41
          Height = 21
          Hint = #20869#21151#31561#32423'1,'#22686#30410'100%'#26102','#22686#21152'1%'#30340#25915#38450#13#24403#22686#30410'200%'#26102#21363#22686#21152#25915#38450'2%,'#40664#35748'100'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 13
          Value = 100
          OnChange = SpinEditGatherExpRateChange
        end
      end
      object cbDeathWalking: TCheckBox
        Left = 142
        Top = 272
        Width = 117
        Height = 17
        Caption = #25346#26426#20154#29289#33258#21160#36208#21160
        TabOrder = 5
        OnClick = CheckBoxFireBurnEventOffClick
      end
      object SpinEditTest: TSpinEdit
        Left = 76
        Top = 267
        Width = 49
        Height = 21
        EditorEnabled = False
        MaxValue = 255
        MinValue = 0
        TabOrder = 6
        Value = 12
        Visible = False
        OnChange = SpinEditTestChange
      end
      object cbSmiteDamegeShow: TCheckBox
        Left = 265
        Top = 272
        Width = 96
        Height = 17
        Caption = #26292#20987#28418#34880
        TabOrder = 7
        OnClick = CheckBoxFireBurnEventOffClick
      end
    end
    object MonSaySheet: TTabSheet
      Caption = #25193#23637#21151#33021
      object Label160: TLabel
        Left = 8
        Top = 12
        Width = 432
        Height = 132
        Caption = 
          #20116#34892#38453#27861#22855#25928':'#13#13#19979#34920#21015#20030#20102#27599#20010#23646#24615#30340#19982#20854#20182#23646#24615#30340#30456#29983'/'#30456#20811#24773#20917','#21450#30001#27492#21487#33719#24471#30340#22686#30410#25928#26524':'#13#13#33258#36523#23646#24615'  '#38431#21451#23646#24615'('#30456#29983')  '#25928 +
          #26524#9'        '#38431#21451#23646#24615'('#30456#20811')  '#25928#26524#13'-----------------------------------------' +
          '-------------------------------'#13#37329#9'  '#22303#9#9'  '#22686#21152#33258#36523'      '#28779#9'        '#22686#21152#33258 +
          #36523#13#26408#9'  '#27700#9#9'  '#29983#21629#20540#21644'      '#37329'              '#29289#29702#21644#39764#13#27700#9'  '#37329#9#9'  '#39764#27861#20540#19978'      '#22303'   ' +
          '           '#27861#25915#20987#21147#13#28779#9'  '#26408#9#9'  '#38480#9'        '#27700#13#22303#9'  '#28779#9#9#9'        '#26408
      end
      object ButtonMonSayMsgSave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonMonSayMsgSaveClick
      end
      object GroupBox40: TGroupBox
        Left = 8
        Top = 159
        Width = 153
        Height = 97
        Caption = #20116#34892#38453#27861
        TabOrder = 1
        object Label157: TLabel
          Left = 120
          Top = 44
          Width = 24
          Height = 12
          Caption = '/100'
        end
        object Label139: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #30456#29983#20493#25968':'
        end
        object Label158: TLabel
          Left = 8
          Top = 68
          Width = 54
          Height = 12
          Caption = #30456#20811#20493#25968':'
        end
        object Label159: TLabel
          Left = 120
          Top = 68
          Width = 24
          Height = 12
          Caption = '/100'
        end
        object CheckBoxGroupAttrib: TCheckBox
          Left = 8
          Top = 16
          Width = 121
          Height = 17
          Caption = #24320#21551#20116#34892#38453#27861#22855#25928
          TabOrder = 0
          OnClick = CheckBoxGroupAttribClick
        end
        object EditGroupAttribHPMPRate: TSpinEdit
          Left = 68
          Top = 39
          Width = 45
          Height = 21
          Hint = #20116#34892#23646#24615#22686#21152'HP'#65292'MP'#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
          EditorEnabled = False
          Increment = 10
          MaxValue = 10000
          MinValue = 10
          TabOrder = 1
          Value = 100
          OnChange = EditGroupAttribHPMPRateChange
        end
        object EditnGroupAttribPowerRate: TSpinEdit
          Left = 68
          Top = 63
          Width = 45
          Height = 21
          Hint = #20116#34892#23646#24615#25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
          EditorEnabled = False
          Increment = 10
          MaxValue = 10000
          MinValue = 100
          TabOrder = 2
          Value = 100
          OnChange = EditnGroupAttribPowerRateChange
        end
      end
    end
    object PasswordSheet: TTabSheet
      Caption = #23494#30721#20445#25252
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 193
        TabOrder = 0
        object CheckBoxEnablePasswordLock: TCheckBox
          Left = 8
          Top = -5
          Width = 121
          Height = 25
          Caption = #21551#29992#23494#30721#20445#25252#31995#32479
          TabOrder = 0
          OnClick = CheckBoxEnablePasswordLockClick
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 16
          Width = 265
          Height = 169
          Caption = #38145#23450#25511#21046
          TabOrder = 1
          object CheckBoxLockGetBackItem: TCheckBox
            Left = 16
            Top = 16
            Width = 121
            Height = 17
            Caption = #31105#27490#21462#20179#24211#20179#24211
            TabOrder = 0
            OnClick = CheckBoxLockGetBackItemClick
          end
          object GroupBox4: TGroupBox
            Left = 8
            Top = 40
            Width = 249
            Height = 121
            Caption = #30331#24405#38145#23450
            TabOrder = 1
            object CheckBoxLockWalk: TCheckBox
              Left = 8
              Top = 24
              Width = 105
              Height = 17
              Caption = #31105#27490#36208#36335
              TabOrder = 0
              OnClick = CheckBoxLockWalkClick
            end
            object CheckBoxLockRun: TCheckBox
              Left = 8
              Top = 40
              Width = 105
              Height = 17
              Caption = #31105#27490#36305#27493
              TabOrder = 1
              OnClick = CheckBoxLockRunClick
            end
            object CheckBoxLockHit: TCheckBox
              Left = 8
              Top = 56
              Width = 105
              Height = 17
              Caption = #31105#27490#25915#20987
              TabOrder = 2
              OnClick = CheckBoxLockHitClick
            end
            object CheckBoxLockSpell: TCheckBox
              Left = 8
              Top = 72
              Width = 105
              Height = 17
              Caption = #31105#27490#39764#27861
              TabOrder = 3
              OnClick = CheckBoxLockSpellClick
            end
            object CheckBoxLockSendMsg: TCheckBox
              Left = 120
              Top = 40
              Width = 105
              Height = 17
              Caption = #31105#27490#32842#22825
              TabOrder = 4
              OnClick = CheckBoxLockSendMsgClick
            end
            object CheckBoxLockInObMode: TCheckBox
              Left = 120
              Top = 24
              Width = 121
              Height = 17
              Hint = #22914#26524#26377#23494#30721#20445#25252#26102#65292#20154#29289#30331#24405#26102#20026#38544#36523#29366#24577#65292#24618#29289#19981#20250#25915#20987#20154#29289#65292#22312#36755#20837#23494#30721#24320#38145#21518#24674#22797#27491#24120#12290
              Caption = #38145#23450#26102#20026#38544#36523#27169#24335
              TabOrder = 5
              OnClick = CheckBoxLockInObModeClick
            end
            object CheckBoxLockLogin: TCheckBox
              Left = 8
              Top = -2
              Width = 91
              Height = 17
              Caption = #38145#23450#20154#29289#30331#24405
              TabOrder = 6
              OnClick = CheckBoxLockLoginClick
            end
            object CheckBoxLockUseItem: TCheckBox
              Left = 120
              Top = 88
              Width = 105
              Height = 17
              Caption = #31105#27490#20351#29992#21697
              TabOrder = 7
              OnClick = CheckBoxLockUseItemClick
            end
            object CheckBoxLockDropItem: TCheckBox
              Left = 120
              Top = 72
              Width = 105
              Height = 17
              Caption = #31105#27490#25172#29289#21697
              TabOrder = 8
              OnClick = CheckBoxLockDropItemClick
            end
            object CheckBoxLockDealItem: TCheckBox
              Left = 120
              Top = 56
              Width = 121
              Height = 17
              Caption = #31105#27490#20132#26131#29289#21697
              TabOrder = 9
              OnClick = CheckBoxLockDealItemClick
            end
            object CheckBoxLockRecallHero: TCheckBox
              Left = 8
              Top = 88
              Width = 97
              Height = 17
              Caption = #38145#23450#21484#21796#33521#38596
              TabOrder = 10
              OnClick = CheckBoxLockRecallHeroClick
            end
          end
        end
        object GroupBox3: TGroupBox
          Left = 280
          Top = 16
          Width = 145
          Height = 65
          Caption = #23494#30721#36755#20837#38169#35823#25511#21046
          TabOrder = 2
          object Label1: TLabel
            Left = 8
            Top = 18
            Width = 54
            Height = 12
            Caption = #38169#35823#27425#25968':'
          end
          object EditErrorPasswordCount: TSpinEdit
            Left = 68
            Top = 15
            Width = 53
            Height = 21
            Hint = #22312#24320#38145#26102#36755#20837#23494#30721#65292#22914#26524#36755#20837#38169#35823#36229#36807#25351#23450#27425#25968#65292#21017#38145#23450#23494#30721#65292#24517#39035#37325#26032#30331#24405#19968#27425#25165#21487#20197#20877#27425#36755#20837#23494#30721#12290
            EditorEnabled = False
            MaxValue = 10
            MinValue = 1
            TabOrder = 0
            Value = 10
            OnChange = EditErrorPasswordCountChange
          end
          object CheckBoxErrorCountKick: TCheckBox
            Left = 8
            Top = 40
            Width = 129
            Height = 17
            Caption = #36229#36807#25351#23450#27425#25968#36386#19979#32447
            Enabled = False
            TabOrder = 1
            OnClick = CheckBoxErrorCountKickClick
          end
        end
        object ButtonPasswordLockSave: TButton
          Left = 358
          Top = 161
          Width = 65
          Height = 21
          Caption = #20445#23384'(&S)'
          TabOrder = 3
          OnClick = ButtonPasswordLockSaveClick
        end
      end
    end
    object TabSheet33: TTabSheet
      Caption = #24072#24466#31995#32479
      ImageIndex = 5
      object GroupBox21: TGroupBox
        Left = 8
        Top = 8
        Width = 161
        Height = 153
        Caption = #24466#24351#20986#24072
        TabOrder = 0
        object GroupBox22: TGroupBox
          Left = 8
          Top = 16
          Width = 145
          Height = 49
          Caption = #20986#24072#31561#32423
          TabOrder = 0
          object Label29: TLabel
            Left = 8
            Top = 18
            Width = 54
            Height = 12
            Caption = #20986#24072#31561#32423':'
          end
          object EditMasterOKLevel: TSpinEdit
            Left = 68
            Top = 15
            Width = 53
            Height = 21
            Hint = #20986#24072#31561#32423#35774#32622#65292#20154#29289#22312#25308#24072#21518#65292#21040#25351#23450#31561#32423#21518#23558#33258#21160#20986#24072#12290
            MaxValue = 65535
            MinValue = 1
            TabOrder = 0
            Value = 10
            OnChange = EditMasterOKLevelChange
          end
        end
        object GroupBox23: TGroupBox
          Left = 8
          Top = 72
          Width = 145
          Height = 73
          Caption = #24072#29238#25152#24471
          TabOrder = 1
          object Label30: TLabel
            Left = 8
            Top = 18
            Width = 54
            Height = 12
            Caption = #22768#26395#28857#25968':'
          end
          object Label31: TLabel
            Left = 8
            Top = 42
            Width = 54
            Height = 12
            Caption = #20998#37197#28857#25968':'
          end
          object EditMasterOKCreditPoint: TSpinEdit
            Left = 68
            Top = 15
            Width = 53
            Height = 21
            Hint = #24466#24351#20986#24072#21518#65292#24072#29238#24471#21040#30340#22768#26395#28857#25968#12290
            MaxValue = 100
            MinValue = 0
            TabOrder = 0
            Value = 10
            OnChange = EditMasterOKCreditPointChange
          end
          object EditMasterOKBonusPoint: TSpinEdit
            Left = 68
            Top = 39
            Width = 53
            Height = 21
            Hint = #24466#24351#20986#24072#21518#65292#24072#29238#24471#21040#30340#20998#37197#28857#25968#12290
            MaxValue = 1000
            MinValue = 0
            TabOrder = 1
            Value = 10
            OnChange = EditMasterOKBonusPointChange
          end
        end
      end
      object ButtonMasterSave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonMasterSaveClick
      end
    end
    object TabSheet38: TTabSheet
      Caption = #36716#29983#31995#32479
      ImageIndex = 9
      object GroupBox29: TGroupBox
        Left = 8
        Top = 8
        Width = 113
        Height = 257
        Caption = #33258#21160#21464#33394
        TabOrder = 0
        object Label56: TLabel
          Left = 11
          Top = 16
          Width = 18
          Height = 12
          Caption = #19968':'
        end
        object LabelReNewNameColor1: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label58: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 12
          Caption = #20108':'
        end
        object LabelReNewNameColor2: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label60: TLabel
          Left = 11
          Top = 64
          Width = 18
          Height = 12
          Caption = #19977':'
        end
        object LabelReNewNameColor3: TLabel
          Left = 88
          Top = 62
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label62: TLabel
          Left = 11
          Top = 88
          Width = 18
          Height = 12
          Caption = #22235':'
        end
        object LabelReNewNameColor4: TLabel
          Left = 88
          Top = 86
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label64: TLabel
          Left = 11
          Top = 112
          Width = 18
          Height = 12
          Caption = #20116':'
        end
        object LabelReNewNameColor5: TLabel
          Left = 88
          Top = 110
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label66: TLabel
          Left = 11
          Top = 136
          Width = 18
          Height = 12
          Caption = #20845':'
        end
        object LabelReNewNameColor6: TLabel
          Left = 88
          Top = 134
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label68: TLabel
          Left = 11
          Top = 160
          Width = 18
          Height = 12
          Caption = #19971':'
        end
        object LabelReNewNameColor7: TLabel
          Left = 88
          Top = 158
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label70: TLabel
          Left = 11
          Top = 184
          Width = 18
          Height = 12
          Caption = #20843':'
        end
        object LabelReNewNameColor8: TLabel
          Left = 88
          Top = 182
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label72: TLabel
          Left = 11
          Top = 208
          Width = 18
          Height = 12
          Caption = #20061':'
        end
        object LabelReNewNameColor9: TLabel
          Left = 88
          Top = 206
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label74: TLabel
          Left = 11
          Top = 232
          Width = 18
          Height = 12
          Caption = #21313':'
        end
        object LabelReNewNameColor10: TLabel
          Left = 88
          Top = 230
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditReNewNameColor1: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditReNewNameColor1Change
        end
        object EditReNewNameColor2: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditReNewNameColor2Change
        end
        object EditReNewNameColor3: TSpinEdit
          Left = 40
          Top = 60
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditReNewNameColor3Change
        end
        object EditReNewNameColor4: TSpinEdit
          Left = 40
          Top = 84
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditReNewNameColor4Change
        end
        object EditReNewNameColor5: TSpinEdit
          Left = 40
          Top = 108
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditReNewNameColor5Change
        end
        object EditReNewNameColor6: TSpinEdit
          Left = 40
          Top = 132
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditReNewNameColor6Change
        end
        object EditReNewNameColor7: TSpinEdit
          Left = 40
          Top = 156
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditReNewNameColor7Change
        end
        object EditReNewNameColor8: TSpinEdit
          Left = 40
          Top = 180
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditReNewNameColor8Change
        end
        object EditReNewNameColor9: TSpinEdit
          Left = 40
          Top = 204
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditReNewNameColor9Change
        end
        object EditReNewNameColor10: TSpinEdit
          Left = 40
          Top = 228
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 9
          Value = 100
          OnChange = EditReNewNameColor10Change
        end
      end
      object ButtonReNewLevelSave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonReNewLevelSaveClick
      end
      object GroupBox30: TGroupBox
        Left = 128
        Top = 8
        Width = 129
        Height = 97
        Caption = #21517#23383#21464#33394
        TabOrder = 2
        object Label57: TLabel
          Left = 8
          Top = 67
          Width = 114
          Height = 12
          Caption = #26102#38388#38388#38548':        '#31186
        end
        object LabelReNewChangeColorLevel: TLabel
          Left = 8
          Top = 40
          Width = 114
          Height = 12
          Caption = #38656#35201#36716#29983':        '#27425
        end
        object EditReNewNameColorTime: TSpinEdit
          Left = 66
          Top = 63
          Width = 37
          Height = 21
          Hint = #21517#23383#33258#21160#21464#33394#30340#26102#38388#38388#38548#12290
          EditorEnabled = False
          MaxValue = 120
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditReNewNameColorTimeChange
        end
        object CheckBoxReNewChangeColor: TCheckBox
          Left = 8
          Top = 16
          Width = 89
          Height = 17
          Hint = #25171#24320#27492#21151#33021#21518#65292#36716#29983#30340#20154#29289#30340#21517#23383#39068#33394#20250#33258#21160#21464#21270#12290
          Caption = #33258#21160#21464#33394
          TabOrder = 1
          OnClick = CheckBoxReNewChangeColorClick
        end
        object SpinEditReNewChangeColorLevel: TSpinEdit
          Left = 66
          Top = 37
          Width = 37
          Height = 21
          Hint = #21517#23383#33258#21160#21464#33394#38656#35201#30340#36716#29983#27425#25968#12290
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 10
          OnChange = SpinEditReNewChangeColorLevelChange
        end
      end
      object GroupBox33: TGroupBox
        Left = 128
        Top = 112
        Width = 129
        Height = 41
        Caption = #36716#29983#25511#21046
        TabOrder = 3
        object CheckBoxReNewLevelClearExp: TCheckBox
          Left = 8
          Top = 16
          Width = 89
          Height = 17
          Hint = #36716#29983#26102#26159#21542#28165#38500#24050#32463#26377#30340#32463#39564#20540#12290
          Caption = #28165#38500#24050#26377#32463#39564
          TabOrder = 0
          OnClick = CheckBoxReNewLevelClearExpClick
        end
      end
    end
    object TabSheet39: TTabSheet
      Caption = #23453#23453#21319#32423
      ImageIndex = 10
      object ButtonMonUpgradeSave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonMonUpgradeSaveClick
      end
      object GroupBox32: TGroupBox
        Left = 8
        Top = 8
        Width = 186
        Height = 241
        Caption = #31561#32423#39068#33394
        TabOrder = 1
        object Label65: TLabel
          Left = 11
          Top = 20
          Width = 18
          Height = 12
          Caption = #19968':'
        end
        object LabelMonUpgradeColor1: TLabel
          Left = 85
          Top = 18
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label67: TLabel
          Left = 11
          Top = 44
          Width = 18
          Height = 12
          Caption = #20108':'
        end
        object LabelMonUpgradeColor2: TLabel
          Left = 85
          Top = 42
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label69: TLabel
          Left = 11
          Top = 68
          Width = 18
          Height = 12
          Caption = #19977':'
        end
        object LabelMonUpgradeColor3: TLabel
          Left = 85
          Top = 66
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label71: TLabel
          Left = 11
          Top = 92
          Width = 18
          Height = 12
          Caption = #22235':'
        end
        object LabelMonUpgradeColor4: TLabel
          Left = 85
          Top = 90
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label73: TLabel
          Left = 11
          Top = 116
          Width = 18
          Height = 12
          Caption = #20116':'
        end
        object LabelMonUpgradeColor5: TLabel
          Left = 85
          Top = 114
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label75: TLabel
          Left = 11
          Top = 140
          Width = 18
          Height = 12
          Caption = #20845':'
        end
        object LabelMonUpgradeColor6: TLabel
          Left = 85
          Top = 138
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label76: TLabel
          Left = 11
          Top = 164
          Width = 18
          Height = 12
          Caption = #19971':'
        end
        object LabelMonUpgradeColor7: TLabel
          Left = 85
          Top = 162
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label77: TLabel
          Left = 11
          Top = 188
          Width = 18
          Height = 12
          Caption = #20843':'
        end
        object LabelMonUpgradeColor8: TLabel
          Left = 85
          Top = 186
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label86: TLabel
          Left = 11
          Top = 212
          Width = 18
          Height = 12
          Caption = #20061':'
        end
        object LabelMonUpgradeColor9: TLabel
          Left = 85
          Top = 210
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label176: TLabel
          Left = 99
          Top = 18
          Width = 18
          Height = 12
          Caption = #21313':'
        end
        object LabelMonUpgradeColor10: TLabel
          Left = 172
          Top = 16
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelMonUpgradeColor11: TLabel
          Left = 172
          Top = 40
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelMonUpgradeColor12: TLabel
          Left = 172
          Top = 64
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelMonUpgradeColor13: TLabel
          Left = 172
          Top = 88
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelMonUpgradeColor14: TLabel
          Left = 172
          Top = 112
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelMonUpgradeColor15: TLabel
          Left = 172
          Top = 136
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label177: TLabel
          Left = 99
          Top = 114
          Width = 30
          Height = 12
          Caption = #21313#22235':'
        end
        object Label178: TLabel
          Left = 99
          Top = 138
          Width = 30
          Height = 12
          Caption = #21313#20116':'
        end
        object Label179: TLabel
          Left = 99
          Top = 90
          Width = 30
          Height = 12
          Caption = #21313#19977':'
        end
        object Label180: TLabel
          Left = 99
          Top = 66
          Width = 30
          Height = 12
          Caption = #21313#20108':'
        end
        object Label181: TLabel
          Left = 99
          Top = 42
          Width = 30
          Height = 12
          Caption = #21313#19968':'
        end
        object EditMonUpgradeColor1: TSpinEdit
          Left = 40
          Top = 16
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditMonUpgradeColor1Change
        end
        object EditMonUpgradeColor2: TSpinEdit
          Left = 40
          Top = 40
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMonUpgradeColor2Change
        end
        object EditMonUpgradeColor3: TSpinEdit
          Left = 40
          Top = 64
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMonUpgradeColor3Change
        end
        object EditMonUpgradeColor4: TSpinEdit
          Left = 40
          Top = 88
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMonUpgradeColor4Change
        end
        object EditMonUpgradeColor5: TSpinEdit
          Left = 40
          Top = 112
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditMonUpgradeColor5Change
        end
        object EditMonUpgradeColor6: TSpinEdit
          Left = 40
          Top = 136
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditMonUpgradeColor6Change
        end
        object EditMonUpgradeColor7: TSpinEdit
          Left = 40
          Top = 160
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditMonUpgradeColor7Change
        end
        object EditMonUpgradeColor8: TSpinEdit
          Left = 40
          Top = 184
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditMonUpgradeColor8Change
        end
        object EditMonUpgradeColor9: TSpinEdit
          Left = 40
          Top = 208
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditMonUpgradeColor9Change
        end
        object EditMonUpgradeColor10: TSpinEdit
          Left = 128
          Top = 14
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 9
          Value = 100
          OnChange = EditMonUpgradeColor10Change
        end
        object EditMonUpgradeColor15: TSpinEdit
          Left = 128
          Top = 134
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 10
          Value = 100
          OnChange = EditMonUpgradeColor15Change
        end
        object EditMonUpgradeColor14: TSpinEdit
          Left = 128
          Top = 110
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 11
          Value = 100
          OnChange = EditMonUpgradeColor14Change
        end
        object EditMonUpgradeColor13: TSpinEdit
          Left = 128
          Top = 86
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 12
          Value = 100
          OnChange = EditMonUpgradeColor13Change
        end
        object EditMonUpgradeColor12: TSpinEdit
          Left = 128
          Top = 62
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 13
          Value = 100
          OnChange = EditMonUpgradeColor12Change
        end
        object EditMonUpgradeColor11: TSpinEdit
          Left = 128
          Top = 38
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 14
          Value = 100
          OnChange = EditMonUpgradeColor11Change
        end
      end
      object GroupBox31: TGroupBox
        Left = 200
        Top = 8
        Width = 97
        Height = 241
        Caption = #21319#32423#26432#24618#25968
        TabOrder = 2
        object Label61: TLabel
          Left = 11
          Top = 20
          Width = 18
          Height = 12
          Caption = #19968':'
        end
        object Label63: TLabel
          Left = 11
          Top = 44
          Width = 18
          Height = 12
          Caption = #20108':'
        end
        object Label78: TLabel
          Left = 11
          Top = 68
          Width = 18
          Height = 12
          Caption = #19977':'
        end
        object Label79: TLabel
          Left = 11
          Top = 92
          Width = 18
          Height = 12
          Caption = #22235':'
        end
        object Label80: TLabel
          Left = 11
          Top = 116
          Width = 18
          Height = 12
          Caption = #20116':'
        end
        object Label81: TLabel
          Left = 11
          Top = 140
          Width = 18
          Height = 12
          Caption = #20845':'
        end
        object Label82: TLabel
          Left = 11
          Top = 164
          Width = 18
          Height = 12
          Caption = #19971':'
        end
        object Label83: TLabel
          Left = 11
          Top = 188
          Width = 30
          Height = 12
          Caption = #22522#25968':'
        end
        object Label84: TLabel
          Left = 11
          Top = 212
          Width = 30
          Height = 12
          Caption = #20493#29575':'
        end
        object EditMonUpgradeKillCount1: TSpinEdit
          Left = 40
          Top = 16
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditMonUpgradeKillCount1Change
        end
        object EditMonUpgradeKillCount2: TSpinEdit
          Left = 40
          Top = 40
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMonUpgradeKillCount2Change
        end
        object EditMonUpgradeKillCount3: TSpinEdit
          Left = 40
          Top = 64
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMonUpgradeKillCount3Change
        end
        object EditMonUpgradeKillCount4: TSpinEdit
          Left = 40
          Top = 88
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMonUpgradeKillCount4Change
        end
        object EditMonUpgradeKillCount5: TSpinEdit
          Left = 40
          Top = 112
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditMonUpgradeKillCount5Change
        end
        object EditMonUpgradeKillCount6: TSpinEdit
          Left = 40
          Top = 136
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditMonUpgradeKillCount6Change
        end
        object EditMonUpgradeKillCount7: TSpinEdit
          Left = 40
          Top = 160
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditMonUpgradeKillCount7Change
        end
        object EditMonUpLvNeedKillBase: TSpinEdit
          Left = 40
          Top = 184
          Width = 49
          Height = 21
          Hint = #26432#24618#25968#37327'='#31561#32423' * '#20493#29575' + '#31561#32423' + '#22522#25968' + '#27599#32423#25968#37327
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditMonUpLvNeedKillBaseChange
        end
        object EditMonUpLvRate: TSpinEdit
          Left = 40
          Top = 208
          Width = 49
          Height = 21
          Hint = #26432#24618#25968#37327'='#24618#29289#31561#32423' * '#20493#29575' + '#31561#32423' + '#22522#25968' + '#27599#32423#25968#37327
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditMonUpLvRateChange
        end
      end
      object GroupBox35: TGroupBox
        Left = 302
        Top = 8
        Width = 137
        Height = 113
        Caption = #20027#20154#27515#20129#25511#21046
        TabOrder = 3
        object Label88: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #21464#24322#26426#29575':'
        end
        object Label90: TLabel
          Left = 11
          Top = 64
          Width = 54
          Height = 12
          Caption = #22686#21152#25915#20987':'
        end
        object Label92: TLabel
          Left = 11
          Top = 88
          Width = 54
          Height = 12
          Caption = #22686#21152#36895#24230':'
        end
        object CheckBoxMasterDieMutiny: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Caption = #20027#20154#27515#20129#21518#21464#24322
          TabOrder = 0
          OnClick = CheckBoxMasterDieMutinyClick
        end
        object EditMasterDieMutinyRate: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          Hint = #25968#23383#36234#23567#65292#21464#24322#26426#29575#36234#22823#12290
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMasterDieMutinyRateChange
        end
        object EditMasterDieMutinyPower: TSpinEdit
          Left = 72
          Top = 60
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMasterDieMutinyPowerChange
        end
        object EditMasterDieMutinySpeed: TSpinEdit
          Left = 72
          Top = 84
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMasterDieMutinySpeedChange
        end
      end
      object GroupBox47: TGroupBox
        Left = 302
        Top = 128
        Width = 137
        Height = 65
        Caption = #19971#24425#23453#23453
        TabOrder = 4
        object Label112: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #26102#38388#38388#38548':'
        end
        object CheckBoxBBMonAutoChangeColor: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Caption = #23453#23453#33258#21160#21464#33394
          TabOrder = 0
          OnClick = CheckBoxBBMonAutoChangeColorClick
        end
        object EditBBMonAutoChangeColorTime: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          Hint = #25968#23383#36234#23567#65292#21464#33394#36895#24230#36234#24555#65292#21333#20301'('#31186')'#12290
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 1
          TabOrder = 1
          Value = 100
          OnChange = EditBBMonAutoChangeColorTimeChange
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = #25216#33021#39764#27861
      ImageIndex = 1
      object PageControlSkill: TPageControl
        Left = 0
        Top = 0
        Width = 449
        Height = 273
        ActivePage = TabSheet4
        TabOrder = 0
        object TabSheet2: TTabSheet
          Caption = #22522#26412#21442#25968
          object Label212: TLabel
            Left = 8
            Top = 106
            Width = 150
            Height = 12
            Caption = #34880#39746#25216#33021#38388#38548':          '#31186
          end
          object Bevel2: TBevel
            Left = 8
            Top = 91
            Width = 422
            Height = 12
            Shape = bsTopLine
          end
          object Label213: TLabel
            Left = 192
            Top = 105
            Width = 144
            Height = 12
            Caption = #34880#39746'('#25112')'#23041#21147':          %'
          end
          object Label396: TLabel
            Left = 8
            Top = 129
            Width = 150
            Height = 12
            Caption = #21807#25105#29420#23562#38388#38548':          '#31186
          end
          object Label397: TLabel
            Left = 8
            Top = 152
            Width = 150
            Height = 12
            Caption = #21484#21796#24040#39764#23384#27963':          '#20998
          end
          object Label406: TLabel
            Left = 8
            Top = 175
            Width = 360
            Height = 12
            Caption = #31070#40857#38468#20307#25345#32493':          '#31186'  '#38388#38548'          '#31186'  '#23041#21147'          %'
          end
          object Label408: TLabel
            Left = 190
            Top = 152
            Width = 204
            Height = 12
            Caption = #32654#26460#33678#20043#30643#40635#30201#26368#38271#26102#38388'          '#31186
          end
          object GroupBox17: TGroupBox
            Left = 252
            Top = 8
            Width = 137
            Height = 71
            Caption = #39764#27861#25915#20987#33539#22260#38480#21046
            TabOrder = 0
            object Label12: TLabel
              Left = 8
              Top = 20
              Width = 54
              Height = 12
              Caption = #33539#22260#22823#23567':'
            end
            object EditMagicAttackRage: TSpinEdit
              Left = 66
              Top = 17
              Width = 53
              Height = 21
              Hint = #39764#27861#25915#20987#26377#25928#36317#31163#65292#36229#36807#25351#23450#36317#31163#25915#20987#26080#25928#12290
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMagicAttackRageChange
            end
            object cbLargeMagicRange: TCheckBox
              Left = 8
              Top = 48
              Width = 114
              Height = 17
              Hint = #38057#36873#27425#39033#65292#23558#25552#39640#39764#27861#20987#20013#31227#21160#20013#30340#30446#26631#30340#20960#29575#12290
              Caption = #25552#39640#39764#27861#31934#30830#24230
              TabOrder = 1
              OnClick = CheckBoxMagCanHitTargetClick
            end
          end
          object GroupBox75: TGroupBox
            Left = 8
            Top = 8
            Width = 227
            Height = 71
            Caption = #25216#33021#35774#32622
            TabOrder = 1
            object CheckBoxMagCanHitTarget: TCheckBox
              Left = 8
              Top = 14
              Width = 198
              Height = 17
              Hint = #25171#24320#27492#21151#33021#21518#65292#31867#20284#28789#39746#28779#31526#65292#28779#29699#26415#31561#23558#19981#20877#21463#23545#26041#31227#21160#36895#24230#24433#21709#32780#25171#19981#20013#12290
              Caption = #24573#30053#39764#27861#38556#30861'('#31227#21160#40736#26631#26597#30475#25552#31034')'
              TabOrder = 0
              OnClick = CheckBoxMagCanHitTargetClick
            end
            object CheckBoxIgnoreTagDefence: TCheckBox
              Left = 8
              Top = 31
              Width = 198
              Height = 17
              Hint = #26159#21542#20801#35768#21050#26432#12289#24320#22825#26025#12289#36880#26085#21073#27861#31561#23436#20840#24573#35270#23545#26041#30340#29289#29702#38450#24481#65292#40664#35748#20851#38381#12290
              Caption = #21050#26432#24573#35270#38450#24481'('#31227#21160#40736#26631#26597#30475#25552#31034')'
              TabOrder = 1
              OnClick = CheckBoxMagCanHitTargetClick
            end
            object CheckBoxIgnoreTagDefence2: TCheckBox
              Left = 8
              Top = 48
              Width = 214
              Height = 17
              Hint = #26159#21542#20801#35768#21050#26432#12289#24320#22825#26025#12289#36880#26085#21073#27861#31561#23436#20840#24573#35270#23545#26041#30340#39764#27861#30462#65292#40664#35748#20851#38381#12290
              Caption = #21050#26432#24573#35270#39764#27861#30462'('#31227#21160#40736#26631#26597#30475#25552#31034')'
              TabOrder = 2
              OnClick = CheckBoxMagCanHitTargetClick
            end
          end
          object seSuperSkillInvTime: TSpinEdit
            Left = 91
            Top = 101
            Width = 53
            Height = 21
            MaxValue = 5000
            MinValue = 1
            TabOrder = 2
            Value = 100
            OnChange = SpinEditFireHitPowerRateChange
          end
          object sePowerRate_115: TSpinEdit
            Left = 275
            Top = 100
            Width = 53
            Height = 21
            MaxValue = 5000
            MinValue = 1
            TabOrder = 3
            Value = 100
            OnChange = SpinEditFireHitPowerRateChange
          end
          object nSuperSkill68InvTime: TSpinEdit
            Left = 91
            Top = 124
            Width = 53
            Height = 21
            MaxValue = 5000
            MinValue = 1
            TabOrder = 4
            Value = 100
            OnChange = SpinEditFireHitPowerRateChange
          end
          object IceMonLiveTime: TSpinEdit
            Left = 91
            Top = 147
            Width = 53
            Height = 21
            MaxValue = 5000
            MinValue = 1
            TabOrder = 5
            Value = 100
            OnChange = SpinEditFireHitPowerRateChange
          end
          object Skill_68_MP: TCheckBox
            Left = 191
            Top = 127
            Width = 134
            Height = 17
            Caption = #20351#29992#21807#25105#29420#23562#28040#32791'MP'
            TabOrder = 6
            OnClick = CheckBoxMagCanHitTargetClick
          end
          object Skill77Time: TSpinEdit
            Left = 91
            Top = 170
            Width = 53
            Height = 21
            MaxValue = 5000
            MinValue = 1
            TabOrder = 7
            Value = 100
            OnChange = SpinEditFireHitPowerRateChange
          end
          object Skill77Inv: TSpinEdit
            Left = 198
            Top = 170
            Width = 53
            Height = 21
            MaxValue = 5000
            MinValue = 1
            TabOrder = 8
            Value = 100
            OnChange = SpinEditFireHitPowerRateChange
          end
          object SkillMedusaEyeEffectTimeMax: TSpinEdit
            Left = 325
            Top = 147
            Width = 53
            Height = 21
            MaxValue = 999
            MinValue = 1
            TabOrder = 9
            Value = 100
            OnChange = SpinEditFireHitPowerRateChange
          end
          object Skill77PowerRate: TSpinEdit
            Left = 305
            Top = 172
            Width = 53
            Height = 21
            MaxValue = 99999
            MinValue = 1
            TabOrder = 10
            Value = 100
            OnChange = SpinEditFireHitPowerRateChange
          end
        end
        object TabSheet3: TTabSheet
          Caption = #27494#22763#25216#33021
          ImageIndex = 1
          object PageControlMag_Warr: TPageControl
            Left = 0
            Top = 0
            Width = 441
            Height = 246
            ActivePage = TabSheet26
            Align = alClient
            TabOrder = 0
            object TabSheet48: TTabSheet
              Caption = #21050#26432#21073#27861
              object GroupBox10: TGroupBox
                Left = 8
                Top = 64
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label4: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label10: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditSwordLongPowerRate: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 1000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSwordLongPowerRateChange
                end
              end
              object GroupBox9: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #26080#38480#21050#26432
                TabOrder = 1
                object CheckBoxLimitSwordLong: TCheckBox
                  Left = 8
                  Top = 20
                  Width = 97
                  Height = 17
                  Hint = #25171#24320#27492#21151#33021#21518#65292#23558#26816#26597#26816#26597#38548#20301#26159#21542#26377#35282#33394#23384#22312#65292#20197#31105#27490#20992#20992#21050#26432#12290
                  Caption = #31105#27490#26080#38480#21050#26432
                  TabOrder = 0
                  OnClick = CheckBoxLimitSwordLongClick
                end
              end
            end
            object TabSheet5: TTabSheet
              Caption = #24443#22320#38025
              ImageIndex = 2
              object GroupBox51: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #26045#23637#38388#38548#26102#38388
                TabOrder = 0
                object Label59: TLabel
                  Left = 8
                  Top = 20
                  Width = 120
                  Height = 12
                  Caption = #26102#38388':           '#27627#31186
                end
                object SpinEditMagNailTime: TSpinEdit
                  Left = 40
                  Top = 15
                  Width = 57
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  Increment = 200
                  MaxValue = 50000
                  MinValue = 100
                  TabOrder = 0
                  Value = 100
                  OnChange = SpinEditMagNailTimeChange
                end
              end
              object GroupBox57: TGroupBox
                Left = 8
                Top = 64
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 1
                object Label123: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label124: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditMagNailPowerRate: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditMagNailPowerRateChange
                end
              end
            end
            object TabSheet49: TTabSheet
              Caption = #28872#28779#21073#27861
              ImageIndex = 1
              object GroupBox66: TGroupBox
                Left = 8
                Top = 8
                Width = 145
                Height = 73
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label134: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label135: TLabel
                  Left = 104
                  Top = 19
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object SpinEditFireHitPowerRate: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567#38500#20197'100'#20026#23454#38469#20493#25968#65292#40664#35748'100'#12290
                  MaxValue = 5000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = SpinEditFireHitPowerRateChange
                end
                object CheckBoxNoDoubleFireHit: TCheckBox
                  Left = 8
                  Top = 48
                  Width = 121
                  Height = 17
                  Hint = #25171#24320#27492#21151#33021#21518#65292#23558#31105#27490#22806#25346#30340#21452#20493#28872#28779#21073#27861#21151#33021#12290
                  Caption = #31105#27490#21452#20493#28872#28779#21073#27861
                  TabOrder = 1
                  OnClick = CheckBoxNoDoubleFireHitClick
                end
              end
            end
            object TabSheet26: TTabSheet
              Caption = #29422#23376#21564
              ImageIndex = 4
              object GroupBox48: TGroupBox
                Left = 8
                Top = 8
                Width = 113
                Height = 57
                Caption = #23545#20154#29289#25915#20987#26377#25928
                TabOrder = 0
                object CheckBoxGroupMbAttackPlayObject: TCheckBox
                  Left = 8
                  Top = 16
                  Width = 97
                  Height = 17
                  Hint = #25171#24320#27492#21151#33021#21518#65292#23601#21487#20197#40635#30201#20154#29289
                  Caption = #20801#35768#40635#30201#20154#29289
                  TabOrder = 0
                  OnClick = CheckBoxGroupMbAttackPlayObjectClick
                end
                object CheckBoxGroupMbAttackBaobao: TCheckBox
                  Left = 8
                  Top = 32
                  Width = 97
                  Height = 17
                  Hint = #25171#24320#27492#21151#33021#21518#65292#23601#21487#20197#40635#30201#23453#23453
                  Caption = #20801#35768#40635#30201#23453#23453
                  TabOrder = 1
                  OnClick = CheckBoxGroupMbAttackBaobaoClick
                end
              end
            end
            object TabSheet9: TTabSheet
              Caption = #25810#40857#25163
              ImageIndex = 3
              object GroupBox62: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #21442#25968#36873#39033
                TabOrder = 0
                object CheckBoxMagCapturePlayer: TCheckBox
                  Left = 8
                  Top = 20
                  Width = 97
                  Height = 17
                  Caption = #20801#35768#25235#33719#20154#29289
                  TabOrder = 0
                  OnClick = CheckBoxMagCapturePlayerClick
                end
              end
            end
            object TabSheet17: TTabSheet
              Caption = #36880#26085#21073#27861
              ImageIndex = 5
              object GroupBox76: TGroupBox
                Left = 8
                Top = 8
                Width = 153
                Height = 73
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label163: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label164: TLabel
                  Left = 104
                  Top = 19
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object SpinEditPursueHitPowerRate: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567#38500#20197'100'#20026#23454#38469#20493#25968#65292#40664#35748'100'#12290
                  MaxValue = 5000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = SpinEditFireHitPowerRateChange
                end
                object cbNoDoublePursueHit: TCheckBox
                  Left = 8
                  Top = 48
                  Width = 137
                  Height = 17
                  Hint = #25171#24320#27492#21151#33021#21518#65292#23558#31105#27490#22806#25346#30340#21452#20493#36880#26085#21073#27861#21151#33021#12290
                  Caption = #31105#27490#31215#32858#36830#32493#36880#26085#21073#27861
                  TabOrder = 1
                  OnClick = CheckBoxNoDoubleFireHitClick
                end
              end
            end
            object TabSheet51: TTabSheet
              Caption = #37326#34542#20914#25758
              ImageIndex = 7
              object Label214: TLabel
                Left = 17
                Top = 18
                Width = 126
                Height = 12
                Caption = #21345#20301#26102#38388':          '#31186
              end
              object seDoMotaeboPauseTime: TSpinEdit
                Left = 75
                Top = 14
                Width = 53
                Height = 21
                MaxValue = 5000
                MinValue = 1
                TabOrder = 0
                Value = 100
                OnChange = SpinEditFireHitPowerRateChange
              end
            end
            object TabSheet46: TTabSheet
              Caption = #20854#20182#25216#33021
              ImageIndex = 6
              object GroupBox56: TGroupBox
                Left = 8
                Top = 8
                Width = 416
                Height = 203
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label205: TLabel
                  Left = 9
                  Top = 45
                  Width = 126
                  Height = 12
                  Caption = #38647#38662#21073#27861':           %'
                end
                object Label204: TLabel
                  Left = 219
                  Top = 44
                  Width = 126
                  Height = 12
                  Caption = #40857#24433#21073#27861':           %'
                end
                object Label206: TLabel
                  Left = 9
                  Top = 85
                  Width = 126
                  Height = 12
                  Caption = #26029#31354#26025':             %'
                end
                object Bevel1: TBevel
                  Left = 9
                  Top = 70
                  Width = 396
                  Height = 12
                  Shape = bsTopLine
                end
                object Label217: TLabel
                  Left = 9
                  Top = 108
                  Width = 126
                  Height = 12
                  Caption = #24320#22825#26025':             %'
                end
                object seTwinPowerRate: TSpinEdit
                  Left = 69
                  Top = 41
                  Width = 53
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567#38500#20197'100'#20026#23454#38469#20493#25968#65292#40664#35748'100'#12290
                  MaxValue = 5000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = SpinEditFireHitPowerRateChange
                end
                object cbTDBeffect: TCheckBox
                  Left = 9
                  Top = 19
                  Width = 180
                  Height = 17
                  Caption = #20801#35768#38647#38662#21073#27861#40635#30201'('#34892#21160#32531#24930')'
                  TabOrder = 1
                  OnClick = CheckBoxNoDoubleFireHitClick
                end
                object seMagSquPowerRate: TSpinEdit
                  Left = 279
                  Top = 41
                  Width = 53
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567#38500#20197'100'#20026#23454#38469#20493#25968#65292#40664#35748'100'#12290
                  MaxValue = 5000
                  MinValue = 1
                  TabOrder = 2
                  Value = 100
                  OnChange = SpinEditFireHitPowerRateChange
                end
                object cbLimitSquAttack: TCheckBox
                  Left = 219
                  Top = 19
                  Width = 113
                  Height = 17
                  Caption = #31105#27490#20992#20992#40857#24433
                  TabOrder = 3
                  OnClick = CheckBoxNoDoubleFireHitClick
                end
                object seSmiteLongHit2PowerRate: TSpinEdit
                  Left = 69
                  Top = 82
                  Width = 53
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567#38500#20197'100'#20026#23454#38469#20493#25968#65292#40664#35748'100'#12290
                  MaxValue = 5000
                  MinValue = 1
                  TabOrder = 4
                  Value = 100
                  OnChange = SpinEditFireHitPowerRateChange
                end
                object seSquareHitPowerRate: TSpinEdit
                  Left = 69
                  Top = 105
                  Width = 53
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567#38500#20197'100'#20026#23454#38469#20493#25968#65292#40664#35748'100'#12290
                  MaxValue = 5000
                  MinValue = 1
                  TabOrder = 5
                  Value = 100
                  OnChange = SpinEditFireHitPowerRateChange
                end
              end
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = #27861#24072#25216#33021
          ImageIndex = 2
          object PageControlMag_Wizard: TPageControl
            Left = 0
            Top = 0
            Width = 441
            Height = 246
            ActivePage = TabSheet16
            Align = alClient
            TabOrder = 0
            object TabSheet6: TTabSheet
              Caption = #20912#21638#21742
              object GroupBox14: TGroupBox
                Left = 8
                Top = 8
                Width = 121
                Height = 49
                Caption = #25915#20987#33539#22260
                TabOrder = 0
                object Label8: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #33539#22260':'
                end
                object EditSnowWindRange: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = #39764#27861#25915#20987#33539#22260#21322#24452#12290
                  EditorEnabled = False
                  MaxValue = 12
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditSnowWindRangeChange
                end
              end
            end
            object TabSheet15: TTabSheet
              Caption = #29190#35010#28779#28976
              ImageIndex = 1
              object GroupBox13: TGroupBox
                Left = 8
                Top = 8
                Width = 121
                Height = 49
                Caption = #25915#20987#33539#22260
                TabOrder = 0
                object Label7: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #33539#22260':'
                end
                object EditFireBoomRage: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = #39764#27861#25915#20987#33539#22260#21322#24452#12290
                  EditorEnabled = False
                  MaxValue = 12
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditFireBoomRageChange
                end
              end
            end
            object TabSheet16: TTabSheet
              Caption = #28779#22681
              ImageIndex = 2
              object Label216: TLabel
                Left = 163
                Top = 19
                Width = 102
                Height = 12
                Caption = #26368#38271#25345#20037#26102#38388'( '#31186')'
              end
              object GroupBox46: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #23433#20840#21306#31105#27490#28779#22681
                TabOrder = 0
                object CheckBoxFireCrossInSafeZone: TCheckBox
                  Left = 8
                  Top = 16
                  Width = 97
                  Height = 17
                  Hint = #25171#24320#27492#21151#33021#21518#65292#22312#23433#20840#21306#19981#20801#35768#25918#28779#22681#12290
                  Caption = #31105#27490#28779#22681
                  TabOrder = 0
                  OnClick = CheckBoxFireCrossInSafeZoneClick
                end
              end
              object GroupBox61: TGroupBox
                Left = 8
                Top = 64
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 1
                object Label126: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label127: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditEarthFirePowerRate: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 1000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditEarthFirePowerRateChange
                end
              end
              object seShieldHoldTime: TSpinEdit
                Left = 271
                Top = 14
                Width = 67
                Height = 21
                EditorEnabled = False
                MaxValue = 65535
                MinValue = 1
                TabOrder = 2
                Value = 1
                OnChange = EditMagTurnUndeadLevelChange
              end
            end
            object TabSheet12: TTabSheet
              Caption = #22307#35328#26415
              ImageIndex = 3
              object GroupBox37: TGroupBox
                Left = 8
                Top = 8
                Width = 121
                Height = 49
                Caption = #24618#29289#31561#32423#38480#21046
                TabOrder = 0
                object Label97: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #31561#32423':'
                end
                object EditMagTurnUndeadLevel: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = #25351#23450#31561#32423#20197#19979#30340#24618#29289#25165#20250#34987#22307#35328#65292#25351#23450#31561#32423#20197#19978#30340#24618#29289#22307#35328#26080#25928#12290
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditMagTurnUndeadLevelChange
                end
              end
            end
            object TabSheet19: TTabSheet
              Caption = #22320#29425#38647#20809
              ImageIndex = 4
              object GroupBox15: TGroupBox
                Left = 8
                Top = 8
                Width = 121
                Height = 49
                Caption = #25915#20987#33539#22260
                TabOrder = 0
                object Label9: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #33539#22260':'
                end
                object EditElecBlizzardRange: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = #39764#27861#25915#20987#33539#22260#21322#24452#12290
                  EditorEnabled = False
                  MaxValue = 12
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditElecBlizzardRangeChange
                end
              end
            end
            object TabSheet20: TTabSheet
              Caption = #35825#24785#20043#20809
              ImageIndex = 5
              object GroupBox45: TGroupBox
                Left = 136
                Top = 8
                Width = 121
                Height = 49
                Caption = #35825#24785#25968#37327
                TabOrder = 0
                object Label111: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #25968#37327':'
                end
                object EditTammingCount: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = #21487#35825#24785#24618#29289#25968#37327#12290
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditTammingCountChange
                end
              end
              object GroupBox38: TGroupBox
                Left = 8
                Top = 8
                Width = 121
                Height = 49
                Caption = #24618#29289#31561#32423#38480#21046
                TabOrder = 1
                object Label98: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #31561#32423':'
                end
                object EditMagTammingLevel: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = #25351#23450#31561#32423#20197#19979#30340#24618#29289#25165#20250#34987#35825#24785#65292#25351#23450#31561#32423#20197#19978#30340#24618#29289#35825#24785#26080#25928#12290
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditMagTammingLevelChange
                end
              end
              object GroupBox39: TGroupBox
                Left = 8
                Top = 64
                Width = 121
                Height = 73
                Caption = #35825#24785#26426#29575
                TabOrder = 2
                object Label99: TLabel
                  Left = 8
                  Top = 20
                  Width = 54
                  Height = 12
                  Caption = #24618#29289#31561#32423':'
                end
                object Label100: TLabel
                  Left = 8
                  Top = 44
                  Width = 54
                  Height = 12
                  Caption = #24618#29289#34880#37327':'
                end
                object EditMagTammingTargetLevel: TSpinEdit
                  Left = 64
                  Top = 15
                  Width = 41
                  Height = 21
                  Hint = #24618#29289#31561#32423#27604#29575#65292#27492#25968#23383#36234#23567#26426#29575#36234#22823#12290
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditMagTammingTargetLevelChange
                end
                object EditMagTammingHPRate: TSpinEdit
                  Left = 64
                  Top = 39
                  Width = 41
                  Height = 21
                  Hint = #24618#29289#34880#37327#27604#29575#65292#27492#25968#23383#36234#22823#65292#26426#29575#36234#22823#12290
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 1
                  Value = 1
                  OnChange = EditMagTammingHPRateChange
                end
              end
            end
            object TabSheet8: TTabSheet
              Caption = #23506#20912#25484
              ImageIndex = 6
              object GroupBox60: TGroupBox
                Left = 8
                Top = 8
                Width = 121
                Height = 49
                Caption = #25512#20154#20960#29575
                TabOrder = 0
                object Label125: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #25968#37327':'
                end
                object EditMagIceBallRange: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = #21487#35825#24785#24618#29289#25968#37327#12290
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditMagIceBallRangeChange
                end
              end
            end
            object TabSheet27: TTabSheet
              Caption = #27969#26143#28779#38632
              ImageIndex = 7
              object GroupBox78: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label171: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label172: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object seMagicShootingStarPowerRate: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 1000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditEarthFirePowerRateChange
                end
              end
            end
            object TabSheet36: TTabSheet
              Caption = #39764#27861#30462
              ImageIndex = 8
              object Label184: TLabel
                Left = 8
                Top = 24
                Width = 108
                Height = 12
                Caption = #38450#24481#24378#24230'('#24314#35758#20540'8):'
              end
              object SpinEditMagBubbleDefenceRate: TSpinEdit
                Left = 116
                Top = 19
                Width = 47
                Height = 21
                Hint = #25968#23383#36234#22823#65292#38450#24481#24378#24230#36234#22909#65292#21363#21560#25910#20260#23475#36234#22810#65292#40664#35748'10'#65292#24314#35758'5'#12290
                EditorEnabled = False
                MaxValue = 65535
                MinValue = 1
                TabOrder = 0
                Value = 1
                OnChange = EditMagTurnUndeadLevelChange
              end
            end
          end
        end
        object TabSheet47: TTabSheet
          Caption = #36947#22763#25216#33021
          ImageIndex = 3
          object PageControlMag_Taos: TPageControl
            Left = 0
            Top = 0
            Width = 441
            Height = 246
            ActivePage = TabSheet63
            Align = alClient
            TabOrder = 0
            object TabSheet11: TTabSheet
              Caption = #21484#21796#39607#39621
              object GroupBox6: TGroupBox
                Left = 144
                Top = 8
                Width = 281
                Height = 135
                Caption = #39640#32423#35774#32622
                TabOrder = 0
                object GridBoneFamm: TStringGrid
                  Left = 8
                  Top = 16
                  Width = 265
                  Height = 113
                  ColCount = 4
                  DefaultRowHeight = 18
                  FixedCols = 0
                  RowCount = 11
                  Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
                  TabOrder = 0
                  OnSetEditText = GridBoneFammSetEditText
                  ColWidths = (
                    55
                    76
                    57
                    52)
                end
              end
              object GroupBox5: TGroupBox
                Left = 8
                Top = 8
                Width = 129
                Height = 135
                Caption = #22522#26412#35774#32622
                TabOrder = 1
                object Label2: TLabel
                  Left = 8
                  Top = 18
                  Width = 54
                  Height = 12
                  Caption = #24618#29289#21517#31216':'
                end
                object Label3: TLabel
                  Left = 8
                  Top = 58
                  Width = 54
                  Height = 12
                  Caption = #21484#21796#25968#37327':'
                end
                object Label198: TLabel
                  Left = 8
                  Top = 86
                  Width = 114
                  Height = 12
                  Caption = #20027#20154#36947#26415#22686#21152#20854#25915#20987':'
                end
                object EditBoneFammName: TEdit
                  Left = 8
                  Top = 32
                  Width = 113
                  Height = 20
                  Hint = #35774#32622#40664#35748#21484#21796#30340#24618#29289#21517#31216#12290
                  ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                  TabOrder = 0
                  OnChange = EditBoneFammNameChange
                end
                object EditBoneFammCount: TSpinEdit
                  Left = 68
                  Top = 55
                  Width = 53
                  Height = 21
                  Hint = #35774#32622#21487#21484#21796#26368#22823#25968#37327#12290
                  EditorEnabled = False
                  MaxValue = 255
                  MinValue = 1
                  TabOrder = 1
                  Value = 10
                  OnChange = EditBoneFammCountChange
                end
                object seBoneFammDcEx: TSpinEdit
                  Left = 68
                  Top = 102
                  Width = 53
                  Height = 21
                  Hint = #20540#38750'0'#26102#25915#20987#19982#20027#20154#36947#26415#26377#20851#65292#25968#23383#36234#22823#65292#25915#20987#36234#39640#65292#40664#35748'0'#65292#24314#35758'20~60'#12290
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 0
                  TabOrder = 2
                  Value = 10
                  OnChange = EditBoneFammCountChange
                end
              end
            end
            object TabSheet23: TTabSheet
              Caption = #21484#21796#31070#20861
              ImageIndex = 1
              object GroupBox12: TGroupBox
                Left = 144
                Top = 8
                Width = 281
                Height = 135
                Caption = #39640#32423#35774#32622
                TabOrder = 0
                object GridDogz: TStringGrid
                  Left = 8
                  Top = 16
                  Width = 265
                  Height = 113
                  ColCount = 4
                  DefaultRowHeight = 18
                  FixedCols = 0
                  RowCount = 11
                  Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
                  TabOrder = 0
                  OnSetEditText = GridBoneFammSetEditText
                  ColWidths = (
                    55
                    76
                    57
                    52)
                end
              end
              object GroupBox11: TGroupBox
                Left = 8
                Top = 8
                Width = 129
                Height = 135
                Caption = #22522#26412#35774#32622
                TabOrder = 1
                object Label5: TLabel
                  Left = 8
                  Top = 18
                  Width = 54
                  Height = 12
                  Caption = #24618#29289#21517#31216':'
                end
                object Label6: TLabel
                  Left = 8
                  Top = 58
                  Width = 54
                  Height = 12
                  Caption = #21484#21796#25968#37327':'
                end
                object Label200: TLabel
                  Left = 8
                  Top = 86
                  Width = 114
                  Height = 12
                  Caption = #20027#20154#36947#26415#22686#21152#20854#25915#20987':'
                end
                object EditDogzName: TEdit
                  Left = 8
                  Top = 32
                  Width = 113
                  Height = 20
                  Hint = #35774#32622#40664#35748#21484#21796#30340#24618#29289#21517#31216#12290
                  ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                  TabOrder = 0
                  OnChange = EditDogzNameChange
                end
                object EditDogzCount: TSpinEdit
                  Left = 68
                  Top = 55
                  Width = 53
                  Height = 21
                  Hint = #35774#32622#21487#21484#21796#26368#22823#25968#37327#12290
                  EditorEnabled = False
                  MaxValue = 255
                  MinValue = 1
                  TabOrder = 1
                  Value = 10
                  OnChange = EditDogzCountChange
                end
                object seDogzDcEx: TSpinEdit
                  Left = 68
                  Top = 102
                  Width = 53
                  Height = 21
                  Hint = #20540#38750'0'#26102#25915#20987#19982#20027#20154#36947#26415#26377#20851#65292#25968#23383#36234#22823#65292#25915#20987#36234#39640#65292#40664#35748'0'#65292#24314#35758'20~60'#12290
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 0
                  TabOrder = 2
                  Value = 10
                  OnChange = EditBoneFammCountChange
                end
              end
            end
            object TabSheet44: TTabSheet
              Caption = #21484#21796#26376#28789
              ImageIndex = 5
              object Label201: TLabel
                Left = 12
                Top = 16
                Width = 114
                Height = 12
                Caption = #20027#20154#36947#26415#22686#21152#20854#25915#20987':'
              end
              object seAngelDcEx: TSpinEdit
                Left = 129
                Top = 13
                Width = 53
                Height = 21
                Hint = #20540#38750'0'#26102#25915#20987#19982#20027#20154#36947#26415#26377#20851#65292#25968#23383#36234#22823#65292#25915#20987#36234#39640#65292#40664#35748'0'#65292#24314#35758'20~60'#12290
                EditorEnabled = False
                MaxValue = 9999
                MinValue = 0
                TabOrder = 0
                Value = 10
                OnChange = EditBoneFammCountChange
              end
            end
            object TabSheet30: TTabSheet
              Caption = #28779#28976#20912
              ImageIndex = 2
              object GroupBox42: TGroupBox
                Left = 8
                Top = 88
                Width = 137
                Height = 49
                Caption = #40635#30201#21629#20013#26426#29575
                TabOrder = 0
                object Label103: TLabel
                  Left = 8
                  Top = 18
                  Width = 54
                  Height = 12
                  Caption = #21629#20013#26426#29575':'
                end
                object EditMabMabeHitSucessRate: TSpinEdit
                  Left = 68
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = #25915#20987#40635#30201#26426#29575#65292#26368#23567#38480#21046#65292#25968#23383#36234#23567#26426#29575#36234#20302#12290
                  EditorEnabled = False
                  MaxValue = 20
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = EditMabMabeHitSucessRateChange
                end
              end
              object GroupBox43: TGroupBox
                Left = 152
                Top = 8
                Width = 137
                Height = 49
                Caption = #40635#30201#26102#38388#21442#25968#20493#29575
                TabOrder = 1
                object Label104: TLabel
                  Left = 8
                  Top = 18
                  Width = 54
                  Height = 12
                  Caption = #21629#20013#26426#29575':'
                end
                object EditMabMabeHitMabeTimeRate: TSpinEdit
                  Left = 68
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = #40635#30201#26102#38388#38271#24230#20493#29575#65292#22522#25968#19982#35282#33394#30340#39764#27861#26377#20851#12290
                  EditorEnabled = False
                  MaxValue = 20
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = EditMabMabeHitMabeTimeRateChange
                end
              end
              object GroupBox41: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 73
                Caption = #35282#33394#31561#32423#26426#29575#35774#32622
                TabOrder = 2
                object Label101: TLabel
                  Left = 8
                  Top = 18
                  Width = 54
                  Height = 12
                  Caption = #30456#24046#26426#29575':'
                end
                object Label102: TLabel
                  Left = 8
                  Top = 42
                  Width = 54
                  Height = 12
                  Caption = #30456#24046#38480#21046':'
                end
                object EditMabMabeHitRandRate: TSpinEdit
                  Left = 68
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = #25915#20987#34987#25915#20987#21452#26041#30456#24046#31561#32423#21629#20013#26426#29575#65292#25968#23383#36234#22823#26426#29575#36234#23567#12290
                  EditorEnabled = False
                  MaxValue = 20
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = EditMabMabeHitRandRateChange
                end
                object EditMabMabeHitMinLvLimit: TSpinEdit
                  Left = 68
                  Top = 39
                  Width = 53
                  Height = 21
                  Hint = #25915#20987#34987#25915#20987#21452#26041#30456#24046#31561#32423#21629#20013#26426#29575#65292#26368#23567#38480#21046#65292#25968#23383#36234#23567#26426#29575#36234#20302#12290
                  EditorEnabled = False
                  MaxValue = 20
                  MinValue = 1
                  TabOrder = 1
                  Value = 10
                  OnChange = EditMabMabeHitMinLvLimitChange
                end
              end
            end
            object TabSheet32: TTabSheet
              Caption = #20998#36523#26415
              ImageIndex = 4
              object Label115: TLabel
                Left = 232
                Top = 18
                Width = 54
                Height = 12
                Caption = #24618#29289#21517#31216':'
                Visible = False
              end
              object EditBody: TEdit
                Left = 232
                Top = 32
                Width = 113
                Height = 20
                Hint = #35774#32622#40664#35748#21484#21796#30340#20998#36523#24618#29289#21517#31216#65288#27880#24847#35813#24618#29289#22312'DB'#20013#65292'RACE=60'#65289#12290
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 0
                Visible = False
                OnChange = EditBoneFammNameChange
              end
              object GroupBox50: TGroupBox
                Left = 8
                Top = 8
                Width = 148
                Height = 71
                Caption = #22522#26412#35774#32622
                TabOrder = 1
                object Label116: TLabel
                  Left = 8
                  Top = 18
                  Width = 54
                  Height = 12
                  Caption = #21484#21796#25968#37327':'
                end
                object SpinEditBodyCount: TSpinEdit
                  Left = 68
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = #35774#32622#21487#21484#21796#26368#22823#25968#37327#12290
                  EditorEnabled = False
                  MaxValue = 255
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = SpinEditBodyCountChange
                end
                object CheckBoxAllowMakeSlave: TCheckBox
                  Left = 8
                  Top = 40
                  Width = 121
                  Height = 17
                  Caption = #20801#35768#20998#36523#21484#21796#23453#23453
                  TabOrder = 1
                  OnClick = CheckBoxAllowMakeSlaveClick
                end
              end
            end
            object TabSheet31: TTabSheet
              Caption = #26045#27602#26415
              ImageIndex = 5
              object GroupBox16: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 45
                Caption = #27602#33647#38477#28857
                TabOrder = 0
                object Label11: TLabel
                  Left = 8
                  Top = 18
                  Width = 54
                  Height = 12
                  Caption = #28857#25968#25511#21046':'
                end
                object EditAmyOunsulPoint: TSpinEdit
                  Left = 68
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = #20013#27602#21518#25351#23450#26102#38388#20869#38477#28857#25968#65292#23454#38469#28857#25968#36319#25216#33021#31561#32423#21450#26412#36523#36947#26415#39640#20302#26377#20851#65292#27492#21442#25968#21482#26159#35843#20854#20013#31639#27861#21442#25968#65292#27492#25968#23383#36234#23567#65292#28857#25968#36234#22823#12290
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = EditAmyOunsulPointChange
                end
              end
            end
            object TabSheet45: TTabSheet
              Caption = #22124#34880#26415
              ImageIndex = 6
              object Label202: TLabel
                Left = 12
                Top = 16
                Width = 54
                Height = 12
                Caption = #21560#34880#27604#20363':'
              end
              object Label203: TLabel
                Left = 12
                Top = 40
                Width = 54
                Height = 12
                Caption = #23041#21147#27604#20363':'
              end
              object seMagSuckHpRate: TSpinEdit
                Left = 68
                Top = 13
                Width = 53
                Height = 21
                Hint = #25968#23383#36234#22823#65292#21560#25910'HP'#36234#22810#65292#40664#35748'100'#12290
                EditorEnabled = False
                MaxValue = 9999
                MinValue = 1
                TabOrder = 0
                Value = 10
                OnChange = EditBoneFammCountChange
              end
              object seMagSuckHpPowerRate: TSpinEdit
                Left = 68
                Top = 37
                Width = 53
                Height = 21
                Hint = #25968#23383#36234#22823#65292#21560#25910'HP'#36234#22810#65292#40664#35748'100'#12290
                EditorEnabled = False
                MaxValue = 9999
                MinValue = 1
                TabOrder = 1
                Value = 10
                OnChange = EditBoneFammCountChange
              end
            end
            object TabSheet50: TTabSheet
              Caption = #26080#26497#30495#27668
              ImageIndex = 7
              object Label210: TLabel
                Left = 12
                Top = 16
                Width = 78
                Height = 12
                Caption = #22686#21152#36947#26415#27604#20363':'
              end
              object Label215: TLabel
                Left = 12
                Top = 39
                Width = 150
                Height = 12
                Caption = #37322#25918#38388#38548#26102#38388':          '#31186
              end
              object seDoubleScRate: TSpinEdit
                Left = 92
                Top = 13
                Width = 53
                Height = 21
                Hint = #40664#35748'100'#65292#25968#23383#36234#22823#22686#21152#36234#22810#12290
                EditorEnabled = False
                MaxValue = 9999
                MinValue = 1
                TabOrder = 0
                Value = 10
                OnChange = EditBoneFammCountChange
              end
              object seDoubleScInvTime: TSpinEdit
                Left = 92
                Top = 36
                Width = 53
                Height = 21
                Hint = #40664#35748'100'#65292#25968#23383#36234#22823#22686#21152#36234#22810#12290
                EditorEnabled = False
                MaxValue = 9999
                MinValue = 1
                TabOrder = 1
                Value = 10
                OnChange = EditBoneFammCountChange
              end
            end
            object TabSheet63: TTabSheet
              Caption = #27835#24840#26415'/'#32676#20307#27835#24840#26415
              ImageIndex = 8
              object Label439: TLabel
                Left = 16
                Top = 17
                Width = 66
                Height = 12
                Caption = #34917#20914'HP'#36895#29575':'
              end
              object EditHealingRate: TSpinEdit
                Left = 87
                Top = 14
                Width = 41
                Height = 21
                Hint = #36947#22763#27835#24840#25216#33021#30340#21152'HP/MP'#36895#29575#65292#25968#23383#36234#22823#65292#34917#20805'HP'#36895#29575#36234#24555#65292#40664#35748#20026'5'#12290
                EditorEnabled = False
                MaxValue = 999
                MinValue = 1
                TabOrder = 0
                Value = 99
                OnChange = EditCordialAddHPMaxChange
              end
            end
          end
        end
        object TabSheet10: TTabSheet
          Caption = #21512#20987#25216#33021
          ImageIndex = 4
          object PageControlJointAttack: TPageControl
            Left = 0
            Top = 0
            Width = 441
            Height = 246
            ActivePage = TabSheet24
            Align = alClient
            TabOrder = 0
            object TabSheet25: TTabSheet
              Caption = #22522#26412#35774#32622
              ImageIndex = 6
              object GroupBox73: TGroupBox
                Left = 8
                Top = 64
                Width = 137
                Height = 49
                Caption = #34917#20805#24594#27668#20540#20493#25968
                TabOrder = 0
                object Label155: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label156: TLabel
                  Left = 96
                  Top = 20
                  Width = 18
                  Height = 12
                  Caption = '/10'
                end
                object EditEnergyStepUpRate: TSpinEdit
                  Left = 44
                  Top = 16
                  Width = 45
                  Height = 21
                  Hint = #34917#20805#24594#27668#20540#65292#25968#23383#22823#23567#38500#20197'10'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 1000
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = EditSkillWWPowerRateChange
                end
              end
              object GroupBox74: TGroupBox
                Left = 8
                Top = 9
                Width = 137
                Height = 49
                Caption = #24320#25918#33521#38596#21512#20987
                TabOrder = 1
                object CheckBoxAllowJointAttack: TCheckBox
                  Left = 8
                  Top = 20
                  Width = 121
                  Height = 17
                  Hint = #25171#24320#27492#21151#33021#21518#65292#23558#20801#35768#26381#21153#22120#20351#29992#33521#38596#21512#20987#21151#33021#12290
                  Caption = #20801#35768#20351#29992#33521#38596#21512#20987
                  TabOrder = 0
                  OnClick = CheckBoxAllowJointAttackClick
                end
              end
            end
            object TabSheet13: TTabSheet
              Caption = #30772#39746#26025
              object GroupBox67: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label143: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label144: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditSkillWWPowerRate: TSpinEdit
                  Left = 44
                  Top = 16
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 9000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSkillWWPowerRateChange
                end
              end
            end
            object TabSheet14: TTabSheet
              Caption = #21128#26143#26025
              ImageIndex = 1
              object GroupBox68: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label145: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label146: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditSkillTWPowerRate: TSpinEdit
                  Left = 44
                  Top = 16
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 9000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSkillWWPowerRateChange
                end
              end
            end
            object TabSheet18: TTabSheet
              Caption = #38647#38662#19968#20987
              ImageIndex = 2
              object GroupBox69: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label147: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label148: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditSkillZWPowerRate: TSpinEdit
                  Left = 44
                  Top = 16
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 9000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSkillWWPowerRateChange
                end
              end
            end
            object TabSheet21: TTabSheet
              Caption = #22124#39746#27836#27901
              ImageIndex = 3
              object GroupBox70: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label149: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label150: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditSkillTTPowerRate: TSpinEdit
                  Left = 44
                  Top = 16
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 9000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSkillWWPowerRateChange
                end
              end
            end
            object TabSheet22: TTabSheet
              Caption = #26411#26085#23457#21028
              ImageIndex = 4
              object GroupBox71: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label151: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label152: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditSkillZTPowerRate: TSpinEdit
                  Left = 44
                  Top = 16
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 9000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSkillWWPowerRateChange
                end
              end
            end
            object TabSheet24: TTabSheet
              Caption = #28779#40857#27668#28976
              ImageIndex = 5
              object GroupBox72: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = #25915#20987#21147#20493#25968
                TabOrder = 0
                object Label153: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = #20493#25968':'
                end
                object Label154: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditSkillZZPowerRate: TSpinEdit
                  Left = 44
                  Top = 16
                  Width = 45
                  Height = 21
                  Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
                  EditorEnabled = False
                  MaxValue = 9000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSkillWWPowerRateChange
                end
              end
            end
          end
        end
        object TabSheet41: TTabSheet
          Caption = #20854#20182#35774#32622
          ImageIndex = 5
          object PageControl2: TPageControl
            Left = 0
            Top = 0
            Width = 441
            Height = 246
            ActivePage = TabSheet43
            Align = alClient
            TabOrder = 0
            Visible = False
            object TabSheet43: TTabSheet
              Caption = #36830#20987#25216#33021
              ImageIndex = 6
              object Label185: TLabel
                Left = 12
                Top = 14
                Width = 138
                Height = 12
                Caption = #37322#25918#38388#38548#26102#38388':        '#31186
              end
              object Label207: TLabel
                Left = 12
                Top = 38
                Width = 138
                Height = 12
                Caption = #25112#25216#23553#38145#20960#29575':        '#31186
              end
              object speSeriesSkillReleaseInvTime: TSpinEdit
                Left = 91
                Top = 10
                Width = 45
                Height = 21
                Hint = 'Series skill release interval time.'
                EditorEnabled = False
                MaxValue = 1000
                MinValue = 12
                TabOrder = 0
                Value = 12
                OnChange = EditSkillWWPowerRateChange
              end
              object GroupBox80: TGroupBox
                Left = 9
                Top = 60
                Width = 417
                Height = 120
                Caption = #23041#21147#35843#33410
                TabOrder = 1
                object Label186: TLabel
                  Left = 8
                  Top = 21
                  Width = 108
                  Height = 12
                  Caption = #36861#24515#21050':          %'
                end
                object Label187: TLabel
                  Left = 8
                  Top = 45
                  Width = 108
                  Height = 12
                  Caption = #19977#32477#26432':          %'
                end
                object Label188: TLabel
                  Left = 9
                  Top = 69
                  Width = 108
                  Height = 12
                  Caption = #26029#23731#26025':          %'
                end
                object Label189: TLabel
                  Left = 8
                  Top = 93
                  Width = 108
                  Height = 12
                  Caption = #27178#25195#21315#20891':        %'
                end
                object Label190: TLabel
                  Left = 147
                  Top = 69
                  Width = 108
                  Height = 12
                  Caption = #20912#22825#38634#22320':        %'
                end
                object Label191: TLabel
                  Left = 146
                  Top = 93
                  Width = 108
                  Height = 12
                  Caption = #21452#40857#30772':          %'
                end
                object Label192: TLabel
                  Left = 146
                  Top = 45
                  Width = 108
                  Height = 12
                  Caption = #24778#38647#29190':          %'
                end
                object Label193: TLabel
                  Left = 146
                  Top = 21
                  Width = 108
                  Height = 12
                  Caption = #20964#33310#31085':          %'
                end
                object Label194: TLabel
                  Left = 287
                  Top = 69
                  Width = 108
                  Height = 12
                  Caption = #19977#28976#21650':          %'
                end
                object Label195: TLabel
                  Left = 286
                  Top = 93
                  Width = 108
                  Height = 12
                  Caption = #19975#21073#24402#23447':        %'
                end
                object Label196: TLabel
                  Left = 286
                  Top = 45
                  Width = 108
                  Height = 12
                  Caption = #20843#21350#25484':          %'
                end
                object Label197: TLabel
                  Left = 286
                  Top = 21
                  Width = 108
                  Height = 12
                  Caption = #34382#21880#35776':          %'
                end
                object spePowerRateOfSeriesSkill_100: TSpinEdit
                  Left = 63
                  Top = 18
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 0
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_101: TSpinEdit
                  Left = 63
                  Top = 41
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 1
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_102: TSpinEdit
                  Left = 63
                  Top = 65
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 2
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_103: TSpinEdit
                  Left = 63
                  Top = 89
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 3
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_104: TSpinEdit
                  Left = 201
                  Top = 17
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 4
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_105: TSpinEdit
                  Left = 201
                  Top = 41
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 5
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_106: TSpinEdit
                  Left = 201
                  Top = 65
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 6
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_107: TSpinEdit
                  Left = 201
                  Top = 89
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 7
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_108: TSpinEdit
                  Left = 341
                  Top = 17
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 8
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_109: TSpinEdit
                  Left = 341
                  Top = 41
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 9
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_110: TSpinEdit
                  Left = 341
                  Top = 65
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 10
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object spePowerRateOfSeriesSkill_111: TSpinEdit
                  Left = 341
                  Top = 89
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 11
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
              end
              object seSSFreezeRate: TSpinEdit
                Left = 91
                Top = 34
                Width = 45
                Height = 21
                Hint = #35774#32622#34987#25112#22763#36830#20987#25171#20013#30340#29305#25928'('#23558#19981#33021#31227#21160','#39764#27861')'#30340#20960#29575','#40664#35748'100'
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 2
                Value = 12
                OnChange = EditSkillWWPowerRateChange
              end
            end
            object TabSheet62: TTabSheet
              Caption = #39640#32423#25216#33021'1'
              ImageIndex = 1
              object GroupBox87: TGroupBox
                Left = 5
                Top = 8
                Width = 137
                Height = 104
                Caption = #21313#27493#19968#26432
                TabOrder = 0
                object Label407: TLabel
                  Left = 8
                  Top = 21
                  Width = 108
                  Height = 12
                  Caption = #23041#21147':            %'
                end
                object Label431: TLabel
                  Left = 8
                  Top = 44
                  Width = 114
                  Height = 12
                  Caption = #38388#38548#26102#38388':        '#31186
                end
                object sePosMoveAttackPowerRate: TSpinEdit
                  Left = 63
                  Top = 18
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 0
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
                object cbPosMoveAttackParalysisPlayer: TCheckBox
                  Left = 8
                  Top = 64
                  Width = 77
                  Height = 17
                  Caption = #40635#30201#20154#29289
                  TabOrder = 1
                  OnClick = cbPosMoveAttackParalysisPlayerClick
                end
                object sePosMoveAttackInterval: TSpinEdit
                  Left = 63
                  Top = 41
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 2
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
                object cbPosMoveAttackOnItem: TCheckBox
                  Left = 8
                  Top = 82
                  Width = 109
                  Height = 17
                  Caption = #20801#35768#39134#21040#29289#21697#19978
                  TabOrder = 3
                  OnClick = cbPosMoveAttackParalysisPlayerClick
                end
              end
              object GroupBox88: TGroupBox
                Left = 148
                Top = 8
                Width = 137
                Height = 90
                Caption = #20912#38684#32676#38632
                TabOrder = 1
                object Label432: TLabel
                  Left = 8
                  Top = 21
                  Width = 108
                  Height = 12
                  Caption = #23041#21147':            %'
                end
                object Label433: TLabel
                  Left = 8
                  Top = 44
                  Width = 114
                  Height = 12
                  Caption = #38388#38548#26102#38388':        '#31186
                end
                object seMagicIceRainPowerRate: TSpinEdit
                  Left = 63
                  Top = 18
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 0
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
                object cbMagicIceRainParalysisPlayer: TCheckBox
                  Left = 8
                  Top = 64
                  Width = 77
                  Height = 17
                  Caption = #40635#30201#20154#29289
                  TabOrder = 1
                  OnClick = cbPosMoveAttackParalysisPlayerClick
                end
                object seMagicIceRainInterval: TSpinEdit
                  Left = 63
                  Top = 41
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 2
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
              end
              object GroupBox89: TGroupBox
                Left = 290
                Top = 8
                Width = 137
                Height = 201
                Caption = #27515#20129#20043#30524
                TabOrder = 2
                object Label434: TLabel
                  Left = 8
                  Top = 21
                  Width = 108
                  Height = 12
                  Caption = #23041#21147':            %'
                end
                object Label435: TLabel
                  Left = 8
                  Top = 44
                  Width = 114
                  Height = 12
                  Caption = #38388#38548#26102#38388':        '#31186
                end
                object seMagicDeadEyePowerRate: TSpinEdit
                  Left = 63
                  Top = 18
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 0
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
                object cbMagicDeadEyeParalysisPlayer: TCheckBox
                  Left = 8
                  Top = 64
                  Width = 77
                  Height = 17
                  Caption = #40635#30201#20154#29289
                  TabOrder = 1
                  OnClick = cbPosMoveAttackParalysisPlayerClick
                end
                object seMagicDeadEyeInterval: TSpinEdit
                  Left = 63
                  Top = 41
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 2
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
                object chkMagicDeadEyeGreenPosion: TCheckBox
                  Left = 8
                  Top = 85
                  Width = 77
                  Height = 17
                  Caption = #30446#26631#20013#32511#27602
                  TabOrder = 3
                  OnClick = cbPosMoveAttackParalysisPlayerClick
                end
                object chkMagicDeadEyeRedPosion: TCheckBox
                  Left = 8
                  Top = 107
                  Width = 77
                  Height = 17
                  Caption = #30446#26631#20013#32418#27602
                  TabOrder = 4
                  OnClick = cbPosMoveAttackParalysisPlayerClick
                end
              end
              object GroupBox81: TGroupBox
                Left = 5
                Top = 119
                Width = 137
                Height = 90
                Caption = #20506#22825#36767#22320
                TabOrder = 3
                object Label208: TLabel
                  Left = 6
                  Top = 42
                  Width = 90
                  Height = 12
                  Caption = #23041#21147':         %'
                end
                object Label209: TLabel
                  Left = 6
                  Top = 20
                  Width = 120
                  Height = 12
                  Caption = #38388#38548#26102#38388':         '#31186
                end
                object spePowerRateOfSeriesSkill_114: TSpinEdit
                  Left = 63
                  Top = 40
                  Width = 45
                  Height = 21
                  Hint = #25216#33021#23041#21147
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 0
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object speSmiteWideHitSkillInvTime: TSpinEdit
                  Left = 63
                  Top = 17
                  Width = 45
                  Height = 21
                  MaxValue = 9999999
                  MinValue = 10
                  TabOrder = 1
                  Value = 12
                  OnChange = EditSkillWWPowerRateChange
                end
                object cbSkill_114_MP: TCheckBox
                  Left = 7
                  Top = 62
                  Width = 121
                  Height = 17
                  Caption = #20351#29992'MP'#37322#25918#25216#33021
                  TabOrder = 2
                  OnClick = CheckBoxAllowJointAttackClick
                end
              end
              object GroupBox90: TGroupBox
                Left = 148
                Top = 105
                Width = 137
                Height = 104
                Caption = #40857#31070#20043#24594
                TabOrder = 4
                object Label437: TLabel
                  Left = 11
                  Top = 18
                  Width = 114
                  Height = 12
                  Caption = #38388#38548#26102#38388':        '#31186
                end
                object Label436: TLabel
                  Left = 11
                  Top = 43
                  Width = 114
                  Height = 12
                  Caption = #25345#32493#26102#38388':        '#31186
                end
                object Label438: TLabel
                  Left = 11
                  Top = 71
                  Width = 54
                  Height = 12
                  Caption = #26292#20987#22686#20260':'
                end
                object seMagicDragonRageInterval: TSpinEdit
                  Left = 66
                  Top = 15
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 0
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
                object seMagicDragonRageDuration: TSpinEdit
                  Left = 66
                  Top = 39
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 1
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
                object seMagicDragonRageDamageAdd: TSpinEdit
                  Left = 66
                  Top = 67
                  Width = 59
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 999999
                  MinValue = 1
                  TabOrder = 2
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
              end
            end
            object TabSheet64: TTabSheet
              Caption = #39640#32423#25216#33021'2'
              ImageIndex = 2
              object GroupBox91: TGroupBox
                Left = 5
                Top = 8
                Width = 137
                Height = 90
                Caption = #25112#39746#21880
                TabOrder = 0
                object Label440: TLabel
                  Left = 8
                  Top = 21
                  Width = 108
                  Height = 12
                  Caption = #23041#21147':            %'
                end
                object Label441: TLabel
                  Left = 8
                  Top = 44
                  Width = 114
                  Height = 12
                  Caption = #38388#38548#26102#38388':        '#31186
                end
                object SpinEdit1: TSpinEdit
                  Left = 63
                  Top = 18
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 0
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
                object CheckBox1: TCheckBox
                  Left = 8
                  Top = 64
                  Width = 77
                  Height = 17
                  Caption = #40635#30201#20154#29289
                  TabOrder = 1
                  OnClick = cbPosMoveAttackParalysisPlayerClick
                end
                object SpinEdit2: TSpinEdit
                  Left = 63
                  Top = 41
                  Width = 45
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 9999
                  MinValue = 1
                  TabOrder = 2
                  Value = 12
                  OnChange = sePosMoveAttackPowerRateChange
                end
              end
            end
          end
        end
      end
      object ButtonSkillSave: TButton
        Left = 376
        Top = 277
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonSkillSaveClick
      end
    end
    object TabSheet34: TTabSheet
      Caption = #21319#32423#27494#22120
      ImageIndex = 6
      object GroupBox8: TGroupBox
        Left = 280
        Top = 8
        Width = 161
        Height = 121
        Caption = #22522#26412#35774#32622
        TabOrder = 0
        object Label13: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #26368#39640#28857#25968':'
        end
        object Label15: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #25152#38656#36153#29992':'
        end
        object Label16: TLabel
          Left = 8
          Top = 66
          Width = 54
          Height = 12
          Caption = #25152#38656#26102#38388':'
        end
        object Label17: TLabel
          Left = 8
          Top = 90
          Width = 54
          Height = 12
          Caption = #36807#26399#26102#38388':'
        end
        object Label18: TLabel
          Left = 136
          Top = 65
          Width = 12
          Height = 12
          Caption = #31186
        end
        object Label19: TLabel
          Left = 136
          Top = 89
          Width = 12
          Height = 12
          Caption = #22825
        end
        object EditUpgradeWeaponMaxPoint: TSpinEdit
          Left = 68
          Top = 15
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditUpgradeWeaponMaxPointChange
        end
        object EditUpgradeWeaponPrice: TSpinEdit
          Left = 68
          Top = 39
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 1000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditUpgradeWeaponPriceChange
        end
        object EditUPgradeWeaponGetBackTime: TSpinEdit
          Left = 68
          Top = 63
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 36000000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditUPgradeWeaponGetBackTimeChange
        end
        object EditClearExpireUpgradeWeaponDays: TSpinEdit
          Left = 68
          Top = 87
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditClearExpireUpgradeWeaponDaysChange
        end
      end
      object GroupBox18: TGroupBox
        Left = 8
        Top = 8
        Width = 265
        Height = 89
        Caption = #25915#20987#21147#21319#32423
        TabOrder = 1
        object Label20: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #25104#21151#26426#29575':'
        end
        object Label21: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #20108#28857#26426#29575':'
        end
        object Label22: TLabel
          Left = 8
          Top = 66
          Width = 54
          Height = 12
          Caption = #19977#28857#26426#29575':'
        end
        object ScrollBarUpgradeWeaponDCRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = #21319#32423#25915#20987#21147#28857#25968#25104#21151#26426#29575#65292#26426#29575#20026#24038#22823#21491#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponDCRateChange
        end
        object EditUpgradeWeaponDCRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarUpgradeWeaponDCTwoPointRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = #24471#21040#20108#28857#23646#24615#26426#29575#65292#26426#29575#20026#24038#22823#21491#23567#12290
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponDCTwoPointRateChange
        end
        object EditUpgradeWeaponDCTwoPointRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarUpgradeWeaponDCThreePointRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = #24471#21040#19977#28857#23646#24615#26426#29575#65292#26426#29575#20026#24038#22823#21491#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponDCThreePointRateChange
        end
        object EditUpgradeWeaponDCThreePointRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
      object GroupBox19: TGroupBox
        Left = 8
        Top = 104
        Width = 265
        Height = 97
        Caption = #36947#26415#21319#32423
        TabOrder = 2
        object Label23: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #25104#21151#26426#29575':'
        end
        object Label24: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #20108#28857#26426#29575':'
        end
        object Label25: TLabel
          Left = 8
          Top = 66
          Width = 54
          Height = 12
          Caption = #19977#28857#26426#29575':'
        end
        object ScrollBarUpgradeWeaponSCRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = #21319#32423#36947#26415#28857#25968#25104#21151#26426#29575#65292#26426#29575#20026#24038#22823#21491#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponSCRateChange
        end
        object EditUpgradeWeaponSCRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarUpgradeWeaponSCTwoPointRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = #24471#21040#20108#28857#23646#24615#26426#29575#65292#26426#29575#20026#24038#22823#21491#23567#12290
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponSCTwoPointRateChange
        end
        object EditUpgradeWeaponSCTwoPointRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarUpgradeWeaponSCThreePointRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = #24471#21040#19977#28857#23646#24615#26426#29575#65292#26426#29575#20026#24038#22823#21491#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponSCThreePointRateChange
        end
        object EditUpgradeWeaponSCThreePointRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
      object GroupBox20: TGroupBox
        Left = 8
        Top = 208
        Width = 265
        Height = 89
        Caption = #39764#27861#21319#32423
        TabOrder = 3
        object Label26: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #25104#21151#26426#29575':'
        end
        object Label27: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = #20108#28857#26426#29575':'
        end
        object Label28: TLabel
          Left = 8
          Top = 66
          Width = 54
          Height = 12
          Caption = #19977#28857#26426#29575':'
        end
        object ScrollBarUpgradeWeaponMCRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = #21319#32423#39764#27861#28857#25968#25104#21151#26426#29575#65292#26426#29575#20026#24038#22823#21491#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponMCRateChange
        end
        object EditUpgradeWeaponMCRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarUpgradeWeaponMCTwoPointRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = #24471#21040#20108#28857#23646#24615#26426#29575#65292#26426#29575#20026#24038#22823#21491#23567#12290
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponMCTwoPointRateChange
        end
        object EditUpgradeWeaponMCTwoPointRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarUpgradeWeaponMCThreePointRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = #24471#21040#19977#28857#23646#24615#26426#29575#65292#26426#29575#20026#24038#22823#21491#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponMCThreePointRateChange
        end
        object EditUpgradeWeaponMCThreePointRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
      object ButtonUpgradeWeaponSave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 4
        OnClick = ButtonUpgradeWeaponSaveClick
      end
      object ButtonUpgradeWeaponDefaulf: TButton
        Left = 296
        Top = 273
        Width = 65
        Height = 21
        Caption = #40664#35748'(&D)'
        TabOrder = 5
        OnClick = ButtonUpgradeWeaponDefaulfClick
      end
    end
    object TabSheet35: TTabSheet
      Caption = #25366#30719#25511#21046
      ImageIndex = 7
      object GroupBox24: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 60
        Caption = #24471#21040#30719#30707#26426#29575
        TabOrder = 0
        object Label32: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #21629#20013#26426#29575':'
        end
        object Label33: TLabel
          Left = 8
          Top = 36
          Width = 54
          Height = 12
          Caption = #25366#30719#26426#29575':'
        end
        object ScrollBarMakeMineHitRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Hint = #35774#32622#30340#25968#23383#36234#23567#26426#29575#36234#22823#12290
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarMakeMineHitRateChange
        end
        object EditMakeMineHitRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarMakeMineRate: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Hint = #35774#32622#30340#25968#23383#36234#23567#26426#29575#36234#22823#12290
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarMakeMineRateChange
        end
        object EditMakeMineRate: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
      end
      object GroupBox25: TGroupBox
        Left = 8
        Top = 72
        Width = 273
        Height = 121
        Caption = #30719#30707#31867#22411#26426#29575
        TabOrder = 1
        object Label34: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #30719#30707#22240#23376':'
        end
        object Label35: TLabel
          Left = 8
          Top = 38
          Width = 42
          Height = 12
          Caption = #37329#30719#29575':'
        end
        object Label36: TLabel
          Left = 8
          Top = 56
          Width = 42
          Height = 12
          Caption = #38134#30719#29575':'
        end
        object Label37: TLabel
          Left = 8
          Top = 76
          Width = 42
          Height = 12
          Caption = #38081#30719#29575':'
        end
        object Label38: TLabel
          Left = 8
          Top = 96
          Width = 54
          Height = 12
          Caption = #40657#38081#30719#29575':'
        end
        object ScrollBarStoneTypeRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarStoneTypeRateChange
        end
        object EditStoneTypeRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarGoldStoneMax: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarGoldStoneMaxChange
        end
        object EditGoldStoneMax: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarSilverStoneMax: TScrollBar
          Left = 72
          Top = 56
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarSilverStoneMaxChange
        end
        object EditSilverStoneMax: TEdit
          Left = 208
          Top = 56
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarSteelStoneMax: TScrollBar
          Left = 72
          Top = 76
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarSteelStoneMaxChange
        end
        object EditSteelStoneMax: TEdit
          Left = 208
          Top = 76
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditBlackStoneMax: TEdit
          Left = 208
          Top = 96
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarBlackStoneMax: TScrollBar
          Left = 72
          Top = 96
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarBlackStoneMaxChange
        end
      end
      object ButtonMakeMineSave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 2
        OnClick = ButtonMakeMineSaveClick
      end
      object GroupBox26: TGroupBox
        Left = 288
        Top = 8
        Width = 153
        Height = 121
        Caption = #30719#30707#21697#36136
        TabOrder = 3
        object Label39: TLabel
          Left = 8
          Top = 18
          Width = 78
          Height = 12
          Caption = #30719#30707#26368#23567#21697#36136':'
        end
        object Label40: TLabel
          Left = 8
          Top = 42
          Width = 78
          Height = 12
          Caption = #26222#36890#21697#36136#33539#22260':'
        end
        object Label41: TLabel
          Left = 8
          Top = 66
          Width = 66
          Height = 12
          Caption = #39640#21697#36136#26426#29575':'
        end
        object Label42: TLabel
          Left = 8
          Top = 90
          Width = 66
          Height = 12
          Caption = #39640#21697#36136#33539#22260':'
        end
        object EditStoneMinDura: TSpinEdit
          Left = 92
          Top = 15
          Width = 45
          Height = 21
          Hint = #30719#30707#20986#29616#26368#20302#21697#36136#28857#25968#12290
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditStoneMinDuraChange
        end
        object EditStoneGeneralDuraRate: TSpinEdit
          Left = 92
          Top = 39
          Width = 45
          Height = 21
          Hint = #30719#30707#38543#26426#20986#29616#21697#36136#28857#25968#33539#22260#12290
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditStoneGeneralDuraRateChange
        end
        object EditStoneAddDuraRate: TSpinEdit
          Left = 92
          Top = 63
          Width = 45
          Height = 21
          Hint = #30719#30707#20986#29616#39640#21697#36136#28857#25968#26426#29575#65292#39640#21697#36136#37327#25351#21487#36798#21040'20'#25110#20197#19978#30340#28857#25968#12290
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditStoneAddDuraRateChange
        end
        object EditStoneAddDuraMax: TSpinEdit
          Left = 92
          Top = 87
          Width = 45
          Height = 21
          Hint = #39640#21697#36136#30719#30707#38543#26426#20986#29616#21697#36136#28857#25968#33539#22260#12290
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditStoneAddDuraMaxChange
        end
      end
      object ButtonMakeMineDefault: TButton
        Left = 296
        Top = 273
        Width = 65
        Height = 21
        Caption = #40664#35748'(&D)'
        TabOrder = 4
        OnClick = ButtonMakeMineDefaultClick
      end
    end
    object TabSheet42: TTabSheet
      Caption = #31069#31119#27833#25511#21046
      ImageIndex = 12
      object GroupBox44: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 145
        Caption = #26426#29575#35774#32622
        TabOrder = 0
        object Label105: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #35781#21650#26426#29575':'
        end
        object Label106: TLabel
          Left = 8
          Top = 38
          Width = 54
          Height = 12
          Caption = #19968#32423#28857#25968':'
        end
        object Label107: TLabel
          Left = 8
          Top = 56
          Width = 54
          Height = 12
          Caption = #20108#32423#28857#25968':'
        end
        object Label108: TLabel
          Left = 8
          Top = 76
          Width = 54
          Height = 12
          Caption = #20108#32423#26426#29575':'
        end
        object Label109: TLabel
          Left = 8
          Top = 96
          Width = 54
          Height = 12
          Caption = #19977#32423#28857#25968':'
        end
        object Label110: TLabel
          Left = 8
          Top = 116
          Width = 54
          Height = 12
          Caption = #19977#32423#26426#29575':'
        end
        object ScrollBarWeaponMakeUnLuckRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Hint = #20351#29992#31069#31119#27833#35781#21650#26426#29575#65292#25968#23383#36234#22823#26426#29575#36234#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarWeaponMakeUnLuckRateChange
        end
        object EditWeaponMakeUnLuckRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarWeaponMakeLuckPoint1: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Hint = #24403#27494#22120#30340#24184#36816#28857#23567#20110#27492#28857#25968#26102#20351#29992#31069#31119#27833#21017'100% '#25104#21151#12290
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarWeaponMakeLuckPoint1Change
        end
        object EditWeaponMakeLuckPoint1: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarWeaponMakeLuckPoint2: TScrollBar
          Left = 72
          Top = 56
          Width = 129
          Height = 15
          Hint = #24403#27494#22120#30340#24184#36816#28857#23567#20110#27492#28857#25968#26102#20351#29992#31069#31119#27833#21017#25353#25351#23450#26426#29575#20915#23450#26159#21542#21152#24184#36816#12290
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarWeaponMakeLuckPoint2Change
        end
        object EditWeaponMakeLuckPoint2: TEdit
          Left = 208
          Top = 56
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarWeaponMakeLuckPoint2Rate: TScrollBar
          Left = 72
          Top = 76
          Width = 129
          Height = 15
          Hint = #26426#29575#28857#25968#65292#25968#23383#36234#22823#26426#29575#36234#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarWeaponMakeLuckPoint2RateChange
        end
        object EditWeaponMakeLuckPoint2Rate: TEdit
          Left = 208
          Top = 76
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditWeaponMakeLuckPoint3: TEdit
          Left = 208
          Top = 96
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarWeaponMakeLuckPoint3: TScrollBar
          Left = 72
          Top = 96
          Width = 129
          Height = 15
          Hint = #24403#27494#22120#30340#24184#36816#28857#23567#20110#27492#28857#25968#26102#20351#29992#31069#31119#27833#21017#25353#25351#23450#26426#29575#20915#23450#26159#21542#21152#24184#36816#12290
          Max = 500
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarWeaponMakeLuckPoint3Change
        end
        object ScrollBarWeaponMakeLuckPoint3Rate: TScrollBar
          Left = 72
          Top = 116
          Width = 129
          Height = 15
          Hint = #26426#29575#28857#25968#65292#25968#23383#36234#22823#26426#29575#36234#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 10
          OnChange = ScrollBarWeaponMakeLuckPoint3RateChange
        end
        object EditWeaponMakeLuckPoint3Rate: TEdit
          Left = 208
          Top = 116
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 11
        end
      end
      object ButtonWeaponMakeLuckDefault: TButton
        Left = 296
        Top = 273
        Width = 65
        Height = 21
        Caption = #40664#35748'(&D)'
        TabOrder = 1
        OnClick = ButtonWeaponMakeLuckDefaultClick
      end
      object ButtonWeaponMakeLuckSave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 2
        OnClick = ButtonWeaponMakeLuckSaveClick
      end
    end
    object TabSheet37: TTabSheet
      Caption = #24425#31080#25511#21046
      ImageIndex = 8
      object GroupBox27: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 169
        Caption = #20013#22870#26426#29575
        TabOrder = 0
        object Label43: TLabel
          Left = 8
          Top = 42
          Width = 42
          Height = 12
          Caption = #19968#31561#22870':'
        end
        object Label44: TLabel
          Left = 8
          Top = 62
          Width = 42
          Height = 12
          Caption = #20108#31561#22870':'
        end
        object Label45: TLabel
          Left = 8
          Top = 80
          Width = 42
          Height = 12
          Caption = #19977#31561#22870':'
        end
        object Label46: TLabel
          Left = 8
          Top = 100
          Width = 42
          Height = 12
          Caption = #22235#31561#22870':'
        end
        object Label47: TLabel
          Left = 8
          Top = 120
          Width = 42
          Height = 12
          Caption = #20116#31561#22870':'
        end
        object Label48: TLabel
          Left = 8
          Top = 140
          Width = 42
          Height = 12
          Caption = #20845#31561#22870':'
        end
        object Label49: TLabel
          Left = 8
          Top = 18
          Width = 30
          Height = 12
          Caption = #22240#23376':'
        end
        object ScrollBarWinLottery1Max: TScrollBar
          Left = 56
          Top = 40
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarWinLottery1MaxChange
        end
        object EditWinLottery1Max: TEdit
          Left = 192
          Top = 40
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarWinLottery2Max: TScrollBar
          Left = 56
          Top = 60
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarWinLottery2MaxChange
        end
        object EditWinLottery2Max: TEdit
          Left = 192
          Top = 60
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarWinLottery3Max: TScrollBar
          Left = 56
          Top = 80
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarWinLottery3MaxChange
        end
        object EditWinLottery3Max: TEdit
          Left = 192
          Top = 80
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarWinLottery4Max: TScrollBar
          Left = 56
          Top = 100
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarWinLottery4MaxChange
        end
        object EditWinLottery4Max: TEdit
          Left = 192
          Top = 100
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditWinLottery5Max: TEdit
          Left = 192
          Top = 120
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarWinLottery5Max: TScrollBar
          Left = 56
          Top = 120
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarWinLottery5MaxChange
        end
        object ScrollBarWinLottery6Max: TScrollBar
          Left = 56
          Top = 140
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 10
          OnChange = ScrollBarWinLottery6MaxChange
        end
        object EditWinLottery6Max: TEdit
          Left = 192
          Top = 140
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 11
        end
        object EditWinLotteryRate: TEdit
          Left = 192
          Top = 16
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 12
        end
        object ScrollBarWinLotteryRate: TScrollBar
          Left = 56
          Top = 16
          Width = 129
          Height = 15
          Max = 100000
          PageSize = 0
          TabOrder = 13
          OnChange = ScrollBarWinLotteryRateChange
        end
      end
      object GroupBox28: TGroupBox
        Left = 288
        Top = 8
        Width = 145
        Height = 169
        Caption = #22870#37329
        TabOrder = 1
        object Label50: TLabel
          Left = 8
          Top = 18
          Width = 42
          Height = 12
          Caption = #19968#31561#22870':'
        end
        object Label51: TLabel
          Left = 8
          Top = 42
          Width = 42
          Height = 12
          Caption = #20108#31561#22870':'
        end
        object Label52: TLabel
          Left = 8
          Top = 66
          Width = 42
          Height = 12
          Caption = #19977#31561#22870':'
        end
        object Label53: TLabel
          Left = 8
          Top = 90
          Width = 42
          Height = 12
          Caption = #22235#31561#22870':'
        end
        object Label54: TLabel
          Left = 8
          Top = 114
          Width = 42
          Height = 12
          Caption = #20116#31561#22870':'
        end
        object Label55: TLabel
          Left = 8
          Top = 138
          Width = 42
          Height = 12
          Caption = #20845#31561#22870':'
        end
        object EditWinLottery1Gold: TSpinEdit
          Left = 56
          Top = 15
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 0
          Value = 100000000
          OnChange = EditWinLottery1GoldChange
        end
        object EditWinLottery2Gold: TSpinEdit
          Left = 56
          Top = 39
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditWinLottery2GoldChange
        end
        object EditWinLottery3Gold: TSpinEdit
          Left = 56
          Top = 63
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditWinLottery3GoldChange
        end
        object EditWinLottery4Gold: TSpinEdit
          Left = 56
          Top = 87
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditWinLottery4GoldChange
        end
        object EditWinLottery5Gold: TSpinEdit
          Left = 56
          Top = 111
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 4
          Value = 10
          OnChange = EditWinLottery5GoldChange
        end
        object EditWinLottery6Gold: TSpinEdit
          Left = 56
          Top = 135
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 5
          Value = 10
          OnChange = EditWinLottery6GoldChange
        end
      end
      object ButtonWinLotterySave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        ModalResult = 1
        TabOrder = 2
        OnClick = ButtonWinLotterySaveClick
      end
      object ButtonWinLotteryDefault: TButton
        Left = 296
        Top = 273
        Width = 65
        Height = 21
        Caption = #40664#35748'(&D)'
        TabOrder = 3
        OnClick = ButtonWinLotteryDefaultClick
      end
    end
    object TabSheet40: TTabSheet
      Caption = #20840#23616#21151#33021
      ImageIndex = 11
      object GroupBox36: TGroupBox
        Left = 8
        Top = 8
        Width = 137
        Height = 89
        Caption = #31048#31095#29983#25928
        TabOrder = 0
        object Label94: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #29983#25928#26102#38271':'
        end
        object Label96: TLabel
          Left = 11
          Top = 64
          Width = 54
          Height = 12
          Caption = #33021#37327#20493#25968':'
          Enabled = False
        end
        object CheckBoxSpiritMutiny: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Caption = #21551#29992#31048#31095#29305#27530#21151#33021
          TabOrder = 0
          OnClick = CheckBoxSpiritMutinyClick
        end
        object EditSpiritMutinyTime: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditSpiritMutinyTimeChange
        end
        object EditSpiritPowerRate: TSpinEdit
          Left = 72
          Top = 60
          Width = 49
          Height = 21
          EditorEnabled = False
          Enabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditSpiritPowerRateChange
        end
      end
      object ButtonSpiritMutinySave: TButton
        Left = 376
        Top = 273
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonSpiritMutinySaveClick
      end
      object GroupBox49: TGroupBox
        Left = 8
        Top = 102
        Width = 137
        Height = 73
        Caption = #23492#21334#31995#32479
        TabOrder = 2
        object Label113: TLabel
          Left = 11
          Top = 25
          Width = 54
          Height = 12
          Caption = #25968#37327#38480#21046':'
        end
        object Label114: TLabel
          Left = 11
          Top = 49
          Width = 54
          Height = 12
          Caption = #31246' '#25910' '#29575':'
        end
        object EditSellCount: TSpinEdit
          Left = 72
          Top = 21
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditSellCountChange
        end
        object EditSellTax: TSpinEdit
          Left = 72
          Top = 45
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 0
          TabOrder = 1
          Value = 10
          OnChange = EditSellCountChange
        end
      end
      object GroupBox82: TGroupBox
        Left = 153
        Top = 8
        Width = 176
        Height = 74
        Caption = #20854#20182#36873#39033
        TabOrder = 3
        object cbNullAttackOnSale: TCheckBox
          Left = 8
          Top = 49
          Width = 161
          Height = 17
          Caption = #23545#23433#20840#21306#25670#25674#32773#25915#20987#26080#25928
          TabOrder = 0
          OnClick = CheckBoxSpiritMutinyClick
        end
        object cbMedalItemLight: TCheckBox
          Left = 8
          Top = 32
          Width = 113
          Height = 17
          Caption = #24320#21551#21195#31456#29031#26126
          TabOrder = 1
          OnClick = CheckBoxSpiritMutinyClick
        end
        object cbSpiritMutinyDie: TCheckBox
          Left = 8
          Top = 15
          Width = 113
          Height = 17
          Caption = #23646#19979#21467#21464#21518#27515#20129
          TabOrder = 2
          OnClick = CheckBoxSpiritMutinyClick
        end
      end
      object GroupBox84: TGroupBox
        Left = 151
        Top = 87
        Width = 178
        Height = 186
        Caption = #35013#22791#32465#23450#24080#21495
        TabOrder = 4
        object boBindNoSell: TCheckBox
          Left = 8
          Top = 66
          Width = 106
          Height = 17
          Caption = #31105#27490#20182#20154#20986#21806
          TabOrder = 0
          OnClick = CheckBoxSpiritMutinyClick
        end
        object boBindNoScatter: TCheckBox
          Left = 8
          Top = 15
          Width = 81
          Height = 17
          Caption = #27515#20129#19981#25481#33853
          TabOrder = 1
          OnClick = CheckBoxSpiritMutinyClick
        end
        object boBindNoMelt: TCheckBox
          Left = 8
          Top = 32
          Width = 153
          Height = 17
          Caption = #38646#25345#20037#19981#28040#22833'('#23646#24615#22833#25928')'
          TabOrder = 2
          OnClick = CheckBoxSpiritMutinyClick
        end
        object boBindNoUse: TCheckBox
          Left = 8
          Top = 49
          Width = 106
          Height = 17
          Caption = #31105#27490#20182#20154#20351#29992
          TabOrder = 3
          OnClick = CheckBoxSpiritMutinyClick
        end
        object boBindNoPickUp: TCheckBox
          Left = 8
          Top = 83
          Width = 106
          Height = 17
          Caption = #31105#27490#20182#20154#25342#21462
          TabOrder = 4
          OnClick = CheckBoxSpiritMutinyClick
        end
        object cbBindPickup: TCheckBox
          Left = 8
          Top = 100
          Width = 106
          Height = 17
          Caption = #25342#21462#21518#32465#23450
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = CheckBoxSpiritMutinyClick
        end
        object cbBindTakeOn: TCheckBox
          Left = 8
          Top = 117
          Width = 106
          Height = 17
          Caption = #35013#22791#21518#32465#23450
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = CheckBoxSpiritMutinyClick
        end
      end
      object GroupBox85: TGroupBox
        Left = 8
        Top = 181
        Width = 137
        Height = 92
        Caption = #24517#26432#22871#35013#20260#23475
        TabOrder = 5
        object cbItemSuiteDamageTypes_IP: TCheckBox
          Left = 11
          Top = 18
          Width = 97
          Height = 17
          Caption = #20869#21147#20540
          TabOrder = 0
          OnClick = cbItemSuiteDamageTypes_IPClick
        end
        object cbItemSuiteDamageTypes_HP: TCheckBox
          Left = 11
          Top = 35
          Width = 97
          Height = 17
          Caption = 'HP'
          TabOrder = 1
          OnClick = cbItemSuiteDamageTypes_IPClick
        end
        object cbItemSuiteDamageTypes_MP: TCheckBox
          Left = 11
          Top = 52
          Width = 97
          Height = 17
          Caption = 'MP'
          TabOrder = 2
          OnClick = cbItemSuiteDamageTypes_IPClick
        end
      end
    end
    object TabSheet7: TTabSheet
      Caption = #33521#38596#35774#32622
      ImageIndex = 13
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 449
        Height = 301
        ActivePage = TabSheet28
        Align = alClient
        TabOrder = 0
        object TabSheet28: TTabSheet
          Caption = #35774#32622#19968
          object GroupBox55: TGroupBox
            Left = 300
            Top = 122
            Width = 136
            Height = 61
            Caption = #21351#40857#21517#23558#35774#32622
            TabOrder = 0
            object Label161: TLabel
              Left = 11
              Top = 37
              Width = 54
              Height = 12
              Caption = #25187#38500#28789#31526':'
            end
            object CheckBoxNoButchItemSubGird: TCheckBox
              Left = 10
              Top = 16
              Width = 113
              Height = 17
              Hint = #25171#38057#24773#20917#19979#65292#19981#31649#26159#21542#25366#21040#29289#21697#65292#37117#23558#25187#38500#19968#20010#28789#31526#65292#21542#21017#21482#26377#25366#21040#29289#21697#25165#25187#38500#28789#31526#12290
              Caption = #26410#25366#21040#29289#21697#25187#28789#31526
              TabOrder = 0
              OnClick = CheckBoxNoButchItemSubGirdClick
            end
            object EditDiButchItemNeedGird: TSpinEdit
              Left = 72
              Top = 33
              Width = 49
              Height = 21
              MaxValue = 9999
              MinValue = 0
              TabOrder = 1
              Value = 200
              OnChange = EditDiButchItemNeedGirdChange
            end
          end
          object GroupBox53: TGroupBox
            Left = 300
            Top = 2
            Width = 136
            Height = 114
            Caption = #33521#38596#21517#23383#35774#32622
            TabOrder = 1
            object Label120: TLabel
              Left = 8
              Top = 40
              Width = 30
              Height = 12
              Caption = #21517#23383':'
            end
            object Label121: TLabel
              Left = 8
              Top = 64
              Width = 30
              Height = 12
              Caption = #21518#32512':'
            end
            object LabelHeroNameColor: TLabel
              Left = 112
              Top = 86
              Width = 13
              Height = 17
              AutoSize = False
              Color = clBackground
              ParentColor = False
            end
            object Label141: TLabel
              Left = 8
              Top = 89
              Width = 30
              Height = 12
              Caption = #39068#33394':'
            end
            object EditHeroName: TEdit
              Left = 40
              Top = 36
              Width = 81
              Height = 20
              ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
              MaxLength = 14
              TabOrder = 0
              OnChange = EditHeroNameChange
            end
            object EditHeroSlaveName: TEdit
              Left = 40
              Top = 60
              Width = 81
              Height = 20
              ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
              MaxLength = 14
              TabOrder = 1
              OnChange = EditHeroSlaveNameChange
            end
            object CheckBoxPShowMasterName: TCheckBox
              Left = 8
              Top = 16
              Width = 97
              Height = 17
              Caption = #26174#31034#20027#20154#21517#23383
              TabOrder = 2
              OnClick = CheckBoxPShowMasterNameClick
            end
            object EditHeroNameColor: TSpinEdit
              Left = 40
              Top = 85
              Width = 65
              Height = 21
              EditorEnabled = False
              MaxValue = 255
              MinValue = 0
              TabOrder = 3
              Value = 100
              OnChange = EditHeroNameColorChange
            end
          end
          object GroupBox54: TGroupBox
            Left = 157
            Top = 6
            Width = 137
            Height = 169
            Caption = #20998#36523'/'#33521#38596#25216#33021
            TabOrder = 2
            object Label122: TLabel
              Left = 11
              Top = 25
              Width = 114
              Height = 12
              Caption = #28872#28779#38388#38548':        '#31186
            end
            object Label182: TLabel
              Left = 8
              Top = 77
              Width = 120
              Height = 12
              Caption = #19981#38057#36873#38656#22312#21253#35065#25918#31526#27602
              Font.Charset = ANSI_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object SpinEditHeroFireSwordTime: TSpinEdit
              Left = 66
              Top = 21
              Width = 41
              Height = 21
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = SpinEditHeroFireSwordTimeChange
            end
            object GroupBox58: TGroupBox
              Left = 8
              Top = 93
              Width = 121
              Height = 69
              Caption = #25112#22763#33521#38596#22522#26412#25216#33021
              TabOrder = 1
              object RadioButtonMag12: TRadioButton
                Left = 8
                Top = 31
                Width = 73
                Height = 17
                Caption = #20992#20992#21050#26432
                TabOrder = 0
                OnClick = RadioButtonMag12Click
              end
              object RadioButtonMag25: TRadioButton
                Left = 8
                Top = 46
                Width = 73
                Height = 17
                Caption = #21322#26376#24367#20992
                TabOrder = 1
                OnClick = RadioButtonMag25Click
              end
              object RadioButtonMag0: TRadioButton
                Left = 8
                Top = 15
                Width = 73
                Height = 17
                Caption = #26222#36890#25915#20987
                TabOrder = 2
                OnClick = RadioButtonMag0Click
              end
            end
            object CheckBoxDoMotaebo: TCheckBox
              Left = 8
              Top = 42
              Width = 97
              Height = 17
              Caption = #20351#29992#37326#34542#20914#25758
              TabOrder = 2
              OnClick = CheckBoxDoMotaeboClick
            end
            object CheckBoxHeroNeedAmulet: TCheckBox
              Left = 8
              Top = 58
              Width = 121
              Height = 17
              Hint = #19981#25171#38057#26102#65292#33521#38596#21487#20197#22312#25252#36523#31526#20301#32622#20329#24102#20854#20182#35013#22791#65292#37322#25918#39764#27861#38656#35201#25918#30456#24212#30340#31526#25110#31881#26411#22312#21253#35065#20013#12290
              Caption = #38656#20329#24102#31526#25110#27602
              TabOrder = 3
              OnClick = CheckBoxHeroNeedAmuletClick
            end
          end
          object GroupBox65: TGroupBox
            Left = 6
            Top = 2
            Width = 145
            Height = 173
            Caption = #22522#26412#35774#32622
            TabOrder = 3
            object Label142: TLabel
              Left = 8
              Top = 125
              Width = 90
              Height = 12
              Caption = #21484#33521#38596#38388#38548#26102#38388':'
            end
            object Label165: TLabel
              Left = 8
              Top = 102
              Width = 90
              Height = 12
              Caption = #33521#38596#25307#20998#36523#38388#38548':'
            end
            object Label183: TLabel
              Left = 9
              Top = 149
              Width = 96
              Height = 12
              Caption = #20998#36523#23384#27963#26102#38388#20493#29575
            end
            object CheckBoxAllowHeroPickUpItem: TCheckBox
              Left = 8
              Top = 16
              Width = 113
              Height = 17
              Caption = #20801#35768#33521#38596#25441#21462#29289#21697
              TabOrder = 0
              OnClick = CheckBoxAllowHeroPickUpItemClick
            end
            object CheckBoxTaosHeroAutoChangePoison: TCheckBox
              Left = 8
              Top = 32
              Width = 114
              Height = 17
              Caption = #26041#22763#33521#38596#33258#21160#25442#27602
              TabOrder = 1
              OnClick = CheckBoxTaosHeroAutoChangePoisonClick
            end
            object EditRecallHeroIntervalTime: TSpinEdit
              Left = 100
              Top = 122
              Width = 37
              Height = 21
              Hint = #20877#27425#21484#21796#33521#38596#30340#26102#38388#38388#38548'('#31186')'#65292#19981#33021#35774#32622#22826#23567#65292#21542#21017#26377#21487#33021#20986#38169#65292#40664#35748'60'#31186#65281
              MaxValue = 600
              MinValue = 30
              TabOrder = 2
              Value = 30
              OnChange = EditRecallHeroIntervalTimeChange
            end
            object CheckBoxHeroCalcHitSpeed: TCheckBox
              Left = 8
              Top = 48
              Width = 92
              Height = 17
              Hint = #26159#21542#20801#35768#33521#38596#29289#29702#25915#20987#26102#35745#31639#27494#22120#36895#24230
              Caption = #33521#38596#27494#22120#21152#36895
              TabOrder = 3
              OnClick = CheckBoxHeroCalcHitSpeedClick
            end
            object CheckBoxHeroLockTarget: TCheckBox
              Left = 8
              Top = 64
              Width = 113
              Height = 17
              Caption = '[CTRL+W]'#38145#23450#30446#26631
              TabOrder = 4
              OnClick = CheckBoxHeroLockTargetClick
            end
            object speHeroRecallPneumaTime: TSpinEdit
              Left = 100
              Top = 99
              Width = 37
              Height = 21
              Hint = #33521#38596#20877#27425#21484#21796#20998#36523#30340#26102#38388#38388#38548'('#31186')'#65292#40664#35748'20'#31186#65281
              MaxValue = 99
              MinValue = 1
              TabOrder = 5
              Value = 30
              OnChange = speHeroRecallPneumaTimeChange
            end
            object SpinEditShadowExpriesTime: TSpinEdit
              Left = 100
              Top = 145
              Width = 37
              Height = 21
              MaxValue = 999
              MinValue = 1
              TabOrder = 6
              Value = 3
              OnChange = EditHeroGainExpRateChange
            end
            object EditHeroHitSpeedMax: TSpinEdit
              Left = 100
              Top = 46
              Width = 38
              Height = 21
              Hint = #33521#38596#26368#39640#27494#22120#21152#36895#24230#38480#21046
              MaxValue = 99
              MinValue = 1
              TabOrder = 7
              Value = 30
              OnChange = speHeroRecallPneumaTimeChange
            end
          end
          object GroupBox52: TGroupBox
            Left = 6
            Top = 176
            Width = 145
            Height = 92
            Caption = #25915#20987#26102#38388#38388#38548
            TabOrder = 4
            object Label118: TLabel
              Left = 11
              Top = 21
              Width = 126
              Height = 12
              Caption = #25112#22763':            '#27627#31186
            end
            object Label119: TLabel
              Left = 11
              Top = 45
              Width = 126
              Height = 12
              Caption = #27861#24072':            '#27627#31186
            end
            object Label117: TLabel
              Left = 11
              Top = 69
              Width = 126
              Height = 12
              Caption = #36947#22763':            '#27627#31186
            end
            object EditHeroNextHitTime_Warr: TSpinEdit
              Left = 48
              Top = 17
              Width = 57
              Height = 21
              MaxValue = 9999
              MinValue = 200
              TabOrder = 0
              Value = 200
              OnChange = EditHeroNextHitTime_WarrChange
            end
            object EditHeroNextHitTime_Wizard: TSpinEdit
              Left = 48
              Top = 41
              Width = 57
              Height = 21
              MaxValue = 9999
              MinValue = 200
              TabOrder = 1
              Value = 200
              OnChange = EditHeroNextHitTime_WizardChange
            end
            object EditHeroNextHitTime_Taos: TSpinEdit
              Left = 48
              Top = 65
              Width = 57
              Height = 21
              MaxValue = 9999
              MinValue = 200
              TabOrder = 2
              Value = 200
              OnChange = EditHeroNextHitTime_TaosChange
            end
          end
          object GroupBox64: TGroupBox
            Left = 157
            Top = 176
            Width = 137
            Height = 92
            Caption = #34892#36208#26102#38388#38388#38548
            TabOrder = 5
            object Label136: TLabel
              Left = 11
              Top = 21
              Width = 114
              Height = 12
              Caption = #25112#22763':          '#27627#31186
            end
            object Label137: TLabel
              Left = 11
              Top = 45
              Width = 114
              Height = 12
              Caption = #27861#24072':          '#27627#31186
            end
            object Label138: TLabel
              Left = 11
              Top = 69
              Width = 114
              Height = 12
              Caption = #36947#22763':          '#27627#31186
            end
            object EditHeroWalkSpeed_Warr: TSpinEdit
              Left = 48
              Top = 17
              Width = 49
              Height = 21
              MaxValue = 9999
              MinValue = 200
              TabOrder = 0
              Value = 200
              OnChange = EditHeroWalkSpeed_WarrChange
            end
            object EditHeroWalkSpeed_Wizard: TSpinEdit
              Left = 48
              Top = 41
              Width = 49
              Height = 21
              MaxValue = 9999
              MinValue = 200
              TabOrder = 1
              Value = 200
              OnChange = EditHeroWalkSpeed_WizardChange
            end
            object EditHeroWalkSpeed_Taos: TSpinEdit
              Left = 48
              Top = 65
              Width = 49
              Height = 21
              MaxValue = 9999
              MinValue = 200
              TabOrder = 2
              Value = 200
              OnChange = EditHeroWalkSpeed_TaosChange
            end
          end
          object ButtonHeroSetSave: TButton
            Left = 363
            Top = 247
            Width = 65
            Height = 21
            Caption = #20445#23384'(&S)'
            TabOrder = 6
            OnClick = ButtonHeroSetSaveClick
          end
          object cbDieDeductionExp: TCheckBox
            Left = 300
            Top = 185
            Width = 113
            Height = 17
            Caption = #27515#20129#25481#32463#39564
            TabOrder = 7
            OnClick = CheckBoxNoButchItemSubGirdClick
          end
          object CheckBoxHeroHomicideAddMasterPkPoint: TCheckBox
            Left = 300
            Top = 218
            Width = 125
            Height = 17
            Caption = #33521#38596#26432#20154#20027#20154'+PK'#20540
            TabOrder = 8
            OnClick = CheckBoxHeroKillHumanAddPkPointClick
          end
          object CheckBoxHeroKillHumanAddPkPoint: TCheckBox
            Left = 300
            Top = 202
            Width = 113
            Height = 17
            Caption = #33521#38596#26432#20154#22686#21152'PK'#20540
            TabOrder = 9
            OnClick = CheckBoxHeroKillHumanAddPkPointClick
          end
        end
        object TabSheet29: TTabSheet
          Caption = #35774#32622#20108
          ImageIndex = 1
          object GroupBox79: TGroupBox
            Left = 5
            Top = 2
            Width = 113
            Height = 93
            TabOrder = 0
            object Label173: TLabel
              Left = 7
              Top = 19
              Width = 24
              Height = 12
              Caption = #25112#22763
            end
            object Label174: TLabel
              Left = 7
              Top = 41
              Width = 24
              Height = 12
              Caption = #27861#24072
            end
            object Label175: TLabel
              Left = 7
              Top = 65
              Width = 24
              Height = 12
              Caption = #36947#22763
            end
            object SpinEditWarrCmpInvTime: TSpinEdit
              Left = 37
              Top = 16
              Width = 62
              Height = 21
              Hint = #25968#23383#36234#23567', '#32452#21512#36895#24230#36234#27969#30021', '#40664#35748'400.'
              Increment = 10
              MaxValue = 9999
              MinValue = -9999
              TabOrder = 0
              Value = 200
              OnChange = EditHeroWalkSpeed_WarrChange
            end
            object SpinEditTaosCmpInvTime: TSpinEdit
              Left = 37
              Top = 63
              Width = 62
              Height = 21
              Hint = #25968#23383#36234#23567', '#32452#21512#36895#24230#36234#27969#30021', '#40664#35748'200.'
              Increment = 10
              MaxValue = 9999
              MinValue = -9999
              TabOrder = 1
              Value = 200
              OnChange = EditHeroWalkSpeed_WarrChange
            end
            object SpinEditWizaCmpInvTime: TSpinEdit
              Left = 37
              Top = 40
              Width = 62
              Height = 21
              Hint = #25968#23383#36234#23567', '#32452#21512#36895#24230#36234#27969#30021', '#40664#35748'200.'
              Increment = 10
              MaxValue = 9999
              MinValue = -9999
              TabOrder = 2
              Value = 200
              OnChange = EditHeroWalkSpeed_WarrChange
            end
          end
          object ButtonHeroSetSave2: TButton
            Left = 363
            Top = 247
            Width = 65
            Height = 21
            Caption = #20445#23384'(&S)'
            TabOrder = 1
            OnClick = ButtonHeroSetSaveClick
          end
          object GroupBox86: TGroupBox
            Left = 123
            Top = 3
            Width = 169
            Height = 92
            Caption = #32463#39564#35774#32622
            TabOrder = 2
            object Label140: TLabel
              Left = 8
              Top = 42
              Width = 156
              Height = 12
              Caption = #33521#38596#33719#21462#26432#24618#32463#39564':        %'
            end
            object Label199: TLabel
              Left = 8
              Top = 65
              Width = 156
              Height = 12
              Caption = #33521#38596#33719#21462#20854#20182#32463#39564':        %'
            end
            object CheckBoxGetFullExp: TCheckBox
              Left = 8
              Top = 16
              Width = 151
              Height = 17
              Caption = #20154#29289#33521#38596#33719#21462#20840#26432#24618#32463#39564
              TabOrder = 0
              OnClick = CheckBoxAllowHeroPickUpItemClick
            end
            object EditHeroGainExpRate: TSpinEdit
              Left = 111
              Top = 39
              Width = 44
              Height = 21
              Hint = #33521#38596#33719#21462#26432#24618#32463#39564#25152#21344#30340#27604#29575
              MaxValue = 999
              MinValue = 1
              TabOrder = 1
              Value = 3
              OnChange = EditHeroGainExpRateChange
            end
            object EditHeroGainExpRate2: TSpinEdit
              Left = 111
              Top = 61
              Width = 44
              Height = 21
              Hint = #33521#38596#33719#21462#22870#21169#30340#32463#39564#25152#21344#30340#27604#29575
              MaxValue = 999
              MinValue = 1
              TabOrder = 2
              Value = 3
              OnChange = EditHeroGainExpRateChange
            end
          end
          object GroupBox59: TGroupBox
            Left = 298
            Top = 3
            Width = 136
            Height = 120
            Caption = 'HPMP'#35774#32622
            TabOrder = 3
            object Label168: TLabel
              Left = 7
              Top = 34
              Width = 108
              Height = 12
              Caption = 'HP/MP'#35843#33410'('#30334#20998#27604'):'
            end
            object Label218: TLabel
              Left = 7
              Top = 51
              Width = 24
              Height = 12
              Caption = #25112#22763
            end
            object Label219: TLabel
              Left = 7
              Top = 72
              Width = 24
              Height = 12
              Caption = #27861#24072
            end
            object Label220: TLabel
              Left = 7
              Top = 92
              Width = 24
              Height = 12
              Caption = #36947#22763
            end
            object CheckBoxHeroMaxHealthType: TCheckBox
              Left = 7
              Top = 15
              Width = 113
              Height = 17
              Hint = #26159#21542#20197#20154#29289#30340'HP/MP'#20316#20026#22522#30784#26469#35745#31639#33521#38596#30340'HP/MP,'#40664#35748#19981#38057#36873
              Caption = #20197#20154#29289'HPMP'#35745#31639
              TabOrder = 0
              OnClick = CheckBoxHeroMaxHealthTypeClick
            end
            object SpinEditHeroMaxHealthRate: TSpinEdit
              Left = 66
              Top = 48
              Width = 42
              Height = 21
              Hint = #33521#38596#34880#37327#21644#39764#27861#20540#30340#35745#31639#20493#25968','#40664#35748'100'
              MaxValue = 9999
              MinValue = 1
              TabOrder = 1
              Value = 100
              OnChange = SpinEditHeroMaxHealthRateChange
            end
            object SpinEditHeroMaxHealthRate1: TSpinEdit
              Left = 66
              Top = 69
              Width = 42
              Height = 21
              Hint = #33521#38596#34880#37327#21644#39764#27861#20540#30340#35745#31639#20493#25968','#40664#35748'100'
              MaxValue = 9999
              MinValue = 1
              TabOrder = 2
              Value = 100
              OnChange = SpinEditHeroMaxHealthRateChange
            end
            object SpinEditHeroMaxHealthRate2: TSpinEdit
              Left = 66
              Top = 89
              Width = 42
              Height = 21
              Hint = #33521#38596#34880#37327#21644#39764#27861#20540#30340#35745#31639#20493#25968','#40664#35748'100'
              MaxValue = 9999
              MinValue = 1
              TabOrder = 3
              Value = 100
              OnChange = SpinEditHeroMaxHealthRateChange
            end
          end
          object cbHeroAutoLockTarget: TCheckBox
            Left = 13
            Top = 105
            Width = 217
            Height = 18
            Caption = 'CTRL+S'#26102#65292#33258#21160#38145#23450#20027#20154#25915#20987#30340#30446#26631
            TabOrder = 4
            OnClick = CheckBoxHeroMaxHealthTypeClick
          end
          object boHeroEvade: TCheckBox
            Left = 13
            Top = 123
            Width = 217
            Height = 18
            Hint = #21551#29992#21518#65292#33521#38596#20250#22260#32469#30446#26631#25915#20987#65292#36991#20813#25307#24341#22826#22810#30340#24618#29289
            Caption = #22260#32469#30446#26631#25915#20987
            TabOrder = 5
            OnClick = CheckBoxHeroMaxHealthTypeClick
          end
          object boHeroRecalcWalkTick: TCheckBox
            Left = 13
            Top = 139
            Width = 217
            Height = 18
            Hint = #23454#26102#30417#27979#30446#26631#27493#20240#65292#26234#33021#24555#36895#36530#36991#65292#19968#33324#19981#21551#29992#35813#36873#39033#65292#20197#20813#33521#38596#36807#20110#28789#27963#12290
            Caption = #26426#26234#36530#36991'('#19968#33324#19981#21551#29992')'
            TabOrder = 6
            OnClick = CheckBoxHeroMaxHealthTypeClick
          end
          object boHeroHitCmp: TCheckBox
            Left = 10
            Top = 1
            Width = 93
            Height = 18
            Hint = #19968#33324#19981#24314#35758#24320#21551#65292#36866#21512#20110'BT'#26381
            Caption = #32452#21512#36895#24230#34917#20607
            TabOrder = 7
            OnClick = CheckBoxHeroMaxHealthTypeClick
          end
        end
      end
    end
    object TabSheet52: TTabSheet
      Caption = #25366#23453#37492#23453
      ImageIndex = 13
      object PageControl3: TPageControl
        Left = 0
        Top = 0
        Width = 449
        Height = 301
        ActivePage = TabSheet54
        Align = alClient
        TabOrder = 0
        object TabSheet54: TTabSheet
          Caption = #37492#23453
          ImageIndex = 1
          object PageControl4: TPageControl
            Left = 0
            Top = 0
            Width = 441
            Height = 274
            ActivePage = TabSheet55
            Align = alClient
            TabOrder = 0
            object TabSheet55: TTabSheet
              Caption = #20844#29992#35774#32622
              object PageControl5: TPageControl
                Left = 0
                Top = 0
                Width = 433
                Height = 247
                ActivePage = TabSheet61
                Align = alClient
                TabOrder = 0
                object TabSheet59: TTabSheet
                  Caption = #22522#26412#35774#32622
                  object Label265: TLabel
                    Left = 203
                    Top = 11
                    Width = 54
                    Height = 12
                    Caption = #39640#32423#37492#23450':'
                  end
                  object Label263: TLabel
                    Left = 8
                    Top = 11
                    Width = 52
                    Height = 12
                    Caption = #37492#23450#20960#29575
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label264: TLabel
                    Left = 90
                    Top = 11
                    Width = 54
                    Height = 12
                    Caption = #26222#36890#37492#23450':'
                  end
                  object Label256: TLabel
                    Left = 8
                    Top = 34
                    Width = 52
                    Height = 12
                    Caption = #28789#23186#21697#36136
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label257: TLabel
                    Left = 90
                    Top = 34
                    Width = 54
                    Height = 12
                    Caption = #20986#29616#20960#29575':'
                  end
                  object Label266: TLabel
                    Left = 8
                    Top = 82
                    Width = 52
                    Height = 12
                    Caption = #26356#25442#29289#21697
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label267: TLabel
                    Left = 90
                    Top = 81
                    Width = 54
                    Height = 12
                    Caption = #25104#21151#20960#29575':'
                  end
                  object Label261: TLabel
                    Left = 203
                    Top = 57
                    Width = 54
                    Height = 12
                    Caption = #26368#22810#20010#25968':'
                  end
                  object Label262: TLabel
                    Left = 316
                    Top = 56
                    Width = 54
                    Height = 12
                    Caption = #20010#25968#20986#29575':'
                  end
                  object Label260: TLabel
                    Left = 90
                    Top = 57
                    Width = 54
                    Height = 12
                    Caption = #20986#29616#20960#29575':'
                  end
                  object Label259: TLabel
                    Left = 203
                    Top = 34
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label258: TLabel
                    Left = 8
                    Top = 58
                    Width = 52
                    Height = 12
                    Caption = #31070#31192#23646#24615
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label377: TLabel
                    Left = 8
                    Top = 105
                    Width = 52
                    Height = 12
                    Caption = #31070#31192#35299#35835
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label378: TLabel
                    Left = 90
                    Top = 104
                    Width = 54
                    Height = 12
                    Caption = #25104#21151#20960#29575':'
                  end
                  object Label394: TLabel
                    Left = 203
                    Top = 82
                    Width = 186
                    Height = 12
                    Caption = #31934#21147#20540#22686#38271#26102#38388#38388#38548'           '#31186
                  end
                  object Label393: TLabel
                    Left = 8
                    Top = 128
                    Width = 52
                    Height = 12
                    Caption = #21046#20316#21367#36724
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label395: TLabel
                    Left = 90
                    Top = 127
                    Width = 54
                    Height = 12
                    Caption = #25104#21151#20960#29575':'
                  end
                  object Label398: TLabel
                    Left = 110
                    Top = 150
                    Width = 30
                    Height = 12
                    Caption = #25112#22763':'
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clRed
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label399: TLabel
                    Left = 109
                    Top = 174
                    Width = 30
                    Height = 12
                    Caption = #27861#24072':'
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clRed
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label400: TLabel
                    Left = 109
                    Top = 197
                    Width = 30
                    Height = 12
                    Caption = #36947#22763':'
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clRed
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label402: TLabel
                    Left = 8
                    Top = 152
                    Width = 73
                    Height = 12
                    Caption = #24378#36523'+HP'#27604#20363
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label401: TLabel
                    Left = 203
                    Top = 152
                    Width = 73
                    Height = 12
                    Caption = #32858#39764'+MP'#27604#20363
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label403: TLabel
                    Left = 304
                    Top = 148
                    Width = 30
                    Height = 12
                    Caption = #25112#22763':'
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label404: TLabel
                    Left = 304
                    Top = 174
                    Width = 30
                    Height = 12
                    Caption = #27861#24072':'
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label405: TLabel
                    Left = 304
                    Top = 197
                    Width = 30
                    Height = 12
                    Caption = #36947#22763':'
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = []
                    ParentFont = False
                  end
                  object setiSpiritAddRate: TSpinEdit
                    Tag = -1
                    Left = 145
                    Top = 30
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 0
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object setiSpiritAddValueRate: TSpinEdit
                    Tag = -2
                    Left = 258
                    Top = 31
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 1
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object setiSucessRate: TSpinEdit
                    Tag = -6
                    Left = 145
                    Top = 7
                    Width = 41
                    Height = 21
                    Hint = #25968#23383#36234#22823#20960#29575#36234#22823#65288#30334#20998#27604#65289#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 2
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object setiSucessRateEx: TSpinEdit
                    Tag = -7
                    Left = 258
                    Top = 7
                    Width = 41
                    Height = 21
                    Hint = #25968#23383#36234#23567#65292#20960#29575#36234#22823#65288#25351#24471#21040#20027#23472#35013#22791#65289#12290#13#22914#22833#36133#65292#21017#36339#36716#21040#26222#36890#37492#23450#65292#26159#21542#37492#23450#25104#21151#27492#26102#30001#26222#36890#37492#23450#20960#29575#20915#23450#12290
                    EditorEnabled = False
                    MaxValue = 9999
                    MinValue = 1
                    TabOrder = 3
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object setiSecretPropertyAddValueRate: TSpinEdit
                    Tag = -5
                    Left = 371
                    Top = 53
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#22810#20010#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 4
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object setiSecretPropertyAddRate: TSpinEdit
                    Tag = -3
                    Left = 145
                    Top = 53
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 5
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object setiSecretPropertyAddValueMaxLimit: TSpinEdit
                    Tag = -4
                    Left = 258
                    Top = 54
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 10
                    MinValue = 1
                    TabOrder = 6
                    Value = 10
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object setiExchangeItemRate: TSpinEdit
                    Tag = -8
                    Left = 145
                    Top = 77
                    Width = 41
                    Height = 21
                    Hint = #25968#23383#36234#22823#20960#29575#36234#22823#65288#30334#20998#27604#65289#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 7
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object spSecretPropertySucessRate: TSpinEdit
                    Tag = -9
                    Left = 145
                    Top = 101
                    Width = 41
                    Height = 21
                    Hint = #25968#23383#36234#22823#65292#20960#29575#36234#22823#12290#13#35299#35835#25104#21151#29575#21462#20915#20110#21367#36724#30340#29087#32451#24230#65292#22312#27492#22522#30784#19978#65292#27492#21442#25968#26159#24178#39044#35843#33410#20316#29992#12290
                    EditorEnabled = False
                    MaxValue = 9999
                    MinValue = 1
                    TabOrder = 8
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object spEnergyAddTime: TSpinEdit
                    Tag = -10
                    Left = 316
                    Top = 78
                    Width = 57
                    Height = 21
                    MaxValue = 99999
                    MinValue = 1
                    TabOrder = 9
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpSkillAddHPMax: TCheckBox
                    Left = 203
                    Top = 104
                    Width = 123
                    Height = 17
                    Caption = #31070#31192#35299#35835#25216#33021'+HP'
                    TabOrder = 10
                    OnClick = tiSpSkillAddHPMaxClick
                  end
                  object spMakeBookSucessRate: TSpinEdit
                    Tag = -11
                    Left = 145
                    Top = 124
                    Width = 41
                    Height = 21
                    Hint = #21046#20316#21367#36724#30340#25104#21151#20960#29575#34917#20607#12290#25968#23383#36234#22823#65292#20960#29575#36234#22823#12290
                    EditorEnabled = False
                    MaxValue = 9999
                    MinValue = 1
                    TabOrder = 11
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiHPSkillAddHPMax: TCheckBox
                    Tag = 1
                    Left = 8
                    Top = 170
                    Width = 95
                    Height = 17
                    Caption = #24320#21551#24378#36523'+HP'
                    TabOrder = 12
                    OnClick = tiSpSkillAddHPMaxClick
                  end
                  object tiMPSkillAddMPMax: TCheckBox
                    Tag = 2
                    Left = 203
                    Top = 170
                    Width = 93
                    Height = 17
                    Caption = #24320#21551#32858#39764'+MP'
                    TabOrder = 13
                    OnClick = tiSpSkillAddHPMaxClick
                  end
                  object tiAddHealthPlus_0: TSpinEdit
                    Tag = -12
                    Left = 145
                    Top = 147
                    Width = 41
                    Height = 21
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 14
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAddHealthPlus_1: TSpinEdit
                    Tag = -13
                    Left = 145
                    Top = 171
                    Width = 41
                    Height = 21
                    EditorEnabled = False
                    MaxValue = 9999
                    MinValue = 1
                    TabOrder = 15
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAddHealthPlus_2: TSpinEdit
                    Tag = -14
                    Left = 145
                    Top = 194
                    Width = 41
                    Height = 21
                    EditorEnabled = False
                    MaxValue = 9999
                    MinValue = 1
                    TabOrder = 16
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAddSpellPlus_0: TSpinEdit
                    Tag = -15
                    Left = 339
                    Top = 147
                    Width = 41
                    Height = 21
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 17
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAddSpellPlus_1: TSpinEdit
                    Tag = -16
                    Left = 339
                    Top = 171
                    Width = 41
                    Height = 21
                    EditorEnabled = False
                    MaxValue = 9999
                    MinValue = 1
                    TabOrder = 18
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAddSpellPlus_2: TSpinEdit
                    Tag = -17
                    Left = 339
                    Top = 191
                    Width = 41
                    Height = 21
                    EditorEnabled = False
                    MaxValue = 9999
                    MinValue = 1
                    TabOrder = 19
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiPutAbilOnce: TCheckBox
                    Tag = 5
                    Left = 202
                    Top = 124
                    Width = 146
                    Height = 17
                    Caption = #26222#36890#37492#23450#27599#27425#36171#20104'1'#23646#24615
                    TabOrder = 20
                    OnClick = tiSpSkillAddHPMaxClick
                  end
                end
                object TabSheet60: TTabSheet
                  Caption = #29289#21697#23646#24615#19968
                  ImageIndex = 1
                  object Label313: TLabel
                    Left = 7
                    Top = 11
                    Width = 65
                    Height = 12
                    Caption = #30446#26631#29190#29575#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label314: TLabel
                    Left = 7
                    Top = 34
                    Width = 39
                    Height = 12
                    Caption = #38450#29190#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label315: TLabel
                    Left = 7
                    Top = 57
                    Width = 65
                    Height = 12
                    Caption = #21560#34880#19978#38480#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label316: TLabel
                    Left = 7
                    Top = 80
                    Width = 65
                    Height = 12
                    Caption = #20869#21147#24674#22797#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label317: TLabel
                    Left = 89
                    Top = 10
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label318: TLabel
                    Left = 89
                    Top = 33
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label319: TLabel
                    Left = 89
                    Top = 56
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label320: TLabel
                    Left = 89
                    Top = 79
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label321: TLabel
                    Left = 202
                    Top = 10
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label322: TLabel
                    Left = 202
                    Top = 33
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label323: TLabel
                    Left = 202
                    Top = 56
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label324: TLabel
                    Left = 202
                    Top = 79
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label325: TLabel
                    Left = 315
                    Top = 9
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label326: TLabel
                    Left = 315
                    Top = 32
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label327: TLabel
                    Left = 315
                    Top = 55
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label328: TLabel
                    Left = 315
                    Top = 78
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label329: TLabel
                    Left = 7
                    Top = 103
                    Width = 65
                    Height = 12
                    Caption = #20869#21147#19978#38480#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label330: TLabel
                    Left = 7
                    Top = 126
                    Width = 65
                    Height = 12
                    Caption = #20869#21151#20260#23475#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label331: TLabel
                    Left = 7
                    Top = 149
                    Width = 65
                    Height = 12
                    Caption = #20869#21151#20943#20813#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label332: TLabel
                    Left = 7
                    Top = 172
                    Width = 65
                    Height = 12
                    Caption = #20869#20260#31561#32423#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label333: TLabel
                    Left = 89
                    Top = 102
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label334: TLabel
                    Left = 89
                    Top = 125
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label335: TLabel
                    Left = 89
                    Top = 148
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label336: TLabel
                    Left = 89
                    Top = 171
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label337: TLabel
                    Left = 202
                    Top = 102
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label338: TLabel
                    Left = 202
                    Top = 125
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label339: TLabel
                    Left = 202
                    Top = 148
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label340: TLabel
                    Left = 202
                    Top = 171
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label341: TLabel
                    Left = 315
                    Top = 101
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label342: TLabel
                    Left = 315
                    Top = 124
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label343: TLabel
                    Left = 315
                    Top = 147
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label344: TLabel
                    Left = 315
                    Top = 170
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label426: TLabel
                    Left = 7
                    Top = 195
                    Width = 288
                    Height = 12
                    Caption = #20960#29575#23646#24615' '#39033#35774#32622#25968#20540#20026'0'#26102#65292#35013#22791#23558#19981#20250#20986#29616#27492#23646#24615#12290
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clRed
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = []
                    ParentFont = False
                  end
                  object tiAbilTagDropAddRate: TSpinEdit
                    Tag = 100
                    Left = 144
                    Top = 6
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 0
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPreDropAddRate: TSpinEdit
                    Tag = 103
                    Left = 144
                    Top = 29
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 1
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilSuckAddRate: TSpinEdit
                    Tag = 106
                    Left = 144
                    Top = 52
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 2
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpRecoverAddRate: TSpinEdit
                    Tag = 109
                    Left = 144
                    Top = 75
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 3
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilTagDropAddValueMaxLimit: TSpinEdit
                    Tag = 101
                    Left = 257
                    Top = 7
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 4
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPreDropAddValueMaxLimit: TSpinEdit
                    Tag = 104
                    Left = 257
                    Top = 30
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 5
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilSuckAddValueMaxLimit: TSpinEdit
                    Tag = 107
                    Left = 257
                    Top = 53
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 6
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpRecoverAddValueMaxLimit: TSpinEdit
                    Tag = 110
                    Left = 257
                    Top = 76
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 7
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilTagDropAddValueRate: TSpinEdit
                    Tag = 102
                    Left = 370
                    Top = 6
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 8
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPreDropAddValueRate: TSpinEdit
                    Tag = 105
                    Left = 370
                    Top = 29
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 9
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilSuckAddValueRate: TSpinEdit
                    Tag = 108
                    Left = 370
                    Top = 52
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 10
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpRecoverAddValueRate: TSpinEdit
                    Tag = 111
                    Left = 370
                    Top = 75
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 11
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpExAddRate: TSpinEdit
                    Tag = 112
                    Left = 144
                    Top = 98
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 12
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpDamAddRate: TSpinEdit
                    Tag = 115
                    Left = 144
                    Top = 121
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 13
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpReduceAddRate: TSpinEdit
                    Tag = 118
                    Left = 144
                    Top = 144
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 14
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpDecAddRate: TSpinEdit
                    Tag = 121
                    Left = 144
                    Top = 167
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 15
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpExAddValueMaxLimit: TSpinEdit
                    Tag = 113
                    Left = 257
                    Top = 99
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 16
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpDamAddValueMaxLimit: TSpinEdit
                    Tag = 116
                    Left = 257
                    Top = 122
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 17
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpReduceAddValueMaxLimit: TSpinEdit
                    Tag = 119
                    Left = 257
                    Top = 145
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 18
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpDecAddValueMaxLimit: TSpinEdit
                    Tag = 122
                    Left = 257
                    Top = 168
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 19
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpExAddValueRate: TSpinEdit
                    Tag = 114
                    Left = 370
                    Top = 98
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 20
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpDamAddValueRate: TSpinEdit
                    Tag = 117
                    Left = 370
                    Top = 121
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 21
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpReduceAddValueRate: TSpinEdit
                    Tag = 120
                    Left = 370
                    Top = 144
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 22
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilIpDecAddValueRate: TSpinEdit
                    Tag = 123
                    Left = 370
                    Top = 167
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 23
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                end
                object TabSheet58: TTabSheet
                  Caption = #29289#21697#23646#24615#20108
                  ImageIndex = 2
                  object Label345: TLabel
                    Left = 89
                    Top = 79
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label346: TLabel
                    Left = 202
                    Top = 33
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label347: TLabel
                    Left = 202
                    Top = 10
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label348: TLabel
                    Left = 7
                    Top = 57
                    Width = 65
                    Height = 12
                    Caption = #40635#30201#25239#24615#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label349: TLabel
                    Left = 7
                    Top = 34
                    Width = 65
                    Height = 12
                    Caption = #21512#20987#23041#21147#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label350: TLabel
                    Left = 7
                    Top = 11
                    Width = 65
                    Height = 12
                    Caption = #26292#20987#23041#21147#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label351: TLabel
                    Left = 7
                    Top = 80
                    Width = 65
                    Height = 12
                    Caption = #24378#36523#31561#32423#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label352: TLabel
                    Left = 89
                    Top = 56
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label353: TLabel
                    Left = 89
                    Top = 33
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label354: TLabel
                    Left = 89
                    Top = 10
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label355: TLabel
                    Left = 315
                    Top = 78
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label356: TLabel
                    Left = 315
                    Top = 55
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label357: TLabel
                    Left = 315
                    Top = 32
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label358: TLabel
                    Left = 202
                    Top = 79
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label359: TLabel
                    Left = 202
                    Top = 56
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label360: TLabel
                    Left = 315
                    Top = 9
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label361: TLabel
                    Left = 89
                    Top = 171
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label362: TLabel
                    Left = 202
                    Top = 125
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label363: TLabel
                    Left = 202
                    Top = 102
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label364: TLabel
                    Left = 7
                    Top = 149
                    Width = 65
                    Height = 12
                    Caption = #27602#29289#36530#36991#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label365: TLabel
                    Left = 7
                    Top = 126
                    Width = 52
                    Height = 12
                    Caption = #20027#23646#24615#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label366: TLabel
                    Left = 7
                    Top = 103
                    Width = 65
                    Height = 12
                    Caption = #32858#39764#31561#32423#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label367: TLabel
                    Left = 7
                    Top = 172
                    Width = 65
                    Height = 12
                    Caption = #20013#27602#24674#22797#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlue
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label368: TLabel
                    Left = 89
                    Top = 148
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label369: TLabel
                    Left = 89
                    Top = 125
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label370: TLabel
                    Left = 89
                    Top = 102
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label371: TLabel
                    Left = 315
                    Top = 170
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label372: TLabel
                    Left = 315
                    Top = 147
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label373: TLabel
                    Left = 315
                    Top = 124
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label374: TLabel
                    Left = 202
                    Top = 171
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label375: TLabel
                    Left = 202
                    Top = 148
                    Width = 54
                    Height = 12
                    Caption = #26368#39640#28857#25968':'
                  end
                  object Label376: TLabel
                    Left = 315
                    Top = 101
                    Width = 54
                    Height = 12
                    Caption = #28857#25968#26426#29575':'
                  end
                  object Label427: TLabel
                    Left = 7
                    Top = 195
                    Width = 288
                    Height = 12
                    Caption = #20960#29575#23646#24615' '#39033#35774#32622#25968#20540#20026'0'#26102#65292#35013#22791#23558#19981#20250#20986#29616#27492#23646#24615#12290
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clRed
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = []
                    ParentFont = False
                  end
                  object tiAbilGangUpAddRate: TSpinEdit
                    Tag = 127
                    Left = 144
                    Top = 29
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 0
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilBangAddRate: TSpinEdit
                    Tag = 124
                    Left = 144
                    Top = 6
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 1
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPalsyReduceAddRate: TSpinEdit
                    Tag = 130
                    Left = 144
                    Top = 52
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 2
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilHPExAddRate: TSpinEdit
                    Tag = 133
                    Left = 144
                    Top = 75
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 3
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilBangAddValueRate: TSpinEdit
                    Tag = 126
                    Left = 370
                    Top = 6
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 4
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilHPExAddValueRate: TSpinEdit
                    Tag = 135
                    Left = 370
                    Top = 75
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 5
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPalsyReduceAddValueRate: TSpinEdit
                    Tag = 132
                    Left = 370
                    Top = 52
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 6
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilGangUpAddValueRate: TSpinEdit
                    Tag = 129
                    Left = 370
                    Top = 29
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 7
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilBangAddValueMaxLimit: TSpinEdit
                    Tag = 125
                    Left = 257
                    Top = 7
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 8
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilGangUpAddValueMaxLimit: TSpinEdit
                    Tag = 128
                    Left = 257
                    Top = 30
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 9
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilHPExAddValueMaxLimit: TSpinEdit
                    Tag = 134
                    Left = 257
                    Top = 76
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 10
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPalsyReduceAddValueMaxLimit: TSpinEdit
                    Tag = 131
                    Left = 257
                    Top = 53
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 11
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilCCAddRate: TSpinEdit
                    Tag = 139
                    Left = 144
                    Top = 121
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 12
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilMPExAddRate: TSpinEdit
                    Tag = 136
                    Left = 144
                    Top = 98
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 13
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPoisonReduceAddRate: TSpinEdit
                    Tag = 142
                    Left = 144
                    Top = 144
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 14
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPoisonRecoverAddRate: TSpinEdit
                    Tag = 145
                    Left = 144
                    Top = 167
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 15
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilMPExAddValueRate: TSpinEdit
                    Tag = 138
                    Left = 370
                    Top = 98
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 16
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPoisonRecoverAddValueRate: TSpinEdit
                    Tag = 147
                    Left = 370
                    Top = 167
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 17
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPoisonReduceAddValueRate: TSpinEdit
                    Tag = 144
                    Left = 370
                    Top = 144
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 18
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilCCAddValueRate: TSpinEdit
                    Tag = 141
                    Left = 370
                    Top = 121
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                    EditorEnabled = False
                    MaxValue = 100
                    MinValue = 1
                    TabOrder = 19
                    Value = 100
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilMPExAddValueMaxLimit: TSpinEdit
                    Tag = 137
                    Left = 257
                    Top = 99
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 20
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilCCAddValueMaxLimit: TSpinEdit
                    Tag = 140
                    Left = 257
                    Top = 122
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 21
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPoisonRecoverAddValueMaxLimit: TSpinEdit
                    Tag = 146
                    Left = 257
                    Top = 168
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 22
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiAbilPoisonReduceAddValueMaxLimit: TSpinEdit
                    Tag = 143
                    Left = 257
                    Top = 145
                    Width = 41
                    Height = 21
                    Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                    EditorEnabled = False
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 23
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                end
                object TabSheet61: TTabSheet
                  Caption = #29305#27530#23646#24615#21644#25216#33021
                  ImageIndex = 3
                  object Label409: TLabel
                    Left = 3
                    Top = 26
                    Width = 65
                    Height = 12
                    Caption = #20116#23731#29420#23562#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clFuchsia
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label410: TLabel
                    Left = 3
                    Top = 49
                    Width = 65
                    Height = 12
                    Caption = #21484#21796#24040#39764#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clFuchsia
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label411: TLabel
                    Left = 3
                    Top = 72
                    Width = 65
                    Height = 12
                    Caption = #31070#40857#38468#20307#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clFuchsia
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label412: TLabel
                    Left = 3
                    Top = 95
                    Width = 65
                    Height = 12
                    Caption = #20506#22825#21128#22320#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clFuchsia
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label413: TLabel
                    Left = 3
                    Top = 118
                    Width = 79
                    Height = 12
                    Caption = #24453#22686#21152'('#31354')'#65306
                    Enabled = False
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clFuchsia
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label414: TLabel
                    Left = 3
                    Top = 141
                    Width = 79
                    Height = 12
                    Caption = #24453#22686#21152'('#31354')'#65306
                    Enabled = False
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clFuchsia
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label415: TLabel
                    Left = 3
                    Top = 164
                    Width = 79
                    Height = 12
                    Caption = #24453#22686#21152'('#31354')'#65306
                    Enabled = False
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clFuchsia
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label416: TLabel
                    Left = 85
                    Top = 25
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label417: TLabel
                    Left = 85
                    Top = 48
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label418: TLabel
                    Left = 85
                    Top = 71
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label419: TLabel
                    Left = 85
                    Top = 94
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label420: TLabel
                    Left = 85
                    Top = 117
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label421: TLabel
                    Left = 85
                    Top = 140
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label422: TLabel
                    Left = 85
                    Top = 163
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label423: TLabel
                    Left = 3
                    Top = 187
                    Width = 79
                    Height = 12
                    Caption = #24453#22686#21152'('#31354')'#65306
                    Enabled = False
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clFuchsia
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label424: TLabel
                    Left = 85
                    Top = 186
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label379: TLabel
                    Left = 202
                    Top = 49
                    Width = 65
                    Height = 12
                    Caption = #20843#21350#25252#36523#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clGreen
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label380: TLabel
                    Left = 202
                    Top = 72
                    Width = 65
                    Height = 12
                    Caption = #25112#24847#40635#30201#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clGreen
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label381: TLabel
                    Left = 202
                    Top = 95
                    Width = 39
                    Height = 12
                    Caption = #37325#29983#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clGreen
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label382: TLabel
                    Left = 202
                    Top = 118
                    Width = 39
                    Height = 12
                    Caption = #25506#27979#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clGreen
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label383: TLabel
                    Left = 202
                    Top = 141
                    Width = 39
                    Height = 12
                    Caption = #20256#36865#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clGreen
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label384: TLabel
                    Left = 202
                    Top = 164
                    Width = 39
                    Height = 12
                    Caption = #40635#30201#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clGreen
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label385: TLabel
                    Left = 202
                    Top = 187
                    Width = 65
                    Height = 12
                    Caption = #39764#36947#40635#30201#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clGreen
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label386: TLabel
                    Left = 284
                    Top = 48
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label387: TLabel
                    Left = 284
                    Top = 71
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label388: TLabel
                    Left = 284
                    Top = 94
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label389: TLabel
                    Left = 284
                    Top = 117
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label390: TLabel
                    Left = 284
                    Top = 140
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label391: TLabel
                    Left = 284
                    Top = 163
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label392: TLabel
                    Left = 284
                    Top = 186
                    Width = 54
                    Height = 12
                    Caption = #23646#24615#20960#29575':'
                  end
                  object Label425: TLabel
                    Left = 202
                    Top = 26
                    Width = 104
                    Height = 12
                    Caption = #8592#26368#39640#25216#33021#31561#32423#65306
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = [fsBold]
                    ParentFont = False
                  end
                  object Label428: TLabel
                    Left = 3
                    Top = 205
                    Width = 288
                    Height = 12
                    Caption = #20960#29575#23646#24615' '#39033#35774#32622#25968#20540#20026'0'#26102#65292#35013#22791#23558#19981#20250#20986#29616#27492#23646#24615#12290
                    Font.Charset = ANSI_CHARSET
                    Font.Color = clRed
                    Font.Height = -12
                    Font.Name = #23435#20307
                    Font.Style = []
                    ParentFont = False
                  end
                  object tiSpMagicAddRate1: TSpinEdit
                    Tag = 157
                    Left = 140
                    Top = 21
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 0
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpMagicAddRate2: TSpinEdit
                    Tag = 158
                    Left = 140
                    Top = 44
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 1
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpMagicAddRate3: TSpinEdit
                    Tag = 159
                    Left = 140
                    Top = 67
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 2
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpMagicAddRate4: TSpinEdit
                    Tag = 160
                    Left = 140
                    Top = 90
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 3
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpMagicAddRate5: TSpinEdit
                    Tag = 161
                    Left = 140
                    Top = 113
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 4
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpMagicAddRate6: TSpinEdit
                    Tag = 162
                    Left = 140
                    Top = 136
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 5
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpMagicAddRate7: TSpinEdit
                    Tag = 163
                    Left = 140
                    Top = 159
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 6
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpMagicAddRate8: TSpinEdit
                    Tag = 164
                    Left = 140
                    Top = 182
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 7
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object SpecialSkills1: TSpinEdit
                    Tag = 150
                    Left = 339
                    Top = 44
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 8
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object SpecialSkills2: TSpinEdit
                    Tag = 151
                    Left = 339
                    Top = 67
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 9
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object SpecialSkills3: TSpinEdit
                    Tag = 152
                    Left = 339
                    Top = 90
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 10
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object SpecialSkills4: TSpinEdit
                    Tag = 153
                    Left = 339
                    Top = 113
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 11
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object SpecialSkills5: TSpinEdit
                    Tag = 154
                    Left = 339
                    Top = 136
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 12
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object SpecialSkills6: TSpinEdit
                    Tag = 155
                    Left = 339
                    Top = 159
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 13
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object SpecialSkills7: TSpinEdit
                    Tag = 156
                    Left = 339
                    Top = 182
                    Width = 41
                    Height = 21
                    Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                    MaxValue = 99999
                    MinValue = 0
                    TabOrder = 14
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpMagicAddMaxLevel: TSpinEdit
                    Tag = 165
                    Left = 339
                    Top = 21
                    Width = 41
                    Height = 21
                    Hint = 
                      #38480#21046#25216#33021#30340#26368#39640#31561#32423#65288'1~15'#65289#12290#13#20986#29616#25216#33021#23646#24615#30340#21487#20197#26159#27494#22120#21644#20854#20182#30340#26381#39280#65292#27599#20010#35013#22791#20986#29616#21516#26679#30340#13#25216#33021#65292#21017#35013#22791#25216#33021#31561#32423'+1'#65292#27880#24847#65306#20986#29616 +
                      #25216#33021#24517#39035#20197#27494#22120#20026#22522#30784#12290
                    MaxValue = 15
                    MinValue = 1
                    TabOrder = 15
                    Value = 15
                    OnChange = setiWeaponDCAddRateChange
                  end
                  object tiSpMagicAddAtFirst: TCheckBox
                    Tag = 3
                    Left = 3
                    Top = 2
                    Width = 233
                    Height = 17
                    Caption = #35299#35835#31070#31192#23646#24615#26102#20248#20808#35745#31639#25216#33021#20986#29616#20960#29575
                    TabOrder = 16
                    OnClick = tiSpSkillAddHPMaxClick
                  end
                end
              end
            end
            object TabSheet56: TTabSheet
              Caption = #27494#22120#23646#24615
              ImageIndex = 1
              object Label226: TLabel
                Left = 90
                Top = 11
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label224: TLabel
                Left = 203
                Top = 11
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label225: TLabel
                Left = 316
                Top = 10
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label227: TLabel
                Left = 8
                Top = 12
                Width = 39
                Height = 12
                Caption = #25915#20987#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label228: TLabel
                Left = 8
                Top = 35
                Width = 39
                Height = 12
                Caption = #39764#27861#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label229: TLabel
                Left = 90
                Top = 34
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label230: TLabel
                Left = 203
                Top = 34
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label231: TLabel
                Left = 316
                Top = 33
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label232: TLabel
                Left = 8
                Top = 58
                Width = 39
                Height = 12
                Caption = #36947#26415#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label233: TLabel
                Left = 203
                Top = 57
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label234: TLabel
                Left = 316
                Top = 56
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label235: TLabel
                Left = 90
                Top = 57
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label236: TLabel
                Left = 8
                Top = 101
                Width = 39
                Height = 12
                Caption = #24184#36816#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label237: TLabel
                Left = 203
                Top = 100
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label238: TLabel
                Left = 316
                Top = 99
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label239: TLabel
                Left = 90
                Top = 100
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label240: TLabel
                Left = 8
                Top = 193
                Width = 39
                Height = 12
                Caption = #31070#22307#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label241: TLabel
                Left = 203
                Top = 192
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label242: TLabel
                Left = 316
                Top = 191
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label243: TLabel
                Left = 90
                Top = 192
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label244: TLabel
                Left = 8
                Top = 170
                Width = 39
                Height = 12
                Caption = #25915#36895#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label245: TLabel
                Left = 203
                Top = 169
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label246: TLabel
                Left = 316
                Top = 168
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label247: TLabel
                Left = 90
                Top = 169
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label248: TLabel
                Left = 90
                Top = 123
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label249: TLabel
                Left = 316
                Top = 122
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label250: TLabel
                Left = 203
                Top = 123
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label251: TLabel
                Left = 8
                Top = 124
                Width = 39
                Height = 12
                Caption = #35781#21650#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label252: TLabel
                Left = 90
                Top = 146
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label253: TLabel
                Left = 8
                Top = 147
                Width = 39
                Height = 12
                Caption = #20934#30830#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label254: TLabel
                Left = 203
                Top = 146
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label255: TLabel
                Left = 316
                Top = 145
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label429: TLabel
                Left = 8
                Top = 227
                Width = 288
                Height = 12
                Caption = #20960#29575#23646#24615' '#39033#35774#32622#25968#20540#20026'0'#26102#65292#35013#22791#23558#19981#20250#20986#29616#27492#23646#24615#12290
                Font.Charset = ANSI_CHARSET
                Font.Color = clRed
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = []
                ParentFont = False
              end
              object setiWeaponDCAddRate: TSpinEdit
                Left = 145
                Top = 7
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 0
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponDCAddValueMaxLimit: TSpinEdit
                Tag = 1
                Left = 258
                Top = 8
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 1
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponDCAddValueRate: TSpinEdit
                Tag = 2
                Left = 371
                Top = 7
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 2
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponMCAddRate: TSpinEdit
                Tag = 3
                Left = 145
                Top = 30
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 3
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponMCAddValueMaxLimit: TSpinEdit
                Tag = 4
                Left = 258
                Top = 31
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 4
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponMCAddValueRate: TSpinEdit
                Tag = 5
                Left = 371
                Top = 30
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 5
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponSCAddRate: TSpinEdit
                Tag = 6
                Left = 145
                Top = 53
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 6
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponSCAddValueMaxLimit: TSpinEdit
                Tag = 7
                Left = 258
                Top = 54
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 7
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponSCAddValueRate: TSpinEdit
                Tag = 8
                Left = 371
                Top = 53
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 8
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponLuckAddValueMaxLimit: TSpinEdit
                Tag = 10
                Left = 258
                Top = 97
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 9
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponLuckAddValueRate: TSpinEdit
                Tag = 11
                Left = 371
                Top = 96
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 10
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponLuckAddRate: TSpinEdit
                Tag = 9
                Left = 145
                Top = 96
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 11
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponHolyAddValueMaxLimit: TSpinEdit
                Tag = 22
                Left = 258
                Top = 189
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 12
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponHolyAddValueRate: TSpinEdit
                Tag = 23
                Left = 371
                Top = 188
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 13
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponHolyAddRate: TSpinEdit
                Tag = 21
                Left = 145
                Top = 188
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 14
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponHitSpdAddRate: TSpinEdit
                Tag = 18
                Left = 145
                Top = 165
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 15
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponHitSpdAddValueMaxLimit: TSpinEdit
                Tag = 19
                Left = 258
                Top = 166
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 16
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponHitSpdAddValueRate: TSpinEdit
                Tag = 20
                Left = 371
                Top = 165
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 17
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponCurseAddValueMaxLimit: TSpinEdit
                Tag = 13
                Left = 258
                Top = 120
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 18
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponCurseAddRate: TSpinEdit
                Tag = 12
                Left = 145
                Top = 119
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 19
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponCurseAddValueRate: TSpinEdit
                Tag = 14
                Left = 371
                Top = 119
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 20
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponHitAddRate: TSpinEdit
                Tag = 15
                Left = 145
                Top = 142
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 21
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponHitAddValueRate: TSpinEdit
                Tag = 17
                Left = 371
                Top = 142
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 22
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWeaponHitAddValueMaxLimit: TSpinEdit
                Tag = 16
                Left = 258
                Top = 143
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 23
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
            end
            object TabSheet57: TTabSheet
              Caption = #26381#39280#23646#24615
              ImageIndex = 2
              object Label268: TLabel
                Left = 90
                Top = 5
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label269: TLabel
                Left = 203
                Top = 5
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label270: TLabel
                Left = 316
                Top = 4
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label271: TLabel
                Left = 8
                Top = 6
                Width = 39
                Height = 12
                Caption = #25915#20987#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label272: TLabel
                Left = 8
                Top = 26
                Width = 39
                Height = 12
                Caption = #39764#27861#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label273: TLabel
                Left = 90
                Top = 25
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label274: TLabel
                Left = 203
                Top = 25
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label275: TLabel
                Left = 316
                Top = 24
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label276: TLabel
                Left = 8
                Top = 46
                Width = 39
                Height = 12
                Caption = #36947#26415#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label277: TLabel
                Left = 203
                Top = 45
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label278: TLabel
                Left = 316
                Top = 44
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label279: TLabel
                Left = 90
                Top = 45
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label280: TLabel
                Left = 8
                Top = 66
                Width = 39
                Height = 12
                Caption = #29289#38450#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label281: TLabel
                Left = 203
                Top = 65
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label282: TLabel
                Left = 316
                Top = 64
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label283: TLabel
                Left = 90
                Top = 65
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label292: TLabel
                Left = 90
                Top = 85
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label293: TLabel
                Left = 316
                Top = 84
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label294: TLabel
                Left = 203
                Top = 85
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label295: TLabel
                Left = 8
                Top = 86
                Width = 39
                Height = 12
                Caption = #39764#38450#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clWindowText
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label285: TLabel
                Left = 203
                Top = 106
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label286: TLabel
                Left = 316
                Top = 105
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label287: TLabel
                Left = 8
                Top = 107
                Width = 39
                Height = 12
                Caption = #20934#30830#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label288: TLabel
                Left = 90
                Top = 106
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label289: TLabel
                Left = 316
                Top = 125
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label290: TLabel
                Left = 316
                Top = 145
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label291: TLabel
                Left = 8
                Top = 127
                Width = 39
                Height = 12
                Caption = #25935#25463#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label296: TLabel
                Left = 8
                Top = 167
                Width = 65
                Height = 12
                Caption = #39764#27861#36530#36991#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label297: TLabel
                Left = 90
                Top = 146
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label298: TLabel
                Left = 316
                Top = 185
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label299: TLabel
                Left = 203
                Top = 186
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label300: TLabel
                Left = 316
                Top = 165
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label301: TLabel
                Left = 90
                Top = 166
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label302: TLabel
                Left = 203
                Top = 126
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label303: TLabel
                Left = 90
                Top = 126
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label304: TLabel
                Left = 203
                Top = 166
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label305: TLabel
                Left = 90
                Top = 186
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label306: TLabel
                Left = 8
                Top = 187
                Width = 65
                Height = 12
                Caption = #39764#27861#22238#22797#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label307: TLabel
                Left = 8
                Top = 309
                Width = 348
                Height = 12
                Caption = #21253#25324#65306#34915#26381#12289#22836#30420#12289#38772#23376#12289#33136#24102'(StdMode:10,11,15,16,28,29,30)'
                Font.Charset = ANSI_CHARSET
                Font.Color = clGray
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = []
                ParentFont = False
              end
              object Label308: TLabel
                Left = 8
                Top = 147
                Width = 39
                Height = 12
                Caption = #24184#36816#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label309: TLabel
                Left = 203
                Top = 146
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label284: TLabel
                Left = 8
                Top = 208
                Width = 65
                Height = 12
                Caption = #20307#21147#22238#22797#65306
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label310: TLabel
                Left = 90
                Top = 207
                Width = 54
                Height = 12
                Caption = #23646#24615#20960#29575':'
              end
              object Label311: TLabel
                Left = 203
                Top = 207
                Width = 54
                Height = 12
                Caption = #26368#39640#28857#25968':'
              end
              object Label312: TLabel
                Left = 316
                Top = 206
                Width = 54
                Height = 12
                Caption = #28857#25968#26426#29575':'
              end
              object Label430: TLabel
                Left = 8
                Top = 228
                Width = 288
                Height = 12
                Caption = #20960#29575#23646#24615' '#39033#35774#32622#25968#20540#20026'0'#26102#65292#35013#22791#23558#19981#20250#20986#29616#27492#23646#24615#12290
                Font.Charset = ANSI_CHARSET
                Font.Color = clRed
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = []
                ParentFont = False
              end
              object setiDressDCAddRate: TSpinEdit
                Tag = 30
                Left = 145
                Top = 1
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 0
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressDCAddValueMaxLimit: TSpinEdit
                Tag = 31
                Left = 258
                Top = 2
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 1
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressDCAddValueRate: TSpinEdit
                Tag = 32
                Left = 371
                Top = 1
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 2
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressMCAddRate: TSpinEdit
                Tag = 33
                Left = 145
                Top = 21
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 3
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressMCAddValueMaxLimit: TSpinEdit
                Tag = 34
                Left = 258
                Top = 22
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 4
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressMCAddValueRate: TSpinEdit
                Tag = 35
                Left = 371
                Top = 21
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 5
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressSCAddRate: TSpinEdit
                Tag = 36
                Left = 145
                Top = 41
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 6
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressSCAddValueMaxLimit: TSpinEdit
                Tag = 37
                Left = 258
                Top = 42
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 7
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressSCAddValueRate: TSpinEdit
                Tag = 38
                Left = 371
                Top = 41
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 8
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressACAddValueMaxLimit: TSpinEdit
                Tag = 40
                Left = 258
                Top = 62
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 9
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressACAddValueRate: TSpinEdit
                Tag = 41
                Left = 371
                Top = 61
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 10
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressACAddRate: TSpinEdit
                Tag = 39
                Left = 145
                Top = 61
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 11
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressMACAddValueMaxLimit: TSpinEdit
                Tag = 43
                Left = 258
                Top = 82
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 12
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressMACAddRate: TSpinEdit
                Tag = 42
                Left = 145
                Top = 81
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 13
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiDressMACAddValueRate: TSpinEdit
                Tag = 44
                Left = 371
                Top = 81
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 14
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingLuckAddValueMaxLimit: TSpinEdit
                Tag = 52
                Left = 258
                Top = 143
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 15
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingLuckAddValueRate: TSpinEdit
                Tag = 53
                Left = 371
                Top = 142
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 16
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingHitAddValueMaxLimit: TSpinEdit
                Tag = 46
                Left = 258
                Top = 103
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 17
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingHitAddValueRate: TSpinEdit
                Tag = 47
                Left = 371
                Top = 102
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 18
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingSpeedAddValueRate: TSpinEdit
                Tag = 50
                Left = 371
                Top = 122
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 19
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingSpeedAddValueMaxLimit: TSpinEdit
                Tag = 49
                Left = 258
                Top = 123
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 20
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingLuckAddRate: TSpinEdit
                Tag = 51
                Left = 145
                Top = 142
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 21
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingAntiMagicAddValueMaxLimit: TSpinEdit
                Tag = 55
                Left = 258
                Top = 163
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 22
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingAntiMagicAddValueRate: TSpinEdit
                Tag = 56
                Left = 371
                Top = 162
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 23
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingAntiMagicAddRate: TSpinEdit
                Tag = 54
                Left = 145
                Top = 162
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 24
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingHealthRecoverAddValueRate: TSpinEdit
                Tag = 59
                Left = 371
                Top = 182
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 25
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingHitAddRate: TSpinEdit
                Tag = 45
                Left = 145
                Top = 102
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 26
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingSpeedAddRate: TSpinEdit
                Tag = 48
                Left = 145
                Top = 122
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 27
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingHealthRecoverAddValueMaxLimit: TSpinEdit
                Tag = 58
                Left = 258
                Top = 183
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 28
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingHealthRecoverAddRate: TSpinEdit
                Tag = 57
                Left = 145
                Top = 182
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 29
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingSpellRecoverAddRate: TSpinEdit
                Tag = 60
                Left = 145
                Top = 203
                Width = 41
                Height = 21
                Hint = #20986#29616#23646#24615#30340#20960#29575#65292#25968#23383#36234#23567#20960#29575#36234#22823#12290
                MaxValue = 99999
                MinValue = 0
                TabOrder = 30
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingSpellRecoverAddValueMaxLimit: TSpinEdit
                Tag = 61
                Left = 258
                Top = 204
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26368#39640#38480#21046#12290
                EditorEnabled = False
                MaxValue = 15
                MinValue = 1
                TabOrder = 31
                Value = 15
                OnChange = setiWeaponDCAddRateChange
              end
              object setiWearingSpellRecoverAddValueRate: TSpinEdit
                Tag = 62
                Left = 371
                Top = 203
                Width = 41
                Height = 21
                Hint = #26497#21697#23646#24615#28857#26426#29575#65292#25968#25454#36234#22823#26426#29575#36234#23567#65292#26368#39640#19981#36229#36807#26368#39640#28857#25968#25511#21046#12290
                EditorEnabled = False
                MaxValue = 100
                MinValue = 1
                TabOrder = 32
                Value = 100
                OnChange = setiWeaponDCAddRateChange
              end
            end
          end
          object tiOpenSystem: TCheckBox
            Tag = 4
            Left = 197
            Top = 2
            Width = 95
            Height = 17
            Caption = #24320#21551#37492#23453#31995#32479
            TabOrder = 1
            OnClick = tiSpSkillAddHPMaxClick
          end
        end
        object TabSheet53: TTabSheet
          Caption = #25366#23453
          object Label221: TLabel
            Left = 12
            Top = 21
            Width = 72
            Height = 12
            Caption = #28789#29028#25506#32034#20960#29575
          end
          object Label222: TLabel
            Left = 12
            Top = 48
            Width = 60
            Height = 12
            Caption = #25366#23453#21629#20013#29575
          end
          object Label223: TLabel
            Left = 12
            Top = 73
            Width = 36
            Height = 12
            Caption = #25366#23453#29575
          end
          object seDetcetItemRate: TSpinEdit
            Left = 90
            Top = 18
            Width = 62
            Height = 21
            Hint = #25968#23383#36234#23567','#20960#29575#36234#22823
            MaxValue = 9999
            MinValue = 1
            TabOrder = 0
            Value = 200
            OnChange = EditHeroWalkSpeed_WarrChange
          end
          object seMakeItemButchRate: TSpinEdit
            Left = 90
            Top = 45
            Width = 62
            Height = 21
            Hint = #25968#23383#36234#23567','#20960#29575#36234#22823
            MaxValue = 9999
            MinValue = 1
            TabOrder = 1
            Value = 200
            OnChange = EditHeroWalkSpeed_WarrChange
          end
          object seMakeItemRate: TSpinEdit
            Left = 90
            Top = 70
            Width = 62
            Height = 21
            Hint = #25968#23383#36234#23567','#20960#29575#36234#22823
            MaxValue = 9999
            MinValue = 1
            TabOrder = 2
            Value = 200
            OnChange = EditHeroWalkSpeed_WarrChange
          end
        end
      end
      object btnEvaluationSave: TButton
        Left = 400
        Top = 271
        Width = 40
        Height = 21
        Caption = #20445#23384
        TabOrder = 1
        OnClick = btnEvaluationSaveClick
      end
    end
  end
end
