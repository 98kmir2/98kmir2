{*********************************************************************}
{ TADVSTRINGGRID component                                            }
{ for Delphi & C++Builder                                             }
{ version 2.4.x.x                                                     }
{                                                                     }
{ written by TMS Software                                             }
{            copyright © 1996-2002                                    }
{            Email : info@tmssoftware.com                             }
{            Web : http://www.tmssoftware.com                         }
{*********************************************************************}

unit ASGReg;

interface
{$I TMSDEFS.INC}
uses
  Advgrid, Classes, AsgDE, AsgCheck, AsgMemo, BaseGrid,
{$IFDEF DELPHI6_LVL}
  DesignIntf
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Grids', [TAdvStringGrid]);
  RegisterComponents('TMS Grids', [TCapitalCheck]);
  RegisterComponents('TMS Grids', [TMemoEditLink]);
  RegisterComponentEditor(TAdvStringGrid,TAdvStringGridEditor);
end;

end.

