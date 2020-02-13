unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.ImageList, Vcl.ImgList, Masks, FileCtrl, DropFiles, Vcl.ExtDlgs;

type
  TFrmMain = class(TForm)
    grbSetting: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    imlMain: TImageList;
    edtDestDir: TButtonedEdit;
    btnBatchConvert: TButton;
    edtSourceDir: TButtonedEdit;
    Label3: TLabel;
    cbbBmpBitType: TComboBox;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtSourceFile: TButtonedEdit;
    edtDestFile: TButtonedEdit;
    btnFileConvert: TButton;
    cbbBmpBitType2: TComboBox;
    procedure edtSourceDirRightButtonClick(Sender: TObject);
    procedure edtDestDirRightButtonClick(Sender: TObject);
    procedure btnBatchConvertClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtSourceFileRightButtonClick(Sender: TObject);
    procedure edtDestFileRightButtonClick(Sender: TObject);
    procedure btnFileConvertClick(Sender: TObject);
  private
    { Private declarations }
    FDropFiles: TDropFiles;

    function MakeSaveFileName(FileName: string): string;

    procedure SearchAndConvert(const RootPath, SavePath: string; var ConvertCount: Integer);
    procedure SaveBmpFile(const SrcFile, SavePath, FileName: string);

    procedure OnDropFiles(Sender: TObject; Files: TStrings; X, Y: Integer);

    procedure ShowMsg(Text: string; Title: string = '提示');
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  ChangeWindowMessageFilter(WM_DROPFILES, MSGFLT_ADD);
  ChangeWindowMessageFilter(WM_COPYGLOBALDATA, MSGFLT_ADD);

  FDropFiles := TDropFiles.Create(Self);
  FDropFiles.Target := edtSourceFile;
  FDropFiles.OnDropFiles := OnDropFiles;
end;

procedure TFrmMain.ShowMsg(Text, Title: string);
begin
  Application.MessageBox(PChar(Text), PChar(Title), MB_ICONINFORMATION or MB_OK);
end;

procedure TFrmMain.edtDestDirRightButtonClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory('指定保存位置', '', Dir, [sdNewUI, sdNewFolder, sdShowShares], Self) then
  begin
    edtDestDir.Text := Dir;
  end;
end;

procedure TFrmMain.edtSourceDirRightButtonClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory('指定源文件夹', '', Dir, [sdNewUI], Self) then
  begin
    edtSourceDir.Text := Dir;
  end;
end;

procedure TFrmMain.btnBatchConvertClick(Sender: TObject);
var
  SrcPath, SavePath: string;
  ConvertCount: Integer;
begin
  SrcPath := IncludeTrailingPathDelimiter(edtSourceDir.Text);

  if Length(edtDestDir.Text) = 0 then
  begin
    Showmessage('保存目录不能为空');
    Exit;
  end;

  if DirectoryExists(SrcPath) then
  begin
    SavePath := '';
    ConvertCount := 0;
    SearchAndConvert(SrcPath, SavePath, ConvertCount);
    if ConvertCount > 0 then
    begin
      ShowMsg('操作完成，共转换文件' + IntToStr(ConvertCount) + '个');
    end;
  end;
end;

procedure TFrmMain.SearchAndConvert(const RootPath, SavePath: string; var ConvertCount: Integer);
var
  SC: TSearchRec;
