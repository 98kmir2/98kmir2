unit FastMMLogParserU;

interface

uses
  Classes, Contnrs, FastMMTextManagementU;


type

  TAbstractContent = class(TObject)
  private
    FContentText: TStringList;
  protected

  public
    property ContentText: TStringList read FContentText;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    function DisplayText: string; virtual;
    function LogTime: string; virtual;
  end;

  TStackTrace = class(TAbstractContent)
  private
    FContentText: string;
    FContent: TStringList;
    function GetAddress: string;
    function GetLeakInClass: string;
    function GetLineNumber: Integer;
    function GetLeakInMethod: string;
    function GetUnitName: string;
  public
    constructor Create(const ContentText: string);
    destructor Destroy; override;
    property Address: string read GetAddress;
    property UnitName: string read GetUnitName;
    property LeakInClass: string read GetLeakInClass;
    property LeakInMethod: string read GetLeakInMethod;
    property LineNumber: Integer read GetLineNumber;
    function DisplayText: String; override;

  end;


  TLeak = class(TAbstractContent)
  private
    FStrackTraceList: TObjectList;
    FSize: Integer;
    FAllocationNumber: Integer;
    FObjType: string;
    FMemoryDumpAddress: string;
    function GetSize: Integer;
    function GetAllocationNumber: Integer;
    function GetObjType: string;
    function GetValueAtTheEndOfLine(const GetTagStrFunc: TGetTagStringFunc): string;
    procedure LoadFromStrings(aStrings: TStrings);
    function GetMemoryDumpAddress: string;
    function LocateMemoryDumpHeader: Integer;
    function GetMemoryDumpHex: string;
    function GetMemoryDumpText: string;
  public
    property MemoryDumpAddress: string read GetMemoryDumpAddress; 
    property Size: Integer read GetSize;
    property AllocationNumber: Integer read GetAllocationNumber;
    property ObjType: string read GetObjType;
    property StackTraces: TObjectList read FStrackTraceList;
    constructor Create;
    destructor Destroy; override;
    function GetStackTracesText: string;
    function DisplayText: String; override;
    property MemoryDumpHex: string read GetMemoryDumpHex;
    property MemoryDumpText: string read GetMemoryDumpText;
  end;


  TSummary = class(TAbstractContent)
  private
    FMsgHint: string;
    function GetMessageHint: string;
  public
    function DisplayText: String; override;

  end;


  // 程序 ShutDown 之后，本次的完整报告
  TReport = class(TAbstractContent)
  private
    FLeakList: TObjectList;
    FSummary: TSummary;
  public
    property Summary: TSummary read FSummary;
    property Leaks: TObjectList read FLeakList;
    constructor Create;
    destructor Destroy; override;
    function DisplayText: String; override;
    function LogTime: String; override;

  end;

  TFastMMLogParser = class(TAbstractContent)
  private
    FReportList: TObjectList;
    procedure PrepareReports;
  public
    property Reports: TObjectList read FReportList;
    procedure LoadFromFile(const FileName: string);
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
  end;



implementation

uses StrUtils, SysUtils;


procedure TFastMMLogParser.Clear;
begin
  FReportList.Clear;
  ContentText.Clear;
end;

constructor TFastMMLogParser.Create;
begin
  FReportList := TObjectList.Create;
end;

destructor TFastMMLogParser.Destroy;
begin
  FReportList.Free;
  inherited;
end;

procedure TFastMMLogParser.LoadFromFile(const FileName: string);
begin

  Clear;

  ContentText.LoadFromFile(FileName);
  ContentText.Text := Trim(ContentText.Text);

  PrepareReports;

end;


{ TAbstractContent }

procedure TAbstractContent.AfterConstruction;
begin
  inherited;
  FContentText := TStringList.Create;
end;

destructor TAbstractContent.Destroy;
begin
  FContentText.Free;
  inherited;
end;

function IsSummary(Contents: TStrings): Boolean;
begin
  Result := Pos(GetSummaryTag(Contents.Text), Contents.Text) <> 0;
end;


procedure TFastMMLogParser.PrepareReports;
var
  I, J: Integer;
  aContentList: TObjectList;
  aStrList: TStringList;
  aReport: TReport;
  nStartLine: Integer;
  aLeak: TLeak;
begin
  aContentList := TObjectList.Create;

  aStrList := nil;
  try
    //遍历 Log，根据分割线，把文件分段
    for I := 0 to ContentText.Count - 1 do
    begin
      if LeftStr(ContentText[I], 3) = '---' then
      begin
        aStrList := TStringList.Create;
        aContentList.Add(aStrList);
      end;
      if aStrList <> nil then aStrList.Add(ContentText[I]);
    end;

    
    //对每一段的内容进行处理
    nStartLine := 0;
    for I := 0 to aContentList.Count - 1 do
    begin
      aStrList := TStringList(aContentList[I]);
      //如果这一段是 Summry
      if IsSummary(aStrList) then
      begin
        //创建一个 Report
        aReport := TReport.Create;
        FReportList.Add(aReport);
        //为 Report 创建相关的内容
        for J := nStartLine to I - 1 do
        begin
          //创建 Leak
          aLeak := TLeak.Create;
          aReport.FLeakList.Add(aLeak);
          aLeak.LoadFromStrings(TStringList(aContentList[J]));
        end;
        //创建 Summary
        aReport.Summary.ContentText.Assign(TStringList(aContentList[I]));
        //记录新的 Log 从哪里开始
        nStartLine := I + 1;
      end;
    end;

  finally
    aContentList.Free;
  end;
