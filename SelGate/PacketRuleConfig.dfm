object frmPacketRule: TfrmPacketRule
  Left = 514
  Top = 399
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #23433#20840#36807#28388#35774#32622
  ClientHeight = 358
  ClientWidth = 612
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
    Left = 29
    Top = 330
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
    Width = 612
    Height = 313
    ActivePage = TabSheet3
    Align = alTop
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = ' '#36830#25509#21015#34920
      ImageIndex = 1
      object Label9: TLabel
        Left = 10
        Top = 4
        Width = 54
        Height = 12
        Caption = #24403#21069#22312#32447':'
      end
      object LabelTempList: TLabel
        Left = 150
        Top = 5
        Width = 66
        Height = 12
        Caption = #21160#24577#36807#28388'IP:'
      end
      object Label10: TLabel
        Left = 291
        Top = 5
        Width = 66
        Height = 12
        Caption = #27704#20037#36807#28388'IP:'
      end
      object Label23: TLabel
        Left = 150
        Top = 192
        Width = 114
        Height = 12
        Caption = 'IP'#27573#36807#28388' ('#21491#38190#32534#36753')'
      end
      object ListBoxActiveList: TListBox
        Left = 8
        Top = 21
        Width = 134
        Height = 260
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
        Left = 148
        Top = 21
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
        Left = 288
        Top = 21
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
      object ListBoxIPAreaFilter: TListBox
        Left = 148
        Top = 210
        Width = 274
        Height = 71
        Hint = 'IP'#27573#36807#28388#21015#34920#65292#22320#22336#30001#23567#21040#22823#65292#26684#24335#22914#65306'127.0.0.1-128.0.0.1'
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        ParentShowHint = False
        PopupMenu = PopupMenu_IPAreaFilter
        ShowHint = True
        TabOrder = 3
        OnDblClick = ListBoxIPAreaFilterDblClick
      end
      object GroupBox1: TGroupBox
        Left = 428
        Top = 21
        Width = 169
        Height = 97
        Caption = '                 '
        TabOrder = 4
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
          OnChange = etMaxConnectOfIPChange
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
          OnChange = etMaxConnectOfIPChange
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
        end
      end
      object cbCheckNullConnect: TCheckBox
        Tag = 120
        Left = 435
        Top = 19
        Width = 103
        Height = 17
        BiDiMode = bdLeftToRight
        Caption = #38450#27490#36229#36830#25509#25915#20987
        ParentBiDiMode = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object GroupBoxNullConnect: TGroupBox
        Left = 428
        Top = 126
        Width = 169
        Height = 155
        Caption = #27969#37327#25511#21046
        TabOrder = 6
        object Label17: TLabel
          Left = 8
          Top = 50
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
        object etMaxClientMsgCount: TSpinEdit
          Tag = 24
          Left = 68
          Top = 47
          Width = 69
          Height = 21
          Hint = #19968#27425#25509#25910#21040#25968#25454#20449#24687#30340#25968#37327#22810#23569#65292#36229#36807#25351#23450#25968#37327#23558#34987#35270#20026#25915#20987#12290
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Value = 5
          OnChange = etMaxConnectOfIPChange
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
          TabOrder = 1
          Value = 100
          OnChange = etMaxConnectOfIPChange
        end
        object GroupBox7: TGroupBox
          Left = 8
          Top = 73
          Width = 153
          Height = 74
          Caption = #25915#20987#25805#20316
          TabOrder = 2
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
        Left = 436
        Top = 122
        Width = 90
        Height = 17
        Hint = #25171#24320#27492#21151#33021#21518#65292#22914#26524#23458#25143#31471#30340#21457#36865#30340#25968#25454#36229#36807#25351#23450#38480#21046#23558#20250#30452#25509#23558#20854#25481#32447
        BiDiMode = bdLeftToRight
        Caption = #24322#24120#25481#32447#22788#29702
        ParentBiDiMode = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
      end
    end
    object TabSheet3: TTabSheet
      Caption = #26032#24314#35282#33394#36807#28388
      ImageIndex = 2
      object Bevel1: TBevel
        Left = 184
        Top = 0
        Width = 17
        Height = 282
        Shape = bsLeftLine
      end
      object btnChrNameFilterMod: TButton
        Left = 60
        Top = 260
        Width = 48
        Height = 21
        Caption = #20462#25913
        TabOrder = 0
      end
      object btnChrNameFilterAdd: TButton
        Left = 8
        Top = 260
        Width = 48
        Height = 21
        Caption = #22686#21152
        TabOrder = 1
      end
      object PageControl1: TPageControl
        Left = 207
        Top = 8
        Width = 389
        Height = 272
        ActivePage = TabSheet4
        TabOrder = 2
        object TabSheet1: TTabSheet
          Caption = #35282#33394#23383#31526#38480#21046#19968
          object Label3: TLabel
            Left = 15
            Top = 66
            Width = 363
            Height = 52
            AutoSize = False
            Caption = 
              #12289#12290#183#713#711#168#12291#12293#8212#65374#8214#8230#8216#8217#8220#8221#12308#12309#12296#12297#12298#12299#12300#12301#12302#12303#12310#12311#12304#12305#177#215#247#8758#8743#8744#8721#8719#8746#8745#8712#8759#8730#8869#8741#8736#8978#8857#8747#8750#8801#8780#8776#8765#8733#8800#8814#8815#8804#8805#8734#8757#8756#9794 +
              #9792#176#8242#8243#8451#65284#164#65504#65505#8240#167#8470#9734#9733#9675#9679#9678#9671#9670#9633#9632#9651#9650#8251#8594#8592#8593#8595#12307
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object Label1: TLabel
            Left = 15
            Top = 148
            Width = 288
            Height = 24
            Caption = #8560#8561#8562#8563#8564#8565#8566#8567#8568#8569#13#945#946#947#948#949#950#951#952#953#954#955#956#957#958#959#960#961#963#964#965#966#967#968#969
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object Label2: TLabel
            Left = 15
            Top = 208
            Width = 354
            Height = 25
            AutoSize = False
            Caption = #1072#1073#1074#1075#1076#1077#1105#1078#1079#1080#1081#1082#1083#1084#1085#1086#1087#1088#1089#1090#1091#1092#1093#1094#1095#1096#1097#1098#1099#1100#1101#1102#1103
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object cbDenyNullChar: TCheckBox
            Tag = 24
            Left = 15
            Top = 15
            Width = 122
            Height = 17
            Caption = #31105#27490#20351#29992#31354#26684#23383#31526
            TabOrder = 0
          end
          object cbDenySpecChar: TCheckBox
            Tag = 26
            Left = 15
            Top = 46
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#29305#27530#23383#31526#65306
            TabOrder = 1
          end
          object cbDenyHellenicChars: TCheckBox
            Tag = 27
            Left = 15
            Top = 128
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#24076#33098#23383#31526#65306
            TabOrder = 2
          end
          object cbDenyRussiaChar: TCheckBox
            Tag = 28
            Left = 15
            Top = 187
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#20420#32599#26031#23383#31526#65306
            TabOrder = 3
          end
          object cbDenyAnsiChar: TCheckBox
            Tag = 25
            Left = 183
            Top = 15
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#33521#25991#21644#25968#23383
            TabOrder = 4
          end
        end
        object TabSheet4: TTabSheet
          Caption = #35282#33394#23383#31526#38480#21046#20108
          ImageIndex = 1
          object Label4: TLabel
            Left = 15
            Top = 34
            Width = 354
            Height = 19
            AutoSize = False
            Caption = #9352#9353#9354#9355#9356#9357#9358#9359#9360#9361#9362#9363#9364#9365#9366#9367#9368#9369#9370#9371
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object Label5: TLabel
            Left = 15
            Top = 70
            Width = 354
            Height = 16
            AutoSize = False
            Caption = #9332#9333#9334#9335#9336#9337#9338#9339#9340#9341#9342#9343#9344#9345#9346#9347#9348#9349#9350#9351
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object Label6: TLabel
            Left = 15
            Top = 109
            Width = 354
            Height = 14
            AutoSize = False
            Caption = #9312#9313#9314#9315#9316#9317#9318#9319#9320#9321
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object Label7: TLabel
            Left = 15
            Top = 146
            Width = 338
            Height = 15
            AutoSize = False
            Caption = #12832#12833#12834#12835#12836#12837#12838#12839#12840#12841
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object Label8: TLabel
            Left = 15
            Top = 186
            Width = 338
            Height = 39
            AutoSize = False
            Caption = #65296#65297#65298#65299#65300#65301#65302#65303#65304#65305#13#65345#65346#65347#65348#65349#65350#65351#65352#65353#65354#65355#65356#65357#65358#65359#65360#65361#65362#65363#65364#65365#65366#65367#65368#65369#65370#13#65281#65282#65283#65509#65285#65286#65287#65288#65289#65290#65291#65292#65293#65294#65295#65339#65340#65341#65342#65343#65344#65371#65372#65373#65507
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object cbDenySpecNO1: TCheckBox
            Tag = 29
            Left = 15
            Top = 15
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#20197#19979#25968#23383#65306
            TabOrder = 0
          end
          object cbDenySpecNO2: TCheckBox
            Tag = 30
            Left = 15
            Top = 51
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#20197#19979#25968#23383#65306
            TabOrder = 1
          end
          object cbDenySpecNO3: TCheckBox
            Tag = 31
            Left = 15
            Top = 90
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#20197#19979#25968#23383#65306
            TabOrder = 2
          end
          object cbDenySpecNO4: TCheckBox
            Tag = 32
            Left = 15
            Top = 127
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#20197#19979#25968#23383#65306
            TabOrder = 3
          end
          object cbDenySBCChar: TCheckBox
            Tag = 33
            Left = 15
            Top = 167
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#20840#35282#23383#31526#65306
            TabOrder = 4
          end
        end
        object TabSheet5: TTabSheet
          Caption = #35282#33394#23383#31526#38480#21046#19977
          ImageIndex = 2
          object Label15: TLabel
            Left = 15
            Top = 34
            Width = 354
            Height = 23
            AutoSize = False
            Caption = #12353#12354#12355#12356#12357#12358#12359#12360#12361#12362#12363#12364#12365#12366#12367#12368#12369#12370#12371#12372#12373#12374#12375#12413#12414#12415#12416#12417#12418#12419#12420#12421#12422#12423#12424#12425#12426#12427#12428#12429#12430#12431#12432#12433#12434#12435#8230#8230
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object Label16: TLabel
            Left = 15
            Top = 82
            Width = 354
            Height = 39
            AutoSize = False
            Caption = 
              #9472#9473#9474#9475#9476#9477#9478#9479#9480#9481#9482#9483#9484#9485#9486#9487#9488#9489#9490#9491#9492#9493#9494#9495#9496#9497#9498#9499#9500#9501#9502#9503#9504#9505#9506#9507#9508#9509#9510#9511#9512#9513#9514#9515#9516#9517#9518#9519#9520#9521#9522#9523#9524#9525#9526#9527#9528#9529#9530#9531#9532#9533#9534#9535 +
              #9536#9537#9538#9539#9540#9541#9542#9543#9544#9545#9546#9547
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            Transparent = True
            WordWrap = True
          end
          object cbDenykanjiChar: TCheckBox
            Tag = 34
            Left = 15
            Top = 15
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#20551#26085#25991#65306
            TabOrder = 0
          end
          object cbDenyTabs: TCheckBox
            Tag = 35
            Left = 15
            Top = 63
            Width = 140
            Height = 17
            Caption = #31105#27490#20351#29992#21046#34920#31526#65306
            TabOrder = 1
          end
        end
      end
      object btnChrNameFilterDel: TButton
        Left = 111
        Top = 260
        Width = 48
        Height = 21
        Caption = #21024#38500
        TabOrder = 3
      end
      object ListBoxChrNameFilter: TListBox
        Left = 8
        Top = 124
        Width = 149
        Height = 130
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        ItemHeight = 12
        TabOrder = 4
      end
      object cbAllowGetBackChr: TCheckBox
        Tag = 20
        Left = 8
        Top = 8
        Width = 121
        Height = 17
        Caption = #20801#35768#25214#22238#20154#29289#35282#33394
        TabOrder = 5
      end
      object cbNewChrNameFilter: TCheckBox
        Tag = 23
        Left = 8
        Top = 101
        Width = 149
        Height = 17
        Caption = #26032#27880#20876#20154#29289#35282#33394#23383#31526#36807#28388
        TabOrder = 6
      end
      object cbAllowDeleteChr: TCheckBox
        Tag = 21
        Left = 8
        Top = 31
        Width = 121
        Height = 17
        Caption = #20801#35768#21024#38500#20154#29289#35282#33394
        TabOrder = 7
      end
    end
  end
  object btnSave: TButton
    Left = 432
    Top = 323
    Width = 81
    Height = 26
    Caption = #20445#23384'(&S)'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 519
    Top = 323
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
    Left = 232
    Top = 320
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
      Caption = #36386#19979#32447'(&K)'
      OnClick = APOPMENU_KICKClick
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
  end
  object TempBlockListPopupMenu: TPopupMenu
    OnPopup = TempBlockListPopupMenuPopup
    Left = 264
    Top = 320
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
    Left = 296
    Top = 320
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
  object PopupMenu_IPAreaFilter: TPopupMenu
    OnPopup = PopupMenu_IPAreaFilterPopup
    Left = 328
    Top = 320
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
end
