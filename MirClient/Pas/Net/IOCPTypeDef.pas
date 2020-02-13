unit IOCPTypeDef;

interface

uses
  Windows, SysUtils, WinSock2, Messages;

const
  SOCKET_READ               = $00000001; //��������
  SOCKET_SEND               = $00000002; //��������
  SOCKET_ACCEPT             = $00000003; //��������

  MAX_GAME_USER             = 1000;     //2000;     //��󲢷���½�û���Ŀ    //0401
  MAX_LOGIN_USER            = 1024;     //2048;     //����ACCEPTEX�ṹ��Ŀ
  USER_ARRAY_COUNT          = 1024;     //2048;     //����û���Ŀ

  MAX_GAME_SERVER_COUNT     = 6;
  MAX_GAME_SERVICE_COUNT    = 12;
  
  BIND_MAX_COUNT            = 100;
  MAX_WORK_THREAD           = 32;
  MAX_SERVER_COUNT          = 32;

type
  PIOCPCommObj = ^_tagIOCPCommObj;      //ͨ�õ���ɶ˿ڽṹ����
  _tagIOCPCommObj = record
    PTRIOKey: WSAOVERLAPPED;            //�ص��ṹ��ַ
    Socket: TSocket;
    WorkType: DWORD;                    //����״��
    PostTime: DWORD;                    //����ʱ��
    WBuf: WSABUF;                       //����ṹ
    AddObject: Pointer;                 //��ṹ
    MemIndex: UINT;
    ABuffer: PChar;
    BBuffer: PChar;
  end;
  TIOCPCommObj = _tagIOCPCommObj;

function PostIOCPRecv(const PIOCPData: PIOCPCommObj): Boolean;
function PostIOCPSend(const PIOCPData: PIOCPCommObj): Boolean;

{$IFDEF SHDEBUG}
var
  hDebug                    : THANDLE;
{$ENDIF}

implementation

uses
  main;

function PostIOCPRecv(const PIOCPData: PIOCPCommObj): Boolean;
var
  iRc                       : Integer;
  dwFlags, dwSendBytes      : DWORD;
begin
  dwFlags := 0;
  with PIOCPData^ do begin
    PTRIOKey.Internal := 0;
    PTRIOKey.InternalHigh := 0;
    PTRIOKey.Offset := 0;
    PTRIOKey.OffsetHigh := 0;
    PTRIOKey.hEvent := 0;
    iRc := WSARecv(
      Socket,
      @WBuf,
      1,
      dwSendBytes,
      dwFlags,
      @PTRIOKey,
      nil);

    Result := True;
    if iRc = SOCKET_ERROR then begin
      iRc := WSAGetLastError();
      if iRc <> WSA_IO_PENDING then begin
{$IFDEF _SHDEBUG}
        Errlog(Format('PostRecv����,�������Ϊ��%d', [iRc]));
{$ENDIF}
        Result := False;
      end;
    end;
  end;
end;

function PostIOCPSend(const PIOCPData: PIOCPCommObj): Boolean;
var
  iRc                       : Integer;
  dwFlags, dwSendBytes      : DWORD;
begin
  dwFlags := 0;
  with PIOCPData^ do begin
    //FillChar��Ч��̫��
    PTRIOKey.Internal := dwFlags;
    PTRIOKey.InternalHigh := dwFlags;
    PTRIOKey.Offset := dwFlags;
    PTRIOKey.OffsetHigh := dwFlags;
    PTRIOKey.hEvent := dwFlags;
    //FillChar(PTRIOKey, SizeOf(TWSAOverlapped), 0);
    iRc := WSASend(
      Socket,
      @WBuf,
      1,
      dwSendBytes,
      dwFlags,
      @PTRIOKey,
      nil);

    Result := True;
    if iRc = SOCKET_ERROR then begin
      iRc := WSAGetLastError();
      if iRc <> WSA_IO_PENDING then begin
        Result := False;
{$IFDEF _SHDEBUG}
        Errlog(Format('PostSend����,�������Ϊ��%d', [iRc]));
{$ENDIF}
      end;
    end;
  end;
end;

end.

