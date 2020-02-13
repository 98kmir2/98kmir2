unit ShockwaveFlash;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 8291 $
// File generated on 2009-2-12 16:29:50 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\system32\Macromed\Flash\Flash9f.ocx (1)
// LIBID: {D27CDB6B-AE6D-11CF-96B8-444553540000}
// LCID: 0
// Helpfile: 
// HelpString: Shockwave Flash
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v1.0 Project3, (D:\My Documents\RAD Studio\Projects\Project3.tlb)
// Errors:
//   Hint: Parameter 'label' of IShockwaveFlash.TGotoLabel changed to 'label_'
//   Hint: Parameter 'property' of IShockwaveFlash.TSetProperty changed to 'property_'
//   Hint: Parameter 'property' of IShockwaveFlash.TGetProperty changed to 'property_'
//   Hint: Parameter 'label' of IShockwaveFlash.TCallLabel changed to 'label_'
//   Hint: Parameter 'property' of IShockwaveFlash.TSetPropertyNum changed to 'property_'
//   Hint: Parameter 'property' of IShockwaveFlash.TGetPropertyNum changed to 'property_'
//   Hint: Parameter 'property' of IShockwaveFlash.TGetPropertyAsNumber changed to 'property_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ShockwaveFlashObjectsMajorVersion = 1;
  ShockwaveFlashObjectsMinorVersion = 0;

  LIBID_ShockwaveFlashObjects: TGUID = '{D27CDB6B-AE6D-11CF-96B8-444553540000}';

  IID_IShockwaveFlash: TGUID = '{D27CDB6C-AE6D-11CF-96B8-444553540000}';
  DIID__IShockwaveFlashEvents: TGUID = '{D27CDB6D-AE6D-11CF-96B8-444553540000}';
  CLASS_ShockwaveFlash: TGUID = '{D27CDB6E-AE6D-11CF-96B8-444553540000}';
  CLASS_FlashProp: TGUID = '{1171A62F-05D2-11D1-83FC-00A0C9089C5A}';
  IID_IFlashFactory: TGUID = '{D27CDB70-AE6D-11CF-96B8-444553540000}';
  IID_IDispatchEx: TGUID = '{A6EF9860-C720-11D0-9337-00A0C90DCAA9}';
  IID_IFlashObjectInterface: TGUID = '{D27CDB72-AE6D-11CF-96B8-444553540000}';
  IID_IServiceProvider: TGUID = '{6D5140C1-7436-11CE-8034-00AA006009FA}';
  CLASS_FlashObjectInterface: TGUID = '{D27CDB71-AE6D-11CF-96B8-444553540000}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IShockwaveFlash = interface;
  IShockwaveFlashDisp = dispinterface;
  _IShockwaveFlashEvents = dispinterface;

  IShockwaveFlashEvents = interface;
  IFlashFactory = interface;
  IDispatchEx = interface;
  IFlashObjectInterface = interface;
  IServiceProvider = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
 // ShockwaveFlash       = IShockwaveFlash;
  FlashProp            = IUnknown;
  FlashObjectInterface = IFlashObjectInterface;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PUserType1 = ^DISPPARAMS; {*}
  PSYSUINT1 = ^SYSUINT; {*}
  PUserType2 = ^TGUID; {*}


