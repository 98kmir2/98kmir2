unit SafeZoneControlCustomU;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, Grobal2, Dialogs,sysUtils,strUtils,
  Spin;

type
  TftmSafeZoneControlCustom = class(TForm)
    BtnAdd: TButton;
    btnDel: TButton;
    btnSave: TButton;
    grp1: TGroupBox;
    lstTxtCustom: TListBox;
    grp2: TGroupBox;
    MemoPointArr: TMemo;
    lbl1: TLabel;
    EdtCustomID: TSpinEdit;
    lblPath: TLabel;
    lblTxt: TLabel;
    lbl2: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure lstTxtCustomClick(Sender: TObject);
  private
    { Private declarations }
    procedure setButton();
    procedure sysGetFileList(List: TStrings; SourFile,FileName: string);
  public
    procedure Open();
    { Public declarations }
  end;

var
  ftmSafeZoneControlCustom: TftmSafeZoneControlCustom;

implementation

uses M2Share;

{$R *.dfm}

procedure TftmSafeZoneControlCustom.sysGetFileList(List: TStrings; SourFile,FileName: string);
var
  S_Path: String;
  TmpList,S_FileList: TStringList;
  FileRec,SubFileRec: TSearchRec; //sysGetFileList(List,'c:\','*.doc');Listͨ��������ӵ��ļ� sysGetFileList(List,'c:\','*.doc,*.exe'); Listͨ��������Ӷ��ļ�
  I: Integer;
begin
  S_Path := IncludeTrailingPathDelimiter(Trim(SourFile));    //��ԪSysUtils���ж�ĩβ�Ƿ�����ļ���·������'\'��û�е���ȫ
  if not DirectoryExists(S_Path) then
  begin
    List.Clear;
    Exit;
  end;
  S_FileList := TStringList.Create;
  try
    S_FileList.CommaText := FileName;
    TmpList := TStringList.Create;
    for I := 0 to S_FileList.Count - 1 do
    begin
      if FindFirst(S_Path + S_FileList[I],faAnyFile,FileRec) = 0 then
      repeat
        if ((FileRec.Attr and faDirectory) <> 0) then
        begin
          if ((FileRec.Name <> '.') and (FileRec.Name <> '..')) then
            sysGetFileList(TmpList,IncludeTrailingPathDelimiter(S_Path + FileRec.Name),FileName);
        end
        else
        begin
          if ((FileRec.Attr and faDirectory) = 0) then
            //TmpList.Add(S_Path + FileRec.Name);
            TmpList.Add(FileRec.Name);
        end;
      until FindNext(FileRec) <> 0;
    end;
    FindClose(FileRec);
    if TmpList.CommaText <> '' then     //���ļ��в����·��
    begin
      if List.CommaText <> '' then
        List.CommaText := List.CommaText + List.Delimiter + TmpList.CommaText
      else
        List.CommaText := TmpList.CommaText;
    end;
  finally
    FreeAndNil(TmpList);
    FreeAndNil(S_FileList);
  end;
end;


procedure TftmSafeZoneControlCustom.setButton();
begin
 btnDel.Enabled := (lstTxtCustom.Count > 0);
end;

procedure TftmSafeZoneControlCustom.Open;
begin
  ShowModal();
end;


procedure TftmSafeZoneControlCustom.btnSaveClick(Sender: TObject);
var
  sFileName: String;
  i: Integer;
  strs: TStrings;
  bHasError: Boolean;