begin
  if FindFirst(RootPath + '*.*', faAnyFile, SC) = 0 then
  begin
    repeat
      if (SC.Name = '.') or (SC.Name = '..') then Continue;
      if SC.Attr = faDirectory then
      begin
        SearchAndConvert(RootPath + SC.Name + '\', SavePath + SC.Name + '\', ConvertCount);
      end
      else if SameText(ExtractFileExt(SC.Name), '.bmp') then
      begin
        SaveBmpFile(RootPath + SC.Name, SavePath, SC.Name);
        Inc(ConvertCount);
      end;
    until (FindNext(SC) <> 0);

    FindClose(SC);
  end;
end;

procedure TFrmMain.SaveBmpFile(const SrcFile, SavePath, FileName: string);
var
  DestPath: string;
  BmpSrc, BmpDest: TBitmap;
begin
  DestPath := IncludeTrailingPathDelimiter(edtDestDir.Text) + SavePath;
  if not DirectoryExists(DestPath) then
  begin
    ForceDirectories(DestPath);
  end;

  BmpSrc := TBitmap.Create;
  BmpDest := TBitmap.Create;
  try
    BmpSrc.LoadFromFile(SrcFile);
    BmpDest.Width := BmpSrc.Width;
    BmpDest.Height := BmpSrc.Height;

    case cbbBmpBitType.ItemIndex of
      0: BmpDest.PixelFormat := pf1bit;
      1: BmpDest.PixelFormat := pf4bit;
      2: BmpDest.PixelFormat := pf8bit;
      3: BmpDest.PixelFormat := pf15bit;
      4: BmpDest.PixelFormat := pf16bit;
      5: BmpDest.PixelFormat := pf24bit;
      6: BmpDest.PixelFormat := pf32bit;
    else
      BmpDest.PixelFormat := pf16Bit;
    end;

    BmpDest.Canvas.Draw(0, 0, BmpSrc);
    BmpDest.SaveToFile(DestPath + FileName);
  finally
    BmpSrc.Free;
    BmpDest.Free;
  end;
end;

function TFrmMain.MakeSaveFileName(FileName: string): string;
var
  FileExt: string;
begin
  FileExt := ExtractFileExt(FileName);
  FileName := Copy(FileName, 1, Length(FileName) - Length(FileExt));
  Result := FileName + '_2' + FileExt;
end;

procedure TFrmMain.OnDropFiles(Sender: TObject; Files: TStrings; X, Y: Integer);
begin
  if Files.Count > 0 then
  begin
    if SameText(ExtractFileExt(Files[0]), '.bmp') then
    begin
      edtSourceFile.Text := Files[0];

      edtDestFile.Text := MakeSaveFileName(Files[0]);
    end;
  end;
end;

procedure TFrmMain.edtSourceFileRightButtonClick(Sender: TObject);
var
  OpenDlg: TOpenPictureDialog;
begin
  OpenDlg := TOpenPictureDialog.Create(nil);
  try
    OpenDlg.Filter := 'Bitmaps (*.bmp)|*.bmp';
    if OpenDlg.Execute(Handle) then
    begin
      edtSourceFile.Text := OpenDlg.FileName;
      edtDestFile.Text := MakeSaveFileName(OpenDlg.FileName);
    end;
  finally
    OpenDlg.Free;
  end;
end;

procedure TFrmMain.edtDestFileRightButtonClick(Sender: TObject);
var
  SaveDlg: TSavePictureDialog;
begin
  SaveDlg := TSavePictureDialog.Create(nil);
  try
    SaveDlg.Filter := 'Bitmaps (*.bmp)|*.bmp';
    if SaveDlg.Execute(Handle) then
    begin
      edtDestFile.Text := SaveDlg.FileName;
    end;
  finally
    SaveDlg.Free;
  end;
end;

procedure TFrmMain.btnFileConvertClick(Sender: TObject);
var
  FileSrc, FileDest: string;
  BmpSrc, BmpDest: TBitmap;
begin
  FileSrc := edtSourceFile.Text;
  FileDest := edtDestFile.Text;

  if not FileExists(FileSrc) then
  begin
    ShowMsg('源文件不存在');
    Exit;
  end;

  if FileDest = '' then
  begin
    ShowMsg('保存目标不能为空');
    Exit;
  end;

  BmpSrc := TBitmap.Create;
  BmpDest := TBitmap.Create;
  try
    BmpSrc.LoadFromFile(FileSrc);
    BmpDest.Width := BmpSrc.Width;
    BmpDest.Height := BmpSrc.Height;

    case cbbBmpBitType2.ItemIndex of
      0: BmpDest.PixelFormat := pf1bit;
      1: BmpDest.PixelFormat := pf4bit;
      2: BmpDest.PixelFormat := pf8bit;
      3: BmpDest.PixelFormat := pf15bit;
      4: BmpDest.PixelFormat := pf16bit;
      5: BmpDest.PixelFormat := pf24bit;
      6: BmpDest.PixelFormat := pf32bit;
    else
      BmpDest.PixelFormat := pf16Bit;
    end;

    BmpDest.Canvas.Draw(0, 0, BmpSrc);
    BmpDest.SaveToFile(FileDest);
  finally
    BmpSrc.Free;
    BmpDest.Free;
  end;
end;

end.
