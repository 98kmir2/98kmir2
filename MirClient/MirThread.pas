unit MirThread;

interface

uses
  Classes, Windows, SysUtils, Graphics, Controls, Dialogs, PsAPI, TLHelp32, ExtCtrls,
  CnHashTable, IdHTTP, Grobal2, MShare, ClMain, FState;

type
  TModuleDetect = class(TThread)
    FRunTick: LongWord;
    FRunTick2: LongWord;

    FCheckTick: LongWord;
    FCheckTickEx: LongWord;
    FSpeedHackTick: LongWord;
    FHookChkTick: LongWord;
    FInitSock: Boolean;
    FInitThreadHandle: Boolean;
    FGetModule: Boolean;
    FGetFilter: Boolean;
  private
    FPListSite: PTShortStr;
    FOutDlgMsg: string;
    FPosition: Integer;
    FPosition2: Integer;
    FScanBlockPos: Integer;
    Fmodhand: array[0..1024] of hModule;
    FmodName: array[0..MAX_PATH] of Char;
    FProcHand: THandle;
    FModCount: DWORD;
    FSHGetTime: LongWord;
    FSHTimerTime: LongWord;
    FSHFakeCount: Integer;
    FTempList: TStringList;
    FProcFilter: TCnHashTableSmall;
    FslProcList: TCnHashTableSmall;
    FCheckModList: TCnHashTableSmall;
    FIdHTTPCheckModulList: TIdHTTP;
    FVirussignList: TList;
    procedure ShowDlgMsg;
    // procedure ShowBroadMsg;        私有成员函数未调用 2019-10-07 18:00:01 
    procedure InitClientSocket();
    procedure UnInitClientSocket();
    function GetNameByPid(Pid: DWORD): string;
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;


function ZwQuerySystemInformation(ASystemInformationClass: UINT; ASystemInformation: Pointer; ASystemInformationLength: ULONG; AReturnLength: PULONG): NTStatus; stdcall; external 'ntdll.dll' Name 'ZwQuerySystemInformation';
function ZwQueryInformationProcess(ProcessHandle: THandle; PrcInfoClass: DWORD; PrcInfo: Pointer; PrcInfoLength: ULONG; ReturnLength: TPDWord): DWORD; stdcall; external 'ntdll.dll' Name 'ZwQueryInformationProcess';

var
  g_ModuleDetect: TModuleDetect;

resourcestring
  mMsgSpeedHack = '网络出现不稳定情况或使用加速程序！\游戏中止，如有问题请联系游戏管理员';
  mMsgModleHack = '非法HOOK进程：%s\游戏已被中止，如有问题请联系游戏管理员';
  mMsgModleHack2 = '非法模块进程：%s\游戏已被中止，如有问题请联系游戏管理员';

implementation

uses
  HUtil32, IntroScn, WIL, wmUtil, ClFunc, EDcode, VMProtectSDK;

constructor TModuleDetect.Create;
begin
  New(FPListSite);
  frmMain.DCP_mars.InitStr(VMProtectDecryptStringA('sListSite'));
  FPListSite^ := frmMain.DCP_mars.DecryptString(g_pRcHeader.sListSite);
  FSpeedHackTick := GetTickCount;
  FHookChkTick := GetTickCount;
  FRunTick := GetTickCount;
  FRunTick2 := GetTickCount;
  FSHGetTime := 0;
  FSHTimerTime := 0;
  FSHFakeCount := 0;
  FPosition := 0;
  FPosition2 := 0;
  FScanBlockPos := 0;
  FProcHand := 0;
  FCheckTick := 0;
  FCheckTickEx := 0;
  FInitSock := False;
  FInitThreadHandle := False;
  FGetModule := False;
  FGetFilter := False;
  FTempList := TStringList.Create;
  FIdHTTPCheckModulList := TIdHTTP.Create(nil);
  FProcFilter := TCnHashTableSmall.Create();
  FslProcList := TCnHashTableSmall.Create();
  FCheckModList := TCnHashTableSmall.Create();
  FVirussignList := TList.Create;
  inherited Create(True);
end;