begin
  bHasError := False;
  sFileName := g_Config.sEnvirDir+'StartPointExDir\'+ lblTxt.Caption;
  strs := TStringList.create;
  for i:= 0 to MemoPointArr.Lines.Count - 1 do
  begin
    strs.Delimiter := ',';
    strs.DelimitedText := MemoPointArr.Lines[i];
    try
      if (StrToInt(strs[0]) >= 65535) or (StrToInt(strs[1]) >= 65535) or (StrToInt(strs[0]) <= -1) or (StrToInt(strs[1]) <= -1) then
      begin
        bHasError := True;
        break;
      end;
    except
      bHasError := True;
      break;
    end;
  end;
  strs.Free;
  
  if bHasError then
  begin
    ShowMessage('���ڴ�������ݸ�ʽ.��ȷ�����ݸ�ʽΪX,Y');
    exit;
  end;

  if Trim(lblTxt.Caption) = '' then
  begin
    ShowMessage('����ѡ�б���ļ�,�ٵ������');
    exit;
  end;
  MemoPointArr.Lines.SaveToFile(sFileName);
  setButton;
end;

procedure TftmSafeZoneControlCustom.FormCreate(Sender: TObject);
var i:Integer;
begin
 if not DirectoryExists(g_Config.sEnvirDir+'StartPointExDir') then
 begin
   ForceDirectories(g_Config.sEnvirDir+'StartPointExDir');
 end;
 LstTxtCustom.Items.Clear;
 sysGetFileList(LstTxtCustom.Items,g_Config.sEnvirDir+'StartPointExDir\','*.txt');
 setButton;
end;

procedure TftmSafeZoneControlCustom.BtnAddClick(Sender: TObject);
var
  i:Integer;
  bFound:boolean;
begin
  bFound := False;
  for i :=0 to LstTxtCustom.Count -1 do
  begin
    if UpperCase(inttostr(EdtCustomID.value)+'.txt') = UpperCase(LstTxtCustom.Items[i]) then
    begin
      bFound := True;
      LstTxtCustom.Selected[i] := True;
      break;
    end;
  end;

  if bFound then
  begin
    ShowMessage('�ñ���ļ��Ѿ������б��У��������ظ�����');
    exit;
  end
  else
  begin
    LstTxtCustom.Items.Add(inttostr(EdtCustomID.value)+'.txt');
    lstTxtCustom.Selected[lstTxtCustom.Items.Count-1] := True;
    LblTxt.Caption := inttostr(EdtCustomID.value)+'.txt';
    MemoPointArr.Clear;
  end;

  setButton;
end;

procedure TftmSafeZoneControlCustom.btnDelClick(Sender: TObject);
var i:Integer;
begin
  if lstTxtCustom.Items.Count = 0 then
  begin
    ShowMessage('����ѡ���ļ��б�����ݣ��ٵ�ɾ��');
    exit;
  end;

  if MessageBox(Handle, '��ǰɾ��������ͬʱ����ɾ���ļ�����ϵ�ļ���ȷ��Ҫɾ����', '��Ϣ��ʾ', MB_OKCANCEL + MB_ICONQUESTION) =
    IDOK then
  begin
    try
      DeleteFile(g_Config.sEnvirDir+'StartPointExDir\' + lstTxtCustom.Items[lstTxtCustom.ItemIndex]);
    except
    end;
    lstTxtCustom.DeleteSelected;
  end;
 setButton;
end;

procedure TftmSafeZoneControlCustom.lstTxtCustomClick(Sender: TObject);
begin
  if lstTxtCustom.Items.Count > 0 then
  begin
    if FileExists(g_Config.sEnvirDir+'StartPointExDir\' + lstTxtCustom.Items[lstTxtCustom.ItemIndex]) then
    begin
      MemoPointArr.Lines.LoadFromFile(g_Config.sEnvirDir+'StartPointExDir\' + lstTxtCustom.Items[lstTxtCustom.ItemIndex]);
    end
    else
    begin
      MemoPointArr.Clear;
      MemoPointArr.Lines.SaveToFile(g_Config.sEnvirDir+'StartPointExDir\' + lstTxtCustom.Items[lstTxtCustom.ItemIndex]);
    end;
    lblTxt.Caption := lstTxtCustom.Items[lstTxtCustom.itemIndex];
  end;
end;

end.
