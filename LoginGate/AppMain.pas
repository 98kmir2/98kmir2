unit AppMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, Grids, MsXML, DateUtils, ComCtrls, IniFiles,
  IOCPManager, ClientThread, AcceptExWorkedThread, Protocol, SDK, utest;

type
  TFormMain = class(TForm)
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_START: TMenuItem;
    MENU_CONTROL_STOP: TMenuItem;
    MENU_CONTROL_RELOADCONFIG: TMenuItem;
    MENU_CONTROL_CLEAELOG: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_IPFILTER: TMenuItem;
    MENU_VIEW_HELP: TMenuItem;
    MENU_VIEW_HELP_ABOUT: TMenuItem;
    GridSocketInfo: TStringGrid;
    Splitter: TSplitter;
    MemoLog: TMemo;
    StatusBar: TStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MENU_VIEW_HELP_ABOUTClick(Sender: TObject);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure MENU_CONTROL_STOPClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MemoLogDblClick(Sender: TObject);
    procedure GridSocketInfoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_IPFILTERClick(Sender: TObject);
    procedure MENU_CONTROL_CLEAELOGClick(Sender: TObject);
    procedure MENU_CONTROL_RELOADCONFIGClick(Sender: TObject);
  private
    { Private declarations }
    str_EndPtr: string;

    function GetNetTime(aUrl: WideString = 'http://www.sohu.com'): string;
    function GMTToBeiJing(const sGMT: string): TDateTime;
    procedure GetLiuName;

    procedure OnProgramException(Sender: TObject; E: Exception);
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
  public
    m_xRunServerList: TIOCPManager;
    m_xGameServerList: TGameServerManager;
    procedure InitIOCPServer();
    procedure CltOnRead(ClientThread: TClientThread; const Buffer: PChar; const BufLen: UINT);
    procedure CltOnClose(Sender: TObject);
    procedure ClientClosed(UserOBJ: pTUserOBJ; wParam, lParam: DWORD);
    procedure UserEnterEvent(Sender: TUserManager; const UserOBJ: pTUserOBJ); //用户进入事件
    procedure UserLeaveEvent(Sender: TUserManager; const UserOBJ: pTUserOBJ); //用户离开事件
    procedure UserReadBuffer(UserOBJ: TObject; const Buffer: PChar; var BufLen: DWORD; var Succeed: BOOL);

    procedure MyTesMessage(var msg: TMessage); message WM_TESTREST;

  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  FuncForComm, ClientSession, Grobal2, Misc, ConfigManager, LogManager, HUtil32,
  IPAddrFilter, GeneralConfig, PacketRuleConfig,
  SHSocket, VMProtectSDK, uTeaSet, Mars;

//该函数只在本单元文件中有定义，从未被调用过

procedure GetEnDeFunc();
begin
  //g_pEncodeFunc := LPGETDYNCODE(g_pszEndePtr)(1);

  g_pDecodeFunc := LPGETDYNCODE(g_pszEndePtr)(2);
  //ShowMessage(Format('%p',[@g_pDecodeFunc]));
end;

function TFormMain.GetNetTime(aUrl: WideString = 'http://www.sohu.com'): string;
begin
  with CoXMLHTTPRequest.Create do
  begin //新版本是 CoXMLHTTP.Create
    open('Post', aUrl, False, EmptyParam, EmptyParam);
    send(EmptyParam);
    Result := getResponseHeader('Date');
  end;
end;

function TFormMain.GMTToBeiJing(const sGMT: string): TDateTime;
var
  mon, datetxt: string;
  DateLst: TStringList;
  timeGMT, NetTime: TDateTime;
  fs: TFormatSettings;