// *********************************************************************//
// Interface: IShockwaveFlash
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D27CDB6C-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IShockwaveFlash = interface(IDispatch)
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    function Get_ReadyState: Integer; safecall;
    function Get_TotalFrames: Integer; safecall;
    function Get_Playing: WordBool; safecall;
    procedure Set_Playing(pVal: WordBool); safecall;
    function Get_Quality: SYSINT; safecall;
    procedure Set_Quality(pVal: SYSINT); safecall;
    function Get_ScaleMode: SYSINT; safecall;
    procedure Set_ScaleMode(pVal: SYSINT); safecall;
    function Get_AlignMode: SYSINT; safecall;
    procedure Set_AlignMode(pVal: SYSINT); safecall;
    function Get_BackgroundColor: Integer; safecall;
    procedure Set_BackgroundColor(pVal: Integer); safecall;
    function Get_Loop: WordBool; safecall;
    procedure Set_Loop(pVal: WordBool); safecall;
    function Get_Movie: WideString; safecall;
    procedure Set_Movie(const pVal: WideString); safecall;
    function Get_FrameNum: Integer; safecall;
    procedure Set_FrameNum(pVal: Integer); safecall;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); safecall;
    procedure Zoom(factor: SYSINT); safecall;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); safecall;
    procedure Play; safecall;
    procedure Stop; safecall;
    procedure Back; safecall;
    procedure Forward; safecall;
    procedure Rewind; safecall;
    procedure StopPlay; safecall;
    procedure GotoFrame(FrameNum: Integer); safecall;
    function CurrentFrame: Integer; safecall;
    function IsPlaying: WordBool; safecall;
    function PercentLoaded: Integer; safecall;
    function FrameLoaded(FrameNum: Integer): WordBool; safecall;
    function FlashVersion: Integer; safecall;
    function Get_WMode: WideString; safecall;
    procedure Set_WMode(const pVal: WideString); safecall;
    function Get_SAlign: WideString; safecall;
    procedure Set_SAlign(const pVal: WideString); safecall;
    function Get_Menu: WordBool; safecall;
    procedure Set_Menu(pVal: WordBool); safecall;
    function Get_Base: WideString; safecall;
    procedure Set_Base(const pVal: WideString); safecall;
    function Get_Scale: WideString; safecall;
    procedure Set_Scale(const pVal: WideString); safecall;
    function Get_DeviceFont: WordBool; safecall;
    procedure Set_DeviceFont(pVal: WordBool); safecall;
    function Get_EmbedMovie: WordBool; safecall;
    procedure Set_EmbedMovie(pVal: WordBool); safecall;
    function Get_BGColor: WideString; safecall;
    procedure Set_BGColor(const pVal: WideString); safecall;
    function Get_Quality2: WideString; safecall;
    procedure Set_Quality2(const pVal: WideString); safecall;
    procedure LoadMovie(layer: SYSINT; const url: WideString); safecall;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); safecall;
    procedure TGotoLabel(const target: WideString; const label_: WideString); safecall;
    function TCurrentFrame(const target: WideString): Integer; safecall;
    function TCurrentLabel(const target: WideString): WideString; safecall;
    procedure TPlay(const target: WideString); safecall;
    procedure TStopPlay(const target: WideString); safecall;
    procedure SetVariable(const name: WideString; const value: WideString); safecall;
    function GetVariable(const name: WideString): WideString; safecall;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); safecall;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; safecall;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); safecall;
    procedure TCallLabel(const target: WideString; const label_: WideString); safecall;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); safecall;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; safecall;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; safecall;
    function Get_SWRemote: WideString; safecall;
    procedure Set_SWRemote(const pVal: WideString); safecall;
    function Get_FlashVars: WideString; safecall;
    procedure Set_FlashVars(const pVal: WideString); safecall;
    function Get_AllowScriptAccess: WideString; safecall;
    procedure Set_AllowScriptAccess(const pVal: WideString); safecall;
    property ReadyState: Integer read Get_ReadyState;
    property TotalFrames: Integer read Get_TotalFrames;
    property Playing: WordBool read Get_Playing write Set_Playing;
    property Quality: SYSINT read Get_Quality write Set_Quality;
    property ScaleMode: SYSINT read Get_ScaleMode write Set_ScaleMode;
    property AlignMode: SYSINT read Get_AlignMode write Set_AlignMode;
    property BackgroundColor: Integer read Get_BackgroundColor write Set_BackgroundColor;
    property Loop: WordBool read Get_Loop write Set_Loop;
    property Movie: WideString read Get_Movie write Set_Movie;
    property FrameNum: Integer read Get_FrameNum write Set_FrameNum;
    property WMode: WideString read Get_WMode write Set_WMode;
    property SAlign: WideString read Get_SAlign write Set_SAlign;
    property Menu: WordBool read Get_Menu write Set_Menu;
    property Base: WideString read Get_Base write Set_Base;
    property Scale: WideString read Get_Scale write Set_Scale;
    property DeviceFont: WordBool read Get_DeviceFont write Set_DeviceFont;
    property EmbedMovie: WordBool read Get_EmbedMovie write Set_EmbedMovie;
    property BGColor: WideString read Get_BGColor write Set_BGColor;
    property Quality2: WideString read Get_Quality2 write Set_Quality2;
    property SWRemote: WideString read Get_SWRemote write Set_SWRemote;
    property FlashVars: WideString read Get_FlashVars write Set_FlashVars;
    property AllowScriptAccess: WideString read Get_AllowScriptAccess write Set_AllowScriptAccess;
  end;

