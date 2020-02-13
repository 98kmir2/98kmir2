object FrmFunctionConfig: TFrmFunctionConfig
  Left = 356
  Top = 141
  BorderStyle = bsDialog
  Caption = #21151#33021#35774#32622
  ClientHeight = 379
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #26032#23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label14: TLabel
    Left = 8
    Top = 359
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
    Height = 337
    ActivePage = TabSheet2
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = #33258#23450#20041#21629#20196
      ImageIndex = 1
      object Label3: TLabel
        Left = 216
        Top = 168
        Width = 60
        Height = 12
        Caption = #21629#20196#21517#31216#65306
      end
      object Label4: TLabel
        Left = 216
        Top = 192
        Width = 60
        Height = 12
        Caption = #21629#20196#32534#21495#65306
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 201
        Height = 297
        Caption = #33258#23450#20041#21629#20196#21015#34920
        TabOrder = 0
        object ListBoxUserCommand: TListBox
          Left = 8
          Top = 16
          Width = 185
          Height = 273
          ItemHeight = 12
          TabOrder = 0
          OnClick = ListBoxUserCommandClick
        end
      end
      object EditCommandName: TEdit
        Left = 280
        Top = 164
        Width = 161
        Height = 20
        TabOrder = 1
      end
      object ButtonUserCommandAdd: TButton
        Left = 288
        Top = 216
        Width = 75
        Height = 25
        Caption = #22686#21152'(&A)'
        TabOrder = 2
        OnClick = ButtonUserCommandAddClick
      end
      object SpinEditCommandIdx: TSpinEdit
        Left = 280
        Top = 188
        Width = 161
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 3
        Value = 0
      end
      object ButtonUserCommandDel: TButton
        Left = 368
        Top = 216
        Width = 75
        Height = 25
        Caption = #21024#38500'(&D)'
        TabOrder = 4
        OnClick = ButtonUserCommandDelClick
      end
      object ButtonUserCommandChg: TButton
        Left = 288
        Top = 248
        Width = 75
        Height = 25
        Caption = #20462#25913'(&C)'
        TabOrder = 5
        OnClick = ButtonUserCommandChgClick
      end
      object ButtonUserCommandSave: TButton
        Left = 368
        Top = 248
        Width = 75
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 6
        OnClick = ButtonUserCommandSaveClick
      end
      object ButtonLoadUserCommandList: TButton
        Left = 288
        Top = 280
        Width = 153
        Height = 25
        Caption = #37325#26032#21152#36733#33258#23450#20041#21629#20196#21015#34920
        TabOrder = 7
        OnClick = ButtonLoadUserCommandListClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = #31105#27490#29289#21697#35774#32622
      ImageIndex = 2
      object GroupBox21: TGroupBox
        Left = 288
        Top = 8
        Width = 157
        Height = 233
        Caption = #29289#21697#21015#34920
        TabOrder = 0
        object ListBoxitemList: TListBox
          Left = 8
          Top = 16
          Width = 137
          Height = 209
          Hint = #21452#20987#22686#21152#29289#21697#21040#31105#27490#29289#21697#21015#34920
          ItemHeight = 12
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnDblClick = ListBoxitemListDblClick
        end
      end
      object ButtonDisallowDel: TButton
        Left = 288
        Top = 248
        Width = 75
        Height = 25
        Caption = #21024#38500'(&D)'
        TabOrder = 1
        OnClick = ButtonDisallowDelClick
      end
      object ButtonDisallowSave: TButton
        Left = 368
        Top = 248
        Width = 75
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 2
        OnClick = ButtonDisallowSaveClick
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 265
        Caption = #31105#27490#29289#21697#21015#34920
        TabOrder = 3
        object ListViewDisallow: TListView
          Left = 8
          Top = 16
          Width = 257
          Height = 241
          Hint = '0'#20026#20801#35768' 1'#20026#31105#27490
          Columns = <
            item
              Caption = #29289#21697#21517#31216
              Width = 60
            end
            item
              Caption = #31105#27490#20173
              Width = 60
            end
            item
              Caption = #31105#27490#20132#26131
              Width = 60
            end
            item
              Caption = #31105#27490#23384
              Width = 60
            end
            item
              Caption = #31105#27490#20462#29702
              Width = 60
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          ViewStyle = vsReport
          OnClick = ListViewDisallowClick
        end
      end
      object ButtonDisallowDrop: TButton
        Left = 8
        Top = 280
        Width = 65
        Height = 25
        Caption = #31105#27490#20173
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #26032#23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = ButtonDisallowDropClick
      end
      object ButtonDisallowDeal: TButton
        Left = 72
        Top = 280
        Width = 65
        Height = 25
        Caption = #31105#27490#20132#26131
        TabOrder = 5
        OnClick = ButtonDisallowDealClick
      end
      object ButtonDisallowStorage: TButton
        Left = 136
        Top = 280
        Width = 65
        Height = 25
        Caption = #31105#27490#23384
        TabOrder = 6
        OnClick = ButtonDisallowStorageClick
      end
      object ButtonDisallowRepair: TButton
        Left = 200
        Top = 280
        Width = 65
        Height = 25
        Caption = #31105#27490#20462#29702
        TabOrder = 7
        OnClick = ButtonDisallowRepairClick
      end
      object ButtonLoadCheckItemList: TButton
        Left = 288
        Top = 280
        Width = 153
        Height = 25
        Caption = #37325#26032#21152#36733#31105#27490#29289#21697#37197#32622
        TabOrder = 8
        OnClick = ButtonLoadCheckItemListClick
      end
    end
    object TabSheet5: TTabSheet
      Caption = #28040#24687#36807#28388
      ImageIndex = 4
      object GroupBox22: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 161
        Caption = #28040#24687#36807#28388#21015#34920
        TabOrder = 0
        object ListViewMsgFilter: TListView
          Left = 8
          Top = 16
          Width = 417
          Height = 137
          Columns = <
            item
              Caption = #36807#28388#28040#24687
              Width = 200
            end
            item
              Caption = #26367#25442#28040#24687
              Width = 200
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnClick = ListViewMsgFilterClick
        end
      end
      object GroupBox23: TGroupBox
        Left = 8
        Top = 176
        Width = 433
        Height = 81
        Caption = #28040#24687#36807#28388#21015#34920#32534#36753
        TabOrder = 1
        object Label22: TLabel
          Left = 8
          Top = 24
          Width = 60
          Height = 12
          Caption = #36807#28388#28040#24687#65306
        end
        object Label23: TLabel
          Left = 8
          Top = 48
          Width = 60
          Height = 12
          Caption = #26367#25442#28040#24687#65306
        end
        object EditFilterMsg: TEdit
          Left = 72
          Top = 20
          Width = 353
          Height = 20
          TabOrder = 0
        end
        object EditNewMsg: TEdit
          Left = 72
          Top = 44
          Width = 353
          Height = 20
          TabOrder = 1
        end
      end
      object ButtonMsgFilterAdd: TButton
        Left = 8
        Top = 272
        Width = 65
        Height = 25
        Caption = #22686#21152'(&A)'
        TabOrder = 2
        OnClick = ButtonMsgFilterAddClick
      end
      object ButtonMsgFilterDel: TButton
        Left = 80
        Top = 272
        Width = 65
        Height = 25
        Caption = #21024#38500'(&D)'
        TabOrder = 3
        OnClick = ButtonMsgFilterDelClick
      end
      object ButtonMsgFilterSave: TButton
        Left = 224
        Top = 272
        Width = 65
        Height = 25
        Caption = #20445#23384'(&S)'
        TabOrder = 4
        OnClick = ButtonMsgFilterSaveClick
      end
      object ButtonMsgFilterChg: TButton
        Left = 152
        Top = 272
        Width = 65
        Height = 25
        Caption = #20462#25913'(&C)'
        TabOrder = 5
        OnClick = ButtonMsgFilterChgClick
      end
      object ButtonLoadMsgFilterList: TButton
        Left = 296
        Top = 272
        Width = 145
        Height = 25
        Caption = #37325#26032#21152#36733#28040#24687#36807#28388#21015#34920
        TabOrder = 6
        OnClick = ButtonLoadMsgFilterListClick
      end
    end
  end
end
