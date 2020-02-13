unit MemoryManager;

interface

procedure SnapCurrMemStatToFile(Filename: string);

implementation

uses
  Windows, SysUtils, TypInfo, Dialogs;

const
  MaxCount = High(Word);

var
  OldMemMgr: TMemoryManager;
  ObjList: array[0..MaxCount] of Pointer;
  FreeInList: Integer = 0;
  GetMemCount: Integer = 0;
  FreeMemCount: Integer = 0;
  ReallocMemCount: Integer = 0;

procedure AddToList(P: Pointer);
begin
  if FreeInList > High(ObjList) then
  begin
  //MainOutMessage('�ڴ���������ָ���б�������������б�������');
    //ShowMessage('�ڴ���������ָ���б�������������б�������');//, '�ڴ���������', mb_ok);
    Exit;
  end;
  ObjList[FreeInList] := P;
  Inc(FreeInList);
end;

procedure RemoveFromList(P: Pointer);
var
  I: Integer;
begin
  for I := 0 to FreeInList - 1 do
    if ObjList[I] = P then
    begin
      Dec(FreeInList);
      Move(ObjList[I + 1], ObjList[I], (FreeInList - I) * SizeOf(Pointer));
      Exit;
    end;
end;

procedure SnapCurrMemStatToFile(Filename: string);
const
  FIELD_WIDTH = 20;
var
  OutFile: TextFile;
  I, CurrFree, BlockSize: Integer;
  HeapStatus: THeapStatus;
  Item: TObject;
  ptd: PTypeData;
  ppi: PPropInfo;

  procedure Output(Text: string; Value: integer);
  begin
    Writeln(OutFile, Text: FIELD_WIDTH, Value div 1024, ' KB(', Value, ' Byte)');
  end;

begin
  AssignFile(OutFile, Filename);
  try
    if FileExists(Filename) then
    begin
      Append(OutFile);
      Writeln(OutFile);
    end
    else
      Rewrite(OutFile);
    CurrFree := FreeInList;
    HeapStatus := GetHeapStatus; { �ֲ���״̬ }
    with HeapStatus do
    begin
      Writeln(OutFile, '===== ', ExtractFileName(ParamStr(0)), ',', DateTimeToStr(Now), ' =====');
      Writeln(OutFile);
      Output('���õ�ַ�ռ� : ', TotalAddrSpace);
      Output('δ�ύ���� : ', TotalUncommitted);
      Output('���ύ���� : ', TotalCommitted);
      Output('���в��� : ', TotalFree);
      Output('�ѷ��䲿�� : ', TotalAllocated);
      Output('ȫ��С�����ڴ�� : ', FreeSmall);
      Output('ȫ��������ڴ�� : ', FreeBig);
      Output('����δ���ڴ�� : ', Unused);
      Output('�ڴ���������� : ', Overhead);
      Writeln(OutFile, '��ַ�ռ����� : ': FIELD_WIDTH, TotalAllocated div (TotalAddrSpace div 100), '%');
    end;
    Writeln(OutFile);
    Writeln(OutFile, Format('��ǰ���� %d ���ڴ�©�� :', [GetMemCount - FreeMemCount]));
    for I := 0 to CurrFree - 1 do
    begin
      Write(OutFile, I: 4, ') ', IntToHex(Cardinal(ObjList[I]), 16), ' - ');
      BlockSize := PDWORD(DWORD(ObjList[I]) - 4)^;
      Write(OutFile, BlockSize: 4, '($' + IntToHex(BlockSize, 4) + ')�ֽ�', ' - ');
      try
        Item := TObject(ObjList[I]);
        if PTypeInfo(Item.ClassInfo).Kind <> tkClass then { type info technique }
          write(OutFile, '���Ƕ���')
        else
        begin
          ptd := GetTypeData(PTypeInfo(Item.ClassInfo));
          ppi := GetPropInfo(PTypeInfo(Item.ClassInfo), 'Name'); { �����TComponent }
          if ppi <> nil then
          begin
            write(OutFile, GetStrProp(Item, ppi));
            write(OutFile, ' : ');
          end
          else
            write(OutFile, '(δ����): ');
          Write(OutFile, Item.ClassName, ' (', ptd.ClassType.InstanceSize,
            ' �ֽ�) - In ', ptd.UnitName, '.pas');
        end
      except
        on Exception do
          write(OutFile, '���Ƕ���');
      end;
      writeln(OutFile);
    end;
  finally
    CloseFile(OutFile);
  end;
end;

function NewGetMem(Size: Integer): Pointer;
begin
  Inc(GetMemCount);
  Result := OldMemMgr.GetMem(Size);
  AddToList(Result);
end;

function NewFreeMem(P: Pointer): Integer;
begin
  Inc(FreeMemCount);
  Result := OldMemMgr.FreeMem(P);
  RemoveFromList(P);
end;

function NewReallocMem(P: Pointer; Size: Integer): Pointer;
begin
  Inc(ReallocMemCount);
  Result := OldMemMgr.ReallocMem(P, Size);
  RemoveFromList(P);
  AddToList(Result);
end;

const
  NewMemMgr: TMemoryManager = (
    GetMem: NewGetMem;
    FreeMem: NewFreeMem;
    ReallocMem: NewReallocMem);

initialization
  GetMemoryManager(OldMemMgr);
  SetMemoryManager(NewMemMgr);

finalization
  SetMemoryManager(OldMemMgr);
  if (GetMemCount - FreeMemCount) <> 0 then
    SnapCurrMemStatToFile(ExtractFileDir(ParamStr(0)) + '.\CheckMemory.Log');
end.

