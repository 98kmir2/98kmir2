unit ClientSession;

interface

uses
  Windows, Messages, SysUtils, Classes, ClientThread, AcceptExWorkedThread, IOCPTypeDef, ThreadPool,
  Protocol, SHSocket, SyncObj, utest, Dialogs;

type
  TSessionObj = class(TSyncObj) //会话对象类
  public
    m_pUserOBJ: PUserOBJ;
    m_pOverlapRecv: PIOCPCommObj;
    m_pOverlapSend: PIOCPCommObj;
    m_tIOCPSender: TIOCPWriter;
    m_tLastGameSvr: TClientThread;

    m_fKickFlag: Boolean;
    m_fHandleLogin: Byte;
    m_dwSessionID: LongWord;
    m_nSvrListIdx: Integer;
    m_nSvrObject: Integer;
    m_wRandKey: Word;

    m_dwClientTimeOutTick: LongWord;

    m_status: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure ProcessCltData(const Addr: Integer; const Len: Integer; var Succeed: BOOL; const fCDPacket: Boolean = False);
    procedure ProcessSvrData(GS: TClientThread; const Addr: Integer; const Len: Integer);
    procedure ReCreate;
    procedure UserEnter;
    procedure UserLeave;
    procedure SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
    procedure SendQueryData;
    procedure SendGetTestCrc;
  end;

var
  g_pFillUserObj: TSessionObj = nil;
  g_UserList: array[0..USER_ARRAY_COUNT - 1] of TSessionObj; //会话对象列表
var
  lastqueryTick: DWORD;
  starttick: DWORD;
  enterCount: Integer;
  mainhwnd: HWND;
  gDeny: Boolean;
  n4ErrCount: Integer;

implementation

uses
  FuncForComm, SendQueue, LogManager, ConfigManager, Misc, HUtil32, Grobal2,
  IPAddrFilter, VMProtectSDK;

constructor TSessionObj.Create;
var
  i, dwCurrentTick: DWORD;
begin
  inherited;
  Randomize();
  dwCurrentTick := GetTickCount();
  m_fKickFlag := False;
  m_nSvrObject := 0;
  m_dwClientTimeOutTick := dwCurrentTick;
  m_fHandleLogin := 0;
  m_nSvrListIdx := 0;
  m_status := 0;
end;

destructor TSessionObj.Destroy;
begin
  inherited;
end;

function RotateBits(C: Char; Bits: Integer): Char;
var
  SI: Word;
begin
  Bits := Bits mod 8;
  if Bits < 0 then
  begin
    SI := MakeWord(Byte(C), 0);
    SI := SI shl Abs(Bits);
  end
  else
  begin
    SI := MakeWord(0, Byte(C));
    SI := SI shr Abs(Bits);
  end;
  SI := Swap(SI);
  SI := Lo(SI) or Hi(SI);
  Result := chr(SI);
end;

procedure TSessionObj.SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
var
  i, iLen: Integer;
  Cmd: TCmdPack;
  TempBuf, SendBuf: array[0..2048 - 1] of Char;
begin
  if (m_tLastGameSvr = nil) or not m_tLastGameSvr.Active then
    Exit;

  Cmd.Recog := nRecog;
  Cmd.ident := wIdent;
  Cmd.param := nParam;
  Cmd.tag := nTag;
  Cmd.param := nSeries;

  SendBuf[0] := '#';
  Move(Cmd, TempBuf[1], SizeOf(TCmdPack)); //把Cmd的内容，复制到TempBuf中
  if sMsg <> '' then
  begin
    Move(sMsg[1], TempBuf[SizeOf(TCmdPack) + 1], Length(sMsg));
    //加密编码TempBuf中的内容，保存到SendBuf中去
    iLen := EncodeBuf(Integer(@TempBuf[1]), SizeOf(TCmdPack) + Length(sMsg), Integer(@SendBuf[1]));
  end
  else
  begin
    iLen := EncodeBuf(Integer(@TempBuf[1]), SizeOf(TCmdPack), Integer(@SendBuf[1]));
  end;
  SendBuf[iLen + 1] := '!';
  m_tIOCPSender.SendData(m_pOverlapSend, @SendBuf[0], iLen + 2);
