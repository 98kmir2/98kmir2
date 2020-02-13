unit ShareUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms;

type

  TUserRecord = record
    Bz: Byte;
    ValueSize: Integer;
    ValueBuf: Pointer;
    PassSize: Integer;
    PassBuf: Pointer;
  end;
  pUserRecord = ^TUserRecord;

{�ڵ���SDK֮ǰ��ȡ�����ͨ�ŵĴ��ھ��������Ԫinitialization�����Ѿ����øú���}
procedure GetRegisterHandle;
{ȡ�ù�15��ע�������Ϣ����INDEXֵ��
0�Ƿ�ע��(Y/N)��1������Ϣ��2ע���û���3ע����Ϣ��4������ƣ�ע�ᴰ�ڱ��⣩
5���������ж��ٷ��ӣ�6ÿ�����ٷ���Ҫ��ע�ᣬ7ÿ���������ж��ٷ���
8��һ���ڱ���ʹ����������ڣ���ʽYYYYMMDD��9�����������ڣ���ʽYYYYMMDD
10��������������11�����д�����12�������ô�����
13�ӿ�ʱ���õ���������ֵ��14Ϊ���������EPEHashֵ�������˶����ж��Ƿ��ƽ��
��������ָ���ͬʱȫ��������RegisterStrings��}
function GetRegisterInfo(Index: Integer = 0): string;
{ȡ��ע���û����ƣ�δע����Ϊ�գ�GetRegisterInfo(2)����δע��Ҳ��ֵ}
function GetRegisterUser: string;
{��ʾע�ᴰ��}
function ShowRegisterForm: Boolean;
{��EncryptPE���ܳ������й����в�����ProcessNameָ���Ľ��̣�����.EXE�����У�
����������ε��øú����������ö��Ÿ������������}
function KillProcess(ProcessName: string): Boolean;
{ȡ����ɱ����KillProcess}
function NotKillProcess(ProcessName: string): Boolean;
{���üӿǽ����в�������ص�ģ�����������Զ��Ÿ������ģ����}
function KillDLL(DllName: string): Boolean;
{��ȡָ���ִ���EPEHashֵ}
function EPEHash(SourceString: string): string;
{�ÿ�ȥִ�б��ӿǳ����ĳ��������������������ܶ���ִ�У����޲����޷���ֵ��
Address�Ǻ�����ʵ��ַ�뱣�������HASHֵǰ��λ�������λ��ǰ��0��ת�����������Լ�������������������}
function RunFunction(Address: Cardinal): Boolean;

//���º���Ҫ����˿���������

