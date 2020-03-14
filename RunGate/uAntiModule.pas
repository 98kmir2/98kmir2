unit uAntiModule;

interface

uses SysUtils, Classes;

type
  TAntiModuleManager = class

    constructor Create;


// 加载
// 重新加载
//
    procedure LoadModules;
    procedure ReloadModules;
      //
    function GetOrdContext;

  end;

  //切换线
  
var
  antimodule: TAntiModuleManager;

implementation

end.

