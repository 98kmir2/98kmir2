unit SendQueue;

interface

uses
  Windows, SysUtils, Classes, IOCPTypeDef, MemPool, Protocol;

const
  SEND_BUFFER_LEN = 08 * 1024;
  SEND_BLOCK_LEN = 01 * 1024;

  ADD_BUFFER_TO_QUEUE_OK = $00000000; //加入成功
  ADD_BUFFER_TO_QUEUE_DEATH_USER = $00000001; //该用户已经删除
  ADD_BUFFER_TO_QUEUE_FULL_BUFFRE = $00000002; //该用户的缓冲区已经满了，可能对方死机了
  ADD_BUFFER_TO_QUEUE_OTHER_ERROR = $00000003; //其他错误
  ADD_BUFFER_TO_QUEUE_SEND_ERROR = $00000004; //发送数据出错

type
  TDynPacket = record
    Pos: Integer;
    Len: Integer;
    Buf: PAnsiChar;
  end;
  pTDynPacket = ^TDynPacket;

  PSendQueueNode = ^_tagSendQueueNode;
  _tagSendQueueNode = record
    CommObj: TIOCPCommObj;
    QueueLock: TRTLCriticalSection;
    InSend: BOOL;
    MemPoolID: Integer;
    BufLPos: Integer;
    BufRPos: Integer;
    LeftLen: Integer;
    RightLen: Integer;
    SendLen: Integer; //发送中的长度
    DPBuffer: PAnsiChar; //拷贝数据的开始地址，减少计算
    SPBuffer: PAnsiChar; //发送缓冲的头地址
    BPBuffer: PAnsiChar; //头地址@buffer
    Buffer: array[0..SEND_BUFFER_LEN + 63] of Char;
    DynSendList: Classes.TList;
  end;
  TSendQueueNode = _tagSendQueueNode;

  ESendQueue = class(Exception);

  TSendQueue = class
  private
    FSendPool: TMemPool;
    FMaxUser: Integer;
  protected
    procedure InitMemPool;
    procedure FreeMemPoolRecvObj(const MemID: UINT; const MemBuffer: PAnsiChar);
    procedure CleanupMemPool;
  public
    property MemPool: TMemPool read FSendPool;
    procedure FreeSocket(ComOBJ: PIOCPCommObj);
    function GetSendQueue(InCommObj: PIOCPCommObj): PIOCPCommObj;
    function FreeSendQueue(ComOBJ: PIOCPCommObj): Boolean;
    function GetBuffer(ComOBJ: PIOCPCommObj): Boolean;
    function AddBuffer(ComOBJ: PIOCPCommObj; const pInBuffer: PChar; const nSize: Integer): Integer;
    function AddBuffer2(ComOBJ: PIOCPCommObj; const pInBuffer: PChar; const nSize: Integer): Boolean;
    function GetDynPacket(ComOBJ: PIOCPCommObj): pTDynPacket;
    constructor Create(MaxUser: Integer);
    destructor Destroy; override;
  end;

implementation

uses
  SHSocket, AcceptExWorkedThread, WinSock2, LogManager;

{ TSendQueue }

function TSendQueue.GetDynPacket(ComOBJ: PIOCPCommObj): pTDynPacket;
var
  PTRSendObj: PSendQueueNode;
begin
  Result := nil;
  PTRSendObj := PSendQueueNode(ComOBJ);
  if PTRSendObj.DynSendList.Count > 0 then
    Result := PTRSendObj.DynSendList[0];
end;

function TSendQueue.AddBuffer(ComOBJ: PIOCPCommObj; const pInBuffer: PChar; const nSize: Integer): Integer;
var
  PTRSendObj: PSendQueueNode;
  iSendLen: Integer;
  QuerySend, IsDynPacket, AddBufferOK: Boolean;
  NewDynBuf, DynPacket: pTDynPacket;

  InBuffer: PChar;
  Size: Integer;
