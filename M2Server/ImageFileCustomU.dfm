object ftmImageFileCustom: TftmImageFileCustom
  Left = 404
  Top = 331
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #33258#23450#20041#36164#28304#25991#20214#21015#34920
  ClientHeight = 226
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
  object lbl: TLabel
    Left = 9
    Top = 13
    Width = 57
    Height = 12
    AutoSize = False
    Caption = #25991#20214#21517
  end
  object ListBoxImageFileCustom: TListBox
    Left = 8
    Top = 38
    Width = 329
    Height = 177
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ItemHeight = 12
    ParentFont = False
    TabOrder = 0
  end
  object BtnAdd: TButton
    Left = 352
    Top = 8
    Width = 77
    Height = 23
    Caption = #22686#21152
    TabOrder = 1
    OnClick = BtnAddClick
  end
  object btnDel: TButton
    Left = 352
    Top = 40
    Width = 77
    Height = 23
    Caption = #21024#38500
    TabOrder = 2
    OnClick = btnDelClick
  end
  object btnSave: TButton
    Left = 352
    Top = 72
    Width = 77
    Height = 23
    Caption = #20445#23384
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object edtFileName: TEdit
    Left = 51
    Top = 9
    Width = 254
    Height = 20
    TabOrder = 4
  end
  object btnSelect: TButton
    Left = 309
    Top = 8
    Width = 25
    Height = 25
    Caption = '...'
    TabOrder = 5
    OnClick = btnSelectClick
  end
  object dlgOpen: TOpenDialog
    Filter = '*.wil|*.wil|*.wzl|*.wzl'
    Left = 344
    Top = 192
  end
end
