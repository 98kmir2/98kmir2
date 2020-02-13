{***************************************************************************}
{ TAdvStringGrid unicode editor component                                   }
{ for Delphi & C++Builder                                                   }
{ version 2.4.0.0 - rel. Oct 2002                                           }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 1996-2002                                          }
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

unit AsgUni;

interface

{$WARNINGS OFF}

uses
  Windows, Messages, Classes, Controls, StdCtrls, Graphics, ADVXPVS;


type

  TCustomUNIEdit = class(TCustomEdit)
  private
    function GetSelText: WideString; reintroduce;
    procedure SetSelText(const Value: WideString);
    function GetText: WideString;
    procedure SetText(const Value: WideString);
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent);override;
    property SelText: WideString read GetSelText write SetSelText;
    property Text: WideString read GetText write SetText;
  end;


  TAsgUniEdit = class(TCustomUNIEdit)
  published
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TAnsiStrings = TStrings;

  TWideStrings = class(TPersistent)
  private
    FAnsiStrings: TAnsiStrings;
    FUpdateCount: integer;
    FLanguage: LCID;
    FSaved,
    FSaveUnicode: boolean;
    function GetCommaText: WideString;
    function GetName(Index: integer): WideString;
    function GetValue(const Name: WideString): WideString;
    procedure ReadData(Reader: TReader);
    procedure SetCommaText(const Value: WideString);
    procedure SetValue(const Name, Value: WideString);
    procedure WriteData(Writer: TWriter);
    procedure SetAnsiStrings(const Value: TAnsiStrings);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Error(const Msg: WideString; Data: integer);
    function Get(Index: integer): WideString; virtual; abstract;
    function GetCapacity: integer; virtual;
    function GetCount: integer; virtual; abstract;
    function GetObject(Index: integer): TObject; virtual;
    function GetTextStr: WideString; virtual;
    procedure Put(Index: integer; const S: WideString); virtual;
    procedure PutObject(Index: integer; AObject: TObject); virtual;
    procedure SetCapacity(NewCapacity: integer); virtual;
    procedure SetTextStr(const Value: WideString); virtual;
    procedure SetUpdateState(Updating: boolean); virtual;
    procedure SetLanguage(Value: LCID); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const S: WideString): integer; virtual;
    function AddObject(const S: WideString; AObject: TObject): integer; virtual;
    procedure Append(const S: WideString);
    procedure AddStrings(Strings: TAnsiStrings); overload; virtual;
    procedure AddStrings(Strings: TWideStrings); overload; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure BeginUpdate;
    procedure Clear; virtual; abstract;
    procedure Delete(Index: integer); virtual; abstract;
    procedure EndUpdate;
    function Equals(Strings: TWideStrings): boolean;
    procedure Exchange(Index1, Index2: integer); virtual;
    function GetText: PWideChar; virtual;
    function IndexOf(const S: WideString): integer; virtual;
    function IndexOfName(const Name: WideString): integer;
    function IndexOfObject(AObject: TObject): integer;
    procedure Insert(Index: integer; const S: WideString); virtual; abstract;
    procedure InsertObject(Index: integer; const S: WideString; AObject: TObject);
    procedure Move(CurIndex, NewIndex: integer); virtual;
    procedure SetText(Text: PWideChar); virtual;

    property Capacity: integer read GetCapacity write SetCapacity;
    property CommaText: WideString read GetCommaText write SetCommaText;
    property Count: integer read GetCount;
    property Language: LCID read FLanguage write SetLanguage;
    property Names[Index: integer]: WideString read GetName;
    property Objects[Index: integer]: TObject read GetObject write PutObject;
    property Values[const Name: WideString]: WideString read GetValue write SetValue;
    property Saved: boolean read FSaved;
    property SaveUnicode: boolean read FSaveUnicode write FSaveUnicode;
    property Strings[Index: integer]: WideString read Get write Put; default;
    property Text: WideString read GetTextStr write SetTextStr;

  published
    property AnsiStrings: TAnsiStrings read FAnsiStrings write SetAnsiStrings stored False;
  end;

  TCustomUNIComboBox = class(TCustomComboBox)
  private
    FItems: TWideStrings;
    function GetItems: TWideStrings;
    procedure SetItems(const Value: TWideStrings); reintroduce;
    function GetSelText: WideString;
    procedure SetSelText(const Value: WideString);
    function GetText: WideString;
    procedure SetText(const Value: WideString);

    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  protected
    procedure DoEditCharMsg(var Message: TWMChar); virtual;
    procedure CreateWnd; override;
    procedure ComboWndProc(var Message: TMessage; ComboWnd: HWnd;
      ComboProc: Pointer); override;
    procedure KeyPress(var Key: char); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
  public
    property SelText: WideString read GetSelText write SetSelText;
    property Text: WideString read GetText write SetText;
    property Items: TWideStrings read GetItems write SetItems;
  end;

  {
  TAsgUNIComboBox = class(TCustomUNIComboBox)
  published
    property Style;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDock;
    property OnStartDrag;
    property Items;
  end;
  }

  TASGUniCustomCombo = class(TCustomUniComboBox)
  private
    FAutoFocus: boolean;
    FFlat: Boolean;
    FEtched: Boolean;
    FOldColor: TColor;
    FOldParentColor: Boolean;
    FButtonWidth: Integer;
    FFocusBorder: Boolean;
    FMouseInControl: Boolean;
    FDropWidth: integer;
    FIsWinXP: Boolean;
    procedure SetEtched(const Value: Boolean);
    procedure SetFlat(const Value: Boolean);
    procedure SetButtonWidth(const Value: Integer);
    procedure DrawButtonBorder(DC:HDC);
    procedure DrawControlBorder(DC:HDC);
    procedure DrawBorders;
    function  Is3DBorderControl: Boolean;
    function  Is3DBorderButton: Boolean;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CNCommand (var Message: TWMCommand); message CN_COMMAND;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
    procedure SetDropWidth(const Value: integer);
  protected
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth;
    property Flat: Boolean read FFlat write SetFlat;
    property Etched: Boolean read FEtched write SetEtched;
    property FocusBorder: Boolean read FFocusBorder write FFocusBorder;
    property AutoFocus: Boolean read FAutoFocus write FAutoFocus;
    property DropWidth: integer read fDropWidth write SetDropWidth;
  public
    property IsWinXP: Boolean read FIsWinXP write FIsWinXP;
    constructor Create(AOwner: TComponent); override;
  end;

  TASGUniComboBox = class(TASGUniCustomCombo)
  published
    property AutoFocus;
    property ButtonWidth;
    property Style;
    property Flat;
    property Etched;
    property FocusBorder;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property DropWidth;
    property Enabled;
    property Font;
    {$IFNDEF DELPHI2_LVL}
    property ImeMode;
    property ImeName;
    {$ENDIF}
    property ItemHeight;
    property Items;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
    {$IFDEF DELPHI4_LVL}
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF}
  end;




implementation

uses
  Forms, SysUtils, Consts, Imm;