begin
  PTRSendObj := PSendQueueNode(ComOBJ);
  Result := ADD_BUFFER_TO_QUEUE_OK;
  QuerySend := False;
  with PTRSendObj^ do
  begin
    EnterCriticalSection(QueueLock);
    try
      //数据包太大，丢掉
      if (nSize > 0) and (nSize <= SEND_BUFFER_LEN) then
      begin
        //如果动态列表有数据，继续加到动态列表，取出列表前端数据加到缓冲，保证顺序
        DynPacket := GetDynPacket(ComOBJ);
        if DynPacket <> nil then
        begin
          New(NewDynBuf);
          NewDynBuf.Pos := 0;
          NewDynBuf.Len := nSize;
          GetMem(NewDynBuf.Buf, nSize + 4);
          Move(pInBuffer^, NewDynBuf.Buf^, nSize);
          DynSendList.Add(NewDynBuf);

          InBuffer := DynPacket.Buf;
          Size := DynPacket.Len;
          IsDynPacket := True;
        end
        else
        begin
          InBuffer := pInBuffer;
          Size := nSize;
          IsDynPacket := False;
        end;

        AddBufferOK := False;
        if BufLPos = 0 then
        begin
          if RightLen >= Size then
          begin
            Move(InBuffer^, DPBuffer^, Size);
            Dec(RightLen, Size);
            Inc(BufRPos, Size);
            Inc(DPBuffer, Size);
            AddBufferOK := True;
          end
          else if LeftLen >= Size then
          begin
            Move(InBuffer^, BPBuffer^, Size);
            DPBuffer := PChar(Integer(BPBuffer) + Size);
            BufLPos := Size;
            AddBufferOK := True;
          end
          else
          begin
            //缓冲区满，暂时加到动态列表
            if not IsDynPacket then
            begin
              New(NewDynBuf);
              NewDynBuf.Pos := 0;
              NewDynBuf.Len := Size;
              GetMem(NewDynBuf.Buf, Size + 4);
              Move(InBuffer^, NewDynBuf.Buf^, Size);
              DynSendList.Add(NewDynBuf);
            end;
          end;
        end
        else
        begin
          if (LeftLen - BufLPos) >= Size then
          begin
            Move(InBuffer^, DPBuffer^, Size);
            Inc(BufLPos, Size);
            Inc(DPBuffer, Size);
            AddBufferOK := True;
          end
          else
          begin
            //缓冲区满，暂时加到动态列表
            if not IsDynPacket then
            begin
              New(NewDynBuf);
              NewDynBuf.Pos := 0;
              NewDynBuf.Len := Size;
              GetMem(NewDynBuf.Buf, Size + 4);
              Move(InBuffer^, NewDynBuf.Buf^, Size);
              DynSendList.Add(NewDynBuf);
            end;
          end;
        end;

        //取的动态数据加到缓冲成功，释放内存
        if IsDynPacket and AddBufferOK then
        begin
          FreeMem(DynPacket.Buf);
          Dispose(DynPacket);
          DynSendList.Delete(0);
        end;
      end;

      //当前没有发送数据，缓冲有数据，则开始发送请求...
      if not InSend then
      begin
        iSendLen := BufRPos - LeftLen;
        if iSendLen > 0 then
        begin
          if iSendLen > SEND_BLOCK_LEN then
            iSendLen := SEND_BLOCK_LEN;
          CommObj.WBuf.Buf := PChar(Integer(BPBuffer) + LeftLen);
          CommObj.WBuf.Len := iSendLen;
          SPBuffer := CommObj.WBuf.Buf;
          SendLen := CommObj.WBuf.Len;
          InSend := True;
          QuerySend := True;
        end
        else
        begin
          if BufLPos > 0 then
          begin
            CommObj.WBuf.Buf := BPBuffer;
            if BufLPos > SEND_BLOCK_LEN then
              CommObj.WBuf.Len := SEND_BLOCK_LEN
            else
              CommObj.WBuf.Len := BufLPos;
            SendLen := CommObj.WBuf.Len;
            SPBuffer := BPBuffer;
            LeftLen := 0;
            BufRPos := BufLPos;
            BufLPos := 0;
            RightLen := SEND_BUFFER_LEN - BufRPos;
            InSend := True;
            QuerySend := True;
          end;
        end;
      end;
    finally
      LeaveCriticalSection(QueueLock);
    end;
  end;

  if QuerySend then
  begin
    if not PostIOCPSend(ComOBJ) then
    begin
      Result := ADD_BUFFER_TO_QUEUE_SEND_ERROR;
      if g_pLogMgr.CheckLevel(4) then
        g_pLogMgr.Add('Send Buffer Failed, Client Recv Failed ?');
    end;
  end;

{$IFDEF _SHDEBUG}
  if Result = ADD_BUFFER_TO_QUEUE_FULL_BUFFRE then
  begin
    with PTRSendObj^ do
      if g_pLogMgr.CheckLevel(8) then
        g_pLogMgr.Add(format('BufLPos:%d, BufRPos:%d,LeftLen:%d,RightLen:%d,SendLen:%d,Size:%d',
          [BufLPos, BufRPos, LeftLen, RightLen, SendLen, Size]));
  end;
{$ENDIF}
end;

function TSendQueue.AddBuffer2(ComOBJ: PIOCPCommObj; const pInBuffer: PChar; const nSize: Integer): Boolean;
var
  PTRSendObj: PSendQueueNode;
  iSendLen: Integer;
  QuerySend: Boolean;
  NewDynBuf, DynPacket: pTDynPacket;
