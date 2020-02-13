object FrmIDHum: TFrmIDHum
  Left = 632
  Top = 312
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #20154#29289#31649#29702
  ClientHeight = 275
  ClientWidth = 681
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label3: TLabel
    Left = 248
    Top = 12
    Width = 54
    Height = 12
    Caption = #20154#29289#21517#31216':'
  end
  object Label4: TLabel
    Left = 9
    Top = 592
    Width = 54
    Height = 12
    Caption = #24080#21495#21015#34920':'
  end
  object BtnCreateChr: TSpeedButton
    Left = 6
    Top = 242
    Width = 79
    Height = 24
    Caption = #21019#24314#20154#29289
    OnClick = BtnCreateChrClick
  end
  object BtnEraseChr: TSpeedButton
    Left = 90
    Top = 242
    Width = 79
    Height = 24
    Caption = #21024#38500#20154#29289
    OnClick = BtnEraseChrClick
  end
  object BtnChrNameSearch: TSpeedButton
    Left = 401
    Top = 7
    Width = 72
    Height = 22
    Caption = #35282#33394#26597#25214
    OnClick = BtnChrNameSearchClick
  end
  object BtnSelAll: TSpeedButton
    Left = 481
    Top = 7
    Width = 72
    Height = 22
    Caption = #27169#31946#26597#25214
    OnClick = BtnSelAllClick
  end
  object BtnDeleteChr: TSpeedButton
    Left = 174
    Top = 242
    Width = 79
    Height = 24
    Caption = #31105#29992#20154#29289
    OnClick = BtnDeleteChrClick
  end
  object BtnRevival: TSpeedButton
    Left = 258
    Top = 242
    Width = 79
    Height = 24
    Caption = #21551#29992#20154#29289
    OnClick = BtnRevivalClick
  end
  object SpeedButton1: TSpeedButton
    Left = 594
    Top = 242
    Width = 79
    Height = 24
    Caption = #25968#25454#31649#29702#24037#20855
    OnClick = SpeedButton1Click
  end
  object Label2: TLabel
    Left = 10
    Top = 12
    Width = 54
    Height = 12
    Caption = #30331#24405#24080#21495':'
  end
  object BtnDeleteChrAllInfo: TSpeedButton
    Left = 510
    Top = 242
    Width = 79
    Height = 24
    Caption = #21024#38500#20154#29289#25968#25454
    OnClick = BtnDeleteChrAllInfoClick
  end
  object SpeedButton2: TSpeedButton
    Left = 342
    Top = 242
    Width = 79
    Height = 24
    Caption = #31105#29992#32034#24341#21495
    OnClick = SpeedButton2Click
  end
  object LabelCount: TLabel
    Left = 72
    Top = 40
    Width = 6
    Height = 12
  end
  object SpeedButtonEditData: TSpeedButton
    Left = 427
    Top = 243
    Width = 79
    Height = 24
    Caption = #32534#36753#25968#25454
    OnClick = SpeedButtonEditDataClick
  end
  object Label1: TLabel
    Left = 256
    Top = 688
    Width = 36
    Height = 12
    Caption = 'lAbEl1'
  end
  object BtnChrAccountSearch: TSpeedButton
    Left = 161
    Top = 7
    Width = 72
    Height = 22
    Caption = #24080#21495#26597#25214
    OnClick = BtnChrAccountSearchClick
  end
  object EdChrName: TEdit
    Left = 304
    Top = 8
    Width = 89
    Height = 20
    TabOrder = 0
    OnKeyPress = EdChrNameKeyPress
  end
  object IdGrid: TStringGrid
    Left = 8
    Top = 608
    Width = 617
    Height = 73
    ColCount = 8
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 1
    ColWidths = (
      69
      70
      77
      95
      70
      78
      194
      64)
  end
  object ChrGrid: TStringGrid
    Left = 8
    Top = 34
    Width = 665
    Height = 199
    ColCount = 6
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 12
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 2
    OnClick = ChrGridClick
    OnDblClick = ChrGridDblClick
    ColWidths = (
      94
      99
      98
      103
      191
      71)
  end
  object CbShowDelChr: TCheckBox
    Left = 569
    Top = 10
    Width = 96
    Height = 17
    Caption = #26174#31034#31105#29992#20154#29289
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object EdUserId: TEdit
    Left = 68
    Top = 8
    Width = 85
    Height = 20
    TabOrder = 4
    OnKeyPress = EdUserIdKeyPress
  end
  object Edit1: TEdit
    Left = 8
    Top = 688
    Width = 113
    Height = 20
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 136
    Top = 688
    Width = 113
    Height = 20
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = 'fds'
  end
end
