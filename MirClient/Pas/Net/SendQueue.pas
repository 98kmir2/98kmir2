unit SendQueue;

interface

uses
  Windows, SysUtils, IOCPTypeDef, MemPool, sharevar;

const
  SEND_BUFFER_LEN           = 48 * 1024; //发送缓冲区的长度  //0824
  SEND_BLOCK_LEN            = 08 * 1024; //每次发送的包长度  //0824

  //AddBuffer的返回值错误 类型
  ADD_BUFFER_TO_QUEUE_OK    = $00000000; //加入成功
  ADD_BUFFER_TO_QUEUE_DEATH_USER = $00000001; //该用户已经删除
  ADD_BUFFER_TO_QUEUE_FULL_BUFFRE = $00000002; //该用户的缓冲区已经满了，可能对方死机了
  ADD_BUFFER_TO_QUEUE_OTHER_ERROR = $00000003; //其他错误
  ADD_BUFFER_TO_QUEUE_SEND_ERROR = $00000004; //发送数据出错

type

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
    SendLen: Integer;                   //发送中的长度
    DPBuffer: PAnsiChar;                //拷贝数据的开始地址，减少计算
    SPBuffer: PAnsiChar;                //发送缓冲的头地址
    BPBuffer: PAnsiChar;                //头地址@buffer
    Buffer: array[0..SEND_BUFFER_LEN + 63] of Char;
  end;
  TSendQueueNode = _tagSendQueueNode;

  ESendQueue = class(Exception);

  TSendQueue = class
  private
    FSendPool: TMemPool;
    //FPollSendQueueNode: PSendQueueNode;
    FMaxUser: Integer;
  protected
    procedure InitMemPool;
    procedure FreeMemPoolRecvObj(const MemID: UINT; const MemBuffer: PAnsiChar);
    procedure cleanupMemPool;
  public
    property MemPool: TMemPool read FSendPool;
    procedure FreeSocket(ComOBJ: PIOCPCommObj);

    //分配一个发送缓冲队列返回为该sendqueue的ID
    //如果分配失败则返回0
    function GetSendQueue(InCommObj: PIOCPCommObj): PIOCPCommObj;
    //释放一个发送缓冲队列，如果释放失败返回为false否则返回true
    function FreeSendQueue(ComOBJ: PIOCPCommObj): Boolean;

    //需要内联的函数
    //是不是正确的sendqueue ID
    //function IsRightID(ComOBJ: PIOCPCommObj): Boolean;
    //该发送队列是不是无效的也就是socket缓冲满了的ID
    //function IsDeathID(ComOBJ: PIOCPCommObj): Boolean;

    //根据ID从对应的发送缓冲中得到清除大小的内存
    //由于该缓冲内的数据已拷贝到了SOCKET缓冲区
    function GetBuffer(ComOBJ: PIOCPCommObj): Boolean;

    //向编号ID的 sendqueue中加入size大小的地址为buffer的内存
    function AddBuffer(ComOBJ: PIOCPCommObj; const InBuffer: PChar; const size: Integer): Integer;

    constructor Create(MaxUser: Integer);
    destructor Destroy; override;
  end;

implementation

uses
  SHSocket, AcceptExWorkedThread, WinSock2, main;

{ TSendQueue }

function TSendQueue.AddBuffer(ComOBJ: PIOCPCommObj; const InBuffer: PChar; const size: Integer): Integer;
var
  PTRSendObj                : PSendQueueNode;
  iSendLen                  : Integer;
  bSend                     : Boolean;
