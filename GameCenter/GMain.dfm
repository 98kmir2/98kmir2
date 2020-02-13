object frmMain: TfrmMain
  Left = 908
  Top = 524
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26381#21153#22120#25511#21046#21488
  ClientHeight = 364
  ClientWidth = 522
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 522
    Height = 364
    ActivePage = TabSheet1
    Align = alClient
    HotTrack = True
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #26381#21153#31471#25511#21046
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 497
        Height = 321
        Caption = #26381#21153#22120#25511#21046
        TabOrder = 0
        object EditM2ServerProgram: TEdit
          Left = 520
          Top = 64
          Width = 297
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ReadOnly = True
          TabOrder = 1
          Visible = False
        end
        object EditDBServerProgram: TEdit
          Left = 520
          Top = 16
          Width = 297
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ReadOnly = True
          TabOrder = 2
          Visible = False
        end
        object EditLoginSrvProgram: TEdit
          Left = 520
          Top = 40
          Width = 297
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ReadOnly = True
          TabOrder = 3
          Visible = False
        end
        object EditLogServerProgram: TEdit
          Left = 520
          Top = 88
          Width = 297
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ReadOnly = True
          TabOrder = 4
          Visible = False
        end
        object EditLoginGateProgram: TEdit
          Left = 520
          Top = 112
          Width = 297
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ReadOnly = True
          TabOrder = 5
          Visible = False
        end
        object EditSelGateProgram: TEdit
          Left = 520
          Top = 136
          Width = 297
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ReadOnly = True
          TabOrder = 6
          Visible = False
        end
        object EditRunGateProgram: TEdit
          Left = 520
          Top = 160
          Width = 297
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ReadOnly = True
          TabOrder = 7
          Visible = False
        end
        object ButtonStartGame: TButton
          Left = 160
          Top = 279
          Width = 177
          Height = 33
          Caption = #21551#21160#21453#22806#25346#24341#25806'(&S)'
          Default = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = ButtonStartGameClick
        end
        object CheckBoxM2Server: TCheckBox
          Left = 17
          Top = 36
          Width = 161
          Height = 17
          Caption = #28216#25103#20027#35201#31243#24207'(M2Server)'
          TabOrder = 8
          OnClick = CheckBoxM2ServerClick
        end
        object CheckBoxDBServer: TCheckBox
          Left = 17
          Top = 20
          Width = 161
          Height = 17
          Caption = #25968#25454#24211#26381#21153#22120'(DBServer)'
          TabOrder = 9
          OnClick = CheckBoxDBServerClick
        end
        object CheckBoxLoginServer: TCheckBox
          Left = 200
          Top = 20
          Width = 161
          Height = 17
          Caption = #24080#21495#26381#21153#22120'(LoginSvr)'
          TabOrder = 10
          OnClick = CheckBoxLoginServerClick
        end
        object CheckBoxLogServer: TCheckBox
          Left = 200
          Top = 36
          Width = 161
          Height = 17
          Caption = #26085#24535#26381#21153#22120'(LogServer)'
          TabOrder = 11
          OnClick = CheckBoxLogServerClick
        end
        object CheckBoxLoginGate: TCheckBox
          Left = 17
          Top = 52
          Width = 161
          Height = 17
          Caption = #28216#25103#30331#38470#32593#20851'(LoginGate)'
          TabOrder = 12
          OnClick = CheckBoxLoginGateClick
        end
        object CheckBoxSelGate: TCheckBox
          Left = 200
          Top = 52
          Width = 161
          Height = 17
          Caption = #28216#25103#35282#33394#32593#20851'(SelGate)'
          TabOrder = 13
          OnClick = CheckBoxSelGateClick
        end
        object CheckBoxRunGate: TCheckBox
          Left = 17
          Top = 68
          Width = 161
          Height = 17
          Caption = #28216#25103#32593#20851'(Rungate)'
          TabOrder = 14
          OnClick = CheckBoxRunGateClick
        end
        object EditRunGate1Program: TEdit
          Left = 520
          Top = 184
          Width = 297
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ReadOnly = True
          TabOrder = 15
          Visible = False
        end
        object EditRunGate2Program: TEdit
          Left = 520
          Top = 208
          Width = 297
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ReadOnly = True
          TabOrder = 16
          Visible = False
        end
        object MemoLog: TMemo
          Left = 8
          Top = 112
          Width = 481
          Height = 161
          Color = clNone
          Font.Charset = ANSI_CHARSET
          Font.Color = clLime
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ParentFont = False
          TabOrder = 17
          OnChange = MemoLogChange
        end
      end
    end
    object TabSheet15: TTabSheet
      Caption = #24080#21495#31649#29702
      ImageIndex = 5
      object GroupBox25: TGroupBox
        Left = 8
        Top = 8
        Width = 497
        Height = 321
        Caption = #30331#24405#24080#21495#23494#30721
        TabOrder = 0
        object Label30: TLabel
          Left = 24
          Top = 23
          Width = 54
          Height = 12
          Caption = #30331#24405#24080#21495':'
        end
        object EditSearchLoginAccount: TEdit
          Left = 80
          Top = 20
          Width = 105
          Height = 20
          Hint = #25552#31034#65306'ID'#36755#20837#23436#27605#25353#22238#36710#38190#25628#32034#12290
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 0
          OnKeyPress = EditSearchLoginAccountKeyPress
        end
        object ButtonSearchLoginAccount: TButton
          Left = 200
          Top = 17
          Width = 89
          Height = 23
          Caption = #25628#32034'(&S)'
          TabOrder = 1
          OnClick = ButtonSearchLoginAccountClick
        end
        object GroupBox26: TGroupBox
          Left = 8
          Top = 48
          Width = 481
          Height = 265
          Caption = #24080#21495#20449#24687
          TabOrder = 2
          object Label31: TLabel
            Left = 40
            Top = 20
            Width = 30
            Height = 12
            Alignment = taRightJustify
            Caption = #24080#21495':'
          end
          object Label32: TLabel
            Left = 208
            Top = 20
            Width = 30
            Height = 12
            Alignment = taRightJustify
            Caption = #23494#30721':'
          end
          object Label33: TLabel
            Left = 16
            Top = 44
            Width = 54
            Height = 12
            Alignment = taRightJustify
            Caption = #29992#25143#21517#31216':'
          end
          object Label34: TLabel
            Left = 16
            Top = 140
            Width = 54
            Height = 12
            Alignment = taRightJustify
            Caption = #36523#20221#35777#21495':'
          end
          object Label35: TLabel
            Left = 40
            Top = 68
            Width = 30
            Height = 12
            Alignment = taRightJustify
            Caption = #29983#26085':'
          end
          object Label36: TLabel
            Left = 196
            Top = 44
            Width = 42
            Height = 12
            Alignment = taRightJustify
            Caption = #38382#39064#19968':'
          end
          object Label37: TLabel
            Left = 196
            Top = 68
            Width = 42
            Height = 12
            Alignment = taRightJustify
            Caption = #31572#26696#19968':'
          end
          object Label38: TLabel
            Left = 196
            Top = 92
            Width = 42
            Height = 12
            Alignment = taRightJustify
            Caption = #38382#39064#20108':'
          end
          object Label39: TLabel
            Left = 196
            Top = 116
            Width = 42
            Height = 12
            Alignment = taRightJustify
            Caption = #31572#26696#20108':'
          end
          object Label40: TLabel
            Left = 16
            Top = 116
            Width = 54
            Height = 12
            Alignment = taRightJustify
            Caption = #31227#21160#30005#35805':'
          end
          object Label41: TLabel
            Left = 28
            Top = 188
            Width = 42
            Height = 12
            Alignment = taRightJustify
            Caption = #22791#27880#19968':'
          end
          object Label42: TLabel
            Left = 28
            Top = 212
            Width = 42
            Height = 12
            Alignment = taRightJustify
            Caption = #22791#27880#20108':'
          end
          object Label43: TLabel
            Left = 16
            Top = 237
            Width = 54
            Height = 12
            Alignment = taRightJustify
            Caption = #30005#23376#37038#31665':'
          end
          object Label44: TLabel
            Left = 40
            Top = 92
            Width = 30
            Height = 12
            Alignment = taRightJustify
            Caption = #30005#35805':'
          end
          object Label66: TLabel
            Left = 184
            Top = 140
            Width = 54
            Height = 12
            Alignment = taRightJustify
            Caption = #21019#24314#26102#38388':'
          end
          object Label67: TLabel
            Left = 16
            Top = 164
            Width = 54
            Height = 12
            Alignment = taRightJustify
            Caption = #26356#26032#26102#38388':'
          end
          object EditLoginAccount: TEdit
            Left = 72
            Top = 16
            Width = 105
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 10
            TabOrder = 0
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountPasswd: TEdit
            Left = 240
            Top = 16
            Width = 129
            Height = 20
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 10
            TabOrder = 1
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountUserName: TEdit
            Left = 72
            Top = 40
            Width = 105
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 20
            TabOrder = 2
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountSSNo: TEdit
            Left = 72
            Top = 136
            Width = 105
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 14
            TabOrder = 3
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountBirthDay: TEdit
            Left = 72
            Top = 64
            Width = 105
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 10
            TabOrder = 4
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountQuiz: TEdit
            Left = 240
            Top = 40
            Width = 225
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 20
            TabOrder = 5
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountAnswer: TEdit
            Left = 240
            Top = 64
            Width = 225
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 12
            TabOrder = 6
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountQuiz2: TEdit
            Left = 240
            Top = 88
            Width = 225
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 20
            TabOrder = 7
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountAnswer2: TEdit
            Left = 240
            Top = 112
            Width = 225
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 12
            TabOrder = 8
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountMobilePhone: TEdit
            Left = 72
            Top = 112
            Width = 105
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 13
            TabOrder = 9
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountMemo1: TEdit
            Left = 72
            Top = 184
            Width = 393
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 40
            TabOrder = 10
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountEMail: TEdit
            Left = 72
            Top = 232
            Width = 393
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 40
            TabOrder = 11
            OnChange = EditLoginAccountChange
          end
          object EditLoginAccountMemo2: TEdit
            Left = 72
            Top = 208
            Width = 393
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 40
            TabOrder = 12
            OnChange = EditLoginAccountChange
          end
          object CkFullEditMode: TCheckBox
            Left = 376
            Top = 16
            Width = 89
            Height = 17
            Caption = #20462#25913#24080#21495#20449#24687
            TabOrder = 13
            OnClick = CkFullEditModeClick
          end
          object EditLoginAccountPhone: TEdit
            Left = 72
            Top = 88
            Width = 105
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 13
            TabOrder = 14
            OnChange = EditLoginAccountChange
          end
          object EditUpdateDate: TEdit
            Left = 72
            Top = 160
            Width = 393
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 10
            TabOrder = 15
            OnChange = EditLoginAccountChange
          end
          object EditCreateDate: TEdit
            Left = 240
            Top = 136
            Width = 225
            Height = 20
            Enabled = False
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 10
            TabOrder = 16
            OnChange = EditLoginAccountChange
          end
        end
        object ButtonLoginAccountOK: TButton
          Left = 392
          Top = 17
          Width = 89
          Height = 23
          Caption = #30830#23450'(&O)'
          Enabled = False
          TabOrder = 3
          OnClick = ButtonLoginAccountOKClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #37197#32622#21521#23548
      ImageIndex = 1
      object PageControl3: TPageControl
        Left = 8
        Top = 8
        Width = 497
        Height = 321
        ActivePage = TabSheet6
        HotTrack = True
        TabOrder = 0
        TabPosition = tpBottom
        object TabSheet4: TTabSheet
          Caption = #31532#19968#27493'('#22522#26412#35774#32622')'
          object GroupBox1: TGroupBox
            Left = 8
            Top = 8
            Width = 473
            Height = 177
            Caption = #31243#24207#30446#24405#21450#29289#21697#25968#25454#24211#35774#32622
            TabOrder = 0
            object Label1: TLabel
              Left = 8
              Top = 28
              Width = 102
              Height = 12
              Caption = #25968#25454#24341#25806#25152#22312#30446#24405':'
            end
            object Label2: TLabel
              Left = 8
              Top = 52
              Width = 102
              Height = 12
              Caption = #25968#25454#25806#25968#25454#24211#21517#31216':'
            end
            object Label3: TLabel
              Left = 8
              Top = 76
              Width = 102
              Height = 12
              Caption = #25968#25454#25806#26381#21153#22120#21517#31216':'
            end
            object Label4: TLabel
              Left = 8
              Top = 100
              Width = 102
              Height = 12
              Caption = #26381#21153#22120#22806#32593'IP'#22320#22336':'
            end
            object EditGameDir: TEdit
              Left = 112
              Top = 24
              Width = 257
              Height = 20
              Hint = #36755#20837#26381#21153#22120#25152#22312#30446#24405#12290#19968#33324#40664#35748#20026#8220'D:\GameOfmir\'#8221#12290
              ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
              TabOrder = 0
              Text = 'D:\wolserver\'
            end
            object Button1: TButton
              Left = 376
              Top = 20
              Width = 81
              Height = 25
              Caption = #27983#35272'(&B)'
              TabOrder = 1
              Visible = False
            end
            object EditHeroDB: TEdit
              Left = 112
              Top = 48
              Width = 257
              Height = 20
              Hint = #26381#21153#22120#31471'BDE '#25968#25454#24211#21517#31216#65292#40664#35748#20026' '#8220'HeroDB'#8221#12290
              ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
              TabOrder = 2
              Text = 'HeroDB'
            end
            object EditGameName: TEdit
              Left = 112
              Top = 72
              Width = 257
              Height = 20
              Hint = #36755#20837#28216#25103#30340#21517#31216#12290
              ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
              TabOrder = 3
              Text = #28909#34880#20256#22855
            end
            object EditGameExtIPaddr: TEdit
              Left = 112
              Top = 96
              Width = 137
              Height = 20
              Hint = #36755#20837#26381#21153#22120#30340#22806#32593'IP'#22320#22336#12290
              ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
              TabOrder = 4
              Text = '192.168.1.5'
            end
            object CheckBoxDynamicIPMode: TCheckBox
              Left = 256
              Top = 96
              Width = 81
              Height = 17
              Hint = #21160#24577'IP'#22320#22336#27169#24335#65292#25903#25345#25300#21495#21160#24577'IP'#32593#32476#26465#20214#65292#25171#24320#27492#27169#24335#21518#65292#26381#21153#22120#31471#19981#38656#35201#25913#20219#20309'IP'#65292#33258#21160#35782#21035#30331#24405'IP'#22320#22336#12290
              Caption = #21160#24577'IP'#22320#22336
              TabOrder = 5
              OnClick = CheckBoxDynamicIPModeClick
            end
            object ButtonGeneralDefalult: TButton
              Left = 376
              Top = 92
              Width = 81
              Height = 25
              Caption = #40664#35748#35774#32622'(&D)'
              TabOrder = 6
              OnClick = ButtonGeneralDefalultClick
            end
            object GroupBox29: TGroupBox
              Left = 8
              Top = 122
              Width = 458
              Height = 47
              Caption = 'GroupBox29'
              TabOrder = 7
              object Label24: TLabel
                Left = 248
                Top = 20
                Width = 192
                Height = 12
                Caption = #36873#25321#21518#65292#25353'['#19979#19968#27493']'#33267#20445#23384#35774#32622#21363#21487
                Font.Charset = ANSI_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = #23435#20307
                Font.Style = []
                ParentFont = False
              end
              object RadioButton1: TRadioButton
                Left = 8
                Top = 19
                Width = 105
                Height = 17
                Caption = #24403#21069#26159#20027#26381#21153#22120
                Checked = True
                TabOrder = 0
                TabStop = True
                OnClick = RadioButton1Click
              end
              object RadioButton2: TRadioButton
                Left = 119
                Top = 19
                Width = 106
                Height = 17
                Caption = #24403#21069#26159#20998#26381#21153#22120
                TabOrder = 1
                OnClick = RadioButton1Click
              end
            end
            object CheckBox10: TCheckBox
              Left = 16
              Top = 118
              Width = 115
              Height = 17
              Caption = #31616#26131#19968#26426#21452#26381#37197#32622
              TabOrder = 8
              OnClick = CheckBox10Click
            end
          end
          object ButtonReLoadConfig: TButton
            Left = 304
            Top = 247
            Width = 81
            Height = 33
            Caption = #37325#21152#36733'(&R)'
            TabOrder = 2
            OnClick = ButtonReLoadConfigClick
          end
          object ButtonNext1: TButton
            Left = 392
            Top = 247
            Width = 81
            Height = 33
            Caption = #19979#19968#27493'(&N)'
            TabOrder = 1
            OnClick = ButtonNext1Click
          end
        end
        object TabSheet5: TTabSheet
          Caption = #31532#20108#27493'('#30331#24405#21069#32622#26381#21153#22120')'
          ImageIndex = 1
          object ButtonNext2: TButton
            Left = 392
            Top = 247
            Width = 81
            Height = 33
            Caption = #19979#19968#27493'(&N)'
            TabOrder = 0
            OnClick = ButtonNext2Click
          end
          object GroupBox2: TGroupBox
            Left = 8
            Top = 8
            Width = 473
            Height = 177
            Caption = #30331#24405#32593#20851#35774#32622
            TabOrder = 1
            object GroupBox7: TGroupBox
              Left = 8
              Top = 16
              Width = 153
              Height = 73
              Caption = #31383#21475#20301#32622
              TabOrder = 0
              object Label9: TLabel
                Left = 8
                Top = 20
                Width = 36
                Height = 12
                Caption = #24231#26631'X:'
              end
              object Label10: TLabel
                Left = 8
                Top = 44
                Width = 36
                Height = 12
                Caption = #24231#26631'Y:'
              end
              object EditLoginGate_MainFormX: TSpinEdit
                Left = 48
                Top = 16
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'X'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 0
                Value = 0
                OnChange = EditLoginGate_MainFormXChange
              end
              object EditLoginGate_MainFormY: TSpinEdit
                Left = 48
                Top = 40
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'Y'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 1
                Value = 0
                OnChange = EditLoginGate_MainFormYChange
              end
            end
            object ButtonLoginGateDefault: TButton
              Left = 384
              Top = 144
              Width = 81
              Height = 25
              Caption = #40664#35748#35774#32622'(&D)'
              TabOrder = 1
              OnClick = ButtonLoginGateDefaultClick
            end
            object GroupBox23: TGroupBox
              Left = 167
              Top = 16
              Width = 213
              Height = 113
              Caption = #26381#21153#22120#31471#21475
              TabOrder = 2
              object Label28: TLabel
                Left = 8
                Top = 20
                Width = 42
                Height = 12
                Caption = #31471#21475#19968':'
              end
              object Label5: TLabel
                Left = 8
                Top = 42
                Width = 42
                Height = 12
                Caption = #31471#21475#20108':'
              end
              object Label6: TLabel
                Left = 8
                Top = 64
                Width = 42
                Height = 12
                Caption = #31471#21475#19977':'
              end
              object Label7: TLabel
                Left = 8
                Top = 86
                Width = 42
                Height = 12
                Caption = #31471#21475#22235':'
              end
              object Label27: TLabel
                Left = 112
                Top = 19
                Width = 42
                Height = 12
                Caption = #31471#21475#20116':'
              end
              object Label45: TLabel
                Left = 112
                Top = 41
                Width = 42
                Height = 12
                Caption = #31471#21475#20845':'
              end
              object Label46: TLabel
                Left = 112
                Top = 63
                Width = 42
                Height = 12
                Caption = #31471#21475#19971':'
              end
              object Label47: TLabel
                Left = 112
                Top = 85
                Width = 42
                Height = 12
                Caption = #31471#21475#20843':'
              end
              object EditLoginGate_GatePort1: TEdit
                Left = 56
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 0
                Text = '7000'
              end
              object EditLoginGate_GatePort2: TEdit
                Left = 56
                Top = 39
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 1
                Text = '7000'
              end
              object EditLoginGate_GatePort3: TEdit
                Left = 56
                Top = 61
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 2
                Text = '7000'
              end
              object EditLoginGate_GatePort4: TEdit
                Left = 56
                Top = 83
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 3
                Text = '7000'
              end
              object EditLoginGate_GatePort5: TEdit
                Left = 160
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 4
                Text = '7000'
              end
              object EditLoginGate_GatePort6: TEdit
                Left = 160
                Top = 38
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 5
                Text = '7000'
              end
              object EditLoginGate_GatePort7: TEdit
                Left = 160
                Top = 60
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 6
                Text = '7000'
              end
              object EditLoginGate_GatePort8: TEdit
                Left = 160
                Top = 82
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 7
                Text = '7000'
              end
            end
            object GroupBox27: TGroupBox
              Left = 8
              Top = 96
              Width = 153
              Height = 70
              Caption = #26159#21542#21551#21160
              TabOrder = 3
              object CheckBoxboLoginGate_GetStart: TCheckBox
                Left = 6
                Top = 18
                Width = 144
                Height = 17
                Caption = #21551#21160#30331#24405#32593#20851'      '#24320
                TabOrder = 0
                OnClick = CheckBoxboLoginGate_GetStartClick
              end
              object CheckBoxLoginGateSleep: TCheckBox
                Left = 6
                Top = 42
                Width = 117
                Height = 17
                Caption = #24310#36831'      '#31186#24320#21551
                TabOrder = 1
                OnClick = CheckBoxLoginGateSleepClick
              end
              object SpinEditLoginGateSleep: TSpinEdit
                Left = 48
                Top = 39
                Width = 31
                Height = 21
                EditorEnabled = False
                MaxValue = 600
                MinValue = 0
                TabOrder = 2
                Value = 0
                OnChange = SpinEditLoginGateSleepChange
              end
              object EditLoginGateCount: TSpinEdit
                Left = 98
                Top = 16
                Width = 31
                Height = 21
                EditorEnabled = False
                MaxValue = 8
                MinValue = 1
                TabOrder = 3
                Value = 1
                OnChange = SpinEditLoginGateSleepChange
              end
            end
          end
          object ButtonPrv2: TButton
            Left = 304
            Top = 247
            Width = 81
            Height = 33
            Caption = #19978#19968#27493'(&P)'
            TabOrder = 2
            OnClick = ButtonPrv2Click
          end
        end
        object TabSheet6: TTabSheet
          Caption = #31532#19977#27493'('#35282#33394#21069#32622#26381#21153#22120')'
          ImageIndex = 2
          object GroupBox3: TGroupBox
            Left = 8
            Top = 8
            Width = 473
            Height = 177
            Caption = #35282#33394#32593#20851#35774#32622
            TabOrder = 0
            object GroupBox8: TGroupBox
              Left = 8
              Top = 16
              Width = 153
              Height = 73
              Caption = #31383#21475#20301#32622
              TabOrder = 0
              object Label11: TLabel
                Left = 8
                Top = 20
                Width = 36
                Height = 12
                Caption = #24231#26631'X:'
              end
              object Label12: TLabel
                Left = 8
                Top = 44
                Width = 36
                Height = 12
                Caption = #24231#26631'Y:'
              end
              object EditSelGate_MainFormX: TSpinEdit
                Left = 48
                Top = 16
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'X'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 0
                Value = 0
                OnChange = EditSelGate_MainFormXChange
              end
              object EditSelGate_MainFormY: TSpinEdit
                Left = 48
                Top = 40
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'Y'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 1
                Value = 0
                OnChange = EditSelGate_MainFormYChange
              end
            end
            object ButtonSelGateDefault: TButton
              Left = 384
              Top = 144
              Width = 81
              Height = 25
              Caption = #40664#35748#35774#32622'(&D)'
              TabOrder = 1
              OnClick = ButtonSelGateDefaultClick
            end
            object GroupBox24: TGroupBox
              Left = 167
              Top = 16
              Width = 213
              Height = 112
              Caption = #26381#21153#22120#31471#21475
              TabOrder = 2
              object Label29: TLabel
                Left = 8
                Top = 20
                Width = 42
                Height = 12
                Caption = #31471#21475#19968':'
              end
              object Label48: TLabel
                Left = 8
                Top = 42
                Width = 42
                Height = 12
                Caption = #31471#21475#20108':'
              end
              object Label49: TLabel
                Left = 8
                Top = 64
                Width = 42
                Height = 12
                Caption = #31471#21475#19977':'
              end
              object Label57: TLabel
                Left = 8
                Top = 86
                Width = 42
                Height = 12
                Caption = #31471#21475#22235':'
              end
              object Label58: TLabel
                Left = 112
                Top = 19
                Width = 42
                Height = 12
                Caption = #31471#21475#20116':'
              end
              object Label59: TLabel
                Left = 112
                Top = 41
                Width = 42
                Height = 12
                Caption = #31471#21475#20845':'
              end
              object Label60: TLabel
                Left = 112
                Top = 63
                Width = 42
                Height = 12
                Caption = #31471#21475#19971':'
              end
              object Label63: TLabel
                Left = 112
                Top = 85
                Width = 42
                Height = 12
                Caption = #31471#21475#20843':'
              end
              object EditSelGate_GatePort1: TEdit
                Left = 56
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 0
                Text = '7100'
              end
              object EditSelGate_GatePort2: TEdit
                Left = 56
                Top = 39
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 1
                Text = '7000'
              end
              object EditSelGate_GatePort3: TEdit
                Left = 56
                Top = 61
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 2
                Text = '7000'
              end
              object EditSelGate_GatePort4: TEdit
                Left = 56
                Top = 83
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 3
                Text = '7000'
              end
              object EditSelGate_GatePort5: TEdit
                Left = 160
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 4
                Text = '7000'
              end
              object EditSelGate_GatePort6: TEdit
                Left = 160
                Top = 38
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 5
                Text = '7000'
              end
              object EditSelGate_GatePort7: TEdit
                Left = 160
                Top = 60
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 6
                Text = '7000'
              end
              object EditSelGate_GatePort8: TEdit
                Left = 160
                Top = 82
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 7
                Text = '7000'
              end
            end
            object GroupBox28: TGroupBox
              Left = 8
              Top = 96
              Width = 153
              Height = 70
              Caption = #26159#21542#21551#21160
              TabOrder = 3
              object CheckBoxboSelGate_GetStart: TCheckBox
                Left = 8
                Top = 18
                Width = 140
                Height = 17
                Caption = #21551#21160#35282#33394#32593#20851'      '#24320
                TabOrder = 0
                OnClick = CheckBoxboSelGate_GetStartClick
              end
              object EditSelGate_GateCount: TSpinEdit
                Left = 98
                Top = 16
                Width = 31
                Height = 21
                EditorEnabled = False
                MaxValue = 8
                MinValue = 1
                TabOrder = 1
                Value = 1
                OnChange = SpinEditLoginGateSleepChange
              end
            end
          end
          object ButtonPrv3: TButton
            Left = 304
            Top = 247
            Width = 81
            Height = 33
            Caption = #19978#19968#27493'(&P)'
            TabOrder = 1
            OnClick = ButtonPrv3Click
          end
          object ButtonNext3: TButton
            Left = 391
            Top = 247
            Width = 81
            Height = 33
            Caption = #19979#19968#27493'(&N)'
            TabOrder = 2
            OnClick = ButtonNext3Click
          end
        end
        object TabSheet12: TTabSheet
          Caption = #31532#22235#27493'('#25968#25454#24341#25806#21069#32622#26381#21153#22120')'
          ImageIndex = 8
          object ButtonPrv4: TButton
            Left = 304
            Top = 247
            Width = 81
            Height = 33
            Caption = #19978#19968#27493'(&P)'
            TabOrder = 0
            OnClick = ButtonPrv4Click
          end
          object ButtonNext4: TButton
            Left = 392
            Top = 247
            Width = 81
            Height = 33
            Caption = #19979#19968#27493'(&N)'
            TabOrder = 1
            OnClick = ButtonNext4Click
          end
          object GroupBox17: TGroupBox
            Left = 8
            Top = 8
            Width = 473
            Height = 177
            Caption = #28216#25103#32593#20851#35774#32622
            TabOrder = 2
            object GroupBox18: TGroupBox
              Left = 8
              Top = 16
              Width = 153
              Height = 73
              Caption = #31383#21475#20301#32622
              TabOrder = 0
              object Label21: TLabel
                Left = 8
                Top = 20
                Width = 36
                Height = 12
                Caption = #24231#26631'X:'
              end
              object Label22: TLabel
                Left = 8
                Top = 44
                Width = 36
                Height = 12
                Caption = #24231#26631'Y:'
              end
              object EditRunGate_MainFormX: TSpinEdit
                Left = 48
                Top = 16
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'X'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 0
                Value = 0
              end
              object EditRunGate_MainFormY: TSpinEdit
                Left = 48
                Top = 40
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'Y'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 1
                Value = 0
              end
            end
            object GroupBox19: TGroupBox
              Left = 8
              Top = 96
              Width = 153
              Height = 49
              Caption = #24320#21551#28216#25103#32593#20851#25968#37327
              TabOrder = 1
              object Label23: TLabel
                Left = 8
                Top = 20
                Width = 30
                Height = 12
                Caption = #25968#37327':'
              end
              object EditRunGate_Connt: TSpinEdit
                Left = 48
                Top = 16
                Width = 41
                Height = 21
                Hint = #35774#32622#24320#21551#28216#25103#32593#20851#25968#37327#65292#19968#33324'200'#20154#20197#19979#30340#24320#19968#20010#32593#20851#65292'400'#20154#20197#19979#30340#24320#20108#20010#32593#20851#65292'400'#20154#20197#19978#30340#24320#19977#20010#32593#20851#12290
                MaxValue = 8
                MinValue = 1
                TabOrder = 0
                Value = 1
                OnChange = EditRunGate_ConntChange
              end
            end
            object GroupBox22: TGroupBox
              Left = 167
              Top = 16
              Width = 209
              Height = 122
              Caption = #26381#21153#22120#31471#21475
              TabOrder = 2
              object LabelRunGate_GatePort1: TLabel
                Left = 8
                Top = 20
                Width = 42
                Height = 12
                Caption = #31471#21475#19968':'
              end
              object LabelLabelRunGate_GatePort2: TLabel
                Left = 8
                Top = 44
                Width = 42
                Height = 12
                Caption = #31471#21475#20108':'
              end
              object LabelRunGate_GatePort3: TLabel
                Left = 8
                Top = 68
                Width = 42
                Height = 12
                Caption = #31471#21475#19977':'
              end
              object LabelRunGate_GatePort4: TLabel
                Left = 8
                Top = 92
                Width = 42
                Height = 12
                Caption = #31471#21475#22235':'
              end
              object LabelRunGate_GatePort5: TLabel
                Left = 104
                Top = 20
                Width = 42
                Height = 12
                Caption = #31471#21475#20116':'
              end
              object LabelRunGate_GatePort6: TLabel
                Left = 104
                Top = 44
                Width = 42
                Height = 12
                Caption = #31471#21475#20845':'
              end
              object LabelRunGate_GatePort7: TLabel
                Left = 104
                Top = 68
                Width = 42
                Height = 12
                Caption = #31471#21475#19971':'
              end
              object LabelRunGate_GatePort78: TLabel
                Left = 104
                Top = 92
                Width = 42
                Height = 12
                Caption = #31471#21475#20843':'
              end
              object EditRunGate_GatePort1: TEdit
                Left = 56
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 0
                Text = '7200'
              end
              object EditRunGate_GatePort2: TEdit
                Left = 56
                Top = 40
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 1
                Text = '7200'
              end
              object EditRunGate_GatePort3: TEdit
                Left = 56
                Top = 64
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 2
                Text = '7200'
              end
              object EditRunGate_GatePort4: TEdit
                Left = 56
                Top = 88
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 3
                Text = '7200'
              end
              object EditRunGate_GatePort5: TEdit
                Left = 152
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 4
                Text = '7200'
              end
              object EditRunGate_GatePort6: TEdit
                Left = 152
                Top = 40
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 5
                Text = '7200'
              end
              object EditRunGate_GatePort7: TEdit
                Left = 152
                Top = 64
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 6
                Text = '7200'
              end
              object EditRunGate_GatePort8: TEdit
                Left = 152
                Top = 88
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 7
                Text = '7200'
              end
            end
            object ButtonRunGateDefault: TButton
              Left = 384
              Top = 144
              Width = 81
              Height = 25
              Caption = #40664#35748#35774#32622'(&D)'
              TabOrder = 3
              OnClick = ButtonRunGateDefaultClick
            end
          end
        end
        object TabSheet7: TTabSheet
          Caption = #31532#20116#27493'('#24080#21495#30331#24405#26381#21153#22120')'
          ImageIndex = 3
          object GroupBox9: TGroupBox
            Left = 8
            Top = 8
            Width = 473
            Height = 177
            Caption = #24080#21495#30331#24405#26381#21153#22120#35774#32622
            TabOrder = 0
            object GroupBox10: TGroupBox
              Left = 8
              Top = 16
              Width = 129
              Height = 73
              Caption = #31383#21475#20301#32622
              TabOrder = 0
              object Label13: TLabel
                Left = 8
                Top = 20
                Width = 36
                Height = 12
                Caption = #24231#26631'X:'
              end
              object Label14: TLabel
                Left = 8
                Top = 44
                Width = 36
                Height = 12
                Caption = #24231#26631'Y:'
              end
              object EditLoginServer_MainFormX: TSpinEdit
                Left = 48
                Top = 16
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'X'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 0
                Value = 0
                OnChange = EditLoginServer_MainFormXChange
              end
              object EditLoginServer_MainFormY: TSpinEdit
                Left = 48
                Top = 40
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'Y'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 1
                Value = 0
                OnChange = EditLoginServer_MainFormYChange
              end
            end
            object ButtonLoginServerConfig: TButton
              Left = 296
              Top = 144
              Width = 81
              Height = 25
              Caption = #39640#32423#35774#32622
              TabOrder = 1
              OnClick = ButtonLoginServerConfigClick
            end
            object ButtonLoginSrvDefault: TButton
              Left = 384
              Top = 144
              Width = 81
              Height = 25
              Caption = #40664#35748#35774#32622'(&D)'
              TabOrder = 2
              OnClick = ButtonLoginSrvDefaultClick
            end
            object GroupBox33: TGroupBox
              Left = 144
              Top = 16
              Width = 137
              Height = 91
              Caption = #21069#32622#26381#21153#22120#31471#21475
              TabOrder = 3
              object Label50: TLabel
                Left = 8
                Top = 20
                Width = 54
                Height = 12
                Caption = #36830#25509#31471#21475':'
              end
              object Label51: TLabel
                Left = 8
                Top = 44
                Width = 54
                Height = 12
                Caption = #36890#35759#31471#21475':'
              end
              object Label25: TLabel
                Left = 8
                Top = 68
                Width = 54
                Height = 12
                Caption = #30417#21548#31471#21475':'
              end
              object EditLoginServerGatePort: TEdit
                Left = 64
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 0
                Text = '7200'
              end
              object EditLoginServerServerPort: TEdit
                Left = 64
                Top = 40
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 1
                Text = '7200'
              end
              object EditLogListenPort: TEdit
                Left = 64
                Top = 64
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 2
                Text = '7200'
              end
            end
            object GroupBox34: TGroupBox
              Left = 8
              Top = 96
              Width = 129
              Height = 41
              Caption = #26159#21542#21551#21160
              TabOrder = 4
              object CheckBoxboLoginServer_GetStart: TCheckBox
                Left = 8
                Top = 16
                Width = 105
                Height = 17
                Caption = #21551#21160#24080#21495#26381#21153#22120
                TabOrder = 0
                OnClick = CheckBoxboLoginServer_GetStartClick
              end
            end
          end
          object ButtonPrv5: TButton
            Left = 304
            Top = 247
            Width = 81
            Height = 33
            Caption = #19978#19968#27493'(&P)'
            TabOrder = 1
            OnClick = ButtonPrv5Click
          end
          object ButtonNext5: TButton
            Left = 392
            Top = 247
            Width = 81
            Height = 33
            Caption = #19979#19968#27493'(&N)'
            TabOrder = 2
            OnClick = ButtonNext5Click
          end
        end
        object TabSheet8: TTabSheet
          Caption = #31532#20845#27493'('#25968#25454#24211#26381#21153#22120')'
          ImageIndex = 4
          object GroupBox11: TGroupBox
            Left = 8
            Top = 8
            Width = 473
            Height = 177
            Caption = #25968#25454#24211#26381#21153#22120#35774#32622
            TabOrder = 0
            object GroupBox12: TGroupBox
              Left = 8
              Top = 16
              Width = 129
              Height = 73
              Caption = #31383#21475#20301#32622
              TabOrder = 0
              object Label15: TLabel
                Left = 8
                Top = 20
                Width = 36
                Height = 12
                Caption = #24231#26631'X:'
              end
              object Label16: TLabel
                Left = 8
                Top = 44
                Width = 36
                Height = 12
                Caption = #24231#26631'Y:'
              end
              object EditDBServer_MainFormX: TSpinEdit
                Left = 48
                Top = 16
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'X'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 0
                Value = 0
                OnChange = EditDBServer_MainFormXChange
              end
              object EditDBServer_MainFormY: TSpinEdit
                Left = 48
                Top = 40
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'Y'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 1
                Value = 0
                OnChange = EditDBServer_MainFormYChange
              end
            end
            object ButtonDBServerDefault: TButton
              Left = 384
              Top = 144
              Width = 81
              Height = 25
              Caption = #40664#35748#35774#32622'(&D)'
              TabOrder = 1
              OnClick = ButtonDBServerDefaultClick
            end
            object GroupBox35: TGroupBox
              Left = 8
              Top = 96
              Width = 129
              Height = 41
              Caption = #26159#21542#21551#21160
              TabOrder = 2
              object CheckBoxDBServerGetStart: TCheckBox
                Left = 8
                Top = 16
                Width = 113
                Height = 17
                Caption = #21551#21160#25968#25454#24211#26381#21153#22120
                TabOrder = 0
                OnClick = CheckBoxDBServerGetStartClick
              end
            end
            object GroupBox36: TGroupBox
              Left = 144
              Top = 16
              Width = 129
              Height = 73
              Caption = #21069#32622#26381#21153#22120#31471#21475
              TabOrder = 3
              object Label52: TLabel
                Left = 8
                Top = 20
                Width = 54
                Height = 12
                Caption = #36830#25509#31471#21475':'
              end
              object Label53: TLabel
                Left = 8
                Top = 44
                Width = 54
                Height = 12
                Caption = #36890#35759#31471#21475':'
              end
              object EditDBServerGatePort: TEdit
                Left = 64
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 0
                Text = '5100'
              end
              object EditDBServerServerPort: TEdit
                Left = 64
                Top = 40
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 1
                Text = '6000'
              end
            end
          end
          object ButtonPrv6: TButton
            Left = 304
            Top = 247
            Width = 81
            Height = 33
            Caption = #19978#19968#27493'(&P)'
            TabOrder = 1
            OnClick = ButtonPrv6Click
          end
          object ButtonNext6: TButton
            Left = 392
            Top = 247
            Width = 81
            Height = 33
            Caption = #19979#19968#27493'(&N)'
            TabOrder = 2
            OnClick = ButtonNext6Click
          end
        end
        object TabSheet9: TTabSheet
          Caption = #31532#19971#27493'('#28216#25103#26085#24535#26381#21153#22120')'
          ImageIndex = 5
          object GroupBox13: TGroupBox
            Left = 8
            Top = 8
            Width = 473
            Height = 177
            Caption = #24341#25806#26085#24535#26381#21153#22120#35774#32622
            TabOrder = 0
            object GroupBox14: TGroupBox
              Left = 8
              Top = 16
              Width = 129
              Height = 73
              Caption = #31383#21475#20301#32622
              TabOrder = 0
              object Label17: TLabel
                Left = 8
                Top = 20
                Width = 36
                Height = 12
                Caption = #24231#26631'X:'
              end
              object Label18: TLabel
                Left = 8
                Top = 44
                Width = 36
                Height = 12
                Caption = #24231#26631'Y:'
              end
              object EditLogServer_MainFormX: TSpinEdit
                Left = 48
                Top = 16
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'X'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 0
                Value = 0
                OnChange = EditLogServer_MainFormXChange
              end
              object EditLogServer_MainFormY: TSpinEdit
                Left = 48
                Top = 40
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'Y'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 1
                Value = 0
                OnChange = EditLogServer_MainFormYChange
              end
            end
            object ButtonLogServerDefault: TButton
              Left = 384
              Top = 144
              Width = 81
              Height = 25
              Caption = #40664#35748#35774#32622'(&D)'
              TabOrder = 1
              OnClick = ButtonLogServerDefaultClick
            end
            object GroupBox37: TGroupBox
              Left = 8
              Top = 96
              Width = 129
              Height = 41
              Caption = #26159#21542#21551#21160
              TabOrder = 2
              object CheckBoxLogServerGetStart: TCheckBox
                Left = 8
                Top = 16
                Width = 113
                Height = 17
                Caption = #21551#21160#26085#24535#26381#21153#22120
                TabOrder = 0
                OnClick = CheckBoxLogServerGetStartClick
              end
            end
            object GroupBox38: TGroupBox
              Left = 144
              Top = 16
              Width = 129
              Height = 73
              Caption = #32593#32476#31471#21475
              TabOrder = 3
              object Label54: TLabel
                Left = 8
                Top = 20
                Width = 54
                Height = 12
                Caption = #32593#32476#31471#21475':'
              end
              object EditLogServerPort: TEdit
                Left = 64
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 0
                Text = '10000'
              end
            end
          end
          object ButtonPrv7: TButton
            Left = 304
            Top = 247
            Width = 81
            Height = 33
            Caption = #19978#19968#27493'(&P)'
            TabOrder = 1
            OnClick = ButtonPrv7Click
          end
          object ButtonNext7: TButton
            Left = 392
            Top = 247
            Width = 81
            Height = 33
            Caption = #19979#19968#27493'(&N)'
            TabOrder = 2
            OnClick = ButtonNext7Click
          end
        end
        object TabSheet10: TTabSheet
          Caption = #31532#20843#27493'('#21453#22806#25346#25968#25454#24341#25806')'
          ImageIndex = 6
          object GroupBox15: TGroupBox
            Left = 8
            Top = 8
            Width = 473
            Height = 177
            Caption = #21453#22806#25346#25968#25454#24341#25806#35774#32622
            TabOrder = 0
            object GroupBox16: TGroupBox
              Left = 8
              Top = 16
              Width = 129
              Height = 73
              Caption = #31383#21475#20301#32622
              TabOrder = 0
              object Label19: TLabel
                Left = 8
                Top = 20
                Width = 36
                Height = 12
                Caption = #24231#26631'X:'
              end
              object Label20: TLabel
                Left = 8
                Top = 44
                Width = 36
                Height = 12
                Caption = #24231#26631'Y:'
              end
              object EditM2Server_MainFormX: TSpinEdit
                Left = 48
                Top = 16
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'X'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 0
                Value = 0
                OnChange = EditM2Server_MainFormXChange
              end
              object EditM2Server_MainFormY: TSpinEdit
                Left = 48
                Top = 40
                Width = 65
                Height = 21
                Hint = #21551#21160#31243#24207#31383#21475#22312#23631#24149#19978#30340#20301#32622#65292#24231#26631'Y'#12290
                MaxValue = 10000
                MinValue = 0
                TabOrder = 1
                Value = 0
                OnChange = EditM2Server_MainFormYChange
              end
            end
            object ButtonM2ServerDefault: TButton
              Left = 384
              Top = 144
              Width = 81
              Height = 25
              Caption = #40664#35748#35774#32622'(&D)'
              TabOrder = 1
              OnClick = ButtonM2ServerDefaultClick
            end
            object GroupBox32: TGroupBox
              Left = 280
              Top = 16
              Width = 153
              Height = 73
              Caption = #26032#20154#35774#32622
              TabOrder = 2
              Visible = False
              object Label61: TLabel
                Left = 8
                Top = 20
                Width = 54
                Height = 12
                Caption = #24320#22987#31561#32423':'
              end
              object Label62: TLabel
                Left = 8
                Top = 44
                Width = 54
                Height = 12
                Caption = #24320#22987#37329#24065':'
              end
              object EditM2Server_TestLevel: TSpinEdit
                Left = 68
                Top = 16
                Width = 69
                Height = 21
                Hint = #20154#29289#36215#22987#31561#32423#12290
                MaxValue = 20000
                MinValue = 0
                TabOrder = 0
                Value = 10
                OnChange = EditM2Server_TestLevelChange
              end
              object EditM2Server_TestGold: TSpinEdit
                Left = 68
                Top = 40
                Width = 69
                Height = 21
                Hint = #27979#35797#27169#24335#20154#29289#36215#22987#37329#24065#25968#12290
                Increment = 1000
                MaxValue = 20000000
                MinValue = 0
                TabOrder = 1
                Value = 10
                OnChange = EditM2Server_TestGoldChange
              end
            end
            object GroupBox39: TGroupBox
              Left = 144
              Top = 16
              Width = 129
              Height = 73
              Caption = #21069#32622#26381#21153#22120#31471#21475
              TabOrder = 3
              object Label55: TLabel
                Left = 8
                Top = 20
                Width = 54
                Height = 12
                Caption = #36830#25509#31471#21475':'
              end
              object Label56: TLabel
                Left = 8
                Top = 44
                Width = 54
                Height = 12
                Caption = #36890#35759#31471#21475':'
              end
              object EditM2ServerGatePort: TEdit
                Left = 64
                Top = 16
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 0
                Text = '5000'
              end
              object EditM2ServerMsgSrvPort: TEdit
                Left = 64
                Top = 40
                Width = 41
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                TabOrder = 1
                Text = '4900'
              end
            end
            object GroupBox40: TGroupBox
              Left = 8
              Top = 96
              Width = 129
              Height = 41
              Caption = #26159#21542#21551#21160
              TabOrder = 4
              object CheckBoxM2ServerGetStart: TCheckBox
                Left = 8
                Top = 16
                Width = 97
                Height = 17
                Caption = #21551#21160#28216#25103#24341#25806
                TabOrder = 0
                OnClick = CheckBoxM2ServerGetStartClick
              end
            end
          end
          object ButtonPrv8: TButton
            Left = 304
            Top = 247
            Width = 81
            Height = 33
            Caption = #19978#19968#27493'(&P)'
            TabOrder = 1
            OnClick = ButtonPrv8Click
          end
          object ButtonNext8: TButton
            Left = 392
            Top = 247
            Width = 81
            Height = 33
            Caption = #19979#19968#27493'(&N)'
            TabOrder = 2
            OnClick = ButtonNext8Click
          end
        end
        object TabSheet11: TTabSheet
          Caption = #31532#20061#27493'('#20445#23384#37197#32622')'
          ImageIndex = 7
          object ButtonSave: TButton
            Left = 392
            Top = 247
            Width = 81
            Height = 33
            Caption = #20445#23384'(&S)'
            TabOrder = 0
            OnClick = ButtonSaveClick
          end
          object ButtonGenGameConfig: TButton
            Left = 216
            Top = 247
            Width = 81
            Height = 33
            Caption = #29983#25104#37197#32622'(&G)'
            TabOrder = 1
            OnClick = ButtonGenGameConfigClick
          end
          object ButtonPrv9: TButton
            Left = 304
            Top = 247
            Width = 81
            Height = 33
            Caption = #19978#19968#27493'(&P)'
            TabOrder = 2
            OnClick = ButtonPrv9Click
          end
          object GroupBox6: TGroupBox
            Left = 8
            Top = 8
            Width = 473
            Height = 57
            Caption = #20445#23384#35774#32622
            TabOrder = 3
            object Label8: TLabel
              Left = 8
              Top = 24
              Width = 216
              Height = 12
              Caption = #36873#25321#26159#21542#20445#23384#24403#21069#37197#32622#65292#29983#25104#37197#32622#25991#20214#12290
            end
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #25968#25454#22791#20221
      ImageIndex = 2
      object GroupBox43: TGroupBox
        Left = 5
        Top = 8
        Width = 503
        Height = 323
        Caption = #25968#25454#20445#23384#21442#25968#35774#32622
        TabOrder = 0
        object Label64: TLabel
          Left = 9
          Top = 198
          Width = 78
          Height = 12
          Caption = #25968#25454#20445#23384#30446#24405':'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object LabelNotice: TLabel
          Left = 10
          Top = 217
          Width = 487
          Height = 12
          AutoSize = False
          Caption = #22791#20221#25552#31034':......'
          Color = clBtnFace
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object Label65: TLabel
          Left = 102
          Top = 298
          Width = 180
          Height = 12
          Caption = #24517#39035#23433#35013'WinRar'#65292#24182#35774#32622#22909#36335#24452#65281
          Color = clBtnFace
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object EditIDDB: TEdit
          Left = 93
          Top = 15
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 0
          OnChange = EditIDDBChange
        end
        object EditFDB: TEdit
          Left = 93
          Top = 35
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 1
          OnChange = EditIDDBChange
        end
        object BitBtnFDB: TBitBtn
          Left = 464
          Top = 37
          Width = 28
          Height = 17
          Caption = '...'
          TabOrder = 2
          OnClick = BitBtnFDBClick
        end
        object BitBtnBACKUP: TBitBtn
          Left = 464
          Top = 197
          Width = 28
          Height = 17
          Caption = '...'
          TabOrder = 3
          OnClick = BitBtnBACKUPClick
        end
        object EditBakDir: TEdit
          Left = 93
          Top = 195
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 4
          OnChange = EditIDDBChange
        end
        object BitBtnGUILD: TBitBtn
          Left = 464
          Top = 57
          Width = 28
          Height = 17
          Caption = '...'
          TabOrder = 5
          OnClick = BitBtnGUILDClick
        end
        object EditGuild: TEdit
          Left = 93
          Top = 55
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 6
          OnChange = EditIDDBChange
        end
        object BitBtnIDDB: TBitBtn
          Left = 464
          Top = 16
          Width = 28
          Height = 18
          Caption = '...'
          TabOrder = 7
          OnClick = BitBtnIDDBClick
        end
        object BitBtnBak: TBitBtn
          Left = 15
          Top = 293
          Width = 79
          Height = 24
          Caption = #25163#21160#22791#20221'(&M)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnClick = BitBtnBakClick
        end
        object BitBtnSaveSetup: TBitBtn
          Left = 408
          Top = 293
          Width = 79
          Height = 24
          Caption = #20445#23384#37197#32622'(&S)'
          Enabled = False
          TabOrder = 9
          OnClick = BitBtnSaveSetupClick
        end
        object BitBtnPrv: TBitBtn
          Left = 320
          Top = 293
          Width = 79
          Height = 24
          Caption = #40664#35748#35774#32622'(&P)'
          TabOrder = 10
          OnClick = BitBtnPrvClick
        end
        object GroupBox44: TGroupBox
          Left = 7
          Top = 236
          Width = 489
          Height = 53
          TabOrder = 11
          object RadioButtonWeek: TRadioButton
            Left = 8
            Top = 19
            Width = 249
            Height = 17
            Caption = #27599'                     '#26102'         '#20998#25110
            Enabled = False
            TabOrder = 4
            OnClick = RadioButtonWeekClick
          end
          object RadioButtonMin: TRadioButton
            Left = 256
            Top = 19
            Width = 223
            Height = 17
            Caption = #27599'            '#20998#65292#36827#34892#36827#34892#25968#25454#22791#20221
            Enabled = False
            TabOrder = 0
            OnClick = RadioButtonMinClick
          end
          object SpinEditMinInter: TSpinEdit
            Left = 288
            Top = 17
            Width = 65
            Height = 21
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            MaxValue = 1000
            MinValue = 1
            ParentFont = False
            TabOrder = 1
            Value = 10
            OnChange = SpinEditMinInterChange
          end
          object SpinEditHour: TSpinEdit
            Left = 110
            Top = 18
            Width = 51
            Height = 21
            EditorEnabled = False
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            MaxValue = 23
            MinValue = 0
            ParentFont = False
            TabOrder = 2
            Value = 0
            OnChange = SpinEditHourChange
          end
          object SpinEditMin: TSpinEdit
            Left = 177
            Top = 18
            Width = 51
            Height = 21
            EditorEnabled = False
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            MaxValue = 59
            MinValue = 0
            ParentFont = False
            TabOrder = 3
            Value = 0
            OnChange = SpinEditMinChange
          end
          object ComboBoxInterDay: TComboBox
            Left = 40
            Top = 18
            Width = 65
            Height = 20
            Enabled = False
            Font.Charset = ANSI_CHARSET
            Font.Color = clBlack
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            ItemHeight = 12
            ParentFont = False
            TabOrder = 5
            Text = #27599#22825
            Items.Strings = (
              #27599#22825)
          end
        end
        object CheckBoxBackupTimer: TCheckBox
          Left = 15
          Top = 234
          Width = 89
          Height = 17
          Caption = #23450#26102#22791#20221#25968#25454
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          OnClick = CheckBoxBackupTimerClick
        end
        object EditData: TEdit
          Left = 93
          Top = 75
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 13
          OnChange = EditIDDBChange
        end
        object BitBtnData: TBitBtn
          Left = 464
          Top = 77
          Width = 28
          Height = 17
          Caption = '...'
          TabOrder = 14
          OnClick = BitBtnDataClick
        end
        object EditBigBagSize: TEdit
          Left = 93
          Top = 95
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 15
          OnChange = EditIDDBChange
        end
        object BitBtnBigBagSize: TBitBtn
          Left = 464
          Top = 97
          Width = 28
          Height = 17
          Caption = '...'
          TabOrder = 16
          OnClick = BitBtnBigBagSizeClick
        end
        object BitBtnSabuk: TBitBtn
          Left = 464
          Top = 117
          Width = 28
          Height = 17
          Caption = '...'
          TabOrder = 17
          OnClick = BitBtnSabukClick
        end
        object EditSabuk: TEdit
          Left = 93
          Top = 115
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 18
          OnChange = EditIDDBChange
        end
        object CheckBox1: TCheckBox
          Left = 9
          Top = 15
          Width = 84
          Height = 17
          Caption = 'IDDB'#28304#30446#24405':'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 19
          OnClick = CheckBox1Click
        end
        object CheckBox2: TCheckBox
          Left = 9
          Top = 35
          Width = 84
          Height = 17
          Caption = 'FDB '#28304#30446#24405':'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 20
          OnClick = CheckBox1Click
        end
        object CheckBox3: TCheckBox
          Left = 9
          Top = 55
          Width = 84
          Height = 17
          Caption = #34892#20250#28304#30446#24405':'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 21
          OnClick = CheckBox1Click
        end
        object CheckBox4: TCheckBox
          Left = 9
          Top = 75
          Width = 84
          Height = 17
          Caption = #25968#25454#28304#30446#24405':'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 22
          OnClick = CheckBox1Click
        end
        object CheckBox5: TCheckBox
          Left = 9
          Top = 95
          Width = 84
          Height = 17
          Caption = #21253#35065#28304#30446#24405':'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 23
          OnClick = CheckBox1Click
        end
        object CheckBox6: TCheckBox
          Left = 9
          Top = 115
          Width = 84
          Height = 17
          Caption = #27801#22478#28304#30446#24405':'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 24
          OnClick = CheckBox1Click
        end
        object EditOtherSourceDir1: TEdit
          Left = 93
          Top = 135
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 25
          OnChange = EditIDDBChange
        end
        object BitBtn1: TBitBtn
          Left = 464
          Top = 137
          Width = 28
          Height = 17
          Caption = '...'
          TabOrder = 26
          OnClick = BitBtn1Click
        end
        object CheckBox7: TCheckBox
          Left = 9
          Top = 135
          Width = 84
          Height = 17
          Caption = #20445#30041#30446#24405#19968':'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 27
          OnClick = CheckBox1Click
        end
        object EditOtherSourceDir2: TEdit
          Left = 93
          Top = 155
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 28
          OnChange = EditIDDBChange
        end
        object BitBtn2: TBitBtn
          Left = 464
          Top = 157
          Width = 28
          Height = 17
          Caption = '...'
          TabOrder = 29
          OnClick = BitBtn2Click
        end
        object CheckBox8: TCheckBox
          Left = 9
          Top = 155
          Width = 84
          Height = 17
          Caption = #20445#30041#30446#24405#20108':'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 30
          OnClick = CheckBox1Click
        end
        object EditWinrarFile: TEdit
          Left = 93
          Top = 175
          Width = 365
          Height = 20
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          TabOrder = 31
          Text = 'C:\'
          OnChange = EditIDDBChange
        end
        object BitBtnWinrarFile: TBitBtn
          Left = 464
          Top = 177
          Width = 28
          Height = 17
          Caption = '...'
          TabOrder = 32
          OnClick = BitBtnWinrarFileClick
        end
        object CheckBox9: TCheckBox
          Left = 9
          Top = 175
          Width = 84
          Height = 17
          Caption = 'WinRar'#30446#24405':'
          Checked = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          State = cbChecked
          TabOrder = 33
          OnClick = CheckBox1Click
        end
      end
    end
    object TabSheet14: TTabSheet
      Caption = #25968#25454#28165#29702
      ImageIndex = 4
      object Label26: TLabel
        Left = 3
        Top = 6
        Width = 48
        Height = 12
        Caption = #22522#26412#30446#24405
      end
      object Button2: TButton
        Left = 442
        Top = 3
        Width = 67
        Height = 21
        Caption = #24320#22987#28165#29702
        TabOrder = 1
        OnClick = Button2Click
      end
      object EditMirDir: TEdit
        Left = 57
        Top = 3
        Width = 228
        Height = 20
        Enabled = False
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        TabOrder = 2
        Text = #24517#39035#20808#36873#25321#28216#25103#26681#30446#24405#65288'D:\MirServer\'#65289
        OnChange = EditIDDBChange
      end
      object BitBtnMirDir: TBitBtn
        Left = 290
        Top = 3
        Width = 58
        Height = 20
        Caption = #36873#25321#36335#24452
        Default = True
        TabOrder = 0
        OnClick = BitBtnMirDirClick
      end
      object GroupBox21: TGroupBox
        Left = 3
        Top = 24
        Width = 507
        Height = 73
        Caption = #22266#23450#25968#25454#21024#38500
        TabOrder = 3
        object CheckBox11: TCheckBox
          Left = 7
          Top = 16
          Width = 97
          Height = 17
          Caption = #24341#25806#26085#24535
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CheckBox12: TCheckBox
          Left = 7
          Top = 33
          Width = 97
          Height = 17
          Caption = #24341#25806#30331#38470#26085#24535
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object CheckBox13: TCheckBox
          Left = 7
          Top = 49
          Width = 97
          Height = 17
          Caption = #27801#22478#25968#25454
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object CheckBox14: TCheckBox
          Left = 108
          Top = 16
          Width = 97
          Height = 17
          Caption = #34892#20250#25968#25454
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object CheckBox15: TCheckBox
          Left = 108
          Top = 32
          Width = 97
          Height = 17
          Caption = #20132#26131#24066#22330#25968#25454
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object CheckBox16: TCheckBox
          Left = 108
          Top = 48
          Width = 97
          Height = 17
          Caption = #27494#22120#21319#32423#25968#25454
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object CheckBox17: TCheckBox
          Left = 209
          Top = 16
          Width = 97
          Height = 17
          Caption = #21830#20154#32531#20914#25968#25454
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object CheckBox18: TCheckBox
          Left = 209
          Top = 48
          Width = 97
          Height = 17
          Caption = #35282#33394#25968#25454
          Checked = True
          State = cbChecked
          TabOrder = 7
        end
        object CheckBox19: TCheckBox
          Left = 310
          Top = 16
          Width = 97
          Height = 17
          Caption = #24080#21495#25968#25454
          Checked = True
          State = cbChecked
          TabOrder = 8
        end
        object CheckBox20: TCheckBox
          Left = 310
          Top = 32
          Width = 97
          Height = 17
          Caption = #24080#21495#27880#20876#26085#24535
          Checked = True
          State = cbChecked
          TabOrder = 9
        end
        object CheckBox21: TCheckBox
          Left = 310
          Top = 48
          Width = 97
          Height = 17
          Caption = #24080#21495#32479#35745#26085#24535
          Checked = True
          State = cbChecked
          TabOrder = 10
        end
        object CheckBox22: TCheckBox
          Left = 412
          Top = 16
          Width = 91
          Height = 17
          Caption = #28216#25103#29289#21697#26085#24535
          Checked = True
          State = cbChecked
          TabOrder = 11
        end
        object CheckBox23: TCheckBox
          Left = 209
          Top = 33
          Width = 97
          Height = 17
          Caption = #28216#25103#20840#23616#21464#37327
          Checked = True
          State = cbChecked
          TabOrder = 12
        end
      end
      object GroupBox30: TGroupBox
        Left = 3
        Top = 96
        Width = 507
        Height = 110
        Caption = #33258#23450#25991#26412#28165#31354' ('#21491#38190#23637#24320#33756#21333')('#22810#36873#26041#27861#65306#24038#38190#25353#20303#25289#21015#34920#25110#37197#21512'CTRL SHIFT'#31561#20351#29992')'
        TabOrder = 4
        object CheckListBoxClear: TListBox
          Left = 2
          Top = 14
          Width = 503
          Height = 94
          Align = alClient
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ItemHeight = 12
          MultiSelect = True
          PopupMenu = PopupMenu1
          TabOrder = 0
        end
      end
      object GroupBox31: TGroupBox
        Left = 3
        Top = 209
        Width = 507
        Height = 110
        Caption = #33258#23450#25991#26412#21024#38500' ('#21491#38190#23637#24320#33756#21333')('#22810#36873#26041#27861#65306#21516#19978')'
        TabOrder = 5
        object CheckListBoxDel: TListBox
          Left = 2
          Top = 14
          Width = 503
          Height = 94
          Align = alClient
          ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
          ItemHeight = 12
          MultiSelect = True
          PopupMenu = PopupMenu2
          TabOrder = 0
        end
      end
      object ProgressBarCur: TProgressBar
        Left = 3
        Top = 321
        Width = 507
        Height = 15
        TabOrder = 6
      end
      object Button3: TButton
        Left = 354
        Top = 3
        Width = 59
        Height = 21
        Caption = #20445#23384#35774#32622
        TabOrder = 7
        OnClick = Button3Click
      end
    end
  end
  object TimerStartGame: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerStartGameTimer
    Left = 304
    Top = 256
  end
  object TimerStopGame: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerStopGameTimer
    Left = 208
    Top = 256
  end
  object TimerCheckRun: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = TimerCheckRunTimer
    Left = 176
    Top = 256
  end
  object TimerAutoBackup: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = TimerAutoBackupTimer
    Left = 272
    Top = 256
  end
  object OpenDlg: TOpenDialog
    Left = 369
    Top = 255
  end
  object Timer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerTimer
    Left = 336
    Top = 256
  end
  object TimerCheckDebug: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerCheckDebugTimer
    Left = 240
    Top = 256
  end
  object PopupMenu1: TPopupMenu
    Left = 88
    Top = 256
    object MenuItem3: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = MenuItem3Click
    end
    object N1: TMenuItem
      Caption = #33258#21160#22686#21152'(&S)'
      OnClick = N1Click
    end
    object MenuItem4: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = MenuItem4Click
    end
    object MenuItem5: TMenuItem
      Caption = #20840#37096#21024#38500'(&C)'
      OnClick = MenuItem5Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object O1: TMenuItem
      Caption = #26597#30475#25991#20214'(&O)'
      OnClick = O1Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = #25991#26412#25991#20214'(*.txt)|*.txt'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 121
    Top = 255
  end
  object PopupMenu2: TPopupMenu
    Left = 352
    Top = 296
    object MenuItem1: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Caption = #33258#21160#22686#21152'(&S)'
      Enabled = False
      OnClick = N1Click
    end
    object MenuItem6: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = MenuItem6Click
    end
    object MenuItem7: TMenuItem
      Caption = #20840#37096#21024#38500'(&C)'
      OnClick = MenuItem7Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object O2: TMenuItem
      Caption = #26597#30475#25991#20214'(&O)'
      OnClick = O2Click
    end
  end
end
