unit RunSock;

interface

uses
  Windows, Classes, SysUtils, StrUtils, SyncObjs, ObjBase, Grobal2,
  FrnEngn, UsrEngn, D7ScktComp, MD5;

type
  TGateInfo = record
    Socket: TCustomWinSocket;
    UserList: TList;
    nGateID: Integer;
    boUsed: Boolean;
    sAddr: string[15];
    nPort: Integer;
    nUserCount: Integer;
    Buffer: PChar;
    nBuffLen: Integer;
    BufferList: TList;
    boSendKeepAlive: Boolean;
    nSendChecked: Integer;
    nSendBlockCount: Integer;
    dwSendTick: LongWord;
    dwSendCheckTick: LongWord;
    nSendMsgCount: Integer;
    nSendRemainCount: Integer;
    nSendMsgBytes: Integer;
    nSendedMsgCount: Integer;
    nSendBytesCount: Integer;
    nSendCount: Integer;
  end;
  pTGateInfo = ^TGateInfo;

  TGateUserInfo = record
    PlayObject: TPlayObject;
    sAccount: string[10];
    sIPaddr: string[15];
    sCharName: string[14];
    nSessionID: Integer;
    nGSocketIdx: Integer;
    nClientVersion: Integer;
    boCertification: Boolean;
    SessInfo: pTSessInfo;
    nSocket: Integer;
    FrontEngine: TFrontEngine;
    UserEngine: TUserEngine;
  end;
  pTGateUserInfo = ^TGateUserInfo;

  TRunSocket = class
    m_RunSocketSection: TRTLCriticalSection;
    m_RunAddrList: TStringList;
    m_nIPCount: Integer;
    m_IPaddrArr: array[0..19] of TIPaddr;
    dwSendTestMsgTick: LongWord;
  private
    procedure LoadRunAddr;
    procedure ExecGateBuffers(nGateIndex: Integer; Gate: pTGateInfo; Buffer: PChar; nMsgLen: Integer);
    procedure DoClientCertification(GateIdx: Integer; GateUser: pTGateUserInfo; nSocket: Integer; sMsg: string);
    procedure ExecGateMsg(GateIdx: Integer; Gate: pTGateInfo; MsgHeader: pTMsgHeader; MsgBuff: PChar; nMsgLen: Integer);
    procedure SendCheck(Socket: TCustomWinSocket; nIdent: Integer);
    function OpenNewUser(nSocket: Integer; nGSocketIdx: Integer; sIPaddr: string; UserList: TList): Integer;
    procedure SendNewUserMsg(Socket: TCustomWinSocket; nSocket: Integer; nSocketIndex, nUserIdex: Integer);
    // procedure SendGateTestMsg(nIndex: Integer);         
    function SendGateBuffers(GateIdx: Integer; Gate: pTGateInfo; MsgList: TList): Boolean;
    function GetGateAddr(sIPaddr: string): string;
  public
    constructor Create();
    destructor Destroy; override;
    procedure AddGate(Socket: TCustomWinSocket);
    procedure SocketRead(Socket: TCustomWinSocket);
    procedure CloseGate(Socket: TCustomWinSocket);
    procedure CloseErrGate(Socket: TCustomWinSocket; var ErrorCode: Integer);
    procedure CloseAllGate();
    procedure Run();
    procedure DemoRun();
    procedure Execute;
    procedure CloseUser(GateIdx, nSocket: Integer);
    function AddGateBuffer(GateIdx: Integer; Buffer: PChar): Boolean;
    function AddGateBufferAll(Buffer: PChar; BufLen: Integer): Boolean;
    procedure SendOutConnectMsg(nGateIdx, nSocket, nGsIdx: Integer);
    procedure SetGateUserList(nGateIdx, nSocket: Integer; PlayObject: TPlayObject);
    procedure KickUser(sAccount: string; nSessionID: Integer);
  end;
var
  g_GateArr: array[0..19] of TGateInfo;
  g_nGateRecvMsgLenMin: Integer;
  g_nGateRecvMsgLenMax: Integer;

implementation

uses HUtil32, M2Share, IdSrvClient, EDcode, EncryptUnit;

var
  nRunSocketRun: Integer = -1;

procedure TRunSocket.AddGate(Socket: TCustomWinSocket);
var
  i: Integer;
  sIPaddr: string;
  Gate: pTGateInfo;
resourcestring
  sGateOpen = '游戏网关[%d](%s:%d)已打开..';
  sKickGate = '服务器未就绪: %s';
begin
  if boStartReady then
  begin
    EnterCriticalSection(m_RunSocketSection);
    try
      sIPaddr := Socket.RemoteAddress;
      for i := Low(g_GateArr) to High(g_GateArr) do
      begin
        Gate := @g_GateArr[i];
        if Gate.boUsed then
          Continue;
        Gate.boUsed := True;
        Gate.Socket := Socket;
        Gate.sAddr := GetGateAddr(sIPaddr);
        Gate.nPort := Socket.RemotePort;
        Gate.UserList := TList.Create;
        Gate.nUserCount := 0;
        Gate.Buffer := nil;
        Gate.nBuffLen := 0;
        Gate.BufferList := TList.Create;
        Gate.boSendKeepAlive := False;
        Gate.nSendChecked := 0;
        Gate.nSendBlockCount := 0;
        MainOutMessageAPI(Format(sGateOpen, [i, Socket.RemoteAddress, Socket.RemotePort]));
        Break;
      end;
    finally
      LeaveCriticalSection(m_RunSocketSection);
    end;
  end
  else
  begin
    MainOutMessageAPI(Format(sKickGate, [Socket.RemoteAddress]));
    Socket.Close;
  end;
end;

procedure TRunSocket.CloseAllGate;
var
  GateIdx: Integer;
  Gate: pTGateInfo;
