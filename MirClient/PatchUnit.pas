unit PatchUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, D7ScktComp, StdCtrls, Grobal2, CnCRC32, VCLUnZip, Wil;

const
  PM_INDEX = 1;
  PM_DATA = 2;
  PM_CRC = 3;
  PM_WAV = 4;
  PM_MAP = 5;

type
  TImageIdx = packed record
    dwFileCRC: DWORD;
    WMImages: TWMImages;
  end;
  pTImageIdx = ^TImageIdx;

  TPatchData = packed record
    tHdr: TMsgHeader;
    Data: Pointer;
    dwDelay: LongWord;
    szFileName: string;
  end;
  pTPatchData = ^TPatchData;

  TPatchClient = class;

  TPatchClientManager = class
    m_nLastIndex: Integer;
    m_xWMImageList: TStringList;
    m_xObjectList: TStringList;
  public
    constructor Create();
    destructor Destroy; override;

    function AddClientSocket(PatchClient: TPatchClient): Integer; overload;
    function AddClientSocket(szIP: string; wPort: Word): Integer; overload;
    function DelObject(PatchClient: TPatchClient): Integer;

    procedure AssignedWMImages(szFileNameEx: string; WMImages: TWMImages);
    procedure SendProcMsg(xObject: TObject; szFileName: string; nCmd, nIndex: Integer; dwDelay: LongWord = 0; pszData: PChar = nil; nDataLen: Integer = 0);

    procedure ExecSendBuffer();
    procedure ExecRecvBuffer();
  end;

  TPatchClient = class
    m_fFirstGetCrc: Boolean;
    m_fGetCrcErr: Boolean;
    m_nSvrWzlFileList: TStringList;
    m_nSvrWavFileList: TStringList;
    m_nSvrMapFileList: TStringList;

    m_SendLock: TRTLCriticalSection;
    m_RecvLock: TRTLCriticalSection;
    m_FileLock: TRTLCriticalSection;

    m_xProcSendList: TList;
    m_xTempProcSendList: TList;

    m_pRecvBuffer: PChar;
    m_nRecvBuffLen: Integer;
    m_xProcRecvList: TList;

    m_Unzip: TVCLUnZip;
    m_dwReConnecTick: LongWord;
    m_ClientSocket: TClientSocket;

    m_PatchClientManager: TPatchClientManager;
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);

    procedure ExecSendBuffer();
    procedure ExecRecvBuffer();
    procedure ProcRecvBuffer(pszBuffer: PChar; nRecvLen: Integer);
    procedure AddProcRecvMsg(pMsgHeader: pTMsgHeader; pszMsgBuff: PChar);
  public
    constructor Create(Manager: TPatchClientManager);
    destructor Destroy; override;

    procedure Lock_Send();
    procedure UnLock_Send();

    procedure Lock_Recv();
    procedure UnLock_Recv();

    procedure SendProcMsg(xObject: TObject; szFileName: string; nCmd, nIndex: Integer; dwDelay: LongWord = 0; pszData: PChar = nil; nDataLen: Integer = 0);
  end;

var
  g_PatchClientManager: TPatchClientManager;

implementation

uses
  MShare, HUtil32, MapUnit, Actor, wmUtil, clMain;

{--- TPatchClientManager ---}

constructor TPatchClientManager.Create();
begin
  m_nLastIndex := -1;
  m_xObjectList := TStringList.Create;

  m_xWMImageList := TStringList.Create;
  m_xWMImageList.CaseSensitive := False;
  m_xWMImageList.Sorted := True;
end;

destructor TPatchClientManager.Destroy;
var
  i: Integer;
  PatchClient: TPatchClient;
begin
  for i := 0 to m_xObjectList.Count - 1 do
  begin
    PatchClient := TPatchClient(m_xObjectList.Objects[i]);
    PatchClient.Free;
  end;
  m_xObjectList.Free;
end;

function TPatchClientManager.AddClientSocket(PatchClient: TPatchClient): Integer;
begin
  Result := m_xObjectList.AddObject('', PatchClient);
end;

function TPatchClientManager.AddClientSocket(szIP: string; wPort: Word): Integer;
var
  PatchClient: TPatchClient;
begin
  PatchClient := TPatchClient.Create(Self);
  if IsIPaddr(szIP) then
    PatchClient.m_ClientSocket.Address := szIP
  else
    PatchClient.m_ClientSocket.Host := szIP;
  PatchClient.m_ClientSocket.Port := wPort;
  PatchClient.m_ClientSocket.Active := True;
  PatchClient.m_dwReConnecTick := GetTickCount;
  Self.AddClientSocket(PatchClient);
end;

function TPatchClientManager.DelObject(PatchClient: TPatchClient): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := m_xObjectList.Count - 1 downto 0 do
  begin
    if PatchClient = m_xObjectList.Objects[i] then
    begin
      m_xObjectList.Delete(i);
      Result := m_xObjectList.Count;
      Break;
    end;
  end;
end;

procedure TPatchClientManager.AssignedWMImages(szFileNameEx: string; WMImages: TWMImages);
var
  i, ii: Integer;
  PatchClient: TPatchClient;
begin
  for i := m_xObjectList.Count - 1 downto 0 do
  begin
    PatchClient := TPatchClient(m_xObjectList.Objects[i]);
    if PatchClient.m_nSvrWzlFileList.Count > 0 then
    begin
      ii := PatchClient.m_nSvrWzlFileList.IndexOf(szFileNameEx);
      if ii >= 0 then
      begin
        pTImageIdx(PatchClient.m_nSvrWzlFileList.Objects[ii]).WMImages := WMImages;
      end;
    end;
  end;
end;

procedure TPatchClientManager.SendProcMsg(xObject: TObject; szFileName: string; nCmd, nIndex: Integer; dwDelay: LongWord = 0; pszData: PChar = nil; nDataLen: Integer = 0);
var
  i: Integer;
  PatchClient: TPatchClient;
begin
  if m_xObjectList.Count > 0 then
  begin
    if (m_nLastIndex < 0) or (m_nLastIndex >= m_xObjectList.Count) then
      m_nLastIndex := 0;
    PatchClient := TPatchClient(m_xObjectList.Objects[m_nLastIndex]);

    i := 0;
    while True do
    begin
      if not PatchClient.m_fFirstGetCrc or PatchClient.m_ClientSocket.Socket.Connected then
        Break;
      Inc(m_nLastIndex);
      if m_nLastIndex >= m_xObjectList.Count then
        m_nLastIndex := 0;
      PatchClient := TPatchClient(m_xObjectList.Objects[m_nLastIndex]);
      Inc(i);
      if i >= m_xObjectList.Count then
        Break;
    end;

    Inc(m_nLastIndex);
    PatchClient.SendProcMsg(xObject, szFileName, nCmd, nIndex, dwDelay, pszData, nDataLen);
  end;
