unit uAntiModule;

interface

uses SysUtils, Classes;

type
  TAntiModuleManager = class

    constructor Create;


// ����
// ���¼���
//
    procedure LoadModules;
    procedure ReloadModules;
      //
    function GetOrdContext;

  end;

  //�л���
  
var
  antimodule: TAntiModuleManager;

implementation

end.

