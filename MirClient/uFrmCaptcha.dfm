object frmCaptcha: TfrmCaptcha
  Left = 470
  Top = 367
  BorderStyle = bsDialog
  Caption = #35831#36755#20837#27491#30830#39564#35777#30721
  ClientHeight = 200
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 19
    Top = 125
    Width = 90
    Height = 12
    Caption = #36755#20837#19978#38754#22270#29255#30340#31572#26696
  end
  object Label2: TLabel
    Left = 25
    Top = 176
    Width = 40
    Height = 12
    Caption = #36820#22238#32467#26524
  end
  object Edit1: TEdit
    Left = 25
    Top = 144
    Width = 144
    Height = 20
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 304
    Height = 121
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 302
      Height = 119
      Align = alClient
      Center = True
    end
  end
  object Button2: TBitBtn
    Left = 186
    Top = 144
    Width = 97
    Height = 19
    Caption = #25552#20132
    TabOrder = 2
    OnClick = Button2Click
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 280
    Top = 168
  end
  object Timer2: TTimer
    Interval = 500
    OnTimer = Timer2Timer
    Left = 216
    Top = 208
  end
end