begin
  PTRSendObj := PSendQueueNode(ComOBJ);
  Result := True;
  QuerySend := False;
  with PTRSendObj^ do
  begin
    EnterCriticalSection(QueueLock);
    try
      //数据包太大，丢掉
      if (nSize > 0) and (nSize <= SEND_BUFFER_LEN) then
      begin
        if BufLPos = 0 then
        begin
          if RightLen >= nSize then
          begin
            Move(pInBuffer^, DPBuffer^, nSize);
            Dec(RightLen, nSize);
            Inc(BufRPos, nSize);
            Inc(DPBuffer, nSize);
          end
          else if LeftLen >= nSize then
          begin
            Move(pInBuffer^, BPBuffer^, nSize);
            DPBuffer := PChar(Integer(BPBuffer) + nSize);
            BufLPos := nSize;
          end;
        end
        else
        begin
          if (LeftLen - BufLPos) >= nSize then
          begin
            Move(pInBuffer^, DPBuffer^, nSize);
            Inc(BufLPos, nSize);
            Inc(DPBuffer, nSize);
          end;
        end;
      end;

      //当前没有发送数据，缓冲有数据，则开始发送请求...
      if not InSend then
      begin
        iSendLen := BufRPos - LeftLen;
        if iSendLen > 0 then
        begin
          if iSendLen > SEND_BLOCK_LEN then
            iSendLen := SEND_BLOCK_LEN;
          CommObj.WBuf.Buf := PChar(Integer(BPBuffer) + LeftLen);
          CommObj.WBuf.Len := iSendLen;
          SPBuffer := CommObj.WBuf.Buf;
          SendLen := CommObj.WBuf.Len;
          InSend := True;
          QuerySend := True;
        end
        else
        begin
          if BufLPos > 0 then
          begin
            CommObj.WBuf.Buf := BPBuffer;
            if BufLPos > SEND_BLOCK_LEN then
              CommObj.WBuf.Len := SEND_BLOCK_LEN
            else
              CommObj.WBuf.Len := BufLPos;
            SendLen := CommObj.WBuf.Len;
            SPBuffer := BPBuffer;
            LeftLen := 0;
            BufRPos := BufLPos;
            BufLPos := 0;
            RightLen := SEND_BUFFER_LEN - BufRPos;
            InSend := True;
            QuerySend := True;
          end;
        end;
      end;
    finally
      LeaveCriticalSection(QueueLock);
    end;
  end;

  if QuerySend then
  begin
    Result := PostIOCPSend(ComOBJ);
  end;
end;

procedure TSendQueue.CleanupMemPool;
var
  i: Integer;
  PTRSendObj: PSendQueueNode;
  PTRMemId: PMemNode;
  DynPacket: pTDynPacket;
begin
  PTRMemId := FSendPool.MemoryIDHeader;

  for i := 0 to FSendPool.RealBlockCount - 1 do
  begin
    PTRSendObj := PSendQueueNode(PTRMemId.MemBuffer);
    while True do
    begin
      DynPacket := GetDynPacket(PIOCPCommObj(PTRSendObj));
      if DynPacket = nil then
        Break;
      FreeMem(DynPacket.Buf);
      Dispose(DynPacket);
      PTRSendObj.DynSendList.Delete(0);
    end;
    DeleteCriticalSection(PTRSendObj.QueueLock);
    Inc(PTRMemId);
  end;

  FSendPool.Free;
end;

constructor TSendQueue.Create(MaxUser: Integer);
begin
  inherited Create;
  FMaxUser := MaxUser;
  InitMemPool;
end;

destructor TSendQueue.Destroy;
begin
  CleanupMemPool;
  inherited Destroy;
end;

procedure TSendQueue.FreeMemPoolRecvObj(const MemID: UINT; const MemBuffer: PAnsiChar);
var
  PTRCommObj: PIOCPCommObj;
begin
  PTRCommObj := PIOCPCommObj(MemBuffer);
  SHSocket.FreeSocket(PTRCommObj.Socket);
end;

function TSendQueue.FreeSendQueue(ComOBJ: PIOCPCommObj): Boolean;
begin
  SHSocket.FreeSocket(ComOBJ.Socket);

  FSendPool.LockMemPool;
  try
    Result := FSendPool.FreeMemory(ComOBJ.MemIndex);
  finally
    FSendPool.UnLockMemPool;
  end;

end;

procedure TSendQueue.FreeSocket(ComOBJ: PIOCPCommObj);
begin
  SHSocket.FreeSocket(ComOBJ.Socket);
end;