begin
  for GateIdx := Low(g_GateArr) to High(g_GateArr) do
  begin
    Gate := @g_GateArr[GateIdx];
    if Gate.Socket <> nil then
      Gate.Socket.Close;
  end;
end;

procedure TRunSocket.CloseErrGate(Socket: TCustomWinSocket; var ErrorCode: Integer);
begin
  if Socket.Connected then
    Socket.Close;
  ErrorCode := 0;
end;

procedure TRunSocket.CloseGate(Socket: TCustomWinSocket);
var
  i, GateIdx: Integer;
  GateUser: pTGateUserInfo;
  UserList: TList;
  Gate: pTGateInfo;
resourcestring
  sGateClose = '游戏网关[%d](%s:%d)已关闭..';
begin
  EnterCriticalSection(m_RunSocketSection);
  try
    for GateIdx := Low(g_GateArr) to High(g_GateArr) do
    begin
      Gate := @g_GateArr[GateIdx];
      if Gate.Socket = Socket then
      begin
        UserList := Gate.UserList;
        for i := 0 to UserList.Count - 1 do
        begin
          GateUser := UserList.Items[i];
          if GateUser <> nil then
          begin
            if GateUser.PlayObject <> nil then
            begin
              TPlayObject(GateUser.PlayObject).m_boEmergencyClose := True;
              if not TPlayObject(GateUser.PlayObject).m_boReconnection then
                FrmIDSoc.SendHumanLogOutMsg(GateUser.sAccount, GateUser.nSessionID);
            end;
            Dispose(GateUser);
            UserList.Items[i] := nil;
          end;
        end;
        Gate.UserList.Free;
        Gate.UserList := nil;
        if Gate.Buffer <> nil then
          FreeMem(Gate.Buffer);
        Gate.Buffer := nil;
        Gate.nBuffLen := 0;
        for i := 0 to Gate.BufferList.Count - 1 do
          FreeMem(Gate.BufferList.Items[i]);
        Gate.BufferList.Free;
        Gate.BufferList := nil;
        Gate.boUsed := False;
        Gate.Socket := nil;
        MainOutMessageAPI(Format(sGateClose, [GateIdx, Socket.RemoteAddress, Socket.RemotePort]));
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(m_RunSocketSection);
  end;
end;

procedure TRunSocket.ExecGateBuffers(nGateIndex: Integer; Gate: pTGateInfo; Buffer: PChar; nMsgLen: Integer);
var
  //fProced                   : Boolean;
  nLen: Integer;
  Buff: PChar;
  MsgBuff: PChar;
  MsgHeader: pTMsgHeader;
  nCheckMsgLen: Integer;
  TempBuff: PChar;
resourcestring
  sExceptionMsg1 = '[Exception] TRunSocket::ExecGateBuffers -> pBuffer';
  sExceptionMsg2 = '[Exception] TRunSocket::ExecGateBuffers -> @pwork, ExecGateMsg ';
  sExceptionMsg3 = '[Exception] TRunSocket::ExecGateBuffers -> FreeMem';
begin
  //fProced := False;
  nLen := 0;
  Buff := nil;
  try
    if Buffer <> nil then
    begin
      ReAllocMem(Gate.Buffer, Gate.nBuffLen + nMsgLen);
      Move(Buffer^, Gate.Buffer[Gate.nBuffLen], nMsgLen);
    end;
  except
    MainOutMessageAPI(sExceptionMsg1);
  end;
  try
    nLen := Gate.nBuffLen + nMsgLen;
    Buff := Gate.Buffer;

    //nLen2 := Gate.nBuffLen + nMsgLen;
    //Buff2 := Gate.Buffer;

    if nLen >= SizeOf(TMsgHeader) then
    begin
      while (True) do
      begin
        MsgHeader := pTMsgHeader(Buff);
        nCheckMsgLen := abs(MsgHeader.nLength) + SizeOf(TMsgHeader);
        //MainOutMessageAPI('nCheckMsgLen = ' + IntToStr(nCheckMsgLen));
        if (MsgHeader.dwCode = RUNGATECODE) and (nCheckMsgLen < $8000) then
        begin //0319
          if nLen < nCheckMsgLen then
            Break;
          MsgBuff := Buff + SizeOf(TMsgHeader);
          ExecGateMsg(nGateIndex, Gate, MsgHeader, MsgBuff, MsgHeader.nLength);
          Buff := Buff + SizeOf(TMsgHeader) + MsgHeader.nLength;
          nLen := nLen - (MsgHeader.nLength + SizeOf(TMsgHeader));
          //fProced := True;			//修正丢包
        end
        else
        begin
          //MainOutMessageAPI('not RUNGATECODE = ' + IntToStr(nCheckMsgLen));
          Inc(Buff);
          Dec(nLen);
        end;
        if nLen < SizeOf(TMsgHeader) then
          Break;
      end;
    end;
  except
    MainOutMessageAPI(sExceptionMsg2);
  end;
  try
    if nLen > 0 then
    begin
      {if not fProced and (nLen2 >= SizeOf(TMsgHeader)) then begin
        nLen := nLen2;
        Buff := Buff2;
      end;}
      GetMem(TempBuff, nLen);
      Move(Buff^, TempBuff^, nLen);
      FreeMem(Gate.Buffer);
      Gate.Buffer := TempBuff;
      Gate.nBuffLen := nLen;
    end
    else
    begin
      FreeMem(Gate.Buffer);
      Gate.Buffer := nil;
      Gate.nBuffLen := 0;
    end;
  except
    MainOutMessageAPI(sExceptionMsg3);
  end;
end;

procedure TRunSocket.SocketRead(Socket: TCustomWinSocket);
var
  nMsgLen, GateIdx: Integer;
  Gate: pTGateInfo;
  RecvBuffer: array[0..DATA_BUFSIZE * 2 - 1] of Char;
resourcestring
  sExceptionMsg1 = '[Exception] TRunSocket::SocketRead';
