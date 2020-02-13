{*********************************************************************}
{ TASGComboBox component for TAdvStringGrid                           }
{ for Delphi & C++Builder                                             }
{ version 1.1                                                         }
{                                                                     }
{ written by                                                          }
{  TMS Software                                                       }
{  copyright © 2001 - 2002                                            }
{  Email : info@tmssoftware.com                                       }
{  Web : http://www.tmssoftware.com                                   }
{                                                                     }
{ The source code is given as is. The author is not responsible       }
{ for any possible damage done due to the use of this code.           }
{ The component can be freely used in any application. The source     }
{ code remains property of the author and may not be distributed      }
{ freely as such.                                                     }
{*********************************************************************}

unit asgcombo;

{$I TMSDEFS.INC}

interface

uses
  Windows, Messages, Classes, Forms, Controls, Graphics, StdCtrls, SysUtils,
  AdvXPVS;

type
  TASGCustomCombo = class(TCustomComboBox)
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

  TASGComboBox = class(TASGCustomCombo)
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

{ TASGCustomCombo }

constructor TASGCustomCombo.Create(AOwner: TComponent);
begin
  inherited;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL) + 4;
  FOldColor := inherited Color;
  FOldParentColor := inherited ParentColor;
  FFlat := True;
  FMouseInControl := False;
end;

procedure TASGCustomCombo.SetButtonWidth(const Value: integer);
begin
  if (value < 14) or (value > 32) then Exit;
  FButtonWidth := Value;
  Invalidate;
end;

procedure TASGCustomCombo.SetFlat(const Value: Boolean);
begin
  if Value<>FFlat then
  begin
    FFlat := Value;
    Ctl3D := not Value;
    Invalidate;
  end;
end;

procedure TASGCustomCombo.SetEtched(const Value: Boolean);
begin
  if Value <> FEtched then
  begin
    FEtched := Value;
    Invalidate;
  end;
end;

procedure TASGCustomCombo.CMEnter(var Message: TCMEnter);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    DrawBorders;
end;

procedure TASGCustomCombo.CMExit(var Message: TCMExit);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    DrawBorders;
end;

procedure TASGCustomCombo.CMMouseEnter(var Message: TMessage);
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

procedure TASGCustomCombo.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if FMouseInControl and Enabled then
  begin
    FMouseInControl := False;
    DrawBorders;
  end;
end;

procedure TASGCustomCombo.CMEnabledChanged(var Msg: TMessage);
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

procedure TASGCustomCombo.WMNCPaint(var Message: TMessage);
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

procedure TASGCustomCombo.WMPaint(var Message: TWMPaint);
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

function TASGCustomCombo.Is3DBorderControl: Boolean;
begin
  if csDesigning in ComponentState then
    Result := False
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);

  Result := Result and FFocusBorder;
end;

function TASGCustomCombo.Is3DBorderButton: Boolean;
begin
  if csDesigning in ComponentState then
    Result := Enabled
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);
end;

procedure TASGCustomCombo.DrawButtonBorder(DC: HDC);
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

procedure TASGCustomCombo.DrawControlBorder(DC: HDC);
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

procedure TASGCustomCombo.DrawBorders;
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

procedure TASGCustomCombo.CNCommand(var Message: TWMCommand);
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


procedure TASGCustomCombo.SetDropWidth(const Value: integer);
begin
  FDropWidth := Value;
  if value > 0 then
    SendMessage(self.Handle,CB_SETDROPPEDWIDTH,FDropWidth,0);
end;

end.