{��ȡ�ӿ�ʱ���õ������ļ������ݣ�����ָ���ӵڼ����ֽڿ�ʼ��ȡ�೤����}
function GetSavedData(From, Len: Word): Pointer;
{д��ע���û�����ע����Ϣ����GetRegisterInfo��Ͽ�������Ƹ���ע�ᴰ��}
function SetRegisterInfo(User, INFO: string): Boolean;
{�ı�ע��ܿڵĽ�������Ԫ�أ�PLanguageָ���ڴ棨�������ź�ʡ�Ժţ���
һ���ֽ��ַ�����һ���ֽ������С���������ƣ�0���ַ���4��0���ַ���5��0��......���ַ���17��0
��һ���ַ�����#134#9'����'#0'����'#0'����δ֪����'��0......'ȡ��(&C)'#0
�����û���д�����Գ���}
function SetLanguage(PLanguage: Pointer): Boolean;
{�ı�ע�ᴰ�ڵ���ʾ����վ��ҳ���ʼ���ַ����Ϣ��PHintָ���ڴ棨�������ţ�:
���ں��������ɫת���ɵ��ַ�����0����ʾ��Ϣ��0����ҳ��0�������ַ��0
��һ���ַ�����'$0000FF'#0'��ע�᱾���'#0'http://www.server.com'#0'mailto:someone@server.com'#0}
function SetRegisterHint(PHint: Pointer): Boolean;
{����ע�ᴰ���Ƿ�XP�����ʾ}
function SetXPStyle(flag: Boolean): Boolean;
{��Indexȡֵ0��9�ֱ��Ӧ�������£�
+ - * div mod and or xor shl shr
����ֵΪĳһ�����Ľ��ֵ}
function EPECaclResult(Value1, Value2: Integer; Index: Byte): Integer;

//���º���Ҫ����ҵרҵ������

{���ط�Χ�� >=0 �� < Value ���������}
function EPERandom(Value: Integer): Integer;
{��Indexȡֵ0��9�ֱ𷵻أ�
ϵͳ�汾VER_PLATFORM_WIN32S(0) VER_PLATFORM_WIN32_WINDOWS(1) VER_PLATFORM_WIN32_NT(2),
GetTickCount, GetCurrentProcess, GetCurrentProcessID, GetCurrentThread, GetCurrentThreadID,
GetActiveWindow, GetFocus, GetForegroundWindow, GetDesktopWindow}
function EPECustomValue(Index: Integer): Cardinal;

//���º���Ҫ����ҵ����������

{��Indexȡֵ0��9�Դ��ھ��aHwndִ�����WINDOW�����жϽ����
IsWindow, IsWindowVisible, IsIconic, IsZoomed, ��ʾ����, ���ش���,
ʹ���������û�����, ʹ���ڲ������û�����, IsWindowEnabled, CloseWindow, DestroyWindow}
function EPEWindowFunction(Index: Integer; AHwnd: HWND): Boolean;
{����Size��С�ڴ�ռ�}
function EPEGetMem(Size: Integer): Pointer;
{�ͷ��ڴ�}
function EPEFreeMem(Buf: Pointer): Boolean;
{���һ���ڴ�}
function EPEZeroMemory(Buf: Pointer; Size: Integer): Boolean;
{��Fill�ֽ�ֵ���һ���ڴ�}
function EPEFillMemory(Buf: Pointer; Size: Integer; fill: Byte): Boolean;
{�ڴ渴��}
function EPECopyMemory(Destination, Source: Pointer; Size: Integer): Boolean;
{�ڴ��ƶ�}
function EPEMoveMemory(Destination, Source: Pointer; Size: Integer): Boolean;
{��Indexȡֵ0��5�ֱ��ã�
GetCurrentDirectory, GetWindowsDirectory, GetSystemDirectory,
GetTempPath, GetComputerName, GetUserName}
function EPESystemStr(Index: Integer): string;
{�ڴ�����ѹ��}
procedure Compress(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
{ѹ��������ݽ�ѹ��}
procedure Decompress(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
{�ַ���ѹ�������µ��ַ���}
function StringCompress(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
{��ѹ�����ɵ��ַ�����ѹ����ԭ��ԭ�ַ���}
function StringDecompress(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
{��һ���ڴ����ݽ��м���}
procedure Encrypt(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
{���Ѽ������ݽ��н���}
procedure Decrypt(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
{���ַ������м��������µ��ַ���}
function StringEncrypt(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
{���������ɵ��ַ������ܻ�ԭ��ԭ�ַ���}
function StringDecrypt(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;

var
  Hint                      : Integer = High(Integer);
  RegisterHandle            : HWND;
  RegisterStrings           : TStringList;

implementation

procedure GetRegisterHandle;
var
  TempStr                   : string;
  i                         : Integer;
  hFileMap                  : Cardinal;
  TempP                     : ^Cardinal;
begin
  RegisterHandle := 0;
  TempStr := GetModuleName(hInstance);
  i := Pos('\', TempStr);
  while i > 0 do begin
    TempStr := Copy(TempStr, 1, i - 1) + '/' + Copy(TempStr, i + 1, Length(TempStr) - i);
    i := Pos('\', TempStr);
  end;
  TempStr := TempStr + '/' + IntToHex(GetCurrentProcessId, 8);
  hFileMap := OpenFileMapping(FILE_MAP_WRITE, False, PChar(TempStr));
  if hFileMap > 0 then begin
    TempP := MapViewOfFile(hFileMap, FILE_MAP_WRITE, 0, 0, 0);
    if TempP <> nil then begin
      RegisterHandle := TempP^;
      UnmapViewOfFile(TempP);
    end;
    CloseHandle(hFileMap);
  end;
end;

function GetRegisterInfo(Index: Integer = 0): string;
var
  i, MessageResult          : Integer;
begin
  Result := '';
  if Index = 0 then
    Result := 'N';
  if (Index = 4) and not IsLibrary then
    Result := Application.Title;
  if not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 0, 1);
    if (MessageResult <> -1) and (MessageResult <> 0) then begin
      //SetLength(Result, Length(PChar(MessageResult)));
      //CopyMemory(@Result[1], Pointer(MessageResult), Length(Result));
      Result := PChar(MessageResult);
      if RegisterStrings = nil then
        RegisterStrings := TStringList.Create;
      RegisterStrings.Text := Result;
      if (Index >= 0) and (Index < RegisterStrings.Count) then
        Result := RegisterStrings[Index]
      else
        Result := '';
      Break;
    end;
  end;
end;

function GetRegisterUser: string;
begin
  Result := '';
  if IsWindow(RegisterHandle) then
    if GetRegisterInfo = 'Y' then
      Result := RegisterStrings[2]
    else
      Result := '';
end;

function ShowRegisterForm: Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 0, 0);
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function KillProcess(ProcessName: string): Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if (ProcessName = '') or not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 88, Integer(PChar(ProcessName + #0)));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function NotKillProcess(ProcessName: string): Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if (ProcessName = '') or not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 89, Integer(PChar(ProcessName + #0)));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function KillDLL(DllName: string): Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 90, Integer(PChar(DllName + #0)));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function EPEHash(SourceString: string): string;
var
  i, MessageResult          : Integer;
begin
  Result := '';
  if not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 99, Integer(PChar(SourceString + #0)));
    if (MessageResult <> -1) and (MessageResult <> 0) then begin
      Result := PChar(MessageResult);
      Break;
    end;
  end;
end;

function RunFunction(Address: Cardinal): Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 66, Address);
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function GetSavedData(From, Len: Word): Pointer;
var
  i, MessageResult          : Integer;
begin
  Result := nil;
  if not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 77, From shl 16 + Len);
    if (MessageResult <> -1) and (MessageResult <> 0) then begin
      Result := Pointer(MessageResult);
      Break;
    end;
  end;
end;

function SetRegisterInfo(User, INFO: string): Boolean;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := False;
  if not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := $FF;
  P.ValueSize := Length(User);
  if P.ValueSize > 0 then
    P.ValueBuf := @User[1]
  else
    P.ValueBuf := nil;
  P.PassSize := Length(INFO);
  if P.PassSize > 0 then
    P.PassBuf := @INFO[1]
  else
    P.PassBuf := nil;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 100, Integer(@P));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function SetLanguage(PLanguage: Pointer): Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if not Assigned(PLanguage) or not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 1000, Integer(PLanguage));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function SetRegisterHint(PHint: Pointer): Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if not Assigned(PHint) or not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 10000, Integer(PHint));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function SetXPStyle(flag: Boolean): Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 100000, Integer(flag));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function EPECaclResult(Value1, Value2: Integer; Index: Byte): Integer;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := 0;
  if not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := Index;
  P.ValueSize := Value1;
  P.PassSize := Value2;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 5, Integer(@P));
    if MessageResult = 1 then begin
      Result := P.ValueSize;
      Break;
    end;
  end;
end;

function EPERandom(Value: Integer): Integer;
var
  i                         : Integer;
begin
  Result := 0;
  if not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    Result := SendMessage(RegisterHandle, WM_USER, 15, Value);
    if Result <> -1 then
      Break;
  end;
end;

function EPECustomValue(Index: Integer): Cardinal;
var
  i                         : Integer;
begin
  Result := 0;
  if (Index < 0) or (Index > 9) or not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    Result := Cardinal(SendMessage(RegisterHandle, WM_USER, 25, Index));
    if Result <> Cardinal(-1) then
      Break
    else
      if Index = 2 then
        Break;
  end;
end;

function EPEWindowFunction(Index: Integer; AHwnd: HWND): Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if (Index < 0) or (Index > 10) or not IsWindow(AHwnd) or not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, Index * 10 + 35, AHwnd);
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function EPEGetMem(Size: Integer): Pointer;
var
  i, MessageResult          : Integer;
begin
  Result := nil;
  if (Size <= 0) or not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 145, Size);
    if (MessageResult <> -1) and (MessageResult <> 0) then begin
      Result := Pointer(MessageResult);
      Break;
    end;
  end;
end;

function EPEFreeMem(Buf: Pointer): Boolean;
var
  i, MessageResult          : Integer;
begin
  Result := False;
  if not Assigned(Buf) or not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 155, Integer(Buf));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function EPEZeroMemory(Buf: Pointer; Size: Integer): Boolean;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := False;
  if not Assigned(Buf) or (Size <= 0) or not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := 0;
  P.ValueSize := Size;
  P.ValueBuf := Buf;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 165, Integer(@P));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function EPEFillMemory(Buf: Pointer; Size: Integer; fill: Byte): Boolean;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := False;
  if not Assigned(Buf) or (Size <= 0) or not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := 1;
  P.ValueSize := Size;
  P.ValueBuf := Buf;
  P.PassSize := fill;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 165, Integer(@P));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function EPECopyMemory(Destination, Source: Pointer; Size: Integer): Boolean;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := False;
  if not Assigned(Destination) or not Assigned(Source) or (Size <= 0) or not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := 2;
  P.PassBuf := Destination;
  P.ValueBuf := Source;
  P.ValueSize := Size;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 165, Integer(@P));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function EPEMoveMemory(Destination, Source: Pointer; Size: Integer): Boolean;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := False;
  if not Assigned(Destination) or not Assigned(Source) or (Size <= 0) or not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := 3;
  P.PassBuf := Destination;
  P.ValueBuf := Source;
  P.ValueSize := Size;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 165, Integer(@P));
    if MessageResult = 1 then begin
      Result := True;
      Break;
    end;
  end;
