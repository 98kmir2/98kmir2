{**************************************************************************}
{ HTML design time property editor interface                               }
{ for Delphi 3.0,4.0,5.0,6.0 & C++Builder 3.0, 4.0,5.0                     }
{ version 1.2                                                              }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright © 2000 - 2001                                       }
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

unit PictureContainerDE;

interface
{$I TMSDEFS.INC}
uses
  Classes,Forms,Dialogs,Controls,Windows,TypInfo,Graphics,Sysutils,
  PictureContainerProp, PictureContainer,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;

type
  TPictureContainerDefaultEditor = class(TDefaultEditor)
  protected
  {$IFNDEF DELPHI6_LVL}
    procedure EditProperty(PropertyEditor: TPropertyEditor;
                           var Continue, FreeEditor: Boolean); override;
  {$ELSE}
    procedure EditProperty(const Prop:IProperty; var Continue:Boolean); override;
  {$ENDIF}
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;

  TPictureContainerProperty = class(TClassProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
    procedure SetValue(const Value: String); override;
    function GetValue: String; override;
  end;

implementation

function TPictureContainerProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TPictureContainerProperty.Edit;
var
  ContainerEditor:TContainerEditor;

begin
  ContainerEditor := TContainerEditor.Create(Application);
  try
    ContainerEditor.PictureContainer.Items.Assign(TPictureCollection(GetOrdValue));

    ContainerEditor.UpdateList;

    if ContainerEditor.Showmodal = mrOK then
      TPictureCollection(GetOrdValue).Assign(ContainerEditor.PictureContainer.Items);

  finally
    ContainerEditor.Free;
  end;
end;

procedure TPictureContainerProperty.SetValue(const Value: String);
begin
end;

function TPictureContainerProperty.GetValue: String;
begin
  Result := '(Container)';
end;



{ THTMLDefaultEditor }
{$IFDEF DELPHI6_LVL}
procedure TPictureContainerDefaultEditor.EditProperty(const Prop:IProperty; var Continue:Boolean);
{$ELSE}
procedure TPictureContainerDefaultEditor.EditProperty(PropertyEditor: TPropertyEditor;
  var Continue, FreeEditor: Boolean);
{$ENDIF}
var
  PropName: string;
begin
 {$IFDEF DELPHI6_LVL}
  PropName := Prop.GetName;
 {$ELSE}
  PropName := PropertyEditor.GetName;
 {$ENDIF}
  if (CompareText(PropName, 'ITEMS') = 0) then
  begin
  {$IFDEF DELPHI6_LVL}
    Prop.Edit;
  {$ELSE}
    PropertyEditor.Edit;
  {$ENDIF}
    Continue := False;
  end;
end;



procedure TPictureContainerDefaultEditor.ExecuteVerb(Index: integer);
var
 compiler:string;
begin
  case Index of
  0:Edit;
  1:begin
    {$IFDEF VER100}
    Compiler := 'Delphi 3';
    {$ENDIF}
    {$IFDEF VER110}
    Compiler := 'C++Builder 3';
    {$ENDIF}
     {$IFDEF VER120}
    Compiler := 'Delphi 4';
    {$ENDIF}
    {$IFDEF VER125}
    Compiler := 'C++Builder 4';
    {$ENDIF}
    {$IFDEF VER130}
    {$IFDEF BCB}
    Compiler := 'C++Builder 5';
    {$ELSE}
    Compiler := 'Delphi 5';
    {$ENDIF}
    {$ENDIF}
    {$IFDEF VER140}
    Compiler := 'Delphi 6';
    {$ENDIF}
    MessageDlg(Component.ClassName+' for '+Compiler+#13#10#13#10'© 1999-2001 by TMS software'#13#10'http://www.tmssoftware.com',
               mtInformation,[mbok],0);
    end;
  end;
end;



function TPictureContainerDefaultEditor.GetVerb(Index: integer): string;
begin
  Result := '';
  case Index of
  0:Result := 'Container Editor';
  1:Result := 'About';
  end;
end;

function TPictureContainerDefaultEditor.GetVerbCount: integer;
begin
  Result := 2;
end;

end.
