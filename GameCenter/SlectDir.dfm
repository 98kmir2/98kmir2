object FormSlectDir: TFormSlectDir
  Left = 448
  Top = 232
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #36873#25321#36335#24452
  ClientHeight = 298
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 12
  object LabelCurPath: TLabel
    Left = 18
    Top = 16
    Width = 289
    Height = 12
    AutoSize = False
    Caption = #24403#21069#36335#24452':'
  end
  object BitBtnSelectDir: TBitBtn
    Left = 128
    Top = 265
    Width = 75
    Height = 22
    Caption = #30830#23450'(&O)'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = BitBtnSelectDirClick
    NumGlyphs = 2
  end
  object BitBtnCancel: TBitBtn
    Left = 215
    Top = 265
    Width = 75
    Height = 22
    Caption = #21462#28040'(&C)'
    ModalResult = 2
    TabOrder = 0
    NumGlyphs = 2
  end
end
