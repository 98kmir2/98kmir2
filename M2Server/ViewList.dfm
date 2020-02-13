object frmViewList: TfrmViewList
  Left = 600
  Top = 352
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26597#30475#21015#34920#20449#24687
  ClientHeight = 429
  ClientWidth = 722
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
  object Label23: TLabel
    Left = 10
    Top = 414
    Width = 444
    Height = 12
    Caption = #35843#25972#30340#21442#25968#31435#21363#29983#25928#65292#22312#32447#26102#35831#30830#35748#27492#21442#25968#30340#20316#29992#20877#35843#25972#65292#20081#35843#25972#23558#23548#33268#28216#25103#28151#20081#65281
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object PageControlGameManageList: TPageControl
    Left = 8
    Top = 8
    Width = 705
    Height = 403
    ActivePage = TabSheet11
    TabOrder = 0
    object TabSheet7: TTabSheet
      Caption = #29289#21697#35268#21017#21015#34920
      ImageIndex = 2
      object GroupBox2: TGroupBox
        Left = 232
        Top = 8
        Width = 217
        Height = 361
        Caption = #25968#25454#24211#29289#21697'(CTRL+F'#26597#25214')'
        TabOrder = 1
        object ListBoxServerItemList: TListBox
          Left = 8
          Top = 19
          Width = 201
          Height = 334
          ItemHeight = 12
          TabOrder = 0
          OnClick = ListBoxServerItemListClick
          OnKeyDown = ListBoxServerItemListKeyDown
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 8
        Width = 217
        Height = 361
        Caption = #38480#23450#29289#21697#21015#34920
        TabOrder = 0
        object ListBoxLimitItemList: TListBox
          Left = 8
          Top = 19
          Width = 201
          Height = 334
          ItemHeight = 12
          TabOrder = 0
          OnClick = ListBoxLimitItemListClick
        end
      end
      object GroupBox11: TGroupBox
        Left = 456
        Top = 8
        Width = 233
        Height = 361
        Caption = #35268#21017#35774#32622
        TabOrder = 2
        object Label24: TLabel
          Left = 8
          Top = 16
          Width = 54
          Height = 12
          Caption = #29289#21697#21517#31216':'
        end
        object Label25: TLabel
          Left = 8
          Top = 40
          Width = 54
          Height = 12
          Caption = #29289#21697' IDX:'
        end
        object EditLimitItemName: TEdit
          Left = 64
          Top = 12
          Width = 153
          Height = 20
          Hint = #33050#26412#25991#20214#21517#31216#12290#25991#20214#21517#31216#20197#27492#21517#23383#21152#22320#22270#21517#32452#21512#20026#23454#38469#25991#20214#21517#12290
          Enabled = False
          TabOrder = 0
        end
        object EditLimitItemIndex: TEdit
          Left = 64
          Top = 36
          Width = 153
          Height = 20
          Hint = #33050#26412#25991#20214#21517#31216#12290#25991#20214#21517#31216#20197#27492#21517#23383#21152#22320#22270#21517#32452#21512#20026#23454#38469#25991#20214#21517#12290
          Enabled = False
          TabOrder = 1
        end
        object GroupBoxLimitItem: TGroupBox
          Left = 8
          Top = 60
          Width = 217
          Height = 221
          Caption = #32534#36753#29289#21697#23646#24615
          TabOrder = 2
          object CheckBoxAllowMake: TCheckBox
            Left = 8
            Top = 16
            Width = 65
            Height = 17
            Caption = #20801#35768#21046#36896
            TabOrder = 0
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisableMake: TCheckBox
            Left = 8
            Top = 31
            Width = 65
            Height = 17
            Caption = #31105#27490#21046#36896
            TabOrder = 2
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisableDrop: TCheckBox
            Left = 112
            Top = 31
            Width = 65
            Height = 17
            Caption = #31105#27490#20173#25481
            TabOrder = 3
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisableDeal: TCheckBox
            Left = 112
            Top = 16
            Width = 65
            Height = 17
            Caption = #31105#27490#20132#26131
            TabOrder = 1
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisableUpgrade: TCheckBox
            Left = 112
            Top = 76
            Width = 65
            Height = 17
            Caption = #31105#27490#21319#32423
            TabOrder = 9
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisableStorage: TCheckBox
            Left = 112
            Top = 46
            Width = 65
            Height = 17
            Caption = #31105#27490#23384#20179
            TabOrder = 5
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDispearOnLogon: TCheckBox
            Left = 112
            Top = 61
            Width = 65
            Height = 17
            Caption = #19978#32447#28040#22833
            TabOrder = 7
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisableTakeOff: TCheckBox
            Left = 8
            Top = 46
            Width = 65
            Height = 17
            Caption = #31105#27490#21462#19979
            TabOrder = 4
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxAllowSellOff: TCheckBox
            Left = 8
            Top = 61
            Width = 65
            Height = 17
            Caption = #20801#35768#25293#21334
            TabOrder = 6
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisableSell: TCheckBox
            Left = 8
            Top = 76
            Width = 65
            Height = 17
            Caption = #31105#27490#20986#21806
            TabOrder = 8
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisableRepair: TCheckBox
            Left = 8
            Top = 91
            Width = 65
            Height = 17
            Caption = #31105#27490#20462#29702
            TabOrder = 10
            OnClick = CheckBoxAllowMakeClick
          end
          object BitBtnSelectAll: TBitBtn
            Left = 8
            Top = 193
            Width = 96
            Height = 21
            Caption = #20840#37096#36873#20013
            TabOrder = 14
            OnClick = BitBtnSelectAllClick
          end
          object BitBtnUnSelectAll: TBitBtn
            Left = 112
            Top = 193
            Width = 96
            Height = 21
            Caption = #20840#37096#19981#36873
            TabOrder = 15
            OnClick = BitBtnUnSelectAllClick
          end
          object CheckBoxDieDropWithOutFail: TCheckBox
            Left = 112
            Top = 91
            Width = 65
            Height = 17
            Hint = #35813#36873#39033#36873#20013#30340#29289#21697#27515#20129#25110#19979#32447#21518#24517#23450#25481#33853#12290
            Caption = #24517#23450#25481#33853
            TabOrder = 11
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxAbleDropInSafeZone: TCheckBox
            Left = 8
            Top = 106
            Width = 65
            Height = 17
            Hint = #20801#35768#23433#20840#21306#20173#25481#27425#29289#21697#65288#27604#22914#28895#33457#29289#21697#65289
            Caption = #23433#20840#21306#20002
            TabOrder = 12
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxNoScatter: TCheckBox
            Left = 8
            Top = 137
            Width = 81
            Height = 17
            Caption = #27515#20129#19981#25481#33853
            TabOrder = 13
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisallowHeroUse: TCheckBox
            Left = 112
            Top = 122
            Width = 89
            Height = 17
            Caption = #31105#27490#33521#38596#20351#29992
            TabOrder = 16
            OnClick = CheckBoxAllowMakeClick
          end
          object ChkMonDropItem: TCheckBox
            Left = 8
            Top = 154
            Width = 97
            Height = 17
            Hint = #35813#36873#39033#36873#20013#30340#24618#29289#25481#33853#29289#21697#26102#35302#21457#12290#35302#21457#26432#24618#20154#29289'QFunction'#20013#30340'[@MonDropItem]'
            Caption = #24618#29289#25481#33853#35302#21457
            TabOrder = 17
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBox5: TCheckBox
            Left = 8
            Top = 170
            Width = 65
            Height = 17
            Hint = #35813#36873#39033#36873#20013#30340#29289#21697#27515#20129#24517#23450#25481#33853#12290
            Caption = #39044#30041#35774#32622
            Enabled = False
            TabOrder = 18
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDisablePSell: TCheckBox
            Left = 8
            Top = 121
            Width = 65
            Height = 17
            Caption = #31105#27490#23492#21806
            TabOrder = 19
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxDUse: TCheckBox
            Left = 112
            Top = 138
            Width = 89
            Height = 17
            Caption = #31105#27490#20154#29289#20351#29992
            TabOrder = 20
            OnClick = CheckBoxAllowMakeClick
          end
          object ChkPickItem: TCheckBox
            Left = 112
            Top = 154
            Width = 65
            Height = 17
            Hint = 
              #35813#36873#39033#36873#20013#30340#29289#21697#25441#21462#26102#35302#21457#12290#20154#29289#35302#21457'QFunction'#20013#30340'[@PickItem],'#33521#38596#35302#21457'QFunction'#20013#30340'[@H.Pick' +
              'Item]'
            Caption = #25441#21462#35302#21457
            TabOrder = 21
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBox9: TCheckBox
            Left = 112
            Top = 170
            Width = 65
            Height = 17
            Hint = #35813#36873#39033#36873#20013#30340#29289#21697#27515#20129#24517#23450#25481#33853#12290
            Caption = #39044#30041#35774#32622
            Enabled = False
            TabOrder = 22
            OnClick = CheckBoxAllowMakeClick
          end
          object CheckBoxdCustomName: TCheckBox
            Left = 112
            Top = 106
            Width = 65
            Height = 17
            Hint = #35813#36873#39033#36873#20013#30340#29289#21697#23558#31105#27490#33258#23450#20041#29289#21697#21517#31216#12290
            Caption = #31105#27490#21629#21517
            TabOrder = 23
            OnClick = CheckBoxAllowMakeClick
          end
        end
        object ButtonItemLimitAdd: TButton
          Left = 8
          Top = 286
          Width = 105
          Height = 21
          Caption = #22686#21152'(&A)'
          TabOrder = 3
          OnClick = ButtonItemLimitAddClick
        end
        object ButtonItemLimitDelete: TButton
          Left = 120
          Top = 286
          Width = 105
          Height = 21
          Caption = #21024#38500'(&A)'
          TabOrder = 4
          OnClick = ButtonItemLimitDeleteClick
        end
        object ButtonItemLimitSave: TButton
          Left = 120
          Top = 332
          Width = 105
          Height = 21
          Hint = #20445#23384#20462#25913#32467#26524#21040#25991#20214#65292#28216#25103#20013#21363#21051#29983#25928#12290
          Caption = #20445#23384'(&S)'
          TabOrder = 8
          OnClick = ButtonItemLimitSaveClick
        end
        object ButtonItemLimitChange: TButton
          Left = 8
          Top = 332
          Width = 105
          Height = 21
          Hint = #20462#25913#21518#22312#28216#25103#20013#31435#21363#29983#25928#65292#20294#19981#20445#23384#21040#25991#20214#12290
          Caption = #20462#25913'(&C)'
          TabOrder = 7
          OnClick = ButtonItemLimitChangeClick
        end
        object ButtonItemLimitAddAll: TButton
          Left = 8
          Top = 309
          Width = 105
          Height = 21
          Hint = #28155#21152#20840#37096#29289#21697#21040#38480#21046#21015#34920#20013#65288#40664#35748#19981#21152#20219#20309#38480#21046#65289#12290
          Caption = #20840#37096#22686#21152'(&A)'
          TabOrder = 5
          OnClick = ButtonItemLimitAddAllClick
        end
        object ButtonItemLimitDeleteAll: TButton
          Left = 120
          Top = 309
          Width = 105
          Height = 21
          Hint = #21024#38500#20840#37096#35268#21017#38480#21046#21015#34920#12290
          Caption = #20840#37096#21024#38500'(&D)'
          TabOrder = 6
          OnClick = ButtonItemLimitDeleteAllClick
        end
      end
    end
    object TabSheet11: TTabSheet
      Caption = #22871#35013#21151#33021#21015#34920
      ImageIndex = 3
      object Label40: TLabel
        Left = 16
        Top = 351
        Width = 42
        Height = 12
        Caption = #25552'  '#31034':'
      end
      object Label78: TLabel
        Left = 171
        Top = 325
        Width = 72
        Height = 12
        Caption = #35013#22791#28608#27963#39068#33394
      end
      object LabelReNewNameColor1: TLabel
        Left = 295
        Top = 323
        Width = 24
        Height = 17
        AutoSize = False
        Color = clBackground
        ParentColor = False
      end
      object Label80: TLabel
        Left = 333
        Top = 325
        Width = 72
        Height = 12
        Caption = #23646#24615#28608#27963#39068#33394
      end
      object LabelReNewNameColor2: TLabel
        Left = 457
        Top = 323
        Width = 24
        Height = 17
        AutoSize = False
        Color = clBackground
        ParentColor = False
      end
      object ListViewSuite: TListView
        Left = 167
        Top = 205
        Width = 465
        Height = 110
        Columns = <
          item
            Caption = #24207#21495
            Width = 40
          end
          item
            Caption = #25552#31034
            Width = 100
          end
          item
            Caption = #22871#35013#29289#21697
            Width = 140
          end
          item
            Caption = #38468#21152#23646#24615
            Width = 170
          end>
        GridLines = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = ListViewSuiteChange
        OnClick = ListViewSuiteClick
      end
      object GroupBox24: TGroupBox
        Left = 168
        Top = 8
        Width = 526
        Height = 192
        Caption = #38468#21152#23646#24615#21152#25104
        TabOrder = 1
        object Label41: TLabel
          Left = 8
          Top = 25
          Width = 96
          Height = 12
          Caption = 'HP'#19978#38480':        %'
        end
        object Label42: TLabel
          Left = 8
          Top = 49
          Width = 96
          Height = 12
          Caption = 'MP'#19978#38480':        %'
        end
        object Label43: TLabel
          Left = 8
          Top = 121
          Width = 96
          Height = 12
          Caption = #25915#20987#21147':        %'
        end
        object Label44: TLabel
          Left = 8
          Top = 145
          Width = 96
          Height = 12
          Caption = #39764#27861#21147':        %'
        end
        object Label45: TLabel
          Left = 8
          Top = 169
          Width = 96
          Height = 12
          Caption = #36947#26415#21147':        %'
        end
        object Label46: TLabel
          Left = 8
          Top = 73
          Width = 96
          Height = 12
          Caption = #29289'  '#38450':        %'
        end
        object Label47: TLabel
          Left = 8
          Top = 97
          Width = 96
          Height = 12
          Caption = #39764'  '#38450':        %'
        end
        object Label39: TLabel
          Left = 112
          Top = 25
          Width = 96
          Height = 12
          Caption = #20934'  '#30830':        %'
        end
        object Label62: TLabel
          Left = 112
          Top = 49
          Width = 96
          Height = 12
          Caption = #25935'  '#25463':        %'
        end
        object Label63: TLabel
          Left = 112
          Top = 73
          Width = 96
          Height = 12
          Caption = #39764#36530#36991':        %'
        end
        object Label64: TLabel
          Left = 112
          Top = 97
          Width = 96
          Height = 12
          Caption = #27602#36530#36991':        %'
        end
        object Label65: TLabel
          Left = 112
          Top = 121
          Width = 96
          Height = 12
          Caption = #27602#24674#22797':        %'
        end
        object Label66: TLabel
          Left = 112
          Top = 145
          Width = 96
          Height = 12
          Caption = 'HP'#24674#22797':        %'
        end
        object Label67: TLabel
          Left = 112
          Top = 169
          Width = 96
          Height = 12
          Caption = 'MP'#24674#22797':        %'
        end
        object Label68: TLabel
          Left = 220
          Top = 25
          Width = 48
          Height = 12
          Caption = #20869#21151#24674#22797
        end
        object Label69: TLabel
          Left = 220
          Top = 49
          Width = 102
          Height = 12
          Caption = #26292#20987'            %'
        end
        object Label70: TLabel
          Left = 220
          Top = 73
          Width = 48
          Height = 12
          Caption = #30446#26631#29190#29575
        end
        object Label71: TLabel
          Left = 220
          Top = 97
          Width = 24
          Height = 12
          Caption = #38450#29190
        end
        object Label72: TLabel
          Left = 220
          Top = 121
          Width = 102
          Height = 12
          Caption = #24573#35270#38450#24481'        %'
        end
        object Label73: TLabel
          Left = 220
          Top = 145
          Width = 102
          Height = 12
          Caption = #22686#20260'            %'
        end
        object Label74: TLabel
          Left = 220
          Top = 169
          Width = 102
          Height = 12
          Caption = #20260#23475#21453#23556'        %'
        end
        object Label75: TLabel
          Left = 335
          Top = 73
          Width = 102
          Height = 12
          Caption = #32463#39564#21560#25910'        %'
        end
        object Label76: TLabel
          Left = 335
          Top = 49
          Width = 108
          Height = 12
          Caption = #39764#20943'            % '
        end
        object Label77: TLabel
          Left = 335
          Top = 25
          Width = 108
          Height = 12
          Caption = #29289#20943'            % '
        end
        object EditSuiteMaxHP: TSpinEdit
          Left = 52
          Top = 22
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
        object EditSuiteMaxMP: TSpinEdit
          Left = 52
          Top = 46
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 0
        end
        object EditSubMCRate: TSpinEdit
          Left = 52
          Top = 142
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 0
        end
        object EditSubDCRate: TSpinEdit
          Left = 52
          Top = 118
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 3
          Value = 0
        end
        object EditSubSCRate: TSpinEdit
          Left = 52
          Top = 166
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 4
          Value = 0
        end
        object EditSubACRate: TSpinEdit
          Left = 52
          Top = 70
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 5
          Value = 0
        end
        object EditSubMACRate: TSpinEdit
          Left = 52
          Top = 94
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 6
          Value = 0
        end
        object CheckBoxParalysis: TCheckBox
          Left = 335
          Top = 134
          Width = 49
          Height = 17
          Caption = #40635#30201
          TabOrder = 7
        end
        object CheckBoxMagicShield: TCheckBox
          Left = 335
          Top = 150
          Width = 49
          Height = 17
          Caption = #25252#36523
          TabOrder = 8
        end
        object CheckBoxTeleport: TCheckBox
          Left = 335
          Top = 166
          Width = 49
          Height = 17
          Caption = #20256#36865
          TabOrder = 9
        end
        object CheckBoxRevival: TCheckBox
          Left = 395
          Top = 132
          Width = 49
          Height = 17
          Caption = #22797#27963
          TabOrder = 10
        end
        object CheckBoxMuscleRing: TCheckBox
          Left = 395
          Top = 149
          Width = 49
          Height = 17
          Caption = #36127#36733
          TabOrder = 11
        end
        object CheckBoxUnParalysis: TCheckBox
          Left = 450
          Top = 69
          Width = 57
          Height = 17
          Caption = #38450#40635#30201
          TabOrder = 12
        end
        object CheckBoxUnAllParalysis: TCheckBox
          Left = 450
          Top = 86
          Width = 57
          Height = 17
          Caption = #38450#20840#27602
          TabOrder = 13
        end
        object CheckBoxUnRevival: TCheckBox
          Left = 450
          Top = 103
          Width = 57
          Height = 17
          Caption = #30772#22797#27963
          TabOrder = 14
        end
        object CheckBoxUnMagicShield: TCheckBox
          Left = 450
          Top = 119
          Width = 57
          Height = 17
          Caption = #30772#25252#36523
          TabOrder = 15
        end
        object CheckBoxRecallSuite: TCheckBox
          Left = 450
          Top = 135
          Width = 70
          Height = 17
          Caption = #35760#24518#23646#24615
          TabOrder = 16
        end
        object CheckBoxFastTrain: TCheckBox
          Left = 395
          Top = 166
          Width = 49
          Height = 17
          Caption = #25216#24039
          TabOrder = 17
        end
        object CheckBoxNoDropItem: TCheckBox
          Left = 450
          Top = 151
          Width = 70
          Height = 17
          Caption = #32972#21253#19981#25481
          TabOrder = 18
        end
        object EditSuiteHitPoint: TSpinEdit
          Left = 156
          Top = 22
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 19
          Value = 0
        end
        object EditSuiteSPDPoint: TSpinEdit
          Left = 156
          Top = 46
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 20
          Value = 0
        end
        object EditSuiteAntiMagic: TSpinEdit
          Left = 156
          Top = 70
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 21
          Value = 0
        end
        object EditSuileAntiPoison: TSpinEdit
          Left = 156
          Top = 94
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 22
          Value = 0
        end
        object EditSuitePoisonRecover: TSpinEdit
          Left = 156
          Top = 118
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 23
          Value = 0
        end
        object EditSuiteHPRecover: TSpinEdit
          Left = 156
          Top = 142
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 24
          Value = 0
        end
        object EditSuiteMPRecover: TSpinEdit
          Left = 156
          Top = 166
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 25
          Value = 0
        end
        object CheckBoxNoDropUseItem: TCheckBox
          Left = 450
          Top = 167
          Width = 70
          Height = 17
          Caption = #36523#19978#19981#25481
          TabOrder = 26
        end
        object CheckBoxProbeNecklace: TCheckBox
          Left = 450
          Top = 21
          Width = 49
          Height = 17
          Caption = #25506#27979
          TabOrder = 27
        end
        object CheckBoxHongMoSuite: TCheckBox
          Left = 450
          Top = 37
          Width = 49
          Height = 17
          Caption = #21560#34880
          TabOrder = 28
        end
        object CheckBoxHideMode: TCheckBox
          Left = 450
          Top = 53
          Width = 44
          Height = 17
          Caption = #38544#36523
          TabOrder = 29
        end
        object SpinEdit1: TSpinEdit
          Left = 272
          Top = 22
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 30
          Value = 0
        end
        object SpinEdit2: TSpinEdit
          Left = 272
          Top = 46
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 31
          Value = 0
        end
        object SpinEdit3: TSpinEdit
          Left = 272
          Top = 70
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 32
          Value = 0
        end
        object SpinEdit4: TSpinEdit
          Left = 272
          Top = 94
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 33
          Value = 0
        end
        object SpinEdit5: TSpinEdit
          Left = 272
          Top = 118
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 34
          Value = 0
        end
        object SpinEdit6: TSpinEdit
          Left = 272
          Top = 142
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 35
          Value = 0
        end
        object SpinEdit7: TSpinEdit
          Left = 272
          Top = 166
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 36
          Value = 0
        end
        object SpinEdit8: TSpinEdit
          Left = 387
          Top = 22
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 37
          Value = 0
        end
        object SpinEdit9: TSpinEdit
          Left = 387
          Top = 46
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 38
          Value = 0
        end
        object SpinEdit10: TSpinEdit
          Left = 387
          Top = 70
          Width = 41
          Height = 21
          MaxValue = 9999
          MinValue = 0
          TabOrder = 39
          Value = 0
        end
        object CheckBox1: TCheckBox
          Left = 88
          Top = -1
          Width = 147
          Height = 17
          Caption = #30331#38470#22120#26174#31034#27492#22871#35013#23646#24615
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 40
        end
      end
      object EditSuiteEffectMsg: TEdit
        Left = 60
        Top = 348
        Width = 634
        Height = 20
        TabOrder = 2
        Text = #22871#35013'1'#29983#25928','#29289#38450#25552#21319'15%!'
      end
      object btnSuiteItemAdd: TButton
        Left = 638
        Top = 205
        Width = 56
        Height = 22
        Caption = #22686#21152'(&A)'
        TabOrder = 3
        OnClick = btnSuiteItemAddClick
      end
      object btnSuiteItemDel: TButton
        Left = 638
        Top = 249
        Width = 56
        Height = 22
        Caption = #21024#38500'(&D)'
        Enabled = False
        TabOrder = 4
        OnClick = btnSuiteItemDelClick
      end
      object btnSuiteItemSave: TButton
        Left = 638
        Top = 271
        Width = 56
        Height = 22
        Caption = #20445#23384'(&S)'
        Enabled = False
        TabOrder = 5
        OnClick = btnSuiteItemSaveClick
      end
      object btnReloadSuiteItem: TButton
        Left = 638
        Top = 293
        Width = 56
        Height = 22
        Caption = #37325#36733'(&R)'
        Enabled = False
        TabOrder = 6
        OnClick = btnReloadSuiteItemClick
      end
      object btnSuiteMob: TButton
        Left = 638
        Top = 227
        Width = 56
        Height = 22
        Caption = #20462#25913'(&M)'
        Enabled = False
        TabOrder = 7
        OnClick = btnSuiteMobClick
      end
      object GroupBox25: TGroupBox
        Left = 9
        Top = 9
        Width = 153
        Height = 333
        Caption = #22871#35013#29289#21697
        TabOrder = 8
        object Label48: TLabel
          Left = 8
          Top = 20
          Width = 42
          Height = 12
          Caption = #34915'  '#26381':'
        end
        object Label49: TLabel
          Left = 8
          Top = 44
          Width = 42
          Height = 12
          Caption = #27494'  '#22120':'
        end
        object Label50: TLabel
          Left = 8
          Top = 68
          Width = 42
          Height = 12
          Caption = #21195'  '#31456':'
        end
        object Label51: TLabel
          Left = 8
          Top = 92
          Width = 42
          Height = 12
          Caption = #39033'  '#38142':'
        end
        object Label52: TLabel
          Left = 8
          Top = 188
          Width = 42
          Height = 12
          Caption = #24038#25106#25351':'
        end
        object Label53: TLabel
          Left = 8
          Top = 164
          Width = 42
          Height = 12
          Caption = #21491#25163#38255':'
        end
        object Label54: TLabel
          Left = 8
          Top = 140
          Width = 42
          Height = 12
          Caption = #24038#25163#38255':'
        end
        object Label56: TLabel
          Left = 8
          Top = 116
          Width = 42
          Height = 12
          Caption = #22836'  '#30420':'
        end
        object Label57: TLabel
          Left = 8
          Top = 284
          Width = 42
          Height = 12
          Caption = #38772'  '#23376':'
        end
        object Label58: TLabel
          Left = 8
          Top = 260
          Width = 42
          Height = 12
          Caption = #33136'  '#24102':'
        end
        object Label59: TLabel
          Left = 8
          Top = 308
          Width = 42
          Height = 12
          Caption = #23453'  '#30707':'
        end
        object Label60: TLabel
          Left = 8
          Top = 212
          Width = 42
          Height = 12
          Caption = #21491#25106#25351':'
        end
        object Label61: TLabel
          Left = 8
          Top = 236
          Width = 42
          Height = 12
          Caption = #36947'  '#31526':'
        end
        object Edit1: TEdit
          Left = 52
          Top = 16
          Width = 89
          Height = 20
          TabOrder = 0
        end
        object Edit2: TEdit
          Left = 52
          Top = 40
          Width = 89
          Height = 20
          TabOrder = 1
        end
        object Edit3: TEdit
          Left = 52
          Top = 64
          Width = 89
          Height = 20
          TabOrder = 2
        end
        object Edit4: TEdit
          Left = 52
          Top = 88
          Width = 89
          Height = 20
          TabOrder = 3
        end
        object Edit5: TEdit
          Left = 52
          Top = 112
          Width = 89
          Height = 20
          TabOrder = 4
        end
        object Edit6: TEdit
          Left = 52
          Top = 136
          Width = 89
          Height = 20
          TabOrder = 5
        end
        object Edit7: TEdit
          Left = 52
          Top = 160
          Width = 89
          Height = 20
          TabOrder = 6
        end
        object Edit8: TEdit
          Left = 52
          Top = 184
          Width = 89
          Height = 20
          TabOrder = 7
        end
        object Edit9: TEdit
          Left = 52
          Top = 208
          Width = 89
          Height = 20
          TabOrder = 8
        end
        object Edit10: TEdit
          Left = 52
          Top = 232
          Width = 89
          Height = 20
          TabOrder = 9
        end
        object Edit11: TEdit
          Left = 52
          Top = 256
          Width = 89
          Height = 20
          TabOrder = 10
        end
        object Edit12: TEdit
          Left = 52
          Top = 280
          Width = 89
          Height = 20
          TabOrder = 11
        end
        object Edit13: TEdit
          Left = 52
          Top = 304
          Width = 89
          Height = 20
          TabOrder = 12
        end
      end
      object EditReNewNameColor1: TSpinEdit
        Left = 247
        Top = 321
        Width = 41
        Height = 21
        EditorEnabled = False
        MaxValue = 255
        MinValue = 0
        TabOrder = 9
        Value = 100
        OnChange = EditReNewNameColor1Change
      end
      object EditReNewNameColor2: TSpinEdit
        Left = 409
        Top = 321
        Width = 41
        Height = 21
        EditorEnabled = False
        MaxValue = 255
        MinValue = 0
        TabOrder = 10
        Value = 100
        OnChange = EditReNewNameColor2Change
      end
    end
    object TabSheet20: TTabSheet
      Caption = #28216#25103#31649#29702#21015#34920
      object PageControlGameManage: TPageControl
        Left = 8
        Top = 6
        Width = 681
        Height = 363
        ActivePage = TabSheet25
        TabOrder = 0
        object TabSheet22: TTabSheet
          Caption = #31649#29702#21592#21015#34920
          object GroupBox12: TGroupBox
            Left = 8
            Top = 4
            Width = 161
            Height = 325
            Caption = #31649#29702#21592#21015#34920
            TabOrder = 0
            object ListBoxAdminList: TListBox
              Left = 8
              Top = 21
              Width = 145
              Height = 296
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxAdminListClick
            end
          end
          object GroupBox15: TGroupBox
            Left = 176
            Top = 4
            Width = 185
            Height = 325
            Caption = #31649#29702#21592#20449#24687
            TabOrder = 1
            object Label4: TLabel
              Left = 8
              Top = 20
              Width = 54
              Height = 12
              Caption = #35282#33394#21517#31216':'
            end
            object Label5: TLabel
              Left = 8
              Top = 44
              Width = 54
              Height = 12
              Caption = #35282#33394#31561#32423':'
            end
            object LabelAdminIPaddr: TLabel
              Left = 8
              Top = 68
              Width = 42
              Height = 12
              Caption = #30331#24405'IP:'
            end
            object EditAdminName: TEdit
              Left = 64
              Top = 16
              Width = 113
              Height = 20
              TabOrder = 0
            end
            object EditAdminPremission: TSpinEdit
              Left = 64
              Top = 39
              Width = 61
              Height = 21
              MaxValue = 10
              MinValue = 1
              TabOrder = 1
              Value = 10
            end
            object ButtonAdminListAdd: TButton
              Left = 11
              Top = 254
              Width = 73
              Height = 25
              Caption = #22686#21152'(&A)'
              TabOrder = 3
              OnClick = ButtonAdminListAddClick
            end
            object ButtonAdminListChange: TButton
              Left = 99
              Top = 254
              Width = 73
              Height = 25
              Caption = #20462#25913'(&M)'
              TabOrder = 4
              OnClick = ButtonAdminListChangeClick
            end
            object ButtonAdminListDel: TButton
              Left = 11
              Top = 286
              Width = 73
              Height = 25
              Caption = #21024#38500'(&D)'
              TabOrder = 5
              OnClick = ButtonAdminListDelClick
            end
            object EditAdminIPaddr: TEdit
              Left = 64
              Top = 64
              Width = 113
              Height = 20
              TabOrder = 2
            end
            object ButtonAdminLitsSave: TButton
              Left = 99
              Top = 287
              Width = 73
              Height = 25
              Caption = #20445#23384'(&S)'
              TabOrder = 6
              OnClick = ButtonAdminLitsSaveClick
            end
          end
        end
        object TabSheet25: TTabSheet
          Caption = #28216#25103#26085#24535#36807#28388
          ImageIndex = 3
          object GroupBox8: TGroupBox
            Left = 8
            Top = 4
            Width = 201
            Height = 325
            Caption = #35760#24405#29289#21697'/'#20107#20214#21015#34920
            TabOrder = 0
            object ListBoxGameLogList: TListBox
              Left = 8
              Top = 23
              Width = 185
              Height = 294
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxGameLogListClick
            end
          end
          object GroupBox9: TGroupBox
            Left = 320
            Top = 4
            Width = 201
            Height = 325
            Caption = #20107#20214'/'#29289#21697#21015#34920
            TabOrder = 1
            object ListBoxLogItemList: TListBox
              Left = 8
              Top = 23
              Width = 185
              Height = 294
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxLogItemListClick
            end
          end
          object ButtonGameLogAdd: TButton
            Left = 224
            Top = 32
            Width = 81
            Height = 25
            Caption = #22686#21152'(&A)'
            TabOrder = 2
            OnClick = ButtonGameLogAddClick
          end
          object ButtonGameLogDel: TButton
            Left = 224
            Top = 64
            Width = 81
            Height = 25
            Caption = #21024#38500'(&D)'
            TabOrder = 3
            OnClick = ButtonGameLogDelClick
          end
          object ButtonGameLogAddAll: TButton
            Left = 224
            Top = 96
            Width = 81
            Height = 25
            Caption = #20840#37096#22686#21152'(&A)'
            TabOrder = 4
            OnClick = ButtonGameLogAddAllClick
          end
          object ButtonGameLogDelAll: TButton
            Left = 224
            Top = 128
            Width = 81
            Height = 25
            Caption = #20840#37096#21024#38500'(&D)'
            TabOrder = 5
            OnClick = ButtonGameLogDelAllClick
          end
          object ButtonGameLogSave: TButton
            Left = 224
            Top = 160
            Width = 81
            Height = 25
            Caption = #20445#23384'(&S)'
            TabOrder = 6
            OnClick = ButtonGameLogSaveClick
          end
        end
        object TabSheet8: TTabSheet
          Caption = #29289#21697#21517#31216#33258#23450#20041
          ImageIndex = 8
          object GroupBox19: TGroupBox
            Left = 496
            Top = 8
            Width = 169
            Height = 321
            Caption = #29289#21697#33258#23450#20041#21517#31216
            TabOrder = 1
            object Label18: TLabel
              Left = 8
              Top = 42
              Width = 48
              Height = 12
              Caption = #29289#21697'IDX:'
            end
            object Label19: TLabel
              Left = 8
              Top = 66
              Width = 54
              Height = 12
              Caption = #29289#21697#24207#21495':'
            end
            object Label20: TLabel
              Left = 8
              Top = 90
              Width = 54
              Height = 12
              Caption = #33258#23450#20041#21517':'
            end
            object Label21: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #29289#21697#21517#31216':'
            end
            object ButtonItemNameMod: TButton
              Left = 88
              Top = 256
              Width = 73
              Height = 25
              Caption = #20462#25913'(&S)'
              TabOrder = 5
              OnClick = ButtonItemNameModClick
            end
            object EditItemNameIdx: TSpinEdit
              Left = 68
              Top = 39
              Width = 93
              Height = 21
              MaxValue = 5000
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditItemNameIdxChange
            end
            object EditItemNameMakeIndex: TSpinEdit
              Left = 68
              Top = 63
              Width = 93
              Height = 21
              MaxValue = 0
              MinValue = 0
              TabOrder = 2
              Value = 10
              OnChange = EditItemNameMakeIndexChange
            end
            object EditItemNameOldName: TEdit
              Left = 68
              Top = 16
              Width = 93
              Height = 20
              ReadOnly = True
              TabOrder = 0
            end
            object ButtonItemNameAdd: TButton
              Left = 8
              Top = 256
              Width = 73
              Height = 25
              Caption = #22686#21152'(&A)'
              TabOrder = 4
              OnClick = ButtonItemNameAddClick
            end
            object ButtonItemNameRef: TButton
              Left = 88
              Top = 288
              Width = 73
              Height = 25
              Caption = #21047#26032'(&R)'
              TabOrder = 7
              OnClick = ButtonItemNameRefClick
            end
            object ButtonItemNameDel: TButton
              Left = 8
              Top = 288
              Width = 73
              Height = 25
              Caption = #21024#38500'(&D)'
              TabOrder = 6
              OnClick = ButtonItemNameDelClick
            end
            object EditItemNameNewName: TEdit
              Left = 68
              Top = 88
              Width = 93
              Height = 20
              TabOrder = 3
              OnChange = EditItemNameNewNameChange
            end
          end
          object GridItemNameList: TStringGrid
            Left = 8
            Top = 8
            Width = 481
            Height = 321
            ColCount = 3
            DefaultRowHeight = 18
            FixedCols = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
            TabOrder = 0
            OnClick = GridItemNameListClick
            ColWidths = (
              106
              79
              145)
          end
        end
        object TabSheet24: TTabSheet
          Caption = #29289#21697#24080#21495#32465#23450
          ImageIndex = 2
          object GridItemBindAccount: TStringGrid
            Left = 8
            Top = 8
            Width = 481
            Height = 321
            Hint = #21152#20837#27492#21015#34920#20013#30340#29289#21697#23558#19982#25351#23450#30340#30331#24405#24080#21495#32465#23450#65292#21482#26377#20197#32465#23450#30340#30331#24405#24080#21495#30331#24405#30340#20154#29289#25165#21487#20197#25140#19978#27492#29289#21697#12290
            ColCount = 4
            DefaultRowHeight = 18
            FixedCols = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
            TabOrder = 0
            OnClick = GridItemBindAccountClick
            ColWidths = (
              94
              70
              77
              88)
          end
          object GroupBox16: TGroupBox
            Left = 496
            Top = 8
            Width = 169
            Height = 321
            Caption = #35268#21017#35774#32622
            TabOrder = 1
            object Label6: TLabel
              Left = 8
              Top = 42
              Width = 48
              Height = 12
              Caption = #29289#21697'IDX:'
            end
            object Label7: TLabel
              Left = 8
              Top = 66
              Width = 54
              Height = 12
              Caption = #29289#21697#24207#21495':'
            end
            object Label8: TLabel
              Left = 8
              Top = 90
              Width = 54
              Height = 12
              Caption = #32465#23450#24080#21495':'
            end
            object Label9: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #29289#21697#21517#31216':'
            end
            object ButtonItemBindAcountMod: TButton
              Left = 88
              Top = 256
              Width = 73
              Height = 25
              Caption = #20462#25913'(&S)'
              TabOrder = 5
              OnClick = ButtonItemBindAcountModClick
            end
            object EditItemBindAccountItemIdx: TSpinEdit
              Left = 68
              Top = 39
              Width = 93
              Height = 21
              MaxValue = 5000
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditItemBindAccountItemIdxChange
            end
            object EditItemBindAccountItemMakeIdx: TSpinEdit
              Left = 68
              Top = 63
              Width = 93
              Height = 21
              MaxValue = 0
              MinValue = 0
              TabOrder = 2
              Value = 10
              OnChange = EditItemBindAccountItemMakeIdxChange
            end
            object EditItemBindAccountItemName: TEdit
              Left = 68
              Top = 16
              Width = 93
              Height = 20
              ReadOnly = True
              TabOrder = 0
            end
            object ButtonItemBindAcountAdd: TButton
              Left = 8
              Top = 256
              Width = 73
              Height = 25
              Caption = #22686#21152'(&A)'
              TabOrder = 4
              OnClick = ButtonItemBindAcountAddClick
            end
            object ButtonItemBindAcountRef: TButton
              Left = 88
              Top = 288
              Width = 73
              Height = 25
              Caption = #21047#26032'(&R)'
              TabOrder = 7
              OnClick = ButtonItemBindAcountRefClick
            end
            object ButtonItemBindAcountDel: TButton
              Left = 8
              Top = 288
              Width = 73
              Height = 25
              Caption = #21024#38500'(&D)'
              TabOrder = 6
              OnClick = ButtonItemBindAcountDelClick
            end
            object EditItemBindAccountName: TEdit
              Left = 68
              Top = 88
              Width = 93
              Height = 20
              TabOrder = 3
              OnChange = EditItemBindAccountNameChange
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = #29289#21697#20154#29289#32465#23450
          ImageIndex = 4
          object GridItemBindCharName: TStringGrid
            Left = 8
            Top = 8
            Width = 481
            Height = 321
            Hint = #21152#20837#27492#21015#34920#20013#30340#29289#21697#23558#19982#25351#23450#30340#20154#29289#21517#31216#32465#23450#65292#21482#26377#32465#23450#30340#20154#29289#25165#21487#20197#25140#19978#27492#29289#21697#12290
            ColCount = 4
            DefaultRowHeight = 18
            FixedCols = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
            TabOrder = 0
            OnClick = GridItemBindCharNameClick
            ColWidths = (
              94
              70
              77
              88)
          end
          object GroupBox17: TGroupBox
            Left = 496
            Top = 8
            Width = 169
            Height = 321
            Caption = #35268#21017#35774#32622
            TabOrder = 1
            object Label10: TLabel
              Left = 8
              Top = 42
              Width = 48
              Height = 12
              Caption = #29289#21697'IDX:'
            end
            object Label11: TLabel
              Left = 8
              Top = 66
              Width = 54
              Height = 12
              Caption = #29289#21697#24207#21495':'
            end
            object Label12: TLabel
              Left = 8
              Top = 90
              Width = 54
              Height = 12
              Caption = #32465#23450#20154#29289':'
            end
            object Label13: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #29289#21697#21517#31216':'
            end
            object ButtonItemBindCharNameMod: TButton
              Left = 88
              Top = 256
              Width = 73
              Height = 25
              Caption = #20462#25913'(&S)'
              TabOrder = 5
              OnClick = ButtonItemBindCharNameModClick
            end
            object EditItemBindCharNameItemIdx: TSpinEdit
              Left = 68
              Top = 39
              Width = 93
              Height = 21
              MaxValue = 5000
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditItemBindCharNameItemIdxChange
            end
            object EditItemBindCharNameItemMakeIdx: TSpinEdit
              Left = 68
              Top = 63
              Width = 93
              Height = 21
              MaxValue = 0
              MinValue = 0
              TabOrder = 2
              Value = 10
              OnChange = EditItemBindCharNameItemMakeIdxChange
            end
            object EditItemBindCharNameItemName: TEdit
              Left = 68
              Top = 16
              Width = 93
              Height = 20
              ReadOnly = True
              TabOrder = 0
            end
            object ButtonItemBindCharNameAdd: TButton
              Left = 8
              Top = 256
              Width = 73
              Height = 25
              Caption = #22686#21152'(&A)'
              TabOrder = 4
              OnClick = ButtonItemBindCharNameAddClick
            end
            object ButtonItemBindCharNameRef: TButton
              Left = 88
              Top = 288
              Width = 73
              Height = 25
              Caption = #21047#26032'(&R)'
              TabOrder = 7
              OnClick = ButtonItemBindCharNameRefClick
            end
            object ButtonItemBindCharNameDel: TButton
              Left = 8
              Top = 288
              Width = 73
              Height = 25
              Caption = #21024#38500'(&D)'
              TabOrder = 6
              OnClick = ButtonItemBindCharNameDelClick
            end
            object EditItemBindCharNameName: TEdit
              Left = 68
              Top = 88
              Width = 93
              Height = 20
              TabOrder = 3
              OnChange = EditItemBindCharNameNameChange
            end
          end
        end
        object TabSheet5: TTabSheet
          Caption = #29289#21697'IP'#32465#23450
          ImageIndex = 5
          object GridItemBindIPaddr: TStringGrid
            Left = 8
            Top = 8
            Width = 481
            Height = 321
            Hint = #21152#20837#27492#21015#34920#20013#30340#29289#21697#23558#19982#25351#23450#30340#30331#24405'IP'#22320#22336#32465#23450#65292#21482#26377#20197#32465#23450#30340#30331#24405'IP'#22320#22336#30331#24405#30340#20154#29289#25165#21487#20197#25140#19978#27492#29289#21697#12290
            ColCount = 4
            DefaultRowHeight = 18
            FixedCols = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
            TabOrder = 0
            OnClick = GridItemBindIPaddrClick
            ColWidths = (
              94
              70
              77
              88)
          end
          object GroupBox18: TGroupBox
            Left = 496
            Top = 8
            Width = 169
            Height = 321
            Caption = #35268#21017#35774#32622
            TabOrder = 1
            object Label14: TLabel
              Left = 8
              Top = 42
              Width = 48
              Height = 12
              Caption = #29289#21697'IDX:'
            end
            object Label15: TLabel
              Left = 8
              Top = 66
              Width = 54
              Height = 12
              Caption = #29289#21697#24207#21495':'
            end
            object Label16: TLabel
              Left = 8
              Top = 90
              Width = 42
              Height = 12
              Caption = #32465#23450'IP:'
            end
            object Label17: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #29289#21697#21517#31216':'
            end
            object ButtonItemBindIPaddrMod: TButton
              Left = 88
              Top = 256
              Width = 73
              Height = 25
              Caption = #20462#25913'(&S)'
              TabOrder = 5
              OnClick = ButtonItemBindIPaddrModClick
            end
            object EditItemBindIPaddrItemIdx: TSpinEdit
              Left = 68
              Top = 39
              Width = 93
              Height = 21
              MaxValue = 5000
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditItemBindIPaddrItemIdxChange
            end
            object EditItemBindIPaddrItemMakeIdx: TSpinEdit
              Left = 68
              Top = 63
              Width = 93
              Height = 21
              MaxValue = 0
              MinValue = 0
              TabOrder = 2
              Value = 10
              OnChange = EditItemBindIPaddrItemMakeIdxChange
            end
            object EditItemBindIPaddrItemName: TEdit
              Left = 68
              Top = 16
              Width = 93
              Height = 20
              ReadOnly = True
              TabOrder = 0
            end
            object ButtonItemBindIPaddrAdd: TButton
              Left = 8
              Top = 256
              Width = 73
              Height = 25
              Caption = #22686#21152'(&A)'
              TabOrder = 4
              OnClick = ButtonItemBindIPaddrAddClick
            end
            object ButtonItemBindIPaddrRef: TButton
              Left = 88
              Top = 288
              Width = 73
              Height = 25
              Caption = #21047#26032'(&R)'
              TabOrder = 7
              OnClick = ButtonItemBindIPaddrRefClick
            end
            object ButtonItemBindIPaddrDel: TButton
              Left = 8
              Top = 288
              Width = 73
              Height = 25
              Caption = #21024#38500'(&D)'
              TabOrder = 6
              OnClick = ButtonItemBindIPaddrDelClick
            end
            object EditItemBindIPaddrName: TEdit
              Left = 68
              Top = 88
              Width = 93
              Height = 20
              TabOrder = 3
              OnChange = EditItemBindIPaddrNameChange
            end
          end
        end
        object TabSheetMonDrop: TTabSheet
          Caption = #24618#29289#29190#29289#21697
          ImageIndex = 7
          object GroupBox7: TGroupBox
            Left = 496
            Top = 8
            Width = 169
            Height = 321
            Caption = #35268#21017#35774#32622
            TabOrder = 1
            object Label29: TLabel
              Left = 8
              Top = 107
              Width = 54
              Height = 12
              Caption = #24050#29190#25968#37327':'
            end
            object Label1: TLabel
              Left = 8
              Top = 59
              Width = 54
              Height = 12
              Caption = #38480#21046#25968#37327':'
            end
            object Label2: TLabel
              Left = 7
              Top = 131
              Width = 54
              Height = 12
              Caption = #26410#29190#25968#37327':'
            end
            object Label3: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #29289#21697#21517#31216':'
            end
            object Label22: TLabel
              Left = 7
              Top = 83
              Width = 54
              Height = 12
              Caption = #28165#38646#22825#25968':'
            end
            object ButtonMonDropLimitSave: TButton
              Left = 88
              Top = 256
              Width = 73
              Height = 25
              Caption = #20462#25913'(&S)'
              TabOrder = 6
              OnClick = ButtonMonDropLimitSaveClick
            end
            object EditDropCount: TSpinEdit
              Left = 62
              Top = 104
              Width = 51
              Height = 21
              MaxValue = 100000
              MinValue = 0
              TabOrder = 3
              Value = 10
              OnChange = EditDropCountChange
            end
            object EditCountLimit: TSpinEdit
              Left = 62
              Top = 56
              Width = 51
              Height = 21
              MaxValue = 100000
              MinValue = 0
              TabOrder = 1
              Value = 10
              OnChange = EditCountLimitChange
            end
            object EditNoDropCount: TSpinEdit
              Left = 62
              Top = 128
              Width = 51
              Height = 21
              MaxValue = 100000
              MinValue = 0
              TabOrder = 4
              Value = 10
              OnChange = EditNoDropCountChange
            end
            object EditItemName: TEdit
              Left = 6
              Top = 32
              Width = 149
              Height = 20
              TabOrder = 0
            end
            object ButtonMonDropLimitAdd: TButton
              Left = 8
              Top = 256
              Width = 73
              Height = 25
              Caption = #22686#21152'(&A)'
              TabOrder = 5
              OnClick = ButtonMonDropLimitAddClick
            end
            object ButtonMonDropLimitRef: TButton
              Left = 88
              Top = 288
              Width = 73
              Height = 25
              Caption = #21047#26032'(&R)'
              TabOrder = 8
              OnClick = ButtonMonDropLimitRefClick
            end
            object ButtonMonDropLimitDel: TButton
              Left = 8
              Top = 288
              Width = 73
              Height = 25
              Caption = #21024#38500'(&D)'
              TabOrder = 7
              OnClick = ButtonMonDropLimitDelClick
            end
            object EditClearTime: TSpinEdit
              Left = 62
              Top = 80
              Width = 51
              Height = 21
              MaxValue = 100000
              MinValue = 0
              TabOrder = 2
              Value = 10
              OnChange = EditClearTimeChange
            end
          end
          object StringGridMonDropLimit: TStringGrid
            Left = 8
            Top = 8
            Width = 481
            Height = 321
            DefaultRowHeight = 18
            FixedCols = 0
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
            TabOrder = 0
            OnClick = StringGridMonDropLimitClick
            ColWidths = (
              85
              66
              60
              54
              64)
          end
        end
        object TabSheet6: TTabSheet
          Caption = #31105#27490#28165#29702#24618#29289#21015#34920
          ImageIndex = 6
          object GroupBox13: TGroupBox
            Left = 8
            Top = 4
            Width = 201
            Height = 325
            Caption = #31105#27490#28165#29702#24618#29289#21015#34920
            TabOrder = 0
            object ListBoxNoClearMonList: TListBox
              Left = 8
              Top = 20
              Width = 185
              Height = 297
              Hint = #31105#27490#28165#38500#24618#29289#35774#32622#65292#29992#20110#33050#26412#21629#20196'CLEARMAPMON'#65292#21152#20837#27492#21015#34920#30340#24618#29289#65292#22312#20351#29992#27492#33050#26412#21629#20196#26102#19981#20250#34987#28165#38500#12290
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxNoClearMonListClick
            end
          end
          object GroupBox14: TGroupBox
            Left = 320
            Top = 4
            Width = 201
            Height = 325
            Caption = #24618#29289#21015#34920
            TabOrder = 1
            object ListBoxMonList: TListBox
              Left = 8
              Top = 20
              Width = 185
              Height = 297
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxMonListClick
            end
          end
          object ButtonNoClearMonAdd: TButton
            Left = 224
            Top = 32
            Width = 81
            Height = 25
            Caption = #22686#21152'(&A)'
            TabOrder = 2
            OnClick = ButtonNoClearMonAddClick
          end
          object ButtonNoClearMonDel: TButton
            Left = 224
            Top = 64
            Width = 81
            Height = 25
            Caption = #21024#38500'(&D)'
            TabOrder = 3
            OnClick = ButtonNoClearMonDelClick
          end
          object ButtonNoClearMonAddAll: TButton
            Left = 224
            Top = 96
            Width = 81
            Height = 25
            Caption = #20840#37096#22686#21152'(&A)'
            TabOrder = 4
            OnClick = ButtonNoClearMonAddAllClick
          end
          object ButtonNoClearMonDelAll: TButton
            Left = 224
            Top = 128
            Width = 81
            Height = 25
            Caption = #20840#37096#21024#38500'(&D)'
            TabOrder = 5
            OnClick = ButtonNoClearMonDelAllClick
          end
          object ButtonNoClearMonSave: TButton
            Left = 224
            Top = 160
            Width = 81
            Height = 25
            Caption = #20445#23384'(&S)'
            TabOrder = 6
            OnClick = ButtonNoClearMonSaveClick
          end
        end
        object TabSheet23: TTabSheet
          Caption = #31105#27490#20256#36865#22320#22270
          ImageIndex = 1
          object GroupBox5: TGroupBox
            Left = 8
            Top = 4
            Width = 201
            Height = 325
            Caption = #31105#27490#22320#22270#21015#34920
            TabOrder = 0
            object ListBoxDisableMoveMap: TListBox
              Left = 8
              Top = 20
              Width = 185
              Height = 297
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxDisableMoveMapClick
            end
          end
          object GroupBox6: TGroupBox
            Left = 320
            Top = 4
            Width = 201
            Height = 325
            Caption = #22320#22270#21015#34920
            TabOrder = 1
            object ListBoxMapList: TListBox
              Left = 8
              Top = 20
              Width = 185
              Height = 297
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxMapListClick
            end
          end
          object ButtonDisableMoveMapAdd: TButton
            Left = 224
            Top = 32
            Width = 81
            Height = 25
            Caption = #22686#21152'(&A)'
            TabOrder = 2
            OnClick = ButtonDisableMoveMapAddClick
          end
          object ButtonDisableMoveMapDelete: TButton
            Left = 224
            Top = 64
            Width = 81
            Height = 25
            Caption = #21024#38500'(&D)'
            TabOrder = 3
            OnClick = ButtonDisableMoveMapDeleteClick
          end
          object ButtonDisableMoveMapAddAll: TButton
            Left = 224
            Top = 96
            Width = 81
            Height = 25
            Caption = #20840#37096#22686#21152'(&A)'
            TabOrder = 4
            OnClick = ButtonDisableMoveMapAddAllClick
          end
          object ButtonDisableMoveMapDeleteAll: TButton
            Left = 224
            Top = 128
            Width = 81
            Height = 25
            Caption = #20840#37096#21024#38500'(&D)'
            TabOrder = 5
            OnClick = ButtonDisableMoveMapDeleteAllClick
          end
          object ButtonDisableMoveMapSave: TButton
            Left = 224
            Top = 160
            Width = 81
            Height = 25
            Caption = #20445#23384'(&S)'
            TabOrder = 6
            OnClick = ButtonDisableMoveMapSaveClick
          end
        end
      end
    end
    object TabSheetOther: TTabSheet
      Caption = #20854#20182#21151#33021#21015#34920
      ImageIndex = 2
      object PageControl1: TPageControl
        Left = 8
        Top = 8
        Width = 681
        Height = 361
        ActivePage = TabSheet4
        TabOrder = 0
        object TabSheet10: TTabSheet
          Caption = #21830#38138#29289#21697#21015#34920'('#26032')'
          ImageIndex = 5
          object Label32: TLabel
            Left = 8
            Top = 308
            Width = 54
            Height = 12
            Caption = #29289#21697#25551#36848':'
          end
          object Label33: TLabel
            Left = 8
            Top = 284
            Width = 54
            Height = 12
            Caption = #29289#21697#20215#26684':'
          end
          object Label34: TLabel
            Left = 8
            Top = 236
            Width = 54
            Height = 12
            Caption = #29289#21697#21517#31216':'
          end
          object Label35: TLabel
            Left = 184
            Top = 236
            Width = 252
            Height = 12
            Caption = 'Items.wil'#24207#21495':              ('#23454#29616#29289#21697#22270#26631')'
          end
          object Label36: TLabel
            Left = 184
            Top = 260
            Width = 252
            Height = 12
            Caption = 'Effect.wil'#24207#21495':             ('#23454#29616#29289#21697#28436#31034')'
          end
          object Label37: TLabel
            Left = 184
            Top = 284
            Width = 252
            Height = 12
            Caption = 'Effect.wil'#25968#37327':             ('#28436#31034#22270#29255#24352#25968')'
          end
          object Label38: TLabel
            Left = 8
            Top = 260
            Width = 54
            Height = 12
            Caption = #29289#21697#31867#21035':'
          end
          object GroupBox23: TGroupBox
            Left = 536
            Top = 2
            Width = 129
            Height = 271
            Caption = #29289#21697#21015#34920
            TabOrder = 0
            object ListBoxShopItemList: TListBox
              Left = 8
              Top = 18
              Width = 113
              Height = 245
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxShopItemListClick
            end
          end
          object btnShopItemDel: TButton
            Left = 448
            Top = 256
            Width = 79
            Height = 21
            Caption = #21024#38500'(&D)'
            TabOrder = 1
            OnClick = btnShopItemDelClick
          end
          object btnReloadShopItemList: TButton
            Left = 448
            Top = 304
            Width = 79
            Height = 21
            Caption = #37325#26032#21152#36733
            Enabled = False
            TabOrder = 2
            OnClick = btnReloadShopItemListClick
          end
          object btnShopItemSave: TButton
            Left = 448
            Top = 280
            Width = 79
            Height = 21
            Caption = #20445#23384'(&S)'
            TabOrder = 3
            OnClick = btnShopItemSaveClick
          end
          object btnShopItemAdd: TButton
            Left = 448
            Top = 232
            Width = 79
            Height = 21
            Caption = #22686#21152'(&A)'
            Enabled = False
            TabOrder = 4
            OnClick = btnShopItemAddClick
          end
          object EditShopItemName: TEdit
            Left = 64
            Top = 232
            Width = 97
            Height = 20
            TabOrder = 5
          end
          object EditShopItemPrice: TSpinEdit
            Left = 64
            Top = 280
            Width = 97
            Height = 21
            MaxValue = 2000000000
            MinValue = 1
            TabOrder = 6
            Value = 100
          end
          object EditShopItemDetail: TEdit
            Left = 64
            Top = 304
            Width = 281
            Height = 20
            MaxLength = 128
            TabOrder = 7
          end
          object SpinEditShopItemIdx1: TSpinEdit
            Left = 272
            Top = 232
            Width = 73
            Height = 21
            MaxValue = 65535
            MinValue = 0
            TabOrder = 8
            Value = 100
          end
          object SpinEditShopItemIdx2: TSpinEdit
            Left = 272
            Top = 256
            Width = 73
            Height = 21
            MaxValue = 65535
            MinValue = 0
            TabOrder = 9
            Value = 100
          end
          object SpinEditShopItemIdx3: TSpinEdit
            Left = 272
            Top = 280
            Width = 73
            Height = 21
            MaxValue = 65535
            MinValue = 0
            TabOrder = 10
            Value = 100
          end
          object ListViewShopItemList: TListView
            Left = 10
            Top = 10
            Width = 519
            Height = 191
            Columns = <
              item
                Caption = #31867#21035
                Width = 40
              end
              item
                Caption = #29289#21697#21517#31216
                Width = 88
              end
              item
                Caption = 'Item.wil'#24207#21495
                Width = 84
              end
              item
                Caption = #29289#21697#20215#26684
                Width = 60
              end
              item
                Caption = 'Effect.wil'#24207#21495
                Width = 98
              end
              item
                Caption = '->'#22270#29255#25968#37327
                Width = 80
              end
              item
                Caption = #20801#35768#36192#36865
                Width = 60
              end
              item
                Caption = #20986#21806#26041#24335
                Width = 60
              end
              item
                Caption = #29289#21697#25551#36848
                Width = 500
              end>
            GridLines = True
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 11
            ViewStyle = vsReport
            OnClick = ListViewShopItemListClick
          end
          object GroupBox26: TGroupBox
            Left = 536
            Top = 280
            Width = 129
            Height = 45
            Caption = #36141#20080#29289#21697#35774#32622
            TabOrder = 12
            Visible = False
            object Label55: TLabel
              Left = 8
              Top = 20
              Width = 54
              Height = 12
              Caption = #32465#23450#29366#24577':'
            end
            object ComboBoxSaleItemBind: TComboBox
              Left = 64
              Top = 16
              Width = 57
              Height = 20
              Hint = #35774#32622#36141#20080#29289#21697#25104#21151#21518#65292#29289#21697#30340#32465#23450#29366#24577#65292#40664#35748#19981#32465#23450#12290
              Style = csDropDownList
              ItemHeight = 12
              TabOrder = 0
              OnChange = ComboBoxSaleItemBindChange
            end
          end
          object rbYb: TRadioButton
            Left = 84
            Top = 208
            Width = 81
            Height = 17
            Caption = #20197#20803#23453#20986#21806
            Checked = True
            TabOrder = 13
            TabStop = True
            OnClick = rbYbClick
          end
          object rbGd: TRadioButton
            Left = 173
            Top = 208
            Width = 81
            Height = 17
            Caption = #20197#37329#24065#20986#21806
            TabOrder = 14
            OnClick = rbYbClick
          end
          object cbPresendItem: TCheckBox
            Left = 8
            Top = 208
            Width = 73
            Height = 17
            Caption = #20801#35768#36192#36865
            TabOrder = 15
            OnClick = cbPresendItemClick
          end
          object cmbItemType: TComboBox
            Left = 64
            Top = 256
            Width = 98
            Height = 22
            Hint = '0='#35013#39280', 1='#34917#32473', 2='#24378#21270',  3='#22909#21451', 4='#38480#37327', 5='#22855#29645
            Style = csOwnerDrawFixed
            ItemHeight = 16
            TabOrder = 16
            Items.Strings = (
              #35013#39280
              #34917#32473
              #24378#21270
              #22909#21451
              #38480#37327
              #22855#29645)
          end
        end
        object TabSheetQueryValeFilter: TTabSheet
          Caption = #25991#26412#23383#31526#36807#28388
          object GroupBox1: TGroupBox
            Left = 262
            Top = 8
            Width = 253
            Height = 321
            Caption = 'NPC'#21629#20196'[QueryVale]'#23383#31526#36807#28388
            TabOrder = 0
            Visible = False
            object ListBoxQueryValueFilter: TListBox
              Left = 8
              Top = 19
              Width = 153
              Height = 294
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxQueryValueFilterClick
              OnDblClick = ListBoxQueryValueFilterDblClick
            end
            object ButtonQVFilterAdd: TButton
              Left = 171
              Top = 23
              Width = 71
              Height = 25
              Caption = #22686#21152'(&A)'
              TabOrder = 1
              OnClick = ButtonQVFilterAddClick
            end
            object ButtonQVFilterDel: TButton
              Left = 171
              Top = 55
              Width = 71
              Height = 25
              Caption = #21024#38500'(&D)'
              Enabled = False
              TabOrder = 2
              OnClick = ButtonQVFilterDelClick
            end
            object ButtonQVFilterMod: TButton
              Left = 171
              Top = 87
              Width = 71
              Height = 25
              Caption = #20462#25913'(&M)'
              Enabled = False
              TabOrder = 3
              OnClick = ButtonQVFilterModClick
            end
            object ButtonQVFilterSave: TButton
              Left = 171
              Top = 119
              Width = 71
              Height = 25
              Caption = #20445#23384'(&S)'
              TabOrder = 4
            end
          end
          object GroupBoxGuildRankNameFilter: TGroupBox
            Left = 6
            Top = 8
            Width = 251
            Height = 321
            Caption = #23383#31526#36807#28388'('#34892#20250#23553#21495'/'#20998#36523#21517#23383'/@@SENDMSG)'
            TabOrder = 1
            object ListBoxGuildRankNameFilter: TListBox
              Left = 8
              Top = 19
              Width = 153
              Height = 294
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxGuildRankNameFilterClick
              OnDblClick = ListBoxGuildRankNameFilterDblClick
            end
            object ButtonGuildRankNameFilterAdd: TButton
              Left = 171
              Top = 23
              Width = 71
              Height = 25
              Caption = #22686#21152'(&A)'
              TabOrder = 1
              OnClick = ButtonQVFilterAddClick
            end
            object ButtonGuildRankNameFilterDel: TButton
              Left = 171
              Top = 55
              Width = 71
              Height = 25
              Caption = #21024#38500'(&D)'
              Enabled = False
              TabOrder = 2
              OnClick = ButtonGuildRankNameFilterDelClick
            end
            object ButtonGuildRankNameFilterMob: TButton
              Left = 171
              Top = 87
              Width = 71
              Height = 25
              Caption = #20462#25913'(&M)'
              Enabled = False
              TabOrder = 3
              OnClick = ButtonGuildRankNameFilterMobClick
            end
            object ButtonGuildRankNameFilterSave: TButton
              Left = 171
              Top = 119
              Width = 71
              Height = 25
              Caption = #20445#23384'(&S)'
              TabOrder = 4
              OnClick = ButtonGuildRankNameFilterSaveClick
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = #33521#38596#25441#21462#29289#21697
          ImageIndex = 2
          object GroupBox3: TGroupBox
            Left = 320
            Top = 2
            Width = 201
            Height = 325
            Caption = #29289#21697#21015#34920
            TabOrder = 0
            object ListBoxItemList: TListBox
              Left = 8
              Top = 23
              Width = 185
              Height = 294
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxItemListClick
            end
          end
          object GroupBox10: TGroupBox
            Left = 8
            Top = 2
            Width = 201
            Height = 325
            Caption = #21487#20197#25441#21462#29289#21697#21015#34920
            TabOrder = 1
            object ListBoxPetPickUpItemList: TListBox
              Left = 8
              Top = 24
              Width = 185
              Height = 293
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxPetPickUpItemListClick
            end
          end
          object ButtonPetPickUpItemAdd: TButton
            Left = 224
            Top = 30
            Width = 81
            Height = 25
            Caption = #22686#21152'(&A)'
            TabOrder = 2
            OnClick = ButtonPetPickUpItemAddClick
          end
          object ButtonPetPickUpItemDel: TButton
            Left = 224
            Top = 62
            Width = 81
            Height = 25
            Caption = #21024#38500'(&D)'
            TabOrder = 3
            OnClick = ButtonPetPickUpItemDelClick
          end
          object ButtonPetPickUpItemAddAll: TButton
            Left = 224
            Top = 94
            Width = 81
            Height = 25
            Caption = #20840#37096#22686#21152'(&A)'
            TabOrder = 4
            OnClick = ButtonPetPickUpItemAddAllClick
          end
          object ButtonPetPickUpItemDelAll: TButton
            Left = 224
            Top = 126
            Width = 81
            Height = 25
            Caption = #20840#37096#21024#38500'(&D)'
            TabOrder = 5
            OnClick = ButtonPetPickUpItemDelAllClick
          end
          object ButtonPetPickUpItemSave: TButton
            Left = 224
            Top = 158
            Width = 81
            Height = 25
            Caption = #20445#23384'(&S)'
            TabOrder = 6
            OnClick = ButtonPetPickUpItemSaveClick
          end
        end
        object TabSheet9: TTabSheet
          Caption = #33258#23450#20041#21629#20196#21015#34920
          ImageIndex = 4
          object GroupBoxUserCmd: TGroupBox
            Left = 8
            Top = 12
            Width = 353
            Height = 317
            Caption = #33258#23450#20041#21629#20196#21015#34920
            TabOrder = 0
            object Label26: TLabel
              Left = 176
              Top = 26
              Width = 54
              Height = 12
              Caption = #21629#20196#21517#31216':'
            end
            object Label27: TLabel
              Left = 176
              Top = 52
              Width = 54
              Height = 12
              Caption = #21629#20196#32534#21495':'
            end
            object ListBoxUserCmd: TListBox
              Left = 8
              Top = 23
              Width = 161
              Height = 282
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxUserCmdClick
            end
            object EditUserCmd: TEdit
              Left = 232
              Top = 22
              Width = 105
              Height = 20
              MaxLength = 50
              TabOrder = 1
            end
            object SpinEditUserCmd: TSpinEdit
              Left = 232
              Top = 47
              Width = 105
              Height = 21
              MaxValue = 99999
              MinValue = 0
              TabOrder = 2
              Value = 10
            end
            object ButtonUserCmdAdd: TButton
              Left = 264
              Top = 218
              Width = 73
              Height = 23
              Caption = #22686#21152'(&A)'
              TabOrder = 3
              OnClick = ButtonUserCmdAddClick
            end
            object ButtonUserCmdDel: TButton
              Left = 264
              Top = 247
              Width = 73
              Height = 23
              Caption = #21024#38500'(&D)'
              TabOrder = 4
              OnClick = ButtonUserCmdDelClick
            end
            object ButtonUserCmdSav: TButton
              Left = 264
              Top = 276
              Width = 73
              Height = 23
              Caption = #20445#23384'(&S)'
              TabOrder = 5
              OnClick = ButtonUserCmdSavClick
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = #39044#30041#21151#33021#21015#34920
          ImageIndex = 3
          object GroupBox20: TGroupBox
            Left = 8
            Top = 2
            Width = 201
            Height = 325
            Caption = #20801#35768'XXX'#30340#29289#21697#21015#34920'('#22810#36873')'
            TabOrder = 0
            object ListBoxUpgradeItemList: TListBox
              Left = 8
              Top = 24
              Width = 185
              Height = 293
              ItemHeight = 12
              MultiSelect = True
              TabOrder = 0
              OnClick = ListBoxUpgradeItemListClick
            end
          end
          object GroupBox21: TGroupBox
            Left = 320
            Top = 2
            Width = 201
            Height = 325
            Caption = #29289#21697#21015#34920
            TabOrder = 1
            object ListBoxItemListAll: TListBox
              Left = 8
              Top = 23
              Width = 185
              Height = 294
              ItemHeight = 12
              TabOrder = 0
              OnClick = ListBoxItemListAllClick
            end
          end
          object ButtonUpgradeItemAdd: TButton
            Left = 224
            Top = 30
            Width = 81
            Height = 25
            Caption = #22686#21152'(&A)'
            TabOrder = 2
            OnClick = ButtonUpgradeItemAddClick
          end
          object ButtonUpgradeItemDel: TButton
            Left = 224
            Top = 62
            Width = 81
            Height = 25
            Caption = #21024#38500'(&D)'
            TabOrder = 3
            OnClick = ButtonUpgradeItemDelClick
          end
          object ButtonUpgradeItemAddAll: TButton
            Left = 224
            Top = 94
            Width = 81
            Height = 25
            Caption = #20840#37096#22686#21152'(&A)'
            TabOrder = 4
            OnClick = ButtonUpgradeItemAddAllClick
          end
          object ButtonUpgradeItemDelAll: TButton
            Left = 224
            Top = 126
            Width = 81
            Height = 25
            Caption = #20840#37096#21024#38500'(&D)'
            TabOrder = 5
            OnClick = ButtonUpgradeItemDelAllClick
          end
          object ButtonUpgradeItemSave: TButton
            Left = 224
            Top = 158
            Width = 81
            Height = 25
            Caption = #20445#23384'(&S)'
            TabOrder = 6
            OnClick = ButtonUpgradeItemSaveClick
          end
        end
        object tabSheetStartPointCustom: TTabSheet
          Caption = #33258#23450#20041#23433#20840#21306#20809#22280#29305#25928
          ImageIndex = 5
          TabVisible = False
          object lvStartPointCustom: TListView
            Left = 10
            Top = 10
            Width = 655
            Height = 231
            Columns = <
              item
                Caption = #24207#21495
              end
              item
                Caption = #29305#25928#31867#22411#32534#21495
                Width = 90
              end
              item
                Caption = #29305#25928#25991#20214
                Width = 200
              end
              item
                Caption = #36215#22987#32034#24341#36126
                Width = 80
              end
              item
                Caption = #32467#26463#32034#24341#36126
                Width = 80
              end
              item
                Caption = #36879#26126#32472#21046
                Width = 60
              end>
            GridLines = True
            MultiSelect = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnClick = ListViewShopItemListClick
          end
          object btn1: TButton
            Left = 121
            Top = 303
            Width = 95
            Height = 21
            Caption = #22686#21152'(&A)'
            Enabled = False
            TabOrder = 1
          end
          object btn2: TButton
            Left = 232
            Top = 303
            Width = 95
            Height = 21
            Caption = #21024#38500'(&D)'
            TabOrder = 2
          end
          object btn3: TButton
            Left = 344
            Top = 304
            Width = 95
            Height = 21
            Caption = #20445#23384'(&S)'
            TabOrder = 3
          end
          object btn4: TButton
            Left = 461
            Top = 304
            Width = 95
            Height = 21
            Caption = #37325#26032#21152#36733
            Enabled = False
            TabOrder = 4
          end
        end
      end
    end
  end
  object PopupMenuFindItemName: TPopupMenu
    Left = 280
    Top = 288
    object PopupMenu_FINDITEMBYNAME: TMenuItem
      Caption = #26597#25214#29289#21697'(&F)'
      OnClick = PopupMenu_FINDITEMBYNAMEClick
    end
  end
end
