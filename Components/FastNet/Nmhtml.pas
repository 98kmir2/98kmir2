unit NMHTML;
{wrapper and support classes for the NetManage/NetMasters HTML OCX}

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL, PSock, NMConst;

const

{ DocStateConstants }

  icDocNone = 0;
  icDocBegin = 1;
  icDocHeaders = 2;
  icDocData = 3;
  icDocError = 4;
  icDocEnd = 5;

const

{ Component class GUIDs }
  Class_DocHeaderCls: TGUID = '{B7FC3591-8CE7-11CF-9754-00AA00C00908}';
  Class_DocHeadersCls: TGUID = '{B7FC3593-8CE7-11CF-9754-00AA00C00908}';
  Class_DocInputCls: TGUID = '{B7FC3596-8CE7-11CF-9754-00AA00C00908}';
  Class_DocOutputCls: TGUID = '{B7FC3598-8CE7-11CF-9754-00AA00C00908}';
  Class_icErrorCls: TGUID = '{B7FC35A1-8CE7-11CF-9754-00AA00C00908}';
  Class_icErrorsCls: TGUID = '{B7FC35A3-8CE7-11CF-9754-00AA00C00908}';


const
  LIBID_HTMLObjects: TGUID = '{B7FC354D-8CE7-11CF-9754-00AA00C00908}';

{ Component class GUIDs }
  Class_HTMLElementCls: TGUID = '{B7FC3550-8CE7-11CF-9754-00AA00C00908}';
  Class_HTMLFormCls: TGUID = '{B7FC3554-8CE7-11CF-9754-00AA00C00908}';
  Class_HTMLFormsCls: TGUID = '{B7FC3557-8CE7-11CF-9754-00AA00C00908}';
  Class_HTMLAttrCls: TGUID = '{B7FC3559-8CE7-11CF-9754-00AA00C00908}';
  Class_HTMLAttrsCls: TGUID = '{B7FC355B-8CE7-11CF-9754-00AA00C00908}';
  Class_HTML: TGUID = '{B7FC355E-8CE7-11CF-9754-00AA00C00908}';

type

{ Forward declarations }
{ Forward declarations: Interfaces }
  DocHeader = interface;
  DocHeaderDisp = dispinterface;
  DocHeaders = interface;
  DocHeadersDisp = dispinterface;
  DocInput = interface;
  DocInputDisp = dispinterface;
  DocOutput = interface;
  DocOutputDisp = dispinterface;
  icError = interface;
  icErrorDisp = dispinterface;
  icErrors = interface;
  icErrorsDisp = dispinterface;

{ Forward declarations: CoClasses }
  DocHeaderCls = DocHeader;
  DocHeadersCls = DocHeaders;
  DocInputCls = DocInput;
  DocOutputCls = DocOutput;
  icErrorCls = icError;
  icErrorsCls = icErrors;

{ Forward declarations: Enums }
  DocStateConstants = TOleEnum;

  HTMLElement = interface;
  HTMLElementDisp = dispinterface;
  HTMLForm = interface;
  HTMLFormDisp = dispinterface;
  HTMLForms = interface;
  HTMLFormsDisp = dispinterface;
  HTMLAttr = interface;
  HTMLAttrDisp = dispinterface;
  HTMLAttrs = interface;
  HTMLAttrsDisp = dispinterface;
  IHTML = interface;
  IHTMLDisp = dispinterface;
  DHTMLEvents = dispinterface;

{ Forward declarations: CoClasses }
  HTMLElementCls = HTMLElement;
  HTMLFormCls = HTMLForm;
  HTMLFormsCls = HTMLForms;
  HTMLAttrCls = HTMLAttr;
  HTMLAttrsCls = HTMLAttrs;
  HTML = IHTML;

{ NetManage Internet Control }

  INMOleControl = interface(IDispatch)
    ['{B7FC35B6-8CE7-11CF-9754-00AA00C00908}']
    function Get_Blocking: WordBool; safecall;
    procedure Set_Blocking(Value: WordBool); safecall;
    function Get_SleepTime: Integer; safecall;
    procedure Set_SleepTime(Value: Integer); safecall;
    function Get_BlockResult: Smallint; safecall;
    procedure AboutBox; safecall;
    property Blocking: WordBool read Get_Blocking write Set_Blocking;
    property SleepTime: Integer read Get_SleepTime write Set_SleepTime;
    property BlockResult: Smallint read Get_BlockResult;
  end;

{ Internet DocHeader object properties and methods }

  DocHeader = interface(IDispatch)
    ['{B7FC3590-8CE7-11CF-9754-00AA00C00908}']
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_Value: WideString; safecall;
    procedure Set_Value(const Value: WideString); safecall;
    procedure SetThisObject(var ThisObject: SYSINT); safecall;
    property Name: WideString read Get_Name write Set_Name;
    property Value: WideString read Get_Value write Set_Value;
  end;

{ DispInterface declaration for Dual Interface DocHeader }

  DocHeaderDisp = dispinterface
    ['{B7FC3590-8CE7-11CF-9754-00AA00C00908}']
    property Name: WideString dispid 0;
    property Value: WideString dispid 2;
    procedure SetThisObject(var ThisObject: SYSINT); dispid 3;
  end;

{ Internet DocHeaders collection properties and methods }

  DocHeaders = interface(IDispatch)
    ['{B7FC3592-8CE7-11CF-9754-00AA00C00908}']
    function Get_Count: Integer; safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const Value: WideString); safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Item(Index: OleVariant): DocHeader; safecall;
    function Add(const Name, Value: WideString): DocHeader; safecall;
    procedure Remove(Index: OleVariant); safecall;
    procedure Clear; safecall;
    procedure SetThisObject(var ThisObject: SYSINT); safecall;
    property Count: Integer read Get_Count;
    property Text: WideString read Get_Text write Set_Text;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

{ DispInterface declaration for Dual Interface DocHeaders }

  DocHeadersDisp = dispinterface
    ['{B7FC3592-8CE7-11CF-9754-00AA00C00908}']
    property Count: Integer readonly dispid 1;
    property Text: WideString dispid 2;
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(Index: OleVariant): DocHeader; dispid 0;
    function Add(const Name, Value: WideString): DocHeader; dispid 4;
    procedure Remove(Index: OleVariant); dispid 5;
    procedure Clear; dispid 6;
    procedure SetThisObject(var ThisObject: SYSINT); dispid 7;
  end;

