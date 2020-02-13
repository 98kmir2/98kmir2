unit FastMMTextManagementU;

interface

uses
  Classes;


type

  TGetTagStringFunc = function (const S: string): string; 

function GetSummaryTag(const S: string): string;
function GetLeakLogHeader(const S: string): string;
function GetCurrentAllocationNumberMsg(const S: string): string;
function GetCurrentObjectClassMsg(const S: string): string;
function GetCurrentStackTraceMsg(const S: string): string;
function GetStackTraceAtAllocMsg(const S: string): string;
function GetMemoryDumpMsg(const S: string): string;

implementation

uses SysUtils;


type

  TLanguageType = (ltEnglish, ltSimplifiedChinese);

{*------------------------------------------------------------------------------
  功能描述：根据文本内容，判断是中文还是英文
  创建日期：2008-03-06 00:31:23
  @author bahb
  @param S 要判断的字符串
  @return  得到的语言类型
  @Comment
  @version
  @throws
  @todo
------------------------------------------------------------------------------*}
function GetLanguageType(const S: string): TLanguageType;
var
  WS: WideString;
begin
  WS := S;
  if Length(S) = Length(WS) then Result := ltEnglish
  else Result := ltSimplifiedChinese;
end;

const
  arrResName: array[TLanguageType] of string = ('Msg_EN', 'Msg_CN');

{*------------------------------------------------------------------------------
  功能描述：从资源中获取字符串
  创建日期：2008-03-06 00:30:51
  @author bahb
  @param aLanguageType 语言类型
  @return              根据语言的类型得到的字符串
  @Comment
  @version
  @throws
  @todo
------------------------------------------------------------------------------*}
function GetMessageText(const aLanguageType: TLanguageType): string;
begin
  with TResourceStream.Create(HInstance, arrResName[aLanguageType], 'MSGTXT') do
  try
    SetLength(Result, Size);
    Read(Pointer(Result)^, Size);
  finally
    Free;
  end;
end;

function GetValue(const S: string): string;
var
  I, nPos, P: Integer;
begin
  nPos := Pos('''', S);
  P := 0;
  if nPos <> 0 then
  begin
    for I := Length(S) downto 1 do
    begin
      if S[I] = '''' then
      begin
        P := I;
        Break;
      end;
    end;
    Result := Copy(S, nPos + 1, P - nPos - 1);
  end else Result := S;
end;

{*------------------------------------------------------------------------------
  功能描述：
  创建日期：2008-03-06 00:36:51
  @author bahb
  @param S   文字内容
  @param Key Key
  @return    得到的 Value
  @Comment
  @version
  @throws
  @todo
------------------------------------------------------------------------------*}
function GetValueByKey(const S, Key: string): string;
var
  I: Integer;
  sTmp: string;
begin

  Result := '';
  
  if Pos(Key, S) <> 0 then
  begin

    with TStringList.Create do
    try
      Text := S;

      for I := 0 to Count - 1 do
      begin
        if Pos(Key, Strings[I]) <> 0 then
        begin
          if Trim(Names[I]) = Key then
          begin
            //sTmp := Trim(ValueFromIndex[I]);
            sTmp := Trim(ValueFromIndex[I]);
            sTmp := GetValue(sTmp);
            Result := sTmp;
            Break;
          end;
        end;
      end;

    finally
      Free;
    end;
  end else Result := '';

end;


function GetTagStrByParam(const S, TagName: string): string;
begin
  Result := GetValueByKey(GetMessageText(GetLanguageType(S)), TagName);
end;


function GetSummaryTag(const S: string): string;
begin
  Result := GetTagStrByParam(S, 'LeakMessageHeader');
end;


function GetLeakLogHeader(const S: string): string;
begin
  Result := GetTagStrByParam(S, 'LeakLogHeader');
end;

function GetCurrentAllocationNumberMsg(const S: string): string;
begin
  Result := GetTagStrByParam(S, 'CurrentAllocationNumberMsg');
end;


function GetCurrentObjectClassMsg(const S: string): string;
begin
  Result := GetTagStrByParam(S, 'CurrentObjectClassMsg');
end;


function GetCurrentStackTraceMsg(const S: string): string;
begin
  Result := GetTagStrByParam(S, 'CurrentStackTraceMsg');
end;


function GetStackTraceAtAllocMsg(const S: string): string;
begin
  Result := GetTagStrByParam(S, 'StackTraceAtAllocMsg');
end;


function GetMemoryDumpMsg(const S: string): string;
begin
  Result := GetTagStrByParam(S, 'MemoryDumpMsg');
end;

end.