end;

function EPESystemStr(Index: Integer): string;
var
  i, MessageResult          : Integer;
begin
  Result := '';
  if (Index < 0) or (Index > 5) or not IsWindow(RegisterHandle) then
    Exit;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, 175, Index);
    if (MessageResult <> -1) and (MessageResult <> 0) then begin
      Result := PChar(MessageResult);
      Break;
    end;
  end;
end;

procedure Compress(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  OutBuf := nil;
  OutBytes := 0;
  if not Assigned(InBuf) or (InBytes <= 0) or not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := 0;
  P.ValueSize := InBytes;
  P.ValueBuf := InBuf;
  P.PassSize := Length(Password);
  if P.PassSize > 0 then
    P.PassBuf := @Password[1]
  else
    P.PassBuf := nil;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, Hint, Integer(@P));
    if MessageResult = 1 then begin
      try
        GetMem(OutBuf, P.ValueSize);
        OutBytes := P.ValueSize;
        CopyMemory(OutBuf, P.ValueBuf, P.ValueSize);
      except
        OutBuf := nil;
        OutBytes := 0;
      end;
      Break;
    end;
  end;
end;

procedure Decompress(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  OutBuf := nil;
  OutBytes := 0;
  if not Assigned(InBuf) or (InBytes <= 0) or not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := 1;
  P.ValueSize := InBytes;
  P.ValueBuf := InBuf;
  P.PassSize := Length(Password);
  if P.PassSize > 0 then
    P.PassBuf := @Password[1]
  else
    P.PassBuf := nil;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, Hint, Integer(@P));
    if MessageResult = 1 then begin
      try
        GetMem(OutBuf, P.ValueSize);
        OutBytes := P.ValueSize;
        CopyMemory(OutBuf, P.ValueBuf, P.ValueSize);
      except
        OutBuf := nil;
        OutBytes := 0;
      end;
      Break;
    end;
  end;