{ Internet DocInput object properties and methods }

  DocInput = interface(IDispatch)
    ['{B7FC3595-8CE7-11CF-9754-00AA00C00908}']
    function Get_Headers: DocHeaders; safecall;
    function Get_State: DocStateConstants; safecall;
    function Get_BytesTotal: Integer; safecall;
    function Get_BytesTransferred: Integer; safecall;
    function Get_FileName: WideString; safecall;
    procedure Set_FileName(const Value: WideString); safecall;
    function Get_DocLink: IUnknown; safecall;
    procedure Set_DocLink(Value: IUnknown); safecall;
    function Get_Suspended: WordBool; safecall;
    function Get_PushStreamMode: WordBool; safecall;
    procedure Set_PushStreamMode(Value: WordBool); safecall;
    procedure GetData(out Data: OleVariant; Type_: OleVariant); safecall;
    procedure SetData(Data: OleVariant); safecall;
    procedure Suspend(Suspend: WordBool); safecall;
    function Get_CPPObject: SYSINT; safecall;
    procedure Set_CPPObject(Value: SYSINT); safecall;
    procedure PushStream; safecall;
    function Get_Tag: OleVariant; safecall;
    procedure Set_Tag(Value: OleVariant); safecall;
    function Get_Errors: icErrors; safecall;
    function Get_URL: WideString; safecall;
    property Headers: DocHeaders read Get_Headers;
    property State: DocStateConstants read Get_State;
    property BytesTotal: Integer read Get_BytesTotal;
    property BytesTransferred: Integer read Get_BytesTransferred;
    property FileName: WideString read Get_FileName write Set_FileName;
    property DocLink: IUnknown read Get_DocLink write Set_DocLink;
    property Suspended: WordBool read Get_Suspended;
    property PushStreamMode: WordBool read Get_PushStreamMode write Set_PushStreamMode;
    property CPPObject: SYSINT read Get_CPPObject write Set_CPPObject;
    property Tag: OleVariant read Get_Tag write Set_Tag;
    property Errors: icErrors read Get_Errors;
    property URL: WideString read Get_URL;
  end;

{ DispInterface declaration for Dual Interface DocInput }

  DocInputDisp = dispinterface
    ['{B7FC3595-8CE7-11CF-9754-00AA00C00908}']
    property Headers: DocHeaders readonly dispid 2;
    property State: DocStateConstants readonly dispid 3;
    property BytesTotal: Integer readonly dispid 4;
    property BytesTransferred: Integer readonly dispid 5;
    property FileName: WideString dispid 6;
    property DocLink: IUnknown dispid 7;
    property Suspended: WordBool readonly dispid 11;
    property PushStreamMode: WordBool dispid 12;
    procedure GetData(out Data: OleVariant; Type_: OleVariant); dispid 9;
    procedure SetData(Data: OleVariant); dispid 8;
    procedure Suspend(Suspend: WordBool); dispid 10;
    property CPPObject: SYSINT dispid 14;
    procedure PushStream; dispid 13;
    property Tag: OleVariant dispid 16;
    property Errors: icErrors readonly dispid 17;
    property URL: WideString readonly dispid 1;
  end;

{ Internet DocOutput object properties and methods }

  DocOutput = interface(IDispatch)
    ['{B7FC3597-8CE7-11CF-9754-00AA00C00908}']
    function Get_Headers: DocHeaders; safecall;
    function Get_State: DocStateConstants; safecall;
    function Get_BytesTotal: Integer; safecall;
    function Get_BytesTransferred: Integer; safecall;
    function Get_FileName: WideString; safecall;
    procedure Set_FileName(const Value: WideString); safecall;
    function Get_DocLink: IUnknown; safecall;
    function Get_Suspended: WordBool; safecall;
    function Get_PushStreamMode: WordBool; safecall;
    function Get_DataString: WideString; safecall;
    function Get_DataBlock: OleVariant; safecall;
    procedure GetData(out Data: OleVariant; Type_: OleVariant); safecall;
    procedure SetData(Data: OleVariant); safecall;
    procedure Suspend(Suspend: WordBool); safecall;
    function Get_CPPObject: SYSINT; safecall;
    procedure Set_CPPObject(Value: SYSINT); safecall;
    function Get_AppendToFile: WordBool; safecall;
    procedure Set_AppendToFile(Value: WordBool); safecall;
    function Get_Tag: OleVariant; safecall;
    procedure Set_Tag(Value: OleVariant); safecall;
    function Get_Errors: icErrors; safecall;
    function Get_URL: WideString; safecall;
    property Headers: DocHeaders read Get_Headers;
    property State: DocStateConstants read Get_State;
    property BytesTotal: Integer read Get_BytesTotal;
    property BytesTransferred: Integer read Get_BytesTransferred;
    property FileName: WideString read Get_FileName write Set_FileName;
    property DocLink: IUnknown read Get_DocLink;
    property Suspended: WordBool read Get_Suspended;
    property PushStreamMode: WordBool read Get_PushStreamMode;
    property DataString: WideString read Get_DataString;
    property DataBlock: OleVariant read Get_DataBlock;
    property CPPObject: SYSINT read Get_CPPObject write Set_CPPObject;
    property AppendToFile: WordBool read Get_AppendToFile write Set_AppendToFile;
    property Tag: OleVariant read Get_Tag write Set_Tag;
    property Errors: icErrors read Get_Errors;
    property URL: WideString read Get_URL;
  end;

{ DispInterface declaration for Dual Interface DocOutput }

  DocOutputDisp = dispinterface
    ['{B7FC3597-8CE7-11CF-9754-00AA00C00908}']
    property Headers: DocHeaders readonly dispid 2;
    property State: DocStateConstants readonly dispid 3;
    property BytesTotal: Integer readonly dispid 4;
    property BytesTransferred: Integer readonly dispid 5;
    property FileName: WideString dispid 6;
    property DocLink: IUnknown readonly dispid 7;
    property Suspended: WordBool readonly dispid 11;
    property PushStreamMode: WordBool readonly dispid 12;
    property DataString: WideString readonly dispid 19;
    property DataBlock: OleVariant readonly dispid 18;
    procedure GetData(out Data: OleVariant; Type_: OleVariant); dispid 9;
    procedure SetData(Data: OleVariant); dispid 8;
    procedure Suspend(Suspend: WordBool); dispid 10;
    property CPPObject: SYSINT dispid 14;
    property AppendToFile: WordBool dispid 15;
    property Tag: OleVariant dispid 16;
    property Errors: icErrors readonly dispid 17;
    property URL: WideString readonly dispid 1;
  end;

