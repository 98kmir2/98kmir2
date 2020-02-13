object FormCastleAttackEdit: TFormCastleAttackEdit
  Left = 529
  Top = 187
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #25915#22478#30003#35831
  ClientHeight = 185
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 345
    Height = 169
    Caption = #25915#22478#30003#35831
    TabOrder = 0
    object Label1: TLabel
      Left = 148
      Top = 45
      Width = 54
      Height = 12
      Caption = #34892#20250#21517#31216':'
    end
    object Label2: TLabel
      Left = 148
      Top = 69
      Width = 54
      Height = 12
      Caption = #25915#22478#26085#26399':'
    end
    object EditName: TEdit
      Left = 206
      Top = 40
      Width = 127
      Height = 20
      Enabled = False
      MaxLength = 15
      TabOrder = 0
      OnChange = EditNameChange
    end
    object DateTimePicker: TDateTimePicker
      Left = 206
      Top = 64
      Width = 127
      Height = 20
      Date = 0.476797592600632900
      Time = 0.476797592600632900
      TabOrder = 1
    end
    object ButtonOK: TButton
      Left = 158
      Top = 134
      Width = 79
      Height = 23
      Caption = #30830#23450'(&O)'
      Enabled = False
      TabOrder = 2
      OnClick = ButtonOKClick
    end
    object CheckBoxAllGuild: TCheckBox
      Left = 148
      Top = 16
      Width = 97
      Height = 17
      Caption = #30003#35831#25152#26377#34892#20250
      TabOrder = 3
      OnClick = CheckBoxAllGuildClick
    end
    object ListBoxGuildList: TListBox
      Left = 8
      Top = 16
      Width = 129
      Height = 145
      ItemHeight = 12
      TabOrder = 4
      OnClick = ListBoxGuildListClick
    end
    object ButtonCancel: TButton
      Left = 246
      Top = 134
      Width = 79
      Height = 23
      Caption = #21462#28040'(&C)'
      ModalResult = 2
      TabOrder = 5
    end
  end
end
