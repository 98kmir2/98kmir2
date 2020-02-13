{***************************************************************************}
{ XPTheme interface                                                         }
{ for Delphi & C++Builder                                                   }
{ version 1.0                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2001 - 2002                                        }
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

unit ASXPVS;

interface

uses
  Windows, Graphics;

const

//---------------------------------------------------------------------------------------
//   "Window" (i.e., non-client) Parts & States
//---------------------------------------------------------------------------------------

  WP_CAPTION = 1;
  WP_SMALLCAPTION = 2;
  WP_MINCAPTION = 3;
  WP_SMALLMINCAPTION = 4;
  WP_MAXCAPTION = 5;
  WP_SMALLMAXCAPTION = 6;
  WP_FRAMELEFT = 7;
  WP_FRAMERIGHT = 8;
  WP_FRAMEBOTTOM = 9;
  WP_SMALLFRAMELEFT = 10;
  WP_SMALLFRAMERIGHT = 11;
  WP_SMALLFRAMEBOTTOM = 12;

    //---- window frame buttons ----
  WP_SYSBUTTON = 13;
  WP_MDISYSBUTTON = 14;
  WP_MINBUTTON = 15;
  WP_MDIMINBUTTON = 16;
  WP_MAXBUTTON = 17;
  WP_CLOSEBUTTON = 18;
  WP_SMALLCLOSEBUTTON = 19;
  WP_MDICLOSEBUTTON = 20;
  WP_RESTOREBUTTON = 21;
  WP_MDIRESTOREBUTTON = 22;
  WP_HELPBUTTON = 23;
  WP_MDIHELPBUTTON = 24;
  //---- scrollbars
  WP_HORZSCROLL = 25;
  WP_HORZTHUMB = 26;
  WP_VERTSCROLL = 27;
  WP_VERTTHUMB = 28;
  //---- dialog ----
  WP_DIALOG = 29;
  //---- hit-test templates ---
  WP_CAPTIONSIZINGTEMPLATE = 30;
  WP_SMALLCAPTIONSIZINGTEMPLATE = 31;
  WP_FRAMELEFTSIZINGTEMPLATE = 32;
  WP_SMALLFRAMELEFTSIZINGTEMPLATE = 33;
  WP_FRAMERIGHTSIZINGTEMPLATE = 34;
  WP_SMALLFRAMERIGHTSIZINGTEMPLATE = 35;
  WP_FRAMEBOTTOMSIZINGTEMPLATE = 36;
  WP_SMALLFRAMEBOTTOMSIZINGTEMPLATE = 37;

  FS_ACTIVE = 1;
  FS_INACTIVE = 2;

  CS_ACTIVE = 1;
  CS_INACTIVE = 2;
  CS_DISABLED = 3;

  MXCS_ACTIVE = 1;
  MXCS_INACTIVE = 2;
  MXCS_DISABLED = 3;

  MNCS_ACTIVE = 1;
  MNCS_INACTIVE = 2;
  MNCS_DISABLED = 3;

  HSS_NORMAL = 1;
  HSS_HOT = 2;
  HSS_PUSHED = 3;
  HSS_DISABLED = 4;

  HTS_NORMAL = 1;
  HTS_HOT = 2;
  HTS_PUSHED = 3;
  HTS_DISABLED = 4;

  VSS_NORMAL = 1;
  VSS_HOT = 2;
  VSS_PUSHED = 3;
  VSS_DISABLED = 4;

  VTS_NORMAL = 1;
  VTS_HOT = 2;
  VTS_PUSHED = 3;
  VTS_DISABLED = 4;

  SBS_NORMAL = 1;
  SBS_HOT = 2;
  SBS_PUSHED = 3;
  SBS_DISABLED = 4;

  MINBS_NORMAL = 1;
  MINBS_HOT = 2;
  MINBS_PUSHED = 3;
  MINBS_DISABLED = 4;

  MAXBS_NORMAL = 1;
  MAXBS_HOT = 2;
  MAXBS_PUSHED = 3;
  MAXBS_DISABLED = 4;

  RBS_NORMAL = 1;
  RBS_HOT = 2;
  RBS_PUSHED = 3;
  RBS_DISABLED = 4;

  HBS_NORMAL = 1;
  HBS_HOT = 2;
  HBS_PUSHED = 3;
  HBS_DISABLED = 4;

  CBS_NORMAL = 1;
  CBS_HOT = 2;
  CBS_PUSHED = 3;
  CBS_DISABLED = 4;

