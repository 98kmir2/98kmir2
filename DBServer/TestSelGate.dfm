object frmTestSelGate: TfrmTestSelGate
  Left = 390
  Top = 433
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #27979#35797#36873#25321#32593#20851
  ClientHeight = 153
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 4
    Width = 289
    Height = 141
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 60
      Width = 54
      Height = 12
      Caption = #35282#33394#32593#20851':'
    end
    object Label2: TLabel
      Left = 8
      Top = 84
      Width = 54
      Height = 12
      Caption = #28216#25103#32593#20851':'
    end
    object Label3: TLabel
      Left = 9
      Top = 12
      Width = 78
      Height = 12
      Caption = #27979#35797#36873#25321#32593#20851':'
    end
    object Label4: TLabel
      Left = 8
      Top = 36
      Width = 54
      Height = 12
      Caption = #26381#21153#22120#21495':'
    end
    object EditSelGate: TEdit
      Left = 64
      Top = 56
      Width = 121
      Height = 20
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditGameGate: TEdit
      Left = 64
      Top = 80
      Width = 209
      Height = 20
      TabOrder = 1
    end
    object ButtonTest: TButton
      Left = 96
      Top = 108
      Width = 74
      Height = 21
      Caption = #27979#35797'(&T)'
      TabOrder = 2
      OnClick = ButtonTestClick
    end
    object Button1: TButton
      Left = 176
      Top = 108
      Width = 74
      Height = 21
      Caption = #37197#32622'(&C)'
      TabOrder = 3
      OnClick = Button1Click
    end
    object EditServerIdx: TEdit
      Left = 64
      Top = 32
      Width = 121
      Height = 20
      TabOrder = 4
      Text = '0'
    end
  end
end
