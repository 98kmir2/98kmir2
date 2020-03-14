unit ClientSession;

interface

uses
  Windows, dialogs, Messages, SysUtils, Classes, ClientThread, AcceptExWorkedThread, IOCPTypeDef, ThreadPool, CDServerSDK,
  Protocol, MD5, SHSocket, SyncObj, UJxModule;

type
  TCheckStep = (csCheckLogin, csSendCheck, csSendSmu, csSendFinsh, csCheckTick);
type
  TSessionObj = class(TSyncObj)
  private
    procedure InitJxModule;
    procedure AfterSendSmug;
    function ReadforSmuggle: Boolean;
  public
    m_xHWID: MD5.MD5Digest;
    m_fOverClientCount: Boolean;
    m_pUserOBJ: PUserOBJ;
    m_pOverlapRecv: PIOCPCommObj;
    m_pOverlapSend: PIOCPCommObj;
    m_tIOCPSender: TIOCPWriter;
    m_tLastGameSvr: TClientThread;

    m_fKickFlag: Boolean;
    m_fSpeedLimit: Boolean;
    m_fHandleLogin: Byte;
    m_dwSessionID: LongWord;
    m_nSvrListIdx: Integer;
    m_szAccount: string[15];
    m_szChrName: string[15];
    m_szTrimChrName: string[15];
    //m_szLoginPacket: string[198];
    m_nSvrObject: Integer;
    m_nChrStutas: Integer;
    m_nItemSpeed: Integer;
    m_nDefItemSpeed: Integer;

    m_dwChatTick: LongWord;
    m_dwLastDirection: LongWord;
    m_dwEatTick: LongWord;
    m_dwHeroEatTick: LongWord;
    m_dwPickupTick: LongWord;
    m_dwMoveTick: LongWord;
    m_dwAttackTick: LongWord;
    m_dwSpellTick: LongWord;
    m_dwSitDownTick: LongWord;
    m_dwTurnTick: LongWord;
    m_dwButchTick: LongWord;

    m_dwDealTick: LongWord;
    m_dwOpenStoreTick: LongWord;
    m_dwWaringTick: LongWord;
    m_dwClientTimeOutTick: LongWord;

    m_xMsgList: Classes.TList;



    //    m_Vtable: PVtalbe;

    // 对发送的数据
//    m_SendClientData: LongWord;
    m_SendIndx: LongWord;
        // 最后一次发送的数据
    m_LastSmu: LongWord;

        //发送之后  1000  ms 之内有确认包，
    //如果没有，就当发送失败，再发一次 容忍 3次错误 3次失败之后，就当成功
    //

    // 重入 ,
    m_reEnter: Boolean;
    m_lastSmuTick: LongWord;
    m_SendSucess: Boolean;
    m_ErrSend: LongWord;
    m_JxModule: TJxMoudle;

//    m_SendCheck: Boolean;
    m_SendCheckTick: LongWord;
    m_checkstr: string;
//    m_StartTick: LongWord;

    m_Stat: TCheckStep;
    m_FinishTick: LongWord;

    constructor Create;
    destructor Destroy; override;
    procedure WriteIndex(value: LongWord);
    property SendIndex: LongWord read m_SendIndx write WriteIndex;

    function PeekDelayMsg(nCmd: Integer): Boolean;
    function GetDelayMsg(pMsg: pTDelayMsg): Boolean;
    function GetDelayMsgCount(): Integer;
    procedure ProcessDelayMsg();
    procedure SendDelayMsg(nMid, nDir, nIdx, nLen: Integer; pMsg: PChar; dwDelay: LongWord);
    procedure ProcessCltData(const Addr: Integer; const Len: Integer; var Succeed: BOOL; const fCDPacket: Boolean = False);
    procedure ProcessSvrData(GS: TClientThread; const Addr: Integer; const Len: Integer);
    procedure ReCreate;
    procedure UserEnter;
    procedure UserLeave;
    procedure HandleLogin(const Addr: Integer; Len: Integer; var Succeed: BOOL);
    procedure SendFirstPack(const szPacket: string);
    procedure SendKickMsg(KickType: Integer);
    procedure SendSysMsg(const szMsg: string);
    procedure SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
    function GenRandString(len: Integer): string;
    procedure ClientTick();
  end;

var
  g_pFillUserObj: TSessionObj = nil;
  //g_UserList                : array[0..USER_ARRAY_COUNT - 1] of TSessionObj;
  g_UserList: array of TSessionObj;

function timeGetTime: DWord; stdcall;
function GetTickCount: DWord;

implementation

uses
  FuncForComm, SendQueue, LogManager, ConfigManager, Misc, TableDef, HUtil32, Grobal2,
  ChatCmdFilter, AbusiveFilter, Punishment, Filter, VMProtectSDK, JxLogger;

function timeGetTime; external _STR_LIB_MMSYSTEM Name 'timeGetTime';

function GetTickCount: DWord;
begin
  Result := timeGetTime;
end;

procedure TSessionObj.AfterSendSmug;
begin
  m_lastSmuTick := GetTickCount;
  m_SendSucess := False;
end;

procedure TSessionObj.ClientTick;
begin
//  if m_Stat = csCheckTick and m_Jx then
//  begin
//    m_checkstr := GenRandString(5 + Random(5));
//    m_jx
//
//
//  end;

end;

constructor TSessionObj.Create;
var
  i, dwCurrentTick: DWord;
begin
  inherited;
  Randomize();

  FillChar(m_xHWID, SizeOf(MD5Digest), 0);
  m_fOverClientCount := False;
  dwCurrentTick := GetTickCount();
  m_fKickFlag := False;
  m_xMsgList := Classes.TList.Create;
  m_fSpeedLimit := False;
  m_nSvrObject := 0;
  m_nItemSpeed := 0;
  m_nDefItemSpeed := 0;
  m_dwLastDirection := LongWord(-1);
  m_dwPickupTick := dwCurrentTick;
  m_dwEatTick := dwCurrentTick;
  m_dwHeroEatTick := dwCurrentTick;
  m_dwMoveTick := dwCurrentTick;
  m_dwSpellTick := dwCurrentTick;
  m_dwAttackTick := dwCurrentTick;
  m_dwChatTick := dwCurrentTick;
  m_dwTurnTick := dwCurrentTick;
  m_dwButchTick := dwCurrentTick;
  m_dwSitDownTick := dwCurrentTick;
  m_dwClientTimeOutTick := dwCurrentTick;
  m_fHandleLogin := 0;
  m_nSvrListIdx := 0;
  m_szAccount := '';
  m_szChrName := '';
  m_szTrimChrName := '';

  m_lastSmuTick := dwCurrentTick;
  SendIndex := 0;
  m_JxModule := nil;
//  m_StartTick := 0;
  m_reEnter := False;
  m_Stat := csCheckLogin;
end;

procedure TSessionObj.ReCreate();
begin
  FillChar(m_xHWID, SizeOf(MD5Digest), 0);

  m_fOverClientCount := False;
  m_fKickFlag := False;
  m_fSpeedLimit := False;
  m_nSvrObject := 0;
  m_nItemSpeed := 0;
  m_nDefItemSpeed := 0;
  m_fHandleLogin := 0;
  m_dwClientTimeOutTick := GetTickCount;
  m_szAccount := '';
  m_szChrName := '';
  m_szTrimChrName := '';

  m_JxModule := nil;
//  m_StartTick := 0;
  m_reEnter := False;
  m_Stat := csCheckLogin;
end;

destructor TSessionObj.Destroy;
var
  i: Integer;
begin
  Lock();
  try
    for i := 0 to m_xMsgList.Count - 1 do
      Dispose(pTDelayMsg(m_xMsgList[i]));
    m_xMsgList.Free;
  finally
    UnLock();
  end;
  inherited;
end;

procedure TSessionObj.SendDelayMsg(nMid, nDir, nIdx, nLen: Integer; pMsg: PChar; dwDelay: LongWord);
var
  pDelayMsg: pTDelayMsg;
begin
  if (nLen > 0) and (nLen < DELAY_BUFFER_LEN) then
  begin
    New(pDelayMsg);
    pDelayMsg.nMag := nMid;
    pDelayMsg.nDir := nDir;
    pDelayMsg.nCmd := nIdx;
    pDelayMsg.dwDelayTime := GetTickCount + dwDelay;
    pDelayMsg.nBufLen := nLen;
    Move(pMsg^, pDelayMsg.pBuffer[0], nLen);
    Lock();
    m_xMsgList.Add(pDelayMsg);
    UnLock();
  end;
end;

function TSessionObj.PeekDelayMsg(nCmd: Integer): Boolean;
var
  i, iCmd: Integer;
  pDelayMsg: pTDelayMsg;