begin
  for GateIdx := Low(g_GateArr) to High(g_GateArr) do
  begin
    Gate := @g_GateArr[GateIdx];
    if Gate.Socket = Socket then
    begin
      //try
      while (True) do
      begin
        nMsgLen := Socket.ReceiveBuf(RecvBuffer, SizeOf(RecvBuffer));
        if nMsgLen <= 0 then
          Break;
        ExecGateBuffers(GateIdx, Gate, @RecvBuffer, nMsgLen);
      end;
      Break;
      {except
        MainOutMessageAPI(sExceptionMsg1);
      end;}
    end;
  end;
end;

procedure TRunSocket.Run();
var
  dwRunTick: LongWord;
  i, nC: Integer;
  Gate: pTGateInfo;
resourcestring
  sExceptionMsg = '[Exception] TRunSocket::Run %d';
begin
  dwRunTick := GetTickCount();
  if boStartReady then
  begin
    nC := 0;
    try
      {if g_Config.nGateLoad > 0 then begin
        if (GetTickCount - dwSendTestMsgTick) >= 100 then begin
          dwSendTestMsgTick := GetTickCount();
          for i := Low(g_GateArr) to High(g_GateArr) do begin
            Gate := @g_GateArr[i];
            if Gate.BufferList <> nil then begin
              for nG := 0 to g_Config.nGateLoad - 1 do
                SendGateTestMsg(i);
            end;
          end;
        end;
      end;}

      {if (GetTickCount - dwSendBlockUserTick) >= 500 then begin
        dwSendBlockUserTick := GetTickCount();
        EnterCriticalSection(g_BlockUserLock);
        try
          for nC := 0 to g_xBlockUserList.Count - 1 do begin
            SetLength(szUserName, Length(g_xBlockUserList[nC]));
            Move(g_xBlockUserList[nC][1], szUserName[1], Length(g_xBlockUserList[nC]));
            for i := Low(g_GateArr) to High(g_GateArr) do begin
              Gate := @g_GateArr[i];
              if Gate.BufferList <> nil then begin
                SendGateBlockUserMsg(i, szUserName);
              end;
            end;
          end;
          g_xBlockUserList.Clear;
        finally
          LeaveCriticalSection(g_BlockUserLock);
        end;
      end;}

      nC := 1;
      for i := Low(g_GateArr) to High(g_GateArr) do
      begin
        Gate := @g_GateArr[i];
        nC := 2;
        if Gate.boUsed and (Gate.Socket <> nil) and (Gate.BufferList <> nil) then
        begin
          nC := 3;
          EnterCriticalSection(m_RunSocketSection);
          try
            nC := 4;
            Gate.nSendMsgCount := Gate.BufferList.Count;
            nC := 5;
            if SendGateBuffers(i, Gate, Gate.BufferList) then
              Gate.nSendRemainCount := Gate.BufferList.Count
            else
              Gate.nSendRemainCount := Gate.BufferList.Count;
          finally
            LeaveCriticalSection(m_RunSocketSection);
          end;
        end;
      end;

      nC := 6;
      for i := Low(g_GateArr) to High(g_GateArr) do
      begin
        nC := 7;
        if g_GateArr[i].Socket <> nil then
        begin
          nC := 8;
          Gate := @g_GateArr[i];
          nC := 9;
          if (GetTickCount - Gate.dwSendTick) >= 1000 then
          begin
            Gate.dwSendTick := GetTickCount();
            Gate.nSendMsgBytes := Gate.nSendBytesCount;
            Gate.nSendedMsgCount := Gate.nSendCount;
            Gate.nSendBytesCount := 0;
            Gate.nSendCount := 0;
          end;
          nC := 10;
          if Gate.boSendKeepAlive then
          begin
            Gate.boSendKeepAlive := False;
            SendCheck(Gate.Socket, GM_CHECKSERVER);
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        MainOutMessageAPI(Format(sExceptionMsg, [nC]));
        MainOutMessageAPI(E.Message);
      end;
    end;
  end;
  g_nSockCountMin := GetTickCount - dwRunTick;
  if g_nSockCountMin > g_nSockCountMax then
    g_nSockCountMax := g_nSockCountMin;
end;

procedure TRunSocket.DoClientCertification(GateIdx: Integer; GateUser: pTGateUserInfo; nSocket: Integer; sMsg: string);

  function GetCertification(sMsg: string;
    var sAccount: string;
    var sChrName: string;
    var nSessionID: Integer;
    var nClientVersion: Integer;
    var tHWID: MD5Digest;
    var boFlag: Boolean): Boolean;
  var
    sData, sHWID: string;
    sCodeStr, sClientVersion: string;
    sIdx: string;
  resourcestring
    sExceptionMsg = '[Exception] TRunSocket::DoClientCertification -> GetCertification';
  begin
    Result := False;
    try
      sData := DecodeString(sMsg);
      if (Length(sData) > 2) and (sData[1] = '*') and (sData[2] = '*') then
      begin
        sData := Copy(sData, 3, Length(sData) - 2);
        sData := GetValidStr3(sData, sAccount, ['/']);
        sData := GetValidStr3(sData, sChrName, ['/']);
        sData := GetValidStr3(sData, sCodeStr, ['/']);
        sData := GetValidStr3(sData, sClientVersion, ['/']);
        sData := GetValidStr3(sData, sIdx, ['/']);
        sData := GetValidStr3(sData, sHWID, ['/']);

        nSessionID := Str_ToInt(sCodeStr, 0);
        if sIdx = '0' then
          boFlag := True
        else
          boFlag := False;
        if (sAccount <> '') and (sChrName <> '') and (nSessionID >= 2) and (sHWID <> '') then
        begin
          nClientVersion := Str_ToInt(sClientVersion, 0);
          tHWID := MD5.MD5UnPrint(sHWID);
          Result := True;
        end;
      end;
    except
      MainOutMessageAPI(sExceptionMsg);
    end;
  end;

