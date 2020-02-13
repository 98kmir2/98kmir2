unit FastMM4OptionsEditorU;

interface

uses
  SysUtils, Classes, Contnrs;

type


  TBlockType = (btGroup, btDescription, btDefine, btOther);

  TContentBlock = class(TObject)
  private
    FContent: TStringList;
    FLineNum: Integer;
  public
    property Content: TStringList read FContent;
    property LineNumber: Integer read FLineNum write FLineNum;
    constructor Create;
    destructor Destroy; override;
    function BlockType: TBlockType;
    function Indent: Integer;
    function Valid: Boolean;
    function NeedConfig: Boolean;
  end;


  TFastMMOptionsEditor = class(TObject)
  private
    FContent: TStringList;
    FBlockList: TObjectList;
    procedure Parse;
  public
    property Blocks: TObjectList read FBlockList;
    procedure LoadFormFile(const FileName: string);
    constructor Create;
    destructor Destroy; override;
    procedure EnableLine(const LineNumber: Integer; bEnable: Boolean);
    procedure SaveToFile(const FileName: string);
  end;


implementation


{ TConditionDefineEditor }

constructor TFastMMOptionsEditor.Create;
begin
  FContent := TStringList.Create;
  FBlockList := TObjectList.Create;
end;

destructor TFastMMOptionsEditor.Destroy;
begin
  FContent.Free;
  FBlockList.Free;
  inherited;
end;

procedure TFastMMOptionsEditor.EnableLine(const LineNumber: Integer;
  bEnable: Boolean);
var
  S: string;
begin
  S := FContent[LineNumber];
  if bEnable then S := StringReplace(S, '{.$', '{$', [])
  else S := StringReplace(S, '{$', '{.$', []);
  FContent[LineNumber] := S;
end;

procedure TFastMMOptionsEditor.LoadFormFile(const FileName: string);
begin
  FContent.LoadFromFile(FileName);
  FBlockList.Clear;
  Parse;
end;


function GetBracketsCount(const S: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
  begin
    if S[I] = '{' then Result := Result + 1;
    if S[I] = '}' then Result := Result - 1;
  end;
end;


procedure TFastMMOptionsEditor.Parse;
var
  I, nSumBracketsCount: Integer;
  S: string;
  aBlock: TContentBlock;
  nIdx, nEnd: Integer;
begin
  nSumBracketsCount := 0;

//  aBlock := TContentBlock.Create;
//  FBlockList.Add(aBlock);

  nIdx := FContent.IndexOf('{Do not change anything below this line}');
  if nIdx = -1 then nEnd := FContent.Count - 1
  else nEnd := nIdx - 1;

  aBlock := nil;

  for I := 0 to nEnd do
  begin
    if nSumBracketsCount = 0 then
    begin
      aBlock := TContentBlock.Create;
      aBlock.LineNumber := I;
      FBlockList.Add(aBlock);
    end;

    S := FContent[I];
    aBlock.Content.Add(S);
    nSumBracketsCount := nSumBracketsCount + GetBracketsCount(S);

  end;
end;

procedure TFastMMOptionsEditor.SaveToFile(const FileName: string);
begin
  FContent.SaveToFile(FileName);
end;

{ TContentBlock }

function TContentBlock.BlockType: TBlockType;
var
  S: string;
begin

  S := FContent.Text;

  if (Pos('{$', S) > 0) or (Pos('{.$', S) > 0) then Result := btDefine
  else if Pos('---------', S) > 0 then Result := btGroup
  else Result := btDescription;

end;

constructor TContentBlock.Create;
begin
  FContent := TStringList.Create;
end;

destructor TContentBlock.Destroy;
begin
  FContent.Free;
  inherited;
end;


function TContentBlock.Indent: Integer;
var
  I: Integer;
  S: string;
  nBlankCount: Integer;
begin
  nBlankCount := 0;
  if Content.Count > 0 then
  begin
    S := Content[0];
    for I := 1 to Length(S) do
    begin
      if S[I] = ' ' then Inc(nBlankCount)
      else Break;
    end;
  end;
  Result := nBlankCount div 2;
end;

function TContentBlock.NeedConfig: Boolean;
var
  S: string;
begin
  S := Trim(Content.Text);

  Result := Pos('ifdef', S) + Pos('endif', S) + Pos('else', S)
          + Pos('ifudef', S) = 0;
end;

function TContentBlock.Valid: Boolean;
var
  S: string;
begin
  S := Trim(Content.Text);
  Result := Pos('{$', S) = 1;
end;

end.