begin
  PTRSendObj := PSendQueueNode(ComOBJ);
  Result := ADD_BUFFER_TO_QUEUE_OK;
  bSend := False;
  with PTRSendObj^ do begin
    EnterCriticalSection(QueueLock);
    try
      {两边空闲区域都放不下新入的数据
      |<-----------------------------Size---------------------------------------->|
      |<-------------------LeftLen----------------->||||||||||||||||||<-RightLen->|
      |<----------------------------BufRPos------------------------->|
      |<||||||||BufLPos|||||||||>|                  |<-InSendLen->|}

      //要设置好DPBuffer的值
      if BufLPos = 0 then begin
        if RightLen >= size then begin  //这个时候数据放在右边
          Move(InBuffer^, DPBuffer^, size); //DPBuffer是目标地址
          Dec(RightLen, size);
          Inc(BufRPos, size);
          Inc(DPBuffer, size);
        end else if LeftLen >= size then begin //把数据放在左边
          Move(InBuffer^, BPBuffer^, size);
          DPBuffer := PChar(Integer(BPBuffer) + size);
          BufLPos := size;
        end else begin                  //drop the packet, not to kick the user. by blue
          //Result := ADD_BUFFER_TO_QUEUE_FULL_BUFFRE;
          //MainOutMessage('ADD_BUFFER_TO_QUEUE_FULL_BUFFRE (BufLPos = 0)', 0);
          //Exit;
        end;
      end else begin                    //数据只能放左边
        {
         |<-----------------------------Size---------------------------------------->|
         |<-------------------LeftLen----------------->||||||||||||||||||<-RightLen->|
         |<----------------------------BufRPos------------------------->|
         |<||||||||BufLPos|||||||||>|                  |<-InSendLen->|
         }
        if (LeftLen - BufLPos) >= size then begin
          Move(InBuffer^, DPBuffer^, size);
          Inc(BufLPos, size);
          Inc(DPBuffer, size);
        end else begin                  //drop the packet, not to kick the user. by blue
          //Result := ADD_BUFFER_TO_QUEUE_FULL_BUFFRE;
          //MainOutMessage('ADD_BUFFER_TO_QUEUE_FULL_BUFFRE (BufLPos <> 0)', 0);
          //Exit;
        end;
      end;

      //两边空闲区域都放不下新入的数据,如果发送操作已经停止,开始投递下一个重叠I/O发送请求
      if not InSend then begin
        iSendLen := BufRPos - LeftLen;
        if iSendLen > 0 then begin
          if iSendLen > SEND_BLOCK_LEN then
            iSendLen := SEND_BLOCK_LEN;
          CommObj.WBuf.Buf := PChar(Integer(BPBuffer) + LeftLen);
          CommObj.WBuf.Len := iSendLen;
          SPBuffer := CommObj.WBuf.Buf;
          SendLen := CommObj.WBuf.Len;
          InSend := True;
          bSend := True;
        end else begin
          {
          |<-----------------------------Size---------------------------------------->|
          |<-------------------LeftLen----------------->||||||||||||||||||<-RightLen->|
          |<----------------------------BufRPos------------------------->|
          |<||||||||BufLPos|||||||||>|                  |<-InSendLen->|
          }
          if BufLPos > 0 then begin
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
            bSend := True;
          end;
        end;
      end;
    finally
      LeaveCriticalSection(QueueLock);
    end;
  end;

  if bSend then
    if not PostIOCPSend(ComOBJ) then
      Result := ADD_BUFFER_TO_QUEUE_SEND_ERROR;

{$IFDEF _SHDEBUG}
  if Result = ADD_BUFFER_TO_QUEUE_FULL_BUFFRE then begin
    with PTRSendObj^ do
      MainOutMessage(Format('BufLPos:%d, BufRPos:%d,LeftLen:%d,RightLen:%d,SendLen:%d,Size:%d', [BufLPos, BufRPos, LeftLen, RightLen, SendLen, size]), 8);
    //RGFrm.Errlog(Format('BufLPos:%d, BufRPos:%d,LeftLen:%d,RightLen:%d,SendLen:%d,Size:%d', [BufLPos, BufRPos, LeftLen, RightLen, SendLen, size]));
  end;
{$ENDIF}
end;

procedure TSendQueue.cleanupMemPool;
var
  i                         : Integer;
  PTRSendObj                : PSendQueueNode;
  PTRMemId                  : PMemNode;
