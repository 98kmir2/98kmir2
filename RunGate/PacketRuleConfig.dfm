object frmPacketRule: TfrmPacketRule
  Left = 1049
  Top = 281
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #23433#20840#36807#28388#35774#32622
  ClientHeight = 381
  ClientWidth = 644
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label11: TLabel
    Left = 253
    Top = 32
    Width = 108
    Height = 12
    Caption = #35013#22791#21152#36895#24230#36739#27491#22240#25968
  end
  object Label13: TLabel
    Left = 13
    Top = 349
    Width = 384
    Height = 12
    Caption = #27880#24847#65306#20197#19978#21442#25968#35843#33410#21518#23558#31435#21363#29983#25928#65281#40736#26631#31227#21160#21040#25511#20214#19978#65292#21487#20197#26597#30475#25552#31034#12290
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object pcProcessPack: TPageControl
    Left = 0
    Top = 0
    Width = 644
    Height = 337
    ActivePage = TabSheet1
    Align = alTop
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = ' '#36895#24230#25511#21046' '
      object Label19: TLabel
        Left = 435
        Top = 38
        Width = 108
        Height = 12
        Caption = #23545#21152#36895#23553#21253#22788#29702#26041#24335
      end
      object Label21: TLabel
        Left = 435
        Top = 16
        Width = 144
        Height = 12
        Caption = #26368#22823#35013#22791#21152#36895'        '#22240#25968
      end
      object cbAttackInterval: TCheckBox
        Tag = 101
        Left = 8
        Top = 33
        Width = 87
        Height = 17
        Caption = #25915#20987#38388#38548#26102#38388
        TabOrder = 0
        OnClick = cbMoveIntervalClick
      end
      object cbButchInterval: TCheckBox
        Tag = 103
        Left = 8
        Top = 80
        Width = 87
        Height = 17
        Caption = #25366#32905#38388#38548#26102#38388
        TabOrder = 1
        OnClick = cbMoveIntervalClick
      end
      object cbMoveInterval: TCheckBox
        Tag = 100
        Left = 8
        Top = 8
        Width = 87
        Height = 17
        Caption = #31227#21160#38388#38548#26102#38388
        TabOrder = 2
        OnClick = cbMoveIntervalClick
      end
      object cbSitDownInterval: TCheckBox
        Tag = 104
        Left = 8
        Top = 104
        Width = 87
        Height = 17
        Caption = #36466#19979#38388#38548#26102#38388
        TabOrder = 3
        OnClick = cbMoveIntervalClick
      end
      object cbSpellInterval: TCheckBox
        Tag = 105
        Left = 8
        Top = 128
        Width = 121
        Height = 17
        Caption = #39764#27861#38388#38548#35774#32622#21015#34920':'
        TabOrder = 4
        OnClick = cbMoveIntervalClick
      end
      object cbTurnInterval: TCheckBox
        Tag = 102
        Left = 8
        Top = 56
        Width = 87
        Height = 17
        Caption = #36716#36523#38388#38548#26102#38388
        TabOrder = 5
        OnClick = cbMoveIntervalClick
      end
      object cbEat: TCheckBox
        Tag = 107
        Left = 435
        Top = 61
        Width = 119
        Height = 17
        Caption = #21507#33647#21697#30340#26102#38388#38388#38548
        TabOrder = 6
        OnClick = cbMoveIntervalClick
      end
      object cbPickUp: TCheckBox
        Tag = 108
        Left = 435
        Top = 84
        Width = 119
        Height = 17
        Caption = #25342#21462#29289#21697#26102#38388#38388#38548
        TabOrder = 7
        OnClick = cbMoveIntervalClick
      end
      object cbSpeedHackWarning: TCheckBox
        Tag = 106
        Left = 9
        Top = 176
        Width = 72
        Height = 17
        Caption = #21152#36895#26041#24335':'
        TabOrder = 8
        OnClick = cbMoveIntervalClick
      end
      object cbxMagicList: TComboBox
        Tag = 200
        Left = 8
        Top = 150
        Width = 87
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        TabOrder = 9
        OnChange = cbxMagicListChange
      end
      object cbxSpeedHackWarningMethod: TComboBox
        Tag = 201
        Left = 84
        Top = 175
        Width = 66
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        OnChange = cbxMagicListChange
        Items.Strings = (
          #23494#20154
          #24377#31383)
      end
      object cbxSpeedHackPunishMethod: TComboBox
        Tag = 202
        Left = 551
        Top = 35
        Width = 79
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        OnChange = cbxMagicListChange
        Items.Strings = (
          #36716#25442#23553#21253
          #20002#25481#23553#21253
          #23553#21253#26080#25928
          #20572#39039#22788#29702)
      end
      object etSpeedHackSendBackMsg: TEdit
        Left = 164
        Top = 175
        Width = 466
        Height = 20
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        MaxLength = 255
        ParentFont = False
        TabOrder = 12
        Text = '['#25552#31034']:'#35831#29233#25252#28216#25103#29615#22659#65292#20851#38381#21152#36895#22806#25346#37325#26032#30331#38470
        OnChange = etSpeedHackSendBackMsgChange
      end
      object GroupBox3: TGroupBox
        Left = 9
        Top = 203
        Width = 621
        Height = 101
        TabOrder = 13
        object Label28: TLabel
          Left = 7
          Top = 19
          Width = 48
          Height = 12
          Caption = #25915#20987#36895#24230
        end
        object Label29: TLabel
          Left = 7
          Top = 45
          Width = 48
          Height = 12
          Caption = #39764#27861#36895#24230
        end
        object Label30: TLabel
          Left = 7
          Top = 72
          Width = 48
          Height = 12
          Caption = #31227#21160#36895#24230
        end
        object Label31: TLabel
          Left = 522
          Top = 19
          Width = 6
          Height = 12
          Caption = '0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label32: TLabel
          Left = 522
          Top = 45
          Width = 6
          Height = 12
          Caption = '0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label33: TLabel
          Left = 522
          Top = 72
          Width = 6
          Height = 12
          Caption = '0'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object TrackBarMoveSpd: TTrackBar
          Tag = 2
          Left = 57
          Top = 67
          Width = 448
          Height = 27
          Max = 68
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = TrackBarAttackSpdChange
        end
        object TrackBarAttackSpd: TTrackBar
          Left = 57
          Top = 13
          Width = 448
          Height = 27
          Max = 68
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnChange = TrackBarAttackSpdChange
        end
        object TrackBarSpellSpd: TTrackBar
          Tag = 1
          Left = 57
          Top = 40
          Width = 448
          Height = 27
          Max = 68
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnChange = TrackBarAttackSpdChange
        end
      end
      object GroupBox5: TGroupBox
        Left = 164
        Top = 0
        Width = 251
        Height = 169
        Caption = #32452#21512#36895#24230#25511#21046#34917#20607
        TabOrder = 14
        object Label2: TLabel
          Left = 8
          Top = 18
          Width = 60
          Height = 12
          Caption = #31227#21160#21518#25915#20987
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 9
          Top = 68
          Width = 60
          Height = 12
          Caption = #25915#20987#21518#31227#21160
        end
        object Label3: TLabel
          Left = 8
          Top = 118
          Width = 60
          Height = 12
          Caption = #39764#27861#21518#31227#21160
        end
        object Label6: TLabel
          Left = 11
          Top = 230
          Width = 132
          Height = 12
          Caption = #27491#24120#31227#21160#30340#24674#22797#35745#26102#38388#38548
          Enabled = False
        end
        object Label5: TLabel
          Left = 11
          Top = 254
          Width = 132
          Height = 12
          Caption = #27491#24120#25915#20987#30340#24674#22797#35745#26102#38388#38548
          Enabled = False
        end
        object Label4: TLabel
          Left = 11
          Top = 278
          Width = 132
          Height = 12
          Caption = #27491#24120#39764#27861#30340#24674#22797#35745#26102#38388#38548
          Enabled = False
        end
        object Label7: TLabel
          Left = 129
          Top = 18
          Width = 48
          Height = 12
          Caption = #24809#32602#22522#25968
        end
        object Label27: TLabel
          Left = 129
          Top = 43
          Width = 48
          Height = 12
          Caption = #24809#32602#20493#25968
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label34: TLabel
          Left = 8
          Top = 43
          Width = 60
          Height = 12
          Caption = #31227#21160#21518#39764#27861
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label40: TLabel
          Left = 9
          Top = 93
          Width = 60
          Height = 12
          Caption = #25915#20987#21518#39764#27861
        end
        object Label41: TLabel
          Left = 8
          Top = 143
          Width = 60
          Height = 12
          Caption = #39764#27861#21518#25915#20987
        end
        object Label42: TLabel
          Left = 129
          Top = 81
          Width = 12
          Height = 12
          Caption = '->'
        end
        object speSpellNextMoveCompensate: TSpinEdit
          Tag = 11
          Left = 74
          Top = 113
          Width = 49
          Height = 21
          Hint = #39764#27861#21518#23545#31227#21160#65292#25915#20987#31561#20854#20182#21160#20316#30340#34917#20607#26102#38388#65292#25968#20540#36234#23567#65292#23553#21152#36895#36234#20005#21385#65292#40664#35748'200'#12290
          MaxValue = 9999
          MinValue = -999
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Value = 600
          OnChange = speAttackIntervalChange
        end
        object speAttackNextMoveCompensate: TSpinEdit
          Tag = 10
          Left = 74
          Top = 63
          Width = 49
          Height = 21
          Hint = #25915#20987#21518#23545#31227#21160#65292#39764#27861#31561#20854#20182#21160#20316#30340#34917#20607#26102#38388#65292#25968#20540#36234#23567#65292#23553#21152#36895#36234#20005#21385#65292#40664#35748'200'#12290
          MaxValue = 9999
          MinValue = -999
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Value = 600
          OnChange = speAttackIntervalChange
        end
        object speMoveNextAttackCompensate: TSpinEdit
          Tag = 8
          Left = 74
          Top = 13
          Width = 49
          Height = 21
          Hint = #31227#21160#21518#23545#25915#20987#21160#20316#30340#34917#20607#26102#38388#65292#25968#20540#36234#23567#65292#23553#21152#36895#36234#20005#21385#65292#40664#35748'280'#12290
          MaxValue = 9999
          MinValue = -999
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Value = 320
          OnChange = speAttackIntervalChange
        end
        object spePunishBaseInterval: TSpinEdit
          Tag = 12
          Left = 195
          Top = 15
          Width = 49
          Height = 21
          Hint = #23545#21152#36895#24809#32602#30340#22522#25968#65292#25968#25454#36234#22823#65292#23553#21152#36895#36234#20005#21385#65292#40664#35748'0'#65292#24314#35758#35843#33410#21040'20~120'#12290
          MaxValue = 45000
          MinValue = 0
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Value = 600
          OnChange = speAttackIntervalChange
        end
        object spePunishIntervalRate: TMaskEdit
          Left = 195
          Top = 40
          Width = 49
          Height = 20
          Hint = #23545#36229#36895#24809#32602#30340#20493#25968#65292#25968#20540#36234#22823#65292#23553#21152#36895#36234#20005#21385#65292#40664#35748'1.00'#12290#13#36229#36895#36234#22810#65292#28216#25103#36234#21345#12290#12290#12290
          EditMask = '!9.99;1;_'
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          MaxLength = 4
          TabOrder = 4
          Text = ' .  '
          OnChange = spePunishIntervalRateChange
        end
        object speMoveNextSpellCompensate: TSpinEdit
          Tag = 9
          Left = 74
          Top = 38
          Width = 49
          Height = 21
          Hint = #31227#21160#21518#23545#39764#27861#21160#20316#30340#34917#20607#26102#38388#65292#25968#20540#36234#23567#65292#23553#21152#36895#36234#20005#21385#65292#40664#35748'80'#12290
          MaxValue = 9999
          MinValue = -999
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          Value = 320
          OnChange = speAttackIntervalChange
        end
        object speAttackNextSpellCompensate: TSpinEdit
          Tag = 18
          Left = 74
          Top = 88
          Width = 49
          Height = 21
          Hint = #25915#20987#21518#23545#31227#21160#65292#39764#27861#31561#20854#20182#21160#20316#30340#34917#20607#26102#38388#65292#25968#20540#36234#23567#65292#23553#21152#36895#36234#20005#21385#65292#40664#35748'200'#12290
          MaxValue = 9999
          MinValue = -999
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          Value = 600
          OnChange = speAttackIntervalChange
        end
        object speSpellNextAttackCompensate: TSpinEdit
          Tag = 19
          Left = 74
          Top = 138
          Width = 49
          Height = 21
          Hint = #39764#27861#21518#23545#31227#21160#65292#25915#20987#31561#20854#20182#21160#20316#30340#34917#20607#26102#38388#65292#25968#20540#36234#23567#65292#23553#21152#36895#36234#20005#21385#65292#40664#35748'200'#12290
          MaxValue = 9999
          MinValue = -999
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          Value = 600
          OnChange = speAttackIntervalChange
        end
        object cbItemSpeedCompensate: TCheckBox
          Tag = 114
          Left = 147
          Top = 78
          Width = 93
          Height = 17
          Caption = #32771#34385#35013#22791#36895#24230
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnClick = cbMoveIntervalClick
        end
      end
      object cbKickUserOverPackCnt: TCheckBox
        Tag = 109
        Left = 435
        Top = 107
        Width = 164
        Height = 17
        Hint = #36890#24120#26159#27604#36739#24555#30340#21152#36895#25165#20250#35302#21457#27492#26816#27979#65292#34429#28982#21152#36895#24182#27809#26377#20160#20040#23454#38469#25928#26524#12290
        Caption = #36386#38500#36229#37327#21160#20316#23553#21253#30340#29609#23478
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 15
        OnClick = cbMoveIntervalClick
      end
      object speAttackInterval: TSpinEdit
        Tag = 1
        Left = 101
        Top = 30
        Width = 49
        Height = 21
        MaxValue = 45000
        MinValue = 100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object speButchInterval: TSpinEdit
        Tag = 3
        Left = 101
        Top = 78
        Width = 49
        Height = 21
        MaxValue = 45000
        MinValue = 100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 17
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object speSpellInterval: TSpinEdit
        Tag = 5
        Left = 101
        Top = 149
        Width = 49
        Height = 21
        MaxValue = 45000
        MinValue = 100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object speMoveInterval: TSpinEdit
        Left = 101
        Top = 6
        Width = 49
        Height = 21
        MaxValue = 45000
        MinValue = 100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 19
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object speSitDownInterval: TSpinEdit
        Tag = 4
        Left = 101
        Top = 102
        Width = 49
        Height = 21
        MaxValue = 45000
        MinValue = 100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 20
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object speTurnInterval: TSpinEdit
        Tag = 2
        Left = 101
        Top = 54
        Width = 49
        Height = 21
        MaxValue = 45000
        MinValue = 100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 21
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object speEatItemInvTime: TSpinEdit
        Tag = 13
        Left = 560
        Top = 59
        Width = 70
        Height = 21
        MaxValue = 45000
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 22
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object speItemSpeedRate: TSpinEdit
        Tag = 7
        Left = 585
        Top = 11
        Width = 45
        Height = 21
        Hint = #29609#23478#21152#36895#24230#35013#22791#22240#25968#65292#25968#20540#36234#23567#65292#23553#21152#36895#36234#20005#21385#65292#40664#35748'60'#12290
        EditorEnabled = False
        MaxValue = 100
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 23
        Value = 100
        OnChange = speAttackIntervalChange
      end
      object spePickUpItemInvTime: TSpinEdit
        Tag = 14
        Left = 560
        Top = 83
        Width = 70
        Height = 21
        MaxValue = 45000
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 24
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object speMaxItemSpeed: TSpinEdit
        Tag = 6
        Left = 511
        Top = 11
        Width = 40
        Height = 21
        Hint = #26368#39640#30340#20154#29289#36523#19978#25152#26377#35013#22791'+'#36895#24230#65292#40664#35748'6'#12290
        EditorEnabled = False
        MaxValue = 255
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 25
        Value = 100
        OnChange = speAttackIntervalChange
      end
      object cbSyncSpeedRate: TCheckBox
        Tag = 111
        Left = 470
        Top = 196
        Width = 148
        Height = 17
        Caption = #21516#27493#35843#33410#21160#20316#30340#26102#38388#38388#38548
        Checked = True
        State = cbChecked
        TabOrder = 26
        OnClick = cbMoveIntervalClick
      end
      object cbOpenClientSpeedRate: TCheckBox
        Tag = 110
        Left = 16
        Top = 196
        Width = 79
        Height = 17
        Caption = #23458#25143#31471#36895#24230
        Checked = True
        State = cbChecked
        TabOrder = 27
        OnClick = cbMoveIntervalClick
      end
      object cbCheckDoMotaebo: TCheckBox
        Tag = 112
        Left = 435
        Top = 130
        Width = 77
        Height = 17
        Caption = #23553#36229#32423#37326#34542
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 28
        OnClick = cbMoveIntervalClick
      end
      object cbDenyPresend: TCheckBox
        Tag = 113
        Left = 529
        Top = 130
        Width = 87
        Height = 17
        Caption = #31105#27490#21830#22478#36192#36865
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 29
        OnClick = cbMoveIntervalClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = ' '#36830#25509#21015#34920' '
      ImageIndex = 1
      object Label9: TLabel
        Left = 8
        Top = 5
        Width = 78
        Height = 12
        Caption = #24403#21069#22312#32447#29609#23478':'
      end
      object LabelTempList: TLabel
        Left = 208
        Top = 4
        Width = 66
        Height = 12
        Caption = #21160#24577#36807#28388'IP:'
      end
      object Label10: TLabel
        Left = 349
        Top = 4
        Width = 66
        Height = 12
        Caption = #27704#20037#36807#28388'IP:'
      end
      object Label15: TLabel
        Left = 487
        Top = 24
        Width = 96
        Height = 12
        Caption = #31227#21160#38480#36895#24809#32602#22522#25968
      end
      object Label24: TLabel
        Left = 487
        Top = 48
        Width = 96
        Height = 12
        Caption = #25915#20987#38480#36895#24809#32602#22522#25968
      end
      object Label26: TLabel
        Left = 487
        Top = 72
        Width = 96
        Height = 12
        Caption = #39764#27861#38480#36895#24809#32602#22522#25968
      end
      object Label8: TLabel
        Left = 487
        Top = 96
        Width = 138
        Height = 12
        Caption = #38480#36895#29609#23478#21015#34920'('#21491#38190#32534#36753'):'
      end
      object Label23: TLabel
        Left = 208
        Top = 191
        Width = 180
        Height = 12
        Caption = 'IP'#27573#36807#28388','#26684#24335':'#23567'-'#22823' ('#21491#38190#32534#36753')'
      end
      object ListBoxActiveList: TListBox
        Left = 6
        Top = 21
        Width = 194
        Height = 283
        Hint = #24403#21069#36830#25509#30340'IP'#22320#22336#21015#34920
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        Items.Strings = (
          '888.888.888.888')
        ParentShowHint = False
        PopupMenu = ActiveListPopupMenu
        ShowHint = True
        Sorted = True
        TabOrder = 0
      end
      object ListBoxTempList: TListBox
        Left = 206
        Top = 20
        Width = 134
        Height = 165
        Hint = #21160#24577#36807#28388#21015#34920#65292#22312#27492#21015#34920#20013#30340'IP'#23558#26080#27861#24314#31435#36830#25509#65292#20294#22312#31243#24207#37325#26032#21551#21160#26102#27492#21015#34920#30340#20449#24687#23558#34987#28165#31354
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        Items.Strings = (
          '888.888.888.888')
        ParentShowHint = False
        PopupMenu = TempBlockListPopupMenu
        ShowHint = True
        Sorted = True
        TabOrder = 1
      end
      object ListBoxBlockList: TListBox
        Left = 346
        Top = 20
        Width = 134
        Height = 165
        Hint = #27704#20037#36807#28388#21015#34920#65292#22312#27492#21015#34920#20013#30340'IP'#23558#26080#27861#24314#31435#36830#25509#65292#27492#21015#34920#23558#20445#23384#20110#37197#32622#25991#20214#20013#65292#22312#31243#24207#37325#26032#21551#21160#26102#20250#37325#26032#21152#36733#27492#21015#34920
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        Items.Strings = (
          '888.888.888.888')
        ParentShowHint = False
        PopupMenu = BlockListPopupMenu
        ShowHint = True
        Sorted = True
        TabOrder = 2
      end
      object spePunishMoveInterval: TSpinEdit
        Tag = 15
        Left = 586
        Top = 21
        Width = 46
        Height = 21
        MaxValue = 45000
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object spePunishAttackInterval: TSpinEdit
        Tag = 16
        Left = 586
        Top = 45
        Width = 46
        Height = 21
        MaxValue = 45000
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object spePunishSpellInterval: TSpinEdit
        Tag = 17
        Left = 586
        Top = 69
        Width = 46
        Height = 21
        MaxValue = 45000
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object ListBoxSpeedLimitList: TListBox
        Left = 487
        Top = 114
        Width = 145
        Height = 189
        Hint = #38480#21046#28216#25103#36895#24230#30340#29609#23478#21517#31216#21015#34920#65292#32467#21512#19978#38754'3'#20010#24809#32602#22522#25968#36827#34892#35843#33410#12290
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        ParentShowHint = False
        PopupMenu = PopupMenuSpeedLimit
        ShowHint = True
        TabOrder = 6
      end
      object ListBoxIPAreaFilter: TListBox
        Left = 206
        Top = 209
        Width = 274
        Height = 95
        Hint = 'IP'#27573#36807#28388#21015#34920#65292#22320#22336#30001#23567#21040#22823#65292#26684#24335#22914#65306'127.0.0.1-128.0.0.1'
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        ParentShowHint = False
        PopupMenu = PopupMenu_IPAreaFilter
        ShowHint = True
        TabOrder = 7
        OnDblClick = ListBoxIPAreaFilterDblClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = ' '#36830#25509#25511#21046' '
      ImageIndex = 2
      object GroupBoxNullConnect: TGroupBox
        Left = 8
        Top = 113
        Width = 169
        Height = 177
        Caption = #27969#37327#25511#21046
        TabOrder = 0
        object Label16: TLabel
          Left = 8
          Top = 47
          Width = 54
          Height = 12
          Caption = #26368#22823#38480#21046':'
        end
        object Label17: TLabel
          Left = 8
          Top = 71
          Width = 54
          Height = 12
          Caption = #25968#37327#38480#21046':'
        end
        object Label18: TLabel
          Left = 8
          Top = 23
          Width = 54
          Height = 12
          Caption = #20020#30028#22823#23567':'
        end
        object etMaxClientPacketSize: TSpinEdit
          Tag = 23
          Left = 68
          Top = 44
          Width = 69
          Height = 21
          Hint = 
            #25509#25910#21040#30340#25968#25454#20449#24687#26368#22823#38480#21046#65292#22914#26524#36229#36807#27492#22823#23567#65292#13#21017#34987#35270#20026#25915#20987#12290#27492#25968#20540#29992#20110#36807#28388#34892#20250#32534#36753#25968#25454#65292#13#19968#33324#24773#20917#19979#19981#20250#36229#36807'8000'#65292#40664#35748#20026'102' +
            '40'#21363#21487#12290
          EditorEnabled = False
          Increment = 100
          MaxValue = 20000
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Value = 6000
          OnChange = speAttackIntervalChange
        end
        object etMaxClientMsgCount: TSpinEdit
          Tag = 24
          Left = 68
          Top = 68
          Width = 69
          Height = 21
          Hint = #19968#27425#25509#25910#21040#25968#25454#20449#24687#30340#25968#37327#22810#23569#65292#36229#36807#25351#23450#25968#37327#23558#34987#35270#20026#25915#20987#65292#21487#20197#29992#20110#23553#25209#37327#36141#20080#12290
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Value = 5
          OnChange = speAttackIntervalChange
        end
        object etNomClientPacketSize: TSpinEdit
          Tag = 22
          Left = 68
          Top = 20
          Width = 69
          Height = 21
          Hint = #25509#25910#21040#30340#25968#25454#20449#24687#20020#30028#22823#23567#65292#22914#26524#36229#36807#27492#22823#23567#65292#13#23558#34987#29305#27530#22788#29702#65292#19968#33324#35774#32622#40664#35748#20540'400'#21363#21487#12290
          Increment = 10
          MaxValue = 2000
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Value = 100
          OnChange = speAttackIntervalChange
        end
        object GroupBox7: TGroupBox
          Left = 8
          Top = 94
          Width = 153
          Height = 74
          Caption = #25915#20987#25805#20316
          TabOrder = 3
          object rdAddBlockList: TRadioButton
            Left = 8
            Top = 51
            Width = 129
            Height = 17
            Hint = #23558#27492#36830#25509#30340'IP'#21152#20837#27704#20037#36807#28388#21015#34920#65292#24182#23558#27492'IP'#30340#25152#26377#36830#25509#24378#34892#20013#26029
            Caption = #21152#20837#27704#20037#36807#28388#21015#34920
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = rdDisConnectClick
          end
          object rdAddTempList: TRadioButton
            Left = 8
            Top = 33
            Width = 129
            Height = 17
            Hint = #23558#27492#36830#25509#30340'IP'#21152#20837#21160#24577#36807#28388#21015#34920#65292#24182#23558#27492'IP'#30340#25152#26377#36830#25509#24378#34892#20013#26029
            Caption = #21152#20837#21160#24577#36807#28388#21015#34920
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = rdDisConnectClick
          end
          object rdDisConnect: TRadioButton
            Left = 8
            Top = 16
            Width = 129
            Height = 17
            Hint = #23558#36830#25509#31616#21333#30340#26029#24320#22788#29702
            Caption = #26029#24320#36830#25509
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = rdDisConnectClick
          end
        end
      end
      object cbKickOverPacketSize: TCheckBox
        Tag = 121
        Left = 16
        Top = 111
        Width = 90
        Height = 17
        Hint = #25171#24320#27492#21151#33021#21518#65292#22914#26524#23458#25143#31471#30340#21457#36865#30340#25968#25454#36229#36807#25351#23450#38480#21046#23558#20250#30452#25509#23558#20854#25481#32447
        BiDiMode = bdLeftToRight
        Caption = #24322#24120#25481#32447#22788#29702
        ParentBiDiMode = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = cbMoveIntervalClick
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 169
        Height = 97
        Caption = '                 '
        TabOrder = 2
        object Label12: TLabel
          Left = 8
          Top = 45
          Width = 150
          Height = 12
          Caption = #36830#25509#38480#21046':         '#36830#25509'/IP'
        end
        object Label14: TLabel
          Left = 8
          Top = 71
          Width = 120
          Height = 12
          Caption = #36830#25509#36229#26102':         '#31186
        end
        object etMaxConnectOfIP: TSpinEdit
          Tag = 20
          Left = 63
          Top = 42
          Width = 49
          Height = 21
          Hint = #21333#20010'IP'#22320#22336#65292#26368#22810#21487#20197#24314#31435#36830#25509#25968#65292#36229#36807#25351#23450#36830#25509#25968#23558#25353#19979#38754#30340#25805#20316#22788#29702
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Value = 50
          OnChange = speAttackIntervalChange
        end
        object etClientTimeOutTime: TSpinEdit
          Tag = 21
          Left = 63
          Top = 68
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 90
          MinValue = 10
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Value = 10
          OnChange = speAttackIntervalChange
        end
        object cbDefenceCC: TCheckBox
          Tag = 122
          Left = 8
          Top = 19
          Width = 105
          Height = 17
          BiDiMode = bdLeftToRight
          Caption = #38450#27490'CC'#25915#20987
          ParentBiDiMode = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = cbMoveIntervalClick
        end
      end
      object cbCheckNullConnect: TCheckBox
        Tag = 120
        Left = 15
        Top = 6
        Width = 103
        Height = 17
        BiDiMode = bdLeftToRight
        Caption = #38450#27490#36229#36830#25509#25915#20987
        ParentBiDiMode = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = cbMoveIntervalClick
      end
      object GroupBox2: TGroupBox
        Left = 187
        Top = 8
        Width = 442
        Height = 282
        Caption = #23458#25143#31471#26426#22120#30721#25511#21046
        TabOrder = 4
        object Label37: TLabel
          Left = 8
          Top = 187
          Width = 42
          Height = 12
          Caption = #40657#21517#21333':'
        end
        object Label38: TLabel
          Left = 92
          Top = 18
          Width = 54
          Height = 12
          Caption = #22810#24320#38480#21046':'
        end
        object Label39: TLabel
          Left = 194
          Top = 17
          Width = 54
          Height = 12
          Caption = #22810#24320#25552#31034':'
        end
        object Label25: TLabel
          Left = 9
          Top = 261
          Width = 54
          Height = 12
          Caption = #34987#23553#25552#31034':'
        end
        object ListViewCurHWIDList: TListView
          Left = 8
          Top = 39
          Width = 425
          Height = 139
          Color = clWhite
          Columns = <
            item
              Caption = #35782#21035#30721
              Width = 250
            end
            item
              Caption = #29992#25143#21517
              Width = 100
            end
            item
              Caption = #36830#25509#25968
              Width = 53
            end>
          ColumnClick = False
          GridLines = True
          MultiSelect = True
          ReadOnly = True
          RowSelect = True
          PopupMenu = PopupMenu_CurHWIDList
          SortType = stText
          TabOrder = 0
          ViewStyle = vsReport
        end
        object ListBoxBlockHWIDList: TListBox
          Left = 8
          Top = 207
          Width = 425
          Height = 45
          Hint = #23458#25143#31471#35782#21035#30721#27573#36807#28388#21015#34920
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ItemHeight = 12
          ParentShowHint = False
          PopupMenu = PopupMenu_BlockHWIDList
          ShowHint = True
          TabOrder = 1
          OnDblClick = ListBoxIPAreaFilterDblClick
        end
        object cbProcClientCount: TCheckBox
          Tag = 123
          Left = 11
          Top = 15
          Width = 63
          Height = 17
          BiDiMode = bdLeftToRight
          Caption = #24320#21551#25511#21046
          ParentBiDiMode = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = cbMoveIntervalClick
        end
        object seMaxClientCount: TSpinEdit
          Tag = 25
          Left = 148
          Top = 13
          Width = 35
          Height = 21
          Hint = #25511#21046#27599#21488#30005#33041#24320#21551#30340#23458#25143#31471#25968#37327
          EditorEnabled = False
          MaxValue = 10000
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Value = 50
          OnChange = speAttackIntervalChange
        end
        object EditHWIDList: TEdit
          Tag = 4
          Left = 52
          Top = 183
          Width = 351
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          MaxLength = 255
          ParentFont = False
          TabOrder = 4
          OnChange = etSpeedHackSendBackMsgChange
        end
        object btnHWIDList: TButton
          Left = 407
          Top = 183
          Width = 26
          Height = 20
          Caption = '...'
          TabOrder = 5
          OnClick = btnHWIDListClick
        end
        object edOverClientCntMsg: TEdit
          Tag = 5
          Left = 251
          Top = 13
          Width = 182
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          MaxLength = 255
          ParentFont = False
          TabOrder = 6
          OnChange = etSpeedHackSendBackMsgChange
        end
        object edHWIDBlockedMsg: TEdit
          Tag = 6
          Left = 66
          Top = 257
          Width = 367
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          MaxLength = 255
          ParentFont = False
          TabOrder = 7
          OnChange = etSpeedHackSendBackMsgChange
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = ' '#35828#35805#25511#21046' '
      ImageIndex = 3
      object Label22: TLabel
        Left = 326
        Top = 206
        Width = 198
        Height = 12
        Caption = #38388#38548'           '#27627#31186#25165#21487#20197#25342#21462#29289#21697
      end
      object Label20: TLabel
        Left = 8
        Top = 8
        Width = 78
        Height = 12
        Caption = #33039#35805#36807#28388#21015#34920':'
      end
      object Bevel: TBevel
        Left = 318
        Top = 50
        Width = 316
        Height = 10
        Shape = bsTopLine
      end
      object Bevel1: TBevel
        Left = 318
        Top = 136
        Width = 316
        Height = 10
        Shape = bsTopLine
      end
      object Bevel2: TBevel
        Left = 318
        Top = 230
        Width = 316
        Height = 10
        Shape = bsTopLine
      end
      object cbChatInterval: TCheckBox
        Tag = 130
        Left = 326
        Top = 24
        Width = 90
        Height = 17
        Caption = #32842#22825#26102#38388#38388#38548
        TabOrder = 0
        OnClick = cbMoveIntervalClick
      end
      object cbChatFilter: TCheckBox
        Tag = 131
        Left = 326
        Top = 84
        Width = 243
        Height = 17
        Caption = #25991#23383#36807#28388#26041#24335'                 '#20195#26367#25991#23383
        TabOrder = 1
        OnClick = cbMoveIntervalClick
      end
      object cbxChatFilterMethod: TComboBox
        Tag = 203
        Left = 420
        Top = 83
        Width = 95
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnChange = cbxMagicListChange
        Items.Strings = (
          #25972#21477#26367#25442
          #26367#25442#28041#21450#25991#23383
          #25481#32447#22788#29702)
      end
      object cbSpaceMoveNextPickupInterval: TCheckBox
        Tag = 132
        Left = 326
        Top = 176
        Width = 189
        Height = 17
        Caption = #20351#29992#20256#36865#21629#20196'          '#20043#21518',  '
        TabOrder = 3
        OnClick = cbMoveIntervalClick
      end
      object cbChatCmdFilter: TCheckBox
        Tag = 133
        Left = 190
        Top = 7
        Width = 105
        Height = 17
        Caption = #36807#28388#21629#20196#21015#34920':'
        TabOrder = 4
        OnClick = cbMoveIntervalClick
      end
      object etCmdMove: TEdit
        Left = 420
        Top = 175
        Width = 53
        Height = 20
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        MaxLength = 255
        ParentFont = False
        TabOrder = 5
        Text = 'move'
        OnChange = etSpeedHackSendBackMsgChange
      end
      object etAbuseReplaceWords: TEdit
        Tag = 1
        Left = 318
        Top = 109
        Width = 243
        Height = 21
        AutoSize = False
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        MaxLength = 255
        TabOrder = 6
        Text = '*'
        OnChange = etSpeedHackSendBackMsgChange
      end
      object ListBoxAbuseFilterText: TListBox
        Left = 8
        Top = 24
        Width = 176
        Height = 280
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        TabOrder = 7
        OnClick = ListBoxAbuseFilterTextClick
        OnDblClick = ListBoxAbuseFilterTextDblClick
      end
      object MemoCmdFilter: TMemo
        Left = 190
        Top = 24
        Width = 122
        Height = 280
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        Lines.Strings = (
          'MemoCmdFilter')
        TabOrder = 8
        OnChange = MemoCmdFilterChange
      end
      object speCltSay: TSpinEdit
        Tag = 30
        Left = 420
        Top = 23
        Width = 53
        Height = 21
        EditorEnabled = False
        Increment = 10
        MaxValue = 45000
        MinValue = 100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object speSpaceMovePickUpInvTime: TSpinEdit
        Tag = 31
        Left = 355
        Top = 203
        Width = 53
        Height = 21
        EditorEnabled = False
        Increment = 10
        MaxValue = 45000
        MinValue = 100
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        Value = 600
        OnChange = speAttackIntervalChange
      end
      object btnAbuseMod: TButton
        Left = 62
        Top = 277
        Width = 44
        Height = 21
        Caption = #20462#25913
        TabOrder = 11
        OnClick = btnAbuseModClick
      end
      object btnAbuseAdd: TButton
        Left = 16
        Top = 277
        Width = 44
        Height = 21
        Caption = #22686#21152
        TabOrder = 12
        OnClick = btnAbuseAddClick
      end
      object btnAbuseDel: TButton
        Left = 108
        Top = 277
        Width = 44
        Height = 21
        Caption = #21024#38500
        TabOrder = 13
        OnClick = btnAbuseDelClick
      end
    end
    object TabSheet5: TTabSheet
      Caption = #20854#20182#35774#32622
      ImageIndex = 4
      object Label35: TLabel
        Left = 9
        Top = 37
        Width = 90
        Height = 12
        Caption = #26816#27979#21040#22806#25346#25552#31034':'
      end
      object Label36: TLabel
        Left = 11
        Top = 83
        Width = 114
        Height = 12
        Caption = #23458#25143#31471#29256#26412#38169#35823#25552#31034':'
      end
      object etPacketDecryptErrMsg: TEdit
        Tag = 2
        Left = 9
        Top = 53
        Width = 432
        Height = 20
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        MaxLength = 255
        ParentFont = False
        TabOrder = 0
        OnChange = etSpeedHackSendBackMsgChange
      end
      object etCDVersionErrMsg: TEdit
        Tag = 3
        Left = 9
        Top = 99
        Width = 432
        Height = 20
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        MaxLength = 255
        ParentFont = False
        TabOrder = 1
        OnChange = etSpeedHackSendBackMsgChange
      end
      object cbClientItemShowMode: TCheckBox
        Tag = 140
        Left = 8
        Top = 8
        Width = 190
        Height = 17
        Caption = #26032#30340#26497#21697#26174#31034#26041#24335'(for V1.76)'
        TabOrder = 2
        OnClick = cbMoveIntervalClick
      end
    end
  end
  object btnSave: TButton
    Left = 460
    Top = 347
    Width = 81
    Height = 26
    Caption = #20445#23384'(&S)'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 547
    Top = 347
    Width = 81
    Height = 26
    Caption = #20851#38381'(&O)'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object ActiveListPopupMenu: TPopupMenu
    OnPopup = ActiveListPopupMenuPopup
    Left = 224
    Top = 344
    object APOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = APOPMENU_REFLISTClick
    end
    object APOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = APOPMENU_SORTClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object APOPMENU_KICK: TMenuItem
      Caption = #36386#38500#19979#32447'(&K)'
      OnClick = APOPMENU_KICKClick
    end
    object APOPMENU_AddToPunishList: TMenuItem
      Caption = #21152#20837#38480#36895#21015#34920'(&P)'
      ImageIndex = 0
      OnClick = APOPMENU_AddToPunishListClick
    end
    object APOPMENU_AddAllToPunishList: TMenuItem
      Caption = #20840#37096#21152#20837#38480#36895#21015#34920'(&G)'
      ImageIndex = 0
      OnClick = APOPMENU_AddAllToPunishListClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object APOPMENU_ADDTEMPLIST: TMenuItem
      Caption = #21152#20837#21160#24577#36807#28388#21015#34920'(&A)'
      OnClick = APOPMENU_ADDTEMPLISTClick
    end
    object APOPMENU_BLOCKLIST: TMenuItem
      Caption = #21152#20837#27704#20037#36807#28388#21015#34920'(&D)'
      OnClick = APOPMENU_BLOCKLISTClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object APOPMENU_AllToTempBLOCKLIST: TMenuItem
      Caption = #20840#37096#21152#20837#21160#24577#36807#28388#21015#34920'(&T)'
      OnClick = APOPMENU_AllToTempBLOCKLISTClick
    end
    object APOPMENU_AllToBLOCKLIST: TMenuItem
      Caption = #20840#37096#21152#20837#27704#20037#36807#28388#21015#34920'(&B)'
      OnClick = APOPMENU_AllToBLOCKLISTClick
    end
    object APOPMENU_AllNullNameToBLOCKLIST: TMenuItem
      Caption = #20840#37096#31354#21517#23383#21152#20837#21160#24577#36807#28388#21015#34920'(&N)'
      OnClick = APOPMENU_AllNullNameToBLOCKLISTClick
    end
  end
  object TempBlockListPopupMenu: TPopupMenu
    OnPopup = TempBlockListPopupMenuPopup
    Left = 256
    Top = 344
    object TPOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = TPOPMENU_REFLISTClick
    end
    object TPOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = TPOPMENU_SORTClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object TPOPMENU_ADD: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = TPOPMENU_ADDClick
    end
    object TPOPMENU_DELETE: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = TPOPMENU_DELETEClick
    end
    object TPOPMENU_DELETE_ALL: TMenuItem
      Caption = #20840#37096#21024#38500'(&C)'
      OnClick = TPOPMENU_DELETE_ALLClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object TPOPMENU_AddtoBLOCKLIST: TMenuItem
      Caption = #21152#20837#27704#20037#36807#28388#21015#34920'(&A)'
      OnClick = TPOPMENU_AddtoBLOCKLISTClick
    end
    object TPOPMENU_ALLTOBLOCKLIST: TMenuItem
      Caption = #20840#37096#21152#20837#27704#20037#36807#28388#21015#34920'(&B)'
      OnClick = TPOPMENU_ALLTOBLOCKLISTClick
    end
  end
  object BlockListPopupMenu: TPopupMenu
    OnPopup = BlockListPopupMenuPopup
    Left = 288
    Top = 344
    object BPOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = BPOPMENU_REFLISTClick
    end
    object BPOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = BPOPMENU_SORTClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object BPOPMENU_ADD: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = BPOPMENU_ADDClick
    end
    object BPOPMENU_DELETE: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = BPOPMENU_DELETEClick
    end
    object BPOPMENU_DELETE_ALL: TMenuItem
      Caption = #20840#37096#21024#38500'(&C)'
      OnClick = BPOPMENU_DELETE_ALLClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object BPOPMENU_ADDTEMPLIST: TMenuItem
      Caption = #21152#20837#21160#24577#36807#28388#21015#34920'(&A)'
      OnClick = BPOPMENU_ADDTEMPLISTClick
    end
    object BPOPMENU_ALLTOTEMPLIST: TMenuItem
      Caption = #20840#37096#21152#20837#21160#24577#36807#28388#21015#34920'(&T)'
      OnClick = BPOPMENU_ALLTOTEMPLISTClick
    end
  end
  object PopupMenuSpeedLimit: TPopupMenu
    OnPopup = PopupMenuSpeedLimitPopup
    Left = 320
    Top = 344
    object MenuItem_SpeedLimitPunish_Renew: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = MenuItem_SpeedLimitPunish_RenewClick
    end
    object MenuItem_SpeedLimitPunish_Add: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = MenuItem_SpeedLimitPunish_AddClick
    end
    object MenuItem_SpeedLimitPunish_Del: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = MenuItem_SpeedLimitPunish_DelClick
    end
    object MenuItem_SpeedLimitPunish_DelAll: TMenuItem
      Caption = #20840#37096#21024#38500'(&C)'
      OnClick = MenuItem_SpeedLimitPunish_DelAllClick
    end
  end
  object PopupMenu_IPAreaFilter: TPopupMenu
    OnPopup = PopupMenu_IPAreaFilterPopup
    Left = 360
    Top = 344
    object MenuItem_IPAreaMod: TMenuItem
      Caption = #20462#25913'(&M)'
      OnClick = MenuItem_IPAreaModClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object MenuItem_IPAreaAdd: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = MenuItem_IPAreaAddClick
    end
    object MenuItem_IPAreaDel: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = MenuItem_IPAreaDelClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object MenuItem_IPAreaDelAll: TMenuItem
      Caption = #20840#37096#21024#38500'(&C)'
      OnClick = MenuItem_IPAreaDelAllClick
    end
  end
  object PopupMenu_BlockHWIDList: TPopupMenu
    OnPopup = PopupMenu_BlockHWIDListPopup
    Left = 424
    Top = 264
    object MenuItem_BlockHWIDList_Add: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = MenuItem_BlockHWIDList_AddClick
    end
    object MenuItem_BlockHWIDList_Del: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = MenuItem_BlockHWIDList_DelClick
    end
    object MenuItem_BlockHWIDList_DelAll: TMenuItem
      Caption = #20840#37096#21024#38500'(&C)'
      OnClick = MenuItem_BlockHWIDList_DelAllClick
    end
  end
  object PopupMenu_CurHWIDList: TPopupMenu
    OnPopup = PopupMenu_CurHWIDListPopup
    Left = 416
    Top = 168
    object MenuItem_CurHWIDList_Flush: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = MenuItem_CurHWIDList_FlushClick
    end
    object MenuItem_CurHWIDList_CopyHWID: TMenuItem
      Caption = #22797#21046#35782#21035#30721'(&D)'
      OnClick = MenuItem_CurHWIDList_CopyHWIDClick
    end
    object MenuItem_CurHWIDList_AddToBlockList: TMenuItem
      Caption = #21152#20837#40657#21517#21333'(&A)'
      OnClick = MenuItem_CurHWIDList_AddToBlockListClick
    end
    object MenuItem_CurHWIDList_AllAddToBlockList: TMenuItem
      Caption = #20840#37096#21152#20837#40657#21517#21333'(&T)'
      OnClick = MenuItem_CurHWIDList_AllAddToBlockListClick
    end
  end
end