var
  nCheckCode: Integer;
  sData: string;
  sAccount, sChrName: string;
  nSessionID: Integer;
  boFlag: Boolean;
  nClientVersion: Integer;
  nPayMent, nPayMode: Integer;
  SessInfo: pTSessInfo;
  tHWID: MD5Digest;
resourcestring
  sExceptionMsg = '[Exception] TRunSocket::DoClientCertification CheckCode: ';
  sDisable = '*disable*';
begin
  nCheckCode := 0;
  try
    if GateUser.sAccount = '' then
    begin
      if TagCount(sMsg, '!') > 0 then
      begin
        sData := ArrestStringEx(sMsg, '#', '!', sMsg);
        sMsg := Copy(sMsg, 2, Length(sMsg) - 1);
        if GetCertification(sMsg, sAccount, sChrName, nSessionID, nClientVersion, tHWID, boFlag) then
        begin
          SessInfo := FrmIDSoc.GetAdmission(sAccount, GateUser.sIPaddr, nSessionID, nPayMode, nPayMent);
          if (SessInfo <> nil) and (nPayMent > 0) then
          begin
            GateUser.boCertification := True;
            GateUser.sAccount := Trim(sAccount);
            GateUser.sCharName := Trim(sChrName);
            GateUser.nSessionID := nSessionID;
            GateUser.nClientVersion := nClientVersion;
            GateUser.SessInfo := SessInfo;
            //if HeroGetMaster(GateUser.sCharName, GateUser.sAccount) then GateUser.sIPaddr := '@HERO@';
            try
              FrontEngine.AddToLoadRcdList(sAccount,
                sChrName,
                GateUser.sIPaddr,
                1,
                nSessionID,
                nPayMent,
                nPayMode,
                nClientVersion,
                nSocket,
                GateUser.nGSocketIdx,
                GateIdx,
                '',
                @tHWID);
            except
              MainOutMessageAPI(Format(sExceptionMsg, [nCheckCode]));
            end;
          end
          else
          begin
            nCheckCode := 2;
            GateUser.sAccount := sDisable;
            GateUser.boCertification := False;
            CloseUser(GateIdx, nSocket);
            //nCheckCode := 3;
          end;
        end
        else
        begin
          nCheckCode := 4;
          GateUser.sAccount := sDisable;
          GateUser.boCertification := False;
          CloseUser(GateIdx, nSocket);
          //nCheckCode := 5;
        end;
      end;
    end;
  except
    MainOutMessageAPI(Format(sExceptionMsg, [nCheckCode]));
  end;
end;

{type
  TGateMag = packed record
    BufferLen: Integer;
    MsgHeader: TMsgHeader;
    DefMsg: TDefaultMessage;
    Sendmsg: PChar;
  end;
  PTGateMag = ^TGateMag;}

function TRunSocket.SendGateBuffers(GateIdx: Integer; Gate: pTGateInfo; MsgList: TList): Boolean;
var
  dwRunTick: LongWord;
  BufferA: PChar;
  BufferB: PChar;
  BufferC: PChar;
  i, nRet, nCheckCode: Integer;
  nBuffALen: Integer;
  nBuffBLen: Integer;
  nBuffCLen: Integer;
  nSendBuffLen: Integer;
  nSendFail: Integer;
resourcestring
  sExceptionMsg1 = '[Exception] TRunSocket::SendGateBuffers -> ProcessBuff';
  sExceptionMsg2 = '[Exception] TRunSocket::SendGateBuffers -> SendBuff Code:%d';
