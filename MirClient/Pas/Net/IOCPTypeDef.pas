unit IOCPTypeDef;

interface

uses
  Windows, SysUtils, WinSock2, Messages;

const
  SOCKET_READ               = $00000001; //接受数据
  SOCKET_SEND               = $00000002; //发送数据
  SOCKET_ACCEPT             = $00000003; //接受连接

  MAX_GAME_USER             = 1000;     //2000;     //最大并发登陆用户数目    //0401
  MAX_LOGIN_USER            = 1024;     //2048;     //最大的ACCEPTEX结构数目
  USER_ARRAY_COUNT          = 1024;     //2048;     //最大用户数目

  MAX_GAME_SERVER_COUNT     = 6;
  MAX_GAME_SERVICE_COUNT    = 12;
  
  BIND_MAX_COUNT            = 100;
  MAX_WORK_THREAD           = 32;
  MAX_SERVER_COUNT          = 32;

type
  PIOCPCommObj = ^_tagIOCPCommObj;      //通用的完成端口结构数据
  _tagIOCPCommObj = record
    PTRIOKey: WSAOVERLAPPED;            //重叠结构地址
    Socket: TSocket;
    WorkType: DWORD;                    //工作状况
    PostTime: DWORD;                    //发送时间
    WBuf: WSABUF;                       //缓冲结构
    AddObject: Pointer;                 //类结构
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
        Errlog(Format('PostRecv出错,错误代码为：%d', [iRc]));
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
    //FillChar的效率太低
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
        Errlog(Format('PostSend出错,错误代码为：%d', [iRc]));
{$ENDIF}
      end;
    end;
  end;
end;

end.

