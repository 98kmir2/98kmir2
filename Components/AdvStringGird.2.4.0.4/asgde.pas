{**************************************************************************}
{ TADVSTRINGGRID DESIGN TIME EDITOR                                        }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0,4.0,5.0,6.0                  }
{ version 2.2.x.x                                                          }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright © 1996-2002                                         }
{            Email : info@tmssoftware.com                                  }
{            Web : http://www.tmssoftware.com                              }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit asgde;

interface
{$I TMSDEFS.INC}
uses
  Classes, AdvGrid,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;

type
  TAdvStringGridEditor = class(TComponentEditor)
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;

implementation

uses
  Dialogs;

procedure TAdvStringGridEditor.ExecuteVerb(Index: integer);
var
  compiler: string;
  od: TOpendialog;
begin
  case index of
  0:begin
    {$IFDEF VER100}
    compiler := 'Delphi 3';
    {$ENDIF}
    {$IFDEF VER110}
    compiler := 'C++Builder 3';
    {$ENDIF}
    {$IFDEF VER120}
    compiler := 'Delphi 4';
    {$ENDIF}
    {$IFDEF VER125}
    compiler := 'C++Builder 4';
    {$ENDIF}
    {$IFDEF VER130}
    {$IFDEF BCB}
    compiler := 'C++Builder 5';
    {$ELSE}
    compiler := 'Delphi 5';
    {$ENDIF}
    {$ENDIF}
    {$IFDEF VER140}
      {$IFDEF BCB}
      compiler := 'C++Builder 6';
      {$ELSE}
      compiler := 'Delphi 6';
      {$ENDIF}
    {$ENDIF}

    {$IFDEF VER150}
      {$IFNDEF BCB}
      compiler := 'Delphi 7';
      {$ENDIF}
    {$ENDIF}

    MessageDlg(Component.ClassName+' version '+(Component as TAdvStringGrid).VersionString+' for '+compiler+#13#10'© 1997-2002 by TMS software',
               mtinformation,[mbok],0);
    end;
  1:begin
    od := TOpenDialog.Create(nil);
    od.DefaultExt := '*.CSV';
    od.Filter := 'CSV files (*.csv)|*.csv|All files (*.*)|*.*';
    if od.Execute then
    begin
      (Component as TAdvStringGrid).SaveFixedCells:=false;
      (Component as TAdvStringGrid).LoadFromCSV(od.FileName);
    end;
    od.Free;
   end;
  2:begin
     (Component as TAdvStringGrid).Clear;
    end;
  end;
end;

function TAdvStringGridEditor.GetVerb(index: integer): string;
begin
  case index of
  0:result:='&Version';
  1:result:='&Load CSV file';
  2:result:='&Clear';
  end;
end;

function TAdvStringGridEditor.GetVerbCount: integer;
begin
  Result := 3;
end;


end.