begin
  Result := True;
  if MsgList.Count = 0 then
    Exit;
  dwRunTick := GetTickCount();
  if Gate.nSendChecked > 0 then
  begin {如果网关未回复状态消息，则不再发送数据}
    if (GetTickCount - Gate.dwSendCheckTick) > g_dwSocCheckTimeOut {2 * 1000} then
    begin
      Gate.nSendChecked := 0;
      Gate.nSendBlockCount := 0;
    end;
    Exit;
  end;

  try
    if MsgList.Count > 1 then
    begin //将小数据合并为一个指定大小的数据, 减少send()缓冲区压力
      i := 0;
      BufferA := MsgList.Items[i];
      while (True) do
      begin
        nRet := i + 1;
        if nRet >= MsgList.Count then
          Break;
        BufferB := MsgList.Items[nRet];

        //nBuffALen := PTGateMag(BufferA).BufferLen; //
        //nBuffBLen := PTGateMag(BufferB).BufferLen; //

        Move(BufferA^, nBuffALen, SizeOf(Integer));
        Move(BufferB^, nBuffBLen, SizeOf(Integer));

        if (nBuffALen + nBuffBLen) < g_Config.nSendBlock then
        begin
          MsgList.Delete(nRet);
          GetMem(BufferC, nBuffALen + SizeOf(Integer) + nBuffBLen);
          nBuffCLen := nBuffALen + nBuffBLen;
          Move(nBuffCLen, BufferC^, SizeOf(Integer));
          Move(BufferA[SizeOf(Integer)], PChar(BufferC + SizeOf(Integer))^, nBuffALen);
          Move(BufferB[SizeOf(Integer)], PChar(BufferC + nBuffALen + SizeOf(Integer))^, nBuffBLen);
          FreeMem(BufferA);
          FreeMem(BufferB);
          BufferA := BufferC;
          MsgList.Items[i] := BufferA;
          Continue;
        end;
        Inc(i);
        BufferA := BufferB;
        if i > 10240 then
          Break; //0901 10240     1001
      end;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(sExceptionMsg1);
      MainOutMessageAPI(E.Message);
    end;
  end;

  nCheckCode := 0;
  try
    nSendFail := 0;
    while MsgList.Count > 0 do
    begin
      nCheckCode := 1;
      BufferA := MsgList.Items[0];
      if BufferA = nil then
      begin
        MsgList.Delete(0);
        Continue;
      end;
      nCheckCode := 2;
      //nSendBuffLen := PTGateMag(BufferA).BufferLen;
      Move(BufferA^, nSendBuffLen, SizeOf(Integer));

      if nSendBuffLen = 0 then
      begin
        MsgList.Delete(0);
        FreeMem(BufferA);
        Continue;
      end;

      nCheckCode := 3;
      if (Gate.nSendChecked = 0) and ((Gate.nSendBlockCount + nSendBuffLen) >= g_Config.nCheckBlock) then
      begin
        if (Gate.nSendBlockCount = 0) and (g_Config.nCheckBlock <= nSendBuffLen) then
        begin //丢掉大数据包
          nCheckCode := 4;
          MsgList.Delete(0);
          FreeMem(BufferA);
          Break;
        end
        else
        begin
          nCheckCode := 5;
          if Gate.nSendBlockCount + nSendBuffLen >= g_Config.nCheckBlock * 2 then
          begin
            SendCheck(Gate.Socket, GM_RECEIVE_OK);
            Gate.nSendChecked := 1;
            Gate.dwSendCheckTick := GetTickCount();
          end;
          //if Gate.nSendBlockCount + nSendBuffLen >= g_Config.nCheckBlock * 10 then //延迟发送，这里限制了发送流量
          //  Break;
        end;
        //Break;
      end;

      nCheckCode := 6;
      BufferB := BufferA + SizeOf(Integer);

      nCheckCode := 7;
      if nSendBuffLen > 0 then
      begin
        if Gate.Socket <> nil then
        begin
          nRet := nSendBuffLen;
          nCheckCode := 8;
          if Gate.Socket.Connected then
          begin
            nCheckCode := 9;
            nRet := Gate.Socket.SendBuf(BufferB^, nSendBuffLen);
            if nRet <= 0 then
            begin //发送未成功
              Inc(nSendFail);

              nCheckCode := 10;
              if (GetTickCount - dwRunTick) > g_dwSocLimit then
              begin //超时处理
                Result := False;
                Break;
              end;

              //0625
              nCheckCode := 11;
              if MsgList.Count > 32 then
              begin //移动到数据末端，等待下次发送   0802
                MsgList.Move(0, MsgList.Count - 1);
                Continue;
              end;

              if nSendFail <= 512 then
              begin
                Continue;
              end;

              Break;
            end;
          end;
          Inc(Gate.nSendCount);
          Inc(Gate.nSendBytesCount, nRet); //real send...
          Inc(Gate.nSendBlockCount, nRet);
        end;
        nSendBuffLen := 0;
      end;

      nCheckCode := 12;
      MsgList.Delete(0);
      FreeMem(BufferA);
      if (GetTickCount - dwRunTick) > g_dwSocLimit then
      begin
        Result := False;
        Break;
      end;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg2, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

procedure TRunSocket.CloseUser(GateIdx, nSocket: Integer);
var
  i, n: Integer;
  GateUser: pTGateUserInfo;
  Gate: pTGateInfo;
resourcestring
  sExceptionMsg0 = '[Exception] TRunSocket::CloseUser 0';
  sExceptionMsg1 = '[Exception] TRunSocket::CloseUser 1';
  sExceptionMsg2 = '[Exception] TRunSocket::CloseUser 2-%d';
  sExceptionMsg3 = '[Exception] TRunSocket::CloseUser 3';
  sExceptionMsg4 = '[Exception] TRunSocket::CloseUser 4';