begin
  Result := False;
  Lock();
  try
    i := 0;
    while m_xMsgList.Count > i do
    begin
      iCmd := pTDelayMsg(m_xMsgList[i]).nCmd;
      if nCmd = CM_HIT then
      begin
        if (iCmd = CM_HIT) or
          (iCmd = CM_HEAVYHIT) or
          (iCmd = CM_BIGHIT) or
          (iCmd = CM_POWERHIT) or
          (iCmd = CM_LONGHIT) or
          (iCmd = CM_WIDEHIT) or
          (iCmd = CM_CRSHIT) or
          (iCmd = CM_SQUHIT) or
          (iCmd = CM_TWNHIT) or
          (iCmd = CM_FIREHIT) or
          (iCmd = CM_HERO_LONGHIT2) or
          (iCmd = CM_PURSUEHIT) or
          (iCmd = CM_SMITELONGHIT2) or
          (iCmd = CM_SMITELONGHIT3) then
        begin
          Result := True;
          Break;
        end
        else
          Inc(i);
      end
      else if nCmd = CM_RUN then
      begin
        if (iCmd = CM_WALK) or (iCmd = CM_RUN) then
        begin
          Result := True;
          Break;
        end
        else
          Inc(i);
      end
      else if iCmd = nCmd then
      begin
        Result := True;
        Break;
      end
      else
        Inc(i);
    end;
  finally
    UnLock();
  end;
end;

function TSessionObj.GetDelayMsgCount(): Integer;
begin
  Result := 0;
  Lock();
  try
    Result := m_xMsgList.Count;
  finally
    UnLock();
  end;
end;

function TSessionObj.GenRandString(len: Integer): string;
var i: Integer;
const SourceStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
begin
  randomize;
  Result := '';
  for i := 1 to len do
    Result := Result + sourcestr[Random(62) + 1];

end;

function TSessionObj.GetDelayMsg(pMsg: pTDelayMsg): Boolean;
var
  i: Integer;
  pDelayMsg: pTDelayMsg;
begin
  Result := False;
  Lock();
  try
    i := 0;
    while m_xMsgList.Count > i do
    begin
      pDelayMsg := m_xMsgList.Items[i];
      if (pDelayMsg.dwDelayTime <> 0) and (GetTickCount < pDelayMsg.dwDelayTime) then
      begin
        Inc(i);
        Continue;
      end;
      m_xMsgList.Delete(i);
      pMsg.nMag := pDelayMsg.nMag;
      pMsg.nDir := pDelayMsg.nDir;
      pMsg.nCmd := pDelayMsg.nCmd;
      pMsg.nBufLen := pDelayMsg.nBufLen;
      Move(pDelayMsg.pBuffer[0], pMsg.pBuffer[0], pMsg.nBufLen);
      Dispose(pDelayMsg);
      Result := True;
      Break;
    end;
  finally
    UnLock();
  end;
end;

procedure TSessionObj.ProcessDelayMsg();
var
  nNextMov, nNextAtt: Integer;
  dwCurrentTick: LongWord;
  DelayMsg: TDelayMsg;
begin
  if GetDelayMsgCount() = 0 then
    Exit;

  while GetDelayMsg(@DelayMsg) do
  begin
    if DelayMsg.nBufLen > 0 then
    begin
      m_tLastGameSvr.SendBuffer(DelayMsg.pBuffer, DelayMsg.nBufLen);
      dwCurrentTick := GetTickCount;
      case DelayMsg.nCmd of
        CM_BUTCH:
          begin
            m_dwButchTick := dwCurrentTick;
          end;
        CM_SITDOWN:
          begin
            m_dwSitDownTick := dwCurrentTick;
          end;
        CM_TURN:
          begin
            m_dwTurnTick := dwCurrentTick;
          end;
        CM_WALK, CM_RUN:
          begin
            m_dwMoveTick := dwCurrentTick;
            m_dwSpellTick := dwCurrentTick - g_pConfig.m_nMoveNextSpellCompensate; //1200
            if m_dwAttackTick < dwCurrentTick - g_pConfig.m_nMoveNextAttackCompensate then
              m_dwAttackTick := dwCurrentTick - g_pConfig.m_nMoveNextAttackCompensate; //900
            m_dwLastDirection := DelayMsg.nDir;
          end;
        CM_HIT, CM_HEAVYHIT, CM_BIGHIT, CM_POWERHIT,
          CM_LONGHIT, CM_WIDEHIT, CM_CRSHIT, CM_SQUHIT,
          CM_TWNHIT, CM_FIREHIT, CM_HERO_LONGHIT2,
          CM_PURSUEHIT, CM_SMITELONGHIT2, CM_SMITELONGHIT3:
          begin
            if m_dwAttackTick < dwCurrentTick then
              m_dwAttackTick := dwCurrentTick;

            if g_pConfig.m_fItemSpeedCompensate then
            begin
              m_dwMoveTick := dwCurrentTick - (g_pConfig.m_nAttackNextMoveCompensate + g_pConfig.m_nMaxItemSpeedRate * m_nItemSpeed); //550
              m_dwSpellTick := dwCurrentTick - (g_pConfig.m_nAttackNextSpellCompensate + g_pConfig.m_nMaxItemSpeedRate * m_nItemSpeed); //1150
            end
            else
            begin
              m_dwMoveTick := dwCurrentTick - g_pConfig.m_nAttackNextMoveCompensate; //550
              m_dwSpellTick := dwCurrentTick - g_pConfig.m_nAttackNextSpellCompensate; //1150
            end;

            m_dwLastDirection := DelayMsg.nDir;
          end;
        CM_SPELL:
          begin
            m_dwSpellTick := dwCurrentTick;
            if MAIGIC_ATTACK_ARRAY[DelayMsg.nMag] then
            begin
              nNextMov := g_pConfig.m_nSpellNextMoveCompensate;
              nNextAtt := g_pConfig.m_nSpellNextAttackCompensate;
            end
            else
            begin
              nNextMov := g_pConfig.m_nSpellNextMoveCompensate + 80;
              nNextAtt := g_pConfig.m_nSpellNextAttackCompensate + 80;
            end;

            m_dwMoveTick := dwCurrentTick - nNextMov; //550
            if m_dwAttackTick < dwCurrentTick - nNextAtt then //900
              m_dwAttackTick := dwCurrentTick - nNextAtt;

            m_dwLastDirection := DelayMsg.nDir;
          end;
      end;
    end;
  end;
end;

procedure TSessionObj.SendKickMsg(KickType: Integer);
var
  i, iLen: Integer;
  Cmd: TCmdPack;
  SendMsg: string;
  Kick: Boolean;
  TempBuf, SendBuf: array[0..1023] of Char;
begin
  if (m_tLastGameSvr = nil) or not m_tLastGameSvr.Active then
    Exit;
  Kick := False;
  Cmd.UID := m_nSvrObject;
  Cmd.Cmd := SM_SYSMESSAGE;
  Cmd.X := MakeWord($FF, $F9);
  Cmd.Y := 0;
  Cmd.Direct := 0;
  case KickType of
    0:
      begin
        if g_pConfig.m_fKickOverSpeed then
          Kick := True;
        SendMsg := g_pConfig.m_szOverSpeedSendBack;
      end;
    1:
      begin
        Kick := True;
        SendMsg := g_pConfig.m_szPacketDecryptFailed;
      end;
    2:
      begin
        Kick := True;
        SendMsg := '当前登录帐号正在其它位置登录，本机已被强行离线';
      end;
    4:
      begin
        Kick := True;
        Cmd.Cmd := SM_VERSION_FAIL;
      end;
    5:
      begin
        Kick := True;
        SendMsg := g_pConfig.m_szOverClientCntMsg;
        //Cmd.Cmd := SM_OVERCLIENTCOUNT;
      end;
    6:
      begin
        Kick := True;
        SendMsg := g_pConfig.m_szHWIDBlockedMsg;
        //Cmd.Cmd := SM_OVERCLIENTCOUNT;
      end;
    12:
      begin
        Kick := True;
        SendMsg := '反外挂模块更新失败,请重启客户端!!!!';
      end;

  end;

  SendBuf[0] := '#';
  Move(Cmd, TempBuf[1], SizeOf(TCmdPack));
  if SendMsg <> '' then
  begin
    Move(SendMsg[1], TempBuf[13], Length(SendMsg));
    iLen := SizeOf(TCmdPack) + Length(SendMsg);
  end
  else
  begin
    iLen := SizeOf(TCmdPack);
  end;
  iLen := EncodeBuf(Integer(@TempBuf[1]), iLen, Integer(@SendBuf[1]));
  SendBuf[iLen + 1] := '!';

  m_tIOCPSender.SendData(m_pOverlapSend, @SendBuf[0], iLen + 2);

  m_fKickFlag := Kick;
end;

procedure TSessionObj.SendSysMsg(const szMsg: string);
var
  i, iLen: Integer;
  Cmd: TCmdPack;
  TempBuf, SendBuf: array[0..1023] of Char;
begin
  if (m_tLastGameSvr = nil) or not m_tLastGameSvr.Active then
    Exit;
  Cmd.UID := m_nSvrObject;
  Cmd.Cmd := SM_SYSMESSAGE;
  Cmd.X := MakeWord($FF, $F9);
  Cmd.Y := 0;
  Cmd.Direct := 0;

  SendBuf[0] := '#';
  Move(Cmd, TempBuf[1], SizeOf(TCmdPack));
  Move(szMsg[1], TempBuf[13], Length(szMsg));
  iLen := SizeOf(TCmdPack) + Length(szMsg);
  iLen := EncodeBuf(Integer(@TempBuf[1]), iLen, Integer(@SendBuf[1]));
  SendBuf[iLen + 1] := '!';

  m_tIOCPSender.SendData(m_pOverlapSend, @SendBuf[0], iLen + 2);
end;

