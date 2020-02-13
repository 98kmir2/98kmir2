{********************************************************************}
{ TADVGRIDPRINTSETTINGSDIALOG component & property editor            }
{ for Delphi 3.0,4.0,5.0,6. & C++Builder 3.0,4.0,5.0,6.0             }
{ version 1.3                                                        }
{                                                                    }
{ written by    Christopher Sansone, ScholarSoft                     }
{               Web : http://www.meteortech.com/ScholarSoft/         }
{ enhanced by : TMS Software                                         }
{               copyright © 1998-2002                                }
{               Email : info@tmssoftware.com                         }
{               Web : http://www.tmssoftware.com                     }
{********************************************************************}
unit asgprnr;

interface
{$I TMSDEFS.INC}
uses
  asgprint,advgrid,classes,forms,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


type
  TAdvGridPrintSettingsEditor = class(TComponentEditor)
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;

  TPrintSettingsProperty =class(TClassProperty)
  public
    function GetAttributes:TPropertyAttributes; override;
    procedure Edit; override;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Grids', [TAdvGridPrintSettingsDialog]);
  RegisterComponentEditor(TAdvGridPrintSettingsDialog,TAdvGridPrintSettingsEditor);
  RegisterPropertyEditor(TypeInfo(TPrintSettings),TAdvStringGrid,'PrintSettings',TPrintSettingsProperty);
end;


procedure TAdvGridPrintSettingsEditor.ExecuteVerb(Index: integer);
begin
 (component as TAdvGridPrintSettingsDialog).Execute;
end;

function TAdvGridPrintSettingsEditor.GetVerb(index: integer): string;
begin
  Result := '&Execute';
end;

function TAdvGridPrintSettingsEditor.GetVerbCount: integer;
begin
  Result := 1;
end;

{ TPrintSettingsProperty }

procedure TPrintSettingsProperty.Edit;
var
  Grid: TAdvStringGrid;
  Settings: TAdvGridPrintSettingsDialog;
begin
  Grid:=tadvstringgrid(getcomponent(0));
  Settings:=TAdvGridPrintSettingsDialog.Create(Application);
  Settings.Grid :=grid;
  Settings.Options:=[psBorders,psGeneral,psFonts,psDateTime,psTitle,psPages,psMargins,psSpacing,psOrientation];
  if settings.Execute then Modified;
  Settings.free;
end;

function TPrintSettingsProperty.GetAttributes: TPropertyAttributes;
begin
 result:=[paDialog];
end;


end.




