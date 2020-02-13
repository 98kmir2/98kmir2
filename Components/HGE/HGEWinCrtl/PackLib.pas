unit PackLib;
{资源包解包对象}
interface

{.$RANGECHECKS OFF}
{$WARNINGS OFF}
{$HINTS OFF}

uses
  Windows, Sysutils, Classes, HGE, inifiles;

const
  XORCODE                   = $58;
  FREEINTERVAL              = 1 * 60 * 1000; //每5分钟释放一次
type
  pTDataInfo = ^TDataInfo;
  TDataInfo = record
    Offset: DWOrd;
    Size: integer;
    Data: IResource;                    //数据缓冲，在一定时间之内重复访问，将不需要读盘
    Tick: DWOrd;
  end;

  TResLib = class
  private
    FNames: TStringList;
    FReader: TFileStream;
    FLibName: string;
    FVersion: DWOrd;
    function GetOffsets(Name: string): DWOrd;
    function LoadIndex: Boolean;
  public
    constructor Create(FileName: string);
    destructor Destroy; override;
    procedure FreeTimeoutResource;
    function Resource_Load(const FileName: string; const Size: PLongword): IResource;
    function Stream_Load(const FileName: string; const Size: PLongword): TMemoryStream;
    property Offsets[Name: string]: DWOrd read GetOffsets;
    property LibName: string read FLibName write FLibName;
  end;

  TIniConfig = class
    SectList: TStringList;
  private
    m_boNeedUpdate: Boolean;
    m_FileName: string;
    FAutoSave: Boolean;
    procedure EncodeStr(s: PChar; len: integer);
    procedure DecodeStr(s: PChar; len: integer);
    procedure CleanUp;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromIni(FileName: string): Boolean;
    function LoadFromStrings(sList: TStrings): Boolean;
    function LoadFromCfg(FileName: string): Boolean;
    function SaveToIni(FileName: string): Boolean;
    function SaveToCfg(FileName: string): Boolean;
    function GetString(Sect, key, def: string): string;
    function GetInt(Sect, key: string; def: integer): integer;
    function GetFloat(Sect, key: string; def: Double): Double;
    procedure SetString(Sect, key, val: string);
    procedure SetInt(Sect, key: string; val: integer);
    procedure SetFloat(Sect, key: string; val: Double);
    property AutoSave: Boolean read FAutoSave write FAutoSave;
  end;

implementation

uses
  pngimage;
  
{ TResLib }

constructor TResLib.Create(FileName: string);
begin
  inherited Create;
  FNames := TStringList.Create;
  FNames.Sorted := True;
  FLibName := FileName;
  try
    FReader := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    //装载索引列表
    LoadIndex;
  except
    FReader := nil;
  end;
end;

destructor TResLib.Destroy;
var
  I                         : integer;
begin
  if FReader <> nil then FReader.free;
  for I := 0 to FNames.Count - 1 do
    dispose(pTDataInfo(FNames.Objects[I]));
  FNames.free;
  inherited;
end;

procedure TResLib.FreeTimeoutResource;
var
  I                         : integer;
  Info                      : pTDataInfo;
begin
  {for I := 0 to FNames.Count - 1 do begin
    Info:=pTDataInfo(FNames.Objects[i]);
    if (Info.Data<>nil) and (TResource(Info.Data).RefCount=1) and (Integer(GetTickCount - Info.Tick)>=FREEINTERVAL) then
      Info.Data:=nil;
  end;}
end;

function TResLib.GetOffsets(Name: string): DWOrd;
var
  I                         : integer;
begin
  I := FNames.IndexOf(Name);
  if I >= 0 then
    Result := pTDataInfo(FNames.Objects[I]).Offset
  else
    Result := 0;
end;

function TResLib.LoadIndex: Boolean;
var
  Count, I, j               : integer;
  s                         : string;
  b                         : Byte;
  Data                      : pTDataInfo;