begin
  if (nSocket = -1) then
    Exit;

  if GateIdx <= High(g_GateArr) then
  begin
    Gate := @g_GateArr[GateIdx];
    if Gate.UserList <> nil then
    begin
      EnterCriticalSection(m_RunSocketSection);
      try
        try
          for i := 0 to Gate.UserList.Count - 1 do
          begin
            if Gate.UserList.Items[i] <> nil then
            begin
              GateUser := Gate.UserList.Items[i];
              if GateUser.nSocket = nSocket then
              begin
                try
                  if GateUser.FrontEngine <> nil then
                    TFrontEngine(GateUser.FrontEngine).DeleteHuman(i, GateUser.nSocket);
                except
                  MainOutMessageAPI(sExceptionMsg1);
                end;

                try
                  n := 0;
                  if GateUser.PlayObject <> nil then
                  begin
                    n := 1;
                    if TPlayObject(GateUser.PlayObject).m_boSetOffLine and not TPlayObject(GateUser.PlayObject).m_boDeath and TPlayObject(GateUser.PlayObject).InSafeZone() then
                    begin
                      //n := 3;
                      if (TPlayObject(GateUser.PlayObject).m_HeroObject <> nil) and not TPlayObject(GateUser.PlayObject).m_HeroObject.m_boGhost then
                      begin

                        TPlayObject(GateUser.PlayObject).m_HeroObject.m_dwHeroSaveRcdTick := 0; //Save rcd now

                        //TPlayObject(GateUser.PlayObject).SendDefMessage(SM_HEROSTATEDISPEAR, 0, 0, 0, 0, '');
                        //TPlayObject(GateUser.PlayObject).m_HeroObject.SendRefMsg(RM_HEROLOGOUT, 0, TPlayObject(GateUser.PlayObject).m_HeroObject.m_nCurrX, TPlayObject(GateUser.PlayObject).m_HeroObject.m_nCurrY, 0, '');
                        //TPlayObject(GateUser.PlayObject).m_HeroObject.MakeGhost;
                        //TPlayObject(GateUser.PlayObject).m_HeroObject := nil;
                      end;

                      if (g_FunctionNPC <> nil) then
                      begin
                        if not TPlayObject(GateUser.PlayObject).m_boReconnection then //大退
                          g_FunctionNPC.GotoLable(TPlayObject(GateUser.PlayObject), '@OnLogout_OffLinePlaying', False)
                        else
                          g_FunctionNPC.GotoLable(TPlayObject(GateUser.PlayObject), '@OnLogout_SoftClosing', False);
                      end;

                      n := 8;
                      TPlayObject(GateUser.PlayObject).m_boOffLineFlag := True;
                      //TPlayObject(GateUser.PlayObject).m_boSearch := True;
                      //检测
                      if not TPlayObject(GateUser.PlayObject).m_boOffLinePlay then
                        TPlayObject(GateUser.PlayObject).m_btHeroRelax := 2;

                      TPlayObject(GateUser.PlayObject).m_boAllowGroup := False;
                      TPlayObject(GateUser.PlayObject).m_boAutoGetExpInSafeZone := True;
                      TPlayObject(GateUser.PlayObject).m_AutoGetExpEnvir := TPlayObject(GateUser.PlayObject).m_PEnvir;
                      if TPlayObject(GateUser.PlayObject).m_nAutoGetExpTime = 0 then
                        TPlayObject(GateUser.PlayObject).m_nAutoGetExpTime := 120 * 1000;
                      if TPlayObject(GateUser.PlayObject).m_nAutoGetExpPoint = 0 then
                        TPlayObject(GateUser.PlayObject).m_nAutoGetExpPoint := 500;
                      //TPlayObject(GateUser.PlayObject).m_dwKickOffLineTick := High(DWORD);
                    end;
                    n := 9;
                    if not TPlayObject(GateUser.PlayObject).m_boOffLineFlag then
                    begin
                      TPlayObject(GateUser.PlayObject).m_boSoftClose := True
                    end
                    else if not TPlayObject(GateUser.PlayObject).m_boReconnection then
                    begin
                      FrmIDSoc.SendHumanLogOutMsg(TPlayObject(GateUser.PlayObject).m_sUserID, TPlayObject(GateUser.PlayObject).m_nSessionID);
                    end;
                  end;
                except
                  MainOutMessageAPI(Format(sExceptionMsg2, [n]));
                end;

                try
                  if (GateUser.PlayObject <> nil) then
                  begin
                    if (TPlayObject(GateUser.PlayObject).m_boGhost and not TPlayObject(GateUser.PlayObject).m_boReconnection) then
                      FrmIDSoc.SendHumanLogOutMsg(GateUser.sAccount, GateUser.nSessionID);
                  end;
                except
                  MainOutMessageAPI(sExceptionMsg3);
                end;

                try
                  Dispose(GateUser);
                  Gate.UserList.Items[i] := nil;
                  Dec(Gate.nUserCount);
                except
                  MainOutMessageAPI(sExceptionMsg4);
                end;

                Break;
              end;
            end;
          end;
        except
          on E: Exception do
          begin
            MainOutMessageAPI(sExceptionMsg0);
            MainOutMessageAPI(E.Message);
          end;
        end;
      finally
        LeaveCriticalSection(m_RunSocketSection);
      end;
    end;
  end;
end;

function TRunSocket.OpenNewUser(nSocket: Integer; nGSocketIdx: Integer; sIPaddr: string; UserList: TList): Integer;
var
  i: Integer;
  GateUser: pTGateUserInfo;
begin
  New(GateUser);
  GateUser.sAccount := '';
  GateUser.sCharName := '';
  GateUser.sIPaddr := sIPaddr;
  GateUser.nSocket := nSocket;
  GateUser.nGSocketIdx := nGSocketIdx;
  GateUser.nSessionID := 0;
  GateUser.UserEngine := nil;
  GateUser.FrontEngine := nil;
  GateUser.PlayObject := nil;
  GateUser.boCertification := False;
  for i := 0 to UserList.Count - 1 do
  begin
    if UserList.Items[i] = nil then
    begin
      UserList.Items[i] := GateUser;
      Result := i;
      Exit;
    end;
  end;
  UserList.Add(GateUser);
  Result := UserList.Count - 1;
end;

procedure TRunSocket.SendNewUserMsg(Socket: TCustomWinSocket; nSocket: Integer; nSocketIndex, nUserIdex: Integer);
var
  MsgHeader: TMsgHeader;
begin
  if not Socket.Connected then
    Exit;
  MsgHeader.dwCode := RUNGATECODE;
  MsgHeader.nSocket := nSocket;
  MsgHeader.wGSocketIdx := nSocketIndex;
  MsgHeader.wIdent := GM_SERVERUSERINDEX;
  MsgHeader.wUserListIndex := nUserIdex;
  MsgHeader.nLength := 0;
  if Socket <> nil then
    Socket.SendBuf(MsgHeader, SizeOf(TMsgHeader));
end;

procedure TRunSocket.ExecGateMsg(GateIdx: Integer; Gate: pTGateInfo; MsgHeader: pTMsgHeader; MsgBuff: PChar; nMsgLen: Integer);
var
  nUserIdx: Integer;
  sIPaddr: string;
  GateUser: pTGateUserInfo;
  i: Integer;
resourcestring
  sExceptionMsg = '[Exception] TRunSocket::ExecGateMsg %d';