begin
  datetxt := sGMT;
  datetxt := Copy(datetxt, Pos(',', datetxt) + 1, 100);
  datetxt := StringReplace(datetxt, 'GMT', '', []);
  datetxt := Trim(datetxt);
  if datetxt = '' then
    Exit;

  DateLst := TStringList.Create;
  while Pos(' ', datetxt) > 0 do
  begin
    DateLst.Add(Copy(datetxt, 1, Pos(' ', datetxt) - 1));
    datetxt := Copy(datetxt, Pos(' ', datetxt) + 1, 100);
  end;
  DateLst.Add(datetxt);

  if DateLst[1] = 'Jan' then
    mon := '01'
  else if DateLst[1] = 'Feb' then
    mon := '02'
  else if DateLst[1] = 'Mar' then
    mon := '03'
  else if DateLst[1] = 'Apr' then
    mon := '04'
  else if DateLst[1] = 'Mar' then
    mon := '05'
  else if DateLst[1] = 'Jun' then
    mon := '06'
  else if DateLst[1] = 'Jul' then
    mon := '07'
  else if DateLst[1] = 'Aug' then
    mon := '08'
  else if DateLst[1] = 'Sep' then
    mon := '09'
  else if DateLst[1] = 'Oct' then
    mon := '10'
  else if DateLst[1] = 'Nov' then
    mon := '11'
  else if DateLst[1] = 'Dec' then
    mon := '12';

  fs.ShortDateFormat := 'yyyy-mm-dd';
  fs.DateSeparator := '-';
  timeGMT := StrToDateTime(DateLst[2] + '-' + mon + '-' + DateLst[0] + ' ' + DateLst[3], fs);
  //转换时区
  NetTime := IncHour(TimeGMT, 8);
  FreeAndNil(DateLst);
  //Result:= FormatDateTime('yyyy/mm/dd HH:NN:SS', NetTime);
  Result := NetTime;
end;

procedure TFormMain.GetLiuName;
var
  strGMT, strEnd: string;
  bjDateTime: TDateTime;
begin
  strGMT := GetNetTime(); ShowMessage(strGMT);
  bjDateTime := GMTToBeiJing(strGMT);

  strEnd := FormatDateTime('yyyymmdd', bjDateTime);
  ShowMessage(strEnd);
  //ShowMessageFmt('%s'#13#10'%s', [strGMT, DateTimeToStr(bjDateTime)]);

  if strEnd >= str_EndPtr then
    ShowMessage('已经到期了！');
end;

procedure TFormMain.OnProgramException(Sender: TObject; E: Exception);
begin
  g_pLogMgr.Add(E.Message);
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if g_fCanClose then
    Exit;
  if Application.MessageBox('是否确认退出服务器？', '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
  begin
    if g_fServiceStarted then
    begin
      StopService();
      Sleep(20);
      CanClose := True;
    end;
  end
  else
    CanClose := False;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  nX, nY: Integer;

  fHandle, fHandle2: THandle;
  EDHeader, EDHeader2: TEDHeader;
  pszBufPtr: PChar;
  pszBuffer: array[0..MAX_CLIENT_FUNC_SIZE - 1] of Char;

  L, I, cLen: Integer;
  dat, temp: TLong2;
  Long2Data: TLong2Data;
  tMasterKey: TTeaKey;
  qwFileSize: Int64;
  decode: TMemoryStream;
  tempstr: string;

  Cmd: TCmdPack;
  CltCmd: PCmdPack;

  pszBuf: array[0..1024 - 1] of Char;

  ts: TMemoryStream;
begin
  Application.OnException := OnProgramException;
  g_ProcMsgThread := TProcMsgThread.Create;

  g_hMainWnd := Self.Handle;
  g_hGameCenterHandle := Str_ToInt(ParamStr(1), 0); //运行到此，g_hGameCenterHandle值是 0
  nX := Str_ToInt(ParamStr(2), -1);
  nY := Str_ToInt(ParamStr(3), -1);
  if (nX >= 0) or (nY >= 0) then
  begin
    Left := nX;
    Top := nY;
  end;
  g_pLogMgr := TLogMgr.Create(MemoLog.Handle);
  g_pConfig := TConfigMgr.Create(_STR_CONFIG_FILE);

  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(g_hMainWnd));

  GridSocketInfo.Cells[0, 0] := _STR_GRID_IP;
  GridSocketInfo.Cells[1, 0] := _STR_GRID_PORT;
  GridSocketInfo.Cells[2, 0] := _STR_GRID_CONNECT_STATUS;
  GridSocketInfo.Cells[3, 0] := _STR_GRID_ONLINE_USER;

  //1
  g_DCP_mars := TDCP_mars.Create(nil); //初始化加密核心
  g_nEndeBufLen := 0;
  New(g_pLTCrc);
  g_pLTCrc^ := 0;

  mainhwnd := Handle;