begin
  try
    //读数量
    FReader.seek(0, 0);
    FReader.Read(Count, 4);
    //获得版本号
    FReader.Read(FVersion, 4);
    FVersion := ByteSwap(FVersion);
    if FVersion < $80000000 then FReader.seek(-4, soFromCurrent); //老版本的，没有版本号
    for I := 0 to Count - 1 do begin
      FReader.Read(b, 1);
      if FReader.Position + b + 8 > FReader.Size then Break;
      setlength(s, b);
      FReader.Read(s[1], b);
      for j := 1 to length(s) do s[j] := chr(ord(s[j]) xor $58);
      New(Data);
      FReader.Read(Data^.Offset, 4);
      FReader.Read(Data^.Size, 4);
      Data^.Data := nil;
      Data^.Tick := 0;
      FNames.AddObject(s, TObject(Data));
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure LoadXPNGToBuf(Reader: TStream; var Buf: PChar; var Size: integer);
const
  IDEND                     : array[0..11] of Byte = ($00, $00, $00, $00, $49, $45, $4E, $44, $AE, $42, $60, $82);
var
  w, IM                     : Word;
  I                         : integer;
  tmpData                   : PChar;
  b                         : Byte;
  lHdr                      : TIHDRData;
  ChunkName                 : TChunkName;
  ChunkSize, ChunkCRC, AddSize: Cardinal;
  ColorType                 : Byte;
begin
  Size := 0;
  Buf := nil;
  try
    Size := 8 + SizeOf(lHdr) + 12;      //文件头+IHDR
    Buf := AllocMem(Size);
    Move(PngHeader[0], Buf[0], 8);
    //重组文件头
    Reader.Read(w, 2);
    lHdr.Width := w and $3FFF;
    IM := w shr 14;
    Reader.Read(w, 2);
    lHdr.Height := w;
    Reader.Read(b, 1);
    lHdr.BitDepth := b and $1F;
    lHdr.ColorType := b shr 5;
    ColorType := lHdr.ColorType;
    lHdr.CompressionMethod := 0;
    lHdr.FilterMethod := 0;
    lHdr.InterlaceMethod := IM;

    lHdr.Width := ByteSwap(lHdr.Width);
    lHdr.Height := ByteSwap(lHdr.Height);

    ChunkName := 'IHDR';
    ChunkSize := SizeOf(lHdr);
    ChunkSize := ByteSwap(ChunkSize);

    ChunkCRC := update_crc($FFFFFFFF, @ChunkName[0], 4);
    ChunkCRC := update_crc(ChunkCRC, @lHdr, SizeOf(lHdr)) xor $FFFFFFFF;
    ChunkCRC := ByteSwap(ChunkCRC);

    //写IHDR
    Move(ChunkSize, Buf[8], 4);         //长度   8-B     4
    Move(ChunkName[0], Buf[12], 4);     //块名   C-F     4
    Move(lHdr, Buf[16], SizeOf(lHdr));  //块数据 10-1C   13
    Move(ChunkCRC, Buf[16 + SizeOf(lHdr)], 4); //CRC    1D-20   4   含文件头总共33字节

    w := 0;
    Reader.Read(w, 1);
    for I := 0 to integer(w) - 1 do begin
      if (I = 0) and (ColorType = COLOR_PALETTE) then
        ChunkName := 'PLTE'
      else
        ChunkName := 'IDAT';
      Reader.Read(ChunkSize, 4);
      AddSize := ChunkSize + 4 + 4;     //每个数据块包括：长度4字节、名称4字节、数据体、校验码4字节。在XPNG中数据体和校验码的长度为ChunkSize
      Buf := ReallocMemory(Buf, Size + AddSize);
      ChunkSize := ByteSwap(ChunkSize - 4);
      Move(ChunkSize, Buf[Size], 4);    //长度
      Move(ChunkName[0], Buf[Size + 4], 4); //块名称
      Reader.Read(Buf[Size + 8], AddSize - 8); //块数据
      Size := Size + AddSize;
    end;
    //IEND
    Buf := ReallocMemory(Buf, Size + 12);
    Move(IDEND[0], Buf[Size], 12);
    Size := Size + 12;
  except
    if Size > 0 then FreeMem(Buf, Size);
    Size := 0;
  end;