procedure TSessionObj.SendDefMessage(wIdent: Word; nRecog: Integer; nParam, nTag, nSeries: Word; sMsg: string);
var
  i, iLen: Integer;
  Cmd: TCmdPack;
  TempBuf, SendBuf: array[0..1048 - 1] of Char;
begin
  if (m_tLastGameSvr = nil) or not m_tLastGameSvr.Active then
    Exit;

  Cmd.Recog := nRecog;
  Cmd.ident := wIdent;
  Cmd.param := nParam;
  Cmd.tag := nTag;
  Cmd.Series := nSeries;

  SendBuf[0] := '#';
  Move(Cmd, TempBuf[1], SizeOf(TCmdPack));
  if sMsg <> '' then
  begin
    Move(sMsg[1], TempBuf[SizeOf(TCmdPack) + 1], Length(sMsg));
    iLen := EncodeBuf(Integer(@TempBuf[1]), SizeOf(TCmdPack) + Length(sMsg), Integer(@SendBuf[1]));
  end
  else
  begin
    iLen := EncodeBuf(Integer(@TempBuf[1]), SizeOf(TCmdPack), Integer(@SendBuf[1]));
  end;
  SendBuf[iLen + 1] := '!';
  m_tIOCPSender.SendData(m_pOverlapSend, @SendBuf[0], iLen + 2);
end;

function GetRealMsgId(msgid: dword): dword;
begin
  result := msgid;
  case msgid of
    3014: Result := 3018; //CM_POWERHIT;
    3003: Result := 3019; //CM_LONGHIT;
    1007: Result := 1008; //CM_MAGICKEYCHANGE;
    3017: Result := 3012; //CM_SITDOWN;
    3016: Result := 3013; //CM_RUN;
    3009: Result := 3010; //CM_TURN;
    3018: Result := 3011; //CM_WALK;
    3011: Result := 3016; //CM_BIGHIT;
    3002: Result := 3017; //CM_SPELL;
    3013: Result := 3014; //CM_HIT;
    3012: Result := 3015; //CM_HEAVYHIT;
    3010: Result := 3005; //CM_THROW;
    1008: Result := 3003; //CM_SQUHIT;
    3019: Result := 3002; //CM_PURSUEHIT;
    1006: Result := 1007; //CM_BUTCH;
    3015: Result := 1006; //CM_EAT;
    3005: Result := 3009; //CM_HORSERUN;

  end;
end;

procedure TSessionObj.ProcessCltData(const Addr, Len: Integer; var Succeed: BOOL; const fCDPacket: Boolean);
var
  fConvertPacket: Boolean;
  fPacketOverSpeed: Boolean;

  dwCurrentTick: DWord;
  dwDelay, dwNextMove, dwNextAtt: DWord;

  nABuf, nBBuf, nBuffer: Integer;
  nInterval: Integer;
  nMoveInterval: Integer;
  nSpellInterval: Integer;
  nAttackInterval: Integer;
  nAttackFixInterval: Integer;
  nMsgCount: Integer;
  nDeCodeLen: Integer;
  nEnCodeLen: Integer;

  Cmd: TCmdPack;
  CltCmd: PCmdPack;

  fChatFilter, nChatStrPos: Integer;
  szChatBuffer: string;
  pszChatCmd: array[0..255] of Char;
  pszSendBuf: array[0..255] of Char;
  pszChatBuffer: array[0..255] of Char;
  res, res2: Cardinal;
  log: string;
begin
  fConvertPacket := False;

  //prcoess next kick
  if m_fKickFlag then
  begin
    m_fKickFlag := False;
    Succeed := False; //停止 PostIOCPRecv
    Exit;
  end;

  PByte(Addr + Len)^ := 0;

  //cc defence
  if (Len >= 5) and g_pConfig.m_fDefenceCCPacket then
  begin
    if StrPos(PChar(Addr), 'HTTP/') <> nil then
    begin
      if g_pLogMgr.CheckLevel(6) then
        g_pLogMgr.Add('CC Attack, Kick: ' + m_pUserOBJ.pszIPAddr);
      KickUser(m_pUserOBJ.nIPAddr);
      Succeed := False;
      Exit;
    end;
  end;

  //process client packet
  if m_fHandleLogin >= 2 then
  begin
    nABuf := Integer(m_pOverlapRecv.ABuffer);
    nBBuf := Integer(m_pOverlapRecv.BBuffer);


    nDeCodeLen := DecodeBuf(Addr, Len, nABuf);
    PByte(nABuf + nDeCodeLen)^ := 0;

    fPacketOverSpeed := False;
    dwDelay := 0;

    CltCmd := PCmdPack(nABuf);
//{$IFDEF JX_ENCODE}
//    CltCmd.Cmd := GetRealMsgId(CltCmd.Cmd);
//{$ENDIF}
    case CltCmd.Cmd of
      CM_GUILDUPDATENOTICE, CM_GUILDUPDATERANKINFO:
        begin
          if Len > g_pConfig.m_nMaxClientPacketSize then
          begin
            if g_pLogMgr.CheckLevel(3) then
              g_pLogMgr.Add('Kick off user,over max client packet size: ' + IntToStr(Len));
            KickUser(m_pUserOBJ.nIPAddr);
            Succeed := False;
            Exit;
          end;
        end;
    else
      begin
        if Len > g_pConfig.m_nNomClientPacketSize then
        begin
          if g_pLogMgr.CheckLevel(3) then
            g_pLogMgr.Add('Kick off user,over nom client packet size: ' + IntToStr(Len));
          KickUser(m_pUserOBJ.nIPAddr);
          Succeed := False;
          Exit;
        end;
      end;
    end;

        //111
    //if g_pLogMgr <> nil then
    //  g_pLogMgr.Add( Format('packet: %s %s %d', [m_pUserOBJ.pszIPAddr, m_szTrimChrName, CltCmd.Cmd]));
    //process client packet cmd

    if (m_Stat = csCheckLogin) or (m_Stat = csSendCheck) then
    begin
      dwCurrentTick := GetTickCount;
      // 如果5 秒 没有回数据 就下发数据
      if 0 = m_SendCheckTick then
        m_SendCheckTick := dwCurrentTick;
      if (dwCurrentTick - m_SendCheckTick) > 1000 * 5 then
      begin
        m_Stat := csSendSmu;
      end;
    end;

