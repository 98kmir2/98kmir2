{********************************************************************}
{ TAdvGridReplaceDialog component                                    }
{ for Delphi & C++Builder                                            }
{ version 1.0                                                        }
{                                                                    }
{ written by  : TMS Software                                         }
{               copyright © 2002                                     }
{               Email : info@tmssoftware.com                         }
{               Web : http://www.tmssoftware.com                     }
{********************************************************************}

unit asgreplacer;

interface
{$I TMSDEFS.INC}
uses
  Classes, AsgReplaceDialog,
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
  RegisterComponents('TMS Grids', [TAdvGridReplaceDialog]);
end;

end.
