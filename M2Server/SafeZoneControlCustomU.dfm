object ftmSafeZoneControlCustom: TftmSafeZoneControlCustom
  Left = 404
  Top = 331
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #33258#23450#20041#24322#24418#23433#20840#21306
  ClientHeight = 234
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object lbl1: TLabel
    Left = 10
    Top = 176
    Width = 48
    Height = 12
    Caption = #32534#21495#25991#20214
  end
  object lbl2: TLabel
    Left = 181
    Top = 206
    Width = 168
    Height = 12
    Caption = #25552#31034':'#20445#23384#25968#25454#21518','#37325#21551'M2'#21518#29983#25928
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object BtnAdd: TButton
    Left = 16
    Top = 199
    Width = 77
    Height = 23
    Caption = #22686#21152#32534#21495#25991#20214
    TabOrder = 0
    OnClick = BtnAddClick
  end
  object btnDel: TButton
    Left = 99
    Top = 199
    Width = 77
    Height = 23
    Caption = #21024#38500#32534#21495#25991#20214
    TabOrder = 1
    OnClick = btnDelClick
  end
  object btnSave: TButton
    Left = 352
    Top = 200
    Width = 77
    Height = 23
    Caption = #20445#23384#22352#26631#25968#25454
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object grp1: TGroupBox
    Left = 8
    Top = 0
    Width = 183
    Height = 169
    Caption = #33258#23450#20041#24322#24418#23433#20840#21306#20851#32852#32534#21495#25991#20214
    TabOrder = 3
    object lstTxtCustom: TListBox
      Left = 8
      Top = 14
      Width = 165
      Height = 147
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      TabOrder = 0
      OnClick = lstTxtCustomClick
    end
  end
  object grp2: TGroupBox
    Left = 192
    Top = 0
    Width = 241
    Height = 193
    Caption = #23433#20840#21306#22352#26631#31995'X,Y'
    TabOrder = 4
    object lblPath: TLabel
      Left = 8
      Top = 174
      Width = 114
      Height = 12
      Caption = #24403#21069#22352#26631#20445#23384#25991#20214#20026':'
    end
    object lblTxt: TLabel
      Left = 125
      Top = 175
      Width = 105
      Height = 12
      AutoSize = False
    end
    object MemoPointArr: TMemo
      Left = 3
      Top = 16
      Width = 230
      Height = 153
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object EdtCustomID: TSpinEdit
    Left = 66
    Top = 172
    Width = 115
    Height = 21
    Hint = #32534#21495#25991#20214#33539#22260#20026'10000..19999'
    MaxValue = 19999
    MinValue = 10000
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Value = 10000
  end
end
