unit SendQueue;

interface

uses
  Windows, SysUtils, IOCPTypeDef, MemPool, sharevar;

const
  SEND_BUFFER_LEN           = 48 * 1024; //���ͻ������ĳ���  //0824
  SEND_BLOCK_LEN            = 08 * 1024; //ÿ�η��͵İ�����  //0824

  //AddBuffer�ķ���ֵ���� ����
  ADD_BUFFER_TO_QUEUE_OK    = $00000000; //����ɹ�
  ADD_BUFFER_TO_QUEUE_DEATH_USER = $00000001; //���û��Ѿ�ɾ��
  ADD_BUFFER_TO_QUEUE_FULL_BUFFRE = $00000002; //���û��Ļ������Ѿ����ˣ����ܶԷ�������
  ADD_BUFFER_TO_QUEUE_OTHER_ERROR = $00000003; //��������
  ADD_BUFFER_TO_QUEUE_SEND_ERROR = $00000004; //�������ݳ���

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
    SendLen: Integer;                   //�����еĳ���
    DPBuffer: PAnsiChar;                //�������ݵĿ�ʼ��ַ�����ټ���
    SPBuffer: PAnsiChar;                //���ͻ����ͷ��ַ
    BPBuffer: PAnsiChar;                //ͷ��ַ@buffer
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

    //����һ�����ͻ�����з���Ϊ��sendqueue��ID
    //�������ʧ���򷵻�0
    function GetSendQueue(InCommObj: PIOCPCommObj): PIOCPCommObj;
    //�ͷ�һ�����ͻ�����У�����ͷ�ʧ�ܷ���Ϊfalse���򷵻�true
    function FreeSendQueue(ComOBJ: PIOCPCommObj): Boolean;

    //��Ҫ�����ĺ���
    //�ǲ�����ȷ��sendqueue ID
    //function IsRightID(ComOBJ: PIOCPCommObj): Boolean;
    //�÷��Ͷ����ǲ�����Ч��Ҳ����socket�������˵�ID
    //function IsDeathID(ComOBJ: PIOCPCommObj): Boolean;

    //����ID�Ӷ�Ӧ�ķ��ͻ����еõ������С���ڴ�
    //���ڸû����ڵ������ѿ�������SOCKET������
    function GetBuffer(ComOBJ: PIOCPCommObj): Boolean;

    //����ID�� sendqueue�м���size��С�ĵ�ַΪbuffer���ڴ�
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
      {���߿������򶼷Ų������������
      |<-----------------------------Size---------------------------------------->|
      |<-------------------LeftLen----------------->||||||||||||||||||<-RightLen->|
      |<----------------------------BufRPos------------------------->|
      |<||||||||BufLPos|||||||||>|                  |<-InSendLen->|}

      //Ҫ���ú�DPBuffer��ֵ
      if BufLPos = 0 then begin
        if RightLen >= size then begin  //���ʱ�����ݷ����ұ�
          Move(InBuffer^, DPBuffer^, size); //DPBuffer��Ŀ���ַ
          Dec(RightLen, size);
          Inc(BufRPos, size);
          Inc(DPBuffer, size);
        end else if LeftLen >= size then begin //�����ݷ������
          Move(InBuffer^, BPBuffer^, size);
          DPBuffer := PChar(Integer(BPBuffer) + size);
          BufLPos := size;
        end else begin                  //drop the packet, not to kick the user. by blue
          //Result := ADD_BUFFER_TO_QUEUE_FULL_BUFFRE;
          //MainOutMessage('ADD_BUFFER_TO_QUEUE_FULL_BUFFRE (BufLPos = 0)', 0);
          //Exit;
        end;
      end else begin                    //����ֻ�ܷ����
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

      //���߿������򶼷Ų������������,������Ͳ����Ѿ�ֹͣ,��ʼͶ����һ���ص�I/O��������
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
        //�ж�ʣ�µ�����
        iSendLen := BufRPos - LeftLen - SendLen;
        //�������������Ҫ����
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

          //������߻�����������
          {
          |<-----------------------------Size---------------------------------------->|
          |<-------------------LeftLen----------------->||||||||||||||||||<-RightLen->|
          |<----------------------------BufRPos------------------------->|
          |<||||||||BufLPos|||||||||>|                  |<-SendLen->|
          }

          if BufLPos > 0 then begin
            //������ұߵı��
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
      //���û��������������ݻ�������ַ
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

