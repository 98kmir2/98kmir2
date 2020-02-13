object FrmLogin: TFrmLogin
  Left = 443
  Top = 228
  BorderStyle = bsDialog
  Caption = #28216#25103#30331#24405
  ClientHeight = 267
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl3: TLabel
    Left = 76
    Top = 237
    Width = 48
    Height = 13
    Caption = #20998#36776#29575#65306
  end
  object grp1: TGroupBox
    Left = 7
    Top = 7
    Width = 336
    Height = 214
    Caption = #26381#21153#22120#21015#34920
    TabOrder = 0
    object lbl1: TLabel
      Left = 7
      Top = 137
      Width = 72
      Height = 13
      Caption = #26381#21153#22120#21517#31216#65306
    end
    object Label1: TLabel
      Left = 7
      Top = 159
      Width = 72
      Height = 13
      Caption = #26381#21153#22120#22320#22336#65306
    end
    object lbl2: TLabel
      Left = 225
      Top = 159
      Width = 36
      Height = 13
      Caption = #31471#21475#65306
    end
    object lvServer: TListView
      Left = 7
      Top = 17
      Width = 321
      Height = 110
      Columns = <
        item
          Caption = #26381#21153#22120#21517#31216
          Width = 139
        end
        item
          Caption = #26381#21153#22120'IP'
          Width = 93
        end
        item
          Caption = #31471#21475#21495
          Width = 56
        end>
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
    object edtName: TEdit
      Left = 71
      Top = 133
      Width = 257
      Height = 21
      TabOrder = 1
    end
    object edtAddr: TEdit
      Left = 71
      Top = 155
      Width = 137
      Height = 21
      TabOrder = 2
    end
    object sePort: TSpinEdit
      Left = 255
      Top = 156
      Width = 74
      Height = 22
      MaxValue = 65535
      MinValue = 1
      TabOrder = 3
      Value = 7000
    end
    object btnAddServer: TButton
      Left = 111
      Top = 181
      Width = 70
      Height = 23
      Caption = #28155#21152#21015#34920
      TabOrder = 4
      OnClick = btnAddServerClick
    end
    object btnDelServer: TButton
      Left = 184
      Top = 181
      Width = 70
      Height = 23
      Caption = #21024#38500#21015#34920
      TabOrder = 5
      OnClick = btnDelServerClick
    end
    object btnSave: TButton
      Left = 257
      Top = 181
      Width = 70
      Height = 23
      Caption = #20445#23384#37197#32622
      TabOrder = 6
      OnClick = btnSaveClick
    end
  end
  object chkFullScreen: TCheckBox
    Left = 6
    Top = 236
    Width = 68
    Height = 16
    Caption = #20840#23631#27169#24335
    TabOrder = 1
  end
  object cbbScreenMode: TComboBox
    Left = 117
    Top = 233
    Width = 85
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = cbbScreenModeChange
  end
  object btnRun: TButton
    Left = 273
    Top = 228
    Width = 71
    Height = 28
    Caption = #24320#22987#28216#25103
    TabOrder = 3
    OnClick = btnRunClick
  end
end