end;

function TResLib.Resource_Load(const FileName: string; const Size: PLongword): IResource;
var
  Data                      : PChar;
  I                         : integer;
  Info                      : pTDataInfo;
  ReadSize                  : integer;
begin
  Result := nil;
  if (FileName = '') then Exit;
  I := FNames.IndexOf(FileName);
  if I < 0 then Exit;
  Info := pTDataInfo(FNames.Objects[I]);
  //if Info.Data<>nil then begin
  //  Result:=Info.Data;
  //end else begin
  FReader.seek(Info^.Offset, soFromBeginning);
  if (FVersion >= $80000000) and (uppercase(Copy(FileName, length(FileName) - 3, 4)) = '.PNG') then begin
    LoadXPNGToBuf(FReader, Data, Info^.Size);
  end else begin
    GetMem(Data, Info^.Size);
    FReader.Read(Data^, Info.Size);
  end;
  Result := TResource.Create(Data, Info^.Size);
  //  Info.Data:=Result;
  //end;
  //Info.Tick:=GetTickCount;
  if Assigned(Size) then Size^ := Info^.Size;
end;

function TResLib.Stream_Load(const FileName: string; const Size: PLongword): TMemoryStream;
var
  I                         : integer;
  Info                      : pTDataInfo;
begin
  Result := nil;
  if (FileName = '') then Exit;
  I := FNames.IndexOf(FileName);
  if I < 0 then Exit;
  Info := pTDataInfo(FNames.Objects[I]);
  FReader.seek(Info.Offset, 0);
  Result := TMemoryStream.Create;
  Result.CopyFrom(FReader, Info.Size);
  Result.seek(0, 0);
  if Assigned(Size) then
    Size^ := Info.Size;
end;

{ TIniConfig }

procedure TIniConfig.CleanUp;
var
  I, j                      : integer;
  KeyList                   : TStringList;
begin
  if m_boNeedUpdate and FAutoSave then begin
    SaveToCfg(m_FileName);
  end;
  for I := 0 to SectList.Count - 1 do begin
    KeyList := TStringList(SectList.Objects[I]);
    for j := 0 to KeyList.Count - 1 do begin
      FreeMem(PChar(KeyList.Objects[j])); //,Length(PChar(KeyList.Objects[j])));
    end;
    KeyList.free;
  end;
  SectList.Clear;
end;

constructor TIniConfig.Create;
begin
  inherited Create;
  m_boNeedUpdate := False;
  SectList := TStringList.Create;
  SectList.CaseSensitive := False;
  FAutoSave := True;
end;

procedure TIniConfig.DecodeStr(s: PChar; len: integer);
var
  I                         : integer;
begin
  for I := 0 to len - 1 do
    s[I] := chr(ord(s[I]) xor $5A);
end;

destructor TIniConfig.Destroy;
begin
  CleanUp;
  SectList.free;
  inherited;
end;

procedure TIniConfig.EncodeStr(s: PChar; len: integer);
var
  I                         : integer;
begin
  for I := 0 to len - 1 do
    s[I] := chr(ord(s[I]) xor $5A);
end;

function TIniConfig.GetFloat(Sect, key: string; def: Double): Double;
var
  s                         : string;
begin
  s := GetString(Sect, key, '');
  if s = '' then begin
    Result := def;
    if FAutoSave then SetFloat(Sect, key, def);
  end else try
    Result := StrToFloat(s);
  except
    Result := def;
  end;
end;

function TIniConfig.GetInt(Sect, key: string; def: integer): integer;
var
  s                         : string;
begin
  s := GetString(Sect, key, '');
  if s = '' then begin
    Result := def;
    if FAutoSave then SetInt(Sect, key, def);
  end else try
    Result := StrToInt(s);
  except
    Result := def;
  end;
end;

function TIniConfig.GetString(Sect, key, def: string): string;
var
  KeyList                   : TStringList;
  I                         : integer;