begin
  PTRMemId := FSendPool.MemoryIDHeader;

  for i := 0 to FSendPool.RealBlockCount - 1 do begin
    PTRSendObj := PSendQueueNode(PTRMemId.MemBuffer);
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
  cleanupMemPool;
  inherited Destroy;
end;

procedure TSendQueue.FreeMemPoolRecvObj(const MemID: UINT; const MemBuffer: PAnsiChar);
var
  PTRCommObj                : PIOCPCommObj;
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
  PTRSendObj                : PSendQueueNode;
  iSendLen                  : Integer;
  bSendData                 : Boolean;
begin
  bSendData := False;
  Result := False;
  PTRSendObj := PSendQueueNode(ComOBJ);
  with PTRSendObj^ do begin
    EnterCriticalSection(QueueLock);
    try
      {
       |<-----------------------------Size---------------------------------------->|
       |<-------------------LeftLen----------------->||||||||||||||||||<-RightLen->|
       |<----------------------------BufRPos------------------------->|
       |<||||||||BufLPos|||||||||>|                  |<-SendLen->|
       }
      if PTRSendObj.InSend then begin
        //判断剩下的数据
        iSendLen := BufRPos - LeftLen - SendLen;
        //如果还有数据需要发送
        if iSendLen > 0 then begin
          Inc(LeftLen, SendLen);
          Inc(SPBuffer, SendLen);
          if iSendLen > SEND_BLOCK_LEN then
            iSendLen := SEND_BLOCK_LEN;
          CommObj.WBuf.Buf := SPBuffer;
          CommObj.WBuf.Len := iSendLen;
          SendLen := iSendLen;
          bSendData := True;
        end else begin

          //发送左边缓冲区的数据
          {
          |<-----------------------------Size---------------------------------------->|
          |<-------------------LeftLen----------------->||||||||||||||||||<-RightLen->|
          |<----------------------------BufRPos------------------------->|
          |<||||||||BufLPos|||||||||>|                  |<-SendLen->|
          }

          if BufLPos > 0 then begin
            //先清空右边的标记
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
          end else begin
            Result := True;
            DPBuffer := BPBuffer;
            SPBuffer := BPBuffer;
            LeftLen := 0;
            BufRPos := 0;
            SendLen := 0;
            BufLPos := 0;
            RightLen := SEND_BUFFER_LEN;
            InSend := False;
          end;
        end;
      end;
    finally
      LeaveCriticalSection(QueueLock);
    end;
  end;
  if bSendData then
    Result := PostIOCPSend(ComOBJ);
end;

function TSendQueue.GetSendQueue(InCommObj: PIOCPCommObj): PIOCPCommObj;
var
  MemID                     : UINT;
  PTRSendObj                : PSendQueueNode;
begin
  FSendPool.LockMemPool;
  try
    PTRSendObj := FSendPool.GetMemory(MemID);
  finally
    FSendPool.UnLockMemPool;
  end;
  if (MemID > 0) then begin
    Result := @PTRSendObj.CommObj;
    with PTRSendObj^ do begin
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
  end else
    Result := nil;
end;

procedure TSendQueue.InitMemPool;
var
  i                         : Integer;
  PTRSendObj                : PSendQueueNode;
  PTRMemId                  : PMemNode;
begin
  FSendPool := TMemPool.Create(FMaxUser, SizeOf(TSendQueueNode));
  PTRMemId := FSendPool.MemoryIDHeader;

  for i := 0 to FSendPool.RealBlockCount - 1 do begin
    PTRSendObj := PSendQueueNode(PTRMemId.MemBuffer);
    PTRSendObj.BPBuffer := @PTRSendObj.Buffer;
    PTRSendObj.CommObj.WorkType := SOCKET_SEND;
    PTRSendObj.CommObj.Socket := INVALID_SOCKET;
    InitializeCriticalSection(PTRSendObj.QueueLock);

    PTRMemId := PTRMemId.NextNode;
  end;

  FSendPool.OnDestroyEvent := FreeMemPoolRecvObj;

end;

end.