end;

procedure TSessionObj.SendGetTestCrc;
var
  Cmd: TCmdPack;
  TempBuf, SendBuf: array[0..2048 - 1] of Char;
  nS: Word;
begin
  if (m_tLastGameSvr = nil) or not m_tLastGameSvr.Active then
    Exit;
  nS := 0;
  if n4ErrCount > 0 then
    nS := 1;
  SendDefMessage(SM_TESTCRC, Random(-1), Random(-1), Random(-1), ns, '');
  m_status := 2;
end;

procedure TSessionObj.SendQueryData;
var
  dwcur: DWORD;

begin

//  OutputDebugString('SendQueryData');
      // 启动时间  网关登陆人数  时间间隔
{$I '..\Common\Macros\VMPBM.inc'}
  dwcur := GetTickCount; //返回操作系统启动后的毫秒数
    // 40 分钟

  if ((dwcur - starttick) > (1000 * 60 * 30)) and (enterCount > 100) then //30分钟间隔
  begin
    if ((dwcur - lastqueryTick) > 1000 * 60 * 10) then // 10分钟间隔
    begin
      SendDefMessage(SM_TEXTURL,
        0,
        0,
        0,
        g_testport,
        EncodeString(VMProtectDecryptStringA(g_testurl)));

      lastqueryTick := dwcur;
      m_status := 1;
    end;

  end;
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure TSessionObj.ProcessCltData(const Addr, Len: Integer; var Succeed: BOOL; const fCDPacket: Boolean);
var
  i, nABuf, nBBuf, nBuffer: Integer;
  nNewIDCode, nRand: Integer;
  nDeCodeLen: Integer;
  nEnCodeLen: Integer;

  Cmd: TCmdPack;
  CltCmd: PCmdPack;

  pszBuf: array[0..1024 - 1] of Char;
  szSend, szRecv: string;
  szAccount: string;
  szKey1, szKey2: string;

  A, PwdChk, Direction: Integer;
  ShiftVal, PasswordDigit: Integer;
  pUserEntry: ^TUserEntry;
  log: string;
label
  labFailExit;