begin
  Result := '';
  I := SectList.IndexOf(Sect);
  if I >= 0 then begin
    KeyList := TStringList(SectList.Objects[I]);
    I := KeyList.IndexOf(key);
    if I >= 0 then
      Result := PChar(KeyList.Objects[I]);
  end;
  if Result = '' then begin
    Result := def;
    if FAutoSave then SetString(Sect, key, def);
  end;
end;

function TIniConfig.LoadFromCfg(FileName: string): Boolean;
var
  KeyList                   : TStringList;
  I, j, K, Count, KeyCount  : integer;
  b                         : Byte;
  Reader                    : TFileStream;
  Sec, key                  : string;
  Data                      : PChar;
  RandDW                    : DWOrd;
begin
  CleanUp;
  m_FileName := FileName;
  if not FileExists(FileName) then Exit;
  try
    Reader := TFileStream.Create(FileName, fmOpenRead);
  except
    Sleep(500);
    try
      Reader := TFileStream.Create(FileName, fmOpenRead);
    except
      Exit;                             //无法读取配置，有可能是网吧共享目录时，此文件正被访问
    end;
  end;
  try
    Reader.Read(RandDW, SizeOf(integer));
    Reader.Read(Count, SizeOf(integer)); //段数量
    Count := Count xor RandDW;
    for I := 0 to Count - 1 do begin
      Reader.Read(b, SizeOf(Byte));
      setlength(Sec, b);
      if b > 0 then Reader.Read(Sec[1], b); //段名
      DecodeStr(PChar(Sec), b);
      KeyList := TStringList.Create;
      KeyList.Sorted := True;
      KeyList.CaseSensitive := False;
      SectList.AddObject(Sec, KeyList);
      Reader.Read(KeyCount, SizeOf(integer)); //Key数量
      for j := 0 to KeyCount - 1 do begin
        Reader.Read(b, SizeOf(Byte));
        setlength(key, b);
        if b > 0 then Reader.Read(key[1], b); //Key名
        DecodeStr(PChar(key), length(key));
        Reader.Read(b, SizeOf(Byte));
        GetMem(Data, b + 1);
        if b > 0 then Reader.Read(Data[0], b); //Key值
        Data[b] := #0;
        DecodeStr(Data, b);
        if KeyList.IndexOf(key) < 0 then //如果不存在，则添加
          KeyList.AddObject(key, TObject(Data))
        else begin                      //已经存在，释放
          FreeMem(Data, b + 1);
        end;
      end;
    end;
  finally
    Reader.free;
  end;
end;

function TIniConfig.LoadFromStrings(sList: TStrings): Boolean;
var
  sLine, sLastSection, sSection, sKey, sValue: string;
  I, j                      : integer;
  KeyList                   : TStringList;
  Data                      : PChar;
begin
  CleanUp;
  try
    sLastSection := '';
    SectList.Sorted := True;
    KeyList := nil;
    for I := 0 to sList.Count - 1 do begin
      sLine := Trim(sList[I]);
      if (length(sLine) = 0) or (sLine[1] = ';') then Continue;
      if sLine[1] = '[' then begin      //段开始
        Delete(sLine, 1, 1);            //删除[
        Delete(sLine, length(sLine), 1); //删除]
        KeyList := TStringList.Create;
        KeyList.Sorted := True;
        SectList.AddObject(sLine, KeyList);
        Continue;
      end;
      if KeyList = nil then Continue;
      //一个键=值
      j := Pos('=', sLine);
      if j <= 1 then Continue;
      sKey := Trim(Copy(sLine, 1, j - 1));
      sValue := Trim(Copy(sLine, j + 1, length(sLine)));
      GetMem(Data, length(sValue) + 1);
      if length(sValue) > 0 then
        Move(sValue[1], Data^, length(sValue));
      Data[length(sValue)] := #0;
      KeyList.AddObject(sKey, TObject(Data));
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function TIniConfig.LoadFromIni(FileName: string): Boolean;
var
  sList                     : TStringList;