destructor TModuleDetect.Destroy;
begin
  inherited;
  Dispose(FPListSite);
  FProcFilter.Free;
  FTempList.Free;
  FslProcList.Free;
  FCheckModList.Free;
  FIdHTTPCheckModulList.Free;
  FVirussignList.Free;
end;

procedure TModuleDetect.ShowDlgMsg;
begin
  FrmDlg.DMessageDlg(FOutDlgMsg, [mbOk]);
end;
{
procedure TModuleDetect.ShowBroadMsg;
begin
  DScreen.AddChatBoardString(FOutMsg, clWhite, clblack);
end;
 }
function GetFileInfo_FCompanyName(const AFileName: TFileName): string;
var
  FFile: TFileName;
  FInfoSize, temp, Len: Cardinal;
  InfoBuf: Pointer;
  TranslationLength: Cardinal;
  TranslationTable: Pointer;
  LanguageID, CodePage, LookupString: string;
  Value: PChar;
begin
  Result := '';
  {.$I '..\Common\Macros\VMPBM.inc'}
  FFile := AFileName;
  if Length(FFile) = 0 then
    Exit;
  FInfoSize := GetFileVersionInfoSize(PChar(FFile), temp);
  if FInfoSize > 0 then
  begin
    InfoBuf := AllocMem(FInfoSize);
    try
      GetFileVersionInfo(PChar(FFile), 0, FInfoSize, InfoBuf);
      if VerQueryValue(InfoBuf, '\VarFileInfo\Translation', TranslationTable, TranslationLength) then
      begin
        CodePage := Format('%.4x', [HiWord(PLongInt(TranslationTable)^)]);
        LanguageID := Format('%.4x', [LoWord(PLongInt(TranslationTable)^)]);
      end;
      LookupString := 'StringFileInfo\' + LanguageID + CodePage + '\';
      if VerQueryValue(InfoBuf, PChar(LookupString + 'CompanyName'), Pointer(Value), Len) then
        Result := Value;
    finally
      FreeMem(InfoBuf, FInfoSize);
    end;
  end;
  {.$I '..\Common\Macros\VMPE.inc'}
end;

function GetInfoTable(ATableType: ULONG): Pointer;
var
  mSize: ULONG;
  mPtr: Pointer;
  st: NTStatus;
begin
  mSize := $4000;
  {.$I '..\Common\Macros\VMPBM.inc'}
  repeat
    GetMem(mPtr, mSize);
    ZeroMemory(mPtr, mSize);
    st := ZwQuerySystemInformation(ATableType, mPtr, mSize, nil);
    if st = STATUS_INFO_LENGTH_MISMATCH then
    begin
      FreeMem(mPtr);
      mSize := mSize * 2;
    end;
  until st <> STATUS_INFO_LENGTH_MISMATCH;
  if st = STATUS_SUCCESS then
    Result := mPtr
  else
  begin
    FreeMem(mPtr);
    Result := nil;
  end;
  {.$I '..\Common\Macros\VMPE.inc'}
end;

function TModuleDetect.GetNameByPid(Pid: DWORD): string;
var
  hProcess, Bytes: DWORD;
  INFO: PROCESS_BASIC_INFORMATION;
  ProcessParametres: Pointer;
  ImagePath: TUNICODE_STRING;
  ImgPath: array[0..MAX_PATH] of WideChar;
begin
  Result := '';
  {.$I '..\Common\Macros\VMPBM.inc'}
  ZeroMemory(@ImgPath, MAX_PATH * SizeOf(WideChar));
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, Pid);
  if ZwQueryInformationProcess(hProcess, DWORD(ProcessBasicInformation), @INFO, SizeOf(PROCESS_BASIC_INFORMATION), nil) = STATUS_SUCCESS then
  begin
    if ReadProcessMemory(hProcess, Pointer(DWORD(INFO.PebBaseAddress) + $10), @ProcessParametres, SizeOf(Pointer), Bytes) and
      ReadProcessMemory(hProcess, Pointer(DWORD(ProcessParametres) + $38), @ImagePath, SizeOf(TUNICODE_STRING), Bytes) and
      ReadProcessMemory(hProcess, ImagePath.Buffer, @ImgPath, ImagePath.Length, Bytes) then
    begin
      Result := ExtractFileName(WideCharLenToString(ImgPath, MAX_PATH * SizeOf(WideChar)));
    end;
  end;
  CloseHandle(hProcess);
  {.$I '..\Common\Macros\VMPE.inc'}