//    g_pJxLogger.WriteLog('client msgid:%d,%d', [CltCmd.Cmd, Integer(m_Stat)]);

    // 如果下发成功  得多少秒有数据如果没有的话，那就是有问题
    if (m_Stat = csSendFinsh) then
    begin
      dwCurrentTick := GetTickCount;
      if (dwCurrentTick - m_FinishTick) > 1000 * 10 then
      begin
        SendKickMsg(12);
      end;
    end;


    case CltCmd.Cmd of
      SM_SMUGGLE_SUCESS:
        begin
          m_SendSucess := True;
          SendIndex := SendIndex + 1; // 设置状态
          m_ErrSend := 0;
          Exit;
        end;
        // 第一个消息    检测客户是否有下载好的client
      CM_LOGINNOTICEOK:
        begin
          if (m_JxModule <> nil) and (m_stat = csCheckLogin) then
          begin
            m_checkstr := GenRandString(10);
            SendDefMessage(SM_CHECKCLIENT, 0, 0, 0, 0, m_checkstr);
            m_SendCheckTick := GetTickCount;
            m_stat := csSendCheck;
          end;
        end;
      CM_CHECKCLIENT_RES:
        begin
          if (m_JxModule <> nil) and (m_stat = csSendCheck) then
          begin
            res := m_JxModule.m_vtable.pfn_GetStrCheck(@m_checkstr[1], Length(m_checkstr));
            res2 := MakeLong(CltCmd.Y, CltCmd.X);
            if res2 = res then // 反外挂版本已经加载过了。
            begin
              m_Stat := csCheckTick; //直接操作
            end
            else
            begin
              m_Stat := csSendSmu;
              SendIndex := 0;
            end;
          end;
          Exit;
        end;
      CM_LOADMOD_OK:
        begin
          if (m_JxModule <> nil) and (m_stat = csSendFinsh) then
          begin
            m_Stat := csCheckTick; //直接操作
          end;
          Exit;
        end;

      CM_SHOPPRESEND:
        begin
          if g_pConfig.m_fDenyPresend then
          begin
            Cmd.X := 0;
            Cmd.Y := 0;
            Cmd.Direct := 0;
            Cmd.UID := -9;
            Cmd.Cmd := SM_PRESENDITEMFAIL;
            pszSendBuf[0] := '#';
            nEnCodeLen := EncodeBuf(Integer(@Cmd), SizeOf(TCmdPack), Integer(@pszSendBuf[1]));
            pszSendBuf[nEnCodeLen + 1] := '!';
            m_tIOCPSender.SendData(m_pOverlapSend, @pszSendBuf[0], nEnCodeLen + 2);
            Exit;
          end;
        end;

      CM_WALK, CM_RUN: if g_pConfig.m_fMoveInterval then
        begin //700
          fPacketOverSpeed := False;
          dwCurrentTick := GetTickCount();
          if m_fSpeedLimit then
            nMoveInterval := g_pConfig.m_nMoveInterval + g_pConfig.m_nPunishMoveInterval
          else
            nMoveInterval := g_pConfig.m_nMoveInterval;
          nInterval := Integer(dwCurrentTick - m_dwMoveTick);
          if (nInterval >= nMoveInterval) then
          begin
            m_dwMoveTick := dwCurrentTick;
            m_dwSpellTick := dwCurrentTick - g_pConfig.m_nMoveNextSpellCompensate;
            if m_dwAttackTick < dwCurrentTick - g_pConfig.m_nMoveNextAttackCompensate then
              m_dwAttackTick := dwCurrentTick - g_pConfig.m_nMoveNextAttackCompensate;
            m_dwLastDirection := CltCmd.Dir;
          end
          else
          begin
            fPacketOverSpeed := True;
            if g_pConfig.m_tOverSpeedPunishMethod = ptDelaySend then
            begin
              nMsgCount := GetDelayMsgCount();
              if nMsgCount = 0 then
              begin
                dwDelay := g_pConfig.m_nPunishBaseInterval + Round((nMoveInterval - nInterval) * g_pConfig.m_nPunishIntervalRate);
                m_dwMoveTick := dwCurrentTick + dwDelay;
              end
              else
              begin
                m_dwMoveTick := dwCurrentTick + (nMoveInterval - nInterval);
                if nMsgCount >= 2 then
                begin
                  SendKickMsg(0);
                end;
                Exit;
              end;
            end;
          end;
        end;
      CM_HIT,
        CM_HEAVYHIT,
        CM_BIGHIT,
        CM_POWERHIT,
        CM_LONGHIT,
        CM_WIDEHIT,
        CM_CRSHIT,
        CM_SQUHIT,
        CM_TWNHIT,
        CM_FIREHIT,
        CM_HERO_LONGHIT2,
        CM_PURSUEHIT,
        CM_SMITELONGHIT2,
        CM_SMITELONGHIT3:
        if g_pConfig.m_fAttackInterval then
        begin
          fPacketOverSpeed := False;
          dwCurrentTick := GetTickCount();
          //m_dwDealTick := dwCurrentTick;
          if m_fSpeedLimit then
            nAttackInterval := g_pConfig.m_nAttackInterval + g_pConfig.m_nPunishAttackInterval
          else
            nAttackInterval := g_pConfig.m_nAttackInterval;

          nAttackFixInterval := _MAX(0, (nAttackInterval - g_pConfig.m_nMaxItemSpeedRate * m_nItemSpeed));
          nInterval := Integer(dwCurrentTick - m_dwAttackTick);
          if (nInterval >= nAttackFixInterval) then
          begin
            m_dwAttackTick := dwCurrentTick;

            if g_pConfig.m_fItemSpeedCompensate then
            begin
              m_dwMoveTick := dwCurrentTick - (g_pConfig.m_nAttackNextMoveCompensate + g_pConfig.m_nMaxItemSpeedRate * m_nItemSpeed); //550
              m_dwSpellTick := dwCurrentTick - (g_pConfig.m_nAttackNextSpellCompensate + g_pConfig.m_nMaxItemSpeedRate * m_nItemSpeed); //1150
            end
            else
            begin
              m_dwMoveTick := dwCurrentTick - g_pConfig.m_nAttackNextMoveCompensate; //550
              m_dwSpellTick := dwCurrentTick - g_pConfig.m_nAttackNextSpellCompensate; //1150
            end;

            m_dwLastDirection := CltCmd.Dir;
          end
          else
          begin
            fPacketOverSpeed := True;
            if g_pConfig.m_tOverSpeedPunishMethod = ptDelaySend then
            begin
              nMsgCount := GetDelayMsgCount();
              if nMsgCount = 0 then
              begin
                dwDelay := g_pConfig.m_nPunishBaseInterval + Round((nAttackFixInterval - nInterval) * g_pConfig.m_nPunishIntervalRate);
                m_dwAttackTick := dwCurrentTick + dwDelay;
              end
              else
              begin
                m_dwAttackTick := dwCurrentTick + (nAttackFixInterval - nInterval);
                if nMsgCount >= 2 then
                begin
                  SendKickMsg(0);
                end;
                Exit;
              end;
            end;
          end;
        end;
      CM_SPELL: if g_pConfig.m_fSpellInterval then
        begin //1380
          dwCurrentTick := GetTickCount();
          if CltCmd^.Magic >= MAGIC_NUM then
          begin
            fPacketOverSpeed := False;
            Exit;
          end
          else if MAIGIC_DELAY_ARRAY[CltCmd^.Magic] then
          begin //过滤武士魔法
            fPacketOverSpeed := False;
            if m_fSpeedLimit then
              nSpellInterval := MAIGIC_DELAY_TIME_LIST[CltCmd^.Magic] + g_pConfig.m_nPunishSpellInterval
            else
              nSpellInterval := MAIGIC_DELAY_TIME_LIST[CltCmd^.Magic];

            //m_dwDealTick := dwCurrentTick;

            nInterval := Integer(dwCurrentTick - m_dwSpellTick);
            if (nInterval >= nSpellInterval) then
            begin
              if MAIGIC_ATTACK_ARRAY[CltCmd^.Magic] then
              begin
                dwNextMove := g_pConfig.m_nSpellNextMoveCompensate;
                dwNextAtt := g_pConfig.m_nSpellNextAttackCompensate;
              end
              else
              begin
                dwNextMove := g_pConfig.m_nSpellNextMoveCompensate + 80;
                dwNextAtt := g_pConfig.m_nSpellNextAttackCompensate + 80;
              end;
              m_dwSpellTick := dwCurrentTick;
              m_dwMoveTick := dwCurrentTick - dwNextMove;
              m_dwAttackTick := dwCurrentTick - dwNextAtt;
              m_dwLastDirection := CltCmd.Dir;
            end
            else
            begin
              fPacketOverSpeed := True;
              if g_pConfig.m_tOverSpeedPunishMethod = ptDelaySend then
              begin
                nMsgCount := GetDelayMsgCount();
                if nMsgCount = 0 then
                begin
                  dwDelay := g_pConfig.m_nPunishBaseInterval + Round((nSpellInterval - nInterval) * g_pConfig.m_nPunishIntervalRate); // + Integer(bof) * 180;
                end
                else
                begin
                  if nMsgCount >= 2 then
                  begin
                    SendKickMsg(0);
                  end;
                  Exit;
                end;
              end;
            end;
          end;
        end;
      CM_SITDOWN:
        begin
          if g_pConfig.m_fSitDownInterval then
          begin
            fPacketOverSpeed := False;
            dwCurrentTick := GetTickCount();
            nInterval := Integer(dwCurrentTick - m_dwSitDownTick);
            if nInterval >= g_pConfig.m_nSitDownInterval then
            begin
              m_dwSitDownTick := dwCurrentTick;
            end
            else
            begin
              fPacketOverSpeed := True;
              if g_pConfig.m_tOverSpeedPunishMethod = ptDelaySend then
              begin
                nMsgCount := GetDelayMsgCount();
                if nMsgCount = 0 then
                begin
                  dwDelay := g_pConfig.m_nPunishBaseInterval + Round((g_pConfig.m_nSitDownInterval - nInterval) * g_pConfig.m_nPunishIntervalRate);
                  m_dwSitDownTick := dwCurrentTick + dwDelay;
                end
                else
                begin
                  m_dwSitDownTick := dwCurrentTick + (g_pConfig.m_nSitDownInterval - nInterval);
                  if nMsgCount >= 2 then
                  begin
                    SendKickMsg(0);
                  end;
                  Exit;
                end;
              end;
            end;
          end;
        end;
      CM_BUTCH:
        begin
          if g_pConfig.m_fButchInterval then
          begin
            fPacketOverSpeed := False;
            dwCurrentTick := GetTickCount();
            nInterval := Integer(dwCurrentTick - m_dwButchTick);
            if nInterval >= g_pConfig.m_nButchInterval then
            begin
              m_dwButchTick := dwCurrentTick;
            end
            else
            begin
              fPacketOverSpeed := True;
              if g_pConfig.m_tOverSpeedPunishMethod = ptDelaySend then
              begin
                if not PeekDelayMsg(CltCmd.Cmd) then
                begin
                  dwDelay := g_pConfig.m_nPunishBaseInterval + Round((g_pConfig.m_nButchInterval - nInterval) * g_pConfig.m_nPunishIntervalRate);
                  m_dwButchTick := dwCurrentTick + dwDelay;
                end
                else
                begin
                  m_dwSitDownTick := dwCurrentTick + (g_pConfig.m_nButchInterval - nInterval);
                  Exit;
                end;
              end;
            end;
          end;
        end;
      CM_TURN: if g_pConfig.m_fTurnInterval and (g_pConfig.m_tOverSpeedPunishMethod <> ptTurnPack) then
        begin
          if m_dwLastDirection <> CltCmd.Dir then
          begin
            fPacketOverSpeed := False;
            dwCurrentTick := GetTickCount();
            if dwCurrentTick - m_dwTurnTick >= g_pConfig.m_nTurnInterval then
            begin
              m_dwLastDirection := CltCmd.Dir;
              m_dwTurnTick := dwCurrentTick;
            end
            else
            begin
              if g_pConfig.m_tOverSpeedPunishMethod = ptDelaySend then
              begin
                if not PeekDelayMsg(CltCmd.Cmd) then
                begin
                  fPacketOverSpeed := True;
                  dwDelay := g_pConfig.m_nPunishBaseInterval + Round((g_pConfig.m_nTurnInterval - (dwCurrentTick - m_dwTurnTick)) * g_pConfig.m_nPunishIntervalRate);
                end
                else
                begin
                  fConvertPacket := True;
                  fPacketOverSpeed := True;
                end;
              end
              else
                fPacketOverSpeed := True;
            end;
          end;
        end;

      CM_DEALTRY:
        begin
          dwCurrentTick := GetTickCount();
          if (dwCurrentTick - m_dwDealTick < 10000) then
          begin
            if (dwCurrentTick - m_dwWaringTick > 2000) then
            begin
              m_dwWaringTick := dwCurrentTick;
              SendSysMsg(format('攻击状态不能交易！请稍等%d秒……', [(10000 - (dwCurrentTick - m_dwDealTick)) div 1000 + 1]));
            end;
            Exit;
          end;
        end;

      CM_OPENSTALL:
        begin
          dwCurrentTick := GetTickCount();
          if (CltCmd.Series = 0) then
          begin //取消摆摊
            m_dwOpenStoreTick := dwCurrentTick;
          end
          else
          begin
            if (dwCurrentTick - m_dwOpenStoreTick >= 12000) then
            begin
              m_dwOpenStoreTick := dwCurrentTick;
            end
            else
            begin
              if (dwCurrentTick - m_dwWaringTick > 1000) then
              begin
                m_dwWaringTick := dwCurrentTick;
                szChatBuffer := Format('请在%d秒后再尝试摆摊。', [(12000 - (dwCurrentTick - m_dwOpenStoreTick)) div 1000 + 1]);
                SendDefMessage(SM_MENU_OK, 0, 0, 0, 0, szChatBuffer);
              end;
              Exit;
            end;
          end;
        end;

      CM_UPDATESTALLITEM:
        begin //相当于修正了摆摊改价格问题
          dwCurrentTick := GetTickCount();
          if (CltCmd.Series > 0) then
          begin
            if (dwCurrentTick - m_dwWaringTick > 1000) then
            begin
              m_dwWaringTick := dwCurrentTick;
              SendDefMessage(SM_MENU_OK, 0, 0, 0, 0, '管理员已禁止【添加摆摊物品】功能！');
            end;
          end
          else
          begin
            SendDefMessage(SM_UPDATESTALLITEM, -50, 0, 0, 0, '');
            if (dwCurrentTick - m_dwWaringTick > 1000) then
            begin
              m_dwWaringTick := dwCurrentTick;
              SendDefMessage(SM_MENU_OK, 0, 0, 0, 0, '管理员已禁止【撤销摆摊物品】功能！');
            end;
          end;
          Exit;
        end;

      CM_SAY:
        begin
          if g_pConfig.m_fChatInterval then
          begin
            if PChar(nABuf + SizeOf(TCmdPack))^ <> '@' then
            begin
              dwCurrentTick := GetTickCount();
              if dwCurrentTick - m_dwChatTick < g_pConfig.m_nChatInterval then
                Exit;
              m_dwChatTick := dwCurrentTick;
            end;
          end;
          if nDeCodeLen > SizeOf(TCmdPack) then
          begin
            if PChar(nABuf + SizeOf(TCmdPack))^ = '@' then
            begin
              Move(PChar(nABuf + SizeOf(TCmdPack))^, pszChatBuffer[0], nDeCodeLen - SizeOf(TCmdPack));
              pszChatBuffer[nDeCodeLen - SizeOf(TCmdPack)] := #0;
              nChatStrPos := Pos(' ', pszChatBuffer);
              if nChatStrPos > 0 then
              begin
                Move(pszChatBuffer[0], pszChatCmd[0], nChatStrPos - 1);
                pszChatCmd[nChatStrPos - 1] := #0;
              end
              else
                Move(pszChatBuffer[0], pszChatCmd[0], StrLen(pszChatBuffer));

              if g_ChatCmdFilterList.IndexOf(pszChatCmd) >= 0 then
              begin
                Cmd.UID := m_nSvrObject;
                Cmd.Cmd := SM_WHISPER;
                Cmd.X := MakeWord($FF, 56);
                StrFmt(pszChatBuffer, _STR_CMD_FILTER, [pszChatCmd]);
                pszSendBuf[0] := '#';
                Move(Cmd, m_pOverlapRecv.BBuffer[1], SizeOf(TCmdPack));
                Move(pszChatBuffer[0], m_pOverlapRecv.BBuffer[13], StrLen(pszChatBuffer));
                nEnCodeLen := EncodeBuf(Integer(@m_pOverlapRecv.BBuffer[1]), SizeOf(TCmdPack) + StrLen(pszChatBuffer), Integer(@pszSendBuf[1]));
                pszSendBuf[nEnCodeLen + 1] := '!';
                m_tIOCPSender.SendData(m_pOverlapSend, @pszSendBuf[0], nEnCodeLen + 2);
                Exit;
              end;

              if g_pConfig.m_fSpaceMoveNextPickupInterval then
              begin
                if CompareText(pszChatBuffer, g_pConfig.m_szCMDSpaceMove) = 0 then
                  m_dwPickupTick := GetTickCount + g_pConfig.m_nSpaceMoveNextPickupInterval;
              end;
            end
            else if g_pConfig.m_fChatFilter then
            begin
              if PChar(nABuf + SizeOf(TCmdPack))^ = '/' then
              begin
                Move(PChar(nABuf + SizeOf(TCmdPack))^, pszChatBuffer[0], nDeCodeLen - SizeOf(TCmdPack));
                pszChatBuffer[nDeCodeLen - SizeOf(TCmdPack)] := #0;
                nChatStrPos := Pos(' ', pszChatBuffer);
                if nChatStrPos > 0 then
                begin
                  Move(pszChatBuffer[0], pszChatCmd[0], nChatStrPos - 1);
                  pszChatCmd[nChatStrPos - 1] := #0;
                  szChatBuffer := StrPas(PChar(@pszChatBuffer[nChatStrPos]));
                  fChatFilter := CheckChatFilter(szChatBuffer, Succeed);
                  if (fChatFilter > 0) and not Succeed then
                  begin
                    if g_pLogMgr.CheckLevel(6) then
                      g_pLogMgr.Add('Kick off user,saying in filter');
                    Exit;
                  end;
                  if fChatFilter = 2 then
                  begin
                    StrFmt(pszChatBuffer, '%s %s', [pszChatCmd, szChatBuffer]);
                    nDeCodeLen := StrLen(pszChatBuffer) + SizeOf(TCmdPack);
                    Move(pszChatBuffer[0], PChar(nABuf + SizeOf(TCmdPack))^, StrLen(pszChatBuffer));
                  end;
                end;
              end
              else if PChar(nABuf + SizeOf(TCmdPack))^ <> '@' then
              begin
                szChatBuffer := StrPas(PChar(nABuf + SizeOf(TCmdPack)));
                fChatFilter := CheckChatFilter(szChatBuffer, Succeed);
                if (fChatFilter > 0) and not Succeed then
                begin
                  if g_pLogMgr.CheckLevel(6) then
                    g_pLogMgr.Add('Kick off user,saying in filter');
                  Exit;
                end;
                if fChatFilter = 2 then
                begin
                  nDeCodeLen := Length(szChatBuffer) + SizeOf(TCmdPack);
                  Move(szChatBuffer[1], PChar(nABuf + SizeOf(TCmdPack))^, Length(szChatBuffer));
                end;
              end;
            end;
          end;
        end;

      CM_PICKUP: if g_pConfig.m_fPickupInterval then
        begin
          dwCurrentTick := GetTickCount();
          if dwCurrentTick - m_dwPickupTick > g_pConfig.m_nPickupInterval then
            m_dwPickupTick := dwCurrentTick
          else
            Exit;
        end;

      CM_HEROEAT: if g_pConfig.m_fEatInterval and (CltCmd.Direct in [0, 1, 3]) then
        begin
          dwCurrentTick := GetTickCount();
          if dwCurrentTick - m_dwHeroEatTick > g_pConfig.m_nEatInterval then
            m_dwHeroEatTick := dwCurrentTick
          else
          begin
            FillChar(Cmd, SizeOf(Cmd), 0);
            Cmd.UID := CltCmd.UID;
            Cmd.Cmd := SM_HEROEAT_FAIL;
            pszSendBuf[0] := '#';
            nEnCodeLen := EncodeBuf(Integer(@Cmd), SizeOf(TCmdPack), Integer(@pszSendBuf[1]));
            pszSendBuf[nEnCodeLen + 1] := '!';

            m_tIOCPSender.SendData(m_pOverlapSend, @pszSendBuf[0], nEnCodeLen + 2);
            Exit;
          end;
        end;

      CM_EAT: if g_pConfig.m_fEatInterval then
        begin
          if CltCmd.Direct in [0, 1, 3] then
          begin
            dwCurrentTick := GetTickCount();
            if dwCurrentTick - m_dwEatTick > g_pConfig.m_nEatInterval then
              m_dwEatTick := dwCurrentTick
            else
            begin
              FillChar(Cmd, SizeOf(Cmd), 0);
              Cmd.UID := CltCmd.UID;
              Cmd.Cmd := SM_EAT_FAIL;
              pszSendBuf[0] := '#';
              nEnCodeLen := EncodeBuf(Integer(@Cmd), SizeOf(TCmdPack), Integer(@pszSendBuf[1]));
              pszSendBuf[nEnCodeLen + 1] := '!';
              m_tIOCPSender.SendData(m_pOverlapSend, @pszSendBuf[0], nEnCodeLen + 2);
              Exit;
            end;
          end;
        end;
    end;

    if fPacketOverSpeed then
    begin
      if fConvertPacket then
      begin
        CltCmd.Cmd := CM_TURN;
      end
      else
      begin
        if g_pConfig.m_fOverSpeedSendBack then
        begin
          if g_pConfig.m_tSpeedHackWarnMethod = ptSysmsg then
          begin
            CltCmd.Cmd := RM_WHISPER;
            CltCmd.UID := $FF; //FrontColor
            CltCmd.X := $F9; //BackColor
          end
          else
            CltCmd.Cmd := CM_SPEEDHACKMSG;
          nBuffer := Integer(@m_pOverlapRecv.BBuffer[SizeOf(TSvrCmdPack)]);
          with PSvrcmdPack(m_pOverlapRecv.BBuffer)^ do
          begin
            Flag := RUNGATECODE;
            SockID := m_dwSessionID;
            Cmd := GM_DATA;
            GGSock := m_nSvrListIdx;
            DataLen := SizeOf(TCmdPack);
            Move(Pointer(nABuf)^, Pointer(nBuffer)^, SizeOf(TCmdPack));
            Move(PChar(g_pConfig.m_szOverSpeedSendBack)^, PChar(nBuffer + SizeOf(TCmdPack))^, Length(g_pConfig.m_szOverSpeedSendBack));
            Inc(DataLen, Length(g_pConfig.m_szOverSpeedSendBack) + 1);
            PByte(nBuffer + DataLen - 1)^ := 0;
            m_tLastGameSvr.SendBuffer(m_pOverlapRecv.BBuffer, DataLen + SizeOf(TSvrCmdPack));
          end;
          Exit;
        end;

        case g_pConfig.m_tOverSpeedPunishMethod of
          ptTurnPack: CltCmd.Cmd := CM_TURN;
          ptDropPack: Exit;
          ptNullPack: CltCmd.Cmd := $FFFF;
          ptDelaySend:
            begin
              if dwDelay > 0 then
              begin
                nBuffer := Integer(@m_pOverlapRecv.BBuffer[SizeOf(TSvrCmdPack)]);
                with PSvrcmdPack(m_pOverlapRecv.BBuffer)^ do
                begin
                  Flag := RUNGATECODE;
                  SockID := m_dwSessionID;
                  Cmd := GM_DATA;
                  GGSock := m_nSvrListIdx;
                  DataLen := SizeOf(TCmdPack);
                  Move(Pointer(nABuf)^, Pointer(nBuffer)^, SizeOf(TCmdPack));
                  if nDeCodeLen > SizeOf(TCmdPack) then
                  begin
                    Inc(DataLen, EncodeBuf(nABuf + SizeOf(TCmdPack), nDeCodeLen - SizeOf(TCmdPack), nBuffer + SizeOf(TCmdPack)) + 1);
                    PByte(nBuffer + DataLen - 1)^ := 0;
                  end;
                  SendDelayMsg(CltCmd^.Magic, CltCmd^.Dir, CltCmd^.Cmd, DataLen + SizeOf(TSvrCmdPack), m_pOverlapRecv.BBuffer, dwDelay);
                end;
                Exit;
              end;
            end;
        end; //
      end;
    end;

    nBuffer := Integer(@m_pOverlapRecv.BBuffer[SizeOf(TSvrCmdPack)]);
    with PSvrcmdPack(m_pOverlapRecv.BBuffer)^ do
    begin
      Flag := RUNGATECODE;
      SockID := m_dwSessionID;
      Cmd := GM_DATA;
      GGSock := m_nSvrListIdx;
      DataLen := SizeOf(TCmdPack);
      Move(Pointer(nABuf)^, Pointer(nBuffer)^, SizeOf(TCmdPack));
      if nDeCodeLen > SizeOf(TCmdPack) then
      begin
        Inc(DataLen, EncodeBuf(nABuf + SizeOf(TCmdPack), nDeCodeLen - SizeOf(TCmdPack), nBuffer + SizeOf(TCmdPack)) + 1);
        PByte(nBuffer + DataLen - 1)^ := 0;
      end;
      m_tLastGameSvr.SendBuffer(m_pOverlapRecv.BBuffer, DataLen + SizeOf(TSvrCmdPack));
      //if bJump then UserLeave;
    end;
  end
  else if m_fHandleLogin = 0 then
  begin
    nABuf := Integer(m_pOverlapRecv.ABuffer);
    nDeCodeLen := DecodeBuf(Addr, Len, nABuf);
    PByte(nABuf + nDeCodeLen)^ := 0;
    HandleLogin(nABuf, nDeCodeLen, Succeed);
    if not Succeed then
      KickUser(m_pUserOBJ.nIPAddr);
  end;
