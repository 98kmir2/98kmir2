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

{在调用SDK之前需取得与壳通信的窗口句柄，本单元initialization部分已经调用该函数}
procedure GetRegisterHandle;
{取得共15条注册相关信息，按INDEX值：
0是否注册(Y/N)，1机器信息，2注册用户，3注册信息，4软件名称（注册窗口标题）
5本次已运行多少分钟，6每隔多少分钟要求注册，7每次限制运行多少分钟
8第一次在本机使用软件的日期，格式YYYYMMDD，9限制试用日期，格式YYYYMMDD
10限制试用天数，11已运行次数，12限制试用次数，
13加壳时设置的特征整数值，14为保护密码的EPEHash值，可依此二者判断是否破解版
函数返回指定项，同时全部保存在RegisterStrings中}
function GetRegisterInfo(Index: Integer = 0): string;
{取得注册用户名称，未注册则为空，GetRegisterInfo(2)可能未注册也有值}
function GetRegisterUser: string;
{显示注册窗口}
function ShowRegisterForm: Boolean;
{在EncryptPE加密程序运行过程中不允许ProcessName指定的进程（不含.EXE）运行，
多个进程则多次调用该函数，或者用逗号隔开多个进程名}
function KillProcess(ProcessName: string): Boolean;
{取消截杀，见KillProcess}
function NotKillProcess(ProcessName: string): Boolean;
{设置加壳进程中不允许加载的模块名，可以以逗号隔开多个模块名}
function KillDLL(DllName: string): Boolean;
{获取指字字串的EPEHash值}
function EPEHash(SourceString: string): string;
{让壳去执行被加壳程序的某个函数，这个函数必须能独立执行，且无参数无返回值。
Address是函数真实地址与保护密码的HASH值前八位（不足八位则前补0）转换过来的数以及特征整数两次异或过的}
function RunFunction(Address: Cardinal): Boolean;

//以下函数要求个人开发版以上

{获取加壳时设置的数据文件的内容，可以指定从第几个字节开始读取多长内容}
function GetSavedData(From, Len: Word): Pointer;
{写入注册用户名、注册信息，与GetRegisterInfo配合可用于设计个性注册窗口}
function SetRegisterInfo(User, INFO: string): Boolean;
{改变注册窜口的界面语言元素，PLanguage指向内存（不含逗号和省略号）：
一个字节字符集，一个字节字体大小，字体名称＃0，字符串4＃0，字符串5＃0，......，字符串17＃0
如一个字符串：#134#9'宋体'#0'警告'#0'出现未知错误'＃0......'取消(&C)'#0
方便用户编写多语言程序}
function SetLanguage(PLanguage: Pointer): Boolean;
{改变注册窗口的提示、网站主页、邮件地址等信息，PHint指向内存（不含逗号）:
过期后输入框颜色转换成的字符串＃0，提示信息＃0，主页＃0，邮箱地址＃0
如一个字符串：'$0000FF'#0'请注册本软件'#0'http://www.server.com'#0'mailto:someone@server.com'#0}
function SetRegisterHint(PHint: Pointer): Boolean;
{设置注册窗口是否按XP风格显示}
function SetXPStyle(flag: Boolean): Boolean;
{按Index取值0至9分别对应操作如下：
+ - * div mod and or xor shl shr
返回值为某一操作的结果值}
function EPECaclResult(Value1, Value2: Integer; Index: Byte): Integer;

//以下函数要求企业专业版以上

{返回范围在 >=0 且 < Value 的随机整数}
function EPERandom(Value: Integer): Integer;
{按Index取值0至9分别返回：
系统版本VER_PLATFORM_WIN32S(0) VER_PLATFORM_WIN32_WINDOWS(1) VER_PLATFORM_WIN32_NT(2),
GetTickCount, GetCurrentProcess, GetCurrentProcessID, GetCurrentThread, GetCurrentThreadID,
GetActiveWindow, GetFocus, GetForegroundWindow, GetDesktopWindow}
function EPECustomValue(Index: Integer): Cardinal;

//以下函数要求企业开发版以上

{按Index取值0至9对窗口句柄aHwnd执行相关WINDOW函数判断结果：
IsWindow, IsWindowVisible, IsIconic, IsZoomed, 显示窗口, 隐藏窗口,
使窗口能与用户交互, 使窗口不能与用户交互, IsWindowEnabled, CloseWindow, DestroyWindow}
function EPEWindowFunction(Index: Integer; AHwnd: HWND): Boolean;
{申请Size大小内存空间}
function EPEGetMem(Size: Integer): Pointer;
{释放内存}
function EPEFreeMem(Buf: Pointer): Boolean;
{清空一段内存}
function EPEZeroMemory(Buf: Pointer; Size: Integer): Boolean;
{以Fill字节值填充一段内存}
function EPEFillMemory(Buf: Pointer; Size: Integer; fill: Byte): Boolean;
{内存复制}
function EPECopyMemory(Destination, Source: Pointer; Size: Integer): Boolean;
{内存移动}
function EPEMoveMemory(Destination, Source: Pointer; Size: Integer): Boolean;
{按Index取值0至5分别获得：
GetCurrentDirectory, GetWindowsDirectory, GetSystemDirectory,
GetTempPath, GetComputerName, GetUserName}
function EPESystemStr(Index: Integer): string;
{内存数据压缩}
procedure Compress(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
{压缩后的数据解压缩}
procedure Decompress(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
{字符串压缩生成新的字符串}
function StringCompress(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
{将压缩生成的字符串解压缩还原成原字符串}
function StringDecompress(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
{对一段内存数据进行加密}
procedure Encrypt(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
{对已加密数据进行解密}
procedure Decrypt(InBuf: Pointer; InBytes: Integer; var OutBuf: Pointer; var OutBytes: Integer; Password: string = '');
{对字符串进行加密生成新的字符串}
function StringEncrypt(SourceString: string; Password: string = ''; HFlag: Boolean = True): string;
{将加密生成的字符串解密还原成原字符串}
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

