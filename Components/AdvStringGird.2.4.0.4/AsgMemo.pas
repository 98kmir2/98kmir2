{***************************************************************************}
{ TAdvStringGrid Memo EditLink                                              }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0,6.0                   }
{ version 2.02 - rel. March 2002                                            }
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

unit AsgMemo;

interface

uses
  AdvGrid, StdCtrls, Windows, Classes, Messages, Controls, Graphics, Forms;

type

  TAdvGridMemo = class(TMemo)
  private
    FTabIsExit: Boolean;
    procedure CMWantSpecialKey(var Msg:TCMWantSpecialKey); message CM_WANTSPECIALKEY;
    procedure WMKeyDown(var Msg:TWMKeydown); message WM_KEYDOWN;
  protected
  public
  published
    property TabIsExit: Boolean read FTabIsExit write FTabIsExit;
  end;

  TMemoEditLink = class(TEditLink)
  private
    FEdit: TAdvGridMemo;
    FColor: TColor;
    FMaxLength: Integer;
    FScrollbars: TScrollStyle;
    FTabIsExit: Boolean;
    FWantReturns: Boolean;
    FWantTabs: Boolean;
  protected
    procedure EditExit(Sender: TObject);
  public
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    constructor Create(AOwner: TComponent); override;
    procedure CreateEditor(AParent: TWinControl); override;
    procedure DestroyEditor; override;
    function GetEditControl: TWinControl; override;
    function GetEditorValue: String; override;
    procedure SetEditorValue(s: String); override;
    procedure SetProperties; override;
  published
    property Color: TColor read FColor write FColor;
    property Scrollbars: TScrollStyle read FScrollbars write FScrollbars;
    property MaxLength: Integer read FMaxLength write FMaxLength;
    property TabIsExit: Boolean read FTabIsExit write FTabIsExit;
    property WantReturns: Boolean read FWantReturns write FWantReturns;
    property WantTabs: Boolean  read FWantTabs write FWantTabs;
  end;


implementation

type
  TProtectedGrid = class(TAdvStringGrid)
  end;


{ TMemoEditLink }

Procedure TMemoEditLink.CreateEditor(AParent: TWinControl);
Begin
  FEdit := TAdvGridMemo.Create(Grid);
  FEdit.OnKeydown := EditKeyDown;
  FEdit.OnExit := EditExit;
  FEdit.BorderStyle := bsSingle;
  FEdit.Scrollbars := ssBoth;
  FEdit.Width := 0;
  FEdit.Height := 0;
  FEdit.Parent := AParent;
End;

Procedure TMemoEditLink.DestroyEditor;
Begin
  FEdit.Free;
End;

Procedure TMemoEditLink.EditExit(Sender: TObject);
Begin
  HideEditor;
End;

Function TMemoEditLink.GetEditorValue: String;
Begin
  Result := FEdit.Lines.Text;
End;

Procedure TMemoEditLink.SetEditorValue(s: String);
Begin
  FEdit.Lines.Text := s;
  FEdit.SelectAll;
End;

Function TMemoEditLink.GetEditControl: TWinControl;
Begin
  Result := FEdit;
End;

Constructor TMemoEditLink.Create(aOwner: TComponent);
Begin
  Inherited;
  EditStyle := esPopup;
  PopupHeight := 100;
  PopupWidth := 100;
  WantKeyReturn := True;
  WantKeyUpDown := True;
  ScrollBars := ssBoth;
  Color := clWindow;
End;

Procedure TMemoEditLink.SetProperties;
begin
  Inherited;
  FEdit.Color := FColor;
  FEdit.Scrollbars := FScrollbars;
  FEdit.MaxLength := FMaxLength;
  FEdit.Font.Assign(Grid.Canvas.Font);
  FEdit.TabIsExit := FTabIsExit;
  FEdit.WantReturns := FWantReturns;
  FEdit.WantTabs := FWantTabs;

  if  EditStyle = esInplace then
    FEdit.BorderStyle := bsNone
  else
    FEdit.BorderStyle := bsSingle;
end;

procedure TMemoEditLink.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (FTabIsExit and (Key = VK_TAB))  then
  begin
    with TprotectedGrid(Grid) do
    begin
      SetFocus;
      HideInplaceEdit;
      AdvanceEdit(Col,Row,False,True,True);
      Key := 0;
    end;
  end;

  if ((Key = VK_ESCAPE) and WantKeyEscape) then
  begin
    with TprotectedGrid(Grid) do
    begin
      FEdit.Text := OriginalCellValue;
      SetFocus;
      HideInplaceEdit;
      Key := 0;
    end;
  end;
end;

{ TAdvGridMemo }

procedure TAdvGridMemo.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if (Msg.CharCode = VK_TAB) and FTabIsExit then
    Msg.Result := 1;
end;

procedure TAdvGridMemo.WMKeyDown(var Msg: TWMKeydown);
begin
  inherited;
end;



end.
