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
    ActivePage = TabSheet2
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
          Top = 69
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
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
          OnClick = cbAllowGetBackChrClick
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
        OnClick = cbAllowGetBackChrClick
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
        OnClick = cbAllowGetBackChrClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = #26032#24314#24080#21495#36807#28388
      ImageIndex = 2
      object Bevel1: TBevel
        Left = 240
        Top = 3
        Width = 17
        Height = 282
        Shape = bsLeftLine
      end
      object Label5: TLabel
        Left = 15
        Top = 29
        Width = 156
        Height = 12
        Caption = #20005' <-> '#26494' '#31561#32423':    ('#24314#35758'5)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object cbCheckNewIDOfIP: TCheckBox
        Tag = 24
        Left = 15
        Top = 6
        Width = 114
        Height = 17
        Caption = #38480#21046#26032#24314#24080#21495#36895#24230
        TabOrder = 0
        OnClick = cbAllowGetBackChrClick
      end
      object TrackBarIDLimitLevel: TTrackBar
        Left = 8
        Top = 41
        Width = 226
        Height = 25
        Max = 50
        Min = 1
        Position = 1
        TabOrder = 1
        OnChange = TrackBarIDLimitLevelChange
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
