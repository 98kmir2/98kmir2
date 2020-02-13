object frmGeneralConfig: TfrmGeneralConfig
  Left = 205
  Top = 250
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #22522#26412#35774#32622
  ClientHeight = 280
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 12
  object Label26: TLabel
    Left = 10
    Top = 263
    Width = 312
    Height = 12
    Caption = #35843#25972#30340#21442#25968#22312#20445#23384#21518#29983#25928#65292#37096#20221#21442#25968#24517#39035#37325#21551#31243#24207#25165#20250#29983#25928
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 401
    Height = 252
    ActivePage = ShareSheet
    TabOrder = 0
    OnChanging = PageControlChanging
    object NetWorkSheet: TTabSheet
      Caption = #32593#32476#35774#32622
      ImageIndex = 2
      object GroupBoxNet: TGroupBox
        Left = 8
        Top = 5
        Width = 185
        Height = 68
        Caption = #32593#32476#25509#21475
        TabOrder = 0
        object LabelGateIPaddr: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #32465#23450#22320#22336':'
        end
        object LabelGatePort: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #32593#20851#31471#21475':'
        end
        object EditGateAddr: TEdit
          Left = 80
          Top = 16
          Width = 97
          Height = 20
          Hint = #28216#25103#32593#20851#36830#25509#31471#21475#32465#23450'IP'#65292#27492#37197#32622#19968#33324#29992#20110#22810'IP'#29615#22659#65292#26222#36890#29615#22659#21482#38656#35774#32622#20026'0.0.0.0'#12290
          TabOrder = 0
          Text = '127.0.0.1'
          OnChange = EditValueChange
        end
        object EditGatePort: TEdit
          Left = 80
          Top = 40
          Width = 41
          Height = 20
          Hint = #28216#25103#32593#20851#36830#25509#31471#21475#65292#27492#31471#21475#40664#35748#20026'5000'#12290
          TabOrder = 1
          Text = '5000'
          OnChange = EditValueChange
        end
      end
      object ButtonNetWorkSave: TButton
        Left = 320
        Top = 195
        Width = 65
        Height = 23
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonNetWorkSaveClick
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 78
        Width = 185
        Height = 68
        Caption = #25968#25454#24211#26381#21153#22120
        TabOrder = 2
        object Label4: TLabel
          Left = 8
          Top = 44
          Width = 66
          Height = 12
          Caption = #26381#21153#22120#31471#21475':'
        end
        object Label5: TLabel
          Left = 8
          Top = 20
          Width = 66
          Height = 12
          Caption = #26381#21153#22120#22320#22336':'
        end
        object EditDBPort: TEdit
          Left = 80
          Top = 40
          Width = 41
          Height = 20
          Hint = #20154#29289#25968#25454#24211#26381#21153#22120#36830#25509#31471#21475#12290
          TabOrder = 0
          Text = '6000'
          OnChange = EditValueChange
        end
        object EditDBAddr: TEdit
          Left = 80
          Top = 16
          Width = 97
          Height = 20
          Hint = #20154#29289#25968#25454#24211#26381#21153#22120'IP'#22320#22336#12290
          TabOrder = 1
          Text = '127.0.0.1'
          OnChange = EditValueChange
        end
      end
      object GroupBox2: TGroupBox
        Left = 200
        Top = 5
        Width = 185
        Height = 68
        Caption = #30331#24405#26381#21153#22120
        TabOrder = 3
        object Label2: TLabel
          Left = 8
          Top = 44
          Width = 66
          Height = 12
          Caption = #26381#21153#22120#31471#21475':'
        end
        object Label3: TLabel
          Left = 8
          Top = 20
          Width = 66
          Height = 12
          Caption = #26381#21153#22120#22320#22336':'
        end
        object EditIDSPort: TEdit
          Left = 80
          Top = 40
          Width = 41
          Height = 20
          Hint = #31649#29702#26381#21153#22120#31471#21475#12290
          TabOrder = 0
          Text = '5600'
          OnChange = EditValueChange
        end
        object EditIDSAddr: TEdit
          Left = 80
          Top = 16
          Width = 97
          Height = 20
          Hint = #31649#29702#26381#21153#22120'IP'#22320#22336#12290
          TabOrder = 1
          Text = '127.0.0.1'
          OnChange = EditValueChange
        end
      end
      object GroupBox3: TGroupBox
        Left = 200
        Top = 78
        Width = 185
        Height = 68
        Caption = #26085#24535#26381#21153#22120
        TabOrder = 4
        object Label6: TLabel
          Left = 8
          Top = 44
          Width = 66
          Height = 12
          Caption = #26381#21153#22120#31471#21475':'
        end
        object Label7: TLabel
          Left = 8
          Top = 20
          Width = 66
          Height = 12
          Caption = #26381#21153#22120#22320#22336':'
        end
        object EditLogServerPort: TEdit
          Left = 80
          Top = 40
          Width = 41
          Height = 20
          Hint = #28216#25103#26085#24535#26381#21153#22120#31471#21475#12290
          TabOrder = 0
          Text = '10000'
          OnChange = EditValueChange
        end
        object EditLogServerAddr: TEdit
          Left = 80
          Top = 16
          Width = 97
          Height = 20
          Hint = #28216#25103#26085#24535#26381#21153#22120'IP'#22320#22336#12290
          TabOrder = 1
          Text = '127.0.0.1'
          OnChange = EditValueChange
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 151
        Width = 185
        Height = 68
        Caption = #28216#25103#20027#26381#21153#22120
        TabOrder = 5
        object Label8: TLabel
          Left = 8
          Top = 44
          Width = 66
          Height = 12
          Caption = #26381#21153#22120#31471#21475':'
        end
        object Label9: TLabel
          Left = 8
          Top = 20
          Width = 66
          Height = 12
          Caption = #26381#21153#22120#22320#22336':'
        end
        object EditMsgSrvPort: TEdit
          Left = 80
          Top = 40
          Width = 41
          Height = 20
          Hint = #20027#28216#25103#26381#21153#22120#31471#21475#65292#27492#35774#32622#29992#20110#22810#26381#21153#22120#36127#36733#29615#22659#20351#29992#12290#26222#36890#29615#22659#19981#38656#35201#26356#25913#27492#35774#32622#12290
          TabOrder = 0
          Text = '4900'
          OnChange = EditValueChange
        end
        object EditMsgSrvAddr: TEdit
          Left = 80
          Top = 16
          Width = 97
          Height = 20
          Hint = #20027#28216#25103#26381#21153#22120'IP'#65292#27492#35774#32622#29992#20110#22810#26381#21153#22120#36127#36733#29615#22659#20351#29992#12290#26222#36890#29615#22659#19981#38656#35201#26356#25913#27492#35774#32622#12290
          TabOrder = 1
          Text = '127.0.0.1'
          OnChange = EditValueChange
        end
      end
    end
    object ServerInfoSheet: TTabSheet
      Caption = #28216#25103#35774#32622
      object GroupBoxInfo: TGroupBox
        Left = 8
        Top = 5
        Width = 217
        Height = 92
        Caption = #22522#26412#21442#25968
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #28216#25103#21517#31216':'
        end
        object Label10: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #26381#21153#22120#21495':'
        end
        object Label11: TLabel
          Left = 112
          Top = 44
          Width = 54
          Height = 12
          Caption = #26381#21153#22120#25968':'
        end
        object EditGameName: TEdit
          Left = 64
          Top = 16
          Width = 137
          Height = 20
          Hint = #28216#25103#26381#21153#22120#21517#31216#12290
          TabOrder = 0
          Text = #32043#20113#20256#22855
          OnChange = EditValueChange
        end
        object EditServerIndex: TEdit
          Left = 64
          Top = 40
          Width = 33
          Height = 20
          Hint = #28216#25103#26381#21153#22120#24207#21495#65292#27492#35774#32622#29992#20110#22810#26381#21153#22120#36127#36733#29615#22659#65292#26222#36890#29615#22659#35774#32622#20026'0'#12290
          TabOrder = 1
          Text = '0'
          OnChange = EditValueChange
        end
        object EditServerNumber: TEdit
          Left = 168
          Top = 40
          Width = 33
          Height = 20
          Hint = #22810#26381#21153#22120#36127#36733#65292#26381#21153#22120#25968#37327#12290
          TabOrder = 2
          Text = '0'
          OnChange = EditValueChange
        end
        object CheckBoxServiceMode: TCheckBox
          Left = 8
          Top = 64
          Width = 73
          Height = 17
          Hint = #20813#36153#27169#24335#65292#25171#24320#27492#20808#39033#23558#19981#23545#29992#25143#35745#36153#12290
          Caption = #20813#36153#27169#24335
          TabOrder = 3
          OnClick = EditValueChange
        end
      end
      object GroupBox5: TGroupBox
        Left = 232
        Top = 5
        Width = 153
        Height = 92
        TabOrder = 1
        object Label12: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #24320#22987#31561#32423':'
        end
        object Label13: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #24320#22987#37329#24065':'
        end
        object Label14: TLabel
          Left = 8
          Top = 68
          Width = 54
          Height = 12
          Caption = #27979#35797#20154#25968':'
        end
        object EditTestLevel: TEdit
          Left = 64
          Top = 16
          Width = 73
          Height = 20
          Hint = #27979#35797#27169#24335#65292#20154#29289#36215#22987#31561#32423#12290
          TabOrder = 0
          Text = '0'
          OnChange = EditValueChange
        end
        object EditTestGold: TEdit
          Left = 64
          Top = 40
          Width = 73
          Height = 20
          Hint = #27979#35797#27169#24335#65292#20154#29289#36215#22987#37329#24065#25968#12290
          TabOrder = 1
          Text = '0'
          OnChange = EditValueChange
        end
        object EditTestUserLimit: TEdit
          Left = 64
          Top = 64
          Width = 73
          Height = 20
          Hint = #27979#35797#27169#24335#65292#26368#39640#19978#32447#20154#25968#12290
          TabOrder = 2
          Text = '0'
          OnChange = EditValueChange
        end
        object CheckBoxTestServer: TCheckBox
          Left = 8
          Top = -1
          Width = 65
          Height = 17
          Hint = #27979#35797#27169#24335#65292#25171#24320#27492#27169#24335#65292#21487#23545#26381#21153#22120#21508#39033#21442#25968#21450#21151#33021#36827#34892#27979#35797#12290
          Caption = #27979#35797#27169#24335
          TabOrder = 3
          OnClick = CheckBoxTestServerClick
        end
      end
      object ButtonServerInfoSave: TButton
        Left = 320
        Top = 195
        Width = 65
        Height = 23
        Caption = #20445#23384'(&S)'
        TabOrder = 2
        OnClick = ButtonServerInfoSaveClick
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 104
        Width = 161
        Height = 49
        Caption = #26368#39640#19978#32447#20154#25968
        TabOrder = 3
        object Label15: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #19978#38480#20154#25968':'
        end
        object EditUserFull: TEdit
          Left = 64
          Top = 16
          Width = 81
          Height = 20
          Hint = #26381#21153#22120#26368#39640#19978#32447#20154#25968#38480#21046#12290
          TabOrder = 0
          Text = '1000'
          OnChange = EditValueChange
        end
      end
      object GroupBox7: TGroupBox
        Left = 8
        Top = 160
        Width = 161
        Height = 49
        Caption = #28216#25103#25968#25454#28304#21517#31216
        TabOrder = 4
        object Label16: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #25968#25454#24211#21517':'
        end
        object EditDBName: TEdit
          Left = 64
          Top = 16
          Width = 81
          Height = 20
          TabOrder = 0
          Text = 'HeroDB'
          OnChange = EditValueChange
        end
      end
    end
    object ShareSheet: TTabSheet
      Caption = #30446#24405#35774#32622
      ImageIndex = 1
      object Label17: TLabel
        Left = 8
        Top = 12
        Width = 54
        Height = 12
        Caption = #34892#20250#30446#24405':'
      end
      object Label18: TLabel
        Left = 8
        Top = 36
        Width = 54
        Height = 12
        Caption = #34892#20250#25991#20214':'
      end
      object Label23: TLabel
        Left = 8
        Top = 156
        Width = 54
        Height = 12
        Caption = #20844#21578#30446#24405':'
      end
      object Label22: TLabel
        Left = 8
        Top = 132
        Width = 54
        Height = 12
        Caption = #22320#22270#30446#24405':'
      end
      object Label21: TLabel
        Left = 8
        Top = 108
        Width = 54
        Height = 12
        Caption = #37197#32622#30446#24405':'
      end
      object Label20: TLabel
        Left = 8
        Top = 84
        Width = 54
        Height = 12
        Caption = #22478#22561#30446#24405':'
      end
      object Label19: TLabel
        Left = 8
        Top = 60
        Width = 54
        Height = 12
        Caption = #30331#24405#26085#24535':'
      end
      object Label24: TLabel
        Left = 8
        Top = 180
        Width = 54
        Height = 12
        BiDiMode = bdLeftToRight
        Caption = #21151#33021#25554#20214':'
        ParentBiDiMode = False
      end
      object Label25: TLabel
        Left = 8
        Top = 204
        Width = 48
        Height = 12
        BiDiMode = bdLeftToRight
        Caption = 'Venture:'
        ParentBiDiMode = False
      end
      object EditGuildDir: TEdit
        Left = 64
        Top = 8
        Width = 241
        Height = 20
        Hint = #34892#20250#25968#25454#20445#23384#30446#24405#12290
        TabOrder = 0
        OnChange = EditValueChange
      end
      object EditGuildFile: TEdit
        Left = 64
        Top = 32
        Width = 241
        Height = 20
        Hint = #34892#20250#25968#25454#20445#23384#25991#20214#21517#12290
        TabOrder = 1
        OnChange = EditValueChange
      end
      object EditConLogDir: TEdit
        Left = 64
        Top = 56
        Width = 241
        Height = 20
        Hint = #20154#29289#30331#24405#26085#24535#20449#24687#20445#23384#30446#24405#12290
        TabOrder = 2
        OnChange = EditValueChange
      end
      object EditCastleDir: TEdit
        Left = 64
        Top = 80
        Width = 241
        Height = 20
        TabOrder = 3
        OnChange = EditValueChange
      end
      object EditEnvirDir: TEdit
        Left = 64
        Top = 104
        Width = 241
        Height = 20
        TabOrder = 4
        OnChange = EditValueChange
      end
      object EditMapDir: TEdit
        Left = 64
        Top = 128
        Width = 241
        Height = 20
        TabOrder = 5
        OnChange = EditValueChange
      end
      object EditNoticeDir: TEdit
        Left = 64
        Top = 152
        Width = 241
        Height = 20
        TabOrder = 6
        OnChange = EditValueChange
      end
      object EditPlugDir: TEdit
        Left = 64
        Top = 176
        Width = 241
        Height = 20
        TabOrder = 7
        OnChange = EditValueChange
      end
      object EditVentureDir: TEdit
        Left = 64
        Top = 200
        Width = 241
        Height = 20
        TabOrder = 8
        OnChange = EditValueChange
      end
      object ButtonShareDirSave: TButton
        Left = 320
        Top = 195
        Width = 65
        Height = 23
        Caption = #20445#23384'(&S)'
        TabOrder = 9
        OnClick = ButtonShareDirSaveClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = #20449#24687#25552#31034
      ImageIndex = 3
      object GroupBox8: TGroupBox
        Left = 10
        Top = 98
        Width = 207
        Height = 55
        Caption = #25552#31034#20449#24687
        TabOrder = 0
        object Label27: TLabel
          Left = 8
          Top = 24
          Width = 54
          Height = 12
          Caption = #32972#26223#39068#33394':'
        end
        object ColorBoxHint: TColorBox
          Left = 66
          Top = 20
          Width = 127
          Height = 22
          Hint = 
            'Colour that will be used for the mouseover hints like the one yo' +
            'u are reading now'
          DefaultColorColor = clAqua
          ItemHeight = 16
          TabOrder = 0
          OnChange = ColorBoxHintChange
        end
      end
      object ButtonHintSave: TButton
        Left = 320
        Top = 195
        Width = 65
        Height = 23
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonHintSaveClick
      end
      object GroupBox9: TGroupBox
        Left = 10
        Top = 8
        Width = 207
        Height = 81
        Caption = #24341#25806#26085#24535
        TabOrder = 2
        object Label28: TLabel
          Left = 8
          Top = 24
          Width = 54
          Height = 12
          Caption = #23383#20307#39068#33394':'
        end
        object Label29: TLabel
          Left = 8
          Top = 48
          Width = 54
          Height = 12
          Caption = #32972#26223#39068#33394':'
        end
        object ColorBoxMemoLogFontColor: TColorBox
          Left = 66
          Top = 20
          Width = 127
          Height = 22
          DefaultColorColor = clAqua
          ItemHeight = 16
          TabOrder = 0
          OnChange = ColorBoxHintChange
        end
        object ColorBoxMemoLogColor: TColorBox
          Left = 66
          Top = 44
          Width = 127
          Height = 22
          DefaultColorColor = clAqua
          ItemHeight = 16
          TabOrder = 1
          OnChange = ColorBoxHintChange
        end
      end
    end
  end
end
