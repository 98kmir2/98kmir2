object frmMain: TfrmMain
  Left = 218
  Top = 163
  BorderStyle = bsDialog
  ClientHeight = 666
  ClientWidth = 1057
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1057
    Height = 666
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet2: TTabSheet
      Caption = #25342#21462#29289#21697
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label3: TLabel
        Left = 278
        Top = 10
        Width = 48
        Height = 12
        Caption = #25968#25454#24211#21517
      end
      object EditDBName: TEdit
        Left = 330
        Top = 7
        Width = 72
        Height = 20
        ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
        TabOrder = 1
        Text = 'HeroDB'
      end
      object btnLoadFromDB: TButton
        Left = 639
        Top = 20
        Width = 105
        Height = 25
        Caption = #33258#21160#20998#26512'DB'#23548#20837
        TabOrder = 2
        OnClick = btnLoadFromDBClick
      end
      object btnSaveToFile: TButton
        Left = 863
        Top = 20
        Width = 89
        Height = 25
        Caption = #20445#23384#21040#25991#20214
        TabOrder = 3
        OnClick = btnSaveToFileClick
      end
      object Button1: TButton
        Left = 765
        Top = 20
        Width = 75
        Height = 25
        Caption = #23548#20837#25991#20214
        Default = True
        TabOrder = 0
        OnClick = Button1Click
      end
      object AdvStringGrid1: TAdvStringGrid
        Left = 3
        Top = 67
        Width = 1025
        Height = 572
        Cursor = crDefault
        ColCount = 5
        Ctl3D = True
        DefaultRowHeight = 21
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 2
        FixedRows = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        GridLineWidth = 1
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 4
        GridLineColor = clSilver
        ActiveCellShow = False
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        ActiveCellColor = clGray
        Bands.PrimaryColor = clInfoBk
        Bands.PrimaryLength = 1
        Bands.SecondaryColor = clWindow
        Bands.SecondaryLength = 1
        Bands.Print = False
        AutoNumAlign = False
        AutoSize = False
        VAlignment = vtaCenter
        EnhTextSize = False
        EnhRowColMove = False
        SizeWithForm = False
        Multilinecells = False
        DragDropSettings.OleAcceptFiles = True
        DragDropSettings.OleAcceptText = True
        SortSettings.AutoColumnMerge = False
        SortSettings.Column = 0
        SortSettings.Show = False
        SortSettings.IndexShow = False
        SortSettings.IndexColor = clYellow
        SortSettings.Full = True
        SortSettings.SingleColumn = False
        SortSettings.IgnoreBlanks = False
        SortSettings.BlankPos = blFirst
        SortSettings.AutoFormat = True
        SortSettings.Direction = sdAscending
        SortSettings.FixedCols = False
        SortSettings.NormalCellsOnly = False
        SortSettings.Row = 0
        FloatingFooter.Color = clBtnFace
        FloatingFooter.Column = 0
        FloatingFooter.FooterStyle = fsFixedLastRow
        FloatingFooter.Visible = False
        ControlLook.Color = clBlack
        ControlLook.CheckSize = 15
        ControlLook.RadioSize = 10
        ControlLook.ControlStyle = csClassic
        ControlLook.FlatButton = False
        EnableBlink = False
        EnableHTML = True
        EnableWheel = True
        Flat = False
        Look = glTMS
        HintColor = clInfoBk
        SelectionColor = clHighlight
        SelectionTextColor = clHighlightText
        SelectionRectangle = False
        SelectionResizer = False
        SelectionRTFKeep = False
        HintShowCells = False
        HintShowLargeText = False
        HintShowSizing = False
        PrintSettings.FooterSize = 0
        PrintSettings.HeaderSize = 0
        PrintSettings.Time = ppNone
        PrintSettings.Date = ppNone
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.PageNr = ppNone
        PrintSettings.Title = ppNone
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.Borders = pbNoborder
        PrintSettings.BorderStyle = psSolid
        PrintSettings.Centered = False
        PrintSettings.RepeatFixedRows = False
        PrintSettings.RepeatFixedCols = False
        PrintSettings.LeftSize = 0
        PrintSettings.RightSize = 0
        PrintSettings.ColumnSpacing = 0
        PrintSettings.RowSpacing = 0
        PrintSettings.TitleSpacing = 0
        PrintSettings.Orientation = poPortrait
        PrintSettings.PageNumberOffset = 0
        PrintSettings.MaxPagesOffset = 0
        PrintSettings.FixedWidth = 0
        PrintSettings.FixedHeight = 0
        PrintSettings.UseFixedHeight = False
        PrintSettings.UseFixedWidth = False
        PrintSettings.FitToPage = fpNever
        PrintSettings.PageNumSep = '/'
        PrintSettings.NoAutoSize = False
        PrintSettings.NoAutoSizeRow = False
        PrintSettings.PrintGraphics = False
        HTMLSettings.Width = 100
        HTMLSettings.XHTML = False
        Navigation.AdvanceDirection = adLeftRight
        Navigation.InsertPosition = pInsertBefore
        Navigation.HomeEndKey = heFirstLastColumn
        Navigation.TabToNextAtEnd = False
        Navigation.TabAdvanceDirection = adLeftRight
        ColumnSize.Location = clRegistry
        CellNode.Color = clSilver
        CellNode.NodeColor = clBlack
        CellNode.ShowTree = False
        MaxEditLength = 0
        IntelliPan = ipBoth
        URLColor = clBlue
        URLShow = False
        URLFull = False
        URLEdit = False
        ScrollType = ssNormal
        ScrollColor = clNone
        ScrollWidth = 17
        ScrollSynch = False
        ScrollProportional = False
        ScrollHints = shNone
        OemConvert = False
        FixedFooters = 0
        FixedRightCols = 0
        FixedColWidth = 384
        FixedRowHeight = 21
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = []
        FixedAsButtons = False
        FloatFormat = '%.2f'
        IntegralHeight = False
        WordWrap = False
        Lookup = False
        LookupCaseSensitive = False
        LookupHistory = False
        BackGround.Top = 0
        BackGround.Left = 0
        BackGround.Display = bdTile
        BackGround.Cells = bcNormal
        Filter = <>
        ColWidths = (
          384
          142
          137
          136
          153)
      end
      object CheckBox1: TCheckBox
        Left = 440
        Top = 9
        Width = 118
        Height = 17
        Caption = #38598#25104#29289#21697#36807#28388#25991#20214
        Enabled = False
        TabOrder = 5
        Visible = False
      end
      object Button2: TButton
        Left = 15
        Top = 5
        Width = 90
        Height = 25
        Caption = #20840#37096#26497#21697#26174#31034
        TabOrder = 6
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 111
        Top = 5
        Width = 66
        Height = 25
        Caption = #20840#37096#25342#21462
        TabOrder = 7
        OnClick = Button2Click
      end
      object Button4: TButton
        Left = 183
        Top = 5
        Width = 66
        Height = 25
        Caption = #20840#37096#26174#31034
        TabOrder = 8
        OnClick = Button2Click
      end
      object Button5: TButton
        Left = 15
        Top = 36
        Width = 90
        Height = 25
        Caption = #20840#19981#26497#21697#26174#31034
        TabOrder = 9
        OnClick = Button2Click
      end
      object Button6: TButton
        Left = 111
        Top = 36
        Width = 66
        Height = 25
        Caption = #20840#19981#25342#21462
        TabOrder = 10
        OnClick = Button2Click
      end
      object Button7: TButton
        Left = 183
        Top = 36
        Width = 66
        Height = 25
        Caption = #20840#19981#26174#31034
        TabOrder = 11
        OnClick = Button2Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = #38598#25104#34917#19969
      ImageIndex = 2
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object AdvStringGrid2: TAdvStringGrid
        Left = 3
        Top = 3
        Width = 1025
        Height = 636
        Cursor = crDefault
        ColCount = 4
        Ctl3D = True
        DefaultRowHeight = 21
        DefaultDrawing = True
        FixedCols = 0
        RowCount = 51
        FixedRows = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        GridLineWidth = 1
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        GridLineColor = clSilver
        ActiveCellShow = False
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -12
        ActiveCellFont.Name = #23435#20307
        ActiveCellFont.Style = [fsBold]
        ActiveCellColor = clGray
        Bands.PrimaryColor = clInfoBk
        Bands.PrimaryLength = 1
        Bands.SecondaryColor = clWindow
        Bands.SecondaryLength = 1
        Bands.Print = False
        AutoNumAlign = False
        AutoSize = False
        VAlignment = vtaCenter
        EnhTextSize = False
        EnhRowColMove = False
        SizeWithForm = False
        Multilinecells = False
        OnDblClickCell = AdvStringGrid2DblClickCell
        OnButtonClick = AdvStringGrid2ButtonClick
        DragDropSettings.OleAcceptFiles = True
        DragDropSettings.OleAcceptText = True
        SortSettings.AutoColumnMerge = False
        SortSettings.Column = 0
        SortSettings.Show = False
        SortSettings.IndexShow = False
        SortSettings.IndexColor = clYellow
        SortSettings.Full = True
        SortSettings.SingleColumn = False
        SortSettings.IgnoreBlanks = False
        SortSettings.BlankPos = blFirst
        SortSettings.AutoFormat = True
        SortSettings.Direction = sdAscending
        SortSettings.FixedCols = False
        SortSettings.NormalCellsOnly = False
        SortSettings.Row = 0
        FloatingFooter.Color = clBtnFace
        FloatingFooter.Column = 0
        FloatingFooter.FooterStyle = fsFixedLastRow
        FloatingFooter.Visible = False
        ControlLook.Color = clBlack
        ControlLook.CheckSize = 15
        ControlLook.RadioSize = 10
        ControlLook.ControlStyle = csClassic
        ControlLook.FlatButton = False
        EnableBlink = False
        EnableHTML = True
        EnableWheel = True
        Flat = False
        HintColor = clInfoBk
        SelectionColor = clHighlight
        SelectionTextColor = clHighlightText
        SelectionRectangle = False
        SelectionResizer = False
        SelectionRTFKeep = False
        HintShowCells = False
        HintShowLargeText = False
        HintShowSizing = False
        PrintSettings.FooterSize = 0
        PrintSettings.HeaderSize = 0
        PrintSettings.Time = ppNone
        PrintSettings.Date = ppNone
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.PageNr = ppNone
        PrintSettings.Title = ppNone
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.Borders = pbNoborder
        PrintSettings.BorderStyle = psSolid
        PrintSettings.Centered = False
        PrintSettings.RepeatFixedRows = False
        PrintSettings.RepeatFixedCols = False
        PrintSettings.LeftSize = 0
        PrintSettings.RightSize = 0
        PrintSettings.ColumnSpacing = 0
        PrintSettings.RowSpacing = 0
        PrintSettings.TitleSpacing = 0
        PrintSettings.Orientation = poPortrait
        PrintSettings.PageNumberOffset = 0
        PrintSettings.MaxPagesOffset = 0
        PrintSettings.FixedWidth = 0
        PrintSettings.FixedHeight = 0
        PrintSettings.UseFixedHeight = False
        PrintSettings.UseFixedWidth = False
        PrintSettings.FitToPage = fpNever
        PrintSettings.PageNumSep = '/'
        PrintSettings.NoAutoSize = False
        PrintSettings.NoAutoSizeRow = False
        PrintSettings.PrintGraphics = False
        HTMLSettings.Width = 100
        HTMLSettings.XHTML = False
        Navigation.AdvanceDirection = adLeftRight
        Navigation.InsertPosition = pInsertBefore
        Navigation.HomeEndKey = heFirstLastColumn
        Navigation.TabToNextAtEnd = False
        Navigation.TabAdvanceDirection = adLeftRight
        ColumnSize.Location = clRegistry
        CellNode.Color = clSilver
        CellNode.NodeColor = clBlack
        CellNode.ShowTree = False
        MaxEditLength = 0
        IntelliPan = ipVertical
        URLColor = clBlue
        URLShow = False
        URLFull = False
        URLEdit = False
        ScrollType = ssNormal
        ScrollColor = clNone
        ScrollWidth = 17
        ScrollSynch = False
        ScrollProportional = False
        ScrollHints = shNone
        OemConvert = False
        FixedFooters = 0
        FixedRightCols = 0
        FixedColWidth = 572
        FixedRowHeight = 21
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = []
        FixedAsButtons = False
        FloatFormat = '%.2f'
        IntegralHeight = False
        WordWrap = False
        Lookup = False
        LookupCaseSensitive = False
        LookupHistory = False
        ShowSelection = False
        BackGround.Top = 0
        BackGround.Left = 0
        BackGround.Display = bdTile
        BackGround.Cells = bcNormal
        Filter = <>
        ColWidths = (
          572
          360
          71
          70)
      end
    end
    object TabSheet1: TTabSheet
      Caption = #30331#24405#22120#35774#32622
      object PageControl2: TPageControl
        Left = 0
        Top = 0
        Width = 1049
        Height = 638
        ActivePage = TabSheet5
        Align = alClient
        TabOrder = 0
        object TabSheet5: TTabSheet
          Caption = #22522#26412#35774#32622
          ImageIndex = 1
          object Label1: TLabel
            Left = 10
            Top = 7
            Width = 60
            Height = 12
            Caption = #30331#38470#22120#21517#65306
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label4: TLabel
            Left = 10
            Top = 121
            Width = 60
            Height = 12
            Caption = #23448#32593#22320#22336#65306
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label5: TLabel
            Left = 10
            Top = 152
            Width = 60
            Height = 12
            Caption = #20844#21578#22320#22336#65306
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label6: TLabel
            Left = 10
            Top = 35
            Width = 60
            Height = 12
            Caption = #26381#21153#21015#34920#65306
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label7: TLabel
            Left = 10
            Top = 63
            Width = 60
            Height = 12
            Caption = #22791#29992#21015#34920#65306
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label8: TLabel
            Left = 466
            Top = 46
            Width = 234
            Height = 12
            Caption = #31034#20363' (http://www.98km2.com/liebiao.txt)'
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label9: TLabel
            Left = 10
            Top = 240
            Width = 132
            Height = 12
            Caption = #20869#26680#31243#24207#20801#35768#22810#24320#25968#37327#65306
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label10: TLabel
            Left = 184
            Top = 239
            Width = 198
            Height = 12
            Caption = '(0'#20026#19981#38480#21046','#26368#22810#20801#35768#22810#24320#25968#37327#20026'255)'
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label2: TLabel
            Left = 10
            Top = 91
            Width = 60
            Height = 12
            Caption = #26356#26032#21015#34920#65306
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label11: TLabel
            Left = 466
            Top = 91
            Width = 228
            Height = 12
            Caption = #31034#20363' (http://www.98km2.com/update.txt)'
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label12: TLabel
            Left = 10
            Top = 182
            Width = 60
            Height = 12
            Caption = #20250#21592#35013#22791#65306
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Label13: TLabel
            Left = 11
            Top = 212
            Width = 60
            Height = 12
            Caption = #32852#31995#23458#26381#65306
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object Edit1: TEdit
            Left = 87
            Top = 6
            Width = 360
            Height = 20
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 255
            TabOrder = 0
            Text = '98k'
          end
          object Panel3: TPanel
            Left = 852
            Top = 0
            Width = 189
            Height = 610
            Align = alRight
            Caption = 'Panel3'
            TabOrder = 1
            Visible = False
            object Memo1: TMemo
              Left = 1
              Top = 299
              Width = 187
              Height = 310
              Align = alBottom
              ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
              Lines.Strings = (
                '@'#25506#27979
                '@'#31227#21160
                '@'#21152#20837#38376#27966
                '@'#36864#20986#38376#27966
                '@'#20801#35768#20132#26131
                '@'#20801#35768#22825#22320#21512#19968
                '@'#20801#35768#34892#20250#21512#19968
                '@'#20801#35768#22827#22971#20256#36865
                '@'#20801#35768#24072#24466#20256#36865
                '@'#22825#22320#21512#19968
                '@'#20179#24211#24320#38145
                '@'#38145#23450#20179#24211
                '@'#35774#32622#23494#30721
                '@'#20462#25913#23494#30721
                '@'#26597#35810#20276#20387
                '@'#26597#35810#24072#24466
                '@'#22827#22971#20256#36865
                '@'#24072#24466#20256#36865)
              ScrollBars = ssVertical
              TabOrder = 0
              Visible = False
            end
            object MemoPatchSvrIP: TMemo
              Left = 1
              Top = 38
              Width = 187
              Height = 261
              Align = alClient
              ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
              Lines.Strings = (
                '; '#24494#23458#25143#31471'IP'#37197#32622
                '; '
                ';--------------------------'
                '; '#21069#25552#35201#24320#21551#23458#25143#31471#36164#28304#20282#26381#22120
                '; '#26684#24335#65306'IP:'#31471#21475','#32447#36335
                '; '#20363#22914#65306'127.0.0.1:8200,1'
                '; '#32447#36335#65306'1'#20195#34920' '#30005#20449',2'#20195#34920#32593#36890
                ';       '#20854#20182#23383#31526#19981#21306#20998
                '; '#24314#35758#65306#21516'IP'#26080#38656#22810#20010
                '; '
                ';---------------------------')
              TabOrder = 1
              Visible = False
            end
            object Panel4: TPanel
              Left = 1
              Top = 1
              Width = 187
              Height = 37
              Align = alTop
              TabOrder = 2
              object route1: TEdit
                Left = 24
                Top = 11
                Width = 65
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                MaxLength = 12
                TabOrder = 0
                Text = #30005#20449
                Visible = False
              end
              object route2: TEdit
                Left = 104
                Top = 8
                Width = 65
                Height = 20
                ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
                MaxLength = 12
                TabOrder = 1
                Text = #32593#36890
                Visible = False
              end
            end
          end
          object EdtWebSite: TEdit
            Left = 88
            Top = 118
            Width = 360
            Height = 20
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 255
            TabOrder = 2
            Text = 'http://www.98km2/index.html'
          end
          object EdtGG: TEdit
            Left = 88
            Top = 149
            Width = 360
            Height = 20
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 255
            TabOrder = 3
            Text = 'http://www.98km2/gg.html'
          end
          object EdtMaster: TEdit
            Left = 88
            Top = 32
            Width = 360
            Height = 20
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 255
            TabOrder = 4
            Text = 'http://www.98km2.com/liebiao.txt'
          end
          object EdtSlave: TEdit
            Left = 88
            Top = 60
            Width = 360
            Height = 20
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 255
            TabOrder = 5
            Text = 'http://www.98km2.com/liebiao.txt'
          end
          object EdtCount: TEdit
            Left = 148
            Top = 236
            Width = 30
            Height = 20
            TabOrder = 6
            Text = '0'
          end
          object EdtUpdate: TEdit
            Left = 88
            Top = 88
            Width = 360
            Height = 20
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 255
            TabOrder = 7
            Text = 'http://www.98km2/update.txt'
          end
          object EdtItems: TEdit
            Left = 88
            Top = 179
            Width = 360
            Height = 20
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 255
            TabOrder = 8
            Text = 'http://www.98km2.com/vipitems.html'
          end
          object EdtContactUs: TEdit
            Left = 88
            Top = 209
            Width = 360
            Height = 20
            ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
            MaxLength = 255
            TabOrder = 9
            Text = 'http://www.98km2.com/contact.html'
          end
          object GroupBox2: TGroupBox
            Left = 10
            Top = 292
            Width = 437
            Height = 45
            Caption = #22320#22270#35835#21462
            Color = clBtnFace
            ParentBackground = False
            ParentColor = False
            TabOrder = 10
            object CheckBox5: TCheckBox
              Left = 147
              Top = 18
              Width = 63
              Height = 16
              Caption = #35835#21462'Wzl'
              Checked = True
              State = cbChecked
              TabOrder = 0
            end
            object CheckBox4: TCheckBox
              Left = 78
              Top = 18
              Width = 63
              Height = 16
              Caption = #35835#21462'Wil'
              Checked = True
              State = cbChecked
              TabOrder = 1
            end
            object CheckBox3: TCheckBox
              Left = 9
              Top = 18
              Width = 63
              Height = 16
              Caption = #35835#21462'Wis'
              TabOrder = 2
            end
          end
          object GroupBox3: TGroupBox
            Left = 10
            Top = 343
            Width = 436
            Height = 105
            Caption = #24494#31471#35774#32622
            TabOrder = 11
            object Label18: TLabel
              Left = 9
              Top = 26
              Width = 30
              Height = 12
              AutoSize = False
              Caption = #22320#22336':'
              Font.Charset = GB2312_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object Label19: TLabel
              Left = 9
              Top = 51
              Width = 30
              Height = 12
              AutoSize = False
              Caption = #31471#21475':'
              Font.Charset = GB2312_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object Label20: TLabel
              Left = 216
              Top = 25
              Width = 210
              Height = 12
              Caption = #31034#20363' (127.0.0.1'#65289#37197#32622#23558#21551#29992#24494#31471#27169#24335
              Font.Charset = GB2312_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object Label21: TLabel
              Left = 181
              Top = 52
              Width = 72
              Height = 12
              Caption = #40664#35748#65288'8200'#65289
              Font.Charset = GB2312_CHARSET
              Font.Color = clBlue
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object EdtMicroAddress: TEdit
              Left = 45
              Top = 22
              Width = 165
              Height = 20
              ImeName = #20013#25991'('#31616#20307') - '#24517#24212' Bing '#36755#20837#27861
              MaxLength = 255
              TabOrder = 0
            end
            object EdtMicroPort: TSpinEdit
              Left = 45
              Top = 48
              Width = 121
              Height = 21
              MaxValue = 65535
              MinValue = 1
              TabOrder = 1
              Value = 8200
            end
            object RadioGroup1: TRadioGroup
              Left = 3
              Top = 67
              Width = 429
              Height = 35
              Caption = #27169#24335
              Columns = 2
              ItemIndex = 0
              Items.Strings = (
                #32431#24494#31471'('#26080#38656#21028#26029#26159#21542#23433#35013#20256#22855#30446#24405')'
                #36731#31471)
              TabOrder = 2
            end
          end
          object ChkCoreVersion: TCheckBox
            Left = 10
            Top = 263
            Width = 132
            Height = 17
            Caption = #23458#25143#31471#26174#31034#20869#26680#29256#26412
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -12
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
            TabOrder = 12
          end
        end
        object TabSheet6: TTabSheet
          Caption = #26356#26032#25991#20214#21015#34920#35774#32622
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel5: TPanel
            Left = 744
            Top = 0
            Width = 297
            Height = 610
            Align = alRight
            TabOrder = 0
            object Label17: TLabel
              Left = 10
              Top = 287
              Width = 54
              Height = 12
              AutoSize = False
              Caption = #19979#36733#22320#22336':'
            end
            object RadGFileLX: TRadioGroup
              Left = 6
              Top = -1
              Width = 285
              Height = 105
              Caption = #25991#20214#31867#22411
              Columns = 2
              ItemIndex = 0
              Items.Strings = (
                #26222#36890#25991#20214
                #30331#24405#22120#25991#20214)
              TabOrder = 0
            end
            object Button11: TButton
              Left = -1
              Top = 336
              Width = 70
              Height = 25
              Caption = #28155#21152#34892#25968#25454
              TabOrder = 1
              OnClick = Button11Click
            end
            object Button12: TButton
              Left = 75
              Top = 336
              Width = 70
              Height = 25
              Caption = #21024#38500#34892#25968#25454
              TabOrder = 2
              OnClick = Button12Click
            end
            object GroupBox1: TGroupBox
              Left = 6
              Top = 110
              Width = 283
              Height = 164
              Caption = #25991#20214
              TabOrder = 3
              object Label15: TLabel
                Left = 6
                Top = 45
                Width = 54
                Height = 12
                AutoSize = False
                Caption = #25991#20214#21517#31216':'
              end
              object Label16: TLabel
                Left = 6
                Top = 77
                Width = 54
                Height = 12
                AutoSize = False
                Caption = #25991#20214'CRC:'
              end
              object Label14: TLabel
                Left = 6
                Top = 14
                Width = 54
                Height = 12
                AutoSize = False
                Caption = #23384#25918#30446#24405':'
              end
              object EdtFileName: TEdit
                Left = 75
                Top = 42
                Width = 199
                Height = 20
                TabOrder = 0
              end
              object EdtFileCRC: TEdit
                Left = 75
                Top = 74
                Width = 199
                Height = 20
                TabOrder = 1
              end
              object Button13: TButton
                Left = 110
                Top = 111
                Width = 75
                Height = 25
                Caption = #21152#36733#25991#20214'..'
                TabOrder = 2
                OnClick = Button13Click
              end
              object cmbFileSaveDir: TComboBox
                Left = 75
                Top = 11
                Width = 200
                Height = 20
                ItemHeight = 0
                ItemIndex = 0
                TabOrder = 3
                Text = '.'
                OnExit = cmbFileSaveDirExit
                Items.Strings = (
                  '.'
                  'data'
                  'map'
                  'wav')
              end
            end
            object EdtFileDownURL: TEdit
              Left = 79
              Top = 284
              Width = 210
              Height = 20
              TabOrder = 4
            end
            object Button15: TButton
              Left = 224
              Top = 336
              Width = 70
              Height = 25
              Caption = #20445#23384#21015#34920
              TabOrder = 5
              OnClick = Button15Click
            end
            object Memo2: TMemo
              Left = 6
              Top = 392
              Width = 283
              Height = 209
              Color = clSkyBlue
              Font.Charset = GB2312_CHARSET
              Font.Color = clGrayText
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              Lines.Strings = (
                #22791#27880#35828#26126#65306
                '        1.'#21015#34920#40664#35748#21152#36733#26159#24403#21069#31243#24207#24037#20316#30446#24405#19979#30340
                'update.txt'#20026#40664#35748#21152#36733#26356#26032#25991#20214#21015#34920#12290
                ''
                '        2.'#20445#23384#30340'update.txt'#25991#20214#35831#19978#20256#21040#26356#26032#26381#21153
                #22120#20013#65292#24182#37197#32622#26356#26032#21015#34920#22320#22336#65292#21363#21487#20351#29992#12290
                ''
                '        3."'#23384#25918#30446#24405'"'#22635'.'#21017#20195#34920#40664#35748#25918#32622#22312#20256#22855#23433
                #35013#26681#30446#24405#65292#21542#21017#25918#32622#20301#32622#20026'"{'#20256#22855#30446#24405'}\'#23384#25918#30446#24405'"'
                #12290)
              ParentFont = False
              ReadOnly = True
              TabOrder = 6
            end
            object Button14: TButton
              Left = 151
              Top = 336
              Width = 70
              Height = 25
              Caption = #21152#36733#21015#34920'..'
              TabOrder = 7
              OnClick = Button14Click
            end
          end
          object ListView1: TListView
            Left = 0
            Top = 0
            Width = 744
            Height = 610
            Align = alClient
            Columns = <
              item
                Caption = #24207#21495
              end
              item
                Caption = #25991#20214#31867#22411
                Width = 100
              end
              item
                Caption = #23384#25918#30446#24405
                Width = 100
              end
              item
                Caption = #25991#20214#21517#31216
                Width = 100
              end
              item
                Caption = #25991#20214'CRC'
                Width = 100
              end
              item
                Caption = #19979#36733#22320#22336
                Width = 400
              end>
            RowSelect = True
            TabOrder = 1
            ViewStyle = vsReport
            OnClick = ListView1Click
          end
        end
        object TabSheet4: TTabSheet
          Caption = #32972#26223#19982#29983#25104
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object Panel1: TPanel
            Left = 0
            Top = 573
            Width = 1041
            Height = 37
            Align = alBottom
            TabOrder = 0
            object ButtonPic: TButton
              Left = 231
              Top = 6
              Width = 99
              Height = 22
              Caption = #32972#26223#22270#29255#27983#35272'...'
              TabOrder = 0
              OnClick = ButtonPicClick
            end
            object Button8: TButton
              Left = 336
              Top = 6
              Width = 98
              Height = 23
              Caption = #35835#21462#30382#32932#25991#20214'...'
              TabOrder = 1
              OnClick = Button8Click
            end
            object Button9: TButton
              Left = 547
              Top = 6
              Width = 97
              Height = 23
              Caption = #30382#32932#21478#23384#20026'...'
              Enabled = False
              TabOrder = 2
              OnClick = Button9Click
            end
            object btnCreatePlug: TButton
              Left = 650
              Top = 6
              Width = 98
              Height = 23
              Caption = #29983#25104#30331#38470#22120
              Enabled = False
              TabOrder = 3
              OnClick = btnCreatePlugClick
            end
            object Button10: TButton
              Left = 444
              Top = 6
              Width = 97
              Height = 23
              Caption = #20445#23384#40664#35748#30382#32932
              Enabled = False
              TabOrder = 4
              OnClick = Button10Click
            end
          end
          object ScrollBox1: TScrollBox
            Left = 0
            Top = 0
            Width = 1041
            Height = 564
            Align = alTop
            TabOrder = 1
            object ImageMain: TImage
              Left = 0
              Top = 0
              Width = 819
              Height = 679
              AutoSize = True
              PopupMenu = PopStartGame
            end
            object RzLabel1: TRzLabel
              Left = 77
              Top = 483
              Width = 48
              Height = 12
              Cursor = crHandPoint
              Caption = #24403#21069#25991#20214
              Color = clWhite
              Font.Charset = ANSI_CHARSET
              Font.Color = 4963313
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentColor = False
              ParentFont = False
              Transparent = True
              OnMouseDown = RzLabel1MouseDown
              OnMouseMove = RzLabel1MouseMove
              OnMouseUp = RzLabel1MouseUp
            end
            object RzLabel2: TRzLabel
              Left = 77
              Top = 503
              Width = 48
              Height = 12
              Cursor = crHandPoint
              Caption = #25152#26377#25991#20214
              Color = clWhite
              Font.Charset = ANSI_CHARSET
              Font.Color = 4963313
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentColor = False
              ParentFont = False
              Transparent = True
              OnMouseDown = RzLabel2MouseDown
              OnMouseMove = RzLabel2MouseMove
              OnMouseUp = RzLabel2MouseUp
            end
            object RzLabel3: TRzLabel
              Left = 77
              Top = 467
              Width = 48
              Height = 12
              Cursor = crHandPoint
              Caption = #24403#21069#29366#24577
              Color = clWhite
              Font.Charset = ANSI_CHARSET
              Font.Color = 4963313
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentColor = False
              ParentFont = False
              Transparent = True
              OnMouseDown = RzLabel3MouseDown
              OnMouseMove = RzLabel3MouseMove
              OnMouseUp = RzLabel3MouseUp
            end
            object RzLabel4: TRzLabel
              Left = 152
              Top = 434
              Width = 66
              Height = 12
              Cursor = crHandPoint
              AutoSize = False
              Caption = #28216#25103#20998#36776#29575':'
              Color = clWhite
              Font.Charset = ANSI_CHARSET
              Font.Color = 4963313
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentColor = False
              ParentFont = False
              Transparent = True
              OnMouseDown = RzLabel4MouseDown
              OnMouseMove = RzLabel4MouseMove
              OnMouseUp = RzLabel4MouseUp
            end
            object RzLabelStatus: TRzLabel
              Left = 131
              Top = 467
              Width = 183
              Height = 12
              Cursor = crHandPoint
              AutoSize = False
              Caption = #35831#36873#25321#26381#21153#22120#30331#38470'...'
              Color = clWhite
              Font.Charset = ANSI_CHARSET
              Font.Color = 4963313
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentColor = False
              ParentFont = False
              Transparent = True
              OnMouseDown = RzLabelStatusMouseDown
              OnMouseMove = RzLabelStatusMouseMove
              OnMouseUp = RzLabelStatusMouseUp
              CondenseCaption = ccWithinPath
            end
            object btnChangePassword: TRzBmpButton
              Left = 453
              Top = 497
              Width = 104
              Height = 26
              Cursor = crHandPoint
              Bitmaps.Disabled.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100007700000000000000A1A1
                A0006B6B6D003D3E43002D2F3200E6FFFD007B8887004A4A4A000A052000747B
                7B00545A5A00B8C3C200FFFFFF0008012A008F9C9B000A00360014151500838E
                9C00515866003A3A31007C878600CEE1DF004C4D5100ADB3B300687170001A0D
                530095A6A500252728000908110064656A0011034A001C1F1E0020222B008E96
                960054545800D7EFED008E9BA9002B245D00C4D5D3003436390043444800636B
                7B00B0BFBE00A3ACAB0066666600040505008586890019057200828A89000C0E
                0E003A3A3A007D7E820014055700BEBEBE004E4E76002F323C0017191D00BFD0
                CE009DABBA00424242006C6D7200999999003C3C3F005151520075757A00292A
                2E005A5A5A000F073900DFF7F5005C5D87009D9EA10015045B00B7CAD200D1E5
                E300616B6B007B839C000F100F0096A4B3005E5F630002000A00A8A8AA009596
                99002022210033333300AEADAE00C5DBD900AEC2C000424A4A00BBCFD500737E
                8C000502160010044300100A2C00B4B4B40014045F00424A4200191919008484
                84008C8C8C00939393007B7B7C00474F4E00737474002929290008090800A4A4
                A40013131C00404551005B5C5F00BDD6CE009EA7A6004D4F530011005600838D
                A400CCE1E300C3D8DC00B5C1C00016075E00D3E7E50000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000005B5B5C383838
                3838383838383838383838383838383838383838383838383838383838383838
                3838383838383838383838383838383838383838383838383838383838383838
                3838383838383838383838383838383838383838383838383838383838383838
                43340F084C4C6041272727272727272727272727272727272727272727272727
                2727272727272727272727272727272727272727272727272727272727272727
                2727272727272727272727272727272727272727272727272727272727272727
                272727272767104C4C0F0D68681F3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3260681C5A2D686060606060606060606060
                6060606060606060606060606060606060606060606060606060606060606060
                6060606060606060606060606060606060606060606060606060606060606060
                60606060606060606060606060606060606060606060606068684F004C606041
                0304323B3B3B3B3B1B1B3E3E3E3B3B3B3B3B2752043B3B3B3B3B27273E3B3204
                1B1F5267671F6060043B3B3B3B041F1F52323B32415260606060606060606060
                6060606060606060606060606060606060606060606060606060606060606060
                68004F004C601B0707413E16161616161607071616161616163B6767273B3B3B
                3B3B3B273207415267273B073B320404033B3B3B3B073E273E3E3E3E3B3E2760
                6060606060606060606060606060606060606060606060606060606060606060
                606060606060606068004F4F1052272222530322222222222232273F22222222
                28414153323B3B3B3B3B3253533B3241533B3B3B3B3B5327283B3B3253323B3B
                3B272704273E3B1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F312D1C31603B4242422828426C6C6C6C
                6C2767280A223F3F3E042752273B27273B3B3B275252525252525252273B3B27
                5252273B27525252273B3B3B3B3B3B3B3B275252525252525252273B3B3B2752
                52525252525252525252525252525252525252525252525210316A1F1B2C6C03
                3F4E28422C2C2C2C2C2C070722280303076767673B0C3B3B0C0C0C3B3B326767
                323B3B3B3B0C0C3B32323B0C3B6767673B0C0C0C0C0C0C0C0C3B6767323B323B
                32673B0C0C0C3B32676767676767676767676767676767676767676767676767
                521F205353020A322828326C02020202020202024E0A6F6F4E0404043B0C3B3B
                3B3B3B0C0C3B32043B0C0C0C3B3B3B0C3B3B0C3B320404043B0C3B3B0C3B3B3B
                0C3B04043B0C3B0C3B04323B3B3B0C3B04040404040404040404040404040404
                0404040404040404040437653E1D1D42073E163C6666664E0266666666666666
                662727273B0C3B0C3B3B0C3B3B0C3B273B0C3B3B0C0C3B3B0C0C3B3E27272727
                3B0C3B3B0C3B273B0C3B27273B0C0C0C3B3B3B3B3B3B0C3B2727272727272727
                2727272727272727272727272727272728656B4A65651D643C3C646464666C28
                6F4E026666646464643E3E3E3B0C3B0C3B0C3B0C3B3B3B3E3B0C3B3B3B3B3B3B
                0C3B3B3E3E3E3B3B3B3B3B3B3B3B3B3B3B3B3E3E3B0C3B0C0C0C0C0C0C3B0C3B
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E0A4A120642220261
                616464644042072828073F22221D6461022828283B0C3B0C3B3B0C3B0C3B3B3B
                3B0C3B3B3B3B3B0C3B0C3B3B3B3B3B0C0C0C3B0C0C0C0C3B3B3B3B3B3B0C3B0C
                3B3B3B3B3B3B0C3B282828282828282828282828282828282828282828282828
                1806291A0264622E3C4E4E4E0A1616161616161616161D621D1616283B0C3B0C
                0C0C3B0C3B0C0C3B3B0C3B3B3B0C3B0C3B3B0C3B1616283B3B3B0C0C3B3B0C3B
                3B0C3B3B0C0C3B0C3B0C0C0C0C0C0C3B16161616161616161616161616161616
                1616161616161616141A5956096263666C1D3C3C422222222222222222423C61
                4E22223B0C0C3B0C3B3B0C3B0C3B3B073B0C0C0C0C3B0C3B073B0C3B2222223B
                0C3B0C3B0C3B0C3B0C3B07073B0C0C0C3B3B0C3B3B0C3B072222222222222222
                222222222222222222222222222222220E561155305151401D666251644E6C6C
                6C6C6C6C6C1D40024E4E4E163B0C3B0C0C3B3B0C3B166C6C163B3B3B0C3B0C3B
                163B0C3B6C6C163B3B0C0C3B3B0C3B163B3B166C3B0C3B3B163B0C3B3B0C3B6C
                6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C2B5524232101013D
                61646301612C2C2C2C2C2C2C2C2C2C2C2C2C2C2C3B0C3B0C3B0C0C3B0C3B3F2C
                2C2C2C3B0C3B3B0C3B3B0C3B3F2C3B0C0C3B3B3B0C3B0C3B3B0C3B2C3B0C3B2C
                2C3B0C3B3B0C3B2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2A234D054663015050466969333C3C3C3C3C3C3C3C3C3C3C3C3C3C3C223B0C3B
                223B0C0C0C0C3B3C223B3B3B0C3B3B0C0C0C0C0C3B3C223B0C0C0C0C0C0C0C0C
                0C0C3B223B0C3B3B223B3B3B3B0C3B3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C
                3C3C3C3C3C3C3C3C39054D056E332E623D545454516440404040404040404040
                40404040403B0C3B403B0C3B3B3B42403B0C0C0C0C3B3B0C3B3B3B3B42404042
                3B3B3B3B0C3B3B3B3B3B423B0C0C0C0C3B0C0C0C0C0C3B404040404040404040
                4040404040404040404040404040404039054D052B3333336151545D50613333
                33333333333333333333333333423B4233423B4233333333423B3B3B3B42423B
                4233333333333333333333423B423333333333423B3B3B3B423B3B3B3B3B4233
                33333333333333333333333333333333333333333333333339054D05172E2E2E
                2E2E6935462E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E
                2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E
                2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E
                2605710574626262626246354662626262626262626262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262150536057651636363633D35696363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363636363636363632B05441E580549173D3D3D3D5435463D3D
                3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D
                3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D
                3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0B440571702573050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                3A751E47194B7205050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                05050505050548455E2F}
              Bitmaps.Down.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100008B000000010011008D9B
                AB00080473003E447B00162B450001014200CCFFFF000806750001003A000302
                620008069C00E6FFFD00B2C6D4000000330055728600020253000908A4002540
                5A00060593006E809500130E430000002900333872000F0054000B1F38005C5D
                8700080263009DABBA0006047B00CCE2E4000A088C00160FB600010021003348
                66001F29440003004A000202590046647A000E193000060484000A0883000704
                6B000F0BB1002B245D003C5A72007C839C001F3D5A00565F8E00122340005976
                8900ABBECD0007035000C3D8DC0005062B0012304F0096A4B30006034B001A13
                C50006112400D6F0F0006B779D003550690019057200010019005C6E84001B0E
                5300464F75000E0A99001D21430015055F0007045A00274561008DA9B5000906
                6D00838DA400273B53001D324C004A5C7300110DA7000F0A9600606B94001031
                4A000C00400016203A00718D9D0009077A0019375400E0F9F800A8C4CB0095A6
                BB0042556B003D466A000C0732002A4863000F088F000D0AA4001412BB00535C
                8B00D2EAEE001613BD00333D5D00B7CAD200C1DCDF007E90A400223350001605
                5B001915C5004D567F00192142000F233A00415B7200808EA000173553000B01
                370000006B000B0B56000506660012044B00120DB6000F0DA00047657B001200
                5900091329001C2E4A003A4B640038556E008C9DB20019294A002A3E59007180
                930010104A005F6E85004F4F77001F204700120CAA00BBCFD50029325100FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000525285783131
                3131313131313131313131313131313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                313131313131313131313131313131313131313131313131313131313131315A
                1417714425256E21808064646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                64646464643D25256E145C3D7D6815150D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D354B7D80535D4C2020151515150D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D151515152020115D302E263F3F0D
                33053833333333330D0D33333333333333330808080533333305050538383805
                0D0D0D0D0D15151508330505050515150D050505050D0D0D0D20202020202020
                2020202020202020202020202020202020202020202020202020202020203F3F
                042E30707A0020050515082323232323232323232323232323080D0D0D080823
                2308080808231515150D08080808151508080808080808080808080808080815
                15153F1515151515151515151515151515153F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F006D706D363A001505050D0D2323232323230D0D2323232323
                230D3F3F3F15081515080808153F3F3F3F3F3F3F3F150808153F3F1508153F3F
                3F150808080808080808153F3F3F3F3F3F3F3F15080808153F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F0018366D363A150505232308230F0F0F0F
                0F0D2008232323230D152020200806080806060608080D20200D080808080606
                080D0D0D06082020200806060606060606060820200D0D0D0D0D200806060608
                0D2020202020202020202020202020202020203F3F3F3F00183630567A05050D
                2324050F2424242424240505232308080808202020080608080808080606080D
                200806060608080806080806080D202020080608080608080806082020080608
                0608200D08080806082020202020202020202020202020202020202020203F3F
                6D567B472633330D050505467474747474747474463333334646151515080608
                0608080608080608150806080806060808060608081515151508060808060815
                0806081515080606060808080808080608151515151515151515151515151515
                151515151515203F04474B2C5333464623083329020202092902020202020202
                020F0D0D0D0D060806080608060808080808060808080808080608080D0D0D08
                080808080808080808080808080806080606060606060806080D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D15204B2C7C0E220846070707282828551A23
                0F1A020202020202022305050505060806080806080608080808060808080808
                0608060808080808060606080606060608080808080806080608080808080806
                080505050505050505050505050505050505050505050D157C0E4D5488057428
                28282828281A0F0F0F0F46464649282807232323050506080606060806080606
                0808060808080608060808060823230508080806060808060808060808060608
                0608060606060606082323232323232323232323232323232323232323230808
                4D548348644928282849494974242424242424242424074F070F0F0F08060608
                0608080608060808230806060606080608230806082424240806080608060806
                0806082323080606060808060808060823242424242424242424242424242424
                2424242424380505404881585B555E552955282829747474747474747474284F
                0774747423080608060608080608237474230808080608060823080608747423
                0808060608080608230808237408060808230806080806087474747474747474
                7474747474747474747474747424380513586F6642284F281C1E774E1E070202
                0202020202271E280202020202080608060806060806080F0202020208060808
                06080806080F0208060608080806080608080608020806080202080608080608
                020202020202020202020202020202020202020202090F236766013B6B5E7777
                4343861F77272727272727272727272727272727272408060824080606060608
                2724080808060808060606060608272408060606060606060606060824080608
                082408080808060827272727272727272727272727272727272727271C1C0933
                7E3B370B61287776606060600A12121212121212121212121212121212120806
                0812080608080809120806060606080806080808080912120908080808060808
                0808080908060606060806060606060812121212121212121212121212121212
                12121212271C290F590B370B61291E0A2A393939760A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0908090A0908090A0A0A0A0908080808090908090A0A0A0A0A0A
                0A0A0A0A0908090A0A0A0A0A0908080808090808080808090A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A12270224590B370B61741C1E0A2A6A6A6A100A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A12270209590B370B2F090727
                120A76392A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A12270246
                590B4A0B3C24291C27275F395F12121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                12121212271C2924320B840B0C730929291C1C1F4F1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C7424160B5775870B32030F0F0909285E740909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090F50620B4A792B340B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                1B457969412D1D0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B6519453E}
              Bitmaps.Hot.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B000000010000C70000000C07320096A4
                B3000504D900193754000C128C00030274004149BA00E6FFFD00557286001D14
                9C00071CBD000C0040000B19A0002C4AA0000905BC00FFFFFF00130EC3000B07
                9C00B6C9D1001223400042556B001E2AAC000705CC007182C2000E0A7B007180
                9300170EBD0097A7F000203976001E12C6000906B00004026C00281EA7001018
                96000E0E7D00D6F0F0002F27AF000D088B0010235E000807D7005058D3002745
                6100616BEA003C5A7200100CE8000604DE00050359001D13A2009DABBA000A06
                A600212EAF000F186B000C0793000E08AD004F4F77000605DE002F369C003C4D
                8B00C1DCDF00141D9B0011304E003439E4000806C5000D088400281AB600ABBE
                F500080052000E203D00100EE100808EA000597689001219700018109900C3D8
                DC002114CB00262D8E002110AD00142762005F70B0004D5E9D003A4B64002929
                B5008E9EE0002818BF00191095002B2BAE0046647A002F2FB300050363002F20
                B400130DAC00A8C4CB00595A8500B3C7F60002027A00130E4300100CD3002843
                870010005C000908E4002A3B5500161E78008091D2002B245D000A1FB9008D9B
                AB001D2143002634B600160950001A13E4001B1794002016D400545DE6002323
                A3001931690000003B001924A5001D12B200E0F9F800100BA5000F099B001230
                4F002719AF00CBE1E3002C1EB100211994003840AB000D138E002921BD000F0A
                C7000F0ABC000B08B6008DA9B500271AC600718D9D003F45E5005F6E85001810
                B3003550690047657B001A13DF002A486300415B72001F3D5A0034519600100B
                D2000D0ACF000D0AE70014006F002331B3002016BD002B21AD00121B9B001506
                5D004951C700BBCFD5006C77EC00110AB400D3EAFA001A12CD002318A4001204
                4B00161F3E0079819A002C3D7B00243E8E002A3E59001E2582002110DE005760
                E900173553000B0137000A17A200110B93000F00540020199C001B26A8002215
                B700130FED002416CE002417AC001B11D7001620A0001B11AE001C2E4A003855
                6E0026426A00555DDC00838DA4002318C2001424770015276300415F83001010
                4A001F2047001E306D004D5C7500375492000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000B0BC28B4646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464614
                5FAEAB6A5656C0900D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0DC58B8B8E5F008AB9A50A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A6861B9A6A28D1CACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACBA8D138FBE0404B6
                9574156B6B6B6B953B3B9595956B6B6B6B6B1521746B6B6B6B6B15B095953274
                3B7F21B6987F7F7F746B6B6B6B74217F21326B32B62104040404040404040404
                0404040404040404040404040404040404040404040404040404040404040404
                728F13AA47227F55556E71575757575757555757575757575722222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                22222222222222224DAA437933226E24246EAF2424242424246E6E9724242424
                7118181818181818181818181818181818181818181818181818181818181818
                1818181818181818181818181818181818181818181818181818181818181818
                181818181818181818181818181818182679433C33AF979797AFAF9724242424
                245422AF972020206E1818182E732E2E7373732E18181818181818182E73732E
                18182E732E1818182E73737373737373732E18181818181818182E7373732E18
                181818181818181818181818181818181818181818181818263C130347599754
                A07C0920595959595959AFAFA009545409181818730F73730F0F0F73732E1818
                2E737373730F0F732E2E730F73181818730F0F0F0F0F0F0F0F7318182E732E73
                2E18730F0F0F732E181818181818181818181818181818181818181818181818
                BF03B8296559A0AD4848ADB459595959595959597AA02F2FB43F3F3F730F7373
                7373730F0F732E3F730F0F0F7373730F73730F732E3F3F3F730F73730F737373
                0F733F3F730F730F733F2E7373730F733F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3FC329642BA77A7A4C48AD2F40404040B44080808080808080
                80252525730F730F73730F73730F7325730F73730F0F73730F0F732E25252525
                730F73730F7325730F732525730F0F0F7373737373730F732525252525252525
                25252525252525252525252525252525A42B50084B787553B1B153535353B778
                77B7B1B15353535353343434730F730F730F730F73735834730F735873735873
                0F73583434345873737358737373735873583434730F730F0F0F0F0F0F730F73
                3434343434343434343434343434343434343434343434343908C48638771A85
                85BDBDBD965A1111111177777789BD8575111111730F730F73730F730F737358
                730F73115873730F730F73581111730F0F0F730F0F0F0F7358735858730F730F
                7373737373730F73111111111111111111111111111111111111111111111111
                4F8688847E1DB34A1A9D9D9D353131313131313131311AB39D313158730F730F
                0F0F730F730F0F73730F7373730F730F73730F733131587373730F0F73730F73
                730F73730F0F730F730F0F0F0F0F0F7331313131313131313131313131313131
                31313131313131314E84195B066F6F10838210101E1E1E1E1E1E1E1E1E1E109F
                821E1E730F0F730F73730F730F73731F730F0F0F0F730F731F730F731E1E1E73
                0F730F730F730F730F731F1F730F0F0F73730F73730F731F1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E175B453A9AB5B5810E81B5B5810E0E0E
                0E0E0E0E0E0E81810E0E0E05730F730F0F73730F73050E0E057373730F730F73
                05730F730E0E0573730F0F73730F73057373050E730F737305730F73730F730E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E663A6923288C8C8C
                6092B58C913E3E3E3E3E3E3E3E3E3E3E3E3E3E3E730F730F730F0F730F73053E
                3E3E3E730F73730F73730F73053E730F0F7373730F730F73730F733E730F733E
                3E730F73730F733E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                52230107BB44446D6D6D6D6D9216161616161616161616161616161605730F73
                05730F0F0F0F7316057373730F73730F0F0F0F0F731605730F0F0F0F0F0F0F0F
                0F0F7305730F737305737373730F731616161616161616161616161616161616
                16161616161616161B07010770272727446D6D6D442727272727272727272727
                2727272727730F7327730F7373735E27730F0F0F0F73730F737373735E27275E
                737373730F73737373735E730F0F0F0F730F0F0F0F0F73272727272727272727
                272727272727272727272727272727271B070107700202020263B2B22C020202
                020202020202020202020202025E735E025E735E020202025E737373735E5E73
                5E020202020202020202025E735E02020202025E737373735E73737373735E02
                0202020202020202020202020202020202020202020202021B070107A92D2D2D
                2D2D93B2632D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                1B07BC079C2D2D2D2D2D63B2632D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D410736075D442D2D2D2D2DB2632D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D3D0776A19B0741872D2D2D2D632C372D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2A9E07BCAE6749070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                309962626CA37B07070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                070707070707125C6294}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A000000000000000000000001000000000000010021008893
                A5000000990019375400000058006B8599000000F0004F517200E2FCFA000000
                D7000000420001008D000000CC00C1DCDF000100830017184300E6FFFD002B3D
                8E0001003A00010072001A1C9A000000C4000000BC00A8C4CB003A3668000000
                E50001004A0000003300292258008999F8000000AD001B1ED200000066006E7B
                F10047657B00D6F0F00000005200A4B4BF000B1070005572860000002A000D0F
                F1002D3B5B0011304E00181A8B000E014A003C5A7200657D8E0000006B000E11
                5F0085A0B100B6D0DA001B1EAA0001007B0038556E003A528400100054002E36
                5A00112B4900CAE0E200CCFFFF0001009300506C8300494872000F0058001732
                4D002E33E0000C023A00DEF7EF000000B5008DA9B5001F3D5A00ABC2C9005976
                8900030628000000DF007E95A3001B1EC5001E21F2002745610036445F000B0D
                52001524510015177C001E27490029428C0008004A00CAE3EB0018345200B1C3
                CB0030486E007178940095A2B40021425A00BED4D8000000F6000200A300D7F0
                F70005083C00718D9D0094A5F8000E164B009FB9C600121A700012304F002A48
                630004063200CBE1E300060A2C0095ADB7001F314E0057738600DDF6F5001114
                6E00B5CEDE001B1EB8000E043B00364B63002E428B00080B460021426300FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002D74506F4949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949492739
                2D40437522223711111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                11111111763722222A2D54365A26131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313131313131313131313136736360F4769650A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A52696E474700001224
                0A1A24242424241B1B24242424242424241A1B1204242424241A1A1A1A1A1A1B
                282812122828280A242424240A2828281A041A12120000000000000000000000
                000000000000000000000000000000000000000000000000000000000000006C
                47585858001B24241B1A0404040404040404040404040404041B1B1B0A0A0404
                040A1B12241B00001B1212040A0028121A040A0A0A1A120A0A0A0A0A0A1B1B1B
                1B00000028282828282828282828282828000000000000000000000000000000
                000000000000004A58416868280A0404121A0404040404040A0A040404040404
                1B1B1B1B0A0A0A041A121B1B0A0A001B0A0A0A0A0A1B1B0A0A0A1212121A1A12
                121B1B1B1212121B1B1B00282828282828282828282828282828000000000000
                0000000000000000000000000000004A683A2B2B1A040404041A042020202020
                0A1B1A040404040A281B28281B1B1B1B1212121B28282828282828281B1B1B1B
                28281B1B1B2828281B12121212121212121B28282828282828281B1212121B28
                2828282828282828282828282828282828282828282828282B3A030330301A04
                202420303030303030242424241A1A1A1A1A2828123C12123C3C3C1212121212
                12121212123C3C121212123C12282828123C3C3C3C3C3C3C3C12121212121212
                1212123C3C3C121228282828282828282828282828282828282828282828286A
                03414F4F35200A24241A203535353535353535303004043013131212123C1212
                1212123C3C121212123C3C3C1212123C12123C1212121212123C12123C121212
                3C121212123C123C1212121212123C1212121212121212121212121212121212
                12121212121212624F5D2E36131320041A04353535353035350E0E0E0E0E0E0E
                0E130A0A0A3C123C12123C12123C1212123C12123C3C12123C3C12120A0A0A0A
                0A3C12123C1212123C121212123C3C3C1212121212123C120A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A772E75273E04130B35350B0B0B0E300404
                3035350E0B0B0B0B0E041A1A123C123C123C123C12120A1A123C120A0A0A0A0A
                3C120A1A1A1A0A1212120A121212120A0A0A1A1A123C123C3C3C3C3C3C123C12
                1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A5127226305200E3D3D
                0B0B0B0B3004040404202020350B0B0E200A0404123C123C12123C123C12121A
                123C12041A12123C123C121A0404123C3C3C123C3C3C3C121A121A1A123C123C
                1212121212123C12040404040404040404040404040404040404040404040431
                632F46323D60600E353535132020202020202020200E600E201A201A123C123C
                3C3C123C123C3C12123C1212123C123C12123C1220201A1212123C3C12123C12
                123C12123C3C123C123C3C3C3C3C3C1220202020202020202020202020202020
                2020202020202071464C486660600B350E0B0B131313131313131313130B600E
                131313123C3C123C12123C123C121224123C3C3C3C123C1224123C1213131312
                3C123C123C123C123C122424123C3C3C12123C12123C12241313131313131313
                13131313131313131313131313131353176D0D331E45020B0B1E1E020E0E0E0E
                0E0E0E0E0B0B0B0E0E0E0E04123C123C3C12123C12040E0E041212123C123C12
                04123C120E0E0412123C3C12123C12041212040E123C121204123C12123C120E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E2C0D4823571616161E
                6045451E3D0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B123C123C123C3C123C12040B
                0B0B0B123C12123C12123C12040B123C3C1212123C123C12123C120B123C120B
                0B123C12123C120B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B14
                235E1061161515151515151E6060606060606060606060606060606020123C12
                20123C3C3C3C1260201212123C12123C3C3C3C3C126020123C3C3C3C3C3C3C3C
                3C3C1220123C121220121212123C126060606060606060606060606060606060
                6060606060606034103B10614545451509090915451E1E1E1E1E1E1E1E1E1E1E
                1E1E1E1E1E123C121E123C121212301E123C3C3C3C12123C12121212301E1E30
                121212123C121212121230123C3C3C3C123C3C3C3C3C121E1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E73106B1061161616160C09090915161616
                1616161616161616161616161613121316131213161616161312121212131312
                1316161616161616161616131213161616161613121212121312121212121316
                16161616161616161616161616161616161616161616164D106B10610C0C0C0C
                0C4B4B4B0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C1F
                106B081009090909094B4B4B0909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090942103359102119191919190606191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919196410013F10101D29060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606064E6410701C2D5B08101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101070
                072D404018250810101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010235C1C2D2D}
              Color = clBtnFace
              PopupMenu = PopPass
              TabOrder = 0
              OnMouseDown = btnChangePasswordMouseDown
              OnMouseMove = btnChangePasswordMouseMove
              OnMouseUp = btnChangePasswordMouseUp
            end
            object btnColse: TRzBmpButton
              Left = 782
              Top = 90
              Width = 16
              Height = 16
              Cursor = crHandPoint
              Bitmaps.Down.Data = {
                6E030000424D6E030000000000006E0200002800000010000000100000000100
                08000000000000010000120B0000120B00008E0000008E00000084CFE70073C7
                E7006BC3E7005ABEDE004AB6DE005AB6D60000AEFF0039B2DE0052B2D60000AA
                F70029AAD60021AAD60063A6C60000A2EF0052A6C60039A6CE0018A6D60063A2
                BD0010A2D600429ECE0052A2BD00009AE700639EB5004296C600299ABD00009A
                CE004292C6000096CE00008ED6000092C600398EBD00008EBD003986B500008A
                B5003986AD000082C6000086B5002982AD002982A5000082AD00317DA5003979
                AD002979AD00007DAD00297D9C003179A5003975AD000075BD0031799C003175
                A5002175A5002975A5000079A5003171A5002171A50008759C0018719C00316D
                9C00216D9C000069AD0031699C0029699C00106D940031699400216D8C00006D
                940029659C0021658C002161940000658C0021618C0018618C00005D9C001861
                8400295D8C00185D8C0000618400185D840029598C0018598C00215D7B002159
                840029558C00105984002955840018597B0008558C001855840000597B000059
                73000859730010557B0010518400214D840008517B00004D840018497B002149
                7B0008498400104D730000516B001849730010497300104D6300184D63002145
                73001845730008496B00084573002141730008456B001841730010416B001045
                5A0008416B0000455A0008416300103C6B00083C630000415200003C6300103C
                52000838630018346B00083C5200003C52001834630000346300083463000034
                5A0008384A0008305A0000344200002C5A00002C52000028520000244A000024
                3100001C42004210000039040000000000008B3B2F231C150D0906090D151C23
                2F8B487F8A888787858585858686888A5F3B488A868163766E6C6C7276787F86
                8A3B4887806B081643535E2C00506C7A873B4883744C19011143260F02054766
                833B487A66827D1D050E07121B344B5C7A3B487557477C59190A101D37383A4F
                753B48704B364958211912184025324B703B486A463A3E24242B1D040C222A44
                6A3B486A4D371F1D417373210314333D653B486A5B644C455A286884270B313D
                603B486A5179896728131E71773E2D42613B486F4E3F31201A1A1A305531314E
                6F3B487E614A392E2E2E2E31313C4A617E3B48627B6D5D5452525252545D697B
                563B8C3B2F231C150D0906090D151C232F8C}
              Bitmaps.Hot.Data = {
                F6030000424DF603000000000000F60200002800000010000000100000000100
                08000000000000010000120B0000120B0000B0000000B0000000E7F7FF00DEF3
                FF00DEEFF700D6EBF700C6EBFF00CEEBF700BDE7FF00C6E7FF00C6E7F700CEE7
                F700BDE7F700B5E3FF00CEE3F700C6E3F700BDE3F700B5E3F700A5DFFF00C6DF
                EF00ADDFF700BDDFEF00B5DFEF009CDBFF00ADDFEF00A5DBF700ADDBF700B5DB
                EF00ADDBEF008CD7FF00A5D7F7009CD7F700ADD7EF0084D7FF0094D7F700A5D7
                EF009CD7EF00B5D7E70094D7EF007BD3FF0084D3FF00A5D3EF008CD3F7008CD3
                EF007BCFFF008CD3E700A5CFE7006BCFFF009CCFE70084CFE70073CBF700A5CB
                E7007BCBEF007BCBE70084CBE700B5CBD6007BC7EF006BC7F70094C7E70094C7
                DE0084C7E7009CC7DE006BC7E70073C7E700B5C7CE0084C3E70094C3DE0063C3
                E7007BC3DE0031BEFF0094C3CE0084BEDE007BBEDE008CBED600A5BECE0084BE
                D60063BEDE0031BAF70039BAF70084BAD6008CBACE0052BADE0039B6F70018B6
                FF0084B6D6004ABADE007BB6D6006BB6D60073B6D60052B6DE004AB6DE0018B2
                F70031B2EF0018AEF70039AEE70063AECE0018AAEF0084AEBD0029AAE7006BAA
                CE0031AED6004AAECE0063AACE007BAAC60010A6EF0021AAD60063A6CE0031A6
                DE006BA6C60063A6C60021A6D60042A2D60018A2E70052A2CE00109EE70018A2
                D60010A2D6005A9EC600219ADE004A9EBD00299AD600089ECE00009ACE001096
                D6004A96BD002192CE000096C6000896C6006396A5004292BD00108ACE005A8E
                9C00428AB500108EB5000886CE004286B500008ABD003186B5002986B500008A
                B5003182B5003982B5001082B500317DAD00187DB5000879BD00007DAD002979
                AD000079BD001879B5001075B50021799C001075AD001071AD000871AD001871
                A500086DAD00006DAD00186DA50052717B001069A5000865A50029697B001069
                84004A69730000658C004265730000618400005D7B00085D7300004D6B00004D
                630008495A0000455A0000283900421000003904000000000000AD947B76695C
                5050434B5A6074808FAD9E887F736A616161616A6B737F878E9A997A6B52653B
                3B3B3B4047546B7A889891684949AAA448111181AC5F47617F978D56316C86AB
                A2357EA1A9AA4E496F948A4523223D77A7A0A3868975133964938B381303164F
                7C90897D63130C2C5593852E0D021A57727889953E3E031E468E822709024278
                716777A5A44403193F8E8221145D837762333C71A89D05183A93821C34585862
                3C00082972A6081736938B200F122B2F0A01010F414A0E1D32969128170B0607
                04040406240B172830989C2A1B1515101010101010151B2A379A9F6D30261F1F
                1F1F1F1B1B26252D8C9BAE9A84807970665B51595E6E798492AE}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                36050000424D3605000000000000360400002800000010000000100000000100
                08000000000000010000000000000000000000010000000000008CD3E70063CB
                FF005AC7FF0063C7FF006BC7E7005AC3F70063C3E7007BC3DE005ABEF7005ABE
                EF0052BEEF005ABAEF0052BAEF0052BADE0052B6EF004ABADE0052B6E70063B6
                D6004AB6DE004AB2E70000AEFF0052AEDE0000AAF7004AAADE0042AADE0031AE
                D6004AAAD60052AACE006BAAC60063AAC6004AA6D60021AAD60042A6D6004AA6
                CE0000A2EF004AA2CE0039A2D60018A2D60010A2D600429ECE00009AE700399A
                CE00319ACE00089ECE00429EBD00399AC6005A9AB5003196CE002996CE003996
                C600319ABD00009ACE004A96B5003996BD003196BD003192C6000096C6002992
                C6004A92B500008ED600318EBD00298EBD00298ABD00218ABD00318AB500008A
                BD00008AB5001886B5000082C6001882B500217DAD00317DA500007DAD000079
                B500007DA5001079AD001879A5000075BD001875A5000875A50021759C001075
                9C0008759C001071A5000071AD000871A50010719C0018719C0021719400086D
                A500006DA5000069AD00086D9C0008699C001069940008699400086594000069
                8C0021658C0000658C00005D9C00085D8400005D8400005D7B0008557B000055
                7300105173000851730000516B00004D6B00004D630000496300084963000045
                5A00083C5200003C520008384A00003042000028310042100000390400000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000775B44443B28
                2216141622283B444D77645A59595C595959595959595959545B644F4F5D6560
                594F4F5F5F5C5555555B644B5365737568565E6F766B534B4B5B644557254171
                756A70696E735E45455B643F463A112B6C71634142614C3F3F5B64393D46340D
                38484242524E3E39395B642A2A37503226334266623E2F2F2F5B642429405633
                251F2B6774582924245B64203C514A2B191B04256D723118185B64182D121219
                36472E0726673113135B6413271D002C3517271C06431E0E0E5B64080C15231A
                100A0E211B1E0C08085B6405050505050505050909080505055B643008010101
                0101010101010102495B785B44443B282216141622283B444D78}
              Color = clBtnFace
              PopupMenu = PopClose
              TabOrder = 1
              OnMouseDown = btnColseMouseDown
              OnMouseMove = btnColseMouseMove
              OnMouseUp = btnColseMouseUp
            end
            object btnEditGame: TRzBmpButton
              Left = 677
              Top = 465
              Width = 104
              Height = 26
              Cursor = crHandPoint
              Bitmaps.Disabled.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100007700000000000000A1A1
                A0006B6B6D003D3E43002D2F3200E6FFFD007B8887004A4A4A000A052000747B
                7B00545A5A00B8C3C200FFFFFF0008012A008F9C9B000A00360014151500838E
                9C00515866007C8786003A3A3100CEE1DF004C4D5100ADB3B300687170001A0D
                530095A6A500252728000908110064656A0011034A001C1F1E0020222B003436
                39008E96960054545800D7EFED008E9BA9002B245D00C4D5D30043444800636B
                7B00B0BFBE00A3ACAB0004050500666666008586890019057200828A89000C0E
                0E003A3A3A007D7E820014055700BEBEBE004E4E76002F323C0017191D00BFD0
                CE009DABBA00424242006C6D7200999999003C3C3F005151520075757A00292A
                2E005A5A5A000F073900DFF7F5005C5D87009D9EA10015045B00B7CAD200D1E5
                E300616B6B007B839C000F100F0096A4B3005E5F630002000A00A8A8AA009596
                99002022210033333300AEADAE00C5DBD900AEC2C000424A4A00BBCFD500737E
                8C000502160010044300100A2C00B4B4B40014045F00424A4200191919008484
                84008C8C8C00939393007B7B7C00474F4E00737474002929290008090800A4A4
                A40013131C00404551005B5C5F00BDD6CE009EA7A6004D4F530011005600838D
                A400CCE1E300C3D8DC00B5C1C00016075E00D3E7E50000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000005B5B5C383838
                3838383838383838383838383838383838383838383838383838383838383838
                3838383838383838383838383838383838383838383838383838383838383838
                3838383838383838383838383838383838383838383838383838383838383838
                43340F084C4C6041212121212121212121212121212121212121212121212121
                2121212121212121212121212121212121212121212121212121212121212121
                2121212121212121212121212121212121212121212121212121212121212121
                212121212167104C4C0F0D68681F3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3260681C5A2C686060606060606060606060
                6060606060606060606060606060606060606060606060606060606060606060
                6060606060606060606060606060606060606060606060606060606060606060
                60606060606060606060606060606060606060606060606068684F004C606041
                0304323B3B3B3B3B1B1B3E3E3E3B3B3B3B3B2152043B3B3B3B3B21213E3B3204
                1B1F5267671F6060043B3B3B3B041F1F52323B32415260606060606060606060
                6060606060606060606060606060606060606060606060606060606060606060
                68004F004C601B0707413E16161616161607071616161616163B6767213B3B3B
                3B3B3B213207415267213B073B320404033B3B3B3B073E213E3E3E3E3B3E2160
                6060606060606060606060606060606060606060606060606060606060606060
                606060606060606068004F4F1052212323530323232323232332213F23232323
                28414153323B3B3B3B3B3253533B3241533B3B3B3B3B5321283B3B3253323B3B
                3B212104213E3B1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F312C1C31603B4242422828426C6C6C6C
                6C2167280A233F3F3E0421525252213B3B21525252213B21213B21213B3B3B21
                5252213B2152525252213B3B3B3B3B3B215252213B213B3B213B3B2152213B21
                52525252525252525252525252525252525252525252525210316A1F1B2D6C03
                3F4E28422D2D2D2D2D2D070723280303076767323B323B0C0C3B3267323B0C3B
                3B0C3B3B0C0C0C3B67323B0C3B676767673B0C0C0C0C0C0C3B67673B0C3B0C0C
                3B0C0C3B323B0C3B676767676767676767676767676767676767676767676767
                521F205353020A322828326C02020202020202024E0A6F6F4E04043B0C3B3B0C
                3B0C3B323B0C3B32323B0C3B3B3B0C3B323B0C3B3204323B3B3B0C3B3B3B3B0C
                3B04043B0C3B3B0C3B0C3B0C3B0C3B3204040404040404040404040404040404
                0404040404040404040437653E1D1D42073E163C6666664E0266666666666666
                6621213E3B0C0C0C3B3B0C3B0C3B3E21213E3B0C3B3B0C3B3B0C3B3E21213B0C
                0C3B0C3B3B3B3B0C3B3B3E3E3B0C3B0C3B0C3B3B0C3B3E212121212121212121
                2121212121212121212121212121212128656B4A65651D643C3C646464666C28
                6F4E026666646464643E3E3E3B0C3B0C0C3B3B0C3B3B3E3E3E3E3E3B0C3B0C3B
                0C3B3B3B3E3E3B3B3B0C0C0C0C0C0C0C0C0C3B3E3B0C3B0C3B0C3B0C3B0C3B3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E0A4A120642230261
                616464644042072828073F23231D6461022828283B0C3B0C3B3B3B0C3B3B3B3B
                3B3B3B0C0C0C0C0C0C0C0C3B2828283B3B3B3B0C3B3B0C3B3B3B3B3B3B0C0C0C
                3B0C3B0C3B0C3B28282828282828282828282828282828282828282828282828
                1806291A0264622E3C4E4E4E0A1616161616161616161D621D1616163B0C0C0C
                3B0C0C0C0C0C0C3B1616283B3B0C3B3B3B0C3B3B1616163B0C3B3B3B0C0C3B3B
                161616163B0C3B0C3B0C0C0C0C0C3B1616161616161616161616161616161616
                1616161616161616131A5956096263666C1D3C3C422323232323232323423C61
                4E2323233B0C3B0C3B3B3B0C3B3B3B072323073B3B3B0C3B3B3B072323232307
                3B0C3B0C3B3B0C3B072323233B0C3B0C3B0C3B3B3B3B07232323232323232323
                232323232323232323232323232323230E561155305151401D666251644E6C6C
                6C6C6C6C6C1D40024E6C6C6C3B0C0C0C3B0C0C0C0C0C0C3B6C6C3B0C0C0C0C0C
                0C3B166C6C6C163B3B3B0C0C0C0C0C0C3B3B166C3B0C0C0C3B0C3B0C0C0C3B6C
                6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C2B5525242201013D
                61646301612D2D2D2D2D2D2D2D2D2D2D2D2D2D3F3B0C3B0C3B3B3B0C3B3B3B3F
                2D3F3B3B3B0C3B3B3B0C3B2D2D2D3B0C0C3B3B0C3B3B3B3B3B0C3B2D3B0C3B0C
                3B0C3B3B3B0C3B2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2A244D054663015050466969333C3C3C3C3C3C3C3C3C3C3C3C3C3C3B0C0C0C0C
                0C3B0C3B0C3B233C3C3B0C0C0C0C0C3B3B3B3B233C3C233B0C0C0C0C0C0C0C0C
                0C0C3B3C3B0C3B0C3B0C3B3B3B0C3B3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C
                3C3C3C3C3C3C3C3C39054D056E332E623D545454516440404040404040404040
                404040423B3B3B3B3B0C3B423B0C3B4040423B3B3B3B3B0C0C0C0C3B40404042
                3B3B3B3B0C3B3B3B3B3B42403B0C0C0C3B0C0C0C0C0C3B404040404040404040
                4040404040404040404040404040404039054D052B3333336151545D50613333
                33333333333333333333333333333333423B4233423B4233333333333333423B
                3B3B3B4233333333333333423B42333333333333423B3B3B423B3B3B3B3B4233
                33333333333333333333333333333333333333333333333339054D05172E2E2E
                2E2E6935462E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E
                2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E
                2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E
                2705710574626262626246354662626262626262626262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262150536057651636363633D35696363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363636363636363632B05441E580549173D3D3D3D5435463D3D
                3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D
                3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D
                3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0B440571702673050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                3A751E47194B7205050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                05050505050548455E2F}
              Bitmaps.Down.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100008B000000010011008D9B
                AB00080473003E447B00162B450001014200CCFFFF0008067500040469000100
                3A000302620008069C00E6FFFD00B2C6D4000000330055728600020253000908
                A40025405A00060593006E809500130E430000002900333872000F0054000B1F
                38005C5D87009DABBA0006047B00CCE2E4000A088C00160FB600010021003348
                660003004A001F2944000202590046647A000E193000060484000A0883000802
                63000F0BB1002B245D003C5A72007C839C001F3D5A00565F8E00122340005976
                8900ABBECD0007035000C3D8DC0005062B0012304F0096A4B30006034B001A13
                C50006112400D6F0F0006B779D003550690019057200010019005C6E84001B0E
                5300464F75000E0A99001D21430009066D0007045A0015055F00274561008DA9
                B500838DA400273B53001D324C004A5C7300110DA7000F0A9600606B94001031
                4A000C00400016203A00718D9D0009077A0019375400E0F9F800A8C4CB0095A6
                BB0042556B003D466A000C0732002A4863000F088F000D0AA4001412BB00535C
                8B00D2EAEE001613BD00333D5D00B7CAD200C1DCDF007E90A400223350001605
                5B001915C5004D567F00192142000F233A00415B7200808EA000173553000B01
                370008006B000B0B56000506660012044B00120DB6000F0DA00047657B001200
                5900091329001C2E4A003A4B640038556E008C9DB20019294A002A3E59007180
                930010104A005F6E85004F4F77001F204700120CAA00BBCFD50029325100FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000525285783131
                3131313131313131313131313131313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                313131313131313131313131313131313131313131313131313131313131315A
                1518714425256E21808064646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                64646464643D25256E155C3D7D6816160E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E354B7D80535D4C2020161616160E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E161616162020125D302E263F3F0E
                33053833333333330E0E33333333333333330909090533333305050538383805
                0E0E0E0E0E16161609330505050516160E050505050E0E0E0E20202020202020
                2020202020202020202020202020202020202020202020202020202020203F3F
                042E30707A0020050516092222222222222222222222222222090E0E0E090922
                2209090909221616160E09090909161609090909090909090909090909090916
                16163F1616161616161616161616161616163F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F006D706D363A001605050E0E2222222222220E0E2222222222
                220E3F3F3F3F3F160909163F3F3F16091616091616090909163F3F1609163F3F
                3F3F16090909090909163F3F1609160909160909163F1609163F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F0019366D363A1605052222092210101010
                100E2009222222220E1620200E0E0E0E0606090E200E0E060909060909060606
                09200E0E060920202020090606060606060920200906090606090606090E0E06
                092020202020202020202020202020202020203F3F3F3F00193630567A05050E
                222405102424242424240505222209090909202009060909060906090E0E0609
                0E0E0E0609090906090E0E06090E200E09090906090909090609202009060909
                06090609060906090E2020202020202020202020202020202020202020203F3F
                6D567B482633330E05050546747474747474747446333333464616160E0E0606
                060909060906090916160E0E0609090609090609091616090606090609090909
                0609090909090609060906090906090916161616161616161616161616161616
                161616161616203F04484B2C53334646220933450202020A4502020202020202
                02100E0E0E0E0609060609090609090E0E0E0E0E0E0609060906090909090909
                0909060606060606060606090909060906090609060906090E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E16204B2C7C0F230946070707282828552922
                1029020202020202022205050505060906090909060909090909090906060606
                0606060609050505090909090609090609090909090906060609060906090609
                050505050505050505050505050505050505050505050E167C0F4D5488057428
                2828282828291010101046464645282807222222220906060609060606060606
                0922220505050609090906090522222209060905050606090522222222090609
                0609060606060609222222222222222222222222222222222222222222220909
                4D548349644528282845454574242424242424242424074F0710242424090609
                0609090906090909222424220909090609090922242424242209060906090906
                0922242424090609060906090909092224242424242424242424242424242424
                2424242424380505404981585B555E550855282808080808080808080808284F
                0708080808090606060906060606060609080809060606060606092208080822
                0909090606060606060909220809060606090609060606090808080808080808
                0808080808080808080808080824380514586F6642284F281C1E774E1E070202
                0202020202271E28020202021009060906090909060909091002100909090609
                0909060902020209060609090609090909090609020906090609060909090609
                0202020202020202020202020202020202020202020A10226766013B6B5E7777
                4343861F77272727272727272727272727272727090606060606090609060924
                2727090606060606090909092427272409060606060606060606060927090609
                060906090909060927272727272727272727272727272727272727271C1C0A33
                7E3B370C61287776606060600B1313131313131313131313131313130A090909
                090906090A09060913130A090909090906060606091313130A09090909060909
                0909090A13090606060906060606060913131313131313131313131313131313
                13131313271C0810590C370C61451E0B2A393939760B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0A090A0B0A090A0B0B0B0B0B0B0B0A090909090A0B0B0B
                0B0B0B0B0A090A0B0B0B0B0B0B0A0909090A09090909090A0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B13270224590C370C61741C1E0B2A6A6A6A110B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B1327020A590C370C2F0A0727
                130B76392A0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B13270246
                590C4A0C3C24451C27275F395F13131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313271C0824320C840C0D730A080202271F4F1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C0824170C5775870C320310100A0A285E080A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A1050620C4A792B340C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                1B477969412D1D0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C651A473E}
              Bitmaps.Hot.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B000000010000C70000000C07320096A4
                B3000504D900193754000C128C00030274004149BA00E6FFFD00557286001D14
                9C00071CBD000C0040000B19A0002C4AA0000905BC00FFFFFF00130EC3000A06
                A600B6C9D1001223400042556B001E2AAC000705CC007182C200718093000E0A
                7B00170EBD0097A7F000203976000C0793001E12C60004026C00281EA7001018
                96000E0E7D00D6F0F0002F27AF0010235E000807D7005058D3000906B0001910
                9500274561003C5A72000604DE0005035900100CE8001D13A2009DABBA00212E
                AF000F186B000D088B000E08AD008091D2004F4F77000605DE002F369C003C4D
                8B00C1DCDF00141D9B0011304E003439E4000806C500281AB60008005200ABBE
                F5000D0884000E203D000B079C00100EE100808EA0005976890012197000C3D8
                DC002114CB00262D8E002110AD00142762005F70B0004D5E9D003A4B64002929
                B5006C77EC002818BF002B2BAE0046647A002F2FB300050363005760E9002F20
                B400130DAC00A8C4CB00595A8500B3C7F60010005C00130E4300100CD3002843
                87000908E4002A3B5500161E78002B245D000A1FB90002027A008D9BAB001D21
                4300160950002634B6001A13E4001B1794002016D4002323A300193169000000
                3B001924A5001D12B200E0F9F800100BA5000F099B0012304F002719AF00CBE1
                E3002C1EB100211994003840AB002921BD000F0ABC000B08B6000F0AC7008DA9
                B500271AC600718D9D003F45E5005F6E85001810B3003550690047657B001A13
                DF002A486300415B72001F3D5A00545DE6001810990034519600100BD2000D0A
                CF000D138E000D0AE7002331B30014006F002016BD002B21AD00121B9B001506
                5D004951C700BBCFD500110AB4008E9EE000D3EAFA001A12CD002318A4001204
                4B00161F3E0079819A002C3D7B00616BEA00243E8E002A3E59001E2582002110
                DE00173553000B0137000A17A200110B93000F00540020199C001B26A8002215
                B700130FED002416CE002417AC001B11D7001620A0001B11AE001C2E4A003855
                6E0026426A00555DDC00838DA4002318C2001424770015276300415F83001010
                4A001F2047001E306D004D5C7500375492000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000B0BC2884747
                4747474747474747474747474747474747474747474747474747474747474747
                4747474747474747474747474747474747474747474747474747474747474747
                4747474747474747474747474747474747474747474747474747474747474714
                5FAEAB695555C08F0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0DC588888B5F0087B9A60A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A6661B9A7A28A1CACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACBA8A138CBE0404B6
                9472156B6B6B6B943B3B9494946B6B6B6B6B1521726B6B6B6B6B15B094943172
                3B9221B698929292726B6B6B6B72219221316B31B62104040404040404040404
                0404040404040404040404040404040404040404040404040404040404040404
                708C13AA48229254546D6F565656565656545656565656565622222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                22222222222222224DAA437732226D24246DAF2424242424246D6D9724242424
                6F19191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                191919191919191919191919191919192577433C32AF979797AFAF9724242424
                242922AF972020206D19191919192D71712D1919192D712D2D712D2D7171712D
                19192D712D191919192D7171717171712D19192D712D71712D71712D192D712D
                191919191919191919191919191919191919191919191919253C130348599729
                A07A0920595959595959AFAFA00929290919192D712D710F0F712D192D710F71
                710F71710F0F0F71192D710F7119191919710F0F0F0F0F0F711919710F710F0F
                710F0F712D710F71191919191919191919191919191919191919191919191919
                BF03B82A6459A0AD8E8EADB4595959595959595978A02F2FB44242710F71710F
                710F712D710F712D2D710F7171710F712D710F712D422D7171710F717171710F
                714242710F71710F710F710F710F712D42424242424242424242424242424242
                4242424242424242C32A632BA878784C8EAD2F3F3F3F3FB43F7D7D7D7D7D7D7D
                7D33332D710F0F0F71710F710F712D33332D710F71710F71710F712D3333710F
                0F710F717171710F71712D2D710F710F710F71710F712D333333333333333333
                33333333333333333333333333333333A42B50084B767353B1B153535353B776
                75B7B1B153535353531D1D1D710F710F0F71710F71571D1D1D1D57710F710F71
                0F7171571D1D5771710F0F0F0F0F0F0F0F0F711D710F710F710F710F710F711D
                1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D3908C48338751A82
                82BDBDBD965A4444444475757586BD8273444444710F710F7171710F71717157
                4444710F0F0F0F0F0F0F0F71444444577171710F71710F7171715744710F0F0F
                710F710F710F7144444444444444444444444444444444444444444444444444
                4F8385817C1EB34A1A9C9C9C341111111111111111111AB39C111111710F0F0F
                710F0F0F0F0F0F7111115771710F7171710F7157111111710F7157710F0F7157
                11111111710F710F710F0F0F0F0F711111111111111111111111111111111111
                11111111111111114E81185B066E6E107F7E101028282828282828282828109F
                7E282828710F710F7171710F7171711F28281F7171710F7171711F282828281F
                710F710F71710F711F282828710F710F710F717171711F282828282828282828
                28282828282828282828282828282828175B463A9AB5B5800E80B5B5800E0E0E
                0E0E0E0E0E0E80800E0E0E0E710F0F0F710F0F0F0F0F0F710E0E710F0F0F0F0F
                0F71050E0E0E057171710F0F0F0F0F0F7171050E710F0F0F710F710F0F0F710E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E353A682327898989
                6091B589903E3E3E3E3E3E3E3E3E3E3E3E3E3E05710F710F7171710F71717105
                3E057171710F7171710F713E3E3E710F0F71710F71717171710F713E710F710F
                710F7171710F713E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                9D230107BB45456C6C6C6C6C911616161616161616161616161616710F0F0F0F
                0F710F710F71051616710F0F0F0F0F7171717105161605710F0F0F0F0F0F0F0F
                0F0F7116710F710F710F7171710F711616161616161616161616161616161616
                16161616161616161B0701078D262626456C6C6C452626262626262626262626
                2626266771717171710F7167710F7126266771717171710F0F0F0F7126262667
                717171710F71717171716726710F0F0F710F0F0F0F0F71262626262626262626
                262626262626262626262626262626261B0701078D0202020262B2B22E020202
                0202020202020202020202020202020267716702677167020202020202026771
                7171716702020202020202677167020202020202677171716771717171716702
                0202020202020202020202020202020202020202020202021B070107582C2C2C
                2C2C93B2622C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                1B07BC07522C2C2C2C2C62B2622C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C410736075D452C2C2C2C2CB2622C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C3D0774A19B0741842C2C2C2C622E372C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2CA59E07BCAE6549070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                30995E5E6AA37907070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                070707070707125C5E95}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A000000000000000000000001000000000000010021008893
                A5000000990019375400000058006B8599000000F0004F517200E2FCFA000000
                D7000000420001008D000000CC0001008300C1DCDF00E6FFFD00171843002B3D
                8E0001003A00010072001A1C9A000000C4000000BC00A8C4CB003A3668000000
                E50001004A0000003300292258008999F8000000AD001B1ED200000066006E7B
                F10047657B0000005200D6F0F000A4B4BF000B1070005572860000002A000D0F
                F1002D3B5B0011304E00181A8B000E014A003C5A720000006B00657D8E000E11
                5F0085A0B100B6D0DA0001007B001B1EAA0038556E003A528400100054002E36
                5A00112B4900CAE0E200CCFFFF0001009300506C8300494872000F0058001732
                4D002E33E0000C023A00DEF7EF000000B5008DA9B5001F3D5A00ABC2C9005976
                89000000DF007E95A300030628001B1EC5001E21F2002745610036445F000B0D
                52001524510015177C001E27490029428C0008004A00CAE3EB0018345200B1C3
                CB0030486E007178940095A2B40021425A00BED4D8000000F6000200A300D7F0
                F70005083C00718D9D0094A5F8000E164B009FB9C600121A700012304F002A48
                630004063200CBE1E300060A2C0095ADB7001F314E0057738600DDF6F5001114
                6E00B5CEDE001B1EB8000E043B00364B63002E428B00080B460021426300FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002D74506F4949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949492739
                2D40437522223711111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                11111111763722222A2D54365A26131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313673636104769650A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A52696E474700001223
                0A1A23232323231B1B23232323232323231A1B1204232323231A1A1A1A1A1A1B
                282812122828280A232323230A2828281A041A12120000000000000000000000
                000000000000000000000000000000000000000000000000000000000000006C
                47585858001B23231B1A0404040404040404040404040404041B1B1B0A0A0404
                040A1B12231B00001B1212040A0028121A040A0A0A1A120A0A0A0A0A0A1B1B1B
                1B00000028282828282828282828282828000000000000000000000000000000
                000000000000004C58416868280A0404121A0404040404040A0A040404040404
                1B1B1B1B0A0A0A041A121B1B0A0A001B0A0A0A0A0A1B1B0A0A0A1212121A1A12
                121B1B1B1212121B1B1B00282828282828282828282828282828000000000000
                0000000000000000000000000000004C683A2B2B1A040404041A042020202020
                0A1B1A040404040A281B282828281B1B1B1B2828281B1B1B1B1B1B1B1212121B
                28281B1B1B282828281B1212121212121B28281B1B1B1B1B1B1B1B1B281B1B1B
                2828282828282828282828282828282828282828282828282B3A03032F2F1A04
                2023202F2F2F2F2F2F232323231A1A1A1A1A281B1B1B1B3C3C12121212123C12
                123C12123C3C3C121212123C1228282828123C3C3C3C3C3C121212123C123C3C
                123C3C1212123C1228282828282828282828282828282828282828282828286A
                03414F4F34200A23231A2034343434343434342F2F04042F131312123C12123C
                123C1212123C121212123C1212123C1212123C121212121212123C121212123C
                121212123C12123C123C123C123C121212121212121212121212121212121212
                12121212121212624F5D2E36131320041A04343434342F34340D0D0D0D0D0D0D
                0D130A0A0A3C3C3C12123C123C1212121212123C12123C12123C12121212123C
                3C123C121212123C12121212123C123C123C12123C12120A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A772E75273E04130B34340B0B0B0D2F0404
                2F34340D0B0B0B0B0D041A1A123C123C3C12123C120A1A1A1A1A0A0A3C123C12
                3C12120A1A1A0A0A0A3C3C3C3C3C3C3C3C3C121A123C123C123C123C123C121A
                1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A5127226305200D3D3D
                0B0B0B0B2F04040404202020340B0B0D200A0404123C123C1212123C1212121A
                0404123C3C3C3C3C3C3C3C120404041A1212123C12123C1212121A04123C3C3C
                123C123C123C1204040404040404040404040404040404040404040404040431
                633046323D60600D343434132020202020202020200D600D201A2020123C3C3C
                123C3C3C3C3C3C1220201A12123C1212123C121A202020123C121A123C3C121A
                20202020123C123C123C3C3C3C3C122020202020202020202020202020202020
                2020202020202071464B486660600B340D0B0B131313131313131313130B600D
                13131313123C123C1212123C121212231313231212123C121212231313131323
                123C123C12123C1223131313123C123C123C1212121223131313131313131313
                13131313131313131313131313131353176D0E331E45020B0B1E1E020D0D0D0D
                0D0D0D0D0B0B0B0D0D0D0D0D123C3C3C123C3C3C3C3C3C120D0D123C3C3C3C3C
                3C12040D0D0D041212123C3C3C3C3C3C1212040D123C3C3C123C123C3C3C120D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D2C0E4824571616161E
                6045451E3D0B0B0B0B0B0B0B0B0B0B0B0B0B0B04123C123C1212123C12121204
                0B041212123C1212123C120B0B0B123C3C12123C12121212123C120B123C123C
                123C1212123C120B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B14
                245E0F61161515151515151E606060606060606060606060606060123C3C3C3C
                3C123C123C12206060123C3C3C3C3C1212121220606020123C3C3C3C3C3C3C3C
                3C3C1260123C123C123C1212123C126060606060606060606060606060606060
                60606060606060350F3B0F614545451509090915451E1E1E1E1E1E1E1E1E1E1E
                1E1E1E2F12121212123C122F123C121E1E2F12121212123C3C3C3C121E1E1E2F
                121212123C12121212122F1E123C3C3C123C3C3C3C3C121E1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E730F6B0F61161616160C09090915161616
                1616161616161616161616161616161613121316131213161616161616161312
                1212121316161616161616131213161616161616131212121312121212121316
                16161616161616161616161616161616161616161616164D0F6B0F610C0C0C0C
                0C4A4A4A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C1F
                0F6B080F09090909094A4A4A0909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                09090909090909420F33590F2119191919190606191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                191919191919191919191919191919640F013F0F0F1D29060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606064E640F701C2D5B080F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F70
                072D40401825080F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F245C1C2D2D}
              Color = clBtnFace
              PopupMenu = PopContactUs
              TabOrder = 2
              OnMouseDown = btnEditGameMouseDown
              OnMouseMove = btnEditGameMouseMove
              OnMouseUp = btnEditGameMouseUp
            end
            object btnEditGameList: TRzBmpButton
              Left = 677
              Top = 497
              Width = 104
              Height = 26
              Cursor = crHandPoint
              Bitmaps.Disabled.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B00000001000077000000000000009999
                990066666600E6FFFD003D3E43002D2F32007D7E8200A1A1A0004A4A4A000A05
                2000B8C3C200687170007B839C00FFFFFF0008012A000A003600545458001415
                15008C8C8C003A3A3100CEE1DF008F9C9B00ADB3B300616B6B004C4D5100747B
                7B001A0D53002527280009081100515866008E96960011034A001C1F1E004E4E
                760020222B00343639009EA7A600D7EFED002B245D00C4D5D300848484004344
                4800B0BFBE006C6D7200A3ACAB0096A4B30004050500190572000C0E0E003C3C
                3F00140557005A5A5A00BEBEBE007C8786002F323C0017191D00BFD0CE005C5D
                8700424242009DABBA006B6B6D0064656A0095A6A5003A3A3A00515152007575
                7A00292A2E000F073900DFF7F5008586890015045B00B7CAD200838E9C00D1E5
                E3000F100F005E5F630002000A00A8A8AA008E9BA900959699009D9EA1002022
                210033333300AEADAE00C5DBD900AEC2C000424A4A00636B7B00BBCFD500737E
                8C00545A5A000502160010044300100A2C00B4B4B40014045F00424A42001919
                1900939393007B7B7C00474F4E00737474002929290008090800A4A4A4001313
                1C00404551005B5C5F00BDD6CE004D4F5300110056007B8C8400838DA400CCE1
                E300C3D8DC00B5C1C000828A890016075E00D3E7E50000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000005C5C5D373737
                3737373737373737373737373737373737373737373737373737373737373737
                3737373737373737373737373737373737373737373737373737373737373737
                3737373737373737373737373737373737373737373737373737373737373737
                43320F094A4A6142232323232323232323232323232323232323232323232323
                2323232323232323232323232323232323232323232323232323232323232323
                2323232323232323232323232323232323232323232323232323232323232323
                232323232366114A4A0F0E676720313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                31313131313131313131313131313F61671C5B2E676161616161616161616161
                6161616161616161616161616161616161616161616161616161616161616161
                6161616161616161616161616161616161616161616161616161616161616161
                61616161616161616161616161616161616161616161616167674C004A616142
                04053F3A3A3A3A3A1B1B3131313A3A3A3A3A2351053A3A3A3A3A2323313A3F05
                1B20516666206161053A3A3A3A052020513F3A3F425161616161616161616161
                6161616161616161616161616161616161616161616161616161616161616161
                67004C004A611B0808423118181818181808081818181818183A6666233A3A3A
                3A3A3A233F08425166233A083A3F0505043A3A3A3A083123313131313A312361
                6161616161616161616161616161616161616161616161616161616161616161
                616161616161616167004C4C115123101052041010101010103F234010101010
                294242523F3A3A3A3A3A3F52523A3F42523A3A3A3A3A5223293A3A3F523F3A3A
                3A23230523313A20202020202020202020202020202020202020202020202020
                20202020202020202020202020202020302E1C30613A3333332929336B6B6B6B
                6B23662933104040310523233A2351233A3A3A3A3A3A3A2351233A3A3A3A3A3A
                3A3A3A23515151233A23233A3A233A3A235151233A2351233A3A2351233A3A23
                515151515151515151515151515151515151515151515151113069201B026B04
                404B29330202020202020808102904040866663A0D3A3A3A0D0D0D0D0D0D0D3A
                663A0D0D0D0D0D0D0D0D0D3A66663F3A0D3A3A0D0D3A0D0D3A66663A0D3A3F3A
                0D0D3A3F3A0D0D3A666666666666666666666666666666666666666666666666
                51202252523C5A3F29293F6B3C3C3C3C3C3C3C3C4B5A6D6D4B05053A0D3A0D0D
                3A3A3A3A3A3A3A3F053A0D3A3A3A0D3A3A3A0D3A05053A0D3A0D3A3A0D3A3A0D
                3A05053F3A0D3A3F3A3A0D3A0D3A0D3A05050505050505050505050505050505
                050505050505050505053664313D3D330831182B6565654B3C65656565656565
                652323313A0D3A3A0D0D0D3A3A0D3A23233A0D3A233A0D3A233A0D3A23233A0D
                3A3A0D3A0D3A3A0D3A2323233A0D3A3A0D3A3A0D3A3A0D3A2323232323232323
                2323232323232323232323232323232329646A1764643D632B2B636363656B29
                6D4B3C6565636363633131313A0D3A3A0D3A3A3A0D3A3A31313A0D3A313A0D3A
                313A0D3A31313A0D3A3A0D3A0D3A3A0D3A3A3A31313A0D0D3A3A3A0D3A3A3A3A
                3131313131313131313131313131313131313131313131315A171D3533103C28
                286363634133082929084010103D63283C2929293A0D3A3A0D3A0D0D3A0D3A3A
                3A3A0D3A3A3A0D3A3A3A0D3A3A3A3A3A0D3A0D3A0D3A0D0D0D0D3A3A3A3A0D3A
                3A3A0D3A0D3A3A29292929292929292929292929292929292929292929292929
                0B35573E176312452B4B4B4B101818181818181818183D123D1818293A0D3A3A
                0D3A3A3A3A3A3A1818293A3A3A3A0D3A3A3A3A3A1818183A0D3A0D3A0D3A3A0D
                3A3A3A3A3A0D3A0D3A3A0D3A3A0D3A1818181818181818181818181818181818
                1818181818181818353E5955191262656B3D2B2B331010101010101010332B28
                4B10103A0D0D3A3A0D0D0D0D0D0D3A10103A0D0D0D0D0D0D0D0D0D3A1010083A
                0D3A0D0D0D3A3A3A0D3A083A0D3A3A0D0D0D0D3A3A3A3A081010101010101010
                1010101010101010101010101010101015554854744F4F413D65124F634B6B6B
                6B6B6B6B6B3D413C4B4B4B183A3A183A0D3A3A3A3A0D3A6B6B3A0D3A3A3A0D3A
                3A3A0D3A6B6B3A0D3A3A0D3A3A0D0D0D0D0D3A183A183A0D3A3A0D0D0D0D0D3A
                6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B2C544E251E070701
                28636207280202020202020202020202020202023A0D3A3A0D0D0D0D0D0D3A02
                023A0D3A023A0D3A023A0D3A0202403A3A0D0D0D0D0D3A3A3A3A40403A3A3A0D
                3A3A0D3A3A0D3A40020202020202020202020202020202020202020202020202
                2A252D035062074D4D506868062B2B2B2B2B2B2B2B2B2B2B2B2B2B103A0D3A3A
                0D3A3A3A3A0D3A2B2B3A0D3A2B3A0D3A2B3A0D3A2B2B103A0D3A3A0D3A3A0D0D
                0D0D3A3A0D0D0D0D3A3A0D3A3A0D3A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B
                2B2B2B2B2B2B2B2B38032D0324064512015353534F6341414141414141414141
                4141413A0D3A333A0D0D0D0D0D0D3A4141333A33413A0D3A41333A3341413A0D
                3A3A0D3A333A0D3A3A3A33333A3A3A3A333A0D3A0D3A33414141414141414141
                4141414141414141414141414141414138032D032C060606284F535E4D280606
                0606060606060606060606333A3306333A3A3A3A3A3A33060606060606333A33
                060606060606333A33333A3306333A33060606060606060606333A333A330606
                06060606060606060606060606060606060606060606060638032D0316454545
                4545683450454545454545454545454545454545454545454545454545454545
                4545454545454545454545454545454545454545454545454545454545454545
                4545454545454545454545454545454545454545454545454545454545454545
                2703700373121212121250345012121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                121212121212121214032103764F626262620134686262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262626262626262622C03441F58034916010101015334500101
                0101010101010101010101010101010101010101010101010101010101010101
                0101010101010101010101010101010101010101010101010101010101010101
                010101010101010101010101010101010101010101010A4403706E2672030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                3B751F461A0C7103030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                03030303030347395F2F}
              Bitmaps.Down.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100008B000000010011008D9B
                AB00080473003E447B00162B450001014200CCFFFF0008067500040469000100
                3A000302620008069C00E6FFFD00B2C6D4000000330055728600020253000908
                A40025405A00060593006E809500130E430000002900333872000F0054000B1F
                38005C5D87009DABBA0006047B00CCE2E4000A088C00160FB600010021003348
                660003004A001F2944000202590046647A00060484000E1930000A0883000802
                63000F0BB1002B245D003C5A72007C839C001F3D5A00565F8E00122340000703
                500059768900ABBECD0005062B00C3D8DC0012304F0096A4B30006034B001A13
                C50006112400D6F0F0006B779D003550690019057200010019005C6E84001B0E
                5300464F75000E0A99001D21430009066D0015055F0007045A00274561008DA9
                B500838DA400273B53001D324C004A5C7300110DA7000F0A9600606B94001031
                4A000C00400016203A00718D9D0009077A0019375400E0F9F800A8C4CB0095A6
                BB0042556B003D466A000C0732002A4863000F088F000D0AA4001412BB00535C
                8B00D2EAEE001613BD00333D5D00B7CAD200C1DCDF007E90A400223350001605
                5B001915C5004D567F00192142000F233A00415B7200808EA000173553000B01
                370008006B000B0B56000506660012044B00120DB6000F0DA00047657B001200
                5900091329001C2E4A003A4B640038556E008C9DB20019294A002A3E59007180
                930010104A005F6E85004F4F77001F204700120CAA00BBCFD50029325100FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000525285783232
                3232323232323232323232323232323232323232323232323232323232323232
                3232323232323232323232323232323232323232323232323232323232323232
                323232323232323232323232323232323232323232323232323232323232325A
                1518714425256E21808064646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                64646464643D25256E155C3D7D6816160E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E344B7D80535D4C2020161616160E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E161616162020125D302E273F3F0E
                31053831313131310E0E31313131313131310909090531313105050538383805
                0E0E0E0E0E16161609310505050516160E050505050E0E0E0E20202020202020
                2020202020202020202020202020202020202020202020202020202020203F3F
                042E30707A0020050516092222222222222222222222222222090E0E0E090922
                2209090909221616160E09090909161609090909090909090909090909090916
                16163F1616161616161616161616161616163F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F006D706D363A001605050E0E2222222222220E0E2222222222
                220E3F3F1609163F1609090909090909163F16090909090909090909163F3F3F
                160916160909160909163F3F1609163F160909163F160909163F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F0019366D363A1605052222092210101010
                100E2009222222220E1620200906090909060606060606060920090606060606
                060606060920200E0E06090906060906060920200906090E0E0606090E0E0606
                092020202020202020202020202020202020203F3F3F3F00193630567A05050E
                2224051024242424242405052222090909092020090609060609090909090909
                0E2009060909090609090906092020090609060909060909060920200E0E0609
                0E0E0E0609060906092020202020202020202020202020202020202020203F3F
                6D567B482731310E05050547747474747474747447313131474716160E0E0609
                0906060609090609161609060916090609160906091616090609090609060909
                0609161616090609090609090609090609161616161616161616161616161616
                161616161616203F04484B2C53314747220931450202020A4502020202020202
                02100E0E0E0E0609090609090906090909090906090909060909090609090909
                060909060906090906090909090909060609090906090909090E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E16204B2C7C0F230947070707282828552922
                1029020202020202022205050505060909060906060906090909090609090906
                0909090609090909090609060906090606060609090909060909090609060909
                050505050505050505050505050505050505050505050E167C0F4D5488057428
                2828282828291010101047474745282807222222050506090906090909090905
                2222050909090906090909090522222209060906090609090609090505050609
                0609090609090609222222222222222222222222222222222222222222220909
                4D548349644528282845454574242424242424242424074F0710101009060609
                0906060606060609242409060606060606060606092424220906090606060909
                0906092209060909060606060909090922242424242424242424242424242424
                2424242424380505404981585B555E550855282808080808080808080808284F
                0708080822090922090609090909060908080906090909060909090609080809
                0609090609090606060606092209220906090906060606060908080808080808
                0808080808080808080808080824380514586F6642284F281C1E774E1E070202
                0202020202261E28020202020209060909060606060606090202090609020906
                0902090609020210090906060606060909090910100909090609090609090609
                1002020202020202020202020202020202020202020A10226766013B6B5E7777
                4343861F77262626262626262626262626262626240906090906090909090609
                2626090609260906092609060926262409060909060909060606060909060606
                060909060909060926262626262626262626262626262626262626261C1C0A31
                7E3B370C61287776606060600B1313131313131313131313131313130906090A
                090606060606060913130A090A13090609130A090A13130906090906090A0906
                0909090A0A090909090A09060906090A13131313131313131313131313131313
                13131313261C0810590C370C61451E0B2A393939760B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0A090A0B0A0909090909090A0B0B0B0B0B0B0A090A0B0B0B0B0B0B0A
                090A0A090A0B0A090A0B0B0B0B0B0B0B0B0B0A090A090A0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B13260224590C370C61741C1E0B2A6A6A6A110B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B1326020A590C370C2F0A0726
                130B76392A0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B13260247
                590C4A0C3C24451C26265F395F13131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313261C0824330C840C0D730A080202261F4F1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C0824170C5775870C330310100A0A285E080A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A1050620C4A792B350C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                1B467969412D1D0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C651A463E}
              Bitmaps.Hot.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B000000010000C70000000C07320096A4
                B3000504D900193754000C128C00030274004149BA00E6FFFD00557286001D14
                9C00071CBD000C0040000B19A0002C4AA0000905BC00FFFFFF00130EC3000B07
                9C00B6C9D1001223400042556B001E2AAC000705CC007182C2000E0A7B007180
                9300170EBD0097A7F000203976001E12C6000906B00004026C00281EA7001018
                96000E0E7D00D6F0F0002F27AF000D088B0010235E000807D7005058D3002745
                61003C5A7200100CE8000604DE000A06A600130E43001D13A2009DABBA00212E
                AF000F186B000C0793008091D2000E08AD004F4F77000605DE002F369C003C4D
                8B00C1DCDF00141D9B0011304E003439E4000806C5000D088400281AB600ABBE
                F5000E203D0005035900100EE100808EA000597689001810990012197000C3D8
                DC002114CB00262D8E002110AD00142762005F70B0004D5E9D003A4B64002929
                B5006C77EC002818BF00191095002B2BAE0046647A00050363002F2FB3005760
                E9002F20B400130DAC0008005200A8C4CB00595A8500B3C7F600100CD3000202
                7A0028438700160950000908E4002A3B5500161E78002B245D000A1FB9008D9B
                AB001D2143002634B6001A13E4001B1794002016D4002323A300193169000000
                3B001924A5001D12B200E0F9F800100BA5000F099B0012304F002719AF00CBE1
                E3002C1EB100211994003840AB000D138E002921BD000F0AC7000F0ABC000B08
                B6008DA9B50010005C00271AC600718D9D003F45E5005F6E85001810B3003550
                690047657B001A13DF002A486300415B72001F3D5A00545DE60034519600100B
                D2000D0ACF000D0AE7002331B30014006F002016BD002B21AD00121B9B004951
                C700BBCFD5008E9EE000110AB400D3EAFA001A12CD002318A40012044B00161F
                3E0079819A002C3D7B00616BEA00243E8E002A3E59001E2582002110DE001735
                53000B0137000A17A200110B93000F00540020199C001B26A8002215B700130F
                ED002416CE002417AC001B11D7001620A0001B11AE001C2E4A0038556E002642
                6A00555DDC00838DA4002318C20010104A001424770015276300415F83001506
                5D001F2047001E306D004D5C7500375492000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000B0BC28A4646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464614
                2EADAA6A5656C0900D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0DC58A8A8D2E0089B8A50A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A6862B8A6A18C1CABABABABABABABABABABAB
                ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB
                ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB
                ABABABABABABABABABABABABABABABABABABABABABABABABB98C138EBE0404B5
                9472156B6B6B6B943B3B9494946B6B6B6B6B1521726B6B6B6B6B15AF94943172
                3B7D21B5987D7D7D726B6B6B6B72217D21316B31B52104040404040404040404
                0404040404040404040404040404040404040404040404040404040404040404
                708E13A948227D55556D6F585858585858555858585858585822222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                22222222222222224DA9427732226D24246DAE2424242424246D6D9724242424
                6F18181818181818181818181818181818181818181818181818181818181818
                1818181818181818181818181818181818181818181818181818181818181818
                181818181818181818181818181818182677423C32AE979797AEAE9724242424
                245422AE972020206D1818437143184371717171717171431843717171717171
                7171714318181843714343717143717143181843714318437171431843717143
                181818181818181818181818181818181818181818181818263C1303485A9754
                9F7A09205A5A5A5A5A5AAEAE9F095454091818710F7171710F0F0F0F0F0F0F71
                18710F0F0F0F0F0F0F0F0F71181843710F71710F0F710F0F711818710F714371
                0F0F7143710F0F71181818181818181818181818181818181818181818181818
                BF03B729665A9FAC4747ACB35A5A5A5A5A5A5A5A789F2F2FB33F3F710F710F0F
                71717171717171433F710F7171710F7171710F713F3F710F710F71710F71710F
                713F3F43710F714371710F710F710F713F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3FC329652AA778784C47AC2F40404040B3407E7E7E7E7E7E7E
                7E252543710F71710F0F0F71710F712525710F7125710F7125710F712525710F
                71710F710F71710F71252525710F71710F71710F71710F712525252525252525
                25252525252525252525252525252525A32A50084B767353B0B053535353B676
                75B6B0B05353535353333333710F71710F7171710F71573333710F7133710F71
                33710F713333710F71710F710F71710F7171573357710F0F7157710F71577157
                3333333333333333333333333333333333333333333333333908C48538751A84
                84BCBCBC965B1111111175757588BC8473111111710F71710F710F0F710F7111
                11710F7111710F7111710F71111157710F710F710F710F0F0F0F711157710F71
                57710F710F715711111111111111111111111111111111111111111111111111
                4F8587827C1DB24A1A9C9C9C352D2D2D2D2D2D2D2D2D1AB29C2D2D57710F7171
                0F7171717171572D2D57717171710F71717171572D2D2D710F710F710F71710F
                71715757710F710F71710F71710F712D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D4E82195D066E6E10818010101E1E1E1E1E1E1E1E1E1E109E
                801E1E710F0F71710F0F0F0F0F0F711E1E710F0F0F0F0F0F0F0F0F711E1E1F71
                0F710F0F0F7171710F711F710F71710F0F0F0F717171711F1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E175D453A99B4B47F0E7FB4B47F0E0E0E
                0E0E0E0E0E0E7F7F0E0E0E05717105710F717171710F710E0E710F7171710F71
                71710F710E0E710F71710F71710F0F0F0F0F71057105710F71710F0F0F0F0F71
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E343A6923288B8B8B
                6092B48B913E3E3E3E3E3E3E3E3E3E3E3E3E3E3E710F71710F0F0F0F0F0F713E
                3E710F713E710F713E710F713E3E0571710F0F0F0F0F7171717105057171710F
                71710F71710F71053E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                9B230107BA44446C6C6C6C6C92161616161616161616161616161605710F7171
                0F717171710F711616710F7116710F7116710F71161605710F71710F71710F0F
                0F0F71710F0F0F0F71710F71710F711616161616161616161616161616161616
                16161616161616161B0701078F272727446C6C6C442727272727272727272727
                272727710F7161710F0F0F0F0F0F71272761716127710F71276171612727710F
                71710F7161710F71717161617171717161710F710F7161272727272727272727
                272727272727272727272727272727271B0701078F0202020264B1B12B020202
                0202020202020202020202617161026171717171717161020202020202617161
                0202020202026171616171610261716102020202020202020261716171610202
                0202020202020202020202020202020202020202020202021B070107592C2C2C
                2C2C93B1642C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                1B07BB07522C2C2C2C2C64B1642C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C410736075F442C2C2C2C2CB1642C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C3D0774A09A0741862C2C2C2C642B372C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2CA49D07BBAD6749070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                30C1838363A27907070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                070707070707125E8395}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A000000000000000000000001000000000000010021008893
                A5000000990019375400000058006B8599000000F0004F517200E2FCFA000000
                D7000000420001008D000000CC00C1DCDF000100830017184300E6FFFD002B3D
                8E0001003A00010072001A1C9A000000C4000000BC00A8C4CB003A3668000000
                E50001004A0029225800000033008999F8000000AD00000066001B1ED2006E7B
                F10047657B00D6F0F00000005200A4B4BF000B1070005572860000002A000D0F
                F1002D3B5B0011304E00181A8B000C00460000006B003C5A7200657D8E000E11
                5F0085A0B100B6D0DA001B1EAA0001007B0038556E003A528400100054002E36
                5A00112B4900CAE0E200CCFFFF0001009300506C8300494872000F0058001732
                4D002E33E0000C023A00DEF7EF000000B5008DA9B5001F3D5A00ABC2C9005976
                89000000DF007E95A300030628001B1EC5001E21F2002745610036445F000B0D
                52001524510015177C001E27490029428C00CAE3EB0018345200B1C3CB003048
                6E007178940095A2B4000E014A0021425A00BED4D8000000F6000200A300D7F0
                F70005083C00718D9D0094A5F8000E164B009FB9C600121A700012304F002A48
                630004063200CBE1E300060A2C0095ADB7001F314E0057738600DDF6F500080B
                460011146E00B5CEDE001B1EB8000E043B00364B63002E428B0021426300FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002D75506F4949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949492739
                5C40437622223711111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                11111111773722222A2D54365926131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313131313131313131313136736360F4769650A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A52696E474700001224
                0A1A24242424241C1C24242424242424241A1C1204242424241A1A1A1A1A1A1C
                282812122828280A242424240A2828281A041A12120000000000000000000000
                000000000000000000000000000000000000000000000000000000000000006C
                47575757001C24241C1A0404040404040404040404040404041C1C1C0A0A0404
                040A1C12241C00001C1212040A0028121A040A0A0A1A120A0A0A0A0A0A1C1C1C
                1C00000028282828282828282828282828000000000000000000000000000000
                000000000000004C57416868280A0404121A0404040404040A0A040404040404
                1C1C1C1C0A0A0A041A121C1C0A0A001C0A0A0A0A0A1C1C0A0A0A1212121A1A12
                121C1C1C1212121C1C1C00282828282828282828282828282828000000000000
                0000000000000000000000000000004C683A2B2B1A040404041A041F1F1F1F1F
                0A1C1A040404040A281C281C1C1C281C121212121212121C281C121212121212
                1212121C2828281C1C1C1C1C1C1C1C1C1C28281C1C1C281C1C1C1C281C1C1C1C
                2828282828282828282828282828282828282828282828282B3A03032E2E1A04
                1F241F2E2E2E2E2E2E242424241A1A1A1A1A28123C1212123C3C3C3C3C3C3C12
                12123C3C3C3C3C3C3C3C3C12121212123C12123C3C123C3C121212123C121212
                3C3C1212123C3C1228282828282828282828282828282828282828282828286A
                03414F4F351F0A24241A1F35353535353535352E2E04042E131312123C123C3C
                121212121212121212123C1212123C1212123C121212123C123C12123C12123C
                12121212123C121212123C123C123C1212121212121212121212121212121212
                12121212121212624F5D2F3613131F041A04353535352E35350E0E0E0E0E0E0E
                0E130A0A0A3C12123C3C3C12123C121212123C1212123C1212123C121212123C
                12123C123C12123C120A0A0A0A3C12123C12123C12123C120A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A712F76273E04130B35350B0B0B0E2E0404
                2E35350E0B0B0B0B0E041A1A123C12123C1212123C120A1A1A123C121A123C12
                1A123C121A1A123C12123C123C12123C12120A1A0A0A3C3C120A0A3C120A0A0A
                1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A51272263051F0E3D3D
                0B0B0B0B2E040404041F1F1F350B0B0E1F0A0404123C12123C123C3C123C1204
                04123C1204123C1204123C1204041A123C123C123C123C3C3C3C12041A123C12
                1A123C123C121A04040404040404040404040404040404040404040404040431
                633046323D60600E353535131F1F1F1F1F1F1F1F1F0E600E1F1A1F1A123C1212
                3C12121212121A1F1F1A121212123C121212121A1F1F1F123C123C123C12123C
                12121A1A123C123C12123C12123C121F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F72464B486660600B350E0B0B131313131313131313130B600E
                131313123C3C12123C3C3C3C3C3C121313123C3C3C3C3C3C3C3C3C1213132412
                3C123C3C3C1212123C1224123C12123C3C3C3C12121212241313131313131313
                13131313131313131313131313131353176D0D331E45020B0B1E1E020E0E0E0E
                0E0E0E0E0B0B0B0E0E0E0E04121204123C121212123C120E0E123C1212123C12
                12123C120E0E123C12123C12123C3C3C3C3C12041204123C12123C3C3C3C3C12
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E2C0D4823561616161E
                6045451E3D0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B123C12123C3C3C3C3C3C120B
                0B123C120B123C120B123C120B0B0412123C3C3C3C3C1212121204041212123C
                12123C12123C12040B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B14
                235E1061161515151515151E6060606060606060606060606060601F123C1212
                3C121212123C126060123C1260123C1260123C1260601F123C12123C12123C3C
                3C3C12123C3C3C3C12123C12123C126060606060606060606060606060606060
                6060606060606034103B10614545451509090915451E1E1E1E1E1E1E1E1E1E1E
                1E1E1E123C122E123C3C3C3C3C3C121E1E2E122E1E123C121E2E122E1E1E123C
                12123C122E123C1212122E2E121212122E123C123C122E1E1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E74106B1061161616160C09090915161616
                1616161616161616161616131213161312121212121213161616161616131213
                1616161616161312131312131613121316161616161616161613121312131616
                16161616161616161616161616161616161616161616164D106B10610C0C0C0C
                0C4A4A4A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C20
                106B081009090909094A4A4A0909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090942103358102119191919190606191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919196410013F10101D29060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606064E6410701B2D5A08101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101070
                075C404018250810101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010235B1B2D2D}
              Color = clBtnFace
              PopupMenu = PopExit
              TabOrder = 3
              OnMouseDown = btnEditGameListMouseDown
              OnMouseMove = btnEditGameListMouseMove
              OnMouseUp = btnEditGameListMouseUp
            end
            object btNewAccount: TRzBmpButton
              Left = 341
              Top = 497
              Width = 104
              Height = 26
              Cursor = crHandPoint
              Bitmaps.Disabled.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100007700000000000000A1A1
                A0006B6B6D003D3E43002D2F3200E6FFFD007B8887004A4A4A000A052000747B
                7B00545A5A00B8C3C200FFFFFF0008012A008F9C9B0025272800141515002022
                2B00838E9C00515866003A3A31007C878600CEE1DF004C4D5100ADB3B3006871
                700015045B0095A6A5000908110064656A00110056002B245D001C1F1E008E96
                96003436390054545800D7EFED008E9BA90011034A00C4D5D30043444800636B
                7B00B0BFBE00A3ACAB0066666600040505001004430085868900828A89000C0E
                0E0014045F003A3A3A007D7E8200BEBEBE004E4E76000A0036002F323C001719
                1D00BFD0CE009DABBA00424242006C6D7200999999003C3C3F00515152007575
                7A00292A2E005A5A5A00DFF7F5005C5D8700190572009D9EA100B7CAD200D1E5
                E300616B6B001A0D53007B839C000F100F0096A4B3005E5F630002000A00A8A8
                AA00959699002022210033333300AEADAE00C5DBD900AEC2C000424A4A00BBCF
                D500737E8C00140557000F07390005021600100A2C00B4B4B400424A42001919
                1900848484008C8C8C00939393007B7B7C0073747400474F4E00292929000809
                0800A4A4A40013131C00404551005B5C5F00BDD6CE009EA7A6004D4F5300838D
                A400CCE1E300C3D8DC00B5C1C000D3E7E50016075E0000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002E2E5E393939
                3939393939393939393939393939393939393939393939393939393939393939
                3939393939393939393939393939393939393939393939393939393939393939
                3939393939393939393939393939393939393939393939393939393939393939
                5C5B37084D4D6142222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                222222222268104D4D370D6969203F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3361691C5D2D696161616161616161616161
                6161616161616161616161616161616161616161616161616161616161616161
                6161616161616161616161616161616161616161616161616161616161616161
                616161616161616161616161616161616161616161616161696950004D616142
                0304333C3C3C3C3C0F0F3F3F3F3C3C3C3C3C2253043C3C3C3C3C22223F3C3304
                0F20536868206161043C3C3C3C04202053333C33425361616161616161616161
                6161616161616161616161616161616161616161616161616161616161616161
                690050004D610F0707423F17171717171707071717171717173C6868223C3C3C
                3C3C3C223307425368223C073C330404033C3C3C3C073F223F3F3F3F3C3F2261
                6161616161616161616161616161616161616161616161616161616161616161
                6161616161616161690050501053222323540323232323232333224023232323
                28424254333C3C3C3C3C3354543C3342543C3C3C3C3C5422283C3C3354333C3C
                3C222204223F3C20202020202020202020202020202020202020202020202020
                20202020202020202020202020202020312D1C31613C4343432828436D6D6D6D
                6D2268280A2340403F042253223C223C3C3C3C3C3C3C3C22223C22223C3C3C22
                3C3C3C2253535353223C2253223C2253223C225353535353223C3C3C22535353
                53535353535353535353535353535353535353535353535310316B200F2C6D03
                404F28432C2C2C2C2C2C070723280303076868683C0C3C0C0C0C0C0C0C0C0C3C
                3C0C3C3C0C0C0C3C0C0C0C3C686868683C0C3C683C0C3C333C0C3C6868686868
                3C0C0C0C3C336868686868686868686868686868686868686868686868686868
                5320115454020A332828336D02020202020202024F0A70704F0404333C0C3C3C
                3C3C0C3C3C3C3C33333C0C3C3C0C3C0C3C3C0C3C040404043C0C3C043C0C0C3C
                0C3C330404040404333C3C3C0C3C040404040404040404040404040404040404
                0404040404040404040438673F1D1D43073F173D6666664F0266666666666666
                6622223C0C0C3C22223C0C3C22222222223C0C3C3C0C3C0C3C3C0C3C22223F3C
                3C0C3C3C3C0C3C3C0C3C222222223F3C3C3C3C3C0C3C22222222222222222222
                2222222222222222222222222222222228676C4A67671D653D3D656565666D28
                704F026666656565653F3F3F3C0C3C3C3C3C0C3C3C3C3C3F3F3C0C3C3C0C3C0C
                3C3C0C3C3F3F3C0C3C0C0C0C3C0C3C0C3C3C3F3F3F3F3C0C0C0C0C0C0C3C3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F0A4A130643230262
                626565654143072828074023231D6562022828283C0C3C3C0C0C0C0C0C0C3C3C
                3C3C0C3C3C0C3C0C3C3C0C3C3C3C3C0C3C0C3C0C3C0C3C0C3C3C3C3C3C3C3C0C
                3C3C3C3C3C3C3C3C282828282828282828282828282828282828282828282828
                1906291B0265632F3D4F4F4F0A1717171717171717171D631D17173C0C3C0C3C
                3C3C0C3C3C3C3C17283C0C3C3C0C3C0C3C3C0C3C3C173C0C3C0C3C0C0C0C0C0C
                0C0C3C3C0C0C0C0C0C0C0C0C0C0C0C3C17171717171717171717171717171717
                1717171717171717151B5A57096364666D1D3D3D432323232323232323433D62
                4F23233C0C3C0C3C233C0C3C232323233C0C0C0C0C0C0C0C0C0C0C0C3C233C0C
                3C0C3C0C3C0C3C3C3C3C07073C3C3C3C3C3C3C3C3C3C3C072323232323232323
                232323232323232323232323232323230E571256305252411D666352654F6D6D
                6D6D6D6D6D1D41024F4F4F173C3C3C3C3C3C0C3C3C3C3C17173C0C3C3C0C3C0C
                3C3C0C3C176D3C0C3C0C3C0C3C0C0C3C176D6D6D6D3C0C0C0C0C0C0C0C3C6D6D
                6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D2B5625242101013E
                62656401622C2C2C2C2C2C2C2C2C2C2C2C2C2C2C3C0C3C0C0C0C0C0C0C0C0C3C
                2C3C0C3C3C0C3C0C3C3C0C3C2C2C3C0C0C0C0C0C3C0C3C0C3C402C2C2C3C0C3C
                3C3C3C3C0C3C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2A244E054764015151476A6A343D3D3D3D3D3D3D3D3D3D3D3D3D3D233C0C3C3C
                3C3C0C3C3C0C3C233D3C0C3C3C0C3C0C3C3C0C3C3D3D233C3C0C3C3C3C0C3C3C
                0C3C3D3D3D3C0C3C3C3C3C3C0C3C3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D
                3D3D3D3D3D3D3D3D3A054E056F342F633E555555526541414141414141414141
                4141413C0C3C43413C0C3C43433C4341413C0C0C0C0C3C0C0C0C0C3C41414141
                3C0C3C413C0C3C433C434141413C0C0C0C0C0C0C0C3C41414141414141414141
                414141414141414141414141414141413A054E052B3434346252555F51623434
                3434343434343434343434433C433434433C43343434343434433C3C3C3C433C
                3C3C3C4334343434433C4334433C43343434343434433C3C3C3C3C3C3C433434
                3434343434343434343434343434343434343434343434343A054E05182F2F2F
                2F2F6A35472F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2705710574636363636347354763636363636363636363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363160536057552646464643E356A6464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464642B054426590549183E3E3E3E5535473E3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E0B4405711E1F73050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                3B76261A4B4C7205050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                05050505050548453246}
              Bitmaps.Down.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100008B000000010011008D9B
                AB00080473003E447B00162B450001014200CCFFFF000806750001003A000404
                69000302620008069C00E6FFFD00B2C6D4000000330055728600020253000908
                A40025405A00060593006E809500130E430000002900333872000F0054000B1F
                38005C5D870006047B009DABBA00CCE2E4000A088C00160FB600010021003348
                66001F29440003004A000202590046647A00060484000E1930000A0883000802
                63000F0BB1002B245D003C5A72007C839C001F3D5A00565F8E00122340005976
                8900ABBECD0005062B00C3D8DC000703500012304F0096A4B30006034B001A13
                C50006112400D6F0F0006B779D003550690019057200010019005C6E84001B0E
                5300464F75000E0A99001D21430009066D0015055F0007045A00274561008DA9
                B500838DA400273B53001D324C004A5C7300110DA7000F0A9600606B94001031
                4A000C00400016203A00718D9D0009077A0019375400E0F9F800A8C4CB0095A6
                BB0042556B003D466A000C0732002A4863000F088F000D0AA4001412BB00535C
                8B00D2EAEE001613BD00333D5D00B7CAD200C1DCDF007E90A400223350001605
                5B001915C5004D567F00192142000F233A00415B7200808EA000173553000B01
                370008006B000B0B56000506660012044B00120DB6000F0DA00047657B001200
                5900091329001C2E4A003A4B640038556E008C9DB20019294A002A3E59007180
                930010104A005F6E85004F4F77001F204700120CAA00BBCFD50029325100FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000525285783131
                3131313131313131313131313131313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                313131313131313131313131313131313131313131313131313131313131315A
                1518714425256E21808064646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                64646464643D25256E155C3D7D6816160E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E334B7D80535D4C2020161616160E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E161616162020125D302E273F3F0E
                35053835353535350E0E35353535353535350808080535353505050538383805
                0E0E0E0E0E16161608350505050516160E050505050E0E0E0E20202020202020
                2020202020202020202020202020202020202020202020202020202020203F3F
                042E30707A0020050516082323232323232323232323232323080E0E0E080823
                2308080808231616160E08080808161608080808080808080808080808080816
                16163F1616161616161616161616161616163F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F006D706D363A001605050E0E2323232323230E0E2323232323
                230E3F3F3F1608160808080808080808161608161608080816080808163F3F3F
                3F1608163F1608163F1608163F3F3F3F3F16080808163F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F0019366D363A1605052323082310101010
                100E2008232323230E1620202008060806060606060606060808060808060606
                080606060820202020080608200806080E0E0608202020202008060606080E20
                202020202020202020202020202020202020203F3F3F3F00193630567A05050E
                23240510242424242424050523230808080820200E0E06080808080608080808
                0E0E0E0608080608060808060820202020080608200806060806080E20202020
                200E080808060820202020202020202020202020202020202020202020203F3F
                6D567B482735350E050505477474747474747474473535354747161608060608
                16160806081616161616080608080608060808060816160E0E0E060808080608
                080608161616160E080808080806081616161616161616161616161616161616
                161616161616203F04484B2C53354747230835450202020A4502020202020202
                02100E0E0E0E0608080808060808080808080806080806080608080608080808
                06080606060806080608080E0E0E0E0E060606060606080E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E16204B2C7C0F220847070707282828552923
                1029020202020202022323230808060808060606060606080808080608080608
                0608080608080808060806080608060806080808080808080608080808080808
                080505050505050505050505050505050505050505050E167C0F4D5488057428
                2828282828291010101047474745282807232323080608060808080608080805
                2305050608080608060808060805230806080608060606060606060808060606
                0606060606060606082323232323232323232323232323232323232323230808
                4D548349644528282845454574242424242424242424074F0710101008060806
                0824080608242424240806060606060606060606060824080608060806080608
                0808082323080808080808080808080823242424242424242424242424242424
                2424242424380505404981585B555E550955282809090909090909090909284F
                0709090923080808080808060808080823230806080806080608080608230908
                0608060806080606082309090909080606060606060608090909090909090909
                0909090909090909090909090924380514586F6642284F281B1E774E1E070202
                0202020202261E28020202020208060806060606060606060802080608080608
                0608080608020208060606060608060806081002020208060808080808060802
                0202020202020202020202020202020202020202020A10236766013B6B5E7777
                4343861F77262626262626262626262626262626240806080808080608080608
                2426080608080608060808060826262408080608080806080806082626260806
                080808080806082626262626262626262626262626262626262626261B1B0A35
                7E3B370C61287776606060600B1313131313131313131313131313130806080A
                130806080A0A080A131308060606060806060606081313131308060813080608
                0A080A1313130806060606060606081313131313131313131313131313131313
                13131313261B0910590C370C61451E0B2A393939760B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0A080A0B0B0A080A0B0B0B0B0B0B0A080808080A080808080A0B0B0B
                0B0A080A0B0A080A0B0B0B0B0B0B0A080808080808080A0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B13260224590C370C61741B1E0B2A6A6A6A110B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B1326020A590C370C2F0A0726
                130B76392A0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B13260247
                590C4A0C3C24451B26265F395F13131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313261B0924320C840C0D730A090202261F4F1B1B1B1B1B1B1B1B1B1B1B
                1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B
                1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B
                1B1B1B1B1B1B1B1B1B1B1B1B1B0924170C5775870C320310100A0A285E090A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A1050620C4A792B340C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                1C467969412D1D0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C651A463E}
              Bitmaps.Hot.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B000000010000C70000000C07320096A4
                B3000504D900193754000C128C00030274004149BA00E6FFFD00557286001D14
                9C00071CBD000C0040000B19A0002C4AA0000905BC00FFFFFF00130EC3000B07
                9C00B6C9D1001223400042556B001E2AAC000705CC007182C200718093000E0A
                7B00170EBD0097A7F000203976001E12C6000906B00004026C00281EA7000E0E
                7D0010189600D6F0F0000D088B002F27AF0010235E000807D7005058D3002745
                6100616BEA003C5A7200100CE8000604DE00050359001D13A2009DABBA000A06
                A600212EAF000C0793000E08AD000605DE000F186B004F4F77002F369C003C4D
                8B00C1DCDF00141D9B000D08840011304E003439E4000806C500281AB6000800
                5200ABBEF5000E203D00100EE100808EA000597689001219700018109900C3D8
                DC002114CB00262D8E002110AD00142762005F70B0004D5E9D003A4B64002929
                B5008E9EE0002818BF00191095002B2BAE0046647A002F2FB3002F20B400130D
                AC00A8C4CB00595A850005036300B3C7F600130E4300100CD300284387000908
                E40010005C002A3B5500161E780002027A008091D2002B245D000A1FB9008D9B
                AB001D214300160950002634B6001A13E4001B1794002016D400545DE6002323
                A3001931690000003B001924A5001D12B200E0F9F800100BA5000F099B001230
                4F002719AF00CBE1E3002C1EB100211994003840AB000D138E002921BD000F0A
                C7000F0ABC000B08B6008DA9B500271AC600718D9D003F45E5005F6E85001810
                B3003550690047657B001A13DF002A486300415B72001F3D5A0034519600100B
                D2000D0ACF000D0AE7002331B30014006F002016BD002B21AD00121B9B001506
                5D004951C700BBCFD5006C77EC00110AB400D3EAFA001A12CD002318A4001204
                4B00161F3E0079819A002C3D7B00243E8E002A3E59001E2582002110DE005760
                E900173553000B0137000A17A200110B93000F00540020199C001B26A8002215
                B700130FED002416CE002417AC001B11D7001620A0001B11AE001C2E4A003855
                6E0026426A00555DDC00838DA4002318C2001424770015276300415F83001010
                4A001F2047001E306D004D5C7500375492000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000B0BC28B4646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464614
                5EAEAB6A5656C0900D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0DC58B8B8E5E008AB9A50A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A6860B9A6A28D1CACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACBA8D138FBE0404B6
                9474156C6C6C6C943B3B9494946C6C6C6C6C1522746C6C6C6C6C15B094943274
                3B7F22B6987F7F7F746C6C6C6C74227F22326C32B62204040404040404040404
                0404040404040404040404040404040404040404040404040404040404040404
                728F13AA47217F55556E71575757575757555757575757575721212121212121
                2121212121212121212121212121212121212121212121212121212121212121
                2121212121212121212121212121212121212121212121212121212121212121
                21212121212121214DAA437936216E25256EAF2525252525256E6E9725252525
                7119191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                191919191919191919191919191919192679433D36AF979797AFAF9725252525
                255421AF972020206E1919192E732E73737373737373732E2E732E2E7373732E
                7373732E191919192E732E192E732E192E732E19191919192E7373732E191919
                191919191919191919191919191919191919191919191919263D130347589754
                A07C0920585858585858AFAFA009545409191919730F730F0F0F0F0F0F0F0F73
                730F73730F0F0F730F0F0F7319191919730F7319730F732E730F731919191919
                730F0F0F732E1919191919191919191919191919191919191919191919191919
                BF03B8296458A0AD4848ADB458585858585858587AA02F2FB43C3C2E730F7373
                73730F737373732E2E730F73730F730F73730F733C3C3C3C730F733C730F0F73
                0F732E3C3C3C3C3C2E7373730F733C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C
                3C3C3C3C3C3C3C3CC329632BA77A7A4C48AD2F40404040B44080808080808080
                802424730F0F732424730F732424242424730F73730F730F73730F7324242E73
                730F7373730F73730F73242424242E73737373730F7324242424242424242424
                24242424242424242424242424242424A42B50084B787553B1B153535353B778
                77B7B1B1535353535333335C730F735C73730F7373735C3333730F73730F730F
                73730F733333730F730F0F0F730F730F735C33333333730F0F0F0F0F0F733333
                3333333333333333333333333333333333333333333333333908C48638771A85
                85BDBDBD96591111111177777789BD857511115C730F73730F0F0F0F0F0F7311
                11730F73730F730F73730F731111730F730F730F730F730F73735C5C7373730F
                737373737373735C111111111111111111111111111111111111111111111111
                4F8688847E1DB34A1A9D9D9D343131313131313131311AB39D3131730F730F73
                73730F7373735C315C730F73730F730F73730F735C31730F730F730F0F0F0F0F
                0F0F73730F0F0F0F0F0F0F0F0F0F0F7331313131313131313131313131313131
                31313131313131314E84185A066F6F10838210101E1E1E1E1E1E1E1E1E1E109F
                821E1E730F730F731E730F731E1E1E1E730F0F0F0F0F0F0F0F0F0F0F731E730F
                730F730F730F737373731F1F73737373737373737373731F1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E175A453A9AB5B5810E81B5B5810E0E0E
                0E0E0E0E0E0E81810E0E0E057373737373730F737373730505730F73730F730F
                73730F73050E730F730F730F730F0F73050E0E0E0E730F0F0F0F0F0F0F730E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E663A6923288C8C8C
                5F92B58C913F3F3F3F3F3F3F3F3F3F3F3F3F3F3F730F730F0F0F0F0F0F0F0F73
                3F730F73730F730F73730F733F3F730F0F0F0F0F730F730F73053F3F3F730F73
                737373730F733F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                52230107BB44446D6D6D6D6D92161616161616161616161616161605730F7373
                73730F73730F730516730F73730F730F73730F7316160573730F7373730F7373
                0F73161616730F73737373730F73161616161616161616161616161616161616
                16161616161616161B07010770272727446D6D6D442727272727272727272727
                272727730F736527730F73656573652727730F0F0F0F730F0F0F0F7327272727
                730F7327730F73657365272727730F0F0F0F0F0F0F7327272727272727272727
                272727272727272727272727272727271B070107700202020261B2B22C020202
                0202020202020202020202657365020265736502020202020265737373736573
                7373736502020202657365026573650202020202026573737373737373650202
                0202020202020202020202020202020202020202020202021B070107A92D2D2D
                2D2D93B2612D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                1B07BC079C2D2D2D2D2D61B2612D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D420737075D442D2D2D2D2DB2612D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D3E0776A19B0742872D2D2D2D612C352D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2A9E07BCAE6749070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                309962626BA37B07070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                070707070707125B6295}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A000000000000000000000001000000000000010021008893
                A5000000990019375400000058006B8599000000F0004F517200E2FCFA000000
                D7000000420001008D000000CC00C1DCDF000100830017184300E6FFFD002B3D
                8E0001003A00010072001A1C9A000000C4000000BC00A8C4CB003A3668000000
                E50001004A0000003300292258000000AD008999F8001B1ED200000066006E7B
                F10047657B00D6F0F00000005200A4B4BF000B1070005572860000002A000D0F
                F1002D3B5B0011304E00181A8B000C0046003C5A7200657D8E0000006B000E11
                5F0085A0B100B6D0DA001B1EAA0001007B0038556E003A528400100054002E36
                5A00112B4900CAE0E200CCFFFF0001009300506C8300494872000F0058001732
                4D002E33E0000C023A00DEF7EF000000B5008DA9B5001F3D5A00ABC2C9005976
                89000000DF007E95A300030628001B1EC5001E21F2002745610036445F000B0D
                52001524510015177C001E27490029428C00CAE3EB0018345200B1C3CB003048
                6E007178940095A2B4000E014A0021425A00BED4D8000000F6000200A300D7F0
                F70005083C00718D9D0094A5F8000E164B009FB9C600121A700012304F002A48
                630004063200CBE1E300060A2C0095ADB7001F314E0057738600DDF6F500080B
                460011146E00B5CEDE001B1EB8000E043B00364B63002E428B0021426300FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002D75506F4949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949492739
                5C40437622223711111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                11111111773722222A2D54365926131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313131313131313131313136736360F4769650A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A52696E474700001224
                0A1A24242424241B1B24242424242424241A1B1204242424241A1A1A1A1A1A1B
                282812122828280A242424240A2828281A041A12120000000000000000000000
                000000000000000000000000000000000000000000000000000000000000006C
                47575757001B24241B1A0404040404040404040404040404041B1B1B0A0A0404
                040A1B12241B00001B1212040A0028121A040A0A0A1A120A0A0A0A0A0A1B1B1B
                1B00000028282828282828282828282828000000000000000000000000000000
                000000000000004C57416868280A0404121A0404040404040A0A040404040404
                1B1B1B1B0A0A0A041A121B1B0A0A001B0A0A0A0A0A1B1B0A0A0A1212121A1A12
                121B1B1B1212121B1B1B00282828282828282828282828282828000000000000
                0000000000000000000000000000004C683A2B2B1A040404041A042020202020
                0A1B1A040404040A281B28281B1B1B12121212121212121B1B1B1B1B1212121B
                1212121B282828281B1B1B281B1B1B281B1B1B28282828281B1212121B282828
                2828282828282828282828282828282828282828282828282B3A030330301A04
                202420303030303030242424241A1A1A1A1A2828123C123C3C3C3C3C3C3C3C12
                123C12123C3C3C123C3C3C1228282828123C1212123C1212123C122828282828
                123C3C3C1212282828282828282828282828282828282828282828282828286A
                03414F4F35200A24241A203535353535353535303004043013131212123C1212
                12123C121212121212123C12123C123C12123C1212121212123C1212123C3C12
                3C12121212121212121212123C12121212121212121212121212121212121212
                12121212121212624F5D2E36131320041A04353535353035350E0E0E0E0E0E0E
                0E130A0A3C3C121212123C120A0A0A0A0A0A3C12123C123C12123C1212121212
                123C1212123C12123C120A0A0A0A1212121212123C120A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A712E76273E04130B35350B0B0B0E300404
                3035350E0B0B0B0B0E041A0A0A3C120A0A0A3C1212120A1A1A123C12123C123C
                12123C121A1A123C123C3C3C123C123C120A1A1A1A1A123C3C3C3C3C3C121A1A
                1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A5127226305200E3D3D
                0B0B0B0B3004040404202020350B0B0E200A041A123C12123C3C3C3C3C3C1204
                04123C12123C123C12123C120404123C123C123C123C123C12121A1A1212123C
                121212121212121A040404040404040404040404040404040404040404040431
                632F46323D60600E353535132020202020202020200E600E201A20123C123C12
                12123C1212121A201A123C12123C123C12123C121A20123C123C123C3C3C3C3C
                3C3C12123C3C3C3C3C3C3C3C3C3C3C1220202020202020202020202020202020
                2020202020202072464B486660600B350E0B0B131313131313131313130B600E
                131313123C123C1213123C1213131313123C3C3C3C3C3C3C3C3C3C3C1213123C
                123C123C123C1212121224241212121212121212121212241313131313131313
                13131313131313131313131313131353176D0D331D45020B0B1D1D020E0E0E0E
                0E0E0E0E0B0B0B0E0E0E0E041212121212123C121212120404123C12123C123C
                12123C12040E123C123C123C123C3C12040E0E0E0E123C3C3C3C3C3C3C120E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E2C0D4823561616161D
                6045451D3D0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B123C123C3C3C3C3C3C3C3C12
                0B123C12123C123C12123C120B0B123C3C3C3C3C123C123C12040B0B0B123C12
                121212123C120B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B14
                235E1061161515151515151D60606060606060606060606060606020123C1212
                12123C12123C122060123C12123C123C12123C1260602012123C1212123C1212
                3C12606060123C12121212123C12606060606060606060606060606060606060
                6060606060606034103B10614545451509090915451D1D1D1D1D1D1D1D1D1D1D
                1D1D1D123C12301D123C12303012301D1D123C3C3C3C123C3C3C3C121D1D1D1D
                123C121D123C123012301D1D1D123C3C3C3C3C3C3C121D1D1D1D1D1D1D1D1D1D
                1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D74106B1061161616160C09090915161616
                1616161616161616161616131213161613121316161616161613121212121312
                1212121316161616131213161312131616161616161312121212121212131616
                16161616161616161616161616161616161616161616164D106B10610C0C0C0C
                0C4A4A4A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C1F
                106B081009090909094A4A4A0909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090942103358102119191919190606191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919196410013F10101E29060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606064E6410701C2D5A08101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101070
                075C404018250810101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010235B1C2D2D}
              Color = clBtnFace
              PopupMenu = PopRegister
              TabOrder = 4
              OnMouseDown = btNewAccountMouseDown
              OnMouseMove = btNewAccountMouseMove
              OnMouseUp = btNewAccountMouseUp
            end
            object btnGetBackPassword: TRzBmpButton
              Left = 565
              Top = 497
              Width = 104
              Height = 26
              Cursor = crHandPoint
              Bitmaps.Disabled.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100007700000000000000A1A1
                A0006B6B6D003D3E43002D2F3200E6FFFD007B8887004A4A4A000A052000747B
                7B00545A5A00B8C3C200FFFFFF0008012A008F9C9B000A00360014151500838E
                9C00515866003A3A3100CEE1DF007C8786004C4D5100ADB3B300687170001A0D
                530095A6A500252728000908110064656A0011034A001C1F1E0020222B008E96
                960054545800D7EFED008E9BA9002B245D0034363900C4D5D30043444800636B
                7B00B0BFBE00A3ACAB0004050500666666008586890019057200828A89000C0E
                0E003C3C3F007D7E820014055700BEBEBE004E4E76002F323C0017191D00BFD0
                CE009DABBA00424242006C6D7200999999003A3A3A005151520075757A00292A
                2E005A5A5A000F073900DFF7F5005C5D87009D9EA10015045B00B7CAD200D1E5
                E300616B6B007B839C000F100F0096A4B3005E5F630002000A00A8A8AA009596
                99002022210033333300AEADAE00C5DBD900AEC2C000424A4A00BBCFD500737E
                8C000502160010044300100A2C00B4B4B40014045F00424A4200191919008484
                84008C8C8C00939393007B7B7C00474F4E00737474002929290008090800A4A4
                A40013131C00404551005B5C5F00BDD6CE009EA7A6004D4F530011005600838D
                A400CCE1E300C3D8DC00B5C1C00016075E00D3E7E50000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000005B5B5C383838
                3838383838383838383838383838383838383838383838383838383838383838
                3838383838383838383838383838383838383838383838383838383838383838
                3838383838383838383838383838383838383838383838383838383838383838
                43340F084C4C6041262626262626262626262626262626262626262626262626
                2626262626262626262626262626262626262626262626262626262626262626
                2626262626262626262626262626262626262626262626262626262626262626
                262626262667104C4C0F0D68681F323232323232323232323232323232323232
                3232323232323232323232323232323232323232323232323232323232323232
                3232323232323232323232323232323232323232323232323232323232323232
                32323232323232323232323232323E60681C5A2C686060606060606060606060
                6060606060606060606060606060606060606060606060606060606060606060
                6060606060606060606060606060606060606060606060606060606060606060
                60606060606060606060606060606060606060606060606068684F004C606041
                03043E3B3B3B3B3B1B1B3232323B3B3B3B3B2652043B3B3B3B3B2626323B3E04
                1B1F5267671F6060043B3B3B3B041F1F523E3B3E415260606060606060606060
                6060606060606060606060606060606060606060606060606060606060606060
                68004F004C601B0707413216161616161607071616161616163B6767263B3B3B
                3B3B3B263E07415267263B073B3E0404033B3B3B3B073226323232323B322660
                6060606060606060606060606060606060606060606060606060606060606060
                606060606060606068004F4F105226222253032222222222223E263F22222222
                284141533E3B3B3B3B3B3E53533B3E41533B3B3B3B3B5326283B3B3E533E3B3B
                3B26260426323B1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F312C1C31603B4242422828426C6C6C6C
                6C2667280A223F3F320426263B3B3B263B265252263B3B2652263B2652525252
                5252263B26525252263B3B3B3B3B3B3B3B265252525252525252263B3B3B2652
                52525252525252525252525252525252525252525252525210316A1F1B2D6C03
                3F4E28422D2D2D2D2D2D0707222803030767673B0C0C0C3B0C3B3E3E3B0C0C3B
                673B0C3B3B3B3B3B3B3B3B0C3B6767673B0C0C0C0C0C0C0C0C3B67673E3B3E3B
                3E673B0C0C0C3B3E676767676767676767676767676767676767676767676767
                521F205353020A3E28283E6C02020202020202024E0A6F6F4E04043E3B3B0C3B
                3B0C3B3B0C3B0C3B043B0C0C0C0C0C0C0C0C0C0C3B0404043B0C3B3B0C3B3B3B
                0C3B04043B0C3B0C3B043E3B3B3B0C3B04040404040404040404040404040404
                040404040404040404043765321D1D420732163C6666664E0266666666666666
                66262626263B0C3B323B0C0C3B3B0C3B263B0C3B3B3B3B3B3B3B3B0C3B262626
                3B0C3B3B0C3B263B0C3B26263B0C0C0C3B3B3B3B3B3B0C3B2626262626262626
                2626262626262626262626262626262628656B4A65651D643C3C646464666C28
                6F4E0266666464646432323B3B3B0C3B32323B0C3B3B3B3B323B0C3B0C3B3B3B
                0C3B3B0C3B323B3B3B3B3B3B3B3B3B3B3B3B32323B0C3B0C0C0C0C0C0C3B0C3B
                3232323232323232323232323232323232323232323232320A4A120642220261
                616464644042072828073F22221D64610228283B0C0C0C3B3B3B0C3B0C3B3B3B
                3B3B0C3B0C0C0C0C0C3B3B0C3B3B3B0C0C0C3B0C0C0C0C3B3B3B3B3B3B0C3B0C
                3B3B3B3B3B3B0C3B282828282828282828282828282828282828282828282828
                1806291A0264622E3C4E4E4E0A1616161616161616161D621D1616283B3B0C0C
                0C3B0C3B3B0C3B16163B0C3B0C3B3B3B0C3B3B0C3B16283B3B3B0C0C3B3B0C3B
                3B0C3B3B0C0C3B0C3B0C0C0C0C0C0C3B16161616161616161616161616161616
                1616161616161616151A5956096263666C1D3C3C422222222222222222423C61
                4E222222223B0C3B3B3B0C3B3B3B3B07223B0C3B0C3B3B3B0C3B3B0C3B22223B
                0C3B0C3B0C3B0C3B0C3B07073B0C0C0C3B3B0C3B3B0C3B072222222222222222
                222222222222222222222222222222220E561155305151401D666251644E6C6C
                6C6C6C6C6C1D40024E4E4E163B3B0C3B3B0C0C0C0C0C0C3B6C3B0C3B0C0C0C0C
                0C3B3B0C3B6C163B3B0C0C3B3B0C3B163B3B166C3B0C3B3B163B0C3B3B0C3B6C
                6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C2B5524232101013D
                61646301612D2D2D2D2D2D2D2D2D2D2D2D2D2D3B0C0C0C0C0C3B0C3B3B3B3B3F
                2D3B0C3B3B3B3B3B3B3F3B0C3B2D3B0C0C3B3B3B0C3B0C3B3B0C3B2D3B0C3B2D
                2D3B0C3B3B0C3B2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D
                2A234D054663015050466969333C3C3C3C3C3C3C3C3C3C3C3C3C3C223B3B0C3B
                3B3B0C3B3B0C3B3C3C3B0C3B3B3B3B3B3B3B3B0C3B3C223B0C0C0C0C0C0C0C0C
                0C0C3B223B0C3B3B223B3B3B3B0C3B3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C
                3C3C3C3C3C3C3C3C39054D056E332E623D545454516440404040404040404040
                40404040403B0C3B403B0C3B0C3B4240403B0C0C0C0C0C0C0C0C0C0C3B404042
                3B3B3B3B0C3B3B3B3B3B423B0C0C0C0C3B0C0C0C0C0C3B404040404040404040
                4040404040404040404040404040404039054D052B3333336151545D50613333
                33333333333333333333333333423B4233423B423B42333333423B3B3B3B3B3B
                3B3B3B3B42333333333333423B423333333333423B3B3B3B423B3B3B3B3B4233
                33333333333333333333333333333333333333333333333339054D05172E2E2E
                2E2E6935462E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E
                2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E
                2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E
                2705710574626262626246354662626262626262626262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262140536057651636363633D35696363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363636363636363632B05441E580549173D3D3D3D5435463D3D
                3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D
                3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D
                3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D3D0B440571702573050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                3A751E47194B7205050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                0505050505050505050505050505050505050505050505050505050505050505
                05050505050548455E2F}
              Bitmaps.Down.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100008B000000010011008D9B
                AB00080473003E447B00162B450001014200CCFFFF000806750001003A000302
                620008069C00E6FFFD00B2C6D4000000330055728600020253000908A4002540
                5A00060593006E809500130E430000002900333872000F0054000B1F38005C5D
                87009DABBA000802630006047B00CCE2E4000A088C00160FB600010021003348
                66001F29440003004A000202590046647A000E193000060484000A0883000704
                6B000F0BB1002B245D003C5A72007C839C001F3D5A00565F8E00122340005976
                8900ABBECD0007035000C3D8DC0005062B0012304F0096A4B30006034B001A13
                C50006112400D6F0F0006B779D003550690019057200010019005C6E84001B0E
                5300464F75000E0A99001D21430015055F0007045A00274561008DA9B5000906
                6D00838DA400273B53001D324C004A5C7300110DA7000F0A9600606B94001031
                4A000C00400016203A00718D9D0009077A0019375400E0F9F800A8C4CB0095A6
                BB0042556B003D466A000C0732002A4863000F088F000D0AA4001412BB00535C
                8B00D2EAEE001613BD00333D5D00B7CAD200C1DCDF007E90A400223350001605
                5B001915C5004D567F00192142000F233A00415B7200808EA000173553000B01
                370000006B000B0B56000506660012044B00120DB6000F0DA00047657B001200
                5900091329001C2E4A003A4B640038556E008C9DB20019294A002A3E59007180
                930010104A005F6E85004F4F77001F204700120CAA00BBCFD50029325100FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000525285783131
                3131313131313131313131313131313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                313131313131313131313131313131313131313131313131313131313131315A
                1417714425256E21808064646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                64646464643D25256E145C3D7D6815150D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D354B7D80535D4C2020151515150D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D151515152020115D302E263F3F0D
                33053833333333330D0D33333333333333330808080533333305050538383805
                0D0D0D0D0D15151508330505050515150D050505050D0D0D0D20202020202020
                2020202020202020202020202020202020202020202020202020202020203F3F
                042E30707A0020050515082323232323232323232323232323080D0D0D080823
                2308080808231515150D08080808151508080808080808080808080808080815
                15153F1515151515151515151515151515153F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F006D706D363A001505050D0D2323232323230D0D2323232323
                230D3F3F150808081508153F3F150808153F1508153F3F3F3F3F3F1508153F3F
                3F150808080808080808153F3F3F3F3F3F3F3F15080808153F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F0018366D363A150505232308230F0F0F0F
                0F0D2008232323230D152020080606060806080D0D0D06060820080608080808
                0808080806082020200806060606060606060820200D0D0D0D0D200806060608
                0D2020202020202020202020202020202020203F3F3F3F00183630567A05050D
                2324050F242424242424050523230808080820200D0D0D060808060808060806
                0820080606060606060606060608202020080608080608080806082020080608
                0608200D08080806082020202020202020202020202020202020202020203F3F
                6D567B472633330D050505467474747474747474463333334646151515150806
                0808080606080806081508060808080808080808060815151508060808060815
                0806081515080606060808080808080608151515151515151515151515151515
                151515151515203F04474B2C5333464623083329020202092902020202020202
                020F0D0D08080806080808080608080808080806080608080806080806080808
                080808080808080808080808080806080606060606060806080D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D15204B2C7C0E220846070707282828551B23
                0F1B020202020202022323230806060608080806080608080808080608060606
                0606080806080808060606080606060608080808080806080608080808080806
                080505050505050505050505050505050505050505050D157C0E4D5488057428
                28282828281B0F0F0F0F46464649282807232323050505060606080608080608
                2323080608060808080608080608230508080806060808060808060808060608
                0608060606060606082323232323232323232323232323232323232323230808
                4D548348644928282849494974242424242424242424074F070F242424240806
                0808080608080808232408060806080808060808060824240806080608060806
                0806082323080606060808060808060823242424242424242424242424242424
                2424242424380505404881585B555E552955282829747474747474747474284F
                0774747423080806080806060606060608740806080606060606080806087423
                0808060608080608230808237408060808230806080806087474747474747474
                7474747474747474747474747424380513586F6642284F281C1E774E1E070202
                0202020202271E28020202020806060606060806080808080F02080608080808
                08080F0806080208060608080806080608080608020806080202080608080608
                020202020202020202020202020202020202020202090F236766013B6B5E7777
                4343861F77272727272727272727272727272727240808060808080608080608
                2727080608080808080808080608272408060606060606060606060824080608
                082408080808060827272727272727272727272727272727272727271C1C0933
                7E3B370B61287776606060600A12121212121212121212121212121212120806
                0812080608060809121208060606060606060606060812120908080808060808
                0808080908060606060806060606060812121212121212121212121212121212
                12121212271C290F590B370B61291E0A2A393939760A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0908090A09080908090A0A0A0908080808080808080808090A0A
                0A0A0A0A0908090A0A0A0A0A0908080808090808080808090A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A12270224590B370B61741C1E0A2A6A6A6A100A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A12270209590B370B2F090727
                120A76392A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A12270246
                590B4A0B3C24291C27275F395F12121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                12121212271C2924320B840B0C730929291C1C1F4F1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C1C
                1C1C1C1C1C1C1C1C1C1C1C1C1C7424160B5775870B32030F0F0909285E740909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090F50620B4A792B340B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                1A457969412D1D0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B6519453E}
              Bitmaps.Hot.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B000000010000C70000000C07320096A4
                B3000504D900193754000C128C00030274004149BA00E6FFFD00557286001D14
                9C00071CBD000C0040000B19A0002C4AA0000905BC00FFFFFF00130EC3000B07
                9C00B6C9D1001223400042556B001E2AAC000705CC007182C200718093000E0A
                7B00170EBD0097A7F000203976001E12C6000906B00004026C00281EA7001018
                96000E0E7D00D6F0F0002F27AF000D088B0010235E000807D7005058D3002745
                61003C5A7200100CE8000604DE00050359001D13A2009DABBA000A06A600212E
                AF000F186B008091D2000E08AD000C0793004F4F77000605DE002F369C003C4D
                8B00C1DCDF00141D9B0011304E003439E4000806C5000D088400281AB600ABBE
                F500080052000E203D00100EE100808EA000597689001219700018109900C3D8
                DC002114CB00262D8E002110AD00142762005F70B0004D5E9D003A4B64002929
                B5006C77EC002818BF00191095002B2BAE0046647A002F2FB3005760E9000503
                63002F20B400130DAC00A8C4CB00595A8500B3C7F600130E4300100CD3002843
                87000908E40010005C0002027A002A3B5500161E78002B245D000A1FB9008D9B
                AB001D214300160950002634B6001A13E4001B1794002016D4002323A3001931
                690000003B001924A5001D12B200E0F9F800100BA5000F099B0012304F002719
                AF00CBE1E3002C1EB100211994003840AB000D138E002921BD000F0AC7000F0A
                BC000B08B6008DA9B500271AC600718D9D003F45E5005F6E85001810B3003550
                690047657B001A13DF002A486300415B72001F3D5A00545DE60034519600100B
                D2000D0ACF000D0AE70014006F002331B3002016BD002B21AD00121B9B001506
                5D004951C700BBCFD5008E9EE000110AB400D3EAFA001A12CD002318A4001204
                4B00161F3E0079819A002C3D7B00616BEA00243E8E002A3E59001E2582002110
                DE00173553000B0137000A17A200110B93000F00540020199C001B26A8002215
                B700130FED002416CE002417AC001B11D7001620A0001B11AE001C2E4A003855
                6E0026426A00555DDC00838DA4002318C2001424770015276300415F83001010
                4A001F2047001E306D004D5C7500375492000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000B0BC28A4646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464614
                5FAEAB6A5656C0900D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0DC58A8A8D5F0089B9A60A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A6861B9A7A28C1CACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACBA8C138EBE0404B6
                9573156C6C6C6C953B3B9595956C6C6C6C6C1521736C6C6C6C6C15B095953173
                3B7E21B6987E7E7E736C6C6C6C73217E21316C31B62104040404040404040404
                0404040404040404040404040404040404040404040404040404040404040404
                718E13AA47227E55556E70575757575757555757575757575722222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                22222222222222224DAA437832226E24246EAF2424242424246E6E9724242424
                7019191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                191919191919191919191919191919192678433C32AF979797AFAF9724242424
                245422AF972020206E19192D7272722D722D19192D72722D192D722D19191919
                19192D722D1919192D72727272727272722D19191919191919192D7272722D19
                191919191919191919191919191919191919191919191919263C1303475A9754
                A07B09205A5A5A5A5A5AAFAFA0095454091919720F0F0F720F722D2D720F0F72
                19720F72727272727272720F72191919720F0F0F0F0F0F0F0F7219192D722D72
                2D19720F0F0F722D191919191919191919191919191919191919191919191919
                BF03B829665AA0AD4848ADB45A5A5A5A5A5A5A5A79A02E2EB43F3F2D72720F72
                720F72720F720F723F720F0F0F0F0F0F0F0F0F0F723F3F3F720F72720F727272
                0F723F3F720F720F723F2D7272720F723F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3FC329652AA879794C48AD2E40404040B4407F7F7F7F7F7F7F
                7F25252525720F722D720F0F72720F7225720F72727272727272720F72252525
                720F72720F7225720F722525720F0F0F7272727272720F722525252525252525
                25252525252525252525252525252525A42A50084B777453B1B153535353B777
                76B7B1B1535353535335355972720F723559720F7259725935720F720F727272
                0F72720F72355972727259727272725972593535720F720F0F0F0F0F0F720F72
                3535353535353535353535353535353535353535353535353908C48538761A84
                84BDBDBD965B1111111176767688BD84741111720F0F0F7272720F720F725911
                11720F720F0F0F0F0F72720F7211720F0F0F720F0F0F0F7259725959720F720F
                7272727272720F72111111111111111111111111111111111111111111111111
                4F8587837D1DB34A1A9D9D9D343030303030303030301AB39D30305972720F0F
                0F720F72720F723030720F720F7272720F72720F7230597272720F0F72720F72
                720F72720F0F720F720F0F0F0F0F0F7230303030303030303030303030303030
                30303030303030304E83185C066F6F10828110101E1E1E1E1E1E1E1E1E1E109F
                811E1E1E1E720F7272720F727272721F1E720F720F7272720F72720F721E1E72
                0F720F720F720F720F721F1F720F0F0F72720F72720F721F1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E175C453A9AB5B5800E80B5B5800E0E0E
                0E0E0E0E0E0E80800E0E0E0572720F72720F0F0F0F0F0F720E720F720F0F0F0F
                0F72720F720E0572720F0F72720F72057272050E720F727205720F72720F720E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E333A6923288B8B8B
                6092B58B913E3E3E3E3E3E3E3E3E3E3E3E3E3E720F0F0F0F0F720F7272727205
                3E720F72727272727205720F723E720F0F7272720F720F72720F723E720F723E
                3E720F72720F723E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                9C230107BB44446D6D6D6D6D9216161616161616161616161616160572720F72
                72720F72720F721616720F72727272727272720F721605720F0F0F0F0F0F0F0F
                0F0F7205720F727205727272720F721616161616161616161616161616161616
                16161616161616161B0701078F272727446D6D6D442727272727272727272727
                2727272727720F7227720F720F72642727720F0F0F0F0F0F0F0F0F0F72272764
                727272720F727272727264720F0F0F0F720F0F0F0F0F72272727272727272727
                272727272727272727272727272727271B0701078F0202020262B2B22B020202
                0202020202020202020202020264726402647264726402020264727272727272
                7272727264020202020202647264020202020264727272726472727272726402
                0202020202020202020202020202020202020202020202021B070107582C2C2C
                2C2C93B2622C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                1B07BC07522C2C2C2C2C62B2622C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C410736075E442C2C2C2C2CB2622C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C3D0775A19B0741862C2C2C2C622B372C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2CA59E07BCAE6749070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                2F9963636BA37A07070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                070707070707125D6394}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A000000000000000000000001000000000000010021008893
                A5000000990019375400000058006B8599000000F0004F517200E2FCFA000000
                D7000000420001008D000000CC00C1DCDF0001008300E6FFFD00171843002B3D
                8E0001003A00010072001A1C9A000000C4000000BC00A8C4CB003A3668000000
                E50001004A0000003300292258008999F8000000AD001B1ED200000066006E7B
                F10047657B00D6F0F00000005200A4B4BF000B1070005572860000002A000D0F
                F1002D3B5B0011304E00181A8B000E014A003C5A7200657D8E0000006B000E11
                5F0085A0B100B6D0DA001B1EAA0001007B0038556E003A528400100054002E36
                5A00112B4900CAE0E200CCFFFF0001009300506C8300494872000F0058001732
                4D002E33E0000C023A00DEF7EF000000B5008DA9B5001F3D5A00ABC2C9005976
                89000000DF00030628007E95A3001B1EC5001E21F2002745610036445F000B0D
                52001524510015177C001E27490029428C0008004A00CAE3EB0018345200B1C3
                CB0030486E007178940095A2B40021425A00BED4D8000000F6000200A300D7F0
                F70005083C00718D9D0094A5F8000E164B009FB9C600121A700012304F002A48
                630004063200CBE1E300060A2C0095ADB7001F314E0057738600DDF6F5001114
                6E00B5CEDE001B1EB8000E043B00364B63002E428B00080B460021426300FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002D74506F4949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949492739
                2D40437522223711111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                11111111763722222A2D54365A26131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313673636104769650A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A52696E474700001224
                0A1A24242424241B1B24242424242424241A1B1204242424241A1A1A1A1A1A1B
                282812122828280A242424240A2828281A041A12120000000000000000000000
                000000000000000000000000000000000000000000000000000000000000006C
                47585858001B24241B1A0404040404040404040404040404041B1B1B0A0A0404
                040A1B12241B00001B1212040A0028121A040A0A0A1A120A0A0A0A0A0A1B1B1B
                1B00000028282828282828282828282828000000000000000000000000000000
                000000000000004B58416868280A0404121A0404040404040A0A040404040404
                1B1B1B1B0A0A0A041A121B1B0A0A001B0A0A0A0A0A1B1B0A0A0A1212121A1A12
                121B1B1B1212121B1B1B00282828282828282828282828282828000000000000
                0000000000000000000000000000004B683A2B2B1A040404041A042020202020
                0A1B1A040404040A281B281B1212121B1B1B28281B1B1B1B281B1B1B28282828
                28281B1B1B2828281B12121212121212121B28282828282828281B1212121B28
                2828282828282828282828282828282828282828282828282B3A030330301A04
                202420303030303030242424241A1A1A1A1A28123C3C3C123C121212123C3C12
                12123C12121212121212123C12282828123C3C3C3C3C3C3C3C12121212121212
                1212123C3C3C121228282828282828282828282828282828282828282828286A
                03414F4F35200A24241A20353535353535353530300404301313121212123C12
                123C12123C123C1212123C3C3C3C3C3C3C3C3C3C12121212123C12123C121212
                3C121212123C123C1212121212123C1212121212121212121212121212121212
                12121212121212624F5D2E36131320041A04353535353035350E0E0E0E0E0E0E
                0E130A0A0A0A3C1212123C3C12123C1212123C12121212121212123C120A0A0A
                0A3C12123C1212123C121212123C3C3C1212121212123C120A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A772E75273E04130B35350B0B0B0E300404
                3035350E0B0B0B0B0E041A0A0A0A3C121A0A0A3C120A0A0A1A123C123C121212
                3C12123C121A0A1212120A121212120A0A0A1A1A123C123C3C3C3C3C3C123C12
                1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A5127226305200E3D3D
                0B0B0B0B3004040404202020350B0B0E200A04123C3C3C1212123C123C121A04
                04123C123C3C3C3C3C12123C1204123C3C3C123C3C3C3C121A121A1A123C123C
                1212121212123C12040404040404040404040404040404040404040404040431
                632F46323D60600E353535132020202020202020200E600E201A201A12123C3C
                3C123C12123C122020123C123C1212123C12123C12201A1212123C3C12123C12
                123C12123C3C123C123C3C3C3C3C3C1220202020202020202020202020202020
                2020202020202071464C486660600B350E0B0B131313131313131313130B600E
                1313131313123C1212123C121212122413123C123C1212123C12123C12131312
                3C123C123C123C123C122424123C3C3C12123C12123C12241313131313131313
                13131313131313131313131313131353176D0D331E45020B0B1E1E020E0E0E0E
                0E0E0E0E0B0B0B0E0E0E0E0412123C12123C3C3C3C3C3C120E123C123C3C3C3C
                3C12123C120E0412123C3C12123C12041212040E123C121204123C12123C120E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E2C0D4823571616161E
                6045451E3D0B0B0B0B0B0B0B0B0B0B0B0B0B0B123C3C3C3C3C123C1212121204
                0B123C12121212121204123C120B123C3C1212123C123C12123C120B123C120B
                0B123C12123C120B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B14
                235E0F61161515151515151E6060606060606060606060606060602012123C12
                12123C12123C126060123C12121212121212123C126020123C3C3C3C3C3C3C3C
                3C3C1220123C121220121212123C126060606060606060606060606060606060
                60606060606060340F3B0F614545451509090915451E1E1E1E1E1E1E1E1E1E1E
                1E1E1E1E1E123C121E123C123C12301E1E123C3C3C3C3C3C3C3C3C3C121E1E30
                121212123C121212121230123C3C3C3C123C3C3C3C3C121E1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E730F6B0F61161616160C09090915161616
                1616161616161616161616161613121316131213121316161613121212121212
                1212121213161616161616131213161616161613121212121312121212121316
                16161616161616161616161616161616161616161616164D0F6B0F610C0C0C0C
                0C4A4A4A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C1F
                0F6B080F09090909094A4A4A0909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                09090909090909420F33590F2119191919190606191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                191919191919191919191919191919640F013F0F0F1D29060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606064E640F701C2D5B080F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F70
                072D40401825080F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                0F0F0F0F0F235C1C2D2D}
              Color = clBtnFace
              PopupMenu = PopFindPass
              TabOrder = 5
              OnMouseDown = btnGetBackPasswordMouseDown
              OnMouseMove = btnGetBackPasswordMouseMove
              OnMouseUp = btnGetBackPasswordMouseUp
            end
            object btnMinSize: TRzBmpButton
              Left = 765
              Top = 90
              Width = 16
              Height = 16
              Cursor = crHandPoint
              Bitmaps.Down.Data = {
                92020000424D9202000000000000920100002800000010000000100000000100
                08000000000000010000120B0000120B000057000000570000007BCBE7006BC7
                E7004ABADE004AB2E70000AEFF0000AAF7004AAADE0042A2D60000A2EF00429E
                CE00009AE7004296CE000096CE00008ED600428ABD00398ABD00218ABD00318A
                B5003986B5003186B5000082C6003182AD00217DB5003979AD00007DAD001879
                AD003975AD000075BD003175A5002175A5001871A500186DA500316D9C00296D
                9C00216D9C00186D9C000069AD0029699C002169940029659C00216194001061
                9400005D9C00295D8C00185D8C00105D8C0029598C0018598C0008598C002955
                8C002955840008558C0010518400214D840000557300004D8400084D7B002149
                7B0018497B000849840018497300104973002145730018457300084573002141
                73001841730010416B0008416B00103C6B000041520000386300083863001834
                6B00183463000034630000384A0008305A0000344200002C5A00002C52000028
                520000244A00001C420042100000390400000000000054241B140D0A08050405
                080A0D141B542A4B535250504F4F4F4F5050525337242A535047444040404040
                40444B5053242A5148383029292929292930384851242A4D3D2D1E1919191919
                191F2D3D4D242A4834231610101010101016233448242A452F221D1D1D1D1D1D
                1D1D222F45242A432C260C02010101010000262C43242A3F28214E4C46464646
                361821283F242A3C2515131111111111111115253C242A3A250F070303030303
                03070F253A242A3927120906060606060609122739242A422E1C0E0B0B0B0B0B
                0B0E1C2E42242A4A392B201A1A1A1A1A1A202B394A242A3B4941353231313131
                32353E49332455241B140D0A08050405080A0D141B55}
              Bitmaps.Hot.Data = {
                A6020000424DA602000000000000A60100002800000010000000100000000100
                08000000000000010000120B0000120B00005C0000005C000000B5DFF700BDDF
                F700ADDBF700ADDBEF00A5D7F7009CD7F700ADD7EF0094D3F7008CD3F7009CD3
                EF00ADD3E70084CFF700A5CFE70094CFEF0063CBFF008CCBEF0094CBE7007BCB
                EF007BCBE7005AC7FF0073C7F70063C7FF007BC7EF0094C7E7006BC7F7008CC7
                E70073C7EF0063C7F70094C7DE006BC7E70063C3F7005AC3F7006BBEEF005ABE
                F70073BEE70063BEEF0084BEDE005ABAEF007BBADE005AB6E7004ABADE0073B6
                DE007BB6D6005AB2DE0073B2D60000AEFF006BAECE0000AAF70052AAD6005AAA
                D60063AACE0000A2EF0052A2CE004A9ECE00429ECE00009AE700429AC6002996
                CE000096CE003192C6003192BD00008ED600318EBD00298ABD00318AB5002986
                B5000082C6001882B5002182B500187DAD00007DAD000079B5000075BD000875
                A5001071AD000871AD000071AD00086DAD00006DAD00086DA500006DA5000069
                AD000865A50008619C0000619C00005D9C00005573000041520000384A000034
                420039040000000000005A5142423D37332F2D2F33373D42485A55504F4F4F4F
                4F4F4F4F4F4F4F4F4C5155494949494949494949494949494951554543444140
                3E3E3E3E404144434551543F3C3834322E2C2C2E3234383C3F4E533B35322A24
                1C1C1C1C242A32353B4D52363126170C0A06060A0C172631364B523029194656
                5757575758591929304A522B221012121D1D1D1D283A10222B4A5227220F0903
                0001010003090F22274B532720160D0504020204050D1620274D5425231A110B
                080707080B111A23254E5521211E1E1818141418181B1B1F1F51551F1F1F1F1F
                1F1F1F1F1F1F1F1F1F515539210E0E0E0E0E0E0E0E0E0E1347515A5142423D37
                332F2D2F33373D42485A}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                36050000424D3605000000000000360400002800000010000000100000000100
                080000000000000100000000000000000000000100000000000063CBFF005AC7
                FF007BCBE70063C7FF006BC7E7005AC3F7005ABEF70052B6EF004ABADE004AB2
                E70000AEFF0000AAF70042AADE0042A2D60000A2EF0039A2D600009AE700319A
                CE002996CE000096CE002992C6003992BD00008ED600218ABD00298ABD00318A
                B5002986B5000082C6001882B500217DAD00007DAD000079B5001079AD000075
                BD002175A5000875A5000071AD00086DA500006DA5000069AD00005D9C000055
                73000041520000384A0000344200421000003904000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002D271B1B1610
                0E0B0A0B0E10161B212D28262525252525252525252525252427282323232323
                2323232323232323232728202020202020202020202020202027281C1C1C1C1C
                1C1C1C1C1C1C1C1C1C2728171717171717171717171717171727281414181D22
                22222222221D181414272811111A1E292A2A2A2A2B2C1A111127280F0F190202
                040404040813190F0F27280C0C0D15191919191919150D0C0C27280909090909
                0909090909090909092728070707070707070707070707070727280606060606
                0606060606060606062728050505050505050505050505050527281206000000
                00000000000000011F272E271B1B16100E0B0A0B0E10161B212E}
              Color = clBtnFace
              PopupMenu = PopMized
              TabOrder = 6
              OnMouseDown = btnMinSizeMouseDown
              OnMouseMove = btnMinSizeMouseMove
              OnMouseUp = btnMinSizeMouseUp
            end
            object btnStartGame: TRzBmpButton
              Left = 343
              Top = 465
              Width = 104
              Height = 26
              Cursor = crHandPoint
              Bitmaps.Disabled.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B00000001000077000000000000009999
                990066666600E6FFFD003D3E43002D2F32007C878600A1A1A0004A4A4A000A05
                2000B8C3C200687170007B839C00FFFFFF0008012A000A003600545458001415
                15003A3A31008C8C8C00CEE1DF008F9C9B00747B7B00ADB3B3004C4D5100616B
                6B001A0D53002527280009081100515866008E96960011034A00343639001C1F
                1E004E4E760020222B009EA7A600D7EFED002B245D00C4D5D30043444800B0BF
                BE006C6D7200A3ACAB0096A4B30004050500190572000C0E0E003C3C3F007B8C
                84007D7E8200140557005A5A5A00BEBEBE002F323C0017191D00BFD0CE005C5D
                8700424242009DABBA006B6B6D0064656A0095A6A5003A3A3A00515152007575
                7A00292A2E000F073900DFF7F50015045B00B7CAD200838E9C00D1E5E3000F10
                0F005E5F630002000A00A8A8AA008E9BA90085868900959699009D9EA1002022
                210033333300AEADAE00C5DBD900AEC2C000424A4A00636B7B00BBCFD500737E
                8C00545A5A00828A89000502160010044300100A2C00B4B4B40014045F00424A
                42001919190084848400939393007B7B7C00474F4E0073747400292929000809
                0800A4A4A40013131C00404551005B5C5F00BDD6CE004D4F530011005600838D
                A400CCE1E300C3D8DC00B5C1C00016075E00D3E7E50000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000005D5D5E373737
                3737373737373737373737373737373737373737373737373737373737373737
                3737373737373737373737373737373737373737373737373737373737373737
                3737373737373737373737373737373737373737373737373737373737373737
                43330F0949496242202020202020202020202020202020202020202020202020
                2020202020202020202020202020202020202020202020202020202020202020
                2020202020202020202020202020202020202020202020202020202020202020
                2020202020681149490F0E696921303030303030303030303030303030303030
                3030303030303030303030303030303030303030303030303030303030303030
                3030303030303030303030303030303030303030303030303030303030303030
                30303030303030303030303030303F62691C5C2D696262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                62626262626262626262626262626262626262626262626269694B0049626242
                04053F3A3A3A3A3A1B1B3030303A3A3A3A3A2051053A3A3A3A3A2020303A3F05
                1B21516868216262053A3A3A3A052121513F3A3F425162626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                69004B0049621B0808423018181818181808081818181818183A6868203A3A3A
                3A3A3A203F08425168203A083A3F0505043A3A3A3A083020303030303A302062
                6262626262626262626262626262626262626262626262626262626262626262
                626262626262626269004B4B115120101052041010101010103F204010101010
                284242523F3A3A3A3A3A3F52523A3F42523A3A3A3A3A5220283A3A3F523F3A3A
                3A20200520303A21212121212121212121212121212121212121212121212121
                212121212121212121212121212121212F2D1C2F623A3434342828346D6D6D6D
                6D20682834104040300520203A3A20515151203A20515151203A20515151203A
                2051203A205151203A20203A3A203A3A205151203A2051203A3A2051203A3A20
                515151515151515151515151515151515151515151515151112F6B211B026D04
                404A28340202020202020808102804040868683A0D0D3A3F68683A0D3A686868
                3A0D3A3F3F3A3A0D3A3A3A0D3A683F3A0D3A3A0D0D3A0D0D3A68683A0D3A3F3A
                0D0D3A3F3A0D0D3A686868686868686868686868686868686868686868686868
                51212352523C5A3F28283F6D3C3C3C3C3C3C3C3C4A5A6F6F4A05053F3A3A0D3A
                3F053A0D3A0505053F3A0D3A3A0D3A0D0D0D0D0D3A053A0D3A0D3A3A0D3A3A0D
                3A05053F3A0D3A3F3A3A0D3A0D3A0D3A05050505050505050505050505050505
                050505050505050505053666303D3D340830182A6767674A3C67676767676767
                6720202020303A0D3A203A0D3A202020303A3A0D0D3A3A0D3A3A3A0D3A203A0D
                3A3A0D3A0D3A3A0D3A2020203A0D3A3A0D3A3A0D3A3A0D3A2020202020202020
                2020202020202020202020202020202028666C1966663D652A2A656565676D28
                6F4A3C67676565656530303030303A0D3A303A0D3A3030303A0D0D3A0D3A3A0D
                3A3A3A0D3A303A0D3A3A0D3A0D3A3A0D3A3A3A30303A0D0D3A3A3A0D3A3A3A3A
                3030303030303030303030303030303030303030303030305A191D0634103C63
                636565654134082828084010103D65633C28283A3A3A3A0D3A3A3A0D3A3A3A3A
                3A3A0D3A0D3A3A0D0D0D0D0D3A3A3A3A0D3A0D3A0D3A0D0D0D0D3A3A3A3A0D3A
                3A3A0D3A0D3A3A28282828282828282828282828282828282828282828282828
                0B06573E1965134E2A4A4A4A101818181818181818183D133D18183A0D0D0D0D
                0D0D0D0D0D0D0D3A183A0D3A0D3A3A3A3A3A3A3A3A18183A0D3A0D3A0D3A3A0D
                3A3A3A3A3A0D3A0D3A3A0D3A3A0D3A1818181818181818181818181818181818
                1818181818181818063E5955161364676D3D2A2A341010101010101010342A63
                4A1010083A3A3A0D3A3A3A0D3A3A3A08103A0D3A0D3A0D0D0D0D0D0D3A10083A
                0D3A0D0D0D3A3A3A0D3A083A0D3A3A0D0D0D0D3A3A3A3A081010101010101010
                10101010101010101010101010101010155547545B4F4F413D67134F654A6D6D
                6D6D6D6D6D3D413C4A6D6D6D6D6D3A0D3A6D3A0D3A6D6D6D183A0D3A0D3A0D3A
                3A3A3A0D3A6D3A0D3A3A0D3A3A0D0D0D0D0D3A183A183A0D3A3A0D0D0D0D0D3A
                6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D2B544D251E070701
                6365640763020202020202020202020202020202403A3A0D3A3A3A0D3A3A3A40
                3A0D0D0D0D0D3A0D3A3A0D3A4002403A3A0D0D0D0D0D3A3A3A3A40403A3A3A0D
                3A3A0D3A3A0D3A40020202020202020202020202020202020202020202020202
                29252C035064074C4C506A6A322A2A2A2A2A2A2A2A2A2A2A2A2A2A2A3A0D0D0D
                0D0D0D0D0D0D0D3A103A3A0D3A3A103A0D3A3A102A2A103A0D3A3A0D3A3A0D0D
                0D0D3A3A0D0D0D0D3A3A0D3A3A0D3A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A38032C0324324E13015353534F6541414141414141414141
                41414141343A3A3A3A3A3A3A3A0D3A3441413A0D3A41413A0D3A414141413A0D
                3A3A0D3A343A0D3A3A3A34343A3A3A3A343A0D3A0D3A34414141414141414141
                4141414141414141414141414141414138032C032B323232634F535F4C633232
                3232323232323232323232323232323232323232343A34323232343A34323234
                3A3432323232343A34343A3432343A34323232323232323232343A343A343232
                32323232323232323232323232323232323232323232323238032C03174E4E4E
                4E4E6A35504E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E
                4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E
                4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E
                2703710374131313131350355013131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                131313131313131314032203764F6464646401356A6464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464642B03441F58034817010101015335500101
                0101010101010101010101010101010101010101010101010101010101010101
                0101010101010101010101010101010101010101010101010101010101010101
                010101010101010101010101010101010101010101010A440371702673030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                3B751F451A0C7203030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303034639602E}
              Bitmaps.Down.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100008B000000010011008D9B
                AB00080473003E447B00162B450001014200CCFFFF000806750001003A000302
                620008069C00E6FFFD00B2C6D4000000330055728600020253000908A4002540
                5A00060593006E809500130E430000002900333872000F0054000B1F38005C5D
                8700080263009DABBA00CCE2E40006047B000A088C00160FB600010021003348
                66001F29440003004A000202590046647A000E193000060484000A0883000704
                6B000F0BB1002B245D003C5A72007C839C001F3D5A00565F8E00122340000703
                500059768900ABBECD0005062B00C3D8DC0012304F0096A4B30006034B001A13
                C50006112400D6F0F0006B779D003550690019057200010019005C6E84001B0E
                5300464F75000E0A99001D21430015055F0007045A00274561008DA9B5000906
                6D00838DA400273B53001D324C004A5C7300110DA7000F0A9600606B94001031
                4A000C00400016203A00718D9D0009077A0019375400E0F9F800A8C4CB0095A6
                BB0042556B003D466A000C0732002A4863000F088F000D0AA4001412BB00535C
                8B00D2EAEE001613BD00333D5D00B7CAD200C1DCDF007E90A400223350001605
                5B001915C5004D567F00192142000F233A00415B7200808EA000173553000B01
                370000006B000B0B56000506660012044B00120DB6000F0DA00047657B001200
                5900091329001C2E4A003A4B640038556E008C9DB20019294A002A3E59007180
                930010104A005F6E85004F4F77001F204700120CAA00BBCFD50029325100FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000525285783232
                3232323232323232323232323232323232323232323232323232323232323232
                3232323232323232323232323232323232323232323232323232323232323232
                323232323232323232323232323232323232323232323232323232323232325A
                1417714425256E21808064646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                64646464643D25256E145C3D7D6815150D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D344B7D80535D4C2020151515150D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D151515152020115D302E263F3F0D
                31053831313131310D0D31313131313131310808080531313105050538383805
                0D0D0D0D0D15151508310505050515150D050505050D0D0D0D20202020202020
                2020202020202020202020202020202020202020202020202020202020203F3F
                042E30707A0020050515082323232323232323232323232323080D0D0D080823
                2308080808231515150D08080808151508080808080808080808080808080815
                15153F1515151515151515151515151515153F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F006D706D363A001505050D0D2323232323230D0D2323232323
                230D3F3F150808153F3F3F1508153F3F3F1508153F3F3F1508153F1508153F3F
                150815150808150808153F3F1508153F150808153F150808153F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F0018366D363A150505232308230F0F0F0F
                0F0D2008232323230D152020080606080D20200806082020200806080D0D0D0D
                060808080608200D0D06080806060806060820200806080D0D0606080D0D0606
                082020202020202020202020202020202020203F3F3F3F00183630567A05050D
                2324050F242424242424050523230808080820200D0D0D06080D200806082020
                200D0D060808060806060606060820080608060808060808060820200D0D0608
                0D0D0D0608060806082020202020202020202020202020202020202020203F3F
                6D567B472631310D050505467474747474747474463131314646151515150D0D
                0608150806081515150D0D0D0606080806080808060815080608080608060808
                0608151515080608080608080608080608151515151515151515151515151515
                151515151515203F04474B2C5331464623083129020202092902020202020202
                020F0D0D0D0D0D0D0608080806080D0D0D0D0606080608080608080806080808
                060808060806080806080808080808060608080806080808080D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D15204B2C7C0E220846070707282828551A23
                0F1A020202020202022323230808080806080808060808080808080608060808
                0606060606080808080608060806080606060608080808060808080608060808
                050505050505050505050505050505050505050505050D157C0E4D5488057428
                28282828281A0F0F0F0F46464649282807232323080606060606060606060606
                0823080608060808080808080805232308060806080608080608080505050608
                0608080608080608232323232323232323232323232323232323232323230808
                4D548348644928282849494974242424242424242424074F070F0F0F23080808
                0608080806080808232408060806080606060606060824230806080606060808
                0806082308060808060606060808080823242424242424242424242424242424
                2424242424380505404881585B555E552955282829747474747474747474284F
                0774747474747408060874080608747474230806080608060808080806087408
                0608080608080606060606082308230806080806060606060874747474747474
                7474747474747474747474747424380513586F6642284F281D1E774E1E070202
                0202020202271E2802020202020F080806080808060808080F08060606060608
                06080806080F020F08080606060606080808080F0F0808080608080608080608
                0F0202020202020202020202020202020202020202090F236766013B6B5E7777
                4343861F77272727272727272727272727272727270806060606060606060606
                0824080806080824080608082427272408060808060808060606060808060606
                060808060808060827272727272727272727272727272727272727271D1D0931
                7E3B370B61287776606060600A12121212121212121212121212121212090808
                0808080808080608091212080608121208060812121212080608080608090806
                0808080909080808080908060806080912121212121212121212121212121212
                12121212271D290F590B370B61291E0A2A393939760A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0908090A0A0A0908090A0A0908090A0A0A0A09
                08090908090A0908090A0A0A0A0A0A0A0A0A09080908090A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A12270224590B370B61741D1E0A2A6A6A6A100A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A12270209590B370B2F090727
                120A76392A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A12270246
                590B4A0B3C24291D27275F395F12121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                12121212271D2924330B840B0C730929291D1D1F4F1D1D1D1D1D1D1D1D1D1D1D
                1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D
                1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D
                1D1D1D1D1D1D1D1D1D1D1D1D1D7424160B5775870B33030F0F0909285E740909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090F50620B4A792B350B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                1B457969412D1C0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B6519453E}
              Bitmaps.Hot.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B000000010000C70000000C07320096A4
                B3000504D900193754000C128C00030274004149BA00E6FFFD00557286001D14
                9C00071CBD000C0040000B19A0002C4AA0000905BC00FFFFFF00130EC3000B07
                9C00B6C9D1001223400042556B001E2AAC000705CC007182C2000E0A7B007180
                9300170EBD0097A7F000203976001E12C60004026C000906B000281EA7001018
                96000E0E7D00D6F0F0002F27AF000D088B0010235E000807D7005058D3002745
                61000604DE003C5A7200100CE800050359001D13A2000A06A6009DABBA00212E
                AF000F186B000C0793008091D2000E08AD000605DE004F4F77002F369C003C4D
                8B00C1DCDF00141D9B0011304E003439E4000806C5000D08840008005200281A
                B600ABBEF5000E203D00100EE100808EA000597689001219700018109900C3D8
                DC002114CB00262D8E002110AD00142762005F70B0004D5E9D003A4B64002929
                B5006C77EC002818BF00191095002B2BAE0046647A00050363002F2FB3005760
                E9002F20B400130DAC00A8C4CB00595A850002027A00B3C7F600130E4300100C
                D3002843870010005C000908E4002A3B5500161E78002B245D000A1FB9008D9B
                AB001D214300160950002634B6001A13E4001B1794002016D4002323A3001931
                690000003B001924A5001D12B200E0F9F800100BA5000F099B0012304F002719
                AF00CBE1E3002C1EB100211994003840AB000D138E002921BD000F0ABC000F0A
                C7000B08B6008DA9B500271AC600718D9D003F45E5005F6E85001810B3003550
                690047657B001A13DF002A486300415B72001F3D5A00545DE60034519600100B
                D2000D0ACF000D0AE70014006F002331B3002016BD002B21AD00121B9B001506
                5D004951C700BBCFD5008E9EE000110AB400D3EAFA001A12CD002318A4001204
                4B00161F3E0079819A002C3D7B00616BEA00243E8E002A3E59001E2582002110
                DE00173553000B0137000A17A200110B93000F00540020199C001B26A8002215
                B700130FED002416CE002417AC001B11D7001620A0001B11AE001C2E4A003855
                6E0026426A00555DDC00838DA4002318C2001424770015276300415F83001010
                4A001F2047001E306D004D5C7500375492000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000B0BC28A4646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464614
                60AEAB6A5656C0900D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0DC58A8A8D600089B9A60A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A6862B9A7A28C1CACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACBA8C138EBE0404B6
                9573156C6C6C6C953B3B9595956C6C6C6C6C1521736C6C6C6C6C15B095953173
                3B7E21B6987E7E7E736C6C6C6C73217E21316C31B62104040404040404040404
                0404040404040404040404040404040404040404040404040404040404040404
                718E13AA47227E55556E70585858585858555858585858585822222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                22222222222222224DAA437832226E24246EAF2424242424246E6E9724242424
                7018181818181818181818181818181818181818181818181818181818181818
                1818181818181818181818181818181818181818181818181818181818181818
                181818181818181818181818181818182678433C32AF979797AFAF9724242424
                245422AF972020206E18182D72722D1818182D722D1818182D722D1818182D72
                2D182D722D18182D722D2D72722D72722D18182D722D182D72722D182D72722D
                181818181818181818181818181818181818181818181818263C1303475A9754
                A07B09205A5A5A5A5A5AAFAFA0095454091818720F0F722D1818720F72181818
                720F722D2D72720F7272720F72182D720F72720F0F720F0F721818720F722D72
                0F0F722D720F0F72181818181818181818181818181818181818181818181818
                BF03B829665AA0AD4848ADB45A5A5A5A5A5A5A5A79A02E2EB43F3F2D72720F72
                2D3F720F723F3F3F2D720F72720F720F0F0F0F0F723F720F720F72720F72720F
                723F3F2D720F722D72720F720F720F723F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3FC329652BA879794C48AD2E41414141B4417F7F7F7F7F7F7F
                7F252525252D720F7225720F722525252D72720F0F72720F7272720F7225720F
                72720F720F72720F72252525720F72720F72720F72720F722525252525252525
                25252525252525252525252525252525A42B50084B777453B1B153535353B777
                76B7B1B153535353533333333333720F7233720F72333333720F0F720F72720F
                7272720F7233720F72720F720F72720F7272573357720F0F7257720F72577257
                3333333333333333333333333333333333333333333333333908C48538761A84
                84BDBDBD965B1111111176767688BD84741111577272720F7272720F72727257
                57720F720F72720F0F0F0F0F721157720F720F720F720F0F0F0F721157720F72
                57720F720F725711111111111111111111111111111111111111111111111111
                4F8587837D1DB34A1A9D9D9D352F2F2F2F2F2F2F2F2F1AB39D2F2F720F0F0F0F
                0F0F0F0F0F0F0F722F720F720F72727272727272572F2F720F720F720F72720F
                72725757720F720F72720F72720F722F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F4E83195C066F6F10828010101F1F1F1F1F1F1F1F1F1F109F
                801F1F1E7272720F7272720F7272721E1F720F720F720F0F0F0F0F0F721F1E72
                0F720F0F0F7272720F721E720F72720F0F0F0F727272721E1F1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F175C453A9AB5B5810E81B5B5810E0E0E
                0E0E0E0E0E0E81810E0E0E0E0E0E720F720E720F720E0E0E05720F720F720F72
                7272720F720E720F72720F72720F0F0F0F0F72057205720F72720F0F0F0F0F72
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E343A6923288B8B8B
                6192B58B913E3E3E3E3E3E3E3E3E3E3E3E3E3E3E0572720F7272720F72727205
                720F0F0F0F0F720F72720F72053E0572720F0F0F0F0F7272727205057272720F
                72720F72720F72053E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                9C230107BB44446D6D6D6D6D92161616161616161616161616161616720F0F0F
                0F0F0F0F0F0F0F720572720F727205720F727205161605720F72720F72720F0F
                0F0F72720F0F0F0F72720F72720F721616161616161616161616161616161616
                16161616161616161B0701078F272727446D6D6D442727272727272727272727
                272727275E72727272727272720F725E2727720F722727720F7227272727720F
                72720F725E720F7272725E5E727272725E720F720F725E272727272727272727
                272727272727272727272727272727271B0701078F0202020264B2B22C020202
                02020202020202020202020202020202020202025E725E0202025E725E02025E
                725E020202025E725E5E725E025E725E0202020202020202025E725E725E0202
                0202020202020202020202020202020202020202020202021B070107592A2A2A
                2A2A93B2642A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                1B07BC07522A2A2A2A2A64B2642A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A420737075F442A2A2A2A2AB2642A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A3D0775A19B0742862A2A2A2A642C362A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A
                2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2A2AA59E07BCAE6749070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                309963636BA37A07070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                070707070707125D6394}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A000000000000000000000001000000000000010021008893
                A5000000990019375400000058006B8599000000F0004F517200E2FCFA000000
                D7000000420001008D000000CC0001008300C1DCDF0017184300E6FFFD002B3D
                8E0001003A00010072001A1C9A000000C4000000BC00A8C4CB003A3668000000
                E50001004A0000003300292258008999F8000000AD001B1ED200000066006E7B
                F10047657B0000005200D6F0F000A4B4BF000B1070005572860000002A000D0F
                F1002D3B5B0011304E00181A8B000C0046003C5A720000006B00657D8E000E11
                5F0085A0B100B6D0DA001B1EAA0001007B0038556E003A528400100054002E36
                5A00112B4900CAE0E200CCFFFF0001009300506C8300494872000F0058001732
                4D002E33E0000C023A00DEF7EF000000B5008DA9B5001F3D5A00ABC2C9005976
                89000000DF007E95A300030628001B1EC5001E21F2002745610036445F000B0D
                52001524510015177C001E27490029428C00CAE3EB0018345200B1C3CB003048
                6E007178940095A2B4000E014A0021425A00BED4D8000000F6000200A300D7F0
                F70005083C00718D9D0094A5F8000E164B009FB9C600121A700012304F002A48
                630004063200CBE1E300060A2C0095ADB7001F314E0057738600DDF6F500080B
                460011146E00B5CEDE001B1EB8000E043B00364B63002E428B0021426300FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002D75506F4949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949492739
                5C40437622223711111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                11111111773722222A2D54365926131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313131313131313131313136736360F4769650A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A52696E474700001223
                0A1A23232323231B1B23232323232323231A1B1204232323231A1A1A1A1A1A1B
                282812122828280A232323230A2828281A041A12120000000000000000000000
                000000000000000000000000000000000000000000000000000000000000006C
                47575757001B23231B1A0404040404040404040404040404041B1B1B0A0A0404
                040A1B12231B00001B1212040A0028121A040A0A0A1A120A0A0A0A0A0A1B1B1B
                1B00000028282828282828282828282828000000000000000000000000000000
                000000000000004C57416868280A0404121A0404040404040A0A040404040404
                1B1B1B1B0A0A0A041A121B1B0A0A001B0A0A0A0A0A1B1B0A0A0A1212121A1A12
                121B1B1B1212121B1B1B00282828282828282828282828282828000000000000
                0000000000000000000000000000004C683A2B2B1A040404041A042020202020
                0A1B1A040404040A281B281B1B1B1B2828281B1B1B2828281B1B1B2828281B1B
                1B281B1B1B28281B1B1B1B1B1B1B1B1B1B28281B1B1B281B1B1B1B281B1B1B1B
                2828282828282828282828282828282828282828282828282B3A03032F2F1A04
                2023202F2F2F2F2F2F232323231A1A1A1A1A28123C3C12121212123C12282828
                123C12121212123C1212123C121212123C12123C3C123C3C121212123C121212
                3C3C1212123C3C1228282828282828282828282828282828282828282828286A
                03414F4F35200A23231A2035353535353535352F2F04042F1313121212123C12
                1212123C1212121212123C12123C123C3C3C3C3C1212123C123C12123C12123C
                12121212123C121212123C123C123C1212121212121212121212121212121212
                12121212121212624F5D2E36131320041A04353535352F35350D0D0D0D0D0D0D
                0D130A0A0A0A0A3C1212123C120A0A0A1212123C3C12123C1212123C1212123C
                12123C123C12123C120A0A0A0A3C12123C12123C12123C120A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A712E76273E04130B35350B0B0B0D2F0404
                2F35350D0B0B0B0B0D041A1A1A1A123C121A123C121A1A1A123C3C123C12123C
                1212123C121A123C12123C123C12123C12120A1A0A0A3C3C120A0A3C120A0A0A
                1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A5127226305200D3D3D
                0B0B0B0B2F04040404202020350B0B0D200A041A1212123C1212123C1212121A
                1A123C123C12123C3C3C3C3C12041A123C123C123C123C3C3C3C12041A123C12
                1A123C123C121A04040404040404040404040404040404040404040404040431
                633046323D60600D353535132020202020202020200D600D201A20123C3C3C3C
                3C3C3C3C3C3C3C1220123C123C121212121212121A2020123C123C123C12123C
                12121A1A123C123C12123C12123C122020202020202020202020202020202020
                2020202020202072464B486660600B350D0B0B131313131313131313130B600D
                131313231212123C1212123C1212122313123C123C123C3C3C3C3C3C12132312
                3C123C3C3C1212123C1223123C12123C3C3C3C12121212231313131313131313
                13131313131313131313131313131353176D0E331E45020B0B1E1E020D0D0D0D
                0D0D0D0D0B0B0B0D0D0D0D0D0D0D123C120D123C120D0D0D04123C123C123C12
                1212123C120D123C12123C12123C3C3C3C3C12041204123C12123C3C3C3C3C12
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D2C0E4824561616161E
                6045451E3D0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0412123C1212123C12121204
                123C3C3C3C3C123C12123C12040B0412123C3C3C3C3C1212121204041212123C
                12123C12123C12040B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B14
                245E1061161515151515151E60606060606060606060606060606060123C3C3C
                3C3C3C3C3C3C3C122012123C121220123C121220606020123C12123C12123C3C
                3C3C12123C3C3C3C12123C12123C126060606060606060606060606060606060
                6060606060606034103B10614545451509090915451E1E1E1E1E1E1E1E1E1E1E
                1E1E1E1E2F12121212121212123C122F1E1E123C121E1E123C121E1E1E1E123C
                12123C122F123C1212122F2F121212122F123C123C122F1E1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E74106B1061161616160C09090915161616
                1616161616161616161616161616161616161616131213161616131213161613
                1213161616161312131312131613121316161616161616161613121312131616
                16161616161616161616161616161616161616161616164D106B10610C0C0C0C
                0C4A4A4A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C1F
                106B081009090909094A4A4A0909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090942103358102119191919190606191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919196410013F10101D29060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606064E6410701C2D5A08101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101070
                075C404018250810101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010245B1C2D2D}
              Color = clBtnFace
              PopupMenu = PopStartGame
              TabOrder = 7
              OnMouseDown = btnStartGameMouseDown
              OnMouseMove = btnStartGameMouseMove
              OnMouseUp = btnStartGameMouseUp
            end
            object ckWindowed: TRzCheckBox
              Left = 78
              Top = 433
              Width = 68
              Height = 15
              Cursor = crHandPoint
              AlignmentVertical = avBottom
              AutoSize = False
              Caption = #31383#21475#27169#24335
              Color = clBtnFace
              FrameColor = 4963313
              Font.Charset = ANSI_CHARSET
              Font.Color = 4963313
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              HighlightColor = clBlue
              HotTrackColor = clBlue
              LightTextStyle = True
              ParentColor = False
              ParentFont = False
              TextShadowDepth = 1
              State = cbUnchecked
              TabOrder = 8
              Transparent = True
              OnMouseMove = ckWindowedMouseMove
            end
            object Panel2: TPanel
              Left = 224
              Top = 430
              Width = 95
              Height = 20
              Cursor = crHandPoint
              Caption = #20998#36776#29575#21015#34920#20301#32622
              Color = clMenuHighlight
              Font.Charset = GB2312_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentBackground = False
              ParentFont = False
              TabOrder = 9
              OnMouseMove = PanelServerListMouseMove
            end
            object PanelProcessCur: TPanel
              Left = 131
              Top = 485
              Width = 183
              Height = 12
              Cursor = crHandPoint
              Color = clMenuHighlight
              ParentBackground = False
              TabOrder = 10
              OnMouseMove = PanelProcessCurMouseMove
            end
            object PanelProcessMax: TPanel
              Left = 131
              Top = 501
              Width = 183
              Height = 11
              Cursor = crHandPoint
              Color = clMenuHighlight
              ParentBackground = False
              TabOrder = 11
              OnMouseMove = PanelProcessMaxMouseMove
            end
            object PanelServerList: TPanel
              Left = 77
              Top = 66
              Width = 230
              Height = 325
              Cursor = crHandPoint
              BevelInner = bvLowered
              Caption = #26381#21153#22120#21015#34920#20301#32622
              Color = clMenuHighlight
              Font.Charset = GB2312_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentBackground = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 12
              OnMouseMove = PanelServerListMouseMove
            end
            object PanelWebBrowser: TPanel
              Left = 353
              Top = 66
              Width = 406
              Height = 359
              Cursor = crHandPoint
              BevelInner = bvLowered
              Caption = #32593#31449#20844#21578#20301#32622
              Color = clMenuHighlight
              Font.Charset = GB2312_CHARSET
              Font.Color = clWhite
              Font.Height = -12
              Font.Name = #23435#20307
              Font.Style = []
              ParentBackground = False
              ParentFont = False
              TabOrder = 13
              OnMouseMove = PanelServerListMouseMove
            end
            object RzBmpButton1: TRzBmpButton
              Left = 565
              Top = 465
              Width = 104
              Height = 26
              Cursor = crHandPoint
              Bitmaps.Disabled.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B00000001000077000000000000009999
                990066666600E6FFFD003D3E43002D2F32007D7E8200A1A1A0004A4A4A000A05
                200068717000B8C3C2007B839C0008012A00FFFFFF000A003600545458001415
                15008C8C8C003A3A3100CEE1DF008F9C9B00747B7B00616B6B004C4D5100ADB3
                B3001A0D53002527280009081100515866008E96960011034A001C1F1E004E4E
                760020222B009EA7A600D7EFED002B245D00C4D5D30034363900848484004344
                4800B0BFBE006C6D7200A3ACAB0096A4B30004050500190572000C0E0E003A3A
                3A00140557005A5A5A00BEBEBE002F323C007C87860017191D00BFD0CE005C5D
                8700424242009DABBA006B6B6D0064656A0095A6A5003C3C3F00515152007575
                7A00292A2E000F073900DFF7F5008586890015045B00B7CAD200838E9C00D1E5
                E3000F100F005E5F630002000A00A8A8AA008E9BA900959699009D9EA1002022
                210033333300AEADAE00C5DBD900AEC2C000424A4A00636B7B00BBCFD500737E
                8C00545A5A000502160010044300100A2C00B4B4B40014045F00424A42001919
                1900939393007B7B7C0073747400474F4E002929290008090800A4A4A4001313
                1C00404551005B5C5F00BDD6CE004D4F5300110056007B8C8400838DA400CCE1
                E300C3D8DC00B5C1C000828A890016075E00D3E7E50000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000005C5C5D373737
                3737373737373737373737373737373737373737373737373737373737373737
                3737373737373737373737373737373737373737373737373737373737373737
                3737373737373737373737373737373737373737373737373737373737373737
                43320F094A4A6142272727272727272727272727272727272727272727272727
                2727272727272727272727272727272727272727272727272727272727272727
                2727272727272727272727272727272727272727272727272727272727272727
                272727272766114A4A0F0D6767203F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3161671C5B2E676161616161616161616161
                6161616161616161616161616161616161616161616161616161616161616161
                6161616161616161616161616161616161616161616161616161616161616161
                61616161616161616161616161616161616161616161616167674C004A616142
                0405313A3A3A3A3A1B1B3F3F3F3A3A3A3A3A2751053A3A3A3A3A27273F3A3105
                1B20516666206161053A3A3A3A05202051313A31425161616161616161616161
                6161616161616161616161616161616161616161616161616161616161616161
                67004C004A611B0808423F18181818181808081818181818183A6666273A3A3A
                3A3A3A273108425166273A083A310505043A3A3A3A083F273F3F3F3F3A3F2761
                6161616161616161616161616161616161616161616161616161616161616161
                616161616161616167004C4C1151271010520410101010101031274010101010
                29424252313A3A3A3A3A3152523A3142523A3A3A3A3A5227293A3A3152313A3A
                3A272705273F3A20202020202020202020202020202020202020202020202020
                20202020202020202020202020202020302E1C30613A3333332929336B6B6B6B
                6B276629331040403F052751273A3A3A3A3A3A3A3A3A2751273A3A3A3A275151
                273A3A275151515151273A3A2751273A3A3A275151273A3A3A3A3A3A3A275151
                515151515151515151515151515151515151515151515151113069201B026B04
                404B2933020202020202080810290404086666663A0E0E0E0E0E0E0E0E0E3A66
                3A0E0E0E0E3A31313A0E0E3A6666313A3A3A0E0E3A313A0E0E0E3A66663A0E0E
                0E0E0E0E0E3A6666666666666666666666666666666666666666666666666666
                51202252523C5A312929316B3C3C3C3C3C3C3C3C4B5A6D6D4B050505313A0E3A
                3A3A3A3A0E3A3105313A3A3A3A0E3A3A0E3A3A3105053A0E0E3A0E3A0E3A0E3A
                3A3A3105053A0E3A3A0E3A3A0E3A050505050505050505050505050505050505
                0505050505050505050535653F3D3D33083F182B6464644B3C64646464646464
                642727273F3A3A0E3A3A3A0E3A3A3F2727273A0E3A3A0E0E3A3A0E3A27273F3A
                3A0E0E3A3A0E3A0E3A3F2727273A0E0E0E0E0E0E0E3A27272727272727272727
                2727272727272727272727272727272729656A1765653D632B2B636363646B29
                6D4B3C6464636363633F3F3F3A0E0E0E0E0E0E0E0E0E3A3F3F3F3A0E3A3A0E3A
                3A3A0E3A3F3F3A3A3A3A3A0E3A0E3A3A0E3A3A3A3A3A0E3A3A0E3A3A0E3A3A3A
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F5A171D3633103C28
                286363634133082929084010103D63283C29293A3A3A3A3A3A3A3A3A3A3A3A29
                29293A0E3A3A0E3A3A3A0E3A3A3A3A0E0E0E0E0E0E0E0E0E0E0E3A3A0E0E0E0E
                0E0E0E0E0E0E0E3A292929292929292929292929292929292929292929292929
                0A36573E176312452B4B4B4B101818181818181818183D123D18183A0E3A3A3A
                3A3A3A3A3A3A3A3A18183A0E3A3A3A3A3A3A0E3A1818293A3A3A0E3A0E3A3A3A
                3A3A3A3A3A3A0E0E3A3A3A3A0E3A3A3A18181818181818181818181818181818
                1818181818181818363E5955161262646B3D2B2B331010101010101010332B28
                4B1010083A0E3A0E0E0E0E0E3A0E0E3A10103A0E0E0E0E0E0E0E0E3A10103A0E
                0E3A0E3A0E0E0E0E0E3A1010083A3A3A0E3A3A0E3A0810101010101010101010
                1010101010101010101010101010101015554854744F4F413D64124F634B6B6B
                6B6B6B6B6B3D413C4B6B6B6B183A0E3A3A3A3A3A0E3A3A186B6B183A3A3A3A3A
                3A3A3A186B6B183A3A0E0E3A3A3A0E3A3A3A186B3A0E3A183A0E0E3A186B6B6B
                6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B2C544E241E070701
                286362072802020202020202020202020202020202403A0E3A403A0E3A400202
                02023A0E0E0E0E0E0E0E3A020202403A0E3A0E0E0E0E0E0E0E0E3A02403A0E3A
                0E3A3A0E3A400202020202020202020202020202020202020202020202020202
                2A242D035062074D4D506868062B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B103A
                0E3A0E3A102B2B2B2B2B3A0E3A3A3A3A3A0E3A2B2B2B3A0E3A3A0E3A3A3A0E3A
                3A3A102B2B103A0E0E0E0E0E0E3A2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B
                2B2B2B2B2B2B2B2B38032D0323064512015353534F6341414141414141414141
                41414141414141333A0E3A334141414141413A0E0E0E0E0E0E0E3A414141333A
                333A0E3A413A0E3A4141414141413A0E3A3A3A3A3A3341414141414141414141
                4141414141414141414141414141414138032D032C060606284F535E4D280606
                06060606060606060606060606060606333A3306060606060606333A3A3A3A3A
                3A3A33060606060606333A3306333A33060606060606333A3306060606060606
                06060606060606060606060606060606060606060606060638032D0319454545
                4545683450454545454545454545454545454545454545454545454545454545
                4545454545454545454545454545454545454545454545454545454545454545
                4545454545454545454545454545454545454545454545454545454545454545
                2603700373121212121250345012121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                1212121212121212121212121212121212121212121212121212121212121212
                121212121212121214032103764F626262620134686262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262626262626262626262626262626262626262626262626262
                6262626262626262626262626262622C03441F58034919010101015334500101
                0101010101010101010101010101010101010101010101010101010101010101
                0101010101010101010101010101010101010101010101010101010101010101
                010101010101010101010101010101010101010101010B4403706E2572030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                3B751F461A0C7103030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                0303030303030303030303030303030303030303030303030303030303030303
                03030303030347395F2F}
              Bitmaps.Down.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100008B000000010011008D9B
                AB00080473003E447B00162B450003004A00CCFFFF000806750001003A000806
                9C0004046900E6FFFD00B2C6D4000000330002025900557286000908A4000B1F
                380025405A00060593006E80950000002900333872001200590006034B000604
                7B005C5D87009DABBA00CCE2E4000A088C0001014200160FB600010021003348
                6600030262001F294400130E46000604840046647A000E1930000A0883000F0B
                B100020253003C5A72007C839C002B245D001F3D5A00565F8E00080263005976
                8900ABBECD00C3D8DC0005062B0012304F0016203A0096A4B300130E43001A13
                C50006112400D6F0F000070350006B779D003550690019057200010019005C6E
                8400464F75000E0A990009066D0007045A001F204700274561008DA9B500838D
                A400273B53001D324C004A5C7300110DA7000F0A960012234000606B94001605
                5B0010314A000C004000718D9D0009077A0019375400E0F9F800A8C4CB0095A6
                BB0042556B003D466A000C0732002A4863000F088F000F0054000D0AA4001412
                BB00535C8B00D2EAEE001613BD001D214300333D5D00B7CAD200C1DCDF007E90
                A400223350001915C5004D567F000F233A001B0E5300415B7200808EA0001735
                53000B01370008006B000B0B56000506660012044B00120DB6000F0DA0004765
                7B00091329001C2E4A003A4B640038556E001921420015055F008C9DB2001929
                4A002A3E5900718093005F6E85004F4F7700120CAA00BBCFD50029325100FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000535346793131
                3131313131313131313131313131313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                313131313131313131313131313131313131313131313131313131313131315A
                385F726526266F21828266666666666666666666666666666666666666666666
                6666666666666666666666666666666666666666666666666666666666666666
                6666666666666666666666666666666666666666666666666666666666666666
                66666666663E26266F245C3E7D6A15150D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D344A7D82365D4B2020151515150D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D151515152020125D4F2E2740400D
                3C1E183C3C3C3C3C0D0D3C3C3C3C3C3C3C3C0808081E3C3C3C1E1E1E1818181E
                0D0D0D0D0D151515083C1E1E1E1E15150D1E1E1E1E0D0D0D0D20202020202020
                2020202020202020202020202020202020202020202020202020202020204040
                042E4F717A00201E1E15080505050505050505050505050505080D0D0D080805
                0508080808051515150D08080808151508080808080808080808080808080815
                1515401515151515151515151515151515154040404040404040404040404040
                40404040404040006D716D353A00151E1E0D0D0505050505050D0D0505050505
                050D404040150808080808080808081540150808080815404015080815404040
                4040150808154015080808154040150808080808080815404040404040404040
                4040404040404040404040404040400011356D353A151E1E050508052A2A2A2A
                2A0D2008050505050D152020200806060606060606060608200806060606080D
                0D0D06060820200D0808080606080D0D06060608202008060606060606060820
                20202020202020202020202020202020202020404040400011354F567A1E1E0D
                050E1E2A0E0E0E0E0E0E1E1E0505080808082020200D0D06080808080806080D
                200D080808080608080608080D20200806060806080608060808080D20200806
                0808060808060820202020202020202020202020202020202020202020204040
                6D567B47273C3C0D1E1E1E457575757575757575453C3C3C45451515150D0D0D
                06080808060808081515150806080806060808060815150D0D0D060608080608
                0608081515150806060606060606081515151515151515151515151515151515
                151515151515204004474A2B363C454505083C44020202224402020202020202
                022A0D0D0D0D060606060606060606080D0D0D0D060808060808080608080808
                080808080608060808060808080808060808060808060808080D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D15204A2B7C0F230845070707282828553005
                2A30020202020202020505050808080808080808080808081E1E1E1E06080806
                0808080608080808060606060606060606060608080606060606060606060606
                081E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E0D157C0F4C54881E7528
                2828282828302A2A2A2A454545442828070505050806081E08080808081E1E1E
                1E05050806080808080808060805051E08080806080608080808081E1E1E1E06
                06080808080608081E0505050505050505050505050505050505050505050808
                4C5484486644282828444444750E0E0E0E0E0E0E0E0E074E072A2A2A05080608
                0606060606080606080E0E080606060606060606080E0E080606080608060606
                0606080E0E050808080608080608050E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E181E1E414883585B555E550A5528280A0A0A0A0A0A0A0A0A0A284E
                070A0A0A0A0508060808080808060808050A0A050808080808080808050A0A05
                0808060608080806080808050A0806080508060608050A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0E181E1458706842284E28191D784D1D070202
                0202020202251D280202020202022A0806082A0806082A020202020806060606
                060606080202022A080608060606060606060608022A08060806080806082A02
                020202020202020202020202020202020202020202220E056968013B6C5E7878
                4343861F782525252525252525252525252525252525250E08060806080E2525
                2525250806080808080806082525250806080806080808060808080E25250E08
                060606060606082525252525252525252525252525252525252525251919223C
                803B370B62287877616161610913131313131313131313131313131313131313
                2208060822131313131313080606060606060608131313220822080608130806
                0813131313131308060808080808221313131313131313131313131313131313
                1313131325190A0E590B370B62441D0929393939770909090909090909090909
                0909090909090909092208220909090909090922080808080808082209090909
                0909220822092208220909090909092208220909090909090909090909090909
                0909090909090909090909091325020E590B370B6275191D09296B6B6B100909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                090909090909090909090909090909090909090913250222590B370B2F220725
                1309773929090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090913250245
                590B490B3D0E4419252560396013131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131325190A0E320B850B0C74220A0202251F4E1919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                191919191919191919191919190A0E160B5776870B32030E0E0E22285E0A2222
                2222222222222222222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222A50630B49172D330B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                1B7F17516E2C1C0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B671A7F3F}
              Bitmaps.Hot.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B000000010000C70000000C07320096A4
                B3000504D900193754000C128C00030274004149BA00E6FFFD00557286001D14
                9C00071CBD000C0040000B19A0002C4AA0000905BC00FFFFFF00130EC3000B07
                9C00B6C9D1001223400042556B001E2AAC000705CC007182C2000E0A7B007180
                9300170EBD0097A7F000203976001E12C6000906B00004026C00281EA7001018
                96000E0E7D00D6F0F0002F27AF000807D7000D088B0010235E005058D3000604
                DE0027456100616BEA003C5A7200100CE800050359000A06A6001D13A2009DAB
                BA00212EAF000F186B000605DE000E08AD000C0793004F4F77002F369C003C4D
                8B00C1DCDF00141D9B000806C50011304E003439E4000D088400281AB600ABBE
                F500080052000E203D00100EE100808EA000597689001219700018109900C3D8
                DC002114CB00262D8E002110AD00142762005F70B0004D5E9D003A4B64002929
                B5008E9EE0002818BF00191095002B2BAE0046647A002F2FB300050363002F20
                B400130DAC00A8C4CB00595A8500B3C7F60002027A00130E4300100CD3002843
                870010005C000908E4002A3B5500161E78008091D2002B245D000A1FB9008D9B
                AB001D2143002634B600160950001A13E4001B1794002016D400545DE6002323
                A3001931690000003B001924A5001D12B200E0F9F800100BA5000F099B001230
                4F002719AF00CBE1E3002C1EB100211994003840AB000D138E002921BD000F0A
                C7000F0ABC000B08B6008DA9B500271AC600718D9D003F45E5005F6E85001810
                B3003550690047657B001A13DF002A486300415B72001F3D5A0034519600100B
                D2000D0ACF000D0AE7002331B30014006F002016BD002B21AD00121B9B001506
                5D004951C700BBCFD5006C77EC00110AB400D3EAFA001A12CD002318A4001204
                4B00161F3E0079819A002C3D7B00243E8E002A3E59001E2582002110DE005760
                E900173553000B0137000A17A200110B93000F00540020199C001B26A8002215
                B700130FED002416CE002417AC001B11D7001620A0001B11AE001C2E4A003855
                6E0026426A00555DDC00838DA4002318C2001424770015276300415F83001010
                4A001F2047001E306D004D5C7500375492000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000B0BC28B4646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464646
                4646464646464646464646464646464646464646464646464646464646464614
                5FAEAB6A5656C0900D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D
                0D0D0D0D0DC58B8B8E5F008AB9A50A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A6861B9A6A28D1CACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACACAC
                ACACACACACACACACACACACACACACACACACACACACACACACACBA8D138FBE0404B6
                9474156B6B6B6B943B3B9494946B6B6B6B6B1521746B6B6B6B6B15B094943274
                3B7F21B6987F7F7F746B6B6B6B74217F21326B32B62104040404040404040404
                0404040404040404040404040404040404040404040404040404040404040404
                728F13AA47227F55556E71575757575757555757575757575722222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                2222222222222222222222222222222222222222222222222222222222222222
                22222222222222224DAA437933226E24246EAF2424242424246E6E9724242424
                7118181818181818181818181818181818181818181818181818181818181818
                1818181818181818181818181818181818181818181818181818181818181818
                181818181818181818181818181818182779433D33AF979797AFAF9724242424
                245422AF972020206E1818182E7373737373737373732E182E737373732E1818
                2E73732E18181818182E73732E182E7373732E18182E737373737373732E1818
                181818181818181818181818181818181818181818181818273D130347599754
                A07C0920595959595959AFAFA009545409181818730F0F0F0F0F0F0F0F0F7318
                730F0F0F0F732E2E730F0F7318182E7373730F0F732E730F0F0F731818730F0F
                0F0F0F0F0F731818181818181818181818181818181818181818181818181818
                BF03B82A6559A0AD4848ADB459595959595959597AA03030B43F3F3F2E730F73
                737373730F732E3F2E737373730F73730F73732E3F3F730F0F730F730F730F73
                73732E3F3F730F73730F73730F733F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3FC32A642CA77A7A4C48AD3040404040B44080808080808080
                802626262E73730F7373730F73732E262626730F73730F0F73730F7326262E73
                730F0F73730F730F732E262626730F0F0F0F0F0F0F7326262626262626262626
                26262626262626262626262626262626A42C50084B787553B1B153535353B778
                77B7B1B15353535353363636730F0F0F0F0F0F0F0F0F73363636730F73730F73
                58730F73363658737373730F730F73730F73585873730F73730F73730F737358
                3636363636363636363636363636363636363636363636363908C48638771A85
                85BDBDBD965A1111111177777789BD8575111158737373737373737373735811
                1111730F73730F7311730F731111730F0F0F0F0F0F0F0F0F0F0F73730F0F0F0F
                0F0F0F0F0F0F0F73111111111111111111111111111111111111111111111111
                4F8688847E1DB34A1A9D9D9D352F2F2F2F2F2F2F2F2F1AB39D2F2F730F735873
                73737373587373582F2F730F7373737373730F732F2F587373730F730F737373
                7373585873730F0F737373730F7373582F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F4E84195B066F6F10838210101E1E1E1E1E1E1E1E1E1E109F
                821E1E1F730F730F0F0F0F0F730F0F731E1E730F0F0F0F0F0F0F0F731E1E730F
                0F730F730F0F0F0F0F731E1E1F7373730F73730F731F1E1E1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E175B453A9AB5B5810E81B5B5810E0E0E
                0E0E0E0E0E0E81810E0E0E0E05730F73737373730F7373050E0E057373737373
                737373050E0E0573730F0F7373730F737373050E730F7305730F0F73050E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E663A6923288C8C8C
                6092B58C913C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C05730F7305730F73053C3C
                3C3C730F0F0F0F0F0F0F733C3C3C05730F730F0F0F0F0F0F0F0F733C05730F73
                0F73730F73053C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C
                52230107BB44446D6D6D6D6D9216161616161616161616161616161616160573
                0F730F73051616161616730F73737373730F73161616730F73730F7373730F73
                737305161605730F0F0F0F0F0F73161616161616161616161616161616161616
                16161616161616161B07010770252525446D6D6D442525252525252525252525
                252525252525255E730F735E252525252525730F0F0F0F0F0F0F732525255E73
                5E730F7325730F73252525252525730F73737373735E25252525252525252525
                252525252525252525252525252525251B070107700202020263B2B22D020202
                020202020202020202020202020202025E735E020202020202025E7373737373
                73735E0202020202025E735E025E735E0202020202025E735E02020202020202
                0202020202020202020202020202020202020202020202021B070107A9292929
                292993B263292929292929292929292929292929292929292929292929292929
                2929292929292929292929292929292929292929292929292929292929292929
                2929292929292929292929292929292929292929292929292929292929292929
                1B07BC079C292929292963B26329292929292929292929292929292929292929
                2929292929292929292929292929292929292929292929292929292929292929
                2929292929292929292929292929292929292929292929292929292929292929
                2929292929292929410737075D442929292929B2632929292929292929292929
                2929292929292929292929292929292929292929292929292929292929292929
                2929292929292929292929292929292929292929292929292929292929292929
                2929292929292929292929292929293E0776A19B07418729292929632D342929
                2929292929292929292929292929292929292929292929292929292929292929
                2929292929292929292929292929292929292929292929292929292929292929
                292929292929292929292929292929292929292929292B9E07BCAE6749070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                319962626CA37B07070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                070707070707125C6295}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A000000000000000000000001000000000000010021008893
                A5000000990019375400000058000000DF004F5172006B859900E2FCFA000000
                42000000D70001008D000000CC0001008300C1DCDF00171843002B3D8E00E6FF
                FD0001003A00010072001A1C9A000000C4002E33E0000000BC00A8C4CB003A36
                680001004A0029225800000033000000AD008999F8000000F000000066004765
                7B006E7BF100D6F0F00000005200A4B4BF000B1070005572860000002A000D0F
                F1002D3B5B0011304E00181A8B001B1ED2000E014A003C5A7200657D8E000000
                6B000E115F0085A0B100B6D0DA001B1EAA0001007B0038556E003A5284001000
                54002E365A00112B4900CAE0E200CCFFFF0001009300506C8300494872000F00
                580017324D000C023A00DEF7EF000000B5008DA9B5001F3D5A00ABC2C9005976
                89000000E5007E95A300030628001B1EC5001E21F2002745610036445F000B0D
                52001524510015177C001E27490029428C0008004A00CAE3EB0018345200B1C3
                CB0030486E007178940095A2B40021425A00BED4D8000000F6000200A300D7F0
                F70005083C00718D9D0094A5F8000E164B009FB9C600121A700012304F002A48
                630004063200CBE1E300060A2C0095ADB7001F314E0057738600DDF6F5001114
                6E00B5CEDE001B1EB8000E043B00364B63002E428B00080B460021426300FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002E74506F4949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949494949
                494949494949494949494949494949494949494949494949494949494949273A
                2E41437521213810101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                10101010763821212A2E54375A26131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313131313131313131313136737370F4769650909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                090909090909090909090909090909090909090909090952696E474700001224
                091A24242424241C1C24242424242424241A1C1204242424241A1A1A1A1A1A1C
                282812122828280924242424092828281A041A12120000000000000000000000
                000000000000000000000000000000000000000000000000000000000000006C
                47585858001C24241C1A0404040404040404040404040404041C1C1C09090404
                04091C12241C00001C121204090028121A040909091A120909090909091C1C1C
                1C00000028282828282828282828282828000000000000000000000000000000
                000000000000004C5842686828090404121A0404040404040909040404040404
                1C1C1C1C090909041A121C1C0909001C09090909091C1C0909091212121A1A12
                121C1C1C1212121C1C1C00282828282828282828282828282828000000000000
                0000000000000000000000000000004C683B2B2B1A040404041A042020202020
                091C1A0404040409281C28281C1212121212121212121C281C121212121C2828
                1C1C1C1C28282828281C1C1C1C281C1212121C28281C121212121212121C2828
                2828282828282828282828282828282828282828282828282B3B030331311A04
                202420313131313131242424241A1A1A1A1A2828123D3D3D3D3D3D3D3D3D1212
                123D3D3D3D121212123D3D121212121212123D3D1212123D3D3D121212123D3D
                3D3D3D3D3D12282828282828282828282828282828282828282828282828286A
                03424F4F36200924241A20363636363636363631310404311313121212123D12
                121212123D12121212121212123D12123D1212121212123D3D123D123D123D12
                1212121212123D12123D12123D12121212121212121212121212121212121212
                12121212121212624F5D2F37131320041A04363636363136360D0D0D0D0D0D0D
                0D1309091212123D1212123D121212090909093D12123D3D12123D1212121212
                123D3D12123D123D1212090909093D3D3D3D3D3D3D1209090909090909090909
                090909090909090909090909090909772F75273F04130B36360B0B0B0D310404
                3136360D0B0B0B0B0D041A1A123D3D3D3D3D3D3D3D3D121A1A1A123D12123D12
                09093D121A1A09121212123D123D12123D12090909093D12123D12123D121209
                1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A5127216307200D3E3E
                0B0B0B0B3104040404202020360B0B0D2009041A121212121212121212121A04
                0404123D12123D1204123D120404123D3D3D3D3D3D3D3D3D3D3D12123D3D3D3D
                3D3D3D3D3D3D3D12040404040404040404040404040404040404040404040432
                633046333E60600D363636132020202020202020200D600D201A20123D121A12
                121212121A12121A2020123D1212121212123D1220201A1212123D123D121212
                12121A1A12123D3D121212123D12121A20202020202020202020202020202020
                2020202020202071464B486660600B360D0B0B131313131313131313130B600D
                13131324123D123D3D3D3D3D123D3D121313123D3D3D3D3D3D3D3D121313123D
                3D123D123D3D3D3D3D121313241212123D12123D122413131313131313131313
                13131313131313131313131313131353186D0E341D45020B0B1D1D020D0D0D0D
                0D0D0D0D0B0B0B0D0D0D0D0D04123D12121212123D1212040D0D041212121212
                121212040D0D0412123D3D1212123D121212040D123D1204123D3D12040D0D0D
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D2C0E4823571717171D
                6045451D3E0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B04123D1204123D12040B0B
                0B0B123D3D3D3D3D3D3D120B0B0B04123D123D3D3D3D3D3D3D3D120B04123D12
                3D12123D12040B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B14
                235E1161171515151515151D6060606060606060606060606060606060602012
                3D123D12206060606060123D12121212123D12606060123D12123D1212123D12
                121220606020123D3D3D3D3D3D12606060606060606060606060606060606060
                6060606060606035113C1161454545150A0A0A15451D1D1D1D1D1D1D1D1D1D1D
                1D1D1D1D1D1D1D31123D12311D1D1D1D1D1D123D3D3D3D3D3D3D121D1D1D3112
                31123D121D123D121D1D1D1D1D1D123D1212121212311D1D1D1D1D1D1D1D1D1D
                1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D73116B1161171717170C0A0A0A15171717
                1717171717171717171717171717171713121317171717171717131212121212
                1212131717171717171312131713121317171717171713121317171717171717
                17171717171717171717171717171717171717171717174D116B11610C0C0C0C
                0C0505050C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C2D
                116B08110A0A0A0A0A0505050A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A1611345911224A4A4A4A4A1F1F4A4A4A4A4A4A4A4A4A4A4A4A
                4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A
                4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A
                4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A6411014011111E291F1F1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F4E6411701B2E5B08111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111170
                062E414119250811111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111235C1B2E2E}
              Color = clBtnFace
              PopupMenu = PopZhuangBei
              TabOrder = 14
              OnMouseDown = RzBmpButton1MouseDown
              OnMouseMove = RzBmpButton1MouseMove
              OnMouseUp = RzBmpButton1MouseUp
            end
            object RzBmpButton3: TRzBmpButton
              Left = 453
              Top = 465
              Width = 104
              Height = 26
              Cursor = crHandPoint
              Bitmaps.Disabled.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B00000001000077000000000000009999
                990066666600DFF7F5003D3E43002D2F32007C8786004A4A4A00A1A1A0000A05
                20006871700008012A007B839C00AEC2C000FFFFFF0025272800545458001415
                150020222B003A3A31008C8C8C008F9C9B00C4D5D300747B7B004C4D5100616B
                6B0015045B00ADB3B3000908110051586600110056008E969600CCE1E3002B24
                5D001C1F1E004E4E76009EA7A6003436390011034A00BFD0CE00434448006C6D
                7200A3ACAB0096A4B3000405050010044300BEBEBE000C0E0E0014045F003C3C
                3F007B8C84007D7E82005A5A5A000A0036002F323C0017191D005C5D8700E6FF
                FD0042424200D7EFED009DABBA006B6B6D0064656A0095A6A500B0BFBE003A3A
                3A005151520075757A00292A2E00C3D8DC0019057200B7CAD200838E9C001A0D
                53000F100F005E5F630002000A00A8A8AA008E9BA90085868900959699009D9E
                A1002022210033333300AEADAE00424A4A00636B7B00B8C3C200737E8C00D1E5
                E300545A5A00828A8900140557000F07390005021600100A2C00B4B4B400CEE1
                DF00424A42001919190084848400939393007B7B7C00474F4E00737474002929
                290008090800A4A4A40013131C00404551005B5C5F00BDD6CE004D4F5300C5DB
                D900838DA400B5C1C000BBCFD500D3E7E50016075E0000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002D2D5F373737
                3737373737373737373737373737373737373737373737373737373737373737
                3737373737373737373737373737373737373737373737373737373737373737
                3737373737373737373737373737373737373737373737373737373737373737
                5D5C35094A4A6344252525252525252525252525252525252525252525252525
                2525252525252525252525252525252525252525252525252525252525252525
                2525252525252525252525252525252525252525252525252525252525252525
                252525252569114A4A350B6A6A22313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                313131313131313131313131313141636A1C5E2C6A6363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6363636363636363636363636363636363636363636363636A6A4C004A636344
                0405413A3A3A3A3A0F0F3131313A3A3A3A3A2552053A3A3A3A3A2525313A4105
                0F22526969226363053A3A3A3A05222252413A41445263636363636363636363
                6363636363636363636363636363636363636363636363636363636363636363
                6A004C004A630F0707443118181818181807071818181818183A6969253A3A3A
                3A3A3A254107445269253A073A410505043A3A3A3A073125313131313A312563
                6363636363636363636363636363636363636363636363636363636363636363
                63636363636363636A004C4C1152251010530410101010101041254210101010
                28444453413A3A3A3A3A4153533A4144533A3A3A3A3A5325283A3A4153413A3A
                3A25250525313A22222222222222222222222222222222222222222222222222
                222222222222222222222222222222222F2C1C2F633A3434342828346E6E6E6E
                6E256928341042423105255252253A3A3A3A3A3A3A255252253A3A2552253A3A
                3A255252525252253A2552525252253A3A3A255252525252253A2552253A2552
                525252525252525252525252525252525252525252525252112F6C220F026E04
                424B283402020202020207071028040407696969693A0E0E0E0E0E0E0E3A6969
                3A0E0E3A413A0E0E0E3A41696969693A0E3A696969693A0E0E0E3A413A3A4169
                3A0E3A3A3A0E3A69696969696969696969696969696969696969696969696969
                52221253533D5A412828416E3D3D3D3D3D3D3D3D4B5A70704B050505053A0E3A
                3A3A3A3A0E3A0505413A3A0E3A413A3A3A0E3A050505053A0E3A05050505413A
                3A0E3A3A0E0E3A3A3A0E0E0E0E0E3A0505050505050505050505050505050505
                050505050505050505053667313E3E34073118296868684B3D68686868686868
                68252525253A0E3A3A3A3A3A0E3A25252525313A0E3A25253A0E3A252525253A
                0E3A25313A31313A3A0E3A313A3A0E0E0E0E3A3A3A0E3A252525252525252525
                2525252525252525252525252525252528676D1967673E662929666666686E28
                704B3D686866666666313131313A0E0E0E0E0E0E0E3A31313131313A0E3A3A31
                3A0E3A313131313A0E3A3A3A0E3A3A0E3A0E3A31313A0E3A3A0E3A3A3A0E3A31
                3131313131313131313131313131313131313131313131315A191D0634103D64
                646666664334072828074210103E66643D282828283A0E3A3A3A3A3A3A3A2828
                282828283A0E3A3A3A0E3A282828283A0E0E3A0E3A0E3A0E3A0E3A3A3A0E3A0E
                3A0E0E0E0E0E3A28282828282828282828282828282828282828282828282828
                0A06563F1966144F294B4B4B101818181818181818183E143E181818183A0E0E
                0E0E0E0E0E3A1818181818183A0E3A3A3A0E3A181818183A0E3A0E3A3A3A0E3A
                3A0E3A183A0E3A0E3A3A3A0E3A3A3A1818181818181818181818181818181818
                1818181818181818063F580D171465686E3E2929341010101010101010342964
                4B101010103A0E3A3A3A3A3A0E3A1010101010103A0E0E0E0E0E3A101010103A
                0E3A0E3A073A0E3A3A0E3A103A0E3A0E3A103A0E3A1010101010101010101010
                10101010101010101010101010101010150D48715B5050433E681450664B6E6E
                6E6E6E6E6E3E433D4B4B4B183A3A0E0E0E0E0E0E0E3A3A18183A3A3A3A0E3A3A
                3A3A3A3A186E6E3A0E0E3A0E3A0E3A0E3A0E3A183A3A3A3A3A183A0E3A3A3A18
                6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E2A714E3B1F080801
                646665086402020202020202020202020202023A0E0E3A3A3A3A3A3A3A3A0E3A
                3A0E0E0E0E0E0E0E0E0E0E0E3A02023A0E3A3A0E3A3A3A0E3A0E3A3A0E0E0E0E
                0E3A3A0E0E0E0E3A020202020202020202020202020202020202020202020202
                403B2B395165084D4D516B6B332929292929292929292929292929103A0E0E0E
                0E0E0E0E0E0E0E3A103A3A3A3A3A3A0E3A3A0E3A1029293A0E3A3A3A3A3A3A3A
                3A0E3A103A3A0E3A3A103A0E3A3A3A1029292929292929292929292929292929
                292929292929292927392B3924334F1401545454506643434343434343434343
                43434343343A3A3A3A0E3A3A3A3A3A3443434343433A0E3A34343A344343433A
                0E0E0E0E0E0E0E0E0E0E3A433A0E3A3443433A0E3A4343434343434343434343
                4343434343434343434343434343434327392B392A333333645054604D643333
                33333333333333333333333333333333343A3433333333333333333333343A34
                33333333333333343A3A3A3A3A3A3A3A3A3A3433343A34333333343A34333333
                33333333333333333333333333333333333333333333333327392B391B4F4F4F
                4F4F6B2E514F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F
                4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F
                4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F
                16397239731414141414512E5114141414141414141414141414141414141414
                1414141414141414141414141414141414141414141414141414141414141414
                1414141414141414141414141414141414141414141414141414141414141414
                141414141414141461392339755065656565012E6B6565656565656565656565
                6565656565656565656565656565656565656565656565656565656565656565
                6565656565656565656565656565656565656565656565656565656565656565
                6565656565656565656565656565652A3903267439591B01010101542E510101
                0101010101010101010101010101010101010101010101010101010101010101
                0101010101010101010101010101010101010101010101010101010101010101
                01010101010101010101010101010101010101010101570339721E2145393939
                3939393939393939393939393939393939393939393939393939393939393939
                3939393939393939393939393939393939393939393939393939393939393939
                3939393939393939393939393939393939393939393939393939393939393939
                3C76261A490C2039393939393939393939393939393939393939393939393939
                3939393939393939393939393939393939393939393939393939393939393939
                3939393939393939393939393939393939393939393939393939393939393939
                39393939393947383046}
              Bitmaps.Down.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B0000000100008B000000010011008D9B
                AB00080473003E447B00162B450001014200CCFFFF000806750001003A000404
                69000302620008069C00E6FFFD00B2C6D4000000330004005200557286000908
                A40025405A00060593006E809500130E430000002900333872000F0054000B1F
                38005C5D87009DABBA00CCE2E40006047B000A088C0001002100160FB6003348
                660003004A001F2944000202590046647A000E193000060484000A0883000802
                63000F0BB1002B245D003C5A72007C839C001F3D5A00565F8E00122340005976
                8900ABBECD0005062B00C3D8DC0012304F000703500096A4B30006034B001A13
                C50006112400D6F0F0006B779D003550690019057200010019005C6E84001B0E
                5300464F75000E0A99001D21430009066D0007045A0015055F00274561008DA9
                B500838DA400273B53001D324C004A5C7300110DA7000F0A9600606B94001031
                4A000C00400016203A00718D9D0009077A0019375400E0F9F800A8C4CB0095A6
                BB0042556B003D466A000C0732002A4863000F088F000D0AA4001412BB00535C
                8B00D2EAEE001613BD00333D5D00B7CAD200C1DCDF007E90A400223350001605
                5B001915C5004D567F00192142000F233A00415B7200808EA000173553000B01
                370008006B000B0B56000506660012044B00120DB6000F0DA00047657B001200
                5900091329001C2E4A003A4B640038556E008C9DB20019294A002A3E59007180
                930010104A005F6E85004F4F77001F204700120CAA00BBCFD50029325100FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000525285783131
                3131313131313131313131313131313131313131313131313131313131313131
                3131313131313131313131313131313131313131313131313131313131313131
                313131313131313131313131313131313131313131313131313131313131315A
                1518714425256E21808064646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                6464646464646464646464646464646464646464646464646464646464646464
                64646464643D25256E155C3D7D6816160E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E334B7D80535D4C1F1F161616160E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E161616161F1F125D302E263F3F0E
                36053836363636360E0E36363636363636360808080536363605050538383805
                0E0E0E0E0E16161608360505050516160E050505050E0E0E0E1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F3F3F
                042E30707A001F050516082222222222222222222222222222080E0E0E080822
                2208080808221616160E08080808161608080808080808080808080808080816
                16163F1616161616161616161616161616163F3F3F3F3F3F3F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F006D706D353A001605050E0E2222222222220E0E2222222222
                220E3F3F3F3F1608080808080808163F3F160808163F16080808163F3F3F3F3F
                1608163F3F3F3F16080808163F3F3F3F3F1608163F1608163F3F3F3F3F3F3F3F
                3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F0019356D353A1605050F05050F0F0F0F0F
                0F0E1F080F2222220E161F1F1F1F0806060606060606081F1F080606080E0E06
                0606080E1F1F1F1F0806081F1F1F1F08060606080E0E0E0E1F08060808080608
                1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F3F3F3F3F00193530567A05050E
                2224050F24242424242405052222080808081F1F1F1F0806080808080806081F
                1F0E0E0E06080E08080806081F1F1F1F0806081F1F1F1F0E0E0E060808060608
                08080606060606081F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F3F3F
                6D567B482636360E050505467474747474747474464636364646161616160806
                08080808080608161616160E0E0608161608060816161616080608160E0E0E0E
                0E0E060808080806060606080808060816161616161616161616161616161616
                1616161616161F3F04484B2C53364646220836450202020A4502020202020202
                020F0E0E0E0E0E06060606060606080E0E0E0E0E0E060808080806080E0E0E0E
                0E06080808060808060806080808080608080608080806080E0E0E0E0E0E0E0E
                0E0E0E0E0E0E0E0E0E0E0E0E0E0E161F4B2C7C10230846070707282828552922
                0F29020202020202022205050505050608080808080808050505050505050608
                0808060805050505050606080608060806080608080806080608060606060608
                050505050505050505050505050505050505050505050E167C104D5488057428
                2828282828290F0F0F0F46464645282807222222222208060606060606060822
                2222222222080608080806082222222208060806080505060808060822080608
                0608080806080805222222222222222222222222222222222222222222220808
                4D548349644528282845454574242424242424242424074F0724242424240806
                0808080808060824242424242408060606060608242424240806080608220806
                0808060824080608060824080608242424242424242424242424242424242424
                2424242424380505404981585B555E550955282809090909090909090909284F
                0709090922080806060606060606080822220808080806080808080808220909
                0806060806080608060806082208080808082208060808082209090909090909
                0909090909090909090909090924380514586F6642284F281D1E774E1E070202
                0202020202271E28020202020806060808080808080808060808060606060606
                0606060606080202080608080608080806080608080606060606080806060606
                0802020202020202020202020202020202020202020A24226766013B6B5E7777
                4343862077272727272727272727272727272727240806060606060606060606
                0824080808080808060808060824272708060808080808080808060824080806
                080824080608080824272727272727272727272727272727272727271D1D0A36
                7E3B370C61287776606060600B131313131313131313131313131313130A0808
                08080608080808080A13131313130806080A0A080A1313130806060606060606
                06060608130806080A1313080608131313131313131313131313131313131313
                13131313271D0924590C370C61451E0B2A393939760B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0A080A0B0B0B0B0B0B0B0B0B0B0A080A0B0B0B0B0B0B0B
                0A080808080808080808080A0B0A080A0B0B0B0A080A0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B13270224590C370C61741D1E0B2A6A6A6A110B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B1327020A590C370C2F0A0727
                130B76392A0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
                0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B13270246
                590C4A0C3C24451D27275F395F13131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313271D0924320C840C0D730A09020227204F1D1D1D1D1D1D1D1D1D1D1D
                1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D
                1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D
                1D1D1D1D1D1D1D1D1D1D1D1D1D0924170C5775870C32032424240A285E090A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0F50620C4A792B340C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                1B477969412D1C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C651A473E}
              Bitmaps.Hot.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A0000120B0000120B000000010000C70000000C07320096A4
                B3000504D900193754000C07930002027A004149BA00E6FFFD0055728600071C
                BD001D149C000C0040002C4AA0000905BC00130EC300FFFFFF000B19A0001223
                4000B6C9D1000D08840042556B001E2AAC000A06A6000705CC007182C2007180
                930004026C00170EBD0097A7F000203976001E12C600281EA7000E0A7B000C12
                8C001018960019316900D6F0F0000807D7000906B0002F27AF005058D3001230
                4F00191095000F186B000E0E7D0027456100616BEA000604DE003C5A7200100C
                E800050359001E14A9009DABBA000E08AD001E2582000605DE004F4F77002F36
                9C003C4D8B00C1DCDF00141D9B003439E4000806C5000B079C00281AB600ABBE
                F500080052000E203D0005036300100EE100808EA00059768900212EAF000D08
                8B0010235E00C3D8DC002114CB0010314A005F70B0004D5E9D003A4B64008E9E
                E0002818BF001D13A20046647A002F2FB3002F20B400130DAC00A8C4CB00595A
                85002B245D00B3C7F600130E4300100CD3002843870010005C000908E4002A3B
                55008091D2000A1FB9008D9BAB001D21430016095000142477002634B6001A13
                E4001B179400161E78002016D400545DE6002323A30000003B001924A5001D12
                B200E0F9F800100BA5000F099B002719AF00CBE1E3002C1EB1002B2BAE002119
                94003840AB002921BD000B08B6000F0AC7000F0ABC00142762008DA9B500271A
                C600718D9D003F45E5005F6E8500030270001810B3003550690047657B001A13
                DF002A486300415B72001F3D5A001810990034519600100BD2000D138E000D0A
                CF000D0AE7002331B30014006F002016BD002B21AD00121B9B0015065D004951
                C700BBCFD5006C77EC00110AB400262D8E00D3EAFA001A12CD002318A4001204
                4B00161F3E0079819A002C3D7B0017355300243E8E002A3E59002110DE005760
                E9000B0137000A17A200110B93000F00540020199C001B26A8002929B5002215
                B700130FED00121970002417AC002416CE001B11D7001620A0001B11AE001C2E
                4A0038556E0026426A00555DDC00838DA4002318C2001E306D00415F83001010
                4A001F204700152763004D5C7500375492000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000000B0BC2884747
                4747474747474747474747474747474747474747474747474747474747474747
                4747474747474747474747474747474747474747474747474747474747474747
                4747474747474747474747474747474747474747474747474747474747474714
                5CADAA655454C08E0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0CC588888B5C0087BAA6090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909635EBAA7A28A1DABABABABABABABABABABAB
                ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB
                ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB
                ABABABABABABABABABABABABABABABABABABABABABABABABBB8A118C672121B7
                93701568686868933C3C9393936868686868152270686868686815AF93934870
                3C9022B797909090706868686870229022486848B72221212121212121212121
                2121212121212121212121212121212121212121212121212121212121212121
                238C11A5B32C9078786A6E55555555555578555555555555552C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C2C
                2C2C2C2C2C2C2C2C7FA543292B2C6A27276AAE2727272727276A6A9627272727
                6E20202020202020202020202020202020202020202020202020202020202020
                2020202020202020202020202020202020202020202020202020202020202020
                202020202020202020202020202020204A2943292BAE969696AEAE9627272727
                272A2CAE961F1F1F6A20202020326F6F6F6F6F6F6F322020326F6F3220326F6F
                6F322020202020326F3220202020326F6F6F322020202020326F3220326F3220
                2020202020202020202020202020202020202020202020204A291103B356962A
                A0770A1F565656565656AEAEA00A2A2A0A202020206F0F0F0F0F0F0F0F6F2020
                6F0F0F6F326F0F0F0F6F32202020206F0F6F202020206F0F0F0F6F326F6F3220
                6F0F6F6F6F0F6F20202020202020202020202020202020202020202020202020
                C303B92D6B5633AC8D8DACB4565656565656565675335353B4131313136F0F6F
                6F6F6F6F0F6F1313326F6F0F6F326F6F6F0F6F131313136F0F6F13131313326F
                6F0F6F6F0F0F6F6F6F0F0F0F0F0F6F1313131313131313131313131313131313
                1313131313131313BF2D6130367575338DAC5340404040B4407B7B7B7B7B7B7B
                7B494949496F0F6F6F6F6F6F0F6F49494949326F0F6F49496F0F6F494949496F
                0F6F49326F32326F6F0F6F326F6F0F0F0F0F6F6F6F0F6F494949494949494949
                49494949494949494949494949494949A43050089D747152B1B152525252B874
                73B8B1B15252525252040404046F0F0F0F0F0F0F0F6F04040404046F0F6F4404
                6F0F6F040404046F0F6F446F0F6F6F0F6F0F6F04446F0F6F6F0F6F6F6F0F6F04
                0404040404040404040404040404040404040404040404043A08C48239731B81
                81BEBEBE95573F3F3F3F73737386BE81713F3F3F3F6F0F6F6F6F6F6F6F443F3F
                3F3F3F446F0F6F3F6F0F6F3F3F3F3F6F0F0F6F0F6F0F6F0F6F0F6F3F6F0F6F0F
                6F0F0F0F0F0F6F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F
                4F8284807A1EB54C1B9C9C9C351616161616161616161BB59C161616166F0F0F
                0F0F0F0F0F6F1616161616166F0F6F6F6F0F6F161616166F0F6F0F6F446F0F6F
                6F0F6F166F0F6F0F6F6F6F0F6F6F441616161616161616161616161616161616
                16161616161616164E801958066C6C0E7C7E0E0E262626262626262626260E9F
                7C262626266F0F6F6F6F6F6F0F6F2626262626266F0F0F0F0F0F6F262626266F
                0F6F0F6F1A6F0F6F6F0F6F266F0F6F0F6F266F0F6F2626262626262626262626
                262626262626262626262626262626261858463B99B6B67D0D7DB6B67D0D0D0D
                0D0D0D0D0D0D7D7D0D0D0D856F6F0F0F0F0F0F0F0F6F6F85856F6F6F6F0F6F6F
                6F6F6F6F850D0D6F0F0F6F0F6F0F6F0F6F0F6F856F6F6F6F6F856F0F6F6F6F85
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D623B642428898989
                5D91B6898F3E3E3E3E3E3E3E3E3E3E3E3E3E3E6F0F0F6F6F6F6F6F6F6F6F0F6F
                6F0F0F0F0F0F0F0F0F0F0F0F6F3E3E6F0F6F6F0F6F6F6F0F6F0F6F6F0F0F0F0F
                0F6F6F0F0F0F0F6F3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                51240107BC45456969696969911717171717171717171717171717056F0F0F0F
                0F0F0F0F0F0F0F6F056F6F6F6F6F6F0F6F6F0F6F0517176F0F6F6F6F6F6F6F6F
                6F0F6F056F6F0F6F6F056F0F6F6F6F0517171717171717171717171717171717
                17171717171717171C0701076D25252545696969452525252525252525252525
                25252525056F6F6F6F0F6F6F6F6F6F0525252525256F0F6F05056F052525256F
                0F0F0F0F0F0F0F0F0F0F6F256F0F6F0525256F0F6F2525252525252525252525
                252525252525252525252525252525251C0701076D0202020260B2B231020202
                02020202020202020202020202020202056F0502020202020202020202056F05
                02020202020202056F6F6F6F6F6F6F6F6F6F0502056F05020202056F05020202
                0202020202020202020202020202020202020202020202021C070107A92F2F2F
                2F2F92B2602F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                1C07BD079B2F2F2F2F2F60B2602F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F410738075B452F2F2F2F2FB2602F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F3D0772A19A0741832F2F2F2F6031372F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F
                2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2E9E07BDAD5A4B070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                34985F5F66A37607070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                0707070707070707070707070707070707070707070707070707070707070707
                07070707070712595F94}
              Bitmaps.TransparentColor = clOlive
              Bitmaps.Up.Data = {
                C60E0000424DC60E0000000000003604000028000000680000001A0000000100
                080000000000900A000000000000000000000001000000000000010021008893
                A5000000990019375400000058006B8599000000F0004F517200E2FCFA000000
                D7000000420001008D000000CC0001008300C1DCDF00171843002B3D8E00E6FF
                FD0001003A00010072001A1C9A000000C4000000BC00A8C4CB003A3668000000
                E50001004A0000003300292258008999F8000000AD00000066001B1ED2006E7B
                F10047657B00D6F0F00000005200A4B4BF000B1070005572860000002A000D0F
                F1002D3B5B0011304E00181A8B000C00460000006B003C5A7200657D8E000E11
                5F0085A0B100B6D0DA0001007B001B1EAA0038556E003A528400100054002E36
                5A00112B4900CAE0E200CCFFFF0001009300506C8300494872000F0058001732
                4D002E33E0000C023A00DEF7EF000000B5008DA9B5001F3D5A00ABC2C9005976
                89000000DF00030628007E95A3001B1EC5001E21F2002745610036445F000B0D
                52001524510015177C001E27490029428C00CAE3EB0018345200B1C3CB003048
                6E007178940095A2B4000E014A0021425A00BED4D8000000F6000200A300D7F0
                F70005083C00718D9D0094A5F8000E164B009FB9C600121A700012304F002A48
                630004063200CBE1E300060A2C0095ADB7001F314E0057738600DDF6F500080B
                460011146E00B5CEDE001B1EB8000E043B00364B63002E428B0021426300FFFF
                FF00000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000000000000000002D75506F4949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949494949
                4949494949494949494949494949494949494949494949494949494949492739
                5C40437622223710101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                1010101010101010101010101010101010101010101010101010101010101010
                10101010773722222A2D54365926131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                1313131313131313131313131313131313131313131313131313131313131313
                13131313131313131313131313136736360F4769650A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A52696E474700001224
                0A1A24242424241B1B24242424242424241A1B1204242424241A1A1A1A1A1A1B
                282812122828280A242424240A2828281A041A12120000000000000000000000
                000000000000000000000000000000000000000000000000000000000000006C
                47575757001B24241B1A0404040404040404040404040404041B1B1B0A0A0404
                040A1B12241B00001B1212040A0028121A040A0A0A1A120A0A0A0A0A0A1B1B1B
                1B00000028282828282828282828282828000000000000000000000000000000
                000000000000004B57416868280A0404121A0404040404040A0A040404040404
                1B1B1B1B0A0A0A041A121B1B0A0A001B0A0A0A0A0A1B1B0A0A0A1212121A1A12
                121B1B1B1212121B1B1B00282828282828282828282828282828000000000000
                0000000000000000000000000000004B683A2B2B1A040404041A041F1F1F1F1F
                0A1B1A040404040A281B2828281B121212121212121B28281B1B1B1B281B1212
                121B28282828281B1B1B282828281B1212121B28282828281B1B1B281B1B1B28
                2828282828282828282828282828282828282828282828282B3A03032E2E1A04
                1F241F2E2E2E2E2E2E242424241A1A1A1A1A282828123C3C3C3C3C3C3C121212
                123C3C1212123C3C3C121228282828123C1228282828123C3C3C121212121212
                123C1212123C122828282828282828282828282828282828282828282828286A
                03414F4F341F0A24241A1F34343434343434342E2E04042E1313121212123C12
                121212123C1212121212123C12121212123C1212121212123C12121212121212
                123C12123C3C1212123C3C3C3C3C121212121212121212121212121212121212
                12121212121212624F5D2F3613131F041A04343434342E34340D0D0D0D0D0D0D
                0D130A0A0A0A3C12121212123C120A0A0A0A0A0A3C121212123C120A0A0A0A0A
                3C12121212121212123C121212123C3C3C3C1212123C120A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A712F76273E04130B34340B0B0B0D2E0404
                2E34340D0B0B0B0B0D041A1A1A123C3C3C3C3C3C3C121A1A1A1A1A123C120A1A
                123C121A1A1A1A123C120A0A3C12123C123C121A0A0A3C12123C1212123C121A
                1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A1A51272263051F0D3D3D
                0B0B0B0B2E040404041F1F1F340B0B0D1F0A040404123C1212121212121A0404
                0404041A123C1204123C1204040404123C3C123C123C123C123C1204123C123C
                123C3C3C3C3C1204040404040404040404040404040404040404040404040431
                633046323D60600D343434131F1F1F1F1F1F1F1F1F0D600D1F1A1F1F1F123C3C
                3C3C3C3C3C121F1F1F1F1F1F123C1212123C121F1F1F1F123C123C121A123C12
                123C121F123C123C1212123C12121A1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F
                1F1F1F1F1F1F1F72464C486660600B340D0B0B131313131313131313130B600D
                1313131313123C12121212123C12131313131313123C3C3C3C3C121313131312
                3C123C1224123C12123C1213123C123C1213123C121313131313131313131313
                13131313131313131313131313131353176D0E331E45020B0B1E1E020D0D0D0D
                0D0D0D0D0B0B0B0D0D0D0D0412123C3C3C3C3C3C3C12120404121212123C1212
                12121212040D0D123C3C123C123C123C123C1204121212121204123C12121204
                0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D2C0E4823561616161E
                6045451E3D0B0B0B0B0B0B0B0B0B0B0B0B0B0B123C3C12121212121212123C12
                123C3C3C3C3C3C3C3C3C3C3C120B0B123C12123C1212123C123C12123C3C3C3C
                3C12123C3C3C3C120B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B14
                235E1161161515151515151E6060606060606060606060606060601F123C3C3C
                3C3C3C3C3C3C3C121F1212121212123C12123C121F6060123C12121212121212
                123C121F12123C12121F123C1212121F60606060606060606060606060606060
                6060606060606035113B11614545451509090915451E1E1E1E1E1E1E1E1E1E1E
                1E1E1E1E2E121212123C12121212122E1E1E1E1E1E123C122E2E122E1E1E1E12
                3C3C3C3C3C3C3C3C3C3C121E123C122E1E1E123C121E1E1E1E1E1E1E1E1E1E1E
                1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E74116B1161161616160C09090915161616
                1616161616161616161616161616161613121316161616161616161616131213
                1616161616161613121212121212121212121316131213161616131213161616
                16161616161616161616161616161616161616161616164D116B11610C0C0C0C
                0C4A4A4A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
                0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C20
                116B081109090909094A4A4A0909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090909090909090909090909090909090909090909090909090909
                0909090909090942113358112119191919190606191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919191919191919191919191919191919191919
                1919191919191919191919191919196411013F11111D29060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606060606060606060606060606
                0606060606060606060606060606060606060606064E6411701C2D5A08111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111170
                075C404018250811111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111111111111111111111111111111111111111111111111111111111
                1111111111235B1C2D2D}
              Color = clBtnFace
              PopupMenu = PopWebSite
              TabOrder = 15
              OnMouseDown = RzBmpButton3MouseDown
              OnMouseMove = RzBmpButton3MouseMove
              OnMouseUp = RzBmpButton3MouseUp
            end
          end
        end
      end
    end
  end
  object OpenDlg: TOpenDialog
    FileName = 'lsDefaultItemFilter.txt'
    Filter = #25991#26412#25991#20214'(*.txt)|*.txt'
    Left = 577
    Top = 303
  end
  object OpenDialog3: TOpenDialog
    Filter = #25152#26377#25991#20214'(*.*)|*.*'
    Left = 577
    Top = 359
  end
  object PopStartGame: TPopupMenu
    OnPopup = PopStartGamePopup
    Left = 248
    Top = 552
    object N1: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #26159#21542#26174#31034
      OnClick = N2Click
    end
  end
  object PopWebSite: TPopupMenu
    OnPopup = PopWebSitePopup
    Left = 424
    Top = 560
    object N3: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #26159#21542#26174#31034
      OnClick = N4Click
    end
  end
  object PopZhuangBei: TPopupMenu
    OnPopup = PopZhuangBeiPopup
    Left = 608
    Top = 576
    object N5: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = N5Click
    end
    object N6: TMenuItem
      Caption = #26159#21542#26174#31034
      OnClick = N6Click
    end
  end
  object PopContactUs: TPopupMenu
    OnPopup = PopContactUsPopup
    Left = 736
    Top = 576
    object N7: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = N7Click
    end
    object N8: TMenuItem
      Caption = #26159#21542#26174#31034
      OnClick = N8Click
    end
  end
  object PopRegister: TPopupMenu
    OnPopup = PopRegisterPopup
    Left = 368
    Top = 576
    object MenuItem1: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = MenuItem1Click
    end
    object N12: TMenuItem
      Caption = #26159#21542#26174#31034
      OnClick = N12Click
    end
  end
  object PopPass: TPopupMenu
    OnPopup = PopPassPopup
    Left = 480
    Top = 576
    object MenuItem3: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = MenuItem3Click
    end
    object N14: TMenuItem
      Caption = #26159#21542#26174#31034
      OnClick = N14Click
    end
  end
  object PopFindPass: TPopupMenu
    OnPopup = PopFindPassPopup
    Left = 592
    Top = 576
    object MenuItem5: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = MenuItem5Click
    end
    object N16: TMenuItem
      Caption = #26159#21542#26174#31034
      OnClick = N16Click
    end
  end
  object PopExit: TPopupMenu
    OnPopup = PopExitPopup
    Left = 704
    Top = 576
    object MenuItem7: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = MenuItem7Click
    end
    object N18: TMenuItem
      Caption = #26159#21542#26174#31034
      OnClick = N18Click
    end
  end
  object PopMized: TPopupMenu
    Left = 920
    Top = 120
    object N9: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = N9Click
    end
  end
  object PopClose: TPopupMenu
    Left = 864
    Top = 160
    object N10: TMenuItem
      Caption = #25353#38062#22270#29255
      OnClick = N10Click
    end
  end
  object sknLoadDlg: TOpenDialog
    Filter = '98k'#30331#24405#30382#32932#25991#20214'(*.98k_skn)|*.98k_skn'
    Left = 688
    Top = 104
  end
  object sknSaveDlg: TSaveDialog
    DefaultExt = '*.98k_skn'
    Filter = '98k'#30331#24405#30382#32932#25991#20214'(*.98k_skn)|*.98k_skn'
    Left = 640
    Top = 120
  end
  object pngLoadDlg: TOpenDialog
    Filter = '98k'#32972#26223#22270#29255'(*.png)|*.png'
    Left = 640
    Top = 440
  end
  object OpenFileDlg: TOpenDialog
    Filter = #25152#26377#25991#20214'(*.*)|*.*'
    Left = 752
    Top = 104
  end
  object OpenUpdateDlg: TOpenDialog
    Filter = #26356#26032#21015#34920#25991#20214'(*.txt)|*.txt'
    Left = 672
    Top = 224
  end
end
