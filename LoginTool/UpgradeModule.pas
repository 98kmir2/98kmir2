unit UpgradeModule;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, IdComponent, IdHTTP, Registry, IniFiles,
  StdCtrls, ExtCtrls, ComCtrls, VCLUnZip, IdHashMessageDigest, IdGlobal, IdHash, VMProtectSDK;

type
  TStartThread = class(TThread)
  private
    MemoryStream: TMemoryStream;
    procedure IdHTTPDownLoadWorkBegin(Sender: TObject; AWorkMode: TWorkMode; {$IFDEF VER185}{$ELSE}const{$ENDIF}AWorkCountMax: Integer);
    procedure IdHTTPDownLoadWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure IdHTTPDownLoadWork(Sender: TObject; AWorkMode: TWorkMode; {$IFDEF VER185}{$ELSE}const{$ENDIF}AWorkCount: Integer);
    { Private declarations }
  protected
    procedure Execute; override;
  public
    destructor Destroy; override;
    procedure StartUpgThread;
  end;

function GetStatusText(): string;
procedure SetStatusText(sMsg: string);

var
  CriticalSection: TRTLCriticalSection;
  sStatusText: string;
  StartThread: TStartThread;
  nCount: Integer;
  nWorkCountMax: Integer;
  nWorkCountCur: Integer;
  nDownFileIdx: Integer;

  sCurDownLoadSite: string;
  sCurDownLoadFile: string;
  sRealDownLoadFile: string;
  DownList: TList;
  sSelfFileName: string;
  sSelfFileName_Bin: string;
  boUpdateBusy: Boolean;

  gamemodulemd5: string;
  bIsExcept: Boolean;
implementation

uses
  HUtil32, LShare, {__DESUnit,} EDcode, MsgBox, LMain, MD5;

