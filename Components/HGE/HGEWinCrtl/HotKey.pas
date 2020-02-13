unit HotKey;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls;

const
  // Windows 2000/XP multimedia keys (adapted from winuser.h and renamed to avoid potential conflicts)
  // See also: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/winui/winui/WindowsUserInterface/UserInput/VirtualKeyCodes.asp
  _VK_BROWSER_BACK          = $A6;      // Browser Back key
  _VK_BROWSER_FORWARD       = $A7;      // Browser Forward key
  _VK_BROWSER_REFRESH       = $A8;      // Browser Refresh key
  _VK_BROWSER_STOP          = $A9;      // Browser Stop key
  _VK_BROWSER_SEARCH        = $AA;      // Browser Search key
  _VK_BROWSER_FAVORITES     = $AB;      // Browser Favorites key
  _VK_BROWSER_HOME          = $AC;      // Browser Start and Home key
  _VK_VOLUME_MUTE           = $AD;      // Volume Mute key
  _VK_VOLUME_DOWN           = $AE;      // Volume Down key
  _VK_VOLUME_UP             = $AF;      // Volume Up key
  _VK_MEDIA_NEXT_TRACK      = $B0;      // Next Track key
  _VK_MEDIA_PREV_TRACK      = $B1;      // Previous Track key
  _VK_MEDIA_STOP            = $B2;      // Stop Media key
  _VK_MEDIA_PLAY_PAUSE      = $B3;      // Play/Pause Media key
  _VK_LAUNCH_MAIL           = $B4;      // Start Mail key
  _VK_LAUNCH_MEDIA_SELECT   = $B5;      // Select Media key
  _VK_LAUNCH_APP1           = $B6;      // Start Application 1 key
  _VK_LAUNCH_APP2           = $B7;      // Start Application 2 key
  // Self-invented names for the extended keys
  NAME_VK_BROWSER_BACK      = 'Browser Back';
  NAME_VK_BROWSER_FORWARD   = 'Browser Forward';
  NAME_VK_BROWSER_REFRESH   = 'Browser Refresh';
  NAME_VK_BROWSER_STOP      = 'Browser Stop';
  NAME_VK_BROWSER_SEARCH    = 'Browser Search';
  NAME_VK_BROWSER_FAVORITES = 'Browser Favorites';
  NAME_VK_BROWSER_HOME      = 'Browser Start/Home';
  NAME_VK_VOLUME_MUTE       = 'Volume Mute';
  NAME_VK_VOLUME_DOWN       = 'Volume Down';
  NAME_VK_VOLUME_UP         = 'Volume Up';
  NAME_VK_MEDIA_NEXT_TRACK  = 'Next Track';
  NAME_VK_MEDIA_PREV_TRACK  = 'Previous Track';
  NAME_VK_MEDIA_STOP        = 'Stop Media';
  NAME_VK_MEDIA_PLAY_PAUSE  = 'Play/Pause Media';
  NAME_VK_LAUNCH_MAIL       = 'Start Mail';
  NAME_VK_LAUNCH_MEDIA_SELECT = 'Select Media';
  NAME_VK_LAUNCH_APP1       = 'Start Application 1';
  NAME_VK_LAUNCH_APP2       = 'Start Application 2';
  
  mmsyst                    = 'winmm.dll';
  kernel32                  = 'kernel32.dll';
  HotKeyAtomPrefix          = 'HotKeyManagerHotKey';
  ModName_Shift             = 'Shift';
  ModName_Ctrl              = 'Ctrl';
  ModName_Alt               = 'Alt';
  ModName_Win               = 'Win';
  VK2_SHIFT                 = 32;
  VK2_CONTROL               = 64;
  VK2_ALT                   = 128;
  VK2_WIN                   = 256;

var
  EnglishKeyboardLayout     : HKL;
  ShouldUnloadEnglishKeyboardLayout: Boolean;
  LocalModName_Shift        : string = ModName_Shift;
  LocalModName_Ctrl         : string = ModName_Ctrl;
  LocalModName_Alt          : string = ModName_Alt;
  LocalModName_Win          : string = ModName_Win;
  
function GetHotKey(Modifiers, Key: Word): Cardinal;
procedure SeparateHotKey(HotKey: Cardinal; var Modifiers, Key: Word);
function HotKeyToText(HotKey: Cardinal; Localized: Boolean): string;

implementation

function IsExtendedKey(Key: Word): Boolean;
begin
  Result := ((Key >= _VK_BROWSER_BACK) and (Key <= _VK_LAUNCH_APP2));
end;

function GetHotKey(Modifiers, Key: Word): Cardinal;
var
  HK                        : Cardinal;
begin
  HK := 0;
  if (Modifiers and MOD_ALT) <> 0 then
    Inc(HK, VK2_ALT);
  if (Modifiers and MOD_CONTROL) <> 0 then
    Inc(HK, VK2_CONTROL);
  if (Modifiers and MOD_SHIFT) <> 0 then
    Inc(HK, VK2_SHIFT);
  if (Modifiers and MOD_WIN) <> 0 then
    Inc(HK, VK2_WIN);
  HK := HK shl 8;
  Inc(HK, Key);
  Result := HK;
end;

