{********************************************************************}
{ TAdvGridFindDialog component                                       }
{ for Delphi 2.0,3.0,4.0,5.0 & C++Builder 1.0,3.0,4.0,5.0            }
{ version 1.0                                                        }
{                                                                    }
{ written by  : TMS Software                                         }
{               copyright © 2001                                     }
{               Email : info@tmssoftware.com                         }
{               Web : http://www.tmssoftware.com                     }
{********************************************************************}

unit asgfindr;

interface
{$I TMSDEFS.INC}
uses
  Classes, AsgFindDialog,
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
 RegisterComponents('TMS Grids', [TAdvGridFindDialog]);
end;

end.