function ExtractWebFileName(const FileName: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('/' + DriveDelim, FileName);
  Result := Copy(FileName, I + 1, MaxInt);
end;

function GetStatusText(): string;
begin
  EnterCriticalSection(CriticalSection);
  try
    Result := sStatusText;
  finally
    LeaveCriticalSection(CriticalSection);
  end;
end;

procedure SetStatusText(sMsg: string);
begin
  EnterCriticalSection(CriticalSection);
  try
    sStatusText := sMsg;
  finally
    LeaveCriticalSection(CriticalSection);
  end;
end;

{ TStartThread }

destructor TStartThread.Destroy;
begin
  MemoryStream.Free;
  inherited;
end;

procedure TStartThread.StartUpgThread;
begin

end;

procedure TStartThread.Execute;
var
  I: Integer;
  IdHTTPDownLoad: TIdHTTP;
  IdHTTGetMD5: TIdHTTP;
  sFileMD5: string;
  sLineText: string;
  sFileName: string;
  sDownFileName: string;
  sCheckFileName: string;
  sDownSite: string;
  d, DownSoft: pTDownSoft;
  VCLUnZip1: TVCLUnZip;
  outsteam: TMemoryStream;
  bExcept: Boolean;
  temp: TMemoryStream;
  strmd5: string;
begin
  exit;
  Sleep(250);
  IdHTTPDownLoad := TIdHTTP.Create(nil);
  //IdHTTPDownLoad.AllowCookies := False;
  //IdHTTPDownLoad.HTTPOptions := IdHTTPDownLoad.HTTPOptions + [hoKeepOrigProtocol];
  //IdHTTPDownLoad.ProtocolVersion := pv1_0;
  //IdHTTPDownLoad.Request.Accept := 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/msword, */*';

  IdHTTPDownLoad.ReadTimeout := 60 * 1000;
  IdHTTPDownLoad.OnWorkBegin := IdHTTPDownLoadWorkBegin;
  IdHTTPDownLoad.OnWork := IdHTTPDownLoadWork;
  IdHTTPDownLoad.OnWorkEnd := IdHTTPDownLoadWorkEnd;

  if MemoryStream = nil then MemoryStream := TMemoryStream.Create;

  while not Terminated do begin
    Sleep(80);
    case g_UpgradeStep of
      uGetUpgrade: if g_sUpgList.Count > 0 then begin
          SetStatusText('正在取得更新信息……');
          try
            try
              d := nil;
              for I := 0 to g_sUpgList.Count - 1 do begin
                sLineText := g_sUpgList.Strings[I];
                if (sLineText = '') or (sLineText[1] = ';') then Continue;
                sLineText := GetValidStr3(sLineText, sFileName, [' ', #9]);
                sDownSite := Trim(GetValidStr3(sLineText, sFileMD5, [' ', #9]));

                if sDownSite <> '' then begin
                  if (CompareText(sFileName, g_LoginTool_Bin) = 0) then begin
                    if CompareText(g_sOldWorkDir, g_sWorkDir) <> 0 then
                      ChDir(g_sOldWorkDir);
                    if CompareText(MD5Print(MD5File(g_sLoginTool_Bin)), sFileMD5) = 0 then
                      Continue
                    else begin
                      New(d);
                      d.sFileName := sFileName;
                      d.sDownSite := sDownSite;
                      Continue;
                    end;
                  end else if (CompareText(sFileName, g_LoginTool_Exe) = 0) then begin
                    if CompareText(g_sOldWorkDir, g_sWorkDir) <> 0 then
                      ChDir(g_sOldWorkDir);
                    if CompareText(MD5Print(MD5File(g_sLoginTool)), sFileMD5) = 0 then
                      Continue
                    else begin
                      New(d);
                      d.sFileName := sFileName;
                      d.sDownSite := sDownSite;
                      Continue;
                    end;
                  end else begin
                    sDownFileName := '.\' + sFileName;
                    if (CompareText(sFileName, 'LoginDLL.dll') = 0) then
                    begin
                      ChDir(g_sOldWorkDir);
                    end
                    else
                    begin
                      if not IsLegendGameDir then
                        ChDir(g_sWorkDir);
                    end;
                    if FileExists(sDownFileName) then begin
                      if CompareText(MD5Print(MD5File(sDownFileName)), sFileMD5) = 0 then
                        Continue;
                    end;
                  end;

                  New(DownSoft);
                  DownSoft.sFileName := sFileName;
                  DownSoft.sDownSite := sDownSite;
                  DownList.Add(DownSoft);
                end;
              end;
              if d <> nil then DownList.Insert(0, d);
            except
              g_sUpgList.Text := '';
            end;
          finally
            //sList.Free;
            //IdHTTP.Free;
          end;
          if DownList.Count > 0 then
            g_UpgradeStep := uDownLoadUpgrade
          else
            g_UpgradeStep := uNoNewSoft;
        end;
      uDownLoadUpgrade: begin
          SetStatusText('正在下载更新软件……');
          for I := 0 to DownList.Count - 1 do begin
            nDownFileIdx := I;
            DownSoft := DownList.Items[I];
            sCurDownLoadFile := DownSoft.sFileName;

            sCurDownLoadSite := DownSoft.sDownSite;
            //DownSoft.sDownSite := AnsiReplaceText(DownSoft.sDownSite, '\', '/');
            sRealDownLoadFile := ExtractWebFileName(DownSoft.sDownSite);

         //   OutputDebugString(pchar(sCurDownLoadSite));
          //  OutputDebugString(pchar(sRealDownLoadFile));
            try
              MemoryStream.Clear;
              IdHTTPDownLoad.Get(sCurDownLoadSite, MemoryStream);
            except
              bExcept := True;
            end;
            if bExcept and
              (CompareText(sCurDownLoadFile, 'gamemodule.pk') = 0) then
            begin

            //下载失败 得到文件md5
              try
                bIsExcept := bExcept;
                MemoryStream.Clear;
                IdHTTGetMD5 := TIdHTTP.Create(nil);
                temp := TMemoryStream.Create;
                IdHTTGetMD5.Get(VMProtectDecryptStringA('http://bluedlq.oss-cn-hangzhou.aliyuncs.com/MD5.txt'), temp);
                SetLength(strmd5, temp.size);
                temp.Position := 0;
                temp.Read(Pointer(strmd5)^, temp.size);
                gamemodulemd5 := Trim(strmd5);
                OutputDebugString(pchar(gamemodulemd5));
                temp.Clear;
                temp.Free;
                if 0 <> AnsiCompareStr(MD5Print(MD5File('gamemodule.pk')), gamemodulemd5) then
                begin
                  try
                    MemoryStream.Clear;
                //    OutputDebugString('down load yun');
                    ChDir(g_sWorkDir);
                    DeleteFile('gamemodule.pk');
                    DeleteFile('gamemodule.pk.zip');
                    IdHTTPDownLoad.Get(VMProtectDecryptStringA('http://bluedlq.oss-cn-hangzhou.aliyuncs.com/gamemodule.dll'), MemoryStream);
                  except
                  end;
                end;

              except
              end;
            end;
            Dispose(DownSoft);
          end;
          DownList.Clear;
          g_UpgradeStep := uOver;
        end;
      uNoNewSoft: begin
          SetStatusText('当前没有更新文件！');
          //g_UpgradeStat := sNoNew;
          Break;
        end;
      uOver: begin
          SetStatusText('文件更新完成……');
          //g_UpgradeStat := sOK;
          Break;
        end;
    end;
  end;
  for I := 0 to DownList.Count - 1 do begin
    DownSoft := DownList.Items[I];
    Dispose(DownSoft);
  end;
  DownList.Clear;
  boUpdateBusy := False;
end;

procedure TStartThread.IdHTTPDownLoadWork(Sender: TObject;
  AWorkMode: TWorkMode; {$IFDEF VER185}{$ELSE}const{$ENDIF}AWorkCount: Integer);
begin
  nWorkCountCur := AWorkCount;
end;

procedure TStartThread.IdHTTPDownLoadWorkBegin(Sender: TObject;
  AWorkMode: TWorkMode; {$IFDEF VER185}{$ELSE}const{$ENDIF}AWorkCountMax: Integer);
begin
  nWorkCountMax := AWorkCountMax;
end;

procedure processgamemoudle(MemoryStream: TMemoryStream);
var
  MyMD5: TIdHashMessageDigest5;
  Digest: T4x4LongWordRecord;
  curmd5: string;
  VCLUnZip1: TVCLUnZip;
  outstream: TMemoryStream;

begin
  try

    MyMD5 := TIdHashMessageDigest5.Create;
    MemoryStream.Position := 0;
    Digest := MyMD5.HashValue(MemoryStream);
    curmd5 := MyMD5.AsHex(Digest);
//  ShowMessage('32: ' + curmd5);
  //  OutputDebugString(pchar(curmd5));
//    OutputDebugString(pchar(gamemodulemd5));
 // MemoryStream.SaveToFile('d:\gamemodule.bin2');
    if CompareText(curmd5, gamemodulemd5) = 0 then
    begin
      outstream := TMemoryStream.Create;
      VCLUnZip1 := TVCLUnZip.Create(nil);
      MemoryStream.Position := 0;
      VCLUnZip1.ArchiveStream := MemoryStream;
      VCLUnZip1.UnZipToStream(outstream, 'gamemodule.dll');
    //  outstream.SaveToFile('d:\gamemodule.txt');
  {
    GpeNetStream := TMemoryStream.Create;
    GpeNetStream.Clear;

    outstream.SaveToStream(GpeNetStream);

    WaitLoadThread.Resume;
    outstream.Free;
    }
      thunk := TMemoryStream.Create;
      outstream.SaveToStream(thunk);
     // OutputDebugString(pchar(IntToStr(thunk.Size)));
      outstream.Free;
      VCLUnZip1.Free;
    end;
  except
  end;
end;

procedure TStartThread.IdHTTPDownLoadWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
var
  boChanged: Boolean;
  attr: Integer;
  sDelFileName: string;
  sSaveDir: string;
  sSaveFile, sSaveFile2: string;
  MyReg: TRegIniFile;
  curgamedir: string;
begin
  nWorkCountCur := nWorkCountMax;
 // OutputDebugString('IdHTTPDownLoadWorkEnd:');
//  OutputDebugString(pchar(sCurDownLoadFile));
  ChDir(g_sOldWorkDir);
  if CompareText(sCurDownLoadFile, g_LoginTool_Bin) = 0 then begin
    sDelFileName := '.\' + sSelfFileName_Bin + '.bak';
    if FileExists(sDelFileName) then
      DeleteFile(sDelFileName);
    RenameFile(sSelfFileName_Bin, sDelFileName);
    MemoryStream.SaveToFile('.\' + sSelfFileName_Bin);
    g_boRestart := True;
    Exit;
  end;
  if CompareText(sCurDownLoadFile, g_LoginTool_Exe) = 0 then begin
    sDelFileName := '.\' + sSelfFileName + '.bak';
    if FileExists(sDelFileName) then
      DeleteFile(sDelFileName);
    RenameFile(sSelfFileName, sDelFileName);
    MemoryStream.SaveToFile('.\' + sSelfFileName);
    g_boRestart := True;
    Exit;
  end;
  if CompareText(sCurDownLoadFile, 'LoginDLL.dll') = 0 then begin
    sDelFileName := '.\LoginDLL.dll.bak';
    if FileExists(sDelFileName) then
      DeleteFile(sDelFileName);
    RenameFile('LoginDLL.dll', sDelFileName);
    MemoryStream.SaveToFile('.\LoginDLL.dll');
    Exit;
  end;

//  OutputDebugString(pchar(IntToStr(MemoryStream.Size)));
  if 0 = MemoryStream.size then
  begin
    Exit;
  end;
  if CompareText(sCurDownLoadFile, 'gamemodule.pk') = 0 then
  begin
    ChDir(g_sWorkDir);
    sDelFileName := '.\gamemodule.pk.bak';
    if FileExists(sDelFileName) then
      DeleteFile(sDelFileName);
    RenameFile('gamemodule.pk', sDelFileName);
    MemoryStream.SaveToFile('.\gamemodule.pk.zip');

    SetStatusText('UnZip:' + sRealDownLoadFile + ' ……');
    FrmMain.VCLUnZip.ClearZip;
    FrmMain.VCLUnZip.ZipName := '.\gamemodule.pk.zip';
    FrmMain.VCLUnZip.DestDir := '.\';
    FrmMain.VCLUnZip.DoAll := True;
    FrmMain.VCLUnZip.RecreateDirs := True;
    FrmMain.VCLUnZip.ReplaceReadOnly := True;
    FrmMain.VCLUnZip.RetainAttributes := True;

    FrmMain.VCLUnZip.UnZip;
    Sleep(100);
    DeleteFile('.\gamemodule.pk.zip');
    if bIsExcept then
    begin
      gamemodulemd5 := MD5Print(MD5File('.\gamemodule.pk'));
    end;

    Exit;
  end;

//  if CompareText(sCurDownLoadFile, 'gamemodule.dll') = 0 then begin
 //   processgamemoudle(MemoryStream);
  //  Exit;
 // end;

  //OutputDebugString(Pchar(g_sWorkDir));
  if DirectoryExists(g_sWorkDir) then
    ChDir(g_sWorkDir);

  if not IsLegendGameDir then begin
    MyReg := TRegIniFile.Create('Software\BlueSoft');
    curgamedir := MyReg.ReadString('LoginTool', 'MirClientDir', '');
    if DirectoryExists(curgamedir) then
    begin
      if not SameText(curgamedir, g_sWorkDir) then
      begin
        g_sWorkDir := curgamedir;
        ChDir(g_sWorkDir);
      end;
    end;
  end;

  sSaveFile := '.\' + sCurDownLoadFile;

  {if sCurDownLoadFile <> '' then begin
    if sCurDownLoadFile[1] <> '.' then
      sSaveFile := '.\' + sCurDownLoadFile
    else
      sSaveFile := sCurDownLoadFile;
  end else
    sSaveFile := '.\' + sCurDownLoadFile;}

 // OutputDebugString(Pchar('curxx ' + GetCurrentDir));
  sSaveDir := ExtractFileDir(sSaveFile);
  //tputDebugString(Pchar(sSaveDir));
  //tputDebugString(Pchar(g_sWorkDir));
  if not DirectoryExists(sSaveDir) then
    if not ForceDirectories(sSaveDir) then
    begin
      OutputDebugString('exit');
      Exit;
    end;

  if CompareText(ExtractFileExt(sRealDownLoadFile), '.zip') = 0 then begin
    SetStatusText('UnZip:' + sRealDownLoadFile + ' ……');

    MemoryStream.Position := 0;
    MemoryStream.SaveToFile('.\' + sRealDownLoadFile);
    FrmMain.VCLUnZip.ZipName := '.\' + sRealDownLoadFile;
    FrmMain.VCLUnZip.DestDir := '.\';
    FrmMain.VCLUnZip.DoAll := True;
    FrmMain.VCLUnZip.RecreateDirs := True;
    FrmMain.VCLUnZip.ReplaceReadOnly := True;
    FrmMain.VCLUnZip.RetainAttributes := True;
    FrmMain.VCLUnZip.UnZip;
    Sleep(100);
    DeleteFile('.\' + sRealDownLoadFile);
   //utputDebugString('zzz');
   //utputDebugString(Pchar(sRealDownLoadFile));
  end else begin
    if FileExists(sSaveFile) then begin
      boChanged := False;
      attr := FileGetAttr(sSaveFile);
      if attr and faReadOnly = faReadOnly then begin
        attr := attr xor faReadOnly;
        boChanged := True;
      end;
      if attr and faSysFile = faSysFile then begin
        attr := attr xor faSysFile;
        boChanged := True;
      end;
      if attr and faHidden = faHidden then begin
        attr := attr xor faHidden;
        boChanged := True;
      end;
      if boChanged then
        FileSetAttr(sSaveFile, attr);
    end;
   // OutputDebugString(Pchar(sSaveFile));
    MemoryStream.SaveToFile(sSaveFile);
  end;

  {MemoryStream.SavetoFile(sSaveFile);
  if CompareText(ExtractFileExt(sSaveFile), '.zip') = 0 then begin
    sSaveFile2 := ExtractFileName(sSaveFile);
    FrmMain.VCLUnZip.ZipName := '.\' + sSaveFile2;
    FrmMain.VCLUnZip.DestDir := '.\';   // + Copy(sSaveFile2, 1, Length(sSaveFile2) - 4);
    FrmMain.VCLUnZip.DoAll := True;
    FrmMain.VCLUnZip.RecreateDirs := True;
    FrmMain.VCLUnZip.ReplaceReadOnly := True;
    FrmMain.VCLUnZip.RetainAttributes := True;
    FrmMain.VCLUnZip.UnZip;
  end;}
end;

initialization
  InitializeCriticalSection(CriticalSection);
  DownList := TList.Create;
  StartThread := TStartThread.Create(True);
  bIsExcept := False;

finalization
  //DeleteCriticalSection(CriticalSection);
  //for nCount := 0 to DownList.Count - 1 do
  //  Dispose(pTDownSoft(DownList.Items[nCount]));
  //DownList.Free;

end.