{ Internet error object properties and methods }

  icError = interface(IDispatch)
    ['{B7FC35A0-8CE7-11CF-9754-00AA00C00908}']
    function Get_Type_: WideString; safecall;
    function Get_Code: Integer; safecall;
    function Get_Description: WideString; safecall;
    procedure SetThisObject(var ThisObject: SYSINT); safecall;
    procedure InitProperties(var ErrorType, ErrorDesc: WideString; var ErrorCode: Integer); safecall;
    property Type_: WideString read Get_Type_;
    property Code: Integer read Get_Code;
    property Description: WideString read Get_Description;
  end;

{ DispInterface declaration for Dual Interface icError }

  icErrorDisp = dispinterface
    ['{B7FC35A0-8CE7-11CF-9754-00AA00C00908}']
    property Type_: WideString readonly dispid 0;
    property Code: Integer readonly dispid 151;
    property Description: WideString readonly dispid 152;
    procedure SetThisObject(var ThisObject: SYSINT); dispid 154;
    procedure InitProperties(var ErrorType, ErrorDesc: WideString; var ErrorCode: Integer); dispid 155;
  end;

{ Internet errors collection properties and methods }

  icErrors = interface(IDispatch)
    ['{B7FC35A2-8CE7-11CF-9754-00AA00C00908}']
    function Get_Count: Integer; safecall;
    function Get_Source: OleVariant; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Item(Index: OleVariant): icError; safecall;
    procedure Clear; safecall;
    procedure SetItem(var ErrCode: Integer; var ErrType, ErrDesc: WideString); safecall;
    procedure SetThisObject(var ThisObject: SYSINT); safecall;
    procedure SetCollection(var initString: WideString); safecall;
    property Count: Integer read Get_Count;
    property Source: OleVariant read Get_Source;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

{ DispInterface declaration for Dual Interface icErrors }

  icErrorsDisp = dispinterface
    ['{B7FC35A2-8CE7-11CF-9754-00AA00C00908}']
    property Count: Integer readonly dispid 100;
    property Source: OleVariant readonly dispid 102;
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(Index: OleVariant): icError; dispid 0;
    procedure Clear; dispid 103;
    procedure SetItem(var ErrCode: Integer; var ErrType, ErrDesc: WideString); dispid 153;
    procedure SetThisObject(var ThisObject: SYSINT); dispid 104;
    procedure SetCollection(var initString: WideString); dispid 105;
  end;

{ Internet DocHeader object }

  CoDocHeaderCls = class
    class function Create: DocHeader;
    class function CreateRemote(const MachineName: string): DocHeader;
  end;

{ Internet DocHeaders object }

  CoDocHeadersCls = class
    class function Create: DocHeaders;
    class function CreateRemote(const MachineName: string): DocHeaders;
  end;

{ Internet DocInput object }

  CoDocInputCls = class
    class function Create: DocInput;
    class function CreateRemote(const MachineName: string): DocInput;
  end;

{ Internet DocOutput object }

  CoDocOutputCls = class
    class function Create: DocOutput;
    class function CreateRemote(const MachineName: string): DocOutput;
  end;

{ Internet error object }

  CoicErrorCls = class
    class function Create: icError;
    class function CreateRemote(const MachineName: string): icError;
  end;

{ Internet errors collection }

  CoicErrorsCls = class
    class function Create: icErrors;
    class function CreateRemote(const MachineName: string): icErrors;
  end;

{ HTML Element properties and methods }

  HTMLElement = interface(IDispatch)
    ['{B7FC354E-8CE7-11CF-9754-00AA00C00908}']
  end;

{ DispInterface declaration for Dual Interface HTMLElement }

  HTMLElementDisp = dispinterface
    ['{B7FC354E-8CE7-11CF-9754-00AA00C00908}']
  end;

{ HTML Form properties and methods }

  HTMLForm = interface(IDispatch)
    ['{B7FC3551-8CE7-11CF-9754-00AA00C00908}']
    function Get_Method: WideString; safecall;
    function Get_URL: WideString; safecall;
    function Get_URLEncodedBody: WideString; safecall;
    procedure RequestSubmit; safecall;
    function Get_CPPObject: SYSINT; safecall;
    procedure Set_CPPObject(Value: SYSINT); safecall;
    property Method: WideString read Get_Method;
    property URL: WideString read Get_URL;
    property URLEncodedBody: WideString read Get_URLEncodedBody;
    property CPPObject: SYSINT read Get_CPPObject write Set_CPPObject;
  end;

{ DispInterface declaration for Dual Interface HTMLForm }

  HTMLFormDisp = dispinterface
    ['{B7FC3551-8CE7-11CF-9754-00AA00C00908}']
    property Method: WideString readonly dispid 1;
    property URL: WideString readonly dispid 2;
    property URLEncodedBody: WideString readonly dispid 3;
    procedure RequestSubmit; dispid 4;
    property CPPObject: SYSINT dispid 100;
  end;

{ HTML Forms collection properties and methods }

  HTMLForms = interface(IDispatch)
    ['{B7FC3555-8CE7-11CF-9754-00AA00C00908}']
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Item(Index: OleVariant): HTMLForm; safecall;
    function Get_CPPObject: SYSINT; safecall;
    procedure Set_CPPObject(Value: SYSINT); safecall;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
    property CPPObject: SYSINT read Get_CPPObject write Set_CPPObject;
  end;

{ DispInterface declaration for Dual Interface HTMLForms }

  HTMLFormsDisp = dispinterface
    ['{B7FC3555-8CE7-11CF-9754-00AA00C00908}']
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(Index: OleVariant): HTMLForm; dispid 2;
    property CPPObject: SYSINT dispid 100;
  end;

