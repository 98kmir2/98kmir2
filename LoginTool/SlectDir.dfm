object FormSlectDir: TFormSlectDir
  Left = 708
  Top = 187
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #36873#25321#30446#24405
  ClientHeight = 332
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object LabelCaption: TLabel
    Left = 16
    Top = 16
    Width = 48
    Height = 12
    Caption = #36873#25321#30446#24405
  end
  object BitBtnSelectDir: TBitBtn
    Left = 152
    Top = 297
    Width = 81
    Height = 23
    Caption = #30830#23450'(&O)'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = BitBtnSelectDirClick
    NumGlyphs = 2
  end
  object BitBtnCancel: TBitBtn
    Left = 239
    Top = 296
    Width = 82
    Height = 23
    Caption = #21462#28040'(&C)'
    TabOrder = 0
    OnClick = BitBtnCancelClick
    NumGlyphs = 2
  end
  object RzShellTree: TRzShellTree
    Left = 24
    Top = 34
    Width = 305
    Height = 247
    Indent = 19
    TabOrder = 2
    OnChange = RzShellTreeChange
  end
end