//---------------------------------------------------------------------------------------
//   "Button" Parts & States
//---------------------------------------------------------------------------------------
  BP_PUSHBUTTON = 1;
  BP_RADIOBUTTON = 2;
  BP_CHECKBOX = 3;
  BP_GROUPBOX = 4;
  BP_USERBUTTON = 5;

  PBS_NORMAL = 1;
  PBS_HOT = 2;
  PBS_PRESSED = 3;
  PBS_DISABLED = 4;
  PBS_DEFAULTED = 5;

  RBS_UNCHECKEDNORMAL = 1;
  RBS_UNCHECKEDHOT = 2;
  RBS_UNCHECKEDPRESSED = 3;
  RBS_UNCHECKEDDISABLED = 4;
  RBS_CHECKEDNORMAL = 5;
  RBS_CHECKEDHOT = 6;
  RBS_CHECKEDPRESSED = 7;
  RBS_CHECKEDDISABLED = 8;

  CBS_UNCHECKEDNORMAL = 1;
  CBS_UNCHECKEDHOT = 2;
  CBS_UNCHECKEDPRESSED = 3;
  CBS_UNCHECKEDDISABLED = 4;
  CBS_CHECKEDNORMAL = 5;
  CBS_CHECKEDHOT = 6;
  CBS_CHECKEDPRESSED = 7;
  CBS_CHECKEDDISABLED = 8;
  CBS_MIXEDNORMAL = 9;
  CBS_MIXEDHOT = 10;
  CBS_MIXEDPRESSED = 11;
  CBS_MIXEDDISABLED = 12;

  GBS_NORMAL = 1;
  GBS_DISABLED = 2;

//---------------------------------------------------------------------------------------
//   "Rebar" Parts & States
//---------------------------------------------------------------------------------------

  RP_GRIPPER = 1;
  RP_GRIPPERVERT = 2;
  RP_BAND = 3;
  RP_CHEVRON = 4;
  RP_CHEVRONVERT = 5;

  CHEVS_NORMAL = 1;
  CHEVS_HOT = 2;
  CHEVS_PRESSED = 3;

//---------------------------------------------------------------------------------------
//   "Toolbar" Parts & States
//---------------------------------------------------------------------------------------

  TP_BUTTON = 1;
  TP_DROPDOWNBUTTON = 2;
  TP_SPLITBUTTON = 3;
  TP_SPLITBUTTONDROPDOWN = 4;
  TP_SEPARATOR = 5;
  TP_SEPARATORVERT = 6;

  TS_NORMAL = 1;
  TS_HOT = 2;
  TS_PRESSED = 3;
  TS_DISABLED = 4;
  TS_CHECKED = 5;
  TS_HOTCHECKED = 6;

//---------------------------------------------------------------------------------------
//   "Status" Parts & States
//---------------------------------------------------------------------------------------
  SP_PANE = 1;
  SP_GRIPPERPANE = 2;
  SP_GRIPPER = 3;

//---------------------------------------------------------------------------------------
//   "Menu" Parts & States
//---------------------------------------------------------------------------------------

  MP_MENUITEM = 1;
  MP_MENUDROPDOWN = 2;
  MP_MENUBARITEM = 3;
  MP_MENUBARDROPDOWN = 4;
  MP_CHEVRON = 5;
  MP_SEPARATOR = 6;

  MS_NORMAL = 1;
  MS_SELECTED = 2;
  MS_DEMOTED = 3;

//---------------------------------------------------------------------------------------
//   "ListView" Parts & States
//---------------------------------------------------------------------------------------

  LVP_LISTITEM = 1;
  LVP_LISTGROUP = 2;
  LVP_LISTDETAIL = 3;
  LVP_LISTSORTEDDETAIL = 4;
  LVP_EMPTYTEXT = 5;

  LIS_NORMAL = 1;
  LIS_HOT = 2;
  LIS_SELECTED = 3;
  LIS_DISABLED = 4;
  LIS_SELECTEDNOTFOCUS = 5;

//---------------------------------------------------------------------------------------
//   "Header" Parts & States
//---------------------------------------------------------------------------------------
  HP_HEADERITEM = 1;
  HP_HEADERITEMLEFT = 2;
  HP_HEADERITEMRIGHT = 3;
  HP_HEADERSORTARROW = 4;

  HIS_NORMAL = 1;
  HIS_HOT = 2;
  HIS_PRESSED = 3;

  HILS_NORMAL = 1;
  HILS_HOT = 2;
  HILS_PRESSED = 3;

  HIRS_NORMAL = 1;
  HIRS_HOT = 2;
  HIRS_PRESSED = 3;

  HSAS_SORTEDUP = 1;
  HSAS_SORTEDDOWN = 2;

//---------------------------------------------------------------------------------------
//   "Progress" Parts & States
//---------------------------------------------------------------------------------------
  PP_BAR = 1;
  PP_BARVERT = 2;
  PP_CHUNK = 3;
  PP_CHUNKVERT = 4;