end;

procedure TPatchClientManager.ExecSendBuffer();
var
  i: Integer;
  PatchClient: TPatchClient;
begin
  if m_xObjectList.Count > 0 then
  begin
    for i := 0 to m_xObjectList.Count - 1 do
    begin
      PatchClient := TPatchClient(m_xObjectList.Objects[i]);
      PatchClient.ExecSendBuffer;
      //Application.ProcessMessages;
    end;
  end;
end;

procedure TPatchClientManager.ExecRecvBuffer();
var
  i: Integer;
  PatchClient: TPatchClient;
begin
  if m_xObjectList.Count > 0 then
  begin
    for i := 0 to m_xObjectList.Count - 1 do
    begin
      PatchClient := TPatchClient(m_xObjectList.Objects[i]);
      PatchClient.ExecRecvBuffer;
      //Application.ProcessMessages;
    end;
  end;
end;

{--- TPatchClient ---}

constructor TPatchClient.Create(Manager: TPatchClientManager);
begin
  inherited Create();
  m_PatchClientManager := Manager;

  m_fFirstGetCrc := False;
  m_fGetCrcErr := False;
  m_nSvrWzlFileList := TStringList.Create;
  m_nSvrWzlFileList.CaseSensitive := False;
  m_nSvrWzlFileList.Sorted := True;

  m_nSvrWavFileList := TStringList.Create;
  m_nSvrWavFileList.CaseSensitive := False;
  m_nSvrWavFileList.Sorted := True;

  m_nSvrMapFileList := TStringList.Create;
  m_nSvrMapFileList.CaseSensitive := False;
  m_nSvrMapFileList.Sorted := True;

  InitializeCriticalSection(m_SendLock);
  InitializeCriticalSection(m_RecvLock);
  InitializeCriticalSection(m_FileLock);

  m_pRecvBuffer := nil;
  m_nRecvBuffLen := 0;
  m_xProcSendList := TList.Create;
  m_xTempProcSendList := TList.Create;
  m_xProcRecvList := TList.Create;

  m_Unzip := TVCLUnZip.Create(nil);

  m_ClientSocket := TClientSocket.Create(nil);
  m_ClientSocket.OnConnect := ClientSocketConnect;
  m_ClientSocket.OnDisconnect := ClientSocketDisconnect;
  m_ClientSocket.OnError := ClientSocketError;
  m_ClientSocket.OnRead := ClientSocketRead;

  if not DirectoryExists('.\Data\') then
    ForceDirectories('.\Data\');
  if not DirectoryExists('.\Wav\') then
    ForceDirectories('.\Wav\');
  if not DirectoryExists('.\Map\') then
    ForceDirectories('.\Map\');
end;

destructor TPatchClient.Destroy;
var
  i: Integer;
begin
  for i := 0 to m_xProcRecvList.Count - 1 do
  begin
    if pTPatchData(m_xProcRecvList[i]).Data <> nil then
      FreeMem(pTPatchData(m_xProcRecvList[i]).Data);
    Dispose(pTPatchData(m_xProcRecvList[i]));
  end;
  m_xProcRecvList.Free;

  for i := 0 to m_xProcSendList.Count - 1 do
  begin
    if pTPatchData(m_xProcSendList[i]).Data <> nil then
      FreeMem(pTPatchData(m_xProcSendList[i]).Data);
    Dispose(pTPatchData(m_xProcSendList[i]));
  end;
  m_xProcSendList.Free;

  for i := 0 to m_xTempProcSendList.Count - 1 do
  begin
    if pTPatchData(m_xTempProcSendList[i]).Data <> nil then
      FreeMem(pTPatchData(m_xTempProcSendList[i]).Data);
    Dispose(pTPatchData(m_xTempProcSendList[i]));
  end;
  m_xTempProcSendList.Free;

  m_ClientSocket.Free;

  DeleteCriticalSection(m_SendLock);
  DeleteCriticalSection(m_RecvLock);
  DeleteCriticalSection(m_FileLock);

  m_nSvrWzlFileList.Free;
  m_nSvrWavFileList.Free;
  m_nSvrMapFileList.Free;
  m_Unzip.Free;
  inherited;
end;

procedure TPatchClient.Lock_Send();
begin
  EnterCriticalSection(m_SendLock);
end;

procedure TPatchClient.UnLock_Send();
begin
  LeaveCriticalSection(m_SendLock);
end;

procedure TPatchClient.Lock_Recv();
begin
  EnterCriticalSection(m_RecvLock);
end;

procedure TPatchClient.UnLock_Recv();
begin
  LeaveCriticalSection(m_RecvLock);
end;

procedure TPatchClient.SendProcMsg(xObject: TObject; szFileName: string; nCmd, nIndex: Integer; dwDelay: LongWord = 0; pszData: PChar = nil; nDataLen: Integer = 0);
var
  i: Integer;
  dwFileCRC: DWORD;
  pPatchData: pTPatchData;
begin
  if m_fGetCrcErr then
    Exit;

  if (szFileName <> '') and (nIndex >= 0) then
  begin
    szFileName := ExtractFileName(szFileName);
    szFileName := ChangeFileExt(szFileName, '');
  end;

  if not m_fFirstGetCrc then
  begin
    New(pPatchData);
    pPatchData.tHdr.dwCode := MAGICCODE;
    pPatchData.tHdr.nSocket := 0;
    pPatchData.tHdr.wGSocketIdx := MAGICWORD;
    pPatchData.tHdr.wIdent := nCmd;
    pPatchData.tHdr.wUserListIndex := nIndex;
    pPatchData.tHdr.nLength := nDataLen;
    if dwDelay > 0 then
      pPatchData.dwDelay := GetTickCount + dwDelay
    else
      pPatchData.dwDelay := GetTickCount;
    pPatchData.Data := nil;
    pPatchData.szFileName := szFileName;
    if (pPatchData.tHdr.nLength > 0) and (pszData <> nil) then
    begin
      GetMem(pPatchData.Data, pPatchData.tHdr.nLength);
      Move(pszData^, pPatchData.Data^, pPatchData.tHdr.nLength);
    end;
    Lock_Send();
    try
      m_xTempProcSendList.Add(pPatchData);
    finally
      UnLock_Send();
    end;
    Exit;
  end;

{$I '..\Common\Macros\VMPBM.inc'}
  dwFileCRC := 0;
  if szFileName <> '' then
  begin //请求wzl相关
    case nCmd of
      PM_INDEX, PM_DATA:
        begin
          if m_nSvrWzlFileList.Count = 0 then
            Exit;
          i := m_nSvrWzlFileList.IndexOf(szFileName);
          if i >= 0 then
            dwFileCRC := pTImageIdx(m_nSvrWzlFileList.Objects[i]).dwFileCRC;
          if dwFileCRC = 0 then
            Exit;
        end;
      PM_WAV:
        begin
          if m_nSvrWavFileList.Count = 0 then
            Exit;
          i := m_nSvrWavFileList.IndexOf(szFileName);
          if i >= 0 then
            dwFileCRC := pTImageIdx(m_nSvrWavFileList.Objects[i]).dwFileCRC;
          if dwFileCRC = 0 then
            Exit;
        end;
      PM_MAP:
        begin
          if m_nSvrMapFileList.Count = 0 then
            Exit;
          i := m_nSvrMapFileList.IndexOf(szFileName);
          if i >= 0 then
            dwFileCRC := pTImageIdx(m_nSvrMapFileList.Objects[i]).dwFileCRC;
          if dwFileCRC = 0 then
            Exit;
        end;
    end;
  end
  else
  begin
    case nCmd of
      PM_CRC:
        begin
          dwFileCRC := DWORD(xObject);
        end;
    end;
  end;
{$I '..\Common\Macros\VMPE.inc'}

  New(pPatchData);
  pPatchData.tHdr.dwCode := MAGICCODE;
  pPatchData.tHdr.nSocket := dwFileCRC;
  pPatchData.tHdr.wGSocketIdx := MAGICWORD;
  pPatchData.tHdr.wIdent := nCmd;
  pPatchData.tHdr.wUserListIndex := nIndex;
  pPatchData.tHdr.nLength := nDataLen;
  if dwDelay > 0 then
    pPatchData.dwDelay := GetTickCount + dwDelay
  else
    pPatchData.dwDelay := 0;
  pPatchData.Data := nil;
  pPatchData.szFileName := '';
  if (pPatchData.tHdr.nLength > 0) and (pszData <> nil) then
  begin
    GetMem(pPatchData.Data, pPatchData.tHdr.nLength);
    Move(pszData^, pPatchData.Data^, pPatchData.tHdr.nLength);
  end;
  Lock_Send();
  try
    m_xProcSendList.Add(pPatchData);
  finally
    UnLock_Send();
  end;
end;

procedure TPatchClient.ExecSendBuffer();
var
  i, ii: Integer;
  dwFileCRC: DWORD;
  fGetMsg: Boolean;
  pszBuff: PChar;
  nBuffLen: Integer;
  nSendMsgCount: Integer;
  PatchData: TPatchData;
  pPatchData: pTPatchData;
begin
  if not m_ClientSocket.Socket.Connected then
  begin
    Lock_Send();
    try
      nSendMsgCount := m_xTempProcSendList.Count;
    finally
      UnLock_Send();
    end;
    if (m_nSvrWzlFileList.Count > 0) or (m_nSvrWavFileList.Count > 0) or (m_nSvrMapFileList.Count > 0) then
    begin
      if GetTickCount - m_dwReConnecTick > 3 * 1000 then
      begin
        m_dwReConnecTick := GetTickCount;
        if nSendMsgCount > 0 then
          m_ClientSocket.Active := True;
      end;
    end;
  end;

  if not m_ClientSocket.Socket.Connected then
  begin
    Lock_Send();
    try
      if m_xTempProcSendList.Count > 0 then
      begin
        ii := 0;
        for i := m_xTempProcSendList.Count - 1 downto 0 do
        begin
          pPatchData := m_xTempProcSendList[i];
          if (pPatchData.dwDelay > 0) and (GetTickCount > pPatchData.dwDelay + 60 * 1000) then
          begin //超时丢掉
            if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
              FreeMem(pPatchData.Data);
            Dispose(pPatchData);
            m_xTempProcSendList.Delete(i);
            if ii > $10 then
              Break;
          end;
        end;
      end;
    finally
      UnLock_Send();
    end;
  end;

  if not m_ClientSocket.Socket.Connected or not m_fFirstGetCrc then
    Exit;

  Lock_Send();
  try
    if m_xTempProcSendList.Count > 0 then
    begin
      for i := 0 to m_xTempProcSendList.Count - 1 do
      begin
        pPatchData := m_xTempProcSendList[i];
        pPatchData.dwDelay := GetTickCount + 900;
        case pPatchData.tHdr.wIdent of
          PM_INDEX, PM_DATA:
            begin
              if pPatchData.szFileName <> '' then
              begin
                if m_nSvrWzlFileList.Count > 0 then
                begin
                  dwFileCRC := 0;
                  ii := m_nSvrWzlFileList.IndexOf(pPatchData.szFileName);
                  if ii >= 0 then
                  begin
                    dwFileCRC := pTImageIdx(m_nSvrWzlFileList.Objects[ii]).dwFileCRC;
                  end;
                  if dwFileCRC <> 0 then
                  begin
                    pPatchData.tHdr.wGSocketIdx := MAGICWORD;
                    pPatchData.tHdr.nSocket := dwFileCRC;
                    pPatchData.szFileName := '';
                    m_xProcSendList.Add(pPatchData);
                  end
                  else
                  begin //丢掉
                    if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
                    begin
                      FreeMem(pPatchData.Data);
                      pPatchData.Data := nil;
                    end;
                    Dispose(pPatchData);
                  end;
                end
                else
                begin //丢掉
                  if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
                  begin
                    FreeMem(pPatchData.Data);
                    pPatchData.Data := nil;
                  end;
                  Dispose(pPatchData);
                end;
              end
              else
                m_xProcSendList.Add(pPatchData);
            end;
          PM_WAV:
            begin
              if pPatchData.szFileName <> '' then
              begin
                if m_nSvrWavFileList.Count > 0 then
                begin
                  dwFileCRC := 0;
                  ii := m_nSvrWavFileList.IndexOf(pPatchData.szFileName);
                  if ii >= 0 then
                    dwFileCRC := pTImageIdx(m_nSvrWavFileList.Objects[ii]).dwFileCRC;
                  if dwFileCRC <> 0 then
                  begin
                    pPatchData.tHdr.wGSocketIdx := MAGICWORD;
                    pPatchData.tHdr.nSocket := dwFileCRC;
                    pPatchData.szFileName := '';
                    m_xProcSendList.Add(pPatchData);
                  end
                  else
                  begin //丢掉
                    if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
                    begin
                      FreeMem(pPatchData.Data);
                      pPatchData.Data := nil;
                    end;
                    Dispose(pPatchData);
                  end;
                end
                else
                begin //丢掉
                  if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
                  begin
                    FreeMem(pPatchData.Data);
                    pPatchData.Data := nil;
                  end;
                  Dispose(pPatchData);
                end;
              end
              else
                m_xProcSendList.Add(pPatchData);
            end;
          PM_MAP:
            begin
              if pPatchData.szFileName <> '' then
              begin
                if m_nSvrMapFileList.Count > 0 then
                begin
                  dwFileCRC := 0;
                  ii := m_nSvrMapFileList.IndexOf(pPatchData.szFileName);
                  if ii >= 0 then
                    dwFileCRC := pTImageIdx(m_nSvrMapFileList.Objects[ii]).dwFileCRC;
                  if dwFileCRC <> 0 then
                  begin
                    pPatchData.tHdr.wGSocketIdx := MAGICWORD;
                    pPatchData.tHdr.nSocket := dwFileCRC;
                    pPatchData.szFileName := '';
                    m_xProcSendList.Add(pPatchData);
                  end
                  else
                  begin //丢掉
                    if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
                    begin
                      FreeMem(pPatchData.Data);
                      pPatchData.Data := nil;
                    end;
                    Dispose(pPatchData);
                  end;
                end
                else
                begin //丢掉
                  if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
                  begin
                    FreeMem(pPatchData.Data);
                    pPatchData.Data := nil;
                  end;
                  Dispose(pPatchData);
                end;
              end
              else
                m_xProcSendList.Add(pPatchData);
            end;

        end;
      end;
      m_xTempProcSendList.Clear;
    end;
  finally
    UnLock_Send();
  end;

  fGetMsg := False;
  Lock_Send();
  try
    i := 0;
    while m_xProcSendList.Count > i do
    begin
      pPatchData := m_xProcSendList[i];
      if (pPatchData.dwDelay > 0) and (GetTickCount < pPatchData.dwDelay) then
      begin
        Inc(i);
        Continue;
      end;
      PatchData.tHdr := pPatchData.tHdr;
      PatchData.Data := nil;
      if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
      begin
        GetMem(PatchData.Data, pPatchData.tHdr.nLength);
        Move(pPatchData.Data^, PatchData.Data^, pPatchData.tHdr.nLength);
        FreeMem(pPatchData.Data);
        pPatchData.Data := nil;
      end;
      Dispose(pPatchData);
      m_xProcSendList.Delete(i);
      fGetMsg := True;
      Break;
    end;
  finally
    UnLock_Send();
  end;

  if fGetMsg then
  begin
    if (PatchData.tHdr.nLength > 0) and (PatchData.Data <> nil) then
    begin
      nBuffLen := PatchData.tHdr.nLength + SizeOf(TMsgHeader);
      GetMem(pszBuff, nBuffLen);
      Move(PatchData.tHdr, pszBuff^, SizeOf(TMsgHeader));
      Move(PatchData.Data^, pszBuff[SizeOf(TMsgHeader)], PatchData.tHdr.nLength);
      m_ClientSocket.Socket.SendBuf(pszBuff^, nBuffLen);
      FreeMem(pszBuff);
    end
    else
    begin
      m_ClientSocket.Socket.SendBuf(PatchData.tHdr, SizeOf(TMsgHeader));
    end;
  end;
end;

procedure TPatchClient.ExecRecvBuffer();
var
  fGetMsg: Boolean;
  i, ii, nPos: Integer;
  szFileLine: string;
  szFileName: string;
  szFileIndex: string;
  szDirectory: string;

  szRecvFileList: string;
  szWzlList: string;
  szWavList: string;
  szMapList: string;
  nFileHandle: Integer;
  dwFileCRC: DWORD;
  nClientCrcIndex: Integer;

  szFileBuff: PChar;
  nFileBuff: Integer;
  szFileBuff2: Pointer;
  nFileBuff2: Integer;

  dwCRC: DWORD;
  aCrcList: array of DWORD;

  PatchData: TPatchData;
  pPatchData: pTPatchData;
  pImageIdx: pTImageIdx;

  fCheckData: Boolean;
  slen, dlen, mlen: Integer;
  nImageSize: Integer;
  pWzlImgInfo: pTWZLInfo;
  WMImages: TWMImages;
begin
  fGetMsg := False;
  PatchData.Data := nil;

  Lock_Recv();
  try
    if m_xProcRecvList.Count > 0 then
    begin
      pPatchData := m_xProcRecvList[0];
      PatchData.tHdr := pPatchData.tHdr;
      PatchData.Data := nil;
      if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
      begin
        GetMem(PatchData.Data, pPatchData.tHdr.nLength);
        Move(pPatchData.Data^, PatchData.Data^, pPatchData.tHdr.nLength);
        FreeMem(pPatchData.Data);
        pPatchData.Data := nil;
      end;
      Dispose(pPatchData);
      m_xProcRecvList.Delete(0);
      fGetMsg := True;
    end;
  finally
    UnLock_Recv();
  end;

  if fGetMsg then
  begin
    try
      case PatchData.tHdr.wIdent of
        PM_CRC:
          begin
{$I '..\Common\Macros\VMPBM.inc'}
            nClientCrcIndex := -1;

            if (PatchData.tHdr.nSocket = 0) and (PatchData.tHdr.wUserListIndex = 0) and (PatchData.tHdr.nLength = 0) then
            begin
              //清理旧请求
              Lock_Send();
              try
                for i := 0 to m_xProcSendList.Count - 1 do
                begin
                  pPatchData := m_xProcSendList[i];
                  if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
                    FreeMem(pPatchData.Data);
                  Dispose(pPatchData);
                end;
                m_xProcSendList.Clear;

                for i := 0 to m_xTempProcSendList.Count - 1 do
                begin
                  pPatchData := m_xTempProcSendList[i];
                  if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
                    FreeMem(pPatchData.Data);
                  Dispose(pPatchData);
                end;
                m_xTempProcSendList.Clear;

                // FreeMem
                for i := 0 to m_nSvrWzlFileList.Count - 1 do
                  Dispose(pTImageIdx(m_nSvrWzlFileList.Objects[i]));
                m_nSvrWzlFileList.Clear;

                for i := 0 to m_nSvrWavFileList.Count - 1 do
                  Dispose(pTImageIdx(m_nSvrWavFileList.Objects[i]));
                m_nSvrWavFileList.Clear;

                for i := 0 to m_nSvrMapFileList.Count - 1 do
                  Dispose(pTImageIdx(m_nSvrMapFileList.Objects[i]));
                m_nSvrMapFileList.Clear;

              finally
                UnLock_Send();
              end;

              m_fFirstGetCrc := False;

              Exit;
            end;

            m_fFirstGetCrc := True;
            if (PatchData.tHdr.nLength > 0) and (PatchData.Data <> nil) and (PatchData.tHdr.wUserListIndex = 0) then
            begin //包含数据的验证

              // Clear Cached
              for i := 0 to m_nSvrWzlFileList.Count - 1 do
                Dispose(pTImageIdx(m_nSvrWzlFileList.Objects[i]));
              m_nSvrWzlFileList.Clear;

              for i := 0 to m_nSvrWavFileList.Count - 1 do
                Dispose(pTImageIdx(m_nSvrWavFileList.Objects[i]));
              m_nSvrWavFileList.Clear;

              for i := 0 to m_nSvrMapFileList.Count - 1 do
                Dispose(pTImageIdx(m_nSvrMapFileList.Objects[i]));
              m_nSvrMapFileList.Clear;

              if PatchData.tHdr.nLength >= PatchData.tHdr.nSocket * 4 then
              begin
                nFileBuff := PatchData.tHdr.nLength - PatchData.tHdr.nSocket * 4;
                if nFileBuff > 0 then
                begin
                  GetMem(szFileBuff, nFileBuff);
                  try
                    Move(PChar(Integer(PatchData.Data) + PatchData.tHdr.nSocket * 4)^, szFileBuff^, nFileBuff);
                    m_Unzip.ZLibDecompressBuffer(szFileBuff, nFileBuff, szFileBuff2, nFileBuff2);
                    SetLength(szRecvFileList, nFileBuff2);
                    Move(szFileBuff2^, szRecvFileList[1], nFileBuff2);
                  finally
                    FreeMem(szFileBuff);
                    FreeMem(szFileBuff2);
                  end;

                  szWzlList := '';
                  szWavList := '';
                  szMapList := '';

                  if szRecvFileList <> '' then
                  begin
                    szRecvFileList := GetValidStr3(szRecvFileList, szWzlList, ['/']);
                    szRecvFileList := GetValidStr3(szRecvFileList, szWavList, ['/']);
                    szRecvFileList := GetValidStr3(szRecvFileList, szMapList, ['/']);
                  end;

                  //wzl
                  // i := 0;
                  while szWzlList <> '' do
                  begin
                    szWzlList := GetValidStr3(szWzlList, szFileLine, ['|']);
                    if szWzlList = '' then
                      Break;
                    szFileLine := GetValidStr3(szFileLine, szFileName, [',']);
                    szFileLine := GetValidStr3(szFileLine, szFileIndex, [',']);

                    dwFileCRC := Str_ToInt(szFileIndex, 0);
                    if dwFileCRC <> 0 then
                    begin
                      New(pImageIdx);
                      pImageIdx.WMImages := nil;
                      pImageIdx.dwFileCRC := DWORD(dwFileCRC);
                      nPos := m_PatchClientManager.m_xWMImageList.IndexOf(szFileName);
                      if nPos >= 0 then
                        pImageIdx.WMImages := TWMImages(m_PatchClientManager.m_xWMImageList.Objects[nPos]);
                      m_nSvrWzlFileList.AddObject(szFileName, TObject(pImageIdx));
                      // Inc(i);
                    end;
                  end;

                  //wav
                  // i := 0;
                  while szWavList <> '' do
                  begin
                    szWavList := GetValidStr3(szWavList, szFileLine, ['|']);
                    if szWavList = '' then
                      Break;
                    szFileLine := GetValidStr3(szFileLine, szFileName, [',']);
                    szFileLine := GetValidStr3(szFileLine, szFileIndex, [',']);

                    dwFileCRC := Str_ToInt(szFileIndex, 0);
                    if dwFileCRC <> 0 then
                    begin
                      New(pImageIdx);
                      pImageIdx.WMImages := nil;
                      pImageIdx.dwFileCRC := DWORD(dwFileCRC);
                      m_nSvrWavFileList.AddObject(szFileName, TObject(pImageIdx));
                      // Inc(i);
                    end;
                  end;

                  //map
                  // i := 0;
                  while szMapList <> '' do
                  begin
                    szMapList := GetValidStr3(szMapList, szFileLine, ['|']);
                    if szMapList = '' then
                      Break;
                    szFileLine := GetValidStr3(szFileLine, szFileName, [',']);
                    szFileLine := GetValidStr3(szFileLine, szFileIndex, [',']);

                    dwFileCRC := Str_ToInt(szFileIndex, 0);
                    if dwFileCRC <> 0 then
                    begin
                      New(pImageIdx);
                      pImageIdx.WMImages := nil;
                      pImageIdx.dwFileCRC := DWORD(dwFileCRC);
                      m_nSvrMapFileList.AddObject(szFileName, TObject(pImageIdx));
                      // Inc(i);
                    end;
                  end;
                end;
              end;
              if PatchData.tHdr.nSocket > 0 then
              begin //CRC Client FileCount
                SetLength(aCrcList, PatchData.tHdr.nSocket);
                Move(PatchData.Data^, aCrcList[0], PatchData.tHdr.nSocket * 4);
                dwCRC := $FFFFFFFF;
                CnCRC32.FileCRC32(ParamStr(0), dwCRC);

                //DebugOutStr(format('ClientCRC: %.8x', [dwCRC]));

                for i := 0 to PatchData.tHdr.nSocket - 1 do
                begin
                  //DebugOutStr(format('ServerCRC: %.8x', [aCrcList[i]]));
                  if dwCRC = aCrcList[i] then
                  begin
                    nClientCrcIndex := i;
                    SendProcMsg(TObject(dwCRC), '', PM_CRC, nClientCrcIndex); //首次回送CRC，加密？
                    Break;
                  end;
                end;
              end;
            end
            else
            begin
              if (DWORD(PatchData.tHdr.nSocket) > 0) and (PatchData.tHdr.wUserListIndex > 0) then
              begin //服务器的CRC下发检测，加密？
                dwCRC := $FFFFFFFF;
                CnCRC32.FileCRC32(ParamStr(0), dwCRC, DWORD(PatchData.tHdr.nSocket), PatchData.tHdr.wUserListIndex);

                //debugoutstr(format('%.8x  nStartPos: %d   nLen: %d', [dwCRC, DWORD(PatchData.tHdr.nSocket), PatchData.tHdr.wUserListIndex]));
                SendProcMsg(TObject(dwCRC), '', PM_CRC, nClientCrcIndex);
              end;
            end;
{$I '..\Common\Macros\VMPE.inc'}
          end;
        PM_INDEX:
          begin
            //结合CRC？
            for i := 0 to m_nSvrWzlFileList.Count - 1 do
            begin
              if DWORD(PatchData.tHdr.nSocket) = pTImageIdx(m_nSvrWzlFileList.Objects[i]).dwFileCRC then
              begin
                szFileName := '.\data\' + m_nSvrWzlFileList[i] + '.wzl';
                szFileIndex := '.\data\' + m_nSvrWzlFileList[i] + '.wzx';
                dwCRC := 0;
                WMImages := pTImageIdx(m_nSvrWzlFileList.Objects[i]).WMImages;
                try
                  if FileExists(szFileName) then
                  begin
                    nFileHandle := FileOpen(szFileName, fmOpenWrite or fmShareDenyNone);
                    if nFileHandle <> INVALID_HANDLE_VALUE then
                    begin
                      FileSeek(nFileHandle, $30 - 4, 0);
                      FileWrite(nFileHandle, PatchData.tHdr.wUserListIndex, 4);
                      FileClose(nFileHandle);
                      Inc(dwCRC);
                    end;
                  end;
                  if FileExists(szFileIndex) then
                  begin
                    nFileHandle := FileOpen(szFileIndex, fmOpenWrite or fmShareDenyNone);
                    if nFileHandle <> INVALID_HANDLE_VALUE then
                    begin
                      FileSeek(nFileHandle, $30 - 4, 0);
                      FileWrite(nFileHandle, PatchData.tHdr.wUserListIndex, 4);
                      FileClose(nFileHandle);
                      Inc(dwCRC);
                    end;
                  end;
                finally
                  if (dwCRC = 2) and (WMImages <> nil) then
                  begin
                    if (WMImages.m_fQueryIndex) and (WMImages.m_IndexList.Count <> PatchData.tHdr.wUserListIndex) then
                    begin
                      WMImages.m_IndexList.Clear;
                      WMImages.m_FileStream.Free;
                      WMImages.Initialize;
                    end;
                    if (WMImages <> nil) and WMImages.m_fQueryImgCnt and (WMImages.m_IndexList.Count <> PatchData.tHdr.wUserListIndex) then
                    begin

                      if (PatchData.tHdr.wUserListIndex > WMImages.FImageCount) then
                      begin
                        dlen := PatchData.tHdr.wUserListIndex - WMImages.FImageCount; //add imagecount
                        if WMImages.m_ImgArr <> nil then
                        begin
                          ReAllocMem(WMImages.m_ImgArr, SizeOf(TDxImage) * PatchData.tHdr.wUserListIndex);
                          FillChar(Pointer(LongWord(WMImages.m_ImgArr) + SizeOf(TDxImage) * WMImages.FImageCount)^, SizeOf(TDxImage) * dlen, 0);
                        end;
                        WMImages.FImageCount := PatchData.tHdr.wUserListIndex;

                        for slen := 0 to dlen - 1 do
                        begin
                          //mlen := $30;
                          WMImages.m_IndexList.Add(Pointer(nil));
                        end;
                      end;
                    end;
                  end;
                end;
                Break;
              end;
            end;
          end;
        PM_DATA:
          begin //结合CRC？
            if (PatchData.tHdr.nSocket <> 0) and (PatchData.Data <> nil) and (DWORD(PatchData.tHdr.nLength) > $10) then
            begin
              if PatchData.tHdr.wUserListIndex < 0 then
              begin
                //uib mmap
                for i := 0 to m_nSvrWzlFileList.Count - 1 do
                begin
                  if (DWORD(PatchData.tHdr.nSocket) = pTImageIdx(m_nSvrWzlFileList.Objects[i]).dwFileCRC) then
                  begin
                    szFileName := m_nSvrWzlFileList[i];
                    szDirectory := ExtractFilePath(szFileName);
                    if not DirectoryExists(szDirectory) then
                      ForceDirectories(szDirectory);

                    if FileExists(szFileName) then
                      Break;

                    m_Unzip.ZLibDecompressBuffer(PatchData.Data, PatchData.tHdr.nLength, szFileBuff2, nFileBuff2);
                    try
                      if (nFileBuff2 > 0) and (nFileBuff2 = -PatchData.tHdr.wUserListIndex) then
                      begin
                        nFileHandle := FileCreate(szFileName);
                        if nFileHandle <> INVALID_HANDLE_VALUE then
                        begin
                          FileWrite(nFileHandle, szFileBuff2^, nFileBuff2);
                          FileClose(nFileHandle);
                        end;
                      end;
                    finally
                      FreeMem(szFileBuff2);
                    end;
                    Break;
                  end;
                end;
              end
              else
              begin
                for i := 0 to m_nSvrWzlFileList.Count - 1 do
                begin
                  if (DWORD(PatchData.tHdr.nSocket) = pTImageIdx(m_nSvrWzlFileList.Objects[i]).dwFileCRC) then
                  begin
                    szFileName := '.\data\' + m_nSvrWzlFileList[i] + '.wzl';
                    szFileIndex := '.\data\' + m_nSvrWzlFileList[i] + '.wzx';
                    if not FileExists(szFileName) then
                      Break;

                    fCheckData := True;
                    pWzlImgInfo := pTWZLInfo(PatchData.Data);
                    try
                      if (pWzlImgInfo.Width < 0) or (pWzlImgInfo.Height < 0) then
                        fCheckData := False
                      else
                      begin
                        nImageSize := pWzlImgInfo.Size;
                        if (nImageSize = 0) and ((pWzlImgInfo.Width = 0) or (pWzlImgInfo.Height = 0)) then
                          fCheckData := False;
                        if pWzlImgInfo.ColorFlag = 5 then
                        begin
                          slen := (pWzlImgInfo.Width * 2 + 3) div 4 * 4;
                          // dlen := slen div 2;
                        end
                        else
                        begin
                          slen := (pWzlImgInfo.Width + 3) div 4 * 4;
                          // dlen := slen;
                        end;
                        mlen := slen * pWzlImgInfo.Height;
                        if mlen = 0 then
                          fCheckData := False;

                        if nImageSize = 0 then
                          nImageSize := mlen;
                        if nImageSize = 0 then
                          fCheckData := False;
                      end;
                    finally
                    end;

                    if not (pWzlImgInfo.ColorFlag in [3, 5]) then
                    begin
                      {if pTImageIdx(m_nSvrWzlFileList.Objects[i]).WMImages <> nil then
                        debugoutstr(format('Wzl Data Error: %s Size:%.8x (%d/%d)',
                          [pTImageIdx(m_nSvrWzlFileList.Objects[i]).WMImages.FileName,
                          nImageSize, pWzlImgInfo.Width, pWzlImgInfo.Height]));}
                      fCheckData := False;
                    end;

                    if not fCheckData then
                      Break;

                    nFileHandle := FileOpen(szFileName, fmOpenWrite or fmShareDenyNone);
                    if nFileHandle <> INVALID_HANDLE_VALUE then
                    begin
                      nPos := FileSeek(nFileHandle, 0, 2);
                      FileWrite(nFileHandle, PatchData.Data^, PatchData.tHdr.nLength);
                      FileClose(nFileHandle);

                      if not FileExists(szFileIndex) then
                        Break;
                      nFileHandle := FileOpen(szFileIndex, fmOpenWrite or fmShareDenyNone);
                      if nFileHandle <> INVALID_HANDLE_VALUE then
                      begin
                        FileSeek(nFileHandle, $30 + PatchData.tHdr.wUserListIndex * 4, 0);
                        FileWrite(nFileHandle, nPos, 4);
                        FileClose(nFileHandle);
                        if (pTImageIdx(m_nSvrWzlFileList.Objects[i]).WMImages <> nil) and
                          (PatchData.tHdr.wUserListIndex < pTImageIdx(m_nSvrWzlFileList.Objects[i]).WMImages.m_IndexList.Count) then
                        begin

                          pTImageIdx(m_nSvrWzlFileList.Objects[i]).WMImages.m_IndexList[PatchData.tHdr.wUserListIndex] := Pointer(nPos);
                        end;
                      end;
                    end;
                    Break;
                  end;
                end;
              end;
            end;
          end;
        PM_WAV:
          begin
            if (PatchData.tHdr.nSocket <> 0) and (PatchData.Data <> nil) and (PatchData.tHdr.nLength > 0) then
            begin
              for i := 0 to m_nSvrWavFileList.Count - 1 do
              begin
                if (DWORD(PatchData.tHdr.nSocket) = pTImageIdx(m_nSvrWavFileList.Objects[i]).dwFileCRC) then
                begin
                  szFileName := '.\wav\' + m_nSvrWavFileList[i] + '.wav';

                  if FileExists(szFileName) then
                    Break;

                  m_Unzip.ZLibDecompressBuffer(PatchData.Data, PatchData.tHdr.nLength, szFileBuff2, nFileBuff2);
                  try
                    if (nFileBuff2 > 0) and (nFileBuff2 = PatchData.tHdr.wUserListIndex) then
                    begin
                      nFileHandle := FileCreate(szFileName);
                      if nFileHandle <> INVALID_HANDLE_VALUE then
                      begin
                        FileWrite(nFileHandle, szFileBuff2^, nFileBuff2);
                        FileClose(nFileHandle);

                        // handle files
                        szFileName := Copy(szFileName, 3, Length(szFileName));
                        for ii := 0 to g_SoundList.Count - 1 do
                        begin
                          if (g_SoundList[ii] = '') or (g_SoundList.Objects[ii] <> nil) then
                            Continue;
                          if CompareText(g_SoundList[ii], szFileName) = 0 then
                          begin
                            g_SoundList.Objects[ii] := TObject(Integer(1));
                            //Break;
                          end;
                        end;

                      end;
                    end;
                  finally
                    FreeMem(szFileBuff2);
                  end;
                  Break;
                end;
              end;
            end;
          end;
        PM_MAP:
          begin
            if (PatchData.tHdr.nSocket <> 0) and (PatchData.Data <> nil) and (PatchData.tHdr.nLength > 0) then
            begin
              for i := 0 to m_nSvrMapFileList.Count - 1 do
              begin
                if (DWORD(PatchData.tHdr.nSocket) = pTImageIdx(m_nSvrMapFileList.Objects[i]).dwFileCRC) then
                begin
                  szFileName := '.\Map\' + m_nSvrMapFileList[i] + '.Map';

                  if FileExists(szFileName) then
                    Break;

                  m_Unzip.ZLibDecompressBuffer(PatchData.Data, PatchData.tHdr.nLength, szFileBuff2, nFileBuff2);
                  try
                    if (nFileBuff2 > 0) and (nFileBuff2 = PatchData.tHdr.wUserListIndex) then
                    begin
                      nFileHandle := FileCreate(szFileName);
                      if nFileHandle <> INVALID_HANDLE_VALUE then
                      begin
                        FileWrite(nFileHandle, szFileBuff2^, nFileBuff2);
                        FileClose(nFileHandle);
                        //ReLoad ...
                        if (Map <> nil) and (g_MySelf <> nil) then
                          Map.LoadMap(Map.m_sCurrentMap, g_MySelf.m_nCurrX, g_MySelf.m_nCurrY);
                      end;
                    end;
                  finally
                    FreeMem(szFileBuff2);
                  end;
                  Break;
                end;
              end;
            end;
          end;
      end;
    finally
      if PatchData.Data <> nil then
      begin
        FreeMem(PatchData.Data);
        PatchData.Data := nil;
      end;
    end;
  end;
end;

procedure TPatchClient.AddProcRecvMsg(pMsgHeader: pTMsgHeader; pszMsgBuff: PChar);
var
  pPatchData: pTPatchData;
begin
  New(pPatchData);
  pPatchData.tHdr := pMsgHeader^;
  pPatchData.Data := nil;
  if (pMsgHeader.nLength > 0) then
  begin
    GetMem(pPatchData.Data, pMsgHeader.nLength);
    Move(pszMsgBuff^, pPatchData.Data^, pMsgHeader.nLength);
  end;
  Lock_Recv();
  try
    m_xProcRecvList.Add(pPatchData);
  finally
    UnLock_Recv();
  end;
end;

procedure TPatchClient.ProcRecvBuffer(pszBuffer: PChar; nRecvLen: Integer);
var
  fProced: Boolean;
  nBuffLen, nBuffLen2: Integer;
  nRealLen: Integer;
  pszBuff, pszBuff2: PChar;
  pszData: PChar;
  pTempBuff: PChar;
  pMsgHeader: pTMsgHeader;
resourcestring
  sExceptionMsg1 = '[Exception] TPatchClient::ExecRecvBuffer 1';
  sExceptionMsg2 = '[Exception] TPatchClient::ExecRecvBuffer 2';
  sExceptionMsg3 = '[Exception] TPatchClient::ExecRecvBuffer 3';
begin
  fProced := False;
  nBuffLen := 0;
  pszBuff := nil;

  try
    if pszBuffer <> nil then
    begin
      ReAllocMem(m_pRecvBuffer, m_nRecvBuffLen + nRecvLen);
      Move(pszBuffer^, m_pRecvBuffer[m_nRecvBuffLen], nRecvLen);
    end;
  except
    debugoutstr(sExceptionMsg1);
  end;

  try
    nBuffLen := m_nRecvBuffLen + nRecvLen;
    pszBuff := m_pRecvBuffer;

    nBuffLen2 := nBuffLen;
    pszBuff2 := m_pRecvBuffer;

    if nBuffLen >= SizeOf(TMsgHeader) then
    begin
      while True do
      begin
        pMsgHeader := pTMsgHeader(pszBuff);
        if (pMsgHeader.dwCode = MAGICCODE) and (pMsgHeader.wIdent in [1..5]) and (pMsgHeader.wGSocketIdx = MAGICWORD) then
        begin
          nRealLen := abs(pMsgHeader.nLength) + SizeOf(TMsgHeader);
          if nBuffLen < nRealLen then
            Break;
          pszData := pszBuff + SizeOf(TMsgHeader);

          AddProcRecvMsg(pMsgHeader, pszData);

          pszBuff := pszBuff + SizeOf(TMsgHeader) + pMsgHeader.nLength;
          nBuffLen := nBuffLen - (pMsgHeader.nLength + SizeOf(TMsgHeader));
          fProced := True;
        end
        else
        begin
          Inc(pszBuff);
          Dec(nBuffLen);
        end;
        if nBuffLen < SizeOf(TMsgHeader) then
          Break;
      end;
    end;
  except
    debugoutstr(sExceptionMsg2);
  end;

  try
    if nBuffLen > 0 then
    begin
      if not fProced and (nBuffLen2 >= SizeOf(TMsgHeader)) then
      begin //bug?
        nBuffLen := nBuffLen2;
        pszBuff := pszBuff2;
      end;

      GetMem(pTempBuff, nBuffLen);
      Move(pszBuff^, pTempBuff^, nBuffLen);
      FreeMem(m_pRecvBuffer);
      m_pRecvBuffer := pTempBuff;
      m_nRecvBuffLen := nBuffLen;
    end
    else
    begin
      FreeMem(m_pRecvBuffer);
      m_pRecvBuffer := nil;
      m_nRecvBuffLen := 0;
    end;
  except
    debugoutstr(sExceptionMsg3);
  end;
end;

procedure TPatchClient.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  if m_pRecvBuffer <> nil then
    FreeMem(m_pRecvBuffer);
  m_pRecvBuffer := nil;
  m_nRecvBuffLen := 0;
end;

procedure TPatchClient.ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: Integer;
  pPatchData: pTPatchData;
begin
  Lock_Send();
  try
    for i := 0 to m_xProcSendList.Count - 1 do
    begin
      pPatchData := m_xProcSendList[i];
      if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
        FreeMem(pPatchData.Data);
      Dispose(pPatchData);
    end;
    m_xProcSendList.Clear;

    for i := 0 to m_xTempProcSendList.Count - 1 do
    begin
      pPatchData := m_xTempProcSendList[i];
      if (pPatchData.tHdr.nLength > 0) and (pPatchData.Data <> nil) then
        FreeMem(pPatchData.Data);
      Dispose(pPatchData);
    end;
    m_xTempProcSendList.Clear;

    m_fFirstGetCrc := False;

    // FreeMem
    {for i := 0 to m_nSvrWzlFileList.Count - 1 do
      Dispose(pTImageIdx(m_nSvrWzlFileList.Objects[i]));
    m_nSvrWzlFileList.Clear;

    for i := 0 to m_nSvrWavFileList.Count - 1 do
      Dispose(pTImageIdx(m_nSvrWavFileList.Objects[i]));
    m_nSvrWavFileList.Clear;

    for i := 0 to m_nSvrMapFileList.Count - 1 do
      Dispose(pTImageIdx(m_nSvrMapFileList.Objects[i]));
    m_nSvrMapFileList.Clear;}

  finally
    UnLock_Send();
  end;

  {Lock_Recv();
  try
    for i := 0 to m_xProcRecvList.Count - 1 do begin
      if pTPatchData(m_xProcRecvList[i]).Data <> nil then
        FreeMem(pTPatchData(m_xProcRecvList[i]).Data);
      Dispose(pTPatchData(m_xProcRecvList[i]));
    end;
    m_xProcRecvList.Clear;
  finally
    UnLock_Recv();
  end;}

  if m_pRecvBuffer <> nil then
    FreeMem(m_pRecvBuffer);
  m_pRecvBuffer := nil;
  m_nRecvBuffLen := 0;
end;

procedure TPatchClient.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TPatchClient.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  nRecvLen: Integer;
  pszRecvBuffer: array[0..DATA_BUFSIZE * 2 - 1] of Char;
begin
  while True do
  begin
    nRecvLen := Socket.ReceiveBuf(pszRecvBuffer, SizeOf(pszRecvBuffer));
    if nRecvLen <= 0 then
      Break;
    ProcRecvBuffer(@pszRecvBuffer, nRecvLen);
  end;
end;

initialization

finalization

end.