begin
  try
    case MsgHeader.wIdent of
      //SendServerMsg(GM_OPEN, nSockIdx, Socket.SocketHandle, 0, Length(Socket.RemoteAddress) + 1, PChar(Socket.RemoteAddress));
      GM_OPEN:
        begin
          sIPaddr := StrPas(MsgBuff);
          nUserIdx := OpenNewUser(MsgHeader.nSocket, MsgHeader.wGSocketIdx, sIPaddr, Gate.UserList);
          SendNewUserMsg(Gate.Socket, MsgHeader.nSocket, MsgHeader.wGSocketIdx, nUserIdx + 1);
          Inc(Gate.nUserCount);
        end;
      GM_CLOSE:
        begin
          CloseUser(GateIdx, MsgHeader.nSocket);
        end;
      GM_CHECKCLIENT:
        begin
          Gate.boSendKeepAlive := True;
        end;
      GM_RECEIVE_OK:
        begin
          //MainOutMessageAPI('[TRunSocket] :: GM_RECEIVE_OK ...');
          Gate.nSendChecked := 0;
          Gate.nSendBlockCount := 0;
        end;
      GM_DATA:
        begin
          GateUser := nil;
          if MsgHeader.wUserListIndex >= 1 then
          begin //speed up
            nUserIdx := MsgHeader.wUserListIndex - 1;
            if Gate.UserList.Count > nUserIdx then
            begin
              GateUser := Gate.UserList.Items[nUserIdx];
              if (GateUser <> nil) and (GateUser.nSocket <> MsgHeader.nSocket) then
                GateUser := nil;
            end;
          end;
          if GateUser = nil then
          begin
            //MainOutMessageAPI('[TRunSocket] :: ExecGateMsg GateUser=nil ...');
            for i := 0 to Gate.UserList.Count - 1 do
            begin
              if Gate.UserList.Items[i] = nil then
                Continue;
              if pTGateUserInfo(Gate.UserList.Items[i]).nSocket = MsgHeader.nSocket then
              begin
                GateUser := Gate.UserList.Items[i];
                Break;
              end;
            end;
          end;

          if GateUser <> nil then
          begin
            if (GateUser.PlayObject <> nil) and (GateUser.UserEngine <> nil) then
            begin
              if GateUser.boCertification and (nMsgLen >= SizeOf(TDefaultMessage)) then
              begin
                if nMsgLen = SizeOf(TDefaultMessage) then
                  UserEngine.ProcessUserMessage(TPlayObject(GateUser.PlayObject), pTDefaultMessage(MsgBuff), nil)
                else
                  UserEngine.ProcessUserMessage(TPlayObject(GateUser.PlayObject), pTDefaultMessage(MsgBuff), @MsgBuff[SizeOf(TDefaultMessage)]);
              end;
            end
            else
              DoClientCertification(GateIdx, GateUser, MsgHeader.nSocket, StrPas(MsgBuff));
          end;
        end;
    end;
  except
    MainOutMessageAPI(Format(sExceptionMsg, [0]));
  end;
end;

procedure TRunSocket.SendCheck(Socket: TCustomWinSocket; nIdent: Integer);
var
  MsgHeader: TMsgHeader;
begin
  if not Socket.Connected then
    Exit;
  MsgHeader.dwCode := RUNGATECODE;
  MsgHeader.nSocket := 0;
  MsgHeader.wIdent := nIdent;
  MsgHeader.nLength := 0;
  if Socket <> nil then
    Socket.SendBuf(MsgHeader, SizeOf(TMsgHeader));
end;

procedure TRunSocket.LoadRunAddr();
var
  sFileName: string;
begin
  sFileName := '.\RunAddr.txt';
  if FileExists(sFileName) then
  begin
    m_RunAddrList.LoadFromFile(sFileName);
    TrimStringList(m_RunAddrList);
  end;
end;

constructor TRunSocket.Create();
var
  i: Integer;
  Gate: pTGateInfo;
begin
  InitializeCriticalSection(m_RunSocketSection);
  m_RunAddrList := TStringList.Create;
  for i := Low(g_GateArr) to High(g_GateArr) do
  begin
    Gate := @g_GateArr[i];
    Gate.boUsed := False;
    Gate.Socket := nil;
    Gate.boSendKeepAlive := False;
    Gate.nSendMsgCount := 0;
    Gate.nSendRemainCount := 0;
    Gate.dwSendTick := GetTickCount();
    Gate.nSendMsgBytes := 0;
    Gate.nSendedMsgCount := 0;
  end;
  LoadRunAddr();
end;

procedure TRunSocket.DemoRun;
begin
{$IF SoftVersion = VERDEMO}
  Run();
{$IFEND}
end;

destructor TRunSocket.Destroy;
begin
  m_RunAddrList.Free;
  DeleteCriticalSection(m_RunSocketSection);
  inherited;
end;

function TRunSocket.AddGateBuffer(GateIdx: Integer; Buffer: PChar): Boolean;
var
  Gate: pTGateInfo;
begin
  Result := False;
  if Buffer = nil then
    Exit;
  if GateIdx < RUNGATEMAX then
  begin
    EnterCriticalSection(m_RunSocketSection);
    try
      Gate := @g_GateArr[GateIdx];
      if (Gate.BufferList <> nil) {and (Buffer <> nil)} then
      begin
        if Gate.boUsed and (Gate.Socket <> nil) then
        begin
          Gate.BufferList.Add(Buffer);
          Result := True;
        end;
      end;
    finally
      LeaveCriticalSection(m_RunSocketSection);
    end;
  end;
end;

function TRunSocket.AddGateBufferAll(Buffer: PChar; BufLen: Integer): Boolean;
var
  i: Integer;
  Gate: pTGateInfo;
  pAddBuf: PChar;
begin
  Result := False;
  if (Buffer = nil) or (BufLen = 0) then
    Exit;
  EnterCriticalSection(m_RunSocketSection);
  try
    for i := Low(g_GateArr) to High(g_GateArr) do
    begin
      Gate := @g_GateArr[i];
      if Gate.boUsed and (Gate.Socket <> nil) and (Gate.UserList <> nil) then
      begin
        if Gate.BufferList <> nil then
        begin
          GetMem(pAddBuf, BufLen);
          Move(Buffer^, pAddBuf^, BufLen);
          Gate.BufferList.Add(pAddBuf);
          Result := True;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(m_RunSocketSection);
  end;
end;

procedure TRunSocket.SendOutConnectMsg(nGateIdx, nSocket, nGsIdx: Integer);
var
  DefMsg: TDefaultMessage;
  MsgHeader: TMsgHeader;
  nLen: Integer;
  Buff: PChar;
