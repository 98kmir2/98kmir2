unit CDClientSDK;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  Windows;

type
  pfnSendCallback = function(pBuf: Pointer; nSize: Integer; pCallbackContext: Pointer): Integer; stdcall;
  pfnNotifyCallback = function(NotifyType: Integer; NotifyData: Integer; pCallbackContext: Pointer): Integer; stdcall;

const
  CD_CLIENT_NOTIFY_TYPE_AUTHMODULE_INIT_FAILED = 0;
  CD_CLIENT_NOTIFY_TYPE_SERVER_PACKET_ERROR = 1;

{$IFDEF CD}
  CDClientDLL = 'CDClient.DLL';

function CDClientInit(): LongBool; stdcall; external CDClientDLL index 1;

function CDClientSetSendCallback(fnSendCallback: pfnSendCallback; pCallbackContext: Pointer = nil): LongBool; stdcall; external CDClientDLL index 2;

function CDClientSetNotifyCallback(fnNotifyCallback: pfnNotifyCallback; pCallbackContext: Pointer = nil): LongBool; stdcall; external CDClientDLL index 3;

function CDClientGetMaxEncryptedSize(pBuf: Pointer; nSize: Integer): Integer; stdcall; external CDClientDLL index 4;

function CDClientPacketEncrypt(pSrcBuf: Pointer; nSize: Integer; pDstBuf: Pointer; pActualSize: PInteger; bAllowCallbacks: LongBool = True): LongBool; stdcall; external CDClientDLL index 5;

function CDClientGetMaxDecryptedSize(pBuf: Pointer; nSize: Integer): Integer; stdcall; external CDClientDLL index 6;

function CDClientPacketDecrypt(pSrcBuf: Pointer; nSize: Integer; pDstBuf: Pointer; pActualSize: PInteger; bAllowCallbacks: LongBool = True): LongBool; stdcall; external CDClientDLL index 7;

function CDClientFree(): LongBool; stdcall; external CDClientDLL index 8;

procedure CDClientAcquireLock(); stdcall; external CDClientDLL index 9;

procedure CDClientReleaseLock(); stdcall; external CDClientDLL index 10;
{$ENDIF}

implementation

end.
