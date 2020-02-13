object frmCastleManage: TfrmCastleManage
  Left = 277
  Top = 323
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #22478#22561#31649#29702
  ClientHeight = 297
  ClientWidth = 569
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 193
    Height = 281
    Caption = #22478#22561#21015#34920
    TabOrder = 0
    object ListViewCastle: TListView
      Left = 8
      Top = 16
      Width = 177
      Height = 257
      Columns = <
        item
          Caption = #24207#21495
          Width = 40
        end
        item
          Caption = #32534#21495
          Width = 40
        end
        item
          Caption = #21517#31216
          Width = 93
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewCastleClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 208
    Top = 8
    Width = 353
    Height = 281
    Caption = #22478#22561#20449#24687
    TabOrder = 1
    object PageControlCastle: TPageControl
      Left = 8
      Top = 16
      Width = 337
      Height = 257
      ActivePage = TabSheet3
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #22522#26412#29366#24577
        object GroupBox3: TGroupBox
          Left = 5
          Top = 5
          Width = 321
          Height = 96
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 20
            Width = 54
            Height = 12
            Caption = #25152#23646#34892#20250':'
          end
          object Label1: TLabel
            Left = 8
            Top = 44
            Width = 54
            Height = 12
            Caption = #36164#37329#24635#25968':'
          end
          object Label3: TLabel
            Left = 8
            Top = 68
            Width = 54
            Height = 12
            Caption = #24403#22825#25910#20837':'
          end
          object Label7: TLabel
            Left = 191
            Top = 44
            Width = 30
            Height = 12
            Caption = #31561#32423':'
          end
          object Label8: TLabel
            Left = 191
            Top = 68
            Width = 30
            Height = 12
            Caption = #33021#28304':'
          end
          object Label12: TLabel
            Left = 191
            Top = 20
            Width = 30
            Height = 12
            Caption = #29366#24577':'
          end
          object EditOwenGuildName: TEdit
            Left = 64
            Top = 16
            Width = 89
            Height = 20
            TabOrder = 0
          end
          object EditTotalGold: TSpinEdit
            Left = 64
            Top = 40
            Width = 89
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 1
            Value = 0
          end
          object EditTodayIncome: TSpinEdit
            Left = 64
            Top = 64
            Width = 89
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 3
            Value = 0
          end
          object EditTechLevel: TSpinEdit
            Left = 223
            Top = 40
            Width = 57
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 2
            Value = 0
          end
          object EditPower: TSpinEdit
            Left = 223
            Top = 64
            Width = 57
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 4
            Value = 0
          end
          object EditStatus: TEdit
            Left = 223
            Top = 16
            Width = 89
            Height = 20
            Enabled = False
            TabOrder = 5
          end
        end
        object btnStartWarNow: TButton
          Left = 154
          Top = 199
          Width = 81
          Height = 23
          Caption = #24320#22987#25915#22478
          Enabled = False
          TabOrder = 1
          OnClick = btnStartWarNowClick
        end
        object btnStopWarNow: TButton
          Left = 241
          Top = 199
          Width = 81
          Height = 23
          Caption = #20572#27490#25915#22478
          Enabled = False
          TabOrder = 2
          OnClick = btnStopWarNowClick
        end
      end
      object TabSheet3: TTabSheet
        Caption = #23432#21355#29366#24577
        ImageIndex = 2
        object GroupBox5: TGroupBox
          Left = 5
          Top = 0
          Width = 318
          Height = 225
          TabOrder = 0
          object ListViewGuard: TListView
            Left = 8
            Top = 16
            Width = 300
            Height = 169
            Columns = <
              item
                Caption = #24207#21495
                Width = 40
              end
              item
                Caption = #21517#31216
                Width = 100
              end
              item
                Caption = #24231#26631
                Width = 80
              end
              item
                Caption = #34880#37327
                Width = 80
              end
              item
                Caption = #22478#38376#29366#24577
                Width = 60
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
          end
          object ButtonRefresh: TButton
            Left = 224
            Top = 192
            Width = 81
            Height = 23
            Caption = #21047#26032'(&R)'
            TabOrder = 1
            OnClick = ButtonRefreshClick
          end
        end
      end
      object TabSheet4: TTabSheet
        Caption = #25915#22478#30003#35831
        ImageIndex = 3
        object ListViewWar: TListView
          Left = 0
          Top = 0
          Width = 329
          Height = 189
          Columns = <
            item
              Caption = #24207#21495
            end
            item
              Caption = #34892#20250#21517#31216
              Width = 150
            end
            item
              Caption = #25915#22478#26102#38388
              Width = 125
            end>
          GridLines = True
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
          OnClick = ListViewWarClick
        end
        object ButtonAdd: TButton
          Left = 32
          Top = 199
          Width = 81
          Height = 23
          Caption = #22686#21152'(&A)'
          Enabled = False
          TabOrder = 1
          OnClick = ButtonAddClick
        end
        object ButtonMod: TButton
          Left = 125
          Top = 199
          Width = 81
          Height = 23
          Caption = #32534#36753'(&M)'
          Enabled = False
          TabOrder = 2
          OnClick = ButtonModClick
        end
        object ButtonDel: TButton
          Left = 217
          Top = 199
          Width = 81
          Height = 23
          Caption = #21024#38500'(&D)'
          Enabled = False
          TabOrder = 3
          OnClick = ButtonDelClick
        end
      end
      object TabSheet2: TTabSheet
        Caption = #35774#32622
        ImageIndex = 1
        object GroupBox4: TGroupBox
          Left = 5
          Top = 5
          Width = 321
          Height = 100
          TabOrder = 0
          object Label4: TLabel
            Left = 8
            Top = 20
            Width = 54
            Height = 12
            Caption = #22478#22561#21517#31216':'
          end
          object Label5: TLabel
            Left = 8
            Top = 44
            Width = 54
            Height = 12
            Caption = #25152#23646#34892#20250':'
          end
          object Label6: TLabel
            Left = 168
            Top = 20
            Width = 54
            Height = 12
            Caption = #22238#22478#22320#22270':'
          end
          object Label9: TLabel
            Left = 168
            Top = 44
            Width = 54
            Height = 12
            Caption = #22238#22478#22352#26631':'
          end
          object Label10: TLabel
            Left = 8
            Top = 68
            Width = 54
            Height = 12
            Caption = #30343#23467#22320#22270':'
          end
          object Label11: TLabel
            Left = 168
            Top = 68
            Width = 54
            Height = 12
            Caption = #23494#36947#22320#22270':'
          end
          object EditCastleName: TEdit
            Left = 64
            Top = 16
            Width = 81
            Height = 20
            TabOrder = 0
            OnChange = EditCastleNameChange
          end
          object EditCastleGuild: TEdit
            Left = 64
            Top = 40
            Width = 81
            Height = 20
            TabOrder = 2
            OnChange = EditCastleNameChange
          end
          object EditCastleHome: TEdit
            Left = 224
            Top = 16
            Width = 81
            Height = 20
            TabOrder = 1
            OnChange = EditCastleNameChange
          end
          object EditCastleHomex: TEdit
            Left = 224
            Top = 40
            Width = 25
            Height = 20
            TabOrder = 3
            Text = '0'
            OnChange = EditCastleNameChange
          end
          object EditCastleHuang: TEdit
            Left = 64
            Top = 64
            Width = 81
            Height = 20
            TabOrder = 7
            OnChange = EditCastleNameChange
          end
          object EditCastleMiDao: TEdit
            Left = 224
            Top = 64
            Width = 81
            Height = 20
            TabOrder = 8
            OnChange = EditCastleNameChange
          end
          object UpDown1: TUpDown
            Left = 249
            Top = 40
            Width = 16
            Height = 20
            Associate = EditCastleHomex
            Max = 800
            TabOrder = 4
          end
          object UpDown2: TUpDown
            Left = 289
            Top = 40
            Width = 16
            Height = 20
            Associate = EditCastleHomey
            Max = 800
            TabOrder = 6
          end
          object EditCastleHomey: TEdit
            Left = 264
            Top = 40
            Width = 25
            Height = 20
            TabOrder = 5
            Text = '0'
            OnChange = EditCastleNameChange
          end
        end
        object ButtonCastleSave: TButton
          Left = 240
          Top = 199
          Width = 81
          Height = 23
          Caption = #20445#23384'(&S)'
          Enabled = False
          TabOrder = 1
          OnClick = ButtonCastleSaveClick
        end
      end
    end
  end
end