function HotKeyToText(HotKey: Cardinal; Localized: Boolean): string;

  function GetExtendedVKName(Key: Word): string;
  begin
    case Key of
      _VK_BROWSER_BACK: Result := NAME_VK_BROWSER_BACK;
      _VK_BROWSER_FORWARD: Result := NAME_VK_BROWSER_FORWARD;
      _VK_BROWSER_REFRESH: Result := NAME_VK_BROWSER_REFRESH;
      _VK_BROWSER_STOP: Result := NAME_VK_BROWSER_STOP;
      _VK_BROWSER_SEARCH: Result := NAME_VK_BROWSER_SEARCH;
      _VK_BROWSER_FAVORITES: Result := NAME_VK_BROWSER_FAVORITES;
      _VK_BROWSER_HOME: Result := NAME_VK_BROWSER_HOME;
      _VK_VOLUME_MUTE: Result := NAME_VK_VOLUME_MUTE;
      _VK_VOLUME_DOWN: Result := NAME_VK_VOLUME_DOWN;
      _VK_VOLUME_UP: Result := NAME_VK_VOLUME_UP;
      _VK_MEDIA_NEXT_TRACK: Result := NAME_VK_MEDIA_NEXT_TRACK;
      _VK_MEDIA_PREV_TRACK: Result := NAME_VK_MEDIA_PREV_TRACK;
      _VK_MEDIA_STOP: Result := NAME_VK_MEDIA_STOP;
      _VK_MEDIA_PLAY_PAUSE: Result := NAME_VK_MEDIA_PLAY_PAUSE;
      _VK_LAUNCH_MAIL: Result := NAME_VK_LAUNCH_MAIL;
      _VK_LAUNCH_MEDIA_SELECT: Result := NAME_VK_LAUNCH_MEDIA_SELECT;
      _VK_LAUNCH_APP1: Result := NAME_VK_LAUNCH_APP1;
      _VK_LAUNCH_APP2: Result := NAME_VK_LAUNCH_APP2;
    else
      Result := '';
    end;
  end;

  function GetModifierNames: string;
  var
    s                       : string;
  begin
    s := '';
    if Localized then begin
      if (HotKey and $4000) <> 0 then   // scCtrl
        s := s + LocalModName_Ctrl + '+';
      if (HotKey and $2000) <> 0 then   // scShift
        s := s + LocalModName_Shift + '+';
      if (HotKey and $8000) <> 0 then   // scAlt
        s := s + LocalModName_Alt + '+';
      if (HotKey and $10000) <> 0 then
        s := s + LocalModName_Win + '+';
    end
    else begin
      if (HotKey and $4000) <> 0 then   // scCtrl
        s := s + ModName_Ctrl + '+';
      if (HotKey and $2000) <> 0 then   // scShift
        s := s + ModName_Shift + '+';
      if (HotKey and $8000) <> 0 then   // scAlt
        s := s + ModName_Alt + '+';
      if (HotKey and $10000) <> 0 then
        s := s + ModName_Win + '+';
    end;
    Result := s;
  end;

  function GetVKName(Special: Boolean): string;
  var
    scanCode                : Cardinal;
    KeyName                 : array[0..255] of Char;
    oldkl                   : HKL;
    Modifiers, Key          : Word;
  begin
    Result := '';
    if Localized then {// Local language key names} begin
      if Special then
        scanCode := (MapVirtualKey(Byte(HotKey), 0) shl 16) or (1 shl 24)
      else
        scanCode := (MapVirtualKey(Byte(HotKey), 0) shl 16);
      if scanCode <> 0 then begin
        GetKeyNameText(scanCode, KeyName, SizeOf(KeyName));
        Result := KeyName;
      end;
    end
    else {// English key names} begin
      if Special then
        scanCode := (MapVirtualKeyEx(Byte(HotKey), 0, EnglishKeyboardLayout) shl 16) or (1 shl 24)
      else
        scanCode := (MapVirtualKeyEx(Byte(HotKey), 0, EnglishKeyboardLayout) shl 16);
      if scanCode <> 0 then begin
        oldkl := GetKeyboardLayout(0);
        if oldkl <> EnglishKeyboardLayout then
          ActivateKeyboardLayout(EnglishKeyboardLayout, 0); // Set English kbd. layout
        GetKeyNameText(scanCode, KeyName, SizeOf(KeyName));
        Result := KeyName;
        if oldkl <> EnglishKeyboardLayout then begin
          if ShouldUnloadEnglishKeyboardLayout then
            UnloadKeyboardLayout(EnglishKeyboardLayout); // Restore prev. kbd. layout
          ActivateKeyboardLayout(oldkl, 0);
        end;
      end;
    end;

    if Length(Result) <= 1 then begin
      // Try the internally defined names
      SeparateHotKey(HotKey, Modifiers, Key);
      if IsExtendedKey(Key) then
        Result := GetExtendedVKName(Key);
    end;
  end;

var
  KeyName                   : string;
begin
  if HotKey = 0 then begin
    Result := '';
    Exit;
  end;
  case Byte(HotKey) of
    // PgUp, PgDn, End, Home, Left, Up, Right, Down, Ins, Del
    $21..$28, $2D, $2E: KeyName := GetVKName(True);
  else
    KeyName := GetVKName(False);
  end;
  Result := GetModifierNames + KeyName;
end;

procedure SeparateHotKey(HotKey: Cardinal; var Modifiers, Key: Word);
var
  Virtuals                  : Integer;
  v                         : Word;
  X                         : Word;
begin
  Key := Byte(HotKey);
  X := HotKey shr 8;
  Virtuals := X;
  v := 0;
  if (Virtuals and VK2_WIN) <> 0 then
    Inc(v, MOD_WIN);
  if (Virtuals and VK2_ALT) <> 0 then
    Inc(v, MOD_ALT);
  if (Virtuals and VK2_CONTROL) <> 0 then
    Inc(v, MOD_CONTROL);
  if (Virtuals and VK2_SHIFT) <> 0 then
    Inc(v, MOD_SHIFT);
  Modifiers := v;
end;

end.