{ HTML Attribute properties and methods }

  HTMLAttr = interface(IDispatch)
    ['{B7FC3558-8CE7-11CF-9754-00AA00C00908}']
    function Get_Name: WideString; safecall;
    function Get_Value: WideString; safecall;
    function Get_CPPObject: SYSINT; safecall;
    procedure Set_CPPObject(Value: SYSINT); safecall;
    property Name: WideString read Get_Name;
    property Value: WideString read Get_Value;
    property CPPObject: SYSINT read Get_CPPObject write Set_CPPObject;
  end;

{ DispInterface declaration for Dual Interface HTMLAttr }

  HTMLAttrDisp = dispinterface
    ['{B7FC3558-8CE7-11CF-9754-00AA00C00908}']
    property Name: WideString readonly dispid 1;
    property Value: WideString readonly dispid 2;
    property CPPObject: SYSINT dispid 100;
  end;

{ HTML Attributes collection properties and methods }

  HTMLAttrs = interface(IDispatch)
    ['{B7FC355A-8CE7-11CF-9754-00AA00C00908}']
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Item(Index: OleVariant): HTMLAttr; safecall;
    function Get_CPPObject: SYSINT; safecall;
    procedure Set_CPPObject(Value: SYSINT); safecall;
    procedure Set_InternalCount(Value: Integer); safecall;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
    property CPPObject: SYSINT read Get_CPPObject write Set_CPPObject;
    property InternalCount: Integer write Set_InternalCount;
  end;

{ DispInterface declaration for Dual Interface HTMLAttrs }

  HTMLAttrsDisp = dispinterface
    ['{B7FC355A-8CE7-11CF-9754-00AA00C00908}']
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(Index: OleVariant): HTMLAttr; dispid 2;
    property CPPObject: SYSINT dispid 100;
    property InternalCount: Integer writeonly dispid 3;
  end;

{ Properties/Methods for NetManage HTML Control }

  IHTML = interface(INMOleControl)
    ['{B7FC355C-8CE7-11CF-9754-00AA00C00908}']
    function Get_DocInput: DocInput; safecall;
    function Get_DocOutput: DocOutput; safecall;
    function Get_URL: WideString; safecall;
    function Get_RequestURL: WideString; safecall;
    function Get_BaseURL: WideString; safecall;
    function Get_Forms: HTMLForms; safecall;
    function Get_TotalWidth: Integer; safecall;
    function Get_TotalHeight: Integer; safecall;
    function Get_RetrieveBytesTotal: Integer; safecall;
    function Get_RetrieveBytesDone: Integer; safecall;
    function Get_ParseDone: WordBool; safecall;
    function Get_LayoutDone: WordBool; safecall;
    function Get_DeferRetrieval: WordBool; safecall;
    procedure Set_DeferRetrieval(Value: WordBool); safecall;
    function Get_ViewSource: WordBool; safecall;
    procedure Set_ViewSource(Value: WordBool); safecall;
    function Get_RetainSource: WordBool; safecall;
    procedure Set_RetainSource(Value: WordBool); safecall;
    function Get_SourceText: WideString; safecall;
    function Get_ElemNotification: WordBool; safecall;
    procedure Set_ElemNotification(Value: WordBool); safecall;
    function Get_Timeout: Integer; safecall;
    procedure Set_Timeout(Value: Integer); safecall;
    function Get_Redraw: WordBool; safecall;
    procedure Set_Redraw(Value: WordBool); safecall;
    function Get_UnderlineLinks: WordBool; safecall;
    procedure Set_UnderlineLinks(Value: WordBool); safecall;
    function Get_UseDocColors: WordBool; safecall;
    procedure Set_UseDocColors(Value: WordBool); safecall;
    function Get_BackImage: WideString; safecall;
    procedure Set_BackImage(const Value: WideString); safecall;
    function Get_BackColor: TColor; safecall;
    procedure Set_BackColor(Value: TColor); safecall;
    function Get_ForeColor: TColor; safecall;
    procedure Set_ForeColor(Value: TColor); safecall;
    function Get_LinkColor: TColor; safecall;
    procedure Set_LinkColor(Value: TColor); safecall;
    function Get_VisitedColor: TColor; safecall;
    procedure Set_VisitedColor(Value: TColor); safecall;
    function Get_DocBackColor: TColor; safecall;
    function Get_DocForeColor: TColor; safecall;
    function Get_DocLinkColor: TColor; safecall;
    function Get_DocVisitedColor: TColor; safecall;
    function Get_Font: IFontDisp; safecall;
    procedure Set_Font(const Value: IFontDisp); safecall;
    function Get_FixedFont: IFontDisp; safecall;
    procedure Set_FixedFont(const Value: IFontDisp); safecall;
    function Get_Heading1Font: IFontDisp; safecall;
    procedure Set_Heading1Font(const Value: IFontDisp); safecall;
    function Get_Heading2Font: IFontDisp; safecall;
    procedure Set_Heading2Font(const Value: IFontDisp); safecall;
    function Get_Heading3Font: IFontDisp; safecall;
    procedure Set_Heading3Font(const Value: IFontDisp); safecall;
    function Get_Heading4Font: IFontDisp; safecall;
    procedure Set_Heading4Font(const Value: IFontDisp); safecall;
    function Get_Heading5Font: IFontDisp; safecall;
    procedure Set_Heading5Font(const Value: IFontDisp); safecall;
    function Get_Heading6Font: IFontDisp; safecall;
    procedure Set_Heading6Font(const Value: IFontDisp); safecall;
    function Get_IsPrintingDone(PageNumber: Integer): WordBool; safecall;
    procedure RequestDoc(const URL: WideString); safecall;
    procedure RequestAllEmbedded; safecall;
    procedure Cancel(Message: OleVariant); safecall;
    procedure BeginPrinting(hDC: Integer; x, y, Width, Height, DefaultHeaders, DefaultTitle: OleVariant); safecall;
    procedure PrintPage(hDC, PageNumber: Integer); safecall;
    procedure EndPrinting; safecall;
    procedure AutoPrint(hDC: Integer); safecall;
    function Get_Errors: icErrors; safecall;
    function Get_hWnd: OLE_HANDLE; safecall;
    function GetPlainText(selected, fancy: WordBool): WideString; safecall;
    function HasSelection: WordBool; safecall;
    procedure SelectAll; safecall;
    property DocInput: DocInput read Get_DocInput;
    property DocOutput: DocOutput read Get_DocOutput;
    property URL: WideString read Get_URL;
    property RequestURL: WideString read Get_RequestURL;
    property BaseURL: WideString read Get_BaseURL;
    property Forms: HTMLForms read Get_Forms;
    property TotalWidth: Integer read Get_TotalWidth;
    property TotalHeight: Integer read Get_TotalHeight;
    property RetrieveBytesTotal: Integer read Get_RetrieveBytesTotal;
    property RetrieveBytesDone: Integer read Get_RetrieveBytesDone;
    property ParseDone: WordBool read Get_ParseDone;
    property LayoutDone: WordBool read Get_LayoutDone;
    property DeferRetrieval: WordBool read Get_DeferRetrieval write Set_DeferRetrieval;
    property ViewSource: WordBool read Get_ViewSource write Set_ViewSource;
    property RetainSource: WordBool read Get_RetainSource write Set_RetainSource;
    property SourceText: WideString read Get_SourceText;
    property ElemNotification: WordBool read Get_ElemNotification write Set_ElemNotification;
    property Timeout: Integer read Get_Timeout write Set_Timeout;
    property Redraw: WordBool read Get_Redraw write Set_Redraw;
    property UnderlineLinks: WordBool read Get_UnderlineLinks write Set_UnderlineLinks;
    property UseDocColors: WordBool read Get_UseDocColors write Set_UseDocColors;
    property BackImage: WideString read Get_BackImage write Set_BackImage;
    property BackColor: TColor read Get_BackColor write Set_BackColor;
    property ForeColor: TColor read Get_ForeColor write Set_ForeColor;
    property LinkColor: TColor read Get_LinkColor write Set_LinkColor;
    property VisitedColor: TColor read Get_VisitedColor write Set_VisitedColor;
    property DocBackColor: TColor read Get_DocBackColor;
    property DocForeColor: TColor read Get_DocForeColor;
    property DocLinkColor: TColor read Get_DocLinkColor;
    property DocVisitedColor: TColor read Get_DocVisitedColor;
    property Font: IFontDisp read Get_Font write Set_Font;
    property FixedFont: IFontDisp read Get_FixedFont write Set_FixedFont;
    property Heading1Font: IFontDisp read Get_Heading1Font write Set_Heading1Font;
    property Heading2Font: IFontDisp read Get_Heading2Font write Set_Heading2Font;
    property Heading3Font: IFontDisp read Get_Heading3Font write Set_Heading3Font;
    property Heading4Font: IFontDisp read Get_Heading4Font write Set_Heading4Font;
    property Heading5Font: IFontDisp read Get_Heading5Font write Set_Heading5Font;
    property Heading6Font: IFontDisp read Get_Heading6Font write Set_Heading6Font;
    property IsPrintingDone[PageNumber: Integer]: WordBool read Get_IsPrintingDone;
    property Errors: icErrors read Get_Errors;
    property hWnd: OLE_HANDLE read Get_hWnd;
  end;

