{********************************************************************}
{ TAdvGridHTMLSettingsDialog component                               }
{ for Delphi 3.0,4.0,5.0 & C++Builder 3.0,4.0,5.0                    }
{ version 1.2                                                        }
{                                                                    }
{ written by    Christopher Sansone, ScholarSoft                     }
{               Web : http://www.meteortech.com/ScholarSoft/         }
{ enhanced by : TMS Software                                         }
{               copyright © 1998-2001                                }
{               Email : info@tmssoftware.com                         }
{               Web : http://www.tmssoftware.com                     }
{********************************************************************}

unit asghtmlr;

interface
{$I TMSDEFS.INC}
uses
  Classes,AdvGrid,AsgHtml,Forms,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;



type
  TAdvGridHTMLSettingsEditor = class(TComponentEditor)
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;

  THTMLSettingsProperty =class(TClassProperty)
  public
    function GetAttributes:TPropertyAttributes; override;
    procedure Edit; override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Grids', [TAdvGridHTMLSettingsDialog]);
  RegisterComponentEditor(TAdvGridHTMLSettingsDialog,TAdvGridHTMLSettingsEditor);
  RegisterPropertyEditor(TypeInfo(THTMLSettings),TAdvStringGrid,'HTMLSettings',THTMLSettingsProperty);
end;

procedure TAdvGridHTMLSettingsEditor.ExecuteVerb(Index: integer);
begin
  (Component as TAdvGridHTMLSettingsDialog).Execute;
end;

function TAdvGridHTMLSettingsEditor.GetVerb(index: integer): string;
begin
  Result := '&Execute';
end;

function TAdvGridHTMLSettingsEditor.GetVerbCount: integer;
begin
  Result := 1;
end;

procedure THTMLSettingsProperty.Edit;
var
  Grid: TAdvStringGrid;
  Settings: TAdvGridHTMLSettingsDialog;
begin
  Grid := TAdvStringGrid(Getcomponent(0));
  Settings := TAdvGridHTMLSettingsDialog.Create(Application);
  Settings.Grid := Grid;
  if Settings.Execute then
    Modified;
  Settings.Free;
end;

function THTMLSettingsProperty.GetAttributes: TPropertyAttributes;
begin
 result:=[paDialog];
end;




end.