end;

var
  nIDEvent: UINT = 0;

procedure TModuleDetect.InitClientSocket();
begin
  DScreen.ChangeScene(stIntro);
  frmMain.DXDraw.Cursor := crDefault;
  frmMain.MouseTimer.Enabled := True;
  g_boProcMessagePacket := True;
end;

procedure TModuleDetect.UnInitClientSocket();
begin
  frmMain.MouseTimer.Enabled := False;
end;

procedure TModuleDetect.Execute;
{
var
  gcount, timer: LongWord;
  ahour, amin, asec, amsec: Word;
  i, ii, r, nID: Integer;
  fName: string[255];
  sShort: string[128];
  HandlesInfo, Hi: PSYSTEM_HANDLE_INFORMATION_EX;
  ProcLimit, ProcLimit2: Boolean;
  dwRunTick, dwRunTick2: LongWord;
  dwProcessId: DWORD;
  tPId: ULONG;

  bFound: Boolean;
  BytesRead: LongWord;
  L, n, modResdAdress: Integer;
  CodeSign: string[2];
  PVirusSign: PTVirusSign;
  Buffer: array[1..512] of Char;
  mHandle: THandle;
  FModuleEntry32: TModuleEntry32;
  dwLen: DWORD;
label
  lexit;
  }
begin
  while not Terminated do
  begin
    if not FInitSock then
    begin
      FInitSock := True;
      Synchronize(InitClientSocket);
    end;

    // 去掉检测  2019-10-16 14:30:40
    (*
    if GetTickCount - FRunTick >= 800 then
    begin
      FRunTick := GetTickCount;

      if GetTickCount - FSpeedHackTick > 1000 then
      begin
        FSpeedHackTick := GetTickCount;
        DecodeTime(Time, ahour, amin, asec, amsec);
        timer := ahour * 1000 * 60 * 60 + amin * 1000 * 60 + asec * 1000 + amsec;
        gcount := GetTickCount;
        if FSHGetTime > 0 then
        begin
          if abs((gcount - FSHGetTime) - (timer - FSHTimerTime)) > 45 then
          begin
            Inc(FSHFakeCount);
          end
          else
            FSHFakeCount := 0;
          if FSHFakeCount > 2 then
          begin
            FOutDlgMsg := mMsgSpeedHack;
            Synchronize(ShowDlgMsg);
            goto lexit;
          end;
        end;
        FSHGetTime := gcount;
        FSHTimerTime := timer;
      end;

      {
      if not FGetModule then begin
        FGetModule := True;
        try
          FTempList.Clear;
          FTempList.Text := FIdHTTPCheckModulList.Get(FPListSite^);
          for i := 0 to FTempList.count - 1 do begin
            if not FCheckModList.Exists(LowerCase(FTempList.Strings[i])) then
              FCheckModList.Put(LowerCase(FTempList.Strings[i]), nil);
          end;
          //Travel(FCheckModList, '.\!debug.txt');
          FTempList.Clear;
          spName := Copy(FPListSite^, 1, Length(FPListSite^) - 4) + 'Ex.txt';
          FTempList.Text := FIdHTTPCheckModulList.Get(spName);
          for i := 0 to FTempList.count - 1 do begin
            sLine := FTempList[i];
            if (sLine = '') or (sLine[1] = ';') then Continue;
            sLine := GetValidStr3(sLine, sOffSet, [' ', ',', #9]);
            nOffset := StrToInt(sOffSet);
            if (nOffset >= 0) and (sLine <> '') then begin
              New(PVirusSign);
              PVirusSign.Offset := nOffset;
              PVirusSign.CodeSign := UpperCase(sLine);
              FVirussignList.Add(PVirusSign);
              //DebugOutStr(PVirusSign.CodeSign);
            end;
          end;
        except
        end;
      end;
      }

      // 去掉检测  2019-10-16 14:29:35
      (*
      if not FGetFilter then
      begin
        FGetFilter := True;
        Hi := GetInfoTable(ULONG(SystemHandleInformation));
        if (Hi <> nil) and (Hi^.NumberOfHandles > 0) then
        begin
          for r := 0 to Hi^.NumberOfHandles do
          begin
            if Hi^.Information[r].ObjectTypeNumber in [OB_TYPE_PROCESS, OB_TYPE_THREAD] then
            begin
              tPId := Hi^.Information[r].ProcessId;
              if tPId in [0..4] then
                Continue;
              sShort := Format('%d', [tPId]);
              if FProcFilter.Exists(sShort) then
                Continue;
              if Pos('Microsoft Corporation', GetFileInfo_FCompanyName(GetNameByPid(tPId))) > 0 then //take time
                FProcFilter.Put(sShort, nil);
            end;
          end;
          FreeMem(Hi);
          Hi := nil;
        end;
      end;

    {$IFNDEF TEST}
      // 调试模式不要检测函数是否被Hook，抓包调试  2019-10-07 15:57:46
      if GetTickCount - FRunTick2 >= 8000 then
      begin
        FRunTick2 := GetTickCount;
        DllModule := LoadLibrary(VMProtectDecryptStringA('WS2_32.dll'));
        if DllModule > 32 then
        begin
          PFunc := GetProcAddress(DllModule, VMProtectDecryptStringA('send'));
          //DScreen.AddChatBoardString(format('%08x', [Integer(PFunc)]), GetRGB(5), clWhite);
          //8B FF 55 8B EC
          if PFunc <> nil then
          begin
            pf := PChar(PFunc);
            for ii := 0 to 4 do
            begin
              if g_pWsockAddr[ii] <> BYTE(pf[ii]) then
              begin
                goto lexit;
              end;
            end;
          end;
          FreeLibrary(DllModule);
          //DScreen.AddChatBoardString(pf, GetRGB(5), clWhite);
        end;
      end;
    {$ENDIF}
    
      //DScreen.AddChatBoardString(Inttostr(self.ThreadID), GetRGB(5), clWhite);
      if g_bLoginKey^ and not g_boMapMoving and not g_boServerChanging and FGetModule and ((g_MySelf = nil) or frmMain.CanNextAction) then
      begin
        //DScreen.AddChatBoardString('2', GetRGB(5), clWhite);
        if FVirussignList.count > 0 then
        begin
          if (GetTickCount - FCheckTickEx > 17 * 1000) then
          begin
            FCheckTickEx := GetTickCount;

            mHandle := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, GetCurrentProcessId);
            if mHandle <> 0 then
            begin
              FModuleEntry32.dwSize := SizeOf(TModuleEntry32);
              if Module32First(mHandle, FModuleEntry32) then
              begin
                nID := 0;
                while Module32Next(mHandle, FModuleEntry32) do
                begin
                  for i := 0 to FVirussignList.count - 1 do
                  begin
                    PVirusSign := FVirussignList[i];
                    L := Length(PVirusSign.CodeSign) div 2;
                    modResdAdress := Integer(FModuleEntry32.modBaseAddr) + PVirusSign.Offset;
                    if (modResdAdress + L) <= (Integer(FModuleEntry32.modBaseAddr) + FModuleEntry32.modBaseSize) then
                    begin
                      bFound := True;
                      try
                        ReadProcessMemory(GetCurrentProcess, Pointer(modResdAdress), @Buffer[1], L, BytesRead);
                      except
                      end;
                      n := 1;
                      for ii := 1 to Length(PVirusSign.CodeSign) {L} do
                      begin
                        if ii mod 2 = 1 then
                        begin
                          CodeSign := UpperCase(Copy(PVirusSign.CodeSign, ii {postion}, 2 {byts}));
                          if (CodeSign <> '??') and (UpperCase(IntToHex(BYTE(Buffer[n]), 2)) <> CodeSign) then
                          begin
                            bFound := False;
                            Break;
                          end;
                          Inc(n);
                        end;
                      end;
                      if bFound then
                      begin
                        nID := 1;
                        FOutDlgMsg := Format(mMsgModleHack2, [FModuleEntry32.szModule]);
                        Synchronize(ShowDlgMsg);
                        Synchronize(UnInitClientSocket);
                        goto lexit;
                      end;
                    end;
                  end;
                  if nID <> 0 then
                    Break;
                end;
              end;
              CloseHandle(mHandle);
            end;
          end;
        end;

        if (GetTickCount - FCheckTick > 29000) then
        begin
          FCheckTick := GetTickCount;
          if (FCheckModList.count > 0) then
          begin
            if FPosition = 0 then
            begin
              FslProcList.Clear;
              HandlesInfo := GetInfoTable(ULONG(SystemHandleInformation));
              if (HandlesInfo <> nil) and (HandlesInfo^.NumberOfHandles > 0) then
              begin
                for r := 0 to HandlesInfo^.NumberOfHandles do
                begin
                  if HandlesInfo^.Information[r].ObjectTypeNumber in [OB_TYPE_PROCESS, OB_TYPE_THREAD] then
                  begin
                    tPId := HandlesInfo^.Information[r].ProcessId;
                    if tPId in [0..4] then
                      Continue;
                    sShort := Format('%d', [tPId]);
                    if FGetFilter and FProcFilter.Exists(sShort) then
                      Continue;
                    if FslProcList.Exists(sShort) then
                      Continue;
                    FslProcList.Put(sShort, nil);
                  end;
                end;
                FreeMem(HandlesInfo);
                HandlesInfo := nil;
              end;
            end;

            if FslProcList.count > 0 then
            begin
              nID := 0;
              ProcLimit := False;
              dwRunTick := GetTickCount();
              for r := FPosition to FslProcList.count - 1 do
              begin
                dwProcessId := StrToInt(FslProcList.Keys[r]);
                if FPosition2 = 0 then
                begin
                  FProcHand := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, dwProcessId);
                  PsAPI.EnumProcessModules(FProcHand, @Fmodhand, SizeOf(Fmodhand), FModCount);
                end;
                if FProcHand > 0 then
                begin
                  ProcLimit2 := False;
                  dwRunTick2 := GetTickCount();
                  for i := FPosition2 to (FModCount div SizeOf(DWORD)) - 1 do
                  begin
                    dwLen := GetModuleBaseNameA(FProcHand, Fmodhand[i], FmodName, SizeOf(FmodName));
                    if dwLen > 0 then
                    begin
                      fName := StrPas(FmodName);
                      if FCheckModList.Exists(LowerCase(fName)) then
                      begin
                        FOutDlgMsg := Format(mMsgModleHack, [GetNameByPid(dwProcessId)]);
                        Synchronize(ShowDlgMsg);
                        //tH := OpenProcess(PROCESS_TERMINATE, BOOL(0), dwProcessId);
                        //TerminateProcess(tH, 0);   //anti virus checked ??
                        //CloseHandle(tH);
                        Synchronize(UnInitClientSocket);
                        //ExitProcess(0);
                        //frmMain.Close;
                        //FrmDlg.Free;
                        //frmMain.Free;

                        lexit:
                        try
                          ExitProcess(0);
                        finally
                        end;

                        frmMain.Close;
                        FrmDlg.Free;
                        frmMain.Free;
                        g_MySelf.Free;

                        UnLoadWMImagesLib();

                        DScreen.Finalize;
                        g_PlayScene.Finalize;
                        LoginNoticeScene.Finalize;

                        DScreen.Free;
                        IntroScene.Free;
                        LoginScene.Free;
                        SelectChrScene.Free;
                        g_PlayScene.Free;
                        g_ShakeScreen.Free;
                        LoginNoticeScene.Free;
                        g_SaveItemList.Free;
                        g_MenuItemList.Free;

                        Inc(nID);
                        Break;
                      end;
                    end;
                    if GetTickCount - dwRunTick2 > 15 then
                    begin
                      ProcLimit2 := True;
                      FPosition2 := i + 1;
                      Break;
                    end;
                  end;
                  if not ProcLimit2 then
                  begin
                    FPosition2 := 0;
                    FModCount := 0;
                    CloseHandle(FProcHand);
                    FProcHand := 0;
                  end;
                end;
                if nID > 0 then
                  Break;
                if GetTickCount - dwRunTick > 15 then
                begin
                  ProcLimit := True;
                  FPosition := r;
                  Break;
                end;
              end;
              if not ProcLimit then
                FPosition := 0;
            end;
          end;
        end;
      end;
    end;
    *)

    Sleep(1);
  end;
end;

end.