//---------------------------------------------------------------------------------------
//   "Tab" Parts & States
//---------------------------------------------------------------------------------------

  TABP_TABITEM = 1;
  TABP_TABITEMLEFTEDGE = 2;
  TABP_TABITEMRIGHTEDGE = 3;
  TABP_TABITEMBOTHEDGE = 4;
  TABP_TOPTABITEM = 5;
  TABP_TOPTABITEMLEFTEDGE = 6;
  TABP_TOPTABITEMRIGHTEDGE = 7;
  TABP_TOPTABITEMBOTHEDGE = 8;
  TABP_PANE = 9;
  TABP_BODY = 10;

  TIS_NORMAL = 1;
  TIS_HOT = 2;
  TIS_SELECTED = 3;
  TIS_DISABLED = 4;
  TIS_FOCUSED = 5;

  TILES_NORMAL = 1;
  TILES_HOT = 2;
  TILES_SELECTED = 3;
  TILES_DISABLED = 4;
  TILES_FOCUSED = 5;

  TIRES_NORMAL = 1;
  TIRES_HOT = 2;
  TIRES_SELECTED = 3;
  TIRES_DISABLED = 4;
  TIRES_FOCUSED = 5;

  TIBES_NORMAL = 1;
  TIBES_HOT = 2;
  TIBES_SELECTED = 3;
  TIBES_DISABLED = 4;
  TIBES_FOCUSED = 5;

  TTIS_NORMAL = 1;
  TTIS_HOT = 2;
  TTIS_SELECTED = 3;
  TTIS_DISABLED = 4;
  TTIS_FOCUSED = 5;

  TTILES_NORMAL = 1;
  TTILES_HOT = 2;
  TTILES_SELECTED = 3;
  TTILES_DISABLED = 4;
  TTILES_FOCUSED = 5;

  TTIRES_NORMAL = 1;
  TTIRES_HOT = 2;
  TTIRES_SELECTED = 3;
  TTIRES_DISABLED = 4;
  TTIRES_FOCUSED = 5;

  TTIBES_NORMAL = 1;
  TTIBES_HOT = 2;
  TTIBES_SELECTED = 3;
  TTIBES_DISABLED = 4;
  TTIBES_FOCUSED = 5;

//---------------------------------------------------------------------------------------
//   "Trackbar" Parts & States
//---------------------------------------------------------------------------------------

  TKP_TRACK = 1;
  TKP_TRACKVERT = 2;
  TKP_THUMB = 3;
  TKP_THUMBBOTTOM = 4;
  TKP_THUMBTOP = 5;
  TKP_THUMBVERT = 6;
  TKP_THUMBLEFT = 7;
  TKP_THUMBRIGHT = 8;
  TKP_TICS = 9;
  TKP_TICSVERT = 10;

  TKS_NORMAL = 1;
  TRS_NORMAL = 1;
  TRVS_NORMAL = 1;

  TUS_NORMAL = 1;
  TUS_HOT = 2;
  TUS_PRESSED = 3;
  TUS_FOCUSED = 4;
  TUS_DISABLED = 5;

  TUBS_NORMAL = 1;
  TUBS_HOT = 2;
  TUBS_PRESSED = 3;
  TUBS_FOCUSED = 4;
  TUBS_DISABLED = 5;

  TUTS_NORMAL = 1;
  TUTS_HOT = 2;
  TUTS_PRESSED = 3;
  TUTS_FOCUSED = 4;
  TUTS_DISABLED = 5;

  TUVS_NORMAL = 1;
  TUVS_HOT = 2;
  TUVS_PRESSED = 3;
  TUVS_FOCUSED = 4;
  TUVS_DISABLED = 5;

  TUVLS_NORMAL = 1;
  TUVLS_HOT = 2;
  TUVLS_PRESSED = 3;
  TUVLS_FOCUSED = 4;
  TUVLS_DISABLED = 5;

  TUVRS_NORMAL = 1;
  TUVRS_HOT = 2;
  TUVRS_PRESSED = 3;
  TUVRS_FOCUSED = 4;
  TUVRS_DISABLED = 5;

  TSS_NORMAL = 1;

  TSVS_NORMAL = 1;

//---------------------------------------------------------------------------------------
//   "Tooltips" Parts & States
//---------------------------------------------------------------------------------------

  TTP_STANDARD = 1;
  TTP_STANDARDTITLE = 2;
  TTP_BALLOON = 3;
  TTP_BALLOONTITLE = 4;
  TTP_CLOSE = 5;

  TTCS_NORMAL = 1;
  TTCS_HOT = 2;
  TTCS_PRESSED = 3;

  TTSS_NORMAL = 1;
  TTSS_LINK = 2;

  TTBS_NORMAL = 1;
  TTBS_LINK = 2;

//---------------------------------------------------------------------------------------
//   "TreeView" Parts & States
//---------------------------------------------------------------------------------------

  TVP_TREEITEM = 1;
  TVP_GLYPH = 2;
  TVP_BRANCH = 3;

  TREIS_NORMAL = 1;
  TREIS_HOT = 2;
  TREIS_SELECTED = 3;
  TREIS_DISABLED = 4;
  TREIS_SELECTEDNOTFOCUS = 5;

  GLPS_CLOSED = 1;
  GLPS_OPENED = 2;

//---------------------------------------------------------------------------------------
//   "Spin" Parts & States
//---------------------------------------------------------------------------------------

  SPNP_UP = 1;
  SPNP_DOWN = 2;
  SPNP_UPHORZ = 3;
  SPNP_DOWNHORZ = 4;

  UPS_NORMAL = 1;
  UPS_HOT = 2;
  UPS_PRESSED = 3;
  UPS_DISABLED = 4;

  DNS_NORMAL = 1;
  DNS_HOT = 2;
  DNS_PRESSED = 3;
  DNS_DISABLED = 4;

  UPHZS_NORMAL = 1;
  UPHZS_HOT = 2;
  UPHZS_PRESSED = 3;
  UPHZS_DISABLED = 4;

  DNHZS_NORMAL = 1;
  DNHZS_HOT = 2;
  DNHZS_PRESSED = 3;
  DNHZS_DISABLED = 4;