end;

procedure TSessionObj.ProcessSvrData(GS: TClientThread; const Addr, Len: Integer);
var
  i, nLen, nEnLen: Integer;
  tCmd: TCmdPack;
  pCmd: PCmdPack;
  pzsSendBuf: PChar;
  pszConfigBuf: array[0..24 - 1] of Char;
  szHWID: string;
  xHWID: MD5.MD5Digest;
  UserOBJ: TSessionObj;
  dwCurrentTick: LongWord;



  pszNewBuff: array[0..1024 * 10 - 1] of Char;

  nHeadlen, nOrgLen, nSmuLen: Integer;

  pszSumData: array[0..1024 * 10 - 1] of Char;
  newCmd: TCmdPack;
  newCmdBuf: array[0..50] of Char;

  log: string;
begin

  if m_fKickFlag then
  begin
    m_fKickFlag := False;
    SHSocket.FreeSocket(m_pOverlapSend.Socket);
    Exit;
  end;

  pzsSendBuf := GS.m_pszSendBuf;
  if Len < 0 then
  begin
    Move(PChar(Addr)^, pzsSendBuf[1], -Len - 1);
    pzsSendBuf[-Len] := '!';
    pzsSendBuf[0] := '#';
    m_tIOCPSender.SendData(m_pOverlapSend, pzsSendBuf, -Len + 1);
    Exit;
  end;

  nLen := Len;

  pCmd := PCmdPack(Addr);

  case pCmd^.Cmd of
    SM_RUNGATELOGOUT:
      begin
        SendKickMsg(2);
      end;
    SM_RUSH: if g_pConfig.m_fDoMotaeboSpeedCheck then
      begin
        if (m_nSvrObject = pCmd^.UID) then
        begin
          dwCurrentTick := GetTickCount();
          m_dwMoveTick := dwCurrentTick;
          m_dwAttackTick := dwCurrentTick;
          m_dwSpellTick := dwCurrentTick;
          m_dwSitDownTick := dwCurrentTick;
          m_dwButchTick := dwCurrentTick;
          m_dwDealTick := dwCurrentTick;
        end;
      end;
    SM_NEWMAP, SM_CHANGEMAP, SM_LOGON:
      begin
        if (m_fHandleLogin <> 3) then
          m_fHandleLogin := 3;
        if (m_nSvrObject = 0) then
        begin
          m_nSvrObject := pCmd^.UID;
        end;
      end;
    SM_CHARSTATUSCHANGED:
      begin
        if (m_nSvrObject = pCmd^.UID) then
        begin
          m_nDefItemSpeed := SmallInt(pCmd^.Direct);
          m_nItemSpeed := _MIN(g_pConfig.m_nMaxItemSpeed, SmallInt(pCmd^.Direct));
          m_nChrStutas := MakeLong(pCmd^.X, pCmd^.Y);
          PWord(Addr + 10)^ := m_nItemSpeed; //同时限制客户端
        end;
      end;
    SM_SERVERCONFIG:
      begin

      end;
    SM_SERVERCONFIG2:
      begin
        if (m_nSvrObject = 0) or (m_nSvrObject = pCmd^.UID) then
        begin
          if m_nSvrObject = 0 then
            m_nSvrObject := pCmd^.UID;
          if g_pConfig.m_nEatInterval > pCmd^.Direct then
            PWord(Addr + 10)^ := g_pConfig.m_nEatInterval;
          tCmd.UID := m_nSvrObject;
          tCmd.Cmd := SM_SERVERCONFIG3;
          tCmd.X := MakeWord(g_pConfig.m_nClientAttackSpeedRate, g_pConfig.m_nClientSpellSpeedRate);
          tCmd.Y := MakeWord(g_pConfig.m_nClientMoveSpeedRate, Byte(not g_pConfig.m_fClientShowHintNewType));
          tCmd.Direct := MakeWord(Byte(g_pConfig.m_fOpenClientSpeedRate), 0);
          pszConfigBuf[0] := '#';
          nEnLen := EncodeBuf(Integer(@tCmd), SizeOf(TCmdPack), Integer(@pszConfigBuf[1]));
          pszConfigBuf[nEnLen + 1] := '!';
          m_tIOCPSender.SendData(m_pOverlapSend, @pszConfigBuf[0], nEnLen + 2);
        end;
      end;
    SM_HWID: if g_pConfig.m_fProcClientHWID then
      begin
        case pCmd^.Series of
          {0: begin
              if nLen > SizeOf(TCmdPack) then begin
                Setlength(szUserName, nLen - SizeOf(TCmdPack) - 1);
                Move(PChar(Addr + SizeOf(TCmdPack))^, szUserName[1], nLen - SizeOf(TCmdPack) - 1);

                for i := 0 to USER_ARRAY_COUNT - 1 do begin
                  UserOBJ := g_UserList[i];
                  if (UserOBJ <> nil) and (UserOBJ.m_tLastGameSvr <> nil) and (UserOBJ.m_tLastGameSvr.Active) and not UserOBJ.m_fKickFlag then begin
                    if CompareText(szUserName, UserOBJ.m_szTrimChrName) = 0 then begin
                      SendSysMsg(Format('获取机器码: %s %s', [szUserName, MD5.MD5Print(UserOBJ.m_xHWID)]));
                      Break;
                    end;
                  end;
                end;
              end;
            end;}
          1:
            begin
              if nLen > SizeOf(TCmdPack) then
              begin
                if nLen - SizeOf(TCmdPack) - 1 = 32 then
                begin
                  Setlength(szHWID, 32);
                  Move(PChar(Addr + SizeOf(TCmdPack))^, szHWID[1], 32);
                  xHWID := MD5.MD5UnPrint(szHWID);
                  for i := 0 to USER_ARRAY_COUNT - 1 do
                  begin
                    UserOBJ := g_UserList[i];
                    if (UserOBJ <> nil) and (UserOBJ.m_tLastGameSvr <> nil) and (UserOBJ.m_tLastGameSvr.Active) and not UserOBJ.m_fKickFlag then
                    begin
                      if MD5Match(xHWID, UserOBJ.m_xHWID) then
                      begin
                        //if CompareText(szHWID, UserOBJ.m_szTrimChrName) = 0 then begin
                        if g_HWIDFilter.AddDeny(UserOBJ.m_xHWID) >= 0 then
                        begin
                          g_HWIDFilter.SaveDenyList;
                          SendSysMsg(Format('封机器码: %s %s', [UserOBJ.m_szTrimChrName, MD5.MD5Print(UserOBJ.m_xHWID)]));
                        end;
                        UserOBJ.m_fKickFlag := True;
                        Break;
                      end;
                    end;
                  end;
                  {for i := 0 to USER_ARRAY_COUNT - 1 do begin
                    UserOBJ := g_UserList[i];
                    if (UserOBJ <> nil) and (UserOBJ.m_tLastGameSvr <> nil) and (UserOBJ.m_tLastGameSvr.Active) and not UserOBJ.m_fKickFlag then begin
                      if MD5Match(xHWID, UserOBJ.m_xHWID) then begin
                        UserOBJ.m_fKickFlag := True;
                        Exit;
                      end;
                    end;
                  end;}
                end;
              end;
            end;
          2:
            begin
              if g_HWIDFilter.m_xDenyList.Count > 0 then
              begin
                SendSysMsg(Format('已清理机器码黑名单: %d 条', [g_HWIDFilter.m_xDenyList.Count]));
                g_HWIDFilter.ClearDeny();
                g_HWIDFilter.SaveDenyList;
              end;
            end;
        end;
      end;
  end;

