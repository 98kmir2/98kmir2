object frmGeneralConfig: TfrmGeneralConfig
  Left = 990
  Top = 426
  Caption = #22522#26412#21442#25968' ('#32593#32476#35774#32622#38656#21551#21160#29983#25928')'
  ClientHeight = 146
  ClientWidth = 378
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 224
    Top = 14
    Width = 30
    Height = 12
    Caption = #26631#39064':'
  end
  object labShowLogLevel: TLabel
    Left = 224
    Top = 42
    Width = 90
    Height = 12
    Caption = #26174#31034#26085#24535#31561#32423': 0'
  end
  object btnSave: TButton
    Left = 296
    Top = 112
    Width = 74
    Height = 26
    Hint = #20445#23384#24403#21069#35774#32622#65292#32593#32476#35774#32622#20110#19979#19968#27425#21551#21160#13#10#26381#21153#26102#29983#25928#12290
    Caption = #30830#23450'(&O)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object EditTitle: TEdit
    Left = 256
    Top = 10
    Width = 113
    Height = 20
    Hint = #31243#24207#26631#39064#19978#26174#31034#30340#21517#31216#65292#27492#21517#31216#21482#29992#20110#26174#31034#13#10#26242#26102#19981#20570#20854#23427#29992#36884#12290
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = 'LegendGame'
    OnChange = EditTitleChange
  end
  object TrackBarLogLevel: TTrackBar
    Left = 219
    Top = 56
    Width = 157
    Height = 25
    Hint = #31243#24207#36816#34892#26085#24535#26174#31034#35814#32454#31561#32423#12290
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnChange = TrackBarLogLevelChange
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 205
    Height = 129
    Caption = #32593#20851#25968#37327':         '
    TabOrder = 3
    object LabelServerIPaddr: TLabel
      Left = 7
      Top = 52
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#22320#22336':'
    end
    object LabelServerPort: TLabel
      Left = 7
      Top = 76
      Width = 66
      Height = 12
      Caption = #26381#21153#22120#31471#21475':'
    end
    object LabelGatePort: TLabel
      Left = 8
      Top = 100
      Width = 54
      Height = 12
      Caption = #32593#20851#31471#21475':'
    end
    object Label2: TLabel
      Left = 8
      Top = 26
      Width = 186
      Height = 12
      Caption = #36873#25321#32534#21495':          '#32534#36753#32593#20851#35774#32622
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object EditServerIPaddr: TEdit
      Left = 72
      Top = 48
      Width = 121
      Height = 20
      Hint = #28216#25103#26381#21153#22120'(M2)'#30340'IP'#22320#22336#65292#22914#26524#26159#21333#26426#13#36816#34892#26381#21153#22120#31471#30340#65292#19968#33324#23601#29992' 127.0.0.1 '#12290
      MaxLength = 15
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '127.0.0.1'
      OnChange = EditServerIPaddrChange
    end
    object EditServerPort: TEdit
      Left = 72
      Top = 72
      Width = 33
      Height = 20
      Hint = #28216#25103#26381#21153#22120'(M2)'#30340#31471#21475#65292#27492#31471#21475#26631#20934#20026' 5000'#65292#22914#26524#13#20351#29992#30340#28216#25103#26381#21153#22120#31471#20462#25913#36807#65292#21017#25913#20026#30456#24212#30340#31471#21475#12290
      MaxLength = 5
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '5000'
      OnChange = EditServerIPaddrChange
    end
    object EditGatePort: TEdit
      Left = 72
      Top = 96
      Width = 33
      Height = 20
      Hint = #32593#20851#23545#22806#24320#25918#30340#31471#21475#21495#65292#27492#31471#21475#26631#20934#20026' 7200'#65292#13#10#27492#31471#21475#21487#26681#25454#33258#24049#30340#35201#27714#36827#34892#20462#25913#12290
      MaxLength = 5
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '7200'
      OnChange = EditServerIPaddrChange
    end
    object speGateIdx: TSpinEdit
      Left = 72
      Top = 22
      Width = 41
      Height = 21
      EditorEnabled = False
      MaxValue = 32
      MinValue = 1
      TabOrder = 3
      Value = 32
      OnChange = speGateIdxChange
    end
  end
  object speGateCount: TSpinEdit
    Left = 80
    Top = 5
    Width = 41
    Height = 21
    EditorEnabled = False
    MaxValue = 32
    MinValue = 1
    TabOrder = 4
    Value = 32
    OnChange = speGateCountChange
  end
  object cbAddLog: TCheckBox
    Tag = 106
    Left = 224
    Top = 82
    Width = 146
    Height = 17
    Caption = #35760#24405#26085#24535#21040#25991#26412'Log.txt'
    TabOrder = 5
    OnClick = cbAddLogClick
  end
end
