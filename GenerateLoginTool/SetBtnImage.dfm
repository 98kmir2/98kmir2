object FrmSetBtnImage: TFrmSetBtnImage
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #25353#38062#22270#29255#35774#32622
  ClientHeight = 322
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 17
    Top = 6
    Width = 216
    Height = 127
    Caption = #25353#38062#22270#29255
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Image1: TImage
      Left = 65
      Top = 57
      Width = 78
      Height = 20
      AutoSize = True
      OnDblClick = RzButton3Click
    end
    object RzButton3: TRzButton
      Left = 186
      Top = 100
      Width = 23
      Height = 19
      Caption = '...'
      TabOrder = 0
      OnClick = RzButton3Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 251
    Top = 6
    Width = 216
    Height = 127
    Caption = #40736#26631#31227#21160
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Image2: TImage
      Left = 65
      Top = 57
      Width = 78
      Height = 20
      AutoSize = True
      OnDblClick = RzButton4Click
    end
    object RzButton4: TRzButton
      Left = 186
      Top = 100
      Width = 23
      Height = 19
      Caption = '...'
      TabOrder = 0
      OnClick = RzButton4Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 251
    Top = 140
    Width = 216
    Height = 127
    Caption = #31105#27490#20351#29992
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Image4: TImage
      Left = 65
      Top = 57
      Width = 78
      Height = 20
      AutoSize = True
      OnDblClick = RzButton6Click
    end
    object RzButton6: TRzButton
      Left = 186
      Top = 100
      Width = 23
      Height = 19
      Caption = '...'
      TabOrder = 0
      OnClick = RzButton6Click
    end
  end
  object GroupBox4: TGroupBox
    Left = 17
    Top = 140
    Width = 216
    Height = 127
    Caption = #40736#26631#25353#19979
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Image3: TImage
      Left = 65
      Top = 57
      Width = 78
      Height = 20
      AutoSize = True
      OnDblClick = RzButton5Click
    end
    object RzButton5: TRzButton
      Left = 186
      Top = 100
      Width = 23
      Height = 19
      Caption = '...'
      TabOrder = 0
      OnClick = RzButton5Click
    end
  end
  object RzButton1: TRzButton
    Left = 108
    Top = 282
    Width = 79
    ModalResult = 1
    Caption = #30830'    '#23450
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
  end
  object RzButton2: TRzButton
    Left = 306
    Top = 282
    Width = 79
    ModalResult = 2
    Caption = #21462'    '#28040
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 
      'All (*.jpg;*.jpeg;*.bmp)|*.jpg;*.jpeg;*.bmp|JPEG Image File (*.j' +
      'pg)|*.jpg|JPEG Image File (*.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.bmp'
    Left = 224
    Top = 56
  end
end
