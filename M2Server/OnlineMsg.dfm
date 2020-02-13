object frmOnlineMsg: TfrmOnlineMsg
  Left = 310
  Top = 249
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #22312#32447#21457#36865#28040#24687
  ClientHeight = 330
  ClientWidth = 470
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 4
    Top = 169
    Width = 54
    Height = 12
    Caption = #22312#32447#20449#24687':'
  end
  object ComboBoxMsg: TComboBox
    Left = 63
    Top = 165
    Width = 402
    Height = 20
    Style = csSimple
    ItemHeight = 12
    TabOrder = 0
    OnChange = ComboBoxMsgChange
    OnKeyPress = ComboBoxMsgKeyPress
  end
  object MemoMsg: TMemo
    Left = 3
    Top = 4
    Width = 462
    Height = 153
    Lines.Strings = (
      'MemoMsg')
    TabOrder = 1
    OnChange = MemoMsgChange
  end
  object StringGrid: TStringGrid
    Left = 3
    Top = 219
    Width = 462
    Height = 106
    ColCount = 1
    DefaultColWidth = 465
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    ScrollBars = ssVertical
    TabOrder = 2
    OnClick = StringGridClick
    OnDblClick = StringGridDblClick
  end
  object ButtonAdd: TButton
    Left = 399
    Top = 191
    Width = 67
    Height = 23
    Caption = #22686#21152'(&A)'
    Enabled = False
    TabOrder = 3
    OnClick = ButtonAddClick
  end
  object ButtonDelete: TButton
    Left = 325
    Top = 191
    Width = 67
    Height = 23
    Caption = #21024#38500'(&D)'
    Enabled = False
    TabOrder = 4
    OnClick = ButtonDeleteClick
  end
  object ButtonSend: TButton
    Left = 212
    Top = 190
    Width = 85
    Height = 23
    Caption = #21457#36865'(&S)'
    TabOrder = 5
    OnClick = ButtonSendClick
  end
end
