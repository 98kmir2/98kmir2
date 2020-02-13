object frmViewSession: TfrmViewSession
  Left = 410
  Top = 200
  Width = 425
  Height = 226
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #26597#30475#20840#23616#20250#35805
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object ButtonRefGrid: TButton
    Left = 328
    Top = 160
    Width = 73
    Height = 25
    Caption = #21047#26032'(&R)'
    TabOrder = 0
    OnClick = ButtonRefGridClick
  end
  object PanelStatus: TPanel
    Left = 8
    Top = 8
    Width = 401
    Height = 145
    TabOrder = 1
    object GridSession: TStringGrid
      Left = 1
      Top = 1
      Width = 399
      Height = 143
      Align = alClient
      ColCount = 6
      DefaultRowHeight = 18
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      ColWidths = (
        36
        92
        91
        60
        47
        58)
    end
  end
end