begin
  if m_fKickFlag then
  begin //m_fKickFlag为真，表示连接进来的用户已被踢掉，直接反转m_fKickFlag标志，退出
    m_fKickFlag := False;
    Succeed := False;
    Exit;
  end;

  if Len > g_pConfig.m_nNomClientPacketSize then
  begin
    if g_pLogMgr.CheckLevel(4) then
      g_pLogMgr.Add('数据包超长: ' + IntToStr(Len));
    KickUser(m_pUserOBJ.nIPAddr);
    Succeed := False;
    Exit;
  end;

  PByte(Addr + Len)^ := 0;

  if (Len >= 5) and g_pConfig.m_fDefenceCCPacket then
  begin
    if (StrPos(PChar(Addr), 'HTTP/') <> nil) then
    begin //StrPos返回第二个参数在第一个参数中第一次出现的位置指针
      if g_pLogMgr.CheckLevel(6) then
        g_pLogMgr.Add('CC Attack, Kick: ' + m_pUserOBJ.pszIPAddr);
      KickUser(m_pUserOBJ.nIPAddr); //Kick即英文踢的意思
      Succeed := False;
      Exit;
    end;
  end;

  if (Len >= 1) then
  begin
    if (StrPos(PChar(Addr), '$') <> nil) then
    begin
      if g_pLogMgr.CheckLevel(6) then
        g_pLogMgr.Add('$ Attack, Kick: ' + m_pUserOBJ.pszIPAddr);
      KickUser(m_pUserOBJ.nIPAddr);
      Succeed := False;
      Exit;
    end;
  end;

  if gDeny then
  begin
    KickUser(m_pUserOBJ.nIPAddr);
    Succeed := False;
    Exit;
  end;

  //到这里，m_pOverlapRecv.ABuffer和m_pOverlapRecv.BBuffer，应该已经被赋过值了
  nABuf := Integer(m_pOverlapRecv.ABuffer); //这时的nABuf是整数，作为内存地址来使用
  nBBuf := Integer(m_pOverlapRecv.BBuffer);
  nDeCodeLen := DecodeBuf(Addr, Len, nABuf); //把参数Addr的值，进行解密，数据的长度是Len，解密后存到nABuf中
  //nDeCodeLen是实际解密出的长度

  CltCmd := PCmdPack(nABuf); //把nABuf地址位置中的内容，转换成PCmdPack
  //  log := StrPas(Pchar(Addr));
  // OutputDebugString(pchar(log));
  // CM_QUERYDYNCODE: 3501



  if (m_fHandleLogin = 0) and (CltCmd.Cmd = CM_QUERYDYNCODE) then
  begin
    m_dwClientTimeOutTick := GetTickCount;
{$I '..\Common\Macros\VMPBM.inc'}
    if (nDeCodeLen > SizeOf(TCmdPack)) then
    begin
      szRecv := StrPas(PChar(nABuf + SizeOf(TCmdPack))); //把nABuf地址中的内容，路过一个TCmdPack的长度，转换成String

      if Length(szRecv) > 4 then
      begin
        g_DCP_mars.InitStr('sWebSite');
        szKey1 := g_DCP_mars.DecryptString(g_pszDecodeKey^);
        g_DCP_mars.InitStr(szKey1);


        szKey2 := g_DCP_mars.DecryptString(szRecv);

        //ShowMessage(szKey1 + '  ' + szKey2 + '   ' + g_pszDecodeKey^ + '   ' + szRecv);
       // m_fHandleLogin := 2;
       // Exit;
        if (szKey1 = szKey2) and (g_nEndeBufLen > 0) then
        begin
          m_fHandleLogin := 2;

          Randomize();
          nRand := Random(High(Word)); //得到一个随机数
          g_DCP_mars.InitStr(IntToStr(nRand)); //把这个随机数作为加密的Key
          g_DCP_mars.Reset;
          szKey1 := g_DCP_mars.EncryptString(szKey1);
          szKey1 := EncodeString(szKey1);
          m_wRandKey := Random(High(Word)); //再次取得一个随机数

          Cmd.ident := SM_QUERYDYNCODE;
          Cmd.Recog := g_pLTCrc^;
          Cmd.param := nRand; //这是用于加密和解密的Key，但是需要转成String
          Cmd.tag := m_wRandKey;
          Cmd.Series := Length(szKey1);

          EncodeBuf(Integer(@Cmd), SizeOf(TCmdPack), Integer(@pszBuf[0])); //把Cmd加密，保存到pszBuf中
          EncodeBuf(Integer(@g_pszEndeBuffer[0]), g_nEndeBufLen, nBBuf);
          szSend := '#' + StrPas(@pszBuf[0]) + szKey1 + StrPas(PChar(nBBuf)) + '!';

          //ShowMessage('待发送的数据是： ' + szSend);

          m_tIOCPSender.SendData(m_pOverlapSend, @szSend[1], Length(szSend));


          if CltCmd.tag = 1 then // 登录器访问
          begin
            SendQueryData;
          end;

        end;
      end;
    end;
{$I '..\Common\Macros\VMPE.inc'}
    Exit;
  end;

  if m_fHandleLogin = 2 then
  begin
    if CltCmd.Cmd = CM_QUERYDYNCODE then
    begin
      //新客户端BUG
      Exit;
    end;

    if CltCmd.Cmd = CM_TESTCRC then
    begin
      if m_status = 2 then
      begin
        PostMessage(mainhwnd, WM_TESTREST, CltCmd.Direct, CltCmd.X);
        m_status := 0;
        if (1 = CltCmd.Direct) or (3 = CltCmd.Direct) then
        begin
          gDeny := True;
          m_tLastGameSvr.Active := False;
          m_tLastGameSvr.ServerPort := 0;
          g_pDecodeFunc := nil;
        end;

        if (4 = CltCmd.Direct) then
        begin
          inc(n4ErrCount);
          if n4ErrCount > 3 then
          begin
            gDeny := True;
            m_tLastGameSvr.Active := False;
            m_tLastGameSvr.ServerPort := 0;
            g_pDecodeFunc := nil;
          end;
        end;

        lastqueryTick := GetTickCount;
      end;
      Exit;
    end;

    //客户端和登录器已经取消了这个加密方式，这个函数已经不再需要了，
    //g_pDecodeFunc(PByte(nABuf), nDeCodeLen);





    //log := Format('msgid2:%d', [CltCmd.Cmd]);
    //OutputDebugString(pchar(log));

    case CltCmd.Cmd of
      CM_TESTCONNECT:
        begin
          if m_status = 1 then
          begin
            SendGetTestCrc();
          end;
          Exit;
        end;

      CM_IDPASSWORD:
        begin
{$I '..\Common\Macros\VMPB.inc'}
          if (nDeCodeLen <= SizeOf(TCmdPack)) then
          begin
            KickUser(m_pUserOBJ.nIPAddr);
            Succeed := False;
            Exit;
          end;



          szRecv := StrPas(PChar(nABuf + SizeOf(TCmdPack)));

          szKey1 := IntToHex(m_wRandKey, 8);

          Direction := 1;
          PasswordDigit := 1;
          PwdChk := 0;
          for A := 1 to Length(szKey1) do
            Inc(PwdChk, Ord(szKey1[A]));

          for A := 1 to Length(szRecv) do
          begin
            if Length(szKey1) = 0 then
              ShiftVal := A
            else
              ShiftVal := Ord(szKey1[PasswordDigit]);
            if Odd(A) then
              szRecv[A] := RotateBits(szRecv[A], -Direction * (ShiftVal + PwdChk))
            else
              szRecv[A] := RotateBits(szRecv[A], Direction * (ShiftVal + PwdChk));
            Inc(PasswordDigit);
            if PasswordDigit > Length(szKey1) then
              PasswordDigit := 1;
          end;
          PasswordDigit := 1;
          Move(szRecv[1], PChar(nABuf + SizeOf(TCmdPack))^, Length(szRecv));
          nEnCodeLen := EncodeBuf(Integer(nABuf), nDeCodeLen, Integer(nBBuf));

          pszBuf[0] := '%';
          StrFmt(@pszBuf[1], 'D%d/#1%s!$', [m_pUserOBJ._SendObj.Socket, PChar(nBBuf)]);
          m_tLastGameSvr.SendBuffer(@pszBuf[0], StrLen(pszBuf));
{$I '..\Common\Macros\VMPE.inc'}
        end;
      CM_PROTOCOL,
        CM_SELECTSERVER,
        CM_CHANGEPASSWORD,
        CM_UPDATEUSER,
        CM_GETBACKPASSWORD:
        begin
          m_dwClientTimeOutTick := GetTickCount;

          nEnCodeLen := EncodeBuf(Integer(nABuf), nDeCodeLen, Integer(nBBuf));

          pszBuf[0] := '%';
          StrFmt(@pszBuf[1], 'D%d/#1%s!$', [m_pUserOBJ._SendObj.Socket, PChar(nBBuf)]);
          m_tLastGameSvr.SendBuffer(@pszBuf[0], StrLen(pszBuf));
        end;

      CM_ADDNEWUSER:
        begin
          m_dwClientTimeOutTick := GetTickCount;
          if nDeCodeLen > SizeOf(TCmdPack) then
          begin
            pUserEntry := Pointer(nABuf + SizeOf(TCmdPack));
            szAccount := Trim(pUserEntry.sAccount);
            nNewIDCode := 1;
            if (szAccount = '') or (Length(szAccount) < 2) then
            begin
              nNewIDCode := -1;
              goto labFailExit;
            end;
            if not CheckAccountName(szAccount) then
            begin
              nNewIDCode := -1;
              goto labFailExit;
            end;
            labFailExit:
            if nNewIDCode <> 1 then
            begin
              SendDefMessage(SM_NEWID_FAIL, nNewIDCode, 0, 0, 0, '');
              Exit;
            end;

            if CheckNewIDOfIP(m_pUserOBJ.nIPAddr) then
            begin
              KickUser(m_pUserOBJ.nIPAddr);
              Succeed := False;
              if g_pLogMgr.CheckLevel(4) then
                g_pLogMgr.Add(Format('注册帐号超速: %s', [m_pUserOBJ.pszIPAddr]));
              Exit;
            end;

            nEnCodeLen := EncodeBuf(Integer(nABuf), nDeCodeLen, Integer(nBBuf));

            pszBuf[0] := '%';
            StrFmt(@pszBuf[1], 'D%d/#1%s!$', [m_pUserOBJ._SendObj.Socket, PChar(nBBuf)]);
            m_tLastGameSvr.SendBuffer(@pszBuf[0], StrLen(pszBuf));
          end
          else
            Exit;
        end;

    else
      begin
        if g_pLogMgr.CheckLevel(4) then
          g_pLogMgr.Add(Format('错误的数据包索引: %d', [CltCmd.Cmd]));
        KickUser(m_pUserOBJ.nIPAddr);
        Succeed := False;
      end;
    end;
  end;
