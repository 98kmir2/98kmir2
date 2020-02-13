object frmGameConfig: TfrmGameConfig
  Left = 912
  Top = 283
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #28216#25103#21442#25968
  ClientHeight = 316
  ClientWidth = 532
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
    Top = 324
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
  object GameConfigControl: TPageControl
    Left = 7
    Top = 8
    Width = 522
    Height = 313
    ActivePage = TabSheet3
    MultiLine = True
    TabOrder = 0
    OnChanging = GameConfigControlChanging
    object GeneralSheet: TTabSheet
      Caption = #29615#22659#35774#32622
      ImageIndex = 2
      object GroupBoxInfo: TGroupBox
        Left = 168
        Top = 55
        Width = 153
        Height = 44
        Caption = #23458#25143#31471#29256#26412#21495
        TabOrder = 0
        object Label16: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #29256#26412#26085#26399':'
        end
        object EditSoftVersionDate: TEdit
          Left = 64
          Top = 16
          Width = 81
          Height = 20
          Hint = #23458#25143#31471#29256#26412#26085#26399#35774#32622#65292#27492#26085#26399#25968#23383#24517#39035#19982#23458#25143#31471#19978#30340#26085#26399#26631#35782#19968#33268#65292#21542#21017#36827#20837#28216#25103#26102#20250#25552#31034#29256#26412#38169#35823#12290#28857#20445#23384#25353#38062#21518#29983#25928#12290
          TabOrder = 0
          Text = '20020522'
          OnChange = EditSoftVersionDateChange
        end
      end
      object GroupBox5: TGroupBox
        Left = 168
        Top = 7
        Width = 153
        Height = 44
        Caption = #25511#21046#21488#26174#31034#20154#25968#26102#38388'('#31186')'
        TabOrder = 1
        object Label17: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #26174#31034#38388#38548':'
        end
        object EditConsoleShowUserCountTime: TSpinEdit
          Left = 68
          Top = 16
          Width = 61
          Height = 21
          Hint = #31243#24207#25511#21046#21488#26174#31034#22312#32447#20154#25968#26102#38388#38388#38548#12290
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 0
          Value = 10
          OnChange = EditConsoleShowUserCountTimeChange
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 106
        Width = 153
        Height = 100
        Caption = #28216#25103#20844#21578#26174#31034#38388#38548'('#31186')'
        TabOrder = 2
        object Label18: TLabel
          Left = 8
          Top = 24
          Width = 54
          Height = 12
          Caption = #26174#31034#38388#38548':'
        end
        object Label19: TLabel
          Left = 8
          Top = 48
          Width = 54
          Height = 12
          Caption = #25991#23383#39068#33394':'
        end
        object Label21: TLabel
          Left = 8
          Top = 72
          Width = 54
          Height = 12
          Caption = #21069#32512#25991#23383':'
        end
        object EditShowLineNoticeTime: TSpinEdit
          Left = 64
          Top = 19
          Width = 57
          Height = 21
          Hint = #28216#25103#20013#20844#21578#20449#24687#26174#31034#26102#38388#38388#38548#26102#38388#12290
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 0
          Value = 10
          OnChange = EditShowLineNoticeTimeChange
        end
        object ComboBoxLineNoticeColor: TComboBox
          Left = 64
          Top = 44
          Width = 57
          Height = 20
          Hint = #20844#21578#25991#23383#26174#31034#40664#35748#39068#33394#12290
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
          OnChange = ComboBoxLineNoticeColorChange
        end
        object EditLineNoticePreFix: TEdit
          Left = 64
          Top = 68
          Width = 73
          Height = 20
          MaxLength = 20
          TabOrder = 2
          Text = #12310#20844#21578#12311
          OnChange = EditLineNoticePreFixChange
        end
      end
      object ButtonGeneralSave: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 3
        OnClick = ButtonGeneralSaveClick
      end
      object GroupBox35: TGroupBox
        Left = 328
        Top = 6
        Width = 145
        Height = 91
        Caption = #25511#21046#21488#26174#31034#20449#24687
        TabOrder = 4
        object CheckBoxShowMakeItemMsg: TCheckBox
          Left = 8
          Top = 18
          Width = 97
          Height = 17
          Caption = 'GM'#25805#20316#20449#24687
          TabOrder = 0
          OnClick = CheckBoxShowMakeItemMsgClick
        end
        object CbViewHack: TCheckBox
          Left = 8
          Top = 34
          Width = 97
          Height = 17
          Caption = #36895#24230#24322#24120#20449#24687
          TabOrder = 1
          OnClick = CbViewHackClick
        end
        object CkViewAdmfail: TCheckBox
          Left = 8
          Top = 50
          Width = 97
          Height = 17
          Caption = #38750#27861#30331#24405#20449#24687
          TabOrder = 2
          OnClick = CkViewAdmfailClick
        end
        object CheckBoxShowExceptionMsg: TCheckBox
          Left = 8
          Top = 66
          Width = 97
          Height = 17
          Caption = #24322#24120#38169#35823#20449#24687
          TabOrder = 3
          OnClick = CheckBoxShowExceptionMsgClick
        end
      end
      object GroupBox51: TGroupBox
        Left = 8
        Top = 7
        Width = 153
        Height = 92
        Caption = #24191#25773#22312#32447#20154#25968
        TabOrder = 5
        object Label98: TLabel
          Left = 8
          Top = 40
          Width = 54
          Height = 12
          Caption = #20154#25968#20493#29575':'
        end
        object Label99: TLabel
          Left = 8
          Top = 64
          Width = 54
          Height = 12
          Caption = #38388#38548#26102#38388':'
        end
        object Label100: TLabel
          Left = 136
          Top = 64
          Width = 12
          Height = 12
          Caption = #31186
        end
        object EditSendOnlineCountRate: TSpinEdit
          Left = 68
          Top = 36
          Width = 61
          Height = 21
          Hint = #24191#25773#22312#32447#20154#29289#34394#20551#20154#25968#20493#29575#65292#30495#23454#25968#25454#20026#38500#20197'10'#65292#40664#35748#20026'10'#23601#26159#19968#20493#65292'11 '#23601#26159'1.1'#20493#12290
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 10
          TabOrder = 0
          Value = 10
          OnChange = EditSendOnlineCountRateChange
        end
        object EditSendOnlineTime: TSpinEdit
          Left = 68
          Top = 60
          Width = 61
          Height = 21
          Hint = #24191#25773#22312#32447#20154#25968#38388#38548#26102#38388#12290
          EditorEnabled = False
          Increment = 10
          MaxValue = 200000
          MinValue = 5
          TabOrder = 1
          Value = 10
          OnChange = EditSendOnlineTimeChange
        end
        object CheckBoxSendOnlineCount: TCheckBox
          Left = 8
          Top = 16
          Width = 89
          Height = 17
          Hint = #26159#21542#21551#29992#22312#32447#24191#25773#22312#32447#20154#25968#21151#33021#65292#25171#24320#27492#21151#33021#21518#22312#28216#25103#37324#23558#20197#32418#23383#26041#24335#26174#31034#22312#32447#20154#25968#12290
          Caption = #24191#25773#22312#32447#20154#25968
          TabOrder = 2
          OnClick = CheckBoxSendOnlineCountClick
        end
      end
      object GroupBox52: TGroupBox
        Left = 168
        Top = 106
        Width = 153
        Height = 99
        Caption = #29289#21697#24618#29289#25968#25454#24211#20493#29575
        TabOrder = 6
        object Label101: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #24618#29289':'
        end
        object Label102: TLabel
          Left = 8
          Top = 44
          Width = 42
          Height = 12
          Caption = #29289#21697#19968':'
        end
        object Label103: TLabel
          Left = 8
          Top = 68
          Width = 42
          Height = 12
          Caption = #29289#21697#20108':'
        end
        object EditMonsterPowerRate: TSpinEdit
          Left = 68
          Top = 16
          Width = 69
          Height = 21
          Hint = #24618#29289#23646#24615#20493#29575'(HP'#12289'MP'#12289'DC'#12289'MC'#12289'SC)'#65292#23454#38469#25968#23383#20026#24403#21069#25968#25454#38500#20197'10'#12290
          EditorEnabled = False
          MaxValue = 20000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditMonsterPowerRateChange
        end
        object EditEditItemsPowerRate: TSpinEdit
          Left = 68
          Top = 40
          Width = 69
          Height = 21
          Hint = #29289#21697#23646#24615#20493#29575'(DC'#12289'MC'#12289'SC)'#65292#23454#38469#25968#23383#20026#24403#21069#25968#25454#38500#20197'10'#12290
          EditorEnabled = False
          MaxValue = 20000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditEditItemsPowerRateChange
        end
        object EditItemsACPowerRate: TSpinEdit
          Left = 68
          Top = 64
          Width = 69
          Height = 21
          Hint = #29289#21697#23646#24615#20493#29575'(AC'#12289'MAC'#20108#20010')'#65292#23454#38469#25968#23383#20026#24403#21069#25968#25454#38500#20197'10'#12290
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditItemsACPowerRateChange
        end
      end
      object GroupBox73: TGroupBox
        Left = 328
        Top = 106
        Width = 145
        Height = 71
        Caption = #29256#26412#25511#21046
        TabOrder = 7
        object CheckBoxCanOldClientLogon: TCheckBox
          Left = 8
          Top = 16
          Width = 129
          Height = 17
          Hint = #26159#21542#20801#35768#26222#36890#26087#23458#25143#31471#30331#24405#28216#25103#65292#38057#19978#20026#25171#24320#65292#22914#26524#20851#38381#27492#21151#33021#65292#21017#32769#23458#25143#31471#23558#26080#27861#30331#24405#21040#28216#25103#12290
          Caption = #20801#35768#26222#36890#23458#25143#31471#30331#24405
          TabOrder = 0
          OnClick = CheckBoxCanOldClientLogonClick
        end
        object CheckBoxOnlyHeroClientLogon: TCheckBox
          Left = 8
          Top = 32
          Width = 129
          Height = 17
          Hint = #26159#21542#21482#20801#35768#33521#38596#23458#25143#31471#30331#24405#28216#25103#65292#38057#19978#20026#25171#24320#65292#22914#26524#24320#21551#27492#21151#33021#65292#21017#38750#33521#38596#23458#25143#31471#23558#26080#27861#30331#24405#21040#28216#25103#12290
          Caption = #21482#20801#35768#33521#38596#23458#25143#31471#29256
          TabOrder = 1
          OnClick = CheckBoxOnlyHeroClientLogonClick
        end
        object CheckBoxOpenLRSys: TCheckBox
          Left = 8
          Top = 48
          Width = 129
          Height = 17
          Caption = #20801#35768#20351#29992#25490#34892#31995#32479
          TabOrder = 2
          OnClick = CheckBoxOpenLRSysClick
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #28216#25103#36873#39033#19968
      ImageIndex = 7
      object GroupBox28: TGroupBox
        Left = 8
        Top = 8
        Width = 145
        Height = 105
        Caption = #28216#25103#27169#24335
        TabOrder = 0
        object CheckBoxTestServer: TCheckBox
          Left = 8
          Top = 14
          Width = 73
          Height = 17
          Hint = #27979#35797#27169#24335#65292#25171#24320#27492#27169#24335#65292#21487#23545#26381#21153#22120#21508#39033#21442#25968#21450#21151#33021#36827#34892#27979#35797#12290
          Caption = #27979#35797#27169#24335
          TabOrder = 0
          OnClick = CheckBoxTestServerClick
        end
        object CheckBoxServiceMode: TCheckBox
          Left = 8
          Top = 28
          Width = 73
          Height = 17
          Hint = #20813#36153#27169#24335#65292#25171#24320#27492#20808#39033#23558#19981#23545#29992#25143#35745#36153#12290
          Caption = #20813#36153#27169#24335
          TabOrder = 1
          OnClick = CheckBoxServiceModeClick
        end
        object CheckBoxVentureMode: TCheckBox
          Left = 8
          Top = 42
          Width = 81
          Height = 17
          Caption = #19981#21047#24618#27169#24335
          TabOrder = 2
          OnClick = CheckBoxVentureModeClick
        end
        object CheckBoxNonPKMode: TCheckBox
          Left = 8
          Top = 56
          Width = 81
          Height = 17
          Caption = #31105#27490'PK'#27169#24335
          TabOrder = 3
          OnClick = CheckBoxNonPKModeClick
        end
      end
      object GroupBox29: TGroupBox
        Left = 8
        Top = 118
        Width = 145
        Height = 88
        Caption = #27979#35797#27169#24335
        TabOrder = 1
        object Label61: TLabel
          Left = 8
          Top = 17
          Width = 54
          Height = 12
          Caption = #24320#22987#31561#32423':'
        end
        object Label62: TLabel
          Left = 8
          Top = 41
          Width = 54
          Height = 12
          Caption = #24320#22987#37329#24065':'
        end
        object Label63: TLabel
          Left = 8
          Top = 65
          Width = 54
          Height = 12
          Caption = #20154#25968#38480#21046':'
        end
        object EditTestLevel: TSpinEdit
          Left = 68
          Top = 13
          Width = 69
          Height = 21
          Hint = #20154#29289#36215#22987#31561#32423#12290
          MaxValue = 20000
          MinValue = 0
          TabOrder = 0
          Value = 10
          OnChange = EditTestLevelChange
          OnKeyDown = EditTestLevelKeyDown
        end
        object EditTestGold: TSpinEdit
          Left = 68
          Top = 37
          Width = 69
          Height = 21
          Hint = #27979#35797#27169#24335#20154#29289#36215#22987#37329#24065#25968#12290
          Increment = 1000
          MaxValue = 20000000
          MinValue = 0
          TabOrder = 1
          Value = 10
          OnChange = EditTestGoldChange
        end
        object EditTestUserLimit: TSpinEdit
          Left = 68
          Top = 61
          Width = 69
          Height = 21
          Hint = #27979#35797#27169#24335#26368#39640#21487#19978#32447#20154#25968#38480#21046#12290
          Increment = 10
          MaxValue = 10000
          MinValue = 0
          TabOrder = 2
          Value = 10
          OnChange = EditTestUserLimitChange
        end
      end
      object GroupBox30: TGroupBox
        Left = 336
        Top = 8
        Width = 137
        Height = 49
        Caption = #20154#29289#36215#22987#35774#32622
        TabOrder = 2
        object Label60: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #36215#22987#26435#38480':'
        end
        object EditStartPermission: TSpinEdit
          Left = 68
          Top = 16
          Width = 53
          Height = 21
          Hint = #20154#29289#28216#25103#36215#22987#26435#38480#65292#40664#35748#20026'0'#12290
          EditorEnabled = False
          MaxValue = 10
          MinValue = 0
          TabOrder = 0
          Value = 10
          OnChange = EditStartPermissionChange
        end
      end
      object ButtonOptionSave0: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 3
        OnClick = ButtonOptionSave0Click
      end
      object GroupBox31: TGroupBox
        Left = 160
        Top = 156
        Width = 169
        Height = 49
        Caption = #19978#32447#20154#25968#38480#21046
        TabOrder = 4
        object Label64: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #20154#25968#38480#21046':'
        end
        object EditUserFull: TSpinEdit
          Left = 68
          Top = 16
          Width = 85
          Height = 21
          Hint = #26368#26032#21487#19978#32447#20154#25968#38480#21046#65292#36229#36807#27492#20154#25968#21518#19978#32447#23558#25552#31034#32418#23383#12290
          MaxValue = 10000
          MinValue = 0
          TabOrder = 0
          Value = 1000
          OnChange = EditUserFullChange
        end
      end
      object GroupBox33: TGroupBox
        Left = 160
        Top = 8
        Width = 169
        Height = 73
        Caption = #20154#29289#36523#19978#37329#24065#25968#38480#21046
        TabOrder = 5
        object Label68: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #27491#24335#27169#24335':'
        end
        object Label69: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #35797#29609#27169#24335':'
        end
        object EditHumanMaxGold: TSpinEdit
          Left = 68
          Top = 16
          Width = 85
          Height = 21
          Increment = 10000
          MaxValue = 2000000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditHumanMaxGoldChange
        end
        object EditHumanTryModeMaxGold: TSpinEdit
          Left = 68
          Top = 40
          Width = 85
          Height = 21
          Increment = 10000
          MaxValue = 2000000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditHumanTryModeMaxGoldChange
        end
      end
      object GroupBox34: TGroupBox
        Left = 160
        Top = 86
        Width = 169
        Height = 65
        Caption = #35797#29609#31561#32423#38480#21046
        TabOrder = 6
        object Label70: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #31561#32423#38480#21046':'
        end
        object EditTryModeLevel: TSpinEdit
          Left = 68
          Top = 16
          Width = 85
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditTryModeLevelChange
        end
        object CheckBoxTryModeUseStorage: TCheckBox
          Left = 8
          Top = 42
          Width = 121
          Height = 17
          Hint = #35797#29609#27169#24335#20801#35768#20351#29992#20179#24211#12290
          Caption = #35797#29609#27169#24335#20351#29992#20179#24211
          TabOrder = 1
          OnClick = CheckBoxTryModeUseStorageClick
        end
      end
      object GroupBox19: TGroupBox
        Left = 336
        Top = 61
        Width = 137
        Height = 44
        Caption = #32452#38431#25104#21592#25968#37327
        TabOrder = 7
        object Label41: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #25104#21592#25968#37327':'
        end
        object EditGroupMembersMax: TSpinEdit
          Left = 68
          Top = 16
          Width = 53
          Height = 21
          Hint = #32452#38431#25104#21592#25968#37327#12290
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditGroupMembersMaxChange
        end
      end
      object GroupBox81: TGroupBox
        Left = 336
        Top = 112
        Width = 137
        Height = 49
        Caption = #34892#20250#25104#21592#25968#37327
        TabOrder = 8
        object Label153: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #25968#37327#38480#21046':'
        end
        object EditGuildMemberMaxLimit: TSpinEdit
          Left = 68
          Top = 16
          Width = 53
          Height = 21
          Hint = #34892#20250#25104#21592#25968#37327#12290
          EditorEnabled = False
          Increment = 10
          MaxValue = 20000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditGuildMemberMaxLimitChange
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #28216#25103#36873#39033#20108
      ImageIndex = 5
      object GroupBox17: TGroupBox
        Left = 280
        Top = 8
        Width = 145
        Height = 165
        Caption = #36305#27493#31359#20154#25511#21046
        TabOrder = 0
        object CheckBoxDisHumRun: TCheckBox
          Left = 11
          Top = 21
          Width = 102
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#20154#29289#23558#19981#20801#35768#31359#36807#24618#29289#25110#20854#23427#20154#29289
          Caption = #31105#27490#36305#27493#31359#20154
          TabOrder = 0
          OnClick = CheckBoxDisHumRunClick
        end
        object CheckBoxRunHum: TCheckBox
          Left = 19
          Top = 38
          Width = 98
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#20154#29289#23558#21487#20197#31359#36807#20854#20182#20154#29289
          Caption = #20801#35768#31359#36807#20154#29289
          TabOrder = 1
          OnClick = CheckBoxRunHumClick
        end
        object CheckBoxRunMon: TCheckBox
          Left = 19
          Top = 55
          Width = 99
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#20154#29289#23558#21487#20197#31359#36807#24618#29289
          Caption = #20801#35768#31359#36807#24618#29289
          TabOrder = 2
          OnClick = CheckBoxRunMonClick
        end
        object CheckBoxWarDisHumRun: TCheckBox
          Left = 19
          Top = 106
          Width = 118
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#22312#25915#22478#21306#22495#65292#23558#31105#27490#31359#20154#21450#24618#29289
          Caption = #25915#22478#21306#22495#20840#31105#27490
          TabOrder = 3
          OnClick = CheckBoxWarDisHumRunClick
        end
        object CheckBoxRunNpc: TCheckBox
          Left = 19
          Top = 72
          Width = 99
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#20154#29289#23558#21487#20197#31359#36807'NPC'
          Caption = #20801#35768#31359#36807' NPC'
          TabOrder = 4
          OnClick = CheckBoxRunNpcClick
        end
        object CheckBoxGMRunAll: TCheckBox
          Left = 19
          Top = 123
          Width = 122
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#36229#32423#28216#25103#31649#29702#21592#19981#21463#20197#19978#35774#32622#38480#21046#12290
          Caption = #31649#29702#21592#19981#21463#25511#21046
          TabOrder = 5
          OnClick = CheckBoxGMRunAllClick
        end
        object CheckBoxRunGuard: TCheckBox
          Left = 19
          Top = 89
          Width = 99
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#20154#29289#23558#21487#20197#31359#36807#23432#21355'('#22823#20992#12289#24339#31661#25163')'
          Caption = #20801#35768#31359#36807#23432#21355
          TabOrder = 6
          OnClick = CheckBoxRunGuardClick
        end
        object CheckBoxSafeZoneRunAll: TCheckBox
          Left = 19
          Top = 141
          Width = 122
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#36229#32423#28216#25103#31649#29702#21592#19981#21463#20197#19978#35774#32622#38480#21046#12290
          Caption = #23433#20840#21306#19981#21463#25511#21046
          TabOrder = 7
          OnClick = CheckBoxSafeZoneRunAllClick
        end
      end
      object ButtonOptionSave3: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonOptionSave3Click
      end
      object GroupBox53: TGroupBox
        Left = 8
        Top = 8
        Width = 129
        Height = 113
        Caption = #20132#26131#25511#21046
        TabOrder = 2
        object Label20: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #20132#26131#38388#38548':'
        end
        object Label104: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #30830#35748#20132#26131':'
        end
        object Label105: TLabel
          Left = 107
          Top = 20
          Width = 12
          Height = 12
          Caption = #31186
        end
        object Label106: TLabel
          Left = 107
          Top = 43
          Width = 12
          Height = 12
          Caption = #31186
        end
        object EditTryDealTime: TSpinEdit
          Left = 68
          Top = 16
          Width = 37
          Height = 21
          Hint = #20851#38381#20132#26131#21518#65292#20877#37325#26032#20132#26131#24517#39035#38388#38548#25351#23450#26102#38388#12290
          EditorEnabled = False
          MaxValue = 10
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditTryDealTimeChange
        end
        object EditDealOKTime: TSpinEdit
          Left = 68
          Top = 40
          Width = 37
          Height = 21
          Hint = #25918#19978#20132#26131#29289#21697#21518#65292#24517#39035#31561#25351#23450#26102#38388#20877#25353#30830#35748#25353#38062#12290
          EditorEnabled = False
          MaxValue = 10
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditDealOKTimeChange
        end
        object CheckBoxCanNotGetBackDeal: TCheckBox
          Left = 11
          Top = 67
          Width = 110
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#20132#26131#30340#29289#21697#25918#19978#20102#21518#23558#19981#21487#20197#21462#22238#65292#21482#33021#21462#28040#20132#26131#20877#37325#26032#20132#26131#12290
          Caption = #31105#27490#21462#22238#29289#21697
          TabOrder = 2
          OnClick = CheckBoxCanNotGetBackDealClick
        end
        object CheckBoxDisableDeal: TCheckBox
          Left = 11
          Top = 81
          Width = 110
          Height = 13
          Hint = #31105#27490#20132#26131#21518#65292#22312#28216#25103#20013#23558#19981#20801#35768#36827#34892#20132#26131#12290
          Caption = #31105#27490#20132#26131
          TabOrder = 3
          OnClick = CheckBoxDisableDealClick
        end
      end
      object GroupBox26: TGroupBox
        Left = 8
        Top = 126
        Width = 129
        Height = 47
        Caption = #32511#27602#20943'HP'#26102#38388'('#27627#31186')'
        TabOrder = 3
        object Label57: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #38388#38548#26102#38388':'
        end
        object EditPosionDecHealthTime: TSpinEdit
          Left = 68
          Top = 16
          Width = 53
          Height = 21
          Hint = #20154#29289#20013#32511#27602#21518#65292#20943#23569#29983#21629#28857#26102#38388#38388#38548#12290
          Increment = 100
          MaxValue = 20000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditPosionDecHealthTimeChange
        end
      end
      object GroupBox27: TGroupBox
        Left = 144
        Top = 126
        Width = 129
        Height = 47
        Caption = #32418#27602#20943#38450#24481#21450#25345#20037#29575
        TabOrder = 4
        object Label59: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #27604#29575':'
        end
        object EditPosionDamagarmor: TSpinEdit
          Left = 44
          Top = 16
          Width = 53
          Height = 21
          Hint = #20154#29289#20013#32418#27602#20943#38450#24481#21450#29289#21697#25345#20037#27604#29575#65292#27492#25968#20540#38500#20197'10'#20026#30495#23454#25968#20540#12290
          EditorEnabled = False
          MaxValue = 20000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditPosionDamagarmorChange
        end
      end
      object GroupBox64: TGroupBox
        Left = 144
        Top = 8
        Width = 129
        Height = 113
        Caption = #25172#29289#21697#25511#21046
        TabOrder = 5
        object Label118: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #29289#21697#20215#26684':'
        end
        object Label119: TLabel
          Left = 8
          Top = 68
          Width = 30
          Height = 12
          Caption = #37329#24065':'
        end
        object EditCanDropPrice: TSpinEdit
          Left = 68
          Top = 40
          Width = 53
          Height = 21
          Hint = #23567#20110#27492#20215#26684#30340#29289#21697#65292#25172#20986#21518#31435#21363#28040#22833#65292#19981#20250#20986#29616#22312#22320#19978#12290
          Increment = 100
          MaxValue = 20000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditCanDropPriceChange
        end
        object CheckBoxControlDropItem: TCheckBox
          Left = 11
          Top = 20
          Width = 110
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#23558#23545#20154#29289#25172#19979#26469#30340#29289#21697#21450#37329#24065#36827#34892#26816#26597#65292#23567#20110#25351#23450#35268#21017#37329#24065#25110#20215#26684#30340#29289#21697#23558#19981#20801#35768#25172#19979#26469#65292#25110#25172#19979#26469#31435#21363#28040#22833#12290
          Caption = #21551#29992#25172#29289#21697#25511#21046
          TabOrder = 1
          OnClick = CheckBoxControlDropItemClick
        end
        object EditCanDropGold: TSpinEdit
          Left = 68
          Top = 64
          Width = 53
          Height = 21
          Hint = #23567#20110#25351#23450#25968#37327#30340#37329#24065#65292#23558#31105#27490#25172#20986#12290
          Increment = 100
          MaxValue = 20000000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditCanDropGoldChange
        end
        object CheckBoxIsSafeDisableDrop: TCheckBox
          Left = 11
          Top = 92
          Width = 110
          Height = 13
          Hint = #25171#24320#27492#21151#33021#21518#65292#22312#23433#20840#21306#23558#19981#20801#35768#25172#29289#21697#12290
          Caption = #23433#20840#21306#31105#27490#25172
          TabOrder = 3
          OnClick = CheckBoxIsSafeDisableDropClick
        end
      end
      object CheckBoxSafeZonePush: TCheckBox
        Left = 297
        Top = 185
        Width = 106
        Height = 13
        Hint = #25171#24320#27492#21151#33021#21518#65292#23433#20840#21306#37325#21472#30340#20154#29289#23558#34987#25512#36208#65288#21487#33021#34987#25512#20986#23433#20840#21306#65289#12290
        Caption = #20801#35768#23433#20840#21306#25512#20154
        Enabled = False
        TabOrder = 6
        Visible = False
        OnClick = CheckBoxSafeZonePushClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = #24231#26631#33539#22260
      ImageIndex = 4
      object ButtonOptionSave: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonOptionSaveClick
      end
      object GroupBox16: TGroupBox
        Left = 8
        Top = 110
        Width = 105
        Height = 45
        Caption = #23433#20840#21306#33539#22260
        TabOrder = 1
        object Label39: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #22823#23567':'
        end
        object EditSafeZoneSize: TSpinEdit
          Left = 44
          Top = 16
          Width = 45
          Height = 21
          Hint = #23433#20840#21306#33539#22260#22823#23567#12290
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditSafeZoneSizeChange
        end
      end
      object GroupBox18: TGroupBox
        Left = 8
        Top = 160
        Width = 105
        Height = 45
        Caption = #26032#20154#20986#29983#28857#33539#22260
        TabOrder = 2
        object Label40: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #33539#22260':'
        end
        object EditStartPointSize: TSpinEdit
          Left = 44
          Top = 16
          Width = 45
          Height = 21
          Hint = #26032#20154#20986#29983#28857#25511#21046#65292#40664#35748#20026#21069#19977#20010#23433#20840#21306#35774#32622#12290
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditStartPointSizeChange
        end
      end
      object GroupBox20: TGroupBox
        Left = 168
        Top = 8
        Width = 153
        Height = 97
        Caption = #32418#21517#26449
        TabOrder = 3
        object Label42: TLabel
          Left = 8
          Top = 44
          Width = 36
          Height = 12
          Caption = #24231#26631'X:'
        end
        object Label43: TLabel
          Left = 8
          Top = 68
          Width = 36
          Height = 12
          Caption = #24231#26631'Y:'
        end
        object Label44: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #22320#22270':'
        end
        object EditRedHomeX: TSpinEdit
          Left = 52
          Top = 40
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditRedHomeXChange
        end
        object EditRedHomeY: TSpinEdit
          Left = 52
          Top = 64
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditRedHomeYChange
        end
        object EditRedHomeMap: TEdit
          Left = 52
          Top = 16
          Width = 73
          Height = 20
          Hint = #32418#21517#20154#29289#38598#20013#28857#22320#22270#21517#31216#12290
          TabOrder = 2
          Text = '3'
          OnChange = EditRedHomeMapChange
        end
      end
      object GroupBox21: TGroupBox
        Left = 8
        Top = 8
        Width = 153
        Height = 97
        Caption = #32418#21517#27515#20129#22238#22478#28857
        TabOrder = 4
        object Label45: TLabel
          Left = 8
          Top = 44
          Width = 36
          Height = 12
          Caption = #24231#26631'X:'
        end
        object Label46: TLabel
          Left = 8
          Top = 68
          Width = 36
          Height = 12
          Caption = #24231#26631'Y:'
        end
        object Label47: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #22320#22270':'
        end
        object EditRedDieHomeX: TSpinEdit
          Left = 52
          Top = 40
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditRedDieHomeXChange
        end
        object EditRedDieHomeY: TSpinEdit
          Left = 52
          Top = 64
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditRedDieHomeYChange
        end
        object EditRedDieHomeMap: TEdit
          Left = 52
          Top = 16
          Width = 73
          Height = 20
          TabOrder = 2
          Text = '3'
          OnChange = EditRedDieHomeMapChange
        end
      end
      object GroupBox22: TGroupBox
        Left = 328
        Top = 8
        Width = 145
        Height = 97
        Caption = #24212#24613#22238#22478#28857
        TabOrder = 5
        object Label48: TLabel
          Left = 8
          Top = 44
          Width = 36
          Height = 12
          Caption = #24231#26631'X:'
        end
        object Label49: TLabel
          Left = 8
          Top = 68
          Width = 36
          Height = 12
          Caption = #24231#26631'Y:'
        end
        object Label50: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #22320#22270':'
        end
        object EditHomeX: TSpinEdit
          Left = 52
          Top = 40
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditHomeXChange
        end
        object EditHomeY: TSpinEdit
          Left = 52
          Top = 64
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditHomeYChange
        end
        object EditHomeMap: TEdit
          Left = 52
          Top = 16
          Width = 73
          Height = 20
          TabOrder = 2
          Text = '3'
          OnChange = EditHomeMapChange
        end
      end
      object GroupBox80: TGroupBox
        Left = 121
        Top = 112
        Width = 116
        Height = 45
        Caption = #38750#34892#20250#31449#21306#21306#33539#22260
        TabOrder = 6
        object Label167: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #22823#23567':'
        end
        object EditNonGuildWarZoneSize: TSpinEdit
          Left = 44
          Top = 16
          Width = 45
          Height = 21
          Hint = 
            #38750#34892#20250#25112#21306#33539#22260#22823#23567#65292#40664#35748'60'#12290#13#25968#20540#36234#23567#65292#34920#31034#36208#20986#23433#20840#19981#36828#23601#26159#34892#20250#25112#21306#12290#13#22914#35201#20986#23433#20840#21306#23601#26159#34892#20250#25112#21306#65292#21487#20197#35774#32622#25968#20540#20026'10~15'#65288#26681 +
            #25454#23433#20840#21306#22823#23567#32780#23450#65289#65281
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditSafeZoneSizeChange
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'PK'#25511#21046
      ImageIndex = 6
      object ButtonOptionSave2: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonOptionSave2Click
      end
      object GroupBox23: TGroupBox
        Left = 8
        Top = 8
        Width = 145
        Height = 73
        Caption = #33258#21160#20943'PK'#28857#25511#21046
        TabOrder = 1
        object Label51: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #38388#38548#26102#38388':'
        end
        object Label52: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #19968#27425#28857#25968':'
        end
        object Label53: TLabel
          Left = 128
          Top = 20
          Width = 12
          Height = 12
          Caption = #31186
        end
        object EditDecPkPointTime: TSpinEdit
          Left = 68
          Top = 16
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditDecPkPointTimeChange
        end
        object EditDecPkPointCount: TSpinEdit
          Left = 68
          Top = 40
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditDecPkPointCountChange
        end
      end
      object GroupBox24: TGroupBox
        Left = 8
        Top = 88
        Width = 145
        Height = 49
        Caption = 'PK'#29366#24577#21464#33394'('#31186')'
        TabOrder = 2
        object Label54: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #26102#38388':'
        end
        object EditPKFlagTime: TSpinEdit
          Left = 44
          Top = 16
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditPKFlagTimeChange
        end
      end
      object GroupBox25: TGroupBox
        Left = 8
        Top = 144
        Width = 145
        Height = 49
        Caption = #26432#20154#22686#21152'PK'#28857#25968
        TabOrder = 3
        object Label55: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #28857#25968':'
        end
        object EditKillHumanAddPKPoint: TSpinEdit
          Left = 44
          Top = 16
          Width = 53
          Height = 21
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditKillHumanAddPKPointChange
        end
      end
      object GroupBox32: TGroupBox
        Left = 160
        Top = 8
        Width = 267
        Height = 167
        Caption = 'PK'#35268#21017
        TabOrder = 4
        object Label58: TLabel
          Left = 112
          Top = 20
          Width = 66
          Height = 12
          Caption = #22686#21152#31561#32423#25968':'
        end
        object Label65: TLabel
          Left = 112
          Top = 44
          Width = 66
          Height = 12
          Caption = #20943#23569#31561#32423#25968':'
        end
        object Label66: TLabel
          Left = 112
          Top = 68
          Width = 66
          Height = 12
          Caption = #22686#21152#32463#39564#25968':'
        end
        object Label56: TLabel
          Left = 112
          Top = 92
          Width = 66
          Height = 12
          Caption = #20943#23569#32463#39564#25968':'
        end
        object Label67: TLabel
          Left = 8
          Top = 92
          Width = 42
          Height = 12
          Caption = 'PK'#31561#32423':'
        end
        object Label114: TLabel
          Left = 112
          Top = 116
          Width = 66
          Height = 12
          Caption = 'PK'#20445#25252#31561#32423':'
        end
        object Label115: TLabel
          Left = 89
          Top = 140
          Width = 90
          Height = 12
          Caption = #32418#21517'PK'#20445#25252#31561#32423':'
        end
        object CheckBoxKillHumanWinLevel: TCheckBox
          Left = 8
          Top = 18
          Width = 97
          Height = 17
          Caption = #26432#20154#22686#21152#31561#32423
          TabOrder = 0
          OnClick = CheckBoxKillHumanWinLevelClick
        end
        object CheckBoxKilledLostLevel: TCheckBox
          Left = 8
          Top = 36
          Width = 97
          Height = 17
          Caption = #34987#26432#20943#31561#32423
          TabOrder = 1
          OnClick = CheckBoxKilledLostLevelClick
        end
        object CheckBoxKilledLostExp: TCheckBox
          Left = 8
          Top = 68
          Width = 97
          Height = 17
          Caption = #34987#26432#20943#32463#39564
          TabOrder = 2
          OnClick = CheckBoxKilledLostExpClick
        end
        object CheckBoxKillHumanWinExp: TCheckBox
          Left = 8
          Top = 52
          Width = 97
          Height = 17
          Caption = #26432#20154#22686#21152#32463#39564
          TabOrder = 3
          OnClick = CheckBoxKillHumanWinExpClick
        end
        object EditKillHumanWinLevel: TSpinEdit
          Left = 184
          Top = 16
          Width = 73
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 4
          Value = 10
          OnChange = EditKillHumanWinLevelChange
        end
        object EditKilledLostLevel: TSpinEdit
          Left = 184
          Top = 40
          Width = 73
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 5
          Value = 10
          OnChange = EditKilledLostLevelChange
        end
        object EditKillHumanWinExp: TSpinEdit
          Left = 184
          Top = 64
          Width = 73
          Height = 21
          Increment = 1000
          MaxValue = 200000000
          MinValue = 1
          TabOrder = 6
          Value = 10
          OnChange = EditKillHumanWinExpChange
        end
        object EditKillHumanLostExp: TSpinEdit
          Left = 184
          Top = 88
          Width = 73
          Height = 21
          Increment = 1000
          MaxValue = 200000000
          MinValue = 1
          TabOrder = 7
          Value = 10
          OnChange = EditKillHumanLostExpChange
        end
        object EditHumanLevelDiffer: TSpinEdit
          Left = 56
          Top = 88
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 8
          Value = 10
          OnChange = EditHumanLevelDifferChange
        end
        object CheckBoxPKLevelProtect: TCheckBox
          Left = 8
          Top = 116
          Width = 89
          Height = 17
          Hint = 
            #21551#29992'PK'#20445#25252#21151#33021#65292#25171#24320#27492#21151#33021#21518#65292#28216#25103#20013#39640#20110#20445#25252#31561#32423#30340#20154#29289#23558#19981#21487#20197#26432#20302#20110#20445#25252#31561#32423#30340#20154#29289'('#20302#31561#32423#20154#29289#20808#25915#20987#21464#33394#38500#22806')'#65292#20302#20110#20445#25252#31561#32423#30340 +
            #20154#29289#20063#19981#21487#20197#26432#39640#20110#20445#25252#31561#32423#30340#20154#29289'('#39640#31561#32423#20154#29289#20808#25915#20987#21464#33394#38500#22806')'#12290
          Caption = #26222#36890'PK'#20445#25252
          TabOrder = 9
          OnClick = CheckBoxPKLevelProtectClick
        end
        object EditPKProtectLevel: TSpinEdit
          Left = 184
          Top = 112
          Width = 73
          Height = 21
          Hint = #20445#25252#31561#32423#12290#27492#31561#32423#20197#19979#20154#29289#21463#20445#25252#65292#20294#20808#25915#20987#21464#33394#21017#19981#21463#20445#25252#12290
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 1
          TabOrder = 10
          Value = 10
          OnChange = EditPKProtectLevelChange
        end
        object EditRedPKProtectLevel: TSpinEdit
          Left = 184
          Top = 136
          Width = 73
          Height = 21
          Hint = 
            #32418#21517#20154#29289'PK'#20445#25252#65292#39640#20110#20445#25252#31561#32423#30340#32418#21517#20154#29289#19981#21487#20197#26432#20302#20110#20445#25252#31561#32423#26410#32418#21517#20154#29289#12290#20302#20110#20445#25252#31561#32423#26410#32418#21517#30340#20154#29289#20063#19981#21487#20197#26432#39640#20110#20445#25252#31561#32423#30340#32418#21517#20154#29289 +
            #12290
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 1
          TabOrder = 11
          Value = 10
          OnChange = EditRedPKProtectLevelChange
        end
      end
    end
    object GameSpeedSheet: TTabSheet
      Caption = #28216#25103#36895#24230
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 97
        Height = 169
        Caption = #38388#38548#25511#21046'('#27627#31186')'
        TabOrder = 0
        object Label1: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #25915#20987':'
        end
        object Label2: TLabel
          Left = 11
          Top = 48
          Width = 30
          Height = 12
          Caption = #39764#27861':'
        end
        object Label3: TLabel
          Left = 11
          Top = 72
          Width = 30
          Height = 12
          Caption = #36305#27493':'
        end
        object Label4: TLabel
          Left = 11
          Top = 96
          Width = 30
          Height = 12
          Caption = #36208#36335':'
        end
        object Label5: TLabel
          Left = 11
          Top = 144
          Width = 30
          Height = 12
          Caption = #25366#32905':'
          Enabled = False
        end
        object Label6: TLabel
          Left = 11
          Top = 120
          Width = 30
          Height = 12
          Caption = #36716#21521':'
        end
        object EditHitIntervalTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 45
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 0
          Value = 900
          OnChange = EditHitIntervalTimeChange
        end
        object EditMagicHitIntervalTime: TSpinEdit
          Left = 44
          Top = 44
          Width = 45
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 1
          Value = 800
          OnChange = EditMagicHitIntervalTimeChange
        end
        object EditRunIntervalTime: TSpinEdit
          Left = 44
          Top = 68
          Width = 45
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 2
          Value = 600
          OnChange = EditRunIntervalTimeChange
        end
        object EditWalkIntervalTime: TSpinEdit
          Left = 44
          Top = 92
          Width = 45
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 3
          Value = 600
          OnChange = EditWalkIntervalTimeChange
        end
        object EditTurnIntervalTime: TSpinEdit
          Left = 44
          Top = 116
          Width = 45
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 4
          Value = 600
          OnChange = EditTurnIntervalTimeChange
        end
        object EditDigUpIntervalTime: TSpinEdit
          Left = 44
          Top = 140
          Width = 45
          Height = 21
          EditorEnabled = False
          Enabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 5
          Value = 10
          OnChange = EditWalkIntervalTimeChange
        end
      end
      object GroupBox2: TGroupBox
        Left = 112
        Top = 8
        Width = 81
        Height = 168
        Caption = #25968#25454#37327#25511#21046
        TabOrder = 1
        object Label7: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #25915#20987':'
        end
        object Label8: TLabel
          Left = 11
          Top = 48
          Width = 30
          Height = 12
          Caption = #39764#27861':'
        end
        object Label9: TLabel
          Left = 11
          Top = 72
          Width = 30
          Height = 12
          Caption = #36305#27493':'
        end
        object Label10: TLabel
          Left = 11
          Top = 96
          Width = 30
          Height = 12
          Caption = #36208#36335':'
        end
        object Label11: TLabel
          Left = 11
          Top = 144
          Width = 30
          Height = 12
          Caption = #25366#32905':'
        end
        object Label12: TLabel
          Left = 11
          Top = 120
          Width = 30
          Height = 12
          Caption = #36716#21521':'
        end
        object EditMaxHitMsgCount: TSpinEdit
          Left = 44
          Top = 20
          Width = 29
          Height = 21
          Hint = #20801#35768#21516#26102#25805#20316#25968#37327#65292#27492#21442#25968#40664#35748#20026'1('#21152#22823#27492#25968#23383#65292#23558#20986#29616#21452#20493#21450#22810#20493#25915#20987')'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 0
          Value = 2
          OnChange = EditMaxHitMsgCountChange
        end
        object EditMaxSpellMsgCount: TSpinEdit
          Left = 44
          Top = 44
          Width = 29
          Height = 21
          Hint = #20801#35768#21516#26102#25805#20316#25968#37327#65292#27492#21442#25968#40664#35748#20026'1('#21152#22823#27492#25968#23383#65292#23558#20986#29616#21452#20493#21450#22810#20493#25915#20987')'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 1
          Value = 2
          OnChange = EditMaxSpellMsgCountChange
        end
        object EditMaxRunMsgCount: TSpinEdit
          Left = 44
          Top = 68
          Width = 29
          Height = 21
          Hint = #20801#35768#21516#26102#25805#20316#25968#37327#65292#27492#21442#25968#40664#35748#20026'1('#21152#22823#27492#25968#23383#65292#23558#20986#29616#21452#20493#21450#22810#20493#25915#20987')'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 2
          Value = 2
          OnChange = EditMaxRunMsgCountChange
        end
        object EditMaxWalkMsgCount: TSpinEdit
          Left = 44
          Top = 92
          Width = 29
          Height = 21
          Hint = #20801#35768#21516#26102#25805#20316#25968#37327#65292#27492#21442#25968#40664#35748#20026'1('#21152#22823#27492#25968#23383#65292#23558#20986#29616#21452#20493#21450#22810#20493#25915#20987')'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 3
          Value = 2
          OnChange = EditMaxWalkMsgCountChange
        end
        object EditMaxTurnMsgCount: TSpinEdit
          Left = 44
          Top = 116
          Width = 29
          Height = 21
          Hint = #20801#35768#21516#26102#25805#20316#25968#37327#65292#27492#21442#25968#40664#35748#20026'1('#21152#22823#27492#25968#23383#65292#23558#20986#29616#21452#20493#21450#22810#20493#25915#20987')'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 4
          Value = 2
          OnChange = EditMaxTurnMsgCountChange
        end
        object EditMaxDigUpMsgCount: TSpinEdit
          Left = 44
          Top = 140
          Width = 29
          Height = 21
          Hint = #20801#35768#21516#26102#25805#20316#25968#37327#65292#27492#21442#25968#40664#35748#20026'1('#21152#22823#27492#25968#23383#65292#23558#20986#29616#21452#20493#21450#22810#20493#25915#20987')'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 5
          Value = 2
          OnChange = EditMaxDigUpMsgCountChange
        end
      end
      object GroupBox3: TGroupBox
        Left = 360
        Top = 72
        Width = 113
        Height = 45
        Caption = #35013#22791#36895#24230
        TabOrder = 2
        object Label13: TLabel
          Left = 11
          Top = 20
          Width = 30
          Height = 12
          Caption = #36895#24230':'
        end
        object EditItemSpeedTime: TSpinEdit
          Left = 52
          Top = 16
          Width = 53
          Height = 21
          Hint = #25511#21046#35013#22791#21152#36895#24773#20917#65292#25968#23383#36234#22823#36234#23485#65292#36234#23567#19987#36234#20005
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 50
          OnChange = EditItemSpeedTimeChange
        end
      end
      object ButtonGameSpeedSave: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 3
        OnClick = ButtonGameSpeedSaveClick
      end
      object GroupBox4: TGroupBox
        Left = 360
        Top = 8
        Width = 113
        Height = 57
        Caption = #36895#24230#25511#21046#27169#24335
        TabOrder = 4
        object RadioButtonDelyMode: TRadioButton
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Hint = #23558#36229#36807#36895#24230#30340#25805#20316#36827#34892#24310#26102#22788#29702#65292#20197#20445#25345#27491#24120#36895#24230#65292#20351#29992#27492#31181#27169#24335#23458#25143#31471#20351#29992#21152#36895#23558#36896#25104#21345#30340#29616#35937#12290
          Caption = #20572#39039#25805#20316#22788#29702
          TabOrder = 0
          OnClick = RadioButtonDelyModeClick
        end
        object RadioButtonFilterMode: TRadioButton
          Left = 8
          Top = 35
          Width = 97
          Height = 17
          Hint = #23558#36229#36807#36895#24230#30340#25805#20316#30452#25509#36807#28388#22788#29702#65292#20002#24323#36229#36895#24230#30340#25805#20316#65292#20351#29992#27492#31181#27169#24335#23458#25143#31471#20351#29992#21152#36895#23558#36896#25104#21345#20992#65292#21453#24377#30340#29616#35937#12290
          Caption = #21453#24377#21345#20992#22788#29702
          TabOrder = 1
          OnClick = RadioButtonFilterModeClick
        end
      end
      object GroupBox7: TGroupBox
        Left = 200
        Top = 110
        Width = 153
        Height = 95
        Caption = #20154#29289#24367#33136#25511#21046
        TabOrder = 5
        object Label22: TLabel
          Left = 11
          Top = 18
          Width = 54
          Height = 12
          Caption = #20572#30041#26102#38388':'
        end
        object EditStruckTime: TSpinEdit
          Left = 68
          Top = 14
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 10
          TabOrder = 0
          Value = 100
          OnChange = EditStruckTimeChange
        end
        object CheckBoxDisableStruck: TCheckBox
          Left = 11
          Top = 39
          Width = 105
          Height = 17
          Caption = #20154#29289#26080#24367#33136#21160#20316
          TabOrder = 1
          OnClick = CheckBoxDisableStruckClick
        end
        object CheckBoxDisableSelfStruck: TCheckBox
          Left = 11
          Top = 55
          Width = 105
          Height = 17
          Caption = #20154#29289#33258#24049#19981#24367#33136
          TabOrder = 2
          OnClick = CheckBoxDisableSelfStruckClick
        end
        object CheckBoxDisableHeroStruck: TCheckBox
          Left = 11
          Top = 71
          Width = 105
          Height = 17
          Caption = #33521#38596#26080#24367#33136#21160#20316
          TabOrder = 3
          OnClick = CheckBoxDisableHeroStruckClick
        end
      end
      object GroupBox15: TGroupBox
        Left = 200
        Top = 8
        Width = 153
        Height = 95
        Caption = #25805#20316#25968#25454#25511#21046
        TabOrder = 6
        object Label38: TLabel
          Left = 11
          Top = 70
          Width = 30
          Height = 12
          Caption = #27425#25968':'
        end
        object Label142: TLabel
          Left = 75
          Top = 70
          Width = 30
          Height = 12
          Caption = #36807#28388':'
        end
        object EditOverSpeedKickCount: TSpinEdit
          Left = 44
          Top = 66
          Width = 29
          Height = 21
          Hint = #36229#36895#27425#25968#65292#36229#25351#23450#27425#25968#21017#34987#36386#19979#32447#12290
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 0
          Value = 4
          OnChange = EditOverSpeedKickCountChange
        end
        object CheckBoxboKickOverSpeed: TCheckBox
          Left = 8
          Top = 46
          Width = 137
          Height = 17
          Hint = #23558#36229#36895#25805#20316#30340#20154#29289#36386#19979#32447#12290
          Caption = #25481#32447#22788#29702#36229#36895#25805#20316#65306
          TabOrder = 1
          OnClick = CheckBoxboKickOverSpeedClick
        end
        object EditDropOverSpeed: TSpinEdit
          Left = 104
          Top = 66
          Width = 41
          Height = 21
          Hint = #36807#28388#36229#36895#25805#20316#25968#25454#65292#25968#23383#36234#23567#36234#20005#65292#36807#28388#21518#23458#25143#31471#20250#20986#29616#21345#20992#25110#21453#24377#29616#35937#12290'('#27627#31186')'
          EditorEnabled = False
          Increment = 10
          MaxValue = 1000
          MinValue = 1
          TabOrder = 2
          Value = 50
          OnChange = EditDropOverSpeedChange
        end
        object CheckBoxSpellSendUpdateMsg: TCheckBox
          Left = 8
          Top = 16
          Width = 129
          Height = 17
          Hint = #25511#21046#20154#29289#21516#26102#30456#21516#39764#27861#25805#20316#25968#25454#65292#21516#26102#21482#33021#26377#19968#20010#39764#27861#25915#20987#25805#20316
          Caption = #39764#27861#25805#20316#25968#25454#37327#25511#21046
          TabOrder = 3
          OnClick = CheckBoxSpellSendUpdateMsgClick
        end
        object CheckBoxActionSendActionMsg: TCheckBox
          Left = 8
          Top = 33
          Width = 129
          Height = 13
          Hint = #25511#21046#20154#29289#21516#26102#30456#21516#25915#20987#25805#20316#25968#25454#65292#21516#26102#21482#33021#26377#19968#20010#39764#27861#25915#20987#25805#20316
          Caption = #25915#20987#25805#20316#25968#25454#37327#25511#21046
          TabOrder = 4
          OnClick = CheckBoxActionSendActionMsgClick
        end
      end
      object ButtonGameSpeedDefault: TButton
        Left = 408
        Top = 220
        Width = 65
        Height = 21
        Caption = #40664#35748'(&D)'
        TabOrder = 7
        OnClick = ButtonGameSpeedDefaultClick
      end
      object ButtonActionSpeedConfig: TButton
        Left = 408
        Top = 195
        Width = 65
        Height = 21
        Caption = #32452#21512#36895#24230
        TabOrder = 8
        OnClick = ButtonActionSpeedConfigClick
      end
      object cbSpeedCheck: TCheckBox
        Left = 9
        Top = 183
        Width = 129
        Height = 17
        Hint = #24314#35758#20851#38381'M2'#30340#21152#36895#25511#21046#65292#32780#20351#29992'Rungate'#26469#25511#21046#21152#36895#12290
        Caption = #20851#38381'M2'#30340#21152#36895#25511#21046
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        OnClick = CheckBoxSpellSendUpdateMsgClick
      end
    end
    object TabSheet10: TTabSheet
      Caption = #22806#25346#25511#21046
      ImageIndex = 13
      object ButtonCharStatusSave: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonCharStatusSaveClick
      end
      object GroupBox72: TGroupBox
        Left = 8
        Top = 8
        Width = 129
        Height = 89
        Caption = #40635#30201#25511#21046
        TabOrder = 1
        object CheckBoxParalyCanRun: TCheckBox
          Left = 8
          Top = 16
          Width = 73
          Height = 17
          Hint = #20154#29289#34987#40635#30201#21518#26159#21542#20801#35768#36305#21160#65292#38057#19978#20026#20801#35768#36305#21160
          Caption = #20801#35768#36305#21160
          TabOrder = 0
          OnClick = CheckBoxParalyCanRunClick
        end
        object CheckBoxParalyCanWalk: TCheckBox
          Left = 8
          Top = 32
          Width = 73
          Height = 17
          Hint = #20154#29289#34987#40635#30201#21518#26159#21542#20801#35768#36305#21160#65292#38057#19978#20026#20801#35768#36208#21160
          Caption = #20801#35768#36208#21160
          TabOrder = 1
          OnClick = CheckBoxParalyCanWalkClick
        end
        object CheckBoxParalyCanHit: TCheckBox
          Left = 8
          Top = 48
          Width = 73
          Height = 17
          Hint = #20154#29289#34987#40635#30201#21518#26159#21542#20801#35768#36305#21160#65292#38057#19978#20026#20801#35768#25915#20987
          Caption = #20801#35768#25915#20987
          TabOrder = 2
          OnClick = CheckBoxParalyCanHitClick
        end
        object CheckBoxParalyCanSpell: TCheckBox
          Left = 8
          Top = 64
          Width = 73
          Height = 17
          Hint = #20154#29289#34987#40635#30201#21518#26159#21542#20801#35768#36305#21160#65292#38057#19978#20026#20801#35768#39764#27861
          Caption = #20801#35768#39764#27861
          TabOrder = 3
          OnClick = CheckBoxParalyCanSpellClick
        end
      end
      object GroupBoxCheckHookTool: TGroupBox
        Left = 144
        Top = 8
        Width = 153
        Height = 65
        Caption = #25346#26426#22806#25346#25511#21046'('#26410#23436#25104')'
        TabOrder = 2
        object LabelCheckHookTool: TLabel
          Left = 8
          Top = 40
          Width = 54
          Height = 12
          Caption = #25346#26426#26816#27979':'
        end
        object CheckBoxCheckHookTool: TCheckBox
          Left = 8
          Top = 16
          Width = 129
          Height = 17
          Caption = #24320#21551#23553#25346#26426#22806#25346#21151#33021
          TabOrder = 0
          OnClick = CheckBoxCheckHookToolClick
        end
        object SpinEditCheckHookTool: TSpinEdit
          Left = 64
          Top = 36
          Width = 53
          Height = 21
          Hint = #26816#27979#25346#26426#22806#25346#29992#65292#25968#23383#36234#23567#65292#26816#27979#36234#20005#26684#65292#40664#35748'20'#12290
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 5
          TabOrder = 1
          Value = 10
          OnChange = SpinEditCheckHookToolChange
        end
      end
      object GroupBox76: TGroupBox
        Left = 8
        Top = 104
        Width = 129
        Height = 65
        Caption = #22806#25346#25511#21046
        TabOrder = 3
        object Label146: TLabel
          Left = 8
          Top = 40
          Width = 54
          Height = 12
          Caption = #26816#27979#21442#25968':'
        end
        object CheckBoxDisableDoubleAttack: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = #31105#27490#21452#20493#25915#20987
          TabOrder = 0
          OnClick = CheckBoxDisableDoubleAttackClick
        end
        object EditDoubleAttackCheck: TSpinEdit
          Left = 64
          Top = 36
          Width = 53
          Height = 21
          Hint = #26816#27979#22810#20493#25915#20987#21442#25968#65292#25968#23383#36234#22823#65292#26816#27979#36234#20005#65292#40664#35748'200'#12290
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditDoubleAttackCheckChange
        end
      end
      object ShowRedHPLable: TCheckBox
        Left = 327
        Top = 12
        Width = 73
        Height = 17
        Caption = #26174#34880#34880#26465
        TabOrder = 4
        OnClick = CheckBoxParalyCanRunClick
      end
      object ShowHPNumber: TCheckBox
        Left = 327
        Top = 29
        Width = 73
        Height = 17
        Caption = #25968#23383#26174#34880
        TabOrder = 5
        OnClick = CheckBoxParalyCanRunClick
      end
    end
    object ExpSheet: TTabSheet
      Caption = #21319#32423#32463#39564
      ImageIndex = 1
      object GroupBox8: TGroupBox
        Left = 184
        Top = 8
        Width = 145
        Height = 89
        Caption = #26432#24618#32463#39564
        TabOrder = 0
        object Label23: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #20493#29575':'
        end
        object EditKillMonExpMultiple: TSpinEdit
          Left = 44
          Top = 20
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditKillMonExpMultipleChange
        end
        object CheckBoxHighLevelKillMonFixExp: TCheckBox
          Left = 11
          Top = 45
          Width = 126
          Height = 17
          Caption = #39640#31561#32423#26432#24618#32463#39564#19981#21464
          TabOrder = 1
          OnClick = CheckBoxHighLevelKillMonFixExpClick
        end
        object CheckBoxHighLevelGroupFixExp: TCheckBox
          Left = 11
          Top = 63
          Width = 126
          Height = 17
          Caption = #32452#38431#30340#32463#39564#24179#22343#20998#37197
          TabOrder = 2
          OnClick = CheckBoxHighLevelGroupFixExpClick
        end
      end
      object ButtonExpSave: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonExpSaveClick
      end
      object GroupBoxLevelExp: TGroupBox
        Left = 8
        Top = 8
        Width = 169
        Height = 257
        Caption = #21319#32423#32463#39564
        TabOrder = 2
        object Label37: TLabel
          Left = 11
          Top = 235
          Width = 30
          Height = 12
          Caption = #35745#21010':'
        end
        object ComboBoxLevelExp: TComboBox
          Left = 48
          Top = 230
          Width = 113
          Height = 20
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnClick = ComboBoxLevelExpClick
        end
        object GridLevelExp: TStringGrid
          Left = 8
          Top = 16
          Width = 153
          Height = 209
          ColCount = 2
          DefaultRowHeight = 15
          RowCount = 501
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
          TabOrder = 1
          OnSetEditText = GridLevelExpSetEditText
          ColWidths = (
            64
            67)
          RowHeights = (
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15
            15)
        end
      end
      object GroupBox75: TGroupBox
        Left = 336
        Top = 8
        Width = 137
        Height = 89
        Caption = #31561#32423#38480#21046
        TabOrder = 3
        object Label151: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #38480#21046#31561#32423':'
        end
        object Label152: TLabel
          Left = 11
          Top = 64
          Width = 54
          Height = 12
          Caption = #38480#21046#20493#29575':'
        end
        object SpinEditLimitLevel: TSpinEdit
          Left = 68
          Top = 36
          Width = 61
          Height = 21
          MaxValue = 65535
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = SpinEditLimitLevelChange
        end
        object CheckBoxLevelLimit: TCheckBox
          Left = 11
          Top = 15
          Width = 118
          Height = 17
          Caption = #26368#39640#31561#32423#32463#39564#38480#21046
          TabOrder = 1
          OnClick = CheckBoxLevelLimitClick
        end
        object SpinEditKillMonExpDiv: TSpinEdit
          Left = 68
          Top = 60
          Width = 61
          Height = 21
          Hint = #36825#37324#30340#25968#20540#36234#23567#65292#38480#21046#36234#20005#26684#65292#24314#35758'300'#12290
          MaxValue = 65535
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = SpinEditKillMonExpDivChange
        end
      end
      object GroupBox77: TGroupBox
        Left = 184
        Top = 104
        Width = 145
        Height = 161
        Caption = #31561#32423#32463#39564#25511#21046
        TabOrder = 4
        object GridLimitLevelExp: TStringGrid
          Left = 8
          Top = 16
          Width = 129
          Height = 137
          ColCount = 2
          DefaultRowHeight = 15
          FixedCols = 0
          RowCount = 21
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
          TabOrder = 0
          OnSetEditText = GridLimitLevelExpSetEditText
          ColWidths = (
            60
            47)
        end
      end
      object GroupBox74: TGroupBox
        Left = 336
        Top = 104
        Width = 137
        Height = 49
        Caption = #33521#38596#21319#32423#38656#35201#32463#39564
        TabOrder = 5
        object Label147: TLabel
          Left = 9
          Top = 24
          Width = 120
          Height = 12
          Caption = #20154#29289#32463#39564#30340':        %'
        end
        object EditHeroLevelExpRate: TSpinEdit
          Left = 75
          Top = 20
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 100
          OnChange = EditHeroLevelExpRateChange
        end
      end
      object grpGroupExp: TGroupBox
        Left = 336
        Top = 160
        Width = 137
        Height = 73
        Caption = #32452#38431#32463#39564#35774#32622
        TabOrder = 6
        object lblGroup: TLabel
          Left = 5
          Top = 23
          Width = 48
          Height = 12
          Caption = #32452#38431#20154#25968
        end
        object lblExpValue: TLabel
          Left = 6
          Top = 48
          Width = 48
          Height = 12
          Caption = #32463#39564#20493#29575
        end
        object lbl1: TLabel
          Left = 120
          Top = 48
          Width = 6
          Height = 12
          Caption = '%'
        end
        object seGroupExpHumRate: TSpinEdit
          Left = 56
          Top = 44
          Width = 64
          Height = 21
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 100
          OnChange = seGroupExpHumRateChange
        end
        object cbbGroupExpHumCount: TComboBox
          Left = 56
          Top = 19
          Width = 72
          Height = 20
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
          OnSelect = cbbGroupExpHumCountSelect
        end
      end
    end
    object CastleSheet: TTabSheet
      Caption = #22478#22561#21442#25968
      ImageIndex = 3
      object GroupBox9: TGroupBox
        Left = 8
        Top = 8
        Width = 161
        Height = 113
        Caption = #36153#29992#25910#20837
        TabOrder = 0
        object Label24: TLabel
          Left = 11
          Top = 16
          Width = 54
          Height = 12
          Caption = #32500#20462#22478#38376':'
        end
        object Label25: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #32500#20462#22478#22681':'
        end
        object Label26: TLabel
          Left = 11
          Top = 64
          Width = 54
          Height = 12
          Caption = #38599#29992#24339#31661':'
        end
        object Label27: TLabel
          Left = 11
          Top = 88
          Width = 54
          Height = 12
          Caption = #38599#29992#21355#22763':'
        end
        object EditRepairDoorPrice: TSpinEdit
          Left = 72
          Top = 12
          Width = 81
          Height = 21
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 0
          Value = 2000000
          OnChange = EditRepairDoorPriceChange
        end
        object EditRepairWallPrice: TSpinEdit
          Left = 72
          Top = 36
          Width = 81
          Height = 21
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 1
          Value = 500000
          OnChange = EditRepairWallPriceChange
        end
        object EditHireArcherPrice: TSpinEdit
          Left = 72
          Top = 60
          Width = 81
          Height = 21
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 2
          Value = 300000
          OnChange = EditHireArcherPriceChange
        end
        object EditHireGuardPrice: TSpinEdit
          Left = 72
          Top = 84
          Width = 81
          Height = 21
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 3
          Value = 300000
          OnChange = EditHireGuardPriceChange
        end
      end
      object GroupBox10: TGroupBox
        Left = 8
        Top = 125
        Width = 161
        Height = 68
        Caption = #37329#24065#19978#38480
        TabOrder = 1
        object Label31: TLabel
          Left = 11
          Top = 16
          Width = 54
          Height = 12
          Caption = #22478#20869#36164#37329':'
        end
        object Label32: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #19968#22825#25910#20837':'
        end
        object EditCastleGoldMax: TSpinEdit
          Left = 72
          Top = 12
          Width = 81
          Height = 21
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 0
          Value = 10000000
          OnChange = EditCastleGoldMaxChange
        end
        object EditCastleOneDayGold: TSpinEdit
          Left = 72
          Top = 36
          Width = 81
          Height = 21
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 1
          Value = 2000000
          OnChange = EditCastleOneDayGoldChange
        end
      end
      object GroupBox11: TGroupBox
        Left = 296
        Top = 58
        Width = 121
        Height = 87
        Caption = #22238#22478#28857
        TabOrder = 2
        object Label28: TLabel
          Left = 11
          Top = 16
          Width = 42
          Height = 12
          Caption = #22320#22270#21495':'
        end
        object Label29: TLabel
          Left = 11
          Top = 40
          Width = 42
          Height = 12
          Caption = #24231#26631' X:'
        end
        object Label30: TLabel
          Left = 11
          Top = 64
          Width = 42
          Height = 12
          Caption = #24231#26631' Y:'
        end
        object EditCastleHomeX: TSpinEdit
          Left = 56
          Top = 36
          Width = 57
          Height = 21
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 644
          OnChange = EditCastleHomeXChange
        end
        object EditCastleHomeY: TSpinEdit
          Left = 56
          Top = 60
          Width = 57
          Height = 21
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 290
          OnChange = EditCastleHomeYChange
        end
        object EditCastleHomeMap: TEdit
          Left = 56
          Top = 12
          Width = 57
          Height = 20
          MaxLength = 20
          TabOrder = 2
          Text = '3'
          OnChange = EditCastleHomeMapChange
        end
      end
      object GroupBox12: TGroupBox
        Left = 176
        Top = 8
        Width = 113
        Height = 63
        Caption = #25915#22478#21306#22495#33539#22260
        TabOrder = 3
        object Label34: TLabel
          Left = 11
          Top = 16
          Width = 42
          Height = 12
          Caption = #24231#26631' X:'
        end
        object Label35: TLabel
          Left = 11
          Top = 40
          Width = 42
          Height = 12
          Caption = #24231#26631' Y:'
        end
        object EditWarRangeX: TSpinEdit
          Left = 56
          Top = 12
          Width = 49
          Height = 21
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 100
          OnChange = EditWarRangeXChange
        end
        object EditWarRangeY: TSpinEdit
          Left = 56
          Top = 36
          Width = 49
          Height = 21
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 100
          OnChange = EditWarRangeYChange
        end
      end
      object ButtonCastleSave: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 4
        OnClick = ButtonCastleSaveClick
      end
      object GroupBox13: TGroupBox
        Left = 176
        Top = 74
        Width = 113
        Height = 63
        Caption = #31246#25910
        TabOrder = 5
        object Label36: TLabel
          Left = 11
          Top = 40
          Width = 42
          Height = 12
          Caption = #31246#25910#29575':'
        end
        object EditTaxRate: TSpinEdit
          Left = 56
          Top = 36
          Width = 49
          Height = 21
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 5
          OnChange = EditTaxRateChange
        end
        object CheckBoxGetAllNpcTax: TCheckBox
          Left = 11
          Top = 13
          Width = 94
          Height = 17
          Caption = #25152#26377#21830#20154#20132#31246
          TabOrder = 1
          OnClick = CheckBoxGetAllNpcTaxClick
        end
      end
      object GroupBox14: TGroupBox
        Left = 296
        Top = 8
        Width = 121
        Height = 44
        Caption = #22478#22561#21517#31216
        TabOrder = 6
        object Label33: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 12
          Caption = #21517#31216':'
        end
        object EditCastleName: TEdit
          Left = 40
          Top = 16
          Width = 73
          Height = 20
          TabOrder = 0
          Text = #27801#24052#20811
          OnChange = EditCastleNameChange
        end
      end
      object GroupBox54: TGroupBox
        Left = 176
        Top = 146
        Width = 113
        Height = 47
        Caption = #25104#21592#25240#25187
        TabOrder = 7
        object Label107: TLabel
          Left = 11
          Top = 16
          Width = 42
          Height = 12
          Caption = #25240#25187#29575':'
        end
        object EditCastleMemberPriceRate: TSpinEdit
          Left = 56
          Top = 12
          Width = 49
          Height = 21
          Hint = #22478#22561#34892#20250#25104#21592#36141#20080#29289#21697#20215#26684#25240#25187#12290#25968#23383#20026#30334#20998#20043#20960#12290
          MaxValue = 200
          MinValue = 10
          TabOrder = 0
          Value = 10
          OnChange = EditCastleMemberPriceRateChange
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #20449#24687#25511#21046
      ImageIndex = 8
      object GroupBox36: TGroupBox
        Left = 8
        Top = 8
        Width = 129
        Height = 73
        Caption = #21457#36865#20449#24687#38271#24230
        TabOrder = 0
        object Label71: TLabel
          Left = 11
          Top = 24
          Width = 54
          Height = 12
          Caption = #32842#22825#20449#24687':'
        end
        object Label72: TLabel
          Left = 11
          Top = 48
          Width = 54
          Height = 12
          Caption = #24191#25773#20449#24687':'
        end
        object EditSayMsgMaxLen: TSpinEdit
          Left = 68
          Top = 20
          Width = 53
          Height = 21
          Hint = #21457#36865#25991#23383#20449#24687#26368#22823#38271#24230#12290
          MaxValue = 255
          MinValue = 1
          TabOrder = 0
          Value = 50
          OnChange = EditSayMsgMaxLenChange
        end
        object EditSayRedMsgMaxLen: TSpinEdit
          Left = 68
          Top = 44
          Width = 53
          Height = 21
          Hint = 'GM'#21457#32418#33394#24191#25773#25991#23383#26368#22823#38271#24230#12290
          MaxValue = 255
          MinValue = 1
          TabOrder = 1
          Value = 50
          OnChange = EditSayRedMsgMaxLenChange
        end
      end
      object GroupBox37: TGroupBox
        Left = 8
        Top = 88
        Width = 129
        Height = 49
        Caption = #20801#35768#21898#35805#31561#32423
        TabOrder = 1
        object Label73: TLabel
          Left = 11
          Top = 24
          Width = 54
          Height = 12
          Caption = #20154#29289#31561#32423':'
        end
        object EditCanShoutMsgLevel: TSpinEdit
          Left = 68
          Top = 20
          Width = 53
          Height = 21
          Hint = #20801#35768#21898#35805#31561#32423#65292#20154#29289#24517#39035#21040#36798#25351#23450#31561#32423#21518#25165#21487#20197#21898#35805#12290
          MaxValue = 65535
          MinValue = 1
          TabOrder = 0
          Value = 50
          OnChange = EditCanShoutMsgLevelChange
        end
      end
      object GroupBox38: TGroupBox
        Left = 144
        Top = 8
        Width = 137
        Height = 73
        Caption = #21457#36865#24191#25773#20449#24687
        TabOrder = 2
        object Label75: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #21457#36865#21629#20196':'
        end
        object CheckBoxShutRedMsgShowGMName: TCheckBox
          Left = 8
          Top = 16
          Width = 105
          Height = 17
          Hint = 'GM'#21457#36865#32418#33394#24191#25773#25991#20214#20449#24687#26102#26159#21542#26174#31034#20154#29289#30340#21517#23383#12290
          Caption = #26174#31034#20154#29289#21517#31216
          TabOrder = 0
          OnClick = CheckBoxShutRedMsgShowGMNameClick
        end
        object EditGMRedMsgCmd: TEdit
          Left = 72
          Top = 37
          Width = 41
          Height = 20
          Hint = #21457#36865#32418#33394#24191#25773#25991#20214#20449#24687#21629#20196#31526#12290#40664#35748#20026#8216'!'#8217#12290
          MaxLength = 20
          TabOrder = 1
          OnChange = EditGMRedMsgCmdChange
        end
      end
      object ButtonMsgSave: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 3
        OnClick = ButtonMsgSaveClick
      end
      object GroupBox68: TGroupBox
        Left = 144
        Top = 88
        Width = 137
        Height = 97
        Caption = #21457#36865#20449#24687#36895#24230#25511#21046
        TabOrder = 4
        object Label135: TLabel
          Left = 11
          Top = 24
          Width = 54
          Height = 12
          Caption = #21457#36865#38388#38548':'
        end
        object Label138: TLabel
          Left = 11
          Top = 48
          Width = 54
          Height = 12
          Caption = #21457#36865#25968#37327':'
        end
        object Label139: TLabel
          Left = 11
          Top = 72
          Width = 54
          Height = 12
          Caption = #31105#35328#26102#38388':'
        end
        object Label140: TLabel
          Left = 115
          Top = 24
          Width = 12
          Height = 12
          Caption = #31186
        end
        object Label141: TLabel
          Left = 115
          Top = 72
          Width = 12
          Height = 12
          Caption = #31186
        end
        object EditSayMsgTime: TSpinEdit
          Left = 68
          Top = 20
          Width = 45
          Height = 21
          MaxValue = 1000000
          MinValue = 1
          TabOrder = 0
          Value = 50
          OnChange = EditSayMsgTimeChange
        end
        object EditSayMsgCount: TSpinEdit
          Left = 68
          Top = 44
          Width = 45
          Height = 21
          MaxValue = 255
          MinValue = 1
          TabOrder = 1
          Value = 50
          OnChange = EditSayMsgCountChange
        end
        object EditDisableSayMsgTime: TSpinEdit
          Left = 68
          Top = 68
          Width = 45
          Height = 21
          MaxValue = 100000
          MinValue = 1
          TabOrder = 2
          Value = 50
          OnChange = EditDisableSayMsgTimeChange
        end
      end
      object GroupBox71: TGroupBox
        Left = 8
        Top = 144
        Width = 129
        Height = 41
        Caption = #26174#31034#21069#32512#20449#24687
        TabOrder = 5
        object CheckBoxShowPreFixMsg: TCheckBox
          Left = 8
          Top = 16
          Width = 105
          Height = 17
          Hint = #28216#25103#20013#32842#22825#26694#20013#26174#31034#30340#20449#24687#26159#21542#26174#31034#21069#32512#20449#24687#12290
          Caption = #26174#31034#20449#24687#30340#21069#32512
          TabOrder = 0
          OnClick = CheckBoxShowPreFixMsgClick
        end
      end
    end
    object TabSheet8: TTabSheet
      Caption = #25991#23383#39068#33394
      ImageIndex = 11
      object ButtonMsgColorSave: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonMsgColorSaveClick
      end
      object GroupBox55: TGroupBox
        Left = 8
        Top = 8
        Width = 105
        Height = 63
        Caption = #32842#22825#25991#23383
        TabOrder = 1
        object Label108: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label109: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabeltHearMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelHearMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditHearMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditHearMsgFColorChange
        end
        object EdittHearMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EdittHearMsgBColorChange
        end
      end
      object GroupBox56: TGroupBox
        Left = 8
        Top = 75
        Width = 105
        Height = 63
        Caption = #31169#32842#25991#23383
        TabOrder = 2
        object Label110: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label111: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabelWhisperMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelWhisperMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditWhisperMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditWhisperMsgFColorChange
        end
        object EditWhisperMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditWhisperMsgBColorChange
        end
      end
      object GroupBox57: TGroupBox
        Left = 8
        Top = 142
        Width = 105
        Height = 63
        Caption = 'GM'#31169#32842#25991#23383
        TabOrder = 3
        object Label112: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label113: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabelGMWhisperMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelGMWhisperMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditGMWhisperMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditGMWhisperMsgFColorChange
        end
        object EditGMWhisperMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditGMWhisperMsgBColorChange
        end
      end
      object GroupBox58: TGroupBox
        Left = 120
        Top = 8
        Width = 105
        Height = 63
        Caption = #32418#33394#25552#31034#25991#23383
        TabOrder = 4
        object Label116: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label117: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabelRedMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelRedMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditRedMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditRedMsgFColorChange
        end
        object EditRedMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditRedMsgBColorChange
        end
      end
      object GroupBox59: TGroupBox
        Left = 120
        Top = 75
        Width = 105
        Height = 63
        Caption = #32511#33394#25552#31034#25991#23383
        TabOrder = 5
        object Label120: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label121: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabelGreenMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelGreenMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditGreenMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditGreenMsgFColorChange
        end
        object EditGreenMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditGreenMsgBColorChange
        end
      end
      object GroupBox60: TGroupBox
        Left = 120
        Top = 142
        Width = 105
        Height = 63
        Caption = #34013#33394#25552#31034#25991#23383
        TabOrder = 6
        object Label124: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label125: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabelBlueMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelBlueMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditBlueMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditBlueMsgFColorChange
        end
        object EditBlueMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditBlueMsgBColorChange
        end
      end
      object GroupBox61: TGroupBox
        Left = 232
        Top = 8
        Width = 105
        Height = 63
        Caption = #21898#35805#25991#23383
        TabOrder = 7
        object Label128: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label129: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabelCryMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelCryMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditCryMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditCryMsgFColorChange
        end
        object EditCryMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditCryMsgBColorChange
        end
      end
      object GroupBox62: TGroupBox
        Left = 232
        Top = 75
        Width = 105
        Height = 63
        Caption = #34892#20250#32842#22825#25991#23383
        TabOrder = 8
        object Label132: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label133: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabelGuildMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelGuildMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditGuildMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditGuildMsgFColorChange
        end
        object EditGuildMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditGuildMsgBColorChange
        end
      end
      object GroupBox63: TGroupBox
        Left = 232
        Top = 142
        Width = 105
        Height = 63
        Caption = #32534#32452#32842#22825#25991#23383
        TabOrder = 9
        object Label136: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label137: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabelGroupMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelGroupMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditGroupMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditGroupMsgFColorChange
        end
        object EditGroupMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditGroupMsgBColorChange
        end
      end
      object GroupBox65: TGroupBox
        Left = 344
        Top = 8
        Width = 105
        Height = 63
        Caption = #31069#31119#35821#25991#23383
        TabOrder = 10
        object Label122: TLabel
          Left = 11
          Top = 16
          Width = 30
          Height = 12
          Caption = #25991#23383':'
        end
        object Label123: TLabel
          Left = 11
          Top = 40
          Width = 30
          Height = 12
          Caption = #32972#26223':'
        end
        object LabelCustMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelCustMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditCustMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditCustMsgFColorChange
        end
        object EditCustMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditCustMsgBColorChange
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = #26102#38388#25511#21046
      ImageIndex = 9
      object GroupBox39: TGroupBox
        Left = 8
        Top = 8
        Width = 105
        Height = 49
        Caption = #30003#35831#25915#22478#22825#25968
        TabOrder = 0
        object Label74: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #22825#25968':'
        end
        object Label77: TLabel
          Left = 83
          Top = 24
          Width = 12
          Height = 12
          Caption = #22825
        end
        object EditStartCastleWarDays: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 21
          Hint = #30003#35831#25915#22478#25152#38656#22825#25968#65292#21253#25324#24403#22825#12290
          MaxValue = 10
          MinValue = 2
          TabOrder = 0
          Value = 4
          OnChange = EditStartCastleWarDaysChange
        end
      end
      object GroupBox40: TGroupBox
        Left = 8
        Top = 64
        Width = 105
        Height = 49
        Caption = #25915#22478#24320#22987#26102#38388
        TabOrder = 1
        object Label76: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #26102#38388':'
        end
        object Label78: TLabel
          Left = 83
          Top = 24
          Width = 12
          Height = 12
          Caption = #28857
        end
        object EditStartCastlewarTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 21
          Hint = #24320#22987#25915#22478#26102#38388#65292'20'#20195#34920'20'#65306'00'
          MaxValue = 24
          MinValue = 1
          TabOrder = 0
          Value = 20
          OnChange = EditStartCastlewarTimeChange
        end
      end
      object GroupBox41: TGroupBox
        Left = 8
        Top = 120
        Width = 105
        Height = 49
        Caption = #25915#22478#32467#26463#25552#31034
        TabOrder = 2
        object Label79: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #26102#38388':'
        end
        object Label80: TLabel
          Left = 83
          Top = 24
          Width = 12
          Height = 12
          Caption = #20998
        end
        object EditShowCastleWarEndMsgTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 21
          Hint = #25915#22478#25112#32467#26463#21069#25351#23450#26102#38388#25552#31034#12290
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditShowCastleWarEndMsgTimeChange
        end
      end
      object GroupBox42: TGroupBox
        Left = 120
        Top = 8
        Width = 113
        Height = 49
        Caption = #25915#22478#26102#38271
        TabOrder = 3
        object Label81: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #26102#38271':'
        end
        object Label82: TLabel
          Left = 91
          Top = 24
          Width = 12
          Height = 12
          Caption = #20998
        end
        object EditCastleWarTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 45
          Height = 21
          Hint = #25915#22478#26102#38388#38271#24230#65292#40664#35748#20026'3'#20010#23567#26102#12290
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 180
          OnChange = EditCastleWarTimeChange
        end
      end
      object GroupBox43: TGroupBox
        Left = 120
        Top = 64
        Width = 113
        Height = 49
        Caption = #31105#27490#21344#39046#26102#38388
        TabOrder = 4
        object Label83: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #26102#38271':'
        end
        object Label84: TLabel
          Left = 91
          Top = 24
          Width = 12
          Height = 12
          Caption = #20998
        end
        object EditGetCastleTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 45
          Height = 21
          Hint = #25915#22478#25112#24320#22987#26102#65292#25351#23450#26102#38388#20869#19981#20801#35768#21344#39046#12290
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditGetCastleTimeChange
        end
      end
      object GroupBox44: TGroupBox
        Left = 240
        Top = 8
        Width = 105
        Height = 49
        Caption = #20154#29289#25968#25454#20445#23384#38388#38548
        TabOrder = 5
        object Label85: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #26102#38271':'
        end
        object Label86: TLabel
          Left = 83
          Top = 24
          Width = 12
          Height = 12
          Caption = #20998
        end
        object EditSaveHumanRcdTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 21
          Hint = #20154#29289#25968#25454#33258#21160#20445#23384#38388#38548#26102#38388#12290
          EditorEnabled = False
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditSaveHumanRcdTimeChange
        end
      end
      object GroupBox45: TGroupBox
        Left = 352
        Top = 8
        Width = 105
        Height = 49
        Caption = #20154#29289#36864#20986#37322#25918
        TabOrder = 6
        object Label87: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #26102#38271':'
        end
        object Label88: TLabel
          Left = 83
          Top = 24
          Width = 12
          Height = 12
          Caption = #20998
        end
        object EditHumanFreeDelayTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 21
          Hint = #20154#29289#36864#21518#25351#23450#26102#38388#21518#37322#25918#26102#38388#65292#36825#20010#26102#38388#19981#33021#22826#30701#65292#21542#21017#21487#33021#24341#36215#38169#35823#12290
          EditorEnabled = False
          MaxValue = 6000000
          MinValue = 5
          TabOrder = 0
          Value = 5
          OnChange = EditHumanFreeDelayTimeChange
        end
      end
      object GroupBox46: TGroupBox
        Left = 120
        Top = 120
        Width = 227
        Height = 51
        Caption = #28165#29702#26102#38388
        TabOrder = 7
        object Label89: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #27515#23608':'
        end
        object Label90: TLabel
          Left = 99
          Top = 24
          Width = 12
          Height = 12
          Caption = #31186
        end
        object Label91: TLabel
          Left = 121
          Top = 24
          Width = 30
          Height = 12
          Caption = #29289#21697':'
        end
        object Label92: TLabel
          Left = 209
          Top = 24
          Width = 12
          Height = 12
          Caption = #31186
        end
        object EditMakeGhostTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 53
          Height = 21
          Hint = #28165#38500#22320#19978#27515#23608#26102#38388#12290
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 180
          OnChange = EditMakeGhostTimeChange
        end
        object EditClearDropOnFloorItemTime: TSpinEdit
          Left = 154
          Top = 20
          Width = 53
          Height = 21
          Hint = #28165#38500#22320#19978#29289#21697#26102#38388#12290
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 1
          Value = 3600
          OnChange = EditClearDropOnFloorItemTimeChange
        end
      end
      object GroupBox47: TGroupBox
        Left = 240
        Top = 64
        Width = 105
        Height = 49
        Caption = #29190#29289#21697#21487#25441#26102#38388
        TabOrder = 8
        object Label93: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #26102#38271':'
        end
        object Label94: TLabel
          Left = 83
          Top = 24
          Width = 12
          Height = 12
          Caption = #31186
        end
        object EditFloorItemCanPickUpTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 21
          Hint = #20182#20154#29190#24618#29289#25110#25481#22320#19978#29289#21697#21487#25441#38388#38548#26102#38388#12290
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditFloorItemCanPickUpTimeChange
        end
      end
      object ButtonTimeSave: TButton
        Left = 408
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 9
        OnClick = ButtonTimeSaveClick
      end
      object GroupBox70: TGroupBox
        Left = 352
        Top = 64
        Width = 105
        Height = 49
        Caption = #34892#20250#25112#26102#38271
        TabOrder = 10
        object Label143: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #26102#38271':'
        end
        object Label144: TLabel
          Left = 83
          Top = 24
          Width = 12
          Height = 12
          Caption = #20998
        end
        object EditGuildWarTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 21
          Hint = #34892#20250#25112#26102#38388#38271#24230#12290
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditGuildWarTimeChange
        end
      end
    end
    object TabSheet7: TTabSheet
      Caption = #20215#26684#36153#29992
      ImageIndex = 10
      object GroupBox48: TGroupBox
        Left = 8
        Top = 8
        Width = 129
        Height = 49
        Caption = #30003#35831#34892#20250#36153#29992
        TabOrder = 0
        object Label95: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #36153#29992':'
        end
        object EditBuildGuildPrice: TSpinEdit
          Left = 44
          Top = 20
          Width = 77
          Height = 21
          Hint = #30003#35831#21019#24314#34892#20250#25152#38656#36153#29992#12290
          MaxValue = 100000000
          MinValue = 1000
          TabOrder = 0
          Value = 1000000
          OnChange = EditBuildGuildPriceChange
        end
      end
      object GroupBox49: TGroupBox
        Left = 8
        Top = 64
        Width = 129
        Height = 49
        Caption = #30003#35831#34892#20250#25112#36153#29992
        TabOrder = 1
        object Label96: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #36153#29992':'
        end
        object EditGuildWarPrice: TSpinEdit
          Left = 44
          Top = 20
          Width = 77
          Height = 21
          Hint = #30003#35831#34892#20250#25112#20105#25152#38656#36153#29992#12290
          MaxValue = 100000000
          MinValue = 1000
          TabOrder = 0
          Value = 30000
          OnChange = EditGuildWarPriceChange
        end
      end
      object GroupBox50: TGroupBox
        Left = 8
        Top = 120
        Width = 129
        Height = 49
        Caption = #28860#33647#20215#26684
        TabOrder = 2
        object Label97: TLabel
          Left = 11
          Top = 24
          Width = 30
          Height = 12
          Caption = #20215#26684':'
        end
        object EditMakeDurgPrice: TSpinEdit
          Left = 44
          Top = 20
          Width = 77
          Height = 21
          Hint = #28860#21046#33647#21697#25152#38656#36153#29992#12290
          MaxValue = 100000000
          MinValue = 10
          TabOrder = 0
          Value = 100
          OnChange = EditMakeDurgPriceChange
        end
      end
      object ButtonPriceSave: TButton
        Left = 411
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 3
        OnClick = ButtonPriceSaveClick
      end
      object GroupBox66: TGroupBox
        Left = 144
        Top = 8
        Width = 137
        Height = 73
        Caption = #20462#29702#29289#21697
        TabOrder = 4
        object Label126: TLabel
          Left = 11
          Top = 24
          Width = 78
          Height = 12
          Caption = #29305#20462#20215#26684#20493#25968':'
        end
        object Label127: TLabel
          Left = 11
          Top = 48
          Width = 66
          Height = 12
          Caption = #26222#20462#25481#25345#20037':'
        end
        object EditSuperRepairPriceRate: TSpinEdit
          Left = 92
          Top = 20
          Width = 37
          Height = 21
          Hint = #29305#20462#29289#21697#20215#26684#20493#25968#65292#40664#35748#20026#19977#20493#12290
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 3
          OnChange = EditSuperRepairPriceRateChange
        end
        object EditRepairItemDecDura: TSpinEdit
          Left = 92
          Top = 44
          Width = 37
          Height = 21
          Hint = #26222#36890#20462#29702#25481#25345#20037#28857#25968#12290
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 1
          Value = 3
          OnChange = EditRepairItemDecDuraChange
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = #20154#29289#27515#20129
      ImageIndex = 12
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 514
        Height = 269
        ActivePage = TabSheet11
        Align = alClient
        TabOrder = 0
        object TabSheet11: TTabSheet
          Caption = #26222#36890#36873#39033
          object ButtonHumanDieSave: TButton
            Left = 405
            Top = 218
            Width = 65
            Height = 21
            Caption = #20445#23384'(&S)'
            TabOrder = 0
            OnClick = ButtonHumanDieSaveClick
          end
          object GroupBox78: TGroupBox
            Left = 202
            Top = 93
            Width = 199
            Height = 91
            Caption = #27515#20129#25481#37329#24065#31561#32423
            TabOrder = 1
            object GridDieDropGold: TStringGrid
              Left = 8
              Top = 16
              Width = 183
              Height = 65
              ColCount = 2
              DefaultRowHeight = 15
              FixedCols = 0
              RowCount = 21
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
              TabOrder = 0
              OnSetEditText = GridLimitLevelExpSetEditText
              ColWidths = (
                61
                93)
            end
          end
          object GroupBox67: TGroupBox
            Left = 3
            Top = 4
            Width = 193
            Height = 180
            Caption = #20154#29289#27515#20129#25481#29289#21697#35268#21017
            TabOrder = 2
            object Label15: TLabel
              Left = 8
              Top = 133
              Width = 180
              Height = 12
              Caption = #25658#24102#20803#23453'>         '#19981#25481#36523#19978#29289#21697
            end
            object Label145: TLabel
              Left = 7
              Top = 157
              Width = 180
              Height = 12
              Caption = #25658#24102#20803#23453'>         '#19981#25481#32972#21253#29289#21697
            end
            object CheckBoxKillByMonstDropUseItem: TCheckBox
              Left = 8
              Top = 12
              Width = 121
              Height = 17
              Hint = #24403#20154#29289#34987#24618#29289#26432#27515#26102#20250#25353#25481#33853#26426#29575#25481#33853#36523#19978#25140#30340#29289#21697#12290
              Caption = #34987#24618#29289#26432#27515#25481#35013#22791
              TabOrder = 0
              OnClick = CheckBoxKillByMonstDropUseItemClick
            end
            object CheckBoxKillByHumanDropUseItem: TCheckBox
              Left = 8
              Top = 28
              Width = 121
              Height = 17
              Hint = #24403#20154#29289#34987#21035#20154#26432#27515#26102#20250#25353#25481#33853#26426#29575#25481#33853#36523#19978#25140#30340#29289#21697#12290
              Caption = #34987#20154#29289#26432#27515#25481#35013#22791
              TabOrder = 1
              OnClick = CheckBoxKillByHumanDropUseItemClick
            end
            object CheckBoxDieScatterBag: TCheckBox
              Left = 8
              Top = 44
              Width = 113
              Height = 17
              Hint = #24403#20154#29289#27515#20129#26102#20250#25353#25481#33853#26426#29575#25481#33853#32972#21253#37324#30340#29289#21697#12290
              Caption = #27515#20129#25481#32972#21253#29289#21697
              TabOrder = 2
              OnClick = CheckBoxDieScatterBagClick
            end
            object CheckBoxDieDropGold: TCheckBox
              Left = 8
              Top = 60
              Width = 113
              Height = 17
              Hint = #24403#20154#29289#27515#20129#26102#20250#25481#33853#36523#19978#30340#37329#24065#12290
              Caption = #27515#20129#25481#37329#24065
              TabOrder = 3
              OnClick = CheckBoxDieDropGoldClick
            end
            object CheckBoxDieRedScatterBagAll: TCheckBox
              Left = 8
              Top = 76
              Width = 145
              Height = 17
              Hint = #32418#21517#20154#29289#27515#20129#26102#25481#33853#32972#21253#20013#20840#37096#29289#21697#12290
              Caption = #32418#21517#25481#20840#37096#32972#21253#29289#21697
              TabOrder = 4
              OnClick = CheckBoxDieRedScatterBagAllClick
            end
            object EditNoDropItemGamegold: TSpinEdit
              Left = 64
              Top = 129
              Width = 49
              Height = 21
              MaxValue = 1000000
              MinValue = 1
              TabOrder = 5
              Value = 100
              OnChange = EditNoDropItemGamegoldChange
            end
            object EditNoScatterBagGamegold: TSpinEdit
              Left = 64
              Top = 153
              Width = 49
              Height = 21
              MaxValue = 1000000
              MinValue = 1
              TabOrder = 6
              Value = 100
              OnChange = EditNoScatterBagGamegoldChange
            end
            object CheckBoxNoDropItemOfGameGold: TCheckBox
              Left = 8
              Top = 109
              Width = 145
              Height = 17
              Hint = #26159#21542#36215#29992#20803#23453#20197#19979#30340#25968#37327#25193#23637#21151#33021
              Caption = #36215#29992#20803#23453#25968#37327#25193#23637#21151#33021':'
              TabOrder = 7
              OnClick = CheckBoxNoDropItemOfGameGoldClick
            end
            object CheckBoxDropGoldToPlayBag: TCheckBox
              Left = 8
              Top = 92
              Width = 105
              Height = 17
              Caption = #37329#24065#30452#25509#36827#21253#35065
              TabOrder = 8
              OnClick = CheckBoxDropGoldToPlayBagClick
            end
          end
          object GroupBox69: TGroupBox
            Left = 202
            Top = 3
            Width = 199
            Height = 85
            Caption = #25481#29289#21697#26426#29575
            TabOrder = 3
            object Label130: TLabel
              Left = 8
              Top = 21
              Width = 54
              Height = 12
              Caption = #25481#33853#35013#22791':'
            end
            object Label131: TLabel
              Left = 8
              Top = 41
              Width = 54
              Height = 12
              Caption = #32418#21517#35013#22791':'
            end
            object Label134: TLabel
              Left = 8
              Top = 61
              Width = 54
              Height = 12
              Caption = #32972#21253#29289#21697':'
            end
            object ScrollBarDieDropUseItemRate: TScrollBar
              Left = 64
              Top = 19
              Width = 89
              Height = 17
              Hint = #20154#29289#27515#20129#25481#33853#36523#19978#25140#30340#29289#21697#26426#29575#65292#35774#32622#30340#25968#23383#36234#23567#65292#26426#29575#36234#22823#12290
              Max = 500
              PageSize = 0
              TabOrder = 0
              OnChange = ScrollBarDieDropUseItemRateChange
            end
            object EditDieDropUseItemRate: TEdit
              Left = 159
              Top = 19
              Width = 33
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 1
            end
            object ScrollBarDieRedDropUseItemRate: TScrollBar
              Left = 64
              Top = 39
              Width = 89
              Height = 17
              Hint = #32418#21517#20154#29289#27515#20129#25481#33853#36523#19978#25140#30340#29289#21697#26426#29575#65292#35774#32622#30340#25968#23383#36234#23567#65292#26426#29575#36234#22823#12290
              PageSize = 0
              TabOrder = 2
              OnChange = ScrollBarDieRedDropUseItemRateChange
            end
            object EditDieRedDropUseItemRate: TEdit
              Left = 159
              Top = 39
              Width = 33
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 3
            end
            object ScrollBarDieScatterBagRate: TScrollBar
              Left = 64
              Top = 59
              Width = 89
              Height = 17
              Hint = #20154#29289#27515#20129#25481#33853#32972#21253#20013#30340#29289#21697#26426#29575#65292#35774#32622#30340#25968#23383#36234#23567#65292#26426#29575#36234#22823#12290
              Max = 500
              PageSize = 0
              TabOrder = 4
              OnChange = ScrollBarDieScatterBagRateChange
            end
            object EditDieScatterBagRate: TEdit
              Left = 159
              Top = 59
              Width = 33
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 5
            end
          end
        end
        object TabSheet12: TTabSheet
          Caption = #26292#29575#35774#32622
          ImageIndex = 1
          object GroupBox79: TGroupBox
            Left = 3
            Top = 3
            Width = 467
            Height = 237
            TabOrder = 0
            object Label148: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #34915#26381':'
            end
            object Label149: TLabel
              Left = 8
              Top = 44
              Width = 30
              Height = 12
              Caption = #27494#22120':'
            end
            object Label150: TLabel
              Left = 8
              Top = 67
              Width = 30
              Height = 12
              Caption = #21195#31456':'
            end
            object Label154: TLabel
              Left = 8
              Top = 90
              Width = 30
              Height = 12
              Caption = #39033#38142':'
            end
            object Label155: TLabel
              Left = 8
              Top = 113
              Width = 30
              Height = 12
              Caption = #22836#30420':'
            end
            object Label156: TLabel
              Left = 8
              Top = 136
              Width = 30
              Height = 12
              Caption = #24038#25163':'
            end
            object Label157: TLabel
              Left = 8
              Top = 159
              Width = 30
              Height = 12
              Caption = #21491#25163':'
            end
            object Label158: TLabel
              Left = 163
              Top = 66
              Width = 30
              Height = 12
              Caption = #27602#31526':'
            end
            object Label159: TLabel
              Left = 163
              Top = 90
              Width = 30
              Height = 12
              Caption = #33136#24102':'
            end
            object Label160: TLabel
              Left = 163
              Top = 113
              Width = 30
              Height = 12
              Caption = #38772#23376':'
            end
            object Label161: TLabel
              Left = 163
              Top = 136
              Width = 30
              Height = 12
              Caption = #23453#30707':'
            end
            object Label162: TLabel
              Left = 163
              Top = 159
              Width = 30
              Height = 12
              Caption = #26007#31520':'
            end
            object Label163: TLabel
              Left = 163
              Top = 19
              Width = 30
              Height = 12
              Caption = #24038#25106':'
            end
            object Label164: TLabel
              Left = 163
              Top = 43
              Width = 30
              Height = 12
              Caption = #21491#25106':'
            end
            object Label165: TLabel
              Left = 359
              Top = 20
              Width = 54
              Height = 12
              Caption = #32418#21517#20493#29575':'
            end
            object Label166: TLabel
              Left = 415
              Top = 41
              Width = 18
              Height = 12
              Caption = '/10'
            end
            object Label168: TLabel
              Left = 316
              Top = 71
              Width = 30
              Height = 12
              Caption = #20891#40723':'
            end
            object Label169: TLabel
              Left = 316
              Top = 94
              Width = 30
              Height = 12
              Caption = #39532#29260':'
            end
            object Label170: TLabel
              Left = 316
              Top = 117
              Width = 30
              Height = 12
              Caption = #26102#35013':'
            end
            object ScrollBarDieDropUseItemRate0: TScrollBar
              Left = 40
              Top = 19
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 0
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate0: TEdit
              Left = 127
              Top = 19
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 1
            end
            object ScrollBarDieDropUseItemRate1: TScrollBar
              Tag = 1
              Left = 40
              Top = 42
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 2
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate1: TEdit
              Left = 127
              Top = 42
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 3
            end
            object ScrollBarDieDropUseItemRate2: TScrollBar
              Tag = 2
              Left = 40
              Top = 65
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 4
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate2: TEdit
              Left = 127
              Top = 65
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 5
            end
            object EditDieDropUseItemRate5: TEdit
              Left = 127
              Top = 134
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 6
            end
            object ScrollBarDieDropUseItemRate5: TScrollBar
              Tag = 5
              Left = 40
              Top = 134
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 7
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate4: TEdit
              Left = 127
              Top = 111
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 8
            end
            object ScrollBarDieDropUseItemRate4: TScrollBar
              Tag = 4
              Left = 40
              Top = 111
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 9
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate3: TEdit
              Left = 127
              Top = 88
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 10
            end
            object ScrollBarDieDropUseItemRate3: TScrollBar
              Tag = 3
              Left = 40
              Top = 88
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 11
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object ScrollBarDieDropUseItemRate6: TScrollBar
              Tag = 6
              Left = 40
              Top = 157
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 12
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate6: TEdit
              Left = 127
              Top = 157
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 13
            end
            object ScrollBarDieDropUseItemRate9: TScrollBar
              Tag = 9
              Left = 195
              Top = 65
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 14
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate9: TEdit
              Left = 282
              Top = 64
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 15
            end
            object ScrollBarDieDropUseItemRate10: TScrollBar
              Tag = 10
              Left = 195
              Top = 88
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 16
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate10: TEdit
              Left = 282
              Top = 88
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 17
            end
            object ScrollBarDieDropUseItemRate11: TScrollBar
              Tag = 11
              Left = 195
              Top = 111
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 18
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate11: TEdit
              Left = 282
              Top = 111
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 19
            end
            object ScrollBarDieDropUseItemRate12: TScrollBar
              Tag = 12
              Left = 195
              Top = 134
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 20
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate12: TEdit
              Left = 282
              Top = 134
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 21
            end
            object ScrollBarDieDropUseItemRate13: TScrollBar
              Tag = 13
              Left = 195
              Top = 157
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 22
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate13: TEdit
              Left = 282
              Top = 157
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 23
            end
            object ScrollBarDieDropUseItemRate7: TScrollBar
              Tag = 7
              Left = 195
              Top = 18
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 24
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate7: TEdit
              Left = 282
              Top = 18
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 25
            end
            object EditDieDropUseItemRate8: TEdit
              Left = 282
              Top = 41
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 26
            end
            object ScrollBarDieDropUseItemRate8: TScrollBar
              Tag = 8
              Left = 195
              Top = 41
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 27
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object btnDieDropUseItemRateSingleSave: TButton
              Left = 395
              Top = 207
              Width = 65
              Height = 21
              Caption = #20445#23384'(&S)'
              TabOrder = 28
              OnClick = btnDieDropUseItemRateSingleSaveClick
            end
            object EditDieRedDropUseItemRateSingle: TSpinEdit
              Left = 359
              Top = 38
              Width = 54
              Height = 21
              MaxValue = 1000000
              MinValue = 1
              TabOrder = 29
              Value = 100
              OnChange = EditDieRedDropUseItemRateSingleChange
            end
            object cbDieDropUseItemRateSingle: TCheckBox
              Left = 8
              Top = -2
              Width = 137
              Height = 17
              Caption = #24320#21551#21333#29420#35013#22791#26426#29575#25481#33853
              TabOrder = 30
              OnClick = CheckBoxDropGoldToPlayBagClick
            end
            object ScrollBarDieDropUseItemRate14: TScrollBar
              Tag = 14
              Left = 348
              Top = 69
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 31
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate14: TEdit
              Left = 435
              Top = 69
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 32
            end
            object ScrollBarDieDropUseItemRate15: TScrollBar
              Tag = 15
              Left = 348
              Top = 92
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 33
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate15: TEdit
              Left = 435
              Top = 91
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 34
            end
            object ScrollBarDieDropUseItemRate16: TScrollBar
              Tag = 16
              Left = 348
              Top = 113
              Width = 81
              Height = 17
              Max = 999
              PageSize = 0
              TabOrder = 35
              OnChange = ScrollBarDieDropUseItemRate0Change
            end
            object EditDieDropUseItemRate16: TEdit
              Left = 435
              Top = 112
              Width = 25
              Height = 18
              Ctl3D = False
              Enabled = False
              ParentCtl3D = False
              ReadOnly = True
              TabOrder = 36
            end
          end
        end
      end
    end
    object tsSheetHPMP: TTabSheet
      Caption = 'HP/MP'
      ImageIndex = 14
      object lbl3: TLabel
        Left = 1
        Top = 232
        Width = 102
        Height = 12
        Hint = #20154#29289#31227#21160#20943#34880#34880#37327':'#40664#35748#20540#20026'1,'#22635#20889'0'#26102#20026#19981#25481'HP'
        Caption = #20154#29289#31227#21160#20943#34880#34880#37327':'
      end
      object lbl7: TLabel
        Left = 179
        Top = 232
        Width = 102
        Height = 12
        Hint = #20154#29289#31227#21160#20943#34880#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
        Caption = #20154#29289#31227#21160#20943#34880#38388#38548':'
      end
      object btnSaveHPMP: TButton
        Left = 443
        Top = 244
        Width = 65
        Height = 21
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = btnSaveHPMPClick
      end
      object grp1: TGroupBox
        Left = 4
        Top = 0
        Width = 121
        Height = 105
        Caption = #24674#22797#20154#29289#25112#22763'HP/MP'
        TabOrder = 1
        object lblHP: TLabel
          Left = 10
          Top = 16
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          Caption = #34880#37327#22522#25968':'
        end
        object lbl5: TLabel
          Left = 10
          Top = 38
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          Caption = #34880#37327#38388#38548':'
        end
        object lbl9: TLabel
          Left = 10
          Top = 61
          Width = 54
          Height = 12
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          Caption = #39764#27861#22522#25968':'
        end
        object lbl12: TLabel
          Left = 10
          Top = 83
          Width = 90
          Height = 12
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          AutoSize = False
          Caption = #39764#27861#38388#38548':'
        end
        object edtIncHP_HUMAN_WARRIOR: TSpinEdit
          Left = 65
          Top = 12
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 0
          Value = 75
          OnChange = EditCastleNameChange
        end
        object edtIncHPTime_HUMAN_WARRIOR: TSpinEdit
          Left = 65
          Top = 34
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 1
          Value = 300
          OnChange = EditCastleNameChange
        end
        object edtIncMP_HUMAN_WARRIOR: TSpinEdit
          Left = 65
          Top = 59
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 2
          Value = 18
          OnChange = EditCastleNameChange
        end
        object edtIncMPTime_HUMAN_WARRIOR: TSpinEdit
          Left = 65
          Top = 81
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 3
          Value = 800
          OnChange = EditCastleNameChange
        end
      end
      object edtDecHP: TSpinEdit
        Left = 111
        Top = 228
        Width = 50
        Height = 21
        Hint = #31227#21160#20943#34880#34880#37327':'#40664#35748#20540#20026'1,'#22635#20889'0'#26102#20026#19981#25481'HP'
        MaxValue = 9999
        MinValue = 1
        TabOrder = 2
        Value = 1
        OnChange = EditCastleNameChange
      end
      object edtDecHPTime: TSpinEdit
        Left = 289
        Top = 228
        Width = 50
        Height = 21
        Hint = #31227#21160#20943#34880#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
        MaxValue = 9999
        MinValue = 10
        TabOrder = 3
        Value = 300
        OnChange = EditCastleNameChange
      end
      object grp2: TGroupBox
        Left = 132
        Top = 0
        Width = 121
        Height = 105
        Caption = #24674#22797#20154#29289#27861#24072'HP/MP'
        TabOrder = 4
        object lbl2: TLabel
          Left = 10
          Top = 16
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          Caption = #34880#37327#22522#25968':'
        end
        object lbl4: TLabel
          Left = 10
          Top = 38
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          Caption = #34880#37327#38388#38548':'
        end
        object lbl6: TLabel
          Left = 10
          Top = 61
          Width = 54
          Height = 12
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          Caption = #39764#27861#22522#25968':'
        end
        object lbl8: TLabel
          Left = 10
          Top = 83
          Width = 90
          Height = 12
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          AutoSize = False
          Caption = #39764#27861#38388#38548':'
        end
        object edtIncHP_HUMAN_WIZARD: TSpinEdit
          Left = 65
          Top = 12
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 0
          Value = 75
          OnChange = EditCastleNameChange
        end
        object edtIncHPTime_HUMAN_WIZARD: TSpinEdit
          Left = 65
          Top = 34
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 1
          Value = 300
          OnChange = EditCastleNameChange
        end
        object edtIncMP_HUMAN_WIZARD: TSpinEdit
          Left = 65
          Top = 59
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 2
          Value = 18
          OnChange = EditCastleNameChange
        end
        object edtIncMPTime_HUMAN_WIZARD: TSpinEdit
          Left = 65
          Top = 81
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 3
          Value = 800
          OnChange = EditCastleNameChange
        end
      end
      object grp3: TGroupBox
        Left = 260
        Top = 0
        Width = 121
        Height = 105
        Caption = #24674#22797#20154#29289#36947#22763'HP/MP'
        TabOrder = 5
        object lbl10: TLabel
          Left = 10
          Top = 16
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          Caption = #34880#37327#22522#25968':'
        end
        object lbl11: TLabel
          Left = 10
          Top = 38
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          Caption = #34880#37327#38388#38548':'
        end
        object lbl13: TLabel
          Left = 10
          Top = 61
          Width = 54
          Height = 12
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          Caption = #39764#27861#22522#25968':'
        end
        object lbl14: TLabel
          Left = 10
          Top = 83
          Width = 90
          Height = 12
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          AutoSize = False
          Caption = #39764#27861#38388#38548':'
        end
        object edtIncHP_HUMAN_TAOIST: TSpinEdit
          Left = 65
          Top = 12
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 0
          Value = 75
          OnChange = EditCastleNameChange
        end
        object edtIncHPTime_HUMAN_TAOIST: TSpinEdit
          Left = 65
          Top = 34
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 1
          Value = 300
          OnChange = EditCastleNameChange
        end
        object edtIncMP_HUMAN_TAOIST: TSpinEdit
          Left = 65
          Top = 59
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 2
          Value = 18
          OnChange = EditCastleNameChange
        end
        object edtIncMPTime_HUMAN_TAOIST: TSpinEdit
          Left = 65
          Top = 81
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 3
          Value = 800
          OnChange = EditCastleNameChange
        end
      end
      object grp4: TGroupBox
        Left = 388
        Top = 0
        Width = 121
        Height = 105
        Caption = #24674#22797#33521#38596#25112#22763'HP/MP'
        TabOrder = 6
        object lbl15: TLabel
          Left = 10
          Top = 16
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          Caption = #34880#37327#22522#25968':'
        end
        object lbl16: TLabel
          Left = 10
          Top = 38
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          Caption = #34880#37327#38388#38548':'
        end
        object lbl17: TLabel
          Left = 10
          Top = 61
          Width = 54
          Height = 12
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          Caption = #39764#27861#22522#25968':'
        end
        object lbl18: TLabel
          Left = 10
          Top = 83
          Width = 90
          Height = 12
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          AutoSize = False
          Caption = #39764#27861#38388#38548':'
        end
        object edtIncHP_HERO_WARRIOR: TSpinEdit
          Left = 65
          Top = 12
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 0
          Value = 75
          OnChange = EditCastleNameChange
        end
        object edtIncHPTime_HERO_WARRIOR: TSpinEdit
          Left = 65
          Top = 34
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 1
          Value = 300
          OnChange = EditCastleNameChange
        end
        object edtIncMP_HERO_WARRIOR: TSpinEdit
          Left = 65
          Top = 59
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 2
          Value = 18
          OnChange = EditCastleNameChange
        end
        object edtIncMPTime_HERO_WARRIOR: TSpinEdit
          Left = 65
          Top = 81
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 3
          Value = 800
          OnChange = EditCastleNameChange
        end
      end
      object grp5: TGroupBox
        Left = 4
        Top = 109
        Width = 121
        Height = 105
        Caption = #24674#22797#33521#38596#27861#24072'HP/MP'
        TabOrder = 7
        object lbl19: TLabel
          Left = 10
          Top = 16
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          Caption = #34880#37327#22522#25968':'
        end
        object lbl20: TLabel
          Left = 10
          Top = 38
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          Caption = #34880#37327#38388#38548':'
        end
        object lbl21: TLabel
          Left = 10
          Top = 61
          Width = 54
          Height = 12
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          Caption = #39764#27861#22522#25968':'
        end
        object lbl22: TLabel
          Left = 10
          Top = 83
          Width = 90
          Height = 12
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          AutoSize = False
          Caption = #39764#27861#38388#38548':'
        end
        object edtIncHP_HERO_WIZARD: TSpinEdit
          Left = 65
          Top = 12
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 0
          Value = 75
          OnChange = EditCastleNameChange
        end
        object edtIncHPTime_HERO_WIZARD: TSpinEdit
          Left = 65
          Top = 34
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 1
          Value = 300
          OnChange = EditCastleNameChange
        end
        object edtIncMP_HERO_WIZARD: TSpinEdit
          Left = 65
          Top = 59
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 2
          Value = 18
          OnChange = EditCastleNameChange
        end
        object edtIncMPTime_HERO_WIZARD: TSpinEdit
          Left = 65
          Top = 81
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 3
          Value = 800
          OnChange = EditCastleNameChange
        end
      end
      object grp6: TGroupBox
        Left = 132
        Top = 109
        Width = 121
        Height = 105
        Caption = #24674#22797#33521#38596#36947#22763'HP/MP'
        TabOrder = 8
        object lbl23: TLabel
          Left = 10
          Top = 16
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          Caption = #34880#37327#22522#25968':'
        end
        object lbl24: TLabel
          Left = 10
          Top = 38
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          Caption = #34880#37327#38388#38548':'
        end
        object lbl25: TLabel
          Left = 10
          Top = 61
          Width = 54
          Height = 12
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          Caption = #39764#27861#22522#25968':'
        end
        object lbl26: TLabel
          Left = 10
          Top = 83
          Width = 90
          Height = 12
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          AutoSize = False
          Caption = #39764#27861#38388#38548':'
        end
        object edtIncHP_HERO_TAOIST: TSpinEdit
          Left = 65
          Top = 12
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 0
          Value = 75
          OnChange = EditCastleNameChange
        end
        object edtIncHPTime_HERO_TAOIST: TSpinEdit
          Left = 65
          Top = 34
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 1
          Value = 300
          OnChange = EditCastleNameChange
        end
        object edtIncMP_HERO_TAOIST: TSpinEdit
          Left = 65
          Top = 59
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 2
          Value = 18
          OnChange = EditCastleNameChange
        end
        object edtIncMPTime_HERO_TAOIST: TSpinEdit
          Left = 65
          Top = 81
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 3
          Value = 800
          OnChange = EditCastleNameChange
        end
      end
      object grp7: TGroupBox
        Left = 260
        Top = 109
        Width = 121
        Height = 105
        Caption = #24674#22797#24618#29289'HP/MP'
        TabOrder = 9
        object lbl27: TLabel
          Left = 10
          Top = 16
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          Caption = #34880#37327#22522#25968':'
        end
        object lbl28: TLabel
          Left = 10
          Top = 38
          Width = 54
          Height = 12
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          Caption = #34880#37327#38388#38548':'
        end
        object lbl29: TLabel
          Left = 10
          Top = 61
          Width = 54
          Height = 12
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          Caption = #39764#27861#22522#25968':'
        end
        object lbl30: TLabel
          Left = 10
          Top = 83
          Width = 90
          Height = 12
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          AutoSize = False
          Caption = #39764#27861#38388#38548':'
        end
        object edtIncHP_MON: TSpinEdit
          Left = 65
          Top = 12
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#22522#25968':'#40664#35748#20540#20026'75'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'HP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 0
          Value = 75
          OnChange = EditCastleNameChange
        end
        object edtIncHPTime_MON: TSpinEdit
          Left = 65
          Top = 34
          Width = 50
          Height = 21
          Hint = #24674#22797#34880#37327#38388#38548':'#40664#35748#20540#20026'300,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 1
          Value = 300
          OnChange = EditCastleNameChange
        end
        object edtIncMP_MON: TSpinEdit
          Left = 65
          Top = 59
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#22522#25968':'#40664#35748#20540#20026'18'#65292#22635#20889#20540#33539#22260'>0'#30340#27491#25972#25968#13#10#35745#31639#20844#24335#20026':'#24403#21069#20154#29289#26368#22823'MP/'#22635#20889#20540'+1'
          MaxValue = 9999
          MinValue = 1
          TabOrder = 2
          Value = 18
          OnChange = EditCastleNameChange
        end
        object edtIncMPTime_MON: TSpinEdit
          Left = 65
          Top = 81
          Width = 50
          Height = 21
          Hint = #24674#22797#39764#27861#38388#38548':'#40664#35748#20540#20026'800,'#22635#20889#33539#22260#20026#22823#20110'10'#30340#27491#25972#25968','#25968#20540#36234#22823#38388#38548#26102#38388#36234#38271
          MaxValue = 9999
          MinValue = 10
          TabOrder = 3
          Value = 800
          OnChange = EditCastleNameChange
        end
      end
    end
  end
end
