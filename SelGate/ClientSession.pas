unit ClientSession;

interface

uses
  Windows, Messages, SysUtils, Classes, ClientThread, AcceptExWorkedThread, IOCPTypeDef, ThreadPool,
  Protocol, SHSocket, SyncObj, Dialogs;

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

    constructor Create;
    destructor Destroy; override;
    procedure ProcessCltData(const Addr: Integer; const Len: Integer; var Succeed: BOOL; const fCDPacket: Boolean = False);
    procedure ProcessSvrData(GS: TClientThread; const Addr: Integer; const Len: Integer);
    procedure ReCreate;
    procedure UserEnter;
    procedure UserLeave;
    procedure SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
  end;

var
  g_pFillUserObj: TSessionObj = nil;
  g_UserList: array[0..USER_ARRAY_COUNT - 1] of TSessionObj; //会话对象列表
var
  starttick: DWORD;
  enterCount: Integer;
  mainhwnd: HWND;
  gDeny: Boolean;
implementation

uses
  FuncForComm, SendQueue, LogManager, ConfigManager, Misc, HUtil32, Grobal2,
  IPAddrFilter;

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
end;

destructor TSessionObj.Destroy;
begin
  inherited;
end;

//function RotateBits(C: Char; Bits: Integer): Char;
//var
//  SI: Word;
//begin
//  Bits := Bits mod 8;
//  if Bits < 0 then begin
//    SI := MakeWord(Byte(C), 0);
//    SI := SI shl Abs(Bits);
//  end
//  else begin
//    SI := MakeWord(0, Byte(C));
//    SI := SI shr Abs(Bits);
//  end;
//  SI := Swap(SI);
//  SI := Lo(SI) or Hi(SI);
//  Result := chr(SI);
//end;

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


procedure TSessionObj.ProcessCltData(const Addr, Len: Integer; var Succeed: BOOL; const fCDPacket: Boolean);
var
  i, nABuf, nBBuf, nBuffer: Integer;
  nNewIDCode, nRand: Integer;
  nDeCodeLen: Integer;
  nEnCodeLen: Integer;
  Cmd: TCmdPack;
  CltCmd: PCmdPack;
  pszBuf: array[0..1024 - 1] of Char;
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
  if m_fHandleLogin = 0 then
  begin
    case CltCmd.Cmd of
      CM_QUERYSELCHARCODE,
        CM_QUERYCHR, CM_NEWCHR, CM_DELCHR, CM_SELCHR, CM_QUERYDELCHR, CM_GETBACKDELCHR:
        begin
          m_dwClientTimeOutTick := GetTickcount;
          nEnCodeLen := EncodeBuf(Integer(nABuf), nDeCodeLen, Integer(nBBuf));
          pszBuf[0] := '%';
          StrFmt(@pszBuf[1], '>%d/#1%s!$', [m_PUserOBJ._SendObj.Socket, PChar(nBBuf)]);
          m_tLastGameSvr.SendBuffer(@pszBuf[0], StrLen(pszBuf));
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
  szSenfBuf := '%' + Format('K%d/%s/%s$', [m_pUserOBJ._SendObj.Socket, m_pUserOBJ.pszIPAddr, m_pUserOBJ.pszLocalIPAddr]);
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
    szSenfBuf := '%' + Format('L%d$', [m_pUserOBJ._SendObj.Socket]);
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
//  m_status := 0;
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
//  lastqueryTick := starttick;
  enterCount := 0;
//  n4ErrCount := 0;

finalization
  CleanupUserList();

end.