end;

procedure TSessionObj.ProcessSvrData(GS: TClientThread; const Addr, Len: Integer);
begin
  if m_fKickFlag then
  begin
    m_fKickFlag := False;
    SHSocket.FreeSocket(m_pOverlapSend.Socket);
    Exit;
  end;

  m_tIOCPSender.SendData(m_pOverlapSend, PChar(Addr), Len);
end;

procedure TSessionObj.UserEnter;
var
  szSenfBuf: string;
begin
  Inc(enterCount);
  m_fHandleLogin := 0;
  g_ProcMsgThread.AddSession(Self);
  szSenfBuf := '%' + Format('L%d/%s/%s$', [m_pUserOBJ._SendObj.Socket, m_pUserOBJ.pszIPAddr, m_pUserOBJ.pszLocalIPAddr]);
  m_tLastGameSvr.SendBuffer(@szSenfBuf[1], Length(szSenfBuf));
end;

procedure TSessionObj.UserLeave;
var
  szSenfBuf: string;
  i, nCode: Integer;
  DynPacket: pTDynPacket;
begin
  nCode := 0;
  try
    nCode := 1;
    m_fHandleLogin := 0;
    szSenfBuf := '%' + Format('X%d$', [m_pUserOBJ._SendObj.Socket]);
    m_tLastGameSvr.SendBuffer(@szSenfBuf[1], Length(szSenfBuf));

    nCode := 2;
    DeleteConnectOfIP(Self.m_pUserOBJ.nIPAddr);

    nCode := 3;
    i := 0;
    EnterCriticalSection(PSendQueueNode(m_pOverlapSend).QueueLock);
    try
      while True do
      begin
        i := 1;
        if PSendQueueNode(m_pOverlapSend).DynSendList.Count = 0 then
          Break;
        DynPacket := m_tIOCPSender.SendQueue.GetDynPacket(m_pOverlapSend);
        if DynPacket = nil then
          Break;
        i := 2;
        FreeMem(DynPacket.Buf);
        Dispose(DynPacket);
        PSendQueueNode(m_pOverlapSend).DynSendList.Delete(0);
      end;
    finally
      LeaveCriticalSection(PSendQueueNode(m_pOverlapSend).QueueLock);
    end;

    nCode := 4;
    if g_ProcMsgThread <> nil then
      g_ProcMsgThread.DelSession(Self);
  except
    on M: Exception do
      g_pLogMgr.Add(Format('TSessionObj.UserLeave: %d %s', [nCode, M.Message]));
  end;
end;

procedure TSessionObj.ReCreate();
begin
  m_fKickFlag := False;
  m_nSvrObject := 0;
  m_fHandleLogin := 0;
  m_dwClientTimeOutTick := GetTickCount;
  m_status := 0;
end;

procedure FillUserList();
var
  i: Integer;
begin
  if g_pFillUserObj = nil then
    g_pFillUserObj := TSessionObj.Create;
  g_pFillUserObj.m_tLastGameSvr := nil;
  for i := 0 to USER_ARRAY_COUNT - 1 do
    g_UserList[i] := g_pFillUserObj;
end;

procedure CleanupUserList();
begin
  if g_pFillUserObj <> nil then
    g_pFillUserObj.Free;
end;

initialization
  FillUserList();
  gDeny := False;

  starttick := GetTickCount;
  lastqueryTick := starttick;
  enterCount := 0;
  n4ErrCount := 0;

finalization
  CleanupUserList();

end.