//          Cmd.ident := SM_QUERYDYNCODE;
//          Cmd.Recog := $89abcdef;
//          Cmd.param := 456;
//          Cmd.tag := 888;
//          Cmd.Series := 4444;
//
//
//          EncodeBuf(Integer(@Cmd), SizeOf(TCmdPack), Integer(@pszBuf[0]));
//

{$IFDEF TEST}
  fHandle := FileOpen('.\LoginGate.bak.exe', FmOpenRead or fmShareDenyNone);
{$ELSE}
  fHandle := FileOpen(ParamStr(0), FmOpenRead or fmShareDenyNone);
  //fHandle := FileOpen('d:\gateinfo.dat', FmOpenRead or fmShareDenyNone);
{$ENDIF}

  (*
  if fHandle <> 0 then begin
    try
      FileSeek(fHandle, -SizeOf(TEDHeader), 2);//2表示从文件尾开始读，负号表示向文件开始方向
      FileRead(fHandle, EDHeader, SizeOf(TEDHeader));//读取长度为TEDHeader的结构长度的内容，读到EDHeader中去

      //g_DCP_mars.InitStr(VMProtectDecryptStringA('MIR2EX Logingate - edHeader 20150725'));
      g_DCP_mars.InitStr(VMProtectDecryptStringA('RAMM2 LoginGate - edHeader 20160201'));
      g_DCP_mars.DecryptCFB8bit(EDHeader, EDHeader2, SizeOf(TEDHeader));//解密EDHeader结构，放到EDHEader2中去

      g_pLTCrc^ := EDHeader2.nLoginToolCrc;//nLoginToolCrc是指LoginTool所需要的资源的长度
      if g_pLTCrc^ = 0 then//g_pLTCrc是一个整数指针，它的意思也是LoginTool所需要的资源长度，LT就是LoginTool的意思
        Exit;

      // 修改加密算法
   {
      if (EDHeader2.nStrLen <> 0) and (EDHeader2.nCetLen <> 0) then begin
        FileSeek(fHandle, -(EDHeader2.nStrLen + EDHeader2.nCetLen + SizeOf(TEDHeader)), 2);
        pszBufPtr := @pszBuffer[0];
        FileRead(fHandle, pszBufPtr^, EDHeader2.nStrLen);
        pszBufPtr[EDHeader2.nStrLen] := #0;
        PCharToLong2Data(pszBufPtr, EDHeader2.nStrLen, Long2Data, 0);
        StrToKey(VMProtectDecryptStringA('MC_20090209'), tMasterKey);

        L := Length(Long2Data);
        dat := Long2Data[L - 1];
        XTeaDecrypt(dat, tMasterKey);
        for I := Length(Long2Data) - 2 downto 0 do begin
          DecLong2(dat);
          temp := dat;
          XTeaEncrypt(temp, tMasterKey);
          Long2Data[I] := XORLong2(temp, Long2Data[I]);
        end;
        qwFileSize := Int64(Long2Data[L - 2]);
        FillChar(pszBufPtr^, MAX_CLIENT_FUNC_SIZE, #0);
        Long2DataToPChar(pszBufPtr, cLen, Long2Data, qwFileSize);
        g_pszDecodeKey^ := StrPas(pszBufPtr);
      //  ShowMessage(g_pszDecodeKey^);
        //2
        FileSeek(fHandle, -(EDHeader2.nCetLen + SizeOf(TEDHeader)), 2);
        FillChar(g_pszEndePtr^, MAX_CLIENT_FUNC_SIZE, #0);
        FileRead(fHandle, g_pszEndePtr^, EDHeader2.nCetLen);
        PCharToLong2Data(g_pszEndePtr, EDHeader2.nCetLen, Long2Data, 0);

        g_DCP_mars.InitStr('');
        StrToKey(g_DCP_mars.DecryptString(g_pszDecodeKey^), tMasterKey);

        L := Length(Long2Data);
        dat := Long2Data[L - 1];
        XTeaDecrypt(dat, tMasterKey);
        for I := Length(Long2Data) - 2 downto 0 do begin
          DecLong2(dat);
          temp := dat;
          XTeaEncrypt(temp, tMasterKey);
          Long2Data[I] := XORLong2(temp, Long2Data[I]);
        end;
        qwFileSize := Int64(Long2Data[L - 2]);
        FillChar(g_pszEndePtr^, MAX_CLIENT_FUNC_SIZE, #0);
        Long2DataToPChar(g_pszEndePtr, g_nEndeBufLen, Long2Data, qwFileSize);
        g_pszEndePtr[g_nEndeBufLen] := #0;

        }

      if (EDHeader2.nStrLen <> 0) and (EDHeader2.nCetLen <> 0) then begin
        begin
          FillChar(pszBuffer, MAX_CLIENT_FUNC_SIZE, #0);
          pszBufPtr := @pszBuffer[0];
          FileSeek(fHandle, -(EDHeader2.nStrLen + EDHeader2.nCetLen + SizeOf(TEDHeader)), 2);
          FileRead(fHandle, pszBufPtr^, EDHeader2.nStrLen);//读出字符串，到 pszBufPtr中

          tempstr := StrPas(pszBufPtr);
          //ShowMessage(tempstr + '  ------  ' + InttoStr(EDHeader2.nStrLen) + '     ' + InttoStr(EDHeader2.nCetLen) +
            //'      ' + InttoStr(Sizeof(TEDHeader)));
{$IFDEF  FREE}
          g_DCP_mars.InitStr(VMProtectDecryptStringA('ram gate free'));
{$ELSE}
          //g_DCP_mars.InitStr(VMProtectDecryptStringA('blue gate'));
          g_DCP_mars.InitStr(VMProtectDecryptStringA('ram gate'));
{$ENDIF}

          g_pszDecodeKey^ := g_DCP_mars.DecryptString(tempstr);//此时相当于是enkey

          //ShowMessage('g_pszDecodeKey的值是： ' + g_pszDecodeKey^);

          //Memo1.Lines.Add(g_pszDecodeKey^);
          //exit;
          //2


          FileSeek(fHandle, -(EDHeader2.nCetLen + SizeOf(TEDHeader)), 2);
          FillChar(pszBuffer, MAX_CLIENT_FUNC_SIZE, #0);
          FileRead(fHandle, pszBuffer, EDHeader2.nCetLen);  //ShowMessage(pszBuffer + '    ' + InttoStr(EDHeader2.nCetLen));
          g_DCP_mars.InitStr(g_pszDecodeKey^);
          g_DCP_mars.Decrypt(pszBuffer, g_pszEndePtr^, EDHeader2.nCetLen);
          g_nEndeBufLen := EDHeader2.nCetLen;
          g_pszEndePtr[g_nEndeBufLen] := #0;
          //g_pszEndePtr := '匦';
          //ShowMessage(g_pszEndePtr);
          str_EndPtr := g_pszEndePtr;
          //ShowMessage(str_EndPtr);

          //GetLiuName;

          {tempstr := g_pszEndePtr;
          ts := TMemoryStream.Create;
          ts.Write(tempstr, Length(tempstr));
          ts.Position := 0;
          ts.SaveToFile('d:\nGetLen.txt');

          ShowMessage(InttoStr(Length(tempstr)));

          ts.Free;}

          //ShowMessage(strPas(g_pszEndePtr));
        end;
      end;
    finally
      FileClose(fHandle);
    end;
  end;
  *)
  //GetEnDeFunc();//该函数一运行，将导致登录网关报错，报告内存错误

  g_DCP_mars.InitStr(g_pszDecodeKey^);
  Move('www.qhs.com', g_pszEndePtr[0], 11);
  g_nEndeBufLen := 11;
  g_pszEndePtr[g_nEndeBufLen] := #0;

  LoadBlockIPList();
  LoadBlockIPAreaList();

  SetTimer(g_hMainWnd, _IDM_TIMER_STARTSERVICE, 100, Pointer(@OnTimerProc));
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  g_DCP_mars.Free;
  g_pConfig.Free;
  g_pLogMgr.Free;
  g_ProcMsgThread.Free;
end;

procedure TFormMain.GridSocketInfoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  with Sender as TStringGrid do
  begin
    Canvas.FillRect(Rect);
    DrawText(Canvas.Handle,
      PChar(Cells[ACol, ARow]),
      Length(Cells[ACol, ARow]),
      Rect, // 包含文字的矩形
      DT_CENTER or // 水平居中 DT_RIGHT 水平居右
      DT_SINGLELINE or // 不折行
      DT_VCENTER); // 垂直居中
  end;
end;

procedure TFormMain.MemoLogDblClick(Sender: TObject);
begin
  if MemoLog.Lines.Count = 0 then
    Exit;
  if Application.MessageBox('是否确认清除显示的日志信息？', '确认信息', MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then
    Exit;
  MemoLog.Clear;
end;

procedure TFormMain.MENU_CONTROL_CLEAELOGClick(Sender: TObject);
begin
  MemoLogDblClick(nil);
end;

procedure TFormMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MENU_CONTROL_RELOADCONFIGClick(Sender: TObject);
begin
  g_pConfig.LoadConfig();
  Caption := g_pConfig.m_szTitle;

  LoadBlockIPList();
  LoadBlockIPAreaList();

  g_pLogMgr.Add('重新加载配置完成...');
end;

procedure TFormMain.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  StartService();
end;

procedure TFormMain.MENU_CONTROL_STOPClick(Sender: TObject);
begin
  StopService();
end;

procedure TFormMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  with frmGeneralConfig, g_pConfig do
  begin
    frmGeneralConfig.Top := Self.Top + 20;
    frmGeneralConfig.Left := Self.Left;
    m_Showed := False;
    EditTitle.Text := m_szTitle;
    TrackBarLogLevel.Position := m_nShowLogLevel;
    speGateCount.Value := m_nGateCount;
    speGateIdx.Value := 1;
    EditServerIPaddr.Text := g_pConfig.m_xGameGateList[1].sServerAdress;
    EditServerPort.Text := IntToStr(g_pConfig.m_xGameGateList[1].nServerPort);
    EditGatePort.Text := IntToStr(g_pConfig.m_xGameGateList[1].nGatePort);
    m_Showed := True;
    ShowModal;
  end;
end;

procedure TFormMain.MENU_OPTION_IPFILTERClick(Sender: TObject);
var
  I, n: Integer;
  UserOBJ: TSessionObj;
begin
  with frmPacketRule, g_pConfig do
  begin
    m_ShowOpen := False;
    frmPacketRule.Top := Self.Top + 20;
    frmPacketRule.Left := Self.Left;

    ListBoxActiveList.Clear;
    if g_fServiceStarted then
    begin
      for n := 0 to USER_ARRAY_COUNT - 1 do
      begin
        UserOBJ := g_UserList[n];
        if (UserOBJ <> nil) and (UserOBJ.m_tLastGameSvr <> nil) and (UserOBJ.m_tLastGameSvr.Active) and not UserOBJ.m_fKickFlag then
          ListBoxActiveList.Items.AddObject(Trim(UserOBJ.m_pUserOBJ.pszIPAddr), TObject(UserOBJ));
      end;
    end;
    ListBoxTempList.Clear;
    for I := 0 to g_TempBlockIPList.Count - 1 do
      ListBoxTempList.Items.AddObject(g_TempBlockIPList.Strings[I], g_TempBlockIPList.Objects[I]);

    ListBoxBlockList.Clear;
    for I := 0 to g_BlockIPList.Count - 1 do
      ListBoxBlockList.Items.AddObject(g_BlockIPList.Strings[I], g_BlockIPList.Objects[I]);

    ListBoxIPAreaFilter.Clear;
    for I := 0 to g_BlockIPAreaList.Count - 1 do
      ListBoxIPAreaFilter.Items.AddObject(g_BlockIPAreaList.Strings[I], g_BlockIPAreaList.Objects[I]);

    etMaxConnectOfIP.Value := m_nMaxConnectOfIP;
    etClientTimeOutTime.Value := m_nClientTimeOutTime div 1000;
    case m_tBlockIPMethod of
      mDisconnect: rdDisConnect.Checked := True;
      mBlock: rdAddTempList.Checked := True;
      mBlockList: rdAddBlockList.Checked := True;
    end;
    etNomClientPacketSize.Value := m_nNomClientPacketSize;
    etMaxClientMsgCount.Value := m_nMaxClientPacketCount;
    cbKickOverPacketSize.Checked := m_fKickOverPacketSize;
    cbCheckNullConnect.Checked := m_fCheckNullSession;
    cbDefenceCC.Checked := m_fDefenceCCPacket;
    cbCheckNewIDOfIP.Checked := m_fCheckNewIDOfIP;

    TrackBarIDLimitLevel.Position := m_nCheckNewIDOfIP;
    TrackBarIDLimitLevelChange(TrackBarIDLimitLevel);

    pcProcessPack.ActivePageIndex := 0;
    m_ShowOpen := True;
    btnSave.Enabled := False;
    ShowModal;
  end;
end;

procedure TFormMain.MENU_VIEW_HELP_ABOUTClick(Sender: TObject);
var
  szStr: string;
begin
  //g_pLogMgr.Add(VMProtectDecryptStringA(PChar(Format('最高限制: %d 人', [MAX_GAME_USER]))));
  g_pLogMgr.Add(VMProtectDecryptStringA('程序名称: 98K登陆网关'));
  g_pLogMgr.Add(VMProtectDecryptStringA('程序版本: 2019/11/6'));
  g_pLogMgr.Add(VMProtectDecryptStringA('程序网站: http://www.98km2.com'));
end;

procedure TFormMain.InitIOCPServer;
var
  I: Integer;
  ClientThread: TClientThread;
begin
  with m_xRunServerList.IOCPServer do
  begin
    UserManager.OnUserEnter := Self.UserEnterEvent;
    UserManager.OnUserLeave := Self.UserLeaveEvent;
    Reader.OnReadEvent := Self.UserReadBuffer;
  end;

  if g_pConfig.m_nGateCount > 0 then
  begin
    for I := 1 to g_pConfig.m_nGateCount do
    begin
      ClientThread := m_xGameServerList.InitGameServer(g_pConfig.m_xGameGateList[I].nServerPort, g_pConfig.m_xGameGateList[I].sServerAdress);
      ClientThread.m_nPos := I;
      ClientThread.OnReadEvent := CltOnRead;
      ClientThread.OnCloseEvent := CltOnClose;
      m_xRunServerList.InitServer(g_pConfig.m_xGameGateList[I].nGatePort, ClientThread);
      ClientThread.Active := True;
    end;
    m_xRunServerList.IOCPServer.StartService;
  end
  else
  begin
    MessageBox(0, '监听端口数量不能少于1个', '错误', MB_OK);
  end;
end;

procedure TFormMain.CltOnRead(ClientThread: TClientThread; const Buffer: PChar; const BufLen: UINT);
var
  I, nPos, nSock, nBufLen, ExecLen: Integer;
  pTRBuf: PChar;
  pTREnd: PChar;
  pTRBuffer: PChar;
  UserOBJ: TSessionObj;
label
  LOOP;
begin
  //ExecLen := 0;
  pTRBuf := Buffer;
  pTREnd := Buffer + BufLen;

  LOOP:
  while DWORD(pTRBuf) < DWORD(pTREnd) do
  begin
    if pTRBuf^ <> '%' then
    begin
      Inc(pTRBuf);
      Continue;
    end;
    if DWORD(pTREnd) - DWORD(pTRBuf) <= 2 then
      Break;
    pTRBuffer := pTRBuf + 1;
    while DWORD(pTRBuffer) < DWORD(pTREnd) do
    begin
      if pTRBuffer^ <> '$' then
      begin
        Inc(pTRBuffer);
        Continue;
      end;
      Inc(pTRBuf, 1);
      nBufLen := UINT(pTRBuffer) - UINT(pTRBuf);

      if nBufLen >= 2 then
      begin
        with g_ProcMsgThread do
        begin
          if pTRBuf^ = '+' then
          begin
            if (pTRBuf + 1)^ = '-' then
            begin
              nSock := Misc.AnsiStrToVal(pTRBuf + 2, nPos);
              UserOBJ := GetSession(nSock);
              if UserOBJ <> nil then
                SHSocket.FreeSocket(UserOBJ.m_pUserOBJ._SendObj.Socket);
            end
            else
            begin
              ClientThread.m_dwKeepAliveTick := GetTickCount();
              //ClientThread.m_fKeepAliveTimcOut := False;
            end;
          end
          else
          begin
            nSock := Misc.AnsiStrToVal(pTRBuf, nPos);
            UserOBJ := GetSession(nSock);
            if (UserOBJ <> nil) and (UserOBJ.m_tLastGameSvr = ClientThread) then
            begin
              UserOBJ.ProcessSvrData(ClientThread, Integer(pTRBuf + nPos + 1), nBufLen - nPos - 1);
            end;
          end;
        end;
      end;
      Inc(pTRBuf, nBufLen + 1);

      //ExecLen := DWORD(pTRBuf) - DWORD(Buffer);

      goto LOOP;
    end;
    Break;
  end;
  //if ExecLen > 0 then
  //  ClientThread.ReaderDone(ExecLen)
  //else
  ClientThread.ReaderDone(DWORD(pTRBuf) - DWORD(Buffer));
end;

procedure TFormMain.CltOnClose(Sender: TObject);
begin
  if g_pLogMgr.CheckLevel(5) then
    g_pLogMgr.Add('服务器连接已关闭: ' + TClientThread(Sender).ServerIP + ':' + IntToStr(TClientThread(Sender).ServerPort));
  with m_xRunServerList.IOCPServer do
    Writer.BroadUserMsg(0, Integer(Sender), ClientClosed);
end;

procedure TFormMain.ClientClosed(UserOBJ: pTUserOBJ; wParam, lParam: DWORD);
var
  ClientObj: TSessionObj;
begin
  ClientObj := TSessionObj(UserOBJ.tData);
  if ClientObj = nil then
    Exit;
  with ClientObj do
  begin
    if m_tLastGameSvr = TClientThread(lParam) then
      m_tIOCPSender.DeleteSocket(m_pOverlapSend);
  end;
end;

procedure TFormMain.UserEnterEvent(Sender: TUserManager; const UserOBJ: pTUserOBJ);
var
  CSession: TSessionObj;
begin
  CSession := TSessionObj(UserOBJ.tData);
  if CSession <> nil then
  begin
    CSession.ReCreate();
  end
  else
  begin
    CSession := TSessionObj.Create;
    UserOBJ.tData := CSession;
  end;
  with CSession do
  begin
    m_pUserOBJ := UserOBJ;
    m_tIOCPSender := UserOBJ.Writer;
    m_pOverlapSend := UserOBJ._SendObj;
    m_dwSessionID := UserOBJ.dwUID;
    InterlockedExchange(Integer(m_tLastGameSvr), Integer(UserOBJ.GameServ));
    InterlockedExchange(Integer(g_UserList[m_dwSessionID]), Integer(CSession));
    UserEnter();
  end;
end;

procedure TFormMain.UserLeaveEvent(Sender: TUserManager; const UserOBJ: pTUserOBJ);
begin
  if UserOBJ.tData <> nil then
  begin
    with TSessionObj(UserOBJ.tData) do
    begin
      UserLeave();
      InterlockedExchange(Integer(m_tLastGameSvr), 0);
    end;
  end;
end;

procedure TFormMain.UserReadBuffer(UserOBJ: TObject; const Buffer: PChar; var BufLen: DWORD; var Succeed: BOOL);
label
  LOOP;
var
  fCDPacket: Boolean;
  dwEndLoop: DWORD;
  iLen, ExecLen, nMsgCount: Integer;
  pTRBuf, pTRBuffer: PByte;
  dwEnd: DWORD;
begin
  fCDPacket := False;
  //ExecLen := 0;
  nMsgCount := 0;
  pTRBuf := PByte(Buffer);
  dwEnd := DWORD(Buffer) + BufLen;

  LOOP:
  while DWORD(pTRBuf) < dwEnd do
  begin
    if (pTRBuf^ <> $23) then
    begin //# &
      Inc(pTRBuf);
      Continue;
    end;
    if (dwEnd - DWORD(pTRBuf)) <= 2 then
      Break;
    pTRBuffer := Pointer(Integer(pTRBuf) + 2);
    while DWORD(pTRBuffer) < dwEnd do
    begin
      if pTRBuffer^ <> $21 then
      begin
        Inc(pTRBuffer);
        Continue;
      end;
      Inc(nMsgCount);
      Inc(pTRBuf, 2);
      iLen := UINT(pTRBuffer) - UINT(pTRBuf);
      TSessionObj(UserOBJ).ProcessCltData(Integer(pTRBuf), iLen, Succeed, fCDPacket);

      if not Succeed then
        Break;

      Inc(pTRBuf, iLen + 1);

      //ExecLen := DWORD(pTRBuf) - DWORD(Buffer);

      if nMsgCount >= g_pConfig.m_nMaxClientPacketCount then
      begin
        KickUser(TSessionObj(UserOBJ).m_pUserOBJ.nIPAddr);
        Break;
      end;
      goto LOOP;
    end;
    Break;
  end;
  if Succeed then
    BufLen := DWORD(pTRBuf) - DWORD(Buffer); //ExecLen;


end;

procedure TFormMain.MyMessage(var MsgData: TWmCopyData);
var
  sData: string;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_QUIT:
      begin
        if g_fServiceStarted then
        begin
          StopService();
          g_fCanClose := True;
          Close();
        end;
      end;
  end;
end;

procedure TFormMain.MyTesMessage(var msg: TMessage);
var
  I: Integer;
begin
{$I '..\Common\Macros\VMPB.inc'}
  if msg.wParam = 2 then
  begin
    Label2.Caption := Format(VMProtectDecryptStringA('该版本还%d天到期,请尽快续费'), [msg.lParam]);
    Label2.Alignment := taCenter;
    Label2.Font.Color := clRed;
  end

  else if msg.wParam = 1 then
  begin
    Label2.Caption := VMProtectDecryptStringA('该版本已经到期!!!');
    Label2.Alignment := taCenter;
    Label2.Font.Color := clRed;
  end
  else if msg.wParam = 3 then
  begin
    Label2.Caption := VMProtectDecryptStringA('该版本已停用,请更新!!!');
    Label2.Alignment := taCenter;
    Label2.Font.Color := clRed;
  end
  else if msg.wParam = 0 then
  begin
    Label2.Caption := VMProtectDecryptStringA('版本正常');
    Label2.Alignment := taRightJustify;
    Label2.Font.Color := clBlue;
  end
  else if msg.wParam = 4 then
  begin
    if (n4ErrCount > 3) then
    begin
      Label2.Caption := VMProtectDecryptStringA('本登录器已停用，请更新');
      Label2.Alignment := taRightJustify;
      Label2.Font.Color := clRed;
    end;
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;

end.
