object FrmMain: TFrmMain
  Left = 449
  Top = 214
  Width = 504
  Height = 411
  Caption = 'Legend of mir2 server D7'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter: TSplitter
    Left = 0
    Top = 235
    Width = 488
    Height = 2
    Cursor = crVSplit
    Align = alTop
    Color = clSkyBlue
    ParentColor = False
  end
  object MemoLog: TMemo
    Left = 0
    Top = 0
    Width = 488
    Height = 177
    Align = alTop
    Color = clBlack
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnDblClick = MemoLogDblClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 177
    Width = 488
    Height = 58
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    object LbRunTime: TLabel
      Left = 427
      Top = 30
      Width = 6
      Height = 12
      Alignment = taRightJustify
    end
    object LbUserCount: TLabel
      Left = 427
      Top = 4
      Width = 6
      Height = 12
      Alignment = taRightJustify
    end
    object Label1: TLabel
      Left = 4
      Top = 4
      Width = 6
      Height = 12
    end
    object Label2: TLabel
      Left = 4
      Top = 17
      Width = 6
      Height = 12
    end
    object Label5: TLabel
      Left = 4
      Top = 43
      Width = 6
      Height = 12
    end
    object LbRunSocketTime: TLabel
      Left = 427
      Top = 17
      Width = 6
      Height = 12
      Alignment = taRightJustify
    end
    object Label20: TLabel
      Left = 4
      Top = 30
      Width = 6
      Height = 12
    end
    object MemStatus: TLabel
      Left = 427
      Top = 43
      Width = 6
      Height = 12
      Alignment = taRightJustify
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      OnClick = MemStatusClick
    end
  end
  object GridGate: TStringGrid
    Left = 0
    Top = 237
    Width = 488
    Height = 115
    Align = alClient
    ColCount = 7
    Ctl3D = True
    DefaultRowHeight = 15
    FixedCols = 0
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    ColWidths = (
      28
      112
      54
      54
      52
      51
      58)
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    Left = 44
    Top = 8
  end
  object RunTimer: TTimer
    Enabled = False
    Interval = 1
    Left = 80
    Top = 8
  end
  object DBSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 6000
    Left = 184
    Top = 8
  end
  object ConnectTimer: TTimer
    Enabled = False
    Interval = 3000
    Left = 220
    Top = 8
  end
  object StartTimer: TTimer
    Enabled = False
    Interval = 100
    Left = 116
    Top = 8
  end
  object SaveVariableTimer: TTimer
    Interval = 15000
    Left = 152
    Top = 8
  end
  object CloseTimer: TTimer
    Enabled = False
    Interval = 100
    Left = 256
    Top = 8
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    AutoLineReduction = maManual
    Left = 294
    Top = 8
    object MENU_CONTROL: TMenuItem
      Caption = #25511#21046'(&C)'
      OnClick = MENU_CONTROLClick
      object MENU_CONTROL_START: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #21551#21160#26381#21153'(&S)'
        OnClick = MENU_CONTROL_STARTClick
      end
      object MENU_CONTROL_STOP: TMenuItem
        Caption = #20572#27490#26381#21153'(&E)'
        OnClick = MENU_CONTROL_STOPClick
      end
      object MENU_CONTROL_CLEARLOGMSG: TMenuItem
        Caption = #28165#38500#26085#24535'(&C)'
        OnClick = MENU_CONTROL_CLEARLOGMSGClick
      end
      object MENU_CONTROL_RELOAD: TMenuItem
        Caption = #37325#26032#21152#36733'(&R)'
        object MENU_CONTROL_RELOAD_QMagegeScriptClick: TMenuItem
          Caption = #30331#38470#33050#26412'(&Q)'
          OnClick = MENU_CONTROL_RELOAD_QMagegeScriptClickClick
        end
        object MENU_CONTROL_RELOAD_QFUNCTIONSCRIPT: TMenuItem
          Caption = #21151#33021#33050#26412'(&F)'
          OnClick = MENU_CONTROL_RELOAD_QFUNCTIONSCRIPTClick
        end
        object mniAllNpc: TMenuItem
          Caption = #25152#26377'NPC(&A)'
          OnClick = mniAllNpcClick
        end
        object N8: TMenuItem
          Caption = #33258#23450#20041#25193#23637#31995#21015
          Visible = False
          object N9: TMenuItem
            Caption = #36164#28304#25991#20214#21015#34920
            OnClick = N9Click
          end
          object N10: TMenuItem
            Caption = #23433#20840#21306#20809#29615#29305#25928
            OnClick = N10Click
          end
          object NPC1: TMenuItem
            Caption = 'NPC'#29305#25928
            OnClick = NPC1Click
          end
        end
        object N3: TMenuItem
          Caption = '-'
        end
        object MENU_CONTROL_RELOAD_CONF: TMenuItem
          Caption = #21442#25968#35774#32622'(&C)'
          OnClick = MENU_CONTROL_RELOAD_CONFClick
        end
        object MENU_CONTROL_RELOAD_DISABLEMAKE: TMenuItem
          Caption = #25968#25454#21015#34920'(&L)'
          OnClick = MENU_CONTROL_RELOAD_DISABLEMAKEClick
        end
        object MENU_CONTROL_RELOAD_SABAK: TMenuItem
          Caption = #27801#22478#37197#32622'(&S)'
          OnClick = MENU_CONTROL_RELOAD_SABAKClick
        end
        object MENU_CONTROL_RELOAD_MONSTERSAY: TMenuItem
          Caption = #24618#29289#35828#35805'(&O)'
          OnClick = MENU_CONTROL_RELOAD_MONSTERSAYClick
        end
        object MENU_CONTROL_RELOAD_STARTPOINT: TMenuItem
          Caption = #23433#20840#21306#37197#32622'(&E)'
          OnClick = MENU_CONTROL_RELOAD_STARTPOINTClick
        end
        object RELOADHILLITEMNAMELIST: TMenuItem
          Caption = #29289#21697#25552#31034#21015#34920'(&H)'
          OnClick = RELOADHILLITEMNAMELISTClick
        end
        object MENU_CONTROL_RELOAD_BOXITEM: TMenuItem
          Caption = #23453#31665#29289#21697#37197#32622'(&B)'
          OnClick = MENU_CONTROL_RELOAD_BOXITEMClick
        end
        object MENU_CONTROL_RELOAD_REFINEITEM: TMenuItem
          Caption = #28140#28860#29289#21697#37197#32622'(&R)'
          OnClick = MENU_CONTROL_RELOAD_REFINEITEMClick
        end
        object M1: TMenuItem
          Caption = #20219#21153#23548#33322#21015#34920'(&T)'
          OnClick = M1Click
        end
        object N1: TMenuItem
          Caption = '-'
        end
        object MENU_CONTROL_RELOAD_ITEMDB: TMenuItem
          Caption = #29289#21697#25968#25454#24211'(&I)'
          OnClick = MENU_CONTROL_RELOAD_ITEMDBClick
        end
        object MENU_CONTROL_RELOAD_MAGICDB: TMenuItem
          Caption = #25216#33021#25968#25454#24211'(&D)'
          OnClick = MENU_CONTROL_RELOAD_MAGICDBClick
        end
        object MENU_CONTROL_RELOAD_MONSTERDB: TMenuItem
          Caption = #24618#29289#25968#25454#24211'(&M)'
          OnClick = MENU_CONTROL_RELOAD_MONSTERDBClick
        end
        object N5: TMenuItem
          Caption = '-'
        end
        object N7: TMenuItem
          Caption = #22320#22270#25366#23453#37197#32622
          OnClick = N7Click
        end
        object N4: TMenuItem
          Caption = #20801#35768#32465#23450#35013#22791#21015#34920
          OnClick = N4Click
        end
      end
      object MENU_CONTROL_GATE: TMenuItem
        Caption = #28216#25103#32593#20851'(&G)'
        object MENU_CONTROL_GATE_OPEN: TMenuItem
          Caption = #25171#24320
          OnClick = MENU_CONTROL_GATE_OPENClick
        end
        object MENU_CONTROL_GATE_CLOSE: TMenuItem
          Caption = #20851#38381
          OnClick = MENU_CONTROL_GATE_CLOSEClick
        end
      end
      object N2: TMenuItem
        Caption = #21152#36733#33258#21160#25346#26426#20154#29289
        OnClick = N2Click
      end
      object MENU_CONTROL_EXIT: TMenuItem
        Caption = #36864#20986'(&X)'
        OnClick = MENU_CONTROL_EXITClick
      end
    end
    object MENU_VIEW: TMenuItem
      Caption = #26597#30475'(&I)'
      object MENU_VIEW_ONLINEHUMAN: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #22312#32447#20154#29289'(&O)'
        OnClick = MENU_VIEW_ONLINEHUMANClick
      end
      object MENU_VIEW_SESSION: TMenuItem
        Caption = #20840#23616#20250#35805'(&T)'
        OnClick = MENU_VIEW_SESSIONClick
      end
      object MENU_VIEW_HIGHRANK: TMenuItem
        Caption = #25490#34892#21015#34920'(&H)'
        OnClick = MENU_VIEW_HIGHRANKClick
      end
      object MENU_VIEW_LEVEL: TMenuItem
        Caption = #31561#32423#23646#24615'(&V)'
        OnClick = MENU_VIEW_LEVELClick
      end
      object MENU_VIEW_LIST: TMenuItem
        Caption = #21015#34920#20449#24687'(&L)'
        OnClick = MENU_VIEW_LISTClick
      end
      object MENU_VIEW_KERNELINFO: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #20869#26680#25968#25454'(&K)'
        OnClick = MENU_VIEW_KERNELINFOClick
      end
      object MENU_VIEW_GATE: TMenuItem
        Caption = #32593#20851#29366#24577'(&G)'
        Checked = True
        OnClick = MENU_VIEW_GATEClick
      end
      object N6: TMenuItem
        Caption = #30417#21548#32842#22825#20449#24687
        Hint = #24320#21551#25110#20851#38381#30417#21548#25152#26377#22312#32447#20154#29289#30340'['#31169#20154'/'#34892#20250'/'#32452#38431']'#32842#22825#20449#24687
        OnClick = N6Click
      end
    end
    object MENU_OPTION: TMenuItem
      Caption = #36873#39033'(&O)'
      object MENU_OPTION_GENERAL: TMenuItem
        AutoHotkeys = maManual
        AutoLineReduction = maManual
        Caption = #22522#26412#35774#32622'(&G)'
        OnClick = MENU_OPTION_GENERALClick
      end
      object MENU_OPTION_GAME: TMenuItem
        Caption = #21442#25968#35774#32622'(&S)'
        OnClick = MENU_OPTION_GAMEClick
      end
      object MENU_OPTION_ITEMFUNC: TMenuItem
        Caption = #29289#21697#35013#22791'(&I)'
        OnClick = MENU_OPTION_ITEMFUNCClick
      end
      object G1: TMenuItem
        Caption = #28216#25103#21629#20196'(&C)'
        OnClick = G1Click
      end
      object MENU_OPTION_FUNCTION: TMenuItem
        Caption = #21151#33021#35774#32622'(&F)'
        OnClick = MENU_OPTION_FUNCTIONClick
      end
      object MENU_OPTION_MONSTER: TMenuItem
        Caption = #24618#29289#35774#32622'(&M)'
        OnClick = MENU_OPTION_MONSTERClick
      end
      object MENU_OPTION_SERVERCONFIG: TMenuItem
        Caption = #24615#33021#21442#25968'(&X)'
        OnClick = MENU_OPTION_SERVERCONFIGClick
      end
    end
    object MENU_MANAGE: TMenuItem
      Caption = #31649#29702'(&M)'
      object MENU_MANAGE_ONLINEMSG: TMenuItem
        Caption = #22312#32447#28040#24687'(&S)'
        OnClick = MENU_MANAGE_ONLINEMSGClick
      end
      object MENU_MANAGE_PLUG: TMenuItem
        Caption = #21151#33021#25554#20214'(&P)'
        OnClick = MENU_MANAGE_PLUGClick
      end
      object MENU_MANAGE_CASTLE: TMenuItem
        Caption = #22478#22561#31649#29702'(&M)'
        OnClick = MENU_MANAGE_CASTLEClick
      end
    end
    object N11: TMenuItem
      Caption = #33258#23450#20041#25193#23637
      object N12: TMenuItem
        Caption = #23450#20041#36164#28304#25991#20214#21015#34920
        OnClick = N12Click
      end
      object N13: TMenuItem
        Caption = #23433#20840#21306#20809#22280#25928#26524
        OnClick = N13Click
      end
      object NPC2: TMenuItem
        Caption = #33258#23450#20041'NPC'
        OnClick = NPC2Click
      end
      object N14: TMenuItem
        Caption = #33258#23450#20041#24322#24418#23433#20840#21306
        OnClick = N14Click
      end
    end
    object MENU_TOOLS: TMenuItem
      Caption = #24037#20855'(&T)'
      object MENU_TOOLS_MERCHANT: TMenuItem
        Caption = #20132#26131'NPC'#37197#32622'(&N)'
        OnClick = MENU_TOOLS_MERCHANTClick
      end
      object MENU_TOOLS_NPC: TMenuItem
        Caption = #31649#29702'NPC'#37197#32622'(&M)'
        OnClick = MENU_TOOLS_NPCClick
      end
      object MENU_TOOLS_MONGEN: TMenuItem
        Caption = #21047#24618#37197#32622'(&M)'
        OnClick = MENU_TOOLS_MONGENClick
      end
      object MENU_TOOLS_IPSEARCH: TMenuItem
        Caption = #22320#21306#26597#35810'(&A)'
        OnClick = MENU_TOOLS_IPSEARCHClick
      end
      object MENU_TOOLS_TEST: TMenuItem
        Caption = #27979#35797
        Visible = False
        OnClick = MENU_TOOLS_TESTClick
      end
      object DECODESCRIPT: TMenuItem
        Caption = #35299#23494#33050#26412'(&D)'
        Visible = False
        OnClick = DECODESCRIPTClick
      end
      object MenuStackTest: TMenuItem
        Caption = #22534#26632#27979#35797
        Visible = False
      end
    end
    object MENU_HELP: TMenuItem
      Caption = #24110#21161'(&H)'
      object MENU_HELP_ABOUT: TMenuItem
        Caption = #20851#20110'(&A)'
        OnClick = MENU_HELP_ABOUTClick
      end
    end
  end
  object IdIPWatch: TIdIPWatch
    Active = False
    HistoryEnabled = False
    HistoryFilename = 'iphist.dat'
    Left = 328
    Top = 8
  end
  object LogUDP: TNMUDP
    RemotePort = 0
    LocalPort = 0
    ReportLevel = 1
    Left = 8
    Top = 8
  end
end
