{********************************************************************}
{ TPictureContainer component                                        }
{ for Delphi 3.0,4.0,5.0 C++Builder 3,4,5                            }
{ version 1.0                                                        }
{                                                                    }
{ written                                                            }
{   TMS Software                                                     }
{   copyright © 2001                                                 }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The component can be freely used in any application. The source    }
{ code remains property of the writer and may not be distributed     }
{ freely as such.                                                    }
{********************************************************************}

unit PictureContainerReg;

interface
{$I TMSDEFS.INC}
uses
  PictureContainer, Classes, PictureContainerDE,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS HTML', [TPictureContainer]);
  RegisterPropertyEditor(TypeInfo(TPictureCollection), TPictureContainer, 'Items', TPictureContainerProperty);
  RegisterComponentEditor(TPictureContainer, TPictureContainerDefaultEditor);
end;

end.