begin
  DefMsg := MakeDefaultMsg(SM_OUTOFCONNECTION, 0, 0, 0, 0);
  MsgHeader.dwCode := RUNGATECODE;
  MsgHeader.nSocket := nSocket;
  MsgHeader.wGSocketIdx := nGsIdx;
  MsgHeader.wIdent := GM_DATA;
  MsgHeader.nLength := SizeOf(TDefaultMessage);
  nLen := MsgHeader.nLength + SizeOf(TMsgHeader);
  GetMem(Buff, nLen + SizeOf(Integer));
  Move(nLen, Buff^, SizeOf(Integer));
  Move(MsgHeader, Buff[SizeOf(Integer)], SizeOf(TMsgHeader));
  Move(DefMsg, Buff[SizeOf(Integer) + SizeOf(TMsgHeader)], SizeOf(TDefaultMessage));
  if not AddGateBuffer(nGateIdx, Buff) then
    FreeMem(Buff);
end;

procedure TRunSocket.SetGateUserList(nGateIdx, nSocket: Integer; PlayObject: TPlayObject); //004E0CEC
var
  i: Integer;
  GateUserInfo: pTGateUserInfo;
  Gate: pTGateInfo;
begin
  if nGateIdx > High(g_GateArr) then
    Exit;
  Gate := @g_GateArr[nGateIdx];
  if Gate.UserList = nil then
    Exit;
  EnterCriticalSection(m_RunSocketSection);
  try
    for i := 0 to Gate.UserList.Count - 1 do
    begin
      GateUserInfo := Gate.UserList.Items[i];
      if (GateUserInfo <> nil) and (GateUserInfo.nSocket = nSocket) then
      begin
        GateUserInfo.FrontEngine := nil;
        GateUserInfo.UserEngine := UserEngine;
        GateUserInfo.PlayObject := PlayObject;
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(m_RunSocketSection);
  end;
end;
{
procedure TRunSocket.SendGateTestMsg(nIndex: Integer);
var
  MsgHdr: TMsgHeader;
  Buff: PChar;
  nLen: Integer;
  DefMsg: TDefaultMessage;
begin
  MsgHdr.dwCode := RUNGATECODE;
  MsgHdr.nSocket := 0;
  MsgHdr.wIdent := GM_TEST;
  MsgHdr.nLength := 80;
  nLen := MsgHdr.nLength + SizeOf(TMsgHeader);
  GetMem(Buff, nLen + SizeOf(Integer));
  Move(nLen, Buff^, SizeOf(Integer));
  Move(MsgHdr, Buff[SizeOf(Integer)], SizeOf(TMsgHeader));
  Move(DefMsg, Buff[SizeOf(TMsgHeader) + SizeOf(Integer)], SizeOf(TDefaultMessage));
  if not AddGateBuffer(nIndex, Buff) then
    FreeMem(Buff);
end;
 }
procedure TRunSocket.KickUser(sAccount: string; nSessionID: Integer);
var
  i: Integer;
  ii: Integer;
  GateUserInfo: pTGateUserInfo;
  Gate: pTGateInfo;
  nCheckCode: Integer;
resourcestring
  sExceptionMsg = '[Exception] TRunSocket::KickUser';
  sKickUserMsg = '当前登录帐号正在其它位置登录，本机已被强行离线';
begin
  try
    nCheckCode := 0;
    for i := Low(g_GateArr) to High(g_GateArr) do
    begin
      Gate := @g_GateArr[i];
      if Gate.boUsed and (Gate.Socket <> nil) and (Gate.UserList <> nil) then
      begin
        EnterCriticalSection(m_RunSocketSection);
        try
          for ii := 0 to Gate.UserList.Count - 1 do
          begin
            GateUserInfo := Gate.UserList.Items[ii];
            if GateUserInfo = nil then
              Continue;
            if (GateUserInfo.sAccount = sAccount) or (GateUserInfo.nSessionID = nSessionID) then
            begin
              if GateUserInfo.FrontEngine <> nil then
                TFrontEngine(GateUserInfo.FrontEngine).DeleteHuman(i, GateUserInfo.nSocket);
              if (GateUserInfo.PlayObject <> nil) and not GateUserInfo.PlayObject.m_boOffLineFlag then
              begin
                TPlayObject(GateUserInfo.PlayObject).SendDefMessage(SM_RUNGATELOGOUT, 0, 0, 0, 0, '');
                TPlayObject(GateUserInfo.PlayObject).SysMsg(sKickUserMsg, c_Red, t_Hint);
                TPlayObject(GateUserInfo.PlayObject).m_boEmergencyClose := True;
                TPlayObject(GateUserInfo.PlayObject).m_boSoftClose := True;
              end;
              nCheckCode := 10;
              Dispose(GateUserInfo);
              Gate.UserList.Items[ii] := nil;
              Dec(Gate.nUserCount);
              Break;
            end;
          end;
        finally
          LeaveCriticalSection(m_RunSocketSection);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

function TRunSocket.GetGateAddr(sIPaddr: string): string;
var
  i: Integer;
begin
  Result := sIPaddr;
  for i := 0 to m_nIPCount - 1 do
  begin
    if m_IPaddrArr[i].sIPaddr = sIPaddr then
    begin
      Result := m_IPaddrArr[i].dIPaddr;
      Break;
    end;
  end;
end;

procedure TRunSocket.Execute;
begin
  Run();
  //if (nRunSocketRun >= 0) and Assigned(PlugProcArray[nRunSocketRun].nProcAddr) then
  //  TClassProc(PlugProcArray[nRunSocketRun].nProcAddr)(self);
end;

initialization
  AddToProcTable(@TRunSocket.Run, 'TRunSocket.Run' {'TRunSocket.Run'});
  nRunSocketRun := AddToPulgProcTable('TRunSocket.Run' {'TRunSocket.Run'});

finalization

end.