const
  UNICODE_CLASS_EXT = '.UnicodeClass';
  ANSI_UNICODE_HOLDER = $FF;
  
  WideNull = widechar(#0);
  Tabulator = widechar(#9);
  Space = widechar(#32);
  LF = widechar($A);
  LineFeed = widechar($A);
  VerticalTab = widechar($B);
  FormFeed = widechar($C);
  CR = widechar($D);
  CarriageReturn = widechar($D);
  CRLF: WideString = #$D#$A;
  LineSeparator = widechar($2028);
  ParagraphSeparator = widechar($2029);

type
  TComboBoxStrings = class(TWideStrings)
  protected
    function Get(Index: integer): WideString; override;
    function GetCount: integer; override;
    function GetObject(Index: integer): TObject; override;
{$IFDEF JCL}
    procedure Put(Index: integer; const S: WideString); override;
{$ENDIF}
    procedure PutObject(Index: integer; AObject: TObject); override;
    procedure SetUpdateState(Updating: boolean); override;
  public
    ComboBox: TCustomComboBox; {TCustomComboBox}
    function Add(const S: WideString): integer; override;
    procedure Clear; override;
    procedure Delete(Index: integer); override;
    function IndexOf(const S: WideString): integer; override;
    procedure Insert(Index: integer; const S: WideString); override;
  end;


  TAnsiStringsForWideStrings = class(TAnsiStrings)
  private
    FWideStrings: TWideStrings;
  protected
    function Get(Index: integer): AnsiString; override;
    function GetCount: integer; override;
  public
    procedure Clear; override;
    procedure Delete(Index: integer); override;
    procedure Insert(Index: integer; const S: AnsiString); override;
  end;

  TWinControlTrap = class
  private
    ObjectInstance: Pointer;
    DefObjectInstance: Pointer;
    FControl: TWinControl;
    Handle: THandle;
    PrevWin32Proc: Pointer;
    PrevDefWin32Proc: Pointer;
    PrevWindowProc: TWndMethod;
    LastWin32Msg: UINT;
    procedure Win32Proc(var Message: TMessage);
    procedure DefWin32Proc(var Message: TMessage);
    procedure WindowProc(var Message: TMessage);
    procedure HandleWMDestroy(var Message: TMessage);
  end;
  TAccessWinControl = class(TWinControl);
  TWideCaptionHolder = class(TComponent)
  private
    WideCaption: WideString;
  end;
  TCompareFunc = function(W1, W2: WideString; Locale: LCID): integer;

var
  WinControlTrap_Atom: TAtom = 0;
  WideCompareText: TCompareFunc;


{ TAnsiStringsForWideStrings }

procedure TAnsiStringsForWideStrings.Clear;
begin
  FWideStrings.Clear;
end;

procedure TAnsiStringsForWideStrings.Delete(Index: integer);
begin
  FWideStrings.Delete(Index);
end;

function TAnsiStringsForWideStrings.Get(Index: integer): AnsiString;
begin
  Result := FWideStrings.Get(Index);
end;

function TAnsiStringsForWideStrings.GetCount: integer;
begin
  Result := FWideStrings.Count;
end;

procedure TAnsiStringsForWideStrings.Insert(Index: integer; const S: AnsiString);
begin
  FWideStrings.Insert(Index, S);
end;


{ General Fuctions And Procedures}

procedure WideSetWindowText(Control: TWinControl; const Text: WideString); forward;
function WideGetWindowText(Control: TWinControl): WideString; forward;
procedure DestroyUnicodeHandle(Control: TWinControl); forward;

function Is_IntResource(ResStr: LPCWSTR): boolean;
begin
  Result := HiWord(cardinal(ResStr)) = 0;
end;

function IsTextMessage(Msg: UINT): boolean;
begin
  // WM_CHAR is omitted because of the special handling it receives
  Result := (Msg = WM_SETTEXT) or (Msg = WM_GETTEXT) or (Msg = WM_GETTEXTLENGTH);
end;

function StrScanW(Str: PWideChar; Chr: widechar): PWideChar;

// returns a pointer to first occurrence of a specified character in a string

asm
         PUSH EDI
         PUSH EAX
         MOV EDI, Str
         MOV ECX, 0FFFFFFFFH
         XOR AX, AX
         REPNE SCASW
         NOT ECX
         POP EDI
         MOV AX, Chr
         REPNE SCASW
         MOV EAX, 0
         JNE @@1
         MOV EAX, EDI
         SUB EAX, 2
@@1:     POP EDI
end;

function StrEndW(Str: PWideChar): PWideChar; 

// returns a pointer to the end of a null terminated string

asm
         MOV EDX, EDI
         MOV EDI, EAX
         MOV ECX, 0FFFFFFFFH
         XOR AX, AX
         REPNE SCASW
         LEA EAX, [EDI - 2]
         MOV EDI, EDX
end;

function WideQuotedStr(const S: WideString; Quote: widechar): WideString;

// works like QuotedStr from SysUtils.pas but can insert any quotation character

var
  P, Src, Dest: PWideChar;
  AddCount: integer;
begin
  AddCount := 0;
  P := StrScanW(PWideChar(S), Quote);
  while Assigned(P) do
  begin
    Inc(P);
    Inc(AddCount);
    P := StrScanW(P, Quote);
  end;

  if AddCount = 0 then Result := Quote + S + Quote
  else
  begin
    SetLength(Result, Length(S) + AddCount + 2);
    Dest := PWideChar(Result);
    Dest^ := Quote;
    Inc(Dest);
    Src := PWideChar(S);
    P := StrScanW(Src, Quote);
    repeat
      Inc(P);
      Move(Src^, Dest^, (P - Src) * SizeOf(widechar));
      Inc(Dest, P - Src);
      Dest^ := Quote;
      Inc(Dest);
      Src := P;
      P := StrScanW(Src, Quote);
    until P = nil;
    P := StrEndW(Src);
    Move(Src^, Dest^, (P - Src) * SizeOf(widechar));
    Inc(Dest, P - Src);
    Dest^ := Quote;
  end;  
end;

function StrLenW(Str: PWideChar): cardinal;

// returns number of characters in a string excluding the null terminator

asm
         MOV EDX, EDI
         MOV EDI, EAX
         MOV ECX, 0FFFFFFFFH
         XOR AX, AX
         REPNE SCASW
         MOV EAX, 0FFFFFFFEH
         SUB EAX, ECX
         MOV EDI, EDX
end;

function StrMoveW(Dest, Source: PWideChar; Count: cardinal): PWideChar;

// Copies the specified number of characters to the destination string and returns Dest
// also as result. Dest must have enough room to store at least Count characters.

asm
         PUSH ESI
         PUSH EDI
         MOV ESI, EDX
         MOV EDI, EAX
         MOV EDX, ECX
         CMP EDI, ESI
         JG @@1
         JE @@2
         SHR ECX, 1
         REP MOVSD
         MOV ECX, EDX
         AND ECX, 1
         REP MOVSW
         JMP @@2

@@1:     LEA ESI, [ESI + 2 * ECX - 2]
         LEA EDI, [EDI + 2 * ECX - 2]
         STD
         AND ECX, 1
         REP MOVSW
         SUB EDI, 2
         SUB ESI, 2
         MOV ECX, EDX
         SHR ECX, 1
         REP MOVSD
         CLD
@@2:     POP EDI
         POP ESI
end;

function StrAllocW(Size: cardinal): PWideChar;

// Allocates a buffer for a null-terminated wide string and returns a pointer
// to the first character of the string.

begin
  Size := SizeOf(widechar) * Size + SizeOf(cardinal);
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
  cardinal(Pointer(Result)^) := Size;
  Inc(Result, SizeOf(cardinal) div SizeOf(widechar));
end;

function StrNewW(Str: PWideChar): PWideChar;

// Duplicates the given string (if not nil) and returns the address of the new string.

var
  Size: cardinal;
begin
  if Str = nil then Result := nil
  else
  begin
    Size := StrLenW(Str) + 1;
    Result := StrMoveW(StrAllocW(Size), Str, Size);
  end;
end;

function WideExtractQuotedStr(var Src: PWideChar; Quote: widechar): WideString;

// extracts a string enclosed in quote characters given by Quote

var
  P, Dest: PWideChar;
  DropCount: integer;    
begin
  Result := '';
  if (Src = nil) or (Src^ <> Quote) then Exit;

  Inc(Src);
  DropCount := 1;
  P := Src;
  Src := StrScanW(Src, Quote);

  while Assigned(Src) do   // count adjacent pairs of quote chars
  begin
    Inc(Src);
    if Src^ <> Quote then Break;
    Inc(Src);
    Inc(DropCount);
    Src := StrScanW(Src, Quote);
  end;

  if Src = nil then Src := StrEndW(P);
  if (Src - P) <= 1 then Exit;
  
  if DropCount = 1 then SetString(Result, P, Src - P - 1)
  else
  begin
    SetLength(Result, Src - P - DropCount);
    Dest := PWideChar(Result);
    Src := StrScanW(P, Quote);
    while Assigned(Src) do
    begin
      Inc(Src);
      if Src^ <> Quote then Break;
      Move(P^, Dest^, (Src - P) * SizeOf(widechar));
      Inc(Dest, Src - P);
      Inc(Src);
      P := Src;
      Src := StrScanW(Src, Quote);
    end;
    if Src = nil then Src := StrEndW(P);
    Move(P^, Dest^, (Src - P - 1) * SizeOf(widechar));
  end;
end;

function CodePageFromLocale(Language: LCID): integer;

// determines the code page for a given locale

var
  Buf: array[0..6] of AnsiChar;
begin
  GetLocaleInfo(Language, LOCALE_IDefaultAnsiCodePage, Buf, 6);
  Result := StrToIntDef(Buf, GetACP);
end;

function CompareTextWin95(W1, W2: WideString; Locale: LCID): integer;

// special comparation function for Win9x since there's no system defined comparation function,
// returns -1 if W1 < W2, 0 if W1 = W2 or 1 if W1 > W2

var
  S1, S2: AnsiString;
  CP: integer;
  L1, L2: integer;
begin
  L1 := Length(W1);
  L2 := Length(W2);
  SetLength(S1, L1);
  SetLength(S2, L2);
  CP := CodePageFromLocale(Locale);
  WideCharToMultiByte(CP, 0, PWideChar(W1), L1, PAnsiChar(S1), L1, nil, nil);
  WideCharToMultiByte(CP, 0, PWideChar(W2), L2, PAnsiChar(S2), L2, nil, nil);
  Result := CompareStringA(Locale, NORM_IGNORECASE, PAnsiChar(S1),
    Length(S1), PAnsiChar(S2), Length(S2)) - 2;
end;

//----------------------------------------------------------------------------------------------------------------------

function CompareTextWinNT(W1, W2: WideString; Locale: LCID): integer;

// Wrapper function for WinNT since there's no system defined comparation function in Win9x and
// we need a central comparation function for TWideStringList.
// Returns -1 if W1 < W2, 0 if W1 = W2 or 1 if W1 > W2

begin
  Result := CompareStringW(Locale, NORM_IGNORECASE, PWideChar(W1),
    Length(W1), PWideChar(W2), Length(W2)) - 2;
end;

procedure MakeWMCharMsgSafeForAnsi(var Message: TMessage);
begin
  with TWMChar(Message) do 
  begin
    Assert(Msg = WM_CHAR);
    Assert(Unused = 0);
    if (CharCode > word(High(AnsiChar))) then 
    begin
      Unused := CharCode;
      CharCode := ANSI_UNICODE_HOLDER;
    end;
  end;
end;

procedure RestoreWMCharMsg(var Message: TMessage);
begin
  with TWMChar(Message) do 
  begin
    Assert(Message.Msg = WM_CHAR);
    if (Unused > 0) and (CharCode = ANSI_UNICODE_HOLDER) then
      CharCode := Unused;
    Unused := 0;
  end;
end;

function HandleIMEComposition(hWnd: THandle; Message: TMessage): boolean;
var
  IMC: HIMC;
  Buff: widestring;
  i: integer;
begin
  Result := False;
  if (Win32Platform = VER_PLATFORM_WIN32_NT) and (Message.Msg = WM_IME_COMPOSITION)
    and ((Message.lParam and GCS_RESULTSTR) <> 0) then
  begin
    IMC := ImmGetContext(hWnd);
    if IMC <> 0 then 
    begin
      try
        Result := True;
        // Get the result string
        SetLength(Buff, ImmGetCompositionStringW(IMC, GCS_RESULTSTR,
          nil, 0) div SizeOf(widechar));
        ImmGetCompositionStringW(IMC, GCS_RESULTSTR, PWideChar(Buff),
          Length(Buff) * SizeOf(widechar));
      finally
        ImmReleaseContext(hWnd, IMC);
      end;
      // send WM_CHAR messages for each char in string
      for i := 1 to Length(Buff) do 
      begin
        SendMessageW(hWnd, WM_CHAR, integer(Buff[i]), 0);
      end;
    end;
  end;
end;

{ TComboBoxStrings }

function TComboBoxStrings.GetCount: integer;
begin
  Result := ComboBox.Items.Count;
end;

function TComboBoxStrings.Get(Index: integer): WideString;
var
  Len: integer;
begin
  if (not IsWindowUnicode(ComboBox.Handle)) then
    Result := ComboBox.Items[Index]
  else 
  begin
    Len := SendMessageW(ComboBox.Handle, CB_GETLBTEXTLEN, Index, 0);
    if Len = CB_ERR then
      Result := ''
    else 
    begin
      SetLength(Result, Len + 1);
      Len := SendMessageW(ComboBox.Handle, CB_GETLBTEXT, Index, longint(PWideChar(Result)));
      if Len = CB_ERR then
        Result := ''
      else
        Result := PWideChar(Result);
    end;
  end;
end;

function TComboBoxStrings.GetObject(Index: integer): TObject;
begin
  Result := ComboBox.Items.Objects[Index];
end;

{$IFDEF JCL}
procedure TComboBoxStrings.Put(Index: integer; const S: WideString);
begin
  JCL_WideStrings_Put(Self, Index, S);
end;
{$ENDIF}

procedure TComboBoxStrings.PutObject(Index: integer; AObject: TObject);
begin
  ComboBox.Items.Objects[Index] := AObject;
end;

function TComboBoxStrings.Add(const S: WideString): integer;
begin
  if (not IsWindowUnicode(ComboBox.Handle)) then
    Result := ComboBox.Items.Add(S)
  else 
  begin
    Result := SendMessageW(ComboBox.Handle, CB_ADDSTRING, 0, longint(PWideChar(S)));
    if Result < 0 then
      raise EOutOfResources.Create(SInsertLineError);
  end;
end;

procedure TComboBoxStrings.Insert(Index: integer; const S: WideString);
begin
  if (not IsWindowUnicode(ComboBox.Handle)) then
    ComboBox.Items.Insert(Index, S)
  else 
  begin
    if SendMessageW(ComboBox.Handle, CB_INSERTSTRING, Index, longint(PWideChar(S))) < 0 then
      raise EOutOfResources.Create(SInsertLineError);
  end;
end;

procedure TComboBoxStrings.Delete(Index: integer);
begin
  ComboBox.Items.Delete(Index);
end;

procedure TComboBoxStrings.Clear;
var
  S: widestring;
begin
  S := WideGetWindowText(ComboBox);
  SendMessage(ComboBox.Handle, CB_RESETCONTENT, 0, 0);
  WideSetWindowText(ComboBox, S);
  ComboBox.Update;
end;

procedure TComboBoxStrings.SetUpdateState(Updating: boolean);
begin
  if Updating then
    ComboBox.Items.BeginUpdate
  else
    ComboBox.Items.EndUpdate
end;

function TComboBoxStrings.IndexOf(const S: WideString): integer;
begin
  if (not IsWindowUnicode(ComboBox.Handle)) then
    Result := ComboBox.Items.IndexOf(S)
  else
    Result := SendMessageW(ComboBox.Handle, CB_FINDSTRINGEXACT, - 1, longint(PWideChar(S)));
end;

 { TWinControlTrap }
procedure TWinControlTrap.HandleWMDestroy(var Message: TMessage);
var
  ThisPrevWin32Proc: Pointer;
  ThisHandle: THandle;
begin
  with Message do 
  begin
    Assert(Msg = WM_DESTROY);
    // store local copies of values, since this object is about to be freed
    ThisPrevWin32Proc := PrevWin32Proc;
    ThisHandle := Handle;

    // handle destruction
    DestroyUnicodeHandle(FControl);

    // pass on the WM_DESTROY message
    Result := CallWindowProc(ThisPrevWin32Proc, ThisHandle, Msg, wParam, lParam);
  end;
end;

procedure TWinControlTrap.Win32Proc(var Message: TMessage);
begin
  with Message do 
  begin
    if Msg = WM_DESTROY then 
    begin
      HandleWMDestroy(Message);
      exit; { Do not access any data in object. Object is freed. }
    end;
    if not HandleIMEComposition(Handle, Message) then 
    begin
      LastWin32Msg := Msg;
      Result := CallWindowProcW(PrevWin32Proc, Handle, Msg, wParam, lParam);
    end;
  end;
end;

procedure TWinControlTrap.DefWin32Proc(var Message: TMessage);
begin
  with Message do 
  begin
    if (Msg = WM_CHAR) then 
    begin
      RestoreWMCharMsg(Message)
    end;
    Result := CallWindowProcW(PrevDefWin32Proc, Handle, Msg, wParam, lParam);
  end;
end;

procedure TWinControlTrap.WindowProc(var Message: TMessage);
var
  CameFromWindows: boolean;
begin
  CameFromWindows := LastWin32Msg <> WM_NULL;
  LastWin32Msg := WM_NULL;
  with Message do 
  begin
    if (not CameFromWindows) and (IsTextMessage(Msg)) then
      Result := SendMessageA(Handle, Msg, wParam, lParam)
    else 
    begin
      if (Msg = WM_CHAR) then 
      begin
        MakeWMCharMsgSafeForAnsi(Message);
      end;
      PrevWindowProc(Message)
    end;
  end;
end;

procedure SubClassUnicodeControl(Control: TWinControl);
var
  WinControlTrap: TWinControlTrap;
begin
  if IsWindowUnicode(Control.Handle) then 
  begin
    // create trap object, save reference
    WinControlTrap := TWinControlTrap.Create;
    SetProp(Control.Handle, MakeIntAtom(WinControlTrap_Atom), cardinal(WinControlTrap));

    with WinControlTrap do 
    begin
      // initialize trap object
      FControl := Control;
      Handle := Control.Handle;
      PrevWin32Proc := Pointer(GetWindowLong(Control.Handle, GWL_WNDPROC));
      PrevDefWin32Proc := TAccessWinControl(Control).DefWndProc;
      PrevWindowProc := Control.WindowProc;

      // subclass Window Procedures
      ObjectInstance := MakeObjectInstance(Win32Proc);
      SetWindowLongW(Control.Handle, GWL_WNDPROC, integer(ObjectInstance));
      DefObjectInstance := MakeObjectInstance(DefWin32Proc);
      TAccessWinControl(Control).DefWndProc := DefObjectInstance;
      Control.WindowProc := WindowProc;
    end;
  end;
end;

procedure UnSubClassUnicodeControl(Control: TWinControl);
var
  WinControlTrap: TWinControlTrap;
begin
  if IsWindowUnicode(Control.Handle) then 
  begin
    // get referenct to trap object
    WinControlTrap := TWinControlTrap(GetProp(Control.Handle,
      MakeIntAtom(WinControlTrap_Atom)));
    RemoveProp(Control.Handle, MakeIntAtom(WinControlTrap_Atom));

    with WinControlTrap do 
    begin
      // restore window procs
      Control.WindowProc := PrevWindowProc;
      TAccessWinControl(Control).DefWndProc := PrevDefWin32Proc;
      SetWindowLongW(Control.Handle, GWL_WNDPROC, integer(PrevWin32Proc));
      FreeObjectInstance(ObjectInstance);
      FreeObjectInstance(DefObjectInstance);

      // free trap object
      Free;
    end;
  end;
end;

//----------------------------------------------- CREATE/DESTROY UNICODE HANDLE

function FindWideCaptionHolder(Control: TWinControl;
  Default: WideString = ''): TWideCaptionHolder;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Control.ComponentCount - 1 do 
  begin
    if (Control.Components[i] is TWideCaptionHolder) then 
    begin
      Result := TWideCaptionHolder(Control.Components[i]);
      exit; // found it!
    end;
  end;
  if Result = nil then 
  begin
    Result := TWideCaptionHolder.Create(Control);
    Result.WideCaption := Default;
  end;
end;

procedure CreateUnicodeHandle(Control: TWinControl; const Params: TCreateParams;
  const SubClass: WideString);
var
  WideSubClass: TWndClassW;
  WideWinClassName: widestring;
  WideClass: TWndClassW;
  TempClass: TWndClassW;
  Handle: THandle;
begin
  if Win32Platform <> VER_PLATFORM_WIN32_NT then 
  begin
    with Params do
      TAccessWinControl(Control).WindowHandle := CreateWindowEx(ExStyle, WinClassName,
        Caption, Style, X, Y, Width, Height, WndParent, 0, WindowClass.hInstance, Param);
  end 
  else 
  begin
    // SubClass the unicode version of this control by getting the correct DefWndProc
    if SubClass <> '' then 
    begin
      GetClassInfoW(hInstance, PWideChar(SubClass), WideSubClass);
      TAccessWinControl(Control).DefWndProc := WideSubClass.lpfnWndProc;
    end 
    else
      TAccessWinControl(Control).DefWndProc := @DefWindowProcW;

    with Params do 
    begin
      WideWinClassName := WinClassName + UNICODE_CLASS_EXT;
      if not GetClassInfoW(Params.WindowClass.hInstance,
        PWideChar(WideWinClassName), TempClass) then 
      begin
        // Prepare a TWndClassW record
        WideClass := TWndClassW(WindowClass);
        if not Is_IntResource(PWideChar(WindowClass.lpszMenuName)) then 
        begin
          WideClass.lpszMenuName := PWideChar(WideString(WindowClass.lpszMenuName));
        end;
        WideClass.lpszClassName := PWideChar(WideWinClassName);

        // Register the UNICODE class
        if RegisterClassW(WideClass) = 0 then   RaiseLastWin32Error;
      end;

      // Create UNICODE window
      Handle := CreateWindowExW(ExStyle, PWideChar(WideWinClassName), nil,
        Style, X, Y, Width, Height, WndParent, 0, WindowClass.hInstance, Param);

      // SetWindowLongW needs to be called because InitWndProc converts control to ANSI
      //  CallingSetWindowLongA(.., GWL_WNDPROC) makes Windows think it is an ANSI window
      //    But CallingSetWindowLongW(.., GWL_WNDPROC) make Windows think it is a UNICODE window.
      SetWindowLongW(Handle, GWL_WNDPROC, GetWindowLong(Handle, GWL_WNDPROC));

      // set handle for control
      TAccessWinControl(Control).WindowHandle := Handle;

      // sub-class
      SubClassUnicodeControl(Control);

      // For some reason, caption gets garbled after calling SetWindowLongW(.., GWL_WNDPROC).
      WideSetWindowText(Control, FindWideCaptionHolder(Control, Caption).WideCaption);
    end;
  end;
end;

procedure DestroyUnicodeHandle(Control: TWinControl);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then 
  begin
    // remember caption for future window creation
    if not (csDestroying in Control.ComponentState) then
      FindWideCaptionHolder(Control).WideCaption := WideGetWindowText(Control);
    // un sub-class
    UnSubClassUnicodeControl(Control);
  end;
end;

//----------------------------------------------- GET/SET WINDOW TEXT

function WideGetWindowText(Control: TWinControl): WideString;
begin
  if (not Control.HandleAllocated) or (not IsWindowUnicode(Control.Handle)) then 
  begin
    // NO HANDLE -OR- NOT UNICODE
    Result := TAccessWinControl(Control).Text;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      Result := FindWideCaptionHolder(Control, Result).WideCaption
  end 
  else 
  begin
    // UNICODE & HANDLE
    SetLength(Result, GetWindowTextLengthW(Control.Handle) + 1);
    GetWindowTextW(Control.Handle, PWideChar(Result), Length(Result));
    SetLength(Result, Length(Result) - 1);
  end;
end;

procedure WideSetWindowText(Control: TWinControl; const Text: WideString);
begin
  if (not Control.HandleAllocated) or (not IsWindowUnicode(Control.Handle)) then 
  begin
    // NO HANDLE -OR- NOT UNICODE
    TAccessWinControl(Control).Text := Text;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      FindWideCaptionHolder(Control).WideCaption := Text;
  end 
  else if WideGetWindowText(Control) <> Text then 
  begin
    // UNICODE & HANDLE
    SetWindowTextW(Control.Handle, PWideChar(Text));
    Control.Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

//----------------- TWideStrings ---------------------------------------------------------------------------------------

constructor TWideStrings.Create;

begin
  inherited;
  FAnsiStrings := TAnsiStringsForWideStrings.Create;
  TAnsiStringsForWideStrings(FAnsiStrings).FWideStrings := Self;
  // there should seldom be the need to use a language other than the one of the system
  FLanguage := GetUserDefaultLCID;
end;

//----------------------------------------------------------------------------------------------------------------------

destructor TWideStrings.Destroy;

begin
  FreeAndNil(FAnsiStrings);
  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.SetAnsiStrings(const Value: TAnsiStrings);
begin
  FAnsiStrings.Assign(Value);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.SetLanguage(Value: LCID);

begin
  FLanguage := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.Add(const S: WideString): integer;

begin
  Result := GetCount;
  Insert(Result, S);
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.AddObject(const S: WideString; AObject: TObject): integer;

begin
  Result := Add(S);
  PutObject(Result, AObject);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.Append(const S: WideString);

begin
  Add(S);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.AddStrings(Strings: TAnsiStrings);

var
  I: integer;
begin
  BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do AddObject(Strings[I], Strings.Objects[I]);
  finally
    EndUpdate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.AddStrings(Strings: TWideStrings);

var
  I: integer;
begin
  BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do AddObject(Strings[I], Strings.Objects[I]);
  finally
    EndUpdate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.Assign(Source: TPersistent);

// usual assignment routine, but able to assign wide and small strings

var
  I: integer;
begin
  if Source is TWideStrings then
  begin
    BeginUpdate;
    try
      Clear;
      AddStrings(TWideStrings(Source));
    finally
      EndUpdate;
    end;
  end
  else if Source is TAnsiStrings then
  begin
    BeginUpdate;
    try
      Clear;
      for I := 0 to TAnsiStrings(Source).Count - 1 do
        AddObject(TAnsiStrings(Source)[I], TAnsiStrings(Source).Objects[I]);
    finally
      EndUpdate;
    end;
  end
  else 
    inherited Assign(Source);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.AssignTo(Dest: TPersistent);

// need to do also assignment to old style TStrings, but this class doesn't know TWideStrings, so
// we need to do it from here

var
  I: integer;
begin
  if Dest is TAnsiStrings then
    with Dest as TAnsiStrings do
    begin
      BeginUpdate;
      try
        Clear;
        for I := 0 to Self.Count - 1 do AddObject(Self[I], Self.Objects[I]);
      finally
        EndUpdate;
      end;
    end
  else if Dest is TWideStrings then
    with Dest as TWideStrings do
    begin
      BeginUpdate;
      try
        Clear;
        AddStrings(Self);
      finally
        EndUpdate;
      end;
    end
  else 
    inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.BeginUpdate;

begin
  if FUpdateCount = 0 then SetUpdateState(True);
  Inc(FUpdateCount);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.DefineProperties(Filer: TFiler);

  function DoWrite: boolean;

  begin
    if Filer.Ancestor <> nil then
    begin
      Result := True;
      if Filer.Ancestor is TWideStrings then Result :=
          not Equals(TWideStrings(Filer.Ancestor))
    end
    else 
      Result := Count > 0;
  end;
begin
  Filer.DefineProperty('WideStrings', ReadData, WriteData, DoWrite);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.EndUpdate;

begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then SetUpdateState(False);
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.Equals(Strings: TWideStrings): boolean;

var
  I, Count: integer;
begin
  Result := False;
  Count := GetCount;
  if Count <> Strings.GetCount then Exit;
  for I := 0 to Count - 1 do
    if Get(I) <> Strings.Get(I) then Exit;
  Result := True;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.Error(const Msg: WideString; Data: integer);

  function ReturnAddr: Pointer;

  asm
          MOV EAX, [EBP + 4]
  end;
begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.Exchange(Index1, Index2: integer);

var
  TempObject: TObject;
  TempString: widestring;
begin
  BeginUpdate;
  try
    TempString := Strings[Index1];
    TempObject := Objects[Index1];
    Strings[Index1] := Strings[Index2];
    Objects[Index1] := Objects[Index2];
    Strings[Index2] := TempString;
    Objects[Index2] := TempObject;
  finally
    EndUpdate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.GetCapacity: integer;

begin  // descendants may optionally override/replace this default implementation
  Result := Count;
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.GetCommaText: WideString;

var
  S: widestring;
  P: PWideChar;
  I, Count: integer;
begin
  Count := GetCount;
  if (Count = 1) and (Get(0) = '') then Result := '""'
  else
  begin
    Result := '';
    for I := 0 to Count - 1 do
    begin
      S := Get(I);
      P := PWideChar(S);
      while not (P^ in [WideNull..Space, widechar('"'), widechar(',')]) do Inc(P);
      if (P^ <> WideNull) then S := WideQuotedStr(S, '"');
      Result := Result + S + ',';
    end;
    System.Delete(Result, Length(Result), 1);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.GetName(Index: integer): WideString;

var
  P: integer;
begin
  Result := Get(Index);
  P := Pos('=', Result);
  if P > 0 then SetLength(Result, P - 1)
  else 
    Result := '';
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.GetObject(Index: integer): TObject;

begin
  Result := nil;
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.GetText: PWideChar;

begin
  Result := StrNewW(PWideChar(GetTextStr));
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.GetTextStr: WideString;

var
  I, L, Size, Count: integer;
  P: PWideChar;
  S: widestring;
begin
  Count := GetCount;
  Size := 0;
  for I := 0 to Count - 1 do Inc(Size, Length(Get(I)) + 2);
  SetLength(Result, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := Get(I);
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, 2 * L);
      Inc(P, L);
    end;
    P^ := CarriageReturn;
    Inc(P);
    P^ := LineFeed;
    Inc(P);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.GetValue(const Name: WideString): WideString;

var
  I: integer;
begin
  I := IndexOfName(Name);
  if I >= 0 then Result := Copy(Get(I), Length(Name) + 2, MaxInt)
  else 
    Result := '';
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.IndexOf(const S: WideString): integer;

begin
  for Result := 0 to GetCount - 1 do
    if WideCompareText(Get(Result), S, FLanguage) = 0 then Exit;
  Result := -1;
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.IndexOfName(const Name: WideString): integer;

var
  P: integer;
  S: widestring;
begin
  for Result := 0 to GetCount - 1 do
  begin
    S := Get(Result);
    P := Pos('=', S);
    if (P > 0) and (WideCompareText(Copy(S, 1, P - 1), Name, FLanguage) = 0) then Exit;
  end;
  Result := -1;
end;

//----------------------------------------------------------------------------------------------------------------------

function TWideStrings.IndexOfObject(AObject: TObject): integer;

begin
  for Result := 0 to GetCount - 1 do
    if GetObject(Result) = AObject then Exit;
  Result := -1;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.InsertObject(Index: integer; const S: WideString;
  AObject: TObject);

begin
  Insert(Index, S);
  PutObject(Index, AObject);
end;

procedure TWideStrings.Move(CurIndex, NewIndex: integer);

var
  TempObject: TObject;
  TempString: widestring;
begin
  if CurIndex <> NewIndex then
  begin
    BeginUpdate;
    try
      TempString := Get(CurIndex);
      TempObject := GetObject(CurIndex);
      Delete(CurIndex);
      InsertObject(NewIndex, TempString, TempObject);
    finally
      EndUpdate;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.Put(Index: integer; const S: WideString);

var
  TempObject: TObject;
begin
  TempObject := GetObject(Index);
  Delete(Index);
  InsertObject(Index, S, TempObject);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.PutObject(Index: integer; AObject: TObject);

begin
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.ReadData(Reader: TReader);

begin
  Reader.ReadListBegin;
  BeginUpdate;
  try
    Clear;
    while not Reader.EndOfList do
      if Reader.NextValue in [vaString, vaLString] then
        Add(Reader.ReadString)
    else
      Add(Reader.ReadWideString);
  finally
    EndUpdate;
  end;
  Reader.ReadListEnd;
end;

procedure TWideStrings.SetCapacity(NewCapacity: integer);

begin
  // do nothing - descendants may optionally implement this method
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.SetCommaText(const Value: WideString);

var
  P, P1: PWideChar;
  S: widestring;
begin
  BeginUpdate;
  try
    Clear;
    P := PWideChar(Value);
    while P^ in [widechar(#1)..Space] do Inc(P);
    while P^ <> WideNull do
    begin
      if P^ = '"' then  S := WideExtractQuotedStr(P, '"')
      else
      begin
        P1 := P;
        while (P^ > Space) and (P^ <> ',') do Inc(P);
        SetString(S, P1, P - P1);
      end;
      Add(S);

      while P^ in [widechar(#1)..Space] do Inc(P);
      if P^ = ',' then
        repeat
          Inc(P);
        until not (P^ in [widechar(#1)..Space]);
    end;
  finally
    EndUpdate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.SetText(Text: PWideChar);

begin
  SetTextStr(Text);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.SetTextStr(const Value: WideString);

var
  Head, Tail: PWideChar;
  S: widestring;
begin
  BeginUpdate;
  try
    Clear;
    Head := PWideChar(Value);
    while Head^ <> WideNull do
    begin
      Tail := Head;
      while not (Tail^ in [WideNull, LineFeed, CarriageReturn, VerticalTab, FormFeed])
        and
        (Tail^ <> LineSeparator) and
        (Tail^ <> ParagraphSeparator) do Inc(Tail);
      SetString(S, Head, Tail - Head);
      Add(S);
      Head := Tail;
      if Head^ <> WideNull then
      begin
        Inc(Head);
        if (Tail^ = CarriageReturn) and
          (Head^ = LineFeed) then Inc(Head);
      end;
    end;
  finally
    EndUpdate;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.SetUpdateState(Updating: boolean);

begin
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.SetValue(const Name, Value: WideString);

var
  I: integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then
  begin
    if I < 0 then I := Add('');
    Put(I, Name + '=' + Value);
  end
  else if I >= 0 then Delete(I);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWideStrings.WriteData(Writer: TWriter);

var
  I: integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do
    Writer.WriteWideString(Get(I));
  Writer.WriteListEnd;
end;

{ TUNICustomEdit }

constructor TCustomUNIEdit.Create(AOwner: TComponent);
begin
  inherited;
  Font.Charset := OEM_CHARSET;// THIS sets the Charset so the Edit accepts all UNICODE characters
end;

procedure TCustomUNIEdit.CreateWindowHandle(const Params: TCreateParams);
begin
  if SysLocale.FarEast and (Win32Platform <> VER_PLATFORM_WIN32_NT) and
    ((Params.Style and ES_READONLY) <> 0) then
    inherited
  else
    CreateUnicodeHandle(Self, Params, 'EDIT');
end;

function TCustomUNIEdit.GetSelText: WideString;
begin
  if (not IsWindowUnicode(Handle)) then
    Result := inherited SelText
  else
    Result := Copy(Text, SelStart + 1, SelLength);
end;

procedure TCustomUNIEdit.SetSelText(const Value: WideString);
begin
  if (not IsWindowUnicode(Handle)) then
    inherited SelText := Value
  else
    SendMessageW(Handle, EM_REPLACESEL, 0, longint(PWideChar(Value)));
end;

function TCustomUNIEdit.GetText: WideString;
begin
  Result := WideGetWindowText(Self);
end;

procedure TCustomUNIEdit.SetText(const Value: WideString);
begin
  WideSetWindowText(Self, Value);
end;

{ TCustomUNIComboBox }

constructor TCustomUNIComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TComboBoxStrings.Create;
  TComboBoxStrings(FItems).ComboBox := Self;
  Font.Charset := OEM_CHARSET;// THIS sets the Charset so the Edit accepts all UNICODE characters
end;

destructor TCustomUNIComboBox.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

procedure TCustomUNIComboBox.CreateWindowHandle(const Params: TCreateParams);
begin
  CreateUnicodeHandle(Self, Params, 'COMBOBOX');
end;

procedure TCustomUNIComboBox.CreateWnd;
begin
  inherited;
  if Win32Platform = VER_PLATFORM_WIN32_NT then 
  begin
    if ListHandle <> 0 then
      SetWindowLongW(ListHandle, GWL_WNDPROC, GetWindowLong(ListHandle, GWL_WNDPROC));
    SetWindowLongW(EditHandle, GWL_WNDPROC, GetWindowLong(EditHandle, GWL_WNDPROC));
  end;
end;

procedure TCustomUNIComboBox.ComboWndProc(var Message: TMessage; ComboWnd: HWnd;
  ComboProc: Pointer);
begin
  if (not IsWindowUnicode(ComboWnd)) then
  begin
    if Message.Msg = WM_CHAR then
      DoEditCharMsg(TWMKey(Message));
    inherited;
  end 
  else 
  begin
    try
      // UNICODE
      if IsTextMessage(Message.Msg) then
        with Message do
          Result := CallWindowProcW(ComboProc, ComboWnd, Msg, WParam, LParam)
      else if Message.Msg = WM_CHAR then 
      begin
        MakeWMCharMsgSafeForAnsi(Message);
        DoEditCharMsg(TWMKey(Message));
        if DoKeyPress(TWMKey(Message)) then Exit;
        RestoreWMCharMsg(Message);
        with TWMKey(Message) do 
        begin
          if ((CharCode = VK_RETURN) or (CharCode = VK_ESCAPE)) and DroppedDown then
          begin
            DroppedDown := False;
            Exit;
          end;
        end;
        with Message do
          Result := CallWindowProcW(ComboProc, ComboWnd, Msg, WParam, LParam)
      end 
      else if not HandleIMEComposition(ComboWnd, Message) then
        inherited;
    except
      Application.HandleException(Self);
    end;
  end;
end;

procedure TCustomUNIComboBox.KeyPress(var Key: char);
begin
  { Don't call inherited for VK_BACK and Delphi 6.  This combo's text will be copied to an
    AnsiString, last char deleted, and the AnsiString will be reassigned to this combo.
      This will drop all Unicode chars. }
  if Ord(Key) <> VK_BACK then
    inherited
  else if Assigned(OnKeyPress) then
    OnKeyPress(Self, Key);
end;

function TCustomUNIComboBox.GetItems: TWideStrings;
begin
  Result := FItems;
end;

procedure TCustomUNIComboBox.SetItems(const Value: TWideStrings);
begin
  FItems.Assign(Value);
end;

function TCustomUNIComboBox.GetSelText: WideString;
begin
  if (not IsWindowUnicode(Handle)) then
    Result := inherited SelText
  else 
  begin
    Result := '';
    if Style < csDropDownList then
      Result := Copy(Text, SelStart + 1, SelLength);
  end;
end;

procedure TCustomUNIComboBox.SetSelText(const Value: WideString);
begin
  if (not IsWindowUnicode(Handle)) then
    inherited SelText := Value
  else 
  begin
    if Style < csDropDownList then
    begin
      HandleNeeded;
      SendMessageW(EditHandle, EM_REPLACESEL, 0, longint(PWideChar(Value)));
    end;
  end;
end;

function TCustomUNIComboBox.GetText: WideString;
begin
  Result := WideGetWindowText(Self);
end;

procedure TCustomUNIComboBox.SetText(const Value: WideString);
begin
  WideSetWindowText(Self, Value);
end;

procedure TCustomUNIComboBox.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode <> CBN_SELCHANGE then
    inherited
  else 
  begin
    Text := Items[ItemIndex];
    Click;
    Change;
  end;
end;

procedure TCustomUNIComboBox.DoEditCharMsg(var Message: TWMChar);
begin
end;




constructor TASGUniCustomCombo.Create(AOwner: TComponent);
begin
  inherited;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL) + 4;
  FOldColor := inherited Color;
  FOldParentColor := inherited ParentColor;
  FFlat := True;
  FMouseInControl := False;
end;

procedure TASGUniCustomCombo.SetButtonWidth(const Value: integer);
begin
  if (value < 14) or (value > 32) then Exit;
  FButtonWidth := Value;
  Invalidate;
end;

procedure TASGUniCustomCombo.SetFlat(const Value: Boolean);
begin
  if Value<>FFlat then
  begin
    FFlat := Value;
    Ctl3D := not Value;
    Invalidate;
  end;
end;

procedure TASGUniCustomCombo.SetEtched(const Value: Boolean);
begin
  if Value <> FEtched then
  begin
    FEtched := Value;
    Invalidate;
  end;
end;

procedure TASGUniCustomCombo.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    DrawBorders;
end;

procedure TASGUniCustomCombo.CMExit(var Message: TCMExit);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    DrawBorders;
end;

procedure TASGUniCustomCombo.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if not FMouseInControl and Enabled then
  begin
    FMouseInControl := True;
    DrawBorders;
  end;
  if FAutoFocus then
    Self.SetFocus;
end;

procedure TASGUniCustomCombo.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled then
  begin
    FMouseInControl := False;
    DrawBorders;
  end;
end;

procedure TASGUniCustomCombo.CMEnabledChanged(var Msg: TMessage);
begin
  if FFlat then
  begin
    if Enabled then
    begin
      inherited ParentColor := FOldParentColor;
      inherited Color := FOldColor;
    end
    else
    begin
      FOldParentColor := inherited Parentcolor;
      FOldColor := inherited Color;
      inherited ParentColor := True;
    end;
  end;
  inherited;
end;

procedure TASGUniCustomCombo.WMNCPaint(var Message: TMessage);
begin
  inherited;
  if FFlat then
    DrawBorders;
end;

//  Returns a "True" if a Mouse button happens to be down.
function IsMouseButtonDown:Boolean;
begin
  // Note: Key state is read twice because the first time you read it, you learn
  // if the bittpm has been pressed ever.  The second time you read it you learn if
  // the button is currently pressed.

  if ((GetAsyncKeyState(VK_RBUTTON)and $8000) = 0) and
     ((GetAsyncKeyState(VK_LBUTTON)and $8000) = 0) then
  begin
    // Mouse buttons are up
    Result := False;
  end
  else
  begin
    // Mouse buttons are up
    Result := True;
  end;
end;

procedure TASGUniCustomCombo.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  PS: TPaintStruct;

  procedure DrawButton;
  var
    ARect: TRect;
    htheme: THandle;
  begin
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);

    Inc(ARect.Left, ClientWidth - FButtonWidth);
    InflateRect(ARect, -1, -1);

    if FIsWinXP then
    begin
      htheme := OpenThemeData(Handle,'combobox');
      if IsMouseButtonDown then
        DrawThemeBackground(htheme,DC,CP_DROPDOWNBUTTON,CBXS_PRESSED,@ARect,nil)
      else
        DrawThemeBackground(htheme,DC,CP_DROPDOWNBUTTON,CBXS_NORMAL,@ARect,nil);

      CloseThemeData(htheme);
    end
    else
    begin
      DrawFrameControl(DC, ARect, DFC_SCROLL, DFCS_SCROLLCOMBOBOX or DFCS_FLAT );
      ExcludeClipRect(DC, ClientWidth - FButtonWidth - 4 , 0, ClientWidth + 2, ClientHeight);
    end;
  end;

begin
  if not FFlat then
  begin
    inherited;
    Exit;
  end;

  if Message.DC = 0 then
    DC := BeginPaint(Handle, PS)
  else
    DC := Message.DC;
  try
    if Style <> csSimple then
    begin
      FillRect(DC, ClientRect, Brush.Handle);
      DrawButton;
    end;
    PaintWindow(DC);
  finally
    if Message.DC = 0 then
      EndPaint(Handle, PS);
  end;
  DrawBorders;
end;

function TASGUniCustomCombo.Is3DBorderControl: Boolean;
begin
  if csDesigning in ComponentState then
    Result := False
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);

  Result := Result and FFocusBorder;
end;

function TASGUniCustomCombo.Is3DBorderButton: Boolean;
begin
  if csDesigning in ComponentState then
    Result := Enabled
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);
end;

procedure TASGUniCustomCombo.DrawButtonBorder(DC: HDC);
const
  Flags: array[Boolean] of Integer = (0, BF_FLAT);
  Edge: array[Boolean] of Integer = (EDGE_RAISED,EDGE_ETCHED);
var
  ARect: TRect;
  BtnFaceBrush: HBRUSH;
begin
  ExcludeClipRect(DC, ClientWidth - FButtonWidth + 4, 4, ClientWidth - 4, ClientHeight - 4);

  GetWindowRect(Handle, ARect);
  OffsetRect(ARect, -ARect.Left, -ARect.Top);
  Inc(ARect.Left, ClientWidth - FButtonWidth - 2);
  InflateRect(ARect, -2, -2);

  if Is3DBorderButton then
    DrawEdge(DC, ARect, Edge[Etched], BF_RECT or Flags[DroppedDown])
  else
    begin
      BtnFaceBrush:=CreateSolidBrush(GetSysColor(COLOR_BTNFACE));
      InflateRect(ARect, 0, -1);
      ARect.Right := ARect.Right - 1;
      FillRect(DC, ARect, BtnFaceBrush);
      DeleteObject(BtnFaceBrush);
    end;

  ExcludeClipRect(DC, ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
end;

procedure TASGUniCustomCombo.DrawControlBorder(DC: HDC);
var
  ARect:TRect;
  BtnFaceBrush, WindowBrush: HBRUSH;
begin
  if Is3DBorderControl then
    BtnFaceBrush := CreateSolidBrush(GetSysColor(COLOR_BTNFACE))
  else
    BtnFaceBrush := CreateSolidBrush(ColorToRGB((parent as TWinControl).brush.color));

  WindowBrush := CreateSolidBrush(ColorToRGB(self.Color));

  try
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);
    if Is3DBorderControl then
    begin
      DrawEdge(DC, ARect, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, WindowBrush);
    end
    else
    begin
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, WindowBrush);
    end;
  finally
    DeleteObject(WindowBrush);
    DeleteObject(BtnFaceBrush);
  end;
end;

procedure TASGUniCustomCombo.DrawBorders;
var
  DC: HDC;
begin
  if not FFlat then Exit;

  DC := GetWindowDC(Handle);
  try
    DrawControlBorder(DC);
    if Style <> csSimple then
      DrawButtonBorder(DC);
  finally
    ReleaseDC(Handle,DC);
  end;
end;

procedure TASGUniCustomCombo.CNCommand(var Message: TWMCommand);
var
  r:TRect;
begin
  inherited;
  if Message.NotifyCode in [CBN_CLOSEUP,CBN_DROPDOWN] then
  begin
    r := GetClientRect;
    r.left := r.Right - FButtonWidth;
    InvalidateRect(Handle,@r,FALSE);
  end;
end;


procedure TASGUniCustomCombo.SetDropWidth(const Value: integer);
begin
  FDropWidth := Value;
  if value > 0 then
    SendMessage(self.Handle,CB_SETDROPPEDWIDTH,FDropWidth,0);
end;


var
  AtomText: array[0..127] of AnsiChar;

initialization
  if (Win32Platform and VER_PLATFORM_WIN32_NT) <> 0 then
      @WideCompareText := @CompareTextWinNT
  else @WideCompareText := @CompareTextWin95;
  WinControlTrap_Atom := GlobalAddAtom(StrFmt(AtomText, 'WinControlTrap.UnicodeClass.%d',
    [GetCurrentProcessID]));

finalization
  GlobalDeleteAtom(WinControlTrap_Atom);

end.