begin
  CleanUp;
  m_FileName := Copy(FileName, 1, length(FileName) - 3) + 'CFG';
  sList := TStringList.Create;
  try
    sList.LoadFromFile(FileName);
    LoadFromStrings(sList);
  finally
    sList.free;
  end;
end;

function TIniConfig.SaveToCfg(FileName: string): Boolean;
var
  Writer                    : TFileStream;
  b                         : Byte;
  s                         : string;
  I, j, K                   : integer;
  KeyList                   : TStringList;
  RandDW                    : DWOrd;
begin
  //保存数据
  if FileName = '' then Exit;
  try
    Writer := TFileStream.Create(FileName, fmCreate);
  except
    FAutoSave := False;
    Exit;
  end;
  try
    RandDW := Random(MaxInt);
    Writer.Write(RandDW, SizeOf(integer));
    K := SectList.Count;
    K := K xor RandDW;
    Writer.Write(K, SizeOf(integer));   //段的数量
    for I := 0 to SectList.Count - 1 do begin
      b := length(SectList[I]);         //段名
      Writer.Write(b, SizeOf(Byte));
      s := SectList[I];
      EncodeStr(PChar(s), length(s));
      if b > 0 then Writer.Write(s[1], b);
      KeyList := TStringList(SectList.Objects[I]);
      K := KeyList.Count;
      Writer.Write(K, SizeOf(integer)); //Key数量
      for j := 0 to KeyList.Count - 1 do begin
        b := length(KeyList[j]);
        Writer.Write(b, SizeOf(Byte));
        s := KeyList[j];
        EncodeStr(PChar(s), length(s));
        if b > 0 then Writer.Write(s[1], b); //Key名
        s := PChar(KeyList.Objects[j]);
        EncodeStr(PChar(s), length(s));
        b := length(s);
        Writer.Write(b, SizeOf(Byte));
        if b > 0 then Writer.Write(s[1], b); //Key值
        //Sleep(1);
      end;
    end;
  finally
    Writer.free;
  end;
end;

function TIniConfig.SaveToIni(FileName: string): Boolean;
var
  List                      : TStringList;
  I, j                      : integer;
  KeyList                   : TStringList;
begin
  List := TStringList.Create;
  try
    for I := 0 to SectList.Count - 1 do begin
      List.Add('[' + SectList[I] + ']');
      KeyList := TStringList(SectList.Objects[I]);
      for j := 0 to KeyList.Count - 1 do begin
        List.Add(Format('%s=%s', [KeyList[j], PChar(KeyList.Objects[j])]));
      end;
    end;
    List.SaveToFile(FileName);
  finally
    List.free;
  end;
end;

procedure TIniConfig.SetFloat(Sect, key: string; val: Double);
begin
  SetString(Sect, key, FloatToStr(val));
end;

procedure TIniConfig.SetInt(Sect, key: string; val: integer);
begin
  SetString(Sect, key, inttostr(val));
end;

procedure TIniConfig.SetString(Sect, key, val: string);
var
  KeyList                   : TStringList;
  I, j                      : integer;
  Data                      : PChar;
begin
  I := SectList.IndexOf(Sect);
  if I < 0 then begin                   //没有段，则添加
    KeyList := TStringList.Create;
    KeyList.CaseSensitive := False;
    KeyList.Sorted := True;
    I := SectList.AddObject(Sect, KeyList);
  end;
  KeyList := TStringList(SectList.Objects[I]);
  I := KeyList.IndexOf(key);
  if I < 0 then begin
    j := length(val);
    GetMem(Data, j + 1);
    if j > 0 then Move(val[1], Data^, j);
    Data[j] := #0;
    I := KeyList.AddObject(key, TObject(Data));
  end else begin
    Data := PChar(KeyList.Objects[I]);
    FreeMem(Data);
    j := length(val);
    GetMem(Data, j + 1);
    Move(val[1], Data^, j);
    Data[j] := #0;
    KeyList.Objects[I] := TObject(Data);
  end;
  m_boNeedUpdate := True;
end;

end.

