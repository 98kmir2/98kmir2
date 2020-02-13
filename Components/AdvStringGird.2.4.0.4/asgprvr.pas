{********************************************************************}
{ TADVPREVIEWDIALOG component                                        }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0                }
{ version 1.2                                                        }
{                                                                    }
{ written by TMS Software                                            }
{            copyright © 1998-2001                                   }
{            Email : info@tmssoftware.com                            }
{            Web : http://www.tmssoftware.com                        }
{********************************************************************}

unit asgprvr;

interface
{$I TMSDEFS.INC}
uses
  AsgPrev, Classes,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


type
  TAdvPreviewEditor = class(TComponentEditor)
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Grids', [TAdvPreviewDialog]);
  RegisterComponentEditor(TAdvPreviewDialog,TAdvPreviewEditor);
end;

procedure TAdvPreviewEditor.ExecuteVerb(Index: integer);
begin
  (Component as TAdvPreviewDialog).Execute;
end;

function TAdvPreviewEditor.GetVerb(index: integer): string;
begin
  Result := '&Execute';
end;

function TAdvPreviewEditor.GetVerbCount: integer;
begin
  Result := 1;
end;

end.