//  pzsSendBuf[0] := '#';
//  nLen := EncodeBuf(Integer(pCmd), SizeOf(TCmdPack), Integer(@pzsSendBuf[1]));
//  if Len > SizeOf(TCmdPack) then begin
//    Move(PChar(Addr + SizeOf(TCmdPack))^, pzsSendBuf[nLen + 1], Len - 13); //13 = GameSvr BUG
//    nLen := Len - 13 + nLen;
//  end;
//  pzsSendBuf[nLen + 1] := '!';
//  m_tIOCPSender.SendData(m_pOverlapSend, pzsSendBuf, nLen + 2);
//  exit;

  if (Len > 1024) or (not ReadforSmuggle) then
  begin
    pzsSendBuf[0] := '#';
    nLen := EncodeBuf(Integer(pCmd), SizeOf(TCmdPack), Integer(@pzsSendBuf[1]));
    if Len > SizeOf(TCmdPack) then
    begin
      Move(PChar(Addr + SizeOf(TCmdPack))^, pzsSendBuf[nLen + 1], Len - 13); //13 = GameSvr BUG
      nLen := Len - 13 + nLen;
    end;
    pzsSendBuf[nLen + 1] := '!';
    m_tIOCPSender.SendData(m_pOverlapSend, pzsSendBuf, nLen + 2);
  end
  else
  begin
    nLen := EncodeBuf(Integer(pCmd), SizeOf(TCmdPack), Integer(@pszNewBuff[0]));
    if Len > SizeOf(TCmdPack) then
    begin
      Move(PChar(Addr + SizeOf(TCmdPack))^, pszNewBuff[nLen], Len - 13); //13 = GameSvr BUG
      nLen := Len - 13 + nLen;
    end;
    nOrgLen := nLen;


    FillChar(newCmd, SizeOf(TCmdPack), 0);

    pzsSendBuf[0] := '#';

    nHeadlen := DEFBLOCKSIZE;

    nSmuLen := m_JxModule.GetSendData(Pointer(@pzsSendBuf[1 + nHeadlen]), SendIndex);

    //     nSmuLen 可能为 0

    nOrgLen := EncodeBuf(Integer(@pszNewBuff[0]), nOrgLen, Integer(@pzsSendBuf[1 + nHeadlen + nSmuLen]));

    nLen := nHeadlen + nSmuLen + nOrgLen;

    newCmd.UID := m_nSvrObject;
    newCmd.Ident := SM_SMUGGLE;
    newCmd.X := nSmuLen; // 加密长度
    newCmd.Y := nOrgLen;
    EncodeBuf(Integer(@newCmd), sizeof(TCmdPack), Integer(@newCmdBuf[0]));

    CopyMemory(@pzsSendBuf[1], @newCmdBuf[0], DEFBLOCKSIZE);

    pzsSendBuf[nLen + 1] := '!';
    m_tIOCPSender.SendData(m_pOverlapSend, pzsSendBuf, nLen + 2);
    AfterSendSmug;
    g_pJxLogger.WriteLog('send: %s %d,%d', [m_szChrName, m_SendIndx, m_JxModule.m_BlockCount]);
  end;