end;

function TAbstractContent.DisplayText: string;
begin

end;

function TAbstractContent.LogTime: string;
begin
  if ContentText.Count > 0 then Result := FContentText[0];
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := Trim(Result);
end;

{ TReport }

constructor TReport.Create;
begin
  FLeakList := TObjectList.Create;
  FSummary := TSummary.Create;
end;

destructor TReport.Destroy;
begin
  FLeakList.Free;
  FSummary.Free;
  inherited;
end;

function TReport.DisplayText: String;
begin
  Result := Summary.DisplayText;
end;

function TReport.LogTime: String;
begin
  Result := FSummary.LogTime;
end;

{ TSummary }

function TSummary.DisplayText: String;
begin
  if FMsgHint = '' then FMsgHint := GetMessageHint;
  Result := FMsgHint;
end;

function TSummary.GetMessageHint: string;
begin

  with TStringList.Create do
  try
    Assign(ContentText);
    Delete(0);
    Delete(0);
    Delete(Count - 1);
    Delete(Count - 1);
    Result := Trim(Text);
  finally
    Free;
  end;

end;




{ TLeak }

constructor TLeak.Create;
begin
  FStrackTraceList := TObjectList.Create;
end;

destructor TLeak.Destroy;
begin
  FStrackTraceList.Free;
  inherited;
end;

