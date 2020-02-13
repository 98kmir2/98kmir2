object PasswordDialog: TPasswordDialog
  Left = 311
  Top = 241
  Width = 281
  Height = 165
  Caption = 'Enter password'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object OKButton: TButton
    Left = 109
    Top = 98
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 190
    Top = 98
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 257
    Height = 81
    Caption = 'Password'
    TabOrder = 2
    object Edit: TEdit
      Left = 16
      Top = 18
      Width = 225
      Height = 21
      PasswordChar = '*'
      TabOrder = 0
    end
    object AddButton: TButton
      Left = 16
      Top = 46
      Width = 65
      Height = 25
      Caption = '&Add'
      Enabled = False
      TabOrder = 1
    end
    object RemoveButton: TButton
      Left = 88
      Top = 46
      Width = 65
      Height = 25
      Caption = '&Remove'
      Enabled = False
      TabOrder = 2
    end
    object RemoveAllButton: TButton
      Left = 160
      Top = 46
      Width = 81
      Height = 25
      Caption = 'Re&move all'
      TabOrder = 3
    end
  end
end