end;

function StringCompress(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := '';
  if (SourceString = '') or not IsWindow(RegisterHandle) then
    Exit;
  if HFlag then
    P.Bz := 10
  else
    P.Bz := 20;
  P.ValueSize := Length(SourceString);
  P.ValueBuf := @SourceString[1];
  P.PassSize := Length(Password);
  if P.PassSize > 0 then
    P.PassBuf := @Password[1]
  else
    P.PassBuf := nil;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, Hint, Integer(@P));
    if MessageResult = 1 then begin
      {try
        SetLength(Result, P.ValueSize);
        CopyMemory(@Result[1], P.ValueBuf, P.ValueSize);
      except
        Result := '';
      end;}
      Result := PChar(P.ValueBuf);
      Break;
    end;
  end;
end;

function StringDecompress(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := '';
  if (SourceString = '') or not IsWindow(RegisterHandle) then
    Exit;
  if HFlag then
    P.Bz := 11
  else
    P.Bz := 21;
  P.ValueSize := Length(SourceString);
  P.ValueBuf := @SourceString[1];
  P.PassSize := Length(Password);
  if P.PassSize > 0 then
    P.PassBuf := @Password[1]
  else
    P.PassBuf := nil;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, Hint, Integer(@P));
    if MessageResult = 1 then begin
      {try
        SetLength(Result, P.ValueSize);
        CopyMemory(@Result[1], P.ValueBuf, P.ValueSize);
      except
        Result := '';
      end;}
      Result := PChar(P.ValueBuf);
      Break;
    end;
  end;