//---------------------------------------------------------------------------------------
//   "Page" Parts & States
//---------------------------------------------------------------------------------------

  PGRP_UP = 1;
  PGRP_DOWN = 2;
  PGRP_UPHORZ = 3;
  PGRP_DOWNHORZ = 4;

//--- Pager uses same states as Spin ---

//---------------------------------------------------------------------------------------
//   "Scrollbar" Parts & States
//---------------------------------------------------------------------------------------

  SBP_ARROWBTN = 1;
  SBP_THUMBBTNHORZ = 2;
  SBP_THUMBBTNVERT = 3;
  SBP_LOWERTRACKHORZ = 4;
  SBP_UPPERTRACKHORZ = 5;
  SBP_LOWERTRACKVERT = 6;
  SBP_UPPERTRACKVERT = 7;
  SBP_GRIPPERHORZ = 8;
  SBP_GRIPPERVERT = 9;
  SBP_SIZEBOX = 10;

  ABS_UPNORMAL = 1;
  ABS_UPHOT = 2;
  ABS_UPPRESSED = 3;
  ABS_UPDISABLED = 4;
  ABS_DOWNNORMAL = 5;
  ABS_DOWNHOT = 6;
  ABS_DOWNPRESSED = 7;
  ABS_DOWNDISABLED = 8;
  ABS_LEFTNORMAL = 9;
  ABS_LEFTHOT = 10;
  ABS_LEFTPRESSED = 11;
  ABS_LEFTDISABLED = 12;
  ABS_RIGHTNORMAL = 13;
  ABS_RIGHTHOT = 14;
  ABS_RIGHTPRESSED = 15;
  ABS_RIGHTDISABLED = 16;

  SCRBS_NORMAL = 1;
  SCRBS_HOT = 2;
  SCRBS_PRESSED = 3;
  SCRBS_DISABLED = 4;

  SZB_RIGHTALIGN = 1;
  SZB_LEFTALIGN = 2;

//---------------------------------------------------------------------------------------
//   "Edit" Parts & States
//---------------------------------------------------------------------------------------
  EP_EDITTEXT = 1;
  EP_CARET = 2;

  ETS_NORMAL = 1;
  ETS_HOT = 2;
  ETS_SELECTED = 3;
  ETS_DISABLED = 4;
  ETS_FOCUSED = 5;
  ETS_READONLY = 6;
  ETS_ASSIST = 7;

//---------------------------------------------------------------------------------------
//   "ComboBox" Parts & States
//---------------------------------------------------------------------------------------

  CP_DROPDOWNBUTTON = 1;

  CBXS_NORMAL = 1;
  CBXS_HOT = 2;
  CBXS_PRESSED = 3;
  CBXS_DISABLED = 4;

//---------------------------------------------------------------------------------------
//   "Taskbar Clock" Parts & States
//---------------------------------------------------------------------------------------

  CLP_TIME = 1;
  CLS_NORMAL = 1;

//---------------------------------------------------------------------------------------
//   "Tray Notify" Parts & States
//---------------------------------------------------------------------------------------

  TNP_BACKGROUND = 1;
  TNP_ANIMBACKGROUND = 2;

//---------------------------------------------------------------------------------------
//   "TaskBar" Parts & States
//---------------------------------------------------------------------------------------

  TBP_BACKGROUNDBOTTOM = 1;
  TBP_BACKGROUNDRIGHT = 2;
  TBP_BACKGROUNDTOP = 3;
  TBP_BACKGROUNDLEFT = 4;
  TBP_SIZINGBARBOTTOM = 5;
  TBP_SIZINGBARRIGHT = 6;
  TBP_SIZINGBARTOP = 7;
  TBP_SIZINGBARLEFT = 8;

//---------------------------------------------------------------------------------------
//   "TaskBand" Parts & States
//---------------------------------------------------------------------------------------

  TDP_GROUPCOUNT = 1;
  TDP_FLASHBUTTON = 2;
  TDP_FLASHBUTTONGROUPMENU = 3;

//---------------------------------------------------------------------------------------
//   "StartPanel" Parts & States
//---------------------------------------------------------------------------------------

  SPP_USERPANE = 1;
  SPP_MOREPROGRAMS = 2;
  SPP_MOREPROGRAMSARROW = 3;
  SPP_PROGLIST = 4;
  SPP_PROGLISTSEPARATOR = 5;
  SPP_PLACESLIST = 6;
  SPP_PLACESLISTSEPARATOR = 7;
  SPP_LOGOFF = 8;
  SPP_LOGOFFBUTTONS = 9;
  SPP_USERPICTURE = 10;
  SPP_PREVIEW = 11;

  SPS_NORMAL = 1;
  SPS_HOT = 2;
  SPS_PRESSED = 3;

  SPLS_NORMAL = 1;
  SPLS_HOT = 2;
  SPLS_PRESSED = 3;