function TLeak.DisplayText: String;
begin
  Result := Format('AllocNum: %d'#13#10'Leak %d', [AllocationNumber, Size]);
end;

function TLeak.GetAllocationNumber: Integer;
var
  sRet: string;
begin
  if FAllocationNumber = 0 then
  begin
    sRet := GetValueAtTheEndOfLine(GetCurrentAllocationNumberMsg);
    FAllocationNumber := StrToIntDef(sRet, -1);
  end;
  Result := FAllocationNumber;
end;

function TLeak.GetMemoryDumpAddress: string;
begin
  if FMemoryDumpAddress = '' then
  begin
    FMemoryDumpAddress := GetValueAtTheEndOfLine(GetMemoryDumpMsg);
    FMemoryDumpAddress := StringReplace(FMemoryDumpAddress, ':', '', [rfReplaceAll]);
    FMemoryDumpAddress := Trim(FMemoryDumpAddress);
  end;
  Result := FMemoryDumpAddress;
end;

function TLeak.GetMemoryDumpHex: string;
var
  I: Integer;
  aTmpList: TStringList;
  nStartLine: Integer;
begin

  aTmpList := TStringList.Create;

  try
    nStartLine := LocateMemoryDumpHeader;

    for I := nStartLine + 1 to nStartLine + 8 do
    begin
      aTmpList.Add(ContentText[I]);
    end;

    Result := aTmpList.Text;
  finally
    aTmpList.Free;
  end;

end;

function TLeak.GetMemoryDumpText: string;
var
  I: Integer;
  aTmpList: TStringList;
  nStartLine: Integer;
begin

  aTmpList := TStringList.Create;

  try
    nStartLine := LocateMemoryDumpHeader;

    for I := nStartLine + 9 to nStartLine + 16 do
    begin
      aTmpList.Add(ContentText[I]);
    end;

    Result := aTmpList.Text;
  finally
    aTmpList.Free;
  end;

end;

function TLeak.GetObjType: string;
begin
  if FObjType = '' then
  begin
    FObjType := GetValueAtTheEndOfLine(GetCurrentObjectClassMsg);
    //FObjType := StringReplace(FObjType, ':', '', [rfReplaceAll]);
    FObjType := Trim(FObjType);
  end;
  Result := FObjType;
end;

function TLeak.GetSize: Integer;
var
  S: string;
begin
  if FSize = 0 then
  begin
    S := GetValueAtTheEndOfLine(GetLeakLogHeader);
    FSize := StrToIntDef(S, -1);
  end;
  Result := FSize;
end;

function TLeak.GetStackTracesText: string;
var
  I: Integer;
  aTmpStrList: TStringList;
  S: string;
  nStackTraceStartLine: Integer;
  nStackTraceEndLine: Integer;
begin

  nStackTraceStartLine := 0;
  nStackTraceEndLine := 0;

  aTmpStrList := TStringList.Create;
  try
    for I := 0 to ContentText.Count - 1 do
    begin
      S := ContentText[I];
      if Pos(GetStackTraceAtAllocMsg(S), S) <> 0 then nStackTraceStartLine := I;
      if Pos(GetCurrentObjectClassMsg(S), S) <> 0 then nStackTraceEndLine := I;
      //找到起始、结束位置后，即可退出该循环
      if (nStackTraceStartLine <> 0) and (nStackTraceEndLine <> 0) then Break; 

    end;

    for I := nStackTraceStartLine + 1 to nStackTraceEndLine - 1 do
    begin
      aTmpStrList.Add(ContentText[I]);
    end;

    Result := Trim(aTmpStrList.Text);

  finally
    aTmpStrList.Free;
  end;

end;

function TLeak.GetValueAtTheEndOfLine(const GetTagStrFunc: TGetTagStringFunc): string;
var
  I: Integer;
  S, sRet, sTag: WideString;
begin
  Result := '';
  with TStringList.Create do
  try
    Assign(ContentText);
    for I := 0 to Count - 1 do
    begin
      S := Strings[I];
      sTag := GetTagStrFunc(S);
      if Pos(sTag, S) > 0 then
      begin
        sRet := RightStr(S, Length(S) - Length(sTag));
        //Result := StrToIntDef(sRet, 0);
        //Result := StrToInt(sRet);
        Result := sRet;
        Break;
      end;
    end;
  finally
    Free;
  end;
end;


procedure TLeak.LoadFromStrings(aStrings: TStrings);
var
  I: Integer;
  aTmpStrList: TStringList;
begin
  ContentText.Clear;
  ContentText.AddStrings(aStrings);

  aTmpStrList := TStringList.Create;
  aTmpStrList.Text := GetStackTracesText;
  
  try
    for I := 0 to aTmpStrList.Count - 1 do
    begin
      FStrackTraceList.Add(TStackTrace.Create(aTmpStrList[I]));
    end;
  finally
    aTmpStrList.Free;
  end;

end;

function TLeak.LocateMemoryDumpHeader: Integer;
var
  I: Integer;
  S, sTag: string;
begin
  Result := -1;
  for I := 0 to ContentText.Count - 1 do
  begin
    S := ContentText[I];
    sTag := GetMemoryDumpMsg(S);
    if Pos(sTag, S) <> 0 then
    begin
      Result := I;
      Break;
    end;
  end;
end;

{ TStackTrace }

const
  STACK_TRACE_INFO_ADDRESS_INDEX = 0;
  STACK_TRACE_INFO_UNIT1_INDEX = 1;
  STACK_TRACE_INFO_UNIT2_INDEX = 2;
  STACK_TRACE_INFO_CLASS_INDEX = 3;
  STACK_TRACE_INFO_METHOD_INDEX = 4;
  STACK_TRACE_INFO_LINE_NUMBER_INDEX = 5;

constructor TStackTrace.Create(const ContentText: string);
var
  S: string;
  nPos: Integer;
begin
  FContentText := ContentText;
  FContent := TStringList.Create;

  FContentText := StringReplace(FContentText, '[', #13#10, [rfReplaceAll]);
  FContentText := StringReplace(FContentText, ']', '', [rfReplaceAll]);

  FContent.Text := FContentText;

  case FContent.Count of
    1:
      begin
        while FContent.Count < 5 do FContent.Add('');
      end;
    2:
      begin
        FContent.Insert(1, '');
        FContent.Insert(1, '');
        FContent.Add('');
      end;
    3:
      begin
        FContent.Insert(1, '');
        FContent.Add('');
      end;
    4:
      begin
        FContent.Add('');
      end;
  end;

  //拆分类名与方法名
  S := FContent[STACK_TRACE_INFO_CLASS_INDEX];
  nPos := Pos('.', S);
  if nPos <> 0 then
  begin
    FContent[STACK_TRACE_INFO_CLASS_INDEX] := LeftStr(S, nPos - 1);
    FContent.Insert(STACK_TRACE_INFO_METHOD_INDEX, RightStr(S, Length(S) - nPos));
  end else FContent.Insert(STACK_TRACE_INFO_CLASS_INDEX, ''); //插入空行作为类名

end;

destructor TStackTrace.Destroy;
begin
  FContent.Free;
  inherited;
end;

function TStackTrace.GetAddress: string;
begin
  Result := FContent[STACK_TRACE_INFO_ADDRESS_INDEX];
end;

function TStackTrace.GetLeakInClass: string;
begin
  Result := FContent[STACK_TRACE_INFO_CLASS_INDEX];
end;

function TStackTrace.GetLineNumber: Integer;
begin
  Result := StrToIntDef(FContent[STACK_TRACE_INFO_LINE_NUMBER_INDEX], -1);
end;

function TStackTrace.GetLeakInMethod: string;
begin
  Result := FContent[STACK_TRACE_INFO_METHOD_INDEX];
end;

function TStackTrace.GetUnitName: string;
var
  sDelimiter: String;
  S1, S2: string;
begin

  S1 := FContent[STACK_TRACE_INFO_UNIT1_INDEX];
  S2 := FContent[STACK_TRACE_INFO_UNIT2_INDEX];


  if (S1 = '') or (S2 = '') then sDelimiter := ''
  else sDelimiter := ', ';

  Result := FContent[STACK_TRACE_INFO_UNIT1_INDEX] + sDelimiter
          + FContent[STACK_TRACE_INFO_UNIT2_INDEX];
end;

function TStackTrace.DisplayText: String;
begin
  Result := Address;
end;

end.
