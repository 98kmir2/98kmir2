object frmReaderMain: TfrmReaderMain
  Left = 93
  Top = 98
  Width = 852
  Height = 549
  Caption = 'frmReaderMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 208
    Width = 836
    Height = 5
    Cursor = crVSplit
    Align = alTop
  end
  object pnlDetail: TPanel
    Left = 0
    Top = 213
    Width = 836
    Height = 280
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 836
      Height = 280
      ActivePage = tbsSummary
      Align = alClient
      HotTrack = True
      TabOrder = 0
      TabStop = False
      OnChange = PageControl1Change
      object tbsSummary: TTabSheet
        Caption = #23567#32467
        ImageIndex = 2
        object pnlSummary: TPanel
          Left = 0
          Top = 0
          Width = 828
          Height = 252
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Splitter4: TSplitter
            Left = 193
            Top = 0
            Width = 5
            Height = 252
          end
          object lsvPosition: TListView
            Left = 0
            Top = 0
            Width = 193
            Height = 252
            Align = alLeft
            Columns = <
              item
                AutoSize = True
              end>
            HideSelection = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = lsvPositionSelectItem
          end
          object lsvLeakCount: TListView
            Left = 198
            Top = 0
            Width = 630
            Height = 252
            Align = alClient
            Columns = <
              item
                Caption = #31867#22411
                Width = 250
              end
              item
                Caption = #25968#37327
                Width = 150
              end>
            HideSelection = False
            ReadOnly = True
            RowSelect = True
            TabOrder = 1
            ViewStyle = vsReport
            OnSelectItem = lsvLeakCountSelectItem
          end
        end
      end
      object tbsCallStack: TTabSheet
        Caption = #35843#29992#22534#26632
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 828
          Height = 252
          Align = alClient
          Caption = 'Panel1'
          TabOrder = 0
          object vtvStackTrace: TVirtualStringTree
            Left = 1
            Top = 1
            Width = 826
            Height = 250
            Align = alClient
            Header.AutoSizeIndex = 0
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'MS Sans Serif'
            Header.Font.Style = []
            Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
            Header.ParentFont = True
            TabOrder = 0
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toFullRowSelect]
            OnFocusChanged = vtvStackTraceFocusChanged
            OnGetText = vtvStackTraceGetText
            Columns = <
              item
                Position = 0
                Width = 80
                WideText = #22320#22336
              end
              item
                Position = 1
                Width = 200
                WideText = #21333#20803
              end
              item
                Position = 2
                Width = 150
                WideText = #31867
              end
              item
                Position = 3
                Width = 150
                WideText = #26041#27861
              end
              item
                Position = 4
                Width = 100
                WideText = #34892#21495
              end>
          end
        end
      end
      object TabSheet4: TTabSheet
        Caption = #20869#23384
        ImageIndex = 1
        object pnlMemoryDump: TPanel
          Left = 0
          Top = 0
          Width = 828
          Height = 252
          Align = alClient
          Caption = 'pnlMemoryDump'
          TabOrder = 0
          object Splitter3: TSplitter
            Left = 1
            Top = 98
            Width = 826
            Height = 5
            Cursor = crVSplit
            Align = alTop
          end
          object memMemoryDumpHex: TMemo
            Left = 1
            Top = 1
            Width = 826
            Height = 97
            Align = alTop
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
          end
          object memMemoryDumpText: TMemo
            Left = 1
            Top = 103
            Width = 826
            Height = 148
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
      end
    end
  end
  object pnlList: TPanel
    Left = 0
    Top = 0
    Width = 836
    Height = 208
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 233
      Top = 0
      Width = 5
      Height = 208
    end
    object vtvLeaks: TVirtualStringTree
      Left = 238
      Top = 0
      Width = 598
      Height = 208
      Align = alClient
      ButtonStyle = bsTriangle
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDrag, hoVisible]
      Header.ParentFont = True
      Indent = 30
      TabOrder = 0
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnBeforeCellPaint = vtvLeaksBeforeCellPaint
      OnBeforeItemPaint = vtvLeaksBeforeItemPaint
      OnFocusChanged = vtvLeaksFocusChanged
      OnGetText = vtvLeaksGetText
      OnMeasureItem = vtvLeaksMeasureItem
      Columns = <
        item
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
          Position = 0
          Width = 300
          WideText = #22522#26412#20449#24687
        end
        item
          Position = 1
          Width = 100
          WideText = #20998#37197#32534#21495
        end
        item
          Position = 2
          Width = 300
          WideText = #31867#22411
        end
        item
          Position = 3
          Width = 100
          WideText = #27844#38706#22823#23567
        end
        item
          Position = 4
          Width = 100
          WideText = #36215#22987#22320#22336
        end>
    end
    object pnlCategory: TPanel
      Left = 0
      Top = 0
      Width = 233
      Height = 208
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'pnlCategory'
      TabOrder = 1
      object vtvReports: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 233
        Height = 208
        Align = alClient
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag]
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnFocusChanged = vtvReportsFocusChanged
        OnGetText = vtvReportsGetText
        Columns = <>
      end
    end
  end
  object ActionList1: TActionList
    Left = 320
    Top = 128
    object actOpen: TAction
      Caption = 'actOpen'
      OnExecute = actOpenExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 152
    Top = 40
    object actOpen1: TMenuItem
      Action = actOpen
    end
  end
end