end;

procedure Encrypt(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  OutBuf := nil;
  OutBytes := 0;
  if not Assigned(InBuf) or (InBytes <= 0) or not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := 100;
  P.ValueSize := InBytes;
  P.ValueBuf := InBuf;
  P.PassSize := Length(Password);
  if P.PassSize > 0 then
    P.PassBuf := @Password[1]
  else
    P.PassBuf := nil;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, Hint, Integer(@P));
    if MessageResult = 1 then begin
      try
        GetMem(OutBuf, P.ValueSize);
        OutBytes := P.ValueSize;
        CopyMemory(OutBuf, P.ValueBuf, P.ValueSize);
      except
        OutBuf := nil;
        OutBytes := 0;
      end;
      Break;
    end;
  end;
end;

procedure Decrypt(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  OutBuf := nil;
  OutBytes := 0;
  if not Assigned(InBuf) or (InBytes <= 0) or not IsWindow(RegisterHandle) then
    Exit;
  P.Bz := 101;
  P.ValueSize := InBytes;
  P.ValueBuf := InBuf;
  P.PassSize := Length(Password);
  if P.PassSize > 0 then
    P.PassBuf := @Password[1]
  else
    P.PassBuf := nil;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, Hint, Integer(@P));
    if MessageResult = 1 then begin
      try
        GetMem(OutBuf, P.ValueSize);
        OutBytes := P.ValueSize;
        CopyMemory(OutBuf, P.ValueBuf, P.ValueSize);
      except
        OutBuf := nil;
        OutBytes := 0;
      end;
      Break;
    end;
  end;
end;

function StringEncrypt(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := '';
  if (SourceString = '') or not IsWindow(RegisterHandle) then
    Exit;
  if HFlag then
    P.Bz := 110
  else
    P.Bz := 120;
  P.ValueSize := Length(SourceString);
  P.ValueBuf := @SourceString[1];
  P.PassSize := Length(Password);
  if P.PassSize > 0 then
    P.PassBuf := @Password[1]
  else
    P.PassBuf := nil;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, Hint, Integer(@P));
    if MessageResult = 1 then begin
      {try
        SetLength(Result, P.ValueSize);
        CopyMemory(@Result[1], P.ValueBuf, P.ValueSize);
      except
        Result := '';
      end;}
      Result := PChar(P.ValueBuf);
      Break;
    end;
  end;
end;

function StringDecrypt(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
var
  P                         : TUserRecord;
  i, MessageResult          : Integer;
begin
  Result := '';
  if (SourceString = '') or not IsWindow(RegisterHandle) then
    Exit;
  if HFlag then
    P.Bz := 111
  else
    P.Bz := 121;
  P.ValueSize := Length(SourceString);
  P.ValueBuf := @SourceString[1];
  P.PassSize := Length(Password);
  if P.PassSize > 0 then
    P.PassBuf := @Password[1]
  else
    P.PassBuf := nil;
  for i := 1 to 100 do begin
    MessageResult := SendMessage(RegisterHandle, WM_USER, Hint, Integer(@P));
    if MessageResult = 1 then begin
      {try
        SetLength(Result, P.ValueSize);
        CopyMemory(@Result[1], P.ValueBuf, P.ValueSize);
      except
        Result := '';
      end;}
      Result := PChar(P.ValueBuf);
      Break;
    end;
  end;
end;

initialization
  GetRegisterHandle;

finalization
  if Assigned(RegisterStrings) then
    RegisterStrings.Free;

end.