end;

procedure TSessionObj.UserEnter;
var
  PacketBuffer: array[0..127] of Char;
  iSendLen: Integer;
begin
  g_ProcMsgThread.AddSession(Self);

  iSendLen := m_pUserOBJ.nIPLen;
  Move(m_pUserOBJ.pszIPAddr, PacketBuffer[SizeOf(TSvrCmdPack)], iSendLen);
  Inc(iSendLen, SizeOf(TSvrCmdPack));
  PacketBuffer[iSendLen] := #0;
  Inc(iSendLen);
  with PSvrcmdPack(@PacketBuffer)^ do
  begin
    Flag := RUNGATECODE;
    SockID := m_dwSessionID;
    Cmd := GM_OPEN;
    GGSock := 0;
    DataLen := iSendLen - SizeOf(TSvrCmdPack);
  end;
  m_tLastGameSvr.SendBuffer(@PacketBuffer, iSendLen);
end;

procedure TSessionObj.UserLeave;
var
  CmdPacket: TSvrCmdPack;
  i, nCode: Integer;
  CltMsg: pTDelayMsg;
  DynPacket: pTDynPacket;
begin
  nCode := 0;
  try
    if g_ProcMsgThread <> nil then
      g_ProcMsgThread.DelSession(Self);

    nCode := 1;
    with CmdPacket do
    begin
      Flag := RUNGATECODE;
      SockID := m_dwSessionID;
      Cmd := GM_CLOSE;
      GGSock := 0; //nUListIdx
      DataLen := 0;
    end;
    m_tLastGameSvr.SendBuffer(@CmdPacket, SizeOf(TSvrCmdPack));

    nCode := 2;
    DeleteConnectOfIP(Self.m_pUserOBJ.nIPAddr);
    if not m_fOverClientCount then
      g_HWIDFilter.DecHWIDCount(m_xHWID);

    nCode := 3;

    EnterCriticalSection(PSendQueueNode(m_pOverlapSend).QueueLock);
    try
      while True do
      begin
        if PSendQueueNode(m_pOverlapSend).DynSendList.Count = 0 then
          Break;
        DynPacket := m_tIOCPSender.SendQueue.GetDynPacket(m_pOverlapSend);
        if DynPacket = nil then
          Break;
        FreeMem(DynPacket.Buf);
        Dispose(DynPacket);
        PSendQueueNode(m_pOverlapSend).DynSendList.Delete(0);
      end;
    finally
      LeaveCriticalSection(PSendQueueNode(m_pOverlapSend).QueueLock);
    end;

  except
    on M: Exception do
      g_pLogMgr.Add(Format('TSessionObj.UserLeave: %d %s', [nCode, M.Message]));
  end;
end;

procedure TSessionObj.WriteIndex(value: LongWord);
begin
  m_SendIndx := value;
  if m_JxModule <> nil then
    if m_SendIndx >= m_JxModule.m_BlockCount then
    begin
      m_FinishTick := GetTickCount;
      m_Stat := csSendFinsh;
    end;


end;

procedure TSessionObj.SendFirstPack(const szPacket: string);
var
  PacketBuffer: array[0..255] of Char;
  iSendLen: Integer;