{ DispInterface declaration for Dual Interface IHTML }

  IHTMLDisp = dispinterface
    ['{B7FC355C-8CE7-11CF-9754-00AA00C00908}']
    property DocInput: DocInput readonly dispid 1002;
    property DocOutput: DocOutput readonly dispid 1003;
    property URL: WideString readonly dispid 1001;
    property RequestURL: WideString readonly dispid 2;
    property BaseURL: WideString readonly dispid 3;
    property Forms: HTMLForms readonly dispid 4;
    property TotalWidth: Integer readonly dispid 5;
    property TotalHeight: Integer readonly dispid 6;
    property RetrieveBytesTotal: Integer readonly dispid 7;
    property RetrieveBytesDone: Integer readonly dispid 8;
    property ParseDone: WordBool readonly dispid 9;
    property LayoutDone: WordBool readonly dispid 10;
    property DeferRetrieval: WordBool dispid 11;
    property ViewSource: WordBool dispid 12;
    property RetainSource: WordBool dispid 13;
    property SourceText: WideString readonly dispid 14;
    property ElemNotification: WordBool dispid 15;
    property Timeout: Integer dispid 507;
    property Redraw: WordBool dispid 17;
    property UnderlineLinks: WordBool dispid 18;
    property UseDocColors: WordBool dispid 19;
    property BackImage: WideString dispid 20;
    property BackColor: TColor dispid -501;
    property ForeColor: TColor dispid -513;
    property LinkColor: TColor dispid 21;
    property VisitedColor: TColor dispid 22;
    property DocBackColor: TColor readonly dispid 23;
    property DocForeColor: TColor readonly dispid 24;
    property DocLinkColor: TColor readonly dispid 25;
    property DocVisitedColor: TColor readonly dispid 26;
    property Font: IFontDisp dispid -512;
    property FixedFont: IFontDisp dispid 27;
    property Heading1Font: IFontDisp dispid 28;
    property Heading2Font: IFontDisp dispid 29;
    property Heading3Font: IFontDisp dispid 30;
    property Heading4Font: IFontDisp dispid 31;
    property Heading5Font: IFontDisp dispid 32;
    property Heading6Font: IFontDisp dispid 33;
    property IsPrintingDone[PageNumber: Integer]: WordBool readonly dispid 39;
    procedure RequestDoc(const URL: WideString); dispid 34;
    procedure RequestAllEmbedded; dispid 35;
    procedure Cancel(Message: OleVariant); dispid 520;
    procedure BeginPrinting(hDC: Integer; x, y, Width, Height, DefaultHeaders, DefaultTitle: OleVariant); dispid 36;
    procedure PrintPage(hDC, PageNumber: Integer); dispid 37;
    procedure EndPrinting; dispid 38;
    procedure AutoPrint(hDC: Integer); dispid 50;
    property Errors: icErrors readonly dispid 508;
    property hWnd: Integer{OLE_HANDLE} readonly dispid -515;  //!!
    function GetPlainText(selected, fancy: WordBool): WideString; dispid 41;
    function HasSelection: WordBool; dispid 42;
    procedure SelectAll; dispid 43;
  end;

