object frmEditRcd: TfrmEditRcd
  Left = 430
  Top = 464
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #32534#36753#20154#29289#25968#25454
  ClientHeight = 353
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 609
    Height = 307
    ActivePage = TabSheet2
    TabOrder = 0
    object TabSheet2: TTabSheet
      Caption = #20154#29289#25968#25454
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 8
        Top = 8
        Width = 585
        Height = 265
        TabOrder = 0
        object Label6: TLabel
          Left = 240
          Top = 20
          Width = 30
          Height = 12
          Caption = #31561#32423':'
        end
        object Label7: TLabel
          Left = 240
          Top = 44
          Width = 30
          Height = 12
          Caption = #37329#24065':'
        end
        object Label8: TLabel
          Left = 240
          Top = 68
          Width = 30
          Height = 12
          Caption = #20803#23453':'
        end
        object Label9: TLabel
          Left = 240
          Top = 92
          Width = 42
          Height = 12
          Caption = #28216#25103#28857':'
        end
        object Label16: TLabel
          Left = 240
          Top = 140
          Width = 42
          Height = 12
          Caption = #22768#26395#28857':'
        end
        object Label10: TLabel
          Left = 240
          Top = 116
          Width = 42
          Height = 12
          Caption = #20805#20540#28857':'
        end
        object Label17: TLabel
          Left = 240
          Top = 164
          Width = 30
          Height = 12
          Caption = 'PK'#28857':'
        end
        object Label18: TLabel
          Left = 240
          Top = 188
          Width = 42
          Height = 12
          Caption = #36129#29486#24230':'
        end
        object Label11: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #32034#24341#21495#30721':'
        end
        object Label1: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #20154#29289#21517#31216':'
        end
        object Label2: TLabel
          Left = 8
          Top = 68
          Width = 54
          Height = 12
          Caption = #30331#24405#24080#21495':'
        end
        object Label3: TLabel
          Left = 8
          Top = 92
          Width = 54
          Height = 12
          Caption = #20179#24211#23494#30721':'
        end
        object Label4: TLabel
          Left = 8
          Top = 116
          Width = 54
          Height = 12
          Caption = #37197#20598#21517#31216':'
        end
        object Label5: TLabel
          Left = 8
          Top = 140
          Width = 54
          Height = 12
          Caption = #24072#24466#21517#31216':'
        end
        object Label12: TLabel
          Left = 8
          Top = 164
          Width = 54
          Height = 12
          Caption = #24403#21069#22320#22270':'
        end
        object Label13: TLabel
          Left = 8
          Top = 188
          Width = 54
          Height = 12
          Caption = #24403#21069#24231#26631':'
        end
        object Label14: TLabel
          Left = 8
          Top = 212
          Width = 54
          Height = 12
          Caption = #22238#22478#22320#22270':'
        end
        object Label15: TLabel
          Left = 8
          Top = 236
          Width = 54
          Height = 12
          Caption = #22238#22478#24231#26631':'
        end
        object Label19: TLabel
          Left = 232
          Top = 212
          Width = 54
          Height = 12
          Caption = #33521#38596#21517#31216':'
        end
        object Label20: TLabel
          Left = 232
          Top = 236
          Width = 54
          Height = 12
          Caption = #33521#38596#20027#20154':'
        end
        object Label21: TLabel
          Left = 424
          Top = 20
          Width = 30
          Height = 12
          Caption = #24615#21035':'
        end
        object Label22: TLabel
          Left = 424
          Top = 44
          Width = 30
          Height = 12
          Caption = #32844#19994':'
        end
        object EditLevel: TSpinEdit
          Left = 288
          Top = 16
          Width = 100
          Height = 21
          MaxValue = 65535
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGold: TSpinEdit
          Left = 288
          Top = 40
          Width = 100
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGameGold: TSpinEdit
          Left = 288
          Top = 64
          Width = 100
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 2
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGamePoint: TSpinEdit
          Left = 288
          Top = 88
          Width = 100
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditCreditPoint: TSpinEdit
          Left = 288
          Top = 136
          Width = 100
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 4
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditPayPoint: TSpinEdit
          Left = 288
          Top = 112
          Width = 100
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditPKPoint: TSpinEdit
          Left = 288
          Top = 160
          Width = 100
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 6
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditContribution: TSpinEdit
          Left = 288
          Top = 184
          Width = 100
          Height = 21
          Enabled = False
          MaxValue = 0
          MinValue = 0
          TabOrder = 7
          Value = 0
          OnChange = EditPasswordChange
        end
        object CheckBoxIsMaster: TCheckBox
          Left = 192
          Top = 138
          Width = 41
          Height = 17
          Caption = #24072#29238
          TabOrder = 8
          OnClick = EditPasswordChange
        end
        object EditMasterName: TEdit
          Left = 64
          Top = 136
          Width = 121
          Height = 20
          TabOrder = 9
          OnChange = EditPasswordChange
        end
        object EditDearName: TEdit
          Left = 64
          Top = 112
          Width = 121
          Height = 20
          TabOrder = 10
          OnChange = EditPasswordChange
        end
        object EditPassword: TEdit
          Left = 64
          Top = 88
          Width = 121
          Height = 20
          TabOrder = 11
          OnChange = EditPasswordChange
        end
        object EditAccount: TEdit
          Left = 64
          Top = 64
          Width = 121
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 12
        end
        object EditChrName: TEdit
          Left = 64
          Top = 40
          Width = 121
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 13
        end
        object EditIdx: TEdit
          Left = 64
          Top = 16
          Width = 121
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 14
        end
        object EditHomeX: TSpinEdit
          Left = 64
          Top = 232
          Width = 57
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 15
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditHomeY: TSpinEdit
          Left = 128
          Top = 232
          Width = 57
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 16
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditHomeMap: TEdit
          Left = 64
          Top = 208
          Width = 121
          Height = 20
          TabOrder = 17
          OnClick = EditPasswordChange
        end
        object EditCurX: TSpinEdit
          Left = 64
          Top = 184
          Width = 57
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 18
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditCurY: TSpinEdit
          Left = 128
          Top = 184
          Width = 57
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 19
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditCurMap: TEdit
          Left = 64
          Top = 160
          Width = 121
          Height = 20
          TabOrder = 20
          OnChange = EditPasswordChange
        end
        object EditHeroName: TEdit
          Left = 288
          Top = 208
          Width = 97
          Height = 20
          TabOrder = 21
          OnChange = EditPasswordChange
        end
        object EditHeroMasterName: TEdit
          Left = 288
          Top = 232
          Width = 97
          Height = 20
          TabOrder = 22
          OnChange = EditPasswordChange
        end
        object spGender: TSpinEdit
          Left = 464
          Top = 16
          Width = 100
          Height = 21
          EditorEnabled = False
          MaxValue = 1
          MinValue = 0
          TabOrder = 23
          Value = 0
          OnChange = EditPasswordChange
        end
        object spJob: TSpinEdit
          Left = 464
          Top = 40
          Width = 100
          Height = 21
          EditorEnabled = False
          MaxValue = 2
          MinValue = 0
          TabOrder = 24
          Value = 0
          OnChange = EditPasswordChange
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #25216#33021#21015#34920
      ImageIndex = 2
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 585
        Height = 265
        TabOrder = 0
        object ListViewMagic: TListView
          Left = 8
          Top = 16
          Width = 569
          Height = 241
          Columns = <
            item
              Caption = #24207#21495
              Width = 40
            end
            item
              Caption = #25216#33021'ID'
              Width = 62
            end
            item
              Caption = #25216#33021#21517#31216
              Width = 100
            end
            item
              Caption = #31561#32423
              Width = 62
            end
            item
              Caption = #20462#28860#28857
              Width = 90
            end
            item
              Caption = #24555#25463#38190
              Width = 80
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = #35013#22791#21015#34920
      ImageIndex = 3
      object GroupBox4: TGroupBox
        Left = 8
        Top = 8
        Width = 585
        Height = 265
        TabOrder = 0
        object ListViewUserItem: TListView
          Left = 8
          Top = 16
          Width = 569
          Height = 241
          Columns = <
            item
              Caption = #24207#21495
              Width = 40
            end
            item
              Caption = #26631#35782#24207#21495
              Width = 80
            end
            item
              Caption = #29289#21697'ID'
              Width = 60
            end
            item
              Caption = #29289#21697#21517#31216
              Width = 100
            end
            item
              Alignment = taCenter
              Caption = #25345#20037
              Width = 90
            end
            item
              Caption = #21442#25968
              Width = 190
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #20179#24211#29289#21697
      ImageIndex = 4
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 585
        Height = 265
        TabOrder = 0
        object ListViewStorage: TListView
          Left = 8
          Top = 16
          Width = 569
          Height = 241
          Columns = <
            item
              Caption = #24207#21495
              Width = 40
            end
            item
              Caption = #26631#35782#24207#21495
              Width = 80
            end
            item
              Caption = #29289#21697'ID'
              Width = 60
            end
            item
              Caption = #29289#21697#21517#31216
              Width = 100
            end
            item
              Alignment = taCenter
              Caption = #25345#20037
              Width = 90
            end
            item
              Caption = #21442#25968
              Width = 190
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
  end
  object ButtonSaveData: TButton
    Left = 520
    Top = 322
    Width = 89
    Height = 25
    Caption = #20445#23384#20462#25913'(&S)'
    TabOrder = 1
    OnClick = ButtonExportDataClick
  end
  object ButtonExportData: TButton
    Left = 328
    Top = 322
    Width = 89
    Height = 25
    Caption = #23548#20986#25968#25454'(&E)'
    TabOrder = 2
    OnClick = ButtonExportDataClick
  end
  object ButtonImportData: TButton
    Left = 424
    Top = 322
    Width = 89
    Height = 25
    Caption = #23548#20837#25968#25454'(&I)'
    TabOrder = 3
    OnClick = ButtonExportDataClick
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'hum'
    Filter = #20154#29289#25968#25454' (*.hum)|*.hum'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 536
    Top = 160
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'hum'
    Filter = #20154#29289#25968#25454' (*.hum)|*.hum'
    Left = 504
    Top = 160
  end
end