//---------------------------------------------------------------------------------------
//   "ExplorerBar" Parts & States
//---------------------------------------------------------------------------------------

  EBP_HEADERBACKGROUND = 1;
  EBP_HEADERCLOSE = 2;
  EBP_HEADERPIN = 3;
  EBP_IEBARMENU = 4;
  EBP_NORMALGROUPBACKGROUND = 5;
  EBP_NORMALGROUPCOLLAPSE = 6;
  EBP_NORMALGROUPEXPAND = 7;
  EBP_NORMALGROUPHEAD = 8;
  EBP_SPECIALGROUPBACKGROUND = 9;
  EBP_SPECIALGROUPCOLLAPSE = 10;
  EBP_SPECIALGROUPEXPAND = 11;
  EBP_SPECIALGROUPHEAD = 12;

  EBHC_NORMAL = 1;
  EBHC_HOT = 2;
  EBHC_PRESSED = 3;

  EBHP_NORMAL = 1;
  EBHP_HOT = 2;
  EBHP_PRESSED = 3;
  EBHP_SELECTEDNORMAL = 4;
  EBHP_SELECTEDHOT = 5;
  EBHP_SELECTEDPRESSED = 6;

  EBM_NORMAL = 1;
  EBM_HOT = 2;
  EBM_PRESSED = 3;

  EBNGC_NORMAL = 1;
  EBNGC_HOT = 2;
  EBNGC_PRESSED = 3;

  EBNGE_NORMAL = 1;
  EBNGE_HOT = 2;
  EBNGE_PRESSED = 3;

  EBSGC_NORMAL = 1;
  EBSGC_HOT = 2;
  EBSGC_PRESSED = 3;

  EBSGE_NORMAL = 1;
  EBSGE_HOT = 2;
  EBSGE_PRESSED = 3;