// *********************************************************************//
// DispIntf:  IShockwaveFlashDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D27CDB6C-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IShockwaveFlashDisp = dispinterface
    ['{D27CDB6C-AE6D-11CF-96B8-444553540000}']
    property ReadyState: Integer readonly dispid -525;
    property TotalFrames: Integer readonly dispid 124;
    property Playing: WordBool dispid 125;
    property Quality: SYSINT dispid 105;
    property ScaleMode: SYSINT dispid 120;
    property AlignMode: SYSINT dispid 121;
    property BackgroundColor: Integer dispid 123;
    property Loop: WordBool dispid 106;
    property Movie: WideString dispid 102;
    property FrameNum: Integer dispid 107;
    procedure SetZoomRect(left: Integer; top: Integer; right: Integer; bottom: Integer); dispid 109;
    procedure Zoom(factor: SYSINT); dispid 118;
    procedure Pan(x: Integer; y: Integer; mode: SYSINT); dispid 119;
    procedure Play; dispid 112;
    procedure Stop; dispid 113;
    procedure Back; dispid 114;
    procedure Forward; dispid 115;
    procedure Rewind; dispid 116;
    procedure StopPlay; dispid 126;
    procedure GotoFrame(FrameNum: Integer); dispid 127;
    function CurrentFrame: Integer; dispid 128;
    function IsPlaying: WordBool; dispid 129;
    function PercentLoaded: Integer; dispid 130;
    function FrameLoaded(FrameNum: Integer): WordBool; dispid 131;
    function FlashVersion: Integer; dispid 132;
    property WMode: WideString dispid 133;
    property SAlign: WideString dispid 134;
    property Menu: WordBool dispid 135;
    property Base: WideString dispid 136;
    property Scale: WideString dispid 137;
    property DeviceFont: WordBool dispid 138;
    property EmbedMovie: WordBool dispid 139;
    property BGColor: WideString dispid 140;
    property Quality2: WideString dispid 141;
    procedure LoadMovie(layer: SYSINT; const url: WideString); dispid 142;
    procedure TGotoFrame(const target: WideString; FrameNum: Integer); dispid 143;
    procedure TGotoLabel(const target: WideString; const label_: WideString); dispid 144;
    function TCurrentFrame(const target: WideString): Integer; dispid 145;
    function TCurrentLabel(const target: WideString): WideString; dispid 146;
    procedure TPlay(const target: WideString); dispid 147;
    procedure TStopPlay(const target: WideString); dispid 148;
    procedure SetVariable(const name: WideString; const value: WideString); dispid 151;
    function GetVariable(const name: WideString): WideString; dispid 152;
    procedure TSetProperty(const target: WideString; property_: SYSINT; const value: WideString); dispid 153;
    function TGetProperty(const target: WideString; property_: SYSINT): WideString; dispid 154;
    procedure TCallFrame(const target: WideString; FrameNum: SYSINT); dispid 155;
    procedure TCallLabel(const target: WideString; const label_: WideString); dispid 156;
    procedure TSetPropertyNum(const target: WideString; property_: SYSINT; value: Double); dispid 157;
    function TGetPropertyNum(const target: WideString; property_: SYSINT): Double; dispid 158;
    function TGetPropertyAsNumber(const target: WideString; property_: SYSINT): Double; dispid 172;
    property SWRemote: WideString dispid 159;
    property FlashVars: WideString dispid 170;
    property AllowScriptAccess: WideString dispid 171;
  end;