begin
  Move(szPacket[1], PacketBuffer[SizeOf(TSvrCmdPack)], Length(szPacket));
  iSendLen := Length(szPacket) + SizeOf(TSvrCmdPack);
  PacketBuffer[iSendLen] := #0;
  Inc(iSendLen);
  with PSvrcmdPack(@PacketBuffer)^ do
  begin
    Flag := RUNGATECODE;
    SockID := m_dwSessionID;
    Cmd := GM_DATA;
    GGSock := m_nSvrListIdx;
    DataLen := iSendLen - SizeOf(TSvrCmdPack);
  end;
  //m_tLastGameSvr.SendBuffer(@PacketBuffer, iSendLen);
  SendDelayMsg(0, 0, 0, iSendLen, @PacketBuffer, 1);
end;

procedure TSessionObj.HandleLogin(const Addr: Integer; Len: Integer; var Succeed: BOOL);
var
  szTemp, szAccount: string;
  szCharName, szRemoteIP: string;
  szCert, szClientVerNO: string;
  szCode: string;
  szHarewareID: string;
  nUserType: Integer;
  tDigest: MD5Digest;

  fMatch: Boolean;
  i: Integer;
  Src, Key: string;
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  dest: array[0..1024 - 1] of Char;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
  nDeCodeLen: Integer;
  pHardwareHeader: pTHardwareHeader;

  pszLoginPacket: array[0..1048 - 1] of Char;
begin
  if (Len < FIRST_PAKCET_MAX_LEN) and (Len > 15) then
  begin
    if (PChar(Addr)[0] <> '*') or (PChar(Addr)[1] <> '*') then
    begin
      if g_pLogMgr.CheckLevel(10) then
        g_pLogMgr.Add(Format('[HandleLogin] Kicked 1: %s', [StrPas(PChar(Addr))]));
      Succeed := False;
      Exit;
    end;

    Setlength(szTemp, Len);
    Move(PChar(Addr)^, szTemp[1], Len);

    szTemp := GetValidStr3(szTemp, szAccount, ['/']);
    szTemp := GetValidStr3(szTemp, szCharName, ['/']);
    if (Length(szAccount) > 4) and (Length(szAccount) <= 12) and (Length(szCharName) > 2) and (Length(szCharName) < 15) then
    begin
      Delete(szAccount, 1, 2);
      m_szAccount := szAccount;
      szTemp := GetValidStr3(szTemp, szCert, ['/']);
      szTemp := GetValidStr3(szTemp, szClientVerNO, ['/']);
      szTemp := GetValidStr3(szTemp, szCode, ['/']);
      szTemp := GetValidStr3(szTemp, szHarewareID, ['/']);

      if ((Length(szCert) <= 0) or (Length(szCert) > 8)) then
      begin
        Succeed := False;
        Exit;
      end;
      if (Length(szClientVerNO) <> 9) then
      begin
        Succeed := False;
        Exit;
      end;
      if (Length(szCode) <> 1) then
      begin
        Succeed := False;
        Exit;
      end;

      nUserType := g_PunishList.IndexOf(szCharName);
      if nUserType > -1 then
      begin
        m_fSpeedLimit := True;
        g_PunishList.Objects[nUserType] := TObject(Self);
      end;

      FillChar(m_szChrName[1], 15, #$20);
      Move(szCharName[1], m_szChrName[1], Length(szCharName));
      m_szChrName[0] := Char(15);
      m_szTrimChrName := Trim(m_szChrName);
      if g_pConfig.m_fProcClientHWID then
      begin
        if (szHarewareID = '') or (Length(szHarewareID) > 256) or (Length(szHarewareID) mod 2 <> 0) then
        begin
          if g_pLogMgr.CheckLevel(10) then
            g_pLogMgr.Add(Format('[HandleLogin] Kicked 3: %s', [szCharName]));
          SendKickMsg(4);
          Exit;
        end;
        fMatch := False;
        try
          FillChar(dest, SizeOf(dest), 0);
          Src := szHarewareID;
          Key := VMProtectDecryptStringA('legendsoft');
          KeyLen := Length(Key);
          KeyPos := 0;
          OffSet := StrToInt('$' + Copy(Src, 1, 2));
          SrcPos := 3;
          i := 0;
          repeat
            SrcAsc := StrToInt('$' + Copy(Src, SrcPos, 2));
            if KeyPos < KeyLen then
              KeyPos := KeyPos + 1
            else
              KeyPos := 1;
            TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
            if TmpSrcAsc <= OffSet then
              TmpSrcAsc := 255 + TmpSrcAsc - OffSet
            else
              TmpSrcAsc := TmpSrcAsc - OffSet;
            //dest := dest + Chr(TmpSrcAsc);
            dest[i] := Chr(TmpSrcAsc);
            Inc(i);
            {if i > SizeOf(THardwareHeader) then begin
              SendKickMsg(4);
              Exit;
            end;}
            OffSet := SrcAsc;
            SrcPos := SrcPos + 2;
          until SrcPos >= Length(Src);
        except
          //if g_pLogMgr.CheckLevel(10) then
          //  g_pLogMgr.Add(Format('[HandleLogin] Kicked 4: %s', [StrPas(PChar(Addr))]));
          fMatch := True;
        end;

        if fMatch then
        begin
          if g_pLogMgr.CheckLevel(10) then
            g_pLogMgr.Add(Format('[HandleLogin] Kicked 5: %s', [szCharName]));
          SendKickMsg(4);
          Exit;
        end;

        pHardwareHeader := pTHardwareHeader(@dest[0]);
        if g_pLogMgr.CheckLevel(9) then
          g_pLogMgr.Add(Format('HWID: %s  %s  %s', [MD5Print(pHardwareHeader.xMd5Digest), Trim(m_szTrimChrName), m_pUserOBJ.pszIPAddr]));

        if pHardwareHeader.dwMagicCode = $13F13F13 then
        begin
          if MD5Match(g_MD5EmptyDigest, pHardwareHeader.xMd5Digest) then
          begin
            if g_pLogMgr.CheckLevel(10) then
              g_pLogMgr.Add(Format('[HandleLogin] Kicked 6: %s', [szCharName]));
            SendKickMsg(4);
            Exit;
          end;
          m_xHWID := pHardwareHeader.xMd5Digest;
          if g_HWIDFilter.IsFilter(m_xHWID, m_fOverClientCount) then
          begin
            if g_pLogMgr.CheckLevel(10) then
              g_pLogMgr.Add(Format('[HandleLogin] Kicked 7: %s', [szCharName]));
            if m_fOverClientCount then
              SendKickMsg(5)
            else
              SendKickMsg(6);
            Exit;
          end;
        end
        else
        begin
          if g_pLogMgr.CheckLevel(10) then
            g_pLogMgr.Add(Format('[HandleLogin] Kicked 8: %s', [szCharName]));
          SendKickMsg(4);
          Exit;
        end;
      end;

      FillChar(pszLoginPacket, SizeOf(pszLoginPacket), 0);
      szTemp := Format('**%s/%s/%s/%s/%s/%s', [szAccount, szCharName, szCert, szClientVerNO, szCode, MD5Print(m_xHWID)]);
      //#0.........!
      Len := EncodeBuf(Integer(@szTemp[1]), Length(szTemp), Integer(@pszLoginPacket[2]));
      pszLoginPacket[0] := '#';
      pszLoginPacket[1] := '0';
      pszLoginPacket[Len + 2] := '!';
      m_fHandleLogin := 2;
      SendFirstPack(StrPas(pszLoginPacket));
      InitJxModule;
    end
    else
    begin
      if g_pLogMgr.CheckLevel(10) then
        g_pLogMgr.Add(Format('[HandleLogin] Kicked 2: %s', [StrPas(PChar(Addr))]));
      Succeed := False;
    end;
  end
  else
  begin
    if g_pLogMgr.CheckLevel(10) then
      g_pLogMgr.Add(Format('[HandleLogin] Kicked 0: %s', [StrPas(PChar(Addr))]));
    Succeed := False;
  end;
end;



procedure TSessionObj.InitJxModule;
begin
  m_JxModule := g_pJXMgr.curModule;
  m_lastSmuTick := 0;
  m_SendSucess := True;
  SendIndex := 0;
end;



function TSessionObj.ReadforSmuggle: Boolean;
var
  curtick: LongWord;
begin
  Result := False;

  if m_JxModule = nil then
  begin
    Result := False;
    Exit;
  end;

  if m_Stat <> csSendSmu then
  begin
    Result := False;
    Exit;
  end;


  if SendIndex >= m_JxModule.m_BlockCount then
  begin
    Result := False;
    m_Stat := csSendFinsh;
    Exit;
  end;


  // 如果已经有回应包了，就可以返回了。
  if m_SendSucess = True then
  begin
    Result := True;
    Exit;
  end
  else
  begin
    curtick := GetTickCount;
    if (curtick - m_lastSmuTick) > 1000 * 1 then
    begin
      Result := True; //
      Inc(m_ErrSend);
      if m_ErrSend > 2 then
      begin
        SendIndex := SendIndex + 1;
        m_ErrSend := 0;
        if (m_Stat = csSendFinsh) then
          Result := False;
      end;
    end;

  end;
end;




{procedure FillUserList();
var
  i                         : Integer;
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

finalization
  CleanupUserList();}

end.