function TSendQueue.GetBuffer(ComOBJ: PIOCPCommObj): Boolean;
var
  PTRSendObj: PSendQueueNode;
  iSendLen: Integer;
  bSendData, bAddData: Boolean;
  DynPacket: pTDynPacket;
  pInBuffer: PChar;
  nSize: Integer;
begin
  bAddData := False;
  bSendData := False;
  Result := False;
  PTRSendObj := PSendQueueNode(ComOBJ);
  with PTRSendObj^ do
  begin
    EnterCriticalSection(QueueLock);
    try
      if InSend then
      begin
        iSendLen := BufRPos - LeftLen - SendLen;
        if iSendLen > 0 then
        begin
          Inc(LeftLen, SendLen);
          Inc(SPBuffer, SendLen);
          if iSendLen > SEND_BLOCK_LEN then
            iSendLen := SEND_BLOCK_LEN;
          CommObj.WBuf.Buf := SPBuffer;
          CommObj.WBuf.Len := iSendLen;
          SendLen := iSendLen;
          bSendData := True;
        end
        else
        begin
          if BufLPos > 0 then
          begin
            BufRPos := BufLPos;
            LeftLen := 0;
            RightLen := SEND_BUFFER_LEN - BufRPos;
            SendLen := BufRPos;
            if SendLen > SEND_BLOCK_LEN then
              SendLen := SEND_BLOCK_LEN;
            CommObj.WBuf.Len := SendLen;
            CommObj.WBuf.Buf := BPBuffer;
            SPBuffer := BPBuffer;
            DPBuffer := PChar(Integer(BPBuffer) + BufRPos);
            BufLPos := 0;
            bSendData := True;
          end
          else
          begin
            Result := True;
            DPBuffer := BPBuffer;
            SPBuffer := BPBuffer;
            LeftLen := 0;
            BufRPos := 0;
            SendLen := 0;
            BufLPos := 0;
            RightLen := SEND_BUFFER_LEN;
            InSend := False;

            //如果动态列表有数据，加入继续发送
            DynPacket := GetDynPacket(ComOBJ);
            if DynPacket <> nil then
            begin
              nSize := DynPacket.Len;
              GetMem(pInBuffer, nSize);
              Move(DynPacket.Buf^, pInBuffer^, nSize);
              bAddData := True;

              FreeMem(DynPacket.Buf);
              Dispose(DynPacket);
              DynSendList.Delete(0);
            end;

          end;
        end;
      end;
    finally
      LeaveCriticalSection(QueueLock);
    end;
  end;
  if bSendData then
  begin
    Result := PostIOCPSend(ComOBJ);
  end
  else if bAddData then
  begin
    //这时候缓冲区为空
    Result := AddBuffer2(ComOBJ, pInBuffer, nSize);
    FreeMem(pInBuffer);
  end;
end;

function TSendQueue.GetSendQueue(InCommObj: PIOCPCommObj): PIOCPCommObj;
var
  MemID: UINT;
  PTRSendObj: PSendQueueNode;
begin
  FSendPool.LockMemPool;
  try
    PTRSendObj := FSendPool.GetMemory(MemID);
  finally
    FSendPool.UnLockMemPool;
  end;
  if (MemID > 0) then
  begin
    Result := @PTRSendObj.CommObj;
    with PTRSendObj^ do
    begin
      CommObj.MemIndex := MemID;
      //设置基础缓冲区和数据缓冲区地址
      DPBuffer := BPBuffer;
      SPBuffer := BPBuffer;
      LeftLen := 0;
      BufRPos := 0;
      BufLPos := 0;
      SendLen := 0;
      InSend := False;
      RightLen := SEND_BUFFER_LEN;
    end
  end
  else
    Result := nil;
end;

procedure TSendQueue.InitMemPool;
var
  i: Integer;
  PTRSendObj: PSendQueueNode;
  PTRMemId: PMemNode;
begin
  FSendPool := TMemPool.Create(FMaxUser, SizeOf(TSendQueueNode));
  PTRMemId := FSendPool.MemoryIDHeader;

  for i := 0 to FSendPool.RealBlockCount - 1 do
  begin
    PTRSendObj := PSendQueueNode(PTRMemId.MemBuffer);
    PTRSendObj.BPBuffer := @PTRSendObj.Buffer;
    PTRSendObj.CommObj.WorkType := SOCKET_SEND;
    PTRSendObj.CommObj.Socket := INVALID_SOCKET;
    PTRSendObj.DynSendList := Classes.TList.Create;
    InitializeCriticalSection(PTRSendObj.QueueLock);
    PTRMemId := PTRMemId.NextNode;
  end;

  FSendPool.OnDestroyEvent := FreeMemPoolRecvObj;

end;

end.