// *********************************************************************//
// DispIntf:  _IShockwaveFlashEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {D27CDB6D-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IShockwaveFlashEvents = interface(IDispatch)
    ['{D27CDB6D-AE6D-11CF-96B8-444553540000}']
    function OnReadyStateChange(newState: Integer):HResult ; safecall;
    function OnProgress(percentDone: Integer):HResult; safecall;
    function FSCommand(const command: WideString; const args: WideString):HResult; safecall;
  end;


// *********************************************************************//
// DispIntf:  _IShockwaveFlashEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {D27CDB6D-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  _IShockwaveFlashEvents = dispinterface
    ['{D27CDB6D-AE6D-11CF-96B8-444553540000}']
    procedure OnReadyStateChange(newState: Integer); dispid -609;
    procedure OnProgress(percentDone: Integer); dispid 1958;
    procedure FSCommand(const command: WideString; const args: WideString); dispid 150;
  end;

// *********************************************************************//
// Interface: IFlashFactory
// Flags:     (0)
// GUID:      {D27CDB70-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IFlashFactory = interface(IUnknown)
    ['{D27CDB70-AE6D-11CF-96B8-444553540000}']
  end;

// *********************************************************************//
// Interface: IDispatchEx
// Flags:     (4096) Dispatchable
// GUID:      {A6EF9860-C720-11D0-9337-00A0C90DCAA9}
// *********************************************************************//
  IDispatchEx = interface(IDispatch)
    ['{A6EF9860-C720-11D0-9337-00A0C90DCAA9}']
    function GetDispID(const bstrName: WideString; grfdex: LongWord; out pid: Integer): HResult; stdcall;
    function RemoteInvokeEx(id: Integer; lcid: LongWord; dwFlags: LongWord; var pdp: DISPPARAMS; 
                            out pvarRes: OleVariant; out pei: EXCEPINFO; 
                            const pspCaller: IServiceProvider; cvarRefArg: SYSUINT; 
                            var rgiRefArg: SYSUINT; var rgvarRefArg: OleVariant): HResult; stdcall;
    function DeleteMemberByName(const bstrName: WideString; grfdex: LongWord): HResult; stdcall;
    function DeleteMemberByDispID(id: Integer): HResult; stdcall;
    function GetMemberProperties(id: Integer; grfdexFetch: LongWord; out pgrfdex: LongWord): HResult; stdcall;
    function GetMemberName(id: Integer; out pbstrName: WideString): HResult; stdcall;
    function GetNextDispID(grfdex: LongWord; id: Integer; out pid: Integer): HResult; stdcall;
    function GetNameSpaceParent(out ppunk: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFlashObjectInterface
// Flags:     (4096) Dispatchable
// GUID:      {D27CDB72-AE6D-11CF-96B8-444553540000}
// *********************************************************************//
  IFlashObjectInterface = interface(IDispatchEx)
    ['{D27CDB72-AE6D-11CF-96B8-444553540000}']
  end;

// *********************************************************************//
// Interface: IServiceProvider
// Flags:     (0)
// GUID:      {6D5140C1-7436-11CE-8034-00AA006009FA}
// *********************************************************************//
  IServiceProvider = interface(IUnknown)
    ['{6D5140C1-7436-11CE-8034-00AA006009FA}']
    function RemoteQueryService(var guidService: TGUID; var riid: TGUID; out ppvObject: IUnknown): HResult; stdcall;
  end;

implementation

uses ComObj;

end.