{ HTML Control events }

  DHTMLEvents = dispinterface
    ['{B7FC355D-8CE7-11CF-9754-00AA00C00908}']
    procedure Error(Number: Smallint; var Description: WideString; Scode: Integer; const Source, HelpFile: WideString; HelpContext: Integer; var CancelDisplay: WordBool); dispid -608;
    procedure DocInput(const DocInput: DocInput); dispid 1016;
    procedure DocOutput(const DocOutput: DocOutput); dispid 1017;
    procedure ParseComplete; dispid 1;
    procedure LayoutComplete; dispid 2;
    procedure Timeout; dispid 551;
    procedure BeginRetrieval; dispid 4;
    procedure UpdateRetrieval; dispid 5;
    procedure EndRetrieval; dispid 6;
    procedure DoRequestDoc(const URL: WideString; const Element: HTMLElement; const DocInput: DocInput; var EnableDefault: WordBool); dispid 7;
    procedure DoRequestEmbedded(const URL: WideString; const Element: HTMLElement; const DocInput: DocInput; var EnableDefault: WordBool); dispid 8;
    procedure DoRequestSubmit(const URL: WideString; const Form: HTMLForm; const DocOutput: DocOutput; var EnableDefault: WordBool); dispid 9;
    procedure DoNewElement(const ElemType: WideString; EndTag: WordBool; const Attrs: HTMLAttrs; const text: WideString; var EnableDefault: WordBool); dispid 10;
    procedure KeyPress(KeyAscii: Smallint); dispid -603;
    procedure KeyDown(KeyCode, Shift: Smallint); dispid -602;
    procedure KeyUp(KeyCode, Shift: Smallint); dispid -604;
    procedure Click; dispid -600;
    procedure DblClick; dispid -601;
    procedure MouseDown(Button, Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -605;
    procedure MouseMove(Button, Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -606;
    procedure MouseUp(Button, Shift: Smallint; x: OLE_XPOS_PIXELS; y: OLE_YPOS_PIXELS); dispid -607;
  end;

{ HTML Element }

  CoHTMLElementCls = class
    class function Create: HTMLElement;
    class function CreateRemote(const MachineName: string): HTMLElement;
  end;

{ HTML Form object }

  CoHTMLFormCls = class
    class function Create: HTMLForm;
    class function CreateRemote(const MachineName: string): HTMLForm;
  end;

{ HTML Forms collection }

  CoHTMLFormsCls = class
    class function Create: HTMLForms;
    class function CreateRemote(const MachineName: string): HTMLForms;
  end;

{ HTML Attribute object }

  CoHTMLAttrCls = class
    class function Create: HTMLAttr;
    class function CreateRemote(const MachineName: string): HTMLAttr;
  end;

{ HTML Attributes collection }

  CoHTMLAttrsCls = class
    class function Create: HTMLAttrs;
    class function CreateRemote(const MachineName: string): HTMLAttrs;
  end;

{ NetManage HTML Client Control }

  THTMLError = procedure(Sender: TObject; Number: Smallint; var Description: WideString; Scode: Integer; const Source, HelpFile: WideString; HelpContext: Integer; var CancelDisplay: WordBool) of object;
  //!CH Removed const to workaround BCB-9893 (PS and TH investigating proper method to handle this)
  THTMLDocInput = procedure(Sender: TObject; {const} DocInput: DocInput) of object;
  THTMLDocOutput = procedure(Sender: TObject; {const} DocOutput: DocOutput) of object;
  THTMLDoRequestDoc = procedure(Sender: TObject; const URL: WideString; {const} Element: HTMLElement; {const} DocInput: DocInput; var EnableDefault: WordBool) of object;
  THTMLDoRequestEmbedded = procedure(Sender: TObject; const URL: WideString; {const} Element: HTMLElement; {const} DocInput: DocInput; var EnableDefault: WordBool) of object;
  THTMLDoRequestSubmit = procedure(Sender: TObject; const URL: WideString; {const} Form: HTMLForm; {const} DocOutput: DocOutput; var EnableDefault: WordBool) of object;
  THTMLDoNewElement = procedure(Sender: TObject; const ElemType: WideString; EndTag: WordBool; {const} Attrs: HTMLAttrs; const text: WideString; var EnableDefault: WordBool) of object;

  THTML = class(TOleControl)
  private
    FOnError: THTMLError;
    FOnDocInput: THTMLDocInput;
    FOnDocOutput: THTMLDocOutput;
    FOnParseComplete: TNotifyEvent;
    FOnLayoutComplete: TNotifyEvent;
    FOnTimeout: TNotifyEvent;
    FOnBeginRetrieval: TNotifyEvent;
    FOnUpdateRetrieval: TNotifyEvent;
    FOnEndRetrieval: TNotifyEvent;
    FOnDoRequestDoc: THTMLDoRequestDoc;
    FOnDoRequestEmbedded: THTMLDoRequestEmbedded;
    FOnDoRequestSubmit: THTMLDoRequestSubmit;
    FOnDoNewElement: THTMLDoNewElement;
    FIntf: IHTML;
    function Get_DocInput: DocInput;
    function Get_DocOutput: DocOutput;
    function Get_Forms: HTMLForms;
    function Get_IsPrintingDone(PageNumber: Integer): WordBool;
    function Get_Errors: icErrors;
    function Get_hWnd: OLE_HANDLE;
  protected
    procedure InitControlData; override;
    procedure InitControlInterface(const Obj: IUnknown); override;
  public
    procedure AboutBox;
    procedure RequestDoc(const URL: WideString);
    procedure RequestAllEmbedded;
    procedure Cancel(Message: OleVariant);
    procedure BeginPrinting(hDC: Integer; x, y, Width, Height, DefaultHeaders, DefaultTitle: OleVariant);
    procedure PrintPage(hDC, PageNumber: Integer);
    procedure EndPrinting;
    procedure AutoPrint(hDC: Integer);
    function GetPlainText(selected, fancy: WordBool): WideString;
    function HasSelection: WordBool;
    procedure SelectAll;
    property ControlInterface: IHTML read FIntf;
    property BlockResult: Smallint index 519 read GetSmallintProp;
    property DocInput: DocInput read Get_DocInput;
    property DocOutput: DocOutput read Get_DocOutput;
    property URL: WideString index 1001 read GetWideStringProp;
    property RequestURL: WideString index 2 read GetWideStringProp;
    property BaseURL: WideString index 3 read GetWideStringProp;
    property Forms: HTMLForms read Get_Forms;
    property TotalWidth: Integer index 5 read GetIntegerProp;
    property TotalHeight: Integer index 6 read GetIntegerProp;
    property RetrieveBytesTotal: Integer index 7 read GetIntegerProp;
    property RetrieveBytesDone: Integer index 8 read GetIntegerProp;
    property ParseDone: WordBool index 9 read GetWordBoolProp;
    property LayoutDone: WordBool index 10 read GetWordBoolProp;
    property SourceText: WideString index 14 read GetWideStringProp;
    property DocBackColor: TColor index 23 read GetTColorProp;
    property DocForeColor: TColor index 24 read GetTColorProp;
    property DocLinkColor: TColor index 25 read GetTColorProp;
    property DocVisitedColor: TColor index 26 read GetTColorProp;
    property IsPrintingDone[PageNumber: Integer]: WordBool read Get_IsPrintingDone;
    property Errors: icErrors read Get_Errors;
    property hWnd: OLE_HANDLE read Get_hWnd;
  published
    property ParentColor;
    property ParentFont;
    property TabStop;
    property Align;
    property DragCursor;
    property DragMode;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property Visible;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDrag;
    property OnMouseUp;
    property OnMouseMove;
    property OnMouseDown;
    property OnKeyUp;
    property OnKeyPress;
    property OnKeyDown;
    property OnDblClick;
    property OnClick;
    property Blocking: WordBool index 515 read GetWordBoolProp write SetWordBoolProp stored False;
    property SleepTime: Integer index 516 read GetIntegerProp write SetIntegerProp stored False;
    property DeferRetrieval: WordBool index 11 read GetWordBoolProp write SetWordBoolProp stored False;
    property ViewSource: WordBool index 12 read GetWordBoolProp write SetWordBoolProp stored False;
    property RetainSource: WordBool index 13 read GetWordBoolProp write SetWordBoolProp stored False;
    property ElemNotification: WordBool index 15 read GetWordBoolProp write SetWordBoolProp stored False;
    property Timeout: Integer index 507 read GetIntegerProp write SetIntegerProp stored False;
    property Redraw: WordBool index 17 read GetWordBoolProp write SetWordBoolProp stored False;
    property UnderlineLinks: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property UseDocColors: WordBool index 19 read GetWordBoolProp write SetWordBoolProp stored False;
    property BackImage: WideString index 20 read GetWideStringProp write SetWideStringProp stored False;
    property BackColor: TColor index -501 read GetTColorProp write SetTColorProp stored False;
    property ForeColor: TColor index -513 read GetTColorProp write SetTColorProp stored False;
    property LinkColor: TColor index 21 read GetTColorProp write SetTColorProp stored False;
    property VisitedColor: TColor index 22 read GetTColorProp write SetTColorProp stored False;
    property Font: TFont index -512 read GetTFontProp write SetTFontProp stored False;
    property FixedFont: TFont index 27 read GetTFontProp write SetTFontProp stored False;
    property Heading1Font: TFont index 28 read GetTFontProp write SetTFontProp stored False;
    property Heading2Font: TFont index 29 read GetTFontProp write SetTFontProp stored False;
    property Heading3Font: TFont index 30 read GetTFontProp write SetTFontProp stored False;
    property Heading4Font: TFont index 31 read GetTFontProp write SetTFontProp stored False;
    property Heading5Font: TFont index 32 read GetTFontProp write SetTFontProp stored False;
    property Heading6Font: TFont index 33 read GetTFontProp write SetTFontProp stored False;
    property OnError: THTMLError read FOnError write FOnError;
    property OnDocInput: THTMLDocInput read FOnDocInput write FOnDocInput;
    property OnDocOutput: THTMLDocOutput read FOnDocOutput write FOnDocOutput;
    property OnParseComplete: TNotifyEvent read FOnParseComplete write FOnParseComplete;
    property OnLayoutComplete: TNotifyEvent read FOnLayoutComplete write FOnLayoutComplete;
    property OnTimeout: TNotifyEvent read FOnTimeout write FOnTimeout;
    property OnBeginRetrieval: TNotifyEvent read FOnBeginRetrieval write FOnBeginRetrieval;
    property OnUpdateRetrieval: TNotifyEvent read FOnUpdateRetrieval write FOnUpdateRetrieval;
    property OnEndRetrieval: TNotifyEvent read FOnEndRetrieval write FOnEndRetrieval;
    property OnDoRequestDoc: THTMLDoRequestDoc read FOnDoRequestDoc write FOnDoRequestDoc;
    property OnDoRequestEmbedded: THTMLDoRequestEmbedded read FOnDoRequestEmbedded write FOnDoRequestEmbedded;
    property OnDoRequestSubmit: THTMLDoRequestSubmit read FOnDoRequestSubmit write FOnDoRequestSubmit;
    property OnDoNewElement: THTMLDoNewElement read FOnDoNewElement write FOnDoNewElement;
  end;

procedure Register;

implementation

uses ComObj;

class function CoDocHeaderCls.Create: DocHeader;
begin
  Result := CreateComObject(Class_DocHeaderCls) as DocHeader;
end;

class function CoDocHeaderCls.CreateRemote(const MachineName: string): DocHeader;
begin
  Result := CreateRemoteComObject(MachineName, Class_DocHeaderCls) as DocHeader;
end;

class function CoDocHeadersCls.Create: DocHeaders;
begin
  Result := CreateComObject(Class_DocHeadersCls) as DocHeaders;
end;

class function CoDocHeadersCls.CreateRemote(const MachineName: string): DocHeaders;
begin
  Result := CreateRemoteComObject(MachineName, Class_DocHeadersCls) as DocHeaders;
end;

class function CoDocInputCls.Create: DocInput;
begin
  Result := CreateComObject(Class_DocInputCls) as DocInput;
end;

class function CoDocInputCls.CreateRemote(const MachineName: string): DocInput;
begin
  Result := CreateRemoteComObject(MachineName, Class_DocInputCls) as DocInput;
end;

class function CoDocOutputCls.Create: DocOutput;
begin
  Result := CreateComObject(Class_DocOutputCls) as DocOutput;
end;

class function CoDocOutputCls.CreateRemote(const MachineName: string): DocOutput;
begin
  Result := CreateRemoteComObject(MachineName, Class_DocOutputCls) as DocOutput;
end;

class function CoicErrorCls.Create: icError;
begin
  Result := CreateComObject(Class_icErrorCls) as icError;
end;

class function CoicErrorCls.CreateRemote(const MachineName: string): icError;
begin
  Result := CreateRemoteComObject(MachineName, Class_icErrorCls) as icError;
end;

class function CoicErrorsCls.Create: icErrors;
begin
  Result := CreateComObject(Class_icErrorsCls) as icErrors;
end;

class function CoicErrorsCls.CreateRemote(const MachineName: string): icErrors;
begin
  Result := CreateRemoteComObject(MachineName, Class_icErrorsCls) as icErrors;
end;


class function CoHTMLElementCls.Create: HTMLElement;
begin
  Result := CreateComObject(Class_HTMLElementCls) as HTMLElement;
end;

class function CoHTMLElementCls.CreateRemote(const MachineName: string): HTMLElement;
begin
  Result := CreateRemoteComObject(MachineName, Class_HTMLElementCls) as HTMLElement;
end;

class function CoHTMLFormCls.Create: HTMLForm;
begin
  Result := CreateComObject(Class_HTMLFormCls) as HTMLForm;
end;

class function CoHTMLFormCls.CreateRemote(const MachineName: string): HTMLForm;
begin
  Result := CreateRemoteComObject(MachineName, Class_HTMLFormCls) as HTMLForm;
end;

class function CoHTMLFormsCls.Create: HTMLForms;
begin
  Result := CreateComObject(Class_HTMLFormsCls) as HTMLForms;
end;

class function CoHTMLFormsCls.CreateRemote(const MachineName: string): HTMLForms;
begin
  Result := CreateRemoteComObject(MachineName, Class_HTMLFormsCls) as HTMLForms;
end;

class function CoHTMLAttrCls.Create: HTMLAttr;
begin
  Result := CreateComObject(Class_HTMLAttrCls) as HTMLAttr;
end;

class function CoHTMLAttrCls.CreateRemote(const MachineName: string): HTMLAttr;
begin
  Result := CreateRemoteComObject(MachineName, Class_HTMLAttrCls) as HTMLAttr;
end;

class function CoHTMLAttrsCls.Create: HTMLAttrs;
begin
  Result := CreateComObject(Class_HTMLAttrsCls) as HTMLAttrs;
end;

class function CoHTMLAttrsCls.CreateRemote(const MachineName: string): HTMLAttrs;
begin
  Result := CreateRemoteComObject(MachineName, Class_HTMLAttrsCls) as HTMLAttrs;
end;

procedure THTML.InitControlData;
const
  CEventDispIDs: array[0..12] of DWORD = (
    $FFFFFDA0, $000003F8, $000003F9, $00000001, $00000002, $00000227,
    $00000004, $00000005, $00000006, $00000007, $00000008, $00000009,
    $0000000A);
  CLicenseKey: array[0..36] of Word = (
    $0036, $0036, $0061, $0062, $0037, $0030, $0064, $0030, $002D, $0035,
    $0035, $0064, $0033, $002D, $0031, $0031, $0063, $0066, $002D, $0038,
    $0030, $0034, $0063, $002D, $0030, $0030, $0061, $0030, $0032, $0034,
    $0032, $0034, $0065, $0039, $0032, $0037, $0000);
  CTFontIDs: array [0..7] of DWORD = (
    $FFFFFE00, $0000001B, $0000001C, $0000001D, $0000001E, $0000001F,
    $00000020, $00000021);
  CControlData: TControlData = (
    ClassID: '{B7FC355E-8CE7-11CF-9754-00AA00C00908}';
    EventIID: '{B7FC355D-8CE7-11CF-9754-00AA00C00908}';
    EventCount: 13;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: @CLicenseKey;
    Flags: $00000007;
    Version: 300;
    FontCount: 8;
    FontIDs: @CTFontIDs);
begin
  ControlData := @CControlData;
end;

procedure THTML.InitControlInterface(const Obj: IUnknown);
begin
  FIntf := Obj as IHTML;
end;

procedure THTML.AboutBox;
begin
  ControlInterface.AboutBox;
end;

procedure THTML.RequestDoc(const URL: WideString);
begin
  ControlInterface.RequestDoc(URL);
end;

procedure THTML.RequestAllEmbedded;
begin
  ControlInterface.RequestAllEmbedded;
end;

procedure THTML.Cancel(Message: OleVariant);
begin
  ControlInterface.Cancel(Message);
end;

procedure THTML.BeginPrinting(hDC: Integer; x, y, Width, Height, DefaultHeaders, DefaultTitle: OleVariant);
begin
  ControlInterface.BeginPrinting(hDC, x, y, Width, Height, DefaultHeaders, DefaultTitle);
end;

procedure THTML.PrintPage(hDC, PageNumber: Integer);
begin
  ControlInterface.PrintPage(hDC, PageNumber);
end;

procedure THTML.EndPrinting;
begin
  ControlInterface.EndPrinting;
end;

procedure THTML.AutoPrint(hDC: Integer);
begin
  ControlInterface.AutoPrint(hDC);
end;

function THTML.GetPlainText(selected, fancy: WordBool): WideString;
begin
  Result := ControlInterface.GetPlainText(selected, fancy);
end;

function THTML.HasSelection: WordBool;
begin
  Result := ControlInterface.HasSelection;
end;

procedure THTML.SelectAll;
begin
  ControlInterface.SelectAll;
end;

function THTML.Get_DocInput: DocInput;
begin
  Result := ControlInterface.DocInput;
end;

function THTML.Get_DocOutput: DocOutput;
begin
  Result := ControlInterface.DocOutput;
end;

function THTML.Get_Forms: HTMLForms;
begin
  Result := ControlInterface.Forms;
end;

function THTML.Get_IsPrintingDone(PageNumber: Integer): WordBool;
begin
  Result := ControlInterface.IsPrintingDone[PageNumber];
end;

function THTML.Get_Errors: icErrors;
begin
  Result := ControlInterface.Errors;
end;

function THTML.Get_hWnd: OLE_HANDLE;
begin
  Result := ControlInterface.hWnd;
end;

procedure Register;
begin
  //RegisterComponents(Cons_Palette_Inet, [THTML]);
end;


end.
