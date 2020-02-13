unit CDServerSDK;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  Windows;

type
  pfnSendCallback = function(pBuf: Pointer; nSize: Integer; pUserContext: Pointer; pCallbackContext: Pointer): Integer; stdcall;
  pfnNotifyCallback = function(NotifyType: Integer; NotifyData: Integer; pUserContext: Pointer; pCallbackContext: Pointer): Integer; stdcall;

const
  CD_SERVER_NOTIFY_TYPE_AUTHMODULE_UNLOAD_DONE = 0;
  CD_SERVER_NOTIFY_TYPE_AUTHMODULE_ALREADY_LOADED = 1;
  CD_SERVER_NOTIFY_TYPE_AUTHMODULE_LOAD_FAILED = 2;
  CD_SERVER_NOTIFY_TYPE_CLIENT_CRC_FAILED = 3;
  CD_SERVER_NOTIFY_TYPE_MULTI_CLIENT_EXCEEDED = 4;
  CD_SERVER_NOTIFY_TYPE_CLIENT_PACKET_ERROR = 5;
  CD_SERVER_NOTIFY_TYPE_CLIENT_REQUEST_TIMEOUT = 6;
  CD_SERVER_NOTIFY_TYPE_CLIENT_HWID = 7;
  CD_SERVER_NOTIFY_TYPE_CLIENT_STATUS = 8;
  CD_SERVER_NOTIFY_TYPE_EXPIRE_DATE = 9;

  CDServerDLL = 'CDServer.DLL';

function CDServerInit(): LongBool; stdcall; external CDServerDLL index 1;

function CDServerSetSendCallback(fnSendCallback: pfnSendCallback; pCallbackContext: Pointer = nil): LongBool; stdcall; external CDServerDLL index 2;

function CDServerSetNotifyCallback(fnNotifyCallback: pfnNotifyCallback; pCallbackContext: Pointer = nil): LongBool; stdcall; external CDServerDLL index 3;

function CDServerGetMaxEncryptedSize(pBuf: Pointer; nSize: Integer; pUserContext: Pointer; bAllowCallbacks: LongBool = True): Integer; stdcall; external CDServerDLL index 4;

function CDServerPacketEncrypt(pSrcBuf: Pointer; nSize: Integer; pDstBuf: Pointer; pActualSize: PInteger; pUserContext: Pointer; bAllowCallbacks: LongBool = True): LongBool; stdcall; external CDServerDLL index 5;

function CDServerGetMaxDecryptedSize(pBuf: Pointer; nSize: Integer; pUserContext: Pointer; bAllowCallbacks: LongBool = True): Integer; stdcall; external CDServerDLL index 6;

function CDServerPacketDecrypt(pSrcBuf: Pointer; nSize: Integer; pDstBuf: Pointer; pActualSize: PInteger; pUserContext: Pointer; bAllowCallbacks: LongBool = True): LongBool; stdcall; external CDServerDLL index 7;

function CDServerAddUser(pUserContext: Pointer; bAllowCallbacks: LongBool = True): LongBool; stdcall; external CDServerDLL index 8;

function CDServerRemoveUser(pUserContext: Pointer; bAllowCallbacks: LongBool = True): LongBool; stdcall; external CDServerDLL index 9;

function CDServerTick(bAllowCallbacks: LongBool = True): LongBool; stdcall; external CDServerDLL index 10;

function CDServerAuthModuleUnload(bAllowCallbacks: LongBool = True): LongBool; stdcall; external CDServerDLL index 11;

function CDServerAuthModuleReload(bAllowCallbacks: LongBool = True): LongBool; stdcall; external CDServerDLL index 12;

function CDServerFree(): LongBool; stdcall; external CDServerDLL index 13;

procedure CDServerAcquireLock(); stdcall; external CDServerDLL index 14;

procedure CDServerReleaseLock(); stdcall; external CDServerDLL index 15;
implementation

end.