//---------------------------------------------------------------------------------------
//   "TaskBand" Parts & States
//---------------------------------------------------------------------------------------
  MDP_NEWAPPBUTTON = 1;
  MDP_SEPERATOR = 2;

  MDS_NORMAL = 1;
  MDS_HOT = 2;
  MDS_PRESSED = 3;
  MDS_DISABLED = 4;
  MDS_CHECKED = 5;
  MDS_HOTCHECKED = 6;

  DTT_GRAYED = $1; {// draw a grayed-out string}

  HTTB_BACKGROUNDSEG = $0000;
  HTTB_FIXEDBORDER = $0002; {// Return code may be either HTCLIENT or HTBORDER.}
  HTTB_CAPTION = $0004;
  HTTB_RESIZINGBORDER_LEFT = $0010; {// Hit test left resizing border,}
  HTTB_RESIZINGBORDER_TOP = $0020; {// Hit test top resizing border}
  HTTB_RESIZINGBORDER_RIGHT = $0040; {// Hit test right resizing border}
  HTTB_RESIZINGBORDER_BOTTOM = $0080; {// Hit test bottom resizing border}
  HTTB_RESIZINGBORDER = (HTTB_RESIZINGBORDER_LEFT OR HTTB_RESIZINGBORDER_TOP);
  HTTB_SIZINGTEMPLATE = $0100;
  HTTB_SYSTEMSIZINGMARGINS = $0200;

  MAX_INTLIST_COUNT = 10;

  ETDT_DISABLE = $00000001;
  ETDT_ENABLE = $00000002;
  ETDT_USETABTEXTURE = $00000004;
  ETDT_ENABLETAB = (ETDT_ENABLE OR ETDT_USETABTEXTURE);


  STAP_ALLOW_NONCLIENT = 1;
  STAP_ALLOW_CONTROLS = 2;
  STAP_ALLOW_WEBCONTENT = 4;


  SZ_THDOCPROP_DISPLAYNAME = 'DisplayName';
  SZ_THDOCPROP_CANONICALNAME = 'ThemeName';
  SZ_THDOCPROP_TOOLTIP = 'ToolTip';
  SZ_THDOCPROP_AUTHOR = 'author';


type
  HTHEME = THandle;
  THEMESIZE = ( TS_MIN, TS_TRUE, TS_DRAW );

  _MARGINS = record
    cxLeftWidth: Integer;
    cxRightWidth: Integer;
    cyTopHeight: Integer;
    cyBottomHeight: Integer;
  end {_MARGINS};
  MARGINS = _MARGINS;
  PMARGINS = ^_MARGINS;

  _INTLIST = record
    iValueCount: Integer;
    iValues: Array[0..MAX_INTLIST_COUNT-1] of Integer;
  end {_INTLIST};
  INTLIST = _INTLIST;
  PINTLIST = ^_INTLIST;

  PROPERTYORIGIN = (
    PO_STATE,
    PO_PART,
    PO_CLASS,
    PO_GLOBAL,
    PO_NOTFOUND  );

var
  OpenThemeData: function(hwnd: THandle; pszClassList: PWideChar): HTheme cdecl stdcall;


  CloseThemeData: function(hTheme: HTHEME): THandle cdecl stdcall;

  DrawThemeBackground: function(hTheme: HTHEME;
                                hdc: HDC;
                                iPartId: Integer;
                                iStateId: Integer;
                                const pRect: PRECT;
                                const pClipRect: PRECT): THandle cdecl stdcall;

  DrawThemeText: function(hTheme: HTHEME;
                          hdc: HDC;
                          iPartId: Integer;
                          iStateId: Integer;
                          var pszText: PWideChar;
                          iCharCount: Integer;
                          dwTextFlags: LongInt;
                          dwTextFlags2: LongInt;
                          const pRect: PRECT): THandle cdecl stdcall;

  GetThemeBackgroundContentRect: function(hTheme: HTHEME;
                                          hdc: HDC;
                                          iPartId: Integer;
                                          iStateId: Integer;
                                          const pBoundingRect: PRECT;
                                          var pContentRect: TRECT): THandle cdecl stdcall;

  GetThemeBackgroundExtent: function(hTheme: HTHEME;
                                     hdc: HDC;
                                     iPartId: Integer;
                                     iStateId: Integer;
                                     const pContentRect: PRECT;
                                     var pExtentRect: TRECT): THandle cdecl stdcall;

  GetThemeTextExtent: function(hTheme: HTHEME;
                               hdc: HDC;
                               iPartId: Integer;
                               iStateId: Integer;
                               var pszText: PWideChar;
                               iCharCount: Integer;
                               dwTextFlags: LongInt;
                               const pBoundingRect: PRECT;
                               var pExtentRect: TRECT): THandle cdecl stdcall;

  GetThemeTextMetrics: function(hTheme: HTHEME;
                                hdc: HDC;
                                iPartId: Integer;
                                iStateId: Integer;
                                var ptm: TTEXTMETRIC): THandle cdecl stdcall;

  GetThemeBackgroundRegion: function(hTheme: HTHEME;
                                     hdc: HDC;
                                     iPartId: Integer;
                                     iStateId: Integer;
                                     const pRect: PRECT;
                                     var pRegion: HRGN): THandle cdecl stdcall;

  HitTestThemeBackground: function(hTheme: HTHEME;
                                   hdc: HDC;
                                   iPartId: Integer;
                                   iStateId: Integer;
                                   dwOptions: LongInt;
                                   const pRect: PRECT;
                                   hrgn: HRGN;
                                   var ptTest: Integer;
                                   var pwHitTestCode: WORD): THandle cdecl stdcall;

  DrawThemeEdge: function(hTheme: HTHEME;
                          hdc: HDC;
                          iPartId: Integer;
                          iStateId: Integer;
                          const pDestRect: PRECT;
                          uEdge: Word;
                          uFlags: Word;
                          var pContentRect: TRECT): THandle cdecl stdcall;

  DrawThemeIcon: function(hTheme: HTHEME;
                          hdc: HDC;
                          iPartId: Integer;
                          iStateId: Integer;
                          const pRect: PRECT;
                          himl: THandle;
                          iImageIndex: Integer): THandle cdecl stdcall;

  IsThemePartDefined: function(hTheme: HTHEME;
                      iPartId: Integer;
                      iStateId: Integer): Integer cdecl stdcall;

  IsThemeBackGroundPartiallyTransparent: function(hTheme: HTHEME;
                      iPartId: Integer;
                      iStateId: Integer): Integer cdecl stdcall;

  GetThemeColor: function(hTheme: HTHEME;
                          iPartId: Integer;
                          iStateId: Integer;
                          iPropId: Integer;
                          var pColor: TCOLOR): THandle cdecl stdcall;

  GetThemeMetric: function(hTheme: HTHEME;
                           hdc: HDC;
                           iPartId: Integer;
                           iStateId: Integer;
                           iPropId: Integer;
                           var piVal: Integer): THandle cdecl stdcall;

  GetThemeString: function(hTheme: HTHEME;
                           iPartId: Integer;
                           iStateId: Integer;
                           iPropId: Integer;
                           pszBuff: PWideChar;
                           cchMaxBuffChars: Integer): THandle cdecl stdcall;

  GetThemeBool: function(hTheme: HTHEME;
                         iPartId: Integer;
                         iStateId: Integer;
                         iPropId: Integer;
                         var pfVal: Bool): THandle cdecl stdcall;

  GetThemeInt: function(hTheme: HTHEME;
                        iPartId: Integer;
                        iStateId: Integer;
                        iPropId: Integer;
                        var piVal: Integer): THandle cdecl stdcall;

  GetThemeEnumValue: function(hTheme: HTHEME;
                              iPartId: Integer;
                              iStateId: Integer;
                              iPropId: Integer;
                              var piVal: Integer): THandle cdecl stdcall;

  GetThemePosition: function(hTheme: HTHEME;
                             iPartId: Integer;
                             iStateId: Integer;
                             iPropId: Integer;
                             var pPoint: TPOINT): THandle cdecl stdcall;

  GetThemeFont: function(hTheme: HTHEME;
                         hdc: HDC;
                         iPartId: Integer;
                         iStateId: Integer;
                         iPropId: Integer;
                         var pFont: TLOGFONT): THandle cdecl stdcall;

  GetThemeRect: function(hTheme: HTHEME;
                         iPartId: Integer;
                         iStateId: Integer;
                         iPropId: Integer;
                         var pRect: TRECT): THandle cdecl stdcall;

  GetThemeMargins: function(hTheme: HTHEME;
                            hdc: HDC;
                            iPartId: Integer;
                            iStateId: Integer;
                            iPropId: Integer;
                            var prc: TRECT;
                            var pMargins: TRect): THandle cdecl stdcall;

  GetThemeIntList: function(hTheme: HTHEME;
                            iPartId: Integer;
                            iStateId: Integer;
                            iPropId: Integer;
                            var pIntList: Pointer): THandle cdecl stdcall;

  SetWindowTheme: function(hwnd: HWND;
                           var pszSubAppName: PWideChar;
                           var pszSubIdList: PWideChar): THandle cdecl stdcall;

  GetThemeFilename: function(hTheme: HTHEME;
                             iPartId: Integer;
                             iStateId: Integer;
                             iPropId: Integer;
                             pszThemeFileName: PWideChar;
                             cchMaxBuffChars: Integer): THandle cdecl stdcall;

  GetThemeSysColor: function(hTheme: HTHEME;
                      iColorId: Integer): Integer cdecl stdcall;

  GetThemeSysColorBrush: function(hTheme: HTHEME;
                      iColorId: Integer): Integer cdecl stdcall;

  GetThemeSysBool: function(hTheme: HTHEME;
                      iBoolId: Integer): Integer cdecl stdcall;

  GetThemeSysSize: function(hTheme: HTHEME;
                      iSizeId: Integer): Integer cdecl stdcall;

  GetThemeSysFont: function(hTheme: HTHEME;
                            iFontId: Integer;
                            var plf: TLOGFONT): THandle cdecl stdcall;

  GetThemeSysString: function(hTheme: HTHEME;
                              iStringId: Integer;
                              pszStringBuff: PWideChar;
                              cchMaxStringChars: Integer): THandle cdecl stdcall;

  GetThemeSysInt: function(hTheme: HTHEME;
                           iIntId: Integer;
                           var piValue: Integer): THandle cdecl stdcall;

  IsThemeActive: function: BOOL cdecl stdcall;

  IsAppThemed: function: BOOL cdecl stdcall;

  GetWindowTheme: function(hwnd: HWnd): Integer cdecl stdcall;

  EnableThemeDialogTexture: function(hwnd: HWND;
                                     dwFlags: LongInt): THandle cdecl stdcall;

  IsThemeDialogTextureEnabled: function(hwnd: HWnd): BOOL cdecl stdcall;

  GetThemeAppProperties: function: DWORD cdecl stdcall;

  SetThemeAppProperties: function(dwFlags: DWORD): Integer cdecl stdcall;

  GetCurrentThemeName: function(pszThemeFileName: PWideChar;
                                cchMaxNameChars: Integer;
                                pszColorBuff: PWideChar;
                                cchMaxColorChars: Integer;
                                pszSizeBuff: PWideChar;
                                cchMaxSizeChars: Integer): THandle cdecl stdcall;

  GetThemeDocumentationProperty: function(pszThemeName: PWideChar;
                                          var pszPropertyName: PWideChar;
                                          pszValueBuff: PWideChar;
                                          cchMaxValChars: Integer): THandle cdecl stdcall;

  DrawThemeParentBackground: function(hwnd: HWND;
                                      hdc: HDC;
                                      var prc: TRECT): THandle cdecl stdcall;

  EnableTheming: function(fEnable: Bool): THandle cdecl stdcall;

implementation

var
  DLLLoaded: Boolean = False;
  DLLHandle: THandle;

procedure UnLoadDLL;
begin
  if DLLLoaded then
    FreeLibrary(DLLHandle);
end;

procedure LoadDLL;
begin
  if DLLLoaded then Exit;
  
  DLLHandle := LoadLibrary('UXTHEME.DLL');
  if DLLHandle >= 32 then
  begin
    DLLLoaded := True;
    
    @OpenThemeData := GetProcAddress(DLLHandle,'OpenThemeData');
    Assert(@OpenThemeData <> nil);

    @CloseThemeData := GetProcAddress(DLLHandle,'CloseThemeData');
    Assert(@CloseThemeData <> nil);

    @DrawThemeBackground := GetProcAddress(DLLHandle,'DrawThemeBackground');
    Assert(@DrawThemeBackground <> nil);

    @DrawThemeText := GetProcAddress(DLLHandle,'DrawThemeText');
    Assert(@DrawThemeText <> nil);

    @GetThemeBackgroundContentRect := GetProcAddress(DLLHandle,'GetThemeBackgroundContentRect');
    Assert(@GetThemeBackgroundContentRect <> nil);

    @GetThemeBackgroundExtent := GetProcAddress(DLLHandle,'GetThemeBackgroundExtent');
    Assert(@GetThemeBackgroundExtent <> nil);

    @GetThemeTextExtent := GetProcAddress(DLLHandle,'GetThemeTextExtent');
    Assert(@GetThemeTextExtent <> nil);

    @GetThemeTextMetrics := GetProcAddress(DLLHandle,'GetThemeTextMetrics');
    Assert(@GetThemeTextMetrics <> nil);

    @GetThemeBackgroundRegion := GetProcAddress(DLLHandle,'GetThemeBackgroundRegion');
    Assert(@GetThemeBackgroundRegion <> nil);

    @HitTestThemeBackground := GetProcAddress(DLLHandle,'HitTestThemeBackground');
    Assert(@HitTestThemeBackground <> nil);

    @DrawThemeEdge := GetProcAddress(DLLHandle,'DrawThemeEdge');
    Assert(@DrawThemeEdge <> nil);

    @DrawThemeIcon := GetProcAddress(DLLHandle,'DrawThemeIcon');
    Assert(@DrawThemeIcon <> nil);

    @IsThemePartDefined := GetProcAddress(DLLHandle,'IsThemePartDefined');
    Assert(@IsThemePartDefined <> nil);

    @IsThemeBackGroundPartiallyTransparent := GetProcAddress(DLLHandle,'IsThemeBackgroundPartiallyTransparent');
    Assert(@IsThemeBackGroundPartiallyTransparent <> nil);

    @GetThemeColor := GetProcAddress(DLLHandle,'GetThemeColor');
    Assert(@GetThemeColor <> nil);

    @GetThemeMetric := GetProcAddress(DLLHandle,'GetThemeMetric');
    Assert(@GetThemeMetric <> nil);

    @GetThemeString := GetProcAddress(DLLHandle,'GetThemeString');
    Assert(@GetThemeString <> nil);

    @GetThemeBool := GetProcAddress(DLLHandle,'GetThemeBool');
    Assert(@GetThemeBool <> nil);

    @GetThemeInt := GetProcAddress(DLLHandle,'GetThemeInt');
    Assert(@GetThemeInt <> nil);

    @GetThemeEnumValue := GetProcAddress(DLLHandle,'GetThemeEnumValue');
    Assert(@GetThemeEnumValue <> nil);

    @GetThemePosition := GetProcAddress(DLLHandle,'GetThemePosition');
    Assert(@GetThemePosition <> nil);

    @GetThemeFont := GetProcAddress(DLLHandle,'GetThemeFont');
    Assert(@GetThemeFont <> nil);

    @GetThemeRect := GetProcAddress(DLLHandle,'GetThemeRect');
    Assert(@GetThemeRect <> nil);

    @GetThemeMargins := GetProcAddress(DLLHandle,'GetThemeMargins');
    Assert(@GetThemeMargins <> nil);

    @GetThemeIntList := GetProcAddress(DLLHandle,'GetThemeIntList');
    Assert(@GetThemeIntList <> nil);

    @SetWindowTheme := GetProcAddress(DLLHandle,'SetWindowTheme');
    Assert(@SetWindowTheme <> nil);

    @GetThemeFilename := GetProcAddress(DLLHandle,'GetThemeFilename');
    Assert(@GetThemeFilename <> nil);

    @GetThemeSysColor := GetProcAddress(DLLHandle,'GetThemeSysColor');
    Assert(@GetThemeSysColor <> nil);

    @GetThemeSysColorBrush := GetProcAddress(DLLHandle,'GetThemeSysColorBrush');
    Assert(@GetThemeSysColorBrush <> nil);

    @GetThemeSysBool := GetProcAddress(DLLHandle,'GetThemeSysBool');
    Assert(@GetThemeSysBool <> nil);

    @GetThemeSysSize := GetProcAddress(DLLHandle,'GetThemeSysSize');
    Assert(@GetThemeSysSize <> nil);

    @GetThemeSysFont := GetProcAddress(DLLHandle,'GetThemeSysFont');
    Assert(@GetThemeSysFont <> nil);

    @GetThemeSysString := GetProcAddress(DLLHandle,'GetThemeSysString');
    Assert(@GetThemeSysString <> nil);

    @GetThemeSysInt := GetProcAddress(DLLHandle,'GetThemeSysInt');
    Assert(@GetThemeSysInt <> nil);

    @IsThemeActive := GetProcAddress(DLLHandle,'IsThemeActive');
    Assert(@IsThemeActive <> nil);

    @IsAppThemed := GetProcAddress(DLLHandle,'IsAppThemed');
    Assert(@IsAppThemed <> nil);

    @GetWindowTheme := GetProcAddress(DLLHandle,'GetWindowTheme');
    Assert(@GetWindowTheme <> nil);

    @EnableThemeDialogTexture := GetProcAddress(DLLHandle,'EnableThemeDialogTexture');
    Assert(@EnableThemeDialogTexture <> nil);

    @IsThemeDialogTextureEnabled := GetProcAddress(DLLHandle,'IsThemeDialogTextureEnabled');
    Assert(@IsThemeDialogTextureEnabled <> nil);

    @GetThemeAppProperties := GetProcAddress(DLLHandle,'GetThemeAppProperties');
    Assert(@GetThemeAppProperties <> nil);

    @SetThemeAppProperties := GetProcAddress(DLLHandle,'SetThemeAppProperties');
    Assert(@SetThemeAppProperties <> nil);

    @GetCurrentThemeName := GetProcAddress(DLLHandle,'GetCurrentThemeName');
    Assert(@GetCurrentThemeName <> nil);

    @GetThemeDocumentationProperty := GetProcAddress(DLLHandle,'GetThemeDocumentationProperty');
    Assert(@GetThemeDocumentationProperty <> nil);

    @DrawThemeParentBackground := GetProcAddress(DLLHandle,'DrawThemeParentBackground');
    Assert(@DrawThemeParentBackground <> nil);

    @EnableTheming := GetProcAddress(DLLHandle,'EnableTheming');
    Assert(@EnableTheming <> nil);
  end
  else
  begin
    DLLLoaded := False;
    { Error: UXTHEME.DLL could not be loaded !! }
  end;

end;

initialization
  LoadDLL;
  
finalization
  UnLoadDLL;

end.
