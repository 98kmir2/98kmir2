{***************************************************************************}
{ TAdvStringGrid component                                                  }
{ for Delphi & C++Builder                                                   }
{ version 2.4.0.4 - rel. Jan 2003                                           }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 1996-2003                                          }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

{$I TMSDEFS.INC}

unit AdvGrid;

{$R ADVGRID.RES}
{$H+}                               
{$J+}

{$IFDEF DELPHI5_LVL}
{$DEFINE TMSUNICODE}
{$ENDIF}

interface

uses
  Windows, Graphics, SysUtils, Messages, Classes, Controls, Grids, ClipBrd,
  Dialogs, Printers, Forms, StdCtrls, Buttons, AdvUtil, ExtCtrls, IniFiles,
  AsgSpin, AsgEdit, ComCtrls, AdvObj, AsgCombo, RichEdit, CommCtrl, Registry,
  OleCtnrs, ShellApi, PictureContainer, AsgCheck, AsgHTMLE, BaseGrid, AdvXPVS
  {$IFNDEF DELPHI3_LVL} , OleAuto {$ENDIF}
  {$IFDEF DELPHI3_LVL} , ComObj, Winspool, ActiveX {$ENDIF}
  {$IFDEF DELPHI4_LVL} , ImgList, AsgDD {$ENDIF}
  {$IFDEF TMSUNICODE} , AsgUni {$ENDIF}
  {$IFDEF DELPHI6_LVL} , Variants {$ENDIF}
  {$IFDEF TMSDEBUG} , TMSUtil {$ENDIF}
  {$IFDEF TMSCODESITE} , CSIntf {$ENDIF}
  ;

const
  MAXCOLUMNS = 512;
  RTF_TWIPS = 1440;

  MAJ_VER = 2; // Major version nr.
  MIN_VER = 4; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 4; // Build nr.
  DATE_VER = 'Jan, 2003'; // Month version

var
  CF_GRIDCELLS: Word;

type
  TAdvStringGrid = class;

  PBoolArray = ^TBoolarray;
  TBoolArray = array[0..MAXCOLUMNS] of Boolean;
  TWidthArray = array[0..MAXCOLUMNS] of SmallInt;

  EAdvGridError = class(Exception);

  TAsgVAlignment = TVAlignment;

  TGetEditorTypeEvent = procedure(Sender:TObject;ACol,ARow: Integer;
    var AEditor:TEditorType) of object;

  TEllipsClickEvent = procedure(Sender:TObject;ACol,ARow: Integer;
    var S:string) of object;

  TButtonClickEvent = procedure(Sender:TObject;ACol,ARow: Integer) of object;

  TCheckBoxClickEvent = procedure(Sender:TObject;ACol,ARow: Integer;
    State: Boolean) of object;

  TRadioClickEvent = procedure(Sender:TObject;ACol,ARow,AIdx: Integer) of object;

  TComboChangeEvent = procedure(Sender: TObject; ACol,ARow,AItemIndex: Integer;
    ASelection: string) of object;

  TComboObjectChangeEvent = procedure(Sender:TObject;ACol,ARow,AItemIndex: Integer;
    ASelection: string; AObject: TObject) of object;

  TSpinClickEvent = procedure(Sender:TObject;ACol,ARow,
     AValue: Integer; UpDown: Boolean) of object;

  TFloatSpinClickEvent = procedure(Sender:TObject;ACol,ARow: Integer;
    AValue:Double; UpDown: Boolean) of object;

  TDateTimeSpinClickEvent = procedure(Sender:TObject;ACol,ARow: Integer;
    AValue:TDateTime;UpDown: Boolean) of object;

  TScrollHintType = (shNone,shVertical,shHorizontal,shBoth);

  TSortStyle = (ssAutomatic, ssAlphabetic, ssNumeric, ssDate, ssAlphaNoCase,
    ssAlphaCase, ssShortDateEU, ssShortDateUS, ssCustom, ssFinancial, ssAnsiAlphaCase,
    ssAnsiAlphaNoCase, ssRaw, ssHTML, ssImages, ssCheckBox
    {$IFDEF TMSUNICODE}
    , ssUnicode
    {$ENDIF}
    );

  TPrintPosition = (ppNone,ppTopLeft,ppTopRight,ppTopCenter,ppBottomLeft,
    ppBottomRight,ppBottomCenter);

  TPrintBorders = (pbNoborder,pbSingle,pbDouble,pbVertical,pbHorizontal,pbAround,
    pbAroundVertical,pbAroundHorizontal,pbCustom);

  TCellBorder = (cbTop,cbLeft,cbRight,cbBottom);

  TCellBorders = set of TCellBorder;

  TPrintMethod = (prPreview,prPrint,prCalcPrint,prCalcPreview);

  TSortDirection = (sdAscending,sdDescending);

  TAdvanceDirection = (adLeftRight,adTopBottom);

  TIntelliPan = (ipVertical,ipHorizontal,ipBoth,ipNone);

  TInsertPosition = (pInsertBefore,pInsertAfter);

  TScrollType = (ssNormal,ssFlat,ssEncarta);

  TGridLook = (glStandard,glSoft,glClassic,glTMS);

  TCanInsertRowEvent = procedure(Sender: TObject; ARow: Integer;
    var CanInsert: Boolean) of object;

  TAutoInsertRowEvent = procedure(Sender:TObject; ARow: Integer) of object;

  TCanAddRowEvent = procedure(Sender: TObject; var CanAdd: Boolean) of object;
  TAutoAddRowEvent = procedure(Sender:TObject; ARow: Integer) of object;

  TCanDeleteRowEvent = procedure(Sender: TObject; ARow: Integer;
    var CanDelete: Boolean) of object;

  TAutoDeleteRowEvent = procedure(Sender:TObject; ARow: Integer) of object;

  TAutoInsertColEvent = procedure(Sender:TObject; ACol: Integer) of object;

  TGridProgressEvent = procedure(Sender:TObject;progress: smallint) of object;

  TClipboardEvent = procedure(Sender:TObject; var Allow: Boolean) of object;

  TClickSortEvent = procedure(Sender:TObject; ACol: Integer) of object;

  TCanSortEvent = procedure(Sender:TObject; ACol: Integer; var DoSort: Boolean) of object;

  TNodeClickEvent = procedure(Sender:TObject; ARow,ARowreal: Integer) of object;

  TCustomCompareEvent = procedure(Sender:TObject; str1,str2:string;
    var Res: Integer) of object;

  TRawCompareEvent = procedure(Sender:TObject; ACol,Row1,Row2: Integer;
    var Res: Integer) of object;

  TGridFormatEvent = procedure(Sender : TObject; ACol: Integer;
    var AStyle:TSortStyle; var aPrefix,aSuffix:string) of object;

  TGridColorEvent = procedure(Sender: TObject; ARow, ACol: Integer;
    AState: TGridDrawState; ABrush: TBrush; AFont: TFont ) of object;

  TGridBorderEvent = procedure (Sender: TObject; ARow, ACol: Integer; APen: TPen;
    var Borders: TCellBorders) of object;

  TGridBorderPropEvent = procedure (Sender: TObject; ARow, ACol: Integer;
    LeftPen,TopPen,RightPen,BottomPen: TPen) of object;

  TGridAlignEvent = procedure (Sender: TObject; ARow, ACol: Integer;
    var HAlign: TAlignment;var VAlign: TAsgVAlignment) of object;

  TGridHintEvent = procedure (Sender:TObject; ARow, ACol: Integer;
    var hintstr:string) of object;

  TOleDragDropEvent = procedure (Sender:TObject; ARow, ACol: Integer; data:string;
    var Allow: Boolean) of object;

  TOleDropFileEvent = procedure(Sender: TObject; ARow, ACol: Integer; FileName: string;
    var Allow: Boolean) of object;

  TOleDragOverEvent = procedure (Sender:TObject; ARow, ACol: Integer;
    var Allow: Boolean) of object;

  TOleDragStartEvent = procedure (Sender:TObject; ARow, ACol: Integer) of object;
  TOleDragStopEvent =  procedure (Sender:TObject; OLEEffect: Integer) of object;

  TOleDropColEvent = procedure (Sender:TObject; ARow, ACol, DropCol: Integer) of object;

  TOleDroppedEvent = procedure (Sender:TObject; ARect: TGridRect) of object;

  TRowChangingEvent = procedure(Sender:TObject; OldRow, NewRow: Integer;
    var Allow: Boolean) of object;

  TColChangingEvent = procedure(Sender:TObject; OldCol, NewCol: Integer;
    var Allow: Boolean) of object;
    
  TCellChangingEvent = procedure(Sender:TObject; OldRow,OldCol,NewRow,NewCol: Integer;
    var Allow: Boolean) of object;

  TScrollHintEvent = procedure (Sender:TObject; ARow: Integer;var hintstr:string) of object;

  TGridPrintPageEvent = procedure (Sender:TObject; Canvas: TCanvas; PageNr,PageXSize,PageYSize: Integer) of object;

  TGridPrintStartEvent = procedure (Sender:TObject; NrOfPages: Integer;var FromPage,ToPage: Integer) of object;

  TGridPrintPageDoneEvent = procedure (Sender:TObject; Canvas: TCanvas; LastRow, LastRowOffset, LastPage, PageXSize,PageYSize: Integer) of object;

  TGridPrintCancelEvent = procedure(Sender: TObject; PageNr: Integer; var Cancel: Boolean) of object;

  TGridPrintNewPageEvent = procedure (Sender:TObject; ARow: Integer; var NewPage: Boolean) of object;

  TGridPrintColumnWidthEvent = procedure (Sender:TObject; ACol: Integer; var Width: Integer) of object;
  TGridPrintRowHeightEvent = procedure (Sender:TObject; ARow: Integer; var Height: Integer) of object;

  TOnResizeEvent = procedure (Sender:TObject) of object;

  {$IFDEF DELPHI4_LVL}
  TColumnSizeEvent = procedure (Sender:TObject; ACol: Integer; var Allow: Boolean) of object;
  TRowSizeEvent = procedure (Sender:TObject; ARow: Integer; var Allow: Boolean) of object;
  {$ENDIF}

  TEndColumnSizeEvent = procedure (Sender:TObject; ACol: Integer) of object;

  TUpdateColumnSizeEvent = procedure (Sender:TObject; ACol: Integer; var AWidth: Integer) of object;  
  
  TEndRowSizeEvent = procedure (Sender:TObject; ARow: Integer) of object;

  TClickCellEvent = procedure (Sender:TObject;ARow,ACol: Integer) of object;

  TDblClickCellEvent = procedure (Sender:TObject;ARow,ACol: Integer) of object;

  TCanEditCellEvent = procedure (Sender:TObject;ARow,ACol: Integer;var CanEdit: Boolean) of object;

  TIsFixedCellEvent = procedure (Sender:TObject;ARow,ACol: Integer;var IsFixed: Boolean) of object;
  TIsPasswordCellEvent = procedure (Sender:TObject;ARow,ACol: Integer;var IsPassword: Boolean) of object;

  TAnchorClickEvent = procedure(Sender:TObject;ARow,ACol: Integer; Anchor:string; var AutoHandle: Boolean) of object;

  TAnchorHintEvent = procedure(Sender:TObject;ARow,ACol: Integer;var Anchor:string) of object;

  TAnchorEvent = procedure(Sender:TObject;ARow,ACol: Integer; Anchor:string) of object;

  TCellControlEvent = procedure(Sender: TObject; ARow,ACol: Integer; CtrlID,CtrlType,CtrlVal: string) of object;

  TCellComboControlEvent = procedure(Sender: TObject; ARow,ACol: Integer; CtrlID,CtrlType,CtrlVal: string;
    Values: TStringList; var Edit: Boolean; var DropCount: Integer) of object;

  TCellValidateEvent = procedure(Sender: TObject; ACol, ARow: Integer;
                       var Value: String; var Valid: Boolean) of object;

  TCellsChangedEvent = procedure(Sender: TObject; R: TRect) of object;

  TGetCheckEvent = procedure(Sender: TObject; ACol,ARow: Integer; var Value: string) of object;

  TCustomCellDrawEvent = procedure(Sender: TObject; Canvas: TCanvas; ACol,ARow: Integer;
    AState: TGridDrawState; ARect: TRect; Printing: Boolean) of object;

  TCustomCellSizeEvent = procedure(Sender: TObject; Canvas: TCanvas; ACol,ARow: Integer;
    var ASize: TPoint; Printing: Boolean) of object;

  TDoFitToPageEvent = procedure(Sender:TObject;var ScaleFactor:Double;
    var Allow: Boolean) of object;

  TBeforeCellPasteEvent = procedure(Sender: TObject; ACol,ARow: Integer;
    var Value: string; var Allow: Boolean) of object;

  TFloatFormatEvent = procedure(Sender: TObject; ACol,ARow: Integer;var IsFloat: Boolean;
    var FloatFormat: string) of object;

  TFindParameters = (fnMatchCase,fnMatchFull,fnMatchRegular,fnDirectionLeftRight,
    fnMatchStart,fnFindInCurrentRow,fnFindInCurrentCol,fnIncludeFixed,fnAutoGoto,
    fnIgnoreHTMLTags,fnBackward,fnIncludeHiddenColumns);

  TCellHAlign = (haLeft,haRight,haCenter,haBeforeText,haAfterText,haFull);

  TCellVAlign = (vaTop,vaBottom,vaCenter,vaUnderText,vaAboveText,vaFull);
  TCellType = (ctBitmap,ctIcon,ctNone,ctImageList,ctCheckBox,ctDataCheckBox,
    ctRotated,ctDataImage,ctNode,ctRadio,ctEmpty,ctImages,ctPicture,ctFilePicture,
    ctValue,ctProgress,ctComment,ctButton,ctBitButton,ctVirtCheckBox,ctProgressPie);

  TFitToPage = (fpNever,fpGrow,fpShrink,fpAlways,fpCustom);

  TFindParams = set of TFindParameters;

  TStretchMode = (noStretch,Stretch,StretchWithAspectRatio,Shrink,ShrinkWithAspectRatio);

  TSortBlankPosition = (blFirst,blLast);

  {TCellGraphic}

  TCellGraphic = class(TPersistent)
  private
    FCellType: TCellType;
    FCellBitmap: TBitmap;
    FCellIcon: TIcon;
    FCellVAlign: TCellVAlign;
    FCellHAlign: TCellHAlign;
    FCellIndex: Integer;
    FCellTransparent: Boolean;
    FCellCreated: Boolean;
    FCellBoolean: Boolean;
    FCellAngle: Integer;
    FCellValue: Double;
    FCellErrFrom: SmallInt;
    FCellErrLen: SmallInt;
    FCellText: string;
    FCellVar: variant;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure SetBitmap(ABmp:TBitmap;Transparent: Boolean;hal:TCellHAlign;val:TCellVAlign);
    procedure SetPicture(APicture:TPicture;Transparent: Boolean;StretchMode:TStretchMode;padding: Integer;hal:TCellHAlign;val:TCellVAlign);
    procedure SetFilePicture(APicture:TFilePicture;Transparent: Boolean;stretchmode:TStretchMode;padding: Integer;hal:TCellHAlign;val:TCellVAlign);
    procedure SetImageIdx(idx: Integer;hal:TCellHAlign;val:TCellVAlign);
    procedure SetDataImage(idx: Integer;hal:TCellHAlign;val:TCellVAlign);
    procedure SetMultiImage(Col,Row,dir: Integer;hal:TCellHAlign;val:TCellVAlign;Notifier:TImageChangeEvent);
    procedure SetIcon(aicon:ticon;hal:TCellHAlign;val:TCellVAlign);
    procedure SetCheckBox(Value,Data,Flat: Boolean;hal:TCellHAlign;val:TCellVAlign);
    procedure SetAngle(AAngle:smallint);
    procedure SetButton(bw,bh: Integer;caption:string;hal:TCellHAlign;val:TCellVAlign);
    procedure SetBitButton(bw,bh: Integer;caption:string;Glyph: TBitmap;hal:TCellHAlign;val:TCellVAlign);
    function GetPictureSize(cw,rh: Integer;hastext: Boolean):TPoint;
    property CellIcon: TIcon read FCellIcon write FCellIcon;
    property CellBitmap: TBitmap read FCellBitmap write FCellBitmap;
    property CellVar: Variant read FCellVar write FCellVar;
  published
    property CellType: TCellType read FCellType write FCellType;
    property CellVAlign: TCellVAlign read FCellVAlign write FCellVAlign;
    property CellHAlign: TCellHAlign read FCellHAlign write FCellHAlign;
    property CellIndex: Integer read FCellIndex write FCellIndex;
    property CellTransparent: Boolean read FCellTransparent write FCellTransparent;
    property CellCreated: Boolean read FCellCreated write FCellCreated;
    property CellBoolean: Boolean read FCellBoolean write FCellBoolean;
    property CellAngle: Integer read FCellAngle write FCellAngle;
    property CellValue: Double read FCellValue write FCellValue;
    property CellErrFrom: SmallInt read FCellErrFrom write FCellErrFrom;
    property CellErrLen: SmallInt read FCellErrLen write FCellErrLen;
    property CellText: string read FCellText write FCellText;
  end;

  {TBands}

  TBands = class(TPersistent)
  private
    FPrint: Boolean;
    FActive: Boolean;
    FTotalLength: Integer;
    FSecondaryLength: Integer;
    FPrimaryLength: Integer;
    FSecondaryColor: TColor;
    FPrimaryColor: TColor;
    FOwner:TAdvStringGrid;
    procedure SetActive(const Value: Boolean);
    procedure SetPrimaryColor(const Value: TColor);
    procedure SetPrimaryLength(const Value: Integer);
    procedure SetSecondaryColor(const Value: TColor);
    procedure SetSecondaryLength(const Value: Integer);
  public
    constructor Create(AOwner:TAdvStringGrid);
  published
    property Active: Boolean read FActive write SetActive default False;
    property PrimaryColor: TColor read FPrimaryColor write SetPrimaryColor;
    property PrimaryLength: Integer read FPrimaryLength write SetPrimaryLength;
    property SecondaryColor: TColor read FSecondaryColor write SetSecondaryColor;
    property SecondaryLength: Integer read FSecondaryLength write SetSecondaryLength;
    property Print: Boolean read FPrint write FPrint;
  end;

  TNodeType = (cnFlat,cn3D,cnGlyph,cnLeaf);

  {TCellNode}

  TCellNode = class(TPersistent)
  private
    FColor: TColor;
    FNodeType: TNodeType;
    FNodeColor: TColor;
    FExpandGlyph: TBitmap;
    FContractGlyph: TBitmap;
    FOwner: TAdvStringGrid;
    FShowTree: Boolean;
    procedure SetExpandGlyph(Value: TBitmap);
    procedure SetContractGlyph(Value: TBitmap);
    procedure SetNodeType(Value: TNodeType);
    procedure SetShowTree(const Value: Boolean);
  public
    constructor Create(AOwner: TAdvStringGrid);
    destructor Destroy; override;
  published
    property Color: TColor read FColor write FColor;
    property NodeType: TNodeType read FNodeType write SetNodeType default cnFlat;
    property NodeColor: TColor read FNodeColor write FNodeColor;
    property ExpandGlyph: TBitmap read FExpandGlyph write SetExpandGlyph;
    property ContractGlyph: TBitmap read FContractGlyph write SetContractGlyph;
    property ShowTree: Boolean read FShowTree write SetShowTree;
  end;

  TControlStyle = (csClassic,csFlat,csWinXP,csBorland,csTMS,csGlyph,csTheme);

  TControlLook = class(TPersistent)
  private
    FGrid: TAdvStringGrid;
    FCheckBoxSize: Integer;
    FUnCheckedGlyph: TBitmap;
    FCheckedGlyph: TBitmap;
    FControlStyle: TControlStyle;
    FColor: TColor;
    FRadioSize: Integer;
    FRadioOffGlyph: TBitmap;
    FRadioOnGlyph: TBitmap;
    FFlatButton: Boolean;
    procedure SetCheckBoxSize(const Value: Integer);
    procedure SetControlStyle(const Value: TControlStyle);
    procedure SetCheckedGlyph(const Value: TBitmap);
    procedure SetUnCheckedGlyph(const Value: TBitmap);
    procedure SetColor(const Value: TColor);
    procedure SetRadioOffGlyph(const Value: TBitmap);
    procedure SetRadioOnGlyph(const Value: TBitmap);
    procedure SetRadioSize(const Value: Integer);
    procedure SetFlatButton(const Value: Boolean);
  public
    constructor Create(AOwner: TAdvStringGrid);
    destructor Destroy; override;
  published
    property Color: TColor read FColor write SetColor;
    property CheckedGlyph: TBitmap read FCheckedGlyph write SetCheckedGlyph;
    property UnCheckedGlyph: TBitmap read FUnCheckedGlyph write SetUnCheckedGlyph;
    property RadioOnGlyph: TBitmap read FRadioOnGlyph write SetRadioOnGlyph;
    property RadioOffGlyph: TBitmap read FRadioOffGlyph write SetRadioOffGlyph;
    property CheckSize: Integer read FCheckBoxSize write SetCheckBoxSize;
    property RadioSize: Integer read FRadioSize write SetRadioSize;
    property ControlStyle: TControlStyle read FControlStyle write SetControlStyle;
    property FlatButton: Boolean read FFlatButton write SetFlatButton;
  end;

  {TSizeWhileTyping}

  TSizeWhileTyping = class(TPersistent)
  private
    FHeight: Boolean;
    FWidth: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Height: Boolean read FHeight write FHeight default False;
    property Width: Boolean read FWidth write FWidth default False;
  end;

  {TMouseActions}

  TMouseActions = class(TPersistent)
  private
    FGrid: TAdvStringGrid;
    FColSelect: Boolean;
    FRowSelect: Boolean;
    FAllSelect: Boolean;
    FDirectEdit: Boolean;
    FDirectComboDrop: Boolean;
    FDisjunctRowSelect: Boolean;
    FDisjunctColSelect: Boolean;    
    FAllColumnSize: Boolean;
    FAllRowSize: Boolean;
    FCaretPositioning: Boolean;
    FSizeFixedCol: Boolean;
    FDisjunctCellSelect: Boolean;
    FRangeSelectAndEdit: Boolean;
    FNoAutoRangeScroll: Boolean;
    procedure SetDisjunctColSelect(const AValue: Boolean);
    procedure SetDisjunctRowSelect(const AValue: Boolean);
    procedure SetDisjunctCellSelect(const AValue: Boolean);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
  published
    property AllColumnSize: Boolean read FAllColumnSize write FAllColumnSize default False;
    property AllRowSize: Boolean read FAllRowSize write FAllRowSize default False;
    property AllSelect: Boolean read FAllSelect write FAllSelect default False;
    property CaretPositioning: Boolean read FCaretPositioning write FCaretPositioning default False;
    property ColSelect: Boolean read FColSelect write FColSelect default False;
    property DirectComboDrop: Boolean read FDirectComboDrop write FDirectComboDrop default False;
    property DirectEdit: Boolean read FDirectEdit write FDirectEdit default False;
    property DisjunctRowSelect: Boolean read FDisjunctRowSelect write SetDisjunctRowSelect default False;
    property DisjunctColSelect: Boolean read FDisjunctColSelect write SetDisjunctColSelect default False;
    property DisjunctCellSelect: Boolean read FDisjunctCellSelect write SetDisjunctCellSelect default False;
    property NoAutoRangeScroll: Boolean read FNoAutoRangeScroll write FNoAutoRangeScroll default False;
    property RangeSelectAndEdit: Boolean read FRangeSelectAndEdit write FRangeSelectAndEdit default False;
    property RowSelect: Boolean read FRowSelect write FRowSelect default False;
    property SizeFixedCol: Boolean read FSizeFixedCol write FSizeFixedCol default False;
  end;

  TColumnSizeLocation = (clRegistry,clIniFile);

  {TColumnSize}

  TColumnSize = class(TPersistent)
  private
    Owner: TComponent;
    FSave: Boolean;
    FKey : string;
    FSection : string;
    FStretch: Boolean;
    FStretchColumn: Integer;
    FSynchWithGrid: Boolean;
    {$IFDEF DELPHI4_LVL}
    FLocation: TColumnSizeLocation;
    {$ENDIF}
    procedure SetStretch(Value: Boolean);
  public
    constructor Create(AOwner:TComponent);
    destructor Destroy; override;
  published
    property Save: Boolean read FSave write FSave default False;
    property Key: string read FKey write FKey;
    property Section: string read FSection write FSection;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property StretchColumn: Integer read FStretchColumn write FStretchColumn default -1;
    property SynchWithGrid: Boolean read FSynchWithGrid write FSynchWithGrid default False;
    {$IFDEF DELPHI4_LVL}
    property Location: TColumnSizeLocation read FLocation write FLocation;
    {$ENDIF}
  end;

  THomeEndAction = (heFirstLastColumn,heFirstLastRow);

  {TNavigation}

  TNavigation = class(TPersistent)
  private
    FAllowInsertRow: Boolean;
    FAllowDeleteRow: Boolean;
    FAdvanceOnEnter: Boolean;
    FAdvanceInsert: Boolean;
    FAutoGotoWhenSorted: Boolean;
    FAutoGotoIncremental: Boolean;
    FAutoComboDropSize: Boolean;
    FAllowClipboardShortcuts: Boolean;
    FAllowRTFClipboard: Boolean;
    FAllowSmartClipboard: Boolean;
    FAllowClipboardAlways: Boolean;
    FAllowClipboardColGrow: Boolean;
    FAllowClipboardRowGrow: Boolean;
    FCopyHTMLTagsToClipboard: Boolean;
    FAdvanceDirection: TAdvanceDirection;
    FAdvanceAuto: Boolean;
    FCursorWalkEditor: Boolean;
    FMoveRowOnSort: Boolean;
    FImproveMaskSel: Boolean;
    FAlwaysEdit: Boolean;
    FInsertPosition:TInsertPosition;
    FLineFeedOnEnter: Boolean;
    FHomeEndKey: THomeEndAction;
    FKeepHorizScroll: Boolean;
    FAllowFMTClipboard: Boolean;
    FTabToNextAtEnd: Boolean;
    FEditSelectAll: Boolean;
    FTabAdvanceDirection: TAdvanceDirection;
    procedure SetAutoGoto(aValue: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property AllowInsertRow: Boolean read FAllowInsertRow write FAllowInsertRow default False;
    property AllowDeleteRow: Boolean read FAllowDeleteRow write FAllowDeleteRow default False;
    property AlwaysEdit: Boolean read FAlwaysEdit write FAlwaysEdit default False;
    property AdvanceOnEnter: Boolean read FAdvanceOnEnter write FAdvanceOnEnter default False;
    property AdvanceInsert: Boolean read FAdvanceInsert write FAdvanceInsert default False;
    property AutoGotoWhenSorted: Boolean read FAutoGotoWhenSorted write SetAutoGoto default False;
    property AutoGotoIncremental: Boolean read FAutoGotoIncremental write FAutoGotoIncremental default False;
    property AutoComboDropSize: Boolean read FAutoComboDropSize write FAutoComboDropSize default False;
    property AdvanceDirection: TAdvanceDirection read FAdvanceDirection write FAdvanceDirection;
    property AllowClipboardShortCuts: Boolean read FAllowClipboardShortcuts write FAllowClipboardShortcuts default False;
    property AllowSmartClipboard: Boolean read FAllowSmartClipboard write FAllowSmartClipboard default False;
    property AllowRTFClipboard: Boolean read FAllowRTFClipboard write FAllowRTFClipboard default False;
    property AllowFmtClipboard: Boolean read FAllowFMTClipboard write FAllowFMTClipboard default False;
    property AllowClipboardAlways: Boolean read FAllowClipboardAlways write FAllowClipboardAlways default False;
    property AllowClipboardRowGrow: Boolean read FAllowClipboardRowGrow write FAllowClipboardRowGrow default True;
    property AllowClipboardColGrow: Boolean read FAllowClipboardColGrow write FAllowClipboardColGrow default True;
    property AdvanceAuto: Boolean read FAdvanceAuto write FAdvanceAuto default False;
    property EditSelectAll: Boolean read FEditSelectAll write FEditSelectAll default True;
    property InsertPosition: TInsertPosition read FInsertPosition write FInsertPosition;
    property CursorWalkEditor: Boolean read FCursorWalkEditor write FCursorWalkEditor default False;
    property MoveRowOnSort: Boolean read FMoveRowOnSort write FMoveRowOnSort default False;
    property ImproveMaskSel: Boolean read FImproveMaskSel write FImproveMaskSel default False;
    property CopyHTMLTagsToClipboard: Boolean read FCopyHTMLTagsToClipboard write FCopyHTMLTagsToClipboard default True;
    property KeepHorizScroll: Boolean read FKeepHorizScroll write FKeepHorizScroll default False;
    property LineFeedOnEnter: Boolean read FLineFeedOnEnter write FLineFeedOnEnter default False;
    property HomeEndKey: THomeEndAction read FHomeEndKey write FHomeEndKey;
    property TabToNextAtEnd: Boolean read FTabToNextAtEnd write FTabToNextAtEnd;
    property TabAdvanceDirection: TAdvanceDirection read FTabAdvanceDirection write FTabAdvanceDirection;
  end;

  {THTMLSettings}

  THTMLSettings = class(TPersistent)
  private
    FSaveColor: Boolean;
    FSaveFonts: Boolean;
    FFooterFile: string;
    FHeaderFile: string;
    FBorderSize: Integer;
    FCellSpacing: Integer;
    FCellPadding: Integer;
    FTableStyle: string;
    FPrefixTag: string;
    FSuffixTag: string;
    FWidth: Integer;
    FColWidths: TIntList;
    FXHTML: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property ColWidths: TIntList read FColWidths;
  published
    property BorderSize: Integer read FBorderSize write FBorderSize default 1;
    property CellSpacing: Integer read FCellSpacing write FCellSpacing default 0;
    property CellPadding: Integer read FCellPadding write FCellPadding default 0;
    property SaveColor: Boolean read FSaveColor write FSaveColor default True;
    property SaveFonts: Boolean read FSaveFonts write FSaveFonts default True;
    property FooterFile: string read FFooterFile write FFooterFile;
    property HeaderFile: string read FHeaderFile write FHeaderFile;
    property TableStyle: string read FTableStyle write FTableStyle;
    property PrefixTag: string read FPrefixTag write FPrefixTag;
    property SuffixTag: string read FSuffixTag write FSuffixTag;
    property Width: Integer read FWidth write FWidth;
    property XHTML: Boolean read FXHTML write FXHTML;
  end;

  {TPrintSettings}

  TPrintSettings = class(TPersistent)
  private
    FTime: TPrintPosition;
    FDate: TPrintPosition;
    FPageNr: TPrintPosition;
    FPageNumSep: string;
    FDateFormat: string;
    FTitle: TPrintPosition;
    FFont: TFont;
    FHeaderFont: TFont;
    FFooterFont: TFont;
    FBorders: TPrintBorders;
    FBorderStyle: TPenStyle;
    FTitleText: string;
    FTitleLines: TStringList;
    FCentered: Boolean;
    FRepeatFixedRows: Boolean;
    FRepeatFixedCols: Boolean;
    FFooterSize: Integer;
    FHeaderSize: Integer;
    FLeftSize: Integer;
    FRightSize: Integer;
    FColumnSpacing: Integer;
    FRowSpacing: Integer;
    FTitleSpacing: Integer;
    FOrientation: TPrinterOrientation;
    FPagePrefix: string;
    FPageSuffix: string;
    FFixedHeight: Integer;
    FUseFixedHeight: Boolean;
    FFixedWidth: Integer;
    FUseFixedWidth: Boolean;
    FFitToPage:TFitToPage;
    FNoAutoSize: Boolean;
    FPrintGraphics: Boolean;
    FJobName: string;
    FNoAutoSizeRow: Boolean;
    FPageNumberOffset: Integer;
    FMaxPagesOffset: Integer;
    procedure SetPrintFont(Value: TFont);
    procedure SetPrintHeaderFont(Value: TFont);
    procedure SetPrintFooterFont(Value: TFont);
    procedure SetTitleLines(Value: TStringList);
  protected
  public
    constructor Create;
    destructor Destroy; override;
  published
    property FooterSize: Integer read FFooterSize write FFooterSize;
    property HeaderSize: Integer read FHeaderSize write FHeaderSize;
    property Time: TPrintPosition read FTime write FTime;
    property Date: TPrintPosition read FDate write FDate;
    property DateFormat: string read FDateFormat write FDateFormat;
    property PageNr: TPrintPosition read FPageNr write FPageNr;
    property Title: TPrintPosition read FTitle write FTitle;
    property TitleText : string read FTitleText write FTitleText;
    property TitleLines: TStringList read FTitleLines write SetTitleLines;
    property Font: TFont read FFont write SetPrintFont;
    property HeaderFont: TFont read FHeaderFont write SetPrintHeaderFont;
    property FooterFont: TFont read FFooterFont write SetPrintFooterFont;
    property Borders : TPrintBorders read FBorders write FBorders;
    property BorderStyle : TPenStyle read FBorderStyle write FBorderStyle;
    property Centered : Boolean read FCentered write FCentered;
    property RepeatFixedRows : Boolean read FRepeatFixedRows write FRepeatFixedRows;
    property RepeatFixedCols : Boolean read FRepeatFixedCols write FRepeatFixedCols;
    property LeftSize: Integer read FLeftSize write FLeftSize;
    property RightSize: Integer read FRightSize write FRightSize;
    property ColumnSpacing: Integer read FColumnSpacing write FColumnSpacing;
    property RowSpacing: Integer read FRowSpacing write FRowSpacing;
    property TitleSpacing: Integer read FTitleSpacing write FTitleSpacing;
    property Orientation: TPrinterOrientation read FOrientation write FOrientation;
    property PagePrefix: string read FPagePrefix write FPagePrefix stored True;
    property PageSuffix: string read FPageSuffix write FPageSuffix;
    property PageNumberOffset: Integer read FPageNumberOffset write FPageNumberOffset;
    property MaxPagesOffset: Integer read FMaxPagesOffset write FMaxPagesOffset;
    property FixedWidth: Integer read FFixedWidth write FFixedWidth;
    property FixedHeight: Integer read FFixedHeight write FFixedHeight;
    property UseFixedHeight: Boolean read FUseFixedHeight write FUseFixedHeight;
    property UseFixedWidth: Boolean read FUseFixedWidth write FUseFixedWidth;
    property FitToPage: TFitToPage read FFitToPage write FFitToPage;
    property JobName: string read FJobName write FJobName;
    property PageNumSep: string read FPageNumSep write FPageNumSep;
    property NoAutoSize: Boolean read FNoAutoSize write FNoAutoSize;
    property NoAutoSizeRow: Boolean read FNoAutoSizeRow write FNoAutoSizeRow;
    property PrintGraphics: Boolean read FPrintGraphics write FPrintGraphics;
  end;

  TBackGroundDisplay = (bdTile,bdFixed);
  TBackGroundCells = (bcNormal,bcFixed,bcAll);

  { TSortSettings }

  TSortSettings = class(TPersistent)
  private
    FGrid: TAdvStringGrid;
    FSortShow : Boolean;
    FSortIndexShow: Boolean;
    FSortFull : Boolean;
    FSortSingleColumn: Boolean;
    FSortIgnoreBlanks: Boolean;
    FSortBlankPos: TSortBlankPosition;
    FSortAutoFormat : Boolean;
    FSortDirection : TSortDirection;
    FSortUpGlyph: TBitmap;
    FSortDownGlyph: TBitmap;
    FIndexUpGlyph: TBitmap;
    FIndexDownGlyph: TBitmap;
    FSortNormalCellsOnly: Boolean;
    FSortFixedCols: Boolean;
    FSortColumn: Integer;
    FSortRow: Integer;
    FAutoColumnMerge: Boolean;
    FSortIndexColor: TColor;
    function GetDownGlyph: TBitmap;
    function GetUpGlyph: TBitmap;
    procedure SetDownGlyph(const Value: TBitmap);
    procedure SetUpGlyph(const Value: TBitmap);
    procedure SetSortRow(const Value: Integer);
    procedure SetIndexDownGlyph(const Value: TBitmap);
    procedure SetIndexUpGlyph(const Value: TBitmap);
  protected
  public
    constructor Create(AOwner: TAdvStringGrid);
    destructor Destroy; override;
  published
    property AutoColumnMerge: Boolean read FAutoColumnMerge write FAutoColumnMerge;
    property Column: Integer read FSortColumn write FSortColumn;
    property Show: Boolean read FSortShow write FSortShow;
    property IndexShow: Boolean read FSortIndexShow write FSortIndexShow;
    property IndexColor: TColor read FSortIndexColor write FSortIndexColor;
    property Full: Boolean read FSortFull write FSortFull;
    property SingleColumn: Boolean read FSortSingleColumn write FSortSingleColumn;
    property IgnoreBlanks: Boolean read FSortIgnoreBlanks write FSortIgnoreBlanks;
    property BlankPos: TSortBlankPosition read FSortBlankPos write FSortBlankPos;
    property AutoFormat: Boolean read FSortAutoFormat write FSortAutoFormat;
    property Direction: TSortDirection read FSortDirection write FSortDirection;
    property UpGlyph: TBitmap read GetUpGlyph write SetUpGlyph;
    property DownGlyph: TBitmap read GetDownGlyph write SetDownGlyph;
    property IndexUpGlyph: TBitmap read FIndexUpGlyph write SetIndexUpGlyph;
    property IndexDownGlyph: TBitmap read FIndexDownGlyph write SetIndexDownGlyph;
    property FixedCols: Boolean read FSortFixedCols write FSortFixedCols;
    property NormalCellsOnly: Boolean read FSortNormalCellsOnly write FSortNormalCellsOnly;
    property Row: Integer read FSortRow write SetSortRow;
  end;

  {TBackGround}

  TBackGround = class(TPersistent)
  private
    FGrid: TAdvStringGrid;
    FTop: Integer;
    FLeft: Integer;
    FDisplay: TBackGroundDisplay;
    FBackgroundCells: TBackgroundCells;
    procedure SetBitmap(Value: TBitmap);
    procedure SetTop(Value: Integer);
    procedure SetLeft(Value: Integer);
    procedure SetDisplay(Value: TBackgroundDisplay);
    procedure SetBackGroundCells(const Value: TBackgroundCells);
  private
    FBitmap: TBitmap;
  public
    constructor Create(AGrid: TAdvStringGrid);
    destructor Destroy; override;
  published
    property Top: Integer read FTop write SetTop;
    property Left: Integer read FLeft write SetLeft;
    property Display: TBackgroundDisplay read FDisplay write SetDisplay;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Cells: TBackgroundCells read FBackgroundCells write SetBackGroundCells;
  end;

  TEditStyle = (esInplace,esPopup);

  {TEditLink}

  TEditLink = class(TComponent)
  private
    FOwner: TAdvStringGrid;
    FWantKeyLeftRight: Boolean;
    FWantKeyUpDown: Boolean;
    FWantKeyHomeEnd: Boolean;
    FWantKeyPriorNext: Boolean;
    FWantKeyReturn: Boolean;
    FWantKeyEscape: Boolean;
    FEditStyle: TEditStyle;
    FPopupForm: TForm;
    FPopupWidth: Integer;
    FPopupHeight: Integer;
    FForcedExit: Boolean;
    FEditCell: TPoint;
    FTag: Integer;
    FAutoPopupWidth: Boolean;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure EditExit(Sender: TObject);
    procedure FormExit(Sender: TObject);
    function GetParent:TWinControl;
    function GetEditControl:TWinControl; virtual;
    function GetCellValue: string;
    procedure SetCellValue(s:string);
    procedure CreateEditor(AParent:TWinControl); virtual;
    procedure DestroyEditor; virtual;
    procedure HideEditor;
    procedure SetFocus(Value: Boolean); virtual;
    procedure SetRect(r:TRect); virtual;
    procedure SetVisible(Value: Boolean); virtual;
    procedure SetProperties; virtual;
    procedure SetCellProps(AColor: TColor; AFont: TFont); virtual;
    function GetEditorValue:string; virtual;
    procedure SetEditorValue(s:string); virtual;
    property Grid: TAdvStringGrid read FOwner;
    property EditCell:TPoint read FEditCell;
  published
    property AutoPopupWidth: Boolean read FAutoPopupWidth write FAutoPopupWidth;
    property EditStyle: TEditStyle read FEditStyle write FEditStyle;
    property PopupWidth: Integer read FPopupWidth write FPopupWidth;
    property PopupHeight: Integer read FPopupHeight write FPopupHeight;
    property WantKeyLeftRight: Boolean read FWantKeyLeftRight write FWantKeyLeftRight;
    property WantKeyUpDown: Boolean read FWantKeyUpDown write FWantKeyUpDown;
    property WantKeyHomeEnd: Boolean read FWantKeyHomeEnd write FWantKeyHomeEnd;
    property WantKeyPriorNext: Boolean read FWantKeyPriorNext write FWantKeyPriorNext;
    property WantKeyReturn: Boolean read FWantKeyReturn write FWantKeyReturn;
    property WantKeyEscape: Boolean read FWantKeyEscape write FWantKeyEscape;
    property Tag: Integer read FTag write FTag;
  end;

  TGetEditorPropEvent = procedure(Sender:TObject;ACol,ARow: Integer; AEditLink: TEditLink) of object;

  {TControlCombo}

  TControlCombo = class(TASGCombobox)
  protected
    procedure KeyPress(var Key: Char); override;
  end;

  {TControlEdit}

  TControlEdit = class(TEdit)
  protected
    procedure KeyPress(var Key: Char); override;
  end;

  {TGridCombo}

  TGridCombo = class(TASGCombobox)
  private
    Forced: Boolean;
    WorkMode: Boolean;
    ItemIdx: Integer;
    FOnReturnKey: TNotifyEvent;
    ItemChange: Boolean;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure DoExit; override;
    procedure WndProc(var Message: TMessage); override;
  public
    FGrid: TAdvStringGrid;
    procedure DoChange;
    constructor Create(AOwner: TComponent); override;
    procedure SizeDropDownWidth;
  published
    property OnReturnKey: TNotifyEvent read FOnReturnKey write FOnReturnKey;
  end;

  {TGridSpin}

  TGridSpin = class(TAsgSpinEdit)
  private
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
  protected
    procedure DoClick(UpDown: Boolean);
    procedure UpClick (Sender: TObject); override;
    procedure DownClick (Sender: TObject); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure Keypress(var Key: Char); override;
    procedure DoExit; override;
  published
  public
    FGrid: TAdvStringGrid;
    constructor Create(AOwner: TComponent); override;
  end;

  {$IFDEF TMSUNICODE}

  {TGridUniEdit}

  TGridUniEdit = class(TAsgUniEdit)
  private
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Keypress(var Key: Char); override;
    procedure DoExit; override;
  published
  public
    FGrid: TAdvStringGrid;
    constructor Create(AOwner: TComponent); override;
  end;

  TGridUniCombo = class(TASGUniCombobox)
  private
    Forced: Boolean;
    WorkMode: Boolean;
    ItemIdx: Integer;
    FOnReturnKey: TNotifyEvent;
    ItemChange: Boolean;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
  protected
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure DoExit; override;
    procedure WndProc(var Message: TMessage); override;
  public
    FGrid: TAdvStringGrid;
    procedure DoChange;
    constructor Create(AOwner: TComponent); override;
    procedure SizeDropDownWidth;
  published
    property OnReturnKey: TNotifyEvent read FOnReturnKey write FOnReturnKey;
  end;

  {$ENDIF}

  {TGridDateTimePicker}

  {$IFDEF DELPHI3_LVL}
  TGridDatePicker = class(TDateTimePicker)
  private
    FOldDropped: Boolean;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoExit; override;
  published
  public
    FGrid: TAdvStringGrid;
    constructor Create(AOwner: TComponent); override;
  end;
  {$ENDIF}

  {TGridCheckBox}

  TGridCheckBox = class(TCheckBox)
  private
    procedure WMLButtonDown(var Msg:TWMLButtonDown); message WM_LBUTTONDOWN;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoExit; override;
  published
  public
    FGrid: TAdvStringGrid;
    constructor Create(AOwner:tComponent); override;
  end;

  {TGridEditBtn}

  TGridEditBtn = class(TAsgEditBtn)
  private
    FGrid: TAdvStringGrid;
    procedure WMChar(var Msg:TWMChar); message WM_CHAR;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
  protected
    procedure ExtClick(Sender: TObject);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Keypress(var Key: Char); override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
  end;

  {TGridUnitEditBtn}

  TGridUnitEditBtn = class(TAsgUnitEditBtn)
  private
    FGrid: TAdvStringGrid;
    procedure WMChar(var Msg:TWMChar); message WM_CHAR;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
  end;

  {TGridButton}

  TGridButton = class(TButton)
  private
    FGrid:TAdvStringGrid;
  protected
    procedure WMLButtonUp(var Msg:TWMLButtonDown); message WM_LBUTTONUP;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
  published
  end;

  {TAdvInplaceEdit}

  TAdvInplaceEdit = class(TInplaceEdit)
  private
    FLengthLimit: SmallInt;
    FValign: Boolean;
    FWordWrap: Boolean;
    GotKey: Boolean;
    Workmode: Boolean;
    FGrid: TAdvStringGrid;
    procedure SetVAlign(Value: Boolean);
    procedure SetWordWrap(Value: Boolean);
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMKeyDown(var Msg:TWMKeydown); message WM_KEYDOWN;
    procedure WMKeyUp(var Msg:TWMKeydown); message WM_KEYUP;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMChar(var Msg:TWMKey); message WM_CHAR;
    procedure WMPaste(var Msg:TMessage); message WM_PASTE;
    procedure WMCopy(var Msg:TMessage); message WM_COPY;
    procedure WMCut(var Msg:TMessage); message WM_CUT;
    procedure CMWantSpecialKey(var Msg:TCMWantSpecialKey); message CM_WANTSPECIALKEY;
  protected
    procedure CreateParams(var Params:TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure UpdateContents; override;
    procedure BoundsChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoChange;
  published
    property VAlign: Boolean read FVAlign write SetVAlign;
    property WordWrap: Boolean read FWordwrap write SetWordWrap;
    property LengthLimit: smallint read FLengthLimit write FLengthLimit;
  end;

  {TFilterData}

  TFilterData = class(TCollectionItem)
  private
    FColumn: SmallInt;
    FCondition: string;
    FCaseSensitive: Boolean;
  public
    constructor Create(ACollection: TCollection); override;
  published
    property Column: smallint read FColumn write FColumn;
    property Condition:string read FCondition write FCondition;
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive default True;
  end;

  {TFilter}

  TFilter = class(TCollection)
  private
    FOwner: TAdvStringGrid;
    function GetItem(Index: Integer): TFilterData;
    procedure SetItem(Index: Integer; Value: TFilterData);
    function GetColFilter(Col: Integer): TFilterData;
  public
    constructor Create(AOwner: TAdvStringGrid);
    function Add: TFilterData;
    function Insert(index: Integer): TFilterData;
    property Items[Index: Integer]: TFilterData read GetItem write SetItem;
    property ColumnFilter[Col: Integer]: TFilterData read GetColFilter;
  protected
    {$IFDEF DELPHI3_LVL}
    function GetOwner: TPersistent; override;
    {$ELSE}
    function GetOwner: TPersistent;
    {$ENDIF}
  end;

  {TGridItem}

  TGridItem = class(TCollectionItem)
  private
    FIdx: Integer;
    FItems: TStrings;
    procedure SetIdx(const Value: Integer);
    procedure SetItems(const Value: TStrings);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property Idx: Integer read FIdx write SetIdx;
    property Items:tstrings read FItems write SetItems;
  end;

  {TAdvRichEdit}

  TAdvRichEdit = class(TRichEdit)
  private
    FGrid: TAdvStringGrid;
    FReqHeight: Integer;
    FReqWidth: Integer;
    FLocked: Boolean;
    procedure SelFormat(offset: Integer);
    procedure WMKillFocus(var Msg:TMessage); message WM_KILLFOCUS;
    procedure CNNotify(var Msg:TWMNotify); message CN_NOTIFY;
  protected
    procedure Lock;
    procedure Unlock;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SelSubscript;
    procedure SelSuperscript;
    procedure SelNormal;
  published
    property ReqWidth: Integer read FReqWidth;
    property ReqHeight: Integer read FReqHeight;
  end;

  TMouseSelectMode = (msNormal,msColumn,msRow,msAll,msURL,msResize);
  TClipOperation = (coCut,coCopy);

  {OLE Drag & Drop helper objects}

  {$IFDEF DELPHI4_LVL}
  TDragDropSettings = class(TPersistent)
  private
    FGrid: TAdvStringGrid;
    FOleDropRTF: Boolean;
    FOleAcceptText: Boolean;
    FOleEntireRows: Boolean;
    FOleDropSource: Boolean;
    FOleRemoveRows: Boolean;
    FOleAcceptFiles: Boolean;
    FOleDropTarget: Boolean;
    FOleInsertRows: Boolean;
    FOleCopyAlways: Boolean;
    FOleColumnDragDrop: Boolean;
    procedure SetOleDropRTF(const Value: Boolean);
    procedure SetOleDropTarget(const Value: Boolean);
  public
    constructor Create(AOwner: TAdvStringGrid);
  published
    property OleAcceptFiles: Boolean read FOleAcceptFiles write FOleAcceptFiles default False;
    property OleAcceptText: Boolean read FOleAcceptText write FOleAcceptText default False;
    property OleCopyAlways: Boolean read FOleCopyAlways write FOleCopyAlways default False;
    property OleDropTarget: Boolean read FOleDropTarget write SetOleDropTarget default False;
    property OleDropSource: Boolean read FOleDropSource write FOleDropSource default False;
    property OleEntireRows: Boolean read FOleEntireRows write FOleEntireRows default False;
    property OleInsertRows: Boolean read FOleInsertRows write FOleInsertRows default False;
    property OleRemoveRows: Boolean read FOleRemoveRows write FOleRemoveRows default False;
    property OleDropRTF: Boolean read FOleDropRTF write SetOleDropRTF default False;
    property OleColumnDragDrop: Boolean read FOleColumnDragDrop write FOleColumnDragDrop default False;
  end;

  TGridDropTarget = class(TASGDropTarget)
  private
    FGrid: TAdvStringGrid;
  public
    constructor Create(AGrid:TAdvStringGrid);
    procedure DropText(pt:TPoint;s:string); override;
    procedure DropCol(pt:TPoint;Col: Integer); override;
    procedure DropRTF(pt:TPoint;s:string); override;
    procedure DropFiles(pt:TPoint;files:tstrings); override;
    procedure DragMouseMove(pt:TPoint;var Allow: Boolean; DropFormats:TDropFormats); override;
    procedure DragMouseLeave; override;
  end;

  TGridDropSource = class(TASGDropSource)
  private
    FGrid:TAdvStringGrid;
    FLastEffect: Integer;
  public
    constructor Create(aGrid:TAdvStringGrid);
    procedure CurrentEffect(dwEffect: Longint); override;
    procedure QueryDrag; override;
  published
    property LastEffect: Integer read FLastEffect;
  end;
  {$ENDIF}

  {TGridChangeNotifier}

  TGridChangeNotifier = class(TComponent)
  protected
    procedure CellsChanged(R:TRect); virtual;
  end;

  {THTMLHintWindow}

  THTMLHintWindow = class(THintWindow)
  private
    FTextHeight, FTextWidth: Integer;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); Override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
  published
  end;

  { TFooterPanel }

  TFooterPanel = class(TCustomPanel)
  private
    FGrid: TAdvStringGrid;
  protected
    function HTMLColReplace(s:string):string;
    procedure PaintLastRow;
    procedure PaintColPreview;
    procedure PaintCustomPreview;
    procedure Paint; override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

  TFooterStyle = (fsFixedLastRow, fsColumnPreview, fsCustomPreview);

  { TFloatingFooter }

  TFloatingFooter = class(TPersistent)
  private
    FGrid: TAdvStringGrid;
    FHeight: Integer;
    FVisible: Boolean;
    FColor: TColor;
    FFooterStyle: TFooterStyle;
    FColumn: Integer;
    FCustomTemplate: string;
    procedure SetHeight(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetColor(const Value: TColor);
    procedure SetFooterStyle(const Value: TFooterStyle);
    procedure SetColumn(const Value: Integer);
    procedure SetCustomTemplate(const Value: string);
    function GetColumnCalc(c: Integer): TColumnCalcType;
    procedure SetColumnCalc(c: Integer; const Value: TColumnCalcType);
  protected
  public
    constructor Create(AOwner: TAdvStringGrid);
    destructor Destroy; override;
    procedure Invalidate;
    property Height: Integer read FHeight write SetHeight;
    property ColumnCalc[c: Integer]: TColumnCalcType read GetColumnCalc write SetColumnCalc;
  published
    property Color: TColor read FColor write SetColor;
    property Column: Integer read FColumn write SetColumn;
    property FooterStyle: TFooterStyle read FFooterStyle write SetFooterStyle;
    property CustomTemplate: string read FCustomTemplate write SetCustomTemplate;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  { TCellAlignment }

  TCellAlignment = record
    Alignment: TAlignment;
    VAlignment: TVAlignment;
  end;

  {TAdvStringGrid}

  TAdvStringGrid = class(TBaseGrid)
  private
    {$IFDEF FREEWARE}
    cla:string;
    {$ENDIF}
    FMoveColInd : Integer;
    FMoveRowInd : Integer;
    FGroupColumn : Integer;
    FGroupCaption : string;
    FGroupWidth : Integer;
    FAutoSize : Boolean;
    FAutoNumAlign : Boolean;
    FEnhTextSize : Boolean;
    FEditWithTags: Boolean;
    FOemConvert : Boolean;
    FLookup : Boolean;
    FLookupCaseSensitive: Boolean;
    FDeselectState : Boolean;
    FSelectionClick : Boolean;
    FMouseDown : Boolean;
    FCtrlDown: Boolean;
    FMouseResize: Boolean;
    FMouseDownMove: Boolean;
    FLookupHistory : Boolean;
    FEnhRowColMove : Boolean;
    FSizeWithForm : Boolean;
    FMultilineCells : Boolean;
    FSortRowXRef: TIntList;
    FMergedColumns: TIntList;
    FSelectedCells: TIntList;
    FOnGetCellColor: TGridColorEvent;
    FOnGetCellPrintColor: TGridColorEvent;
    FOnGetCellBorder: TGridBorderEvent;
    FOnGetCellPrintBorder: TGridBorderEvent;
    FOnGetAlignment: TGridAlignEvent;
    FOnGetFormat: TGridFormatEvent;
    FOnGetFloatFormat: TFloatFormatEvent;
    FOnGetCheckTrue: TGetCheckEvent;
    FOnGetCheckFalse: TGetCheckEvent;
    FOnGridHint: TGridHintEvent;
    FOnRowChanging: TRowChangingEvent;
    FOnColChanging: TColChangingEvent;
    FOnCellChanging: TCellChangingEvent;
    FOnShowHint: TShowHintEvent;
    FOnCanAddRow: TCanAddRowEvent;
    FOnAutoAddRow: TAutoAddRowEvent;
    FOnCanInsertRow: TCanInsertRowEvent;
    FOnAutoInsertRow: TAutoInsertRowEvent;
    FOnAutoInsertCol: TAutoInsertColEvent;
    FOnCanDeleteRow: TCanDeleteRowEvent;
    FOnAutoDeleteRow: TAutoDeleteRowEvent;
    {$IFDEF DELPHI4_LVL}
    FOnOleDrop: TOleDragDropEvent;
    FOnOleDrag: TOleDragDropEvent;
    FOnOleDragOver: TOleDragOverEvent;
    FOnOleDragStart: TOleDragStartEvent;
    FOnOleDragStop: TOleDragStopEvent;
    FOnOleDropCol: TOleDropColEvent;
    FOnOleDropped: TOleDroppedEvent;
    FGridDropTarget: TGridDropTarget;
    FOnOleDropFile: TOleDropFileEvent;
    {$ENDIF}
    FOnClickSort: TClickSortEvent;
    FOnCanSort: TCanSortEvent;
    FOnExpandNode: TNodeClickEvent;
    FOnContractNode: TNodeClickEvent;
    FCustomCompare: TCustomCompareEvent;
    FRawCompare: TRawCompareEvent;
    FOnClipboardPaste: TClipboardEvent;
    FOnClipboardCut: TClipboardEvent;
    FOnClipboardCopy: TClipboardEvent;
    FOnClipboardBeforePasteCell: TBeforeCellPasteEvent;
    FOnResize: TOnResizeEvent;
    FOnPrintStart: TGridPrintStartEvent;
    FOnPrintCancel: TGridPrintCancelEvent;
    FOnPrintPage: TGridPrintPageEvent;
    FOnPrintNewPage: TGridPrintNewPageEvent;
    FOnPrintPageDone: TGridPrintPageDoneEvent;
    FOnPrintSetColumnWidth: TGridPrintColumnWidthEvent;
    FOnPrintSetRowHeight: TGridPrintRowHeightEvent;
    FDoFitToPage: TDoFitToPageEvent;
    FOnClickCell: TClickCellEvent;
    FOnRightClickCell: TClickCellEvent;
    FOnDblClickCell: TDblClickCellEvent;
    FOnCanEditCell: TCanEditCellEvent;
    FOnIsFixedCell: TIsFixedCellEvent;
    FOnIsPasswordCell: TIsPasswordCellEvent;
    FOnAnchorClick: TAnchorClickEvent;
    FOnAnchorEnter: TAnchorEvent;
    FOnAnchorExit: TAnchorEvent;
    FOnAnchorHint: TAnchorHintEvent;
    FOnControlClick: TCellControlEvent;
    FOnControlEditDone: TCellControlEvent;
    FOnControlComboList: TCellComboControlEvent;
    FOnCellValidate: TCellValidateEvent;
    FOnCellsChanged: TCellsChangedEvent;
    FOnFileProgress: TGridProgressEvent;
    FOnFilterProgress: TGridProgressEvent;
    FOnRichEditSelectionChange: TNotifyEvent;
    FHintColor: TColor;
    FHintShowCells: Boolean;
    FHintShowLargeText: Boolean;
    FHintShowSizing: Boolean;
    FLastHintPos: TPoint;
    FRowIndicator: TBitmap;
    FSortIndexes: TSortIndexList;
    FBackGround:TBackGround;
    {$IFDEF DELPHI4_LVL}
    FDropSelection: TGridRect;
    FOleDropTargetAssigned: Boolean;
    {$ENDIF}
    {$IFDEF DELPHI3_LVL}
    ArwU,ArwD,ArwL,ArwR:TArRowWindow;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    FOnColumnSize:TColumnSizeEvent;
    FOnRowSize:TRowSizeEvent;
    FOnColumnMove:TColumnSizeEvent;
    FOnRowMove:TRowSizeEvent;
    {$ENDIF}
    FOnEndColumnSize: TEndColumnSizeEvent;
    FOnEndRowSize: TEndRowSizeEvent;
    FPrintSettings: TPrintSettings;
    FFastPrint: Boolean;
    FHTMLSettings: THTMLSettings;
    FBands: TBands;
    FNavigation: TNavigation;
    FColumnSize: TColumnSize;
    FScrollProportional: Boolean;
    FCellNode: TCellNode;
    FSizeWhileTyping: TSizeWhileTyping;
    FMouseActions: TMouseActions;
    FVisibleCol: TBoolArray;
    FAllColWidths: TWidthArray;
    FUpdateCount: Integer;
    FNumNodes: Integer;
    FNumHidden: Integer;
    FSelectionColor: TColor;
    FSelectionTextColor: TColor;
    FSelectionRectangle: Boolean;
    FSelectionRTFKeep: Boolean;
    FVAlignment: TVAlignment;
    FVAlign: DWORD;
    FURLShow: Boolean;
    FURLFull: Boolean;
    FURLColor: TColor;
    FURLEdit: Boolean;
    FGridImages: TImageList;
    FIntelliPan: TIntelliPan;
    FIntelliZoom: Boolean;
    FScrollType: TScrollType;
    FScrollColor: TColor;
    FScrollWidth: Integer;
    FScrollSynch: Boolean;
    FScrollHints: TScrollHintType;
    FIsFlat: Boolean;
    FRichEdit: TAdvRichEdit;
    FInplaceRichEdit: TAdvRichEdit;
    FFixedAsButtons: Boolean;
    FFixedCellPushed: Boolean;
    FPushedFixedCell: TRect;
    FPushedCellButton: TPoint;
    FShowSelection: Boolean;
    FHideFocusRect: Boolean;
    FFixedFont: TFont;
    FFixedRowAlways: Boolean;
    FFixedColAlways: Boolean;
    FColumnHeaders: TStringList;
    FRowHeaders: TStringList;
    FLookupItems: TStringList;
    FRowSelect: TList;
    FColSelect: TList;
    FFixedFooters: Integer;
    FFixedRightCols: Integer;
    FDelimiter:char;
    FPasswordChar:char;
    FJavaCSV: Boolean;
    FCheckTrue: String;
    FCheckFalse: String;
    FEnableHTML: Boolean;
    FEnableWheel: Boolean;
    FFlat: Boolean;
    FAnchorHint: Boolean;
    FSaveFixedCells: Boolean;
    FSaveHiddenCells: Boolean;
    FSaveVirtCells: Boolean;
    FSaveWithHTML: Boolean;
    FWordWrap: Boolean;
    FModified: Boolean;
    FEditDisable: Boolean;
    FEditChange: Boolean;
    FExcelStyleDecimalSeparator: Boolean;
    FHovering: Boolean;
    FFloatFormat: string;
    FOldCellText: string;
    FStartEditChar: Char;
    FOldCol,FOldRow: Integer;
    FOldModifiedValue: Boolean;
    FOldCursor: Integer;
    FBlockFocus: Boolean;
    FDblClk: Boolean;
    FOldSelection: TGridRect;
    FMoveSelection: TGridRect;
    FEntered: Boolean;
    FEditing: Boolean;
    FSpecialEditor: Boolean;
    FEditActive: Boolean;
    FValidating: Boolean;
    FFindBusy: Boolean;
    FComboIdx: Integer;
    SortDir: Integer;
    SortRow: Integer;
    SearchCell:TPoint;
    ResizeAssigned: Boolean;
    FPrintRect: TGridRect;
    FFindParams: TFindParams;
    SearchCache: string;
    SearchInc: string;
    FAnchor: string;
    ZoomFactor: Integer;
    ColchgFlg: Boolean;
    ColMoveFlg: Boolean;
    ColSizeFlg: Boolean;
    ColSized: Boolean;
    Rowsized: Boolean;
    Colclicked: longint;
    Rowclicked: longint;
    Colclickedsize: Integer;
    Rowclickedsize: Integer;
    Movecell: Integer;
    MoveOfsX: Integer;
    MoveOfsY: Integer;
    Clickposx: Integer;
    Clickposy: Integer;
    Clickposdx: Integer;
    Clickposdy: Integer;
    Invokedchange: Boolean;
    InvokedFocusChange: Boolean;
    wheelmsg: Cardinal;
    wheelscrl: Integer;
    wheelpan: Boolean;
    wheelpanpos: TPoint;
    wheeltimer: THandle;
    prevcurs: HIcon;
    FMouseSelectMode: TMouseSelectMode;
    FMouseSelectStart: Integer;
    FPrinterdriverfix: Boolean;
    PrevRect: TRect;
    Fontscalefactor:double;
    FPrintPageWidth: Integer;
    FPrintPageRect: TRect;
    FPrintColStart: Integer;
    FPrintColEnd: Integer;
    FPrintPageFrom: Integer;
    FPrintPageTo: Integer;
    FPrintPageNum: Integer;
    FExcelClipboardFormat: Boolean;
    FGridTimerID: Integer;
    FGridBlink: Boolean;
    FMaxEditLength: Integer;
    FLook: TGridLook;
    FContainer: TPictureContainer;
    FCellChecker: TAdvStringGridCheck;
    FImageCache: THTMLPictureCache;
    FCtrlXY: TPoint;
    FCtrlID: string;
    FCtrlType: string;
    FCtrlEditing: Boolean;
    MaxWidths: array[0..MAXCOLUMNS] of Integer;
    Indents: array[0..MAXCOLUMNS] of Integer;
    FOnGetEditorType: TGetEditorTypeEvent;
    FOnGetEditorProp: TGetEditorPropEvent;
    FOnEllipsClick: TEllipsClickEvent;
    FOnButtonClick: TButtonClickEvent;
    FOnCheckBoxClick: TCheckBoxClickEvent;
    FOnCheckBoxMouseUp: TCheckBoxClickEvent;
    FOnRadioClick: TRadioClickEvent;
    FOnRadioMouseUp: TRadioClickEvent;
    FOnComboChange: TComboChangeEvent;
    FOnComboCloseUp: TClickCellEvent;
    FOnComboObjectChange: TComboObjectChangeEvent;
    FOnSpinClick: TSpinClickEvent;
    FOnFloatSpinClick: TFloatSpinClickEvent;
    FOntimeSpinClick: TDateTimeSpinClickEvent;
    FOnDateSpinClick: TDateTimeSpinClickEvent;
    FEditLink: TEditLink;
    FEditControl: TControlEdit;
    FComboControl: TControlCombo;
    EditCombo: TGridCombo;
    EditSpin: TGridSpin;
    {$IFDEF TMSUNICODE}
    EditUni: TGridUniEdit;
    ComboUni: TGridUniCombo;
    {$ENDIF}
    EditCheck: TGridCheckbox;
    EditBtn: TGridEditBtn;
    UnitEditBtn: TGridUnitEditBtn;
    {$IFDEF DELPHI3_LVL}
    EditDate: TGridDatePicker;
    FOnScrollHint:TScrollHintEvent;
    {$ENDIF}
    GridButton: TGridButton;
    MoveButton: TPopupButton;
    EditControl: TEditorType;
    FGridItems: TCollection;
    FFilter: TFilter;
    FFilterActive: Boolean;
    FFilterFixedRows: Integer;
    FNotifierList: TList;
    FActiveCellShow: Boolean;
    FActiveCellFont: TFont;
    FXYOffset: TPoint;
    FOldSize: Integer;
    FSizeFixed: Boolean;
    FSizingFixed: Boolean;
    FSizeFixedX: Integer;
    FDisableChange: Boolean;
    FNilObjects: Boolean;
    FQuoteEmptyCells: Boolean;
    FAlwaysQuotes: Boolean;
    FSortSettings: TSortSettings;
    FSelectionRectangleColor: TColor;
    {$IFDEF DELPHI4_LVL}
    FDragDropSettings: TDragDropSettings;
    {$ENDIF}
    FControlLook: TControlLook;
    FOnGetCellBorderProp: TGridBorderPropEvent;
    FFooterPanel: TFooterPanel;
    FFloatingFooter: TFloatingFooter;
    FIntegralHeight: Boolean;
    FIsWinXP: Boolean;
    FCommentColor: TColor;
    FClearTextOnly: Boolean;
    FOnEditingDone: TNotifyEvent;
    FOnUpdateColumnSize: TUpdateColumnSizeEvent;
    FHTMLHint: Boolean;
    FAlwaysValidate: Boolean;
    FEnableBlink: Boolean;
    FOnGridResize: TNotifyEvent;
    FSizeGrowOnly: Boolean;
    FActiveCellColor: TColor;
    FSelectionResizer: Boolean;
    FMaxColWidth: Integer;
    FMinRowHeight: Integer;
    FMinColWidth: Integer;
    FMaxRowHeight: Integer;
    FOnCustomCellDraw: TCustomCellDrawEvent;
    FOnCustomCellSize: TCustomCellSizeEvent;
    FTMSGradFrom: TColor;
    FTMSGradTo: TColor;
    FUseHTMLHints: Boolean;
    FShowNullDates: Boolean;
    FICursor: THandle;
    FFixedRowHeight: Integer;
    FSelHidden: Boolean;
    FColumnOrder: TIntList;
    FAutoNumberDirection: TSortDirection;
    FAutoNumberOffset: Integer;
    FAutoNumberStart: Integer;
    FOldLeftCol: Integer;
    FOldTopRow: Integer;
    {$IFDEF TMSUNICODE}
    FUniLocale: LCID;
    FUniCmpFlgs: DWord;
    {$ENDIF}
    {$IFDEF FREEWARE}
    FFreewareCode: Integer;
    {$ENDIF}
    procedure NCPaintProc;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMLButtonUp(var Msg:TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Msg:TWMLButtonUp); message WM_RBUTTONUP;    
    procedure WMLButtonDown(var Msg:TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Msg:TWMLButtonDown); message WM_RBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
    procedure WMKeyUp(var Msg: TWMKeydown); message WM_KEYUP;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMPaint(var Msg: TWMPAINT); message WM_PAINT;
    procedure WMEraseBkGnd(var Message:TMessage); message WM_ERASEBKGND;
    procedure WMTimer(var Msg:TWMTimer); message WM_TIMER;
    procedure WMVScroll(var WMScroll:TWMScroll ); message WM_VSCROLL;
    procedure WMHScroll(var WMScroll:TWMScroll ); message WM_HSCROLL;
    procedure CMCursorChanged(var Message: TMessage); message CM_CURSORCHANGED;
    procedure CMHintShow(var Msg: TMessage); message CM_HINTSHOW;
    procedure CMDialogChar(var Msg: TCMDialogChar); message CM_DIALOGCHAR;
    procedure HideEditControl(ACol,ARow: Integer);
    procedure ShowEditControl(ACol,ARow: Integer);
    function IsEditable(ACol,ARow: Integer): Boolean;
    function IsPassword(ACol,ARow: Integer): Boolean;
    procedure HandleRadioClick(ACol,ARow,Xpos,Ypos: Integer);
    function HasStaticEdit(ACol,ARow: Integer): Boolean;
    procedure TabEdit(Dir: Boolean);
    function ToggleRadio(ACol,ARow: Integer; FromEdit: Boolean): Boolean;
    function GetInplaceEditor: TAdvInplaceEdit;
    procedure SetAutoSizeP(AAutoSize: Boolean);
    procedure SetFlat(const AValue: Boolean);
    procedure SetShowSelection(AValue: Boolean);
    procedure SetMaxEditLength(const AValue: Integer);
    procedure SetGroupColumn(AGroupColumn: Integer);
    procedure QuickSortRows(Col,Left,Right: Integer);
    procedure QuickSortRowsIndexed(Col,Left,Right: Integer);
    procedure SetVAlignment(AVAlignment:TVAlignment);
    function BuildPages(Canvas:TCanvas;PrintMethod:TPrintMethod;MaxPages: Integer;SelRows:Boolean): Integer;
    function Compare(Col,ARow1,ARow2: Integer): Integer;
    function CompareLine(Col,ARow1,ARow2: Integer): Integer;
    function CompareLineIndexed(Colidx,ARow1,ARow2: Integer): Integer;
    function MatchCell(Col,Row: Integer): Boolean;
    procedure ShowHintProc(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure DrawSortIndicator(Canvas:TCanvas;Col,x,y: Integer);
    procedure GridResize(Sender: TObject);
    function FreeCellGraphic(ACol,ARow: Integer): Boolean;
    function RemoveCellGraphic(ACol,ARow: Integer;CellType:TCellType): Boolean;
    function CreateCellGraphic(ACol,ARow: Integer): TCellGraphic;
    function GetCellImages(ACol,ARow: Integer): TIntList;
    function GetCellImageIdx(ACol,ARow: Integer): Integer;
    procedure SetInts(ACol,ARow: Integer;const Value: Integer);
    function GetInts(ACol,ARow: Integer): Integer;
    procedure SetFloats(ACol,ARow: Integer;const Value:double);
    function GetFloats(ACol,ARow: Integer):Double;
    procedure SetDates(ACol,ARow: Integer;const Value:TDateTime);
    function GetDates(ACol,ARow: Integer):TDateTime;
    procedure SetTimes(ACol,ARow: Integer;const Value:TDateTime);
    function GetTimes(ACol,ARow: Integer):TDateTime;
    function GetRowSelect(ARow: Integer): Boolean;
    procedure SetRowSelect(ARow: Integer;Value: Boolean);
    function GetRowSelectCount: Integer;
    procedure SelectToRowSelect(IsShift: Boolean);

    function GetColSelect(ACol: Integer): Boolean;
    procedure SetColSelect(ACol: Integer;Value: Boolean);
    function GetColSelectCount: Integer;
    procedure SelectToColSelect(IsShift: Boolean);

    function ButtonRect(ACol,ARow: Integer):TRect;

    procedure SetFixedFont(Value: TFont);
    procedure FixedFontChanged(Sender: TObject);
    procedure MultiImageChanged(Sender: TObject; ACol,ARow: Integer);
    procedure MergedColumnsChanged(Sender: TObject; ACol,ARow: Integer);
    procedure UndoColumnMerge;
    procedure ApplyColumnMerge;
    procedure RichSelChange(Sender: TObject);
    procedure SetColumnHeaders(Value: TStringList);
    procedure ColHeaderChanged(Sender: TObject);
    procedure SetRowHeaders(Value: TStringList);
    procedure RowHeaderChanged(Sender: TObject);
    function GetPrintColWidth(ACol: Integer): Integer;
    function GetPrintColOffset(ACol: Integer): Integer;
    procedure SetLookupItems(Value: TStringList);
    function PasteFunc(ACol,ARow: Integer): Integer;
    procedure CopyFunc(gd:TGridRect;DoDisjunct: Boolean);
    procedure CopyRTFFunc(ACol,ARow: Integer);
    procedure CopyBinFunc(gd:TGridRect);
    procedure SetPreviewPage(Value: Integer);
    function GetRowIndicator: TBitmap;
    procedure SetRowIndicator(Value: TBitmap);
    procedure SetBackground(Value: TBackground);
    procedure RTFPaint(ACol,ARow: Integer;Canvas:TCanvas;ARect:TRect);
    procedure DrawSizingLine(X: Integer);
    procedure FlatInit;
    procedure FlatDone;
    procedure FlatUpdate;
    procedure FlatSetScrollProp(index,newValue: Integer;fRedraw:bool);
    procedure FlatSetScrollInfo(code: Integer;var scrollinfo:tscrollinfo;fRedraw:bool);
    { procedure FlatSetScrollPos(code,pos: Integer); }
    procedure FlatShowScrollBar(code: Integer;show:bool);
    procedure UpdateVScrollBar;
    procedure UpdateHScrollBar;
    procedure UpdateType;
    procedure UpdateColor;
    procedure UpdateWidth;
    procedure SetScrollType(const Value: TScrollType);
    procedure SetScrollColor(const Value: TColor);
    procedure SetScrollWidth(const Value: Integer);
    procedure SetScrollProportional(Value: Boolean);
    procedure SetActiveCellShow(const Value: Boolean);
    procedure SetActiveCellFont(const Value: TFont);
    procedure SetXYOffset(const Value: TPoint);
    function GetLockFlag : Boolean;
    procedure SetLockFlag(AValue : Boolean);
    function InSizeZone(x,y: Integer): Boolean;
    function RemapCol(ACol: Integer): Integer;
    function RemapColInv(ACol: Integer): Integer;
    function RemapRow(ARow: Integer): Integer;
    function RemapRowInv(ARow: Integer): Integer;
    procedure SetVisibleCol(i: Integer; AValue: Boolean);
    function GetVisibleCol(i: Integer): Boolean;
    function MaxLinesInGrid: Integer;
    function MaxLinesInRow(ARow: Integer): Integer;
    function MaxCharsInCol(ACol: Integer): Integer;
    procedure SizeToLines(const ARow,Lines,Padding: Integer);
    procedure SizeToWidth(const ACol: Integer;inconly: Boolean);
    procedure SizeToHeight(const ARow: Integer;inconly: Boolean);
    function GetCellTextSize(ACol,ARow: Integer;VS: Boolean): TSize;
    function GetCellAlignment(ACol,ARow: Integer): TCellAlignment;
    procedure DrawIntelliFocusPoint;
    procedure EraseIntelliFocusPoint;
    procedure SetImages(Value:tImageList);
    procedure SetURLShow(Value: Boolean);
    procedure SetURLColor(Value: TColor);
    procedure SetURLFull(Value: Boolean);
    procedure SetLook(Value: TGridLook);
    procedure CalcTextPos(var ARect:TRect;AAngle: Integer;ATxt:String;hal: TAlignment;val:TVAlignment);
    procedure SetFixedFooters(Value: Integer);
    procedure SetFixedRightCols(Value: Integer);
    procedure SetFixedColWidth(Value: Integer);
    procedure SetRowCountEx(Value: Integer);
    function GetRowCountEx: Integer;
    procedure SetFixedRowsEx(Value: Integer);
    function GetFixedRowsEx: Integer;
    procedure SetColCountEx(Value: Integer);
    function GetColCountEx: Integer;
    procedure SetFixedColsEx(Value: Integer);
    function GetFixedColsEx: Integer;
    procedure SetHovering(Value: Boolean);
    function GetFixedColWidth: Integer;
    procedure SetFixedRowHeight(Value: Integer);
    function GetFixedRowHeight: Integer;
    procedure SetWordWrap(Value: Boolean);
    procedure SetSelectionColor(AColor: TColor);
    procedure SetSelectionTextColor(AColor: TColor);
    procedure SetSelectionRectangle(AValue: Boolean);
    procedure SetFilterActive(const Value: Boolean);
    procedure ApplyFilter;
    function GetCursorEx: TCursor;
    procedure SetCursorEx(const Value: TCursor);
    function GetCellsEx(i,j: Integer):string;
    procedure SetCellsEx(i,j: Integer;Value:string);
    function GetObjectsEx(i,j: Integer):TObject;
    procedure SetObjectsEx(i,j: Integer;aObject:TObject);
    function GetAllColWidths(i: Integer): Integer;
    procedure SetAllColWidths(i: Integer; const Value: Integer);
    function GetColors(i,j: Integer): TColor;
    procedure SetColors(i,j: Integer;AColor: TColor);
    function GetCellControls(i,j: Integer): TControl;
    procedure SetCellControls(i,j: Integer;AControl: TControl);
    function GetStrippedCell(i,j: Integer): string;
    function HiddenRow(j: Integer): TStrings;
    function PasteText(ACol,ARow: Integer;p:PChar): Integer;
    procedure InputFromCSV(FileName: string;insertmode: Boolean);
    procedure OutputToCSV(FileName: string;appendmode: Boolean);
    procedure OutputToHTML(FileName: string;appendmode: Boolean);
    procedure LoadXLS(filename,sheetname: string);
    procedure SaveXLS(filename,sheetname: string);
    {$IFDEF DELPHI3_LVL}
    function GetDateTimePicker:TDateTimePicker;
    procedure SetArrowColor(Value: TColor);
    function GetArrowColor: TColor;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    function PasteSize(p:PChar):TPoint;
    {$ENDIF}
    procedure MarkCells(s,tag:string;DoCase: Boolean; FromCol,FromRow,ToCol,ToRow: Integer);
    procedure UnMarkCells(tag:string;FromCol,FromRow,ToCol,ToRow: Integer);
    function GetUnSortedCell(i, j: Integer): string;
    procedure SetUnSortedCell(i, j: Integer; const Value: string);
    function GetDefRowHeightEx: Integer;
    procedure SetDefRowHeightEx(const Value: Integer);
    procedure SetIntegralHeight(const Value: Boolean);
    function GetSelectedCells(i, j: Integer): Boolean;
    procedure SetSelectedCells(i, j: Integer; const Value: Boolean);
    function GetSelectedCellsCount: Integer;
    function GetSelectedCell(i: Integer): TGridCoord;
    function GetFontColors(i, j: Integer): TColor;
    procedure SetFontColors(i, j: Integer; const Value: TColor);
    function GetAlignments(i, j: Integer): TAlignment;
    procedure SetAlignments(i, j: Integer; const Value: TAlignment);
    procedure SetActiveCellColor(const Value: TColor);
    procedure SetSelectionResizer(const Value: Boolean);
    function GetFontStyles(i, j: Integer): TFontStyles;
    procedure SetFontStyles(i, j: Integer; const Value: TFontStyles);
    function GetFontNames(i, j: Integer): string;
    function GetFontSizes(i, j: Integer): Integer;
    procedure SetFontNames(i, j: Integer; const Value: string);
    procedure SetFontSizes(i, j: Integer; const Value: Integer);
    procedure SetTMSGradFrom(const Value: TColor);
    procedure SetTMSGradTo(const Value: TColor);
    procedure SetUseHTMLHints(const Value: Boolean);
    procedure DoCalcFooter(ACol: Integer);
    procedure ControlExit(Sender: TObject);
    function GetCtrlVal(ACol, ARow: Integer; ID: string): string;
    procedure SetCtrlVal(ACol, ARow: Integer; ID: string;
      const Value: string);
    function GetAllColCount: Integer;
    function GetAllRowCount: Integer;
    function GetWideCells(i, j: Integer): widestring;
    procedure SetWideCells(i, j: Integer; const Value: widestring);
  protected
    FClipTopLeft: TPoint;
    FClipLastOp: TClipOperation;
    FScrollHintWnd: THTMLHintWindow;
    FScrollHintShow: Boolean;
    FVirtualCells: Boolean;
    FCellCache: string;
    procedure UpdateEditingCell(ACol,ARow: Integer; Value: string); virtual;
    procedure PasteInCell(ACol,ARow: Integer; Value: string); virtual;
    function GetCurrentCell: string; virtual;
    procedure SetCurrentCell(const AValue: string); virtual;
    procedure RestoreCache; virtual;
    function ToggleCheck(ACol,ARow: Integer; FromEdit: Boolean): Boolean; virtual;
    procedure AdvanceEdit(ACol,ARow: Integer;Advance,Show,Frwrd: Boolean);
    function IsFixed(ACol,ARow: Integer): Boolean; override;
    procedure GetVisualProperties(ACol,ARow: Integer; var AState: TGridDrawState; Print, Select,Remap: Boolean;
      ABrush: TBrush; AFont: TFont; var HA: TAlignment; var VA: TVAlignment; var WW: Boolean); override;
    function GetGraphicDetails(ACol,ARow: Integer; var W,H: Integer; var DisplText: Boolean;
      var HA: TCellHAlign;var VA: TCellVAlign): TCellGraphic;
    function GetFormattedCell(ACol,ARow: Integer): string; virtual;   
    function NodeIndent(ARow: Integer): Integer; override;
    function HasNodes: Boolean; override;
    procedure UpdateFooter;
    function GetCellType(ACol,ARow: Integer): TCellType; virtual;
    function GetCellGraphic(ACol,ARow: Integer): TCellGraphic; virtual;
    function GetCellGraphicSize(ACol,ARow: Integer): TPoint; virtual;
    function GetPrintGraphicSize(ACol,ARow,CW,RH: Integer;ResFactor: Double): TPoint; virtual;
    procedure DrawCell(ACol,ARow:longint;ARect:TRect;AState:TGridDrawState); override;
    procedure DrawGridCell(Canvas:TCanvas; ACol,ARow:longint;ARect:TRect;AState:TGridDrawState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    function CreateEditor: TInplaceEdit; override;
    function CanEditShow: Boolean; override;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
    function GetEditText(ACol, ARow: Longint): string; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ColumnMoved(FromIndex, ToIndex: longint); override;
    procedure RowMoved(FromIndex, ToIndex: longint); override;
    procedure KeyPress(var Key:char); override;
    procedure DestroyWnd; override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    function  SelectCell(ACol, ARow: longint): Boolean; override;
    procedure WndProc(var Message:tMessage); override;
    procedure SizeChanged(OldColCount, OldRowCount: longint); override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    {$IFDEF DELPHI4_LVL}
    procedure CalcSizingState(X, Y: Integer; var State: TGridState;
      var Index: Integer; var SizingPos, SizingOfs: Integer;
      var FixedInfo: TGridDrawInfo); override;
    {$ENDIF}
    procedure EditProgress(Value: string; pt: TPoint; SelPos: Integer); virtual;
    procedure DoInsertRow(ARow: Integer); virtual;
    procedure DoDeleteRow(ARow: Integer); virtual;
    procedure Click; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Paint; override;
    procedure ColWidthsChanged; override;
    procedure RowHeightsChanged; override;
    procedure InvalidateGridRect(r:TGridRect);
    procedure TopLeftChanged; override;
    procedure FloatFooterUpdate; override;
    procedure UpdateColSize(ACol: Integer; var NewWidth: Integer); virtual;
    procedure UpdateAutoColSize(ACol: Integer; var NewWidth: Integer); virtual;
    procedure UpdateColHeaders; virtual;
    function EllipsClick(s:string):string; virtual;
    function MatchFilter(ARow: Integer): Boolean; virtual;
    procedure PasteNotify(orig:TPoint;gr:TGridRect; LastOp:TClipOperation); virtual;
    function CalcCell(ACol,ARow: Integer):string; virtual;
    function SaveCell(ACol,ARow: Integer):string; virtual;
    procedure LoadCell(ACol,ARow: Integer; Value: string); virtual;
    procedure UpdateCell(ACol,ARow: Integer); virtual;
    procedure InitValidate(ACol,ARow: Integer); virtual;
    procedure CellsChanged(R:TRect); virtual;
    procedure CellsLoaded; virtual;
    procedure GetCellHint(ACol,ARow: Integer; var AHint: string); virtual;
    procedure GetCellColor(ACol,ARow: Integer;AState: TGridDrawState; ABrush: TBrush; AFont: TFont); virtual;
    procedure GetCellPrintColor(ACol,ARow: Integer;AState: TGridDrawState; ABrush: TBrush; AFont: TFont); virtual;
    procedure GetCellBorder(ACol,ARow: Integer; APen:TPen;var Borders: TCellBorders); virtual;
    procedure GetCellPrintBorder(ACol,ARow: Integer; APen:TPen;var Borders: TCellBorders); virtual;
    procedure GetCellAlign(ACol,ARow: Integer;var HAlign: TAlignment;var VAlign: TVAlignment); virtual;
    procedure GetColFormat(ACol: Integer;var AStyle:TSortStyle;var aPrefix,aSuffix:string); virtual;
    procedure GetCellEditor(ACol,ARow: Integer;var AEditor:TEditorType); virtual;
    procedure GetCellFixed(ACol,ARow: Integer;var IsFixed: Boolean); virtual;
    procedure GetCellReadOnly(ACol,ARow: Integer;var IsReadOnly: Boolean); virtual;
    procedure GetCellPassword(ACol,ARow: Integer;var IsPassword: Boolean); virtual;
    function GetCheckTrue(ACol,ARow: Integer): string; virtual;
    function GetCheckFalse(ACol,ARow: Integer): string; virtual;
    function GetFilter(ACol: Integer): Boolean; virtual;
    function GetSaveStartCol: Integer;
    function GetSaveStartRow: Integer;
    function GetSaveEndCol: Integer;
    function GetSaveEndRow: Integer;
    function GetSaveRowCount: Integer;
    function GetSaveColCount: Integer;
    procedure IRemoveRows(RowIndex, RCount: Integer);
    procedure StretchColumn(ACol: Integer);
    procedure PrivatePrintRect(Gridrect:TGridRect; SelRows: Boolean);
    procedure PrivatePrintPreviewRect(Canvas:TCanvas; Displayrect:TRect; Gridrect:TGridRect; SelRows: Boolean);
    procedure DoneEditing;
    procedure UpdateActiveCells(co,ro,cn,rn: Integer);
    function HasDataCell(ACol,ARow: Integer): Boolean;    
    {$IFDEF DELPHI5_LVL}
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    {$ENDIF}
  public
    LButFlg: Boolean;
    Compares: Integer;
    Swaps: Integer;
    SortTime: DWord;
    Sortlist: TStringList;
    PrevSizeX,PrevSizeY: Integer;
    EditMode: Boolean;
    procedure RegisterNotifier(ANotifier: TGridChangeNotifier);
    procedure UnRegisterNotifier(ANotifier: TGridChangeNotifier);
    procedure ClearComboString;
    procedure AddComboString(const s: string);
    procedure AddComboStringObject(const s: string; AObject: TObject);
    function RemoveComboString(const s: string): Boolean;
    function SetComboSelectionString(const s: string): Boolean;
    procedure SetComboSelection(idx: Integer);
    function GetComboCount: Integer;
    constructor Create(AOwner:tComponent); override;
    destructor Destroy; override;
    procedure Invalidate; override;
    {$IFDEF DELPHI4_LVL}
    procedure Resize; override;
    {$ENDIF}
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    function GetVersionNr: Integer; virtual;
    function GetVersionString:string; virtual;
    function ValidateCell(const NewValue:string): Boolean; virtual;
    procedure RemoveRowsEx(RowIndex, RCount: Integer); virtual;
    procedure RemoveRows(RowIndex, RCount: Integer); virtual;
    procedure InsertRows(RowIndex, RCount: Integer); virtual;
    procedure RemoveCols(ColIndex, CCount: Integer); virtual;
    procedure InsertCols(ColIndex, CCount: Integer); virtual;
    procedure AddColumn;
    procedure AddRow;
    procedure FilterRow(ARow: Integer);
    function GetParentRow(ARow: Integer): Integer;
    procedure InsertChildRow(ARow: Integer);
    procedure RemoveChildRow(ARow: Integer);
    procedure RemoveSelectedRows;
    procedure RemoveUnSelectedRows;
    procedure RemoveDuplicates(ACol: Integer; DoCase: Boolean);
    procedure MergeCols(ColIndex1, ColIndex2 : Integer);
    procedure MergeColumnCells(ColIndex: Integer; MainMerge: Boolean);
    procedure SplitColumnCells(ColIndex: Integer);
    procedure MergeRowCells(RowIndex: Integer; MainMerge: Boolean);
    procedure SplitRowCells(RowIndex: Integer);
    procedure SplitAllCells;
    procedure SwapColumns(ACol1,ACol2: Integer);
    procedure HideColumn(ColIndex: Integer);
    procedure UnHideColumn(ColIndex: Integer);
    procedure HideColumns(FromCol,ToCol: Integer);
    procedure UnHideColumns(FromCol,ToCol: Integer);
    procedure UnHideColumnsAll;
    function IsHiddenColumn(Colindex: Integer): Boolean;
    function NumHiddenColumns: Integer;
    procedure RepaintRect(r:TRect);
    procedure RepaintCell(c,r: Integer);
    procedure RepaintRow(ARow: Integer);
    procedure RepaintCol(ACol: Integer);
    procedure GroupCalc(Colindex,method: Integer);
    procedure GroupSum(Colindex: Integer);
    procedure GroupAvg(Colindex: Integer);
    procedure GroupMin(Colindex: Integer);
    procedure GroupMax(Colindex: Integer);
    procedure GroupCount(ColIndex: Integer);
    procedure Group(Colindex: Integer);
    procedure UnGroup;
    procedure HideRow(Rowindex: Integer);
    procedure HideRows(FromRow,ToRow: Integer);
    procedure HideRowsEx(FromRow,ToRow: Integer);
    procedure UnHideRow(Rowindex: Integer);
    procedure UnHideRows(FromRow,ToRow: Integer);
    procedure UnHideRowsAll;
    procedure HideSelectedRows;
    procedure HideUnSelectedRows;
    function IsHiddenRow(Rowindex: Integer): Boolean;
    function NumHiddenRows: Integer;
    function RealRowIndex(ARow: Integer): Integer;
    function RealColIndex(ACol: Integer): Integer;
    function DisplRowIndex(ARow: Integer): Integer;
    function DisplColIndex(ACol: Integer): Integer;
    procedure SetColumnOrder;
    procedure ResetColumnOrder;
    {$IFDEF TMSDEBUG}
    procedure ShowColumnOrder;
    {$ENDIF}
    function UnSortedRowIndex(ARow: Integer): Integer;
    function SortedRowIndex(ARow: Integer): Integer;
    function GetRealCol: Integer;
    function GetRealRow: Integer;
    procedure ScreenToCell(pt:TPoint; var ACol,ARow: Integer);
    procedure HideSelection;
    procedure UnHideSelection;
    procedure ScrollInView(ColIndex,RowIndex: Integer);
    procedure MoveRow(FromIndex, ToIndex: Integer);
    procedure MoveColumn(FromIndex, ToIndex: Integer);
    procedure SwapRows(ARow1,ARow2: Integer);
    procedure SortSwapRows(ARow1,ARow2: Integer); virtual;
    procedure ClearRect(ACol1,ARow1,ACol2,ARow2: Integer); virtual;
    procedure Clear;
    procedure ClearRows(RowIndex, RCount: Integer);
    procedure ClearCols(ColIndex, CCount: Integer);
    procedure ClearNormalRows(RowIndex, RCount: Integer);
    procedure ClearNormalCols(ColIndex, CCount: Integer);
    procedure ClearNormalCells;
    procedure ClearSelection;
    procedure ClearRowSelect;
    procedure ClearColSelect;
    procedure SelectRows(RowIndex, RCount: Integer);
    procedure SelectCols(ColIndex, CCount: Integer);
    procedure SelectRange(FromCol,ToCol,FromRow,ToRow: Integer);
    procedure ClearSelectedCells;
    function IsCell(SubStr: String; var ACol, ARow: Integer): Boolean;
    procedure SaveToFile(FileName: String);
    procedure SaveToBinFile(FileName: String);
    procedure SaveToBinStream(Stream: TStream);
    procedure SaveRectToBinStream(Rect: TRect; Stream: TStream);
    procedure SaveToHTML(FileName: String);
    procedure AppendToHTML(FileName: String);
    procedure SaveToXML(FileName: String; ListDescr, RecordDescr:string;FieldDescr:TStrings);
    procedure SaveToASCII(FileName: String);
    procedure SaveToCSV(FileName: String);
    procedure AppendToCSV(FileName: String);
    procedure SaveToFixed(FileName: string;positions: TIntList);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(FileName: String);
    procedure LoadFromBinFile(FileName: String);
    procedure LoadFromBinStream(Stream: TStream);
    procedure LoadAtPointFromBinStream(Point: TPoint; Stream: TStream);
    procedure LoadFromCSV(FileName: String);
    procedure LoadFromFixed(FileName:string;positions:TIntList);
    procedure InsertFromCSV(FileName: String);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveColSizes;
    procedure LoadColSizes;
    procedure SaveColPositions;
    procedure LoadColPositions;
    procedure SavePrintSettings(Key,Section:string);
    procedure LoadPrintSettings(Key,Section:string);
    procedure CutToClipboard;
    procedure CutSelectionToClipboard;
    procedure CopyToClipBoard;
    procedure CopySelectionToClipboard;
    procedure PasteFromClipboard;
    procedure PasteSelectionFromClipboard;
    procedure ShowColumnHeaders; 
    procedure ClearColumnHeaders;
    procedure ShowRowHeaders;
    procedure ClearRowHeaders;
    procedure HideCellEdit;
    procedure ShowCellEdit;
    procedure RandomFill(DoFixed: Boolean;Rnd: Integer);
    procedure LinearFill(DoFixed: Boolean);
    procedure TextFill(DoFixed: Boolean; Txt: string);
    function HilightText(DoCase: Boolean; S,Text: string):string;
    function UnHilightText(S:string):string;
    procedure HilightInCell(DoCase: Boolean; Col,Row: Integer; HiText: string);
    procedure HilightInCol(DoFixed,DoCase: Boolean; Col: Integer; HiText: string);
    procedure HilightInRow(DoFixed,DoCase: Boolean; Row: Integer; HiText: string);
    procedure HilightInGrid(DoFixed,DoCase: Boolean; HiText: string);
    procedure UnHilightInCell(Col,Row: Integer);
    procedure UnHilightInCol(DoFixed: Boolean; Col: Integer);
    procedure UnHilightInRow(DoFixed: Boolean; Row: Integer);
    procedure UnHilightInGrid(DoFixed: Boolean);
    function MarkText(DoCase: Boolean; S,Text: string):string;
    function UnMarkText(S:string):string;
    procedure MarkInCell(DoCase: Boolean; Col,Row: Integer; HiText: string);
    procedure MarkInCol(DoFixed,DoCase: Boolean; Col: Integer; HiText: string);
    procedure MarkInRow(DoFixed,DoCase: Boolean; Row: Integer; HiText: string);
    procedure MarkInGrid(DoFixed,DoCase: Boolean; HiText: string);
    procedure UnMarkInCell(Col,Row: Integer);
    procedure UnMarkInCol(DoFixed: Boolean; Col: Integer);
    procedure UnMarkInRow(DoFixed: Boolean; Row: Integer);
    procedure UnMarkInGrid(DoFixed: Boolean);
    function CheckCells(FromCol,FromRow,ToCol,ToRow: Integer): Boolean;
    function CheckCell(Col,Row: Integer): Boolean;
    function CheckGrid(DoFixed: Boolean): Boolean;
    function CheckCol(DoFixed: Boolean; Col: Integer): Boolean;
    function CheckRow(DoFixed: Boolean; Row: Integer): Boolean;
    procedure Zoom(x: Integer);
    procedure SaveToXLS(Filename:string);
    procedure SaveToXLSSheet(Filename, SheetName:string);
    procedure LoadFromXLS(Filename:string);
    procedure LoadFromXLSSheet(Filename, SheetName:string);
    procedure LoadFromMDBTable(Filename, Table: string);
    procedure LoadFromMDBSQL(Filename, SQL: string);
    procedure SaveToDOC(Filename:string);
    procedure RichToCell(Col,Row: Integer; Richeditor:TRichEdit);
    function RichToString(Richeditor:TRichEdit):string;
    procedure CellToRich(Col,Row: Integer; Richeditor:TRichEdit);
    {$IFDEF ISDELPHI}
    function CellToReal(ACol,ARow: Integer): Real;
    {$ENDIF}
    procedure AutoSizeCells(const DoFixedCells: Boolean; const PaddingX,PaddingY: Integer);
    procedure AutoSizeColumns(const DoFixedCols: Boolean; const Padding: Integer);
    procedure AutoSizeCol(const ACol: Integer);
    procedure AutoSizeRows(const DoFixedRows: Boolean; const Padding: Integer);
    procedure AutoSizeRow(const ARow: Integer);
    procedure StretchRightColumn;
    procedure AutoNumberCol(const ACol: Integer);
    procedure AutoNumberRow(const ARow: Integer);
    function IsSelected(ACol,ARow: Integer): Boolean;
    function SelectedText:string;
    procedure ShowInplaceEdit;
    procedure HideInplaceEdit;
    procedure DoneInplaceEdit(Key:word; Shift:TShiftState);
    procedure QSort; virtual;
    procedure QSortIndexed; virtual;
    procedure QSortGroup; virtual;
    procedure InitSortXRef;
    procedure Print;
    procedure PrintRect(Gridrect:TGridRect);
    procedure PrintSelection;
    procedure PrintSelectedRows;
    procedure PrintSelectedCols;    
    procedure PrintPreview(Canvas:TCanvas;Displayrect:TRect);
    procedure PrintPreviewRect(Canvas:TCanvas; Displayrect:TRect; Gridrect:TGridRect);
    procedure PrintPreviewSelectedRows(Canvas:TCanvas; Displayrect:TRect);
    procedure PrintPreviewSelectedCols(Canvas:TCanvas; Displayrect:TRect);    
    procedure PrintPreviewSelection(Canvas:TCanvas; Displayrect:TRect);    
    procedure PrintDraw(Canvas:TCanvas;DrawRect:TRect);
    procedure PrintDrawRect(Canvas:TCanvas;DrawRect:TRect;Gridrect:TGridRect);
    procedure SortByColumn(Col: Integer);
    procedure QuickSort(Col,Left,Right: Integer);
    procedure QuickSortIndexed(Left,Right: Integer);
    function SortLine(Col,ARow1,ARow2: Integer): Boolean;
    function Search(s:string): Integer;
    function Find(StartCell:TPoint; s:string; FindParams: TFindParams): TPoint;
    function FindFirst(s:string; FindParams: TFindParams): TPoint;
    function FindNext: TPoint;
    function MapFontHeight(pointsize: Integer): Integer;
    function MapFontSize(Height: Integer): Integer;
    function CreateBitmap(ACol,ARow: Integer;transparent: Boolean;hal:TCellHalign;val:TCellValign):TBitmap;
    procedure AddBitmap(ACol,ARow: Integer;ABmp:TBitmap;Transparent: Boolean;hal:TCellHalign;val:TCellValign);
    procedure RemoveBitmap(ACol,ARow: Integer);
    function GetBitmap(ACol,ARow: Integer):TBitmap;
    function CreatePicture(ACol,ARow: Integer;transparent: Boolean;stretchmode:TStretchMode;padding: Integer;hal:TCellHalign;val:TCellValign):TPicture;
    procedure AddPicture(ACol,ARow: Integer;APicture:TPicture;transparent: Boolean;stretchmode:TStretchMode;padding: Integer;hal:TCellHalign;val:TCellValign);
    procedure RemovePicture(ACol,ARow: Integer);
    function GetPicture(ACol,ARow: Integer):TPicture;
    function CreateFilePicture(ACol,ARow: Integer;Transparent: Boolean;StretchMode:TStretchMode;padding: Integer;hal:TCellHalign;val:TCellValign):TFilePicture;
    procedure AddFilePicture(ACol,ARow: Integer;AFilePicture:TFilePicture;Transparent: Boolean;stretchmode:TStretchMode;padding: Integer;hal:TCellHalign;val:TCellValign);
    procedure RemoveFilePicture(ACol,ARow: Integer);
    function GetFilePicture(ACol,ARow: Integer):TFilePicture;
    procedure AddNode(ARow,Span: Integer);
    procedure RemoveNode(ARow: Integer);
    procedure RemoveAllNodes;
    function IsNode(ARow: Integer): Boolean;
    function GetNodeSpanType(ARow: Integer): Integer;
    function GetNodeState(ARow: Integer): Boolean;
    procedure SetNodeState(ARow: Integer;Value: Boolean);
    function GetNodeSpan(ARow: Integer): Integer;
    procedure SetNodeSpan(ARow, Span: Integer);
    procedure ExpandNode(ARow: Integer);
    procedure ContractNode(ARow: Integer);
    procedure ExpandAll;
    procedure ContractAll;
    procedure AddRadio(ACol,ARow,DirRadio,IdxRadio: Integer; sl:TStrings);
    function CreateRadio(ACol,ARow,DirRadio,IdxRadio: Integer): TStrings;
    procedure RemoveRadio(ACol,ARow: Integer);
    function IsRadio(ACol,ARow: Integer): Boolean;
    function GetRadioIdx(ACol,ARow: Integer;var IdxRadio: Integer): Boolean;
    function SetRadioIdx(ACol,ARow,IdxRadio: Integer): Boolean;
    function GetRadioStrings(ACol,ARow: Integer): TStrings;
    procedure AddImageIdx(ACol,ARow,Aidx: Integer;hal:TCellHalign;val:TCellValign);
    procedure RemoveImageIdx(ACol,ARow: Integer);
    function GetImageIdx(ACol,ARow: Integer;var idx: Integer): Boolean;
    procedure AddMultiImage(ACol,ARow,Dir: Integer;hal:TCellHalign;val:TCellValign);
    procedure RemoveMultiImage(ACol,ARow: Integer);
    procedure AddDataImage(ACol,ARow,Aidx: Integer;hal:TCellHalign;val:TCellValign);
    procedure RemoveDataImage(ACol,ARow: Integer);
    function HasDataImage(ACol,ARow: Integer): Boolean;
    procedure AddRotated(ACol,ARow: Integer; AAngle: Smallint; s: string);
    procedure SetRotated(ACol,ARow: Integer; AAngle: SmallInt);
    procedure RemoveRotated(ACol,ARow: Integer);
    function IsRotated(ACol,ARow: Integer;var aAngle: Integer): Boolean;
    function CreateIcon(ACol,ARow: Integer;hal:TCellHalign;val:TCellValign):ticon;
    procedure AddIcon(ACol,ARow: Integer;AIcon:TIcon;hal:TCellHalign;val:TCellValign);
    procedure RemoveIcon(ACol,ARow: Integer);
    procedure AddButton(ACol,ARow, bw, bh: Integer;Caption:string;hal:TCellHalign;val:TCellValign);
    procedure SetButtonText(ACol,ARow: Integer; Caption: string);
    procedure PushButton(ACol,ARow: Integer;push: Boolean);
    procedure RemoveButton(ACol,ARow: Integer);
    function HasButton(ACol,ARow: Integer): Boolean;
    procedure AddBitButton(ACol,ARow, bw, bh: Integer;Caption:string;Glyph: TBitmap;hal:TCellHalign;val:TCellValign);
    function CreateBitButton(ACol,ARow, bw, bh: Integer;Caption:string;hal:TCellHalign;val:TCellValign): TBitmap;
    procedure AddCheckBox(ACol,ARow: Integer;State,Data: Boolean);
//    procedure AddCheckBoxEx(ACol,ARow: Integer;State,Data: Boolean;HAlign: TCellHalign;VAlign: TCellVAlign);
    procedure RemoveCheckBox(ACol,ARow: Integer);
    function HasCheckBox(ACol,ARow: Integer): Boolean;
    function HasDataCheckBox(ACol,ARow: Integer): Boolean;
    function GetCheckBoxState(ACol,ARow: Integer;var state: Boolean): Boolean;
    function SetCheckBoxState(ACol,ARow: Integer;state: Boolean): Boolean;
    function ToggleCheckBox(ACol,ARow: Integer): Boolean;
    procedure AddProgress(ACol,ARow: Integer;FGColor,BKColor: TColor);
    procedure AddProgressEx(ACol,ARow: Integer;FGColor,FGTextColor,BKColor,BKTextColor: TColor);
    procedure RemoveProgress(ACol,ARow: Integer);

    procedure AddProgressPie(ACol,ARow: Integer; Color: TColor; Value: Integer);
    procedure SetProgressPie(ACol,ARow: Integer; Value: Integer);
    procedure RemoveProgressPie(ACol,ARow: Integer);

    procedure AddComment(ACol,ARow: Integer; Comment:string);
    procedure RemoveComment(ACol,ARow: Integer);
    procedure AddMarker(ACol,ARow,ErrPos,ErrLen: Integer);
    procedure RemoveMarker(ACol,ARow: Integer);
    procedure GetMarker(ACol,ARow:Integer;var ErrPos,ErrLen: Integer);
    function IsComment(ACol,ARow: Integer;var comment:string): Boolean;
    function ColumnSum(ACol,fromRow,toRow: Integer): Double;
    function ColumnAvg(ACol,fromRow,toRow: Integer): Double;
    function ColumnMin(ACol,fromRow,toRow: Integer): Double;
    function ColumnMax(ACol,fromRow,toRow: Integer): Double;
    function RowSum(ARow,fromCol,toCol: Integer): Double;
    function RowAvg(ARow,fromCol,toCol: Integer): Double;
    function RowMin(ARow,fromCol,toCol: Integer): Double;
    function RowMax(ARow,fromCol,toCol: Integer): Double;
    procedure CalcFooter(ACol: Integer); virtual;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure StartUpdate;
    procedure ResetUpdate;
    property LockUpdate: Boolean read GetLockFlag write SetLockFlag;
    property CellTypes[ACol,ARow: Integer]:TCellType read GetCellType;
    property CellGraphics[ACol,ARow: Integer]:TCellGraphic read GetCellGraphic;
    property CellGraphicSize[ACol,ARow: Integer]:TPoint read GetCellGraphicSize;
    property CellImages[ACol,ARow: Integer]: TIntList read GetCellImages;
    property Ints[ACol,ARow: Integer]: Integer read GetInts write SetInts;
    property Floats[ACol,ARow: Integer]:double read GetFloats write SetFloats;
    property Dates[ACol,ARow: Integer]:TDateTime read GetDates write SetDates;
    property Times[ACol,ARow: Integer]:TDateTime read GetTimes write SetTimes;
    property ControlValues[ACol,ARow: Integer;ID: string]: string read GetCtrlVal write SetCtrlVal;
    property Delimiter:char read FDelimiter write FDelimiter;
    property PasswordChar:char read FPasswordChar write FPasswordChar;
    property JavaCSV: Boolean read FJavaCSV write FJavaCSV;
    property FastPrint: Boolean read FFastPrint write FFastPrint;
    property CheckTrue: string read FCheckTrue write FCheckTrue;
    property CheckFalse: string read FCheckFalse write FCheckFalse;
    property SaveFixedCells: Boolean read FSaveFixedCells write FSaveFixedCells;
    property SaveHiddenCells: Boolean read FSaveHiddenCells write FSaveHiddenCells;
    property SaveVirtCells: Boolean read FSaveVirtCells write FSaveVirtCells;    
    property SaveWithHTML: Boolean read FSaveWithHTML write FSaveWithHTML;
    property SortIndexes: TSortIndexList read FSortIndexes;
    property OriginalCellValue: string read FCellCache;
    property EditActive: Boolean read FEditActive;
    {$IFDEF DELPHI3_LVL}
    property DateTimePicker: TDateTimePicker read GetDateTimePicker;
    {$ENDIF}
    property Combobox: TGridCombo read EditCombo;
    property CommentColor: TColor read FCommentColor write FCommentColor;
    property ClearTextOnly: Boolean read FClearTextOnly write FClearTextOnly;
    {$IFDEF TMSUNICODE}
    property UniCombo: TGridUniCombo read ComboUni;
    property UniEdit: TGridUniEdit read EditUni;
    {$ENDIF}
    property SpinEdit: TGridSpin read EditSpin;
    property BtnEdit: TGridEditBtn read EditBtn;
    property Btn: TGridButton read GridButton;
    property BtnUnitEdit: TGridUnitEditBtn read UnitEditBtn;
    property RichEdit: TAdvRichEdit read FRichEdit;
    property InplaceRichEdit: TAdvRichEdit read FInplaceRichEdit;
    property NormalEdit: TAdvInplaceEdit read GetInplaceEditor;
    property PrinterDriverFix: Boolean read FPrinterDriverFix write FPrinterDriverFix;
    property RowSelect[ARow: Integer]: Boolean read GetRowSelect write SetRowSelect;
    property ColSelect[ACol: Integer]: Boolean read GetColSelect write SetColSelect;    
    property RowSelectCount: Integer read GetRowSelectCount;
    property ColSelectCount: Integer read GetColSelectCount;
    property NodeState[ARow: Integer]: Boolean read GetNodeState write SetNodeState;
    property FindBusy: Boolean read FFindBusy;
    property PrintPageRect:TRect read FPrintPageRect;
    property PrintPageWidth: Integer read FPrintPageWidth;
    property PrintColWidth[ACol: Integer]: Integer read GetPrintColWidth;
    property PrintColOffset[ACol: Integer]: Integer read GetPrintColOffset;
    property PrintColStart: Integer read FPrintColStart;
    property PrintColEnd: Integer read FPrintColEnd;
    property PrintNrOfPages: Integer read FPrintPageNum;
    property ExcelClipboardFormat: Boolean read fExcelClipboardFormat write FExcelClipboardFormat;
    property PreviewPage: Integer read FPrintPageFrom write SetPreviewPage;
    property UnSortedCells[i,j: Integer]: string read GetUnSortedCell write SetUnSortedCell;
    property AllCells[i,j: Integer]: string read GetCellsEx write SetCellsEx;
    property WideCells[i,j: Integer]: widestring read GetWideCells write SetWideCells;
    property AllObjects[i,j: Integer]:TObject read GetObjectsEx write SetObjectsEx;
    property AllColWidths[i: Integer]: Integer read GetAllColWidths write SetAllColWidths;
    property AllColCount: Integer read GetAllColCount;
    property AllRowCount: Integer read GetAllRowCount;
    property Alignments[i,j: Integer]: TAlignment read GetAlignments write SetAlignments;
    property Colors[i,j: Integer]: TColor read GetColors write SetColors;
    property FontColors[i,j: Integer]: TColor read GetFontColors write SetFontColors;
    property FontStyles[i,j: Integer]: TFontStyles read GetFontStyles write SetFontStyles;
    property FontSizes[i,j: Integer]: Integer read GetFontSizes write SetFontSizes;
    property FontNames[i,j: Integer]: string read GetFontNames write SetFontNames;
    property CellControls[i,j: Integer]: TControl read GetCellControls write SetCellControls;
    property StrippedCells[i,j: Integer]: string read GetStrippedCell;
    property SelectedCells[i,j: Integer]: Boolean read GetSelectedCells write SetSelectedCells;
    property SelectedCellsCount: Integer read GetSelectedCellsCount;
    property SelectedCell[i: Integer]: TGridCoord read GetSelectedCell;
    property CurrentCell:string read GetCurrentCell write SetCurrentCell;
    {$IFDEF DELPHI3_LVL}
    property ArrowColor: TColor read GetArrowColor write SetArrowColor;
    {$ENDIF}
    property GroupColumn: Integer read FGroupColumn write SetGroupColumn;
    property QuoteEmptyCells: Boolean read FQuoteEmptyCells write FQuoteEmptyCells;
    property AlwaysQuotes: Boolean read FAlwaysQuotes write FAlwaysQuotes;
    property SelectionRectangleColor: TColor read FSelectionRectangleColor write FSelectionRectangleColor;
    property RealRow: Integer read GetRealRow;
    property RealCol: Integer read GetRealCol;
    property SaveStartCol: Integer read GetSaveStartCol;
    property SaveStartRow: Integer read GetSaveStartRow;
    property SaveEndCol: Integer read GetSaveEndCol;
    property SaveEndRow: Integer read GetSaveEndRow;
    property SaveColCount: Integer read GetSaveColCount;
    property SaveRowCount: Integer read GetSaveRowCount;
    property ShowNullDates: Boolean read FShowNullDates write FShowNullDates;
    property VersionNr: Integer read GetVersionNr;
    property VersionString: string read GetVersionString;
    property EditLink: TEditLink read FEditLink write FEditLink;
    property XYOffset: TPoint read FXYOffset write SetXYOffset;
    property ImageCache: THTMLPictureCache read FImageCache;
    property MergedColumns: TIntList read FMergedColumns;
    property AlwaysValidate: Boolean read FAlwaysValidate write FAlwaysValidate;
    property SizeGrowOnly: Boolean read FSizeGrowOnly write FSizeGrowOnly;
    property MaxRowHeight: Integer read FMaxRowHeight write FMaxRowHeight;
    property MinRowHeight: Integer read FMinRowHeight write FMinRowHeight;
    property MaxColWidth: Integer read FMaxColWidth write FMaxColWidth;
    property MinColWidth: Integer read FMinColWidth write FMinColWidth;
    property TMSGradientFrom: TColor read FTMSGradFrom write SetTMSGradFrom;
    property TMSGradientTo: TColor read FTMSGradTo write SetTMSGradTo;
    property UseHTMLHints: Boolean read FUseHTMLHints write SetUseHTMLHints;
    property AutoNumberDirection: TSortDirection read FAutoNumberDirection write FAutoNumberDirection;
    property AutoNumberOffset: Integer read FAutoNumberOffset write FAutoNumberOffset;
    property AutoNumberStart: Integer read FAutoNumberStart write FAutoNumberStart;
    {$IFDEF TMSUNICODE}
    property UniLocale: LCID read FUniLocale write FUniLocale;
    property UniCmpFlgs: DWORD read FUniCmpFlgs write FUniCmpFlgs;
    {$ENDIF}
    {$IFDEF FREEWARE}
    property FreewareCode: Integer read FFreewareCode write FFreewareCode;
    {$ENDIF}
  published
    property ActiveCellShow: Boolean read FActiveCellShow write SetActiveCellShow;
    property ActiveCellFont: TFont read FActiveCellFont write SetActiveCellFont;
    property ActiveCellColor: TColor read FActiveCellColor write SetActiveCellColor;
    property AnchorHint: Boolean read FAnchorHint write FAnchorHint default False;
    property Bands:TBands read FBands write FBands;
    property AutoNumAlign: Boolean read FAutoNumAlign write FAutoNumAlign;
    property AutoSize: Boolean read FAutoSize write SetAutoSizeP;
    property VAlignment: TVAlignment read FVAlignment write SetVAlignment;
    property EnhTextSize: Boolean read FEnhTextSize write FEnhTextSize;
    property EditWithTags: Boolean read FEditWithTags write FEditWithTags default False;
    property EnhRowColMove: Boolean read FEnhRowColMove write FEnhRowColMove;
    property SizeWithForm: Boolean read FSizeWithForm write FSizeWithForm;
    property Multilinecells: Boolean read FMultilinecells write FMultilinecells;
    property OnCustomCellDraw: TCustomCellDrawEvent read FOnCustomCellDraw
      write FOnCustomCellDraw;
    property OnCustomCellSize: TCustomCellSizeEvent read FOnCustomCellSize
      write FOnCustomCellSize;
    property OnGetCellColor: TGridColorEvent read FOnGetCellColor write FOnGetCellColor;
    property OnGetCellPrintColor: TGridColorEvent read FOnGetCellPrintColor
      write FOnGetCellPrintColor;
    property OnGetCellPrintBorder: TGridBorderEvent read FOnGetCellPrintBorder
      write FOnGetCellPrintBorder;
    property OnGetCellBorder: TGridBorderEvent read FOnGetCellBorder
      write FOnGetCellBorder;
    property OnGetCellBorderProp: TGridBorderPropEvent read FOnGetCellBorderProp
      write FOnGetCellBorderProp;
    property OnGetAlignment: TGridAlignEvent read FOnGetAlignment
      write FOnGetAlignment;
    property OnGetFormat: TGridFormatEvent read FOnGetFormat
      write FOnGetFormat;
    property OnGetCheckTrue: TGetCheckEvent read FOnGetCheckTrue
      write FOnGetCheckTrue;
    property OnGetCheckFalse: TGetCheckEvent read FOnGetCheckFalse
      write FOnGetCheckFalse;
    property OnGridHint:TGridHintEvent read FOnGridHint
      write FOnGridHint;
    property OnRowChanging:TRowChangingEvent read FOnRowChanging
      write FOnRowChanging;
    property OnColChanging:TColChangingEvent read FOnColChanging
      write FOnColChanging;
    property OnCellChanging:TCellChangingEvent read FOnCellChanging
      write FOnCellChanging;
    property OnPrintPage:TGridPrintPageEvent read FOnPrintPage
      write FOnPrintPage;
    property OnPrintPageDone: TGridPrintPageDoneEvent read FOnPrintPageDone
      write FOnPrintPageDone;
    property OnPrintStart:TGridPrintStartEvent read FOnPrintStart
      write FOnPrintStart;
    property OnPrintCancel: TGridPrintCancelEvent read FOnPrintCancel
      write FOnPrintCancel;
    property OnFitToPage:TDoFitToPageEvent read FDoFitToPage
      write FDoFitToPage;
    property OnPrintNewPage:TGridPrintNewPageEvent read FOnPrintNewPage
      write FOnPrintNewPage;
    property OnPrintSetColumnWidth:TGridPrintColumnWidthEvent read FOnPrintSetColumnWidth
      write FOnPrintSetColumnWidth;
    property OnPrintSetRowHeight:TGridPrintRowHeightEvent read FOnPrintSetRowHeight
      write FOnPrintSetRowHeight;
    property OnCanAddRow: TCanAddRowEvent read FOnCanAddRow
      write FOnCanAddRow;
    property OnAutoAddRow:TAutoAddRowEvent read FOnAutoAddRow
      write FOnAutoAddRow;
    property OnCanInsertRow: TCanInsertRowEvent read FOnCanInsertRow
      write FOnCanInsertRow;
    property OnAutoInsertRow:TAutoInsertRowEvent read FOnAutoInsertRow
      write FOnAutoInsertRow;
    property OnAutoInsertCol: TAutoInsertColEvent read FOnAutoInsertCol
      write FOnAutoInsertCol;
    property OnCanDeleteRow: TCanDeleteRowEvent read FOnCanDeleteRow
      write FOnCanDeleteRow;
    property OnAutoDeleteRow: TAutoDeleteRowEvent read FOnAutoDeleteRow
      write FOnAutoDeleteRow;
    property OnClickSort: TClickSortEvent read FOnClickSort
      write FOnClickSort;
    property OnCanSort: TCanSortEvent read FOnCanSort
      write FOnCanSort;
    property OnExpandNode: TNodeClickEvent read FOnExpandNode
      write FOnExpandNode;
    property OnContractNode: TNodeClickEvent read FOnContractNode
      write FOnContractNode;
    property OnCustomCompare: TCustomCompareEvent read FCustomCompare
      write FCustomCompare;
    property OnRawCompare: TRawCompareEvent read FRawCompare
      write FRawCompare;
    property OnClickCell: TClickCellEvent read FOnClickCell
      write FOnClickCell;
    property OnRightClickCell: TClickCellEvent read FOnRightClickCell
      write FOnRightClickCell;
    property OnDblClickCell: TDblClickCellEvent read FOnDblClickCell
      write FOnDblClickCell;
    property OnCanEditCell: TCanEditCellEvent read FOnCanEditCell
      write FOnCanEditCell;
    property OnIsFixedCell: TIsFixedCellEvent read FOnIsFixedCell
      write FOnIsFixedCell;
    property OnIsPasswordCell: TIsPasswordCellEvent read FOnIsPasswordCell
      write FOnIsPasswordCell;
    property OnAnchorClick: TAnchorClickEvent read FOnAnchorClick
      write FOnAnchorClick;
    property OnAnchorEnter: TAnchorEvent read FOnAnchorEnter
      write FOnAnchorEnter;
    property OnAnchorExit: TAnchorEvent read FOnAnchorExit
      write FOnAnchorExit;
    property OnAnchorHint:TAnchorHintEvent read FOnAnchorHint
      write FOnAnchorHint;
    property OnControlClick: TCellControlEvent read FOnControlClick
      write FOnControlClick;
    property OnControlEditDone: TCellControlEvent read FOnControlEditDone
      write FOnControlEditDone;
    property OnControlComboList: TCellComboControlEvent read FOnControlComboList
      write FOnControlComboList;      
    property OnClipboardPaste:TClipboardEvent read FOnClipboardPaste
      write FOnClipboardPaste;
    property OnClipboardCopy:TClipboardEvent read FOnClipboardCopy
      write FOnClipboardCopy;
    property OnClipboardCut:TClipboardEvent read FOnClipboardCut
      write FOnClipboardCut;
    property OnClipboardBeforePasteCell: TBeforeCellPasteEvent read FOnClipboardBeforePasteCell
      write FOnClipboardBeforePasteCell;
    property OnCellValidate: TCellValidateEvent read FOnCellValidate
      write FOnCellValidate;
    property OnCellsChanged: TCellsChangedEvent read FOnCellsChanged
      write FOnCellsChanged;
    property OnFileProgress: TGridProgressEvent read FOnFileProgress
      write FOnFileProgress;
    property OnFilterProgress: TGridProgressEvent read FOnFilterProgress
      write FOnFilterProgress;
    property OnGetEditorType:TGetEditorTypeEvent read FOnGetEditorType
      write FOnGetEditorType;
    property OnGetEditorProp:TGetEditorPropEvent read FOnGetEditorProp
      write FOnGetEditorProp;
    property OnGetFloatFormat: TFloatFormatEvent read FOnGetFloatFormat
      write FOnGetFloatFormat;  
    property OnEllipsClick:TEllipsClickEvent read FOnEllipsClick
      write FOnEllipsClick;
    property OnButtonClick:TButtonClickEvent read FOnButtonClick
      write FOnButtonClick;
    property OnCheckBoxClick:TCheckBoxClickEvent read FOnCheckBoxClick
      write FOnCheckBoxClick;
    property OnCheckBoxMouseUp:TCheckBoxClickEvent read FOnCheckBoxMouseUp
      write FOnCheckBoxMouseUp;
    property OnRadioClick:TRadioClickEvent read FOnRadioClick
      write FOnRadioClick;
    property OnRadioMouseUp:TRadioClickEvent read FOnRadioMouseUp
      write FOnRadioMouseUp;
    property OnComboChange:TComboChangeEvent read FOnComboChange
      write FOnComboChange;
    property OnComboCloseUp: TClickCellEvent read FOnComboCloseUp
      write FOnComboCloseUp;  
    property OnComboObjectChange:TComboObjectChangeEvent read FOnComboObjectChange
      write FOnComboObjectChange;
    property OnSpinClick:TSpinClickEvent read FOnSpinClick
      write FOnSpinClick;
    property OnFloatSpinClick:TFloatSpinClickEvent read FOnFloatSpinClick
      write FOnFloatSpinClick;
    property OnTimeSpinClick:TDateTimeSpinClickEvent read FOnTimeSpinClick
      write FOnTimeSpinClick;
    property OnDateSpinClick:TDateTimeSpinClickEvent read FOnDateSpinClick
      write FOnDateSpinClick;
    property OnRichEditSelectionChange: TNotifyEvent read FOnRichEditSelectionChange
      write FOnRichEditSelectionChange;
    property OnEditingDone: TNotifyEvent read FOnEditingDone write FOnEditingDone;
    property OnResize: TNotifyEvent read FOnGridResize write FOnGridResize;
    {$IFDEF DELPHI4_LVL}
    property OnOleDrop: TOleDragDropEvent read FOnOleDrop write FOnOleDrop;
    property OnOleDropped: TOleDroppedEvent read FOnOleDropped write FOnOleDropped;
    property OnOleDrag: TOleDragDropEvent read FOnOleDrag write FOnOleDrag;
    property OnOleDragOver: TOleDragOverEvent read FOnOleDragOver write FOnOleDragOver;
    property OnOleDragStart: TOleDragStartEvent read FOnOleDragStart write FOnOleDragStart;
    property OnOleDragStop: TOleDragStopEvent read FOnOleDragStop write FOnOleDragStop;
    property OnOleDropCol: TOleDropColEvent read FOnOleDropCol write FOnOleDropCol;
    property OnOleDropFile: TOleDropFileEvent read FOnOleDropFile write FOnOleDropFile;
    property DragDropSettings: TDragDropSettings read FDragDropSettings write FDragDropSettings;
    {$ENDIF}
    property SortSettings: TSortSettings read FSortSettings write FSortSettings;
    property FloatingFooter: TFloatingFooter read FFloatingFooter write FFloatingFooter;
    property ControlLook: TControlLook read FControlLook write FControlLook;
    property EnableBlink: Boolean read FEnableBlink write FEnableBlink;
    property EnableHTML: Boolean read FEnableHTML write FEnableHTML;
    property EnableWheel: Boolean read FEnableWheel write FEnableWheel;
    property ExcelStyleDecimalSeparator: Boolean read FExcelStyleDecimalSeparator write
      FExcelStyleDecimalSeparator default False;
    property Flat: Boolean read FFlat write SetFlat;
    property Look: TGridLook read FLook write SetLook default glSoft;
    property HintColor: TColor read FHintColor write FHintColor;
    property SelectionColor: TColor read FSelectionColor write SetSelectionColor;
    property SelectionTextColor: TColor read FSelectionTextColor write SetSelectionTextColor;
    property SelectionRectangle: Boolean read FSelectionRectangle write SetSelectionRectangle;
    property SelectionResizer: Boolean read FSelectionResizer write SetSelectionResizer;
    property SelectionRTFKeep: Boolean read FSelectionRTFKeep write FSelectionRTFKeep;
    {$IFDEF DELPHI3_LVL}
    property HintShowCells: Boolean read FHintShowCells write FHintShowCells;
    property HintShowLargeText: Boolean read FHintShowLargeText write FHintShowLargeText;
    property HintShowSizing: Boolean read FHintShowSizing write FHintShowSizing;
    property HTMLHint: Boolean read FHTMLHint write FHTMLHint default False;
    property OnScrollHint:TScrollHintEvent read FOnScrollHint write FOnScrollHint;
    {$ENDIF}
    {$IFDEF DELPHI4_LVL}
    property OnColumnSize:TColumnSizeEvent read FOnColumnSize write FOnColumnSize;
    property OnColumnMove:TColumnSizeEvent read FOnColumnMove write FOnColumnMove;
    property OnRowSize:TRowSizeEvent read FOnRowSize write FOnRowSize;
    property OnRowMove:TRowSizeEvent read FOnRowMove write FOnRowMove;
    {$ENDIF}
    property OnEndColumnSize:TEndColumnSizeEvent read FOnEndColumnSize write FOnEndColumnSize;
    property OnUpdateColumnSize: TUpdateColumnSizeEvent read FOnUpdateColumnSize write FOnUpdateColumnSize;
    property OnEndRowSize: TEndRowSizeEvent read FOnEndRowSize write FOnEndRowSize;
    property PrintSettings: TPrintSettings read FPrintSettings write FPrintSettings;
    property HTMLSettings: THTMLSettings read FHTMLSettings write FHTMLSettings;
    property Navigation: TNavigation read FNavigation write FNavigation;
    property ColumnSize: TColumnSize read FColumnSize write FColumnSize;
    property CellNode: TCellNode read fCellNode write fCellNode;
    property SizeWhileTyping: TSizeWhileTyping read FSizeWhileTyping write FSizeWhileTyping;
    property MaxEditLength: Integer read FMaxEditLength write SetMaxEditLength;
    property MouseActions: TMouseActions read FMouseActions write FMouseActions;
    property GridImages: TImageList read FGridImages write SetImages;
    property IntelliPan: TIntelliPan read FIntelliPan write FIntelliPan;
    property IntelliZoom: Boolean read FIntelliZoom write FIntelliZoom default True;
    property URLColor: TColor read FURLColor write SetURLColor;
    property URLShow: Boolean read FURLShow write SetURLShow;
    property URLFull: Boolean read FURLFull write SetURLFull;
    property URLEdit: Boolean read FURLEdit write FURLEdit;
    property PictureContainer: TPictureContainer read FContainer write FContainer;
    property CellChecker: TAdvStringGridCheck read FCellChecker write FCellChecker;
    property ScrollType:TScrollType read FScrollType write SetScrollType;
    property ScrollColor: TColor read FScrollColor write SetScrollColor;
    property ScrollWidth: Integer read FScrollWidth write SetScrollWidth;
    property ScrollSynch: Boolean read FScrollSynch write FScrollSynch;
    property ScrollProportional: Boolean read FScrollProportional write SetScrollProportional;
    property ScrollHints:TScrollHintType read FScrollHints write FScrollHints;
    property OemConvert: Boolean read fOemConvert write fOemConvert;
    property FixedFooters: Integer read FFixedFooters write SetFixedFooters;
    property FixedRightCols: Integer read FFixedRightCols write SetFixedRightCols;
    property FixedColWidth: Integer read GetFixedColWidth write SetFixedColWidth;
    property FixedRowHeight: Integer read GetFixedRowHeight write SetFixedRowHeight;
    property FixedRowAlways: Boolean read FFixedRowAlways write FFixedRowAlways default False;
    property FixedColAlways: Boolean read FFixedColAlways write FFixedColAlways default False;
    property FixedFont: TFont read FFixedFont write SetFixedFont;
    property RowCount: Integer read GetRowCountEx write SetRowCountEx;
    property FixedRows: Integer read GetFixedRowsEx write SetFixedRowsEx;
    property ColCount: Integer read GetColCountEx write SetColCountEx;
    property FixedCols: Integer read GetFixedColsEx write SetFixedColsEx;
    property FixedAsButtons: Boolean read FFixedAsButtons write FFixedAsButtons;
    property FloatFormat:string read FFloatFormat write FFloatFormat;
    property IntegralHeight: Boolean read FIntegralHeight write SetIntegralHeight;
    property WordWrap: Boolean read fWordWrap write SetWordWrap;
    property ColumnHeaders: TStringList read FColumnHeaders write SetColumnHeaders;
    property RowHeaders: TStringList read FRowHeaders write SetRowHeaders;
    property LookupItems: TStringList read FLookupItems write SetLookupItems;
    property Lookup: Boolean read FLookup write FLookup;
    property LookupCaseSensitive: Boolean read FLookupCaseSensitive write FLookupCaseSensitive;
    property LookupHistory: Boolean read FLookupHistory write FLookupHistory;
    property ShowSelection: Boolean read FShowSelection write SetShowSelection default True;
    property HideFocusRect: Boolean read FHideFocusRect write FHideFocusRect default False;
    property RowIndicator:TBitmap read GetRowIndicator write SetRowIndicator;
    property BackGround:TBackground read FBackground write SetBackground;
    property Hovering: Boolean read FHovering write SetHovering default False;
    property Filter: TFilter read FFilter write FFilter;
    property FilterActive: Boolean read FFilterActive write SetFilterActive default False;
    property Cursor: TCursor read GetCursorEx write SetCursorEx;
    property DefaultRowHeight: Integer read GetDefRowHeightEx write SetDefRowHeightEx;
  end;

  TGridSLIO = class(TComponent)
  private
    FStrings: TStringList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Strings: TStringList read FStrings write FStrings;
  end;

  TGridFilePicIO = class(TComponent)
  private
    FPicture: TFilePicture;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Picture: TFilePicture read FPicture write FPicture;
  end;

  TGridPicIO = class(TComponent)
  private
    FPicture: TPicture;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Picture: TPicture read FPicture write FPicture;
  end;

  TGridIconIO = class(TComponent)
  private
    FIcon: TIcon;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Icon: TIcon read FIcon write FIcon;
  end;

  TGridBMPIO = class(TComponent)
  private
    FBitmap: TBitmap;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Bitmap: TBitmap read FBitmap write FBitmap;
  end;

  TGridPropIO = class(TComponent)
  private
    FColCount: Integer;
    FRowCount: Integer;
    FColWidths: string;
    FRowHeights: string;
    FFullGrid: Boolean;
    FID: Integer;
  published
    property ColCount: Integer read FColCount write FColCount;
    property RowCount: Integer read FRowCount write FRowCount;
    property ColWidths: string read FColWidths write FColWidths;
    property RowHeights: string read FRowHeights write FRowHeights;
    property FullGrid: Boolean read FFullGrid write FFullGrid;
    property ID: Integer read FID write FID;
  end;

  TGridGraphicIO = class(TComponent)
  private
    FCellGraphic: TCellGraphic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CellGraphic: TCellGraphic read FCellGraphic write FCellGraphic;
  end;

  TGridCellPropIO = class(TComponent)
  private
    FCellProperties: TCellProperties;
    FHasGraphic: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CellProperties: TCellProperties read FCellProperties write FCellProperties;
    property HasGraphic: Boolean read FHasGraphic write FHasGraphic;
  end;

  TGridCellIO = class(TComponent)
  private
    FRow: SmallInt;
    FCol: SmallInt;
    FCell: string;
    FHasProp: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Col: SmallInt read FCol write FCol;
    property Row: SmallInt read FRow write FRow;
    property Cell: string read FCell write FCell;
    property HasProp: Boolean read FHasProp write FHasProp;
  end;


implementation

const
  ComCtrl = 'comctl32.dll';

  ComCtrlOk: Boolean = True;

  {$IFNDEF DELPHI7_LVL}

  {$EXTERNALSYM CSTR_LESS_THAN}
  CSTR_LESS_THAN           = 1;             { string 1 less than string 2 }
  {$EXTERNALSYM CSTR_EQUAL}
  CSTR_EQUAL               = 2;             { string 1 equal to string 2 }
  {$EXTERNALSYM CSTR_GREATER_THAN}
  CSTR_GREATER_THAN        = 3;             { string 1 greater than string 2 }

  {$ENDIF}


  //------------------------------------------------
  //constant definitions for flat/encarta scrollbars
  //------------------------------------------------
  WSB_PROP_CYVSCROLL  = $0000001;
  WSB_PROP_CXHSCROLL  = $0000002;
  WSB_PROP_CYHSCROLL  = $0000004;
  WSB_PROP_CXVSCROLL  = $0000008;
  WSB_PROP_CXHTHUMB   = $0000010;
  WSB_PROP_CYVTHUMB   = $0000020;
  WSB_PROP_VBKGColOR  = $0000040;
  WSB_PROP_HBKGColOR  = $0000080;
  WSB_PROP_VSTYLE     = $0000100;
  WSB_PROP_HSTYLE     = $0000200;
  WSB_PROP_WINSTYLE   = $0000400;
  WSB_PROP_PALETTE    = $0000800;
  WSB_PROP_MASK       = $0000FFF;

  FSB_FLAT_MODE       =    2;
  FSB_ENCARTA_MODE    =    1;
  FSB_REGULAR_MODE    =    0;

  //-------------------------------------------------
  //constant definitions for OLE automation with Word
  //-------------------------------------------------
  wdAlignParagraphLeft = 0;
  wdAlignParagraphCenter = 1;
  wdAlignParagraphRight = 2;
  wdAlignParagraphJustify = 3;

  //--------------------------------------------------
  //constant definitions for OLE automation with Excel
  //--------------------------------------------------
  xlAddIn = 18;
  xlCSV = 6;
  xlCSVMac = 22;
  xlCSVMSDOS = 24;
  xlCSVWindows = 23;
  xlDBF2 = 7;
  xlDBF3 = 8;
  xlDBF4 = 11;
  xlDIF = 9;
  xlExcel2 = 16;
  xlExcel2FarEast = 27;
  xlExcel3 = 29;
  xlExcel4 = 33;
  xlExcel5 = 39;
  xlExcel7 = 39;
  xlExcel9795 = 43;
  xlExcel4Workbook = 35;
  xlIntlAddIn = 26;
  xlIntlMacro = 25;
  xlWorkbookNormal = -4143;
  xlSYLK = 2;
  xlTemplate = 17;
  xlCurrentPlatformText = -4158;
  xlTextMac = 19;
  xlTextMSDOS = 21;
  xlTextPrinter = 36;
  xlTextWindows = 20;
  xlWJ2WD1 = 14;
  xlWK1 = 5;
  xlWK1ALL = 31;
  xlWK1FMT = 30;
  xlWK3 = 15;
  xlWK4 = 38;
  xlWK3FM3 = 32;
  xlWKS = 4;
  xlWorks2FarEast = 28;
  xlWQ1 = 34;
  xlWJ3 = 40;
  xlWJ3FJ3 = 41;

  xlA1 = 1;
  xlR1C1 = -4150;

  //---------------------------------------------
  //constant definitions for Intellimouse support
  //---------------------------------------------
  MSH_MOUSEWHEEL = 'MSWHEEL_ROLLMSG';
  MOUSEZ_CLASSNAME = 'MouseZ';               // wheel window class
  MOUSEZ_TITLE     = 'Magellan MSWHEEL';     // wheel window title
  MSH_WHEELSUPPORT = 'MSH_WHEELSUPPORT_MSG'; // name of msg to query for wheel support
  MSH_SCROLL_LINES = 'MSH_SCROLL_LINES_MSG';
  MSH_WHEELMODULE_CLASS = MOUSEZ_CLASSNAME;
  MSH_WHEELMODULE_TITLE = MOUSEZ_TITLE;

  //--------------------------------------
  //constant definitions for extra cursors
  //--------------------------------------
  crURLcursor: Integer = 8009;
  crHorzArr = 8010;
  crVertArr = 8011;
  crAsgCross = 8012;
  crAsgSizer = 8013;

  Numeric_Characters = [$30..$39,$8,$9,$D,ord('-'),ord(#27)];
  Positive_Numeric_Characters = [$30..$39,$8,$9,$D,ord(#27)];
  Float_Characters = [$30..$39,$8,$9,$D,ord('-'),ord(','),ord('.'),ord(#27)];

  CSVSeparators: array[1..10] of char = (',',';','#',#9,'|','@','*','-','+','&');

function LongMulDiv(Mult1, Mult2, Div1: Integer): Integer; stdcall;
  external 'kernel32.dll' name 'MulDiv';

{$IFDEF FREEWARE}
procedure GetFreeStr(cl:string;var s:string);
var
  i: Integer;
  t: string;
begin
  t := 'eµ·®³¹ª©e¼®¹­e©ª²´e»ª·¸®´³e´«e';
  for i := 1 to Length(t) do t[i] := Chr(Ord(t[i])-69);
  s := s + ' ' + t + ' ' + cl;
end;
{$ENDIF}

procedure SetTranspWindow(Hwnd:THandle);
var
  es: Integer;
begin
  es := GetWindowLong(Hwnd,GWL_EXSTYLE);
  es := es OR WS_EX_TRANSPARENT;
  SetWindowLong(Hwnd,GWL_EXSTYLE,es);
end;

{$IFDEF DELPHI4_LVL}
function GetFileVersion(FileName:string): Integer;
var
  FileHandle:dword;
  l: Integer;
  pvs: PVSFixedFileInfo;
  lptr: uint;
  querybuf: array[0..255] of char;
  buf: PChar;
begin
  Result := -1;

  StrPCopy(querybuf,FileName);
  l := GetFileVersionInfoSize(querybuf,FileHandle);
  if (l>0) then
  begin
    GetMem(buf,l);
    GetFileVersionInfo(querybuf,FileHandle,l,buf);
    if VerQueryValue(buf,'\',Pointer(pvs),lptr) then
    begin
      if (pvs^.dwSignature=$FEEF04BD) then
      begin
        Result := pvs^.dwFileVersionMS;
      end;
    end;
    FreeMem(buf);
  end;
end;
{$ENDIF}

procedure TColumnSize.SetStretch(Value: Boolean);
begin
  FStretch := Value;
  (Owner as TAdvStringGrid).StretchColumn(FStretchColumn);
end;

constructor TGridCheckBox.Create(AOwner:tComponent);
begin
  inherited Create(AOwner);
  FGrid := AOwner as TAdvStringGrid;
end;

procedure TGridCheckBox.DoExit;
begin
  FGrid.HideInplaceEdit;
  inherited DoExit;
end;

procedure TGridCheckBox.WMLButtonDown(var Msg:TWMLButtonDown);
begin
  Toggle;
  inherited;
end;

procedure TGridCheckBox.Keydown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_SPACE then
    Toggle;

  if (Key in [VK_DOWN,VK_UP,VK_LEFT,VK_RIGHT,VK_PRIOR,VK_NEXT,VK_END,VK_UP,VK_RETURN]) then
  begin
    if Key = VK_ESCAPE then
      self.Text := FGrid.CurrentCell;

    FGrid.HideInplaceEdit;
    FGrid.SetFocus;
    if Key = VK_RETURN then
      FGrid.AdvanceEdit(FGrid.Col,FGrid.Row,False,True,True);

    if Key in [VK_DOWN,VK_UP] then
      FGrid.KeyDown(Key,shift);
  end
  else
    inherited;
end;

constructor TGridSpin.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FGrid := AOwner as TAdvStringGrid;
  MaxValue := 100;
  MinValue := 0;
  Increment := 1;
end;

procedure TGridSpin.DoClick(UpDown: Boolean);
begin
  case SpinType of
  sptNormal:if Assigned(FGrid.OnSpinClick) then
            FGrid.OnSpinClick(FGrid,FGrid.Col,FGrid.Row,Self.Value,UpDown);
  sptFloat:if Assigned(FGrid.OnFloatSpinClick) then
           FGrid.OnFloatSpinClick(FGrid,FGrid.Col,FGrid.Row,Self.FloatValue,UpDown);
  sptTime:if Assigned(FGrid.OnTimeSpinClick) then
          FGrid.OnTimeSpinClick(FGrid,FGrid.Col,FGrid.Row,Self.TimeValue,UpDown);
  sptDate:if Assigned(FGrid.OnDateSpinClick) then
          FGrid.OnDateSpinClick(FGrid,FGrid.Col,FGrid.Row,Self.DateValue,UpDown);
  end;
end;

procedure TGridSpin.UpClick(Sender:TObject);
begin
  inherited;
  DoClick(True);
end;

procedure TGridSpin.DownClick(Sender:TObject);
begin
  inherited;
  DoClick(False);
end;

procedure TGridSpin.DoExit;
begin
  FGrid.HideInplaceEdit;
  inherited DoExit;
end;

procedure TGridSpin.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key,shift);
end;

procedure TGridSpin.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (Msg.CharCode = VK_TAB) and (goTabs in FGrid.Options) then
    Msg.Result := 1;
end;


procedure TGridSpin.WMChar(var Msg:TWMChar);
begin
  if Msg.CharCode in [Ord(#13),Ord(#9)] then Msg.Result :=0 else
  inherited;
end;

procedure TGridSpin.Keypress(var Key:char);
begin
  if Key <> #13 then
    inherited Keypress(Key);
end;

procedure TGridSpin.Keydown(var Key: Word; Shift: TShiftState);
begin
  case Key of
  VK_NEXT:
    case SpinType of
    sptNormal:if self.Value - self.Increment >= self.MinValue then
                self.Value := self.Value - self.Increment;
    sptFloat:if self.FloatValue - self.IncrementFloat >= self.MinFloatValue then
               self.FloatValue := self.FloatValue - self.IncrementFloat;
    end;
  VK_PRIOR:
    case SpinType of
    sptNormal:if self.Value - self.Increment <= self.MaxValue then
                self.Value := self.Value+self.increment;
    sptFloat:if self.FloatValue + self.IncrementFloat <= self.MaxFloatValue then
               self.FloatValue := self.FloatValue+self.IncrementFloat;
    end;
  VK_END:
    case SpinType of
    sptNormal:self.Value := self.MinValue;
    sptFloat:self.FloatValue := self.MinFloatValue;
    end;
  VK_HOME:
    case SpinType of
    sptNormal:self.Value := self.MaxValue;
    sptFloat:self.FloatValue := self.MaxFloatValue;
    end;
  end;

  if Assigned(FGrid.OnSpinClick) then
  begin
    if (Key in [VK_PRIOR,VK_HOME]) then
      FGrid.OnSpinClick(FGrid,FGrid.Col,FGrid.Row,self.Value,False);
    if (Key in [VK_NEXT,VK_END]) then
      FGrid.OnSpinClick(FGrid,FGrid.Col,FGrid.Row,self.Value,False);
  end;

  if (Key in [VK_DOWN,VK_UP,VK_ESCAPE,VK_RETURN,VK_TAB]) then
  begin
    if (Key in [VK_RETURN,VK_UP,VK_DOWN,VK_TAB]) then
    begin
      FGrid.CurrentCell := self.Text;

      if not FGrid.ValidateCell(Self.Text) then
      begin
        self.Text := FGrid.CurrentCell;
        self.SelStart := Length(self.Text);
        Repaint;
        Exit;
       end;
    end;

    // v2.4
    if (Key = VK_TAB) and (goTabs in FGrid.Options) then
    begin
      FGrid.HideInplaceEdit;
      FGrid.SetFocus;
      FGrid.TabEdit(GetKeyState(VK_SHIFT) and $8000 = $8000);
      Exit;
    end;
    //

    if Key = VK_ESCAPE then
      self.Text := FGrid.CurrentCell;

    FGrid.DoneInplaceEdit(Key,Shift);
  end
 else
   inherited;
end;

{$IFDEF TMSUNICODE}
constructor TGridUniEdit.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FGrid := AOwner as TAdvStringGrid;
end;

procedure TGridUniEdit.DoExit;
begin
  FGrid.HideInplaceEdit;
  inherited DoExit;
end;

procedure TGridUniEdit.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (Msg.CharCode = VK_TAB) and (goTabs in FGrid.Options) then
    Msg.Result := 1;
end;

procedure TGridUniEdit.WMChar(var Msg:TWMChar);
begin
  if Msg.CharCode in [Ord(#13),Ord(#9)] then Msg.Result :=0 else
  inherited;
end;

procedure TGridUniEdit.Keypress(var Key:char);
begin
  if Key <> #13 then
    inherited Keypress(Key);
end;

procedure TGridUniEdit.Keydown(var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_DOWN,VK_UP,VK_ESCAPE,VK_RETURN,VK_TAB]) then
  begin
    if (Key in [VK_RETURN,VK_UP,VK_DOWN,VK_TAB]) then
    begin
      FGrid.CurrentCell := self.Text;

      if not FGrid.ValidateCell(Self.Text) then
      begin
        self.Text := FGrid.CurrentCell;
        self.SelStart := Length(self.Text);
        Repaint;
        Exit;
       end;
    end;

    // v2.4
    if (Key = VK_TAB) and (goTabs in FGrid.Options) then
    begin
      FGrid.HideInplaceEdit;
      FGrid.SetFocus;
      FGrid.TabEdit(GetKeyState(VK_SHIFT) and $8000 = $8000);
      Exit;
    end;
    //

    if Key = VK_ESCAPE then
      self.Text := FGrid.CurrentCell;

    FGrid.DoneInplaceEdit(Key,Shift);
  end
 else
   inherited;
end;

procedure TGridUniCombo.DoExit;
begin
  if FGrid.LookupHistory and (Text <> '') then
  begin
    if (Items.IndexOf(Text) = -1) then
      Items.Add(Text);
  end;

  FGrid.HideInplaceEdit;
  inherited DoExit;
end;

procedure TGridUniCombo.WndProc(var Message:tMessage);
begin
  if Assigned(FGrid) then
  begin
    if (Message.Msg = FGrid.WheelMsg) then
    begin
      if Message.Wparam < 0 then
        ItemIndex := ItemIndex + 1
      else
        if ItemIndex > 0 then ItemIndex := ItemIndex - 1;

      if Assigned(FGrid.FOnComboChange) then
      begin
        FGrid.FOnComboChange(Self,FGrid.Col,FGrid.Row,ItemIndex,Items[ItemIndex]);
      end;

      if Assigned(FGrid.FOnComboObjectChange) then
      begin
        FGrid.FOnComboObjectChange(Self,FGrid.Col,FGrid.Row,ItemIndex,Items[ItemIndex],Items.Objects[ItemIndex]);
      end;

      Message.Result := 0;
      Exit;
    end;

    if (Message.Msg = WM_COMMAND) and
       (Message.WParamHi = CBN_SELCHANGE) then
    begin
      if Assigned(FGrid.FOnComboChange) then
      begin
        FGrid.FOnComboChange(Self,FGrid.Col,FGrid.Row,ItemIndex,Items[ItemIndex]);
      end;
    end;
  end;  

  inherited;
end;

procedure TGridUniCombo.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (Msg.CharCode = VK_TAB) and (goTabs in FGrid.Options) then
    Msg.Result := 1;
end;

constructor TGridUniCombo.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  WorkMode := True;
  FGrid := AOwner as TAdvStringGrid;
  ButtonWidth := 16;
  ItemChange := False;
end;

procedure TGridUniCombo.SizeDropDownWidth;
var
  i,tw,nw: Integer;
  HasScroll: Boolean;
  sz: TSize;
  ws: widestring;
begin
  tw := Width;

  HasScroll := Items.Count > DropDownCount;

  for i := 1 to Items.Count do
  begin
    ws := Self.Items[i - 1];
    GetTextExtentPoint32W(FGrid.Canvas.Handle,PWideChar(ws),Length(ws),sz);
    nw := sz.cx;

//    nw := FGrid.Canvas.TextWidth(Self.Items[i - 1]);

    if HasScroll then
    begin
      if nw > tw - 25 then
        tw := nw + 25;
    end
    else
    begin
      if nw > tw - 5 then
        tw := nw + 8;
    end;
  end;

  SendMessage(Handle,CB_SETDROPPEDWIDTH,tw,0);
end;

procedure TGridUniCombo.DoChange;
var
  c,s: string;
  i: Integer;
  UsrStr,AutoAdd:string;

begin
  if not WorkMode then Exit;
  if not FGrid.Lookup then Exit;

  if not FGrid.LookupCaseSensitive then
    c := AnsiUpperCase(Text)
  else
    c := Text;

  c := Copy(c,1,SelStart);

  for i:=1 to Items.Count do
  begin
    if not FGrid.LookupCaseSensitive then
      s := AnsiUpperCase(Items[i - 1])
    else
      s := Items[i - 1];

    if Pos(c,s) = 1 then
    begin
      UsrStr := Copy(Text,1,Length(c));
      AutoAdd := Copy(Items[i - 1],Length(c)+1,255);
      Text := UsrStr + AutoAdd;
      ItemIndex := i - 1;
      SendMessage(Handle,CB_SETEDITSEL,0,MakeLong(Length(c),Length(Text)));
      ItemIdx := i - 1;
      ItemChange := True;
      Exit;
    end;
  end;
end;

procedure TGridUniCombo.WMSetFocus(var Msg: TWMSetFocus);
var
  lpPoint: TPoint;
  i: Integer;
  hwndedit: THandle;
begin
  inherited;

  if not FGrid.LButFlg then
    Exit;

  GetCursorPos(lpPoint);
  lpPoint := ScreenToClient(lpPoint);

  if (lpPoint.x < 0) or (lpPoint.y < 0) or
     (lpPoint.x > Width) or (lpPoint.y > Height) then Exit;

  hwndEdit := FindWindowEx(Handle, 0,nil,nil);

  i := SendMessage(hwndedit,EM_CHARFROMPOS, 0,MakeLong(lpPoint.x,lpPoint.y));
  if i = -1 then
    Exit;

  SelStart := Loword(i);
  SelLength := 0;
  FGrid.LButFlg := False;
end;

procedure TGridUniCombo.Keypress(var Key: char);
begin
  if (Key = #13) and Assigned(FOnReturnKey) then
    FOnReturnKey(Self);

  if Key in [#13,#9] then
    Key := #0;
  inherited Keypress(Key);
end;

procedure TGridUniCombo.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_RETURN then
    inherited KeyUp(Key,shift);


  Self.DoChange;
end;

procedure TGridUniCombo.KeyDown(var Key: Word; Shift: TShiftState);
var
  Condition: Boolean;
  // ComboSelState: Boolean;
begin
  Forced := False;

  if (Self.Style = csDropDownList) or DroppedDown then
    Condition := Key in [VK_LEFT,VK_RIGHT,VK_ESCAPE,VK_TAB,VK_RETURN]
  else
    Condition := Key in [VK_DOWN,VK_UP,VK_PRIOR,VK_NEXT,VK_END,VK_ESCAPE,VK_TAB,VK_RETURN];

  WorkMode := not (Key in [VK_BACK,VK_DELETE]);

  // ComboSelState := (Self.Style = csDropDownList) or DroppedDown;

  if Condition then
  begin
    if Key = VK_ESCAPE then
    begin
      Self.Text := FGrid.WideCells[FGrid.Col,FGrid.Row];
      // Self.Text := FGrid.CurrentCell;
      if Items.IndexOf(FGrid.CurrentCell) <> -1 then
        ItemIndex := Items.IndexOf(FGrid.CurrentCell);
    end;

    if (Key in [VK_RETURN,VK_UP,VK_DOWN,VK_TAB]) then
    begin
      FGrid.DoneInplaceEdit(Key,Shift);
      Exit;

      FGrid.WideCells[FGrid.Col,FGrid.Row] := Self.Text;

      //  FGrid.CurrentCell := Self.Text;
      if not FGrid.ValidateCell(Self.Text) then
      begin
        Self.Text := FGrid.WideCells[FGrid.Col,FGrid.Row];
        // Self.Text := FGrid.CurrentCell;
        Self.SelStart := Length(Self.Text);
        Self.Repaint;
        Exit;
      end;
      Self.Text := FGrid.WideCells[FGrid.Col,FGrid.Row];

      // Self.Text := FGrid.CurrentCell;
    end;

    // v2.4
    if (Key = VK_TAB) and (goTabs in FGrid.Options) then
    begin
      FGrid.HideInplaceEdit;
      FGrid.SetFocus;
      FGrid.TabEdit(GetKeyState(VK_SHIFT) and $8000 = $8000);
      Exit;
    end;
    //
    {
    if ComboSelState then
    begin
      FGrid.HideInplaceEdit;
      if Key in [VK_LEFT,VK_RIGHT] then
        FGrid.KeyDown(Key,Shift);

      if Key in [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_PRIOR,VK_NEXT] then Key := 0;
    end
    else
    begin
      if Key in [VK_LEFT,VK_RIGHT] then Key := 0;

      // handle Alt-Dn for combo dropdown opening
      if (Key = VK_DOWN) and (ssAlt in Shift) then
      begin
        inherited;
        Exit;
      end;
    end;
    }

    FGrid.DoneInplaceEdit(Key,Shift);

    // start added in v2.3.0.6
    Key := 0;
    inherited;
    // end added in v2.3.0.6

  end
  else
    inherited;
end;

{$ENDIF}


procedure TGridCombo.DoExit;
begin
  if FGrid.LookupHistory and (Text <> '') then
  begin
    if (Items.IndexOf(Text) = -1) then Items.Add(text);
  end;

  FGrid.HideInplaceEdit;
  inherited DoExit;
end;

procedure TGridCombo.WndProc(var Message:tMessage);
begin
  if Assigned(FGrid) then
    if (Message.Msg = FGrid.WheelMsg) then
    begin
      if Message.Wparam < 0 then
        ItemIndex := ItemIndex + 1
      else
        if ItemIndex > 0 then ItemIndex := ItemIndex - 1;

      if Assigned(FGrid.FOnComboChange) then
      begin
        FGrid.FOnComboChange(Self,FGrid.Col,FGrid.Row,ItemIndex,Items[ItemIndex]);
      end;

      if Assigned(FGrid.FOnComboObjectChange) then
      begin
        FGrid.FOnComboObjectChange(Self,FGrid.Col,FGrid.Row,ItemIndex,Items[ItemIndex],Items.Objects[ItemIndex]);
      end;

      Message.Result := 0;
      Exit;
    end;

  inherited;
end;

procedure TGridCombo.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (Msg.CharCode = VK_TAB) and (goTabs in FGrid.Options) then
    Msg.Result := 1;
end;

constructor TGridCombo.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  WorkMode := True;
  FGrid := AOwner as TAdvStringGrid;
  ButtonWidth := 16;
  ItemChange := False;
end;

procedure TGridCombo.SizeDropDownWidth;
var
  i,tw,nw: Integer;
  HasScroll: Boolean;
begin
  tw := Width;

  HasScroll := Items.Count > DropDownCount;

  for i := 1 to Items.Count do
  begin
    nw := FGrid.Canvas.TextWidth(Self.Items[i - 1]);

    if HasScroll then
    begin
      if nw > tw - 25 then
        tw := nw + 25;
    end
    else
    begin
      if nw > tw - 5 then
        tw := nw + 8;
    end;
  end;

  SendMessage(Handle,CB_SETDROPPEDWIDTH,tw,0);
end;

procedure TGridCombo.DoChange;
var
  c,s: string;
  i: Integer;
  UsrStr,AutoAdd:string;

begin
  if not WorkMode then Exit;
  if not FGrid.Lookup then Exit;

  if not FGrid.LookupCaseSensitive then
    c := AnsiUpperCase(Text)
  else
    c := Text;

  c := Copy(c,1,SelStart);

  for i:=1 to Items.Count do
  begin
    if not FGrid.LookupCaseSensitive then
      s := AnsiUpperCase(Items[i - 1])
    else
      s := Items[i - 1];

    if Pos(c,s) = 1 then
    begin
      UsrStr := Copy(Text,1,Length(c));
      AutoAdd := Copy(Items[i - 1],Length(c)+1,255);
      Text := UsrStr + AutoAdd;
      ItemIndex := i - 1;
      SendMessage(Handle,CB_SETEDITSEL,0,MakeLong(Length(c),Length(Text)));
      ItemIdx := i - 1;
      ItemChange := True;
      Exit;
    end;
  end;
end;

procedure TGridCombo.WMSetFocus(var Msg: TWMSetFocus);
var
  lpPoint: TPoint;
  i: Integer;
  hwndedit: THandle;
begin
  inherited;

  if not FGrid.LButFlg then
    Exit;

  GetCursorPos(lpPoint);
  lpPoint := ScreenToClient(lpPoint);

  if (lpPoint.x < 0) or (lpPoint.y < 0) or
     (lpPoint.x > Width) or (lpPoint.y > Height) then Exit;

  hwndEdit := FindWindowEx(Handle, 0,nil,nil);

  i := SendMessage(hwndedit,EM_CHARFROMPOS, 0,MakeLong(lpPoint.x,lpPoint.y));
  if i = -1 then
    Exit;

  SelStart := Loword(i);
  SelLength := 0;
  FGrid.LButFlg := False;
end;

procedure TGridCombo.Keypress(var Key: char);
begin
  if (Key = #13) and Assigned(FOnReturnKey) then
    FOnReturnKey(Self);

  if Key in [#13,#9] then
    Key := #0;
  inherited Keypress(Key);
end;


procedure TGridCombo.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Key <> VK_RETURN then
    inherited KeyUp(Key,shift);


  Self.DoChange;
end;

procedure TGridCombo.KeyDown(var Key: Word; Shift: TShiftState);
var
  Condition: Boolean;
  ComboSelState: Boolean;
begin
  Forced := False;

  if (Self.Style = csDropDownList) or DroppedDown then
    Condition := Key in [VK_LEFT,VK_RIGHT,VK_ESCAPE,VK_TAB,VK_RETURN]
  else
    Condition := Key in [VK_DOWN,VK_UP,VK_PRIOR,VK_NEXT,VK_END,VK_ESCAPE,VK_TAB,VK_RETURN];

  WorkMode := not (Key in [VK_BACK,VK_DELETE]);

  if (ssAlt in Shift) and (Key = VK_DOWN) then
    Condition := False;

  ComboSelState := (Self.Style = csDropDownList) or DroppedDown;

  if Condition then
  begin
    if Key = VK_ESCAPE then
    begin
      Self.Text := FGrid.CurrentCell;
      if Items.IndexOf(FGrid.CurrentCell) <> -1 then
        ItemIndex := Items.IndexOf(FGrid.CurrentCell);
    end;

    if (Key in [VK_RETURN,VK_UP,VK_DOWN,VK_TAB]) then
    begin
      FGrid.CurrentCell := Self.Text;
      if not FGrid.ValidateCell(Self.Text) then
        begin
         Self.Text := FGrid.CurrentCell;
         Self.SelStart := Length(Self.Text);
         Self.Repaint;
         Exit;
        end;
      Self.Text := FGrid.CurrentCell;
    end;

    // v2.4
    if (Key = VK_TAB) and (goTabs in FGrid.Options) then
    begin
      FGrid.HideInplaceEdit;
      FGrid.SetFocus;
      FGrid.TabEdit(GetKeyState(VK_SHIFT) and $8000 = $8000);
      Exit;
    end;
    //

    if ComboSelState then
    begin
      FGrid.HideInplaceEdit;
      if Key in [VK_LEFT,VK_RIGHT] then
        FGrid.KeyDown(Key,Shift);

      if Key in [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_PRIOR,VK_NEXT] then Key := 0;
    end
    else
    begin
      if Key in [VK_LEFT,VK_RIGHT] then Key := 0;

      // handle Alt-Dn for combo dropdown opening
      if (Key = VK_DOWN) and (ssAlt in Shift) then
      begin
        inherited;
        Exit;
      end;
    end;

    FGrid.DoneInplaceEdit(Key,Shift);

    // start added in v2.3.0.6
    Key := 0;
    inherited;
    // end added in v2.3.0.6

  end
  else
    inherited;
end;

{ TGridDatePicker }

{$IFDEF DELPHI3_LVL}

procedure TGridDatePicker.CNNotify(var Message: TWMNotify);
begin
  with Message, NMHdr^ do
  begin
    Result := 0;
    case code of
      DTN_CLOSEUP:FOldDropped := False;
      DTN_DROPDOWN:FOldDropped := True;
    end;
  end;
  inherited;
end;

procedure TGridDatePicker.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (Msg.CharCode = VK_TAB) and (goTabs in FGrid.Options) then
    Msg.Result := 1;
end;



procedure TGridDatePicker.WMNCPaint (var Message: TMessage);
var
  DC: HDC;
  arect: TRect;
  WindowBrush:hBrush;
begin
  inherited;
  DC := GetWindowDC(Handle);
  WindowBrush:=0;
  try
    WindowBrush:=CreateSolidBrush(ColorToRGB(clwindow));
    GetWindowRect(Handle, ARect);
    OffsetRect(arect,-arect.Left,-arect.Top);

    FrameRect(DC, ARect, WindowBrush);
    InflateRect(arect,-1,-1);
    FrameRect(DC, ARect, WindowBrush);
  finally
    DeleteObject(windowBrush);
    ReleaseDC(Handle,DC);
  end;
end;

constructor TGridDatePicker.Create(AOwner:tComponent);
begin
  inherited Create(AOwner);
  FGrid := AOwner as TAdvStringGrid;
end;

procedure TGridDatePicker.DoExit;
begin
  FGrid.HideInplaceEdit;
  inherited DoExit;
end;

procedure TGridDatePicker.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_ESCAPE,VK_PRIOR,VK_NEXT,VK_END,VK_RETURN,VK_TAB]) then
  begin
    if (Key = VK_ESCAPE) then
      try
        if Kind = dtkTime then
          Self.Time := StrToTime(FGrid.CurrentCell)
        else
          Self.Date := StrToDate(FGrid.CurrentCell);
      except
        Date := Now;
      end;

    // v2.4
    if (Key = VK_TAB) and (goTabs in FGrid.Options) then
    begin
      FGrid.HideInplaceEdit;
      FGrid.SetFocus;
      FGrid.TabEdit(GetKeyState(VK_SHIFT) and $8000 = $8000);
      Exit;
    end;
    //

    {$IFDEF DELPHI4_LVL}
    if not DroppedDown then
    {$ELSE}
    if not FOldDropped then
    {$ENDIF}
      FGrid.DoneInplaceEdit(Key,Shift);
  end
  else
    inherited;
end;
{$ENDIF}

{TGridEditBtn}
procedure TGridEditBtn.DoExit;
begin
  FGrid.HideInplaceEdit;
  inherited DoExit;
end;

procedure TGridEditBtn.ExtClick(Sender:TObject);
begin
  with FGrid do
    Self.Text := EllipsClick(Self.Text);

  SelStart := 0;
  SelLength := Length(Self.Text);
  Invalidate;
end;

constructor TGridEditBtn.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FGrid := AOwner as TAdvStringGrid;
  OnClickBtn := ExtClick;
end;

procedure TGridEditBtn.WMChar(var Msg:TWMChar);
begin
  if (Msg.CharCode = ord(#13)) then
    Msg.Result :=0
  else
  case FGrid.EditControl of
  edEditBtn:inherited;
  edNumericEditBtn:if (Msg.CharCode in Numeric_Characters) and
                   not ((Msg.CharCode=ord('-')) and (pos('-',text)>0)) and
                   not ((Msg.CharCode=ord('-')) and (SelStart<>0)) then inherited else MessageBeep(0);
  edFloatEditBtn:
    begin
      if Msg.CharCode in Float_Characters then
      begin
        if ((Msg.CharCode = ord(DecimalSeparator)) and
           ( (Pos(DecimalSeparator,self.Text) > 0) and (Pos(DecimalSeparator,self.SelText) = 0) )) then
          Exit;

        if (Msg.CharCode = Ord(ThousandSeparator)) then
          Exit;

        if (Msg.CharCode=ord('-')) and
           (((SelStart<>0) or (pos('-',self.Text)>0)) and not (pos('-',self.SelText)>0)) then
        begin
          MessageBeep(0);
          Exit;
        end;
        inherited;
      end;
    end;
  end;
end;

procedure TGridEditBtn.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (Msg.CharCode = VK_TAB) and (goTabs in FGrid.Options) then
    Msg.Result := 1;
end;

procedure TGridEditBtn.Keypress(var Key: Char);
begin
  inherited Keypress(Key);
  //  problem when used with Tab -> move content to new cell!
  //  FGrid.SetEditText(FGrid.Col,FGrid.Row,Text);
end;

procedure TGridEditBtn.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    inherited;
    Exit;
  end;

  if Key in [VK_DOWN,VK_UP,VK_ESCAPE,VK_RETURN,VK_PRIOR,VK_NEXT,VK_TAB] then
  begin
     if Key in [VK_RETURN,VK_UP,VK_DOWN,VK_TAB] then
    begin
      FGrid.CurrentCell := Self.Text;
      if not FGrid.ValidateCell(Self.Text) then
      begin
        Self.Text := FGrid.CurrentCell;
        SelStart := Length(Self.Text);
        Repaint;
        Exit;
      end;
      Self.Text := FGrid.CurrentCell;
    end;

    // v2.4
    if (Key = VK_TAB) and (goTabs in FGrid.Options) then
    begin
      FGrid.HideInplaceEdit;
      FGrid.SetFocus;
      FGrid.TabEdit(GetKeyState(VK_SHIFT) and $8000 = $8000);
      Exit;
    end;
    //

    if Key = VK_ESCAPE then
      Self.Text := FGrid.CurrentCell;

    FGrid.DoneInplaceEdit(Key,Shift);
  end
  else
    inherited;
end;

{TGridUnitEditBtn}
procedure TGridUnitEditBtn.DoExit;
begin
  FGrid.HideInplaceEdit;
  inherited DoExit;
end;

constructor TGridUnitEditBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGrid := AOwner as TAdvStringGrid;
end;

procedure TGridUnitEditBtn.WMChar(var Msg:TWMChar);
begin
  if Msg.CharCode = Ord(#13) then
    Msg.Result := 0
  else
    inherited;
end;

procedure TGridUnitEditBtn.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (Msg.CharCode = VK_TAB) and (goTabs in FGrid.Options) then
    Msg.Result := 1;
end;

procedure TGridUnitEditBtn.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_DOWN,VK_UP,VK_ESCAPE,VK_RETURN,VK_PRIOR,VK_NEXT,VK_TAB]) then
  begin
    if (Key in [VK_RETURN,VK_UP,VK_DOWN,VK_TAB]) then
    begin
      FGrid.CurrentCell := Self.Text;

      if not FGrid.ValidateCell(self.Text) then
      begin
        Self.Text := FGrid.CurrentCell;
        Exit;
      end;
      Self.Text := FGrid.CurrentCell;
    end;

    // v2.4
    if (Key = VK_TAB) and (goTabs in FGrid.Options) then
    begin
      FGrid.HideInplaceEdit;
      FGrid.SetFocus;
      FGrid.TabEdit(GetKeyState(VK_SHIFT) and $8000 = $8000);
      Exit;
    end;
    //

    if Key = VK_ESCAPE then
      self.Text := FGrid.CurrentCell;

    FGrid.DoneInplaceEdit(Key,Shift);
  end
  else
    inherited;
end;

{TGridButton}
procedure TGridButton.DoExit;
begin
  FGrid.HideInplaceEdit;
  inherited DoExit;
end;

constructor TGridButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGrid := AOwner as TAdvStringGrid;
end;

procedure TGridButton.CreateParams(var Params: TCreateParams);
begin
  inherited;
end;


procedure TGridButton.WMLButtonUp(var Msg:TWMLButtonUp);
begin
  with (Parent as TAdvStringGrid) do
    Self.Caption := EllipsClick(Self.Caption);
  inherited;
end;

procedure TGridButton.Keyup(var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_LEFT,VK_RIGHT,VK_DOWN,VK_UP]) then
  begin
    SendMessage(FGrid.Handle,WM_KEYDOWN,Key,0);
    Visible := False;
    Enabled := False;
    FGrid.EditMode := False;
    FGrid.SetFocus;
    SendMessage(FGrid.Handle,WM_KEYUP,Key,0);
  end;

  if Key = VK_SPACE then
  begin
    Self.Caption := FGrid.EllipsClick(Self.Caption);
    SetFocus;
    Invalidate;
  end;
end;

procedure TGridButton.Keydown(var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_ESCAPE]) then
  begin
    Visible := False;
    Enabled := False;
    FGrid.EditMode:=False;
    FGrid.SetFocus;
    if Key = VK_ESCAPE then
      FGrid.RestoreCache;
    SendMessage(FGrid.Handle,WM_KEYDOWN,Key,0);
  end
  else
    inherited;
end;

constructor TCellNode.Create(AOwner:TAdvStringGrid);
begin
  inherited Create;
  FColor := clSilver;
  FNodeColor := clBlack;
  FNodeType := cnFlat;
  FContractGlyph := TBitmap.Create;
  FExpandGlyph := TBitmap.Create;
  FOwner := AOwner;
end;

destructor TCellNode.Destroy;
begin
  FContractGlyph.Free;
  FExpandGlyph.Free;
  inherited Destroy;
end;

procedure TCellNode.SetNodeType(Value:TNodeType);
begin
  if Value <> FNodeType then
  begin
    FNodeType := Value;
    FOwner.Repaint;
  end;
end;

procedure TCellNode.SetShowTree(const Value: Boolean);
begin
  if Value <> FShowTree then
  begin
    FShowTree := Value;
    FOwner.Repaint;
  end;
end;

procedure TCellNode.SetExpandGlyph(Value:TBitmap);
begin
  FExpandGlyph.Assign(Value);
end;

procedure TCellNode.SetContractGlyph(Value:TBitmap);
begin
  FContractGlyph.Assign(Value);
end;

constructor TSizeWhileTyping.Create;
begin
  inherited Create;
end;

destructor TSizeWhileTyping.Destroy;
begin
  inherited Destroy;
end;

constructor TMouseActions.Create(AOwner: TComponent);
begin
  inherited Create;
  FGrid := AOwner as TAdvStringGrid;
end;

destructor TMouseActions.Destroy;
begin
  inherited Destroy;
end;

procedure TMouseActions.SetDisjunctColSelect(const AValue: Boolean);
begin
  FDisjunctColSelect := AValue;

  if FDisjunctColSelect and (csDesigning in FGrid.ComponentState)  then
  begin
    FDisjunctRowSelect := False;
    FDisjunctCellSelect := False;
  end;

end;

procedure TMouseActions.SetDisjunctRowSelect(const AValue: Boolean);
begin
  FDisjunctRowSelect := AValue;

  if FDisjunctRowSelect and (csDesigning in FGrid.ComponentState) then
  begin
    FDisjunctColSelect := False;
    FDisjunctCellSelect := False;
  end;

end;

procedure TMouseActions.SetDisjunctCellSelect(const AValue: Boolean);
begin
  FDisjunctCellSelect := AValue;
  if FDisjunctCellSelect and (csDesigning in FGrid.ComponentState) then
  begin
    FDisjunctRowSelect := False;
    FDisjunctColSelect := False;
  end;
end;


constructor TCellGraphic.Create;
begin
  inherited Create;
  CellCreated := False;
  CellType := ctNone;
end;

destructor TCellGraphic.Destroy;
begin
  case CellType of
  ctImages: TIntList(CellBitmap).Free;
  ctPicture: if CellCreated then TPicture(CellBitmap).Free;
  ctFilePicture: if CellCreated then TFilePicture(CellBitmap).Free;
  ctIcon: if CellCreated then CellIcon.Free;
  ctBitmap: if CellCreated then CellBitmap.Free;
  ctBitButton: if CellCreated then CellBitmap.Free;
  ctRadio: if CellCreated then TStringList(CellBitmap).Free;
  end;
  inherited Destroy;
end;

procedure TCellGraphic.Assign(Source: TPersistent);
begin
  FCellType := TCellGraphic(Source).CellType;
  FCellVAlign := TCellGraphic(Source).CellVAlign;
  FCellHAlign := TCellGraphic(Source).CellHAlign;
  FCellIndex := TCellGraphic(Source).CellIndex;
  FCellTransparent := TCellGraphic(Source).CellTransparent;
  FCellValue := TCellGraphic(Source).CellValue;
  FCellAngle := TCellGraphic(Source).CellAngle;
  FCellBoolean := TCellGraphic(Source).CellBoolean;
  FCellErrFrom := TCellGraphic(Source).CellErrFrom;
  FCellErrLen := TCellGraphic(Source).CellErrLen;
  FCellText := TCellGraphic(Source).CellText;
  FCellCreated := TCellGraphic(Source).CellCreated;


//  FCellBitmap: TBitmap read FCellBitmap write FCellBitmap;
//  FCellIcon: TIcon read FCellIcon write FCellIcon;
//  FCellCreated: Boolean read FCellCreated write FCellCreated;
end;


procedure TCellGraphic.SetBitmap(ABmp:TBitmap;Transparent: Boolean;hal:TCellHAlign;val:TCellVAlign);
begin
  CellBitmap := ABmp;
  CellType := ctBitmap;
  CellHAlign := hal;
  CellVAlign := val;
  CellTransparent := Transparent;
end;

procedure TCellGraphic.SetButton(bw,bh: Integer;Caption:string;hal:TCellHAlign;val:TCellVAlign);
begin
  CellType := ctButton;
  CellHAlign := hal;
  CellVAlign := val;
  CellIndex := MakeLong(bw,bh);
  CellBoolean := False;
  CellText := Caption;
end;

procedure TCellGraphic.SetBitButton(bw,bh: Integer;Caption:string;Glyph:TBitmap;hal:TCellHAlign;val:TCellVAlign);
begin
  CellType := ctBitButton;
  CellHAlign := hal;
  CellVAlign := val;
  CellIndex := MakeLong(bw,bh);
  CellBoolean := False;
  CellText := Caption;
  CellBitmap := Glyph;
end;


procedure TCellGraphic.SetPicture(APicture:TPicture; Transparent: Boolean;StretchMode:TStretchMode;padding: Integer;hal:TCellHAlign;val:TCellVAlign);
begin
  CellType := ctPicture;
  CellHAlign := hal;
  CellVAlign := val;
  CellBitmap := TBitmap(APicture);
  CellTransparent := Transparent;
  CellAngle := Integer(StretchMode);
  CellIndex := padding;
end;

procedure TCellGraphic.SetFilePicture(APicture: TFilePicture; Transparent: Boolean;stretchmode:TStretchMode;padding: Integer;hal:TCellHAlign;val:TCellVAlign);
begin
  CellType := ctFilePicture;
  CellHAlign := hal;
  CellVAlign := val;
  CellBitmap := TBitmap(APicture);
  CellTransparent := Transparent;
  CellAngle := Integer(StretchMode);
  CellIndex := padding;
end;

function TCellGraphic.GetPictureSize(cw,rh: Integer;hastext: Boolean): TPoint;
var
  pw,ph,w,h: Integer;
  hsi,vsi: Double;
begin
  if not (CellType in [ctPicture,ctFilePicture]) then Exit;

  if CellType = ctPicture then
  begin
    ph := TPicture(CellBitmap).Height;
    pw := TPicture(CellBitmap).Width;
  end
  else
  begin
    ph := TFilePicture(CellBitmap).Height;
    pw := TFilePicture(CellBitmap).Width;
  end;

  w := pw;
  h := ph;

  // CellIndex is spacing
  cw := cw - CellIndex;
  rh := rh - CellIndex;

  case TStretchMode(CellAngle) of
  Stretch:
    begin
      w := cw;
      h := rh;
    end;
  Shrink:
    begin
      if (w > cw) or (h > rh) then
      begin
        w := cw;
        h := rh;
      end;
    end;
  StretchWithAspectRatio:
    begin
      if w > 0 then hsi := cw/w else hsi := 1;
      if h > 0 then vsi := rh/h else vsi := 1;

      if (hsi < vsi) then
      begin
        w := cw;
        h := Round(hsi * h);
      end
      else
      begin
        h := rh;
        w := Round(vsi * w);
      end;
    end;
  ShrinkWithAspectRatio:
    begin
      if (w > cw) or (h > rh) then
      begin
        if w > 0 then hsi := cw/w else hsi := 1;
        if h > 0 then vsi := rh/h else vsi := 1;

        // allow shrink only
        if hsi > 1 then hsi := 1;
        if vsi > 1 then vsi := 1;

        if hsi < vsi then
        begin
          w := cw;
          h := Round(hsi * h);
        end
        else
        begin
          h := rh;
          w := Round(vsi * w);
        end;
      end;
    end;
  end;
  Result.x := w;
  Result.y := h;
end;

procedure TCellGraphic.SetCheckBox(Value,Data,Flat: Boolean;hal:TCellHAlign;val:TCellVAlign);
begin
  if Data then
    CellType := ctDataCheckBox
  else
    CellType := ctCheckbox;
  CellBoolean := Value;
  CellHAlign := hal;
  CellVAlign := val;
  CellTransparent := Flat;
end;

procedure TCellGraphic.SetIcon(AIcon: TIcon;hal:TCellHAlign;val:TCellVAlign);
begin
  CellType := ctIcon;
  CellIcon := aicon;
  CellHAlign := hal;
  CellVAlign := val;
end;

procedure TCellGraphic.SetDataImage(idx: Integer;hal:TCellHAlign;val:TCellVAlign);
begin
  CellType := ctDataImage;
  CellIndex := idx;
  CellHAlign := hal;
  CellVAlign := val;
end;

procedure TCellGraphic.SetMultiImage(Col,Row,dir: Integer;hal:TCellHAlign;val:TCellVAlign;notifier:TImageChangeEvent);
begin
  CellType := ctImages;
  CellHAlign := hal;
  CellVAlign := val;
  CellBoolean := dir = 0;
  CellBitmap := TBitmap(TIntList.Create(Col,Row));
  CellCreated := True;
  TIntList(CellBitmap).OnChange := notifier;
end;

procedure TCellGraphic.SetImageIdx(idx: Integer;hal:TCellHAlign;val:TCellVAlign);
begin
  CellType := ctImageList;
  CellIndex := idx;
  CellHAlign := hal;
  CellVAlign := val;
end;

procedure TCellGraphic.SetAngle(AAngle:smallint);
begin
  CellType := ctRotated;
  while AAngle < 0 do
    AAngle := AAngle + 360;

  while AAngle>360 do
    AAngle := AAngle - 360;
  CellAngle := AAngle;
end;

constructor TColumnSize.Create(AOwner:TComponent);
begin
  inherited Create;
  Owner := AOwner;
  FStretchColumn := -1;
end;

destructor TColumnSize.Destroy;
begin
  inherited Destroy;
end;

constructor TNavigation.Create;
begin
  inherited Create;
  FCopyHTMLTagsToClipboard := True;
  FAllowClipboardRowGrow := True;
  FAllowClipboardColGrow := True;
  FEditSelectAll := True;
end;

destructor TNavigation.Destroy;
begin
  inherited Destroy;
end;

procedure TNavigation.SetAutoGoto(aValue: Boolean);
begin
  FAutoGotoWhenSorted:=aValue;
end;

constructor THTMLSettings.Create;
begin
  inherited Create;
  FSaveColor := True;
  FSaveFonts := True;
  FBorderSize := 1;
  FCellSpacing := 0;
  FCellPadding := 0;
  FWidth := 100;
  FColWidths := TIntList.Create(0,0);
end;

destructor THTMLSettings.Destroy;
begin
  FColWidths.Free;
  inherited Destroy;
end;

constructor TPrintSettings.Create;
begin
  inherited Create;
  FFont:=TFont.Create;
  FHeaderFont := TFont.Create;
  FFooterFont := TFont.Create;
  FTitleLines := TStringList.Create;
  FPagePrefix := '';
  FPageSuffix := '';
  FPageNumSep := '/';
  FDateFormat := 'dd/mm/yyyy';
  FTitleSpacing := 0;
  FPageNumberOffset := 0;
  FMaxPagesOffset := 0;
end;

destructor TPrintSettings.Destroy;
begin
  FFont.Free;
  FHeaderFont.Free;
  FFooterFont.Free;
  FTitleLines.Free;
  inherited Destroy;
end;

procedure TPrintSettings.SetPrintFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TPrintSettings.SetPrintHeaderFont(Value: TFont);
begin
  FHeaderFont.Assign(Value);
end;

procedure TPrintSettings.SetPrintFooterFont(Value: TFont);
begin
  FFooterFont.Assign(Value);
end;

procedure TPrintSettings.SetTitleLines(Value: TStringlist);
begin
  FTitleLines.Assign(Value);
end;

procedure TAdvInplaceEdit.WMCopy(var Msg: TMessage);
var
  Allow: Boolean;
begin
  Allow := True;
  if Assigned(FGrid.FOnClipboardCopy) then
     FGrid.FOnClipboardCopy(Self,Allow);
  if not Allow then Exit;
  inherited;
end;

procedure TAdvInplaceEdit.WMCut(var Msg: TMessage);
var
  Allow: Boolean;
begin
  Allow := True;
  if Assigned(FGrid.FOnClipboardCut) then
     FGrid.FOnClipboardCut(Self,Allow);
  if not Allow then Exit;
  inherited;
end;

procedure TAdvInplaceEdit.WMPaste(var Msg: TMessage);
var
  Data:tHandle;
  Content:PChar;
  newstr:string;
  len:smallint;
  Newsl,Newss: Integer;
  Allow: Boolean;

  function InsertString(s:string):string;
  var
    ss: Integer;
  begin
    Result := self.Text;
    ss := SelStart;
    if SelLength = 0 then
    begin
      Insert(s,Result,ss+1);
      Newsl := 0;
      Newss := ss + Length(s);
    end
    else
    begin
      ss := SelStart;
      Delete(Result,ss + 1,selLength);
      Insert(s,Result,ss + 1);
      Newsl := Length(s);
      Newss := ss;
    end;
  end;

begin
  if not ClipBoard.HasFormat(CF_TEXT) then
    Exit;

  ClipBoard.Open;
  Data := GetClipBoardData(CF_TEXT);
  try
    if Data <> 0 then
      Content := PChar(GlobalLock(Data))
    else
      Content := nil
  finally
    if Data <> 0 then
      GlobalUnlock(Data);
  ClipBoard.Close;
  end;

  if Content = nil then
    Exit;

  Allow := True;

  NewStr := StrPas(Content);

  if Assigned(FGrid.OnClipboardBeforePasteCell) then
    FGrid.OnClipboardBeforePasteCell(Self,FGrid.Col,FGrid.Row,NewStr,Allow);

  if not Allow then
    Exit;

  Len := Length(NewStr);

  if (FLengthLimit > 0) and (Len > FLengthLimit) then
    Exit;

  NewStr := InsertString(NewStr);

  if (Length(NewStr) > FLengthLimit) and (FLengthLimit > 0) then
    Exit;

  if Assigned(FGrid.FOnClipboardPaste) then
    FGrid.FOnClipboardPaste(Self,Allow);

  if not Allow then
    Exit;

  case FGrid.EditControl of
  edNumeric,edPositiveNumeric:
    begin
      if IsType(Newstr) = atNumeric then
        self.Text := NewStr;
    end;
  edFloat:
    begin
      if IsType(NewStr) in [atNumeric,atFloat] then
        self.Text := NewStr;
    end;

  edLowerCase:self.Text := AnsiLowerCase(NewStr);
  edUpperCase:self.Text := AnsiUpperCase(NewStr);
  edMixedCase:self.Text := ShiftCase(NewStr);
  else
    self.Text := NewStr;
  end;

  SelStart := Newss;
  SelLength := Newsl;
end;


procedure TAdvInplaceEdit.DoChange;
var
  s,c,d:string;
  i: Integer;
  se,ss: Integer;

begin
  SendMessage(Handle,EM_GETSEL,Integer(@se),Integer(@ss));

  if not WorkMode or (ss <> se) then Exit;

  if FGrid.LookupCaseSensitive then
    c := EditText
  else
    c := AnsiUpperCase(EditText);

  c := Copy(c,1,SelStart);

  if not Assigned(FGrid.LookupItems) then
    Exit;

  if (FGrid.LookupItems.Count > 0) and
     FGrid.Lookup then
    for i := 0 to FGrid.LookupItems.Count-1 do
    begin
      if FGrid.LookupCaseSensitive then
        d := FGrid.LookupItems.Strings[i]
      else
        d := AnsiUpperCase(FGrid.LookupItems.Strings[i]);

      if Pos(c,d) = 1  then
      begin
        s := Copy(Text,1,Length(c)) + Copy(FGrid.LookupItems.Strings[i],Length(c)+1,255);
        EditText := s;
        SendMessage(Handle,EM_SETSEL,Length(c),Length(s));
        GotKey := False;
        Exit;
      end;
    end;
end;

procedure TAdvInplaceEdit.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (msg.CharCode = VK_TAB) and (goTabs in FGrid.Options) then
    Msg.Result := 1;
end;

procedure TAdvInplaceEdit.WMKeyDown(var Msg:TWMKeydown);
var
  Key: Char;
begin
  if Msg.CharCode = VK_ESCAPE then
    Self.Text := FGrid.OriginalCellValue;

  if (Msg.CharCode = VK_TAB) and (goTabs in FGrid.Options) then
  begin
    if not FGrid.ValidateCell(Self.Text) then
    begin
      self.Text := FGrid.CurrentCell;
      self.SelStart := Length(self.Text);
    end;

    Fgrid.HideInplaceEdit;
    FGrid.TabEdit(GetKeyState(VK_SHIFT) and $8000 = $8000);
    Exit;
  end;


  if (Msg.CharCode in [VK_UP,VK_DOWN]) and
     (GetKeystate(VK_CONTROL) and $8000 = $0) and
     (GetKeystate(VK_SHIFT) and $8000 = $0) then
  begin
    if not FGrid.ValidateCell(Self.Text) then
    begin
      self.Text := FGrid.CurrentCell;
      self.SelStart := Length(self.Text);
      Repaint;
      Exit;
    end;
    // 2.3.0.7 changed    
    self.Text := FGrid.CurrentCell;
  end;

  if (Msg.CharCode = VK_RETURN) and not FGrid.Navigation.LineFeedOnEnter and
     (GetKeystate(VK_CONTROL) and $8000 = $0) then
  begin
    if not FGrid.ValidateCell(Self.Text) then
    begin
      self.Text := FGrid.CurrentCell;
      self.SelStart := Length(self.Text);
      Repaint;
      Exit;
    end;
    // 2.3.0.7 changed
    self.Text := FGrid.CurrentCell;
  end;

  if (Msg.CharCode = VK_RETURN) and
     (GetKeystate(VK_CONTROL) and $8000 = $8000) and
     FGrid.Navigation.LineFeedOnEnter then
  begin
    Key := #13;
    inherited KeyPress(Key);
  end
  else
    inherited;
end;

procedure TAdvInplaceEdit.WMKeyUp(var Msg:TWMKeydown);
var
  i: Integer;
  pt: TPoint;
begin
  inherited;

  if SelStart > 0 then
  begin
    i := SendMessage(self.Handle,EM_POSFROMCHAR,SelStart - 1,0);
    pt.x := loword(i);
    pt.y := hiword(i);
    FGrid.EditProgress(self.Text,pt,SelStart);
  end;
end;

procedure TAdvInplaceEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  inherited;
  if Assigned(FGrid.OnDblClickCell) then
    FGrid.OnDblClickCell(FGrid,FGrid.Row,FGrid.Col);
end;

procedure TAdvInplaceEdit.WMChar(var Msg: TWMKey);
var
  OldSelStart: Integer;
  s:string;

begin
  if (Msg.CharCode = ord('.')) and
     FGrid.ExcelStyleDecimalSeparator and
     (Msg.KeyData and $400000 = $400000) then
  begin
    Msg.CharCode := Ord(DecimalSeparator);
  end;

  if (FLengthLimit>0) and (Length(Text) = FLengthLimit) and (SelLength = 0)
     and (msg.CharCode <> VK_BACK) and (msg.CharCode <> VK_ESCAPE) and
     not ((msg.CharCode = VK_RETURN) and FGrid.Navigation.AdvanceOnEnter) then
    Exit;

  if (FGrid.EditControl in [edNormal,edCapital,edUpperCase,edLowerCase,edMixedCase]) then
  begin
    if (msg.CharCode = VK_RETURN) and
       FGrid.Navigation.LineFeedOnEnter then
    begin
      DefaultHandler(Msg);
      Exit;
    end;
  end;

  case FGrid.EditControl of
  edNormal,edPassword:inherited;
  edNumeric:if (msg.CharCode in Numeric_Characters) and
              not ((msg.CharCode = ord('-')) and (pos('-',Text) > 0)) and
              not ((msg.CharCode = ord('-')) and (SelStart <> 0)) then inherited else MessageBeep(0);
  edPositiveNumeric:if msg.CharCode in Positive_Numeric_Characters then inherited else MessageBeep(0);
  edFloat:
    begin
      if msg.CharCode in Float_Characters then
      begin

        if ((Msg.CharCode = ord(DecimalSeparator)) and
           ((pos(DecimalSeparator,self.Text) > 0) and (pos(DecimalSeparator,self.SelText) = 0) )) then
          Exit;

        if (Msg.CharCode = ord(ThousandSeparator)) then
          Exit;
          
        if (msg.CharCode = ord('-')) and
           (((SelStart<>0) or (pos('-',self.Text)>0)) and not (pos('-',self.SelText)>0)) then
        begin
          MessageBeep(0);
          Exit;
        end;
        inherited;
      end;
    end;
  edCapital,edUpperCase:
    begin
      s := AnsiUpperCase(chr(msg.CharCode));
      msg.CharCode := Ord(s[1]);
      inherited;
    end;
  edLowerCase:
    begin
      s := AnsiLowerCase(chr(msg.CharCode));
      msg.CharCode := Ord(s[1]);
      inherited;
    end;
  edMixedCase:
    begin
      OldSelStart := SelStart;
      inherited;
      self.Text := ShiftCase(self.Text);
      SelStart := OldSelStart + 1;
    end;
  end;
end;

procedure TAdvInplaceEdit.WMKillFocus(var Msg: TWMKillFocus);
begin
  FGrid.FStartEditChar := #0;

  if FGrid.LookupHistory then
  begin
    if FGrid.LookupItems.IndexOf(Text) = -1 then
    begin
      FGrid.LookupItems.Add(Text);
    end;
  end;

  inherited;

  if msg.FocusedWnd <> FGrid.Handle then
  begin
    FGrid.ValidateCell(self.Text);
    FGrid.FEditing := False;
    if FGrid.EditMode then
      FGrid.EditMode := False;
    FGrid.SelectCell(FGrid.Col,FGrid.Row);
  end;

  Self.Text := FGrid.CurrentCell;

  FGrid.EditProgress(self.Text,Point(-1,-1),-1);

  FGrid.DoneEditing;
end;

procedure TAdvInplaceEdit.WMSetFocus(var Msg: TWMSetFocus);
var
  lpPoint: TPoint;
  i: Integer;
begin
  inherited;

  if Editmask <> '' then
  with FGrid do
  begin
    if not LButFlg and Navigation.ImproveMaskSel then
    begin
      SelStart := 0;
      SelLength := 1;
      Exit;
    end;
  end;

  if not FGrid.Navigation.EditSelectAll then
  begin
    SelStart := length(text);
    SelLength := 1;
  end;  

  if not FGrid.LButFlg then
    Exit;

  GetCursorPos(lpPoint);
  lpPoint := ScreenToClient(lpPoint);

  if (lpPoint.x < 0) or (lpPoint.y < 0) or
     (lpPoint.x > Width) or (lpPoint.y > Height) then
    Exit;

  i := SendMessage(Self.Handle,EM_CHARFROMPOS, 0,makelong(lpPoint.x,lpPoint.y));
  if i = -1 then
    Exit;

  SelStart := LoWord(i);
  SelLength := 0;

  FGrid.LButFlg := False;
end;


constructor TAdvInplaceEdit.Create(AOwner: TComponent);
begin
  inherited;
  FGrid := TAdvStringGrid(AOwner);
end;

procedure TAdvInplaceEdit.CreateWnd;
begin
  inherited CreateWnd;

  //FGrid := Parent as TAdvStringGrid;

  if FGrid.EditControl = edPassword then
    SendMessage(Self.Handle, EM_SETPASSWORDCHAR, Ord(FGrid.PassWordChar), 0);

  if FLengthLimit = 0 then
    FLengthLimit := FGrid.MaxEditLength;
end;

procedure TAdvInplaceEdit.CreateParams(var Params:TCreateParams);
const
  WordWraps: array[Boolean] of Integer = (0,ES_AUTOHSCROLL);

begin
  inherited CreateParams(Params);
  FGrid := (Parent as TAdvStringGrid);

  FWordWrap := FGrid.WordWrap;

  if FVAlign then
  begin
    Params.Style := Params.Style AND NOT ES_LEFT;
    Params.Style := Params.Style OR ES_RIGHT;
  end;

  if FGrid.EditControl = edPassword then
  begin
    Params.Style := Params.Style OR ES_PASSWORD;
    //multiline conflicts with ES_PASSWORD!
    Params.Style := Params.Style AND NOT ES_MULTILINE;
  end;

  Params.Style := Params.Style AND NOT WordWraps[fwordwrap];
  Params.Style := Params.Style OR ES_WANTRETURN;

  GotKey := False;
  WorkMode := True;
end;

procedure TAdvInplaceEdit.UpdateContents;
var
  AState: TGridDrawState;
  HAlign: TAlignment;
  VAlign: TVAlignment;
  WW: Boolean;

begin
  inherited UpdateContents;

  with FGrid do
  begin
    AState := [];
    GetVisualProperties(Col,Row,AState,False,False,True,Canvas.Brush,Canvas.Font,HAlign,VAlign,WW);
    Self.Color := Canvas.Brush.Color;
    Self.Font.Assign(Canvas.Font);
  end;
end;

procedure TAdvInplaceEdit.BoundsChanged;
var
  r,dr: TRect;
  Hold: Integer;
begin
  inherited;

  r := FGrid.CellRect(FGrid.Col,FGrid.Row);

  {$IFDEF DELPHI4_LVL}
  if FGrid.UseRightToLeftAlignment then
  begin
    dr := FGrid.CellRect(FGrid.LeftCol,FGrid.TopRow);
    Hold := r.Right - r.Left;
    r.Left := dr.Left - (r.Right - dr.Right);
    r.Right := r.Left + Hold;
  end;
  {$ENDIF}

  Top := r.Top;
  Left := r.Left;
  Width := r.Right - r.Left - 1;
  Height := r.Bottom - r.Top - 1;

  R := Rect(2, 2, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TAdvInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  am: TAdvanceDirection;

begin
  case Key of
  VK_BACK,VK_DELETE:WorkMode := False;

  VK_RIGHT:
  begin
    if (self.SelLength = 0) and (self.SelStart = Length(Text)) and (Shift = []) then
      with FGrid do
      begin
        if Navigation.CursorWalkEditor then
        begin
          am := Navigation.AdvanceDirection;
          Navigation.AdvanceDirection := adLeftRight;
          AdvanceEdit(Col,Row,True,True,True);
          Navigation.AdvanceDirection := am;
          Key := VK_RETURN;
        end;
      end;
  end;
  VK_LEFT:
  begin
    if (self.SelLength = 0) and (self.SelStart = 0) and (Shift = []) then
    with FGrid do
    begin
      if Navigation.CursorWalkEditor then
      begin
        am := Navigation.AdvanceDirection;
        Navigation.AdvanceDirection:=adLeftRight;
        AdvanceEdit(Col,Row,True,True,False);
        Navigation.AdvanceDirection:=am;
        Key := VK_RETURN;
      end;
    end;
  end;
  VK_UP:
  begin
    if SendMessage(self.Handle,EM_LINEFROMCHAR,SelStart,0) > 0 then Exit;
  end;
  VK_DOWN:
  begin
    if (SendMessage(self.Handle,EM_LINEFROMCHAR,SelStart,0) <
        SendMessage(self.Handle,EM_LINEFROMCHAR,Length(self.Text),0)) then
  end;
  VK_RETURN:
  begin
    // ctrl-enter pressed for a new line
    if ssCtrl in Shift then
    with FGrid do
      if  FSizeWhileTyping.Height and MultiLineCells then
      begin
        if LinesInText(self.Text + #13#10 + ' ',FMultiLineCells) < MaxLinesInRow(Row) then
          AutoSizeRow(Row)
        else
          SizeToLines(Row,LinesInText(self.Text + #13#10 + ' ',FMultiLineCells),2 * FXYOffset.Y);

        if Assigned(OnEndRowSize) then
          OnEndRowSize(FGrid,Row);
      end;
  end
  else
    WorkMode := True;
  end;

  inherited KeyDown(Key,shift);
end;

procedure TAdvInplaceEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Key in [VK_LEFT,VK_RIGHT] then
    Exit;

  inherited KeyUp(Key,shift);

  self.DoChange;

  with FGrid do
  begin
    if FSizeWhileTyping.Width then
    begin
      SizeToWidth(Col,True);
    end;

    if FSizeWhileTyping.Height and WordWrap then
    begin
      AutoSizeRow(Row);
      if Assigned(OnEndRowSize) then
        OnEndRowSize(FGrid,Row);
    end;
  end;
end;

procedure TAdvInplaceEdit.KeyPress(var Key: Char);
begin
  if (Key = #13) and not FGrid.Navigation.LineFeedOnEnter then
  begin
    if not FGrid.Validatecell(self.Text) then
    begin
      self.Text := FGrid.CurrentCell;
      Key := #0;
      Exit;
    end;
  end;

  inherited KeyPress(Key);

  if FGrid.Navigation.AdvanceAuto then
  if (Pos(' ',self.Text) = 0) and (self.SelStart = Length(self.Text)) and
     (self.EditMask <> '') then
  begin
    Key := #13;
    FGrid.KeyPress(Key);
  end;

end;

procedure TAdvInplaceEdit.SetVAlign(Value: Boolean);
begin
  FVAlign := Value;
  ReCreateWnd;
end;

procedure TAdvInplaceEdit.SetWordWrap(Value: Boolean);
begin
  FWordWrap := Value;
  ReCreateWnd;
end;

function TAdvStringGrid.CreateEditor: TInplaceEdit;
begin
  Result := TAdvInplaceEdit.Create(Self);
end;

constructor TAdvStringGrid.Create(AOwner:TComponent);
var
  i: Integer;
  Scrollmsg: Integer;
  mshwheel: THandle;
  VerInfo: TOSVersioninfo;

begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csAcceptsControls];

  FFooterPanel := TFooterPanel.Create(Self);
  FFooterPanel.Align := alBottom;
  FFooterPanel.Height := 0;
  FFooterPanel.BorderWidth := 0;

  FFloatingFooter := TFloatingFooter.Create(Self);

  FPrintSettings := TPrintSettings.Create;
  FHTMLSettings := THTMLSettings.Create;
  FSortSettings := TSortSettings.Create(Self);
  {$IFDEF DELPHI4_LVL}
  FDragDropSettings := TDragDropSettings.Create(Self);
  {$ENDIF}
  FControlLook := TControlLook.Create(Self);
  FNavigation := TNavigation.Create;
  FColumnSize := TColumnSize.Create(Self);
  FCellNode := TCellNode.Create(Self);
  FBands := TBands.Create(Self);
  FSizeWhileTyping := TSizeWhileTyping.Create;
  FMouseActions := TMouseActions.Create(Self);
  FColumnHeaders := TStringList.Create;
  FImageCache := THTMLPictureCache.Create;
  FColumnHeaders.OnChange := ColHeaderChanged;
  FFixedFont := TFont.Create;
  FFixedFont.Name := 'Tahoma';
  Font.Name := 'Tahoma';

  FFixedFont.OnChange := FixedFontChanged;
  FActiveCellFont := TFont.Create;
  FActiveCellFont.Style := [fsBold];
  FActiveCellFont.OnChange := FixedFontChanged;
  FActiveCellColor := clGray;
  FXYOffset := Point(2,2);
  FPushedCellButton := Point(-1,-1);
  FOldSize := -1;
  FRowHeaders := TStringList.Create;
  FRowHeaders.OnChange:=RowHeaderChanged;
  SortList := TStringList.Create;
  FLookupItems := TStringList.Create;
  FRowSelect := TList.Create;
  FColSelect := TList.Create;
  FSortIndexes := TSortIndexList.Create(0,0);
  FSortRowXRef := TIntList.Create(0,0);
  FMergedColumns := TIntList.Create(0,0);
  FSelectedCells := TIntList.Create(0,0);
  FMergedColumns.OnChange := MergedColumnsChanged;
  FRowIndicator := TBitmap.Create;
  FBackground := TBackground.Create(Self);
  FScrollHintWnd := THTMLHintWindow.Create(Self);
  FScrollHintShow := False;
  FDeselectState := False;
  FMouseDown := False;
  FCtrlDown := False;
  FMouseResize := False;
  FEnableWheel := True;
  FUpdateCount := 0;
  FMinRowHeight := 0;
  FMaxRowHeight := 0;
  FMinColWidth := 0;
  FMaxColWidth := 0;
  FGroupColumn := -1;
  FClipTopLeft := Point(-1,-1);
  FCommentColor := clRed;
  FSizeGrowOnly := False;
  
  FIntelliZoom := True;
  FEditDisable := False;
  FEditChange := False;
  FNilObjects := False;

  FTMSGradFrom := clSilver;
  FTMSGradTo := clWhite;

  FGridItems := TCollection.Create(TGridItem);
  FFilter := TFilter.Create(self);
  AutoSize := False;
  Invokedchange := False;
  {$IFDEF DELPHI3_LVL}
  FHintColor := clInfoBk;
  {$ELSE}
  FHintColor := clYellow;
  {$ENDIF}
  FSelectionColor := clHighLight;
  FSelectionTextColor := clHighLightText;
  FSelectionClick := False;
  FShowSelection := True;
  FHideFocusRect := False;
  FFixedAsButtons := False;
  FFixedCellPushed := False;
  FQuoteEmptyCells := True;
  FSelectionRectangleColor := clBlack;
  FAlwaysQuotes := False;
  FEnableHTML := True;
  FURLColor := clBlue;
  FVAlignment := vtaTop;
  FStartEditChar := #0;
  FMouseSelectMode := msNormal;
  FMouseSelectStart := -1;
  FEditLink := nil;
  InvokedFocusChange := False;
  FShowNullDates := True;
  FVirtualCells := False;
  
  ResizeAssigned := False;
  FSaveFixedCells := True;
  FSaveHiddenCells := False;
  FSaveVirtCells := True;
  FDisableChange := False;
  FFindBusy := False;
  FComboIdx := -1;
  FPrintPageFrom := 1;
  FPrintPageTo := 1;
  FPrintPageNum := 0;
  FPrinterDriverFix := False;
  FExcelClipboardFormat := False;
  FOnShowHint := nil;

  FLastHintPos := Point(-1,-1);

  if (AOwner is TForm) and not (csDesigning in ComponentState) then
  begin
    if Assigned( (AOwner as TForm).OnResize ) then
    begin
      FOnResize := (AOwner as TForm).OnResize;
      ResizeAssigned := True;
    end;

    (AOwner as TForm).OnResize := GridResize;
    PrevSizex := (AOwner as tform).Width;
    PrevSizey := (AOwner as tform).Height;
  end;

  for i := 0 to MAXCOLUMNS do
    FVisibleCol[i] := True;

  FNumHidden := 0;
  FDelimiter := #0;
  FFloatFormat := '%.2f';
  FPasswordChar := '*';
  FJavaCSV := False;
  FCheckTrue := 'Y';
  FCheckFalse := 'N';
  DefaultRowHeight := 21;
  FFixedRowHeight := DefaultRowHeight;
  ZoomFactor := 0;
  Colchgflg := True;
  Colclicked := -1;
  Rowclicked := -1;
  Colsized := False;
  Rowsized := False;
  SearchInc := '';
  LButFlg := False;
  FClearTextOnly := False;
  FSaveWithHTML := True;  

  Look := glSoft;

  {$IFDEF DELPHI4_LVL}
  FOleDropTargetAssigned := False;
  {$ENDIF}

  {$IFNDEF DELPHI3_LVL}
  Screen.Cursors[crURLcursor] := LoadCursor(HInstance,PChar(crURLcursor));
  {$ENDIF}

  FIsFlat := False;
  FScrollType := ssNormal;
  FScrollColor := clNone;
  FScrollWidth := GetSystemMetrics(SM_CXVSCROLL);

  WheelMsg := 0;
  WheelScrl := 0;
  WheelPan := False;

  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(verinfo);

  FIsWinXP := (verinfo.dwMajorVersion > 5) OR
    ((verinfo.dwMajorVersion = 5) AND (verinfo.dwMinorVersion >= 1));

  if FIsWinXP then
    FIsWinXP := FIsWinXP and IsThemeActive;

  if ((verinfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) AND
     ( (verinfo.dwMajorVersion <4) OR
       (verinfo.dwMajorVersion =4) AND (verinfo.dwMinorVersion<10)) ) or
     ( (verinfo.dwPlatformId = VER_PLATFORM_WIN32_NT) AND
       (verinfo.dwMajorVersion < 4)) then
  begin
    mshwheel := FindWindow(MSH_WHEELMODULE_CLASS,MSH_WHEELMODULE_TITLE);
    if mshwheel > 0 then
    begin
      scrollmsg := RegisterWindowMessage(MSH_SCROLL_LINES);
      wheelmsg := RegisterWindowMessage(MSH_SCROLL_LINES);
      wheelscrl := SendMessage(mshwheel,scrollmsg,0,0);
    end;
  end
  else {its win nt 4+ or Win98 ?}
  begin
    {$IFDEF TMSDEBUG}
    DbgMsg('win nt 4 found or win98 found');
    {$ENDIF}
    SystemParametersInfo(SPI_GETWHEELSCROLLLINES,0,@i,0);
    wheelscrl := i;
    wheelmsg := WM_MOUSEWHEEL;
   end;

  FRichEdit := TAdvRichEdit.Create(Self);
  FInplaceRichEdit := TAdvRichEdit.Create(Self);
  FInplaceRichEdit.OnSelectionChange := RichSelChange;
  FNotifierList := TList.Create;
  FColumnOrder := TIntList.Create(0,0);

  FOldLeftCol := LeftCol;
  FOldTopRow := TopRow;

  if not (csDesigning in ComponentState) then
  begin
    {$IFDEF DELPHI3_LVL}
    ArwU := TArrowWindow.Init(Self,arrUp);
    ArwD := TArrowWindow.Init(Self,arrDown);
    ArwL := TArrowWindow.Init(Self,arrLeft);
    ArwR := TArrowWindow.Init(Self,arrRight);
    {$ENDIF}

    EditCombo := TGridcombo.Create(Self);
    EditCombo.Parent := Self;
    EditCombo.Enabled := False;
    EditCombo.Visible := False;
    EditCombo.IsWinXP := FIsWinXP;

    EditMode := False;
    EditControl := edNormal;

    EditSpin := TGridSpin.Create(Self);
    EditSpin.Parent := Self;
    EditSpin.Enabled := False;
    EditSpin.Visible := False;
    EditSpin.Borderstyle := bsNone;
    EditSpin.IsWinXP := FIsWinXP;

    {$IFDEF TMSUNICODE}
    EditUni := TGridUniEdit.Create(Self);
    EditUni.Parent := Self;
    EditUni.Enabled := False;
    EditUni.Visible := False;
    EditUni.Borderstyle := bsNone;

    ComboUni := TGridUniCombo.Create(Self);
    ComboUni.Parent := Self;
    ComboUni.Enabled := False;
    ComboUni.Visible := False;
    ComboUni.IsWinXP := FIsWinXP;
    {$ENDIF}

    {$IFDEF DELPHI3_LVL}
    if ComCtrlOk then
    begin
      EditDate := TGridDatePicker.Create(Self);
      // EditDate.Parent := Self;
      EditDate.Enabled := False;
      EditDate.Visible := False;
    end;
    {$ENDIF}

    EditCheck := TGridcheckbox.Create(Self);
    EditCheck.Parent := Self;
    EditCheck.Enabled := False;
    EditCheck.Visible := False;

    EditBtn := TGridEditBtn.Create(Self);
    EditBtn.Parent := Self;
    EditBtn.Enabled := False;
    EditBtn.Visible := False;
    EditBtn.ButtonCaption := '...';
    EditBtn.Borderstyle := bsNone;
    EditBtn.IsWinXP := FIsWinXP;

    UnitEditBtn := TGridUnitEditBtn.Create(Self);
    UnitEditBtn.Parent := Self;
    UnitEditBtn.Enabled := False;
    UnitEditBtn.Visible := False;
    UnitEditBtn.Buttoncaption := '...';
    UnitEditBtn.BorderStyle := bsNone;

    Gridbutton := TGridbutton.Create(Self);
    Gridbutton.Parent := Self;
    Gridbutton.Enabled := False;
    Gridbutton.Visible := False;

    MoveButton := TPopupButton.Create(Self);
    MoveButton.Parent := Self;
    MoveButton.Enabled := False;
    MoveButton.Visible := False;

    FEditControl := TControlEdit.Create(Self);
    FEditControl.Visible := False;

    FComboControl := TControlCombo.Create(Self);
    FComboControl.Visible := False;

    FCtrlEditing := False;
  end;

  {$IFDEF FREEWARE}
  cla := self.ClassName;
  {$ENDIF}
end;

destructor TAdvStringGrid.Destroy;
begin
  if Owner is TForm then  // restore owner resize Handler
  begin
    (Owner as TForm).OnResize := FOnResize;
  end;

  if FColumnSize.Save then
    SaveColSizes;
  FClearTextOnly := False;

  Self.Clear;
  FFloatingFooter.Free;
  FSortRowXRef.Free;
  FMergedColumns.Free;
  FSelectedCells.Free;
  FNotifierList.Free;
  FPrintSettings.Free;
  FHTMLSettings.Free;
  FSortSettings.Free;
  {$IFDEF DELPHI4_LVL}
  FDragDropSettings.Free;
  {$ENDIF}
  FControlLook.Free;
  FNavigation.Free;
  FColumnSize.Free;
  FColumnOrder.Free;
  FCellNode.Free;
  FBands.Free;
  FSizeWhileTyping.Free;
  FImageCache.Free;
  FMouseActions.Free;
  FColumnHeaders.Free;
  FFixedFont.Free;
  FActiveCellFont.Free;
  FRowHeaders.Free;
  FLookupItems.Free;
  FRowSelect.Free;
  FColSelect.Free;
  FSortIndexes.Free;
  FRowIndicator.Free;
  FBackground.Free;
  FScrollHintWnd.Free;
  FFooterPanel.Free;

  {$IFDEF DELPHI3_LVL}
  if not (csDesigning in ComponentState) then
  begin
    ArwU.Free;
    ArwD.Free;
    ArwL.Free;
    ArwR.Free;
  end;
  {$ENDIF}

  SortList.Free;

  FGridItems.Free;
  FFilter.Free;

  Cursor := FOldCursor;
  FRichEdit.Free;
  FInplaceRichEdit.Free;

  if not (csDesigning in ComponentState) then
  begin
    EditCombo.Free;
    EditSpin.Free;
    
    {$IFDEF TMSUNICODE}
    EditUni.Free;
    ComboUni.Free;
    {$ENDIF}

    {$IFDEF DELPHI3_LVL}
    if ComCtrlOk then
      EditDate.Free;
    {$ENDIF}
    EditCheck.Free;
    EditBtn.Free;
    UnitEditBtn.Free;
    Gridbutton.Free;
    MoveButton.Free;
    FEditControl.Free;
    FComboControl.Free;
  end;

  inherited Destroy;
end;

procedure TAdvStringGrid.DestroyWnd;
begin
  inherited DestroyWnd;
end;

procedure TAdvStringGrid.CreateWnd;
begin
  inherited CreateWnd;

  if not (Parent is TWinControl) then Exit;

  if not (csDesigning in ComponentState) then
    EditDate.Parent := Self;

  FRichEdit.Parent := Self;
  FRichEdit.Visible := False;
  FRichEdit.Left := 0;
  FRichEdit.Top := 0;
  FRichEdit.Width := 0;
  FRichEdit.Height := 0;
  FRichEdit.BorderStyle := bsNone;
  SetTranspWindow(FRichEdit.Handle);

  FFooterPanel.Parent := Self;
  FFooterPanel.Visible := FFloatingFooter.Visible;

  if FColumnSize.Save then
    LoadColSizes;

  FGridTimerID := SetTimer(Handle,111,500,Nil);
end;


procedure TAdvStringGrid.Invalidate;
begin
  if FEditChange then
  begin
    FEditChange := false;
    Exit;
  end;
  inherited;
end;

{$IFDEF DELPHI4_LVL}
procedure TAdvStringGrid.Resize;
begin
  inherited;
  if Assigned(FOnGridResize) then
    FOnGridResize(Self);
end;
{$ENDIF}


procedure TAdvStringGrid.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if FIntegralHeight and (FUpdateCount = 0) then
  begin
    if VisibleColCount + FixedCols < ColCount then
    begin
      AHeight := AHeight - (AHeight mod DefaultRowHeight) - 1;
    end
    else
    begin
      AHeight := AHeight + DefaultRowHeight
        - (AHeight mod DefaultRowHeight) - 1 - GetSystemMetrics(SM_CYHSCROLL);
    end;
  end;

  inherited SetBounds(ALeft,ATop,AWidth,AHeight);

  if Assigned(Parent) then
    if Parent.HandleAllocated then
      NCPaintProc;
end;

procedure TAdvStringGrid.Loaded;
begin
  inherited;

  FOldCursor := Cursor;
  ShowColumnHeaders;
  ShowRowHeaders;
  {$IFDEF DELPHI3_LVL}
  crURLCursor := crHandPoint;
  {$ENDIF}

  {$IFDEF DELPHI4_LVL}
  with FDragDropSettings do
  if FOleDropTargetAssigned then
  begin
    FGridDropTarget.AcceptText := FOleAcceptText;
    FGridDropTarget.AcceptFiles := FOleAcceptFiles;
  end;
  {$ENDIF}
  if FColumnSize.Save then
    LoadColSizes;

  MinRowHeight := DefaultRowHeight;
  MinColWidth := 10;  
end;


procedure TAdvStringGrid.GetCellHint(ACol, ARow: Integer;
  var AHint: string);
begin
  if Assigned(FOnGridHint) then
  begin
    FOnGridHint(Self,ARow,ACol,AHint);
  end;
end;


procedure TAdvStringGrid.GetCellColor(ACol,ARow: Integer;AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  RACol: Integer;
  cp: TCellProperties;

begin
  if FActiveCellShow then
  begin
    RACol := RemapColInv(ACol);
    if ((Row = ARow) and (RACol = 0) and (FixedCols > 0)) or
       ((Col = RACol) and (ARow = 0) and (FixedRows > 0)) then
    begin
      AFont.Assign(FActiveCellFont);
      ABrush.Color := ActiveCellColor;
    end;
  end;

  if HasCellProperties(ACol,ARow) then
  begin
    cp := CellProperties[ACol,ARow];

    if cp.BrushColor <> clNone then
      ABrush.Color := cp.BrushColor;

    if cp.FontColor <> clNone then
      AFont.Color := cp.FontColor;

    if cp.FontStyle <> [] then
      AFont.Style := cp.FontStyle;

    if cp.FontSize <> 0 then
      AFont.Size := cp.FontSize;

    if cp.FontName <> '' then
      AFont.Name := cp.FontName;
  end;

  if Assigned(OnGetCellColor) then
    OnGetCellColor(self,ARow,ACol,AState,ABrush,AFont);
end;

procedure TAdvStringGrid.GetCellBorder(ACol,ARow: Integer; APen:TPen;var Borders:TCellBorders);
begin
  if Assigned(OnGetCellBorder) then
    OnGetCellBorder(self,ARow,ACol,APen,Borders);
end;

procedure TAdvStringGrid.GetCellPrintBorder(ACol,ARow: Integer; APen:TPen;var borders:TCellBorders);
begin
  if Assigned(OnGetCellPrintBorder) then
    OnGetCellPrintBorder(self,ARow,ACol,APen,Borders);
end;

procedure TAdvStringGrid.GetCellPrintColor(ACol,ARow: Integer;AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
  if Assigned(OnGetCellPrintColor) then
    OnGetCellPrintColor(self,ARow,ACol,AState,ABrush,AFont);
end;

procedure TAdvStringGrid.GetCellAlign(ACol,ARow: Integer;var HAlign: TAlignment;var VAlign: TVAlignment);
begin
  if Assigned(OnGetAlignment) then
    OnGetAlignment(Self,ARow,ACol,HAlign,VAlign);
end;

procedure TAdvStringGrid.GetColFormat(ACol: Integer;var AStyle:TSortStyle;var aPrefix,aSuffix:string);
begin
  if Assigned(OnGetFormat) then
    OnGetFormat(Self,ACol,AStyle,aPrefix,aSuffix);
end;

procedure TAdvStringGrid.GetCellEditor(ACol,ARow: Integer;var AEditor:TEditorType);
begin
  if Assigned(OnGetEditorType) then
    OnGetEditorType(Self,ACol,ARow,AEditor);
end;

procedure TAdvStringGrid.GetCellFixed(ACol,ARow: Integer;var IsFixed: Boolean);
begin
  IsFixed := IsFixed or ((FFixedRowAlways and (ARow = 0) and (RowCount = 1)) or
             (FFixedColAlways and (ACol = 0) and (ColCount = 1)) or
             (ACol < FixedCols) or (ARow < FixedRows));

  if Assigned(OnIsFixedCell) and not IsFixed then
    OnIsFixedCell(Self,ARow,ACol,IsFixed);
end;

procedure TAdvStringGrid.GetCellReadOnly(ACol,ARow: Integer;var IsReadOnly: Boolean);
var
  BC: TPoint;
begin
  BC := BaseCell(ACol,ARow);
  if Assigned(OnCanEditCell) then
    OnCanEditCell(Self,BC.Y,BC.X,IsReadOnly);
end;

procedure TAdvStringGrid.GetCellPassword(ACol,ARow: Integer;var IsPassword: Boolean);
begin
  if Assigned(OnIsPasswordCell) then
    OnIsPasswordCell(self,ARow,ACol,IsPassword);
end;

function TAdvStringGrid.GetCheckTrue(ACol,ARow: Integer): string;
begin
  Result := FCheckTrue;

  if Assigned(OnGetCheckTrue) then
    OnGetCheckTrue(Self,ACol,ARow,Result);

end;

function TAdvStringGrid.GetCheckFalse(ACol,ARow: Integer): string;
begin
  Result := FCheckFalse;

  if Assigned(OnGetCheckFalse) then
    OnGetCheckFalse(Self,ACol,ARow,Result);
end;

function TAdvStringGrid.GetFilter(ACol: Integer): Boolean;
begin
  Result := False;
end;


procedure TAdvStringGrid.SaveColSizes;
var
  i: Integer;
  {$IFDEF DELPHI4_LVL}
  IniFile: TCustomIniFile;
  {$ELSE}
  IniFile: TIniFile;
  {$ENDIF}

begin
  if (FColumnSize.Key<>'') and
     (FColumnSize.Section<>'') and
     (not (csDesigning in ComponentState)) then
  begin
    {$IFDEF DELPHI4_LVL}
    if FColumnSize.Location = clRegistry then
      IniFile := TRegistryIniFile.Create(FColumnSize.Key)
    else
    {$ENDIF}
      IniFile := TIniFile.Create(FColumnSize.Key);

    with IniFile do
    begin
      for i := 0 to ColCount - 1 do
      begin
        WriteInteger(FColumnSize.section,'Col'+inttostr(i),ColWidths[i]);
      end;
    end;
    IniFile.Free;
  end;
end;

procedure TAdvStringGrid.LoadColSizes;
var
  i: Integer;
  {$IFDEF DELPHI4_LVL}
  IniFile: TCustomIniFile;
  {$ELSE}
  IniFile: TIniFile;
  {$ENDIF}
  NewWidth: Integer;
begin
  if (FColumnSize.Key<>'') and
     (FColumnSize.Section<>'') and
     (not (csDesigning in ComponentState)) then
  begin
    {$IFDEF DELPHI4_LVL}
    if FColumnSize.location = clRegistry then
      IniFile := TRegistryIniFile.Create(FColumnSize.Key)
    else
    {$ENDIF}
      IniFile := TIniFile(tIniFile.Create(FColumnSize.Key));

    with IniFile do
    begin
      for i := 0 to ColCount - 1 do
      begin
        NewWidth := ReadInteger(FColumnSize.Section,'Col'+inttostr(i),DefaultColWidth);
        if (NewWidth <> ColWidths[i]) then
        begin
          ColWidths[i] := NewWidth;
        end;
      end;
    end;
    IniFile.Free;
  end;
end;

procedure TAdvStringGrid.SaveColPositions;
var
  i: Integer;
  {$IFDEF DELPHI4_LVL}
  IniFile: TCustomIniFile;
  {$ELSE}
  IniFile: TIniFile;
  {$ENDIF}

begin
  if (FColumnSize.Key<>'') and
     (FColumnSize.Section<>'') and
     (not (csDesigning in ComponentState)) then
  begin
    {$IFDEF DELPHI4_LVL}
    if FColumnSize.Location = clRegistry then
      IniFile := TRegistryIniFile.Create(FColumnSize.Key)
    else
    {$ENDIF}
      IniFile := TIniFile.Create(FColumnSize.Key);

    with IniFile do
    begin
      for i := 1 to FColumnOrder.Count do
      begin
        WriteInteger(FColumnSize.section,'Pos'+inttostr(i-1),FColumnOrder.Items[i - 1]);
      end;
    end;
    IniFile.Free;
  end;
end;

procedure TAdvStringGrid.LoadColPositions;
var
  i: Integer;
  {$IFDEF DELPHI4_LVL}
  IniFile: TCustomIniFile;
  {$ELSE}
  IniFile: TIniFile;
  {$ENDIF}
  NewPos: Integer;
begin
  if (FColumnSize.Key<>'') and
     (FColumnSize.Section<>'') and
     (not (csDesigning in ComponentState)) then
  begin
    {$IFDEF DELPHI4_LVL}
    if FColumnSize.location = clRegistry then
      IniFile := TRegistryIniFile.Create(FColumnSize.Key)
    else
    {$ENDIF}
      IniFile := TIniFile(TIniFile.Create(FColumnSize.Key));

    with IniFile do
    begin
      FColumnOrder.Clear;
      for i := 0 to ColCount - 1 do
      begin
        NewPos := ReadInteger(FColumnSize.Section,'Pos'+inttostr(i),-1);
        if (NewPos <> -1) then
          FColumnOrder.Add(NewPos);
      end;

      if FColumnOrder.Count > 0 then
        ResetColumnOrder;
    end;
    IniFile.Free;
  end;
end;


procedure TAdvStringGrid.SavePrintSettings(Key,Section:string);
var
  IniFile: TIniFile;

  function Bool2String(b: Boolean): string;
  begin
    if b then Result := 'Y' else Result := 'N';
  end;

  function Set2Int(fs:TFont): Integer;
  begin
    Result :=0;
    if (fsBold in fs.Style) then Result := Result + 1;
    if (fsItalic in fs.Style) then Result := Result + 2;
    if (fsUnderLine in fs.Style) then Result := Result + 4;
    if (fsStrikeOut in fs.Style) then Result := Result + 8;
  end;


begin
  IniFile := TIniFile.Create(Key);

  IniFile.writeInteger(section,'ColumnSpacing',FPrintSettings.ColumnSpacing);
  IniFile.WriteInteger(section,'RowSpacing',FPrintSettings.RowSpacing);
  IniFile.WriteInteger(section,'TitleSpacing',FPrintSettings.TitleSpacing);

  IniFile.writeInteger(section,'FixedHeight',FPrintSettings.FixedHeight);
  IniFile.writeInteger(section,'FixedWidth',FPrintSettings.FixedWidth);

  IniFile.WriteString(section,'Centered',bool2string(FPrintSettings.Centered));
  IniFile.WriteString(section,'NoAutoSize',bool2string(FPrintSettings.NoAutoSize));
  IniFile.WriteString(section,'UseFixedHeight',bool2string(FPrintSettings.UseFixedHeight));
  IniFile.WriteString(section,'UseFixedWidth',bool2string(FPrintSettings.UseFixedWidth));
  IniFile.WriteString(section,'RepeatFixedRows',bool2string(FPrintSettings.RepeatFixedRows));
  IniFile.WriteString(section,'RepeatFixedCols',bool2string(FPrintSettings.RepeatFixedCols));

  IniFile.WriteInteger(section,'Borders',ord(FPrintSettings.Borders));
  IniFile.WriteInteger(section,'BorderStyle',ord(FPrintSettings.BorderStyle));
  IniFile.WriteInteger(section,'Date',ord(FPrintSettings.Date));
  IniFile.WriteInteger(section,'PageNr',ord(FPrintSettings.PageNr));
  IniFile.WriteInteger(section,'Title',ord(FPrintSettings.Title));
  IniFile.WriteInteger(section,'Time',ord(FPrintSettings.Time));

  IniFile.WriteString(section,'DateFormat',FPrintSettings.DateFormat);
  IniFile.WriteString(section,'TitleText',FPrintSettings.TitleText);

  IniFile.WriteInteger(section,'FooterSize',FPrintSettings.FooterSize);
  IniFile.WriteInteger(section,'HeaderSize',FPrintSettings.HeaderSize);
  IniFile.WriteInteger(section,'LeftSize',FPrintSettings.LeftSize);
  IniFile.WriteInteger(section,'RightSize',FPrintSettings.RightSize);

  IniFile.WriteInteger(section,'FitToPage',ord(FPrintSettings.FitToPage));

  IniFile.WriteString(section,'FontName',FPrintSettings.Font.name);
  IniFile.WriteInteger(section,'FontSize',FPrintSettings.Font.Size);
  IniFile.WriteInteger(section,'FontStyle',Set2Int(FPrintSettings.Font));
  IniFile.WriteInteger(section,'FontColor',Integer(FPrintSettings.Font.Color));

  IniFile.WriteString(section,'HeaderFontName',FPrintSettings.HeaderFont.name);
  IniFile.WriteInteger(section,'HeaderFontSize',FPrintSettings.HeaderFont.Size);
  IniFile.WriteInteger(section,'HeaderFontStyle',Set2Int(FPrintSettings.HeaderFont));
  IniFile.WriteInteger(section,'HeaderFontColor',ord(FPrintSettings.HeaderFont.Color));

  IniFile.WriteString(section,'FooterFontName',FPrintSettings.FooterFont.name);
  IniFile.WriteInteger(section,'FooterFontSize',FPrintSettings.FooterFont.Size);
  IniFile.WriteInteger(section,'FooterFontStyle',Set2Int(FPrintSettings.FooterFont));
  IniFile.WriteInteger(section,'FooterFontColor',ord(FPrintSettings.FooterFont.Color));

  IniFile.WriteString(section,'PageNumSep',FPrintSettings.PageNumSep);
  IniFile.WriteString(section,'PageSuffix',FPrintSettings.PageSuffix);
  IniFile.WriteString(section,'PagePrefix',FPrintSettings.PagePrefix);

  IniFile.WriteInteger(section,'Orientation',ord(FPrintSettings.Orientation));

  IniFile.WriteString(section,'TitleLines',LFToCLF(FPrintSettings.TitleLines.Text));

  IniFile.Free;
end;

procedure TAdvStringGrid.LoadPrintSettings(Key,Section:string);
var
  IniFile: TIniFile;

  function Int2Set(i: Integer;fs:TFont): Integer;
  begin
    Result := 0;
    if i and 1 > 0 then fs.Style := fs.Style + [fsBold];
    if i and 2 > 0 then fs.Style := fs.Style + [fsItalic];
    if i and 4 > 0 then fs.Style := fs.Style + [fsUnderLine];
    if i and 8 > 0 then fs.Style := fs.Style + [fsStrikeOut];
  end;

  function Int2Pos(i: Integer):TPrintPosition;
  begin
    case i of
    0:Result := ppNone;
    1:Result := ppTopLeft;
    2:Result := ppTopRight;
    3:Result := ppTopCenter;
    4:Result := ppBottomLeft;
    5:Result := ppBottomRight;
    6:Result := ppBottomCenter;
    else Result := ppNone;
    end;
  end;

begin
  IniFile := TIniFile.Create(Key);

  FPrintSettings.ColumnSpacing := IniFile.readInteger(Section,'ColumnSpacing',20);
  FPrintSettings.RowSpacing := IniFile.readInteger(Section,'RowSpacing',20);
  FPrintSettings.TitleSpacing := IniFile.readInteger(Section,'TitleSpacing',20);

  FPrintSettings.FixedHeight := IniFile.readInteger(Section,'FixedHeight',0);
  FPrintSettings.FixedWidth := IniFile.readInteger(Section,'FixedWidth',0);

  FPrintSettings.Centered := IniFile.ReadString(Section,'Centered','Y')='Y';
  FPrintSettings.NoAutoSize := IniFile.ReadString(Section,'NoAutoSize','N')='Y';
  FPrintSettings.UseFixedHeight := IniFile.ReadString(Section,'UseFixedHeight','N')='Y';
  FPrintSettings.UseFixedWidth := IniFile.ReadString(Section,'UseFixedWidth','N')='Y';
  FPrintSettings.RepeatFixedRows := IniFile.ReadString(Section,'RepeatFixedRows','N')='Y';
  FPrintSettings.RepeatFixedCols := IniFile.ReadString(Section,'RepeatFixedCols','N')='Y';

  FPrintSettings.DateFormat := IniFile.ReadString(Section,'DateFormat','');
  FPrintSettings.TitleText := IniFile.ReadString(Section,'TitleText','');

  FPrintSettings.FooterSize := IniFile.ReadInteger(Section,'FooterSize',100);
  FPrintSettings.HeaderSize := IniFile.ReadInteger(Section,'HeaderSize',100);
  FPrintSettings.LeftSize := IniFile.ReadInteger(Section,'LeftSize',100);
  FPrintSettings.RightSize := IniFile.ReadInteger(Section,'RightSize',100);

  FPrintSettings.PageNumSep := IniFile.ReadString(Section,'PageNumSep','');
  FPrintSettings.PageSuffix := IniFile.ReadString(Section,'PageSuffix','');
  FPrintSettings.PagePrefix := IniFile.ReadString(Section,'PagePrefix','');

  case IniFile.ReadInteger(Section,'Borders',0) of
  0:FPrintSettings.Borders := pbNoborder;
  1:FPrintSettings.Borders := pbSingle;
  2:FPrintSettings.Borders := pbDouble;
  3:FPrintSettings.Borders := pbVertical;
  4:FPrintSettings.Borders := pbHorizontal;
  5:FPrintSettings.Borders := pbAround;
  6:FPrintSettings.Borders := pbAroundVertical;
  7:FPrintSettings.Borders := pbAroundHorizontal;
  8:FPrintSettings.Borders := pbCustom;
  end;

  case IniFile.ReadInteger(Section,'BorderStyle',0) of
  0:FPrintSettings.BorderStyle := psSolid;
  1:FPrintSettings.BorderStyle := psDash;
  2:FPrintSettings.BorderStyle := psDot;
  3:FPrintSettings.BorderStyle := psDashDot;
  4:FPrintSettings.BorderStyle := psDashDotDot;
  5:FPrintSettings.BorderStyle := psClear;
  6:FPrintSettings.BorderStyle := psInsideFrame;
  end;

  FPrintSettings.Date := int2pos(IniFile.ReadInteger(Section,'Date',0));
  FPrintSettings.PageNr := int2pos(IniFile.ReadInteger(Section,'PageNr',0));
  FPrintSettings.Title := int2pos(IniFile.ReadInteger(Section,'Title',0));
  FPrintSettings.Time := int2pos(IniFile.ReadInteger(Section,'Time',0));

  case IniFile.readInteger(Section,'FitToPage',0) of
  0:FPrintSettings.FitToPage := fpNever;
  1:FPrintSettings.FitToPage := fpGRow;
  2:FPrintSettings.FitToPage := fpShrink;
  3:FPrintSettings.FitToPage := fpAlways;
  4:FPrintSettings.FitToPage := fpCustom;
  end;

  FPrintSettings.Font.name := IniFile.ReadString(Section,'FontName','Arial');
  FPrintSettings.Font.Size := IniFile.ReadInteger(Section,'FontSize',10);
  Int2Set(IniFile.ReadInteger(Section,'FontStyle',0),FPrintSettings.Font);
  FPrintSettings.Font.Color := IniFile.ReadInteger(Section,'FontColor',clBlack);

  FPrintSettings.HeaderFont.name := IniFile.ReadString(Section,'HeaderFontName','Arial');
  FPrintSettings.HeaderFont.Size := IniFile.ReadInteger(Section,'HeaderFontSize',10);
  Int2Set(IniFile.ReadInteger(Section,'HeaderFontStyle',0),FPrintSettings.HeaderFont);
  FPrintSettings.HeaderFont.Color := IniFile.ReadInteger(Section,'HeaderFontColor',clBlack);

  FPrintSettings.FooterFont.name := IniFile.ReadString(Section,'FooterFontName','Arial');
  FPrintSettings.FooterFont.Size := IniFile.ReadInteger(Section,'FooterFontSize',10);
  Int2Set(IniFile.ReadInteger(Section,'FooterFontStyle',0),FPrintSettings.FooterFont);
  FPrintSettings.FooterFont.Color := IniFile.ReadInteger(Section,'FooterFontColor',clBlack);

  FPrintSettings.TitleLines.Text := CLFToLF(IniFile.ReadString(Section,'TitleLines',''));

  case IniFile.ReadInteger(Section,'Orientation',0) of
  0:FPrintSettings.Orientation := poPortrait;
  1:FPrintSettings.Orientation := poLandScape;
  end;

  IniFile.Free;
end;


procedure TAdvStringGrid.AddRadio(ACol,ARow,DirRadio,IdxRadio: Integer;sl:TStrings);
begin
  with CreateCellGraphic(ACol,ARow) do
  begin
    CellType := ctRadio;
    CellAngle := sl.Count;
    CellBoolean := (DirRadio <> 0);
    CellIndex := IdxRadio;
    CellBitmap := TBitmap(sl);
  end;
end;

function TAdvStringGrid.CreateRadio(ACol,ARow,DirRadio,IdxRadio: Integer): TStrings;
begin
  with CreateCellGraphic(ACol,ARow) do
  begin
    CellType := ctRadio;
    CellAngle := 0;
    CellBoolean := (DirRadio <> 0);
    CellIndex := IdxRadio;
    CellBitmap := TBitmap(TStringList.Create);
    CellCreated := True;
    Result := TStrings(CellBitmap);
  end;
end;

function TAdvStringGrid.GetRadioIdx(ACol,ARow: Integer;var IdxRadio: Integer): Boolean;
var
  cg: TCellGraphic;
begin
  Result := False;
  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then
    Exit;
  Result := cg.CellType = ctRadio;
  IdxRadio := cg.CellIndex;
end;

function TAdvStringGrid.SetRadioIdx(ACol,ARow,IdxRadio: Integer): Boolean;
var
  cg: TCellGraphic;
begin
  Result :=False;

  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then
    Exit;
  Result := cg.CellType = ctRadio;
  cg.CellIndex := IdxRadio;
end;


function TAdvStringGrid.GetRadioStrings(ACol,ARow: Integer): TStrings;
var
  cg: TCellGraphic;
  BC: TPoint;
begin
  Result := nil;

  BC := BaseCell(ACol,ARow);

  cg := GetCellGraphic(BC.X,BC.Y);
  if cg = nil then
    Exit;

  if cg.CellType = ctRadio then
    Result := TStrings(cg.CellBitmap);
end;

function TAdvStringGrid.IsRadio(ACol,ARow: Integer): Boolean;
var
  cg: TCellGraphic;
  BC: TPoint;
begin
  Result := False;

  BC := BaseCell(ACol,ARow);

  cg := GetCellGraphic(BC.X,BC.Y);
  if cg = nil then
    Exit;
  Result := cg.CellType = ctRadio;
end;

procedure TAdvStringGrid.RemoveRadio(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctRadio);
end;

procedure TAdvStringGrid.AddNode(ARow,Span: Integer);
var
  i: Integer;
begin
  ARow := RemapRow(ARow);
  with CreateCellGraphic(0,ARow) do
  begin
    CellType := ctNode;
    CellAngle := ARow;
    CellBoolean := False;
    CellIndex := Span;
    CellHAlign := haBeforeText;
    CellVAlign := vaCenter;
  end;

  for i := 1 to Span do
   CellProperties[0,ARow + i - 1].NodeLevel := 1;
  
  if FNumNodes = 0  then
    InvalidateCol(0);
    
  Inc(FNumNodes);
  if Col = 0  then
    Col := Col + 1;
end;

procedure TAdvStringGrid.RemoveNode(ARow: Integer);
var
  i: Integer;
begin
  ExpandNode(ARow);

  for i := 1 to GetNodeSpan(ARow) do
   CellProperties[0,ARow + i - 1].NodeLevel := 0;

  ARow := RemapRow(ARow);
  RemoveCellGraphic(0,ARow,ctNode);
  if (FNumNodes > 0) then
    Dec(FNumNodes);
end;

procedure TAdvStringGrid.RemoveAllNodes;
var
  i,j,k: Integer;
begin
  i := 0;

  while (i < RowCount) do
  begin
    if IsNode(i) then
    begin
      ExpandNode(i);
      k := GetNodeSpan(i);
      for j := 1 to k do
        CellProperties[0,i + j - 1].NodeLevel := 0;

      k := i + k;
      i := RemapRow(i);
      RemoveCellGraphic(0,i,ctNode);
      if (FNumNodes > 0) then
        Dec(FNumNodes);
      i := k;  
    end
    else
      inc(i);
  end;
end;


function TAdvStringGrid.GetNodeState(ARow: Integer): Boolean;
var
  cg: TCellGraphic;
begin
  Result := False;
  cg := GetCellGraphic(0,ARow);

  if cg = nil then
    Exit;
  if cg.CellType = ctNode then Result := cg.CellBoolean;
end;


procedure TAdvStringGrid.SetNodeState(ARow: Integer;Value: Boolean);
var
  cg:TCellGraphic;

begin
  cg := GetCellGraphic(0,ARow);
  if cg = nil then
    Exit;

  ARow := RemapRowInv(ARow);

  if cg.CellType = ctNode then
  begin
    if Value <> cg.CellBoolean then
    if Value then
      ContractNode(ARow)
    else
      ExpandNode(ARow);
  end;
end;

function TAdvStringGrid.GetNodeSpan(ARow: Integer): Integer;
var
  cg:TCellGraphic;
begin
  Result := -1;

  cg := GetCellGraphic(0,ARow);
  if cg = nil then
    Exit;

  if cg.CellType = ctNode then
    Result := cg.CellIndex;
end;

procedure TAdvStringGrid.SetNodeSpan(ARow,Span: Integer);
var
  cg:TCellGraphic;
begin
  cg := GetCellGraphic(0,ARow);
  if cg = nil then
    Exit;

  if cg.CellType = ctNode then
    cg.CellIndex := Span;
end;

procedure TAdvStringGrid.ExpandAll;
var
  i,j: Integer;
begin
  j := RowCount + NumHiddenRows;
  BeginUpdate;
  try
    for i := FixedRows to j - 1 do
      ExpandNode(i);
  finally
    EndUpdate;
  end;  
end;

procedure TAdvStringGrid.ContractAll;
var
  i,j: Integer;
begin
  j := RowCount + NumHiddenRows;
  BeginUpdate;
  try
    for i := j-1 downto FixedRows do
      ContractNode(i);
  finally
    EndUpdate;
  end;
end;

procedure TAdvStringGrid.ExpandNode(ARow: Integer);
var
  i,j: Integer;
  cg: TCellGraphic;
begin
  ARow := RemapRow(ARow);

  cg := GetCellGraphic(0,ARow);
  if (cg = nil) then Exit;

  if (cg.CellType = ctNode) and (cg.CellBoolean = True) then
    cg.CellBoolean := False
  else
    Exit;

  i := ARow + 1;
  if (cg.CellIndex = 0) then
    while (i < RowCount) do
    begin
      if IsNode(i) then Break;
      Inc(i);
    end;

  j := RemapRowInv(i);
  i := RemapRowInv(ARow);
  
  {$IFDEF TMSDEBUG}
  outputdebugstring(pchar(inttostr(i+1)+':'+inttostr(j-1)));
  {$ENDIF}

  UnHideRows(i + 1,j - 1);
end;

procedure TAdvStringGrid.ContractNode(ARow: Integer);
var
  i,j: Integer;
  cg:TCellGraphic;

begin
  HideInplaceEdit;

  ARow := RemapRow(ARow);
  cg := GetCellGraphic(0,ARow);
  if cg = nil then
    Exit;

  if (cg.CellType = ctNode) and (cg.CellBoolean = False) then
    cg.CellBoolean := True
  else
    Exit;

  i := ARow + 1;

  if (cg.CellIndex > 0) then
    i := ARow + cg.CellIndex
  else
    while (i < RowCount) do
    begin
      if IsNode(i) then Break;
      Inc(i);
    end;

  j := RemapRowInv(i);
  i := RemapRowInv(ARow);

  HideRows(i + 1,j - 1);
end;

function TAdvStringGrid.GetParentRow(ARow: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  if FNumNodes = 0 then
    Exit;

  i := ARow;
  while i > 0 do
  begin
    if IsNode(i) then
    begin
      if GetNodeSpan(i) + i > ARow then
        Result := i;
      Exit;
    end;
    Dec(i);
  end;
end;

procedure TAdvStringGrid.InsertChildRow(ARow: Integer);
var
  pr,j: Integer;
begin
  ARow := DisplRowIndex(ARow);

  pr := GetParentRow(ARow);

  if pr <> -1 then
  begin
    SetNodeSpan(pr,GetNodeSpan(pr) + 1);
    ExpandNode(RealRowIndex(pr));
  end;

  InsertRows(ARow,1);

  if pr <> -1 then
    CellProperties[0,ARow].NodeLevel := 1;


  for j := 1 to FGriditems.Count do
  begin
    if (FGriditems.Items[j - 1] as TGridItem).Idx > pr then
      (FGriditems.Items[j - 1] as TGridItem).Idx := (FGriditems.Items[j - 1] as TGridItem).Idx + 1;
  end;
end;

procedure TAdvStringGrid.RemoveChildRow(ARow: Integer);
var
  pr,j: Integer;
begin
  ARow := DisplRowIndex(ARow);

  pr := GetParentRow(ARow);

  if pr <> -1 then
  begin
    if GetNodeSpan(pr) > 1 then
      SetNodeSpan(pr,GetNodeSpan(pr) - 1);
    ExpandNode(RealRowIndex(pr));
  end;

  RemoveRows(ARow,1);

  for j := 1 to FGriditems.Count do
  begin
    if (FGriditems.Items[j - 1] as TGridItem).Idx > pr then
      (FGriditems.Items[j - 1] as TGridItem).Idx := (FGriditems.Items[j - 1] as TGridItem).Idx - 1;
  end;
end;


function TAdvStringGrid.IsNode(ARow: Integer): Boolean;
begin
  Result := (CellTypes[0,ARow] = ctNode);
end;

function  TAdvStringGrid.GetNodeSpanType(ARow: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  if IsNode(ARow) then
    Exit;

  if ARow = RowCount - FixedFooters - 1 then
  begin
    Result := 1;
    Exit;
  end;

  i := ARow;

  while ARow >= FixedRows do
  begin
    if IsNode(ARow) then
    begin
      if (i - ARow + 1 = GetNodeSpan(ARow)) and not GetNodeState(ARow) then
        Result := 1
      else
        Result := 2;
        {
      if (i - ARow + 1 < GetNodeSpan(ARow)) and not GetNodeState(ARow) then
        Result := 2
      else
        Result := 1;
        }
      Break;
    end;
    dec(ARow);
  end;

end;

function TAdvStringGrid.CreateBitmap(ACol,ARow: Integer;transparent: Boolean;hal:TCellHalign;val:TCellValign):TBitmap;
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  with CreateCellGraphic(ACol,ARow) do
  begin
    SetBitmap(bmp,transparent,hal,val);
    CellCreated := True;
  end;
  Result := bmp;
end;

procedure TAdvStringGrid.AddBitmap(ACol,ARow: Integer;abmp:TBitmap;transparent: Boolean;hal:TCellHalign;val:TCellValign);
begin
  with CreateCellGraphic(ACol,ARow) do
    SetBitmap(abmp,transparent,hal,val);
end;

function TAdvStringGrid.GetBitmap(ACol,ARow: Integer):TBitmap;
var
  cg: TCellGraphic;
begin
  Result := nil;
  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then
    Exit;
  if (cg.CellType = cTBitmap) then
    Result := cg.CellBitmap;
end;

procedure TAdvStringGrid.RemoveBitmap(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctBitmap);
end;

procedure TAdvStringGrid.AddPicture(ACol,ARow: Integer;apicture:TPicture;transparent: Boolean;stretchmode:TStretchMode;
                                    padding: Integer;hal:TCellHalign;val:TCellValign);
begin
  with CreateCellGraphic(ACol,ARow) do
  begin
    SetPicture(apicture,transparent,stretchmode,padding,hal,val);
  end;
end;

function TAdvStringGrid.CreatePicture(ACol,ARow: Integer;transparent: Boolean;stretchmode:TStretchMode;
                                      padding: Integer;hal:TCellHalign;val:TCellValign):TPicture;
var
  pic: TPicture;
begin
  pic := TPicture.Create;
  with CreateCellGraphic(ACol,ARow) do
  begin
    SetPicture(pic,Transparent,StretchMode,Padding,hal,val);
    CellCreated := True;
  end;
  Result := pic;
end;

function TAdvStringGrid.GetPicture(ACol,ARow: Integer):TPicture;
var
  cg:TCellGraphic;
begin
  Result := nil;
  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then
    Exit;
  if (cg.CellType = ctPicture) then
    Result := TPicture(cg.CellBitmap);
end;

procedure TAdvStringGrid.RemovePicture(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctPicture);
end;

procedure TAdvStringGrid.AddFilePicture(ACol,ARow: Integer;AFilePicture:TFilePicture;transparent: Boolean;stretchmode:TStretchMode;
                                    padding: Integer;hal:TCellHalign;val:TCellValign);
begin
  with CreateCellGraphic(ACol,ARow) do
    SetFilePicture(AFilePicture,transparent,stretchmode,padding,hal,val);
end;

function TAdvStringGrid.CreateFilePicture(ACol,ARow: Integer;Transparent: Boolean;stretchmode:TStretchMode;
                                      padding: Integer;hal:TCellHalign;val:TCellValign):TFilePicture;
var
  pic: TFilePicture;
begin
  pic := TFilePicture.Create;
  with CreateCellGraphic(ACol,ARow) do
  begin
    SetFilePicture(pic,transparent,stretchmode,padding,hal,val);
    CellCreated := True;
  end;
  Result := pic;
end;

function TAdvStringGrid.GetFilePicture(ACol,ARow: Integer):TFilePicture;
var
  cg:TCellGraphic;
begin
  Result := nil;
  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then
    Exit;
  if (cg.CellType = ctFilePicture) then
    Result := TFilePicture(cg.CellBitmap);
end;

procedure TAdvStringGrid.RemoveFilePicture(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctFilePicture);
end;


function TAdvStringGrid.CreateIcon(ACol,ARow: Integer;hal:TCellHalign;val:TCellValign):TIcon;
var
  ico: TIcon;
begin
  ico := TIcon.Create;
  with CreateCellGraphic(ACol,ARow) do
  begin
    SetIcon(ico,hal,val);
    CellCreated := True;
  end;
  Result := Ico;
end;


procedure TAdvStringGrid.AddIcon(ACol,ARow: Integer;AIcon:TIcon;hal:TCellHalign;val:TCellValign);
begin
  with CreateCellGraphic(ACol,ARow) do
    SetIcon(AIcon,hal,val);
end;

procedure TAdvStringGrid.RemoveIcon(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctIcon);
end;

procedure TAdvStringGrid.AddProgressPie(ACol,ARow: Integer;Color: TColor; Value: Integer);
begin
  with CreateCellGraphic(ACol,ARow) do
  begin
    CellType := ctProgressPie;
    CellHAlign := haBeforeText;
    CellVAlign := vaTop;
    CellBitmap := TBitmap(Color);
    CellAngle := Value;
  end;
end;

procedure TAdvStringGrid.SetProgressPie(ACol,ARow: Integer; Value: Integer);
var
  cg: TCellGraphic;
begin
  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then Exit;

  if cg.CellType = ctProgressPie then
  begin
    cg.CellAngle := Value;
    RepaintCell(ACol,ARow);
  end;
end;


procedure TAdvStringGrid.RemoveProgressPie(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctProgressPie);
end;

procedure TAdvStringGrid.AddProgress(ACol,ARow: Integer;FGColor,BkColor: TColor);
begin
  with CreateCellGraphic(ACol,ARow) do
  begin
    CellType := ctProgress;
    CellHAlign := haLeft;
    CellVAlign := vaTop;
    CellBitmap := TBitmap(FGColor);
    CellIcon := TIcon(BKColor);
    CellBoolean := False;
  end;
end;

procedure TAdvStringGrid.AddProgressEx(ACol,ARow: Integer;FGColor,FGTextColor,BKColor,BKTextColor: TColor);
begin
  with CreateCellGraphic(ACol,ARow) do
  begin
    CellType := ctProgress;
    CellHAlign := haLeft;
    CellVAlign := vaTop;
    CellBitmap := TBitmap(FGColor);
    CellIcon := TIcon(BKColor);
    CellIndex := TColor(FGTextColor);
    CellAngle := TColor(BKTextColor);
    CellBoolean := True;
  end;
end;

procedure TAdvStringGrid.RemoveProgress(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctProgress);
end;


procedure TAdvStringGrid.AddComment(ACol,ARow: Integer; Comment:string);
begin
  with CreateCellGraphic(ACol,ARow) do
  begin
    CellType := ctComment;
    CellHAlign := haLeft;
    CellVAlign := vaTop;
    CellText := Comment;
  end;
end;

function TAdvStringGrid.IsComment(ACol,ARow: Integer;var comment:string): Boolean;
var
  cg: TCellGraphic;
begin
  Result := False;
  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then Exit;
  Result := cg.CellType = ctComment;
  if Result then
    Comment := cg.CellText;
end;

procedure TAdvStringGrid.RemoveComment(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctComment);
end;

procedure TAdvStringGrid.AddMarker(ACol,ARow,ErrPos,ErrLen: Integer);
var
  cg: TCellGraphic;
begin
  cg := GetCellGraphic(ACol,ARow);

  if not Assigned(cg) then
  begin
    cg := CreateCellGraphic(ACol,ARow);
    cg.CellType := ctEmpty;
  end;

  cg.CellErrFrom := ErrPos;
  cg.CellErrLen := ErrLen;
  InvalidateCell(ACol,ARow);
end;

procedure TAdvStringGrid.RemoveMarker(ACol,ARow: Integer);
var
  cg: TCellGraphic;
begin
  cg := GetCellGraphic(ACol,ARow);
  if not Assigned(cg) then Exit;

  if cg.CellType = ctEmpty then
    RemoveCellGraphic(ACol,ARow,ctEmpty)
  else
  begin
    cg.CellErrFrom := 0;
    cg.CellErrLen := 0;
  end;
end;

procedure TAdvStringGrid.GetMarker(ACol,ARow: Integer;var ErrPos,ErrLen: Integer);
var
  cg: TCellGraphic;
begin
  ErrPos := 0;
  ErrLen := 0;

  cg := GetCellGraphic(ACol,ARow);
  if not Assigned(cg) then Exit;

  ErrPos := cg.CellErrFrom;
  ErrLen := cg.CellErrLen;
end;

procedure TAdvStringGrid.AddBitButton(ACol,ARow, bw, bh: Integer;Caption:string;Glyph: TBitmap;hal:TCellHalign;val:TCellValign);
begin
  with CreateCellGraphic(ACol,ARow) do
    SetBitButton(bw,bh,Caption,Glyph,hal,val);
end;

function TAdvStringGrid.CreateBitButton(ACol,ARow, bw, bh: Integer;Caption:string;hal:TCellHalign;val:TCellValign): TBitmap;
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  with CreateCellGraphic(ACol,ARow) do
  begin
    SetBitButton(bw,bh,Caption,bmp,hal,val);
    CellCreated := True;
  end;
  Result := bmp;
end;

procedure TAdvStringGrid.AddButton(ACol,ARow, bw, bh: Integer;caption:string;hal:TCellHalign;val:TCellValign);
begin
  with CreateCellGraphic(ACol,ARow) do
    SetButton(bw,bh,caption,hal,val);
end;

procedure TAdvStringGrid.SetButtonText(ACol,ARow: Integer; Caption: string);
var
  cg: TCellGraphic;
begin
  cg := GetCellGraphic(RemapCol(ACol),ARow);
  if cg = nil then
    Exit;
  cg.CellText := Caption;
  RepaintCell(ACol,ARow);
end;

procedure TAdvStringGrid.RemoveButton(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctButton);
  RemoveCellGraphic(ACol,ARow,ctBitButton);
end;

procedure TAdvStringGrid.PushButton(ACol,ARow: Integer;push: Boolean);
var
  cg: TCellGraphic;
begin
  cg := GetCellGraphic(RemapCol(ACol),ARow);
  if cg = nil then
    Exit;
  cg.CellBoolean := push;
  RepaintCell(ACol,ARow);
end;

function TAdvStringGrid.HasButton(ACol,ARow: Integer): Boolean;
var
  BC: TPoint;
begin
  BC := BaseCell(ACol,ARow);
  Result := (CellTypes[BC.X,BC.Y] in [ctButton,ctBitButton]);
end;

function TAdvStringGrid.ButtonRect(ACol,ARow: Integer):TRect;
var
  l: Integer;
  cg: TCellGraphic;
  cr: TRect;

begin
  cg := GetCellGraphic(RemapCol(ACol),ARow);
  if cg = nil then Exit;
  l := round(cg.CellValue);

  cr := CellRect(ACol, ARow);

  Result.Left := (l and $FFFF) + cr.Left;
  Result.Top := Integer(((l and $FFFF0000) shr 16)) + cr.Top;

  Result.Right := Result.Left+(cg.CellIndex and $FFFF);
  l := (cg.Cellindex and $FFFF0000) shr 16;
  Result.Bottom := Result.Top+l;

  if (cg.CellVAlign = vaFull) or (cg.CellHAlign = haFull) then
  begin
    cr := CellRect(ACol,ARow);
    if cg.CellVAlign = vaFull then
    begin
      Result.Top := cr.Top;
      Result.Bottom := cr.Bottom;
    end;
    if cg.CellHAlign = haFull then
    begin
      Result.Left := cr.Left;
      Result.Right := cr.Right;
    end;
  end;


end;

procedure TAdvStringGrid.AddCheckBox(ACol,ARow: Integer;state,data: Boolean);
begin
  with CreateCellGraphic(ACol,ARow) do
  begin
    case VAlignment of
    vtaTop: SetCheckBox(state,Data,True,haBeforeText,vaTop);
    vtaCenter: SetCheckBox(state,Data,True,haBeforeText,vaCenter);
    vtaBottom: SetCheckBox(state,Data,True,haBeforeText,vaBottom);
    end;
  end;
end;

procedure TAdvStringGrid.RemoveCheckBox(ACol,ARow: Integer);
var
  cg: TCellGraphic;
begin
  cg := GetCellGraphic(ACol,ARow);
  if cg = Nil then
    Exit;
  if cg.CellType in [ctCheckBox,ctDataCheckBox] then
    FreeCellGraphic(ACol,ARow);
end;

function TAdvStringGrid.HasCheckBox(ACol,ARow: Integer): Boolean;
var
  BC: TPoint;
begin
  BC := BaseCell(ACol,ARow);
  Result := (CellTypes[BC.X,BC.Y] in [ctCheckBox,ctDataCheckBox,ctVirtCheckBox]);
end;

function TAdvStringGrid.HasDataCheckBox(ACol,ARow: Integer): Boolean;
var
  BC: TPoint;
begin
  BC := BaseCell(ACol,ARow);
  Result := (CellTypes[BC.X,BC.Y] in [ctDataCheckBox,ctVirtCheckBox]);
end;

function TAdvStringGrid.HasDataCell(ACol,ARow: Integer): Boolean;
var
  BC: TPoint;
begin
  BC := BaseCell(ACol,ARow);
  Result := (CellTypes[BC.X,BC.Y] in [ctDataCheckBox,ctVirtCheckBox,ctDataImage]);
end;

function TAdvStringGrid.HasStaticEdit(ACol,ARow: Integer): Boolean;
var
  BC: TPoint;
begin
  BC := BaseCell(ACol,ARow);
  Result := (CellTypes[BC.X,BC.Y] in [ctCheckBox,ctDataCheckBox,ctVirtCheckBox,ctRadio]);
end;

function TAdvStringGrid.GetCheckBoxState(ACol,ARow: Integer;var State: Boolean): Boolean;
var
  cg: TCellGraphic;
begin
  Result := False;

  cg := GetCellGraphic(ACol,ARow);
  if cg = Nil then
    Exit;

  if (cg.CellType = ctCheckBox) then
  begin
    State := cg.CellBoolean;
    Result := True;
  end;

  if (cg.CellType in [ctDataCheckBox,ctVirtCheckBox]) then
  begin
    State := Cells[ACol,ARow] = GetCheckTrue(ACol,ARow);
    Result := True;
  end;
end;

function TAdvStringGrid.SetCheckBoxState(ACol,ARow: Integer;State: Boolean): Boolean;
var
  cg:TCellGraphic;
begin
  Result := False;
  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then
    Exit;

  if cg.CellType = ctCheckBox then
  begin
    cg.CellBoolean := state;
    RepaintCell(ACol,ARow);
    Result := True;
  end;

  if (cg.CellType in [ctDataCheckBox,ctVirtCheckBox]) then
  begin
    if state then
      Cells[ACol,ARow] := GetCheckTrue(ACol,ARow)
    else
      Cells[ACol,ARow] := GetCheckFalse(ACol,ARow);
    Result :=True;
  end;
end;

function TAdvStringGrid.ToggleRadio(ACol,ARow: Integer; FromEdit: Boolean): Boolean;
var
  cg: TCellGraphic;
  NewIdx: Integer;
  CanEdit: Boolean;
begin
  Result := False;

  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then
    Exit;

  if cg.CellType = ctRadio then
  begin
    if FromEdit then
    begin
      CanEdit := True;
      GetCellReadOnly(ACol,ARow,CanEdit);
      if not CanEdit then Exit;
    end;

    if cg.CellIndex >= 0 then
      NewIdx := cg.CellIndex + 1
    else
      NewIdx := TStrings(cg.CellBitmap).IndexOf(Cells[ACol,ARow]) + 1;

    if NewIdx >= TStrings(cg.CellBitmap).Count then
      NewIdx := 0;
    if cg.CellIndex >= 0 then
      cg.CellIndex := NewIdx;

    Cells[ACol,ARow] := TStrings(cg.CellBitmap).Strings[NewIdx];
  end;

end;

function TAdvStringGrid.ToggleCheck(ACol,ARow: Integer; FromEdit: Boolean): Boolean;
var
  cg: TCellGraphic;
  Canedit: Boolean;
  RColI: Integer;

begin
  Result := False;

  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then
    Exit;

  if cg.CellType in [ctCheckBox,ctDataCheckBox,ctVirtCheckBox] then
  begin
    if FromEdit then
    begin
      CanEdit := True;
      GetCellReadOnly(ACol,ARow,CanEdit);
      if not CanEdit then Exit;
    end;

    if cg.CellType = ctCheckBox then
      cg.CellBoolean := not cg.CellBoolean
    else
    begin
      if (Cells[ACol,ARow] = GetCheckTrue(ACol,ARow)) then
        Cells[ACol,ARow] := GetCheckFalse(ACol,ARow)
      else
        Cells[ACol,ARow] := GetCheckTrue(ACol,ARow);
    end;

    RColI := RemapColInv(ACol);

    RepaintCell(RColI,ARow);
    Result := True;
  end;
end;

function TAdvStringGrid.ToggleCheckBox(ACol,ARow: Integer): Boolean;
begin
  Result := ToggleCheck(ACol,ARow,False);
end;

function TAdvStringGrid.GetImageIdx(ACol,ARow: Integer;var Idx: Integer): Boolean;
begin
  Result := False;
  if not Assigned(FGridImages) then
    Exit;

  if CellTypes[ACol,ARow] = ctImageList then
  begin
    with GetCellGraphic(ACol,ARow) do
    begin
      Idx := CellIndex;
    end;
    Result := True;
  end;
end;                               

procedure TAdvStringGrid.AddDataImage(ACol,ARow,AIdx: Integer;hal:TCellHalign;val:TCellValign);
begin
  if not Assigned(FGridImages) then
    Exit;

  with CreateCellGraphic(ACol,ARow) do
  begin
    SetDataImage(AIdx,hal,val);
  end;
end;

procedure TAdvStringGrid.RemoveDataImage(ACol,ARow: Integer);
begin
  RemoveImageIdx(ACol,ARow);
end;

function TAdvStringGrid.HasDataImage(ACol,ARow: Integer): Boolean;
var
  BC: TPoint;
begin
  BC := BaseCell(ACol,ARow);
  Result := (CellTypes[BC.X,BC.Y] = ctDataImage);
end;


procedure TAdvStringGrid.AddMultiImage(ACol,ARow,Dir: Integer;hal:TCellHalign;val:TCellValign);
begin
  if not Assigned(FGridImages) then
    Exit;

  with CreateCellGraphic(ACol,ARow) do
  begin
    SetMultiImage(ACol,ARow,dir,hal,val,MultiImageChanged);
  end;
end;

procedure TAdvStringGrid.RemoveMultiImage(ACol,ARow: Integer);
begin
  if CellTypes[ACol,ARow] = ctImages then
  begin
    GetCellGraphic(ACol,ARow).Free;
  end;
end;

procedure TAdvStringGrid.AddImageIdx(ACol,ARow,AIdx: Integer;hal:TCellHalign;val:TCellValign);
begin
  if not Assigned(FGridImages) then Exit;

  with CreateCellGraphic(ACol,ARow) do
  begin
    SetImageIdx(AIdx,hal,val);
  end;
end;

procedure TAdvStringGrid.RemoveImageIdx(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctImageList);
end;

procedure TAdvStringGrid.SetImages(Value: TImageList);
begin
  if Value <> FGridImages then
  begin
    FGridImages := Value;
  end;
end;

procedure TAdvStringGrid.SetURLColor(Value: TColor);
begin
  FURLColor := Value;
  if FURLShow then
    Invalidate;
end;

procedure TAdvStringGrid.SetURLShow(Value: Boolean);
begin
  FURLShow := Value;
  Invalidate;
end;

procedure TAdvStringGrid.SetURLFull(Value: Boolean);
begin
  FURLFull := Value;
  if FURLShow then
    Invalidate;
end;

procedure TAdvStringGrid.SetLook(Value: TGridLook);
begin
  if FLook <> Value then
  begin
    FLook := Value;
    Invalidate;
    UpdateFooter;
  end;
end;

procedure TAdvStringGrid.AddRotated(ACol,ARow: Integer;AAngle:SmallInt;s:string);
begin
  with CreateCellGraphic(ACol,ARow) do
  begin
    SetAngle(AAngle);
  end;
  Cells[ACol,ARow] := s;
end;

procedure TAdvStringGrid.SetRotated(ACol,ARow: Integer;AAngle:SmallInt);
var
  cg: TCellGraphic;
begin
  cg := GetCellgraphic(ACol,ARow);
  if not Assigned(cg) then
    cg := CreateCellGraphic(ACol,ARow);
  cg.SetAngle(AAngle);
end;

procedure TAdvStringGrid.RemoveRotated(ACol,ARow: Integer);
begin
  RemoveCellGraphic(ACol,ARow,ctRotated);
end;

function TAdvStringGrid.IsRotated(ACol,ARow: Integer;var aAngle: Integer): Boolean;
begin
  Result := CellTypes[ACol,ARow] = ctRotated;

  if Result then
    AAngle := GetCellGraphic(ACol,ARow).CellAngle;
end;

procedure TAdvStringGrid.ScrollInView(ColIndex,RowIndex: Integer);
var
  nc,nr: Integer;
begin
  if ColIndex >= ColCount then Exit;
  if RowIndex >= RowCount then Exit;

  nc := LeftCol;
  nr := TopRow;
  if (ColIndex < LeftCol) or (ColIndex >= LeftCol + VisibleColCount) then
  begin
    Col := ColIndex;
    nc := ColIndex - (VisibleColCount shr 1);
    if nc < FixedCols then nc := FixedCols;
  end;

  if (RowIndex < TopRow) or (RowIndex >= TopRow + VisibleRowCount) then
  begin
    Row := RowIndex;
    nr := RowIndex - (VisibleRowCount shr 1);
    if nr < FixedRows then nr := FixedRows;
  end;

  if nc > ColCount - VisibleColCount + 1 then
    nc := ColCount - VisibleColCount + 1;

  LeftCol := nc;

  if nr > RowCount - VisibleRowCount + 1 then
    nr := RowCount - VisibleRowCount + 1;

  TopRow := nr;
end;

procedure TAdvStringGrid.MoveColumn(FromIndex, ToIndex: Integer);
begin
  ColumnMoved(FromIndex,ToIndex);
end;

procedure TAdvStringGrid.MoveRow(FromIndex, ToIndex: Integer);
begin
  RowMoved(FromIndex,ToIndex);
end;

procedure TAdvStringGrid.UnHideSelection;
begin
  FSelHidden := False;
  Selection := FOldSelection;
end;

procedure TAdvStringGrid.HideSelection;
begin
  FOldSelection := Selection;
  Selection := TGridRect(Rect(ColCount,RowCount,ColCount,RowCount));
  FSelHidden := True;
end;

procedure TAdvStringGrid.HideColumn(Colindex: Integer);
begin
  HideColumns(Colindex,Colindex);
end;

procedure TAdvStringGrid.HideColumns(FromCol,ToCol: Integer);
var
  i,j: Integer;
begin
  HideInplaceEdit;
  
  for j := FromCol to ToCol do
  begin
    if (GetVisibleCol(j)) and (j < ColCount + FNumHidden) and (ColCount >= 2) then
    begin
      FAllColWidths[j] := ColWidths[RemapColInv(j)];

      for i := RemapColInv(j) to ColCount - 2 do
        ColWidths[i] := ColWidths[i + 1];
      Inc(FNumHidden);
      SetVisibleCol(j,False);
      ColCount := ColCount - 1;
    end;
  end;
  Invalidate;
end;

procedure TAdvStringGrid.UnHideColumn(Colindex: Integer);
begin
  UnHideColumns(Colindex,Colindex);
end;

procedure TAdvStringGrid.UnHideColumnsAll;
begin
  UnHideColumns(0,ColCount + FNumHidden);
end;

procedure TAdvStringGrid.UnHideColumns(FromCol,ToCol: Integer);
var
  i,j: Integer;
begin
  HideInplaceEdit;
  
  for j := FromCol to ToCol do
  begin
    if not GetVisibleCol(j) then
    begin
      Dec(FNumHidden);
      SetVisibleCol(j,True);
      ColCount := ColCount + 1;
      for i := ColCount - 1 downto RemapColinv(j + 1) do
        ColWidths[i] := ColWidths[i - 1];

      ColWidths[RemapColinv(j)] := FAllColWidths[j];
    end;
  end;
  Invalidate;
end;

function TAdvStringGrid.IsHiddenColumn(Colindex: Integer): Boolean;
begin
  if (ColIndex < MAXCOLUMNS) then
    IsHiddenColumn := not FVisibleCol[Colindex]
  else
    IsHiddenColumn := False;
end;

function TAdvStringGrid.NumHiddenColumns: Integer;
begin
  Result := FNumHidden;
end;

function TAdvStringGrid.RemapRowInv(ARow: Integer): Integer;
var
  i,k: Integer;
begin
  i := 0;
  k := 0;

  while (k <= ARow) do
  begin
    if not IsHiddenRow(i) then Inc(k);
    Inc(i);
  end;

  Result := i - 1;
end;

function TAdvStringGrid.RemapRow(ARow: Integer): Integer;
var
  i,j: Integer;
begin
  i := ARow;
  for j := 1 to FGriditems.Count do
  begin
    if (FGriditems.Items[j - 1] as TGridItem).Idx < i then
      Dec(ARow);
  end;
  Result := ARow;
end;

procedure TAdvStringGrid.SetGroupColumn(AGroupColumn: Integer);
begin
  if AGroupColumn = -1 then
    UnGroup
  else
    if (AGroupColumn > 0) then Group(AGroupColumn);
end;

procedure TAdvStringGrid.GroupSum(Colindex: Integer);
begin
  GroupCalc(Colindex,1);
end;

procedure TAdvStringGrid.GroupAvg(Colindex: Integer);
begin
  GroupCalc(Colindex,2);
end;

procedure TAdvStringGrid.GroupMin(Colindex: Integer);
begin
  GroupCalc(Colindex,3);
end;

procedure TAdvStringGrid.GroupMax(Colindex: Integer);
begin
  GroupCalc(Colindex,4);
end;

procedure TAdvStringGrid.GroupCount(Colindex: Integer);
begin
  GroupCalc(Colindex,5);
end;


procedure TAdvStringGrid.GroupCalc(Colindex,Method: Integer);
var
  i,j: Integer;
begin
  i := FixedRows;
  while (i<RowCount) do
  begin
    if IsNode(i) then
    begin
      Inc(i);
      j := i;
      while not IsNode(j) and (j < RowCount) do
        inc(j);
      case Method of
      1:Floats[Colindex,i-1] := ColumnSum(Colindex,i,j - 1);
      2:Floats[Colindex,i-1] := ColumnAvg(Colindex,i,j - 1);
      3:Floats[Colindex,i-1] := ColumnMin(Colindex,i,j - 1);
      4:Floats[Colindex,i-1] := ColumnMax(Colindex,i,j - 1);
      5:Floats[ColIndex,i-1] := j - 1 - i;
      end;
      i := j;
    end
    else
      Inc(i);
  end;
end;

procedure TAdvStringGrid.Group(Colindex: Integer);
var
  i,np: Integer;
  lc,nc: string;
  grp,grpc: Integer;
begin
  if (Colindex < FixedCols) then
    Exit;

  if FGroupColumn <> -1 then
    UnGroup;

  BeginUpdate;

  FGroupColumn := Colindex;
  FGroupWidth := ColWidths[Colindex];
  if FixedRows > 0 then
    FGroupCaption := Cells[Colindex,0];

  grp := Colindex;
  grpc := 1 + FixedCols;

  // sort the Column to group first
  FSortSettings.Column := Colindex;
  QSort;

  if grpc = Colindex then
    Inc(grpc);

  np := -1;
  lc := #255#254;

  i := FixedRows;
  while i <= RowCount - 1 - FFixedFooters do
  begin
    nc := Cells[Colindex,i];
    if lc <> nc then
    begin
      if np <> -1 then
        AddNode(np,i - np);

      InsertRows(i,1);
      Cells[grpc,i] := nc;
      np := i;
      Inc(i);
    end;
    if i < RowCount - 1 then
      lc := Cells[grp,i];
    Inc(i);
  end;

  if np <> -1 then
    AddNode(np,i - np)
  else
    AddNode(FixedRows,i - 1);

  RemoveCols(grp,1);
  Row := FixedRows;
  EndUpdate;
end;

procedure TAdvStringGrid.UnGroup;
var
  i: Integer;
  nc: string;
  grpc: Integer;
begin
  if FGroupColumn <= 0 then
    Exit;

  ExpandAll;

  if FGroupColumn = 1 then
    grpc := 2
  else
    grpc := 1;

  InsertCols(FGroupColumn,1);

  ColWidths[FGroupColumn] := FGroupWidth;

  if FixedRows > 0 then
    Cells[FGroupColumn,0] := FGroupCaption;

  i := FixedRows;

  while i <= RowCount - 1 - FFixedFooters do
  begin
    if IsNode(i) then
    begin
      nc := Cells[grpc,i];
      RemoveNode(i);
      ClearPropCell(0,i);
      IRemoveRows(i,1);
    end
    else
    begin
      Cells[FGroupColumn,i] := nc;
      inc(i);
    end;
  end;

  FGroupColumn := -1;
end;

procedure TAdvStringGrid.HideRow(RowIndex: Integer);
begin
  HideRows(RowIndex,RowIndex);
end;

procedure TAdvStringGrid.HideRows(FromRow,ToRow: Integer);
var
  j,k: Integer;
begin
  k := FromRow;

  //count nr. of hidden items under RowIndex
  for j := 1 to FGriditems.Count do
  begin
    if (FGriditems.Items[j - 1] as TGridItem).Idx < FromRow then Dec(k);
    // Exit if already hidden
    if (FGriditems.Items[j - 1] as TGridItem).Idx = FromRow then Exit;
  end;

  if FNumHidden > 0 then
    ColCount := ColCount + FNumHidden;

  for j := FromRow to ToRow do
    with (FGridItems.Add as TGridItem) do
    begin
      Items.Assign(Rows[ k + j - FromRow]);
      Idx := FromRow + (j - FromRow);
    end;

  IRemoveRows(k,ToRow - FromRow + 1);

  if FNumHidden > 0 then
    ColCount := ColCount - FNumHidden;
end;

procedure TAdvStringGrid.HideRowsEx(FromRow,ToRow: Integer);
var
  j,k: Integer;
begin
  k := FromRow;

  //count nr. of hidden items under RowIndex
  for j := 1 to FGriditems.Count do
  begin
    if (FGridItems.Items[j - 1] as TGridItem).Idx < FromRow then Dec(k);
    // Exit if already hidden
    if (FGridItems.Items[j - 1] as TGridItem).Idx = FromRow then Exit;
  end;

  if FNumHidden > 0 then
    ColCount := ColCount + FNumHidden;

  for j := FromRow to ToRow do
  begin
    with (FGriditems.Add as TGridItem) do
    begin
      Items.Assign(Rows[k + j - FromRow]);
      Idx := FromRow + (j - FromRow);
    end;
  end;

  if FNumHidden > 0 then
    ColCount := ColCount - FNumHidden;

  RemoveRowsEx(k,ToRow - FromRow + 1);
end;

procedure TAdvStringGrid.UnHideRowsAll;
var
  hs,he,i,j: Integer;
begin
  i := 0;
  j := 0;
  hs := -1;
  he := -1;
  while (FGridItems.Count > 0) and (i <= FGridItems.Count - 1) do
  begin
    if (hs = -1) then
    begin
      hs := (FGriditems.Items[i] as TGridItem).Idx;
      he := hs;
      j := i;
    end;

    if (i < FGridItems.Count - 1) and
       ((FGriditems.Items[i] as TGridItem).Idx+1 = (FGriditems.Items[i+1] as TGridItem).Idx) then
    begin
      Inc(i);
      Inc(he);
    end
    else
    begin
      UnHideRows(hs,he);
      i := j;
      hs := -1;
    end;
  end;

  if hs <> -1 then
    UnHideRows(hs,he);
end;

procedure TAdvStringGrid.UnHideRow(Rowindex: Integer);
var
  j,k,l: Integer;
  flg: Boolean;
begin
  k := RowIndex;
  Flg := False;
  l := 0;

  if FNumHidden > 0 then
    ColCount := ColCount + FNumHidden;

  // count nr. of hidden items under Rowindex
  for j := 1 to FGriditems.Count do
  begin
    if (FGriditems.Items[j-1] as TGridItem).Idx < RowIndex then Dec(k);
    if (FGriditems.Items[j-1] as TGridItem).Idx = RowIndex then
    begin
      Flg := True;
      l := j-1;
    end;
  end;

  if Flg then
  begin
    InsertRows(k,1);

    with (FGriditems.Items[l] as TGridItem) do
    begin
      Rows[k].Assign(Items);
    end;
    (FGriditems.Items[l] as TGridItem).Free;
  end;

 if FNumHidden > 0 then
   ColCount := ColCount - FNumHidden;
end;

procedure TAdvStringGrid.UnHideRows(FromRow,ToRow: Integer);
var
  i,j,k,l: Integer;
  Flg: Boolean;
  Num: Integer;

begin
  k := FromRow;
  Flg := False;

  if FNumHidden > 0 then
    ColCount := ColCount + FNumHidden;

  // count nr. of hidden items under Rowindex
  for j := 1 to FGridItems.Count do
  begin
    if (FGriditems.Items[j-1] as TGridItem).Idx < FromRow then
      Dec(k);
    if (FGriditems.Items[j-1] as TGridItem).Idx = FromRow then
      Flg := True;
  end;

  if Flg then
  begin
    Num := ToRow - FromRow + 1;

    for j := FromRow to ToRow do
      if not IsHiddenRow(j) then Dec(Num);

    if Num > 0 then
    begin
      InsertRows(k,num);

      i := 0;
      while (i < FGridItems.Count) and (FGridItems.Count > 0) do
      begin
        l := (FGridItems.Items[i] as TGridItem).Idx;
        if (l >= FromRow) and (l <= ToRow) then
        begin
           Rows[k + l - FromRow].Assign((FGridItems.Items[i] as TGridItem).Items);
           (FGridItems.Items[i] as TGridItem).Free;
        end
        else Inc(i);
      end;
    end;
  end;

  if FNumHidden > 0 then
    ColCount := ColCount - FNumHidden;
end;


function TAdvStringGrid.IsHiddenRow(Rowindex: Integer): Boolean;
var
  j: Integer;
begin
  Result := False;
  if FGriditems.Count = 0 then
    Exit;
  for j := 1 to FGriditems.Count do
  begin
    if (FGridItems.Items[j-1] as TGridItem).Idx = RowIndex then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TAdvStringGrid.NumHiddenRows: Integer;
begin
  Result := FGridItems.Count;
end;

function TAdvStringGrid.GetRealCol: Integer;
begin
  Result := RemapCol(Col);
end;

function TAdvStringGrid.GetRealRow: Integer;
begin
  Result := RemapRowInv(Row);
end;

function TAdvStringGrid.RealRowIndex(ARow: Integer): Integer;
begin
  Result := RemapRowInv(ARow);
end;

function TAdvStringGrid.RealColIndex(ACol: Integer): Integer;
begin
  Result := RemapCol(ACol);
end;

function TAdvStringGrid.DisplRowIndex(ARow: Integer): Integer;
begin
  Result := RemapRow(ARow);
end;

function TAdvStringGrid.DisplColIndex(ACol: Integer): Integer;
begin
  Result := RemapColinv(ACol);
end;

procedure TAdvStringGrid.SetVisibleCol(i: Integer;aValue: Boolean);
begin
  FVisibleCol[i] := AValue;
end;

function TAdvStringGrid.GetVisibleCol(i: Integer): Boolean;
begin
  Result := FVisibleCol[i];
end;

function TAdvStringGrid.RemapColInv(ACol: Integer): Integer;
var
  i: Integer;
  RemapValue: Integer;
begin
  RemapValue := ACol;
  for i := 0 to ACol - 1 do
  begin
    if not FVisibleCol[i] then Dec(RemapValue);
  end;
  Result := RemapValue;
end;

function TAdvStringGrid.RemapCol(ACol: Integer): Integer;
var
  i: Integer;
  RemapValue: Integer;
begin
  if (ACol >= MAXCOLUMNS) or (FNumHidden = 0) then
  begin
    RemapCol := ACol;
    Exit;
  end;

  RemapValue := 0;
  RemapCol := 0;
  i := 0;

  while i < MAXCOLUMNS do
  begin
    if (RemapValue = ACol) and FVisibleCol[i] then
    begin
      RemapCol := i;
      Exit;
    end;
   if FVisibleCol[i] then
     Inc(RemapValue);
   Inc(i);
  end;
end;

function TAdvStringGrid.GetSaveStartCol: Integer;
begin
  if FSaveFixedCells then
    Result := 0
  else
    Result := FixedCols;
end;

function TAdvStringGrid.GetSaveStartRow: Integer;
begin
  if FSaveFixedCells then
    Result := 0
  else
    Result := FixedRows;
end;

function TAdvStringGrid.GetSaveEndCol: Integer;
begin
  if FSaveFixedCells then
    Result := ColCount - 1
  else
    Result := ColCount - FFixedRightCols - 1;
end;

function TAdvStringGrid.GetSaveEndRow: Integer;
begin
  if FSaveFixedCells then
    Result := RowCount - 1
  else
    Result := RowCount - FFixedFooters - 1;
end;

function TAdvStringGrid.GetSaveColCount: Integer;
begin
  if FSaveFixedCells then
    Result := ColCount
  else
    Result := ColCount - FixedCols - FFixedRightCols;
end;

function TAdvStringGrid.GetSaveRowCount: Integer;
begin
  if FSaveFixedCells then
    Result := RowCount
  else
    Result := RowCount - FixedRows - FFixedFooters;
end;

procedure TAdvStringGrid.ScreenToCell(pt:TPoint; var ACol,ARow: Integer);
begin
  pt := ScreenToClient(pt);
  MouseToCell(pt.x,pt.y,ACol,ARow);
end;

function TAdvStringGrid.InSizeZone(x,y: Integer): Boolean;
var
  c,r: Longint;
  cr: TRect;
begin
  Result := False;
  MouseToCell(x,y,c,r);
  if (c < 0) or (r < 0) then
    Exit;
    
  cr := CellRect(c,r);
  if (r <= FixedRows) and (goColSizing in Options) then
    Result := (Abs(x - cr.Left) < 4) or (Abs(x - cr.Right) < 4);

  if (c <= FixedCols) and (goRowSizing in Options) then
    Result := (Abs(y - cr.Top) < 4) or (Abs(y - cr.Bottom) < 4);
end;

procedure TAdvStringGrid.UpdateType;
begin
  case FScrollType of
  ssNormal:FlatSetScrollProp(WSB_PROP_VSTYLE,FSB_REGULAR_MODE,True);
  ssFlat:FlatSetScrollProp(WSB_PROP_VSTYLE,FSB_FLAT_MODE,True);
  ssEncarta:FlatSetScrollProp(WSB_PROP_VSTYLE,FSB_ENCARTA_MODE,True);
  end;
  case FScrollType of
  ssNormal:FlatSetScrollProp(WSB_PROP_HSTYLE,FSB_REGULAR_MODE,True);
  ssFlat:FlatSetScrollProp(WSB_PROP_HSTYLE,FSB_FLAT_MODE,True);
  ssEncarta:FlatSetScrollProp(WSB_PROP_HSTYLE,FSB_ENCARTA_MODE,True);
  end;
end;

procedure TAdvStringGrid.UpdateColor;
begin
  if FScrollColor = clNone then Exit;
  FlatSetScrollProp(WSB_PROP_VBKGCOLOR,Integer(FScrollColor),True);
  FlatSetScrollProp(WSB_PROP_HBKGCOLOR,Integer(FScrollColor),True);
end;

procedure TAdvStringGrid.UpdateWidth;
begin
  FlatSetScrollProp(WSB_PROP_CXVSCROLL,FScrollWidth,True);
  FlatSetScrollProp(WSB_PROP_CYHSCROLL,FScrollWidth,True);
end;

procedure TAdvStringGrid.UpdateFooter;
begin
  FFooterPanel.Invalidate;
end;

procedure TAdvStringGrid.CalcFooter(ACol: Integer);
begin
  DoCalcFooter(ACol);
end;

procedure TAdvStringGrid.DoCalcFooter(ACol: Integer);
var
  ct: TColumnCalcType;
  co,ce,c: Integer;

begin
  if FloatingFooter.Visible and (FloatingFooter.FooterStyle = fsFixedLastRow) then
  begin
    if ACol = -1 then
    begin
      co := 0;
      ce := ColCount - 1;
    end
    else
    begin
      co := ACol;
      ce := ACol;
    end;

    for c := co to ce do
      if HasCellProperties(c,RowCount - 1) then
      begin
        ct := CellProperties[c,RowCount - 1].CalcType;
        if ct <> acNone then
        begin

          case ct of
          acSUM: Floats[c,RowCount - 1] := ColumnSum(c,FixedRows,RowCount - 2);
          acCOUNT: Floats[c,RowCount - 1] := RowCount - 1 - FixedRows;
          acAVG: Floats[c,RowCount - 1] := ColumnAvg(c,FixedRows,RowCount - 2);
          acMIN: Floats[c,RowCount - 1] := ColumnMin(c,FixedRows,RowCount - 2);
          acMAX: Floats[c,RowCount - 1] := ColumnMax(c,FixedRows,RowCount - 2);
          end;

        end
        else
          Cells[c,RowCount - 1] := '';
      end;
  end;
end;


procedure TAdvStringGrid.FloatFooterUpdate;
begin
  inherited;
  UpdateFooter;
end;


procedure TAdvStringGrid.UpdateVScrollBar;
var
  Scrollinfo: TScrollInfo;
begin
  if not (ScrollBars in [ssBoth,ssVertical]) or not FIsFlat then Exit;

  ScrollInfo.FMask := SIF_ALL;
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  GetScrollInfo(Handle,SB_VERT,ScrollInfo);

  if FScrollProportional then
  begin
    Scrollinfo.FMask := SIF_ALL;
    Scrollinfo.cbSize := SizeOf(ScrollInfo);
    if (ScrollInfo.npos > 127) or (Scrollinfo.npos < 0) then
      ScrollInfo.npos := 0;
    ScrollInfo.nmax := 127;
    ScrollInfo.nmin := 0;
    ScrollInfo.npage := Round(128 * VisibleRowCount / RowCount);
    //scrollinfo.npos:=round((128-scrollinfo.npage)*(scrollinfo.npos/127));
  end;
  FlatSetScrollInfo(SB_VERT,scrollinfo,True);
end;

procedure TAdvStringGrid.UpdateHScrollBar;
var
  ScrollInfo: TScrollinfo;


  function TotColWidth: Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to ColCount do
      Result := Result + ColWidths[i - 1];
    if Result = 0 then
      Result := 1;
  end;

begin
  if not (ScrollBars in [ssBoth,ssHorizontal]) or not FIsFlat then
    Exit;
  ScrollInfo.fMask := SIF_ALL;
  ScrollInfo.cbSize := SizeOf(ScrollInfo);
  GetScrollInfo(self.Handle,SB_HORZ,ScrollInfo);

  if FScrollProportional then
  begin
    ScrollInfo.FMask := SIF_ALL;
    ScrollInfo.cbSize := SizeOf(ScrollInfo);
    if (ScrollInfo.npos > 127) or (ScrollInfo.npos < 0) then
      ScrollInfo.npos := 0;
    ScrollInfo.nmax := 127;
    ScrollInfo.nmin := 0;
    // ScrollInfo.npage := Round(128 * VisibleColCount / ColCount);
    ScrollInfo.nPage := Round(128 * Width / TotColWidth);

    // outputdebugstring(pchar(inttostr(scrollinfo.nPos)+':'+inttostr(scrollinfo.npage)));
  end;

  FlatSetScrollInfo(SB_HORZ,ScrollInfo,True)
end;

procedure TAdvStringGrid.FlatSetScrollInfo(code: Integer;var Scrollinfo:TScrollInfo;FRedraw: bool);
var
  ComCtl32DLL: THandle;
  _FlatSB_SetScrollInfo:function(wnd:hwnd;code: Integer;var Scrollinfo:TScrollInfo;FRedraw: bool): Integer; stdcall;

begin
  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_FlatSB_SetScrollInfo:=GetProcAddress(ComCtl32DLL,'FlatSB_SetScrollInfo');
    if Assigned(_FlatSB_SetScrollInfo) then
    begin
      _FlatSB_SetScrollInfo(self.Handle,code,scrollinfo,fRedraw);
    end;
  end;
end;

procedure TAdvStringGrid.FlatSetScrollProp(index, newValue: Integer;
  FRedraw: bool);
var
  ComCtl32DLL: THandle;
  _FlatSB_SetScrollProp:function(wnd:hwnd;Index,newValue: Integer;fredraw:bool):bool stdcall;

begin
  if not FIsFlat then
    Exit;
  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_FlatSB_SetScrollProp:=GetProcAddress(ComCtl32DLL,'FlatSB_SetScrollProp');
    if Assigned(_FlatSB_SetScrollProp) then
      _FlatSB_SetScrollProp(self.Handle,index,newValue,fRedraw);
  end;
end;

procedure TAdvStringGrid.FlatShowScrollBar(code: Integer;show:bool);
var
  ComCtl32DLL: THandle;
  _FlatSB_ShowScrollBar:function(wnd:hwnd;code: Integer;show:bool): Integer; stdcall;

begin
  if not FIsFlat then
    Exit;

  case code of
  SB_VERT:if not (ScrollBars in [ssBoth,ssVertical]) then Exit;
  SB_HORZ:if not (ScrollBars in [ssBoth,ssHorizontal]) then Exit;
  end;

  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_FlatSB_ShowScrollBar:=GetProcAddress(ComCtl32DLL,'FlatSB_ShowScrollBar');
    if Assigned(_FlatSB_ShowScrollBar) then
      _FlatSB_ShowScrollBar(self.Handle,code,show);
  end;
end;

procedure TAdvStringGrid.FlatUpdate;
begin
  UpdateType;
  UpdateColor;
  UpdateWidth;
  if VisibleRowCount + FixedRows < RowCount then
  begin
    FlatShowScrollBar(SB_VERT,True);
    UpdateVScrollBar;
  end
  else
    FlatShowScrollBar(SB_VERT,False);

  if VisibleColCount + FixedCols < ColCount then
  begin
    FlatShowScrollBar(SB_HORZ,True);
    UpdateHScrollBar;
  end
  else
    FlatShowScrollBar(SB_HORZ,False);
end;

procedure TAdvStringGrid.FlatInit;
var
  ComCtl32DLL: THandle;
  _InitializeFlatSB: function(wnd:hwnd):Bool stdcall;
begin
  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_InitializeFlatSB := GetProcAddress(ComCtl32DLL,'InitializeFlatSB');
    if Assigned(_InitializeFlatSB) then
      _InitializeFlatSB(self.Handle);
    FIsFlat := Assigned(_InitializeFlatSB);
  end;
end;

procedure TAdvStringGrid.FlatDone;
var
  ComCtl32DLL: THandle;
  _UninitializeFlatSB: function(wnd:hwnd):Bool stdcall;
begin
  FisFlat := False;
  ComCtl32DLL := GetModuleHandle(comctrl);
  if ComCtl32DLL > 0 then
  begin
    @_UninitializeFlatSB := GetProcAddress(ComCtl32DLL,'UninitializeFlatSB');
    if Assigned(_UninitializeFlatSB) then
      _UninitializeFlatSB(self.Handle);
  end;
end;

function TAdvStringGrid.GetRowIndicator: TBitmap;
begin
  Result := FRowIndicator;
end;

procedure TAdvStringGrid.SetRowIndicator(Value: TBitmap);
begin
  FRowIndicator.Assign(Value);
  RepaintCell(0,Row);
end;

procedure TAdvStringGrid.SetBackground(Value: TBackground);
begin
  FBackground.Assign(Value);
  Invalidate;
end;

procedure TAdvStringGrid.SetHovering(Value: Boolean);
begin
  if Value <> FHovering then
  begin
    FHovering := Value;
  end;
end;

procedure TAdvStringGrid.SetActiveCellShow(const Value: Boolean);
begin
  FActiveCellShow := Value;
  Invalidate;
end;

procedure TAdvStringGrid.SetActiveCellColor(const Value: TColor);
begin
  FActiveCellColor := Value;
  Invalidate;
end;

procedure TAdvStringGrid.SetActiveCellFont(const Value: TFont);
begin
  FActiveCellFont.Assign(Value);
  Invalidate;
end;

procedure TAdvStringGrid.SetXYOffset(const Value: TPoint);
begin
  FXYOffset := Value;
  Invalidate;
end;

procedure TAdvStringGrid.SetScrollType(const Value: TScrollType);
begin
  if FScrollType <> Value then
  begin
    FScrollType := Value;
    if FScrollType in [ssFlat,ssEncarta] then
    begin
      Flatinit;
      FlatUpdate;
    end
    else
    begin
      FlatDone;
    end;
  end;
  UpdateType;
end;

procedure TAdvStringGrid.SetScrollColor(const Value: TColor);
begin
  FScrollColor := Value;
  UpdateColor;
end;

procedure TAdvStringGrid.SetScrollWidth(const Value: Integer);
begin
  FScrollWidth := Value;
  UpdateWidth;
end;

procedure TAdvStringGrid.SetScrollProportional(Value: Boolean);
var
  ScrollInfo: TScrollinfo;
begin
  FScrollProportional := Value;
  if Value then
  begin
    FlatInit;
    FlatUpdate;
  end
  else
  if FIsflat and (FScrollType = ssNormal) then
  begin
    FlatDone;
    ScrollInfo.cbSize := SizeOf(ScrollInfo);
    ScrollInfo.FMask := SIF_PAGE;
    ScrollInfo.nPage :=0;
    SetScrollInfo(Handle,SB_HORZ,ScrollInfo,True);
    ScrollInfo.cbSize := SizeOf(ScrollInfo);
    ScrollInfo.FMask := SIF_PAGE;
    ScrollInfo.nPage := 0;
    SetScrollInfo(Handle,SB_VERT,ScrollInfo,True);
  end;
end;

procedure TAdvStringGrid.WMHScroll(var WMScroll: TWMScroll);
var
  page: Integer;
  r:TRect;
  s:string;
  pt:TPoint;
  nr: Integer;
  fcr,tcr:TRect;

begin
  if FScrollHints in [shHorizontal,shBoth] then
  begin
    if wmScroll.ScrollCode = SB_ENDSCROLL then
    begin
      FScrollHintWnd.ReleaseHandle;
      FScrollHintShow := False;
    end;
    {$IFDEF DELPHI3_LVL}
    if wmScroll.ScrollCode = SB_THUMBTRACK then
    begin
      nr := FixedRows + longmuldiv(wmScroll.pos,ColCount - VisibleColCount - FixedCols,MaxShortInt);
      s := 'Col : '+inttostr(nr);
      if Assigned(OnScrollHint) then
        OnScrollHint(self,nr,s);

      r := FScrollHintWnd.CalcHinTRect(100,s,Nil);
      FScrollHintWnd.Caption := s;
      FScrollHintWnd.Color := FHintColor;

      GetCursorPos(pt);
      r.Left := r.Left + pt.x + 10;
      r.Right := r.Right + pt.x + 10;
      r.Top := r.Top + pt.y;
      r.Bottom := r.Bottom + pt.y;

      FScrollHintWnd.ActivateHint(r,s);
      FScrollHintShow := True;
    end;
   {$ENDIF}
  end;

  if (wmScroll.scrollcode = SB_THUMBPOSITION) and (FIsFlat) then
  begin
    Page := Round(128 * VisibleColCount/ColCount);
    wmScroll.Pos := Round(127*wmScroll.pos/(128 - Page));
  end;

  if (wmScroll.scrollcode = SB_THUMBTRACK) and (FScrollSynch) then
  begin
    LeftCol := FixedCols + longmuldiv(wmScroll.pos,ColCount-VisibleColCount-FixedCols,MaxShortInt);
  end;

  with FBackground do
  if not Bitmap.Empty and (Display=bdFixed) then
  begin
    MouseToCell(Left,top,longint(fcr.Left),longint(fcr.Top));
    MouseToCell(Left + Bitmap.Width,Top + Bitmap.Height,longint(fcr.Right),longint(fcr.Bottom));
  end;

  inherited;

  with FBackground do
  if not Bitmap.Empty and (Display=bdFixed) then
  begin
    MouseToCell(left,top,longint(tcr.Left),longint(tcr.Top));
    MouseToCell(left + Bitmap.Width,top + Bitmap.Height,longint(tcr.Right),longint(tcr.Bottom));
    if (wmScroll.ScrollCode <> SB_THUMBTRACK) and not EqualRect(fcr,tcr) then
    begin
      RepaintRect(fcr);
      RepaintRect(tcr);
    end;
  end;

  UpdateHScrollBar;
  if HasCheckBox(Col,Row) then
    HideEditor;

  UpdateFooter;
end;


procedure TAdvStringGrid.WMVScroll(var WMScroll: TWMScroll);
var
  r: TRect;
  s: String;
  pt: TPoint;
  nr: Integer;
  fcr,tcr: TRect;

begin
  if FScrollHints in [shVertical,shBoth] then
  begin
    if (wmScroll.ScrollCode = SB_ENDSCROLL) then
    begin
      FScrollHintWnd.ReleaseHandle;
      FScrollHintShow := False;
    end;

    {$IFDEF DELPHI3_LVL}
    if wmScroll.ScrollCode = SB_THUMBTRACK then
    begin
      nr := FixedRows + longmuldiv(wmScroll.pos,RowCount-visibleRowCount-FixedRows,maxshortint);
      s := 'Row : '+inttostr(nr);
      if Assigned(OnScrollHint) then
        OnScrollHint(self,nr,s);
      r := FScrollHintWnd.CalcHintRect(100,s,Nil);
      FScrollHintWnd.Caption := s;
      FScrollHintWnd.Color := FHintColor;
      GetCursorPos(pt);
      r.Left := r.Left + pt.x + 10;
      r.Right := r.Right + pt.x + 10;
      r.Top := r.Top + pt.y;
      r.Bottom := r.Bottom + pt.y;
      FScrollHintWnd.ActivateHint(r,s);
      FScrollHintShow := True;
    end;
   {$ENDIF}
  end;

  if (wmScroll.scrollcode = SB_THUMBTRACK) and (FScrollSynch) then
  begin
    TopRow := FixedRows + longmuldiv(wmScroll.pos,RowCount-VisibleRowCount-FixedRows,MaxShortInt);
  end;

  with FBackground do
  if not Bitmap.Empty and (Display=bdFixed) then
  begin
    MouseToCell(left,top,longint(fcr.Left),longint(fcr.Top));
    MouseToCell(left+Bitmap.Width,top+Bitmap.Height,longint(fcr.Right),longint(fcr.Bottom));
  end;

  inherited;

  {
  if (wmScroll.scrollcode = SB_THUMBTRACK)  then
  begin
    scrollinfo.fMask := SIF_PAGE;
    scrollinfo.cbSize := SizeOf(scrollinfo);
    GetScrollInfo(self.Handle,SB_VERT,scrollinfo);
    if scrollinfo.nPage + wmscroll.pos=128 then
    begin
      TopRow:= RowCount-VisibleRowCount;
      SetScrollPos(self.Handle,SB_VERT,wmscroll.pos,true);
    end
    else
      TopRow := FixedRows+longmuldiv(wmScroll.pos,RowCount-VisibleRowCount-FixedRows,MaxShortInt);
    outputdebugstring(PChar(inttostr(wmScroll.pos)));
  end;
  }

  with FBackground do
  if not Bitmap.Empty and (Display=bdFixed) then
  begin
    MouseToCell(left,top,longint(tcr.Left),longint(tcr.Top));
    MouseToCell(left+Bitmap.Width,top+Bitmap.Height,longint(tcr.Right),longint(tcr.Bottom));
    if (wmScroll.scrollcode <> SB_THUMBTRACK) and not EqualRect(fcr,tcr) then
    begin
      RepaintRect(fcr);
      RepaintRect(tcr);
    end;
  end;

  UpdateVScrollBar;

  if HasCheckBox(Col,Row) then
    HideEditor;
end;

procedure TAdvStringGrid.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FGridImages) then
    FGridImages := nil;

  if (AOperation = opRemove) and (AComponent = FContainer) then
    FContainer := nil;

  if (AOperation = opRemove) and (AComponent = FCellChecker) then
    FCellChecker := nil;

  inherited;
end;


procedure TAdvStringGrid.SizeChanged(OldColCount, OldRowCount: longint);
begin
  if (Parent = Nil) then Exit;

  if FColumnSize.FStretch then
    StretchColumn(FColumnSize.StretchColumn);

  inherited SizeChanged(OldColCount,OldRowCount);

  FlatShowScrollBar(SB_VERT,visibleRowCount + FixedRows < RowCount);
  UpdateVScrollBar;

  FlatShowScrollBar(SB_HORZ,visibleColCount + FixedCols < ColCount);
  UpdateHScrollBar;

  if (FFixedFooters > 0) or (FFixedRightCols > 0) then
    Invalidate;
end;

{$IFDEF DELPHI3_LVL}
function TAdvStringGrid.GetArrowColor: TColor;
begin
  Result := ArwU.Color;
end;

procedure TAdvStringGrid.SetArrowColor(Value: TColor);
begin
  ArwU.Color := Value;
  ArwD.Color := Value;
  ArwL.Color := Value;
  ArwR.Color := Value;
end;
{$ENDIF}

procedure TAdvStringGrid.StretchColumn(ACol: Integer);
var
  i,w: Integer;
begin
  if csLoading in ComponentState then
    Exit;
    
  if ACol = - 1 then
    ACol := ColCount - 1;

  if ACol >= ColCount then
    raise Exception.Create('Stretch column index out of range');

  if (ColCount = 0) or not FColumnSize.FStretch then
    Exit;

  ColchgFlg := False;

  if ColCount = 1 then
  begin
    ColWidths[0] := ClientRect.Right;
    ColchgFlg := True;
    Exit;
  end;

  w := 0;

  // real used Column Width is ColWidth[] + 1 !
  for i := 0 to ColCount - 1 do
  begin
    if i <> ACol then
      w := w + ColWidths[i];
  end;

  if w < ClientRect.Right then
    ColWidths[ACol] := ClientRect.Right - w - 1
  else
    ColWidths[ACol] := DefaultColWidth;  

  ColchgFlg := True;

  if FloatingFooter.Visible then
    FFooterPanel.Align := alBottom;
end;

procedure TAdvStringGrid.StretchRightColumn;
begin
  StretchColumn(ColCount - 1);
end;

procedure TAdvStringGrid.UpdateColSize(ACol: Integer;
  var NewWidth: Integer);
begin
  if Assigned(FOnUpdateColumnSize) then
  begin
    FOnUpdateColumnSize(Self,ACol,NewWidth);
  end;
end;

procedure TAdvStringGrid.UpdateAutoColSize(ACol: Integer;
  var NewWidth: Integer);
begin
  if Assigned(FOnUpdateColumnSize) then
  begin
    FOnUpdateColumnSize(Self,ACol,NewWidth);
  end;
end;

procedure TAdvStringGrid.UpdateColHeaders;
begin

end;

procedure TAdvStringGrid.ColWidthsChanged;
var
  i,nw: Integer;
  Ratio: Double;

begin
  if ColchgFlg then
    StretchColumn(FColumnSize.StretchColumn);

  if csDesigning in ComponentState then
  begin
    if FScrollHintShow then
      FScrollHintWnd.ReleaseHandle;
    FScrollHintShow := False;
  end;

  inherited ColWidthsChanged;

  ColSizeFlg := True;

  if Colsized and FMouseActions.AllColumnSize and (ColclickedSize > 0) then
  begin
    ColSized := False;
    Ratio := ColWidths[Colclicked]/ColClickedSize;
    for i := FixedCols to ColCount - 1 do
      if i <> ColClicked then
        ColWidths[i] := Round(ColWidths[i] * Ratio);
    ColSized := True;
  end;

  if Assigned(FOnEndColumnSize) and ColSized then
    FOnEndColumnSize(Self,ColClicked);

  if ColSized then
  begin
    nw := ColWidths[ColClicked];
    UpdateColSize(ColClicked,nw);

    if nw <> ColWidths[ColClicked] then
    begin
      ColSized := False;
      ColWidths[CoLClicked] := nw;
    end;
  end;

  if ColSized then
  begin
    Colclicked := -1;
    Rowclicked := -1;
  end;

  Colsized := False;
  if HasCheckBox(Col,Row) then
    HideEditor;
  UpdateFooter;
end;

procedure TAdvStringGrid.RowHeightsChanged;
var
  i: Integer;
  Ratio:double;
begin
  if csDesigning in ComponentState then
  begin
    if FScrollHintShow then
      FScrollHintWnd.ReleaseHandle;
    FScrollHintShow := False;
  end;

  inherited RowHeightsChanged;

  if Rowsized and FMouseActions.AllRowSize then
  begin
    Rowsized := False;
    Ratio := RowHeights[Rowclicked]/RowClickedSize;

    for i := FixedRows to RowCount - 1 do
      if i <> RowClicked then
        RowHeights[i] := Round(RowHeights[i] * Ratio);

    Rowsized := True;
  end;

  if Assigned(FOnEndRowSize) and Rowsized then
    FOnEndRowSize(self,Rowclicked);

  if Rowsized then
  begin
    ColClicked := -1;
    RowClicked := -1;
  end;

  Rowsized := False;
  if HasCheckBox(Col,Row) then
    HideEditor;
end;


procedure TAdvStringGrid.RegisterNotifier(ANotifier: TGridChangeNotifier);
begin
  if FNotifierList.IndexOf(ANotifier) = -1 then
    FNotifierList.Add(ANotifier);
end;

procedure TAdvStringGrid.UnRegisterNotifier(ANotifier: TGridChangeNotifier);
var
  Idx: Integer;
begin
  Idx := FNotifierList.IndexOf(ANotifier);

  if Idx <> -1 then
    FNotifierList.Delete(Idx);
end;


procedure TAdvStringGrid.ClearComboString;
begin
  EditCombo.Items.Clear;
end;

function TAdvStringGrid.RemoveComboString(const s:string): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := EditCombo.Items.IndexOf(s);
  if i <> -1 then
  begin
    EditCombo.Items.Delete(i);
    Result := True;
  end;
end;

function TAdvStringGrid.SetComboSelectionString(const s:string): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := EditCombo.Items.IndexOf(s);
  if i <> -1 then
  begin
    FComboIdx := i;
    Result := True;
  end;
end;

procedure TAdvStringGrid.AddComboString(const s:string);
begin
  EditCombo.Items.Add(s);
end;

procedure TAdvStringGrid.AddComboStringObject(const s: string; AObject: TObject);
var
  i: Integer;
begin
  i := EditCombo.Items.Add(s);
  EditCombo.Items.Objects[i] := AObject;
end;


procedure TAdvStringGrid.SetComboSelection(idx: Integer);
begin
  FComboIdx := Idx;
end;

function TAdvStringGrid.GetComboCount: Integer;
begin
  GetComboCount := EditCombo.Items.Count;
end;

function TAdvStringGrid.IsPassword(ACol,ARow: Integer): Boolean;
var
  IsPassword: Boolean;
begin
  IsPassword := False;
  GetCellPassword(ACol,ARow,IsPassword);
  Result := IsPassword;
end;

function TAdvStringGrid.IsEditable(ACol,ARow: Integer): Boolean;
var
  IsFixed,IsEdit: Boolean;
begin
  Result := False;

  if not ((goEditing in Options) or MouseActions.RangeSelectAndEdit) and not FEditDisable then
    Exit;

  // ++ v2.4
  if IsMergedCell(ACol, ARow) and not IsBaseCell(ACol, ARow) then
    Exit;
  // -- v2.4

  IsFixed := False;
  IsEdit := True;
  GetCellReadOnly(ACol,ARow,IsEdit);

  GetCellFixed(ACol,ARow,IsFixed);
  Result := IsEdit and not IsFixed;
end;


function TAdvStringGrid.IsFixed(ACol,ARow: Integer): Boolean;
var
  IsFixed: Boolean;
  pt: TPoint;
begin
  Result := True;
  IsFixed := False;

  pt := BaseCell(RemapCol(ACol),ARow);

  if (pt.Y >= RowCount - FixedFooters) or
     (pt.X >= ColCount - FixedRightCols + NumHiddenColumns) then
    Exit;

  GetCellFixed(pt.X,pt.Y,IsFixed);

  Result := IsFixed;
end;


procedure TAdvStringGrid.UpdateEditingCell(ACol,ARow: Integer; Value: string);
begin
  SetEditText(RemapColInv(ACol),ARow,Value);
  Cells[ACol,ARow] := Value;
end;

procedure TAdvStringGrid.HideEditControl(ACol,ARow: Integer);
begin
  FSpecialEditor := False;

  ACol := RemapCol(ACol);
  FStartEditChar := #0;

  case EditControl of
  edComboEdit,edComboList:
  begin
    if EditMode then
    begin
      EditMode := False;
      UpdateEditingCell(ACol,ARow,EditCombo.Text);

      EditCombo.Visible := False;
      EditCombo.Enabled := False;
    end;
  end;

  {$IFDEF TMSUNICODE}
  edUniEdit:
  begin
    EditMode := False;
    WideCells[ACol,ARow] := EditUni.Text;
    EditUni.Enabled := False;
    EditUni.Visible := False;
  end;
  edUniComboEdit,edUniComboList:
  begin
    EditMode := False;
    WideCells[ACol,ARow] := ComboUni.Text;
    ComboUni.Enabled := False;
    ComboUni.Visible := False;
  end;
  {$ENDIF}

  edSpinEdit,edFloatSpinEdit,edTimeSpinEdit,edDateSpinEdit:
  begin
    EditMode := False;

    if EditControl in [edSpinEdit,edTimeSpinEdit] then
      UpdateEditingCell(ACol,ARow,EditSpin.Text);

    if EditControl = edFloatSpinEdit then
      Floats[ACol,ARow] := EditSpin.FloatValue;

    if EditControl = edDateSpinEdit then
      Dates[ACol,ARow] := EditSpin.DateValue;

    EditSpin.Enabled := False;
    EditSpin.Visible := False;
  end;
  edDateEdit,edDateEditUpDown:
  begin
    {$IFDEF DELPHI3_LVL}
    if ComCtrlOk then
    begin
      if EditDate.Checked then
        UpdateEditingCell(ACol,ARow,DateToStr(EditDate.Date))
      else
        UpdateEditingCell(ACol,ARow,'');

      EditDate.Enabled := False;
      EditDate.Visible := False;
      EditMode := False;
    end;
    {$ENDIF}
  end;
  edTimeEdit:
  begin
    {$IFDEF DELPHI3_LVL}
    if ComCtrlOk then
    begin
      UpdateEditingCell(ACol,ARow,TimeToStr(EditDate.time));
      EditDate.Enabled := False;
      EditDate.Visible := False;
      EditMode := False;
    end;
    {$ENDIF}
  end;
  edCheckBox:
  begin
    EditCheck.Enabled := False;
    EditCheck.Visible := False;
    EditMode := False;
  end;
  edEditBtn,edNumericEditBtn,edFloatEditBtn:
  begin
    UpdateEditingCell(ACol,ARow,EditBtn.Text);
    EditBtn.Enabled := False;
    EditBtn.Visible := False;
    EditMode := False;
  end;
  edUnitEditBtn:
  begin
    UpdateEditingCell(ACol,ARow,UnitEditBtn.Text + UnitEditBtn.UnitID);
    UnitEditBtn.Enabled := False;
    UnitEditBtn.Visible := False;
    EditMode := False;
  end;
  edRichEdit:
  begin
    UpdateEditingCell(ACol,ARow,RichToString(FInplaceRichEdit));
    FInplaceRichEdit.Enabled := False;
    FInplaceRichEdit.Visible := False;
    EditMode := False;
  end;
  edButton:
  begin
    Gridbutton.Enabled := False;
    Gridbutton.Visible := False;
    EditMode := False;
  end;
  edCustom:
  begin
    if Assigned(EditLink) then
    begin
      UpdateEditingCell(ACol,ARow,EditLink.GetEditorValue);
      if EditLink.EditStyle <> esPopup then
        EditLink.SetVisible(False);
      EditMode := False;
    end;
  end;
  end;

  DoneEditing;
  FEditActive := False;
end;

procedure TAdvStringGrid.HideCellEdit;
begin
  HideEditControl(Col,Row);
end;

procedure TAdvStringGrid.ShowCellEdit;
begin
  PostMessage(Handle,WM_KEYDOWN ,VK_F2,0);
end;

procedure TAdvStringGrid.ShowEditControl(ACol,ARow: Integer);
var
  r,dr: TRect;
  s: string;
  pt: TPoint;
  CellWidth,CellHeight,OCol,Hold: Integer;
  EditColor: TColor;
  EditFont: TFont;
  AState: TGridDrawState;
  HAlign: TAlignment;
  VAlign: TVAlignment;
  WW: Boolean;
  ValD: Double;
  Err, ValI: Integer;

  {$IFDEF DELPHI5_LVL}
  i: Integer;
  ws: array of widestring;
  {$ENDIF}

begin
  FEditing := True;
  FSpecialEditor := True;
  FEditActive := True;

  r := CellRect(ACol,ARow);

  {$IFDEF DELPHI4_LVL}
  if UseRightToLeftAlignment then
  begin
    dr := CellRect(LeftCol,TopRow);
    Hold := r.Right - r.Left;
    r.Left := dr.Left - (r.Right - dr.Right);
    r.Right := r.Left + Hold;
  end;
  {$ENDIF}

  OCol := ACol;
  ACol := RemapCol(ACol);

  CellWidth := R.Right - R.Left - 1;
  CellHeight := R.Bottom - R.Top - 1;   

  AState := [];
  GetVisualProperties(OCol,Row,AState,False,False,True,Canvas.Brush,Canvas.Font,HAlign,VAlign,WW);

  EditColor := Canvas.Brush.Color;
  EditFont := Canvas.Font;

  // Make sure the grid is no longer in selecting state
  FGridState := gsNormal;

  case EditControl of
  edComboEdit:
    begin
      EditMode := True;
      EditCombo.Width := 0;
      EditCombo.Height := 0;
      EditCombo.Top := r.Top;
      EditCombo.Left := r.Left;

      EditCombo.Enabled := True;
      EditCombo.DroppedDown := False;

      EditCombo.Style := csDropDown;
      SendMessage(EditCombo.Handle,CB_SETITEMHEIGHT,-1,CellHeight -6);

      EditCombo.Width := CellWidth;
      EditCombo.Height := CellHeight + (EditCombo.DropDownCount + 1) * EditCombo.ItemHeight;

      EditCombo.Text := GetEditText(OCol,ARow);

      EditCombo.Color := EditColor;

      EditCombo.Visible := True;

      EditCombo.Flat := Look in [glSoft,glTMS];
      EditCombo.Etched := Look in [glSoft,glTMS];

      if FNavigation.FAutoComboDropSize then
        EditCombo.SizeDropDownWidth;

      EditCombo.SetFocus;
      EditCombo.DroppedDown := FMouseActions.DirectComboDrop;

      if FStartEditChar <> #0 then
        PostMessage(EditCombo.Handle,WM_CHAR,Ord(FStartEditChar),0);
    end;
  edComboList:
    begin
      EditMode := True;
      EditCombo.Top := r.Top;
      EditCombo.Left := r.Left;

      EditCombo.Width := 0;
      EditCombo.Height := 0;
      EditCombo.DroppedDown := False;
      EditCombo.Enabled := True;

      EditCombo.Style := csDropDownList;

      // EditCombo.DropDownCount := 8;

      EditCombo.Itemindex := EditCombo.Items.IndexOf(Cells[ACol,ARow]);

      if ((FComboIdx = -1) and (EditCombo.ItemIndex = -1)) then
        EditCombo.ItemIndex := 0
      else
        if (EditCombo.ItemIndex = -1) then
          EditCombo.ItemIndex := FComboIdx;

      EditCombo.Width := CellWidth;
      EditCombo.Height := CellHeight + (EditCombo.DropDownCount+1) * EditCombo.ItemHeight;

      EditCombo.Text := GetEditText(OCol,ARow);
      EditCombo.Color := EditColor;

      EditCombo.Visible := True;

      EditCombo.Flat := Look in [glSoft,glTMS];
      EditCombo.Etched := Look in [glSoft,glTMS];

      if FNavigation.FAutoComboDropSize then
        EditCombo.SizeDropDownWidth;

      EditCombo.SetFocus;

      EditCombo.DroppedDown := FMouseActions.DirectComboDrop;

      if FStartEditChar <> #0 then
        PostMessage(EditCombo.Handle,WM_CHAR,Ord(FStartEditChar),0);

    end;

  {$IFDEF TMSUNICODE}
  edUniEdit:
    begin
      EditMode := True;
      EditUni.ReCreateWnd;
      EditUni.Top := r.Top + 2 + XYOffset.Y;
      EditUni.Left := r.Left + 2 + XYOffset.X;
      EditUni.Width := CellWidth - 2 - XYOffset.X * 2;
      EditUni.Height := CellHeight - 2 - XYOffset.Y * 2;
      EditUni.Visible := True;
      EditUni.Enabled := True;
      EditUni.Color := EditColor;
      EditUni.Font.Assign(Font);

      EditUni.Text := WideCells[OCol,ARow];
      EditUni.SetFocus;

      if FStartEditChar <> #0 then
        PostMessage(EditUni.Handle,WM_CHAR,Ord(FStartEditChar),0);
    end;

  edUniComboEdit,edUniComboList:
    begin
      SetLength(ws,combouni.Items.Count);

      // copy widestrings as control recreate causes to push items back to 8bit
      for i := 1 to combouni.Items.Count do
       ws[i - 1] := combouni.Items[i - 1];

      EditMode := True;

      ComboUni.Top := r.Top;
      ComboUni.Left := r.Left;

      ComboUni.Width := 0;
      ComboUni.Height := 0;
      ComboUni.DroppedDown := False;
      ComboUni.Enabled := True;

      if EditControl = edUniComboEdit then
        ComboUni.Style := csDropDown
      else
      begin
        ComboUni.Style := csDropDownList;
      end;

      combouni.Items.Clear;

      for i := 0 to High(ws) do
       combouni.items.Add(ws[i]);

      if EditControl= edUniComboList then
        ComboUni.Itemindex := ComboUni.Items.IndexOf(WideCells[ACol,ARow]);

      if ((FComboIdx = -1) and (ComboUni.ItemIndex = -1)) then
        ComboUni.ItemIndex := 0
      else
        if (ComboUni.ItemIndex = -1) then
          ComboUni.ItemIndex := FComboIdx;

      ComboUni.Width := CellWidth;
      ComboUni.Height := CellHeight + (ComboUni.DropDownCount+1) * ComboUni.ItemHeight;

      ComboUni.Text := WideCells[OCol,ARow];
      ComboUni.Color := EditColor;

      ComboUni.Visible := True;
      ComboUni.Font.Assign(Font);
      ComboUni.Flat := Look in [glSoft,glTMS];
      ComboUni.Etched := Look in [glSoft,glTMS];

      if FNavigation.FAutoComboDropSize then
        ComboUni.SizeDropDownWidth;


      ComboUni.SetFocus;

      ComboUni.DroppedDown := FMouseActions.DirectComboDrop;

    end;
  {$ENDIF}

  edSpinEdit,edFloatSpinEdit,edTimeSpinEdit,edDateSpinEdit:
    begin
      EditMode := True;
      EditSpin.ReCreateWnd;
      EditSpin.Top := r.Top;
      EditSpin.Left := r.Left;
      EditSpin.Width := CellWidth;
      EditSpin.Height := CellHeight;
      EditSpin.Visible := True;
      EditSpin.Enabled := True;
      EditSpin.Color := EditColor;

      s := GetEditText(OCol,ARow);

      case EditControl of
      edSpinEdit:
        begin
          EditSpin.SpinType := sptNormal;
          Val(s,ValI,Err);
          EditSpin.Value := ValI;
        end;
      edFloatSpinEdit:
        begin
          EditSpin.SpinType := sptFloat;
          s := RemoveSeps(s);
          Val(s,ValD,Err);
          EditSpin.FloatValue := ValD;
        end;
      edTimeSpinEdit:
        begin
          EditSpin.SpinType := sptTime;
          EditSpin.Text := GetEditText(ACol,ARow);
        end;
      edDateSpinEdit:
        begin
          try
            if s = '' then
              EditSpin.DateValue := Now
            else
              EditSpin.DateValue := StrToDate(s);
          except
            EditSpin.DateValue := Now;
          end;
          EditSpin.SpinType := sptDate;
        end;
      end;
      EditSpin.SetFocus;
      if FStartEditChar <> #0 then
        PostMessage(EditSpin.Handle,WM_CHAR,Ord(FStartEditChar),0);
    end;
  edDateEdit,edDateEditUpdown:
    begin
      {$IFDEF DELPHI3_LVL}
      if ComCtrlOk then
      begin
        EditMode := True;
        EditDate.Parent := Self;
        EditDate.ReCreatewnd;

        s := GetEditText(OCol,ARow);

        try
          if s = '' then
            EditDate.Date := Now
          else
            EditDate.Date := StrToDate(s);
        except
          EditDate.Date := Now;
        end;
        EditDate.Kind := dtkDate;


        if EditControl = edDateEditUpdown then
          EditDate.DateMode := dmUpDown;
        EditDate.Top := r.Top;
        EditDate.Left := r.Left;
        EditDate.Width := CellWidth;

        if CellHeight < EditDate.Height then
          EditDate.Height := CellHeight;

        EditDate.Enabled := True;
        EditDate.Visible := True;
        EditDate.Color := EditColor;
        EditDate.SetFocus;
      end;
     {$ENDIF}
   end;
  edTimeEdit:
    begin
      {$IFDEF DELPHI3_LVL}
      if ComCtrlOk then
      begin
        EditMode := True;
        EditDate.ReCreateWnd;
        s := GetEditText(OCol,ARow);

        try
          if s = '' then
            EditDate.time := Now
          else
            EditDate.time := StrToTime(GetEditText(OCol,ARow));
        except
          EditDate.time := Now;
        end;
        EditDate.Kind := dtkTime;
        EditDate.Top := r.Top;
        EditDate.Left := r.Left;
        EditDate.Height := CellHeight;
        EditDate.Width := CellWidth;
        EditDate.Enabled := True;
        EditDate.Visible := True;
        EditDate.Color := EditColor;
        EditDate.SetFocus;
      end;
      {$ENDIF}
    end;
  edCheckBox:
    begin
      EditMode := True;
      EditCheck.ReCreatewnd;
      EditCheck.Top := r.Top;
      EditCheck.Left := r.Left;
      EditCheck.Width := CellWidth;
      EditCheck.Height := CellHeight;
      EditCheck.Caption := GetEditText(OCol,ARow);
      EditCheck.Enabled := True;
      EditCheck.Checked := False;
      EditCheck.State := cbUnchecked;
      EditCheck.Visible := True;
      EditCheck.SetFocus;
   end;
  edEditBtn,edFloatEditBtn,edNumericEditBtn:
    begin
      EditMode := True;
      EditBtn.ReCreatewnd;
      EditBtn.Top := r.Top;
      EditBtn.Left := r.Left;
      EditBtn.Width := CellWidth;
      EditBtn.Text := GetEditText(OCol,ARow);
      EditBtn.MaxLength := GetEditLimit;
      EditBtn.Visible := True;
      EditBtn.Enabled := True;
      EditBtn.Color := EditColor;
      EditBtn.SetFocus;
      EditBtn.Height := CellHeight;

      if FStartEditChar <> #0 then
        PostMessage(EditBtn.Handle,WM_CHAR,Ord(FStartEditChar),0);
    end;
  edUnitEditBtn:
    begin
      EditMode := True;
      UnitEditBtn.ReCreatewnd;
      UnitEditBtn.Top := r.Top;
      UnitEditBtn.Left := r.Left;
      UnitEditBtn.Width := CellWidth;
      s := GetEditText(OCol,ARow);
      UnitEditBtn.MaxLength := GetEditLimit;
      UnitEditBtn.UnitID := '';
      UnitEditBtn.Text := '';
      while Length(s) > 0 do
      begin
        if s[1] in ['0'..'9','.',',','-'] then
          UnitEditBtn.Text := UnitEditBtn.Text+s[1]
        else
          UnitEditBtn.UnitID := UnitEditBtn.unitid+s[1];
        Delete(s,1,1);
      end;
      UnitEditBtn.Visible := True;
      UnitEditBtn.Enabled := True;
      UnitEditBtn.Color := EditColor;
      UnitEditBtn.SetFocus;
      UnitEditBtn.Height := CellHeight;

      if FStartEditChar <> #0 then
        PostMessage(EditBtn.Handle,WM_CHAR,Ord(FStartEditChar),0);
    end;
  edButton:
    begin
      EditMode := True;
      Gridbutton.ReCreateWnd;
      Gridbutton.Top := r.Top - 1;
      Gridbutton.Left := r.Left - 1;
      Gridbutton.Width := CellWidth + 2;
      Gridbutton.Height := CellHeight + 2;
      Gridbutton.Text := GetEditText(OCol,ARow);
      Gridbutton.Visible := True;
      Gridbutton.Enabled := True;
      Gridbutton.SetFocus;
    end;

  edRichEdit:
    begin
      EditMode := True;
      FInplaceRichEdit.ReCreateWnd;
      FInplaceRichEdit.Parent := Self;
      FInplaceRichEdit.BorderStyle := bsNone;
      FInplaceRichEdit.HideSelection := False;

      FInplaceRichEdit.Top := r.Top;
      FInplaceRichEdit.Left := r.Left;
      FInplaceRichEdit.Width := CellWidth;
      FInplaceRichEdit.Height := CellHeight;

      FInplaceRichEdit.Lock;

      CellToRich(ACol, ARow, FInplaceRichEdit);

      FInplaceRichEdit.SelStart := 0;
      FInplaceRichEdit.SelLength := Length(FInplaceRichEdit.Text);

      FInplaceRichEdit.Visible := True;
      FInplaceRichEdit.Enabled := True;

      r := Rect(2,2,r.Right - r.Left - 2,r.Bottom - r.Top - 2);
      SendMessage(FInplaceRichEdit.Handle,EM_SETRECT,0,Longint(@r));

      FInplaceRichEdit.Color := EditColor;
      FInplaceRichEdit.SetFocus;

      if FStartEditChar <> #0 then
        PostMessage(FInplaceRichEdit.Handle,WM_CHAR,Ord(FStartEditChar),0);

      FInplaceRichEdit.UnLock;
    end;

  edCustom:
    begin
      if Assigned(EditLink) then
      begin
        EditMode := True;
        EditLink.FOwner := Self;
        EditLink.FEditCell := Point(ACol,ARow);

        if EditLink.EditStyle = esPopup then
        begin
          if EditLink.AutoPopupWidth then
            EditLink.PopupWidth := r.Right - r.Left;

          EditLink.FPopupForm := TForm.Create(Application);
          pt := ClientToScreen(Point(r.Left,r.Top));
          EditLink.FPopupForm.OnDeactivate := EditLink.FormExit;
          EditLink.FPopupForm.Left := pt.x;
          EditLink.FPopupForm.Top := pt.y;
          EditLink.FPopupForm.Width := EditLink.FPopupWidth;
          EditLink.FPopupForm.Height := EditLink.FPopupHeight;
          EditLink.FPopupForm.BorderStyle := bsNone;
          EditLink.FPopupForm.Show;
          EditLink.CreateEditor(EditLink.FPopupForm);
        end
        else
        begin
          EditLink.CreateEditor(Self);
        end;

        if EditLink.EditStyle = esPopup then
          EditLink.SetRect(Rect(0,0,EditLink.FPopupWidth,EditLink.FPopupHeight))
        else
          EditLink.SetRect(Rect(r.Left,r.Top,r.Right,r.Bottom));

        EditLink.SetVisible(True);
        EditLink.SetCellProps(EditColor,EditFont);
        EditLink.SetProperties;

        if Assigned(FOnGetEditorProp) then
          FOnGetEditorProp(self,ACol,ARow,EditLink);

        EditLink.SetEditorValue(GetEditText(OCol,ARow));
        EditLink.SetFocus(True);

        if FStartEditChar <> #0 then
          PostMessage(EditLink.GetEditControl.Handle,WM_CHAR,Ord(FStartEditChar),0);
      end;
    end;
  end;

  FStartEditChar := #0;
end;

procedure TAdvStringGrid.RestoreCache;
begin
  Cells[RemapCol(Col),Row] := FCellCache;
  //cause an edit update when cell is remapped due to hidden Column
  Cells[Col,Row] := Cells[Col,Row];
end;

function TAdvStringGrid.CanEditShow: Boolean;
var
  RCol: Integer;
  BC: TPoint;

begin
  Result := False;

  if FValidating then Exit;

  Result := inherited CanEditshow;

  if csDesigning in ComponentState then
    Exit;

  RCol := RemapCol(Col);
  BC := BaseCell(RCol,Row);

  if Result and not EditMode and HasStaticEdit(BC.X,BC.Y) then
  begin
    Result := False;
    Exit;
  end;

  if Result and not EditMode then
  begin
    FCellCache := CurrentCell;
    EditControl := edNormal;
    GetCellEditor(BC.X,BC.Y,EditControl);
    EditMode := True;
    if not (EditControl in [edNormal,edNumeric,edPositiveNumeric,edFloat,edCapital,
      edMixedCase,edPassword,edUpperCase,edLowerCase]) then
    begin
      BC := BaseCell(Col,Row);
      ShowEditControl(BC.X,BC.Y);
      FEntered := True;
      Result := False;
    end;
  end;

  if Result then
  begin
    FEntered := True;
    FEditing := True;
  end;
end;

function TAdvStringGrid.SelectCell(ACol, ARow: LongInt): Boolean;
var
  CanEdit: Boolean;
  CanChange: Boolean;
  ECol, ERow, OCol, ORow, OSC,OSR: Integer;
  IsNormalEdit: Boolean;
  R: TRect;
  OrgCellVal: string;

begin
  CanChange := True;
  Result := False;

  // floating bottomrow

  if FloatingFooter.Visible then
  begin
    if FloatingFooter.FooterStyle in [fsColumnPreview, fsCustomPreview] then
    begin
      FFooterPanel.Invalidate;

      R := CellRect(ACol,ARow);
      if (R.Bottom > ClientRect.Bottom - FloatingFooter.Height +2) and
       (ARow < RowCount) then
         TopRow := TopRow + 1;
    end
    else
    begin
      R := CellRect(ACol,ARow);
      if (R.Bottom > ClientRect.Bottom - FloatingFooter.Height + 2) and
       (ARow < RowCount - 1) then
         TopRow := TopRow + 1;

      if (ARow = RowCount - 1) then Exit;
    end;
  end;

  if (ACol < 0) or (ARow < 0) then
    Exit;

  if (ARow <> Row) and Assigned(FOnRowChanging) then
    FOnRowChanging(Self,Row,ARow,Canchange);

  if (ACol <> Col) and Assigned(FOnColChanging) then
    FOnColChanging(Self,Col,ACol,Canchange);

  if ((ACol <> Col) or (ARow <> Row)) and Assigned(FOnCellChanging)
    and not FDisableChange then
    FOnCellChanging(Self,Row,Col,ARow,ACol,CanChange);

  if ((ACol = 0) and (FNumNodes > 0) and not (goRowSelect in Options)) or not CanChange then
    Exit;

  OSC := Selection.Left;
  OSR := Selection.Top;
  OCol := Col;
  ORow := Row;

  ERow := Row;
  ECol := RemapCol(ACol);

  // Moved original cell value assignment after cell validation
  OrgCellVal := Cells[ECol,ARow];

  IsNormalEdit := Assigned(NormalEdit);

  if IsNormalEdit then
    IsNormalEdit := (GetFocus = NormalEdit.Handle);

  if not HasStaticEdit(ECol,ARow) then
  begin
    CanEdit := (goEditing in Options) or FEditDisable;

    GetCellReadOnly(ECol,ARow,CanEdit);

    if CanEdit then
    begin
      // Moved inside CanEdit condition
      FEditDisable := False;
      if not (goEditing in Options) then
      begin
        FEditChange := True;
        InitValidate(ACol,ARow);
        Options := Options + [goEditing];
      end;

      if FEditing then
      begin
        HideInplaceEdit;
        OrgCellVal := Cells[ECol,ARow];
      end;
    end
    else
    begin
      if goEditing in Options then
      begin
        FEditDisable := True;
        FEditChange := True;
        Options := Options - [goEditing];
      end;
    end;
  end;

  if FEditing and not IsNormalEdit then
  begin
    Result := ValidateCell(CurrentCell);
    // Result := ValidateCell(Cells[RemapCol(Col),Row]);
    if Result then
      Result := inherited SelectCell(ACol,ARow);
  end
  else
  if IsFixed(ACol,ARow) then
  begin
    Result := False
  end
  else
    Result := inherited SelectCell(ACol,ARow);

  if Assigned(FRowIndicator) and (FixedCols > 0) then
  begin
    if not FRowIndicator.Empty then
    begin
      RepaintCell(0,ERow);
      RepaintCell(0,ARow);
    end;
  end;

  if ActiveCellShow then
  begin
    UpdateActiveCells(OCol,ORow,ACol,ARow);
    if (OSC <> OCol) and (OSR <> ORow) then
      UpdateActiveCells(OSC,OSR,ACol,ARow);
  end;

  FCellCache := OrgCellVal;
end;

procedure TAdvStringGrid.UpdateActiveCells(co,ro,cn,rn: Integer);
begin
  RepaintCell(co,0);
  RepaintCell(0,ro);
  RepaintCell(cn,0);
  RepaintCell(0,rn);
end;

function TAdvStringGrid.FreeCellGraphic(ACol,ARow: Integer): Boolean;
var
  cg:TCellGraphic;
begin
  Result := False;
  cg := GetCellGraphic(ACol,ARow);
  if cg = nil then
    Exit
  else
    if cg.CellType <> ctVirtCheckBox then
      cg.Free;

  GraphicObjects[ACol,ARow] := nil;
  Result :=True;
end;

function TAdvStringGrid.RemoveCellGraphic(ACol,ARow: Integer;celltype:TCellType): Boolean;
begin
  Result := False;
  if CellTypes[ACol,ARow] = celltype then
  begin
    Result := FreeCellGraphic(ACol,ARow);
  end;
end;

function TAdvStringGrid.CreateCellGraphic(ACol,ARow: Integer): TCellGraphic;
var
  cg: TCellGraphic;
  rc: Integer;

begin
  cg := GetCellGraphic(ACol,ARow);

  if Assigned(cg) then
    cg.Free;

  cg := TCellGraphic.Create;
  if (Cells[ACol,ARow] = '') then
  begin
    // make sure cell gets allocated
    Cells[ACol,ARow] := ' ';
    GraphicObjects[ACol,ARow] := cg;
    Cells[ACol,ARow] := '';
  end
  else
    GraphicObjects[ACol,ARow] := cg;

  //++2.4.0.4 -> update correct cell for hidden columns
  if FNumHidden > 0 then
  begin
    rc := RemapColInv(ACol);
    if ACol <> rc then
      RepaintCell(rc,ARow);
  end;

  Result := cg;
end;

function TAdvStringGrid.GetCellGraphic(ACol,ARow: Integer):TCellGraphic;
begin
  Result := nil;

  if Assigned(GraphicObjects[ACol,ARow]) then
  begin
    if not (GraphicObjects[ACol,ARow] is TCellGraphic) then
      Exit;
    Result := (GraphicObjects[ACol,ARow] as TCellGraphic);
  end;
end;

function TAdvStringGrid.GetCellGraphicSize(ACol,ARow: Integer): TPoint;
var
  cg: TCellGraphic;
  w,h,i: Integer;
  s: string;
  CDIM: TPoint;
  r: TRect;

begin
  Result.x := 0;
  Result.y := 0;

  cg := CellGraphics[ACol,ARow];
  if cg = nil then
    Exit;

  w := 0;
  h := 0;
  s := Cells[ACol,ARow];
  CDIM := CellSize(ACol,ARow);

  case cg.celltype of
  ctIcon:
  begin
    if cg.CellHAlign in [haBeforeText,haAfterText] then
      w := cg.CellIcon.Width
    else
      if s = '' then
        w := cg.CellIcon.Width;
    h := cg.CellIcon.Height;
  end;

  ctPicture:
  begin
    Result := cg.GetPictureSize(CDIM.X,CDIM.Y,s <> '');
    w := Result.x;
    h := Result.y;
  end;

  ctFilePicture:
  begin
    Result := cg.GetPictureSize(CDIM.X,CDIM.Y,s <> '');
    w := Result.x;
    h := Result.y;
  end;

  ctButton,ctBitButton:
  begin
    w := cg.CellIndex and $FFFF;
    h := (cg.CellIndex and $FFFF0000) shr 16;
  end;


  ctBitmap:
  begin
    if cg.CellHAlign in [haBeforeText,haAfterText] then
      w := cg.CellBitmap.Width
    else
      if s = '' then
        w := cg.CellBitmap.Width;

    h := cg.CellBitmap.Height;
  end;
  ctImageList,ctDataImage:
  begin
    if Assigned(GridImages) then
    begin
      if cg.CellHAlign in [haBeforeText,haAfterText] then
        w := GridImages.Width
      else
        if s = '' then
          w := GridImages.Width;
      h := GridImages.Height;
    end;
  end;
  ctProgressPie:
  begin
    w := 20;
    h := 20;
  end;

  ctCheckbox,ctDataCheckBox,ctVirtCheckBox:
  begin
    w := FControlLook.CheckSize;
    h := FControlLook.CheckSize;
  end;
  ctRadio:
  begin
    if not cg.CellBoolean then
    begin
      w := 12;
      for i := 1 to TStringList(cg.CellBitmap).Count do
      begin
        if 12 + Canvas.TextWidth(TStringList(cg.CellBitmap).Strings[i - 1]) > w then
         w := 12 + Canvas.TextWidth(TStringList(cg.CellBitmap).Strings[i - 1]);
      end;

      h := (Canvas.TextHeight('gh')) * TStringList(cg.CellBitmap).Count;
    end
    else
    begin
      w := 0;
      h := Canvas.TextHeight('gh');
      for i := 1 to TStringList(cg.CellBitmap).Count do
      begin
        w := w + 12 + Canvas.TextWidth(TStringList(cg.CellBitmap).Strings[i - 1]);
      end;
    end;
  end;
  ctImages:
  begin
    if Assigned(GridImages) then
    begin
      if cg.CellBoolean then
      begin
        w := CellImages[ACol,ARow].Count * GridImages.Width;
        h := GridImages.Height;
      end
      else
      begin
        h := CellImages[ACol,ARow].Count * GridImages.Height;
        w := GridImages.Width;
      end;
    end;
  end;
  end;

  if (cg.CellVAlign = vaFull) or (cg.CellHAlign = haFull) then
  begin
    r := CellRect(ACol,ARow);
    if cg.CellVAlign = vaFull then
    begin
      h := r.Bottom - r.Top;
    end;
    if cg.CellHAlign = haFull then
    begin
      w := r.Right - r.Left;
    end;
  end;



  Result.x := w;
  Result.y := h;
end;

function TAdvStringGrid.GetPrintGraphicSize(ACol,ARow,CW,RH: Integer;ResFactor: Double): TPoint;
var
  cg: TCellGraphic;
  w,h,i: Integer;
  s: string;
  CDIM: TPoint;

begin
  Result.x := 0;
  Result.y := 0;

  cg := CellGraphics[ACol,ARow];
  if cg = nil then
    Exit;

  w := 0;
  h := 0;
  s := Cells[ACol,ARow];
  CDIM := Point(CW,RH);

  case cg.celltype of
  ctIcon:
  begin
    w := cg.CellIcon.Width;
    h := cg.CellIcon.Height;
  end;

  ctPicture:
  begin
    {$IFDEF TMSCODESITE}
    CodeSite.SendPoint('picsize',CDIM);
    {$ENDIF}
    Result := cg.GetPictureSize(CDIM.X,CDIM.Y,s <> '');
    {$IFDEF TMSCODESITE}
    CodeSite.SendPoint('result',Result);
    {$ENDIF}
    w := Round(Result.X / ResFactor);
    h := Round(Result.Y / ResFactor);
  end;

  ctFilePicture:
  begin
    Result := cg.GetPictureSize(CDIM.X,CDIM.Y,s <> '');
    w := Round(Result.X / ResFactor);
    h := Round(Result.Y / ResFactor);
  end;

  ctButton,ctBitButton:
  begin
    w := cg.CellIndex and $FFFF;
    h := (cg.CellIndex and $FFFF0000) shr 16;
  end;

  ctBitmap:
  begin
    w := cg.CellBitmap.Width;
    h := cg.CellBitmap.Height;
  end;
  ctDataImage:
  begin
    if Assigned(GridImages) then
    begin
      w := GridImages.Width;
      h := GridImages.Height;
    end;
  end;
  ctImageList:
  begin
    if Assigned(GridImages) then
    begin
      if cg.CellHAlign in [haBeforeText,haAfterText] then
        w := GridImages.Width
      else
        if s = '' then
          w := GridImages.Width;
      h := GridImages.Height;
    end;
  end;
  ctCheckbox,ctDataCheckBox,ctVirtCheckBox:
  begin
    w := FControlLook.CheckSize;
    h := FControlLook.CheckSize;
  end;
  ctProgressPie:
  begin
    w := 20;
    h := 20;
  end;
  ctRadio:
  begin
    if not cg.CellBoolean then
    begin
      w := 12;
      for i := 1 to TStringList(cg.CellBitmap).Count do
      begin
        if 12 + Canvas.TextWidth(TStringList(cg.CellBitmap).Strings[i - 1]) > w then
         w := 12 + Canvas.TextWidth(TStringList(cg.CellBitmap).Strings[i - 1]);
      end;

      h := (Canvas.TextHeight('gh')) * TStringList(cg.CellBitmap).Count;
    end
    else
    begin
      w := 0;
      h := Canvas.TextHeight('gh');
      for i := 1 to TStringList(cg.CellBitmap).Count do
      begin
        w := w + 12 + Canvas.TextWidth(TStringList(cg.CellBitmap).Strings[i - 1]);
      end;
    end;
  end;
  ctImages:
  begin
    if Assigned(GridImages) then
    begin
      if cg.CellBoolean then
      begin
        w := CellImages[ACol,ARow].Count * GridImages.Width;
        h := GridImages.Height;
      end
      else
      begin
        h := CellImages[ACol,ARow].Count * GridImages.Height;
        w := GridImages.Width;
      end;
    end;
  end;
  end;

  Result.x := w;
  Result.y := h;
end;

function TAdvStringGrid.HasNodes: Boolean;
begin
  Result := FNumNodes > 0; 
end;

function TAdvStringGrid.NodeIndent(ARow: Integer): Integer;
//var
//  i: Integer;
begin
  Result := 0;

  if FNumNodes > 0 then
  begin
    // i := ARow;

    if HasCellProperties(0,ARow) then
      Result := CellProperties[0,ARow].NodeLevel * 16;

    {
    Result := 0;
    if not IsNode(ARow) then
      while ARow > 0 do
      begin
        if IsNode(ARow) and not GetNodeState(ARow) then
          if i - ARow < GetNodeSpan(ARow) then
          begin
            Result := 16;
            Break;
          end;

        Dec(ARow);
      end
    else
      Result := 16;
    }
  end;
end;

function TAdvStringGrid.GetCellType(ACol,ARow: Integer): TCellType;
begin
  Result := ctEmpty;

  if Assigned(GraphicObjects[ACol,ARow]) then
  begin
    if not (GraphicObjects[ACol,ARow] is TCellGraphic) then
      Exit;
    Result := (GraphicObjects[ACol,ARow] as TCellGraphic).CellType;
  end;
end;

function TAdvStringGrid.GetCellImages(ACol,ARow: Integer): TIntList;
begin
  if CellTypes[ACol,ARow] = ctImages then
    Result := TIntList((GraphicObjects[ACol,ARow] as TCellGraphic).CellBitmap)
  else
    Result := nil;
end;

function TAdvStringGrid.GetCellImageIdx(ACol,ARow: Integer): Integer;
begin
  case CellTypes[ACol,ARow] of
  ctImageList:Result := TCellGraphic(GraphicObjects[ACol,ARow]).CellIndex;
  ctIcon:Result := Integer(TCellGraphic(GraphicObjects[ACol,ARow]).CellIcon);
  cTBitmap:Result := Integer(TCellGraphic(GraphicObjects[ACol,ARow]).CellBitmap);
  else
    Result := -1;
  end;
end;


procedure TAdvStringGrid.SetInts(ACol,ARow: Integer;const Value: Integer);
begin
  Cells[ACol,ARow] := IntToStr(Value);
end;

function TAdvStringGrid.GetInts(ACol,ARow: Integer): Integer;
var
  s: string;
  Res,Err: Integer;
begin
  s := Cells[ACol,ARow];
  if s = '' then
    s := '0';
  Val(s,Res,Err);
  if Err <> 0 then
    raise EAdvGridError.Create('Cell does not contain integer value');

  GetInts := Res;
end;

procedure TAdvStringGrid.SetFloats(ACol,ARow: Integer;const Value:double);
begin
  Cells[ACol,ARow] := Format(FFloatFormat,[Value]);
end;

function TAdvStringGrid.GetFloats(ACol,ARow: Integer): Double;
var
  s: string;
  Res: Double;
  Err: Integer;
begin
  s := RemoveSeps(Cells[ACol,ARow]);

  if s = '' then
    s := '0';

  Val(s,Res,Err);
  if Err <> 0 then
    raise EAdvGridError.Create('Cell does not contain a float value');
  GetFloats := Res;
end;

function TAdvStringGrid.GetCtrlVal(ACol, ARow: Integer;
  ID: string): string;
var
  s:string;
begin
  Result := '';
  if GetControlValue(Cells[ACol,ARow],ID,s) then
    Result := s;
end;

procedure TAdvStringGrid.SetCtrlVal(ACol, ARow: Integer; ID: string;
  const Value: string);
var
  s:string;
begin
  s := Cells[ACol,ARow];
  if SetControlValue(s,ID,Value) then
    Cells[ACol,ARow] := s;
end;



function TAdvStringGrid.GetPrintColWidth(ACol: Integer): Integer;
begin
  Result := -1;
  if (ACol < MAXCOLUMNS) and (ACol >= 0) then
    Result := MaxWidths[ACol]
 else
    EAdvGridError.Create('Columns is not in valid range');
end;

function TAdvStringGrid.GetPrintColOffset(ACol: Integer): Integer;
begin
  Result := -1;
  if (ACol < MAXCOLUMNS) and (ACol >= 0) then
    Result := Indents[ACol]
  else
    EAdvGridError.Create('Columns is not in valid range');
end;

procedure TAdvStringGrid.SetLookupItems(Value: TStringList);
begin
  if Assigned(Value) then
    Flookupitems.Assign(Value);
end;

procedure TAdvStringGrid.FixedFontChanged(Sender:TObject);
begin
  Invalidate;
end;

procedure TAdvStringGrid.UndoColumnMerge;
var
  i: Integer;
begin
  for i := 1 to ColCount do
    SplitColumnCells(i - 1);
end;

procedure TAdvStringGrid.ApplyColumnMerge;
var
  i: Integer;
begin
  for i := 1 to MergedColumns.Count do
    MergeColumnCells(FMergedColumns.Items[i - 1],i=1);
end;    

procedure TAdvStringGrid.MergedColumnsChanged(Sender: TObject; ACol,ARow: Integer);
begin
  UndoColumnMerge;
  ApplyColumnMerge;
end;

procedure TAdvStringGrid.MultiImageChanged(Sender: TObject; ACol,ARow: Integer);
begin
  // force a cell update
  RepaintCell(ACol,ARow);
end;

procedure TAdvStringGrid.RichSelChange(Sender: TObject);
begin
  if Assigned(FOnRichEditSelectionChange) then
    FOnRichEditSelectionChange(Self);
end;

procedure TAdvStringGrid.SetFixedFont(Value:tFont);
begin
  FFixedFont.Assign(Value);
  Invalidate;
end;

procedure TAdvStringGrid.SetColumnHeaders(Value: TStringList);
begin
  FColumnHeaders.Assign(Value);
  if FixedRows > 0 then
    ClearColumnHeaders;
  ShowColumnHeaders;
end;

procedure TAdvStringGrid.ColHeaderChanged(Sender:TObject);
begin
  UpdateColHeaders;
  ShowColumnHeaders;
end;

procedure TAdvStringGrid.ClearColumnHeaders;
var
  i: Integer;
begin
  if ColCount > 0 then
    for i := 0 to ColCount - 1 do
      Cells[i,0] := '';
end;

procedure TAdvStringGrid.ShowColumnHeaders;
var
  I: Integer;
begin
  if FixedRows > 0 then
    for i := 0 to FColumnHeaders.Count - 1 do
      if i < ColCount then
        Cells[i,0] := CLFToLF(FColumnHeaders[i]);
end;

procedure TAdvStringGrid.SetRowHeaders(Value: TStringList);
begin
  FRowHeaders.Assign(Value);
  if (csDesigning in ComponentState) then
  begin
    if FixedCols > 0 then
      ClearRowHeaders;
  end;
  ShowRowHeaders;
end;

procedure TAdvStringGrid.RowHeaderChanged(Sender:tObject);
begin
  ShowRowHeaders;
end;

procedure TAdvStringGrid.ClearRowHeaders;
var
  i: Integer;
begin
  if RowCount > 0 then
    for i := 0 to RowCount - 1 do
      Cells[0,i] := '';
end;

procedure TAdvStringGrid.ShowRowHeaders;
var
  i: Integer;
begin
 if FixedCols > 0 then
   for i := 0 to FRowHeaders.Count - 1 do
     if i < RowCount then
       Cells[0,i] := CLFToLF(FRowHeaders[i]);
end;

procedure TAdvStringGrid.MarkCells(s,tag:string;DoCase: boolean; FromCol,FromRow,ToCol,ToRow: Integer);
var
  r,c: Integer;
begin
  for r := FromRow to ToRow do
    for c := FromCol to ToCol do
      Cells[c,r] := Hilight(Cells[c,r],s,tag,DoCase);
end;

procedure TAdvStringGrid.UnMarkCells(tag:string;FromCol,FromRow,ToCol,ToRow: Integer);
var
  r,c: Integer;
begin
  for r := FromRow to ToRow do
    for c := FromCol to ToCol do
      Cells[c,r] := UnHilight(Cells[c,r],tag);
end;

function TAdvStringGrid.HilightText(DoCase: Boolean; S,Text: string):string;
begin
  Result := Hilight(S,Text,'hi',DoCase);
end;

function TAdvStringGrid.UnHilightText(S: string):string;
begin
  Result := UnHilight(S,'hi');
end;

function TAdvStringGrid.MarkText(DoCase: Boolean; S,Text: string):string;
begin
  Result := Hilight(S,Text,'e',DoCase);
end;

function TAdvStringGrid.UnMarkText(S: string):string;
begin
  Result := UnHilight(S,'e');
end;

procedure TAdvStringGrid.HilightInCell(DoCase: Boolean; Col,Row: Integer; HiText: string);
begin
  MarkCells(HiText,'hi',DoCase,Col,Row,Col,Row);
end;

procedure TAdvStringGrid.HilightInCol(DoFixed,DoCase: Boolean; Col: Integer; HiText: string);
var
  rs,re: Integer;
begin
  if DoFixed then
  begin
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;
  MarkCells(HiText,'hi',DoCase,Col,rs,Col,re);
end;

procedure TAdvStringGrid.HilightInRow(DoFixed,DoCase: Boolean; Row: Integer; HiText: string);
var
  cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
  end;
  MarkCells(HiText,'hi',DoCase,cs,Row,ce,Row);
end;

procedure TAdvStringGrid.HilightInGrid(DoFixed,DoCase: Boolean; HiText: string);
var
  rs,re,cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;

  MarkCells(HiText,'hi',DoCase,cs,rs,ce,re);
end;

procedure TAdvStringGrid.UnHilightInCell(Col,Row: Integer);
begin
  UnMarkCells('hi',Col,Row,Col,Row);
end;

procedure TAdvStringGrid.UnHilightInCol(DoFixed: Boolean; Col: Integer);
var
  rs,re: Integer;
begin
  if DoFixed then
  begin
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;

  UnMarkCells('hi',Col,rs,Col,re);
end;

procedure TAdvStringGrid.UnHilightInRow(DoFixed: Boolean; Row: Integer);
var
  cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
  end;

  UnMarkCells('hi',cs,Row,ce,Row);
end;

procedure TAdvStringGrid.UnHilightInGrid(DoFixed: Boolean);
var
  rs,re,cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;

  UnMarkCells('hi',cs,rs,ce,re);
end;

procedure TAdvStringGrid.MarkInCell(DoCase: Boolean; Col,Row: Integer; HiText: string);
begin
  MarkCells(HiText,'e',DoCase,Col,Row,Col,Row);
end;

procedure TAdvStringGrid.MarkInCol(DoFixed,DoCase: Boolean; Col: Integer; HiText: string);
var
  rs,re: Integer;
begin
  if DoFixed then
  begin
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;
  MarkCells(HiText,'e',DoCase,Col,rs,Col,re);
end;

procedure TAdvStringGrid.MarkInRow(DoFixed,DoCase: Boolean; Row: Integer; HiText: string);
var
  cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
  end;
  MarkCells(HiText,'e',DoCase,cs,Row,ce,Row);
end;

procedure TAdvStringGrid.MarkInGrid(DoFixed,DoCase: Boolean; HiText: string);
var
  rs,re,cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;

  MarkCells(HiText,'e',DoCase,cs,rs,ce,re);
end;

procedure TAdvStringGrid.UnMarkInCell(Col,Row: Integer);
begin
  UnMarkCells('e',Col,Row,Col,Row);
end;

procedure TAdvStringGrid.UnMarkInCol(DoFixed: Boolean; Col: Integer);
var
  rs,re: Integer;
begin
  if DoFixed then
  begin
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;

  UnMarkCells('e',Col,rs,Col,re);
end;

procedure TAdvStringGrid.UnMarkInRow(DoFixed: Boolean; Row: Integer);
var
  cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
  end;

  UnMarkCells('e',cs,Row,ce,Row);
end;

procedure TAdvStringGrid.UnMarkInGrid(DoFixed: Boolean);
var
  rs,re,cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;

  UnMarkCells('e',cs,rs,ce,re);
end;

function TAdvStringGrid.CheckCells(FromCol,FromRow,ToCol,ToRow: Integer): Boolean;
var
  r,c: Integer;
  CurRow, CurCol: Integer;
begin
  Result := True;

  if not Assigned(FCellChecker) then
    Exit;

  FCellChecker.StartCheck;

  CurRow := Self.Row;
  CurCol := Self.Col;

  for r := FromRow to ToRow do
    for c := FromCol to ToCol do
      if not CheckCell(c,r) then Result := False;

  FCellChecker.StopCheck;

  if FCellChecker.GotoCell then
  begin
    Self.Row := CurRow;
    Self.Col := CurCol;
  end;
end;

function TAdvStringGrid.CheckCell(Col,Row: Integer): Boolean;
var
  NewValue,OrigValue: string;
begin
  Result := True;
  if not Assigned(CellChecker) then Exit;

  OrigValue := Cells[Col,Row];

  if CellChecker.GotoCell then
    MoveColRow(Col,Row,True,True);

  NewValue := OrigValue;

  if CellChecker.UseCorrect then
    NewValue := CellChecker.Correct(Col,Row,OrigValue);

  if CellChecker.UseMarkError then
    NewValue := CellChecker.MarkError(Col,Row,OrigValue);

  Cells[Col,Row] := NewValue;

  Result := NewValue = OrigValue;
end;

function TAdvStringGrid.CheckCol(DoFixed: Boolean; Col: Integer): Boolean;
var
  rs,re: Integer;
begin
  if DoFixed then
  begin
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;

  Result := CheckCells(Col,rs,Col,re);
end;

function TAdvStringGrid.CheckRow(DoFixed: Boolean; Row: Integer): Boolean;
var
  cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
  end;

  Result := CheckCells(cs,Row,ce,Row);
end;

function TAdvStringGrid.CheckGrid(DoFixed: Boolean): Boolean;
var
  rs,re,cs,ce: Integer;
begin
  if DoFixed then
  begin
    cs := 0;
    ce := ColCount - 1;
    rs := 0;
    re := RowCount - 1;
  end
  else
  begin
    cs := FixedCols;
    ce := ColCount - 1 - FFixedRightCols;
    rs := FixedRows;
    re := RowCount - 1 - FFixedFooters;
  end;

  Result := CheckCells(cs,rs,ce,re);
end;

procedure TAdvStringGrid.TextFill(DoFixed: Boolean; Txt : string);
var
  i,j: Integer;
  ro,co,re,ce: Integer;
begin
  if DoFixed then
  begin
    ro := 0;
    co := 0;
    re := RowCount - 1;
    ce := ColCount - 1;
  end
  else
  begin
    ro := FixedRows;
    co := FixedCols;
    re := RowCount - 1 - FFixedFooters;
    ce := ColCount - 1 - FFixedRightCols;
  end;

  for i := ro to re do
    for j := co to ce do
      Cells[j,i] := Txt;

  CellsLoaded;
end;

procedure TAdvStringGrid.RandomFill(DoFixed: Boolean;rnd: Integer);
var
  i,j: Integer;
  ro,co,re,ce: Integer;
begin
  if DoFixed then
  begin
    ro := 0;
    co := 0;
    re := RowCount - 1;
    ce := ColCount - 1;
  end
  else
  begin
    ro := FixedRows;
    co := FixedCols;
    re := RowCount - 1 - FFixedFooters;
    ce := ColCount - 1 - FFixedRightCols;
  end;

  for i := ro to re do
    for j := co to ce do
      Ints[j,i] := Random(rnd);

  CellsLoaded;
end;

procedure TAdvStringGrid.LinearFill(DoFixed: Boolean);
var
  i,j: Integer;
  ro,co,re,ce: Integer;
begin
  if DoFixed then
  begin
    ro := 0;
    co := 0;
    re := RowCount - 1;
    ce := ColCount - 1;
  end
  else
  begin
    ro := FixedRows;
    co := FixedCols;
    re := RowCount - 1 - FFixedFooters;
    ce := ColCount - 1 - FFixedRightCols;
  end;

  for i := ro to re do
    for j := co to ce do
      Cells[j,i] := IntToStr(j)+':'+IntToStr(i);

  CellsLoaded;
end;


procedure TAdvStringGrid.SetDates(ACol,ARow: Integer;const Value:TDateTime);
begin
  if (Value > 0) or ShowNullDates then
    Cells[ACol,ARow] := DateToStr(Value)
  else
    Cells[ACol,ARow] := '';
end;

function TAdvStringGrid.GetDates(ACol,ARow: Integer):TDateTime;
begin
  GetDates := StrToDate(Cells[ACol,ARow]);
end;

procedure TAdvStringGrid.SetTimes(ACol,ARow: Integer;const Value:TDateTime);
begin
  Cells[ACol,ARow] := TimeToStr(Value);
end;

function TAdvStringGrid.GetTimes(ACol,ARow: Integer):TDateTime;
begin
  GetTimes := StrToTime(Cells[ACol,ARow]);
end;

function TAdvStringGrid.GetRowSelect(ARow: Integer): Boolean;
var
  i,j: Integer;

begin
 if (ARow >= RowCount) or (ARow<0) then
   raise EAdvGridError.Create('Invalid row accessed');

  i := FRowSelect.Count;

  if i < ARow + 1 then
  begin
    FRowSelect.Count := ARow + 1;
    for j := i to FRowSelect.Count - 1 do
      FRowSelect.Items[j] := nil;
  end;
  GetRowSelect := (FRowSelect.Items[ARow] <> nil);
end;

function TAdvStringGrid.GetColSelect(ACol: Integer): Boolean;
var
  i,j: Integer;

begin
 if (ACol >= ColCount) or (ACol<0) then
   raise EAdvGridError.Create('Invalid column accessed');

  i := FColSelect.Count;

  if i < ACol + 1 then
  begin
    FColSelect.Count := ACol + 1;
    for j := i to FColSelect.Count - 1 do
      FColSelect.Items[j] := nil;
  end;
  GetColSelect := (FColSelect.Items[ACol] <> nil);
end;

procedure TAdvStringGrid.RepaintRect(r:TRect);
var
  r1,r2,ur:TRect;
begin
  if (r.Left < 0) or (r.Right < 0) or (r.Top < 0) or (r.Bottom < 0) then
    Exit;
  r1 := CellRect(r.Left,r.Top);
  r2 := CellRect(r.Right,r.Bottom);
  UnionRect(ur,r1,r2);
  if IsRectEmpty(r1) or IsRectEmpty(r2) then
    Repaint
  else
    InvalidateRect(Handle,@ur,True);
end;

procedure TAdvStringGrid.RepaintCell(c,r: Integer);
var
  rc: TRect;
begin
  rc := CellRect(c,r);
  InvalidateRect(Handle,@rc,True);
end;

procedure TAdvStringGrid.RepaintRow(ARow: Integer);
begin
  InvalidateRow(ARow);
end;

procedure TAdvStringGrid.RepaintCol(ACol: Integer);
begin
  InvalidateCol(ACol);
end;

procedure TAdvStringGrid.SelectRows(RowIndex, RCount: Integer);
var
  gr: TGridRect;
  i: Integer;
begin
  if FMouseActions.DisjunctRowSelect then
  begin
    for i := RowIndex to RowIndex + RCount - 1 do
      if i < RowCount then
        RowSelect[i] := True;
  end
  else
  begin
    gr.Left := FixedCols;
    gr.Right := ColCount - 1;
    gr.Top := Rowindex;
    gr.Bottom := Rowindex + rcount - 1;
    Selection := gr;
  end;
end;

procedure TAdvStringGrid.SelectCols(ColIndex, CCount: Integer);
var
  gr: TGridRect;
  i: Integer;
begin
  if FMouseActions.DisjunctColSelect then
  begin
    for i := ColIndex to ColIndex + CCount - 1 do
      if i < ColCount then
        ColSelect[i] := True;
  end
  else
  begin
    gr.Left := ColIndex;
    gr.Right := ColIndex+CCount - 1;
    gr.Top := FixedRows;
    gr.Bottom := RowCount-1;
    Selection := gr;
  end;
end;

procedure TAdvStringGrid.SelectRange(FromCol,ToCol,FromRow,ToRow: Integer);
var
  gr: TGridRect;
begin
  // changed in v2.3.0.6
  Row := ToRow;
  Col := ToCol;
  gr.Left := FromCol;
  gr.Right := ToCol;
  gr.Top := FromRow;
  gr.Bottom := ToRow;
  Selection := gr;
end;

procedure TAdvStringGrid.ClearRowSelect;
var
  i: Integer;
begin
  if FRowSelect.Count <= 0 then
    Exit;

  for i := 0 to FRowSelect.Count - 1 do
  begin
    if FRowSelect.Items[i] <> nil then
      RepaintRow(i);
    FRowSelect.Items[i] := nil;
  end;
end;

procedure TAdvStringGrid.ClearColSelect;
var
  i: Integer;
begin
  if FColSelect.Count <= 0 then
    Exit;

  for i := 0 to FColSelect.Count - 1 do
  begin
    if FColSelect.Items[i] <> nil then
      RepaintCol(i);
    FColSelect.Items[i] := nil;
  end;
end;


procedure TAdvStringGrid.SelectToRowSelect(IsShift: Boolean);
var
  i: Integer;
begin
  for i := FixedRows to RowCount - 1 do
  begin
    if IsShift or
       ((i >= Selection.Top) and (i <= Selection.Bottom)) then
      RowSelect[i] := (i >= Selection.Top) and (i <= Selection.Bottom);
  end;
end;

procedure TAdvStringGrid.SelectToColSelect(IsShift: Boolean);
var
  i: Integer;
begin
  for i := FixedCols to ColCount - 1 do
  begin
    if IsShift or
       ((i >= Selection.Left) and (i <= Selection.Right)) then
      ColSelect[i] := (i >= Selection.Left) and (i <= Selection.Right);
  end;
end;


function TAdvStringGrid.GetRowSelectCount: Integer;
var
  Res,i: Integer;
begin
  Res := 0;
  for i := 1 to FRowSelect.Count do
    if FRowSelect.Items[i-1] <> nil then Inc(Res);
  Result := Res;
end;

function TAdvStringGrid.GetColSelectCount: Integer;
var
  Res,i: Integer;
begin
  Res := 0;
  for i := 1 to FColSelect.Count do
    if FColSelect.Items[i-1] <> nil then Inc(Res);
  Result := Res;
end;

procedure TAdvStringGrid.SetRowSelect(ARow: Integer;Value: Boolean);
var
  i,j: Integer;
begin
  if (ARow >= RowCount) or (ARow < 0) then
    raise EAdvGridError.Create('Invalid row accessed');

  i := FRowSelect.Count;
  if i < ARow + 1 then
  begin
    FRowSelect.Count := ARow + 1;
    for j := i to FRowSelect.Count - 1 do
      FRowSelect.Items[j] := nil;
  end;

  if Value then
  begin
    if FRowSelect.Items[ARow] <> Pointer(1) then
      RepaintRow(ARow);
    FRowSelect.Items[ARow] := Pointer(1);
  end
  else
  begin
    if FRowSelect.Items[ARow] <> nil then
      RepaintRow(ARow);
    FRowSelect.Items[ARow] := nil;
  end;
end;

procedure TAdvStringGrid.SetColSelect(ACol: Integer;Value: Boolean);
var
  i,j: Integer;
begin
  if (ACol >= ColCount) or (ACol < 0) then
    raise EAdvGridError.Create('Invalid column accessed');

  i := FColSelect.Count;
  if i < ACol + 1 then
  begin
    FColSelect.Count := ACol + 1;
    for j := i to FColSelect.Count - 1 do
      FColSelect.Items[j] := nil;
  end;

  if Value then
  begin
    if FColSelect.Items[ACol] <> Pointer(1) then
      RepaintCol(ACol);
    FColSelect.Items[ACol] := Pointer(1);
  end
  else
  begin
    if FColSelect.Items[ACol] <> nil then
      RepaintCol(ACol);
    FColSelect.Items[ACol] := nil;
  end;
end;


function TAdvStringGrid.GetInplaceEditor:TAdvInplaceEdit;
begin
  Result := TAdvInplaceEdit(InplaceEditor);
end;

procedure TAdvStringGrid.AdvanceEdit(ACol,ARow: Integer;advance,show,frwrd: Boolean);
var
  OldCol,OldRow, rm: Integer;
  AllowAdd,CanChange: Boolean;
  Span: TPoint;

begin
  if (not FNavigation.AdvanceOnEnter) and (not Advance) then Exit;

  if MouseActions.RangeSelectAndEdit then
    if not (goEditing in Options) then
      Options := Options + [goEditing];

//  Span := BaseCell(ACol,ARow);
//  ACol := Span.X;
//  ARow := Span.Y;

  OldCol := ACol;
  OldRow := ARow;
  FStartEditChar := #0;

  Span := CellSpan(ACol,ARow);

  if Frwrd then
  begin
    if FNavigation.AdvanceDirection = adLeftRight then
    begin
      if ACol + Span.X = ColCount - 1 - FFixedRightCols then
      begin
        if ARow = RowCount - 1 - FFixedFooters then
        begin
          if FNavigation.AdvanceInsert then {automatic ARowinsert}
          begin
            AllowAdd := True;
            if Assigned(FOnCanAddRow) then
              FOnCanAddRow(self, AllowAdd);
            if AllowAdd then
            begin
              AddRow;
              ARow := ARow + 1;
              ACol := FixedCols;
              if Assigned(FOnAutoAddRow) then
                FOnAutoAddRow(Self,RowCount - 1 - FFixedFooters);
            end;
          end
          else {skip back to first cell}
          begin
            ARow := FixedRows;
            ACol := FixedCols;
          end;
        end
        else
        begin
          ACol := FixedCols;
          ARow := ARow + 1;
        end;
      end
      else
      begin
        ACol := ACol + 1 + Span.X;
      end;
    end;

    if FNavigation.AdvanceDirection = adTopBottom then
    begin
      if ARow = RowCount - 1 - FFixedFooters then
      begin
        if ACol = ColCount - 1 - FFixedRightCols then
        begin
          if FNavigation.AdvanceInsert then
          begin
            ColCount := ColCount + 1;
            ACol := ACol + 1 + Span.X;
            ARow := FixedRows;
            if Assigned(FOnAutoInsertCol) then
              FOnAutoInsertCol(Self,ColCount - 1 - FFixedRightCols);
          end
          else
          begin
            ARow := FixedRows;
            ACol := FixedCols;
          end;
        end
        else
        begin
          ARow := FixedRows;
          ACol := ACol + 1 + Span.X;
          if ACol >= ColCount then
            ACol := FixedCols;
        end;
        Repaint;
      end
      else
      begin
        ARow := ARow + 1;
      end;
    end;
  end
 //Handle backward case
  else
  begin
    if FNavigation.AdvanceDirection = adLeftRight then
    begin
      if ACol > FixedCols then
        ACol := ACol - 1
      else
        if ARow > FixedRows then
        begin
          ARow := ARow - 1;
          ACol := ColCount - 1 - FFixedRightCols;
        end
        else
        begin
          ARow := RowCount - 1 - FFixedFooters;
          ACol := ColCount - 1 - FFixedRightCols;
        end;
    end;

    if FNavigation.AdvanceDirection = adTopBottom then
    begin
      if ARow > FixedRows then
        ARow := ARow - 1
      else
        if ACol > FixedCols then
        begin
          ACol := ACol - 1;
          ARow := RowCount - 1 - FFixedFooters;
        end
        else
        begin
          ACol := ColCount - 1 - FFixedRightCols;
          ARow := RowCount - 1 - FFixedFooters;
        end;
    end;
  end;

  rm := RemapCol(ACol);

  if not IsEditable(rm,ARow) then
    AdvanceEdit(ACol,ARow,Advance,Show,Frwrd)
  else
  begin
    CanChange := True;
    if Assigned(FOnCellChanging) then
      FOnCellChanging(Self,OldRow,OldCol,ARow,ACol,CanChange);

    FDisableChange := True;

    if CanChange then
    begin
      Col := ACol;
      Row := ARow;
    end
    else
      SelectCell(OldCol,OldRow);

    FDisableChange := False;
  end;

  if Show or HasStaticEdit(rm,ARow) then
  begin
    if not IsEditable(rm,ARow) then
      Exit;

    ShowEditor;

    if HasStaticEdit(rm,ARow) then
    begin
      FDisableChange := True;

      Col := OldCol;
      Row := OldRow;

      Col := ACol;
      Row := ARow;

      span.X := CellRect(ACol,ARow).Left + 2;
      span.Y := CellRect(ACol,ARow).Top + 2;
      if not HasStaticEdit(OldCol,OldRow) then
      begin
        MouseDown(mbLeft,[],span.X,span.Y);

        // begin added in v2.3.0.6
        MouseUp(mbLeft,[],span.X,span.Y);
        // end added in v2.3.0.6

        if Navigation.AdvanceDirection <> adLeftRight then
          HideEditor;
      end;

      FDisableChange := False;

      if Assigned(FOnCellChanging) then
        FOnCellChanging(Self,OldRow,OldCol,Row,Col,CanChange);

      // Remove, issue with AdvanceOnEnter
      // HideEditor;
    end;
  end;
end;

procedure TAdvStringGrid.KeyPress(var Key:Char);
var
  p: Integer;
  RCol: Integer;
begin
  if Key = #27 then
  begin
    if (goEditing in Options) and FEditing then
      RestoreCache;
    Exit;
  end;

  RCol := RealCol;

  if (Key = #13) and ((GetFocus <> Handle) or HasStaticEdit(RCol,Row)) then
  begin
    AdvanceEdit(Col,Row,False,False,True);
    if HasStaticEdit(RCol,Row) then
      Exit;
  end;

  if not (goEditing in Options) and
     FNavigation.AutoGotoWhenSorted then
  begin
    if FNavigation.AutoGotoIncremental then
    begin
      if Key = #8 then
        Delete(searchinc,Length(searchinc),1)
      else
        SearchInc := SearchInc + Key;
    end
    else
      SearchInc := Key;

    p := Search(AnsiUpperCase(SearchInc));
    if p <> -1 then
    begin
      Row:=p;
    end;
  end;

  inherited Keypress(Key);
end;

procedure TAdvStringGrid.SetFixedFooters(Value: Integer);
begin
  FFixedFooters := Value;
  Invalidate;
end;


function TAdvStringGrid.GetDefRowHeightEx: Integer;
begin
  Result := inherited DefaultRowHeight;
end;

procedure TAdvStringGrid.SetDefRowHeightEx(const Value: Integer);
begin
  inherited DefaultRowHeight := Value;

  if (csDesigning in ComponentState) then
    FFixedRowHeight := Value;

  FFloatingFooter.FHeight := Value;
  if FFloatingFooter.Visible then
  begin
    FFooterPanel.Height := Value;
  end;
end;


procedure TAdvStringGrid.SetRowCountEx(Value: Integer);
begin
  if (RowCount = FixedRows) and (FixedRowAlways) then
    UnHideSelection;

  inherited RowCount := Value;
  if (RowCount > 1) and FixedRowAlways then
    FixedRows := 1;

  NormalRowCount := Value;
  UpdateFooter;
end;

function TAdvStringGrid.GetRowCountEx: Integer;
begin
  Result := inherited RowCount;
end;

procedure TAdvStringGrid.SetColCountEx(Value: Integer);
begin
  inherited ColCount := Value;
  if (ColCount > 1) and FixedColAlways then
    FixedCols := 1;
  UpdateFooter;
  SetBounds(Left,Top,Width,Height);
end;

function TAdvStringGrid.GetColCountEx: Integer;
begin
  Result := inherited ColCount;
end;

procedure TAdvStringGrid.SetFixedRowsEx(Value: Integer);
begin
  inherited FixedRows := Value;
end;

function TAdvStringGrid.GetFixedRowsEx: Integer;
begin
  Result := inherited FixedRows;
  if (Result = 0) and FixedRowAlways then Result := 1;
end;

procedure TAdvStringGrid.SetFixedColsEx(Value: Integer);
begin
  inherited FixedCols := Value;
end;

function TAdvStringGrid.GetFixedColsEx: Integer;
begin
  Result := inherited FixedCols;
  if (Result=0) and FixedColAlways then
    Result := 1;
end;

procedure TAdvStringGrid.SetFixedColWidth(Value: Integer);
var
  i: Integer;
begin
  if (csDesigning in ComponentState) then
    if Value <> DefaultColWidth then
      for i := 1 to FixedCols do
        ColWidths[i - 1] := Value;
end;

function TAdvStringGrid.GetFixedColWidth: Integer;
begin
  Result := ColWidths[0];
end;

procedure TAdvStringGrid.SetFixedRowHeight(Value: Integer);
var
  i: Integer;
begin
  FFixedRowHeight := Value;
  if (csDesigning in ComponentState) then
    if (Value <> DefaultRowHeight) then
    begin
       for i := 1 to FixedRows do
         RowHeights[i - 1] := Value;
    end
    else
      DefaultRowHeight := Value;
end;

function TAdvStringGrid.GetFixedRowHeight: Integer;
begin
  Result := FFixedRowHeight;
end;

procedure TAdvStringGrid.SetFixedRightCols(Value: Integer);
begin
  FFixedRightCols := Value;
  Invalidate;
end;

procedure TAdvStringGrid.SetWordWrap(Value: Boolean);
begin
  FWordWrap := Value;
  if InplaceEditor <> nil then
  begin
    TAdvInplaceEdit(self.Inplaceeditor).WordWrap := Value;
  end;
  if FUpdateCount = 0 then
    Invalidate;
end;

function TAdvStringGrid.MatchFilter(ARow: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to FFilter.count do
  begin
    with FFilter.Items[i - 1] do
    if not MatchStrEx(Condition,Cells[Column,ARow],CaseSensitive) then
    begin
      Result := False;
      Break;
    end;
  end;
end;

procedure TAdvStringGrid.FilterRow(ARow: Integer);
begin
  if not MatchFilter(ARow) then
  begin
    HideRow(RemapRowInv(ARow));
  end;
end;

procedure TAdvStringGrid.ApplyFilter;
var
  i,j: Integer;
  hs,he: Integer;
  RowsToDo,RowsDone: Integer;

begin
  i := FixedRows;
  j := 0;
  hs := -1;
  he := -1;

  RowsDone := 0;
  RowsTodo := RowCount - FFixedFooters - FixedRows;

  while i < RowCount - FFixedFooters do
  begin
    if not MatchFilter(i) then
    begin
      if hs = -1 then
      begin
        j := i;
        hs := RemapRowInv(i);
        he := hs;
      end
      else
      begin
        Inc(he);
      end;
      Inc(i);
    end
    else
    begin
      if hs <> -1 then
      begin
        HideRows(hs,he);
        hs := -1;
        he := -1;
        i := j;
      end;
      Inc(i);
    end;

    Inc(RowsDone);

    if Assigned(FOnFilterProgress) then
      FOnFilterProgress(Self, Round(100* (RowsDone / RowsTodo)));
  end;

  if hs <> -1 then
  begin
    HideRows(hs,he);
  end;

  if Assigned(FOnFilterProgress) then
    FOnFilterProgress(Self, Round(100* (RowsDone / RowsTodo)));
end;

procedure TAdvStringGrid.SetFilterActive(const Value: Boolean);
begin
  if FFilterActive <> Value then
  begin
    FFilterActive := Value;
    if FFilterActive then
    begin
      FFilterFixedRows := FixedRows;
      BeginUpdate;
      ApplyFilter;
      EndUpdate;
      if (RowCount = FixedFooters + FFilterFixedRows) and not FixedRowAlways then
      begin
        RowCount := FixedFooters + FFilterFixedRows + 1;
        FixedRows := FFilterFixedRows;
      end
      else
        FFilterFixedRows := 0;
    end
    else
    begin
      if (RowCount = FixedRows + FixedFooters + 1) and (FFilterFixedRows > 0) then
      begin
        FFilterFixedRows := FixedRows;
        RowCount := RowCount - 1;
      end
      else
        FFilterFixedRows := FixedRows;
      UnHideRowsAll;
      FixedRows := FFilterFixedRows;
    end;
  end;
end;

procedure TAdvStringGrid.SetSelectionColor(AColor: TColor);
begin
  FSelectionColor := AColor;
  Invalidate;
end;

procedure TAdvStringGrid.SetSelectionTextColor(AColor: TColor);
begin
  FSelectionTextColor := AColor;
  Invalidate;
end;

procedure TAdvStringGrid.SetSelectionRectangle(AValue: Boolean);
begin
  FSelectionRectangle := AValue;
  Invalidate;
end;

procedure TAdvStringGrid.SetSelectionResizer(const Value: Boolean);
begin
  FSelectionResizer := Value;
  Invalidate;  
end;


procedure TAdvStringGrid.SetMaxEditLength(const AValue: Integer);
begin
  FMaxEditLength := AValue;
  if Assigned(NormalEdit) then
    NormalEdit.LengthLimit := AValue;
end;

procedure TAdvStringGrid.SetShowSelection(AValue: Boolean);
begin
  if FShowSelection <> AValue then
  begin
    FShowSelection := AValue;
    Invalidate;
  end;
end;

procedure TAdvStringGrid.SetVAlignment(AVAlignment:TVAlignment);
begin
  FVAlignment := AVAlignment;
  FVAlign := DT_VCENTER;
  case FVAlignment of
  vtaTop:FVAlign := DT_TOP;
  vtaBottom:FVAlign := DT_BOTTOM;
  end;
  if FUpdateCount = 0 then
    Invalidate;
end;


procedure TAdvStringGrid.SetAutoSizeP(AAutoSize: Boolean);
begin
  FAutoSize := AAutoSize;
  if FAutosize then
    AutoSizeColumns(False,10)
end;

procedure TAdvStringGrid.SetFlat(const AValue: Boolean);
begin
  FFlat := AValue;
  if not (csLoading in ComponentState) then
    Invalidate;
end;

function TAdvStringGrid.GetCellAlignment(ACol,ARow: Integer): TCellAlignment;
var
  HAlign: TAlignment;
  VAlign: TVAlignment;
  s: string;
begin
  HAlign := taLeftJustify;
  VAlign := VAlignment;

  if FAutoNumAlign then
  begin
    s := Cells[ACol,ARow];
    if Pos('=',s) = 1 then
      s := CalcCell(ACol,ARow);

    if IsType(s) in [atNumeric,atFloat] then
      HAlign := taRightJustify;
  end;

  if HasCellProperties(ACol,ARow) then
    HAlign := CellProperties[ACol,ARow].Alignment;

  GetCellAlign(ACol,ARow,HAlign,VAlign);

  Result.Alignment := HAlign;
  Result.VAlignment := VAlign;
end;

function TAdvStringGrid.GetCellTextSize(ACol,ARow: Integer;VS: Boolean): TSize;
var
  s,su,Anchor,Stripped,FocusAnchor: string;
  MaxSize,NewSize,NumLines,hl,ml: Integer;
  r,hr,cr: TRect;
  ctt: TTextType;
  AState: TGridDrawState;
  HAlign: TAlignment;
  VAlign: TVAlignment;
  WW: Boolean;
  CID,CT,CV: string;
  AAngle: Integer;
  x1,x2,y1,y2: Integer;
  th: Integer;
  {$IFDEF TMSUNICODE}
  ws: widestring;
  {$ENDIF}

begin
  MaxSize := 0;
  NumLines := 0;

  s := Cells[ACol,ARow];

  ctt := TextType(s,FEnableHTML);

  AState := [];

  GetVisualProperties(ACol,ARow,AState,False,True,True,Canvas.Brush,Canvas.Font,HAlign,VAlign,WW);

  if ctt = ttFormula then
    s := CalcCell(ACol,ARow);

  if ctt = ttHTML then
  begin
    FillChar(r,SizeOf(r),0);
    if VS then
      r.Right := ColWidths[ACol] - 4
    else
      r.Right := $ffff;

    r.Bottom := $ffff;
    HTMLDrawEx(Canvas,s,r,Gridimages,0,0,-1,0,1,False,True,False,True,True,False,not EnhTextSize,false,
               0.0,FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,
               Integer(Result.cx),Integer(Result.cy),hl,ml,hr,cr,CID,CT,CV,FImageCache,FContainer,Handle);

    Result.cx := Result.cx + 2 + FXYOffset.X * 2;
    Result.cy := Result.cy + 2 + FXYOffset.Y * 2;
    Exit;
  end;

  if ctt = ttRTF then
  begin
    CellToRich(ACol,ARow,FRichEdit);
    Canvas.Font.Name := FRichEdit.SelAttributes.Name;
    Canvas.Font.Size := FRichEdit.SelAttributes.Size;
    Canvas.Font.Style := FRichEdit.SelAttributes.Style;
    s := FRichEdit.Text;
  end;

  {$IFDEF TMSUNICODE}
  if ctt = ttUnicode then
  begin
    ws := WideCells[ACol,ARow];
    {
    GetTextExtentPoint32W(Canvas.Handle,PWidechar(ws),Length(ws),sz);
    Result.cy := sz.cy;
    Result.cx := sz.cx + 2 * FXYOffset.X;
    }
    if WordWrap or MultiLineCells then
      Result.cy := DrawTextExW(Canvas.Handle,PWidechar(ws),Length(ws),r,DT_LEFT or DT_WORDBREAK or DT_NOPREFIX or DT_CALCRECT,nil)
    else
      Result.cy := DrawTextExW(Canvas.Handle,PWidechar(ws),Length(ws),r,DT_LEFT or DT_SINGLELINE or DT_NOPREFIX or DT_CALCRECT,nil);

    Result.cx := (r.Right - r.Left) + 2 * FXYOffset.X;
    Exit;
  end;
  {$ENDIF}

  if VS then
  begin
    r := CellRect(ACol,ARow);

    InflateRect(r,-2 - FXYOffset.X, -2 - FXYOffset.Y);

    // if editing cell and return pressed, calculate height assuming new line
    if EditMode and (RemapColInv(ACol) = Col) and (ARow = Row) and (length(s)>0) then
    begin
      if s[length(s)] = #10 then
        s := s + 'w';
    end;

    Result.cy := DrawTextEx(Canvas.Handle,PChar(s),Length(s),r,DT_EDITCONTROL or DT_CALCRECT or DT_WORDBREAK or DT_LEFT or DT_NOPREFIX,nil) + 2 * FXYOffset.Y;
    Result.cx := (r.Right - r.Left) + 2 * FXYOffset.X;
  end
  else
  begin
    repeat
      su := GetNextLine(s,FMultiLineCells);

      if URLShow and not URLFull and (ctt = ttText) then
        StripURLProtoCol(su);

      NewSize := Canvas.TextWidth(su) + 2 * FXYOffset.X;
      if NewSize > MaxSize then
        MaxSize := NewSize;
      Inc(NumLines);
    until s = '';

    Result.cx := MaxSize;
    th := Canvas.TextHeight('gh');
    Result.cy := NumLines * th + 2 * FXYOffset.Y;
  end;

  if IsRotated(ACol,ARow,AAngle) then
  begin
    x1 := Abs(Trunc(Result.cx * cos(AAngle*Pi/180)));
    x2 := Abs(Trunc(Result.cy * sin(AAngle*Pi/180)));

    y1 := Abs(Trunc(Result.cx * sin(AAngle*Pi/180)));
    y2 := Abs(Trunc(Result.cy * cos(AAngle*Pi/180)));

    // distance + correction for font corners
    Result.cx := Abs(x2 - x1) + 12;
    Result.cy := Abs(y2 - y1) + 12;
  end;

  if ctt = ttRTF then
  begin
    // force control recreation.
    // Is necessary to force correct recalculation somehow for TRichEdit
    FRichEdit.Width := MaxSize;
    FRichEdit.Height := 2;
    FRichEdit.WordWrap := True;
    FRichEdit.WordWrap := False;
    SetTranspWindow(FRichEdit.Handle);
    // We need to force a proper REQUESTRESIZE.
    // Direct message EM_RESIZEREQUEST does not work on Win2K!
    FRichEdit.Lines.Add('');

    // v2.3.0.8 don't do this anymore for more accurate sizing
    // FRichEdit.Lines.Delete(FRichEdit.Lines.Count-1);

    Result.cx := FRichEdit.ReqWidth;
    Result.cy := FRichEdit.ReqHeight;
  end;
end;

procedure TAdvStringGrid.NCPaintProc;
var
  DC: HDC;
  WindowBrush:hBrush;
  Canvas: TCanvas;

begin
  if not (Look in [glSoft,glTMS]) then
    Exit;

  if BorderStyle = bsNone then
    Exit;
  if Flat then
    Exit;

  DC := GetWindowDC(Handle);
  WindowBrush := 0;
  try
    Canvas := TCanvas.Create;
    Canvas.Handle := DC;

    WindowBrush := CreateSolidBrush(ColorToRGB(clRed));

    Canvas.Pen.Color := clGray;

    Canvas.MoveTo(1,Height);
    Canvas.LineTo(1,1);
    Canvas.LineTo(Width - 2,1);
    Canvas.LineTo(Width - 2,Height - 2);
    Canvas.LineTo(1,Height - 2);

    if (Parent is TWinControl) then
    begin
      Canvas.Pen.Color := (Parent as TWinControl).Brush.Color;
      Canvas.MoveTo(0,Height);
      Canvas.LineTo(0,0);
      Canvas.LineTo(Width - 1,0);
      Canvas.LineTo(Width - 1,Height - 1);
      Canvas.LineTo(0,Height-1);
    end;

    Canvas.Free;

    // FrameRect(DC, ARect, WindowBrush);
  finally
    DeleteObject(WindowBrush);
    ReleaseDC(Handle,DC);
  end;
end;

procedure TAdvStringGrid.WMNCPaint(var Message: TMessage);
begin
  inherited;
  if FUpdateCount > 0 then Exit;
  NCPaintProc;
  Message.Result := 0;
end;

procedure TAdvStringGrid.Paint;
var
  R: TRect;

begin
  Canvas.Pen.Style := psSolid;

  inherited Paint;

  if FEditing then
  begin
    if GridLineWidth > 0 then
      Canvas.Pen.Color := GridLineColor
    else
      Canvas.Pen.Color := Color;

    r := CellRect(Col,Row);
    if not (goHorzLine in Options) and not (goVertLine in Options) then
      Canvas.Pen.Color := Color;

    Canvas.Rectangle(r.Left,r.Top,r.Right,r.Bottom);
  end;

  Canvas.Pen.Color := clBlack;
end;

procedure TAdvStringGrid.DrawSizingLine(X: Integer);
var
  OldPen: TPen;
  R: TRect;
begin
  OldPen := TPen.Create;
  with Canvas do
  begin
    OldPen.Assign(Pen);
    Pen.Color := clBlack;
    Pen.Style := psDot;
    Pen.Mode := pmXor;
    Pen.Width := 1;

    MoveTo(X, 0);

    R := CellRect(0,RowCount - 1);

    LineTo(X, Max(Height,R.Bottom));

    Pen := OldPen;
  end;
  OldPen.Free;
end;


procedure TAdvStringGrid.RTFPaint(ACol,ARow: Integer;Canvas:TCanvas;ARect:TRect);
type
  rFormatRange = record
    hdc: HDC;
    hdcTarget: HDC;
    rc: TRect;
    rcPage: TRect;
    chrg: TCharRange;
  end;

var
  fr:rFORMATRANGE;
  nLogPixelsX,nLogPixelsY: Integer;
  mm: Integer;
  pt: TPoint;
  FocusCell: Boolean;
  RtfOffsetX,RtfOffsetY: Integer;

begin

  CellToRich(ACol,ARow,FRichEdit);

  FRichEdit.Brush.Style := bsClear;

  FocusCell := (ARow = Row) and (ACol = Col) and
               (GetFocus = Handle) and not (goDrawFocusSelected in Options);

  if (((ACol >= Selection.Left) and (ACol <= Selection.Right) and
     (ARow >= Selection.Top) and (ARow <= Selection.Bottom)) and not FocusCell
      and not MouseActions.DisjunctRowSelect ) or
     (MouseActions.DisjunctRowSelect and RowSelect[ARow]) or
     (MouseActions.DisjunctColSelect and ColSelect[ACol]) then
  begin
    if (not FSelectionRTFKeep) and (GetMapMode(Canvas.Handle) = MM_TEXT) then
    begin
      FRichEdit.SelStart := 0;
      FRichEdit.SelLength := $FFFF;
      FRichEdit.SelAttributes.Color := FSelectionTextColor;
    end;
  end;

  FillChar(fr, SizeOf(TFormatRange), 0);

  lptodp(Canvas.Handle,ARect.Topleft,1);
  lptodp(Canvas.Handle,ARect.Bottomright,1);

  nLogPixelsX := GetDeviceCaps(Canvas.Handle,LOGPIXELSX);
  nLogPixelsY := GetDeviceCaps(Canvas.Handle,LOGPIXELSY);

  pt.x := XYOffset.X;
  pt.y := XYOffset.Y;
  dptolp(Canvas.Handle,pt,1);

  RtfOffsetX := ((pt.x * nLogPixelsX) div 96);
  RtfOffsetY := ((pt.x * nLogPixelsX) div 96);

  with fr do
  begin
    fr.hdc := Canvas.Handle;
    fr.hdctarget := Canvas.Handle;
    {convert to twips}
    fr.rcPage.Left := Round(((ARect.Left + RtfOffsetX)/nLogPixelsX) * RTF_TWIPS);
    fr.rcPage.Top := Round(((ARect.Top + RtfOffsetY)/nLogPixelsY) * RTF_TWIPS);
    fr.rcPage.Right := fr.rcPage.Left + Round(((ARect.Right - ARect.Left - 2*RtfOffsetX)/nLogPixelsX) * RTF_TWIPS);
    fr.rcPage.Bottom := (fr.rcPage.Top + Round(((ARect.Bottom - ARect.Top - 2*RtfOffsetY)/nLogPixelsY) * RTF_TWIPS));
    fr.rc.Left := fr.rcPage.Left;  { 1440 TWIPS = 1 inch. }
    fr.rc.Top := fr.rcPage.Top;
    fr.rc.Right := fr.rcPage.Right;
    fr.rc.Bottom := fr.rcPage.Bottom;
    fr.chrg.cpMin := 0;
    fr.chrg.cpMax := -1;
  end;

  mm := GetMapMode(Canvas.Handle);
  SetMapMode(Canvas.Handle,mm_text);

  SendMessage(FRichEdit.Handle,EM_FORMATRANGE,1,Integer(@fr));

  {clear the richtext cache}
  SendMessage(FRichEdit.Handle,EM_FORMATRANGE,0,0);

  SetMapMode(Canvas.Handle,mm);
end;

procedure TAdvStringGrid.EditProgress(Value: string; pt: TPoint; SelPos: Integer);
begin

end;

procedure TAdvStringGrid.DoInsertRow(ARow: Integer);
begin
  InsertRows(ARow,1);
  if Assigned(FOnAutoInsertRow) then
    FOnAutoInsertRow(self,ARow);
end;

procedure TAdvStringGrid.DoDeleteRow(ARow: Integer);
begin
  if (RowCount - FixedRows - FixedFooters = 1) and not FixedRowAlways then
    ClearRows(ARow,1)
  else
    RemoveRows(ARow,1);

  if Assigned(FOnAutoDeleteRow) then
    FOnAutoDeleteRow(self,ARow);
end;


function TAdvStringGrid.CalcCell(ACol,ARow: Integer): string;
begin
  Result := Cells[ACol,ARow];
end;

procedure TAdvStringGrid.LoadCell(ACol,ARow: Integer; Value: string);
begin
  GridCells[ACol,ARow] := Value;
end;

function TAdvStringGrid.SaveCell(ACol,ARow: Integer): string;
var
  State: Boolean;
begin
  if FSaveVirtCells then
    Result := Cells[ACol,ARow]
  else
    Result := GridCells[ACol,ARow];

  if (Result = '') and (CellTypes[ACol,ARow] = ctCheckBox) then
  begin
    GetCheckBoxState(ACol,ARow,State);
    if State then
      Result := GetCheckTrue(ACol,ARow)
    else
      Result := GetCheckFalse(ACol,ARow);
  end;
  if not  FSaveWithHTML then
    Result := HTMLStrip(Result);
end;


procedure TAdvStringGrid.DrawSortIndicator(Canvas:TCanvas;Col,x,y: Integer);
var
  left,vpos,idx: Integer;
begin
  left := x;
  vpos := y;

  if FSortSettings.IndexShow then
  begin
    idx := SortIndexes.FindIndex(Col);
    if idx = -1 then
      Exit;

    Canvas.Brush.Color := FSortSettings.IndexColor;
    SetBKMode(Canvas.Handle,Transparent);
    Canvas.Font.Color := clBlack;
    Canvas.Font.Size := 6;

    if (SortIndexes.Items[idx] and $80000000 = $80000000) then
    begin
      if (FSortSettings.IndexUpGlyph.Empty) or (FSortSettings.IndexDownGlyph.Empty) then
        Canvas.Polygon([Point(Left-7,vpos-5), Point(Left+7,vpos-5), Point(Left, vpos+8)])
      else
      begin
        {$IFDEF DELPHI3_LVL}
        FSortSettings.IndexUpGlyph.Transparent := True;
        FSortSettings.IndexUpGlyph.TransparentMode := tmAuto;
        {$ENDIF}
        Canvas.Draw(Left - 7,vpos - 7,FSortSettings.IndexUpGlyph);
      end;
      Canvas.Textout(Left - 2,vpos - 4,inttostr(idx+1));
    end
    else
    begin
      if (FSortSettings.IndexUpGlyph.Empty) or (FSortSettings.IndexDownGlyph.Empty) then
        Canvas.Polygon([Point(left-6,vpos+8), Point(left+6,vpos+8), Point(left, vpos-4)])
      else
      begin
        {$IFDEF DELPHI3_LVL}
        FSortSettings.IndexDownGlyph.Transparent := True;
        FSortSettings.IndexDownGlyph.TransparentMode := tmAuto;
        {$ENDIF}
        Canvas.Draw(Left - 7,vpos - 7,FSortSettings.IndexDownGlyph);
      end;
      Canvas.Textout(Left - 2,vpos - 2,inttostr(idx+1));
    end;

    Exit;
  end;

  if FSortSettings.Direction = sdDescending then
  begin
    {draw a full Colored triangle}
    if (FSortSettings.UpGlyph.Empty) or (FSortSettings.DownGlyph.Empty) then
    begin
      Canvas.Pen.Color := clWhite;
      Canvas.Pen.Width := 1;
      Canvas.MoveTo(left+4,vpos-4);
      Canvas.LineTo(left,vpos+4);
      Canvas.pen.Color := clGray;
      Canvas.LineTo(left-4,vpos-4);
      Canvas.LineTo(left+4,vpos-4);
      Canvas.pen.Color := clBlack;
    end
    else
    begin
      {$IFDEF DELPHI3_LVL}
      FSortSettings.DownGlyph.Transparent := True;
      FSortSettings.DownGlyph.TransparentMode := tmAuto;
      {$ENDIF}
      Canvas.Draw(left - 4,vpos - 4,FSortSettings.DownGlyph);
      {reset bk Color since this is a Delphi 3 bug}
      SetBKColor(Canvas.Handle,ColorToRGB(FixedColor));
    end;
  end
  else
  begin
    if (FSortSettings.UpGlyph.Empty) or (FSortSettings.DownGlyph.Empty) then
    begin
      Canvas.Pen.Color := clWhite;
      Canvas.Pen.Width := 1;
      Canvas.MoveTo(left - 4,vpos + 4);
      Canvas.LineTo(left + 4,vpos + 4);
      Canvas.LineTo(left,vpos - 4);
      Canvas.Pen.Color := clGray;
      Canvas.LineTo(left - 4,vpos + 4);
      Canvas.Pen.Color := clBlack;
    end
    else
    begin
      {$IFDEF DELPHI3_LVL}
      FSortSettings.UpGlyph.Transparent := True;
      FSortSettings.UpGlyph.TransparentMode := tmAuto;
      {$ENDIF}
      Canvas.Draw(Left - 4,vpos - 4,FSortSettings.UpGlyph);
      {reset bk Color since this is a Delphi 3 bug}
      SetBKColor(Canvas.Handle,ColorToRGB(FixedColor));
    end;
  end;
end;


procedure TAdvStringGrid.DrawCell(ACol, ARow : longint; ARect : TRect;
  AState : TGridDrawState);
begin
  inherited DrawCell(ACol,ARow,ARect,AState);
end;

procedure TAdvStringGrid.GetVisualProperties(ACol,ARow: Integer; var AState: TGridDrawState; Print, Select,Remap: Boolean;
  ABrush: TBrush; AFont: TFont; var HA: TAlignment; var VA: TVAlignment; var WW: Boolean);
var
  CA: TCellAlignment;
  FixedCell: Boolean;
  RCol: Integer;
  cp: TCellProperties;

begin
  if (ACol < FixedCols) or (ARow < FixedRows) then
  begin
    if Print then
      AFont.Assign(PrintSettings.Font)
    else
      AFont.Assign(FFixedFont);
  end
  else
  begin
    if Print then
      AFont.Assign(PrintSettings.Font)
    else
      AFont.Assign(Font);
  end;

  if Remap then
    RCol := RemapCol(ACol)
  else
    RCol := ACol;  

  ABrush.Color := clNone;

  if HasCellProperties(RCol,ARow) then
  begin
    cp := CellProperties[RCol,ARow];
    if cp.BrushColor <> clNone then
      ABrush.Color := cp.BrushColor;

    if cp.FontColor <> clNone then
      AFont.Color := cp.FontColor;

    if cp.FontStyle <> [] then
      AFont.Style := cp.FontStyle;

    if cp.FontSize <> 0 then
      AFont.Size := cp.FontSize;

    if cp.FontName <> '' then
     AFont.Name := cp.FontName;

  end;

  if ABrush.Color = clNone then
  begin
    ABrush.Color := self.Color;
    if FBands.Active and ((FBands.Print = Print) or not Print) and
       (ACol >= FixedCols) and (ACol < ColCount - FixedRightCols + FNumHidden)
       and (ARow >= FixedRows) and (ARow < RowCount - FixedFooters) then
    begin
      if (((ARow - FixedRows) mod FBands.FTotalLength) < FBands.FPrimaryLength) then
        ABrush.Color := FBands.PrimaryColor
      else
        ABrush.Color := FBands.SecondaryColor;
    end;
  end;
                                  // Added condition in v2.02
  FixedCell := IsFixed(ACol,ARow) or (ACol < FixedCols) or  (ARow < FixedRows);

  if FixedCell and not Print then
  begin
    ABrush.Color := FixedColor;
    AFont.Color := FFixedFont.Color;
    AState := AState + [gdFixed];
  end;

  if Print then
    GetCellPrintColor(RCol,ARow,AState,ABrush,AFont)
  else
    GetCellColor(RCol,ARow,AState,ABrush,AFont);

  if (ACol >= FixedCols) and (ARow >= FixedRows) and MouseActions.DisjunctRowSelect
    and not Print and Select and ShowSelection and not FixedCell then
  begin
    if (not (FMouseDown and (ARow = Row)) and RowSelect[ARow]) or
       (FMouseDown and not RowSelect[ARow] and (gdSelected in AState)) then
    begin
      AState := [gdSelected];
      ABrush.Color := FSelectionColor;
      AFont.Color := FSelectionTextColor;
    end;
  end;

  if (ARow >= FixedRows) and (ACol >= FixedCols) and MouseActions.DisjunctColSelect
    and not Print and Select and ShowSelection and not FixedCell then
  begin
    if (not (FMouseDown and (ACol = Col)) and ColSelect[ACol]) or
       (FMouseDown and not ColSelect[ACol] and (gdSelected in AState)) then
    begin
      AState := [gdSelected];
      ABrush.Color := FSelectionColor;
      AFont.Color := FSelectionTextColor;
    end;
  end;

  if not Print and Select and ShowSelection and not FixedCell and
    (IsSelected(ACol,ARow) and not (MouseActions.DisjunctRowSelect or MouseActions.DisjunctColSelect))
    or ((gdSelected in AState) and FMouseDown) then
  begin
    ABrush.Color := FSelectionColor;
    AFont.Color := FSelectionTextColor;
    AState := AState + [gdSelected];
  end;

  if MouseActions.DisjunctCellSelect then
    if FSelectedCells.IndexOf(Pointer(MakeLong(ACol,ARow))) <> -1 then
    begin
      ABrush.Color := FSelectionColor;
      AFont.Color := FSelectionTextColor;
      AState := AState + [gdSelected];
    end;


  CA := GetCellAlignment(RCol,ARow);
  HA := CA.Alignment;
  VA := CA.VAlignment;
end;


function TAdvStringGrid.GetGraphicDetails(ACol,ARow: Integer; var W,H: Integer; var DisplText: Boolean;
  var HA: TCellHAlign;var VA: TCellVAlign): TCellGraphic;
var
  cg: TCellGraphic;
  pt: TPoint;

begin
  cg := CellGraphics[ACol,ARow];
  Result := cg;
  W := 0;
  H := 0;
  DisplText := True;
  HA := haLeft;
  VA := vaTop;

  if Assigned(cg) then
  begin
    case cg.CellType of
    ctBitmap:
    begin
      W := cg.CellBitmap.Width;
      H := cg.CellBitmap.Height;
    end;
    ctButton,ctBitButton:
    begin
      W := cg.CellIndex and $FFFF;
      H := (cg.CellIndex and $FFFF0000) shr 16;
    end;
    ctFilePicture, ctPicture:
    begin
      pt := CellSize(ACol,ARow);
      pt := cg.GetPictureSize(pt.X,pt.Y,False);
      W := pt.X;
      H := pt.Y;
    end;
    ctCheckBox:
    begin
      W := FControlLook.CheckSize;
      H := FControlLook.CheckSize;
    end;
    ctProgressPie:
    begin
      W := 20;
      H := 20;
    end;
    ctProgress:
    begin
      DisplText := False;
    end;
    ctDataCheckBox,ctVirtCheckBox:
    begin
      W := FControlLook.CheckSize;
      H := FControlLook.CheckSize;
      DisplText := False;
    end;
    ctIcon:
    begin
      W := cg.CellIcon.Width;
      H := cg.CellIcon.Height;
    end;
    ctImageList,ctDataImage:
    begin
      if Assigned(FGridImages) then
      begin
        W := FGridImages.Width;
        H := FGridImages.Height;
        if cg.CellType = ctDataImage then
          DisplText := False;
      end;
    end;
    ctImages:
    begin
      if Assigned(FGridImages) then
      begin
        if cg.CellBoolean then
        begin
          W := FGridImages.Width * CellImages[ACol,ARow].Count;
          H := FGridImages.Height;
        end
        else
        begin
          H := FGridImages.Height * CellImages[ACol,ARow].Count;
          W := FGridImages.Width;
        end;
      end;
    end;
    ctRotated:
    begin
      DisplText := False;
    end;
    ctRadio:
    begin
      DisplText := False;
    end;
    end;
    HA := cg.CellHAlign;
    VA := cg.CellVAlign;
  end;
end;


function TAdvStringGrid.GetFormattedCell(ACol,ARow: Integer): string;
var
  IsFloat: Boolean;
  Fmt: string;
begin
  Result := Cells[ACol,ARow];

  if Assigned(OnGetFloatFormat) then
  begin
    IsFloat := IsType(Result) in [atNumeric,atFloat];
    Fmt := FloatFormat;
    OnGetFloatFormat(Self,ACol,ARow,IsFloat,Fmt);
    if IsFloat then
      Result := Format(fmt,[Floats[ACol,ARow]])
    else
      Result := Cells[ACol,ARow];
  end;
end;


procedure TAdvStringGrid.DrawGridCell(Canvas: TCanvas; ACol, ARow : longint; ARect : TRect;
  AState : TGridDrawState);
const
  WordWraps: array[Boolean] of DWORD = (DT_SINGLELINE,DT_WORDBREAK or DT_EDITCONTROL);
  Alignments: array[TAlignment] of DWORD = (DT_LEFT,DT_RIGHT,DT_CENTER);
  VAlignments: array[TVAlignment] of DWORD = (DT_TOP,DT_VCENTER,DT_BOTTOM);

var
  GraphicWidth,GraphicHeight: Integer;
  MaxTextWidth,MaxTextHeight: Integer;
  HAlignment: TAlignment;
  VAlign: TVAlignment;
  WW: Boolean;
  hal: TCellHAlign;
  val: TCellVAlign;
  tal: TAlignment;
  displtext: Boolean;
  vpos: Integer;
  LFont: TLogFont;
  hOldFont,hNewFont: HFont;
  Anchor,Stripped,FocusAnchor: string;
  xsize,ysize: Integer;
  ctt: TTextType;
  cg: TCellGraphic;
  OCol: Integer;
  FOldBrushColor,FOldFontColor: TColor;
  BRect: TRect;

  procedure DrawBorders(ACol,ARow: Integer;tr: TRect);
  var
    Oldpen: TPen;
    Borders: TCellBorders;
    GLW: Integer;
    PenL,PenR,PenT,PenB: TPen;
  begin
    OldPen := TPen.Create;
    OldPen.Assign(Canvas.Pen);
    borders := [];
    GetCellBorder(ACol,ARow,Canvas.Pen,Borders);

    PenL := TPen.Create;
    PenL.Assign(Canvas.Pen);
    PenR := TPen.Create;
    PenR.Assign(Canvas.Pen);
    PenB := TPen.Create;
    PenB.Assign(Canvas.Pen);
    PenT := TPen.Create;
    PenT.Assign(Canvas.Pen);

    if Assigned(OnGetCellBorderProp) then
      OnGetCellBorderProp(Self, ARow, ACol, PenL, PenT, PenR, PenB);

    GLW := (Canvas.Pen.Width + 1) shr 1;
    tr.Left := tr.Left + GLW;
    tr.Right := tr.Right - GLW;
    tr.Top := tr.Top + GLW;
    tr.Bottom := tr.Bottom - GLW;

    if cbLeft in Borders then
    begin
      Canvas.Pen.Assign(PenL);
      Canvas.MoveTo(tr.Left,tr.Top);
      Canvas.LineTo(tr.Left,tr.Bottom);
    end;

    if cbRight in Borders then
    begin
      Canvas.Pen.Assign(PenR);
      Canvas.MoveTo(tr.Right - 1,tr.Top);
      Canvas.LineTo(tr.Right - 1,tr.Bottom);
    end;

    if cbTop in Borders then
    begin
      Canvas.Pen.Assign(PenT);
      Canvas.MoveTo(tr.Left,tr.Top);
      Canvas.LineTo(tr.Right,tr.Top);
    end;

    if cbBottom in Borders then
    begin
      Canvas.Pen.Assign(PenB);
      Canvas.MoveTo(tr.Left,tr.Bottom - 1);
      Canvas.LineTo(tr.Right,tr.Bottom - 1);
    end;

    Canvas.Pen.Assign(OldPen);
    OldPen.Free;
    PenL.Free;
    PenB.Free;
    PenR.Free;
    PenT.Free;
  end;

  // Draws a checkbox in the cell

  procedure DrawCheck(R:TRect;State,Enabled: Boolean; ControlStyle: TControlStyle);
  var
    DrawState: Integer;
    DrawRect: TRect;
    BMP: TBitmap;
    HTheme: THandle;
  begin
    case ControlStyle of
    csClassic,csFlat:
      begin
        if State then
          DrawState := DFCS_BUTTONCHECK or DFCS_CHECKED
        else
          DrawState := DFCS_BUTTONCHECK;

        if ControlStyle = csFlat then
          DrawState := DrawState or DFCS_FLAT;

        if not Enabled then
          DrawState := DrawState or DFCS_INACTIVE;

        DrawRect.Left := R.Left + (R.Right - R.Left - FControlLook.CheckSize) div 2;
        DrawRect.Top:= R.Top + (R.Bottom - R.Top - FControlLook.CheckSize) div 2;
        DrawRect.Right := DrawRect.Left + FControlLook.CheckSize;
        DrawRect.Bottom := DrawRect.Top + FControlLook.CheckSize;

        DrawFrameControl(Canvas.Handle,DrawRect,DFC_BUTTON,DrawState);
      end;
    csTMS:
      begin
        Bmp := TBitmap.Create;
        if State then
        begin
          if Enabled then
            Bmp.LoadFromResourceName(hinstance,'ASGCHK01')
          else
            Bmp.LoadFromResourceName(hinstance,'ASGCHK03');
        end
        else
        begin
          if Enabled then
            Bmp.LoadFromResourceName(hinstance,'ASGCHK02')
          else
            Bmp.LoadFromResourceName(hinstance,'ASGCHK04');
        end;

        Bmp.Transparent := True;
        Bmp.TransparentMode := tmAuto;

        Canvas.Draw(R.Left,R.Top,bmp);
        Bmp.free;
      end;
    csGlyph:
      begin
        if State and not ControlLook.CheckedGlyph.Empty then
        begin
          ControlLook.CheckedGlyph.Transparent := True;
          ControlLook.CheckedGlyph.TransparentMode := tmAuto;
          Canvas.Draw(R.Left,R.Top,ControlLook.CheckedGlyph);
        end;

        if not State and not ControlLook.UnCheckedGlyph.Empty then
        begin
          ControlLook.UnCheckedGlyph.Transparent := True;
          ControlLook.UnCheckedGlyph.TransparentMode := tmAuto;
          Canvas.Draw(R.Left,R.Top,ControlLook.UnCheckedGlyph);
        end;
      end;
    csTheme:
      begin
        if FIsWinXP then
        begin
          HTheme := OpenThemeData(Self.Handle,'button');

          r := Rect(R.Left, R.Top, R.Left + FControlLook.CheckSize, R.Top + FControlLook.CheckSize);

          if State then
          begin
            if Enabled then
              DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_CHECKEDNORMAL,@r,nil)
            else
              DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_CHECKEDDISABLED,@r,nil);
          end
          else
          begin
            if Enabled then
              DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_UNCHECKEDNORMAL,@r,nil)
            else
              DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_UNCHECKEDDISABLED,@r,nil);
          end;

          CloseThemeData(HTheme);
        end;
      end;
    csWinXP:
      begin
        Bmp := TBitmap.Create;
        if State then
        begin
          if Enabled then
            Bmp.LoadFromResourceName(hinstance,'ASGCHK05')
          else
            Bmp.LoadFromResourceName(hinstance,'ASGCHK07');
        end
        else
        begin
          if Enabled then
            Bmp.LoadFromResourceName(hinstance,'ASGCHK06')
          else
            Bmp.LoadFromResourceName(hinstance,'ASGCHK08');
        end;

        Bmp.Transparent := True;
        Bmp.TransparentMode := tmAuto;

        Canvas.Draw(R.Left,R.Top,bmp);																									// <PI>
        Bmp.free;
      end;

    csBorland:
      begin
        if Enabled then
          Canvas.Brush.Color := clBtnFace
        else
          Canvas.Brush.Color := clBtnShadow;
            
        Canvas.Pen.Color := clBtnFace;
        Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
        Canvas.Pen.Color := clBtnHighLight;
        Canvas.MoveTo(R.Left,R.Bottom);
        Canvas.LineTo(R.Left,R.Top);
        Canvas.LineTo(R.Right,R.Top);
        Canvas.Pen.Color := clBtnShadow;
        Canvas.LineTo(R.Right,R.Bottom);
        Canvas.LineTo(R.Left,R.Bottom);

        if State then
        begin
          if Enabled then
            Canvas.Pen.Color := FControlLook.Color
          else
            Canvas.Pen.Color := clGray;

          Canvas.Pen.Width := 1;
          Dec(R.Top);
          Dec(R.Bottom);
          Canvas.MoveTo(R.Left + 2,R.Top + FControlLook.CheckSize div 2 + 1);
          Canvas.LineTo(R.Left + 2,R.Bottom - 1);
          Canvas.MoveTo(R.Left + 3,R.Top + FControlLook.CheckSize div 2);
          Canvas.LineTo(R.Left + 3,R.Bottom - 2);
          Canvas.MoveTo(R.Left + 2,R.Bottom - 1);
          Canvas.LineTo(R.Right - 2,R.Top + 3);
          Canvas.MoveTo(R.Left + 3,R.Bottom - 1);
          Canvas.LineTo(R.Right - 1,R.Top + 3);
        end;
      end;
    end;
  end;

  // Draws radiobuttons in the cell

  procedure DrawRadio(R:TRect;Num,Idx: Integer;dir,dis: Boolean;sl: TStrings);
  var
    DrawState: Integer;
    DrawRect: TRect;
    DrawNum: Integer;
    DrawOfs,Th: Integer;
    s: string;
    Bmp: TBitmap;
    RadioOn: Boolean;
    HTheme: THandle;
    OldColor: TColor;

  begin
    DrawOfs := 0;
    SetBkMode(Canvas.Handle,TRANSPARENT);

    for DrawNum := 1 to Num do
    begin
      RadioOn := False;
      s := '';

      if Assigned(sl) then
      begin
        if (gdSelected in AState) then
          Canvas.Font.Color := SelectionTextColor;

        if DrawNum <= sl.Count then
        begin
          s := sl.Strings[DrawNum - 1];
          if (idx = -1) and (s = Cells[ACol,ARow]) then
            RadioOn := True;
        end;
      end;

      if (DrawNum - 1 = Idx) then
       RadioOn := True;

      case ControlLook.ControlStyle of
      csClassic,csFlat:
        begin
          DrawState := DFCS_BUTTONRADIO;

          if ControlLook.ControlStyle = csFlat then
            DrawState := DrawState or DFCS_FLAT;

          if Dis then
            DrawState := DrawState or DFCS_INACTIVE;

          if RadioOn then
            DrawState := DrawState or DFCS_CHECKED;

          if dir then
          begin
            DrawRect.Left := DrawOfs + R.Left + 2 + (DrawNum-1) * ControlLook.RadioSize;
            DrawRect.Top := R.Top + (R.Bottom - R.Top - ControlLook.RadioSize) div 2;

            if s <> '' then
            begin
              Canvas.TextOut(DrawRect.Left + ControlLook.RadioSize,DrawRect.Top - 2,s);
              DrawOfs := DrawOfs + Canvas.TextWidth(s);
            end;
          end
          else
          begin
            th := Canvas.TextHeight('gh');
            if s <> '' then
            begin
              DrawRect.Left := R.Left + 2;
              DrawRect.Top := R.Top + 2 + (DrawNum - 1) * th;
              Canvas.TextOut(DrawRect.Left + ControlLook.RadioSize + 4,DrawRect.Top - 2,s);
            end
            else
            begin
              DrawRect.Left := R.Left + (R.Right - R.Left - ControlLook.RadioSize) div 2;
              DrawRect.Top := R.Top + 2 + (DrawNum - 1) * th;
            end;
          end;

          if ControlLook.ControlStyle = csFlat then
          begin
            DrawRect.Right := DrawRect.Left + ControlLook.RadioSize + 2;
            DrawRect.Bottom := DrawRect.Top + ControlLook.RadioSize + 2;
          end
          else
          begin
            DrawRect.Right := DrawRect.Left + ControlLook.RadioSize;
            DrawRect.Bottom := DrawRect.Top + ControlLook.RadioSize;
          end;

          DrawFrameControl(Canvas.Handle,DrawRect,DFC_BUTTON,DrawState);
        end;
      csTMS, csWinXP, csGlyph:
        begin
          bmp := TBitmap.Create;

          if dir then
          begin
            DrawRect.Left := DrawOfs + R.Left + 2 + (DrawNum - 1) * 16;
            DrawRect.Top := R.Top + (R.Bottom - R.Top - 16) div 2;

            if s <> '' then
            begin
             Canvas.Textout(DrawRect.Left + 16,DrawRect.Top - 2,s);
             DrawOfs := DrawOfs + Canvas.TextWidth(s);
            end
          end
          else
          begin
            th := Max(16,Canvas.TextHeight('gh'));
            if s <> '' then
            begin
              DrawRect.Left := R.Left + 2;
              DrawRect.Top := R.Top + 2 + (DrawNum - 1) * th;
              Canvas.Textout(DrawRect.Left + 16 + 2,Drawrect.Top-2,s);
            end
            else
            begin
              DrawRect.Left := R.Left + (R.Right - R.Left - 16) div 2;
              DrawRect.Top := R.Top + 2 + (DrawNum - 1) * th;
            end;
          end;

          if RadioOn then
          begin
            case ControlLook.ControlStyle of
            csTMS:
              begin
                if not dis then
                  Bmp.LoadFromResourceName(hinstance,'ASGRAD01')
                else
                  Bmp.LoadFromResourceName(hinstance,'ASGRAD03');
              end;
            csWinXP:
              begin
                if not dis then
                  Bmp.LoadFromResourceName(hinstance,'ASGRAD05')
                else
                  Bmp.LoadFromResourceName(hinstance,'ASGRAD07');
              end;
            csGlyph:
              Bmp.Assign(ControlLook.RadioOnGlyph);
            end;
          end
          else
          begin
            case ControlLook.ControlStyle of
            csTMS:
              begin
                if not dis then
                  Bmp.LoadFromResourceName(hinstance,'ASGRAD02')
                else
                  Bmp.LoadFromResourceName(hinstance,'ASGRAD04');
              end;
            csWinXP:
              begin
                if not dis then
                  Bmp.LoadFromResourceName(hinstance,'ASGRAD06')
                else
                  Bmp.LoadFromResourceName(hinstance,'ASGRAD08');
              end;
            csGlyph:
              Bmp.Assign(ControlLook.RadioOffGlyph);
            end;
          end;

          Bmp.Transparent := True;
          Bmp.TransparentMode := tmAuto;

          Canvas.Draw(DrawRect.Left,DrawRect.Top,Bmp);
          Bmp.free;
        end;
      csBorland:
        begin
          if dir then
          begin
            DrawRect.Left := DrawOfs + R.Left + 2 + (DrawNum - 1) * 16;
            DrawRect.Top := R.Top + (R.Bottom - R.Top - 16) div 2;

            if s <> '' then
            begin
             Canvas.Textout(DrawRect.Left + 16,DrawRect.Top - 2,s);
             DrawOfs := DrawOfs + Canvas.TextWidth(s);
            end
          end
          else
          begin
            th := Max(16,Canvas.TextHeight('gh'));
            if s <> '' then
            begin
              DrawRect.Left := R.Left + 2;
              DrawRect.Top := R.Top + 2 + (DrawNum - 1) * th;
              Canvas.Textout(DrawRect.Left + 16 + 2,Drawrect.Top - 2,s);
            end
            else
            begin
              DrawRect.Left := R.Left + (R.Right - R.Left - 16) div 2;
              DrawRect.Top := R.Top + 2 + (DrawNum - 1) * th;
            end;
          end;

          OldColor := Canvas.Brush.Color;

          Canvas.Brush.Color := clBtnFace;

          Canvas.Polygon([Point(DrawRect.Left + 2,DrawRect.Top + 8),
                          Point(DrawRect.Left + 8,DrawRect.Top + 2),
                          Point(DrawRect.Left + 14,DrawRect.Top + 8),
                          Point(DrawRect.Left + 8,DrawRect.Top + 14)]);

          if RadioOn then
            Canvas.Pen.Color := clGray
          else
            Canvas.Pen.Color := clWhite;

          Canvas.MoveTo(DrawRect.Left + 8,DrawRect.Top + 14);
          Canvas.LineTo(DrawRect.Left + 2,DrawRect.Top + 8);
          Canvas.LineTo(DrawRect.Left + 8,DrawRect.Top + 2);

          if RadioOn then
            Canvas.Pen.Color := clWhite
          else
            Canvas.Pen.Color := clGray;

          Canvas.LineTo(DrawRect.Left + 14,DrawRect.Top + 8);
          Canvas.LineTo(DrawRect.Left + 8,DrawRect.Top + 14);

          Canvas.Brush.Color := ControlLook.Color;
          Canvas.Pen.Color := ControlLook.Color;

          if RadioOn then
          Canvas.Polygon([Point(DrawRect.Left + 6,DrawRect.Top + 8),
                          Point(DrawRect.Left + 8,DrawRect.Top + 6),
                          Point(DrawRect.Left + 10,DrawRect.Top + 8),
                          Point(DrawRect.Left + 8,DrawRect.Top + 10)]);


          Canvas.Brush.Color := OldColor;


        end;
      csTheme:
        begin
          if FIsWinXP then
          begin
            HTheme := OpenThemeData(self.Handle,'button');

            if dir then
            begin
              DrawRect.Left := DrawOfs + R.Left + 2 + (DrawNum - 1) * 16;
              DrawRect.Top := R.Top + (R.Bottom - R.Top - 16) div 2;

              if s <> '' then
              begin
               Canvas.Textout(DrawRect.Left + 16,DrawRect.Top - 2,s);
               DrawOfs := DrawOfs + Canvas.TextWidth(s);
              end
            end
            else
            begin
              th := Max(16,Canvas.TextHeight('gh'));
              if s <> '' then
              begin
                DrawRect.Left := R.Left + 2;
                DrawRect.Top := R.Top + 2 + (DrawNum - 1) * th;
                Canvas.Textout(DrawRect.Left + 16 + 2,Drawrect.Top-2,s);
              end
              else
              begin
                DrawRect.Left := R.Left + (R.Right - R.Left - 16) div 2;
                DrawRect.Top := R.Top + 2 + (DrawNum - 1) * th;
              end;
            end;

            DrawRect.Right := DrawRect.Left + 16;
            DrawRect.Bottom := DrawRect.Top + 16;

            if RadioOn then
            begin
              if not dis then
                DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_CHECKEDNORMAL,@DrawRect,nil)
              else
                DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_CHECKEDDISABLED,@DrawRect,nil)
            end
            else
            begin
              if not dis then
                DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_UNCHECKEDNORMAL,@DrawRect,nil)
              else
                DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_UNCHECKEDDISABLED,@DrawRect,nil)
            end
          end;
        end;
      end;
    end;
  end;

  // Draws graphic in the cell
  procedure DrawCellGraphic(r: TRect; CellGraphic: TCellGraphic);
  var
    TgtRect,SrcRect: TRect;
    tmpbmp: TBitmap;
    srcColor: TColor;
    idx: Integer;
    s: string;
    IsEdit: Boolean;
    DrawStyle : DWord;
    HTheme: THandle;

  begin
    SrcRect.Top := 0;
    SrcRect.Left := 0;
    SrcRect.Right := GraphicWidth;
    SrcRect.Bottom := GraphicHeight;

    if MaxTextWidth > 0 then
      MaxTextWidth := MaxTextWidth + 2;

    case CellGraphic.CellHAlign  of
    haLeft:
      begin
        TgtRect.Left := r.Left + 1;
        TgtRect.Right := TgtRect.Left + GraphicWidth;
      end;
    haRight:
      begin
        TgtRect.Right := r.Right - 1;
        TgtRect.Left := TgtRect.Right - GraphicWidth;
      end;
    haCenter:
      begin
        if (GraphicWidth < r.Right - r.Left) then
        begin
          TgtRect.Left := r.Left + (r.Right - r.Left - GraphicWidth) shr 1;
          TgtRect.Right := TgtRect.Left + GraphicWidth;
        end
        else
        begin
          TgtRect.Left := r.Left + 1;
          TgtRect.Right := TgtRect.Left + GraphicWidth;
        end;
      end;
    haBeforeText:
      begin
        if (tal = taLeftJustify) then
        begin
          TgtRect.Left := r.Left + 1;
          TgtRect.Right := TgtRect.Left + GraphicWidth;
        end
        else
        begin
          TgtRect.Left := r.Right - MaxTextWidth - GraphicWidth;
          TgtRect.Right := TgtRect.Left + GraphicWidth;
          if TgtRect.Left < r.Left then
            TgtRect.Left := r.Left + 1;
        end
      end;
    haAfterText:
      begin
        if tal = taRightJustify then
        begin
          TgtRect.Right := r.Right - 1;
          TgtRect.Left := TgtRect.Right - GraphicWidth;
        end
        else
        begin
          TgtRect.Left := r.Left + MaxTextWidth;
          TgtRect.Right := TgtRect.Left + GraphicWidth;
        end
      end;
    haFull:
      begin
        TgtRect.Right := r.Right;
        TgtRect.Left := r.Left;
      end;
    end;

    case CellGraphic.CellVAlign  of
    vaTop,vaAboveText:
      begin
        TgtRect.Top := r.Top + 1;
        TgtRect.Bottom := TgtRect.Top + GraphicHeight;
      end;
    vaBottom:
      begin
        TgtRect.Bottom := r.Bottom - 1;
        TgtRect.Top := TgtRect.Bottom - GraphicHeight;
      end;
    vaCenter:
      begin
        if GraphicHeight < (r.Bottom - r.Top) then
        begin
          TgtRect.Top := r.Top + (r.Bottom-r.Top-GraphicHeight) shr 1;
          TgtRect.Bottom := TgtRect.Top + GraphicHeight;
        end
        else
        begin
          TgtRect.Top := r.Top + 1;
          TgtRect.Bottom := TgtRect.Top + GraphicHeight;
        end;
      end;
    vaUnderText:
      begin
        TgtRect.Top := r.Bottom - GraphicHeight;
        TgtRect.Bottom := r.Bottom;
      end;
    vaFull:
      begin
        TgtRect.Top := r.Top;
        TgtRect.Bottom := r.Bottom;
      end;
    end;

    case CellGraphic.CellType of
    ctCheckBox,ctDataCheckBox,ctVirtCheckBox:
    begin
      case HAlignment of
      taLeftJustify:
        begin
          TgtRect.Left := r.Left + 1;
          TgtRect.Right := TgtRect.Left + GraphicWidth;
        end;
      taRightJustify:
        begin
          if CellGraphic.CellType in [ctDataCheckBox,ctVirtCheckBox] then
            TgtRect.Left := r.Right - GraphicWidth - 1
          else
            TgtRect.Left := r.Right - MaxTextWidth - GraphicWidth - 1;

          if TgtRect.Left < r.Left then
            TgtRect.Left := r.Left + 1;
          TgtRect.Right := TgtRect.Left + GraphicWidth;
        end;
      taCenter:
        begin
          if CellGraphic.CellType in [ctDataCheckBox,ctVirtCheckBox] then
            TgtRect.Left := r.Left + (Max(0,(r.Right - GraphicWidth - r.Left)) shr 1)
          else
          begin
            if MaxTextWidth > 0 then
              TgtRect.Left := r.Left - GraphicWidth + Max(0,(r.Right - MaxTextWidth - r.Left)) shr 1
            else
              TgtRect.Left := r.Left + Max(0,(r.Right - GraphicWidth - r.Left)) shr 1;
          end;
          if TgtRect.Left < r.Left then TgtRect.Left := r.Left + 1;
            TgtRect.Right := TgtRect.Left + GraphicWidth;
        end;
      end;

      IsEdit := True;

      GetCellReadOnly(ACol,ARow,IsEdit);

      if CellGraphic.CellType = ctCheckBox then
        DrawCheck(TgtRect,CellGraphic.CellBoolean,IsEdit,FControlLook.ControlStyle)
      else
        DrawCheck(TgtRect,Cells[ACol,ARow] = GetCheckTrue(ACol,ARow),IsEdit,FControlLook.ControlStyle);
    end;

    ctRotated:
    begin
      SrcRect := r;

      CalcTextPos(SrcRect,CellGraphic.CellAngle,Cells[ACol,ARow],HAlignment,VAlign);

      GetObject(Canvas.Font.Handle,SizeOf(LFont),Addr(LFont));
      LFont.lfEscapement := CellGraphic.CellAngle * 10;
      LFont.lfOrientation := CellGraphic.CellAngle * 10;

      hNewFont := CreateFontIndirect(LFont);
      hOldFont := SelectObject(Canvas.Handle,hNewFont);

      SetTextAlign(Canvas.Handle,TA_TOP);

      InflateRect(r,-2,-2);

      Canvas.Brush.Style := bsCLear;
      Canvas.TextRect(r,SrcRect.Left,SrcRect.Top,Cells[ACol,ARow]);

      hNewFont := SelectObject(Canvas.Handle,hOldFont);
      DeleteObject(hNewFont);
    end;

    ctComment:
    begin
      if FCommentColor <> clNone then
      begin
        Canvas.Pen.Color := FCommentColor;
        Canvas.Brush.Color := FCommentColor;
        Canvas.Polygon([Point(r.Right-7,r.Top+1),Point(r.Right-2,r.Top+1),Point(r.Right-2,r.Top+6)]);
        Canvas.Brush.Color := Self.Color;
      end;
    end;

    ctProgressPie:
    begin
      DrawProgress(Canvas,Rect(TgtRect.left,TgtRect.Top,TgtRect.left+20,TgtRect.Top+20),TColor(CellGraphic.CellBitmap),CellGraphic.CellAngle);
    end;

    ctProgress:
    begin
      SrcColor := Canvas.Brush.Color;
      Canvas.Brush.Color := self.Color;
      Canvas.Brush.Color := TColor(CellGraphic.CellBitmap);
      Canvas.Pen.Color := TColor(CellGraphic.CellBitmap);

      if CellGraphic.CellBoolean then
        Canvas.Font.Color := TColor(CellGraphic.CellIndex)
      else
        Canvas.Font.Color := TColor(CellGraphic.CellBitmap) xor $FFFFFF;

      Inflaterect(r,-2,-2);
      SrcRect := r;
      SrcRect.Right := SrcRect.Left+round( (SrcRect.Right-SrcRect.Left)*(Ints[ACol,ARow])/100);
      TgtRect.Left := r.Left + (((r.Right-r.Left) - Canvas.TextWidth(Cells[ACol,ARow]+'%')) div 2);
      TgtRect.Top := r.Top + (((r.Bottom-r.Top) - Canvas.TextHeight(Cells[ACol,ARow]+'%')) div 2);
      Canvas.TextRect(SrcRect,TgtRect.Left,TgtRect.Top,Cells[ACol,ARow]+'%');

      Canvas.Brush.Color := TColor(CellGraphic.CellIcon);
      Canvas.Pen.Color := TColor(CellGraphic.CellIcon);

      if CellGraphic.CellBoolean then
        Canvas.Font.Color := TColor(CellGraphic.CellAngle)
      else
        Canvas.Font.Color := TColor(CellGraphic.CellIcon) xor $FFFFFF;

      SrcRect.Left := SrcRect.Right;
      SrcRect.Right := r.Right;
      Canvas.TextRect(SrcRect,TgtRect.Left,TgtRect.Top,Cells[ACol,ARow]+'%');

      Canvas.Brush.Color := clBlack;
      Canvas.Pen.Color := SrcColor;
      Inflaterect(r,1,1);

      Canvas.FrameRect(r);
      Canvas.Brush.Color := SrcColor;
      Inflaterect(r,1,1);
      Canvas.FrameRect(r);
    end;

    ctBitmap:
    begin
      if (CellGraphic.CellTransparent) then
      begin
        TmpBmp := TBitmap.Create;
        TmpBmp.Height := GraphicHeight;
        TmpBmp.Width := GraphicWidth;

        if ((gdSelected in AState) or
           (RowSelect[ARow] and (goRowSelect in Options) and (ACol >= FixedCols)) )
            and not (gdFocused in AState) then
          TmpBmp.Canvas.Brush.Color := FSelectionColor
        else
          TmpBmp.Canvas.Brush.Color := Canvas.Brush.Color;

        SrcColor := CellGraphic.CellBitmap.Canvas.pixels[0,0];

        TmpBmp.Canvas.BrushCopy(SrcRect,CellGraphic.CellBitmap,SrcRect,srcColor );
        Canvas.CopyRect(TgtRect, TmpBmp.Canvas, SrcRect);
        TmpBmp.Free;
      end
      else
        Canvas.Draw(TgtRect.Left,TgtRect.Top,CellGraphic.CellBitmap);
    end;

    ctButton,ctBitButton:
    begin
      CellGraphic.CellValue := MakeLong(TgtRect.Left - ARect.Left,TgtRect.Top - ARect.Top);
      s := CellGraphic.CellText;
      SrcColor := SetBKColor(Canvas.Handle,ColorToRGB(clBtnFace));

      if FIsWinXP then
      begin
        if IsThemeActive then
        begin
          HTheme := OpenThemeData(Self.Handle,'button');

          if CellGraphic.cellBoolean then
          begin
            DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_PRESSED ,@TgtRect,nil);
            InflateRect(TgtRect,-3,-3);
          end
          else
          begin
            DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_NORMAL ,@TgtRect,nil);
            InflateRect(TgtRect,-2,-2);
          end;

          CloseThemeData(HTheme);
        end;
      end
      else
      begin
        DrawStyle := DFCS_BUTTONPUSH;
        if FControlLook.FlatButton then
          DrawStyle := DrawStyle or DFCS_FLAT;

        if CellGraphic.cellBoolean then
        begin
          DrawFrameControl(Canvas.Handle,TgtRect,DFC_BUTTON, DrawStyle or DFCS_PUSHED);
          InflateRect(TgtRect,-3,-3);
        end
        else
        begin
          DrawFrameControl(Canvas.Handle,TgtRect,DFC_BUTTON,DrawStyle);
          InflateRect(TgtRect,-2,-2);
        end;
      end;

      //Canvas.Font.Assign(Font);

      if CellGraphic.CellType = ctBitButton then
      begin
        if not Cellgraphic.CellBitmap.Empty then
        begin
          DrawBitmapTransp(Canvas,Cellgraphic.CellBitmap,clBtnFace,TgtRect);
          TgtRect.Left := TgtRect.Left + Cellgraphic.CellBitmap.Width + 2;
        end;
      end;
      SetBkMode(Canvas.Handle,TRANSPARENT);
      DrawText(Canvas.Handle,PChar(s),Length(s),TgtRect,DT_CENTER or DT_VCENTER or DT_END_ELLIPSIS);
      SetBKColor(Canvas.Handle,srcColor);
    end;

    ctPicture:
    begin
      if (CellGraphic.CellAngle=0) then
        Canvas.Draw(TgtRect.Left,TgtRect.Top,TPicture(CellGraphic.CellBitmap).Graphic)
      else
        Canvas.StretchDraw(TgtRect,TPicture(CellGraphic.CellBitmap).Graphic);
    end;

    ctFilePicture:
    begin
      TFilepicture(CellGraphic.CellBitmap).DrawPicture(Canvas,TgtRect);
    end;

    ctIcon:
    begin
      Canvas.Draw(TgtRect.Left,TgtRect.Top,CellGraphic.cellIcon);
    end;

    ctRadio:
    begin
      IsEdit := True;
      GetCellReadOnly(ACol,ARow,IsEdit);

      DrawRadio(r,GetRadioStrings(ACol,ARow).Count,CellGraphic.CellIndex,CellGraphic.cellBoolean,not IsEdit,
                TStringList(CellGraphic.cellbitmap));
    end;

    ctImageList:
    begin
      if Assigned(FGridImages) then
        FGridImages.Draw(Canvas,TgtRect.Left,TgtRect.Top,CellGraphic.CellIndex);
    end;

    ctImages:
    begin
      if Assigned(FGridImages) then
      begin
        for idx := 1 to TIntList(CellGraphic.CellBitmap).Count do
        begin
          FGridImages.Draw(Canvas,TgtRect.Left,TgtRect.Top,TIntList(CellGraphic.CellBitmap).Items[idx-1]);
           if CellGraphic.CellBoolean then
             TgtRect.Left := TgtRect.Left + Gridimages.Width
           else
             TgtRect.Top := TgtRect.Top + Gridimages.Height;
        end;
      end;
    end;

    ctDataImage:
    begin
      if Assigned(FGridImages) then
      begin
        idx := Ints[ACol,ARow];
        if idx + CellGraphic.CellIndex < FGridImages.Count then
          FGridImages.Draw(Canvas,TgtRect.Left,TgtRect.Top,idx + CellGraphic.CellIndex);
      end;
    end;

    ctNode:
    begin
      r.Left := r.Left - NodeIndent(ARow);

      if FCellNode.NodeType = cn3D then
      begin
        Canvas.Brush.Color := FCellNode.Color;
        Canvas.Rectangle(r.Left,r.Top,r.Right,r.Bottom);
        Frame3D(Canvas,r,clWhite,clGray,1);
      end;

      if (FCellNode.NodeType = cnLeaf) then
      begin
        if CellGraphic.CellBoolean then
          DrawBitmapResourceTransp(Canvas,Canvas.Brush.Color,r,'ASGLEAFCLOSE')
        else
          DrawBitmapResourceTransp(Canvas,Canvas.Brush.Color,r,'ASGLEAFOPEN');
        Exit;
      end;

      if (FCellNode.NodeType = cnGlyph) and
         (not FCellNode.ExpandGlyph.Empty) and
         (not FCellNode.ContractGlyph.Empty) then
      begin
        if CellGraphic.CellBoolean then
          DrawBitmapTransp(Canvas,FCellNode.FContractGlyph,Canvas.Brush.Color,r)
        else
          DrawBitmapTransp(Canvas,FCellNode.FExpandGlyph,Canvas.Brush.Color,r);
        Exit;
      end;

      Canvas.Brush.Color := FCellNode.Color;
      r.Left := r.Left + 4;
      r.Right := r.Left + 8;
      r.Top := r.Top + (Max(0,r.Bottom - r.Top - 8) shr 1);
      r.Bottom := r.Top + 8;

      if FCellNode.NodeType = cnFlat then
      begin
        Canvas.Pen.Color := FCellNode.NodeColor;
        Canvas.Rectangle(r.Left - 1,r.Top - 1,r.Right + 1,r.Bottom + 1);
        if CellGraphic.CellBoolean then
        begin
          Canvas.MoveTo(r.Left + 1,r.Top+3);
          Canvas.LineTo(r.Left + 6,r.Top+3);
          Canvas.MoveTo(r.Left + 3,r.Top+1);
          Canvas.LineTo(r.Left + 3,r.Top+6);
        end
        else
        begin
          Canvas.MoveTo(r.Left+1,r.Top+3);
          Canvas.LineTo(r.Left+6,r.Top+3);
        end;
      end
      else
      begin
        if CellGraphic.CellBoolean then
          DrawEdge(Canvas.Handle,r,EDGE_RAISED,BF_RECT or BF_SOFT)
        else
          DrawEdge(Canvas.Handle,r,EDGE_SUNKEN,BF_RECT or BF_SOFT);
      end;

    end;
    end;
  end;

  procedure DrawWallPaperFixed(crect: TRect);
  var
    SrcRect,DsTRect,Irect: TRect;
    x,y,ox,oy: Integer;
    dst: TPoint;
  begin
    dst.x := FBackground.Left;
    dst.y := FBackground.Top;
    x := FBackground.Bitmap.Width;
    y := FBackground.Bitmap.Height;

    DsTRect.Top := dst.y;
    DsTRect.Left := dst.x;
    DsTRect.Right := DsTRect.Left+x;
    DsTRect.Bottom := DsTRect.Top+y;

    if not IntersecTRect(irect,crect,dsTRect) then
      Exit;

    SetBkMode(Canvas.Handle,TRANSPARENT);

    ox := crect.Left-dst.x;
    oy := crect.Top-dst.y;

    SrcRect.Left := ox;
    SrcRect.Top := oy;
    SrcRect.Right := ox + crect.Right - crect.Left;
    SrcRect.Bottom := oy + crect.Bottom - crect.Top;

    DsTRect := crect;

    if ox <= 0 then
    begin
      DsTRect.Left := dst.x;
      SrcRect.Left := 0;
      SrcRect.Right := DsTRect.Right-DsTRect.Left;
    end;

    if oy <= 0 then
    begin
      DsTRect.Top := dst.y;
      SrcRect.Top := 0;
      SrcRect.Bottom := DsTRect.Bottom-DsTRect.Top;
    end;

    if (SrcRect.Left + (DsTRect.Right - DsTRect.Left) > x) then
    begin
      DsTRect.Right := DsTRect.Left + x - SrcRect.Left;
      SrcRect.Right := x;
    end;

    if (SrcRect.Top + DsTRect.Bottom - DsTRect.Top > y) then
    begin
      DsTRect.Bottom := DsTRect.Top + y - SrcRect.Top;
      SrcRect.Bottom := y;
    end;
    Canvas.CopyRect(DsTRect,FBackground.Bitmap.Canvas,SrcRect);
  end;

  procedure DrawWallPaperTile(crect:TRect);
  var
    SrcRect,DsTRect:TRect;
    x,y,xo,yo,ox,oy,i: Integer;
  begin
    x := FBackground.Bitmap.Width;
    y := FBackground.Bitmap.Height;
    SetBkMode(Canvas.Handle,TRANSPARENT);

    if FBackGround.FBackgroundCells = bcNormal then
      xo := FixedCols else xo:=0;

    ox := 0;
    for i := xo + 1 to ACol do
      ox := ox + ColWidths[i - 1];

    if FBackGround.FBackgroundCells = bcNormal then
       yo := FixedRows else yo := 0;

    oy:=0;
    for i := yo + 1 to ARow do
      oy := oy + RowHeights[i - 1];

    ox := ox mod x;
    oy := oy mod y;

    SrcRect.Left := ox;
    SrcRect.Top := oy;
    SrcRect.Right := x;
    SrcRect.Bottom := y;

    yo := cRect.Top - 1;

    while yo < cRect.Bottom do
    begin
      xo := cRect.Left -1;
      SrcRect.Left := ox;
      SrcRect.Right := x;
      while xo < cRect.Right do
      begin
        DstRect := Rect(xo,yo,xo + SrcRect.Right - SrcRect.Left,yo + SrcRect.Bottom - SrcRect.Top);

        if DstRect.Right > crect.Right then
        begin
          DstRect.Right := crect.Right;
          SrcRect.Right := SrcRect.Left + (dstRect.Right - dstRect.Left);
        end;
        if DstRect.Bottom > crect.Bottom then
        begin
          DstRect.Bottom := crect.Bottom;
          SrcRect.Bottom := SrcRect.Top + (dstRect.Bottom - dstRect.Top);
        end;

        Canvas.CopyRect(DstRect,FBackground.Bitmap.Canvas,SrcRect);
        xo := xo + SrcRect.Right - SrcRect.Left;
        SrcRect.Left := 0;
        SrcRect.Right := x;
      end;
      yo := yo + SrcRect.Bottom - SrcRect.Top;
      SrcRect.Top := 0;
      SrcRect.Bottom := y;
    end;
  end;

  procedure DrawCellText;
  var
    AlignValue: TAlignment;
    FontHeight: Integer;
    Rect,Hr,CR: TRect;
    TmpStr: string;
    SortWidth: Integer;
    URLCol,OldCol: TColor;
    c,ml,hl,sortindent: Integer;
    DrawStyle: DWord;
    ErrPos,ErrLen: Integer;
    FltrBmp: TBitmap;
    CID,CV,CT: string;
    {$IFDEF DELPHI4_LVL}
    DRect: TRect;
    Hold: Integer;
    {$ENDIF}
    {$IFDEF TMSUNICODE}
    ws: widestring;
    {$ENDIF}

  begin
    URLCol := FURLColor;

    if ((gdSelected in Astate) or
       (RowSelect[ARow] and (goRowSelect in Options) and (ACol >= FixedCols))) and not
       ((gdFocused in AState) and not
       (goDrawFocusSelected in Options)) then
    begin
      if FShowSelection then
      begin
        if FSelectionColor <> clNone then
          Canvas.Brush.Color := FSelectionColor;
        if FSelectionTextColor <> clNone then
          Canvas.Font.Color := FSelectionTextColor;

        URLCol := FSelectionTextColor;
      end;

      if (not (GetFocus = Handle) or (HasCheckBox(ACol,ARow))) and not FShowSelection  then
      begin
        Canvas.Brush.Color := FOldBrushColor;
        Canvas.Font.Color := FOldFontColor;
        URLCol := FURLColor;
      end;
    end;

    TmpStr := GetFormattedCell(ACol,ARow);

    ctt := TextType(TmpStr,FEnableHTML);

    if ctt = ttFormula then
      TmpStr := CalcCell(ACol,ARow);

    GetMarker(ACol,ARow,ErrPos,ErrLen);

    if IsPassword(ACol,ARow) then
      StringToPassword(TmpStr,PasswordChar);

    Rect := ARect;

    if (ARow = 0) and GetFilter(ACol) then
    begin
      FltrBmp := TBitmap.Create;
      FltrBmp.LoadFromResourceName(HInstance,'ASGFILT');
      Rect.Left := Rect.Right -16;
      DrawBitmapTransp(Canvas,FltrBmp,FixedColor,Rect);
      FltrBmp.Free;
      Rect := ARect;
    end;

    if (ACol >= FixedCols) and (ARow >= FixedRows) and not FMouseDown then

      if (FMouseActions.DisjunctRowSelect and not RowSelect[ARow]) or
         (FMouseActions.DisjunctColSelect and not ColSelect[ACol]) then
      begin
        URLCol := FURLColor;
        Canvas.Brush.Color := Color;
        Canvas.Font.Color := Font.Color;
        GetCellColor(ACol,ARow,AState,Canvas.Brush,Canvas.Font);
      end;

    // enhanced code to always draw background image
    if (FBackGround.Bitmap.Empty = False) and
       (((FBackGround.Cells in [bcFixed,bcAll]) and (gdFixed in Astate)) or ((FBackGround.Cells in [bcNormal,bcAll]) and not (gdFixed in Astate)))
       and (((not ((gdSelected in Astate) and not (gdFocused in Astate))) and
       not ((gdFocused in Astate) and (goDrawFocusSelected in Options))) or (FShowSelection = False) ) then
    begin
      if FBackground.Display = bdTile then
        DrawWallPaperTile(Rect)
      else
        DrawWallPaperFixed(Rect);
    end;

    // do the selection rectangle painting here
    c := ACol;
    ACol := RemapColInv(ACol);

    if FSelectionRectangle and IsInGridRect(Selection,ACol,ARow) then
    begin
      Canvas.Pen.Color := FSelectionRectangleColor;
      Canvas.Pen.Width := 2;

      with Canvas do
      begin
        if Selection.Left = ACol then
        begin
          MoveTo(Rect.Left + 1 - GridLineWidth,Rect.Bottom - 1);
          LineTo(Rect.Left + 1 - GridLineWidth,Rect.Top + 1 - GridLineWidth );
        end;

        if Selection.Right = ACol then
        begin
          MoveTo(Rect.Right - 1,Rect.Bottom - 1);
          LineTo(Rect.Right - 1,Rect.Top + 1 - GridLineWidth );
        end;

        if Selection.Top = ARow then
        begin
          MoveTo(Rect.Left + 1 - GridLineWidth ,Rect.Top + 1 - GridLineWidth );
          LineTo(Rect.Right - 1,Rect.Top + 1 - GridLineWidth );
        end;

        if Selection.Bottom = ARow then
        begin
          MoveTo(Rect.Left + 1 - GridLineWidth ,Rect.Bottom - 1);
          LineTo(Rect.Right - 1,Rect.Bottom - 1);
        end;
      end;

      if SelectionResizer and
         (ARow = Selection.Bottom) and (ACol = Selection.Right) then
      begin
        CR := CellRect(Selection.Right,Selection.Bottom);
        CR.Left := Rect.Right - 4;
        CR.Top := Rect.Bottom - 4;
        OldCol := Canvas.Brush.Color;
        Canvas.Brush.Color := SelectionRectangleColor;
        Canvas.Rectangle(CR.Left,CR.Top,CR.Right,CR.Bottom);
        Canvas.Brush.Color := OldCol;
      end;

      Canvas.Pen.Width := 1;
    end;

    ACol := c;

    if not DisplText then Exit;

    // drawing of text
    with Rect do
    begin
      Dec(Right,FXYOffset.X);
      Inc(Left,FXYOffset.X);
      Inc(Top,FXYOffset.Y);
    end;

    // determine text alignment

    AlignValue := HAlignment;

    tal := AlignValue;

    sortindent := 0;

    // centering text in cell
    FontHeight := Canvas.TextHeight('hg');

    // change here cell rectangle dependant of bitmap
    if (HAlignment = taLeftJustify) and (hal = haBeforeText) then
    begin
      Rect.Left := Rect.Left + GraphicWidth;
      sortindent := GraphicWidth;
    end;

    if (hal = haLeft) then
    begin
      sortindent := GraphicWidth;
    end;

    if (HAlignment = taLeftJustify) and (hal = haAfterText) then
    begin
      Rect.Right := Rect.Right - GraphicWidth;
    end;

    if (HAlignment = taRightJustify) and (hal = haAfterText) then
    begin
      Rect.Right := Rect.Right - GraphicWidth;
    end;

    if (HAlignment = taRightJustify) and (hal = haBeforeText) then
    begin
      Rect.Left := Rect.Left + GraphicWidth;
    end;

    if val = vaAboveText then
    begin
      Rect.Top := Rect.Top + GraphicHeight;
    end;

    if val = vaUnderText then
    begin
      Rect.Bottom := Rect.Bottom - GraphicHeight;
    end;

    if ctt = ttHTML then
    begin
      if (ARow = 0) and GetFilter(ACol) then
        Rect.Right := Rect.Right - 18;

      if FSortSettings.Show and (ARow = FSortSettings.Row) and (RowCount > 2) and
         ((ACol = FSortSettings.Column) or (SortIndexes.FindIndex(ACol) <> -1)) and (FixedRows > 0) and
         ((ACol + 1 > FixedCols) or FSortSettings.FixedCols) then
      begin
        Rect.Right := Rect.Right - 10;
      end;

      {$IFDEF DELPHI4_LVL}
      if UseRightToLeftAlignment then
      begin
        DRect := Rect;
        Rect.Left := ClientWidth - Rect.Left;
        Rect.Right := ClientWidth - Rect.Right;
        Hold := Rect.Left;
        Rect.Left := Rect.Right;
        Rect.Right := Hold;
        {$IFDEF DELPHI6_LVL}
        ChangeGridOrientation(False);
        {$ELSE}
        SetGridOrientation(False);
        {$ENDIF}
      end;
      {$ENDIF}


      HTMLDrawEx(Canvas,TmpStr,Rect,Gridimages,
               Rect.Left,Rect.Top,-1,0,1,False,False,False,False,FGridBlink,False,not EnhTextSize,FCtrlDown,
               0.0,URLCol,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,
               XSize,YSize,ml,hl,hr,cr,CID,CT,CV,FImageCache,FContainer,Handle);

      {$IFDEF DELPHI4_LVL}
      if UseRightToLeftAlignment then
      begin
        {$IFDEF DELPHI6_LVL}
        ChangeGridOrientation(True);
        {$ELSE}
        SetGridOrientation(True);
        {$ENDIF}
        Rect := DRect;
      end;
      {$ENDIF}

      if FSortSettings.Show and (ARow = FSortSettings.Row) and (RowCount > 2) and
         ((ACol = FSortSettings.Column) or (SortIndexes.FindIndex(ACol) <> -1)) and (FixedRows > 0) and
         ((ACol + 1 > FixedCols) or FSortSettings.FixedCols) then
      begin
        case VAlign of
        vtaTop:vpos := Rect.Top + 8;
        vtaCenter:vpos := Top +((Rect.Bottom - Rect.Top) shr 1);
        vtaBottom:vpos := Rect.Bottom - 8;
        end;

        if not ((SortIndexes.FindIndex(ACol)>0) and not FSortSettings.IndexShow) then
          DrawSortIndicator(Canvas,ACol,Rect.Right + 2,vpos);
      end;

      //Solves the problem that DrawFocusRect only takes the Canvas Color of the last drawn Font!
      Canvas.TextOut(Rect.Left,Rect.Top,'');

      MaxTextWidth := XSize + 2;

      Exit;
    end;

    if ctt = ttRTF then
    begin
      Canvas.Pen.Color := Canvas.Brush.Color;
      if not (gdSelected in aState) or (gdFocused in aState) or (FSelectionColor <> clNone) then
        Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
      Canvas.Brush.Style := bsClear;
      RTFPaint(ACol,ARow,Canvas,Rect);
      Canvas.Brush.Style := bsSolid;
      Canvas.Font.Color := clBlack; // forces a canvas font reinitialize
      Exit;
    end;

    {$IFDEF TMSUNICODE}
    if ctt = ttUnicode then
    begin
      ws := WideCells[ACol,ARow];

      Canvas.Pen.Color := Canvas.Brush.Color;
      if not (gdSelected in aState) or (gdFocused in aState) or (FSelectionColor <> clNone) then
        Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);

      DrawStyle := VAlignments[VAlign] or Alignments[HAlignment];

      if WordWrap or MultiLineCells then
        DrawTextExW(Canvas.Handle,PWidechar(ws),Length(ws),rect,DT_LEFT or DT_NOPREFIX or DrawStyle,nil)
      else
        DrawTextExW(Canvas.Handle,PWidechar(ws),Length(ws),rect,DT_LEFT or DT_NOPREFIX or DrawStyle or DT_SINGLELINE or DT_END_ELLIPSIS,nil);

      {
      ExtTextOutW(Canvas.Handle,rect.Left,rect.Top,ETO_CLIPPED,@rect,PWideChar(ws),Length(ws),nil);
      }
      Exit;
    end;
    {$ENDIF}

    if (HAlignment = taCenter) and (ARow = FSortSettings.Row) and FSortSettings.Show and
       (ACol = FSortSettings.Column) then
    begin
      Rect.Left := Rect.Left + 10;
    end;

    if (ARow = 0) and (ACol = FSortSettings.Column) and FSortSettings.Show then
      SortWidth := 14
    else
      SortWidth := 0;

    if URLShow then
      if IsURL(Cells[ACol,ARow]) then
      begin
        if not URLFull then
          StripURLProtoCol(TmpStr);
        Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
        Canvas.Font.Color := URLCol;
      end;

    DrawStyle := DT_EDITCONTROL;

    if LinesInText(TmpStr,FMultiLineCells) = 1 then
    begin
      if not WordWrap then
      begin
        TmpStr := GetNextLine(TmpStr,False);
        DrawStyle := DT_SINGLELINE;
        if FEnhTextSize then
          DrawStyle := DrawStyle or DT_END_ELLIPSIS;
      end;
    end;

    {$IFDEF CUSTOMIZED}
    if Pos('*',TmpStr) = 1 then Delete(TmpStr,1,1);
    {$ENDIF}

    FVALign := VAlignments[VAlign];

    DrawStyle := DrawStyle or DT_EXPANDTABS or DT_NOPREFIX or WordWraps[WordWrap] or
      Alignments[HAlignment] or FVAlign;

    {$IFDEF DELPHI4_LVL}
    DrawStyle := DrawTextBiDiModeFlags(DrawStyle);
    {$ENDIF}

    SetBkMode(Canvas.Handle,TRANSPARENT);

    case HAlignment of
    taLeftJustify:Rect.Right := Rect.Right - SortWidth;
    taRightJustify,taCenter:Rect.Left := Rect.Left + SortWidth;
    end;

    if (ARow = 0) and GetFilter(ACol) then
      Rect.Right := Rect.Right - 16;

    {$IFDEF DELPHI4_LVL}
    if UseRightToLeftAlignment then
    begin
      DRect := Rect;
      Rect.Left := ClientWidth - Rect.Left;
      Rect.Right := ClientWidth - Rect.Right;
      Hold := Rect.Left;
      Rect.Left := Rect.Right;
      Rect.Right := Hold;
      {$IFDEF DELPHI6_LVL}
      ChangeGridOrientation(False);
      {$ELSE}
      SetGridOrientation(False);
      {$ENDIF}
    end;
    {$ENDIF}

    if Assigned(cg) and (TmpStr <> '') then
    begin
      CR := Rect;
      DrawTextEx(Canvas.Handle,PChar(TmpStr),Length(TmpStr), CR, DrawStyle OR DT_CALCRECT, nil);
      MaxTextWidth := CR.Right - Rect.Left + 2;
    end;

    DrawTextEx(Canvas.Handle,PChar(TmpStr),Length(TmpStr), Rect, DrawStyle, nil);

    {$IFDEF DELPHI4_LVL}
    if UseRightToLeftAlignment then
    begin
      {$IFDEF DELPHI6_LVL}
      ChangeGridOrientation(True);
      {$ELSE}
      SetGridOrientation(True);
      {$ENDIF}
      Rect := DRect;
    end;
    {$ENDIF}

    if ErrLen > 0 then
    begin
      DrawErrorLines(Self,Canvas, TmpStr, Rect, FontHeight, ErrPos,ErrLen);
    end;

    MaxTextHeight := FontHeight;
    Rect := ARect;

    if (ARow = 0) and GetFilter(ACol) then
      Rect.Right := Rect.Right - 16;


    if FSortSettings.Show and (ARow = FSortSettings.Row) and (RowCount > 2) and
       ((ACol = FSortSettings.Column) or (SortIndexes.FindIndex(ACol) <> -1)) and
       (FixedRows > 0) and ((ACol + 1 > FixedCols) or FSortSettings.FixedCols) then
      with Rect do
      begin
        SortWidth := Min(Rect.Right - Rect.Left - 16,Canvas.TextWidth(TmpStr));

        if SortWidth < 0 then
          SortWidth := 0;

        case AlignValue of
        taLeftJustify:Rect.Left := Rect.Left + SortWidth + 10 + sortindent;
        taRightJustify:Rect.Left := Rect.Right - SortWidth - 10;
        taCenter: Rect.Left := Rect.Left + 8;
        end;

        case VAlign of
        vtaTop:vpos := Rect.Top + 8;
        vtaCenter:vpos := Rect.Top + ((Rect.Bottom - Rect.Top) shr 1);
        vtaBottom:vpos := Rect.Bottom - 8;
        end;

        if not ( (SortIndexes.FindIndex(ACol) > 0) and not FSortSettings.IndexShow) then
          DrawSortIndicator(Canvas,ACol,Rect.Left,vpos);
      end;

      if URLShow then
        Canvas.Font.Style := Canvas.Font.Style - [fsUnderline];
  end;

  procedure DrawGradient(FromColor,ToColor: TColor; Steps: Integer; R: TRect; Direction: Boolean);
  var
    diffr,startr,endr: Integer;
    diffg,startg,endg: Integer;
    diffb,startb,endb: Integer;
    rstepr,rstepg,rstepb,rstepw: Real;
    i,stepw: Word;

  begin
    if Steps = 0 then
      Steps := 1;

    startr := (FromColor and $0000FF);
    startg := (FromColor and $00FF00) shr 8;
    startb := (FromColor and $FF0000) shr 16;
    endr := (ToColor and $0000FF);
    endg := (ToColor and $00FF00) shr 8;
    endb := (ToColor and $FF0000) shr 16;

    diffr := endr - startr;
    diffg := endg - startg;
    diffb := endb - startb;

    rstepr := diffr / steps;
    rstepg := diffg / steps;
    rstepb := diffb / steps;

    if Direction then
      rstepw := (R.Right - R.Left) / Steps
    else
      rstepw := (R.Bottom - R.Top) / Steps;

    with Canvas do
    begin
      for i := 0 to steps-1 do
      begin
        endr := startr + Round(rstepr*i);
        endg := startg + Round(rstepg*i);
        endb := startb + Round(rstepb*i);
        stepw := Round(i*rstepw);
        Pen.Color := endr + (endg shl 8) + (endb shl 16);
        Brush.Color := Pen.Color;
        if Direction then
          Rectangle(R.Left + stepw,R.Top,R.Left + stepw + Round(rstepw)+1,R.Bottom)
        else
          Rectangle(R.Left,R.Top + stepw,R.Right,R.Top + stepw + Round(rstepw)+1);
      end;
    end;

  end;

begin
  if MultiLineCells then
    WordWraps[False] := 0;

  MaxTextWidth := 0;
  MaxTextHeight := 0;

  Ctl3d := not FFlat;

  OCol := ACol;

  // calculate real Col based on hidden Cols
  ACol := RemapCol(ACol);

  GetVisualProperties(OCol,ARow,AState,False,False,True,Canvas.Brush,Canvas.Font,HAlignment,VAlign,WW);
  cg := GetGraphicDetails(ACol,ARow,GraphicWidth,GraphicHeight,DisplText,hal,val);

  if (gdSelected in Astate) and not (gdFocused in Astate) then
  begin
    if FSelectionColor = clNone then
      Canvas.Brush.Color := clHighLight
  end;

  Canvas.Font.Size := Canvas.Font.Size + ZoomFactor;

  // text draw with alignment
  if (ACol = 0) and (ARow = Row) and (FixedCols > 0) and Assigned(FRowIndicator) then
  begin
    DrawBitmapTransp(Canvas,FRowIndicator,FixedColor,ARect);
    ARect.Left := ARect.Left + FRowIndicator.Width;
  end;

  FOldBrushColor := Canvas.Brush.Color;
  FOldFontColor := Canvas.Font.Color;

  if (IsFixed(OCol,ARow) or (OCol < FixedCols) or (ARow < FixedRows)) and
     ((Flook = glTMS) and not Flat) then
  begin
    DrawGradient(FTMSGradFrom,FTMSGradTo,10,ARect,False);
  end;

  DrawCellText;

  {$IFDEF FREEWARE}
  if (ARow = RowCount - 1) then
  begin
    if (Hiword(FFreewareCode) mod 13) +
       (Loword(FFreewareCode) mod 17) <> 13 then
    begin
      BRect := GetCellRect(0,ARow);
      Anchor := ClassName+' '+GetVersionString+' © 2002 http://www.tmssoftware.com';
      Canvas.Font.Color := clGray;
      Canvas.TextOut(BRect.Left+4,BRect.Top,Anchor);
    end;
  end;
  {$ENDIF}

  Canvas.Brush.Color := FOldBrushColor;
  Canvas.Font.Color := FOldFontColor;

  InflateRect(ARect,1,1);

  DrawBorders(ACol,ARow,ARect);

  if (OCol = 0) and (ARow = Row) and (FixedCols > 0) and Assigned(FRowIndicator) then
  begin
    ARect.Left := ARect.Left - FRowIndicator.Width;
  end;

  if (IsFixed(OCol,ARow) or (OCol < FixedCols) or (ARow < FixedRows)) and
     ((Flook = glClassic) and not Flat) then
  begin
    DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_LEFT);
    DrawEdge(Canvas.Handle, ARect, BDR_RAISEDINNER, BF_TOP);
    DrawEdge(Canvas.Handle, ARect, EDGE_RAISED, BF_BOTTOM or BF_RIGHT);

    Canvas.Pen.Color := clBlack;
    Canvas.MoveTo(ARect.Right - 1,ARect.Top);
    Canvas.LineTo(ARect.Right - 1,ARect.Bottom - 1);
    Canvas.LineTo(ARect.Left - 1,ARect.Bottom - 1);
  end;


  if (IsFixed(OCol,ARow) or (OCol < FixedCols) or (ARow < FixedRows)) and
     ((Flook = glTMS) and not Flat) then
  begin

    InflateRect(ARect,1,1);
    ARect.Bottom := ARect.Bottom - 1;

    Canvas.Pen.Color := DarkenColor(FixedColor);
    Canvas.MoveTo(ARect.Left,ARect.Bottom - 1);
    Canvas.LineTo(ARect.Right - 1,ARect.Bottom - 1);
    Canvas.Pen.Color := clWhite;
    Canvas.MoveTo(ARect.Right,ARect.Top + 1);
    Canvas.LineTo(ARect.Left + 1,ARect.Top + 1);
    Canvas.LineTo(ARect.Left + 1,ARect.Bottom - 1);

  end;

  if (IsFixed(OCol,ARow) or (OCol < FixedCols) or (ARow < FixedRows)) and
     ((FLook = glSoft) and not Flat) then
  begin
    if Ctl3D then
    begin
      if (FLook = glSoft) and not Flat then
        InflateRect(ARect,1,1);

      ARect.Bottom := ARect.Bottom - 1;

      if ((FLook = glSoft) and not Flat) and (goFixedHorzLine in Options) then
      begin
        Canvas.Pen.Color := DarkenColor(FixedColor);
        Canvas.MoveTo(ARect.Left,ARect.Bottom - 1);
        Canvas.LineTo(ARect.Right - 1,ARect.Bottom - 1);
        Canvas.Pen.Color := clWhite;
        Canvas.MoveTo(ARect.Right,ARect.Top + 1);
        Canvas.LineTo(ARect.Left + 1,ARect.Top + 1);
        Canvas.LineTo(ARect.Left + 1,ARect.Bottom - 1);
      end;

      if ((FLook = glSoft) and not Flat) and (goFixedVertLine in Options) then
      begin
        Canvas.Pen.Color := DarkenColor(FixedColor);
        Canvas.MoveTo(ARect.Right - 2,ARect.Top);
        Canvas.LineTo(ARect.Right - 2,ARect.Bottom - 1);
        Canvas.Pen.Color := clWhite;
        Canvas.MoveTo(ARect.Right - 1,ARect.Top);
        Canvas.LineTo(ARect.Right - 1,ARect.Bottom - 1);
      end;
    end
    else
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Width := 1;
      if goFixedHorzLine in Options then
      begin
        Canvas.MoveTo(ARect.Left - 1,ARect.Top - 1);
        Canvas.LineTo(ARect.Right + 1,ARect.Top - 1);
        Canvas.MoveTo(ARect.Left - 1,ARect.Bottom + 1);
        Canvas.LineTo(ARect.Right + 1,ARect.Bottom + 1);
      end;
      if goFixedVertLine in Options then
      begin
        Canvas.MoveTo(ARect.Left - 1,ARect.Top - 1);
        Canvas.LineTo(ARect.Left - 1,ARect.Bottom + 1);
        Canvas.MoveTo(ARect.Right + 1,ARect.Top - 1);
        Canvas.LineTo(ARect.Right + 1,ARect.Bottom + 1);
      end;
    end;
  end;

  if (FFixedRightCols > 0) and (ColCount - ACol + FNumHidden <= FFixedRightCols)
     and (Look <> glClassic) then
  begin
    if Ctl3D then
    begin
     // DrawEdge(Canvas.Handle, aRect, BDR_RAISEDINNER, FrameFlags1);
     // DrawEdge(Canvas.Handle, aRect, BDR_RAISEDINNER, FrameFlags2);
    end
    else
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Pen.Width := 1;

      if goFixedHorzLine in Options then
      begin
        Canvas.MoveTo(ARect.Left - 1,ARect.Top - 1);
        Canvas.LineTo(ARect.Right + 1,ARect.Top - 1);
        Canvas.MoveTo(ARect.Left - 1,ARect.Bottom + 1);
        Canvas.LineTo(ARect.Right + 1,ARect.Bottom + 1);
      end;

      if goFixedVertLine in Options then
      begin
        Canvas.MoveTo(ARect.Left - 1,ARect.Top - 1);
        Canvas.LineTo(ARect.Left - 1,ARect.Bottom + 1);
        Canvas.MoveTo(ARect.Right + 1,ARect.Top - 1);
        Canvas.LineTo(ARect.Right + 1,ARect.Bottom + 1);
      end;
    end;
  end;

  if (FNumNodes > 0) and (ACol = 0) and (ARow >= FixedRows) and (FCellNode.ShowTree) then
  begin
    Canvas.Pen.Color := clSilver;
    Canvas.Pen.Width := 1;

    Canvas.MoveTo(ARect.Left - 8,ARect.Top + (ARect.Bottom - ARect.Top) shr 1);
    Canvas.LineTo(ARect.Left,ARect.Top + (ARect.Bottom - ARect.Top) shr 1);

    case GetNodeSpanType(ARow) of
    1:begin
        Canvas.MoveTo(ARect.Left - 8,ARect.Top);
        Canvas.LineTo(ARect.Left - 8,ARect.Top + (ARect.Bottom - ARect.Top) shr 1);
      end;
    2:begin
        Canvas.MoveTo(ARect.Left - 8, ARect.Top );
        Canvas.LineTo(ARect.Left - 8, ARect.Bottom + 4);
      end;
    end;

    Canvas.Pen.Style := psSolid;
  end;

  if Assigned(cg) then
    DrawCellGraphic(ARect,cg);

  if Assigned(OnDrawCell) then
  begin
    BRect := ARect;
    ARect.Top := ARect.Top + 1;
    ARect.Left := ARect.Left + 1;
    ARect.Bottom := ARect.Bottom - GridLineWidth;
    ARect.Right := ARect.Right - GridLineWidth;
    OnDrawCell(Self,ACol,ARow,ARect,AState);
    ARect := BRect;
  end;

  if Assigned(OnCustomCellDraw) then
  begin
    OnCustomCellDraw(Self,Canvas,ACol,ARow,AState,ARect,False);
  end;

  if not FHideFocusRect then
//    if (gdFocused in AState) then
    if (BaseCell(OCol,ARow).X = Col) and (BaseCell(OCol,ARow).Y = Row) and (GetFocus = Handle) then
    begin
      if not (goRowSelect in Options) then
      begin
        InflateRect(ARect,GridLineWidth - 1,GridLineWidth - 1);
        ARect.Right := ARect.Right - 1;
        ARect.Bottom := ARect.Bottom - 1;
        Canvas.DrawFocusRect(ARect);
      end;
    end;
end;


function TAdvStringGrid.Search(s:string): Integer;
var
  i: Integer;
  c: string;
  res,sCol: Integer;

begin
  Search := -1;

  if RowCount < 2 then
    Exit;

  Res := -1;

  if FSortSettings.show then
    sCol := FSortSettings.Column
  else
    sCol := 1;

  for i := FixedRows to RowCount - 1 do
  begin
    c := Cells[sCol,i];
    c := AnsiUpperCase(Copy(c,1,Length(s)));
    if s = c then
    begin
      Res := i;
      Break;
    end;
  end;

  Search := Res;
end;

function TAdvStringGrid.MatchCell(Col,Row: Integer): Boolean;
var
  res1,res2: Boolean;
  ct: string;
  ic: Integer;
begin
  res2 := True;

  if not (fnIncludeHiddenColumns in FFindParams) then
    Col := RemapCol(Col);

  if not (fnMatchCase in FFindParams) then
    ct := AnsiUpperCase(Cells[Col,Row])
  else
    ct:= Cells[Col,Row];

  if fnIgnoreHTMLTags in FFindParams then
    ct := HTMLStrip(ct);

  ic := Pos(SearchCache,ct);

  if fnMatchStart in FFindParams then
    res1 := ic = 1
  else
    res1 := ic > 0;

  if fnMatchFull in FFindParams then
    res2 := SearchCache = ct;

  if fnMatchRegular in FFindParams then
  begin
    MatchCell := MatchStrEx(SearchCache,ct,(fnMatchCase in FFindParams));
  end
  else
    MatchCell := res1 and res2;
end;

function TAdvStringGrid.Find(StartCell:TPoint; s:string; FindParams: TFindParams):TPoint;
var
  MaxCol,MinCol: Integer;
  MaxRow,MinRow: Integer;
  i,j: Integer;

begin
  Result.x := -1;
  Result.y := -1;

  FFindParams := FindParams;
  FFindBusy := True;

  if not (fnMatchCase in FindParams) then
    SearchCache := AnsiUpperCase(s)
  else
    SearchCache := s;

  if (ColCount = FixedCols) or (ColCount = 0) then Exit;
  if (RowCount = FixedRows) or (RowCount = 0) then Exit;

  if fnIncludeFixed in FindParams then
  begin
    MaxCol := ColCount - 1;
    MaxRow := RowCount - 1;
    MinCol := 0;
    MinRow := 0;
  end
  else
  begin
    MaxCol := ColCount - 1 - FixedRightCols;
    MaxRow := RowCount - 1 - FixedFooters;
    MinCol := FixedCols;
    MinRow := FixedRows;
  end;

  if fnIncludeHiddenColumns in FindParams then
    MaxCol := MaxCol + NumHiddenColumns;

  if (StartCell.x = -1) and (StartCell.y = -1) then
  begin
    if fnBackward in FindParams then
    begin
      StartCell.x := MaxCol;
      StartCell.y := MaxRow;
    end
    else
    begin
      StartCell.x := MinCol;
      StartCell.y := MinRow;
    end;
  end
  else
  begin
    if fnDirectionLeftRight in Findparams then
    begin
      if fnBackward in FindParams then
      begin
        if StartCell.x >= MinCol then
          Dec(StartCell.x)
        else
          if StartCell.y >= MinRow then
            Dec(StartCell.y)
          else
          begin
            StartCell.x := MaxCol;
            StartCell.y := MaxRow;
          end;
      end
      else
      begin
        if StartCell.x <= MaxCol then
          Inc(StartCell.x)
        else
          if StartCell.y <= MaxRow then
            Inc(StartCell.y)
          else
          begin
            StartCell.x := MinCol;
            StartCell.y := MinRow;
          end;
      end;
    end
    else
    begin
      if fnBackward in FindParams then
      begin
        if StartCell.y >= MinRow then
          Dec(StartCell.y)
        else
          if StartCell.x >= MinCol then
            Dec(StartCell.x)
          else
          begin
            StartCell.x := MaxCol;
            StartCell.y := MaxRow;
          end;
      end
      else
      begin
        if StartCell.y <= MaxRow then
          Inc(StartCell.y)
        else
          if StartCell.x <= MaxCol then
            Inc(StartCell.x)
          else
          begin
            StartCell.x := MinCol;
            StartCell.y := MinRow;
          end;
      end;
    end;
  end;

  i := StartCell.x;
  j := StartCell.y;

  if fnFindInCurrentRow in Findparams then
  begin
    j := Row;
    MaxRow := Row;
    MinRow := Row;
  end;

  if fnFindInCurrentCol in Findparams then
  begin
    i := Col;
    MaxCol := Col;
    MinCol := Col;
  end;

  StartCell.x := i;
  StartCell.y := j;

  if fnDirectionLeftRight in Findparams then
  begin
    while (j <= MaxRow) and (j >= MinRow) do
    begin
      while (i <= MaxCol) and (i >= MinCol) do
      begin
        if MatchCell(i,j) then
        begin
          SearchCell.x := i;
          SearchCell.y := j;
          Result := SearchCell;
          if fnAutoGoto in FindParams then
          begin
            Row := j;
            Col := i;
          end;
          Exit;
        end;

        if fnBackward in FindParams then
          Dec(i)
        else
          Inc(i);
      end;

    if fnFindInCurrentCol in FindParams then
      i := Col
    else
    begin
      if fnBackward in FindParams then
        i := MaxCol
      else
        i := MinCol;
    end;

    if fnBackward in FindParams then
      Dec(j)
    else
      Inc(j);
    end;
  end
  else
  begin
    while (i <= MaxCol) and (i >= MinCol) do
    begin
      while (j <= MaxRow) and (j >= MinRow) do
      begin
        if MatchCell(i,j) then
        begin
          SearchCell.x := i;
          SearchCell.y := j;
          Result := Searchcell;
          if fnAutoGoto in Findparams then
          begin
            Row:=j;
            Col:=i;
          end;
          Exit;
        end;

        if fnBackward in Findparams then
          Dec(j)
        else
          Inc(j);
      end;

    if fnFindInCurrentRow in Findparams then
      j := Row
    else
    begin
      if fnBackward in FindParams then
        j := MaxRow
      else
        j := MinRow;
    end;

    if fnBackward in Findparams then
      Dec(i)
    else
      Inc(i);
    end;
  end;

  FFindBusy := False;
end;

function TAdvStringGrid.FindFirst(s:string;FindParams: TFindParams):TPoint;
begin
  SearchCell := Find(Point(-1,-1),s,FindParams);
  Result := SearchCell;
end;

function TAdvStringGrid.FindNext:TPoint;
begin
  SearchCell := Find(SearchCell,SearchCache,FFindParams);
  Result := SearchCell;
end;

procedure TAdvStringGrid.Click;
begin
  inherited Click;
  FEntered := False;
  InitValidate(Col,Row);
end;

procedure TAdvStringGrid.InitValidate(ACol,ARow: Integer);
begin
  FOldCol := ACol;
  FOldRow := ARow;
  FOldCellText := Cells[RemapCol(FOldCol), FOldRow];
  FOldModifiedValue := FModified;
end;

procedure TAdvStringGrid.CellsLoaded;
begin
  CalcFooter(-1);
end;

procedure TAdvStringGrid.CellsChanged(R:TRect);
var
  Idx: Integer;
begin
  if Assigned(FOnCellsChanged) then
    FOnCellsChanged(Self,R);

  for Idx := 1 to FNotifierList.Count do
    TGridChangeNotifier(FNotifierList.Items[Idx - 1]).CellsChanged(R);

  CalcFooter(-1);
end;

procedure TAdvStringGrid.UpdateCell(ACol,ARow: Integer);
begin
  CalcFooter(ACol);
end;

function TAdvStringGrid.ValidateCell(const NewValue:string): Boolean;
var
  Value: String;
  Valid: Boolean;
  ROldCol: Integer;

begin
  Result := True;
  if not FEditing then Exit;
  if FValidating then Exit;

  FEditing := False;
  FValidating := True;

  Valid := True;
  ROldCol := RemapCol(FOldCol);

  if (FOldCellText <> NewValue) or FAlwaysValidate then
  begin
    UpdateCell(ROldCol,FOldRow);
    Value := NewValue;
    Valid := True;

    if Assigned(CellChecker) then
      if CellChecker.AutoCorrect then
        Value := CellChecker.Correct(ROldCol,FOldRow,Value);

    if Assigned(FOnCellValidate) then
      FOnCellValidate(Self,ROldCol,FOldRow,Value,Valid);

    if Assigned(CellChecker) then
      if CellChecker.AutoMarkError then
        Value := CellChecker.MarkError(ROldCol,FOldRow,Value);

    CellsChanged(Rect(ROldCol,FOldRow,ROldCol,FOldRow));

    // Since Value is also a VAR parameter, we always
    // use it if it was changed in OnCellValidate.
    if not Valid then
    begin
      if Value <> NewValue then
      begin
        HideEditor;
        Cells[ROldCol,FOldRow] := Value;
        MoveColRow(FOldCol,FOldRow,True,True);
        FValidating := False;
        FEditing := True;
        ShowInplaceEdit;
      end
      else
      begin
        HideEditor;
        Cells[ROldCol,FOldRow] := FOldCellText;
        MoveColRow(FOldCol,FOldRow,True,True);
        FValidating := False;
        FEditing := True;
        ShowInplaceEdit;
        if FOldCol <> Col then
          InvalidateEditor;
      end;

      FModified := FOldModifiedValue;
    end
    else
    begin
      Cells[ROldCol,FOldRow] := Value;
    end;

    FOldCellText := Cells[ROldCol,FOldRow];
  end;

  InitValidate(Col,Row);
  FValidating := False;
  Result := Valid;
end;


procedure TAdvStringGrid.WMSetCursor(var Msg: TWMSetCursor);
begin
  if (FMouseSelectMode <> msNormal) and not
     (FGridState in [gsColSizing,gsRowSizing])
  then
  begin
   case FMouseSelectMode of
   msAll,msResize: SetCursor(LoadCursor(HInstance,MakeIntResource(crAsgCross)));
   msRow: SetCursor(LoadCursor(HInstance,MakeIntResource(crHorzArr)));
   msColumn: SetCursor(LoadCursor(HInstance,MakeIntResource(crVertArr)));
   end;
  end
  else
    inherited;

  if FSizeFixed then
    SetCursor(Screen.Cursors[crHSplit]);
end;


procedure TAdvStringGrid.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  if FCtrlDown then
  begin
    FCtrlDown := False;
    RepaintCell(FCtrlXY.X,FCtrlXY.Y);
  end;
end;

procedure TAdvStringGrid.WMSetFocus(var Msg: TWMSetFocus);
begin
  if InvokedFocusChange then Exit;

  inherited;

  if HasCheckBox(Col,Row) then
    Exit;

  if FInplaceRichEdit.Visible then
  begin
    HideInplaceEdit;
  end;

  if Assigned(NormalEdit) then
  begin
    if (Msg.FocusedWnd <> NormalEdit.Handle) and
       not (FGridstate in [gsColMoving,gsRowMoving]) and
        FNavigation.AlwaysEdit and (EditControl = edNormal) then
    begin
      ShowInplaceEdit;
      Msg.Result := 0;
      Exit;
    end;
  end
  else
    if FNavigation.AlwaysEdit then
    begin
      ShowInplaceEdit;
    end;

  if ((RowCount=1) and (FixedRowAlways)) or
     ((ColCount=1) and (FixedColAlways)) then HideSelection;
end;

procedure TAdvStringGrid.DoEnter;
begin
  if FBlockFocus then Exit;
  try
    inherited DoEnter;
    // FEntered := True;
    SelectCell(Col,Row);
  finally
    InitValidate(Col,Row);
  end;
end;

procedure TAdvStringGrid.DoExit;
begin
  inherited DoExit;
end;

procedure TAdvStringGrid.CMDialogChar(var Msg: TCMDialogChar);
begin
  if ssAlt in KeyDataToShiftState(Msg.KeyData) then
    inherited
  else
  begin
    Msg.CharCode := 0;
    Msg.Result := 0;
  end;
end;

Procedure TAdvStringGrid.CMHintShow(Var Msg: TMessage);
{$IFNDEF DELPHI3_LVL}
type
  PHintInfo = ^THintInfo;
{$ENDIF}
var
  CanShow: Boolean;
  hi: PHintInfo;
{$IFNDEF DELPHI3_LVL}
  s: string;
{$ENDIF}

Begin
  CanShow := True;
  hi := PHintInfo(Msg.LParam);
{$IFNDEF DELPHI3_LVL}
  s := self.Hint;
  ShowHintProc(s,CanShow,hi^);
  self.Hint := s;
{$ELSE}
  ShowHintProc(hi.HintStr,CanShow,hi^);
{$ENDIF}
  Msg.Result := Ord(Not CanShow);
end;

procedure TAdvStringGrid.CMCursorChanged(var Message: TMessage);
begin
  inherited;
  if not InvokedChange then
    FMouseSelectMode := msNormal;
  InvokedChange := False;
end;

procedure TAdvStringGrid.BeginUpdate;
begin
  Inc(FUpdateCount);
  //++ 2.4.0.3
  SendMessage(Handle,WM_SETREDRAW,integer(False),0);
  //-- 2.4.0.3
end;

procedure TAdvStringGrid.StartUpdate;
begin
  Inc(FUpdateCount);
end;


procedure TAdvStringGrid.EndUpdate;
begin
  if FUpdateCount > 0 then Dec(FUpdateCount);
  if FUpdateCount = 0 then
  begin
    //++ 2.4.0.3
    SendMessage(Handle,WM_SETREDRAW,integer(True),0);
    //-- 2.4.0.3
    InvalidateRect(Handle, Nil, False);
    NCPaintProc;
  end;
end;

procedure TAdvStringGrid.ResetUpdate;
begin
  FUpdateCount := 0;
end;

Function TAdvStringGrid.GetLockFlag : Boolean;
begin
  Result := FUpdateCount <> 0;
end;

procedure TAdvStringGrid.SetLockFlag(AValue : Boolean);
begin
  if AValue then
    BeginUpdate
  else
    EndUpdate;
end;

procedure TAdvStringGrid.WMTimer(var Msg: TWMTimer);
var
  lp: TPoint;
  ACol,ARow: Longint;
  r: TRect;
  i,j: Integer;

begin
  if (msg.TimerID = FGridTimerID) then
  begin
     if FHovering and not (csDesigning in Componentstate)  then
     begin
       GetCursorPos(lp);
       if WindowFromPoint(lp)=self.Handle then
       begin
         r := GetClienTRect;
         lp := ScreenToClient(lp);
         if PtInRect(r,lp) then
         begin
           MouseToCell(lp.x,lp.y,ACol,ARow);
           if (ACol>=FixedCols) and (ARow>=FixedRows) and (ACol<ColCount) and (ARow<RowCount) then
           begin
             SetFocus;
             Row := ARow;
             Col := ACol;
           end;
         end;
       end;
     end;

     if FEnableBlink then
     begin
       FGridBlink := not FGridBlink;

       for i := TopRow to TopRow + VisibleRowCount do
         for j := LeftCol to LeftCol + VisibleColCount do
         begin
           if (FIPos('<BLI',Cells[j,i])>0) then RepaintCell(j,i);
         end;

       for i := 0 to FixedRows - 1 do
         for j := LeftCol to LeftCol+VisibleColCount do
         begin
           if (FIPos('<BLI',Cells[j,i])>0) then RepaintCell(j,i);
         end;

       for i := 0 to FixedCols - 1 do
         for j := TopRow to TopRow + VisibleRowCount do
         begin
           if (FIPos('<BLI',Cells[i,j])>0) then RepaintCell(i,j);
         end;
      end;  
    end
  else
    inherited;
end;

procedure TAdvStringGrid.WMPaint(var Msg: TWMPaint);
begin
  if FUpdateCount > 0 then
    Msg.Result := 0
  else
    inherited;
end;

procedure TAdvStringGrid.WMEraseBkGnd(var Message: TMessage);
begin
  Message.Result := 0;
  Exit;
  
  if FUpdateCount > 0 then
    Message.Result := 0
  else
    inherited;
end;

procedure TAdvStringGrid.WMSize(var Msg: TWMSize);
var
  r: Double;
  i,tw,sc: Integer;
  us: Boolean;
begin
  us := True;


  if FColumnSize.FStretch then
  begin
    tw := 0;
    sc := FColumnSize.StretchColumn;
    if sc = -1 then
      sc := ColCount - 1;

    for i := 1 to ColCount do
      if i - 1 <> sc then
      tw := tw + ColWidths[i - 1];

    if tw < Width then
    begin
      StretchColumn(FColumnSize.StretchColumn);
      us := False;
    end;

    ShowScrollbar(Handle,SB_HORZ,(tw + ColWidths[sc] > Width ));

    // added in v2.3.0.6
    ShowScrollbar(Handle,SB_VERT,RowCount - FixedRows > VisibleRowCount);
    // end added in v2.3.0.6

    if not us then
      Exit;
  end;

  inherited;

  if (FOldSize > 0) and (FColumnSize.FSynchWithGrid) then
  begin
    HideInplaceEdit;
    r := Msg.Width / FOldSize;
    for i := 1 to ColCount do
      ColWidths[i - 1] := Round(ColWidths[i - 1] * r);
  end;

  FOldSize := Msg.Width;

  if us then
  begin
    UpdateVScrollBar;
    UpdateHScrollBar;
    FlatShowScrollBar(SB_HORZ,VisibleColCount + FixedCols < ColCount);
    FlatShowScrollBar(SB_VERT,VisibleRowCount + FixedRows < RowCount);
  end;
end;

procedure TAdvStringGrid.WMChar(var Msg: TWMChar);
var
  r: TRect;
  rc: Integer;
begin
  if FMouseActions.RangeSelectAndEdit and not HasStaticEdit(Col,Row) and IsEditable(Col,Row) then
  begin

    Options := Options + [goEditing];
    r := CellRect(Col,Row);
    MouseDown(mbLeft,[],r.Left + 2,r.Top + 2);
    inherited;
    Exit;
  end;

  if (Msg.CharCode = Ord('.')) and FExcelStyleDecimalSeparator and
     (Msg.KeyData and $400000 = $400000) then
  begin
    Msg.CharCode := Ord(DecimalSeparator);
  end;

  rc := RealCol;

  if HasStaticEdit(rc,Row) then
  begin
    //if (Char(Msg.CharCode) = #32) and (HasStaticEdit(RealCol,Row)) then

    if not (Msg.CharCode in [VK_RETURN]) then
      Msg.CharCode := 0;
  end;

  if (goEditing in Options) and
     (Char(Msg.CharCode) in [^H, #32..#255]) then
  begin
    FStartEditChar := Char(Msg.CharCode);
    if not HasStaticEdit(rc,Row) then
      ShowEditorChar(Char(Msg.CharCode));
  end
  else
    inherited;
end;

procedure TAdvStringGrid.TabEdit(Dir: Boolean);
begin
  if Dir then
  begin
    if Navigation.TabAdvanceDirection = adLeftRight then
    begin
      if Col > FixedCols then
        Col := Col - 1
      else
      begin
        Col := ColCount - FixedRightCols - 1;
        if Row > FixedRows then
          Row := Row - 1
        else
          Row := RowCount - FixedFooters - 1;
      end;
    end
    else
    begin
      if Row > FixedRows then
        Row := Row - 1
      else
      begin
        Row := RowCount - FixedFooters - 1;
        if Col > FixedCols then
          Col := Col - 1
        else
          Col := ColCount - FixedRightCols - 1;
      end;
    end;
  end
  else
  begin
    if Navigation.TabAdvanceDirection = adLeftRight then
    begin
      if Col + CellSpan(Col,Row).X + 1 < ColCount - FixedRightCols  then
        Col := Col + CellSpan(Col,Row).X + 1
      else
      begin
        Col := FixedCols;
        if Row < RowCount - FixedFooters - 1 then
          Row := Row + 1
        else
        begin
          Row := FixedRows;
          if (Parent is TWinControl) and Navigation.TabToNextAtEnd then
          begin
            PostMessage((Parent as TWinControl).Handle,WM_KEYDOWN,VK_TAB,0);
          end;
        end;
      end;
    end
    else
    begin
      if Row + CellSpan(Col,Row).Y + 1 < RowCount - FixedFooters  then
        Row := Row + CellSpan(Col,Row).Y + 1
      else
      begin
        Row := FixedRows;
        if Col < ColCount - FixedRightCols - 1 then
          Col := Col + 1
        else
        begin
          Col := FixedCols;
          // tab to next control here
          if (Parent is TWinControl) and Navigation.TabToNextAtEnd then
          begin
            PostMessage((Parent as TWinControl).Handle,WM_KEYDOWN,VK_TAB,0);
          end;
        end;
      end;
    end;
  end;

  if Navigation.AlwaysEdit then
    SetFocus;
end;

procedure TAdvStringGrid.WMKeyUp(var Msg: TWMKeyDown);
begin
  inherited;
end;

procedure TAdvStringGrid.WMKeydown(var Msg: TWMKeyDown);
const
  VK_C = $43;
  VK_V = $56;
  VK_X = $58;
  VK_A = $41;

var
  CanEdit,Chk: Boolean;
  Allow: Boolean;
  SelCol,SelRow,CurRow,RCol,NewIdx: Integer;
  IsCtrl,IsShift: Boolean;
  OldLeftCol: Integer;

begin
  OldLeftCol := LeftCol;

  FMoveSelection := Selection;
  SelCol := Col;
  SelRow := Row;
  RCol := RemapCol(Col);

  IsCtrl := GetKeyState(VK_CONTROL) and $8000 = $8000;
  IsShift := GetKeyState(VK_SHIFT) and $8000 = $8000;

  if (Msg.CharCode = VK_SPACE) then
  begin
    if HasStaticEdit(RCol,Row) then
    begin
      Canedit := (goEditing in Options) or (MouseActions.RangeSelectAndEdit);
      GetCellReadOnly(RCol,Row,CanEdit);

      if CanEdit then
      begin
        if HasCheckBox(RCol,Row) then
        begin
          ToggleCheck(RCol,Row,True);
          GetCheckBoxState(RCol,Row,Chk);
          if Assigned(FOnCheckBoxClick) then
            FOnCheckBoxClick(Self,RCol,Row,Chk);
        end;
        if IsRadio(RCol,Row) then
        begin
          ToggleRadio(RCol,Row,True);
          GetRadioIdx(RCol,Row,NewIdx);
          if Assigned(FOnRadioClick) then
            FOnRadioClick(Self,RCol,Row,NewIdx);
        end;

        RepaintCell(Col,Row);
      end;
    end;

  end;

  if (Msg.CharCode = VK_HOME) and (FNavigation.HomeEndKey = heFirstLastRow) then
  begin
    Row := FixedRows;
    SelectBaseCell;
    Msg.Result := 0;
    Exit;
  end;

  if (Msg.CharCode = VK_HOME) and (FNavigation.HomeEndKey = heFirstLastColumn) and
     (goRowSelect in Options) then
  begin
    Col := FixedCols;
    SelectBaseCell;
    LeftCol := FixedCols;
    Msg.Result := 0;
    Exit;
  end;

  if (Msg.CharCode = VK_END) and (FNavigation.HomeEndKey = heFirstLastRow) then
  begin
    if FFloatingFooter.Visible and (RowCount > 2) then
      Row := RowCount - 2
    else
      Row := RowCount - 1 - FixedFooters;

    SelectBaseCell;
    Msg.Result := 0;
    Exit;
  end;

  if (Msg.CharCode = VK_END) and (FNavigation.HomeEndKey = heFirstLastColumn) and
     (goRowSelect in Options) then
  begin
    Col := ColCount - 1;
    SelectBaseCell;
    LeftCol := ColCount - VisibleColCount;
    Msg.Result := 0;
    Exit;
  end;


  if (Msg.CharCode = VK_TAB) and (goTabs in Options) then
  begin
    // if IsMergedCell(Col,Row) then
    // begin
      TabEdit(GetKeyState(VK_SHIFT) and $8000 = $8000);
      Exit;
    // end;
  end;

  inherited;

  if (Msg.CharCode in [VK_UP,VK_DOWN,VK_PRIOR,VK_NEXT]) and (goRowSelect in Options)
    and FNavigation.KeepHorizScroll then
  begin
    StartUpdate;
    LeftCol := OldLeftCol;
    ResetUpdate;
  end;


  if ((FMoveSelection.Top <> Selection.Top) or
     (FMoveSelection.Right <> Selection.Right) or
     (FMoveSelection.Bottom <> Selection.Bottom) or
     (FMoveSelection.Left <> Selection.Left)) and FSelectionRectangle then
  begin
    InvalidateGridrect(Selection);
    FMoveSelection := Selection;
  end;

  if (Msg.CharCode = VK_X) and
     FNavigation.AllowClipboardShortCuts and
     IsCtrl then
  begin
    Allow := True;
    if Assigned(FOnClipboardCut) then
      FOnClipboardCut(self,Allow);
    if Allow then CutSelectionToClipboard;
    Exit;
  end;

  if (Msg.CharCode = VK_V) and
     FNavigation.AllowClipboardShortCuts and
     IsCtrl then
  begin
    Allow := True;
    if Assigned(FOnClipboardPaste) then FOnClipboardPaste(self,Allow);
    if Allow then PasteSelectionFromClipboard;
    Exit;
  end;

  if (msg.CharCode in [VK_INSERT,VK_C]) and
     FNavigation.AllowClipboardShortCuts and
     IsCtrl then
  begin
    Allow := True;
    if Assigned(FOnClipboardCopy) then
      FOnClipboardCopy(Self,Allow);
    if Allow then CopySelectionToClipboard;
    Exit;
  end;

  if (msg.CharCode = VK_INSERT) and
     FNavigation.AllowClipboardShortCuts and
     IsShift then
  begin
    Allow := True;
    if Assigned(FOnClipboardPaste) then
      FOnClipboardPaste(Self,Allow);
    if Allow then PasteSelectionFromClipboard;
    Exit;
  end;

  if (Msg.CharCode = VK_DELETE) and
     FNavigation.AllowClipboardShortCuts and
     IsShift then
  begin
    Allow := True;
    if Assigned(FOnClipboardCut) then
      FOnClipboardCut(Self,Allow);
    if Allow then CutSelectionToClipboard;
    Exit;
  end;

  if (Msg.CharCode = VK_INSERT) and
     FNavigation.AllowInsertRow and
     not IsCtrl and not IsShift and
     (GetKeystate(VK_MENU) and $8000 = 0) then
  begin
    Allow := True;
    if Assigned(FOnCanInsertRow) then
      FOnCanInsertRow(Self, Row, Allow);
    if not Allow then Exit;
    if FNavigation.InsertPosition = pInsertAfter then
    begin
      if not (FixedRowAlways and (FixedRows = RowCount)) then
      begin
        if Row < RowCount then
        begin
          DoInsertRow(Row + 1);
          Row := Row + 1;
        end
        else
        begin
          DoInsertRow(Row);
          Row := Row;
        end;
      end
      else
      begin
        DoInsertRow(Row);
        Row := 1;
      end;
    end
    else
    begin
      DoInsertRow(Row);
    end;
    CalcFooter(-1);
  end;

  if (msg.CharCode = VK_A) and
     IsCtrl then
  begin
    if (goRowSelect in Options) and (goRangeSelect in Options) then
    begin
      Selection := TGridRect(Rect(FixedCols,FixedRows,
        ColCount - FixedRightCols - 1,RowCount - FixedFooters - 1));
    end;
    Exit;
  end;


  if (Msg.CharCode in [VK_DOWN,VK_UP,VK_LEFT,VK_RIGHT,VK_HOME,VK_END,VK_PRIOR,VK_NEXT]) and
    MouseActions.DisjunctRowSelect then
  begin
    if not IsShift and not IsCtrl then
      ClearRowSelect;

    if IsShift then
      SelectToRowSelect(True)
    else
      RowSelect[Row] := True;
  end;

  if (Msg.CharCode in [VK_DOWN,VK_UP,VK_LEFT,VK_RIGHT,VK_HOME,VK_END,VK_PRIOR,VK_NEXT]) and
    MouseActions.DisjunctColSelect then
  begin
    if not IsShift and not IsCtrl then
      ClearColSelect;

    if IsShift then
      SelectToColSelect(True)
    else
      ColSelect[Col] := True;
  end;

  if (Msg.CharCode = VK_SPACE) and
    MouseActions.DisjunctRowSelect then
  begin
    RowSelect[Row] := not RowSelect[Row];
  end;

  if (Msg.CharCode = VK_SPACE) and
    MouseActions.DisjunctColSelect then
  begin
    ColSelect[Col] := not ColSelect[Col];
  end;

  if (Msg.CharCode = VK_DELETE)
     and (FNavigation.AllowDeleteRow)
     and (GetKeystate(VK_MENU) and $8000 = 0) then
  begin
    if (RowCount - FixedFooters - FixedRows >= 1) or
       ((RowCount - FixedFooters - FixedRows = 1) and FixedRowAlways) then
    begin
      CurRow := Row;

      Allow := True;

      if Assigned(FOnCanDeleteRow) then
        FOnCanDeleteRow(self, Row, Allow);

      if not Allow then Exit;

      DoDeleteRow(CurRow);

      CalcFooter(-1);
    end;
  end;


  if (Msg.CharCode = VK_TAB) and (goTabs in Options) then
  begin

    if (FixedRightCols > 0) and (SelCol = ColCount + NumHiddenColumns - FixedRightCols - 1) then
    begin
      if SelRow = RowCount - FixedFooters - 1 then
        Row := FixedRows
      else
        if Row + 1 < RowCount then
          Row := Row + 1;

      Col := FixedCols;
    end;

  end;
end;

procedure TAdvStringGrid.WMRButtonDown(var Msg: TWMRButtonDown);
var
  x,y:longint;
begin
  inherited;

  MouseToCell(Msg.xpos,Msg.ypos,x,y);
  if Assigned(FOnRightClickCell) then
    FOnRightClickCell(Self,y,x);

  if (x < 0) or (y < 0) then
    Exit;

  if URLShow and URLEdit then
  begin
    if IsURL(Cells[RemapCol(x),y]) then
    begin
      Col := x;
      Row := y;
      ShowEditor;
    end;
  end;

end;

procedure TAdvStringGrid.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  x,y: LongInt;
  r: TRect;
  Allow: Boolean;
begin
  MouseToCell(Message.XPos,Message.YPos,x,y);

  if (y = 0) and (goColSizing in Options) then
  begin
    r := CellRect(x,y);
    if Abs(Message.XPos - r.Left) < 4 then
    begin
      FDblClk := True;
      if x - 1 >= FixedCols then
      begin
        Allow := True;
        {$IFDEF DELPHI4_LVL}
        if Assigned(OnColumnSize) then
          OnColumnSize(Self,x - 1,Allow);
        {$ENDIF}
        if Allow then
        begin
          AutoSizeCol(x - 1);
          if Assigned(FOnEndColumnSize) then
            FOnEndColumnSize(Self,x);
        end;
        Exit;
      end;
    end;

    if Abs(Message.XPos - r.Right) < 4 then
    begin
      if x >= FixedCols then
      begin
        FDblClk := True;
        Allow := True;
        {$IFDEF DELPHI4_LVL}
        if Assigned(OnColumnSize) then
          OnColumnSize(Self,x,Allow);
        {$ENDIF}
        if Allow then
        begin
          AutoSizeCol(x);
          if Assigned(FOnEndColumnSize) then
            FOnEndColumnSize(Self,x);
        end;
        Exit;
      end;
    end;
  end;

  inherited;

  if Assigned(FOnDblClickCell) then
    FOnDblClickCell(Self,y,x);

  if (x >= 0) and (y >= 0) then
  begin
    if FMouseActions.RangeSelectAndEdit and IsEditable(x,y) then
    begin
      Options := Options + [goEditing];
      MouseDown(mbleft,[],message.XPos,message.YPos);
    end;
  end;
end;

procedure TAdvStringGrid.ColumnMoved(FromIndex, ToIndex: longint);
var
  cw,i,ii: Integer;
  cv: Boolean;
  Rfi,Rti: Integer;

begin
  Rfi := RemapCol(FromIndex);
  Rti := RemapCol(ToIndex);

  if (FColumnOrder.Count > FromIndex) and
     (FColumnOrder.Count > ToIndex) then
  begin
    ii := FColumnOrder.Items[FromIndex];
    FColumnOrder.Delete(FromIndex);
    FColumnOrder.Insert(ToIndex,ii);
  end;

  if FNumHidden > 0 then
  begin
    inherited ColumnMoved(Rfi,Rti);
  end
  else
    inherited ColumnMoved(FromIndex,ToIndex);

  if FEnhRowColMove then
  begin
    cw := ColWidths[FromIndex];
    for i := FromIndex to ColCount - 2 do
      ColWidths[i] := ColWidths[i + 1];
    for i := ColCount - 1 downto ToIndex + 1 do
      ColWidths[i] := ColWidths[i - 1];
    ColWidths[ToIndex] := cw;

    if FNumHidden > 0 then
    begin
      cv := FVisibleCol[Rfi];

      for i := Rfi to ColCount + FNumHidden - 2 do
        FVisibleCol[i] := FVisibleCol[i + 1];

      for i := ColCount  + FNumHidden - 1 downto Rti + 1 do
        FVisibleCol[i] := FVisibleCol[i - 1];
      FVisibleCol[Rti] := cv;

      cw := FAllColWidths[Rfi];
      for i := Rfi to ColCount + FNumHidden - 2 do
        FAllColWidths[i] := FAllColWidths[i + 1];

      for i := ColCount + FNumHidden - 1 downto Rti + 1 do
        FAllColWidths[i] := FAllColWidths[i - 1];
      FAllColWidths[Rti] := cw;
    end;

    ColMoveflg := True;
  end;

  if Rfi = FSortSettings.Column then
    FSortSettings.Column := Rti
  else
  begin
    if (Rfi < FSortSettings.Column) and (Rti > FSortSettings.Column) then
      FSortSettings.Column := FSortSettings.Column - 1
    else
    begin
      if (Rfi > FSortSettings.Column) and (Rti <= FSortSettings.Column) then
        FSortSettings.Column := FSortSettings.Column + 1;
    end;
  end;
  
  {$WARNINGS OFF}
  if SortSettings.IndexShow then
  begin
    for i := 1 to SortIndexes.Count do
    begin
      ii := SortIndexes.Items[i - 1] and $FFFF;
      if ii = Rfi then
        SortIndexes.Items[i - 1] := SortIndexes.Items[i - 1] and $FFFF0000 or Rti
      else
      begin
        if (Rfi < ii) and (Rti > ii) then
        SortIndexes.Items[i - 1] := SortIndexes.Items[i - 1] and $FFFF0000 or (ii - 1)
        else
        begin
          if (Rfi > ii) and (Rti <= ii) then
            SortIndexes.Items[i - 1] := SortIndexes.Items[i - 1] and $FFFF0000 or (ii + 1);
        end;
      end;
    end;
  end;
  {$WARNINGS ON}  

  if Rfi = Col then
    Col := Rti
  else
    if (Rfi < Col) and (Rti > Col) then
      Col := Col - 1
    else
    begin
      if (Rfi > Col) and (Rti <= Col) then
        Col := Col + 1;
    end;
end;

procedure TAdvStringGrid.RowMoved(FromIndex, ToIndex: longint);
var
  rh: Integer;
  i: Integer;

begin
  inherited RowMoved(FromIndex,ToIndex);

  if FEnhRowColMove then
  begin
    rh := RowHeights[FromIndex];
    for i := FromIndex to RowCount - 2 do
       RowHeights[i] := RowHeights[i + 1];
    for i := RowCount - 1 downto ToIndex + 1 do
       RowHeights[i] := RowHeights[i - 1];
    RowHeights[ToIndex] := rh;

    ColMoveFlg := True;
  end;
end;

procedure TAdvStringGrid.WMRButtonUp(var Msg:TWMLButtonUp);
begin
  // MouseUp stops colmove / rowmove on both left & right button up !!
  if (Screen.Cursor = crDrag) and
     (FGridstate in [gsColMoving,gsRowMoving]) and FEnhRowColMove then
  begin
    Msg.Result := 0;
  end
  else
    inherited;
end;

procedure TAdvStringGrid.WMLButtonUp(var Msg:TWMLButtonUp);
var
  x,y,cx,cy,displx: Longint;
  idx: Integer;
  doit,chk, WasMove: Boolean;
  r: TRect;
  gr: TGridRect;
  FIsSizing: Boolean;
  lc: Integer;

begin
  ColMoveFlg := False;
  ColSizeFlg := False;
  FMouseDown := False;
  FMouseSelectMode := msNormal;

  if FCtrlDown = True then
  begin
    FCtrlDown := False;
    InvalidateCell(FCtrlXY.X,FCtrlXY.Y);
  end;

  FMouseDownMove := False;
  FMouseSelectStart := -1;

  {$IFDEF DELPHI3_LVL}
  if not (csDesigning in ComponentState) then
  begin
    ArwU.visible := False;
    ArwD.visible := False;
    ArwL.visible := False;
    ArwR.visible := False;
  end;
  {$ENDIF}

  if FSizingFixed then
  begin
    FSizeFixed := False;
    FSizingFixed := False;
    ColWidths[0] := Msg.XPos;
  end;

  if FFixedCellPushed then
  begin
    DrawEdge(Canvas.Handle,FPushedFixedCell, BDR_RAISEDINNER,BF_RIGHT or BF_BOTTOM);
    DrawEdge(Canvas.Handle,FPushedFixedCell, BDR_RAISEDINNER,BF_LEFT or BF_TOP);
    FFixedCellPushed := False;
  end;

  if FPushedCellButton.x <> -1 then
  begin
    PushButton(FPushedCellButton.x,FPushedCellButton.y,False);
    if Assigned(FOnButtonClick) then
      FOnButtonClick(Self,FPushedCellButton.x,FPushedCellButton.y);
    FPushedCellButton := Point(-1,-1);
    ReleaseCapture;
    inherited;
    Exit;
  end;



  if ((csDesigning in ComponentState) or FHintShowSizing) and FScrollHintShow then
  begin
    FScrollHintWnd.ReleaseHandle;
    FScrollHintShow := False;
  end;

  MouseToCell(Msg.XPos,Msg.YPos,x,y);
  displx := x;

  if (x <> -1) and (y <> -1) then
  begin
    if HasButton(x,y) then
    begin
      if PtInRect(ButtonRect(x,y),Point(Msg.XPos,Msg.YPos)) then
        Exit;
    end;
  end;


  FIsSizing := False;
  if (y < FixedRows) and (x >= 0) and (goColSizing in Options) then
  begin
    FIsSizing := GetCursor = Screen.Cursors[crHSplit];
  end;

  if Assigned(OnClick) and not FIsSizing then
    OnClick(Self);

  if FGridState = gsSelecting then
    FGridState := gsNormal;

  if FSelectionClick then
  begin
    FSelectionClick := False;

    if (y >= FixedRows) and (x >= FixedCols) then
    begin
      if goRowSelect in Options then
      begin
        gr.Top := y;
        gr.Left := FixedCols;
        gr.Bottom := y;
        gr.Right := ColCount - 1;
      end
      else
      begin
        gr.Top := y;
        gr.Left := x;
        gr.Bottom := y;
        gr.Right := x;
      end;

      if Assigned(FRowIndicator) and (FixedCols > 0) then
        RepaintCell(0,Row);

      Selection := gr;

      if Assigned(FRowIndicator) and (FixedCols > 0) then
        RepaintCell(0,Row);
    end;
  end;

  if (FMouseActions.DisjunctRowSelect) then
  begin
    SelectToRowSelect(False);
    if ( y >= FixedRows) and (y < RowCount - FFixedFooters) then
    begin
      if FDeselectState then
        RowSelect[y] := False;
    end;
    FDeselectState := False;
  end;

  if (FMouseActions.DisjunctColSelect) then
  begin
    SelectToColSelect(False);
    if ( x >= FixedCols) and (x < ColCount - FFixedRightCols) then
    begin
      if FDeselectState then
        ColSelect[x] := False;
    end;
    FDeselectState := False;
  end;


// if fEnhRowColMove and ((x=0) or (y=0)) then LockWindowUpdate(self.Handle);

  WasMove := False;

  if (Screen.Cursor = crDrag) and
     (FGridstate in [gsColMoving,gsRowMoving]) and FEnhRowColMove then
  begin
    Screen.Cursor := crDefault;

    MoveButton.Enabled := False;
    MoveButton.Visible := False;

    if (FGridState = gsColMoving) and (MoveCell >= 0) and
       (x >= FixedCols) and (MoveCell <> x) then
      MoveColumn(MoveCell,x);

    if (FGridState = gsRowMoving) and (MoveCell >= 0) and
       (y >= FixedRows) and (MoveCell <> y) then
      MoveRow(MoveCell,y);

    if FGridState in [gsRowMoving,gsColMoving] then
      KillTimer(Handle,1);

    FGridState := gsNormal;
    WasMove := True;
  end;

  inherited;

  if FMouseResize then
  begin
    FEditDisable := True;
    PasteSelectionFromClipboard;
    FMouseResize := False;
    FEditDisable := False;
  end;


  if Colmoveflg or Colsizeflg or (x < 0) or (y < 0) or
    ((x < Self.FixedCols) and not FSortSettings.FixedCols) then Exit;

  x := RemapCol(x);

  if HasCheckBox(x,y) then
  begin
    GetCheckBoxState(x,y,chk);
    if Assigned(FOnCheckBoxMouseUp) then
      FOnCheckBoxMouseUp(Self,x,y,Chk);
  end;

  if IsRadio(x,y) then
  begin
    GetRadioIdx(x,y,idx);
    if Assigned(FOnRadioMouseUp) then
      FOnRadioMouseUp(Self,x,y,idx);
  end;

  // Handle here if it is a sortable Column
  Doit := True;

  if FDblClk then
  begin
    FDblClk := False;
    Exit;
  end;

  r := CellRect(displx,y);

  if (y = 0) and (goColSizing in Options) then
  begin
    if (Abs(Msg.xpos - r.Left) < 4)
      or (Abs(Msg.xpos - r.Right) < 4) then Exit;
  end;

  MouseToCell(clickposx,clickposy,cx,cy);

  if ((Msg.Xpos > r.Right - 16) and GetFilter(x)) then
    Exit;

  if (y = FSortSettings.Row) and (cy = FSortSettings.Row) and
     (FixedRows > 0) and
     FSortSettings.Show and not WasMove and
     (RowCount > 2) then
  begin
     if (Assigned(FOnCanSort)) then
       FOnCanSort(self,x,Doit);
  end;

  if (y = FSortSettings.Row) and (cy = FSortSettings.Row) and
     (FixedRows > 0) and
     FSortSettings.Show and
     (RowCount > 2) and
     Doit and not WasMove then
  begin
    HideInplaceEdit;

    if FSortSettings.AutoColumnMerge then
      UndoColumnMerge;

    if FSortSettings.IndexShow then
    begin
      if (GetKeyState(VK_SHIFT) and $8000 = $8000) then
      begin
        if SortIndexes.FindIndex(x)=-1 then SortIndexes.AddIndex(x,True) else
          SortIndexes.ToggleIndex(x);
      end
      else
      begin
        if (SortIndexes.Count=1) and (SortIndexes.FindIndex(x) <> -1) then
          SortIndexes.ToggleIndex(x)
        else
        begin
          SortIndexes.Clear;
          SortIndexes.AddIndex(x,True);
        end;
      end;
      SortTime := GetTickCount;
      QSortIndexed;
      SortTime := GetTickcount - SortTime;
    end
    else
    begin
      if x = FSortSettings.Column then
      begin
        if FSortSettings.Direction = sdAscending then
          FSortSettings.Direction := sdDescending
        else
          FSortSettings.Direction := sdAscending;
      end
      else
      begin
        FSortSettings.Direction := sdAscending;
        FSortSettings.Column := x;
      end;
      SortTime := GetTickCount;

      lc := LeftCol;
      if Navigation.KeepHorizScroll and (goRowSelect in Options) then
        BeginUpdate;

      if FNumNodes > 0 then
        QSortgroup
      else
        QSort;

      if Navigation.KeepHorizScroll and (goRowSelect in Options) then
      begin
        LeftCol := lc;
        EndUpdate;
      end;

      SortTime := GetTickCount - SortTime;
    end;

    if FSortSettings.AutoColumnMerge then
      ApplyColumnMerge;

    if Assigned(FOnClickSort) then
      FOnClickSort(self,FSortSettings.Column);
  end;
end;

procedure TAdvStringGrid.HandleRadioClick(ACol,ARow,Xpos,Ypos: Integer);
var
  cg: TCellGraphic;
  ofs1,ofs2,i,RCol,th: Integer;
  s: string;
  sl: TStrings;
  BC: TPoint;
  RadioSize: Integer;

begin
  GetCellColor(ACol,ARow,[],Canvas.Brush,Canvas.Font);

  BC := BaseCell(ACol,ARow);
  ACol := BC.X;
  ARow := BC.Y;

  cg := GetCellGraphic(ACol,ARow);

  RCol := RemapColInv(ACol);

  Col := RCol;
  Row := ARow;

  ofs1 := 0;
  ofs2 := 0;

  if ControlLook.ControlStyle in [csClassic,csFlat] then
    RadioSize := ControlLook.RadioSize
  else
    RadioSize := 16;

  sl := TStringList(cg.CellBitmap);

  if cg.CellBoolean and Assigned(sl) then
  begin
    for i := 1 to sl.Count do
    begin
      s := sl.Strings[i - 1];

      ofs2 := ofs2 + Canvas.TextWidth(s) + RadioSize + 2;

      if (xpos < ofs2) and (xpos > ofs1) then
      begin
        if cg.CellIndex = -1 then
          Cells[RCol,ARow] := s
        else
          cg.CellIndex := i - 1;

        Cells[RCol,ARow] := Cells[RCol,ARow];

        if Assigned(FOnRadioClick) then
          FOnRadioClick(self,RCol,ARow,i - 1);
        Break;
      end;
      ofs1 := ofs2;
    end;
  end
  else
  begin
    th := Max(RadioSize,Canvas.TextHeight('gh'));
    for i := 1 to sl.Count do
    begin
      ofs2 := ofs2 + th;
      s := sl.Strings[i - 1];

     if (ypos < ofs2) and (ypos > ofs1) then
       begin
         if cg.CellIndex = -1 then
           Cells[RCol,ARow] := s
         else
           cg.CellIndex := i - 1;

        Cells[RCol,ARow] := Cells[RCol,ARow];

        if Assigned(FOnRadioClick) then
          FOnRadioClick(self,RCol,ARow,i - 1);
        Break;
      end;
      ofs1 := ofs2;
    end;
  end;
end;

procedure TAdvStringGrid.WMLButtonDown(var Msg:TWMLButtonDown);
var
  x,y,rx,ml,hl: Integer;
  ClickRect, r, hr,cr: TRect;
  CID,CV,CT: string;
  s,Anchor,Stripped,FocusAnchor: string;
  canedit,chk,comboedit: Boolean;
  xsize,ysize,dropheight: Integer;
  Handle,FixCellClick: Boolean;
  ctt: TTextType;
  cpt: TPoint;
  FOldAlwaysEdit,ClickInSelect: Boolean;
  OldLeftCol,ORow,OCol: Integer;
  OldSel: TGridRect;
  LastCellClicked: Boolean;
begin
  FMouseDownMove := True;

  if (FMouseSelectMode = msResize) then
  begin
    CopySelectionToClipboard;
    FMouseResize := True;
    ORow := Row;
    OCol := Col;
    OldSel := Selection;
    if not (goEditing in Options) then
      inherited;
    Selection := OldSel;
    Col := OCol;
    Row := ORow;
    MouseMove([],Msg.Xpos,Msg.YPos);
    Exit;
  end;

  Searchinc := '';
  FMoveColind := -1;
  FMoveRowind := -1;
  FSelectionClick := False;
  FPushedCellButton := Point(-1,-1);

  OldLeftCol := LeftCol;

  MouseToCell(Msg.XPos,Msg.YPos,X,Y);

  if y = 0 then
    MouseToCell(Msg.XPos - 4,Msg.YPos,ColClicked,RowClicked)
  else
    if x = 0 then
      MouseToCell(Msg.XPos,Msg.YPos - 4,ColClicked,RowClicked)
    else
      MouseToCell(Msg.XPos - 4,Msg.YPos - 4,ColClicked,RowClicked);


  if (ColClicked >= 0) and (RowClicked >= 0) then
  begin
    ColClickedSize := ColWidths[ColClicked];
    RowClickedSize := RowHeights[RowClicked];
  end;

  ClickPosx := Msg.XPos;
  ClickPosy := Msg.YPos;

  FixCellClick := ((Y < FixedRows) or (X < FixedCols)) and (X >= 0) and (Y >= 0);

  if (X <> -1) and (Y <> -1) then
  begin
    cpt := BaseCell(x,y);
    x := cpt.x;
    y := cpt.y;
    ClickRect := CellRect(x,y)
  end
  else
  begin
    HideInplaceEdit;
    inherited;
    Exit;
  end;

  if FMouseActions.CaretPositioning then
    LButFlg := True;

  if FSizeFixed then
  begin
    FSizingFixed := True;
    FSizeFixedX := Msg.XPos;
    DrawSizingLine(FSizeFixedX);
  end;

  if FixCellClick or IsFixed(x,y) then
    HideInplaceEdit;

  FixCellClick := IsFixed(x,y) and not FixCellClick;

  if (x >= 0) and (y >= 0) then
  begin
    if ((y < FixedRows) or (x < FixedCols) or FixCellClick) then
    if (FFixedAsButtons and (goFixedVertLine in Options) and (goFixedHorzLine in Options) and Ctl3D) then
    begin
      FPushedFixedCell := CellRect(x,y);
      FFixedCellPushed := True;
      DrawEdge(Canvas.Handle,FPushedFixedCell, BDR_SUNKENINNER,BF_RIGHT or BF_BOTTOM);
      DrawEdge(Canvas.Handle,FPushedFixedCell, BDR_SUNKENINNER,BF_LEFT or BF_TOP);
    end;
  end;


  rx := RemapCol(x);

  if not (csDesigning in ComponentState) and (x >= 0) and (y >= 0) then
  begin
    if (y >= FixedRows) and (x = 0) then
      if IsNode(y) then
      begin
        if not (GraphicObjects[0,y] as TCellGraphic).CellBoolean then
        begin
          ContractNode(RemapRowInv(y));
          if Assigned(FOnContractNode) then
            FOnContractNode(self,y,RemapRowInv(y));
        end
        else
        begin
          ExpandNode(RemapRowinv(y));
          if Assigned(FOnExpandNode) then
            FOnExpandNode(self,y,RemapRowinv(y));
        end;

        Row := y;
        Exit;
      end;

    if (y >= FixedRows) and (x >= FixedCols) then
      if IsRadio(rx,y) and IsEditable(rx,y) then
      begin
        HideInplaceEdit;
        HandleRadioClick(rx,y,Msg.XPos - ClickRect.Left,Msg.YPos - ClickRect.Top);
        Exit;
      end;

    if (x = 0) and (FNumNodes > 0) then
      Exit;

    {$IFDEF DELPHI4_LVL}
    if (IsSelected(x,y) or
       ((y < FixedRows) and not FEnhRowColMove)) and
       not (goEditing in Options) and
       FDragDropSettings.FOleDropSource and
       not (MouseActions.ColSelect or MouseActions.AllSelect) then
    begin
      if not (((msg.xpos - ClickRect.Left < 4) or (ClickRect.Right - msg.xpos < 4)) and (goColsizing in Options)) then
      begin
        FSelectionClick := True;
        if Assigned(OnClickCell) then
          OnClickCell(self,y,x);
        Exit;
      end;
    end;
    {$ENDIF}

  end;

  if (x >= ColCount) or (y >= RowCount) or (x < 0) or (y < 0) then
  begin
    inherited;
    Exit;
  end;

  if HasButton(rx,y) then
  begin
    HideInplaceEdit;
    Selection := TGridRect(Rect(x,y,x,y));

    if PtInRect(ButtonRect(x,y),Point(Msg.XPos,Msg.YPos)) then
    begin
      PushButton(x,y,True);
      FPushedCellButton := Point(x,y);
      SetCapture(Self.Handle);
    end;
    if Assigned(OnClickCell) then
      OnClickCell(self,y,x);
    Exit;
  end;

  if (ColClicked <> -1) and (RowClicked <> -1) then
    r := CellRect(ColClicked,RowClicked)
  else
    r := Rect(0,0,0,0);

  ClickPosdx := -r.Right + ClickPosx;
  ClickPosdy := -r.Bottom + ClickPosy;

  // if ctrl-pressed / shift pressed
  if (FMouseActions.DisjunctRowSelect) and (y >= FixedRows) then
  begin
    if GetKeystate(VK_CONTROL) and $8000 = $8000 then
    begin
      if RowSelect[y] then FDeselectState := True;
    end
    else
    begin
      FMouseDown := True;
      ClearRowSelect;
    end;
  end;

  if (FMouseActions.DisjunctColSelect) and (x >= FixedCols) then
  begin
    if GetKeystate(VK_CONTROL) and $8000 = $8000 then
    begin
      if ColSelect[x] then FDeselectState := True;
    end
    else
    begin
      FMouseDown := True;
      ClearColSelect;
    end;
  end;


  s := Cells[rx,y];
  ctt := TextType(s,FEnableHTML);

  if URLShow or (ctt = ttHTML) then
  begin
    Anchor := '';
    if (ctt <> ttHTML) and IsURL(s) {$IFDEF CUSTOMIZED} or (pos('*',s)=1) {$ENDIF} then
    begin
      Anchor := s;
    end
    else
    if ctt = ttHTML then
    begin
      r.Left := r.Left + 1 + FXYOffset.X;
      r.Top := r.Top + 1 + FXYOffset.Y;
      if HasCheckBox(rx,y) then
        r.Left := r.Left + ControlLook.CheckSize;
        
      if not HTMLDrawEx(Canvas,s,r,Gridimages,Msg.XPos,Msg.YPos,-1,0,1,
                        True,False,False,False,False,False,not EnhTextSize,False,
                        0.0,FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,
                        XSize,YSize,ml,hl,hr,cr,CID,CV,CT,FImageCache,FContainer,self.Handle) then
        Anchor := '';
    end;

    if Anchor <> '' then
    begin
      Handle := True;

      if CID <> '' then
      begin
        if FCtrlEditing then
          ControlExit(Self);

        if CT = 'BUTTON' then
        begin
          FCtrlXY := Point(rx,y);
          FCtrlDown := True;
          RepaintCell(rx,y);
        end;

        if CT = 'CHECK' then
        begin
          if CV = 'TRUE' then
            SetControlValue(s,CID,'FALSE')
          else
            SetControlValue(s,CID,'TRUE');
          Cells[rx,y] := s;
        end;

        if Assigned(FOnControlClick) then
          FOnControlClick(Self,y,x,CID,CT,CV);

        if CT = 'EDIT' then
        begin
          FCtrlXY := Point(rx,y);
          FCtrlID := CID;
          FCtrlType := CT;

          FCtrlEditing := True;
          FEditControl.Width := 0;


          FEditControl.OnExit := ControlExit;
          FEditControl.Text := CV;
          FEditControl.BorderStyle := bsNone;
          FEditControl.Left := CR.Left + 3;
          FEditControl.Width := CR.Right - CR.Left - 4;
          FEditControl.Top := CR.Top + 5;
          FEditControl.Height := CR.Bottom - CR.Top - 4;
          FEditControl.Parent := Self;
          FEditControl.Visible := True;

          BringWindowToTop(FEditControl.Handle);
          FEditControl.SetFocus;
        end;

        if CT = 'COMBO' then
        begin
          FCtrlXY := Point(rx,y);
          FCtrlID := CID;
          FCtrlType := CT;

          FCtrlEditing := True;

          FComboControl.IsWinXP := FIsWinXP;
          FComboControl.Width := 0;

          ComboEdit := True;
          DropHeight := 8;

          FComboControl.Left := CR.Left + 3;
          FComboControl.Width := CR.Right - CR.Left - 4;
          FComboControl.Top := CR.Top + 5;

          FComboControl.Parent := Self;

          if Assigned(FOnControlComboList) then
            FOnControlComboList(Self,y,x,CID,CT,CV,TStringList(FComboControl.Items),ComboEdit,DropHeight);

          if ComboEdit then
            FComboControl.Style := csDropDown
          else
            FComboControl.Style := csDropDownList;

          if FComboControl.Items.IndexOf(CV) <> -1 then
            FComboControl.ItemIndex := FComboControl.Items.IndexOf(CV);
          FComboControl.Text := CV;
          FComboControl.DropDownCount := DropHeight;

          FComboControl.OnExit := ControlExit;

          FComboControl.Height := FComboControl.ItemHeight * (DropHeight+2);
          FComboControl.Visible := True;
          FComboControl.DroppedDown := True;
          FComboControl.SetFocus;
          // BringWindowToTop(FComboControl.Handle);

        end;

      end
      else
      begin
        if Assigned(FOnAnchorClick) then
          FOnAnchorClick(Self,y,x,Anchor,Handle);
      end;

      if Handle then
        if  Pos('CELL://',Uppercase(Anchor)) > 0 then
        begin
          if NameToCell(Copy(Anchor,8,Length(Anchor)),cpt) then
          begin
            Row := cpt.y;
            Col := cpt.x;
            ScrollInView(cpt.x,cpt.y);
          end;
        end
        else
          ShellExecute(Application.Handle,'open',PChar(Anchor), nil, nil, SW_NORMAL);
        Exit;
    end;
  end;

  MoveCell := -1;

  if (x < FixedCols) and (y < FixedRows) and
     (FMouseActions.AllSelect) and
     (goRangeSelect in Options) and
     (FMouseSelectMode = msAll) then
  begin
    ORow := Selection.Top;
    OCol := Selection.Left;

    SetFocus; // make sure inplace editors are hidden
    HideSelection;
    Selection := TGridRect(Rect(FixedCols,FixedRows,ColCount - 1,RowCount - 1));
    FSelHidden := False;
    DoExit;   // force validatecell call
    if ActiveCellShow then
    begin
      UpdateActiveCells(OCol,ORow,x,y);
    end;
  end;

  if (x < FixedCols) and (y >= FixedRows) and
     (FMouseActions.RowSelect) and
     (goRangeSelect in Options) and
     (FMouseSelectMode = msRow) then
  begin
    ORow := Selection.Top;
    OCol := Selection.Left;

    SetFocus; // make sure inplace editors are hidden
    HideSelection;
    Selection := TGridRect(Rect(FixedCols,y,ColCount - 1,y));
    FSelHidden := False;
    DoExit;   // force validatecell call
    FMouseSelectStart := y;
    if ActiveCellShow then
      UpdateActiveCells(OCol,ORow,x,y);
  end;

  if (x >= FixedCols) and (y < FixedRows) and
     (FMouseActions.ColSelect) and
     (goRangeSelect in Options) and
     (FMouseSelectMode = msColumn) then
  begin
    ORow := Selection.Top;
    OCol := Selection.Left;

    SetFocus; //make sure inplace editors are hidden
    HideSelection;

    Selection := TGridRect(Rect(x,FixedRows,x,RowCount - 1));
    FSelHidden := False;    
    DoExit;   //force validatecell call
    FMouseSelectStart := x;
    if ActiveCellShow then
      UpdateActiveCells(OCol,ORow,x,y);
  end;

  if (x >= FixedCols) and (y < FixedRows) then
    MoveCell := x;

  if (x < FixedCols) and (y >= FixedRows) then
    MoveCell := y;

  r := CellRect(x,y);

  MoveOfsx := Msg.xpos - r.Left;
  MoveOfsy := Msg.ypos - r.Top;

  CanEdit := (goEditing in Options) or MouseActions.RangeSelectAndEdit;

  GetCellReadOnly(rx,y,CanEdit);

  if (x < ColCount) and (y < RowCount) and
     (x >= FixedCols) and (y >= FixedRows) and
     (CanEdit) and HasCheckBox(rx,y) then
  begin
    // hide any other possible active inplace editors
    HideInplaceEdit;
    SetFocus;
    ToggleCheck(rx,y,True);
    GetCheckBoxState(rx,y,chk);
    if Assigned(FOnCheckBoxClick) then
      FOnCheckBoxClick(Self,x,y,chk);

    // move focus to checkbox cell
    if not Navigation.AlwaysEdit then
      MoveColRow(x,y,True,True);

    if FHideFocusRect then
      RepaintCell(x,y);

    Click;
    Exit;
  end;

  if (x >= FixedCols) and
     (y >= FixedRows) and
     CanEdit and FMouseActions.DirectEdit then
  begin
    SetFocus;
    HideEditor;
  end;

  r := CellRect(X,Y);
  ClickInSelect := PtInRect(r,Point(Msg.XPos,Msg.YPos));

  r.Left := BaseCell(X,Y).X;
  r.Top := BaseCell(X,Y).Y;
  r.Right := r.Left;
  r.Bottom := r.Top;

  ClickInSelect := ClickInSelect and EqualRect(TRect(Selection),r);

  FOldAlwaysEdit := FNavigation.AlwaysEdit;

  if FixCellClick then
  begin
    if Assigned(FOnClickCell) then
      FOnClickCell(Self,Y,X);
    Exit;
  end;

  LastCellClicked := (Y = TopRow + VisibleRowCount) or (X = LeftCol + VisibleColCount);

  if not FSelHidden then
  begin
    FNavigation.AlwaysEdit := False;
    inherited;
    FNavigation.AlwaysEdit := FOldAlwaysEdit;
  end;

  // block selecting state on partially visible clicked last row

  if (FGridState = gsSelecting) and LastCellClicked and FMouseActions.NoAutoRangeScroll then
    FGridState := gsnormal;

  if (goRowSelect in Options) and FNavigation.KeepHorizScroll then
  begin
    StartUpdate;
    LeftCol := OldLeftCol;
    ResetUpdate;
  end;

  if Assigned(FOnClickCell) then
    FOnClickCell(Self,Y,X);

  if Assigned(FOnCellValidate) then
  begin
    FEntered := False;
    InitValidate(Col,Row);
  end;

  if IsMergedCell(X,Y) and not IsFixed(X,Y) then
  begin
    Selection := TGridRect(Rect(r.Left,r.Top,r.Right,r.Bottom));
    if ClickInSelect and CanEdit then
      ShowInplaceEdit;
  end;

  r := CellRect(x,y);

  if (Msg.XPos - R.Left) < 4 then
    Exit;

  if (R.Right - Msg.XPos) < 4 then
    Exit;

  if (x >= FixedCols) and
     (y >= FixedRows) and
     CanEdit and
     FMouseActions.DirectEdit and not HasStaticEdit(rx,y) then
     begin
       ShowEditor;
    end;

end;

procedure TAdvStringGrid.ControlExit(Sender: TObject);
var
  s,CV:string;
begin
  if FCtrlType = 'EDIT' then
  begin
    s := Cells[FCtrlXY.X,FCtrlXY.Y];
    CV := FEditControl.Text;
    SetControlValue(s,FCtrlID,CV);
    Cells[FCtrlXY.X,FCtrlXY.Y] := s;
    FEditControl.Visible := False;
  end;

  if FCtrlType = 'COMBO' then
  begin
    s := Cells[FCtrlXY.X,FCtrlXY.Y];
    CV := FComboControl.Text;
    SetControlValue(s,FCtrlID,CV);
    Cells[FCtrlXY.X,FCtrlXY.Y] := s;
    FComboControl.Visible := False;
  end;

  if Assigned(FOnControlEditDone) then
    FonControlEditDone(Self,FCtrlXY.Y,FCtrlXY.X,FCtrlID,FCtrlType,CV);

  FCtrlType := '';  
end;


function TAdvStringGrid.Compare(Col,ARow1,ARow2: Integer): Integer;
var
  AStyle: TSortStyle;
  r1,r2: Double;
  code1,code2: Integer;
  dt1,dt2: TDateTime;
  res,sp: Integer;
  s1,s2:string;
  Prefix,Suffix:string;
  cs1,cs2: Boolean;
  {$IFDEF TMSUNICODE}
  ws1,ws2:widestring;
  {$ENDIF}

begin
  Inc(Compares);

  if FSortSettings.AutoFormat then
    aStyle := ssAutomatic
  else
    aStyle := ssAlphabetic;

  Prefix := '';
  Suffix := '';
  GetColFormat(Col,AStyle,Prefix,Suffix);

  res := 1;

  if AStyle = ssAutomatic then
  begin
    if (CellTypes[Col,ARow1] in [ctCheckBox, ctDataCheckBox,ctVirtCheckBox]) then
      aStyle := ssCheckBox
    else
    begin

      s1 := Cells[Col,ARow1];
      if (IsType(s1) in [atNumeric,atFloat]) then
        aStyle := ssNumeric
      else
      begin
        code1 := pos('/',s1);
        if (code1 > 1) and (Length(s1) > code1) and (code1 < 4) then
        begin
          if (s1[code1 - 1] in ['0'..'9']) and (s1[code1 + 1] in ['0'..'9']) then
            aStyle := ssDate
          else
            aStyle := ssAlphabetic;
        end
        else
          aStyle := ssAlphabetic;
      end;
    end;
  end;

  case aStyle of
  ssAlphabetic,ssAlphaCase:
  begin
    if (Cells[Col,ARow1] > Cells[Col,ARow2]) then
      res := 1
    else
      if (Cells[Col,ARow1] = Cells[Col,ARow2]) then
        res := 0
      else
        res := -1;
  end;
  {$IFDEF TMSUNICODE}
  ssUnicode:
  begin
    ws1 := WideCells[Col,ARow1];
    ws2 := WideCells[Col,ARow2];

    res := CompareStringW(LOCALE_USER_DEFAULT ,NORM_IGNORECASE,PWideChar(ws1),Length(ws1),
      PWideChar(ws2),Length(ws2));
    if res = CSTR_LESS_THAN then res := -1;
    if res = CSTR_EQUAL then res := 0;
    if res = CSTR_GREATER_THAN then res := 1;

  end;
  {$ENDIF}
  ssHTML:
  begin
    s1 := StrippedCells[Col,ARow1];
    s2 := StrippedCells[Col,ARow2];

    if s1 > s2 then
      res := 1
    else
     if s1 = s2 then
       res := 0
     else
       res := -1;
  end;
  ssImages:
  begin
    if GetCellImageIdx(Col,ARow1)>GetCellImageIdx(Col,ARow2) then
      res := 1
    else
      if GetCellImageIdx(Col,ARow1) = GetCellImageIdx(Col,ARow2) then
        res := 0
      else
        res := -1;
  end;
  ssCheckBox:
  begin
    GetCheckBoxState(Col,ARow1,cs1);
    GetCheckBoxState(Col,ARow2,cs2);
    if cs1 and not cs2 then
      res := 1
    else
      if cs1 = cs2 then
        res := 0
      else
        res := -1;
  end;
  ssAlphaNoCase:
  begin
    s1 := UpperCase(Cells[Col,ARow1]);
    s2 := UpperCase(Cells[Col,ARow2]);

    if s1 > s2 then
      res := 1
    else
      if s1 = s2 then
        res := 0
      else
        res := -1;
  end;
  ssAnsiAlphaCase:
  begin
    res := AnsiCompareStr(self.Cells[Col,ARow1],self.Cells[Col,ARow2]);
    if res > 0 then
      res := 1
    else
      if res < 0 then
        res := -1;
  end;
  ssAnsiAlphaNoCase:
  begin
    res := AnsiCompareText(self.Cells[Col,ARow1],self.Cells[Col,ARow2]);
    if res > 0 then
      res := 1
    else
      if res < 0 then
        res := -1;
  end;
  ssNumeric,ssFinancial:
  begin
    s1 := Cells[Col,ARow1];
    s2 := Cells[Col,ARow2];

    if Suffix <> '' then
    begin
     if VarPos(Suffix,s1,sp) > 0 then
       Delete(s1,sp,Length(Suffix));
     if VarPos(Suffix,s2,sp) > 0 then
       Delete(s2,sp,Length(Suffix));
    end;

    if Prefix <> '' then
    begin
      if VarPos(Prefix,s1,sp) > 0 then
        Delete(s1,sp,Length(Prefix));
      if VarPos(Prefix,s2,sp) > 0 then
        Delete(s2,sp,Length(Prefix));
    end;

    if AStyle = ssFinancial then
    begin
      {delete the thousandseparator}
      while VarPos(ThousandSeparator,s1,sp) > 0 do
        Delete(s1,sp,1);
      while VarPos(ThousandSeparator,s2,sp) > 0 do
        Delete(s2,sp,1);
    end;

    if DecimalSeparator <> '.' then
    begin
      if Varpos(Decimalseparator,s1,sp) > 0 then
        s1[sp] := '.';
      if VarPos(DecimalSeparator,s2,sp) > 0 then
        s2[sp] := '.';
    end;

    Val(s1,r1,code1);
    Val(s2,r2,code2);

    if code1 <> 0 then
    begin
      if Cells[Col,ARow1] = '' then
      begin
        r1 := 0;
        code1 := 0;
      end;
    end;

    if code2 <> 0 then
    begin
      if Cells[Col,ARow2] = '' then
      begin
        r2 := 0;
        code2 := 0;
      end;
    end;

    if (code1 <> 0) and (code2 <> 0) then
      res := 0
    else
    begin
      if r1 > r2 then
        res := 1
      else
       if r1 = r2 then
         res := 0
       else
         res := -1;
    end;
  end;

  ssCustom:
  begin
    res := 0;
    if Assigned(FCustomCompare) then
      FCustomCompare(Self,Cells[Col,ARow1],Cells[Col,ARow2],res);
  end;

  ssRaw:
  begin
    res := 0;
    if Assigned(FRawCompare) then
      FRawCompare(self,Col,ARow1,ARow2,res);
  end;

  ssDate,ssShortdateUS,ssShortDateEU:
  begin
    dt1 := 0;
    dt2 := 0;
    s1 := Cells[Col,ARow1];
    s2 := Cells[Col,ARow2];

    case aStyle of
    ssDate:
    begin
      try
        if s1 = '' then
          dt1 := 0
        else
          dt1 := StrToDatetime(s1);
      except
        dt1 := 0;
      end;
      try
        if s2 = '' then
          dt2 := 0
        else
          dt2 := StrToDatetime(s2);
      except
        dt2 := 0;
      end;
    end;
    ssShortDateUS:
    begin
      try
        dt1 := StrToShortDateUS(s1);
      except
        dt1 := 0;
      end;
      try
        dt2 := StrToShortDateUS(s2);
      except
        dt2 := 0;
      end;
    end;
    ssShortDateEU:
    begin
      try
        dt1 := StrToShortDateEU(s1);
      except
        dt1 := 0;
      end;
      try
        dt2 := StrToShortDateEU(s2);
      except
        dt2 := 0;
      end;
    end;
    end;

    if dt1 > dt2 then
      res := 1
    else
      if dt1 = dt2 then
        res := 0
      else
       res := -1;
    end;
  end;

  if FSortSettings.IgnoreBlanks then
  begin
    case FSortSettings.Direction of
    sdAscending:
      begin
        if (Cells[Col,ARow1] = '') and (Cells[Col,ARow2] <> '') then
          if FSortSettings.BlankPos = blFirst then
            res := -1
          else
            res := +1;

        if (Cells[Col,ARow2] = '') and (Cells[Col,ARow1] <> '') then
          if FSortSettings.BlankPos = blFirst then
            res := +1
          else
            res := -1;

      end;
    sdDescending:
      begin
        if (Cells[Col,ARow1] = '') and (Cells[Col,ARow2] <> '') then
          if FSortSettings.BlankPos = blFirst then
            res := +1
          else
            res := -1;

        if (Cells[Col,ARow2] = '') and (Cells[Col,ARow1] <> '') then
          if FSortSettings.BlankPos = blFirst then
            res := -1
          else
            res := +1;

      end;
    end;
  end;

  Compare := res;
end;

function TAdvStringGrid.CompareLine(Col,ARow1,ARow2: Integer): Integer;
var
  res: Integer;
begin
  res := Compare(Col,ARow1,ARow2);

  if (res = 0) and FSortSettings.Full then
  begin
    if Col <= ColCount - 2 then
    begin
      Inc(Col);
      res := CompareLine(Col,ARow1,ARow2);
    end;
  end;

  CompareLine := res;
end;

function TAdvStringGrid.CompareLineIndexed(Colidx,ARow1,ARow2: Integer): Integer;
var
  res: Integer;
  idx: Integer;
begin
  idx := FSortIndexes.Items[Colidx] and $7FFFFFFF;
  res := Compare(idx,ARow1,ARow2);
  if (res = 0) and FSortSettings.Full then
  begin
    if (Colidx < FSortIndexes.Count - 1) then
    begin
      Inc(Colidx);
      res := CompareLineIndexed(Colidx,ARow1,ARow2);
    end;
  end
  else
  begin
    if (FSortIndexes.Items[Colidx] and $80000000 = $80000000) then
    begin
      res := res * -1;
    end;
  end;

  CompareLineIndexed := res;
end;


function TAdvStringGrid.SortLine(Col,ARow1,ARow2: Integer): Boolean;
var
  res: Integer;
begin
  Result := False;

  res := Compare(Col,ARow1,ARow2);

  if res = SortDir then
  begin
    SortSwapRows(ARow1,ARow2);
    Result := True;
  end
  else
    if res = 0 then
    begin
      if Col < ColCount - 1 + NumHiddenColumns then
      begin
        Inc(Col);
        Result := SortLine(Col,ARow1,ARow2);
      end;
    end
    else
      Result := False;
end;

procedure TAdvStringGrid.SortByColumn(Col: Integer);
var
  Idx: Word;
  Changed: Boolean;
begin
  if RowCount < 2 then
    Exit;

  if FSortSettings.Direction = sdAscending then
    SortDir := 1
  else
    SortDir := -1;

  repeat
    Changed := False;
    for Idx := FixedRows to RowCount - 2 - FixedFooters do
    begin
      if SortDir = Compare(Col,Idx,Idx + 1) then
      begin
        SortSwapRows(Idx,Idx + 1);
        Changed := True;
      end;
    end;
  until Changed = False;
end;

procedure TAdvStringGrid.QuickSortRows(Col,Left,Right: Integer);
var
  i,j,k,m: Integer;

begin
  if FSortSettings.Direction = sdAscending then
    SortDir := 1
  else
    SortDir := -1;

  i := Left;
  j := Right;

  if Assigned(OnGetDisplText) or FVirtualCells then
  begin
    m := (Left + Right) shr 1;
    for k := 0 to ColCount - 1 do
      Cells[k, RowCount - 2] := Cells[k,m];
  end
  else
    Rows[RowCount - 2] := Rows[(Left + Right) shr 1];

  repeat
    while (CompareLine(Col,RowCount - 2,i) = SortDir) and (i < Right) do Inc(i);
    while (CompareLine(Col,j,RowCount - 2) = SortDir) and (j > Left) do Dec(j);

    if i <= j then
    begin
      if i <> j then
      begin
        if CompareLine(Col,i,j) <> 0 then
          SortSwapRows(i,j);
      end;
      Inc(i);
      Dec(j);
    end;
  until i > j;

  if Left < j then
    QuickSortRows(Col,Left,j);
  if i < Right then
    QuickSortRows(Col,i,Right);
end;


procedure TAdvStringGrid.QuickSort(Col,Left,Right: Integer);
var
  cw,cc: Integer;
begin
  RowCount := RowCount + 3;

  //necessary to save this due to Delphi 1,2,3 bug in TStringGrid!
  cc := ColCount - 1;
  cw := ColWidths[cc];

  ColCount := ColCount + NumHiddenColumns;

  QuickSortRows(Col,left,right);
  ClearRows(RowCount - 2,2);

  ColCount := ColCount - NumHiddenColumns;
  ColWidths[cc] := cw;
  RowCount := RowCount - 3;
end;

procedure TAdvStringGrid.QuickSortRowsIndexed(Col,Left,Right: Integer);
var
  i,j,k: Integer;
begin
  if FSortSettings.Direction = sdAscending then
    SortDir := 1
  else
    SortDir := -1;

  i := Left;
  j := Right;

  if Assigned(OnGetDisplText) or FVirtualCells then
  begin
    for k := 1 to ColCount do
      Cells[k - 1, RowCount - 2] := Cells[k - 1,(Left + Right) shr 1];
  end
  else
    Rows[RowCount - 2] := Rows[(Left + Right) shr 1];

  repeat
    while (CompareLineIndexed(Col,RowCount - 2,i) = 1) and (i < Right) do Inc(i);
    while (CompareLineIndexed(Col,j,RowCount - 2) = 1) and (j > Left) do Dec(j);
    if i <= j then
    begin
      if i <> j then
        SortSwapRows(i,j);
      Inc(i);
      Dec(j);
    end;
  until i > j;

  if Left < j then
    QuicksortRowsIndexed(Col,Left,j);
  if i < Right then
    QuickSortRowsIndexed(Col,i,Right);
end;


procedure TAdvStringGrid.QuickSortIndexed(Left,Right: Integer);
var
  cw,cc: Integer;

begin
  RowCount := RowCount + 3;
  //necessary to save this due to Delphi 1,2,3 bug in TStringGrid!
  cc := ColCount-1;
  cw := ColWidths[cc];

  ColCount := ColCount + NumHiddenColumns;

  QuickSortRowsIndexed(0,left,right);
  ClearRows(RowCount - 2,2);

  ColCount := ColCount - NumHiddenColumns;
  ColWidths[cc] := cw;
  RowCount := RowCount - 3;
end;

procedure TAdvStringGrid.QSortGroup;
var
  i,j,r1,r2: Integer;
  cw,cc: Integer;
  FCols:TStringList;
begin
  FCols := nil;
  if FSortSettings.NormalCellsOnly and (FixedCols > 0) then
  begin
    FCols := TStringList.Create;
    FCols.Assign(self.Cols[0]);
  end;

  BeginUpdate;
  try
    RowCount := RowCount + 3;
    NormalRowCount := RowCount - 3;

    //necessary to save this due to Delphi 1,2,3 bug in TStringGrid!
    cc := ColCount - 1;
    cw := ColWidths[cc];

    ColCount := ColCount + NumHiddenColumns;
    SortRow := Row;

    if FNavigation.MoveRowOnSort then
      Row := RowCount - 3;

    r1 := 0;
    r2 := 0;
    j := 1;
    for i := 1 to FNumNodes do
    begin
      if IsNode(j) then
      begin
        Inc(j);
        r1 := j;
        while not IsNode(j) and (j < RowCount - 3) do
          Inc(j);

        r2 := j;
      end;

      if r2 - r1 > 1 then
        QuickSortRows(FSortSettings.Column,r1,r2 - 1);
    end;

    //set all added Rows back to Nil}
    FNilObjects := True;
    ClearRows(RowCount - 2,2);
    FNilObjects := False;

    Row := SortRow;
    ColCount := ColCount - NumHiddenColumns;
    ColWidths[cc] := cw;
    RowCount := RowCount - 3;
  finally
    if FSortSettings.NormalCellsOnly and (FixedCols > 0) then
    begin
      Cols[0].Assign(FCols);
      FCols.Free;
    end;
    EndUpdate;
  end;
end;


procedure TAdvStringGrid.QSort;
var
  cw,cc,cr: Integer;
  enterstate: Boolean;
  FCols: TStringList;

begin
  //clear previous sort indexes if QSortIndexed was executed before
  SortIndexes.Clear;

  FCols := nil;
  if FSortSettings.NormalCellsOnly and (FixedCols > 0) then
  begin
    FCols := TStringList.Create;
    FCols.Assign(self.Cols[0]);
  end;

  BeginUpdate;
  try
    RowCount := RowCount + 3;
    NormalRowCount := RowCount - 3;

    //necessary to save this due to Delphi 1,2,3 bug in TStringGrid!
    cc := ColCount-1;
    cw := ColWidths[cc];

    ColCount := ColCount + NumHiddenColumns;
    SortRow := Row;
    cr := Row;

    if FNavigation.MoveRowOnSort then
      Row := RowCount - 3;

    QuickSortRows(FSortSettings.Column,FixedRows,(RowCount - 1) - 3 - FFixedFooters);

    FNilObjects := True;
    ClearRows(RowCount - 2,2);
    FNilObjects := False;

    Enterstate := FEntered;
    FEntered := False;

    if FNavigation.MoveRowOnSort then
      Row := SortRow
    else
      Row := cr;

    FEntered := Enterstate;

    ColCount := ColCount - NumHiddenColumns;
    ColWidths[cc] := cw;
    RowCount := RowCount - 3;
  finally
    if FSortSettings.NormalCellsOnly and (FixedCols > 0) then
    begin
      Cols[0].Assign(fCols);
      FCols.Free;
    end;
    EndUpdate;
  end;
end;

procedure TAdvStringGrid.QSortIndexed;
var
  cw,cc,cr: Integer;
  enterstate: Boolean;
  FCols: TStringList;

begin
  if SortIndexes.Count = 0 then
    raise EAdvGridError.Create('No indexes specified for indexed sort');

  FCols := nil;
  if FSortSettings.NormalCellsOnly and (FixedCols > 0) then
  begin
    FCols := TStringList.Create;
    FCols.Assign(self.Cols[0]);
  end;


  BeginUpdate;
  try
    RowCount := RowCount + 3;
    NormalRowCount := RowCount - 3;

    //necessary to save this due to Delphi 3 bug in TStringGrid!
    cc := ColCount - 1;
    cw := ColWidths[cc];

    ColCount := ColCount + NumHiddenColumns;
    SortRow := Row;

    cr := Row;

    if FNavigation.MoveRowOnSort then
      Row := RowCount - 3;

    QuickSortRowsIndexed(0,self.FixedRows,(self.RowCount - 1) - 3 - FFixedFooters);

    FNilObjects := True;
    ClearRows(RowCount - 2,2);
    FNilObjects := False;

    EnterState := FEntered;
    FEntered := False;

    if FNavigation.MoveRowOnSort then
      Row := SortRow
    else
      Row := cr;

//    Row := SortRow;

    FEntered := EnterState;

    ColCount := ColCount - NumHiddenColumns;
    ColWidths[cc] := cw;
    RowCount := RowCount - 3;
  finally
    if FSortSettings.NormalCellsOnly and (FixedCols > 0) then
    begin
      Cols[0].Assign(fCols);
      FCols.Free;
    end;

    EndUpdate;
  end;
end;

procedure TAdvStringGrid.InitSortXRef;
var
  i: Integer;
begin
  FSortRowXRef.Clear;
  for i := 0 to RowCount - 1 do
  begin
    FSortRowXRef.Add(i);
  end;
end;

procedure TAdvStringGrid.RemoveRowsEx(RowIndex, RCount : Integer);
var
  i,cw,cr: Integer;
  tr: Integer;

begin
  cw := ColWidths[ColCount - 1];
  cr := Row;
  tr := TopRow;

  BeginUpdate;

  ColCount := ColCount + FNumHidden;

  // Move all rows down
  for i := RowIndex to RowCount - 1 do
    Rows[i] := Rows[i + RCount];

  for i := 1 to RCount do
  begin
    DeleteRow(RowIndex);
    if FMouseActions.DisjunctRowSelect and (FRowSelect.Count > RowIndex) then
       FRowSelect.Delete(RowIndex);
  end;

//  for i := RowIndex to RowCount - 1 do
//    RowHeights[i] := RowHeights[i + RCount];
//  RowCount := RowCount - RCount;

  ColCount := ColCount - FNumHidden;
  ColWidths[ColCount-1] := cw;

  if cr < RowCount then
  begin
    Row := cr;
    TopRow := tr;
  end
  else
  begin
    if FixedRows < RowCount then
    begin
      Row := FixedRows;
      TopRow := FixedRows;
    end;
  end;

  EndUpdate;

  CellsChanged(Rect(0,RowIndex,ColCount-1,RowIndex + RCount));
end;

procedure TAdvStringGrid.RemoveRows(RowIndex, RCount : Integer);
begin
  ClearPropRect(0,RowIndex,ColCount - 1,RowIndex + RCount - 1);
  IRemoveRows(RowIndex,RCount);
end;


procedure TAdvStringGrid.IRemoveRows(RowIndex, RCount : Integer);
var
  i: Integer;
  cc,cw,cr: Integer;
  tr: Integer;
  enterstate: Boolean;

begin
  if RowIndex > RowCount then
    Exit;

  //necessary to save this due to Delphi 1,2,3 bug in TStringGrid!
  cc := ColCount - 1;
  cw := ColWidths[cc];

  //turn off the Entered state as a Row delete will reset cell focus}
  Enterstate := FEntered;
  FEntered := False;

  BeginUpdate;
  ColCount := ColCount + FNumHidden;

  tr := TopRow;
  cr := Row;

  {
  if NumHiddenRows > 0 then
  begin
    for i := 1 to FGriditems.Count do
    begin
      if (FGriditems.Items[i - 1] as TGridItem).Idx > RowIndex then
        (FGriditems.Items[i - 1] as TGridItem).Idx :=
          (FGriditems.Items[i - 1] as TGridItem).Idx - RCount;
    end;
  end;
  }

  for i := 1 to RCount do
  begin
    DeleteRow(RowIndex);
    if FMouseActions.DisjunctRowSelect and (FRowSelect.Count > RowIndex) then
       FRowSelect.Delete(RowIndex);
  end;

  if cr < RowCount - FFixedFooters then
  begin
    Row := cr;
    TopRow := tr;
  end
  else
  begin
    if RowCount - FFixedFooters > FixedRows then
      Row := RowCount - FFixedFooters - 1
    else
      HideSelection;
  end;

  ColCount := ColCount - FNumHidden;
  ColWidths[cc] := cw;
  EndUpdate;

  FEntered := EnterState;

  CellsChanged(Rect(0,RowIndex,ColCount-1,RowIndex + RCount));

  if TopRow >= RowCount - 1 then
    TopRow := RowCount - 1;
end;

procedure TAdvStringGrid.RemoveDuplicates(ACol: Integer; DoCase: Boolean);
var
  sl: TStringList;
  i: Integer;
begin
  ACol := RemapCol(ACol);
  sl := TStringList.Create;
  BeginUpdate;

  i := FixedRows;

  while i < RowCount - FixedFooters do
  begin
    if sl.IndexOf(Cells[ACol,i]) = -1 then
    begin
      if DoCase then
        sl.Add(Cells[ACol,i])
      else
        sl.Add(UpperCase(Cells[ACol,i]));
      Inc(i);
    end
    else
      RemoveRows(i,1);
  end;
  EndUpdate;
  sl.Free;
end;

procedure TAdvStringGrid.RemoveSelectedRows;
var
  i: Integer;
begin
  BeginUpdate;
  i := FixedRows;
  if not MouseActions.DisjunctRowSelect then
    SelectToRowSelect(True);
    
  while i < RowCount - FixedFooters do
  begin
    if RowSelect[i] then
      RemoveRows(i,1)
    else
      Inc(i);
  end;
  EndUpdate;
end;

procedure TAdvStringGrid.RemoveUnSelectedRows;
var
  i: Integer;
begin
  BeginUpdate;
  i := FixedRows;
  while i < RowCount - FixedFooters do
  begin
    if not RowSelect[i] then
      RemoveRows(i,1)
    else
      Inc(i);
  end;
  EndUpdate;
end;


procedure TAdvStringGrid.HideSelectedRows;
var
  i,j: Integer;
begin
  i := FixedRows;
  BeginUpdate;
  while i < RowCount do
    if RowSelect[i] then
    begin
      j := RealRowIndex(i);
      HideRows(j,j);
    end
    else
      Inc(i);
  EndUpdate;
end;

procedure TAdvStringGrid.HideUnSelectedRows;
var
  i,j: Integer;
begin
  i := FixedRows;
  BeginUpdate;
  while i < RowCount do
    if not RowSelect[i] then
    begin
      j := RealRowIndex(i);
      HideRows(j,j);
    end
    else
      Inc(i);
  EndUpdate;
end;


procedure TAdvStringGrid.ClearRect(ACol1,ARow1,ACol2,ARow2: Integer);
var
  i,j: Integer;
  rc: Integer;
begin
  for j := ARow1 to ARow2 do
  begin
    for i := ACol1 to ACol2 do
    begin
      if not SaveHiddenCells then
        rc := i
      else
        rc := RemapCol(i);

      if not FClearTextOnly then
      begin
        if HasCellProperties(rc,j) then
        begin
          if FNilObjects then
          begin
            NilCell(rc,j);
          end
          else
          begin
            FreeCellGraphic(rc,j);
            CellProperties[rc,j] := nil;
          end;
        end;
      end;

      if not (csDestroying in ComponentState) then
      begin
        if Cells[rc,j] <> '' then
        begin
          Cells[rc,j] := '';
          if rc <> i then
            RepaintCell(i,j);
        end;
      end;

    end;
  end;
  if not (csDestroying in ComponentState) then
    CellsChanged(Rect(ACol1,ARow1,ACol2,ARow2));
end;

procedure TAdvStringGrid.ClearRows(RowIndex,RCount: Integer);
begin
  if (RowCount > 0) and (ColCount > 0) and (RCount > 0) then
    ClearRect(0,RowIndex,ColCount - 1 + FNumHidden,RowIndex + RCount - 1);
end;

procedure TAdvStringGrid.ClearNormalCols(ColIndex, CCount: Integer);
begin
  if (RowCount > 0) and (ColCount > 0) and (CCount > 0) then
    ClearRect(ColIndex,FixedRows,ColIndex + CCount - 1,RowCount - 1 - FixedFooters);
end;

procedure TAdvStringGrid.ClearNormalRows(RowIndex, RCount: Integer);
begin
  if (RowCount > 0) and (ColCount > 0) and (RCount > 0) then
    ClearRect(FixedCols,RowIndex,ColCount - 1 + FNumHidden - FixedRightCols,RowIndex + RCount - 1);
end;


procedure TAdvStringGrid.AddColumn;
begin
  InsertCols(ColCount,1);
end;

procedure TAdvStringGrid.AddRow;
begin
  if FloatingFooter.Visible then
    InsertRows(RowCount - 1,1)
  else
    InsertRows(RowCount,1);
end;

procedure TAdvStringGrid.InsertRows(RowIndex,RCount: Integer);
var
  i: Integer;
  cw,cc: Integer;
begin
  //necessary to save this due to Delphi 1,2,3 bug in TStringGrid
  cc := ColCount - 1;
  cw := ColWidths[cc];


  ColCount := ColCount + FNumHidden;

  RowCount := RowCount + RCount;

  for i := RowCount - 1 downto (RowIndex + Rcount) do
  begin
    Rows[i] := Rows[i - RCount];
    RowHeights[i] := RowHeights[i - RCount];
  end;

  for i := RowIndex to RowIndex + Rcount - 1 do
    RowHeights[i] := DefaultRowHeight;

  for i := 0 to RCount - 1 do
    NilRow(RowIndex + i);

  ColCount := ColCount - FNumHidden;
  ColWidths[cc] := cw;
end;

procedure TAdvStringGrid.ClearCols(ColIndex,CCount: Integer);
begin
  if (RowCount>0) and (ColCount>0) and (CCount>0) then
    ClearRect(ColIndex,0,ColIndex+CCount-1,RowCount-1);
end;

procedure TAdvStringGrid.RemoveCols(ColIndex,CCount: Integer);
var
  i: Integer;
begin
  ClearCols(ColIndex,CCount);
  for i := ColIndex to ColCount - 1 do
  begin
    Cols[i] := Cols[i + CCount];
    ColWidths[i] := ColWidths[i + CCount];
    FVisibleCol[i] := FVisibleCol[i + CCount];
  end;

  ColCount := ColCount - CCount;
  CellsChanged(Rect(ColIndex,0,ColIndex + CCount, RowCount - 1));
end;

procedure TAdvStringGrid.InsertCols(ColIndex,CCount: Integer);
var
  i: Integer;
begin
  ColCount := ColCount + CCount;

  for i := ColCount - 1 + FNumHidden downto ColIndex + CCount do
  begin
    Cols[i] := Cols[i - CCount];
    if i < ColCount then
      ColWidths[i] := ColWidths[i - CCount];
    FVisibleCol[i] := FVisibleCol[i - CCount];
  end;

  for i := ColIndex to ColIndex + CCount - 1 do
  begin
    ColWidths[i] := DefaultColWidth;
    FVisibleCol[i] := True;
  end;

  for i := 0 to CCount - 1 do
    NilCol(ColIndex + i)
end;

procedure TAdvStringGrid.SplitColumnCells(ColIndex: Integer);
var
  i,j: Integer;
begin
  i := 0;
  while i < RowCount - 1 - FixedFooters do
  begin
    j := i;
    if IsMergedCell(ColIndex,i) then
    begin
      j := i + CellSpan(ColIndex,i).Y + 1;
      SplitCells(ColIndex,i);
    end
    else
      inc(j);
    i := j;
  end;
end;

procedure TAdvStringGrid.MergeColumnCells(ColIndex: Integer; MainMerge: Boolean);
var
  i,j,k: Integer;
begin
  j := 1;
  k := FixedRows;

  for i := FixedRows + 1 to RowCount - 1 - FixedFooters do
  begin
    if (Cells[ColIndex,i] = Cells[ColIndex,i - 1]) and
       (MainMerge or RowSpanIdentical(i,i - 1)) then
      inc(j)
    else
    begin
      MergeCells(ColIndex,k,1,j);
      k := i;
      j := 1;
    end;
  end;

  if j > 1 then
    MergeCells(ColIndex,k,1,j);
end;

procedure TAdvStringGrid.SplitAllCells;
var
  i,j: Integer;

begin
  for i := 1 to RowCount do
    for j := 1 to ColCount do
    begin
      if IsMergedCell(j - 1, i - 1) then
        SplitCells(j - 1,i - 1);
    end;
end;

procedure TAdvStringGrid.SplitRowCells(RowIndex: Integer);
var
  i,j: Integer;
begin
  i := 0;
  while i < ColCount - 1 - FixedRightCols do
  begin
    j := i;
    if IsMergedCell(i,RowIndex) then
    begin
      j := i + CellSpan(i,RowIndex).X + 1;
      SplitCells(i,RowIndex);
    end
    else
      inc(j);
      
    i := j;
  end;
end;

procedure TAdvStringGrid.MergeRowCells(RowIndex: Integer; MainMerge: Boolean);
var
  i,j,k: Integer;
begin
  j := 0;
  k := FixedCols;
  for i := FixedCols + 1 to ColCount - 1 - FixedRightCols do
  begin
    if (Cells[i,RowIndex] = Cells[i - 1,RowIndex]) and
       (MainMerge or ColSpanIdentical(i,i - 1)) then
      inc(j)
    else
    begin
      MergeCells(k,RowIndex,j + 1,1);
      k := i;
      j := 0;
    end;
  end;
  if j >= 1 then
    MergeCells(k,RowIndex,j + 1,1);
end;

procedure TAdvStringGrid.MergeCols(ColIndex1, ColIndex2 : Integer);
var
  i: Integer;
  s:string;
begin
  for i := FixedRows to RowCount - 1 do
  begin
    s := Cells[ColIndex1,i] + ' ' + Cells[ColIndex2,i];
    Cells[ColIndex1,i] := Trim(s);
  end;
  RemoveCols(ColIndex2,1);
end;

procedure TAdvStringGrid.ClearNormalCells;
begin

  if (RowCount > 0) and (ColCount > 0) then
  begin
    ClearRect(FixedCols,FixedRows,ColCount - 1 + FNumHidden - FixedRightCols,RowCount - 1 - FixedFooters);
  end;  
end;

procedure TAdvStringGrid.ClearSelection;
var
  i: Integer;
begin
  if FMouseActions.DisjunctRowSelect then
  begin
    for i := FixedRows to RowCount - 1 do
    begin
      if RowSelect[i] then
        ClearRows(i,1);
    end;
  end
  else
  begin
    if FMouseActions.DisjunctColSelect then
    begin
      for i := FixedCols to ColCount - 1 do
      begin
        if ColSelect[i] then
          ClearCols(i,1);
      end;
    end
    else
      ClearRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom);
  end;
end;

procedure TAdvStringGrid.Clear;
begin
  if (RowCount > 0) and (ColCount > 0) then
    ClearRect(0,0,ColCount - 1 + FNumHidden,RowCount - 1);
  SearchInc := '';
end;

function TAdvStringGrid.IsCell(SubStr: String; var ACol, ARow: Integer): Boolean;
var
  i,j: Integer;
begin
  for i := 0 to RowCount - 1 do
  begin
    for j := 0 to ColCount - 1 do
    begin
      if Rows[i].Strings[j] = SubStr then
      begin
        ARow := i;
        ACol := j;
        Result := True;
        Exit;
      end;
    end;
  end;
  Result := False;
end;

procedure TAdvStringGrid.LoadFromBinFile(FileName: string);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.LoadFromFile(FileName);
    LoadFromBinStream(ms);
  finally
    ms.Free;
  end;
end;


procedure TAdvStringGrid.LoadAtPointFromBinStream(Point: TPoint; Stream: TStream);
var
  cpio: TGridCellIO;
  cgio: TGridGraphicIO;
  gpio: TGridPropIO;
  giio: TGridIconIO;
  gbio: TGridBMPIO;
  gtio: TGridPicIO;
  gfio: TGridFilePicIO;
  gsio: TGridSLIO;
  pio: TGridCellPropIO;
  cg: TCellGraphic;
  sl: TStringList;
  il: TIntList;
  i: Integer;
  bmp: TBitmap;
  ico: TIcon;
  pic: TPicture;
  fpic: TFilePicture;
  FirstCell: Boolean;
  DeltaX,DeltaY: Integer;

begin

  gpio := TGridPropIO.Create(Self);
  cpio := TGridCellIO.Create(Self);
  cgio := TGridGraphicIO.Create(Self);
  gbio := TGridBMPIO.Create(Self);
  giio := TGridIconIO.Create(Self);
  gtio := TGridPicIO.Create(Self);
  gfio := TGridFilePicIO.Create(Self);
  gsio := TGridSLIO.Create(Self);
  pio := TGridCellPropIO.Create(Self);

  Stream.ReadComponent(gpio);

  if (gpio.FullGrid) then
  begin
    Clear;

    RowCount := gpio.RowCount;
    ColCount := gpio.ColCount;

    sl := TStringList.Create;
    sl.CommaText := gpio.ColWidths;
    for i := 1 to ColCount do
      ColWidths[i - 1] := StrToInt(sl.Strings[i - 1]);

    sl.CommaText := gpio.RowHeights;
    for i := 1 to RowCount do
      RowHeights[i - 1] := StrToInt(sl.Strings[i - 1]);

    sl.Free;
  end;

  FirstCell := True;
  DeltaX := 0;
  DeltaY := 0;

  while Stream.Position < Stream.Size - 1 do
  begin
    Stream.ReadComponent(cpio);
    //showmessage('read prop');

    if FirstCell and not gpio.FullGrid then
    begin
      DeltaX := cpio.Col;
      DeltaY := cpio.Row;
      FirstCell := False;
    end;


    Cells[Point.X + cpio.Col - DeltaX,Point.Y + cpio.Row - DeltaY] := cpio.Cell;
    if cpio.HasProp then
    begin
      Stream.ReadComponent(pio);
      CellProperties[Point.X + cpio.Col - DeltaX,Point.Y + cpio.Row - DeltaY].Assign(pio.CellProperties);

      if pio.HasGraphic then
      begin
        Stream.ReadComponent(cgio);
        cg := CreateCellGraphic(Point.X + cpio.Col - DeltaX,Point.Y + cpio.Row - DeltaY);
        cg.Assign(cgio.CellGraphic);

        // it is guaranteed to be created, otherwise not saved
        case cg.CellType of
        ctBitmap,ctBitButton:
          begin
            Stream.ReadComponent(gbio);
            bmp := TBitmap.Create;
            bmp.Assign(gbio.Bitmap);
            cg.CellBitmap := bmp;
          end;
        ctIcon:
          begin
            Stream.ReadComponent(giio);
            ico := TIcon.Create;
            ico.Assign(giio.Icon);
            cg.CellIcon := ico;
          end;
        ctPicture:
          begin
            Stream.ReadComponent(gtio);
            pic := TPicture.Create;
            pic.Assign(gtio.Picture);
            cg.CellBitmap := TBitmap(pic);
          end;
        ctFilePicture:
          begin
            Stream.ReadComponent(gfio);
            fpic := TFilePicture.Create;
            fpic.Assign(gfio.Picture);
            cg.CellBitmap := TBitmap(fpic);
          end;
        ctRadio:
          begin
            Stream.ReadComponent(gsio);
            sl := TStringList.Create;
            sl.Assign(gsio.Strings);
            cg.CellBitmap := TBitmap(sl);
          end;
        ctImages:
          begin
            Stream.ReadComponent(gsio);
            il := TIntList.Create(Point.X + cpio.Col - DeltaX,Point.Y + cpio.Row - DeltaY);
            il.StrValue := gsio.Strings.CommaText;
            cg.CellBitmap := TBitmap(il);
          end;
        end;
      end;

    end;

    cpio.Cell := '';
  end;
  pio.Free;
  gsio.Free;
  gfio.Free;
  gtio.Free;
  giio.Free;
  gbio.Free;
  gpio.Free;
  cpio.Free;
  cgio.Free;
end;

procedure TAdvStringGrid.SaveToBinFile(FileName: string);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  SaveToBinStream(ms);
  ms.SaveToFile(FileName);
  ms.Free;
end;

procedure TAdvStringGrid.SaveRectToBinStream(Rect: TRect; Stream: TStream);
var
  i,j: Integer;
  cpio: TGridCellIO;
  cgio: TGridGraphicIO;
  gpio: TGridPropIO;
  gbio: TGridBMPIO;
  giio: TGridIconIO;
  gtio: TGridPicIO;
  gfio: TGridFilePicIO;
  gsio: TGridSLIO;
  pio: TGridCellPropIO;
  HasProp: Boolean;


begin
  // helper objects
  cpio := TGridCellIO.Create(Self);
  cgio := TGridGraphicIO.Create(Self);
  gpio:= TGridPropIO.Create(Self);
  gbio := TGridBMPIO.Create(Self);
  giio := TGridIconIO.Create(Self);
  gtio := TGridPicIO.Create(Self);
  gfio := TGridFilePicIO.Create(Self);
  gsio := TGridSLIO.Create(Self);
  pio := TGridCellPropIO.Create(Self);

  gpio.RowCount := Rect.Bottom - Rect.Top + 1;
  gpio.ColCount := Rect.Right - Rect.Left + 1;
  gpio.FullGrid := (gpio.RowCount = RowCount) and (gpio.ColCount = ColCount);
  gpio.ID := Integer(Handle);

  for i := Rect.Left to Rect.Right do
   if i > Rect.Left then
     gpio.ColWidths := gpio.ColWidths + ',' + IntToStr(ColWidths[i])
   else
     gpio.ColWidths := IntToStr(ColWidths[i]);

  for i := Rect.Top to Rect.Bottom do
   if i > Rect.Top then
     gpio.RowHeights := gpio.RowHeights + ',' + IntToStr(RowHeights[i])
   else
     gpio.RowHeights := IntToStr(RowHeights[i]);

  Stream.WriteComponent(gpio);

  // need simpler object for cells with text only

  for i := Rect.Left to Rect.Right do
    for j := Rect.Top to Rect.Bottom do
    begin
      HasProp := HasCellProperties(i,j);
      if (Cells[i,j] <> '') or HasProp then
      begin
        cpio.Col := i;
        cpio.Row := j;
        cpio.Cell := Cells[i,j];

        cpio.HasProp := HasProp;

        Stream.WriteComponent(cpio);

        if HasProp then
        begin
          pio.CellProperties.Assign(CellProperties[i,j]);
          pio.HasGraphic := (CellTypes[i,j] <> ctEmpty);
          Stream.WriteComponent(pio);

          if pio.HasGraphic then
          begin
            if not ((CellTypes[i,j] in [ctBitmap,ctBitButton,ctPicture,ctFilePicture,ctImages,ctRadio,ctIcon])
                   and not CellGraphics[i,j].CellCreated) then
            begin
              cgio.CellGraphic.Assign(CellGraphics[i,j]);
              Stream.WriteComponent(cgio);

              case CellTypes[i,j] of
              ctBitmap,ctBitButton:
                begin
                  gbio.Bitmap.Assign(CellGraphics[i,j].CellBitmap);
                  Stream.WriteComponent(gbio);
                end;
              ctIcon:
                begin
                  giio.Icon.Assign(CellGraphics[i,j].CellIcon);
                  Stream.WriteComponent(giio);
                end;
              ctPicture:
                begin
                  gtio.Picture.Assign(TPicture(CellGraphics[i,j].CellBitmap));
                  Stream.WriteComponent(gtio);
                end;
              ctFilePicture:
                begin
                  gfio.Picture.Assign(TFilePicture(CellGraphics[i,j].CellBitmap));
                  Stream.WriteComponent(gfio);
                end;
              ctRadio:
                begin
                  gsio.Strings.Assign(TStringList(CellGraphics[i,j].CellBitmap));
                  Stream.WriteComponent(gsio);
                end;
              ctImages:
                begin
                  gsio.Strings.CommaText := TIntList(CellGraphics[i,j].CellBitmap).StrValue;
                  Stream.WriteComponent(gsio);
                end;
              end;
            end;
          end;

        end;  
      end;
    end;

  pio.Free;
  gsio.Free;
  gfio.Free;
  giio.Free;
  gpio.Free;
  cpio.Free;
  cgio.Free;
  gbio.Free;
end;

procedure TAdvStringGrid.LoadFromBinStream(Stream: TStream);
var
  i: Integer;
begin
  LoadAtPointFromBinStream(Point(0,0),Stream);
  // synchronize nodes when used ...
  FNumNodes := 0;
  for i := FixedRows to RowCount - 1 do
  begin
    if CellTypes[0,i] = ctNode then
      inc(FNumNodes);
  end;
  if FNumNodes > 0 then
    RepaintCol(0);

end;

procedure TAdvStringGrid.SaveToBinStream(Stream: TStream);
begin
  SaveRectToBinStream(Rect(0,0,ColCount - 1,RowCount - 1),Stream);
end;

procedure TAdvStringGrid.SaveToFile(FileName: String);
var
  i,j,n: Integer;
  ss,CellText: string;
  f: TextFile;
  nprogr,oprogr: Integer;
begin
  AssignFile(f, FileName);
  {$i-}
  Rewrite(f);
  {$i+}
  if IOResult <> 0 then
    raise EAdvGridError.Create('Cannot Create ' + FileName);

  oprogr := -1;

  if FSaveHiddenCells then
    n := FNumHidden
  else
    n := 0;

  ss := IntToStr(SaveColCount+n) + ',' + IntToStr(SaveRowCount);
  Writeln(f,ss);

  for i := SaveStartCol to SaveEndCol + n do
  begin
    ss := 'cw '+IntToStr(i) + ',' + IntToStr(ColWidths[i]);
    WriteLn(f,ss);
  end;

  for i := SaveStartRow to SaveEndRow do
  begin
    for j := SaveStartCol to SaveEndCol + FNumHidden do
    begin
      CellText := SaveCell(j,i);
      if CellText <> '' then
      begin
        ss := IntToStr(j) + ',' + IntToStr(i) + ',' + lftofile(CellText);
        Writeln(f,ss);
      end;
    end;

    if Assigned(FOnFileProgress) then
    begin
      nprogr := Round(i/(Min(1,SaveRowCount-1))*100);
      if nprogr <> oprogr then
        FOnFileProgress(self,nprogr);
      oprogr := nprogr;
    end;
  end;
  CloseFile(f);
end;

procedure TAdvStringGrid.LoadFromFile(FileName: String);
var
  X,Y,CW: Integer;
  ss,ss1:string;
  f:TextFile;
  strtCol,strtRow: Integer;
  nprogr,oprogr: Integer;
  seppos: Integer;

  function MStrToInt(s:string): Integer;
  var
    code,i: Integer;
  begin
    val(s,i,code);
    Result := i;
  end;

begin
  AssignFile(f, FileName);
  {$i-}
  Reset(f);
  {$i+}
  if IOResult <> 0 then
    raise EAdvGridError.Create('Cannot open file ' + FileName);

  oprogr := -1;
  StrtCol := FixedCols;
  StrtRow := FixedRows;

  if FSaveFixedCells then
  begin
    StrtCol := 0;
    strtRow := 0;
  end;

  Readln(f,ss);
  if ss <> '' then
  begin
    ss1 := Copy(ss,1,CharPos(',',ss) - 1);
    ColCount := MStrToInt(ss1) + StrtCol;
    ss1 := Copy(ss,CharPos(',',ss) + 1,Length(ss));
    RowCount := MStrToInt(ss1) + StrtRow;
  end;

  if (ColCount = 0) or (RowCount = 0) then
  begin
    Closefile(f);
    raise EAdvGridError.Create('File contains no data or corrupt file '+FileName);
  end;

  while not Eof(f) do
  begin
    Readln(f, ss);

    if Pos('cw',ss)=1 then {parse cw i,Width }
    begin
      seppos := CharPos(',',ss);
      ss1 := Copy(ss,4,seppos - 4);
      ss := Copy(ss,seppos + 1,255);
      CW := MStrToInt(ss1);
      if (cw >= 0) and (cw < ColCount) then
        ColWidths[cw] := mstrtoint(ss);
    end
    else
    begin
      ss1 := GetToken(ss,',');
      X := mStrToInt(ss1);
      ss1 := GetToken(ss,',');
      Y := mStrToInt(ss1);

      if (X < ColCount) and (Y < RowCount) then
      begin
        LoadCell(X,Y,FileToLF(ss,FMultiLineCells));
      end;

      if Assigned(FOnFileProgress) then
      begin
        nprogr := Round(y / (RowCount - 1) * 100);
        if nprogr <> oprogr then
          FOnFileProgress(self,nprogr);
        oprogr := nprogr;
      end;
      Application.ProcessMessages;
    end;
  end;
  CloseFile(f);
  CellsChanged(Rect(0,0,ColCount,RowCount));
  CellsLoaded;
end;

{$IFDEF ISDELPHI}
function TAdvStringGrid.CellToReal(ACol, ARow: Integer): Real;
var
 i:Real;
 Code: Integer;
begin
 Result :=0.0;
 if (Cells[ACol,ARow]<>'') then
 begin
  Val(Cells[ACol, ARow], i, Code);
  if Code <> 0 then raise
        EAdvGridError.Create('Error at position: ' +
        IntToStr(Code) + ' in Cell [' + IntToStr(ACol) + ', ' +
        IntToStr(ARow) + '].')
   else
   Result := i;
 end;
end;
{$ENDIF}

procedure TAdvStringGrid.SaveToASCII(FileName: String);
var
  s,z: Integer;
  CellText,CellStr,str,alistr,remainingstr:string;
  i: Integer;
  MultiLineList: TStringlist;
  OutputFile:TextFile;
  anotherlinepos: Integer;
  blanksfiller: String;
  blankscount,NeededLines: Integer;
  AlignValue:TAlignment;
  Colchars:array[0..MAXColUMNS] of byte;

begin
  Screen.Cursor := crHourGlass;
  AssignFile(OutputFile,FileName);
  {$i-}
  Rewrite(OutputFile);
  {$i+}
  if (ioResult<>0) then EAdvGridError.Create('Cannot create file '+FileName);

  for i:=0 to ColCount-1 do
    Colchars[i] := MaxCharsInCol(RemapCol(i));

  try
    MultiLineList := TStringlist.Create;
    for z:=0 to RowCount-1 do
    begin
      str := '';
      for s:=0 to ColCount-1 do
      begin
        CellText := SaveCell(RemapCol(s),z);
        
        if (Pos(#13#10, CellText) > 0) and MultiLineCells then
        begin
          CellStr := Copy(CellText,0, Pos(#13#10, CellText) - 1);
          remainingstr := copy(CellText, Pos(#13#10, CellText)+2, Length(CellText));
          NeededLines := 0;
          repeat
            inc(NeededLines);
            blanksfiller := '';
            blankscount := 0;

            if (MultiLineList.Count<NeededLines) then  {we haven't already added a new line for an earlier Colunn}
              MultiLineList.Add('');

            {nr of spaces before cell text}
            for i := 0 to s - 1 do
              BlanksCount := BlanksCount + ColChars[i] + 1;

            {add to line sufficient blanks}
            for i := 0 to (blankscount-Length(MultiLineList[NeededLines-1])-1) do
              BlanksFiller := BlanksFiller + ' ';

            MultiLineList[NeededLines-1] := MultiLineList[NeededLines-1] + BlanksFiller;

            AnotherLinePos := Pos(#13#10, remainingstr);

            if AnotherLinePos > 0 then
            begin
              alistr := Copy(remainingstr, 0, AnotherLinePos - 1);
              remainingstr := Copy(remainingstr,pos(#13#10,remainingstr)+2,Length(remainingstr));
            end
            else
            begin
              alistr := remainingstr;
            end;

            AlignValue := GetCellAlignment(s,z).Alignment;

            case AlignValue of
            taRightJustify:while (Length(alistr)<Colchars[s]) do alistr:=' '+alistr;
            taCenter:while (Length(alistr)<Colchars[s]) do alistr:=' '+alistr+' ';
            end;
            MultiLineList[NeededLines-1]:=MultiLineList[NeededLines-1]+alistr;

          until anotherlinepos=0;
        end
        else
          cellstr := CellText;

        if Pos(#13#10,CellStr) > 0 then
          CellStr := Copy(CellStr,0,pos(#13#10,CellStr)-1);

        AlignValue := GetCellAlignment(s,z).Alignment;
        case AlignValue of
        taRightJustify:while (Length(cellstr) < Colchars[s]) do cellstr := ' ' + cellstr;
        taCenter:while (Length(cellstr) < Colchars[s]) do cellstr := ' ' + cellstr+' ';
        end;

        blanksfiller := '';
        blankscount := Colchars[s];
        for i:=0 to (blankscount-Length(cellstr)) do
          blanksfiller := blanksfiller + ' ';
        str := str + cellstr + blanksfiller;
      end;  {Column}

      Writeln(OutputFile,Str);
      for i := 0 to MultiLineList.Count-1 do
        Writeln(OutputFile, MultiLineList[i]);     {finally, add the extra lines for this Row}
      MultiLineList.Clear;

    end;    {Row}
    MultiLineList.Free;
  finally
    CloseFile(OutputFile);
    Screen.Cursor := crDefault;
  end;
end;

procedure TAdvStringGrid.SaveToHTML(Filename:string);
begin
  OutputToHTML(Filename,False);
end;

procedure TAdvStringGrid.AppendToHTML(Filename:string);
begin
  OutputToHTML(Filename,True);
end;


procedure TAdvStringGrid.OutputToHTML(Filename:string;appendmode: Boolean);
var
  i,j,mc,mr: Integer;
  s,al,ac,afs,afe,afc,aff,ass,ase,tablestyle: string;
  slist: TStringlist;
  AlignValue: TAlignment;
  TopRow: Integer;
  strtCol,strtRow: Integer;
  f,hdr: TextFile;
  wraptxt,colwtxt,CellText,SpanTxt: string;
  DoneColW: Boolean;
  Span:TPoint;
  AState: TGridDrawState;
  HAlign: TAlignment;
  VAlign: TVAlignment;
  WW: Boolean;

  function MakeHREF(s:string):string;
  begin
   Result :=s;
   if not URLshow then Exit;
   if (pos('://',s)>0) and (pos('</',s)=0) then
   begin
   if not URLFull then
      Result :='<a href='+s+'>'+copy(s,pos('://',s)+3,255)+'</a>'
     else
      Result :='<a href='+s+'>'+s+'</a>';
    end;

   if (pos('mailto:',s)>0) and (pos('</',s)=0) then
    begin
     if not URLFull then
      Result :='<a href='+s+'>'+copy(s,pos('mailto:',s)+7,255)+'</a>'
     else
      Result :='<a href='+s+'>'+s+'</a>';
    end;
  end;

begin
  StrtCol := FixedCols;
  StrtRow := FixedRows;

  if FSaveFixedCells then
  begin
    StrtCol := 0;
    StrtRow := 0;
  end;

  SList := TStringlist.Create;
  SList.Sorted := False;

  if WordWrap then
    WrapTxt := ''
  else
    WrapTxt := ' nowrap';

  DoneColW := False;

  with SList do
  begin
    if FHTMLSettings.XHTML then
    begin
      Add('<?xml version="1.0" encoding="UTF-8"?>');
      Add('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"');
      Add('"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">');
      Add('<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">');
    end;

    if FHTMLSettings.PrefixTag <> '' then
      Add(FHTMLSettings.PrefixTag);

    if FHTMLSettings.TableStyle <> '' then
      TableStyle := ' ' + FHTMLSettings.TableStyle + ' '
    else
      TableStyle := '';

    Add('<table border="'+IntToStr(FHTMLSettings.BorderSize)+
        '" cellspacing="'+IntToStr(FHTMLSettings.CellSpacing)+
        '" cellpadding="'+IntToStr(FHTMLSettings.CellPadding)+
        '" ' + TableStyle +
        ' width="' + IntToStr(FHTMLSettings.Width) + '%">');  // begin the table

    TopRow := StrtRow;

    if (FixedRows > 0) and FSaveFixedCells then
    begin
      Add('<tr>');
      DoneColW := True;

      for i := StrtCol to ColCount - 1 do
      begin
        if IsBaseCellEx(i,0,mc,mr) then
        begin
          Span := CellSpan(i,0);

          SpanTxt := '';

          if Span.X > 0 then
            SpanTxt := ' colspan="' + IntToStr(Span.X + 1) + '"';

          if Span.Y > 0 then
            SpanTxt := SpanTxt + ' rowspan="' + IntToStr(Span.Y + 1) + '"';


          CellText := SaveCell(RemapCol(i),0);
          s := HTMLLineBreaks(CellText);
          s := MakeHREF(s);
          if s = '' then
            s := '<br>';

          al := '';
          ac := '';
          afs := '';
          afe := '';

          AlignValue := GetCellAlignment(i,0).Alignment;

          if (s <> '') and (AlignValue <> taLeftJustify) then
          begin
            if AlignValue = taRightJustify then
              al := ' align="right"';
            if AlignValue=taCenter then
              al := ' align="center"';
          end;

          if FHTMLSettings.ColWidths.Count > i then
            colwtxt := ' width=' + IntToStr(FHTMLSettings.ColWidths.Items[i])
          else
            colwtxt := '';

          Canvas.Font.Color := $7fffffff;
          Canvas.Font.Style := [];

          GetVisualProperties(i,0,AState,False,False,True,Canvas.Brush,Canvas.Font,HAlign,VAlign,WW);

          afs := '';
          afe := '';
          if (Canvas.Font.Color <> $7fffffff) and FHTMLSettings.SaveColor then
          begin
            afs := '<font color="#'+HTMLColor(dword(ColorToRGB(Canvas.Font.Color))) + '">';
            afe := '</font>';
          end;

          ass := '';
          ase := '';
          if FHTMLSettings.SaveFonts then
          begin
            if (fsBold in Canvas.Font.Style) then
            begin
              ass := ass + '<b>';
              ase := ase + '</b>';
            end;
            if (fsItalic in Canvas.Font.Style) then
            begin
              ass := ass + '<i>';
              ase := '</i>' + ase;
            end;
            if (fsUnderline in Canvas.Font.Style) then
            begin
              ass := ass + '<u>';
              ase := '</u>' + ase;
            end;
          end;

          ac := ' bgcolor="#' + HTMLColor(ColorToRGB(FixedColor)) + '"';
          Add('<td' + wraptxt + al + ac + colwtxt + spantxt + '>' + ass + afs + s + afe + ase + '</b></td>');
        end;
      end;
      Add('</tr>');
      TopRow := 1;
    end;

    for i := TopRow to RowCount - 1 do
    begin
      Add('<tr>');
      for j := StrtCol to ColCount-1 do

      if IsBaseCellEx(j,i,mc,mr) then
      begin
        Span := CellSpan(j,i);

        SpanTxt := '';

        if Span.X > 0 then
          SpanTxt := ' colspan="' + IntToStr(Span.X + 1) + '"';

        if Span.Y > 0 then
          SpanTxt := SpanTxt + ' rowspan="' + IntToStr(Span.Y + 1) + '"';

        CellText := SaveCell(RemapCol(j),i);
        s := HTMLLineBreaks(CellText);
        s := MakeHREF(s);
        al := '';
        ac := '';
        afs := '';
        afe := '';
        ass := '';
        ase := '';
        AlignValue := GetCellAlignment(j,i).Alignment;

        if (AlignValue <> taLeftJustify) and (s <> '') then
        begin
          if AlignValue = taRightJustify then
            al := ' align="right"';

          if AlignValue=taCenter then
            al := ' align="center"';
        end;

        if (i < FixedRows) or (j < FixedCols) then
        begin
          ac := ' bgcolor="#' + HTMLColor(ColorToRGB(FixedColor)) + '"';
        end
        else
          Canvas.Brush.Color := $7fffffff;

        Canvas.Font.Color := $7fffffff;
        Canvas.Font.Style := [];

        GetVisualProperties(j,i,AState,False,False,True,Canvas.Brush,Canvas.Font,HAlign,VAlign,WW);

        if (Canvas.Brush.Color <> $7fffffff) and FHTMLSettings.SaveColor then
           ac := ' bgcolor="#' + HTMLColor(dword(ColorToRGB(Canvas.Brush.Color))) + '"';

        if (Canvas.Font.Color <> $7fffffff) and FHTMLSettings.SaveColor then
        begin
          afs := '<font color="#' + HTMLColor(dword(ColorToRGB(Canvas.Font.Color))) + '">';
          afe := '</font>';
        end;

        if FHTMLSettings.SaveFonts then
        begin
          if (fsBold in Canvas.Font.Style) then
          begin
            ass := ass + '<b>';
            ase := ase + '</b>';
          end;
          if (fsItalic in Canvas.Font.Style) then
          begin
            ass := ass + '<i>';
            ase := '</i>' + ase;
          end;
          if (fsUnderline in Canvas.Font.Style) then
          begin
            ass := ass + '<u>';
            ase := '</u>' + ase;
          end;

          afs := '';
          afc := '';
          aff := '';
          afe := '';

          if (Canvas.Font.Color <> $7fffffff) and FHTMLSettings.SaveColor then
            afc := 'color="#'+HTMLColor(dword(ColorToRGB(Canvas.Font.Color))) + '"';

          if Canvas.Font.Name <> Font.Name then
          begin
            aff := 'face="'+Canvas.Font.Name+'"';
          end;

          if (aff <> '') or (afc <> '') then
          begin
            afs := '<font ' + afc + ' ' + aff + '>';
            afe := '</font>';
          end;

        end;

        if (FHTMLSettings.ColWidths.Count > j - strtcol) and not DoneColW then
          colwtxt := ' width=' + inttostr(FHTMLSettings.ColWidths.Items[j - strtcol ])
        else
          colwtxt := '';

        if s = '' then
          if HTMLSettings.XHTML then
            s := '<br/>'
          else
            s := '<br>';   

        Add('<td' + spantxt + wraptxt + al + ac + colwtxt + '>'+ afs + ass + s + ase + afe + '</td>');
      end;

      Add('</tr>');
    end;

    Add('</table>');
    if FHTMLSettings.SuffixTag <> '' then
      Add(FHTMLSettings.SuffixTag);

    if FHTMLSettings.XHTML then
      Add('</html>');
  end; // with SList

  AssignFile(f,FileName);

  if AppendMode then
  begin
    {$i-}
    Reset(f);
    {$i+}
    if IOResult <> 0 then
    begin
      {$i-}
      Rewrite(f);
      {$i+}
      if IOResult <> 0 then
      begin
        slist.Free;
        raise EAdvGridError.Create('Cannot Create file '+FileName);
      end;
    end
    else Append(f);
  end
  else
  begin
    {$i-}
    Rewrite(f);
    {$i+}
    if  IOResult <> 0 then
    begin
      slist.free;
      raise EAdvGridError.Create('Cannot Create file '+FileName);
    end;
  end;

  if FHTMLSettings.HeaderFile <> '' then
  begin
    AssignFile(hdr,FHTMLSettings.HeaderFile);
    {$i-}
    Reset(hdr);
    {$i+}
    if IOResult = 0 then
    begin
      while not eof(hdr) do
      begin
        ReadLn(hdr,s);
        WriteLn(f,s);
      end;
      CloseFile(hdr);
    end;
  end;

  for i := 1 to slist.Count do
  begin
    WriteLn(f,slist.strings[i - 1]);
  end;

  if FHTMLSettings.FooterFile <> '' then
  begin
    AssignFile(hdr,FHTMLSettings.FooterFile);
    {$i-}
    Reset(hdr);
    {$i+}
    if IOResult = 0 then
    begin
      while not eof(hdr) do
      begin
        ReadLn(hdr,s);
        WriteLn(f,s);
      end;
      CloseFile(hdr);
    end;
  end;
  CloseFile(f);
  slist.Free;
end;

procedure TAdvStringGrid.SaveToXML(FileName: String; ListDescr, RecordDescr:string;FieldDescr: TStrings);
var
  i,j: Integer;
  f: TextFile;
  s: string;
begin
  Assignfile(f,filename);
  {$i-}
  Rewrite(f);
  {$i+}
  if IOResult <> 0 then
    raise EAdvGridError.Create('Cannot Create file '+FileName);

  writeln(f,'<?xml version="1.0" encoding="ISO-8859-1" ?>');
  writeln(f,'<' + ListDescr + '>');

  for i := SaveStartRow to SaveEndRow do
  begin
    writeln(f,'<'+RecordDescr+'>');
    for j := SaveStartCol to SaveEndCol do
    begin
      if Assigned(FieldDescr) and (j - SaveStartCol < FieldDescr.Count) then
        write(f,'<' + FieldDescr.Strings[j - SaveStartCol]+'>')
      else
        write(f,'<FIELD' + IntToStr(j - SaveStartCol)+'>');

      {$IFDEF DELPHI4_LVL}
      s := StringReplace(SaveCell(j,i),'&','$amp',[rfReplaceAll]);
      {$ELSE}
      s := StringReplace(SaveCell(j,i),'&','$amp');
      {$ENDIF}

      write(f,s);

      if Assigned(FieldDescr) and (j - SaveStartCol< FieldDescr.Count) then
        writeln(f,'</' + FieldDescr.Strings[j - SaveStartCol]+'>')
      else
        writeln(f,'</FIELD' + IntToStr(j - SaveStartCol)+'>');
    end;
    writeln(f,'</' + RecordDescr + '>');
  end;

  writeln(f,'</' + ListDescr + '>');

  CloseFile(f);
end;

procedure TAdvStringGrid.CopyBinFunc(gd: TGridRect);
var
  ms: TMemoryStream;
  Data: THandle;
  DataPtr: Pointer;
  Clipboard: TClipboard;
begin
  ms := TMemoryStream.Create;
  Clipboard := TClipboard.Create;
  Clipboard.Open;

  try
    SaveRectToBinStream(TRect(gd),ms);

    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, ms.Size);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(ms.Memory^, DataPtr^, ms.Size);
        SetClipboardData(CF_GRIDCELLS, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    ms.Free;
    Clipboard.Close;
    Clipboard.Free;
  end;
end;

procedure TAdvStringGrid.CopyRTFFunc(ACol,ARow: Integer);
var
  s: string;
  GHandle: THandle;
  Gptr: PChar;
  cf_rtf: word;
begin
  s := Cells[ACol,ARow];
  if Pos('{\',s) = 0 then
    Exit;

  GHandle := GlobalAlloc(gmem_MoveAble,Length(s));
  if GHandle = 0 then
    Exit;

  GPtr := GlobalLock(GHandle);
  if GPtr = nil then
  begin
    GlobalFree(GHandle);
    Exit;
  end;

  StrCopy(gptr,'');
  StrCat(gptr,PChar(s));
  GlobalUnlock(GHandle);

  if not OpenClipBoard(Handle) then
    GlobalFree(GHandle)
  else
  begin
    cf_rtf := RegisterClipboardformat('Rich Text Format');
    SetClipBoardData(cf_rtf,GHandle);
    CloseClipBoard;
  end;
end;

procedure TAdvStringGrid.CopyFunc(gd: TGridRect; DoDisjunct: Boolean);
var
  s,z,rc: Integer;
  len: Integer;
  buffer,ptr: PChar;
  ct: string;
begin
  FClipTopLeft := Point(gd.Left,gd.Top);

  len := 1;

  for z := gd.Top to gd.Bottom do
  begin
    if not (MouseActions.DisjunctRowSelect) or RowSelect[z] or not DoDisjunct or
      MouseActions.DisjunctColSelect then
    begin
      for s := gd.Left to gd.Right do
      begin
        if not (MouseActions.DisjunctColSelect) or ColSelect[s] or not DoDisjunct then
        begin
          rc := RemapCol(s);
          ct := SaveCell(rc,z);
          if not FNavigation.CopyHTMLTagsToClipboard and (Pos('</',ct) > 0) then
          begin
            ct := StrippedCells[rc,z];
          end
          else
          if Pos('{\',ct) > 0 then
          begin
            CellToRich(rc,z,FRichEdit);
            ct := FRichEdit.Text;
          end;
          if (LinesInText(ct,FMultiLineCells) > 1) and
             FExcelClipboardformat then LineFeedsToCSV(ct);

          len := len + Length(ct) + 1; //tab
        end;
      end;
      if gd.Top < gd.Bottom then
        len := len + 1;
    end;
  end;

  Buffer := nil;

  //fill buffer and copy to clipboard
  try
    GetMem(Buffer,len);
    //fill buffer
    Buffer^ := #0;
    ptr := Buffer;
    for z := gd.Top to gd.Bottom do
    begin
      if not (MouseActions.DisjunctRowSelect) or RowSelect[z] or not DoDisjunct or
        MouseActions.DisjunctColSelect then
      begin
        for s := gd.Left to gd.Right do
        begin
          if not (MouseActions.DisjunctColSelect) or ColSelect[s] or not DoDisjunct then
          begin

            rc := RemapCol(s);
            ct := SaveCell(rc,z);
            if not FNavigation.CopyHTMLTagsToClipboard and (Pos('</',ct) > 0) then
              ct := StrippedCells[rc,z]
            else
            if Pos('{\',ct) > 0 then
            begin
               CellToRich(rc,z,FRichEdit);
               ct := FRichEdit.Text;
            end;

            if (LinesInText(ct,FMultiLineCells)>1) and
               (FExcelClipboardFormat) then LineFeedsToCSV(ct);
            ptr := StrEnd(StrPCopy(ptr,ct+#9));
          end;
        end;
        Dec(ptr);
        if gd.Top < gd.Bottom then
          ptr := StrEnd(StrPCopy(ptr,#13+#10));
      end;
    end;

    ptr^ := #0;
    ClipBoard.SetTextBuf(buffer)
  finally
    FreeMem(buffer,len);
  end;

  if FNavigation.AllowRTFClipboard then
    CopyRTFFunc(gd.Left,gd.Top);

  if FNavigation.AllowFmtClipboard then
    CopyBinFunc(gd);
end;

procedure TAdvStringGrid.CopySelectionToClipboard;
var
  gd: TGridRect;
begin
  if MouseActions.DisjunctRowSelect then
  begin
    gd.Top := GetSaveStartRow;
    gd.Left := GetSaveStartCol;
    gd.Bottom := GetSaveEndRow;
    gd.Right := GetSaveEndCol;
    CopyFunc(gd,True);
  end
  else
  begin
    if MouseActions.DisjunctColSelect then
    begin
      gd.Top := GetSaveStartRow;
      gd.Left := GetSaveStartCol;
      gd.Bottom := GetSaveEndRow;
      gd.Right := GetSaveEndCol;
      CopyFunc(gd,True);
    end
    else
      CopyFunc(Selection,False);
  end;

  FClipLastOp := coCopy;
end;

procedure TAdvStringGrid.CopyToClipboard;
var
  gd: TGridRect;
begin
  gd.Top := GetSaveStartRow;
  gd.Left := GetSaveStartCol;
  gd.Bottom := GetSaveEndRow;
  gd.Right := GetSaveEndCol;
  CopyFunc(gd,False);
  FClipLastOp := coCopy;
end;

procedure TAdvStringGrid.CutToClipboard;
var
  s,z: Integer;
  gd: TGridRect;
begin
  gd.Top := GetSaveStartRow;
  gd.Left := GetSaveStartCol;
  gd.Bottom := GetSaveEndRow;
  gd.Right := GetSaveEndCol;
  CopyFunc(gd,False);

  for s := gd.Top to gd.Bottom  do
    for z := gd.Left to gd.Right do
      if (IsEditable(z,s) or (Navigation.AllowClipboardAlways)) then
        Cells[s,z] := '';
  FClipLastOp := coCut;
end;

procedure TAdvStringGrid.CutSelectionToClipboard;
var
  s,z: Integer;
begin
  CopySelectionToClipboard;

  if MouseActions.DisjunctRowSelect then
  begin
    for z := FixedRows to RowCount - 1 do
      if RowSelect[z] then ClearRows(z,1);
  end
  else
  begin
    if MouseActions.DisjunctColSelect then
    begin
      for z := FixedCols to ColCount - 1 do
        if ColSelect[z] then ClearCols(z,1);
    end
    else
      with Selection do
      begin
        for s := Left to Right do
           for z := Top to Bottom do
            if IsEditable(s,z) or Navigation.AllowClipboardAlways then
            begin
              Cells[s,z]:='';
            end;

        if Navigation.AllowFmtClipboard then
          ClearPropRect(Left,Top,Right,Bottom);
      end;
  end;

  FClipLastOp := coCut;
end;


procedure TAdvStringGrid.PasteSelectionFromClipboard;
var
  i,j,k: Integer;
  s1,s2: string;
  dt1,dt2,dtv: TDateTime;
  f1,f2,fv: Double;
  i1,i2,iv,err1,err2: Integer;
  da1,da2,mo1,mo2,ye1,ye2,dmo,dye,dda: Word;

begin
  i := PasteFunc(Selection.Left,Selection.Top);

  if not FNavigation.AllowSmartClipboard then
    Exit;

  if (i = 1) and
     ((Selection.Left <> Selection.Right) or
      (Selection.Top <> Selection.Bottom)) then
  begin
    for j := Selection.Left to Selection.Right do
      for k := Selection.Top to Selection.Bottom do
        if IsEditable(j,k) then
          Cells[j,k] := Cells[Selection.Left,Selection.Top];
  end;

  if (i > 1) and
     ((Selection.Left = Selection.Right) or
      (Selection.Top = Selection.Bottom)) then
  begin
    s1 := Cells[Selection.Left,Selection.Top];
    if (Selection.Left = Selection.Right) then
      s2 := Cells[Selection.Left,Selection.Top + 1];
    if (Selection.Top = Selection.Bottom) then
      s2 := Cells[selection.Left + 1,Selection.Top];

    // try dates
    if ((Pos(DateSeparator,s1) > 0) or (Pos(TimeSeparator,s1) > 0)) and
       ((Pos(DateSeparator,s2) > 0) or (pos(TimeSeparator,s2) > 0)) then
    begin
      try
        dt1 := StrToDateTime(s1);
        dt2 := StrToDateTime(s2);

        dtv := dt2 - dt1;

        DecodeDate(dt1,ye1,mo1,da1);
        DecodeDate(dt2,ye2,mo2,da2);

        dmo := mo2 - mo1;
        dye := ye2 - ye1;
        dda := da2 - da1;

        for j := Selection.Left to Selection.Right do
          for k := Selection.Top to Selection.Bottom do
          begin
            if IsEditable(j,k) then
            begin
              if Pos(DateSeparator,s1) > 0 then
                Cells[j,k] := DateToStr(dt1)
              else
                Cells[j,k] := TimeToStr(dt1);
            end;
            dt1 := GetNextDate(dt1,dye,dmo,dda,dtv);
          end;
        except
        end;
        Exit;
      end;

    // try floats
    if (Pos(DecimalSeparator,s1) > 0) or (Pos(DecimalSeparator,s2) > 0) then
    begin
      try
        f1 := StrToFloat(s1);
        f2 := StrToFloat(s2);
        fv := f2 - f1;
        for j := Selection.Left to Selection.Right do
          for k := Selection.Top to Selection.Bottom do
          begin
            if IsEditable(j,k) then
              Cells[j,k] := Format(FloatFormat,[f1]);
            f1 := f1 + fv;
          end;
      except
      end;
      Exit;
    end;

    // try integer
    Val(s1,i1,err1);
    val(s2,i2,err2);

    if (err1 = 0) and (err2 = 0) then
    begin
      iv := i2 - i1;
      for j := Selection.Left to Selection.Right do
        for k := Selection.Top to Selection.Bottom do
        begin

          if IsEditable(j,k) then
            Ints[j,k] := i1;
          i1 := i1 + iv;
        end;
      Exit;
    end;

    // normal text repeat

    if Selection.Left = Selection.Right then
      for k := Selection.Top + i - 1 to Selection.Bottom do
      begin
        if IsEditable(Selection.Left,k) then
          Cells[Selection.Left,k] := Cells[Selection.Left,k - i + 1];
      end;

    if Selection.Top = Selection.Bottom then
      for k := Selection.Left + i to Selection.Right do
      begin
        if IsEditable(k,Selection.Top) then
          Cells[k,Selection.Top] := Cells[k - i,Selection.Top];
      end;

  end;
end;

procedure TAdvStringGrid.PasteFromClipboard;
begin
  PasteFunc(SaveStartCol,SaveStartRow);
end;

{$IFDEF DELPHI4_LVL}
function TAdvStringGrid.PasteSize(p:PChar):TPoint;
var
  Content,endofRow,cr:PChar;
  Rows,Cols,c: Integer;
  tabpos: Integer;
  line: string;

begin
  Content := p;
  EndOfRow := StrScan(Content,#0);

  Rows := 0;
  Cols := 0;

  repeat
    cr := StrScan(Content,#13);
    if cr = nil then
      cr := EndofRow;

    Line := Copy(strpas(Content),1,cr - Content);
    c := 1;
    while (varpos(#9,line,tabpos)>0) do
    begin
      Inc(c);
      Delete(line,1,tabpos);
    end;

    if c > Cols then
      Cols := c;

    Content := cr + 1;
    if Content^ = #10 then
      Content := cr + 2;
    if cr <> EndOfRow then
      Inc(Rows);
  until cr = EndOfRow;

  if (Cols > 0) and (Rows = 0) then
    Rows := 1;

  Result.x := Cols;
  Result.y := Rows;
end;
{$ENDIF}

procedure TAdvStringGrid.PasteInCell(ACol,ARow: Integer; Value: string);
var
  rc: Integer;
begin
  rc := RemapCol(ACol);
  Cells[rc,ARow] := Value;
  // take hidden cells into account
  if rc <> ACol then
    RepaintCell(ACol,ARow);

end;

function TAdvStringGrid.PasteText(ACol,ARow: Integer;p:PChar): Integer;
var
  Content,endofRow:PChar;
  cr:PChar;
  ct,line:string;
  s,z,tabpos: Integer;
  numcells: Integer;
  gr:TGridRect;
  Allow: Boolean;

begin
  Result := 0;

  if (ACol < 0) or (ARow < 0) then
    Exit;

  if not ((goEditing in Options) or
    (Navigation.AllowClipboardAlways) or (MouseActions.RangeSelectAndEdit)) then
     Exit;

  z := ARow;
  s := ACol;
  Content := p;

  EndOfRow := StrScan(Content,#0);

  NumCells := 0;
  gr.Top := ARow;
  gr.Left := ACol;
  gr.Right := ACol;
  gr.Bottom := ARow;

  repeat
    cr := StrScan(Content,#13);
    if cr = nil then
      cr := EndOfRow;

    Line := Copy(StrPas(Content),1,cr - Content);

    while (VarPos(#9,line,TabPos)>0) do
    begin
      ct := Copy(line,1,TabPos - 1);
      if Pos(#10,ct) > 0 then
      begin
        if FExcelClipboardFormat then
        begin
          if Pos('"',ct)=1 then Delete(ct,1,1);
          if Pos('"',ct) = Length(ct) then
            Delete(ct,Length(ct),1);
          CSVToLineFeeds(ct);
        end;
      end;

      if (s <= ColCount) and (z <= RowCount) then
       if (IsEditable(s,z) or (Navigation.AllowClipboardAlways)) then
       begin
         Allow := True;

         if Assigned(FOnClipboardBeforePasteCell) then
           FOnClipboardBeforePasteCell(Self,s,z,ct,Allow);

         if Allow then
           PasteInCell(s,z,ct);
       end;

      Inc(NumCells);
      Delete(line,1,tabpos);
      inc(s);
      if (s > ColCount) and Navigation.AllowClipboardColGrow then
        ColCount := s;
      if s > gr.Right then
        gr.Right := s;
    end;

    if (s <= ColCount) and (z <= RowCount) then
    begin
      if (IsEditable(s,z) or Navigation.AllowClipboardAlways) then
      begin
        if (cr <> EndOfRow) or (Line <> '') then
        begin
          Allow := True;

          if Assigned(FOnClipboardBeforePasteCell) then
            FOnClipboardBeforePasteCell(Self,s,z,Line,Allow);
          if Allow then
            PasteInCell(s,z,Line);
        end;
      end;
    end;

    Inc(NumCells);
    Inc(s);

    if (s > ColCount) and Navigation.AllowClipboardColGrow then
      ColCount := s;
    if s > gr.Right then
      gr.Right := s;

    Content := cr + 1;

    if Content^ = #10 then
    begin
      Content := cr + 2;
    end;

    s := ACol;
    Inc(z);

    if (z = RowCount) and
       (cr <> EndOfRow) and (Content^ <> #0) and
        Navigation.AllowClipboardRowGRow then
    begin
      RowCount := z + 1;
    end;

    if z > gr.Bottom then
      gr.Bottom := z;

  until cr = EndOfRow;

  gr.Bottom := gr.Bottom - 1;
  gr.Right := gr.Right - 1;

  PasteNotify(FClipTopLeft,gr,FClipLastOp);

  CellsChanged(TRect(gr));

  Result := NumCells;
end;

procedure TAdvStringGrid.PasteNotify(orig:TPoint;gr:TGridRect;lastop:TClipOperation);
begin
end;

function TAdvStringGrid.PasteFunc(ACol,ARow: Integer): Integer;
var
  Content: PChar;
  Data: THandle;
  DataPtr: Pointer;
  cf_rtf,cf_gridcells: Integer;
  s: string;
  MemStream: TMemoryStream;
  Clipboard: TClipboard;
  gr:TGridRect;
  gpio: TGridPropIO;

begin
  Result := 0;
  Clipboard := TClipboard.Create;

  if FNavigation.AllowFmtClipboard then
  begin
    OpenClipboard(Handle);
    cf_gridcells := RegisterClipboardformat('TAdvStringGrid Cells');
    CloseClipboard;

    if Clipboard.HasFormat(cf_gridcells) then
    begin
      // this is the preferred format ??
      Clipboard.Open;

      Data := 0;

      try
        Data := GetClipboardData(CF_GRIDCELLS);
        if Data = 0 then
          Exit;

        DataPtr := GlobalLock(Data);
        if DataPtr = nil then
        begin
          Clipboard.Close;
          Clipboard.Free;
          Exit;
        end;

        MemStream := TMemoryStream.Create;
        try
          MemStream.WriteBuffer(DataPtr^, GlobalSize(Data));
          MemStream.Position := 0;

          LoadAtPointFromBinStream(Point(ACol,ARow),MemStream);

          MemStream.Position := 0;

          gpio := TGridPropIO.Create(self);
          MemStream.ReadComponent(gpio);
          gr.Left := ACol;
          gr.Top := ARow;
          gr.Right := gr.Left + gpio.ColCount - 1;
          gr.Bottom := gr.Top + gpio.RowCount - 1;

          if gpio.ID = Integer(Handle) then
            PasteNotify(FClipTopLeft,gr,FClipLastOp)
          else
            PasteNotify(Point(-1,-1),gr,FClipLastOp);

          Result := gpio.ColCount * gpio.RowCount;

          gpio.Free;


        finally
          MemStream.Free;
        end;

      finally
        GlobalUnlock(Data);
      end;

      Clipboard.Close;
      Clipboard.Free;
      Exit;
    end;
  end;

  if FNavigation.AllowRTFClipboard then
  begin
    OpenClipboard(Handle);
    cf_rtf := RegisterClipboardformat('Rich Text Format');
    CloseClipboard;
    if Clipboard.HasFormat(cf_rtf) then
    begin
      Clipboard.Open;
      Data := GetClipboardData(CF_RTF);
      try
        if Data <> 0 then
          Content := PChar(GlobalLock(Data))
        else
          Content := nil
      finally
        if Data <> 0 then
          GlobalUnlock(Data);
        ClipBoard.Close;
      end;
      if Content = nil then Exit;

      s := '';
      while Content^ <> #0 do
      begin
        s := s + Content^;
        Content := Content + 1;
      end;
      if IsEditable(ACol,ARow) then
        Cells[ACol,ARow] := s;
      Clipboard.Free;
      Exit;
     end;
  end;

  if not Clipboard.HasFormat(CF_TEXT) then
  begin
    Clipboard.Free;
    Exit;
  end;

  Clipboard.Open;
  Data := GetClipboardData(CF_TEXT);
  try
    if Data <> 0 then
      Content := PChar(GlobalLock(Data))
    else
      Content := nil;
    if Content <> nil then
      Result := PasteText(ACol,ARow,Content);
  finally
    if Data <> 0 then
      GlobalUnlock(Data);

    ClipBoard.Close;
    Clipboard.Free;
  end;

end;

procedure TAdvStringGrid.LoadFromXLS(filename:string);
begin
  LoadXLS(filename,'');
end;

procedure TAdvStringGrid.LoadFromXLSSheet(filename,sheetname:string);
begin
  LoadXLS(filename,sheetname);
end;

procedure TAdvStringGrid.LoadXLS(Filename,sheetname:string);
var
  FExcel: Variant;
  FWorkbook: Variant;
  FWorksheet: Variant;
  FCell: Variant;
  FArray: Variant;
  s,z: Integer;
  rangestr:string;
  startstr,endstr:string;
  code: Integer;
  sr,er,sc,ec: Integer;
  strtCol,strtRow: Integer;
  ulc: Boolean;
  FOldFixedCols,FOldFixedRows: Integer;

begin
  Screen.Cursor := crHourGlass;

  try
   FExcel := CreateOleObject('excel.application');
  except
   Screen.Cursor := crDefault;
   raise EAdvGridError.Create('Excel OLE server not found');
   Exit;
 end;

  //FExcel.visible:=True;
  FWorkBook := FExcel.WorkBooks.Open(FileName);

  if SheetName = '' then
    FWorkSheet := FWorkBook.ActiveSheet
  else
  begin
    FWorkSheet:=unAssigned;

    for s := 1 to FWorkbook.Sheets.Count do
      if FWorkBook.Sheets[s].Name = SheetName then
        FWorkSheet := FWorkBook.Sheets[s];

    if VarIsEmpty(FWorksheet) then
    begin
      raise EAdvGridError.Create('Excel worksheet '+sheetname+' not found');
      Exit;
    end;
  end;

  rangestr := FWorkSheet.UsedRange.Address;

  {$IFDEF TMSDEBUG}
  DbgStr('Excel used range',rangestr);
  {$ENDIF}

  //decode here how many cells are required, $A$1:$D$8 for example

  startstr := '';
  endstr := '';

  sc := -1;
  ec := -1;

  if Pos(':',rangestr) > 0 then
  begin
    startstr := Copy(rangestr,1,pos(':',rangestr)-1);
    endstr := Copy(rangestr,pos(':',rangestr)+1,255);

    if pos('$',startstr) = 1 then
      Delete(startstr,1,1);

    if pos('$',endstr) = 1 then
      Delete(endstr,1,1);

    ulc := not (Pos('$',startstr) > 0);

    if pos('$',startstr) > 0 then
      Val(copy(startstr,pos('$',startstr)+1,255),sr,code)
    else
      Val(startstr,sr,code);

    if code <> 0 then
      sr := -1;

    if pos('$',endstr) > 0 then
      Val(copy(endstr,pos('$',endstr)+1,255),er,code)
    else
      Val(endstr,er,code);

    if code <> 0 then
      er := -1;

    // now decode the Columns
    if ulc then
    begin
      sc := 1;
      ec := 256;
    end
    else
    begin
      if pos('$',startstr) > 0 then
        startstr := Copy(startstr,1,pos('$',startstr)-1);
        
      if pos('$',endstr) > 0 then
        endstr := Copy(endstr,1,pos('$',endstr) - 1);

      if startstr <> '' then
        sc := ord(startstr[1]) - 64;
        
      if Length(startstr)>1 then
        sc := sc * 26 + ord(startstr[2]) - 64;

      if endstr<>'' then
        ec := ord(endstr[1]) - 64;
      if Length(endstr)>1 then
        ec := ec * 26 + ord(endstr[2]) - 64;
    end;
  end
  else
  begin
    sc := 1;
    sr := 1;
    ec := 1;
    er := 1;
  end;

  {$IFDEF TMSDEBUG}
  DbgMsg('Rows from '+inttostr(sr)+' to '+inttostr(er));
  DbgMsg('Cols from '+inttostr(sc)+' to '+inttostr(ec));
  {$ENDIF}

  FOldFixedCols := FixedCols;
  FOldFixedRows := FixedRows;

  if (sr <> -1) and (er <> -1) and (sc <> -1) and (ec <> -1) then
  begin
    ColCount := ec - sc + 1;
    RowCount := er - sr + 1;
  end;

  farray := VarArrayCreate([1,1 + ec - sc,1,1 + er - sr],varVariant);

  //rangestr:='A1:';

  rangestr := Chr(ord('A') - 1 + sc) + IntToStr(sr)+':';

  if (ColCount > 26) then
  begin
    rangestr := rangestr + chr(ord('A') - 1 + ((1 + ec - sc) div 26));
    rangestr := rangestr + chr(ord('A') - 1 + ((1 + ec - sc) mod 26));
  end
  else
    rangestr := rangestr + Chr(ord('A') - 1 + ec);

  rangestr := rangestr + IntToStr(er);

  farray := FWorkSheet.Range[RangeStr].Value;

  if FSaveFixedCells then
  begin
    strtCol := 0;
    strtRow := 0;
  end
  else
  begin
    StrtCol := FOldFixedCols;
    StrtRow := FOldFixedRows;
    ColCount := ColCount + FOldFixedCols;
    RowCount := RowCount + FOldFixedRows;
  end;

  if ColCount > FOldFixedCols then
    FixedCols := FOldFixedCols;
  if RowCount  >FOldFixedRows then
    FixedRows := FOldFixedRows;

  for s := 1 to RowCount - StrtRow do
  begin
    for z := 1 to ColCount - StrtCol do
    begin
      FCell := FArray[s,z];

      if not (VarType(FCell) in [varEmpty,varDispatch,varError]) then
        LoadCell(z - 1 + StrtCol,s - 1 + StrtRow,FCell);
    end;
  end;

  FWorkBook.Close(SaveChanges:=False);

  FExcel.Quit;
  FExcel := UnAssigned;
  Screen.Cursor := crDefault;
  CellsChanged(Rect(0,0,ColCount,RowCount));
  CellsLoaded;
end;

procedure TAdvStringGrid.LoadFromMDBTable(Filename, Table: string);
begin
  LoadFromMDBSQL(Filename,'SELECT * FROM ' + Table);
end;

procedure TAdvStringGrid.LoadFromMDBSQL(Filename, SQL: string);
var
  ObjConnC, ObjRSC: variant;
  DSN: string;
  i,j,k: Integer;
begin
  ObjConnC := CreateOleObject('ADODB.Connection');

  DSN := 'Driver={Microsoft Access Driver (*.mdb)};DBQ='+Filename;

  ObjConnC.Open(DSN);
  ObjRSC := CreateOleObject('ADODB.RecordSet');
  ObjRSC.ActiveConnection := ObjConnC;
  ObjRSC.Open(SQL);

  i := ObjRSC.Fields.Count;

  ColCount := FixedCols + i;

  if FixedRows > 0 then
    for j := 1 to i do
    begin
      Cells[FixedCols + j - 1, FixedRows - 1] := ObjRSC.Fields[j - 1].Name;
    end;

  if ObjRSC.RecordCount > 0 then
  begin
    RowCount := FixedRows + ObjRSC.RecordCount;
  end;

  k := FixedRows;

  while (ObjRSC.Eof = False) do
  begin
    for j := 1 to i do
    begin
      if ObjRSC.Fields[j - 1].ActualSize > 0 then
        LoadCell(FixedCols + j - 1, k,ObjRSC.Fields[j - 1].Value)
      else
        LoadCell(FixedCols + j - 1, k,'');
    end;
    ObjRSC.MoveNext;
    inc(k);
    if k > RowCount then
      RowCount := RowCount + 1;
  end;
  ObjRSC.Close;
  ObjConnC.Close;
end;


procedure TAdvStringGrid.SavetoDOC(filename:string);
var
  fword: Variant;
  fdoc: Variant;
  ftable: Variant;
  frng: Variant;
  fcell: Variant;
  s,z: Integer;
begin
  Screen.Cursor := crHourGlass;
  try
    FWord := CreateOLEObject('word.application');
  except
    Screen.Cursor := crDefault;
    raise EAdvGridError.Create('Word OLE server not found');
    Exit;
  end;

  try
    FDoc := FWord.Documents.Add;
    FRng := FDoc.Range(start:=0,end :=0);
    FTable := FDoc.Tables.Add(frng,numRows:=RowCount,numColumns:=ColCount);

    for s := 1 to RowCount do
      for z := 1 to ColCount do
      begin
        FCell := FTable.Cell(Row:=s,Column:=z);
        FCell.Range.InsertAfter(SaveCell(RemapCol(z-1),s-1));
        case GetCellAlignment(z-1,s-1).Alignment of
        taRightJustify:FCell.Range.ParagraphFormat.Alignment := wdAlignParagraphRight;
        taCenter:fcell.Range.ParagraphFormat.Alignment := wdAlignParagraphCenter;
        end;
        {
        .Bold = True
        .ParagraphFormat.Alignment = wdAlignParagraphCenter
        .Font.Name = "Arial"
        }
      end;

    FDoc.SaveAs(FileName);
  finally
    FWord.Quit;
    FWord := Unassigned;
    Screen.Cursor := FOldCursor;
  end;
end;

procedure TAdvStringGrid.SavetoXLS(FileName: string);
begin
  SaveXLS(FileName,'');
end;

procedure TAdvStringGrid.SavetoXLSSheet(FileName,SheetName: string);
begin
  SaveXLS(FileName,SheetName);
end;

procedure TAdvStringGrid.SaveXLS(FileName,SheetName: string);
var
  FExcel: Variant;
  FWorkbook: Variant;
  FWorksheet: Variant;
  FArray: Variant;
  s,z: Integer;
  RangeStr: string;
  StrtCol,StrtRow: Integer;
  newbook: Boolean;

begin
  Screen.Cursor := crHourGlass;

  try
    FExcel := CreateOleObject('excel.application');
  except
    Screen.cursor := crDefault;
    raise EAdvGridError.Create('Excel OLE server not found');
    Exit;
  end;

  newbook := True;

  if SheetName = '' then
  begin
    FWorkBook := FExcel.WorkBooks.Add;
    FWorkSheet := FWorkBook.WorkSheets.Add;
  end
  else
  begin
    newbook := False;
    try
      FWorkBook := FExcel.WorkBooks.Open(Filename);
    except
      if VarIsEmpty(FWorkBook) then
        FWorkBook := FExcel.WorkBooks.Add;
      newbook := true;
    end;


    FWorkSheet := unAssigned;
    for s := 1 to FWorkbook.Sheets.Count do
      if (FWorkBook.Sheets[s].Name = sheetname) then
        FWorkSheet := FWorkBook.Sheets[s];

    if VarIsEmpty(FWorksheet) then
     begin
       FWorkSheet := FWorkBook.WorkSheets.Add;
       FWorkSheet.Name := sheetname;
     end;
  end;

  if FSaveFixedCells then
  begin
    StrtCol := 0;
    StrtRow := 0;
  end
  else
  begin
    StrtCol := FixedCols;
    StrtRow := FixedRows;
  end;

  FArray := VarArrayCreate([0,RowCount - 1 - StrtRow,0, ColCount - 1 - StrtCol],VarVariant);

  for s := StrtRow to RowCount - 1 do
  begin
    for z := StrtCol to ColCount - 1 do
    begin
      // FArray[s - StrtRow,z - StrtCol] := '"' + LineFeedsToXLS(SaveCell(RemapCol(z),s)) + '"';
      FArray[s - StrtRow,z - StrtCol] := LineFeedsToXLS(SaveCell(RemapCol(z),s));
    end;
  end;

  RangeStr := 'A1:';

  if (ColCount - StrtCol) > 26 then
  begin
    if (ColCount - StrtCol) mod 26 = 0 then
    begin
      RangeStr := RangeStr + Chr(Ord('A') - 2 + ((ColCount - StrtCol) div 26));
      RangeStr := RangeStr + 'Z';
    end
    else
    begin
      RangeStr := RangeStr + Chr(Ord('A') - 1 + ((ColCount - StrtCol) div 26));
      RangeStr := RangeStr + Chr(Ord('A') - 1 + ((ColCount - StrtCol) mod 26));
    end;
  end
  else
    RangeStr := RangeStr + Chr(Ord('A') - 1 + (ColCount - StrtCol));

  RangeStr := RangeStr + IntToStr(RowCount - StrtRow);

  FWorkSheet.Range[rangestr].Value := FArray;

  if newbook then
    FWorkbook.SaveAs(filename)
  else
    FWorkbook.Save;

  FExcel.Quit;
  FExcel := unAssigned;

  Screen.Cursor := FOldCursor;
end;

procedure TAdvStringGrid.OutputToCSV(FileName:String;appendmode: Boolean);
var
  f: TextFile;
  z,s,n,rs: Integer;
  oprogr,nprogr: Integer;
  CellText: String;
  Delim: Char;

begin
  oprogr := -1;

  if FSaveHiddenCells then
    n := FNumHidden
  else
    n := 0;

  if FDelimiter = #0 then
    Delim := ','
  else
    Delim := FDelimiter;

  AssignFile(f,FileName);

  if AppendMode then
  begin
    {$i-}
    Reset(f);
    {$i+}
    if IOResult <> 0 then
    begin
      {$i-}
      Rewrite(f);
      {$i+}
      if IOResult <> 0 then raise EAdvGridError.Create('Cannot Create file '+FileName);
    end
    else
      Append(f);
  end
  else
  begin
    {$i-}
    Rewrite(f);
    {$i+}
    if IOResult<>0 then raise EAdvGridError.Create('Cannot Create file '+FileName);
  end;

  for z := SaveStartRow to SaveEndRow do
  begin
    for s := SaveStartCol to SaveEndCol + n do
    begin
      if s > SaveStartCol then
        write(f,Delim);

      if FSaveHiddenCells then
        rs := s
      else
        rs := RemapCol(s);

      CellText := SaveCell(rs,z);

      CellText := CSVQuotes(CellText);

      if FOemConvert then
        StringToOem(CellText);

      if FAlwaysQuotes then
        CellText := '"' + CellText + '"';
          
      if CellText = '' then
      begin
        if JavaCSV then
          CellText := '^'
        else
          if QuoteEmptyCells then
            CellText := '""';
      end;

      if (Pos(Delim,CellText) > 0) or (LinesInText(CellText,FMultiLineCells) > 1) then
      begin
        if JavaCSV then
          LinefeedstoJava(CellText)
        else
          LinefeedsToCSV(CellText);
      end;
      Write(f,CellText);
    end;
    Writeln(f);

    if Assigned(FOnFileProgress) then
    begin
      nprogr := Round(z/(RowCount-1)*100);
      if nprogr <> oprogr then
        FOnFileProgress(self,nprogr);
      oprogr := nprogr;
    end;
  end;
  CloseFile(f)
end;

procedure TAdvStringGrid.SaveToCSV(FileName:String);
begin
  OutputToCSV(FileName,False);
end;

procedure TAdvStringGrid.AppendToCSV(FileName:String);
begin
  OutputToCSV(FileName,True);
end;

procedure TAdvStringGrid.InputFromCSV(Filename:string;insertmode: Boolean);
var
  buffer,celltext: string;
  s,z: Integer;
  f: TextFile;
  strtCol,strtRow: Integer;
  c1,c2,cm: Integer;
  OldDelimiter: Char;
  linecount,linepos: Integer;
  delimiterpos,quotepos: Integer;
  oprogr,nprogr: Smallint;
  lr: TStringList;

begin
  StrtCol := FixedCols;
  StrtRow := FixedRows;

  if FSaveFixedCells then
  begin
    StrtCol := 0;
    StrtRow := 0;
  end;

  AssignFile(f, FileName);
  {$i-}
  Reset(f);
  {$i+}
  if (IOResult<>0) then
    raise EAdvGridError.Create('Cannot open file ' + FileName);

  z := StrtRow;

  lr := TStringList.Create;

  if InsertMode then
  begin
    z := RowCount;
    if FloatingFooter.Visible then
    begin
      lr.Assign(Rows[RowCount - 1]);
      NilRow(RowCount - 1);
      dec(z);
    end;  
  end;

  OldDelimiter := FDelimiter;

  // do intelligent estimate of the separator
  if FDelimiter = #0 then
  begin
    CellText := '';
    ReadLn(f,buffer);
    if not Eof(f) then ReadLn(f,CellText);
    Reset(f);
    cm := 0;
    for s := 1 to 5 do
    begin
      c1 := NumSingleChar(CSVSeparators[s],Buffer);
      c2 := NumSingleChar(CSVSeparators[s],Celltext);
      if (c1 = c2) and (c1 > cm) then
      begin
        FDelimiter := CSVSeparators[s];
        cm := c1;
      end;
    end;

    if cm = 0 then
      for s := 1 to 5 do
      begin
        c1 := NumChar(CSVSeparators[s],Buffer);
        c2 := NumChar(CSVSeparators[s],Celltext);
        if (c1 = c2) and (c1 > cm) then
        begin
          FDelimiter := CSVSeparators[s];
          cm := c1;
        end;
      end;

    // if no matching delimiter count found on line1 & line2, take maximum
    if cm = 0 then
      for s := 1 to 5 do
      begin
        c1 := NumChar(CSVSeparators[s],Buffer);
        c2 := NumChar(CSVSeparators[s],Celltext);
        if (c1 > cm) or (c2 > cm) then
        begin
          FDelimiter := CSVSeparators[s];
          cm := Max(c1,c2);
        end;
      end;
  end;

  LineCount := 0;

  if Assigned(FOnFileProgress) then
  begin
    Reset(f);
    while not Eof(f) do
    begin
      ReadLn(f,buffer);
      Inc(LineCount);
    end;

    if InsertMode then
      RowCount := RowCount + Linecount
    else
      Rowcount := StrtRow + LineCount + FixedFooters;
  end;

  Reset(f);

  oprogr := -1;
  LinePos := 0;

  while not Eof(f) do
  begin
    ReadLn(f,buffer);
    if FOemConvert then
      OemToString(Buffer);

    s := StrtCol;

    if z >= RowCount - FixedFooters then
    begin
      RowCount := z + 1000;
    end;

    while VarCharPos(FDelimiter,Buffer,DelimiterPos) > 0 do
    begin
      if Buffer[1] = '"' then
      begin
        Delete(buffer,1,1);   //delete first quote from buffer
        if SinglePos('"',Buffer,QuotePos) > 0 then  //search for next single quote
        begin
          CellText := Copy(buffer,1,QuotePos-1);
          CellText := DoubleToSingleChar('"',CellText);
          Delete(buffer,1,QuotePos);
        end
        else
          CellText := '';
        VarCharPos(FDelimiter,buffer,DelimiterPos);
      end
      else
      begin
        CellText := Copy(buffer,1,DelimiterPos - 1);
        CellText := DoubleToSingleChar('"',CellText);
      end;

      if JavaCSV then
        JavaToLineFeeds(CellText)
      else
        CSVToLineFeeds(CellText);

      LoadCell(s,z,CellText);

      Delete(buffer,1,DelimiterPos);

      Inc(s);
      if s >= ColCount then
        ColCount := s;
    end;

    if Length(Buffer) > 0 then
    begin
      if Buffer[1] = '"' then
        Delete(buffer,1,1);
      if Length(Buffer) > 0 then
      begin
        if Buffer[Length(Buffer)] = '"' then
          Delete(Buffer,Length(Buffer),1);
      end;

      CellText := DoubleToSingleChar('"',Buffer);

      if JavaCSV then
        JavaToLineFeeds(CellText)
      else
        CSVToLineFeeds(CellText);

      LoadCell(s,z,CellText);
      
      Inc(s);
      if s > ColCount then
        ColCount := s;
    end;

    Inc(z);

    if Assigned(FOnFileProgress) then
    begin
      Inc(LinePos);
      nprogr := Round(LinePos / LineCount * 100);
      if nprogr <> oprogr then
        FOnFileProgress(Self,nprogr);
      oprogr := nprogr;
    end;

  end;

  CloseFile(f);

  RowCount := z + FixedFooters;

  if FloatingFooter.Visible then
    Rows[RowCount - 1].Assign(lr);

  lr.Free;

  FDelimiter := OldDelimiter;
  CellsChanged(Rect(0,0,ColCount,RowCount));
  CellsLoaded;
end;


procedure TAdvStringGrid.LoadFromCSV(Filename:string);
begin
  InputFromCSV(Filename,False);
end;

procedure TAdvStringGrid.InsertFromCSV(Filename:string);
begin
  InputFromCSV(FileName,True);
end;

procedure TAdvStringGrid.SavetoStream(Stream: TStream);
var
  ss,CellText: string;
  i,j: Integer;

  procedure Writestring(s:string);
  var
    buf:PChar;
    c: array[0..1] of char;
  begin
    GetMem(buf,Length(s) + 1);
    StrPLCopy(buf,s,Length(s));
    Stream.Writebuffer(buf^,Length(s));
    c[0] := #13;
    c[1] := #10;
    Stream.Writebuffer(c,2);
    FreeMem(buf);
  end;

begin
  ss := IntToStr(SaveColCount) + ',' + IntToStr(SaveRowCount);
  WriteString(ss);

  //save column Widths
  for i := 1 to ColCount do
    WriteString('cw '+IntToStr(i-1) + ',' + IntToStr(ColWidths[i - 1]));

  //save cell contents
  for i := SaveStartRow to SaveEndRow do
  begin
    for j := SaveStartCol to SaveEndCol do
    begin
      CellText := SaveCell(j,i);
      if CellText <> '' then
      begin
        ss := IntToStr(j - SaveStartCol) + ',' + IntToStr(i - SaveStartRow) + ',' + LFToFile(CellText);
        Writestring(ss);
      end;
    end;
  end;
end;

procedure TAdvStringGrid.SaveToFixed(FileName:string;positions: TIntList);
var
  f: TextFile;
  c,r,m,n: Integer;
  s,su: string;

begin
  Assignfile(f,FileName);
  {$i-}
  ReWrite(f);
  {$i+}
  if IOResult <> 0 then
    raise EAdvGridError.Create('Cannot Create file '+FileName);

  for c := SaveStartCol to SaveEndCol do
    if Positions.Count-1 < c - SaveStartCol then Positions.Add(MaxCharsInCol(c) + 1);

  for r := SaveStartRow to SaveEndRow do
  begin
    s := '';
    for c := SaveStartCol to SaveEndCol do
    begin
      su := SaveCell(c,r);
      n := Length(su);

      if n > Positions.Items[c - SaveStartCol] then
        su := Copy(su,1,Positions.Items[c - SaveStartCol])
      else
        for m := 1 to Positions.Items[c - SaveStartCol] - n do
          su := su + ' ';

      s := s + su;
    end;
    WriteLn(f,s);
  end;
  CloseFile(f);
end;

procedure TAdvStringGrid.LoadFromFixed(filename:string; positions:TIntList);
var
  f: TextFile;
  s,sub: string;
  c,r,i: Integer;

begin
  AssignFile(f, FileName);
  {$i-}
  Reset(f);
  {$i+}
  if IOResult <> 0 then
    raise EAdvGridError.Create('File ' + FileName + ' not found');

  ColCount := FixedCols + Positions.Count - 1;

  r := SaveStartRow;

  while not Eof(f) do
  begin
    ReadLn(f,s);
    c := SaveStartCol;

    for i := 2 to Positions.Count do
    begin
      sub := Copy(s,Positions.Items[i-2],Positions.Items[i-1] - Positions.Items[i-2]);
      LoadCell(c,r,Trim(sub));
      Inc(c);
    end;

    Inc(r);

    if (r >= RowCount) and not Eof(f) then
      RowCount := r + 1;
  end;

  CloseFile(f);
  CellsChanged(Rect(0,0,ColCount,RowCount));
  CellsLoaded;
end;

procedure TAdvStringGrid.LoadFromStream(stream:tStream);
var
  X,Y: Integer;
  ss,ss1: string;

  function ReadString(var s:string): Integer;
  var
    c: char;
  begin
    c := '0';
    s := '';
    while (Stream.Position < Stream.Size) and (c <> #13) do
    begin
      Stream.Read(c,1);
      if (c <> #13) then s := s + c;
    end;
    Stream.Read(c,1); {read the #10 newline marker}
    Result := Length(s);
  end;

begin
  {Allow to put other data before Grid's data in the stream}
  {stream.position:=0;}

  if (Stream.Position < Stream.Size) then
  begin
    if (Readstring(ss) > 0) then
    begin
      ss1 := Copy(ss,1,Pos(',',ss) - 1);
      ColCount := StrToInt(ss1) + SaveStartCol;
      ss1 := Copy(ss,Pos(',',ss) + 1,Length(ss));
      RowCount := StrToInt(ss1) + SaveStartRow;
    end;
  end;

  while (Stream.Position < Stream.Size) do
  begin
    ReadString(ss);
    if Pos('cw',ss)=1 then
    begin
      Delete(ss,1,3);
      ss1 := GetToken(ss,',');
      X := StrToInt(ss1);
      Y := StrToInt(ss);
      ColWidths[X]:=Y;
    end
    else
    begin
      ss1 := GetToken(ss,',');
      X := StrToInt(ss1);
      ss1 := GetToken(ss,',');
      Y := StrToInt(ss1);
      LoadCell(X+SaveStartCol,Y+SaveStartRow,FileToLF(ss,FMultiLineCells));
    end;
  end;

  CellsChanged(Rect(0,0,ColCount,RowCount));
  CellsLoaded;
end;

function TAdvStringGrid.ColumnSum(ACol,FromRow,ToRow: Integer):Double;
var
  i: Integer;
  sum: Double;
begin
  sum := 0;
  for i := FromRow to ToRow do
    Sum := Sum + Floats[ACol,i];
  Result := sum;
end;

function TAdvStringGrid.ColumnAvg(ACol,FromRow,ToRow: Integer):Double;
begin
  Result := ColumnSum(ACol,FromRow,ToRow)/(ToRow - FromRow + 1);
end;

function TAdvStringGrid.ColumnMin(ACol,fromRow,toRow: Integer):Double;
var
  m: Double;
  i: Integer;
begin
  m := Floats[ACol,fromRow];
  for i:=FromRow to ToRow do
    if m > Floats[ACol,i] then
      m := Floats[ACol,i];
  Result := m;
end;

function TAdvStringGrid.ColumnMax(ACol,FromRow,ToRow: Integer):Double;
var
  m: Double;
  i: Integer;
begin
  m := Floats[ACol,fromRow];
  for i := FromRow to ToRow do
    if m < Floats[ACol,i] then
       m := Floats[ACol,i];
  Result := m;
end;

function TAdvStringGrid.RowSum(ARow,FromCol,ToCol: Integer):Double;
var
  i: Integer;
  sum: Double;
begin
  sum := 0.0;
  for i := FromCol to ToCol do
    sum := sum + Floats[i,ARow];
  RowSum := sum;
end;

function TAdvStringGrid.RowAvg(ARow,FromCol,ToCol: Integer):Double;
begin
  Result := RowSum(ARow,FromCol,ToCol)/(ToCol - FromCol);
end;

function TAdvStringGrid.RowMin(ARow,FromCol,ToCol: Integer):Double;
var
  m: Double;
  i: Integer;
begin
  m := Floats[FromCol,ARow];
  for i := FromCol to ToCol do
    if m > Floats[i,ARow] then
      m := Floats[i,ARow];
  Result := m;
end;

function TAdvStringGrid.RowMax(ARow,fromCol,toCol: Integer):double;
var
  m: Double;
  i: Integer;
begin
  m := Floats[fromCol,ARow];
  for i := FromCol to ToCol do
    if m < Floats[i,ARow] then
      m := Floats[i,ARow];
  Result := m;
end;

function TAdvStringGrid.SelectedText:string;
var
  s,z: Integer;
  ct,ts: string;
  gr: TGridRect;

begin
  ts := '';
  gr := Selection;

  {$IFDEF DELPHI4_LVL}
  if (goRowSelect in Options) and (FDragDropSettings.FOleEntireRows) then
  begin
    gr.Left := 0;
    gr.Right := ColCount-1;
  end;
  {$ENDIF}

  if FMouseActions.DisjunctRowSelect then
  begin
    for z := FixedRows to RowCount - 1 do
    if RowSelect[z] then
     begin
       for s := gr.Left to gr.Right do
       begin
         ct := Cells[s,z];
         if Pos('{\',ct) > 0 then
         begin
           CellToRich(s,z,FRichEdit);
           ct := FRichEdit.Text;
         end;
         if (LinesInText(ct,fMultiLineCells) > 1) and
            FExcelClipboardformat then LineFeedsToCSV(ct);
         if s <> gr.Right then
           ts := ts + ct + #9
         else
           ts := ts + ct;
       end;
       if z <> gr.Bottom then
         ts := ts + #13#10;
     end;
   end
  else
  for z := gr.Top to gr.Bottom do
  begin
    for s := gr.Left to gr.Right do
    begin
      ct := Cells[s,z];
      if Pos('{\',ct) > 0 then
      begin
        CellToRich(s,z,FRichEdit);
        ct := FRichEdit.Text;
      end;
      if (LinesInText(ct,fMultiLineCells) > 1) and
         FExcelClipboardformat then LineFeedsToCSV(ct);
      if s <> gr.Right then
        ts := ts + ct + #9
      else
        ts := ts + ct;
    end;
    if z <> gr.Bottom then
      ts := ts + #13#10;
  end;
  Result := ts;
end;

function TAdvStringGrid.IsSelected(ACol,ARow: Integer): Boolean;
begin
  Result := False;
  if (ARow < FixedRows) or (ACol < FixedCols) then Exit;

  if FMouseActions.DisjunctRowSelect then
    Result := RowSelect[ARow]
  else
  begin
    if FMouseActions.DisjunctColSelect then
      Result := ColSelect[ACol]
    else
      Result := (ACol >= Selection.Left) and
                (ACol <= Selection.Right) and
                (ARow >= Selection.Top) and
                (ARow <= Selection.Bottom);
  end;              
end;

procedure TAdvStringGrid.AutoNumberCol(const ACol: Integer);
var
  r: Integer;
begin
  if RowCount > 0 then
  for r := FixedRows + FAutoNumberStart to RowCount -1 - FFixedFooters do
    if FAutoNumberDirection = sdAscending then
      Ints[ACol,r] := r - FixedRows + 1 + FAutoNumberOffset
    else
      Ints[ACol,RowCount -1 - FFixedFooters - r + FixedRows] := r - FixedRows + 1 + FAutoNumberOffset;
end;

procedure TAdvStringGrid.AutoNumberRow(const ARow: Integer);
var
  c: Integer;
begin
  if ColCount > 0 then
  for c := FixedCols + FAutoNumberStart  to ColCount -1 - FFixedRightCols do
    if FAutoNumberDirection = sdAscending then
      Ints[c,ARow] := c - FixedCols + 1 + FAutoNumberOffset
    else
      Ints[ColCount -1 - FFixedRightCols - c + FixedCols,ARow] := c - FixedCols + 1 + FAutoNumberOffset;
end;


procedure TAdvStringGrid.AutoSizeCells(const DoFixedCells: Boolean; const PaddingX,PaddingY: Integer);
var
  i,j,x,y,SCol: Integer;
  TextSize: TSize;
  pt: TPoint;
  ow,nw,oh,nh: Integer;

begin
  if DoFixedCells then
  begin
    x := 0;
    y := 0;

  end
  else
  begin
    x := FixedCols;
    y := FixedRows;
  end;

  BeginUpdate;

  for i := x to ColCount - 1 do
  begin
    SCol := RemapCol(i);

    if SizeGrowOnly then
      ow := ColWidths[i]
    else
      ow := 0;

    for j := y to RowCount - 1 do
    begin
      oh := RowHeights[j];

      if (i < FixedCols) or (j < FixedRows) then
        Canvas.Font.Assign(FixedFont)
      else
        Canvas.Font.Assign(Font);

      GetCellColor(i,j,[],Canvas.Brush,Canvas.Font);

      pt := CellGraphicSize[i,j];

      TextSize := GetCellTextSize(SCol,j,False);

      TextSize.cx := TextSize.cx + pt.x + paddingx;
      TextSize.cy := TextSize.cy + pt.y + paddingy;

      if not IsXMergedCell(i,j) then
      begin                          
        if (TextSize.cx > ow) then
        begin
          nw := CheckLimits(TextSize.cx,MinColWidth,MaxColWidth);
          if nw > ow then
          begin
            ColWidths[i] := nw;
            ow := nw;
          end;
        end;
      end;

      if not IsYMergedCell(i,j) then
      begin
        if (TextSize.cy > oh) then
        begin
          nh := CheckLimits(TextSize.cy,MinRowHeight,MaxRowHeight);
          if nh > oh then
          begin
            RowHeights[j] := nh;
          end;
        end;
      end;
    end;
  end;

  EndUpdate;
end;

procedure TAdvStringGrid.AutoSizeColumns(const DoFixedCols: Boolean; const Padding: Integer);
var
  i,j: Integer;
begin
  if DoFixedCols then
    j := 0
  else
    j := FixedCols;

  for i := j to ColCount - 1 do
  begin
    AutoSizeCol(i);
    if Padding <> 0 then
      ColWidths[i] := CheckLimits(ColWidths[i] + Padding, MinColWidth, MaxColWidth);
  end;
end;

procedure TAdvStringGrid.SizeToWidth(const ACol: Integer;IncOnly: Boolean);
var
  MaxWidth, TextW, NewW, i: Integer;
  cg: TCellGraphic;
begin
  MaxWidth := 0;

  for i := 0 to RowCount - 1 do
  begin
    if not IsXMergedCell(ACol,i) then
    begin
      if (ACol < FixedCols) or (i < FixedRows) then
        Canvas.Font.Assign(FixedFont)
      else
        Canvas.Font.Assign(Font);

      GetCellColor(ACol,i,[],Canvas.Brush,Canvas.Font);

      Canvas.Font.Size := Canvas.Font.Size + ZoomFactor;

      TextW := GetCellTextSize(RemapCol(ACol),i,False).cx + CellGraphicSize[ACol,i].x;

      cg := GetCellGraphic(ACol,i);

      if Assigned(cg) then
        if cg.FCellVAlign = vaFull then
          TextW := CellGraphicSize[ACol,i].x - (XYOffset.X + 2 * (GridLineWidth + 1)) ;

      if TextW > MaxWidth then
        MaxWidth := TextW;
    end;
  end;

  // Allow 2 pixel spacing at begin & end
  NewW := MaxWidth + XYOffset.X + 2 * (GridLineWidth + 1);

  if (IncOnly and (NewW > ColWidths[ACol])) or
     not IncOnly then
  begin
    UpdateAutoColSize(ACol,NewW);
    ColWidths[ACol] := CheckLimits(NewW,MinColWidth,MaxColWidth);
  end;
end;

procedure TAdvStringGrid.SizeToHeight(const ARow: Integer;IncOnly: Boolean);
var
  cg: TCellGraphic;
  MaxHeight, TextH, NewH, i: Integer;
  NoScroll: Boolean;
begin
  MaxHeight := 0;

  for i := 0 to ColCount - 1 do
  begin
    if not IsYMergedCell(i,ARow) then
    begin
      if (ARow < FixedRows) or (i < FixedCols) then
        Canvas.Font.Assign(FixedFont)
      else
        Canvas.Font.Assign(Font);

      GetCellColor(i,ARow,[],Canvas.Brush,Canvas.Font);

      Canvas.Font.Size := Canvas.Font.Size + ZoomFactor;

      TextH := GetCellTextSize(RemapCol(i),ARow,WordWrap).cy + CellGraphicSize[i,ARow].y;

      // When merged, do not take the content of "invisible" cells into account for the height
      if IsMergedCell(i, ARow) then
      begin
        if not IsBaseCell(i,ARow) then
          TextH := 0;
      end;

      cg := GetCellGraphic(i,ARow);

      if Assigned(cg) then
        if cg.FCellVAlign = vaFull then
          TextH := CellGraphicSize[i,ARow].y - (XYOffset.Y + 2 * (GridLineWidth + 1)) ;

      if TextH > MaxHeight then
        MaxHeight := TextH;
    end;
  end;

  // Allow 2 pixel spacing at begin & end
  NewH := MaxHeight + XYOffset.Y + 2 * (GridLineWidth);


  NoScroll := (VisibleRowCount = RowCount) and EditMode and SizeWhileTyping.Height;

  if (IncOnly and (NewH > RowHeights[ARow])) or
     not IncOnly then
  begin
    // UpdateAutoRowSize(ARow,NewH);
    RowHeights[ARow] := CheckLimits(NewH,MinRowHeight, MaxRowHeight);
  end;

  if (VisibleRowCount <> RowCount) and NoScroll then
  begin
    ShowInplaceEdit;
    NormalEdit.SelStart := length(NormalEdit.Text);
  end;
end;


procedure TAdvStringGrid.AutoSizeCol(const ACol: Integer);
begin
  SizetoWidth(ACol,SizeGrowOnly);
end;

procedure TAdvStringGrid.AutoSizeRows(const DoFixedRows: Boolean; const Padding: Integer);
var
  i,j: Integer;
begin
  if RowCount = 0 then
    Exit;

  if DoFixedRows then
    j := 0
  else
    j := FixedRows;

  for i := j to RowCount-1 do
    if Wordwrap then
    begin
      AutoSizeRow(i);
      if Padding <> 0 then
        RowHeights[i] := CheckLimits(RowHeights[i] + Padding, MinRowHeight, MaxRowHeight);
    end
    else
      SizeToLines(i,MaxLinesInRow(i),Padding)
end;

procedure TAdvStringGrid.SizeToLines(const ARow,Lines,padding: Integer);
var
  th: Integer;

begin
  th := Canvas.TextHeight('gh');
  RowHeights[ARow] := CheckLimits(Padding+((th + (th shr 3)) * Lines),MinRowHeight,MaxRowHeight);
end;

procedure TAdvStringGrid.AutoSizeRow(const ARow: Integer);
begin
  SizetoHeight(ARow,SizeGrowOnly);
end;

procedure TAdvStringGrid.SwapColumns(ACol1, ACol2: Integer);
var
 cw: Integer;
begin
  ColCount := ColCount + 1 + FNumHidden;
  Cols[ColCount - 1] := Cols[ACol1];
  Cols[ACol1] := Cols[ACol2];
  Cols[ACol2] := Cols[ColCount - 1];
  ColCount := ColCount - 1 - FNumHidden;
  cw := ColWidths[ACol1];
  ColWidths[ACol1] := ColWidths[ACol2];
  ColWidths[ACol2] := cw;
  if FSortSettings.Column = ACol1 then
    FSortSettings.Column := ACol2
  else
    if FSortSettings.Column = ACol2 then
      FSortSettings.Column := ACol1;
end;

procedure TAdvStringGrid.SwapRows(ARow1, ARow2: Integer);
var
 rh: Integer;
begin
  RowCount := RowCount + 1;
  Rows[RowCount - 1] := Rows[ARow1];
  Rows[ARow1] := Rows[ARow2];
  Rows[ARow2] := Rows[RowCount - 1];

  FNilObjects := True;
  ClearRows(RowCount-1,1);
  FNilObjects := False;

  RowCount := RowCount - 1;
  rh := RowHeights[ARow1];
  RowHeights[ARow1] := RowHeights[ARow2];
  RowHeights[ARow2] := rh;
end;

procedure TAdvStringGrid.SortSwapRows(ARow1, ARow2: Integer);
var
  h1,h2: Integer;
  rs: Boolean;
  s: string;
  o: TObject;
begin
  inc(Swaps);

  if (FSortRowXRef.Count >= ARow1) and (FSortRowXRef.Count >= ARow2) then
  begin
    h1 := FSortRowXRef.Items[ARow1];
    FSortRowXRef.Items[ARow1] := FSortRowXRef.Items[ARow2];
    FSortRowXRef.Items[ARow2] := h1;
  end;

  if FSortSettings.SingleColumn then
  begin
    s := Cells[FSortSettings.Column, ARow1];
    o := GridObjects[FSortSettings.Column, ARow1];
    Cells[FSortSettings.Column, ARow1] := Cells[FSortSettings.Column, ARow2];
    GridObjects[FSortSettings.Column, ARow1] := GridObjects[FSortSettings.Column, ARow2];
    Cells[FSortSettings.Column, ARow2] := s;
    GridObjects[FSortSettings.Column, ARow2] := o;
    Exit;
  end;

  h1 := RowHeights[ARow1];
  h2 := RowHeights[ARow2];

  SortList.Assign(Rows[ARow1]);
  Rows[ARow1] := Rows[ARow2];
  Rows[ARow2].Assign(SortList);

  if h1 <> h2 then
  begin
    RowHeights[ARow1] := h2;
    RowHeights[ARow2] := h1;
  end;

  if FMouseActions.FDisjunctRowSelect and FNavigation.MoveRowOnSort then
  begin
    rs := RowSelect[ARow1];
    RowSelect[ARow1] := RowSelect[ARow2];
    RowSelect[ARow2] := rs;
  end;

  if ARow1 = SortRow then
    SortRow := ARow2
  else
    if ARow2=SortRow then
      SortRow := ARow1;
end;

procedure TAdvStringGrid.SetPreviewPage(Value: Integer);
begin
  FPrintPageFrom := Value;
  FPrintPageTo := Value;
end;

procedure TAdvStringGrid.PrintPreview(Canvas:TCanvas;DisplayRect:TRect);
var
  gr: TGridRect;
begin
  gr.Top := 0;
  gr.Left := 0;
  gr.Bottom := RowCount - 1;
  gr.Right := ColCount - 1;
  PrivatePrintPreviewRect(Canvas,DisplayRect,gr,False);
end;

procedure TAdvStringGrid.PrintPreviewRect(Canvas:TCanvas;DisplayRect:TRect;Gridrect:TGridRect);
begin
  PrivatePrintPreviewRect(Canvas,DisplayRect,GridRect,False);
end;

procedure TAdvStringGrid.PrintPreviewSelection(Canvas:TCanvas;DisplayRect:TRect);
begin
  PrivatePrintPreviewRect(Canvas,DisplayRect,Selection,False);
end;

procedure TAdvStringGrid.PrintPreviewSelectedRows(Canvas:TCanvas;DisplayRect:TRect);
var
  gr: TGridRect;
begin
  gr.Top := 0;
  gr.Left := 0;
  gr.Bottom := RowCount - 1;
  gr.Right := ColCount - 1;
  PrivatePrintPreviewRect(Canvas,DisplayRect,gr,True);
end;

procedure TAdvStringGrid.PrintPreviewSelectedCols(Canvas:TCanvas;DisplayRect:TRect);
var
  gr: TGridRect;
begin
  gr.Top := 0;
  gr.Left := 0;
  gr.Bottom := RowCount - 1;
  gr.Right := ColCount - 1;
  PrivatePrintPreviewRect(Canvas,DisplayRect,gr,True);
end;

procedure TAdvStringGrid.PrivatePrintPreviewRect(Canvas:TCanvas;displayrect:TRect;Gridrect:TGridRect;SelRows: Boolean);
var
  i: Integer;
  mm: Integer;
begin
  FPrintRect := Gridrect;
  mm := GetMapMode(Canvas.Handle);
  SetMapMode(Canvas.Handle,mm_lometric); {everything in 0.1mm}
  PrevRect := DisplayRect;
  if not FFastPrint then
  begin
    i := BuildPages(Canvas,prCalcPreview,-1,SelRows);
    FPrintPageNum := i;
  end
  else
    i:=1;

  Prevrect := DisplayRect;
  BuildPages(Canvas,prPreview,i,SelRows);
  SetMapMode(Canvas.Handle,mm);
end;

procedure TAdvStringGrid.Print;
var
  gr: TGridRect;
begin
  gr.Top := 0;
  gr.Left := 0;
  gr.Bottom := RowCount - 1;
  gr.Right := ColCount - 1;
  PrivatePrintRect(gr,False);
end;

procedure TAdvStringGrid.PrintSelection;
begin
  PrivatePrintRect(Selection,False);
end;

procedure TAdvStringGrid.PrintRect(Gridrect:TGridRect);
begin
  PrivatePrintRect(GridRect,False);
end;

procedure TAdvStringGrid.PrintSelectedRows;
var
  gr: TGridRect;
begin
  gr.Top := 0;
  gr.Left := 0;
  gr.Bottom := RowCount - 1;
  gr.Right := ColCount - 1;
  PrivatePrintRect(gr,True);
end;

procedure TAdvStringGrid.PrintSelectedCols;
var
  gr: TGridRect;
begin
  gr.Top := 0;
  gr.Left := 0;
  gr.Bottom := RowCount - 1;
  gr.Right := ColCount - 1;
  PrivatePrintRect(gr,True);
end;


procedure TAdvStringGrid.PrivatePrintRect(Gridrect:TGridRect;SelRows: Boolean);
var
  i: Integer;
  mm: Integer;

begin
  FPrintRect := Gridrect;
  with Printer do
  begin
    Orientation := FPrintSettings.orientation;

    PrevRect.Top := 0;
    PrevRect.Left := 0;
    PrevRect.Right := Round(254/GetDeviceCaps(Printer.Handle,LOGPIXELSX)*(Printer.PageWidth));
    PrevRect.Bottom := Round(254/GetDeviceCaps(Printer.Handle,LOGPIXELSY)*(Printer.PageHeight));

    if not FFastPrint then
      i := BuildPages(Self.Canvas,prCalcPrint,-1,SelRows)
    else i := 1;

    FPrintPageFrom := 1;
    FPrintPageTo := i;
    FPrintPageNum := i;

    if Assigned(FOnPrintStart) then
    begin
      FOnPrintStart(Self,i,FPrintPageFrom,FPrintPageTo);

      if (FPrintPageFrom = 0) or (FPrintPageTo = 0) or
        (FPrintPageTo < FPrintPageFrom) then Exit;
    end;

    FPrintPageNum := FPrintPageTo;

    Title := FPrintSettings.JobName;
    BeginDoc;
    mm := GetMapMode(Canvas.Handle);
    SetMapMode(Canvas.Handle,mm_lometric);
    BuildPages(Canvas,prPrint,i,SelRows);
    SetMapMode(Canvas.Handle,mm);
    EndDoc;
  end;
end;



procedure TAdvStringGrid.PrintDraw(Canvas:TCanvas;DrawRect: TRect);
var
  gr: TGridRect;
begin
  gr.Top := 0;
  gr.Left := 0;
  gr.Bottom := RowCount - 1;
  gr.Right := ColCount - 1;
  PrintDrawRect(Canvas,DrawRect,gr);
end;

procedure TAdvStringGrid.PrintDrawRect(Canvas:TCanvas;drawrect:TRect;GridRect:TGridRect);
var
  mm: Integer;
begin
  FPrintRect := GridRect;
  Prevrect := DrawRect;
  FPrintPageFrom := 1;
  FPrintPageTo := 1;
  FPrintPageNum := 1;
  mm := GetMapMode(Canvas.Handle);
  SetMapMode(Canvas.Handle,mm_lometric);
  BuildPages(Canvas,prPrint,1,False);
  SetMapMode(Canvas.Handle,mm);
end;


function TAdvStringGrid.MaxLinesInGrid: Integer;
var
  i,j,k: Integer;
begin
  Result := 1;
  if (ColCount <= 0) or (RowCount <= 0) then
    Exit;
  if not FMultiLineCells then
    Exit;

  for i := 0 to ColCount - 1 do
    for j := 0 to RowCount - 1 do
    begin
      k := LinesInText(Cells[RemapCol(i),j],fMultiLineCells);
      if k > Result then Result := k;
    end;
  MaxLinesInGrid := Result;  
end;

function TAdvStringGrid.MaxCharsInCol(ACol: Integer): Integer;
var
  i,k,rc: Integer;
  s,substr: string;

begin
  Result := 0;
  rc := RemapCol(ACol);

  for i := 0 to RowCount - 1 do
  begin
    s := SaveCell(rc,i);
    repeat
      substr := GetNextLine(s,FMultiLineCells);
      k := Length(substr);
      if k > Result then
        Result := k;
    until s = '';
  end;
end;

procedure PositionText(var ARect:TRect;hal:TAlignment;val:TVAlignment;AAngle,x1,x2,y1,y2: Integer);
var
  Q: byte;
begin
  Q := 4;
  if AAngle <= 90 then Q := 1
  else if AAngle <= 180 then Q := 2
  else if AAngle <= 270 then Q := 3;

  case Q of
  1:begin
      case hal of
      taLeftJustify:aRect.Left := aRect.Left;
      taRightJustify:aRect.Left := aRect.Right - x1 - x2;
      taCenter:aRect.Left := aRect.Left + ((aRect.Right - Arect.Left-x2-x1) shr 1);
      end;
      case val of
      vtaTop:aRect.Top := aRect.Top + y1;
      vtaCenter:aRect.Top := arect.Top - ((-arect.Bottom + arect.Top + y2 + y1) shr 1) + y1;
      vtaBottom:aRect.Top := aRect.Bottom - y2;
      end;
    end;
  2:begin
      case hal of
      taLeftJustify:aRect.Left := aRect.Left + x1;
      taRightJustify:aRect.Left := aRect.Right - x2;
      taCenter:aRect.Left := aRect.Right-((aRect.Right-Arect.Left+x2-x1) shr 1);
      end;
      case val of
      vtaTop:aRect.Top := aRect.Top + y1 + y2;
      vtaCenter:aRect.Top := arect.Top - ((-arect.Bottom + arect.Top+y2+y1) shr 1) + y1 + y2;
      vtaBottom:aRect.Top := aRect.Bottom;
      end;
    end;
  3:begin
      case hal of
      taLeftJustify:aRect.Left := aRect.Left + x2 + x1;
      taRightJustify:aRect.Left := aRect.Right;
      taCenter:aRect.Left := aRect.Right-((aRect.Right - Arect.Left - x2 - x1) shr 1);
      end;
      case val of
      vtaTop:aRect.Top := aRect.Top + y2;
      vtaCenter:aRect.Top := arect.Top - ((-arect.Bottom+arect.Top+y2+y1) shr 1)+y2;
      vtaBottom:aRect.Top := aRect.Bottom - y1;
      end;
    end;
  4:begin
      case hal of
      taLeftJustify:aRect.Left:=aRect.Left+x2;
      taRightJustify:aRect.Left:=aRect.Right-x1;
      taCenter:aRect.Left:=aRect.Left+((aRect.Right-Arect.Left+x2-x1) shr 1);
      end;
      case val of
      vtaTop:aRect.Top:=arect.Top;
      vtaCenter:aRect.Top:=aRect.Top-((-aRect.Bottom+Arect.Top+y2+y1) shr 1);
      vtaBottom:aRect.Top:=aRect.Bottom-y2-y1;
      end;
    end;
  end;
end;

procedure TAdvStringGrid.CalcTextPos(var ARect:TRect;AAngle: Integer;ATxt:String;hal: TAlignment; val:TVAlignment);
var
  hSaveFont: HFont;
  Size: TSize;
  y1,y2: Integer;
  x1,x2: Integer;

begin
  hSaveFont := SelectObject(Canvas.Handle,Canvas.Font.Handle);
  GetTextExtentPoint32(Canvas.Handle,PChar(aTxt + 'w'),Length(aTxt),Size);
  SelectObject(Canvas.Handle,hSaveFont);

  ARect.Right := aRect.Right-2;
  ARect.Bottom := aRect.Bottom-2;

  x1 := Abs(Trunc(Size.cx * cos(AAngle*Pi/180)));
  x2 := Abs(Trunc(Size.cy * sin(AAngle*Pi/180)));

  y1 := Abs(Trunc(Size.cx * sin(AAngle*Pi/180)));
  y2 := Abs(Trunc(Size.cy * cos(AAngle*Pi/180)));

  PositionText(ARect,hal,val,AAngle,x1,x2,y1,y2);

  ARect.Left := ARect.Left - FXYOffset.X;
  ARect.Top := ARect.Top - FXYOffset.Y;
end;


function TAdvStringGrid.MaxLinesInRow(ARow: Integer): Integer;
var
  i,k: Integer;
begin
  Result := 1;

  if (ColCount <= 0) or not FMultiLineCells then
    Exit;

  for i := 0 to ColCount - FNumHidden do
  begin
    k := LinesInText(Cells[RemapCol(i),ARow],FMultiLineCells);
    if k > Result then
      Result := k;
  end;
end;

//--------------------------------------------------------------------
// Font mapping conversion routines : used round in previous version!
//--------------------------------------------------------------------
function TAdvStringGrid.MapFontHeight(pointsize: Integer): Integer;
begin
  MapFontHeight := -Trunc(pointsize*254/72*Fontscalefactor);
end;

function TAdvStringGrid.MapFontSize(Height: Integer): Integer;
begin
  MapFontSize := Trunc(Height*72/254);
end;

procedure AsgPrintBitmap(Canvas:  TCanvas; DesTRect:  TRect;  Bitmap:  TBitmap);
var
  BitmapHeader:  pBitmapInfo;
  BitmapImage :  POINTER;
  HeaderSize  :  DWORD;
  ImageSize   :  DWORD;
begin
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage,  ImageSize);
  try
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
                  DestRect.Left, DestRect.Top,     // Destination Origin
                  DestRect.Right  - DestRect.Left, // Destination Width
                  DestRect.Bottom - DestRect.Top,  // Destination Height
                  0, 0,                            // Source Origin
                  Bitmap.Width, Bitmap.Height,     // Source Width & Height
                  BitmapImage,
                  TBitmapInfo(BitmapHeader^),
                  DIB_RGB_COLORS,
                  SRCCOPY)
  finally
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  end;
end;

procedure PrintBitmapRop(Canvas:  TCanvas; DesTRect:  TRect;  Bitmap:  TBitmap; rop:dword);
var
  BitmapHeader: PBitmapInfo;
  BitmapImage: Pointer;
  HeaderSize,ImageSize: DWord;

begin
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage,  ImageSize);
  try
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
                  DesTRect.Left, DesTRect.Top,     // Destination Origin
                  DesTRect.Right  - DesTRect.Left, // Destination Width
                  DesTRect.Bottom - DesTRect.Top,  // Destination Height
                  0, 0,                            // Source Origin
                  Bitmap.Width, Bitmap.Height,     // Source Width & Height
                  BitmapImage,
                  TBitmapInfo(BitmapHeader^),
                  DIB_RGB_ColORS,
                  ROP)
  finally
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  end;
end;

//-----------------------------------------
// Routine to build the page on the Canvas
//-----------------------------------------
function TAdvStringGrid.BuildPages(Canvas:TCanvas; PrintMethod: TPrintMethod; MaxPages: Integer;SelRows: Boolean): Integer;
var
  i,j,m,tw,th,pagnum,pagCol,pagRow: Integer;
  YPosPrint: Integer;
  LastRow: Integer;
  hfntsize,ffntsize: Integer;
  xsize,ysize: Integer;
  spacing: Integer;
  Indent,topIndent,footIndent: Integer;
  AlignValue: TAlignment;
  fntvspace,fnthspace,fntlineHeight:word;
  OldFont,NewFont: TFont;
  OldBrush,NewBrush: TBrush;
  oldpen: TPen;
  TotalWidth: Integer;
  HeaderSize: Integer;
  FooterSize: Integer;
  StartCol,EndCol: Integer;
  SpaceForCols,SpaceForFixedCols: Integer;
  orgsize: Integer;
  repeatCols,multiCol: Boolean;
  forcednewpage: Boolean;
  Allowfittopage: Boolean;
  scalefactor: Double;
  angle: Integer;
  ResFactor,HTMLFactor: Double;
  prevendCol: Integer;
  LFont: TLogFont;
  hOldFont,hNewFont: HFont;
  bmp: TBitmap;
  pic: TPicture;
  iconinfo: TIconinfo;
  hdc: THandle;
  cache_Row,cache_Height: Integer;
  Cancelled: Boolean;
  {$IFDEF TMSUNICODE}
  sz: TSize;
  {$ENDIF}

  function IsSelRow(ARow: Integer): Boolean;
  begin
    Result := True;
    if not SelRows then
      Exit;
    if MouseActions.DisjunctRowSelect then
      Result := RowSelect[ARow]
    else
      Result := (ARow >= Selection.Top) and (ARow <= Selection.Bottom);
  end;

  function IsSelCol(ACol: Integer): Boolean;
  begin
    Result := True;
    if not SelRows then
      Exit;

    if MouseActions.DisjunctColSelect then
      Result := ColSelect[ACol]
    else
      Result := (ACol >= Selection.Left) and (ACol <= Selection.Right);
  end;

  // Get x,y dimensions of Grid cell in Canvas mapmode
  function GetTextSize(Col,Row: Integer): TSize;
  var
    s,su,Anchor,Stripped,FocusAnchor:string;
    MaxSize,newsize,numlines,OldSize,hl,ml: Integer;
    gt: TPoint;
    r,hr,cr: TRect;
    htmlsize: TPoint;
    ctt: TTextType;
    DrawStyle: DWord;
    HAlign: TAlignment;
    VAlign: TVAlignment;
    WW: Boolean;
    AState: TGridDrawState;
    CID,CV,CT: string;
    {$IFDEF TMSUNICODE}
    ws: widestring;
    {$ENDIF}
  begin

    if HasDataCell(Col,Row) then
      s := ''
    else
      s := Cells[Col,Row];

    ctt := TextType(s,FEnableHTML);

    case ctt of
    ttFormula:
      begin
        s := CalcCell(Col,Row);
      end;
    ttRTF:
      begin
        CellToRich(Col,Row,FRichEdit);
        s := FRichEdit.Text;
      end;
    {$IFDEF TMSUNICODE}
    ttUnicode:
      begin
        FillChar(r,SizeOf(r),0);
        r.Right := $FFFF;
        r.Bottom := $FFFF;

        ws := WideCells[col,row];

        GetTextExtentPoint32W(Canvas.Handle,PWideChar(ws),Length(ws),sz);
        Result.cx := sz.cx;
        Result.cy := sz.cy;

        {
        Result.cy := DrawTextExW(Canvas.Handle,PWideChar(ws),length(ws),r,DT_LEFT or DT_CALCRECT,nil);
        Result.cx := R.Right - R.Left;
        }
        Result.cy := -htmlsize.y;
        Exit;
      end;
    {$ENDIF}  
    ttHTML:
      begin
        OldFont.Assign(Canvas.Font);
        NewFont.Assign(Canvas.Font);
        NewFont.Size := orgsize;

        FillChar(r,SizeOf(r),0);
        r.Right := $FFFF;
        r.Bottom := $FFFF;
        Oldsize := Canvas.Font.Size;
        SetMapMode(Canvas.Handle,MM_TEXT);
        Canvas.Font.size := FPrintSettings.Font.Size;

        HTMLDrawEx(Canvas,s,r,GridImages,0,0,-1,0,1,False,True,False,True,True,False,not EnhTextSize,False,
                   HTMLFactor,FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,
                   Integer(htmlsize.x),Integer(htmlsize.y),hl,ml,hr,cr,CID,CT,CV,FImageCache,FContainer,self.Handle);

        // Correct it for the new mapping mode
        SetMapMode(Canvas.Handle,MM_LOMETRIC);
        dptolp(Canvas.Handle,htmlsize,1);
        Canvas.Font.Size := Oldsize;

        Result.cx := htmlsize.x;
        Result.cy := -htmlsize.y;
        Exit;
      end;
    end;

    OldFont.Assign(Canvas.Font);
    NewFont.Assign(Canvas.Font);
    NewFont.Size := orgsize;

    AState := [];

    GetVisualProperties(Col,Row,AState,True,False,False,OldBrush,NewFont,HAlign,VAlign,WW);

    Canvas.Font.Assign(NewFont);
    Canvas.Font.Height := MapFontHeight(NewFont.Size);

    if IsRotated(Col,Row,angle) then
    begin
      GetObject(Canvas.Font.Handle,SizeOf(LFont),Addr(LFont));
      LFont.lfEscapement := -Angle * 10;
      LFont.lfOrientation := -Angle * 10;
      hNewFont := CreateFontIndirect(LFont);
      hOldFont := SelectObject(Canvas.Handle,hNewFont);
    end;

    maxsize := 0;
    numlines := 0;

    if FPrintSettings.PrintGraphics then
    begin
      gt := CellGraphicSize[Col,Row];
      gt.x := Round(gt.x * resfactor);
      gt.y := Round(gt.y * resfactor);
    end
    else gt := point(0,0);

    if s = '' then
      s := 'gh';

    if WordWrap and FPrintSettings.NoAutoSize then
    begin
      r.Top := 0;
      r.Left := 0;

      if IsXMergedCell(Col,Row) then
        r.Right := $FFFF
      else
        r.Right := MaxWidths[Col];

      r.Bottom := 50;
      DrawStyle := DT_CALCRECT or DT_WORDBREAK;
      {$IFDEF DELPHI4_LVL}
      DrawStyle := DrawTextBiDiModeFlags(DrawStyle);
      {$ENDIF}
      r.Bottom := DrawText(Canvas.Handle,PChar(s),Length(s),r,DrawStyle);
      Result.cx := r.Right;
      Result.cy := -r.Bottom;
    end
    else
    begin
      repeat
        su := GetNextLine(s,FMultiLineCells);
        if FURLShow and not FURLFull then StripURLProtoCol(su);
        newsize := Canvas.TextWidth(su) + gt.x;
        if (newsize > maxsize) then maxsize := newsize;
        inc(numlines);
      until (s = '');

      Result.cx := maxsize;
      Result.cy := numlines * Canvas.TextHeight('gh');
    end;

    if IsRotated(Col,Row,angle) then
    begin
      Result.cx := Abs(Round(Result.cx * cos(Angle*Pi/180)))+
                   Abs(Round(Result.cy * sin(Angle*Pi/180)));

      Result.cy := Abs(Round(maxsize * sin(Angle*Pi/180)))+
                   Abs(Round(Result.cy * cos(Angle*Pi/180)));
      hNewFont := SelectObject(Canvas.Handle,hOldFont);
      DeleteObject(hNewFont);
    end;

    if Result.cy < gt.y then
      Result.cy := gt.y;
    if Result.cx < gt.x then
      Result.cx := gt.x;
    Canvas.Font.Assign(oldFont);

    if Assigned(FOnCustomCellSize) then
    begin
      FOnCustomCellSize(Self,Canvas,Col,Row,TPoint(Result),True);
    end;

  end;

  //Calculate required Column Widths for all Columns
  procedure CalculateWidths;
  var
    i,j,k: Integer;
  begin
    for j := FPrintRect.Left to FPrintRect.Right do
      MaxWidths[j] := 0;

    if FPrintSettings.NoAutoSize then
      for j := FPrintRect.Left to FPrintRect.Right do
      begin
        if IsSelCol(j) then
          MaxWidths[j] := Round((ColWidths[j] - 4) * ResFactor);
      end
    else
      for i := FPrintRect.Top to FPrintRect.Bottom do
      begin
        for j := FPrintRect.Left to FPrintRect.Right do
        begin
          if IsSelCol(j) then
          begin
            k := RemapCol(j);
            if FPrintSettings.FUseFixedWidth then
              tw := FPrintSettings.FFixedWidth
            else
              tw := GetTextSize(k,i).cx;

            if (tw > MaxWidths[j]) and not IsXMergedCell(k,i) then
              MaxWidths[j] := tw;
          end;
        end;
      end;
  end;


  //Calculate required Row Height
  function GetRowHeight(ARow: Integer): Integer;
  var
    j,k,nh,mh: Integer;
  begin
    mh := 0;


    if ARow = Cache_Row then
    begin
      Result := Cache_Height;
      Exit;
    end;

    if FPrintSettings.NoAutoSizeRow then
    begin
      Result := Round((RowHeights[ARow]-4) * ResFactor);
      Exit;
    end;


    if FPrintSettings.UseFixedHeight then
      Result := FPrintSettings.FixedHeight
    else
    begin
      if Assigned(FOnPrintSetRowHeight) then
      begin
        mh := FPrintSettings.FixedHeight;
        OnPrintSetRowHeight(Self,ARow,mh);
        Result := mh;
      end
      else
      begin
        nh := 0;
        for j := FPrintRect.Left to FPrintRect.Right do
        begin
          FontScaleFactor := ScaleFactor;

          k := RemapCol(j);
          nh := GetTextSize(k,ARow).cy;

          if not IsYMergedCell(k,ARow) then
          begin
            if nh > mh then mh := nh;
          end;
        end;
        if mh = 0 then
          Result := nh
        else
          Result := mh;
      end;

    end;

    cache_Row := ARow;
    cache_Height := Result;
  end;

  {$IFDEF DELPHI3_LVL}
  function GetPrinterOrientation: Integer;
  var
    Device : array[0..255] of char;
    Driver : array[0..255] of char;
    Port : array[0..255] of char;
    hDMode : THandle;
  begin
    // Printer.PrinterIndex := Printer.PrinterIndex; not required ?
    Printer.GetPrinter(Device, Driver, Port, hDMode);
    Result := winspool.DeviceCapabilities(device,port,DC_ORIENTATION,Nil,Nil);
  end;
 {$ENDIF}

  // Routine to draw header & footer
  function BuildColumnsRow(ypos,Col1,Col2,ARow,hght: Integer): Integer;
  var
    c,k,d,cn,swp,lit: Integer;
    th,thm,tb,yp,cr,ml,hl: Integer;
    s,su,cs,Anchor,Stripped,FocusAnchor:string;
    tr,tp,rg,ir,hr,ctr: TRect;
    first: Integer;
    x1,x2,y1,y2: Integer;
    TextPos: TPoint;
    Q: byte;
    cg: TCellGraphic;
    borders: TCellBorders;
    flg, DrawStyle: DWORD;
    checkstate: Boolean;
    mm,hxsize,hysize,OldSize: Integer;
    ctt: TTextType;
    oldCol: TColor;
    CSP: TPoint;
    CDIM: TPoint;
    CGS: TPoint;
    DFS: DWORD;
    AState: TGridDrawState;
    WW: Boolean;
    HAlign: TAlignment;
    VAlign: TVAlignment;
    CID,CV,CT: string;
    ws: widestring;
  label
    BorderDrawing;

  begin
    FontScaleFactor := ScaleFactor;

    thm := GetRowHeight(ARow);
    thm := thm + (thm shr 3);

    outputdebugstring(pchar('rowheight:'+inttostr(thm)+':'+inttostr(arow)));

    Result := thm + 2 * fntvspace + FPrintSettings.RowSpacing;

    if (PrintMethod in [prCalcPreview,prCalcPrint]) or
       (((pagnum + 1) < FPrintPageFrom) or ((pagnum + 1) > FPrintPageTo)) then
    begin
      Fontscalefactor := 1.0;
      Exit;
    end;


    for c := Col1 to Col2 do
    begin
      if not IsSelCol(c) then
        continue;

      cn := RemapCol(c);

      CSP := CellExt(cn,ARow);

      CDIM.X := 0;
      for k := 0 to CSP.X   do
        CDIM.X := CDIM.X + MaxWidths[c + k] + Spacing;

      CDIM.Y := (CSP.Y + 1) * Result; // take vertical cell merging into account

      tr.Left := Indents[c];
      tr.Right := tr.Left + CDIM.X;

      tr.Top := ypos;
      tr.Bottom := ypos - CDIM.Y;

      if not IsBaseCell(cn,ARow) then
      begin
        goto BorderDrawing;
        // Continue;
        // do some extra border drawing here
      end;

      OldBrush.Assign(Canvas.Brush);
      OldFont.Assign(Canvas.Font);
      NewBrush.Assign(Canvas.Brush);
      NewFont.Assign(Canvas.Font); // Copy everything except size, which is mapped into mm_lometric
      NewFont.Size := OrgSize;

      GetVisualProperties(cn,ARow,AState,True,False,False,NewBrush,NewFont,HAlign,VAlign,WW);

      Canvas.Brush.Assign(NewBrush);
      Canvas.Font.Assign(NewFont);
      Canvas.Font.Height := MapFontHeight(NewFont.Size);

      SetTextColor(Canvas.Handle,ColorToRGB(NewFont.Color));

      if HasDataCell(cn,ARow) then
        cs := ''
      else
        cs := GetFormattedCell(cn,ARow);

      ctt := TextType(cs,FEnableHTML);

      if ctt = ttFormula then
        cs := CalcCell(cn,ARow);

      // do background painting
      OldCol := Canvas.Pen.Color;
      Canvas.Pen.Color := Canvas.Brush.Color;
      Canvas.Rectangle(tr.Left,tr.Top,tr.Right,tr.Bottom);
      Canvas.Pen.Color := OldCol;

      AlignValue := GetCellAlignment(cn,ARow).Alignment;

      th := Canvas.TextHeight('gh') + FPrintSettings.RowSpacing;
      th := th + (th shr 3);

      first := 0;
      s := cs;
      repeat
        su := GetNextLine(s,FMultiLineCells);
        tb := Canvas.TextWidth(su);
        if tb > first then
          first := tb;
      until (s = '');
      tb := first;

      s := cs;

      Angle:=0;

      if IsRotated(cn,ARow,angle) then
      begin
        GetObject(Canvas.Font.Handle,SizeOf(LFont),Addr(LFont));
        if (PrintMethod = prPreview) or not PrinterDriverFix
           {$IFDEF DELPHI3_LVL}
           or (GetPrinterOrientation = 270) {$ENDIF} then
        begin
          LFont.lfEscapement := -Angle * 10;
          LFont.lfOrientation := -Angle * 10;
        end
        else
        begin
          LFont.lfEscapement:=Angle*10;
          LFont.lfOrientation:=Angle*10;
        end;

        hNewFont := CreateFontIndirect(LFont);
        hOldFont := SelectObject(Canvas.Handle,hNewFont);
      end;

      x1 := Abs(Trunc(tb * cos(Angle*Pi/180)));
      x2 := Abs(Trunc(th * sin(Angle*Pi/180)));
      y1 := Abs(Trunc(tb * sin(Angle*Pi/180)));
      y2 := Abs(Trunc(th * cos(Angle*Pi/180)));
      th := y1 + y2;

      first := fntvspace;

      tr.Left := Indents[c];
      tr.Right := tr.Left + CDIM.X;
      tr.Top := ypos;
      tr.Bottom := ypos - CDIM.Y;

      cg := CellGraphics[cn,ARow];

      if (cg <> nil) and FPrintSettings.PrintGraphics then
      begin
        CGS := GetPrintGraphicSize(cn,ARow,CDIM.X,CDIM.Y,ResFactor);

        CGS.X := Round(CGS.X * ResFactor);
        CGS.Y := Round(CGS.Y * ResFactor);

        case cg.CellHalign of
        haBeforeText:
          begin
            rg.Left := tr.Left + Round(ResFactor);
            rg.Right := rg.Left + CGS.X;
            tr.Left := rg.Right;
          end;
        haLeft:
          begin
            rg.Left := tr.Left + Round(ResFactor);
            rg.Right := rg.Left + CGS.X;
            tr.Left := rg.Right;
          end;
        haAfterText:
          begin
            rg.Right := tr.Right;
            rg.Left := rg.Right - CGS.X;
            tr.Right := rg.Left;
          end;
        haRight:
          begin
            rg.Right := tr.Right;
            rg.Left := rg.Right - CGS.X;
            tr.Right := rg.Left;
          end;
        haCenter:
          begin
            rg.Left := tr.Left + ((CDIM.X - CGS.X ) div 2);
            rg.Right := rg.Left + CGS.X;
          end;
        haFull:
          begin
            rg.Left := tr.Left;
            rg.Right := tr.Right;
          end;
        end;

        case cg.CellValign of
        vaTop:
          begin
            rg.Top := tr.Top;
            rg.Bottom := tr.Top - CGS.Y;
          end;
        vaCenter:
          begin
            rg.Top := tr.Top - ((CDIM.Y - CGS.Y) div 2);
            rg.Bottom := rg.Top - CGS.Y;
          end;
        vaBottom:
          begin
            rg.Top := tr.Bottom + CGS.Y;
            rg.Bottom := tr.Bottom;
          end;
        vaUnderText:
          begin
            rg.Top := tr.Bottom + CGS.Y;
            rg.Bottom := rg.Top - CGS.Y;
            tr.Bottom := rg.Top;
          end;
        vaAboveText:
          begin
            rg.Top := tr.Top;
            rg.Bottom := rg.Top - CGS.Y;
            tr.Top := rg.Bottom;
          end;
        vaFull:
          begin
            rg.Top := tr.Top;
            rg.Bottom := tr.Bottom;
          end;
        end;


        if (HAlign = taRightJustify) and
           (cg.CellType in [ctCheckbox, ctDataCheckbox,ctVirtCheckBox]) and (s = '')  then
        begin
          rg.Right := tr.Right;
          rg.Left := rg.Right - CGS.X;
          tr.Right := rg.Left;
        end;

        if (HAlign = taCenter) and
           (cg.CellType in [ctCheckbox, ctDataCheckbox,ctVirtCheckBox]) and (s = '') then
        begin
          rg.Left := Indents[c] + ((CDIM.X - CGS.X ) div 2);
          rg.Right := rg.Left + CGS.X;
        end;

      end;

      case ctt of
      ttRTF:
        begin
          Canvas.Brush.style := bsClear;
          RTFPaint(cn,ARow,Canvas,tr);
          Canvas.Brush.style := bsSolid;
        end;
      ttHTML:
        begin
          lptodp(Canvas.Handle,tr.Topleft,1);
          lptodp(Canvas.Handle,tr.Bottomright,1);

          mm := GetMapMode(Canvas.Handle);
          OldSize := Canvas.Font.Size;
          SetMapMode(Canvas.Handle,MM_TEXT);
          Canvas.Font.Size := FPrintSettings.Font.Size;
          Canvas.Brush.Style := bsClear;

          HTMLDrawEx(Canvas,cs,tr,Gridimages,0,0,-1,0,1, False,False,True,False,True,False,not EnhTextSize,False,
                     HTMLFactor,FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,
                     hxsize,hysize,hl,ml,hr,ctr,CID,CT,CV,FImageCache,FContainer,self.Handle);

          SetMapMode(Canvas.Handle,mm);
          Canvas.Font.Size := Oldsize;
          Canvas.Brush.Style := bsSolid;
        end
      {$IFDEF TMSUNICODE}  ;
      ttUnicode:
        begin
          if tr.Right > XSize then
            tr.Right := Indents[EndCol + 1];

          Canvas.TextRect(tr,tp.Left,tp.Top,'');

          tr.Left := tr.Left + Round(2 * ResFactor);

          ws := WideCells[cn,ARow];
          DrawTextExW(Canvas.Handle,PWideChar(ws),Length(ws), tr, DT_LEFT or DT_NOPREFIX,nil);
        end
      {$ENDIF}  
      else
        begin
        // wordwrap printing

          if Wordwrap and FPrintSettings.NoAutoSize then
          begin
            // Make sure the background is fully drawn in background color
            if tr.Right > XSize then
              tr.Right := Indents[EndCol + 1];

            Canvas.TextRect(tr,tp.Left,tp.Top,'');

            tr.Left := tr.Left + Round(2 * ResFactor);

            DrawStyle := DT_LEFT;

            case AlignValue of
            taLeftJustify:DrawStyle := DT_LEFT;
            taRightJustify:DrawStyle := DT_RIGHT;
            taCenter:DrawStyle := DT_CENTER;
            end;

            DrawStyle := DrawStyle or DT_WORDBREAK or DT_EDITCONTROL or DT_EXPANDTABS or DT_NOPREFIX;

            {$IFDEF DELPHI4_LVL}
            DrawStyle := DrawTextBiDiModeFlags(DrawStyle);
            {$ENDIF}

            DrawText(Canvas.Handle,PChar(s),Length(s),tr,DrawStyle);
          end
          else
          begin
            lit := LinesInText(s,FMultiLineCells);
            if lit = 1 then
            begin
              tp := tr;
              tp.Bottom := tp.Top - Result - FPrintSettings.RowSpacing;

              if tr.Right > XSize then
                tr.Right := Indents[EndCol + 1];

              su := GetNextLine(s,FMultiLineCells);

              if URLShow and not URLFull then
                StripURLProtoCol(su);

              PositionText(tp,AlignValue,VAlign,Angle,x1,x2,-y1,-y2);

              if EnhTextSize and PrintSettings.NoAutoSize then
              begin
                case AlignValue of
                taRightJustify: DrawStyle := DT_RIGHT or DT_END_ELLIPSIS or DT_SINGLELINE or DT_EDITCONTROL;
                taCenter: DrawStyle := DT_CENTER or DT_END_ELLIPSIS or DT_SINGLELINE or DT_EDITCONTROL;
                else
                  DrawStyle := DT_LEFT or DT_END_ELLIPSIS or DT_SINGLELINE or DT_EDITCONTROL;
                end;
                tr.Left := tr.Left + FXYOffset.X;
                tr.Top := tp.Top + FXYOffset.Y;
                DrawText(Canvas.Handle,PChar(su),Length(su),tr,DrawStyle);
              end
              else
              begin
                case AlignValue of
                taLeftJustify:tp.Left := tp.Left + fnthspace;
                taRightJustify:tp.Left := tp.Left - fnthspace;
                end;
                Canvas.TextRect(tr,tp.Left,tp.Top,su);
              end;
            end
            else
            begin
              case Valign of
              vtaTop:First := 0;
              vtaCenter:First := ((Result - ((th - FPrintSettings.RowSpacing) * lit)) div 2);
              vtaBottom:First := Result - ((th - FPrintSettings.RowSpacing) * lit);
              end;

              repeat
                tp := tr;
                su := GetNextLine(s,FMultiLineCells);
                if URLShow and not URLFull then StripURLProtoCol(su);
                case AlignValue of
                taLeftJustify:tp.Left := tp.Left + fnthspace;
                taRightJustify:tp.Left := tp.Right - fnthspace - Canvas.TextWidth(su);
                taCenter:tp.Left := tp.Left+( (tp.Right - tp.Left - Canvas.TextWidth(su)) div 2);
                end;
                Canvas.TextRect(tr,tp.Left,tr.Top - First,su);
                if first > 0 then
                begin
                  tr.Top := tr.Top - First;
                  first := 0;
                end;
                tr.Top := tr.Top - th + FPrintSettings.RowSpacing;
              until (s = '');
            end;
          end;
        end;
      end;

      if (cg <> nil) and FPrintSettings.PrintGraphics then
      begin
        case cg.CellType of
        ctCheckbox,ctDataCheckBox,ctVirtCheckBox:
          begin
            DFS := DFCS_BUTTONCHECK;
            if FControlLook.ControlStyle = csFlat then
              DFS := DFS or DFCS_FLAT;

            rg.Bottom := rg.Top + Round(CellGraphicSize[cn,ARow].y * ResFactor);
            // Canvas.rectangle(rg.Left,rg.Top,rg.Right,rg.Bottom);
            GetCheckBoxState(cn,ARow,checkstate);
            if checkstate then
              DrawFrameControl(Canvas.Handle,rg,DFC_BUTTON, DFS or DFCS_CHECKED)
            else
              DrawFrameControl(Canvas.Handle,rg,DFC_BUTTON, DFS);
          end;
        ctRadio:
          begin
          end;
        ctButton,ctBitButton:
          begin
            {
            rg.Bottom:=rg.Top+round(CellGraphicSize[c,ARow].y*resfactor);
            DrawFrameControl(Canvas.Handle,rg,DFC_BUTTON,DFCS_BUTTONPUSH);
            }
          end;
        ctBitmap:AsgPrintBitmap(Canvas,rg,cg.CellBitmap);
        ctPicture:
          begin
            bmp := TBitmap.Create;
            bmp.Width := TPicture(cg.CellBitmap).Graphic.Width;
            bmp.Height := TPicture(cg.CellBitmap).Graphic.Height;
            bmp.Canvas.draw(0,0,TPicture(cg.CellBitmap).Graphic);
            AsgPrintBitmap(Canvas,rg,bmp);
            bmp.free;
          end;
        ctFilePicture:
          begin
            pic := TPicture.Create;
            pic.LoadFromFile(TFilePicture(cg.CellBitmap).Filename);
            bmp := TBitmap.Create;
            bmp.Width := pic.Graphic.Width;
            bmp.Height := pic.Graphic.Height;
            bmp.Canvas.Draw(0,0,pic.graphic);
            AsgPrintBitmap(Canvas,rg,bmp);
            bmp.Free;
            pic.Free;
          end;
        ctIcon:
          begin
            GetIconInfo(cg.CellIcon.Handle,IconInfo);
            bmp := TBitmap.Create;
            bmp.Handle := Iconinfo.hbmmask;
            PrintBitmapRop(Canvas,rg,bmp,SRCCOPY);
            bmp.Free;
            GetIconInfo(cg.CellIcon.Handle,IconInfo);
            bmp := TBitmap.Create;
            bmp.Handle := IconInfo.hbmColor;
            PrintBitmapROP(Canvas,rg,bmp,SRCINVERT);
            bmp.Free;
          end;
        ctImageList:
          begin
            if Assigned(FGridImages) then
            begin
              bmp := TBitmap.Create;
              bmp.Width := FGridImages.Width;
              bmp.Height := FGridImages.Height;
              bmp.Canvas.Brush.Color := Canvas.Brush.Color;
              bmp.Canvas.Pen.Color := Canvas.Brush.Color;
              bmp.Canvas.Rectangle(0,0,bmp.Width,bmp.Height);
              FGridImages.Draw(bmp.Canvas,0,0,cg.CellIndex);
              AsgPrintBitmap(Canvas,rg,bmp);
              bmp.free;
            end;
          end;
        ctDataImage:
          begin
            if Assigned(FGridImages) then
            begin
              bmp := TBitmap.Create;
              bmp.Width := FGridImages.Width;
              bmp.Height := FGridImages.Height;
              bmp.Canvas.Brush.Color := Canvas.Brush.Color;
              bmp.Canvas.Pen.Color := Canvas.Brush.Color;
              bmp.Canvas.Rectangle(0,0,bmp.Width,bmp.Height);
              FGridImages.Draw(bmp.Canvas,0,0,Ints[cn,ARow]);
              AsgPrintBitmap(Canvas,rg,bmp);
              bmp.free;
            end;
          end;
        ctImages:
          begin
            if Assigned(FGridImages) then
            begin
              ir := rg;
              for d := 1 to CellImages[c,ARow].Count do
              begin
                bmp := TBitmap.Create;

                bmp.Width := FGridImages.Width;
                bmp.Height := FGridImages.Height;
                bmp.Canvas.Brush.Color := Canvas.Brush.Color;
                bmp.Canvas.Pen.Color := Canvas.Brush.Color;
                bmp.Canvas.Rectangle(0,0,bmp.Width,bmp.Height);
                FGridImages.Draw(bmp.Canvas,0,0,TIntList(cg.CellBitmap).Items[d - 1]);

                if cg.cellBoolean then
                begin
                  ir.Left := rg.Left + (d - 1) * Round(FGridimages.Width*ResFactor);
                  ir.Right := ir.Left + Round(FGridimages.Width*ResFactor);
                end
                else
                begin
                  ir.Top := rg.Top + (d - 1) * Round(FGridimages.Height * ResFactor);
                  ir.Bottom := ir.Top + Round(FGridimages.Height * ResFactor);
                end;

                AsgPrintBitmap(Canvas,ir,bmp);
                bmp.Free;
              end;
            end;
          end;
        end;

        if IsRotated(cn,ARow,angle) then
        begin
          hNewFont := SelectObject(Canvas.Handle,hOldFont);
          DeleteObject(hNewFont);
        end;

        Canvas.Font.Assign(oldFont);
        Canvas.Brush.Assign(oldBrush);
      end;

      if Assigned(OnCustomCellDraw) then
      begin
        lptodp(Canvas.Handle,tr.Topleft,1);
        lptodp(Canvas.Handle,tr.Bottomright,1);

        mm := GetMapMode(Canvas.Handle);
        OldSize := Canvas.Font.Size;
        SetMapMode(Canvas.Handle,MM_TEXT);
        Canvas.Font.Size := FPrintSettings.Font.size;

        OnCustomCellDraw(Self,Canvas,cn,ARow,[],tr,true);

        SetMapMode(Canvas.Handle,mm);
        Canvas.Font.Size := Oldsize;
      end;

    BorderDrawing:

      Oldpen.Assign(Canvas.pen);
      borders := [];

      if (FPrintSettings.Fborders in [pbSingle,pbDouble]) then
        borders := [cbLeft,cbRight,cbTop,cbBottom];

      if (FPrintSettings.FBorders in [pbHorizontal,pbAroundHorizontal]) then
        borders := [cbTop,cbBottom];

      if (FPrintSettings.FBorders in [pbVertical,pbAroundVertical]) then
        borders := [cbLeft,cbRight];

      if  CSP.X > 0 then
        borders := borders - [cbRight,cbLeft];

      if  CSP.Y > 0 then
        borders := borders - [cbBottom,cbTop];

      if IsYMergedCell(cn,ARow) and (CSP.Y = 0) then
        borders := borders - [cbTop];

      if IsXMergedCell(cn,ARow) and (CSP.X = 0) then
        borders := borders - [cbLeft];

      if IsBaseCell(cn,ARow) then
        borders := borders + [cbLeft,cbTop];

      {
      if IsYMergedCell(cn,ARow) and not IsXMergedCell(cn,ARow) and not IsBaseCell(cn,ARow) then
      begin
        borders := borders - [cbTop,cbBottom];
      end;

      if IsXMergedCell(cn,ARow) and not IsYMergedCell(cn,ARow) and not IsBaseCell(cn,ARow) then
      begin
        borders := borders - [cbLeft,cbRight];
      end;
      }

      GetCellPrintBorder(cn,ARow,Canvas.Pen,borders);

      tr.Left := Indents[c];
      tr.Right := tr.Left + CDIM.X;

      tr.Top := ypos;
      tr.Bottom := ypos - CDIM.Y;

      if tr.Bottom < YSize + FooterSize then
      begin
        tr.Bottom := ypos - Result;
        borders := borders - [cbBottom];
      end;

      if tr.Right > XSize then
      begin
        tr.Right := Indents[EndCol + 1];
      end;

      if cbLeft in borders then
      begin
        Canvas.MoveTo(tr.Left,tr.Top);
        Canvas.LineTo(tr.Left,tr.Bottom);
      end;

      if cbRight in borders then
      begin
//        Canvas.MoveTo(tr.Right + 1 - Canvas.Pen.Width,tr.Top);
//        Canvas.LineTo(tr.Right + 1 - Canvas.Pen.Width,tr.Bottom);
        Canvas.MoveTo(tr.Right,tr.Top);
        Canvas.LineTo(tr.Right,tr.Bottom);
      end;

      if cbTop in borders then
      begin
        Canvas.MoveTo(tr.Left,tr.Top);
        Canvas.LineTo(tr.Right,tr.Top);
      end;

      if cbBottom in borders then
      begin
//        Canvas.MoveTo(tr.Left,tr.Bottom+Canvas.Pen.Width);
//        Canvas.LineTo(tr.Right,tr.Bottom+Canvas.Pen.Width);
        Canvas.MoveTo(tr.Left,tr.Bottom);
        Canvas.LineTo(tr.Right,tr.Bottom);
      end;

      Canvas.Pen.Assign(OldPen);

    end;

    Fontscalefactor := 1.0;
  end;

   // Routine to draw header & footer
   function BuildHeader: Integer;
   var
     tl,tr,tc,bl,br,bc: string;
     i,j,ml,hl: Integer;
     HTMLHeader: string;
     HTMLTitle: Boolean;
     HTMLRect,hr,cr: TRect;
     HTMLMM: Integer;
     HTMLFontSize,HTMLXSize,HTMLYSize: Integer;
     Anchor,Stripped,FocusAnchor: string;
     CID,CV,CT: string;

     function PagNumStr:string;
     begin
       if MultiCol then
         Result := inttostr(PagRow+1) + '-' + IntToStr(PagCol)
       else
       begin
         if (FPrintSettings.PageNumSep <> '') and (MaxPages > 1) then
           Result := IntToStr(PagNum + 1 + PrintSettings.PageNumberOffset) +
             FPrintSettings.PageNumSep + IntToStr(MaxPages + PrintSettings.MaxPagesOffset)
         else
           Result := IntToStr(PagNum + 1 + PrintSettings.PageNumberOffset);
       end;
     end;

   begin
     Result := 0;
     if ((PagNum + 1) < FPrintPageFrom) or ((Pagnum + 1) > FPrintPageTo) then
       Exit;
     if (PrintMethod in [prCalcPreview,prCalcPrint]) then
       Exit;

     tl := '';
     tr := '';
     tc := '';
     bl := '';
     br := '';
     bc := '';
     HTMLHeader := '';
     HTMLTitle := True;

     with FPrintSettings do
     begin
       case FTime of
       ppTopLeft:tl := FormatDateTime('hh:nn',Now) + ' ' + tl;
       ppTopRight:tr := tr + ' ' + FormatDateTime('hh:nn',Now);
       ppTopCenter:tc := tc + ' ' + FormatDateTime('hh:nn',Now);
       ppBottomLeft:bl := FormatDateTime('hh:nn',Now) + ' ' + bl;
       ppBottomRight:br := br + ' ' + FormatDateTime('hh:nn',Now);
       ppBottomCenter:bc := bc + ' ' + FormatDateTime('hh:nn',Now);
       end;

       case FDate of
       ppTopLeft:tl := FormatDateTime(FDateFormat,Now) + ' ' + tl;
       ppTopRight:tr := tr + ' ' + FormatDateTime(FDateFormat,Now);
       ppTopCenter:tc := tc + ' ' + FormatDateTime(FDateFormat,Now);
       ppBottomLeft:bl := FormatDateTime(FDateFormat,Now) + ' ' + bl;
       ppBottomRight:br := br + ' ' + FormatDateTime(FDateFormat,Now);
       ppBottomCenter:bc := bc + ' ' + FormatDateTime(FDateFormat,Now);
       end;

       case FPageNr of
       ppTopLeft:tl := FPagePrefix+' '+PagNumStr+' '+FPageSuffix+' '+tl;
       ppTopRight:tr := tr+' '+FPagePrefix+' '+PagNumStr+' '+FPageSuffix;
       ppTopCenter:tc := tc+' '+FPagePrefix+' '+PagNumStr+' '+FPageSuffix;
       ppBottomLeft:bl := FPagePrefix+' '+PagNumStr+' '+FPageSuffix+' '+bl;
       ppBottomRight:br := br+' '+FPagePrefix+' '+PagNumStr+' '+FPageSuffix;
       ppBottomCenter:bc := bc+' '+FPagePrefix+' '+PagNumStr+' '+FPageSuffix;
       end;

       if FTitleText <> '' then
       begin
         case FTitle of
         ppTopLeft:tl := FTitleText + ' ' + tl;
         ppTopRight:tr := tr + ' ' + FTitleText;
         ppTopCenter:tc := tc + ' ' + FTitleText;
         ppBottomLeft:bl := FTitleText + ' ' + bl;
         ppBottomRight:br := br + ' ' + FTitleText;
         ppBottomCenter:bc := bc + ' ' + FTitleText;
         end;
       end
       else
       begin
         if TextType(FTitleLines.Text,FEnableHTML) = ttHTML then
         begin
           HTMLHeader := StringListToText(FTitleLines);
           HTMLTitle := FTitle in [ppTopLeft,ppTopCenter,ppTopRight];
         end
         else
           if FTitleLines.Count > 0 then
           begin
             case FTitle of
             ppTopLeft:tl := FTitleLines.Strings[0]+' '+tl;
             ppTopRight:tr := tr + ' ' + FTitleLines.Strings[0];
             ppTopCenter:tc := tc + ' ' + FTitleLines.Strings[0];
             ppBottomLeft:bl := FTitleLines.Strings[0] + ' ' + bl;
             ppBottomRight:br := br + ' ' + FTitleLines.Strings[0];
             ppBottomCenter:bc := bc + ' ' + FTitleLines.Strings[0];
           end;
         end;
       end;
     end;

     {$IFDEF FREEWARE}
     if PrintMethod = prPrint then GetFreeStr(cla,bc);
     {$ENDIF}

     OldFont.Assign(Canvas.Font);
     Canvas.Font.Assign(FPrintSettings.HeaderFont);
     Canvas.Font.Height := MapFontHeight(Canvas.Font.Size); {map into mm_lometric space}

     if tl <> '' then Canvas.Textout(Indent,-Headersize,tl);
     if tr <> '' then Canvas.Textout(xsize-Canvas.TextWidth(tr) - 20 - FPrintSettings.RightSize ,-Headersize,tr);
     if tc <> '' then Canvas.Textout((xsize-Canvas.TextWidth(tc)) shr 1,-Headersize,tc);

     if (FPrintSettings.FTitle in [ppTopLeft,ppTopRight,ppTopCenter]) and
        (FPrintSettings.FTitleLines.Count > 1) and (HTMLHeader = '') then
     begin
       j := 0;
       for i := 2 to FPrintSettings.FTitleLines.Count do
       begin
         j := j + Canvas.TextHeight('gh');
         tc := FPrintSettings.TitleLines[i-1];
         case FPrintSettings.FTitle of
         ppTopLeft:Canvas.Textout(Indent,-Headersize-j,tc);
         ppTopRight:Canvas.Textout(xsize-Canvas.TextWidth(tc)-20-FPrintSettings.RightSize ,-HeaderSize-j,tc);
         ppTopCenter:Canvas.Textout((xsize-Canvas.TextWidth(tc)) shr 1,-HeaderSize - j,tc);
         end;
       end;
     end;

     if (HTMLHeader <> '') and HTMLTitle then
     begin
       HTMLRect := Rect(Indent, -PrintSettings.FHeaderSize, xsize, -HeaderSize);

       lptodp(Canvas.Handle,HTMLRect.Topleft,1);
       lptodp(Canvas.Handle,HTMLRect.Bottomright,1);

       HTMLMM := GetMapMode(Canvas.Handle);
       HTMLFontSize := Canvas.Font.Size;
       SetMapMode(Canvas.Handle,MM_TEXT);
       Canvas.Font.Size := FPrintSettings.HeaderFont.size;
       Canvas.Brush.Style := bsClear;

       HTMLDrawEx(Canvas,HTMLHeader,HTMLRect,Gridimages,0,0,-1,0,1, False,False,True,False,True,False,True,False,
                  HTMLFactor,FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,
                  HTMLXSize,HTMLYSize,ml,hl,hr,cr,CID,CV,CT,FImageCache,FContainer,self.Handle);

       SetMapMode(Canvas.Handle,HTMLMM);
       Canvas.Font.Size := HTMLFontSize;
       Canvas.Brush.Style := bsSolid;
     end;

     Canvas.Font.Assign(FPrintSettings.FooterFont);
     Canvas.Font.Height := MapFontHeight(Canvas.Font.size); {map into mm_lometric space}

     if bl <> '' then Canvas.Textout(Indent,ysize + FFntSize+FntVSpace + Footersize,bl);
     if br <> '' then Canvas.Textout(xsize-Canvas.TextWidth(br)-20-FPrintSettings.RightSize ,ysize+ffntsize+fntvspace+footersize,br);
     if bc <> '' then Canvas.Textout((xsize-Canvas.TextWidth(bc)) shr 1,ysize+ffntsize+fntvspace+footersize,bc);

     if (FPrintSettings.FTitle in [ppBottomLeft,ppBottomRight,ppBottomCenter]) and
        (FPrintSettings.FTitleLines.Count > 1) and (HTMLHeader = '') then
     begin
       j := 0;
       for i := 2 to FPrintSettings.FTitleLines.Count do
       begin
         j := j + Canvas.TextHeight('gh');
         tc := FPrintSettings.TitleLines[i-1];
         case FPrintSettings.FTitle of
         ppBottomLeft:Canvas.Textout(Indent,ysize+ffntsize+fntvspace+footersize-j,tc);
         ppBottomRight:Canvas.Textout(xsize-Canvas.TextWidth(tc)-20-FPrintSettings.RightSize ,ysize+ffntsize+fntvspace+footersize-j,tc);
         ppBottomCenter:Canvas.Textout((xsize-Canvas.TextWidth(tc)) shr 1,ysize+ffntsize+fntvspace+footersize-j,tc);
         end;
       end;
     end;

     if (HTMLHeader <> '') and not HTMLTitle then
     begin
       HTMLRect := Rect(Indent, ysize + FPrintSettings.FooterSize, xsize, ysize );

       lptodp(Canvas.Handle,HTMLRect.Topleft,1);
       lptodp(Canvas.Handle,HTMLRect.Bottomright,1);

       HTMLMM := GetMapMode(Canvas.Handle);
       HTMLFontSize := Canvas.Font.Size;
       SetMapMode(Canvas.Handle,MM_TEXT);
       Canvas.Font.Size := FPrintSettings.HeaderFont.size;
       Canvas.Brush.Style := bsClear;

       HTMLDrawEx(Canvas,HTMLHeader,HTMLRect,Gridimages,0,0,-1,0,1,False,False,True,False,True,False,True,False,
                  HTMLFactor,FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,HTMLXSize,HTMLYSize,
                  hl,ml,hr,cr,CID,CT,CV,FImageCache,FContainer,self.Handle);

       SetMapMode(Canvas.Handle,HTMLMM);
       Canvas.Font.Size := HTMLFontSize;
       Canvas.Brush.Style := bsSolid;
     end;

     Canvas.Font.Assign(OldFont);
   end;

   procedure DrawBorderAround(StartCol,EndCol,yposprint: Integer);
   var
     k: Integer;
   begin
     if ((pagnum+1)<FPrintPageFrom) or ((pagnum+1)>FPrintPageTo) then Exit;
     if (PrintMethod in [prCalcPreview,prCalcPrint]) then Exit;

{     if ((PrintMethod=prPreview) and (pagnum<>PreviewPage)) or
         (PrintMethod in [prCalcPreview,prCalcPrint]) then Exit;}

     if (FPrintSettings.FBorders in [pbAround,pbAroundVertical,pbAroundHorizontal]) then
     begin
       if RepeatCols then
         k := 0
       else
         k := StartCol;

       Canvas.MoveTo(Indents[k],-TopIndent - FPrintSettings.TitleSpacing);
       Canvas.LineTo(Indents[EndCol + 1],-TopIndent - FPrintSettings.TitleSpacing);
       Canvas.LineTo(Indents[EndCol + 1],yposprint +(fntvspace shr 1));
       Canvas.LineTo(Indents[k],yposprint + (fntvspace shr 1));
       Canvas.LineTo(Indents[k],-TopIndent - FPrintSettings.TitleSpacing);
     end;

     if (FPrintSettings.FBorders in [pbDouble,pbHorizontal,pbAroundHorizontal]) then
     begin
       if RepeatCols then
         Canvas.MoveTo(Indents[0],yposprint+(fntvspace shr 1))
       else
         Canvas.MoveTo(Indents[StartCol],yposprint+(fntvspace shr 1));

       Canvas.LineTo(Indents[EndCol+1],yposprint+(fntvspace shr 1));
     end;

     if (FPrintSettings.FBorders in [pbDouble,pbVertical,pbAroundVertical]) then
     begin
       {draw here the vertical Columns too}
       if RepeatCols then
       begin
         for k := 0 to FixedCols - 1 do
         begin
           Canvas.MoveTo(Indents[k],-topIndent-FPrintSettings.TitleSpacing);
           Canvas.LineTo(Indents[k],yposprint+(fntvspace shr 1));
         end;
       end;
       {
       for k := StartCol to EndCol + 1 do
       begin
         Canvas.MoveTo(Indents[k],-TopIndent - FPrintSettings.TitleSpacing);
         Canvas.LineTo(Indents[k],yposprint+(fntvspace shr 1));
       end;
       }
     end;
   end;

   procedure StartNewPage;
   begin
     if ((PagNum + 2) < FPrintPageFrom) or ((PagNum + 2) > FPrintPageTo) then
       Exit;

     if (PrintMethod = prPrint) and (PagNum + 1 >= FPrintPageFrom) then Printer.NewPage;

     SetMapMode(Canvas.Handle,MM_LOMETRIC);

     if (PrintMethod in [prPrint,prPreview]) then
     if Assigned(FOnPrintPage) then
     begin
       FOnPrintPage(Self,Canvas,PagNum + 1,xsize,ysize);
     end;
   end;


begin
  SetMapMode(Canvas.Handle,MM_TEXT);
  try
    hdc := GetDC(self.Handle);
    HTMLFactor := GetDeviceCaps(Canvas.Handle,LOGPIXELSX)/GetDeviceCaps(hdc,LOGPIXELSX);
    ReleaseDC(self.Handle,hdc);
  except
    HTMLFactor := 1.0;
  end;

  SetMapMode(Canvas.Handle,MM_LOMETRIC);
  FontScalefactor := 1.0;

  newFont := TFont.Create;
  oldFont := TFont.Create;
  oldpen := TPen.Create;
  newBrush := TBrush.Create;
  oldBrush := TBrush.Create;
  Canvas.pen.Color := clBlack;
  Canvas.pen.style := FPrintSettings.FBorderStyle;

  if FPrintSettings.FBorders = pbDouble then
    Canvas.Pen.Width := 10
  else
    Canvas.Pen.Width := 2;

  Canvas.Font.Assign(FPrintSettings.HeaderFont);
  Canvas.Font.Height:=MapFontHeight(Canvas.Font.size);

  hfntsize:=Canvas.TextHeight('gh');

  Canvas.Font:=FPrintSettings.FooterFont;
  Canvas.Font.Height:=MapFontHeight(Canvas.Font.size);
  ffntsize:=Canvas.TextHeight('gh');

  Canvas.Font:=FPrintSettings.Font;

  cache_Row := -1;

  orgsize := Canvas.Font.size;

  Canvas.Font.Height:=MapFontHeight(Canvas.Font.size); {map into mm_lometric space}

  FntlineHeight := Canvas.TextHeight('gh');

  FntVSpace := fntlineHeight shr 3;
  FntHSpace := 4; // adapt for multiline

  case PrintMethod of
  prPrint:
    begin
      xsize := Canvas.Cliprect.Right - Canvas.Cliprect.Left;
      ysize := Canvas.Cliprect.Bottom;
    end;
  prCalcPrint:
    begin
      xsize := prevrect.Right - prevrect.Left;
      ysize := -prevrect.Bottom - prevrect.Top;
    end;
  prPreview,prCalcPreview:
    begin
      dptolp(Canvas.Handle,prevrect.Topleft,1);
      dptolp(Canvas.Handle,prevrect.Bottomright,1);
      xsize := (prevrect.Right - prevrect.Left);
      ysize := (prevrect.Bottom - prevrect.Top);
    end;
  end;

  ResFactor := GetDeviceCaps(Canvas.Handle,LOGPIXELSX)/GetDeviceCaps(Self.Canvas.Handle,LOGPIXELSX)*(254/GetDeviceCaps(Canvas.Handle,LOGPIXELSX));

  FPrintPageRect := Rect(0,0,xsize,ysize);

  Indent := FPrintSettings.FLeftSize;

  if FPrintSettings.FUseFixedWidth then
    Spacing := 0
  else
    Spacing := FPrintSettings.ColumnSpacing + 20; // min. 2mm space

  CalculateWidths;

  // total space req. for Columns
  TotalWidth := 0;
  for j := FPrintRect.Left to FPrintRect.Right do
  begin
    if IsSelCol(j) then
      TotalWidth := TotalWidth + MaxWidths[j] + Spacing;
  end;

  ScaleFactor := 1.0;

  if FPrintSettings.FFitToPage <> fpNever then
  begin
    tw := (FPrintRect.Right - FPrintRect.Left + 1) * Spacing;
    if TotalWidth - tw <> 0 then
      ScaleFactor := (XSize - FPrintSettings.FRightSize - FPrintSettings.FLeftSize - tw)/(TotalWidth - tw);

    if (ScaleFactor > 1.0) and (FPrintSettings.FFitToPage = fpShrink) then ScaleFactor := 1.0;
    if (ScaleFactor < 1.0) and (FPrintSettings.FFitToPage = fpGRow) then ScaleFactor := 1.0;

    if (ScaleFactor <> 1.0) and (FPrintSettings.FFitToPage = fpCustom) then
    begin
      AllowFitToPage := True;
      if Assigned(OnFitToPage) then
        OnFitToPage(Self,scalefactor,AllowFitToPage);
      if not AllowFitToPage then
        ScaleFactor := 1.0;
    end;

    if ScaleFactor <> 1.0 then
    begin
      for j := FPrintRect.Left to FPrintRect.Right do
        maxWidths[j] := Trunc(maxWidths[j] * scalefactor);
        
      TotalWidth:=0;
      //recalculate total req. width
      for j := FPrintRect.Left to FPrintRect.Right do
      begin
        TotalWidth := TotalWidth + MaxWidths[j] + spacing;
      end;
    end;
  end;

  if Assigned(FOnPrintSetColumnWidth) then
  begin
    for j := FPrintRect.Left to FPrintRect.Right do
    begin
      FOnPrintSetColumnWidth(Self,j,MaxWidths[j]);
    end;

    TotalWidth := 0;
    for j := FPrintRect.Left to FPrintRect.Right do
    begin
      if IsSelCol(j) then
        TotalWidth := TotalWidth + MaxWidths[j] + Spacing;
    end;
  end;

  StartCol := FPrintRect.Left;
  EndCol := FPrintRect.Left;

  PagNum := 0; //page counter
  PagCol := 0;
  LastRow := -1;

  //calculate the size of the fixed Columns
  MultiCol := False;
  Cancelled := False;

  while (EndCol <= FPrintRect.Right) and not Cancelled do
  begin
    // calculate new endCol here
    SpaceforFixedCols := 0;

    PrevEndCol := EndCol;

    PagRow := 0;
    Inc(PagCol);

    // added fixed spaceforCols here if repeatFixedCols is set

    RepeatCols := (EndCol > FPrintRect.Left) and (FixedCols > 0) and
                  (FPrintSettings.FRepeatFixedCols);

    if RepeatCols then
    begin
      for m := 0 to FixedCols - 1 do
        SpaceForFixedCols := SpaceForFixedCols + MaxWidths[m] + Spacing;
    end;

    SpaceForCols := SpaceForFixedCols;

    while (SpaceForCols <= XSize - FPrintSettings.fRightSize) and (EndCol <= FPrintRect.Right) do
    begin
      SpaceForCols := SpaceForCols + MaxWidths[EndCol] + Spacing;
      if SpaceForCols <= XSize - FPrintSettings.FRightSize then
        inc(EndCol);
    end;

    if not (SpaceforCols <= XSize - FPrintSettings.FRightSize) then
    begin
      SpaceForCols := SpaceForCols - MaxWidths[EndCol] - Spacing;
      Dec(EndCol);
    end;

    if EndCol <= PrevendCol then
      EndCol := PrevEndCol + 1;

    //space for Cols is the Width of the printout
    if EndCol > FPrintRect.Right then
      EndCol := FPrintRect.Right;

    MultiCol := MultiCol or (EndCol < FPrintRect.Right);

    FPrintPageWidth := SpaceForCols;

    if FPrintSettings.FCentered then
    begin
      Indents[StartCol] := 0;
      Indents[0] := 0;
    end
    else
    begin
      Indents[StartCol] := Indent;
      Indents[0] := Indent;
    end;

    for j := StartCol to EndCol do
    begin
      if IsSelCol(j) then
        Indents[j + 1] := Indents[j] + MaxWidths[j] + Spacing
      else
        Indents[j + 1] := Indents[j];
    end;

    FPrintColStart := StartCol;
    FPrintColEnd := EndCol;

    if RepeatCols then
    begin
      for m := 1 to FixedCols - 1 do
      begin
        Indents[m] := Indents[m - 1] + MaxWidths[m - 1] + Spacing;
      end;
    end;

    if (FPrintSettings.FCentered) and (SpaceForCols < XSize) then
    begin
      SpaceforCols := (XSize - SpaceForCols) shr 1;
      for j := StartCol to EndCol + 1 do
      begin
        Indents[j] := Indents[j] + SpaceForCols;
      end;

      //add centering space to repeated Columns
      if RepeatCols then
        for m := 0 to FixedCols do
        begin
          Indents[m] := Indents[m] + SpaceForCols;
        end;
    end;

    // add spacing if required for repeat fixed Columns}
    for j := StartCol to EndCol + 1 do
    begin
      Indents[j] := Indents[j] + SpaceForFixedCols;
    end;

    // fixed Columns
    j:=0;
    yposprint := -TopIndent;
    TopIndent := 0; //reserve a line for header

    HeaderSize := FPrintSettings.FHeaderSize;
    FooterSize := FPrintSettings.FFooterSize;

    if (FPrintSettings.FTime in [ppTopLeft,ppTopCenter,ppTopRight]) or
       (FPrintSettings.FDate in [ppTopLeft,ppTopCenter,ppTopRight]) or
       (FPrintSettings.FPageNr in [ppTopLeft,ppTopCenter,ppTopRight]) or
       (FPrintSettings.FTitle in [ppTopLeft,ppTopCenter,ppTopRight]) then
    begin
      TopIndent := hfntsize + fntvspace + headersize;
      if (FPrintSettings.FTitleLines.Count > 0) and (FPrintSettings.FTitle in [ppTopLeft,ppTopCenter,ppTopRight]) then
        TopIndent := TopIndent + hfntsize * (FPrintSettings.FTitleLines.Count - 1);
    end
    else
      TopIndent := HeaderSize;

    if (FPrintSettings.FTime in [ppBottomLeft,ppBottomCenter,ppBottomRight]) or
       (FPrintSettings.FDate in [ppBottomLeft,ppBottomCenter,ppBottomRight]) or
       (FPrintSettings.FPageNr in [ppBottomLeft,ppBottomCenter,ppBottomRight]) or
       (FPrintSettings.FTitle in [ppBottomLeft,ppBottomCenter,ppBottomRight]) then
    begin
      FootIndent := 2*(FFntSize + FntVSpace) + FooterSize;
      if (FPrintSettings.FTitleLines.Count > 0) and (FPrintSettings.fTitle in [ppBottomLeft,ppBottomCenter,ppBottomRight]) then
        FootIndent := FootIndent+ffntsize*(FPrintSettings.fTitleLines.Count-1);
    end
    else
      FootIndent := 1*(FFntSize + FntVSpace) + Footersize;

    i := FPrintRect.Top;

    if (PrintMethod in [prPrint,prPreview]) then
      if Assigned(FOnPrintPage) then
      begin
        FOnPrintPage(self,Canvas,PagNum + 1,xsize,ysize);
      end;

    // print all Rows here

    while (i < FPrintRect.Bottom + 1) and not Cancelled do
    begin
      //at start of page.. print header
      if j = 0 then
      begin
        YPosPrint := -TopIndent;
        BuildHeader;
        YPosPrint := YPosPrint - FPrintSettings.TitleSpacing;
      end;

      if (j = 0) and (i > 0) and
         ((PagNum > 0) or (FPrintRect.Top >= FixedRows)) and
         FPrintSettings.FRepeatFixedRows and
         (FixedRows > 0) then
      begin
        //here headers are reprinted
        for m := 0 to FixedRows - 1 do
        begin
          //if necessary, reprint fixed Columns
          if RepeatCols then
          begin
            BuildColumnsRow(yposprint,0,FixedCols-1,m,0);
          end;

          //print Columns
          th := BuildColumnsRow(yposprint,startCol,endCol,m,0);
          YPosPrint := YPosPrint - th;
        end;
        inc(j);
      end;

      if IsSelRow(i) then
      begin
        if RepeatCols then
          BuildColumnsRow(yposprint,0,FixedCols-1,i,0);

        th := BuildColumnsRow(YPosPrint,StartCol,EndCol,i,0);
        YPosPrint := YPosPrint - th;
      end;

      inc(i);
      inc(j);

      ForcedNewPage := False;

      // query to print new page after each row
      if Assigned(FOnPrintNewPage) then
      begin
        FOnPrintNewPage(Self,i,ForcedNewPage);
      end;

      if ((YPosPrint - GetRowHeight(j) < YSize + FootIndent) or
         (i >= FPrintRect.Bottom + 1)) or ForcedNewPage then
      begin
        if (PrintMethod in [prPrint,prPreview]) then
        begin
          if Assigned(FOnPrintPageDone) then
            FOnPrintPageDone(Self, Canvas, i, YPosPrint, PagNum + 1, XSize, YSize);

          if Assigned(FOnPrintCancel) then
            FOnPrintCancel(Self,PagNum + 1, Cancelled);  
        end;
      end;

      if ((YPosPrint - GetRowHeight(j) < YSize + FootIndent) and
         (i < FPrintRect.Bottom + 1)) or
         ForcedNewPage then
      begin
        DrawBorderAround(StartCol,EndCol,YPosPrint);
        j := 0;
        LastRow := i;
        StartNewPage;
        if (PreviewPage < PagNum) and FastPrint then i := FPrintRect.Bottom + 1;
         inc(PagNum);
         inc(PagRow);
      end;
    end;

    if (LastRow = -1) or (i <> LastRow) then
      DrawBorderAround(StartCol,EndCol,YPosPrint);

    StartCol := EndCol + 1;
    EndCol := StartCol;
    if EndCol <= FPrintRect.Right then
      StartNewPage;
    Inc(PagNum);
  end; //end of while EndCol < FPrintRect.Right

  // free temporary Font and Brush objects
  NewFont.Free;
  OldFont.Free;
  OldPen.Free;
  NewBrush.Free;
  OldBrush.Free;
  Result := PagNum;
end;


procedure TAdvStringGrid.InvalidateGridRect(r:TGridRect);
var
  gdr1,gdr2,gdr3:TRect;
begin
  gdr1 := CellRect(r.Left,r.Top);
  gdr2 := CellRect(r.Right,r.Bottom);
  UnionRect(gdr3,gdr1,gdr2);
  InvalidateRect(Handle,@gdr3,False);
end;

procedure TAdvStringGrid.ClearSelectedCells;
begin
  FSelectedCells.Clear;
  Invalidate;
end;

function TAdvStringGrid.GetSelectedCell(i: Integer): TGridCoord;
begin
  Result.X := Loword(integer(FSelectedCells.Items[i]));
  Result.Y := Hiword(integer(FSelectedCells.Items[i]));
end;

function TAdvStringGrid.GetSelectedCellsCount: Integer;
begin
  Result := FSelectedCells.Count;
end;

function TAdvStringGrid.GetSelectedCells(i, j: Integer): Boolean;
begin
  Result := FSelectedCells.IndexOf(Pointer(MakeLong(i,j))) <> -1;
end;

procedure TAdvStringGrid.SetSelectedCells(i, j: Integer;
  const Value: Boolean);
var
  k: Integer;
begin
  k := FSelectedCells.IndexOf(Pointer(makelong(i,j)));

  if (k = -1) and Value then
  begin
    FSelectedCells.Add(MakeLong(i,j));
    RepaintCell(i,j)
  end;

  if not Value and (k <> - 1) then
  begin
    FSelectedCells.Delete(k);
    RepaintCell(i,j);
  end;
end;

procedure TAdvStringGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  r,c,i,j: Integer;
begin
  MouseToCell(x,y,c,r);

  if (x > Width) and (FGridState = gsColSIzing) then
  begin
    FGridState := gsNormal;
    Exit;
  end;

  if (y > Height) and (FGridState = gsRowSizing) then
  begin
    FGridState := gsNormal;
    Exit;
  end;

  if MouseActions.DisjunctCellSelect and (Button = mbLeft) and (c > -1) and (r > -1) then
  begin
    c := RealColIndex(c);
    if not IsFixed(c,r) then
    begin
      if ssCtrl in Shift then
      begin
        i := FSelectedCells.IndexOf(Pointer(makelong(c,r)));
        if i = -1 then
          FSelectedCells.Add(MakeLong(c,r))
        else
          FSelectedCells.Delete(i);
      end
      else
      begin
        for i := 1 to FSelectedCells.Count do
          RepaintCell(loword(FSelectedCells.Items[i - 1]),hiword(FSelectedCells.Items[i - 1]));
        FSelectedCells.Clear;
        FSelectedCells.Add(MakeLong(c,r));
      end;
    end;

    if (Selection.Left <> Selection.Right) or
       (Selection.Top <> Selection.Bottom) then
    begin
      for i := Selection.Left to Selection.Right do
        for j := Selection.Top to Selection.Bottom do
          FSelectedCells.Add(MakeLong(i,j));
    end;



    RepaintCell(c,r);
  end;

  if (FGridState = gsColMoving) and (Button = mbRight) then
    Exit
  else
    inherited;
end;

procedure TAdvStringGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  ACol,ARow: longint;
  mrg,i: Integer;
  nondef: Boolean;
  s,Anchor,Stripped,FocusAnchor: string;
  r,hr,cr: TRect;
  pt: TPoint;
  xsize,ysize,ml,hl: Integer;
  ctt: TTextType;
  {$IFDEF DELPHI4_LVL}
  Allow: Boolean;
  dwEffects: Integer;
  DropSource: TGridDropSource;
  {$ENDIF}
  CID,CV,CT: string;
  OldSel: TGridRect;
  cc,rc: Integer;

begin
  if FMouseDownMove and FMouseActions.RangeSelectAndEdit then
    Options := Options - [goEditing];

  NonDef := False;

  OldSel := Selection;

  MouseToCell(X,Y,ACol,ARow);

  if (FMouseSelectStart <> - 1) and
     (MouseActions.RowSelect) and
     (FMouseSelectMode = msRow) then
  begin
    if ARow > FMouseSelectStart then
      Selection := TGridRect(Rect(FixedCols,FMouseSelectStart,ColCount - 1, Max(FixedRows,ARow)))
    else
      Selection := TGridRect(Rect(FixedCols,Max(FixedRows,ARow),ColCount - 1, FMouseSelectStart));
  end;

  if (FMouseSelectStart <> - 1) and
     (MouseActions.ColSelect) and
     (FMouseSelectMode = msColumn) then
  begin
    if ACol > FMouseSelectStart then
      Selection := TGridRect(Rect(FMouseSelectStart,FixedRows,Max(FixedCols,ACol),RowCount - 1))
    else
      Selection := TGridRect(Rect(Max(FixedCols,ACol),FixedRows,FMouseSelectStart,RowCount - 1));
  end;

  FSizeFixed := False;

  if (Abs(ColWidths[0] - X) < 3) and (FixedCols > 0) and
      (ACol >= 0) and (ARow >= 0) and not (csDesigning in ComponentState) then
  begin
    FSizeFixed := FMouseActions.SizeFixedCol;
  end;

  if FSizingFixed then
  begin
    DrawSizingLine(FSizeFixedX);
    FSizeFixedX := X;
    DrawSizingLine(FSizeFixedX);
  end;

  {$IFDEF DELPHI4_LVL}
  if FSelectionClick and (ACol >= 0) and (ARow >= 0) and
     ((Abs(ClickPosX - X) > 3) or (Abs(ClickPosY - Y) > 3)) and
     FDragDropSettings.FOleDropSource and not (FGridState = gsColsizing) then
  begin
    FSelectionClick := False;
    Allow := True;
    ACol := RemapCol(ACol);
    if Assigned(FOnOleDrag) then
      FOnOleDrag(self,ARow,ACol,Cells[x,y],Allow);
    if Allow then
    begin
      DropSource := TGridDropSource.Create(self);
      if Assigned(FOnOleDragStart) then
        FOnOleDragStart(Self,ARow,ACol);

      if (ARow < FixedRows) and (ACol >= 0) and DragDropSettings.OleColumnDragDrop then
      begin
        pt := ClientToScreen(point(x,y));
        MoveButton.Left := pt.x;
        MoveButton.Top := pt.y;
        MoveButton.Width := ColWidths[ACol];
        MoveButton.Height := RowHeights[0];
        MoveButton.Caption := Cells[ACol,ARow];
        MoveButton.Visible := True;
        SetWindowPos(MoveButton.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE);

        if not (StartColDoDragDrop(DropSource,ACol,DROPEFFECT_COPY or DROPEFFECT_MOVE,dwEffects) = DRAGDROP_S_CANCEL) then
        begin
          // do a full Column d&d here 
          if Assigned(FOnOleDragStop) then
            FOnOleDragStop(Self,dwEffects);
        end;

       MoveButton.Visible := False;
       ArwD.Visible := False;
       ArwU.Visible := False;
      end
     else
      begin
        FDropSelection := Selection;
        if not (StartTextDoDragDrop(DropSource,SelectedText,Cells[ACol,ARow],DROPEFFECT_COPY or DROPEFFECT_MOVE,dwEffects) = DRAGDROP_S_CANCEL) then
        begin
          if dwEffects = DROPEFFECT_MOVE then
            if FDragDropSettings.FOleRemoveRows and (goRowSelect in Options) then
            begin
              if FMouseActions.DisjunctRowSelect then
                RemoveSelectedRows
              else
                RemoveRows(FDropSelection.Top,FDropSelection.Bottom - FDropSelection.Top + 1);
            end
            else
            begin
              if not DragDropSettings.OleCopyAlways then
                ClearRect(FDropSelection.Left,FDropSelection.Top,FDropSelection.Right,FDropSelection.Bottom);
            end;

          if Assigned(FOnOleDragStop) then
            FOnOleDragStop(self,dwEffects);
        end
       end
     end
    else

    if FGridState = gsNormal then
      FGridState := gsSelecting;
  end;
 {$ENDIF}


  if not (csDesigning in Componentstate) then
  begin
    if FGridState = gsColSizing then
      Colsized := True;

    if FGridState = gsRowSizing then
      RowSized := True;

    {$IFDEF DELPHI4_LVL}
    if FGridState = gsColMoving then
    begin
      Allow := True;
      if Assigned(FOnColumnMove) then
        FOnColumnMove(Self,MoveCell,Allow);
      if not Allow then
        FGridState := gsNormal;
    end;

    if FGridState = gsRowMoving then
    begin
      Allow := True;
      if Assigned(FOnRowMove) then
        FOnRowMove(Self,MoveCell,Allow);
      if not Allow then
        FGridState := gsNormal;
    end;
    {$ENDIF}

    if (FGridState in [gsColMoving,gsRowMoving]) and
       ( (clickposx <> x) or (clickposy <> y)) and FEnhRowColMove and not FSizingFixed then
    begin
      if (FGridState = gsColMoving) and (MoveCell >= FixedCols) then
      begin
        MoveButton.Caption := Cells[RemapCol(MoveCell),0];
        MoveButton.Width := ColWidths[MoveCell];
        MoveButton.Height := RowHeights[0];
        MoveButton.Invalidate;
      end;

      if (FGridState = gsRowMoving) and (MoveCell >= FixedRows) then
      begin
        MoveButton.Caption := Cells[0,MoveCell];
        MoveButton.Height := RowHeights[MoveCell];
        MoveButton.Width := ColWidths[0];
        MoveButton.Invalidate;
      end;

      pt := ClientToScreen(point(x - moveofsx,y - moveofsy));

      MoveButton.Left := pt.x;
      MoveButton.Top := pt.y;

      {$IFDEF DELPHI3_LVL}
      if FGridState = gsColMoving then
      begin
        if FMoveColInd >= FixedCols then
        begin
          r := CellRect(FMoveColInd,0);
          r.Topleft := ClientToScreen(r.Topleft);
          r.Bottomright := ClientToScreen(r.Bottomright);

          if FMoveColInd < movecell then
          begin
            ArwU.Top := r.Bottom;
            ArwU.Left := r.Left - 5;
            ArwD.Top := r.Top - 8;
            ArwD.Left := r.Left - 5;
          end
          else
          begin
            ArwU.Top := r.Bottom;
            ArwU.Left := r.Left - 5 + ColWidths[FMoveColInd];
            ArwD.Top := r.Top - 8;
            ArwD.Left := r.Left - 5 + ColWidths[FMoveColInd];
          end;
        end;
        ArwD.Visible := (FMoveColind >= FixedCols) and (FMoveColInd - LeftCol < VisibleColCount);
        ArwU.Visible := (FMoveColind >= FixedCols) and (FMoveColInd - LeftCol < VisibleColCount);
        FMoveColInd := ACol;
        FMoveRowInd := ARow;
      end;

      if FGridState = gsRowMoving then
      begin
        if (FMoveRowInd >= FixedRows) and (FMoveRowInd - TopRow < VisibleRowCount) then
        begin
          r := CellRect(0,FMoveRowInd);
          r.Topleft := ClientToScreen(r.Topleft);
          r.Bottomright := ClientToScreen(r.Bottomright);
          
          if FMoveRowInd < movecell then
          begin
            ArwL.Top := r.Top - 5;
            ArwL.Left := r.Left - 10;
            ArwR.Top := r.Top - 5;
            ArwR.Left := r.Right;
          end
          else
          begin
            ArwL.Top := r.Top - 5 + RowHeights[FMoveRowInd];
            ArwL.Left := r.Left - 10;
            ArwR.Top := r.Top - 5 + RowHeights[FMoveRowInd];
            ArwR.Left := r.Right;
          end;
        end;
        ArwR.Visible :=(FMoveRowInd >= FixedRows) and (FMoveRowInd - TopRow < VisibleRowCount) ;
        ArwL.Visible :=(FMoveRowInd >= FixedRows) and (FMoveRowInd - TopRow < VisibleRowCount) ;
        FMoveColInd := ACol;
        FMoveRowInd := ARow;
      end;
      {$ENDIF}

      if (FGridState = gsColMoving) and (VisibleColCount < ColCount) then
      begin
        mrg := 0;
        for i := 1 to FixedCols do
          mrg := mrg + ColWidths[i - 1];
        if (x < mrg) and (LeftCol > FixedCols) then
        begin
          LeftCol := LeftCol - 1;
          Repaint;
        end;
        if (x > Width) and (LeftCol + VisibleColCount < ColCount) then
        begin
          LeftCol := LeftCol + 1;
          Repaint;
        end;
      end;

      if (FGridState = gsRowMoving) and (VisibleRowCount < RowCount) then
      begin
        mrg := 0;
        for i := 1 to FixedRows do
          mrg := mrg + RowHeights[i-1];
        if (y < mrg) and (TopRow > FixedRows) then
        begin
          TopRow := TopRow - 1;
          Repaint;
        end;
        if (y > Height) and (TopRow + VisibleRowCount < RowCount) then
        begin
          TopRow := TopRow + 1;
          Repaint;
        end;
      end;

      if not MoveButton.Visible then
      begin
        MoveButton.Visible := True;
        // +++v2.02+++
        Windows.SetFocus(Parent.Handle);
        // ---v2.02---
      end;

      if not MoveButton.Enabled then
        MoveButton.Enabled := True;

      if Screen.Cursor <> crDrag then
        Screen.Cursor := crDrag;
    end;

    FMouseSelectMode := msNormal;

    if Navigation.AllowSmartClipboard and SelectionResizer and SelectionRectangle then
    begin
      r := CellRect(Selection.Right,Selection.Bottom);
      r.Left := R.Right - 4;
      r.Top := r.Bottom - 4;

      if PtInRect(r,Point(x,y)) then
      begin
        FMouseSelectMode := msResize;
      end;

    end;

    if (ARow < FixedRows) and
       (ARow >= 0) and (ACol >= 0) and
       (ACol < self.FixedCols) and
       (FMouseActions.AllSelect) then
    begin
      NonDef := True;
      Invokedchange := True;
      FMouseSelectMode := msAll;
    end;

    if (ARow < self.FixedRows) and
       (ARow >= 0) and (ACol >= 0) and
       (ACol >= self.FixedCols) and
       (FMouseActions.ColSelect) and not InSizeZone(x,y) then
    begin
      Nondef := True;
      Invokedchange := True;
      FMouseSelectMode := msColumn;
    end;

    if (ACol < Self.FixedCols) and
       (ARow >= 0) and (ACol >= 0) and
       (ARow >= Self.FixedRows) and
       (FMouseActions.RowSelect) and not InSizeZone(x,y) then
    begin
      NonDef := True;
      InvokedChange := True;
      FMouseSelectMode := msRow;
    end;
  end;

  MouseToCell(x,y,ACol,ARow);

  if (ACol < ColCount) and (ARow < RowCount) and
     (ACol >= 0) and (ARow >= 0) then
    begin
      s := Cells[RemapCol(ACol),ARow];
      ctt := TextType(s,FEnableHTML);

      if URLShow and (ctt <> ttHTML) {$IFDEF CUSTOMIZED} or (pos('*',s)=1) {$ENDIF} then
      begin
        if IsURL(s) {$IFDEF CUSTOMIZED}  or (pos('*',s)=1) {$ENDIF}  then
        begin
          NonDef := True;
          InvokedChange := True;
          if Cursor <> crURLcursor then
            inherited Cursor := crURLcursor;
        end;
      end;

      if ctt = ttHTML then
      begin
        r := CellRect(ACol,ARow);
        r.Left := r.Left + 1 + FXYOffset.X;
        r.Top := r.Top + 1 + FXYOffset.Y;

        if HasCheckBox(ACol,ARow) then
          r.Left := r.Left + ControlLook.CheckSize;

        if not HTMLDrawEx(Canvas,s,r,GridImages,x,y,-1,0,1,True,False,False,True,True,False,not EnhTextSize,False,
                          0.0,FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,xsize,ysize,
                          ml,hl,hr,cr,CID,CV,CT,FImageCache,FContainer,self.Handle) then
          Anchor := '';

        if Anchor <> '' then
        begin
          NonDef := True;
          InvokedChange := True;
          if Cursor <> crURLcursor then
            inherited Cursor := crURLcursor;

          if Anchor <> FAnchor then
          begin
            if Assigned(FOnAnchorEnter) then
              FOnAnchorEnter(self,ARow,ACol,Anchor);
            FAnchor := Anchor;
          end;
        end
        else
        begin
          if FAnchor <> '' then
          begin
            if Assigned(FOnAnchorExit) then
              FOnAnchorExit(Self,ARow,ACol,Anchor);
            FAnchor := Anchor;
          end;
        end;
      end;
   end;

  if not NonDef and (Cursor <> FOldCursor) then
  begin
    InvokedChange := True;
    Cursor := FOldCursor;
  end;

  if (FLastHintPos.x >= 0) and (FLastHintPos.y >= 0) then
  begin
    MouseToCell(x,y,ACol,ARow);
    if (ACol <> FLastHintPos.x) or (ARow <> FLastHintPos.y) then
    begin
      Application.CancelHint;
      FLastHintPos := Point(-1,-1);
    end;
  end;

  if (gsSelecting = FGridState) and FSelectionRectangle and
     ((FMoveSelection.Top <> Selection.Top) or
     (FMoveSelection.Right <> Selection.Right) or
     (FMoveSelection.Bottom <> Selection.Bottom) or
     (FMoveSelection.Left <> Selection.Left)) then
  begin //old selection and new selection ?
    InvalidateGridrect(Selection);
    FMoveselection := Selection;
  end;

  if (RowCount = 1) or (ColCount = FixedCols) then
    FGridState := gsNormal;

  inherited MouseMove(Shift, X, Y);

 {$IFDEF DELPHI3_LVL}
  if ((csDesigning in ComponentState) or FHintShowSizing) and
    ((FGridState = gsColSizing) or (FGridState = gsRowSizing) or FSizingFixed)  then
  begin
    if FSizingFixed then
    begin
      r := CellRect(0,0);
      s := 'cw=<b>'+inttostr(FSizeFixedX)+'</b>';
      pt.x := r.Left;
      pt.y := r.Top;
    end
    else
    begin
      cc := ColClicked;
      rc := RowClicked;

      if FGridState = gsColSizing then
      begin
        if cc = -1 then
        begin
          cc := ColCount - 1;
          rc := 0;
        end;
        r := CellRect(cc,rc);
        s := 'cw=<b>'+inttostr(x - r.Left - ClickPosDx)+'</b>';
        pt.x := r.Left;
        pt.y := r.Top;
      end;

      if FGridState = gsRowSizing then
      begin
        if rc = -1 then
        begin
          rc := RowCount - 1;
          cc := 0;
        end;
        r := CellRect(cc,rc);        
        s := 'rh=<b>'+inttostr(y - r.Top - ClickPosDy)+'</b>';
        pt.x := r.Left;
        pt.y := r.Top;
      end;
    end;

    pt := ClientToScreen(pt);

    r := FScrollHintWnd.CalcHinTRect(200,s,Nil);
    FScrollHintWnd.Caption := s;
    FScrollHintWnd.Color := self.HintColor;

    r.Left := r.Left + pt.x;
    r.Right := r.Right + pt.x;
    r.Top := r.Top + pt.y;
    r.Bottom := r.Bottom + pt.y;

    FScrollHintWnd.ActivateHint(r,s);
    FScrollHintShow := True;
  end;
  {$ENDIF}

  if FEnhRowColMove then
  begin
    Update;
  end;
end;

procedure TAdvStringGrid.GridResize(Sender:tObject);
var
  nx,ny: Integer;
begin
  if csDesigning in ComponentState then Exit;

  if (Sender is TForm) and FSizeWithForm then
  begin
    nx := (Sender as tform).Width;
    ny := (Sender as tform).Height;

    if (self.Width + nx - prevsizex > 0) and (self.Height + ny - prevsizey > 0) then
    begin
      self.Width := self.Width + nx - prevsizex;
      self.Height := self.Height + ny - prevsizey;
      prevsizex := nx;
      prevsizey := ny;
    end;
  end;

  if ResizeAssigned then
  begin
    try
      FOnResize(Sender);
    except
    end;
  end;
  StretchColumn(FColumnSize.StretchColumn);
end;


procedure TAdvStringGrid.ShowHintProc(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var
  Col,Row,RCol: Integer;
  HintPos: TRect;
  Anchor,Stripped,FocusAnchor:string;
  XSize,YSize: Integer;
  hl,ml: Integer;
  hr,cr: TRect;
  CID,CV,CT: string;
begin
  HintInfo.HintColor := FHintColor;
  MouseToCell(HintInfo.CursorPos.x,HintInfo.CursorPos.y,Col,Row);

  if (Col >= 0) and (Row >= 0) then
  begin
    FLastHintPos := Point(Col,Row);

    HintPos := CellRect(Col,Row);

    RCol := RemapCol(Col);

    if (TextType(Cells[RCol,Row],FEnableHTML) = ttHTML) and FAnchorHint then
    begin
      if not HTMLDrawEx(Canvas,Cells[RCol,Row],HintPos,GridImages,HintInfo.CursorPos.x,HintInfo.CursorPos.y,-1,0,1,True,False,False,True,True,False,not EnhTextSize,False,
                          0.0,FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,xsize,ysize,
                          ml,hl,hr,cr,CID,CT,CV,FImageCache,FContainer,self.Handle) then
        Anchor := '';

      if Anchor<>'' then
      begin
        if Assigned(FOnAnchorHint) then
          FOnAnchorHint(self,RCol,Row,Anchor);
        HintStr := Anchor;
      end;
    end;

    if IsComment(RCol,Row,HintStr) then
    begin
      HintInfo.HintPos.x := HintPos.Right;
      HintInfo.HintPos.y := HintPos.Top;
    end
    else
    begin
      HintInfo.HintPos.x := HintPos.Left;
      HintInfo.HintPos.y := HintPos.Bottom+6;
    end;

    {$IFDEF DELPHI3_LVL}
    if FHintShowCells and
       (Col >= FixedCols) and
       (Row >= FixedRows) and
       (Col < ColCount - FixedRightCols) and
       (Row < RowCount - FixedFooters) then
    begin
      HintInfo.HintPos.y := HintPos.Top;
      if HTMLHint then
        HintStr := Cells[RCol,Row]
      else
        HintStr := StrippedCells[RCol,Row];
    end;

    if FHintShowLargeText and
       (Col >= FixedCols) and
       (Row >= FixedRows) and
       (Col < ColCount - FixedRightCols) and
       (Row < RowCount - FixedFooters) and
       (GetCellTextSize(RCol,Row,False).cx > ColWidths[Col]) then
    begin
      HintInfo.HintPos.y := HintPos.Top;
      if HTMLHint then
        HintStr := Cells[RCol,Row]
      else
        HintStr := StrippedCells[RCol,Row];
    end;
    {$ENDIF}

    GetCellHint(Col,Row,HintStr);

    HintInfo.HintPos := ClientToScreen(HintInfo.HintPos);
  end;
end;

procedure TAdvStringGrid.SetEditText(ACol, ARow: longint; const Value: string);
begin
  ACol := RemapCol(ACol);
  inherited SetEditText(ACol,ARow,Value);
end;

function TAdvStringGrid.GetEditText(ACol, ARow: Longint): string;
var
  AlignValue:tAlignment;
begin
  ACol := RemapCol(ACol);

  if InplaceEditor <> nil then
  begin
    AlignValue := GetCellAlignment(ACol,ARow).Alignment;
    TAdvInplaceEdit(InplaceEditor).VAlign := (AlignValue = taRightJustify);
  end;

  Result := inherited GetEditText(ACol,ARow);

  if not FEditWithTags then
    Result := HTMLStrip(Result);
end;

procedure TAdvStringGrid.CellToRich(Col,Row: Integer;RichEditor: TRichedit);
var
  MemoryStream: TMemoryStream;
  RtfText: string;
begin
  RtfText := Cells[Col,Row];
  if RtfText <> '' then
  begin
    MemoryStream := TMemoryStream.Create;
    MemoryStream.Write(RtfText[1], Length(RtfText));
    MemoryStream.Position := 0;
    RichEditor.Lines.LoadFromStream(MemoryStream);
    MemoryStream.Free;
  end
  else
    RichEditor.Clear;
end;

procedure TAdvStringGrid.RichToCell(Col,Row: Integer; RichEditor: TRichEdit);
begin
  Cells[Col,Row] := RichToString(RichEditor);
end;

function TAdvStringGrid.RichToString(RichEditor: TRichEdit):string;
var
  MemoryStream: TMemoryStream;
  RtfText: string;
begin
  MemoryStream := TMemoryStream.Create;
  RichEditor.Lines.SaveToStream(MemoryStream);
  MemoryStream.Position := 0;
  if MemoryStream.Size > 0 then
    SetString(RtfText, PChar(MemoryStream.Memory), MemoryStream.Size);
  MemoryStream.Free;

  Result := RtfText;
end;


procedure TAdvStringGrid.SetIntegralHeight(const Value: Boolean);
begin
  FIntegralHeight := Value;
  SetBounds(Left,Top,Width,Height);
end;


{$IFDEF DELPHI4_LVL}
procedure TAdvStringGrid.CalcSizingState(X, Y: Integer; var State: TGridState;
  var Index: Integer; var SizingPos, SizingOfs: Integer;
  var FixedInfo: TGridDrawInfo);
var
  cx,cy: Integer;
  Allow: Boolean;
begin
  inherited;
  MouseToCell(x - 6,y,cx,cy);
  if cy = 0 then
  begin
    Allow := True;
    if Assigned(FOnColumnSize) then
    begin
      FOnColumnSize(self,cx,Allow);
      if not Allow then State := gsNormal;
    end;
  end;

  MouseToCell(x,y - 6,cx,cy);
  if cx = 0 then
  begin
    Allow := True;
    if Assigned(FOnRowSize) then
    begin
      FOnRowSize(self,cy,Allow);
      if not Allow then State := gsNormal;
    end;
  end;

end;
{$ENDIF}

function TAdvStringGrid.HiddenRow(j: Integer):TStrings;
var
  i: Integer;
begin
  Result := nil;
  for i := 1 to FGridItems.Count do
  begin
    if (FGridItems.Items[i - 1] as TGridItem).Idx = j then
    Result := (FGridItems.Items[i - 1] as TGridItem).Items;
  end;
end;

function TAdvStringGrid.GetStrippedCell(i,j: Integer):string;
begin
  Result := HTMLStrip(Cells[i,j]);
end;

procedure TAdvStringGrid.SetUseHTMLHints(const Value: Boolean);
begin
  FUseHTMLHints := Value;

  if Value then
    HintWindowClass := THTMLHintWindow
  else
    HintWindowClass := THintWindow;  
end;


function TAdvStringGrid.GetCurrentCell:string;
begin
  Result := Cells[RealCol,Row];
end;

procedure TAdvStringGrid.SetCurrentCell(const AValue:string);
begin
  Cells[RealCol,Row] := AValue;
end;

function TAdvStringGrid.GetCellsEx(i,j: Integer):string;
begin
  if IsHiddenRow(j) then
  begin
    Result := HiddenRow(j).Strings[i];
  end
  else
  begin
    j := RemapRow(j);
    Result := Cells[i,j];
  end;
end;

function TAdvStringGrid.GetAllColWidths(i: Integer): Integer;
begin
  Result := FAllColWidths[i];
end;

procedure TAdvStringGrid.SetAllColWidths(i: Integer; const Value: Integer);
begin
  FAllColWidths[i] := Value;

  if not IsHiddenColumn(i) then
  begin
    ColWidths[RemapColInv(i)] := Value;
  end;
end;

function TAdvStringGrid.GetCursorEx: TCursor;
begin
  Result := inherited Cursor;
end;

procedure TAdvStringGrid.SetCursorEx(const Value: TCursor);
begin
  inherited Cursor := Value;
  FOldCursor := Value;
end;

function TAdvStringGrid.SortedRowIndex(ARow: Integer): Integer;
begin
  Result := ARow;
  if FSortRowXRef.Count > ARow then
    Result := FSortRowXRef.Items[ARow];
  Result := RemapRowInv(Result);
end;

function TAdvStringGrid.UnsortedRowIndex(ARow: Integer): Integer;
var
  k: Integer;
begin
  Result := ARow;
  if FSortRowXRef.Count > 0 then
  begin
    for k := 0 to FSortRowXRef.Count - 1 do
    begin
      if FSortRowXRef.Items[k] = ARow then
        Break;
    end;
    Result := k;
  end;  
end;

function TAdvStringGrid.GetUnSortedCell(i, j: Integer): string;
var
  k: Integer;
begin
  k := j;
  if FSortRowXRef.Count >= j then
  for k := 0 to FSortRowXRef.Count - 1 do
  begin
    if FSortRowXRef.Items[k ] = j then
      Break;
  end;
  Result := Cells[i,k];
end;

procedure TAdvStringGrid.SetUnSortedCell(i, j: Integer; const Value: string);
var
  k: Integer;
begin
  k := j;
  if FSortRowXRef.Count >= j then
  for k := 0 to FSortRowXRef.Count - 1 do
  begin
    if FSortRowXRef.Items[k ] = j then
      Break;
  end;

  Cells[i,k] := Value;
end;

procedure TAdvStringGrid.SetCellsEx(i,j: Integer;Value:string);
var
  rc: Integer;
begin
  if IsHiddenRow(j) then
    HiddenRow(j).Strings[i] := Value
  else
  begin
    j := RemapRow(j);
    Cells[i,j] := Value;
    rc := RemapColInv(i);
    if rc <> i then
      RepaintCell(rc,j);
  end;
end;

function TAdvStringGrid.GetObjectsEx(i,j: Integer):TObject;
begin
  if IsHiddenRow(j) then
    Result := HiddenRow(j).Objects[i]
  else
  begin
    j := RemapRow(j);
    Result := Objects[i,j];
  end;
end;

procedure TAdvStringGrid.SetObjectsEx(i,j: Integer; AObject:TObject);
begin
  if IsHiddenRow(j) then
    HiddenRow(j).Objects[i] := AObject
  else
  begin
    j := RemapRow(j);
    Objects[i,j] := AObject;
  end;
end;

function TAdvStringGrid.GetCellControls(i,j: Integer): TControl;
begin
  Result := nil;
  if HasCellProperties(i,j) then
    Result := CellProperties[i,j].Control;
end;

procedure TAdvStringGrid.SetCellControls(i,j: Integer;AControl: TControl);
var
  r: TRect;
begin
  CellProperties[i,j].Control := AControl;
  r := CellRect(i,j);
  AControl.SetBounds(r.Left,r.Top,r.Right - r.Left,r.Bottom - r.Top);
end;

procedure TAdvStringGrid.SetColors(i,j: Integer;AColor: TColor);
begin
  CellProperties[i,j].BrushColor := AColor;
  RepaintCell(DisplColIndex(i),j);
end;

function TAdvStringGrid.GetColors(i,j: Integer): TColor;
begin
  Result := clNone;
  if HasCellProperties(i,j) then
    Result := CellProperties[i,j].BrushColor;
end;

function TAdvStringGrid.GetFontColors(i, j: Integer): TColor;
begin
  Result := clNone;
  if HasCellProperties(i,j) then
    Result := CellProperties[i,j].FontColor;
end;

procedure TAdvStringGrid.SetFontColors(i, j: Integer; const Value: TColor);
begin
  CellProperties[i,j].FontColor := Value;
  RepaintCell(DisplColIndex(i),j);
end;

function TAdvStringGrid.GetFontStyles(i, j: Integer): TFontStyles;
begin
  Result := [];
  if HasCellProperties(i,j) then
    Result := CellProperties[i,j].FontStyle;
end;

procedure TAdvStringGrid.SetFontStyles(i, j: Integer;
  const Value: TFontStyles);
begin
  CellProperties[i,j].FontStyle := Value;
  RepaintCell(DisplColIndex(i),j);
end;

function TAdvStringGrid.GetFontNames(i, j: Integer): string;
begin
  Result := '';
  if HasCellProperties(i,j) then
    Result := CellProperties[i,j].FontName;
end;

function TAdvStringGrid.GetFontSizes(i, j: Integer): Integer;
begin
  Result := 0;
  if HasCellProperties(i,j) then
    Result := CellProperties[i,j].FontSize;
end;

procedure TAdvStringGrid.SetFontNames(i, j: Integer; const Value: string);
begin
  CellProperties[i,j].FontName := Value;
  RepaintCell(DisplColIndex(i),j);
end;

procedure TAdvStringGrid.SetFontSizes(i, j: Integer;
  const Value: Integer);
begin
  CellProperties[i,j].FontSize := Value;
  RepaintCell(DisplColIndex(i),j);
end;



function TAdvStringGrid.GetAlignments(i, j: Integer): TAlignment;
begin
  Result := taLeftJustify;
  if HasCellProperties(i,j) then
    Result := CellProperties[i,j].Alignment;
end;

procedure TAdvStringGrid.SetAlignments(i, j: Integer;
  const Value: TAlignment);
begin
  CellProperties[i,j].Alignment := Value;
  RepaintCell(DIsplColIndex(i),j);
end;


procedure TAdvStringGrid.SetTMSGradFrom(const Value: TColor);
begin
  FTMSGradFrom := Value;
  Invalidate;
end;

procedure TAdvStringGrid.SetTMSGradTo(const Value: TColor);
begin
  FTMSGradTo := Value;
  Invalidate;
end;

function TAdvStringGrid.GetAllColCount: Integer;
begin
  Result := ColCount + NumHiddenColumns;
end;

function TAdvStringGrid.GetAllRowCount: Integer;
begin
  Result := RowCount + NumHiddenRows;
end;


procedure TAdvStringGrid.Zoom(x: Integer);
var
  i: Integer;
begin
  if ZoomFactor + x > 10 then Exit;
  if ZoomFactor + x < -10 then Exit;
  Zoomfactor := ZoomFactor+x;

  for i := 0 to ColCount - 1 do
  begin
    if ColWidths[i] + x > 0 then
      ColWidths[i] := ColWidths[i] + x;
  end;

  for i := 0 to RowCount - 1 do
  begin
    if RowHeights[i] + x > 0 then
      RowHeights[i] := RowHeights[i] + x;
  end;
end;

procedure TAdvStringGrid.DrawIntelliFocusPoint;
var
  FocusBmp,TmpBmp: TBitmap;
  arect,brect: TRect;

begin
  focusbmp := TBitmap.Create;

  case FIntelliPan of
  ipBoth:FocusBmp.LoadFromResourceName(hinstance,'INTLI1');
  ipHorizontal:FocusBmp.LoadFromResourceName(hinstance,'INTLI2');
  ipVertical:FocusBmp.LoadFromResourceName(hinstance,'INTLI3');
  end;

  ARect := Rect(0,0,FocusBmp.Width,FocusBmp.Height);
  with wheelpanpos do
  BRect:=Rect(x,y,x + FocusBmp.Width,y + FocusBmp.Height);
  BRect:=Rect(0,0,FocusBmp.Width,FocusBmp.Height);

  TmpBmp := TBitmap.Create;
  TmpBmp.Height := FocusBmp.Height;
  TmpBmp.Width := FocusBmp.Width;
  TmpBmp.Canvas.Brush.Color := clWhite;
  TmpBmp.Canvas.BrushCopy(ARect,FocusBmp,BRect,FocusBmp.Canvas.Pixels[0,0]);

  with wheelpanpos do
    ARect := Rect(x,y,x + focusbmp.Width,y+focusbmp.Height);

  Canvas.CopyRect(ARect,TmpBmp.Canvas,BRect);
  focusbmp.free;
  tmpbmp.free;
end;

procedure TAdvStringGrid.EraseIntelliFocusPoint;
var
  r:TRect;
begin
  r := Rect(wheelpanpos.x,wheelpanpos.y,wheelpanpos.x + 32,wheelpanpos.y + 32);
  InvalidateRect(self.Handle,@r,False);
end;


procedure TAdvStringGrid.WndProc(var Message: TMessage);
var
  nr: Integer;
  pt: TPoint;
  xinc,yinc: Integer;
  cursid: Integer;
  lc: Integer;

begin
  if (Message.Msg = WM_COMMAND) and                                                    
     (Message.WParamHi = CBN_SELCHANGE) and (Message.LParam = Integer(EditCombo.Handle)) then
  begin
    nr := EditCombo.Itemindex;

    if Assigned(FOnComboChange) then
    begin
      FOnComboChange(Self,Col,Row,nr,EditCombo.Items[nr]);
    end;

    if Assigned(FOnComboObjectChange) then
    begin
      FOnComboObjectChange(Self,Col,Row,nr,EditCombo.Items[nr],EditCombo.Items.Objects[nr]);
    end;

  end;

  if (Message.Msg = WM_COMMAND) and
     (Message.WParamHi = CBN_CLOSEUP) and (Message.LParam = Integer(EditCombo.Handle)) then
  begin
    if Assigned(FOnComboCloseUp) then
      FOnComboCloseUp(Self,Col,Row);
  end;


  if Message.Msg = WM_DESTROY then
  begin
    {$IFDEF DELPHI4_LVL}
    if FOleDropTargetAssigned then RevokeDragDrop(self.Handle);
    {$ENDIF}

    KillTimer(Handle,FGridTimerID);
  end;

  if (Message.Msg = WM_COMMAND) and
     (Message.wparamhi = CBN_EDITCHANGE) then
  begin
    if Assigned(FOnComboChange) then
    begin
      FOnComboChange(self,Col,Row,-1,EditCombo.Text);
    end;
  end;

  if (message.msg = WM_TIMER) and (wheelmsg > 0) and wheelpan and (FIntelliPan <> ipNone) then
  begin
    GetCursorPos(pt);
    pt := ScreenToClient(pt);
    yinc := 0;
    xinc := 0;

    if pt.x < wheelpanpos.x - 5 then xinc := -1;
    if pt.x > wheelpanpos.x + 5 then xinc := 1;
    if pt.y < wheelpanpos.y - 5 then yinc := -1;
    if pt.y > wheelpanpos.y + 5 then yinc := 1;

    if FIntelliPan = ipHorizontal then yinc := 0;
    if FIntelliPan = ipVertical then xinc := 0;

    cursid := 8000;

    if (yinc = 0) and (xinc = 0) then cursid := 8000;
    if (yinc = 0) and (xinc > 0) then cursid := 8003;
    if (yinc = 0) and (xinc < 0) then cursid := 8002;
    if (yinc > 0) and (xinc = 0) then cursid := 8001;
    if (yinc < 0) and (xinc = 0) then cursid := 8004;
    if (yinc < 0) and (xinc < 0) then cursid := 8006;
    if (yinc < 0) and (xinc > 0) then cursid := 8005;
    if (yinc > 0) and (xinc < 0) then cursid := 8008;
    if (yinc > 0) and (xinc > 0) then cursid := 8007;

    if Row > RowCount - FixedFooters - 1 then
      Row := RowCount - 1 - FixedFooters;
    if Row < FixedRows then
      Row := FixedRows;
    if Col > ColCount - FixedRightCols - 1 then
      Col := ColCount - 1 - FixedCols;
    if Col < FixedCols then
      Col := FixedCols;

    if (Col > FixedCols) and (xinc = -1) then
    begin
      if (Col + xinc < LeftCol) or (Col + xinc >= LeftCol + VisibleColCount) then
        EraseIntelliFocusPoint;
      Col := Col + xinc;
    end;
    if (Col < ColCount - FixedRightCols - 1) and (xinc=1) then
    begin
      if (Col + xinc < LeftCol) or (Col + xinc >= LeftCol + VisibleColCount) then
        EraseIntelliFocusPoint;
      Col := Col + xinc;
    end;

    if (Row > FixedRows) and (yinc = -1) then
    begin
      if (Row + yinc < TopRow) or (Row + yinc >= TopRow + VisibleRowCount) then
        EraseIntelliFocusPoint;
      if Row + yinc >= 0 then
        Row := Row + yinc;
    end;

    if (Row < RowCount - FixedFooters-1) and (yinc = 1) then
    begin
      if (Row + yinc < TopRow) or (Row + yinc >= TopRow + VisibleRowCount) then
        EraseIntelliFocusPoint;
      if Row + yinc <= RowCount-1 then
        Row := Row + yinc;
    end;

    if cursid = 8000 then
      SetCursor(FICursor)
    else
      SetCursor(LoadCursor(hinstance,makeintresource(cursid)));
      
    DrawIntelliFocusPoint;
  end;

  if (Message.msg = WM_MBUTTONDOWN) and (wheelmsg > 0) and
     not wheelpan and (FIntelliPan <> ipNone) and (RowCount > FixedRows) then
  begin
    FICursor := LoadCursor(hinstance,makeintresource(8000));
    prevcurs := SetCursor(FICursor);
    wheelpan := True;
    wheeltimer := SetTimer(self.Handle,999,10,Nil);
    wheelpanpos.x := loword(message.lparam);
    wheelpanpos.y := hiword(message.lparam);
    SetCapture(Self.Handle);
    ShowHint := False;
    DrawIntelliFocusPoint;
  end
  else
  if ((message.msg = WM_MBUTTONDOWN) and (wheelmsg > 0) and wheelpan) or
     ((message.msg = WM_LBUTTONDOWN) and (wheelmsg > 0) and wheelpan) or
     ((message.msg = WM_RBUTTONDOWN) and (wheelmsg > 0) and wheelpan) or
     ((message.msg = WM_KEYDOWN) and (wheelmsg > 0) and wheelpan) then
  begin
    ReleaseCapture;
    KillTimer(self.Handle,wheeltimer);
    SetCursor(prevcurs);
    Showhint := True;
    wheelpan := False;
    EraseIntelliFocusPoint;
  end;

  if (message.msg = wheelmsg) and (wheelmsg > 0) and not wheelpan then //intellimouse event here
  begin
    if (GetKeystate(VK_CONTROL) and $8000 = $8000) and FIntelliZoom then
    begin  //zoom
      if message.wparam < 0 then
        Zoom(wheelscrl)
      else
        Zoom(-wheelscrl);
    end
    else
    if FEnableWheel then
    begin //normal scrolling
      if FixedRowAlways and (RowCount = 1) then
        Exit;

      if message.wparam < 0 then
        nr := Row + wheelscrl
      else
        nr := Row - wheelscrl;

      if (nr < FixedRows) then
        nr := FixedRows;
      if nr > RowCount - FixedFooters - 1 then
        nr := RowCount - FixedFooters - 1;


      if (Col > ColCount - 1) then
        Col := ColCount - 1;
      if Col < FixedCols then
        Col := FixedCols;

      lc := LeftCol;

      if (nr < RowCount) and (nr >= 0) then
      begin
        StartUpdate;
        Row := nr;
        if (goRowSelect in Options) and Navigation.KeepHorizScroll then
          LeftCol := lc;
        ResetUpdate;
      end;
    end;
  end;
  inherited;
end;

{$IFDEF DELPHI5_LVL}
function TAdvStringGrid.DoMouseWheelDown(Shift: TShiftState;
  MousePos: TPoint): Boolean;
var
  lc: Integer;
begin
  if (goRowSelect in Options) and Navigation.KeepHorizScroll then
  begin
    StartUpdate;
    lc := LeftCol;
    Result := inherited DoMouseWheelDown(Shift,MousePos);
    LeftCol := lc;
    ResetUpdate;
  end
  else
    Result := inherited DoMouseWheelDown(Shift,MousePos);
end;

function TAdvStringGrid.DoMouseWheelUp(Shift: TShiftState;
  MousePos: TPoint): Boolean;
var
  lc: Integer;
begin
  if (goRowSelect in Options) and Navigation.KeepHorizScroll then
  begin
    StartUpdate;
    lc := LeftCol;
    Result := inherited DoMouseWheelUp(Shift,MousePos);
    LeftCol := lc;
    ResetUpdate;
  end
  else
    Result := inherited DoMouseWheelUp(Shift,MousePos);
end;
{$ENDIF}


procedure TAdvStringGrid.ShowInplaceEdit;
begin
  if not HasStaticEdit(Col,Row) then
    ShowEditor;
end;

procedure TAdvStringGrid.HideInplaceEdit;
begin
  if EditMode then
  begin
    HideEditor;
    HideEditControl(Col,Row);
    EditMode := False;
    SelectCell(Col,Row);
    // SetFocus;
  end;
end;

procedure TAdvStringGrid.DoneEditing;
begin
  if Assigned(FOnEditingDone) then
    FOnEditingDone(Self);
end;


procedure TAdvStringGrid.DoneInplaceEdit(Key:word; Shift: TShiftState);
var
  FOldAlwaysEdit: Boolean;
begin
  FBlockFocus := True;
  HideInplaceEdit;
  if Key in [VK_DOWN,VK_UP,VK_LEFT,VK_RIGHT,VK_TAB] then
    Keydown(Key,shift);

  FOldAlwaysEdit := FNavigation.AlwaysEdit;
  FNavigation.AlwaysEdit := False;
  SetFocus;
  if Key = VK_RETURN then
    AdvanceEdit(Col,Row,False,True,True);

  FNavigation.AlwaysEdit := FOldAlwaysEdit;
  FBlockFocus := False;
end;

procedure TAdvStringGrid.TopLeftChanged;
var
  i,j: Integer;
  r: TRect;
  ctrl: TControl;

begin
  inherited TopLeftChanged;
  if (EditMode) and (EditControl <> edNormal) then
    HideInplaceEdit;
  UpdateVScrollBar;
  UpdateHScrollBar;
  UpdateFooter;

  for i := FOldLeftCol to FOldLeftCol + VisibleColCount do
    for j := FOldTopRow to FOldTopRow + VisibleRowCount do
    begin
      if (i < LeftCol) or (i > LeftCol + VisibleColCount) or
         (j < TopRow) or ( j > TopRow + VisibleRowCount) then
      begin
        ctrl := CellControls[i,j];
        if Assigned(ctrl) then
        begin
          r := CellRect(i,j);
          ctrl.SetBounds(r.Left,r.Top,0,0);
        end;
      end;
    end;

  for i := LeftCol to LeftCol + VisibleColCount do
    for j := TopRow to TopRow + VisibleRowCount do
    begin
        ctrl := CellControls[i,j];

        if Assigned(ctrl) then
        begin
          r := CellRect(i,j);
          ctrl.SetBounds(r.Left,r.Top,r.Right - r.Left,r.Bottom - r.Top);
        end;
    end;

  FOldLeftCol := LeftCol;
  FOldTopRow := TopRow;

end;

function TAdvStringGrid.EllipsClick(s:string):string;
var
  c: Integer;
begin
  c := RemapCol(Col);
  Result := s;
  if Assigned(OnEllipsClick) then
  begin
    OnEllipsClick(self,c,Row,s);
    Result := s;
  end;
end;

{$IFDEF DELPHI3_LVL}
function TAdvStringGrid.GeTDateTimePicker:TDateTimePicker;
begin
  Result := TDateTimePicker(EditDate);
end;
{$ENDIF}

procedure TAdvStringGrid.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Key in [VK_LEFT,VK_RIGHT,VK_DOWN,VK_UP,VK_UP,VK_END,VK_PRIOR,VK_NEXT,VK_INSERT,VK_DELETE] then
    SearchInc := '';

  inherited;

  if FNavigation.AlwaysEdit then
  begin
    if Key in [VK_LEFT,VK_RIGHT,VK_DOWN,VK_UP] then
      ShowInplaceEdit;

    if (Key = VK_TAB) and (goTabs in Options) then
      ShowInplaceEdit;
  end;
end;

function TAdvStringGrid.GetVersionNr: Integer;
begin
  Result := MakeLong(MakeWord(BLD_VER,REL_VER),MakeWord(MIN_VER,MAJ_VER));
end;

function TAdvStringGrid.GetVersionString:string;
var
  vn: Integer;
begin
  vn := GetVersionNr;
  Result := IntToStr(Hi(Hiword(vn)))+'.'+IntToStr(Lo(Hiword(vn)))+'.'+IntToStr(Hi(Loword(vn)))+'.'+IntToStr(Lo(Loword(vn)))+' '+DATE_VER;
end;

{OLE Drag & Drop interface only supported in Delphi 4+}

{$IFDEF DELPHI4_LVL}

constructor TGridDropSource.Create(AGrid: TAdvStringGrid);
begin
  inherited Create;
  FGrid := AGrid;
end;

procedure TGridDropSource.CurrentEffect(dwEffect: Longint);
begin
  if dwEffect = DROPEFFECT_MOVE then
    FLastEffect := dwEffect;

  if dwEffect = DROPEFFECT_COPY then
    FLastEffect := dwEffect;
end;

procedure TGridDropSource.QueryDrag;
var
  pt: TPoint;
begin
  GetCursorPos(pt);
  FGrid.MoveButton.Left := pt.x;
  FGrid.MoveButton.Top := pt.y - FGrid.MoveButton.Height;
end;

constructor TGridDropTarget.Create(AGrid: TAdvStringGrid);
begin
  inherited Create;
  FGrid := AGrid;
end;

procedure TGridDropTarget.DropCol(pt:TPoint; Col: Integer);
var
  c,r: Integer;
begin
  FGrid.ScreenToCell(pt,c,r);

  if dfCol in DropFormats then
  begin
    FGrid.ArwD.Visible := False;
    FGrid.ArwU.Visible := False;
    FGrid.MoveButton.Visible := False;
  end;

  if Assigned(FGrid.OnOleDropCol) then
    FGrid.OnOleDropCol(FGrid,r,c,Col);
end;

procedure TGridDropTarget.DropText(pt: TPoint; s: string);
var
  c,r,tr: Integer;
  Allow: Boolean;
  gr: TGridRect;
  Size: TPoint;

begin
  FGrid.ScreenToCell(pt,c,r);

  Allow := True;

  Size := FGrid.PasteSize(PChar(s));

  if (goRowSelect in FGrid.Options) then
  begin
    if FGrid.FDragDropSettings.OleEntireRows then
      c := 0
    else
      c := FGrid.FixedCols;
  end;

  if Assigned(FGrid.FOnOleDrop) then
    FGrid.FOnOleDrop(FGrid,r,c,s,Allow);

  if Allow then
  begin
    gr := FGrid.FDropSelection;

    if (r <= gr.Top) and (FGrid.DragDropSettings.OLERemoveRows) then
    begin
      gr.Top := gr.Top + size.y;
      gr.Bottom := gr.Bottom + size.y;
    end;

    FGrid.FDropSelection := gr;

    if (r = 0) and (FGrid.FixedRowAlways) and (FGrid.RowCount = 1) then
      Inc(r);

    if FGrid.FDragDropSettings.OleInsertRows then
    begin
      tr := FGrid.TopRow;
      if (tr > FGrid.FixedRows) then inc(tr);
      FGrid.InsertRows(r,size.y);
      if (tr > 0) then FGrid.TopRow := tr;
    end;

    FGrid.PasteText(c,r,PChar(s));

    if c < FGrid.FixedCols then
      c := FGrid.FixedCols;

    gr.Top := r;
    gr.Left := c;
    gr.Bottom := r + size.y - 1;

    if goRowSelect in FGrid.Options then
      gr.Right := c + size.x - FGrid.FixedCols
    else
      gr.Right := c + size.x - {FGrid.FixedCols-}1;

    FGrid.Selection := gr;
  end;

  FGrid.ArwL.Visible := False;
  FGrid.ArwD.Visible := False;
  FGrid.MoveButton.Visible := False;

  if Assigned(FGrid.FOnOleDropped) then
    FGrid.FOnOleDropped(FGrid,gr);
end;

procedure TGridDropTarget.DragMouseMove(pt: TPoint; var Allow: Boolean; DropFormats:TDropFormats);
var
  c,r: Integer;
  Rect: TRect;
begin
  inherited;

  FGrid.ScreenToCell(pt,c,r);

  Allow := (c >= 0) and (r >= 0);

  if Allow and not (dfCol in DropFormats) then
  begin
    if (r = 0) and (FGrid.TopRow > FGrid.FixedRows) then
    begin
      FGrid.TopRow := FGrid.TopRow - 1;
    end
    else
    if r = FGrid.TopRow + FGrid.VisibleRowCount then
    begin
      FGrid.TopRow := FGrid.TopRow + 1;
    end;
  end;

  if (dfCol in DropFormats) then
  begin
    if (r >= FGrid.FixedRows) or (c < FGrid.FixedCols) then
      Allow := False;
  end
  else
  begin
    if (r < FGrid.FixedRows) and
       not ((FGrid.RowCount = 1) and FGrid.FixedRowAlways) then
      Allow := False;
  end;

  if Assigned(FGrid.FOnOleDragOver) then
    FGrid.FOnOleDragOver(FGrid,r,c,Allow);

  if (dfCol in DropFormats) and Allow then
  begin
    FGrid.ArwD.Visible := True;
    FGrid.ArwU.Visible := True;

    Rect := FGrid.CellRect(c,r);
    pt := FGrid.ClientToScreen(Point(Rect.Left,Rect.Top));

    FGrid.ArwD.Top := pt.y-8;
    FGrid.ArwD.Left := pt.x;

    pt := FGrid.ClientToScreen(Point(Rect.Left,Rect.Bottom));

    FGrid.ArwU.Top := pt.y;
    FGrid.ArwU.Left := pt.x;

    Exit;
  end
  else
  if Allow then
  begin
    if (r = 0) and FGrid.FixedRowAlways then
      Inc(r);

    if FGrid.FDragDropSettings.FOleEntireRows then
      Rect := FGrid.CellRect(FGrid.FixedCols,r)
    else
      Rect := FGrid.CellRect(c,r);

    pt := FGrid.ClientToScreen(point(Rect.Left,Rect.Top));

    FGrid.ArwL.Visible := True;
    FGrid.ArwL.Top := pt.y;
    FGrid.ArwL.Left := pt.x - 10
  end
  else
  begin
   FGrid.ArwL.Visible := False;
   FGrid.ArwD.Visible := False;
   FGrid.ArwU.Visible := False;
  end;
end;

procedure TGridDropTarget.DragMouseLeave;
begin
  FGrid.ArwD.Visible := False;
  FGrid.ArwU.Visible := False;
  FGrid.ArwL.Visible := False;
end;


procedure TGridDropTarget.DropRTF(pt: TPoint; s: string);
var
  c,r: Integer;
  Allow: Boolean;
begin
  FGrid.ScreenToCell(pt,c,r);
  Allow := True;
  if Assigned(FGrid.FOnOleDrop) then
    FGrid.FOnOleDrop(FGrid,r,c,s,Allow);

  if Allow then
    FGrid.Cells[c,r] := s;

  FGrid.ArwL.Visible := False;
  FGrid.ArwD.Visible := False;
end;

procedure TGridDropTarget.DropFiles(pt:TPoint; Files:TStrings);
var
  Allow: Boolean;
  r,c: Integer;
begin
  if Files.Count = 1 then
  begin
    Allow := True;

    if Assigned(FGrid.OnOleDropFile) then
    begin
      FGrid.ScreenToCell(pt,c,r);
      FGrid.OnOleDropFile(FGrid,r,c,Files[0],Allow);
    end;

    if Allow then
    begin
      if Pos('.CSV',UpperCase(Files[0])) > 0 then
      begin
        if Assigned(FGrid.FOnOleDrop) then
          FGrid.FOnOleDrop(FGrid,-1,-1,Files[0],Allow);
        if Allow then
          FGrid.LoadFromCSV(files[0]);
      end;

      if Pos('.XLS',UpperCase(Files[0])) > 0 then
      begin
        if Assigned(FGrid.FOnOleDrop) then
          FGrid.FOnOleDrop(FGrid,-1,-1,Files[0],Allow);
        if Allow then
          FGrid.LoadFromXLS(Files[0]);
      end;
      
    end;
  end;

  FGrid.ArwL.Visible := False;
  FGrid.ArwD.Visible := False;
end;

procedure Initialize;
var
  Result : HResult;
begin
  Result := OleInitialize(Nil);
  Assert(Result in [S_OK, S_False], Format ('OleInitialize failed ($%x)', [Result]));
end;

{$ENDIF}

{ TGridItem }
constructor TGridItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FItems := TStringList.Create;
end;

destructor TGridItem.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TGridItem.SetIdx(const Value: Integer);
begin
  FIdx := Value;
end;

procedure TGridItem.SetItems(const Value: tstrings);
begin
  FItems := Value;
end;

{ TAdvRichEdit }

procedure TAdvRichEdit.SelNormal;
begin
  SelFormat(0);
end;

procedure TAdvRichEdit.SelSubscript;
begin
  SelFormat(-40);
end;

procedure TAdvRichEdit.SelSuperscript;
begin
  SelFormat(40);
end;

procedure TAdvRichEdit.SelFormat(Offset: Integer);
var
  Format: TCharFormat; { defined in Unit RichEdit }
begin
  FillChar( Format, SizeOf(Format), 0);
  with Format do
  begin
    cbSize := SizeOf(Format);
    dwMask := CFM_OFFSET;
    yOffset := Offset; { superscript by 40 twips, negative Values give subscripts}
  end;
  Perform( EM_SETCHARFORMAT, SCF_SELECTION,Integer(@Format));
end;

constructor TAdvRichEdit.Create(AOwner: TComponent);
begin
  inherited;
  FGrid := AOwner as TAdvStringGrid;
end;

procedure TAdvRichEdit.WMKillFocus(var Msg: TMessage);
begin
  if FGrid.InvokedFocusChange then
    Exit;

  if Msg.wparam = Integer(FGrid.Handle) then
    FGrid.HideInplaceEdit;
  inherited;
end;

procedure TAdvRichEdit.CNNotify(var Msg: TWMNotify);
type
  PREQRESIZE = ^TREQRESIZE;
  TREQRESIZE = record
    NMHdr: TNMHdr;
    rc: TRect;
  end;
var
  ReqResize: PREQRESIZE;
  NewHeight: Integer;
//  NewWidth: Integer;
  R: TRect;
  VerInfo: TOSVersionInfo;
begin
  if Msg.NMHdr^.Code = EN_REQUESTRESIZE then
  begin
    ReqResize := PREQRESIZE(Msg.NMHdr);

    if FGrid.FRichEdit.HandleAllocated then
    begin
      if Msg.NMHdr^.hwndFrom = FGrid.FRichEdit.Handle then
      begin
        FGrid.FRichEdit.FReqWidth := ReqResize^.rc.Right - ReqResize^.rc.Left;
        FGrid.FRichEdit.FReqHeight := ReqResize^.rc.Bottom - ReqResize^.rc.Top;
      end;
    end;

    if not FGrid.FInplaceRichEdit.HandleAllocated then
      Exit;

    ReqResize := PREQRESIZE(Msg.NMHdr);

    with ReqResize^ do
    begin
      if FGrid.SizeWhileTyping.Height and
         (Msg.NMHdr^.hwndFrom = FGrid.FInplaceRichEdit.Handle)
         and not FGrid.FInplaceRichEdit.FLocked then
      begin
        NewHeight := ReqResize^.rc.Bottom - ReqResize^.rc.Top;
        // NewWidth := ReqResize^.rc.Right - ReqResize^.rc.Left;

        if NewHeight > FGrid.RowHeights[FGrid.Row] then
        begin
          R := FGrid.CellRect(FGrid.Col,FGrid.Row);
          if R.Top + NewHeight < FGrid.Height then
          begin
            Height := NewHeight + 4;

            VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
            GetVersionEx(verinfo);

            if (verinfo.dwPlatformId = VER_PLATFORM_WIN32_NT) then
            begin
              // do not do this on Win9x
              // r := Rect(2,2,NewWidth - 2,NewHeight - 2);
              // SendMessage(Handle,EM_SETRECT,0,Longint(@r));
            end;

            FGrid.RowHeights[FGrid.Row] := NewHeight + 5;
            if Assigned(FGrid.OnEndRowSize) then
              FGrid.OnEndRowSize(FGrid,FGrid.Row);
          end;
        end;

      end;

    end;
  end;
  inherited;
end;

procedure TAdvRichEdit.Lock;
begin
  FLocked := True;
end;

procedure TAdvRichEdit.Unlock;
begin
  FLocked := False;
end;

procedure TAdvRichEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key in [VK_UP,VK_DOWN]) and not FGrid.WordWrap
     and not FGrid.MultiLineCells then
  begin
    FGrid.SetFocus;
    FGrid.KeyDown(Key,Shift);
  end;
end;

{ TFilter }

function TFilter.Add: TFilterData;
begin
  Result := TFilterData(inherited Add);
end;

constructor TFilter.Create(AOwner: TAdvStringGrid);
begin
  inherited Create(TFilterData);
  FOwner := AOwner;
end;

function TFilter.GetColFilter(Col: Integer): TFilterData;
var
  i: Integer;
begin
  for i := 1 to Count do
  begin
    if Items[i - 1].Column = Col then
    begin
      Result := Items[i - 1];
      Exit;
    end;
  end;

  Result := Add;
  Result.Column := Col;
end;

function TFilter.GetItem(Index: Integer): TFilterData;
begin
  Result := TFilterData(inherited GetItem(Index));
end;

function TFilter.GetOwner: tPersistent;
begin
  Result := FOwner;
end;

function TFilter.Insert(index: Integer): TFilterData;
begin
  Result := TFilterData(inherited Add);
end;

procedure TFilter.SetItem(Index: Integer; Value: TFilterData);
begin
  inherited SetItem(Index, Value);
end;

{ TBackGround }

constructor TBackGround.Create(AGrid: TAdvStringGrid);
begin
  FGrid := AGrid;
  inherited Create;
  FBitmap := TBitmap.Create;
end;

destructor TBackGround.Destroy;
begin
  FBitmap.Free;
  inherited Destroy;
end;

procedure TBackGround.SetBitmap(Value: TBitmap);
begin
  FBitmap.Assign(Value);
  FGrid.Invalidate;
end;

procedure TBackGround.SetLeft(Value: Integer);
begin
  FLeft := Value;
  FGrid.Invalidate;
end;

procedure TBackGround.SetTop(Value: Integer);
begin
  FTop := Value;
  FGrid.Invalidate;
end;

procedure TBackGround.SetDisplay(Value: TBackgroundDisplay);
begin
  FDisplay := Value;
  FGrid.Invalidate;
end;

procedure TBackGround.SetBackGroundCells(const Value: TBackgroundCells);
begin
  FBackgroundCells := Value;
  FGrid.Invalidate;
end;

{ TBands }

constructor TBands.Create(AOwner: TAdvStringGrid);
begin
  inherited Create;
  FOwner := AOwner;
  FActive := False;
  FPrimaryColor := clInfoBk;
  FSecondaryColor := clWindow;
  FPrimaryLength := 1;
  FSecondaryLength := 1;
  FTotalLength := FPrimaryLength + FSecondaryLength;
end;

procedure TBands.SetActive(const Value: Boolean);
begin
  FActive := Value;
  FOwner.Invalidate;
end;

procedure TBands.SetPrimaryColor(const Value: TColor);
begin
  FPrimaryColor := Value;
  if FActive then FOwner.Invalidate;
end;

procedure TBands.SetPrimaryLength(const Value: Integer);
begin
  FPrimaryLength := Value;
  FTotalLength :=  FSecondaryLength + FPrimaryLength;
  if FActive then FOwner.Invalidate;
end;

procedure TBands.SetSecondaryColor(const Value: TColor);
begin
  FSecondaryColor := Value;
  if FActive then FOwner.Invalidate;
end;

procedure TBands.SetSecondaryLength(const Value: Integer);
begin
  FSecondaryLength := Value;
  FTotalLength :=  FSecondaryLength + FPrimaryLength;
  if FActive then FOwner.Invalidate;
end;

{ TEditLink }

constructor TEditLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FForcedExit := False;
end;

procedure TEditLink.CreateEditor;
begin
  // virtual implementation
end;

destructor TEditLink.Destroy;
begin
  inherited Destroy;
end;

procedure TEditLink.DestroyEditor;
begin
  // virtual implementation
end;

procedure TEditLink.EditExit(Sender: TObject);
begin
  HideEditor;

  if (EditStyle = esPopup) and Assigned(FPopupForm) then
  begin
    FPopupForm.Free;
    FPopupForm := Nil;
  end;
end;

procedure TEditLink.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Allow: Boolean;
begin
  Allow := Key in [VK_LEFT, VK_RIGHT, VK_DOWN, VK_UP, VK_PRIOR, VK_NEXT,
                   VK_END, VK_UP, VK_RETURN, VK_ESCAPE, VK_TAB];

  if FWantKeyUpDown and (Key in [VK_UP,VK_DOWN]) then Allow := False;
  if FWantKeyLeftRight and (Key in [VK_LEFT,VK_RIGHT]) then Allow := False;
  if FWantKeyHomeEnd and (Key in [VK_HOME,VK_END]) then Allow := False;
  if FWantKeyPriorNext and (Key in [VK_PRIOR,VK_NEXT]) then Allow := False;
  if FWantKeyReturn and (Key in [VK_RETURN]) then Allow := False;
  if FWantKeyEscape and (Key in [VK_ESCAPE]) then Allow := False;

  if Allow then
    with FOwner do
    begin
      FForcedExit := True;
      SetFocus;
      FForcedExit := False;

      if Key = VK_ESCAPE then
        FOwner.Cells[FOwner.Col,FOwner.Row] := OriginalCellValue;

      HideInplaceEdit;

      if Key = VK_RETURN then
      begin
        AdvanceEdit(Col,Row,False,True,not (ssShift in Shift));
        Key := 0;
      end;

      if Key in [VK_DOWN,VK_UP] then
        KeyDown(Key,Shift);
    end
  else
    inherited;
end;

procedure TEditLink.FormExit(Sender: TObject);
begin
  //necessary patch for hidden cells
  if Assigned(FOwner.NormalEdit) then
    FOwner.NormalEdit.Text := GetEditorValue;
  if not FForcedExit then
    EditExit(Sender)
  else
    SetCellValue(GetEditorValue);
end;

function TEditLink.GetCellValue: string;
begin
  Result := FOwner.Cells[FOwner.RemapCol(FOwner.Col),FOwner.Row];
end;

function TEditLink.GetEditControl: TWinControl;
begin
  Result := Nil;
end;

function TEditLink.GetEditorValue: string;
begin
  Result := '';
end;

function TEditLink.GetParent: TWinControl;
begin
  if EditStyle = esPopup then
    Result := FPopupForm
  else
    Result := FOwner;
end;

procedure TEditLink.HideEditor;
var
  WinControl: TWinControl;
begin
  SetCellValue(GetEditorValue);
  FOwner.HideInplaceEdit;

  WinControl := GetEditControl;
  if Assigned(WinControl) then
    if WinControl.HandleAllocated then
    begin
      SendMessage(WinControl.Handle,WM_CLOSE,0,0);
    end;
end;

procedure TEditLink.SetCellValue(s: string);
begin
  FOwner.UpdateEditingCell(FOwner.RemapCol(FOwner.Col),FOwner.Row,s);

  //FOwner.Cells[FOwner.RemapCol(FOwner.Col),FOwner.Row] := s;
end;

procedure TEditLink.SetEditorValue(s: string);
begin
  // virtual implementation
end;

procedure TEditLink.SetFocus(Value: Boolean);
begin
  if Value then
    GetEditControl.SetFocus
  else
    FOwner.SetFocus;
end;

procedure TEditLink.SetProperties;
begin
  // virtual implementation
end;

procedure TEditLink.SetCellProps(AColor: TColor; AFont: TFont);
begin
  // virtual implementation
end;

procedure TEditLink.SetRect(r: TRect);
begin
  SetWindowPos(GetEditControl.Handle,0,r.Left,r.Top,
    r.Right-r.Left-FOwner.GridLineWidth,r.Bottom-r.Top-FOwner.GridLineWidth, SWP_NOZORDER);
end;

procedure TEditLink.SetVisible(Value: Boolean);
begin
  GetEditControl.Visible := Value;
end;

{ TGridChangeNotifier}

procedure TGridChangeNotifier.CellsChanged(R:TRect);
begin
end;

{ TFilterData }

constructor TFilterData.Create(ACollection: TCollection);
begin
  inherited;
  FCaseSensitive := True;
end;

procedure THTMLHintWindow.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $00020000;

begin
  inherited CreateParams(Params);
  Params.Style := Params.Style - WS_BORDER;

  if (Win32Platform = VER_PLATFORM_WIN32_NT) and
     ((Win32MajorVersion > 5) or
      ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1))) then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;
end;

procedure THTMLHintWindow.Paint;
var
  DC: HDC;
  R, rd, hr,cr: TRect;
  Brush, SaveBrush: HBRUSH;
  Anchor,Stripped,FocusAnchor:string;
  XSize,YSize,ml,hl:integer;
  CID,CV,CT: string;

  procedure DCFrame3D(var R: TRect; const TopLeftColor, BottomRightColor: TColor);
  var
    Pen, SavePen: HPEN;
    P: array[0..2] of TPoint;
  begin
    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(TopLeftColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-2);
    P[1] := Point(R.Left, R.Top);
    P[2] := Point(R.Right-1, R.Top);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);

    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(BottomRightColor));
    SavePen := SelectObject(DC, Pen);
    P[0] := Point(R.Left, R.Bottom-1);
    P[1] := Point(R.Right-1, R.Bottom-1);
    P[2] := Point(R.Right-1, R.Top-1);
    PolyLine(DC, P, 3);
    SelectObject(DC, SavePen);
    DeleteObject(Pen);
  end;

begin
  DC := Canvas.Handle;
  R := ClientRect;
  RD := ClientRect;

  // Background
  Brush := CreateSolidBrush(ColorToRGB(Color));

  SaveBrush := SelectObject(DC, Brush);
  FillRect(DC, R, Brush);
  SelectObject(DC, SaveBrush);
  DeleteObject(Brush);

  // Border
  DCFrame3D(R, cl3DLight, cl3DDkShadow);

  // Caption
  RD.Left := R.Left + 4;
  RD.Top := R.Top + (R.Bottom - R.Top - FTextHeight) div 2;
  RD.Bottom := RD.Top + FTextHeight + 8;
  RD.Right := RD.Right - 4;
  Canvas.Brush.Color := Color;

  HTMLDrawEx(Canvas,Caption,rd,nil,0,0,-1,0,1,False,False,False,False,False,
               False,False,False,0.0,clBlue,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,
               XSize,YSize,hl,ml,hr,cr,CID,CV,CT,nil,nil,self.Handle);
end;

procedure THTMLHintWindow.ActivateHint(Rect: TRect; const AHint: string);
var
  dx, dy : Integer;
  Pnt: TPoint;
  hr,cr: TRect;
  XSize,YSize,ml,hl: Integer;
  Anchor,Stripped,FocusAnchor: string;
  CID,CV,CT: string;

begin
  Caption := AHint;
  dx := 16;
  dy := 4;

  with Rect do
  begin
    // Calculate width and height
    Rect.Right := Rect.Left + 1024 - dx;

    HTMLDrawEx(Canvas,AHint,Rect,nil,0,0,-1,0,1,False,True,False,False,False,
               False,True,False,0.0,clBlue,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,XSize,YSize,
               hl,ml,hr,cr,CID,CT,CV,nil,nil,self.Handle);

    FTextWidth := XSize;
    Right := Left + FTextWidth + dx;

    FTextHeight := YSize;
    Bottom := Top + FTextHeight + dy;

    // Calculate position
    Pnt := Point(Rect.Left,Rect.Top);
    Left := Pnt.X;
    Top := Pnt.Y;
    Right := Right - Left + Pnt.X;
    Bottom := Bottom - Top + Pnt.Y;

    // Make sure the tooltip is completely visible
    if Right > Screen.Width then
    begin
      Left := Screen.Width - Right + Left -2;
      Right := Left + FTextWidth + dx;
    end;

    if Bottom > Screen.Height then
    begin
      Bottom := Screen.Height - 2;
      Top := Bottom - FTextHeight - dy;
    end;
  end;

  BoundsRect := Rect;

  Pnt := ClientToScreen(Point(0, 0));
  SetWindowPos(Handle, HWND_TOPMOST, Pnt.X, Pnt.Y, 0, 0,
               SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
  invalidate;
end;


function THTMLHintWindow.CalcHintRect(MaxWidth: Integer;
  const AHint: string; AData: Pointer): TRect;
var
  ARect,hr,cr: TRect;
  XSize,YSize,ml,hl: Integer;
  Anchor,Stripped,FocusAnchor: string;
  CID,CT,CV: string;
begin
  FillChar(ARect,SizeOf(ARect),0);

  ARect.Right := ARect.Left + MaxWidth;

  HTMLDrawEx(Canvas,AHint,ARect,nil,0,0,-1,0,1,False,True,False,False,False,False,
           True,False,0.0,clBlue,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,XSize,YSize,
           hl,ml,hr,cr,CID,CT,CV,nil,nil,self.Handle);

  Result := Rect(0,0,XSize,YSize);
end;

procedure THTMLHintWindow.CMTextChanged(var Message: TMessage);
begin
  Invalidate;
end;


{ TSortSettings }

constructor TSortSettings.Create(AOwner: TAdvStringGrid);
begin
  inherited Create;
  FGrid := AOwner;
  FSortFull := True;
  FSortAutoFormat := True;
  FSortUpGlyph := TBitmap.Create;
  FSortDownGlyph := TBitmap.Create;
  FIndexUpGlyph := TBitmap.Create;
  FIndexDownGlyph := TBitmap.Create;
  FSortIndexColor := clYellow;
end;

destructor TSortSettings.Destroy;
begin
  FSortUpGlyph.Free;
  FSortDownGlyph.Free;
  FIndexUpGlyph.Free;
  FIndexDownGlyph.Free;
  inherited;
end;

function TSortSettings.GetDownGlyph: TBitmap;
begin
  Result := FSortDownGlyph;
end;

function TSortSettings.GetUpGlyph: TBitmap;
begin
  Result := FSortUpGlyph;
end;

procedure TSortSettings.SetDownGlyph(const Value: TBitmap);
begin
  FSortDownGlyph.Assign(Value);
end;

procedure TSortSettings.SetIndexDownGlyph(const Value: TBitmap);
begin
  FIndexDownGlyph.Assign(Value);
end;

procedure TSortSettings.SetIndexUpGlyph(const Value: TBitmap);
begin
  FIndexUpGlyph.Assign(Value);
end;

procedure TSortSettings.SetSortRow(const Value: Integer);
begin
  if Value > FGrid.FixedRows then
    raise Exception.Create('Sort row should be smaller than number of fixed rows')
  else
    FSortRow := Value;
end;

procedure TSortSettings.SetUpGlyph(const Value: TBitmap);
begin
  FSortUpGlyph.Assign(Value);
end;

{ TControlLook }

constructor TControlLook.Create(AOwner: TAdvStringGrid);
begin
  inherited Create;
  FGrid := AOwner;
  FCheckBoxSize := 15;
  FRadioSize := 10;
  FCheckedGlyph := TBitmap.Create;
  FUnCheckedGlyph := TBitmap.Create;
  FRadioOnGlyph := TBitmap.Create;
  FRadioOffGlyph := TBitmap.Create;

  Color := clBlack;
end;

destructor TControlLook.Destroy;
begin
  FCheckedGlyph.Free;
  FUnCheckedGlyph.Free;
  FRadioOnGlyph.Free;
  FRadioOffGlyph.Free;
  inherited;
end;

procedure TControlLook.SetCheckBoxSize(const Value: Integer);
begin
  FCheckBoxSize := Value;
  FGrid.Invalidate;
end;

procedure TControlLook.SetCheckedGlyph(const Value: TBitmap);
begin
  FCheckedGlyph.Assign(Value);
  FGrid.Invalidate;
end;

procedure TControlLook.SetColor(const Value: TColor);
begin
  FColor := Value;
  FGrid.Invalidate;
end;

procedure TControlLook.SetControlStyle(const Value: TControlStyle);
begin
  FControlStyle := Value;
  FGrid.Invalidate;
end;

procedure TControlLook.SetFlatButton(const Value: Boolean);
begin
  FFlatButton := Value;
  FGrid.Invalidate;
end;

procedure TControlLook.SetRadioOffGlyph(const Value: TBitmap);
begin
  FRadioOffGlyph.Assign(Value);
  FGrid.Invalidate;
end;

procedure TControlLook.SetRadioOnGlyph(const Value: TBitmap);
begin
  FRadioOnGlyph.Assign(Value);
  FGrid.Invalidate;
end;

procedure TControlLook.SetRadioSize(const Value: Integer);
begin
  FRadioSize := Value;
  FGrid.Invalidate;
end;

procedure TControlLook.SetUnCheckedGlyph(const Value: TBitmap);
begin
  FUnCheckedGlyph.Assign(Value);
  FGrid.Invalidate;
end;

procedure TControlEdit.KeyPress(var Key: Char);
begin
  inherited;
  if Key = #13 then
    DoExit;
end;

procedure TControlCombo.KeyPress(var Key: Char);
begin
  inherited;
  if Key = #13 then
    DoExit;
end;



{ TFooterPanel }

constructor TFooterPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGrid := AOwner as TAdvStringGrid;
end;

procedure TFooterPanel.CreateWnd;
begin
  inherited;

  if FGrid.FloatingFooter.Visible then
    Height := FGrid.FloatingFooter.Height
  else
    Height := 0;
end;

procedure TFooterPanel.PaintColPreview;
var
  i, FW: Integer;
  r: TRect;
  OldColor: TColor;
begin
  FW := 0;

  for i := 1 to FGrid.FixedCols do
    FW := FW + FGrid.ColWidths[i - 1];

  for i := FGrid.LeftCol to FGrid.ColCount - 1 do
    FW := FW + FGrid.ColWidths[i];

  R := ClientRect;
  R.Right := FW;

  Canvas.Brush.Color := FGrid.FloatingFooter.Color;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color :=  FGrid.FloatingFooter.Color;
  Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);

  Canvas.Pen.Color := clGray;
  Canvas.MoveTo(R.Left,R.Bottom);
  Canvas.LineTo(R.Right - 1,R.Bottom);
  Canvas.LineTo(R.Right - 1,R.Top);
  Canvas.Pen.Color := clWhite;
  Canvas.LineTo(R.Left,R.Top);
  Canvas.LineTo(R.Left,R.Bottom);

  OldColor := FGrid.FSelectionTextColor;
  FGrid.FSelectionTextColor := clBlack;

  FGrid.DrawGridCell(Canvas,FGrid.FloatingFooter.Column, FGrid.Row, R, []);

  FGrid.FSelectionTextColor := OldColor;


  Canvas.Brush.Color := FGrid.Color;
  Canvas.Pen.Color := FGrid.Color;
  R.Left := FW;
  R.Right := ClientRect.Right;
  Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
end;

function TFooterPanel.HTMLColReplace(s:string):string;
var
  beforetag,aftertag,fld:string;
  i,j,colidx,err:integer;
begin
  beforetag:='';
  while Pos('<#',s) > 0 do
  begin
    i := pos('<#',s);
    beforetag := beforetag + Copy(s,1,i-1); //part prior to the tag
    aftertag := Copy(s,i,length(s)); //part after the tag
    j := pos('>',aftertag);
    fld := Copy(aftertag,1,j-1);
    Delete(fld,1,2);
    Delete(s,1,i+j-1);

    val(fld,colidx,err);

    if err = 0 then
      beforetag := beforetag + FGrid.Cells[colidx,FGrid.Row];
  end;

  Result := beforetag + s;
end;


procedure TFooterPanel.PaintCustomPreview;
var
  i, FW: Integer;
  r: TRect;
  OldColor: TColor;
  s: string;
  Anchor,Stripped,FocusAnchor: string;
  XSize,YSize,hl,ml: integer;
  hr,cr: TRect;
  CID,CV,CT: string;

begin
  FW := 0;

  for i := 1 to FGrid.FixedCols do
    FW := FW + FGrid.ColWidths[i - 1];

  for i := FGrid.LeftCol to FGrid.ColCount - 1 do
    FW := FW + FGrid.ColWidths[i];

  R := ClientRect;
  R.Right := FW;

  Canvas.Brush.Color := FGrid.FloatingFooter.Color;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color :=  FGrid.FloatingFooter.Color;
  Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);

  Canvas.Pen.Color := clGray;
  Canvas.MoveTo(R.Left,R.Bottom);
  Canvas.LineTo(R.Right - 1,R.Bottom);
  Canvas.LineTo(R.Right - 1,R.Top);
  Canvas.Pen.Color := clWhite;
  Canvas.LineTo(R.Left,R.Top);
  Canvas.LineTo(R.Left,R.Bottom);

  OldColor := FGrid.FSelectionTextColor;
  FGrid.FSelectionTextColor := clBlack;

  if csDesigning in ComponentState then
  begin
    s := FGrid.FloatingFooter.CustomTemplate;
    DrawText(Canvas.Handle,PChar(s),Length(s),R,0);
  end
  else
  begin
    s := HTMLColReplace(FGrid.FloatingFooter.CustomTemplate);

    R.Top := R.Top + 2;
    with FGrid do
    HTMLDrawEx(self.Canvas,s,R,Gridimages,0,0,-1,0,1,False,False,False,False,False,False,not EnhTextSize,False,
      0.0,FURLColor,clNone,clNone,clGray,Anchor,Stripped,FocusAnchor,
      XSize,YSize,hl,ml,hr,cr,CID,CT,CV,FImageCache,FContainer,self.Handle);
    R.Top := R.Top - 2;
  end;

  FGrid.FSelectionTextColor := OldColor;

  Canvas.Brush.Color := FGrid.Color;
  Canvas.Pen.Color := FGrid.Color;
  R.Left := FW;
  R.Right := ClientRect.Right;
  Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
end;

procedure TFooterPanel.PaintLastRow;
var
  i, FW: Integer;
  r: TRect;
begin
  FW := 0;

  for i := 1 to FGrid.FixedCols do
    FW := FW + FGrid.ColWidths[i - 1];

  for i := FGrid.LeftCol to FGrid.ColCount - 1 do
    FW := FW + FGrid.ColWidths[i];

  R := ClientRect;
  R.Right := FW;

  Canvas.Brush.Color := FGrid.FloatingFooter.Color;
  Canvas.Pen.Color :=  FGrid.FloatingFooter.Color;
  Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);

  Canvas.Brush.Color := FGrid.Color;
  Canvas.Pen.Color := FGrid.Color;
  R.Left := FW;
  R.Right := ClientRect.Right;


  Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);

  FW := 0;

  for i := 1 to FGrid.FixedCols do
  begin
    Canvas.Pen.Color := clWhite;

    Canvas.MoveTo(FW,R.Bottom);
    if (goFixedVertLine in FGrid.Options) and ((FGrid.Look = glSoft) and not FGrid.Flat) then
      Canvas.LineTo(FW,R.Top);

    Canvas.MoveTo(FW,R.Top);

    FW := FW + FGrid.ColWidths[i - 1];
    if (goFixedHorzLine in FGrid.Options) and ((FGrid.Look = glSoft) and not FGrid.Flat) then
      Canvas.LineTo(FW -1,R.Top);

    Canvas.MoveTo(FW -1,R.Top);

    Canvas.Pen.Color := clGray;

    if (goFixedVertLine in FGrid.Options) then
      Canvas.LineTo(FW - 1,R.Bottom);
  end;

  for i := FGrid.LeftCol to FGrid.ColCount - 1 do
  begin
    Canvas.Pen.Color := clWhite;

    Canvas.MoveTo(FW,R.Bottom);
    if (goFixedVertLine in FGrid.Options) and ((FGrid.Look = glSoft) and not FGrid.Flat) then
      Canvas.LineTo(FW,R.Top);

    Canvas.MoveTo(FW,R.Top);

    FW := FW + FGrid.ColWidths[i];
    if (goFixedHorzLine in FGrid.Options) and ((FGrid.Look = glSoft) and not FGrid.Flat) then
      Canvas.LineTo(FW -1,R.Top);

    Canvas.MoveTo(FW -1,R.Top);

    Canvas.Pen.Color := clGray;

    if (goFixedVertLine in FGrid.Options) then
      Canvas.LineTo(FW - 1,R.Bottom);
  end;

  R := ClientRect;

  for i := 1 to FGrid.FixedCols do
  begin
    R.Right := R.Left + FGrid.ColWidths[i - 1] - 1;
    FGrid.DrawGridCell(Canvas,i - 1, FGrid.RowCount - 1, R, [gdFixed]);
    R.Left := R.Right + 1;
  end;

  for i := FGrid.LeftCol to FGrid.ColCount - 1 do
  begin
    R.Right := R.Left + FGrid.ColWidths[i] - 1;
    R.Left := R.Left + 1;

    if FGrid.Colors[i,FGrid.RowCount - 1] <> clNone then
    begin
      Canvas.Brush.Color := FGrid.Colors[i,FGrid.RowCount - 1];
      Canvas.Rectangle(R.Left,R.Top,R.Right,R.Bottom);
    end;

    FGrid.DrawGridCell(Canvas,i, FGrid.RowCount - 1, R, [gdFixed]);
    R.Left := R.Right + 1;
  end;
end;

procedure TFooterPanel.Paint;
begin
  case FGrid.FloatingFooter.FooterStyle of
  fsFixedLastRow: PaintLastRow;
  fsColumnPreview: PaintColPreview;
  fsCustomPreview: PaintCustomPreview;
  end;
end;

destructor TFooterPanel.Destroy;
begin
  inherited;
end;

{ TFloatingFooter }

constructor TFloatingFooter.Create(AOwner: TAdvStringGrid);
begin
  inherited Create;
  FGrid := AOwner;
  FColor := clBtnFace;
end;

destructor TFloatingFooter.Destroy;
begin
  inherited;
end;

function TFloatingFooter.GetColumnCalc(c: Integer): TColumnCalcType;
begin
  Result := acNone;
  if FGrid.HasCellProperties(c,FGrid.RowCount - 1) then
    Result := FGrid.CellProperties[c,FGrid.RowCount -1].CalcType;
end;

procedure TFloatingFooter.Invalidate;
begin
  FGrid.FFooterPanel.Invalidate;
end;

procedure TFloatingFooter.SetColor(const Value: TColor);
begin
  FColor := Value;
  FGrid.FFooterPanel.Invalidate;
end;

procedure TFloatingFooter.SetColumn(const Value: Integer);
begin
  FColumn := Value;
  FGrid.FFooterPanel.Invalidate;
end;

procedure TFloatingFooter.SetColumnCalc(c: Integer;
  const Value: TColumnCalcType);
begin
  FGrid.CellProperties[c,FGrid.RowCount -1].CalcType := Value;
  FGrid.UpdateCell(c,FGrid.RowCount - 1);
end;

procedure TFloatingFooter.SetCustomTemplate(const Value: string);
begin
  FCustomTemplate := Value;
  FGrid.FFooterPanel.Invalidate;
end;

procedure TFloatingFooter.SetFooterStyle(const Value: TFooterStyle);
begin
  FFooterStyle := Value;

  FGrid.HideLastRow := (FFooterStyle = fsFixedLastRow) and Visible;
  FGrid.Invalidate;
  FGrid.FFooterPanel.Invalidate;
end;

procedure TFloatingFooter.SetHeight(const Value: Integer);
begin
  FHeight := Value;
  FGrid.FFooterPanel.Height := Value - 1;
end;

procedure TFloatingFooter.SetVisible(const Value: Boolean);
begin
  FVisible := Value;

  if Value then
    FGrid.FFooterPanel.Height := FHeight - 1
  else
    FGrid.FFooterPanel.Height := 0;

  FGrid.FFooterPanel.Visible := Value;

  if FGrid.FFooterPanel.Visible then
    FGrid.FixedFooters := 1
  else
    FGrid.FixedFooters := 0;

  FGrid.HideLastRow := (FFooterStyle = fsFixedLastRow) and Value;
  FGrid.Invalidate;
end;

{ TGridCellIO }

constructor TGridCellIO.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TGridCellIO.Destroy;
begin
  inherited;
end;

{ TGridCellPropIO }

constructor TGridCellPropIO.Create(AOwner: TComponent);
begin
  inherited;
  FCellProperties := TCellProperties.Create(TBaseGrid(AOwner),0,0);
end;

destructor TGridCellPropIO.Destroy;
begin
  FCellProperties.Free;
  inherited;
end;


{ TGridGraphicIO }

constructor TGridGraphicIO.Create(AOwner: TComponent);
begin
  inherited;
  FCellGraphic := TCellGraphic.Create;
end;

destructor TGridGraphicIO.Destroy;
begin
  FCellGraphic.Free;
  inherited;
end;

{ TGridBMPIO }

constructor TGridBMPIO.Create(AOwner: TComponent);
begin
  inherited;
  FBitmap := TBitmap.Create;
end;

destructor TGridBMPIO.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

{ TGridIconIO }

constructor TGridIconIO.Create(AOwner: TComponent);
begin
  inherited;
  FIcon := TIcon.Create;
end;

destructor TGridIconIO.Destroy;
begin
  FIcon.Free;
  inherited;
end;

{ TGridPicIO }

constructor TGridPicIO.Create(AOwner: TComponent);
begin
  inherited;
  FPicture := TPicture.Create;
end;

destructor TGridPicIO.Destroy;
begin
  FPicture.Free;
  inherited;
end;

{ TGridFilePicIO }

constructor TGridFilePicIO.Create(AOwner: TComponent);
begin
  inherited;
  FPicture := TFilePicture.Create;
end;

destructor TGridFilePicIO.Destroy;
begin
  FPicture.Free;
  inherited;
end;

{ TGridSLIO }

constructor TGridSLIO.Create(AOwner: TComponent);
begin
  inherited;
  FStrings := TStringList.Create;
end;

destructor TGridSLIO.Destroy;
begin
  FStrings.Free;
  inherited;
end;





{$IFDEF DELPHI4_LVL}

{ TDragDropSettings }

constructor TDragDropSettings.Create(AOwner: TAdvStringGrid);
begin
  inherited Create;
  FGrid := AOwner;
  FOleDropTarget := False;
  FOleAcceptFiles := True;
  FOleAcceptText := True;
end;

procedure TDragDropSettings.SetOleDropRTF(const Value: Boolean);
begin
  SetRTFAware(Value);
  FOleDropRTF := Value;
end;

procedure TDragDropSettings.SetOleDropTarget(const Value: Boolean);
begin
  FOleDropTarget := Value;

  if not (csDesigning in FGrid.ComponentState) then
  begin
    if FOleDropTarget then
    begin
      FGrid.FGridDropTarget := TGridDropTarget.Create(FGrid);
      FGrid.FOleDropTargetAssigned := RegisterDragDrop(FGrid.Handle, FGrid.FGridDropTarget )=s_OK;
    end
    else
      if FGrid.FOleDropTargetAssigned then RevokeDragDrop(FGrid.Handle);
  end;
end;

{$IFDEF TMSDEBUG}
procedure TAdvStringGrid.ShowColumnOrder;
var
  i: Integer;
begin
  for i := 1 to ColCount do
  begin
    outputdebugstring(pchar(inttostr(i)+':'+inttostr(FColumnOrder.Items[i - 1])));
  end;
end;
{$ENDIF}

procedure TAdvStringGrid.ResetColumnOrder;
var
  i: Integer;
  rst: Boolean;
begin
  rst := False;
  while not rst do
  begin
    rst := True;
    for i := 1 to ColCount do
    begin
      if i - 1 > FColumnOrder.Items[i - 1] then
      begin
        rst := False;
        MoveColumn(i - 1,FColumnOrder.Items[i - 1]);
      end;
    end;
  end;
end;

procedure TAdvStringGrid.SetColumnOrder;
var
  i: Integer;
begin
  FColumnOrder.Clear;
  for i := 1 to ColCount do
    FColumnOrder.Add(i - 1);
end;

function TAdvStringGrid.GetWideCells(i, j: Integer): widestring;
var
  wc: widechar;
  wsi: Integer;
  s:string;

begin
  Result := '';
  s := Cells[i,j];
  if pos('|\',s) = 1 then
  begin
    delete(s,1,2);
    for wsi := 1 to length(s) div 2 do
    begin
      wc := widechar(smallint(ord(s[wsi * 2]) + 256 * ord(s[wsi * 2 - 1])));
      Result := Result + wc;
    end;
  end
  else
    Result := s;
end;

procedure TAdvStringGrid.SetWideCells(i, j: Integer;
  const Value: widestring);
var
  k: Integer;
  wc: widechar;
  d: string;
begin
  d := '|\'; // unicode start marker

  for k := 1 to length(Value) do
  begin
    wc := Value[k];
    d := d + chr(((smallint(wc) and $FF00) shr 8));
    d := d + chr(smallint(wc) and $FF);
  end;
  Cells[i,j] := d;
end;

initialization
  Initialize;

  {$IFDEF ISDELPHI}
  RegisterClass(TAdvStringGrid);
  {$ENDIF}
  
  ComCtrlOk := GetfileVersion(comctrl) >= $00040046;
  CF_GRIDCELLS := RegisterClipboardFormat('TAdvStringGrid Cells');

finalization
  OleUninitialize
{$ENDIF}

end.



