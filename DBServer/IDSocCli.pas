unit IDSocCli;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grobal2, DBShare, D7ScktComp;

type
  TFrmIDSoc = class(TForm)
    IDSocket: TClientSocket;
    CheckTimer: TTimer;
    KeepAliveTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckTimerTimer(Sender: TObject);
    procedure KeepAliveTimerTimer(Sender: TObject);
    procedure IDSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure IDSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure IDSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure IDSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  private
    GlobaSessionList: TList;
    m_sSockMsg: string;
    procedure ProcessSocketMsg;
    procedure ProcessAddSession(sData: string);
    procedure ProcessDelSession(sData: string);
    procedure ProcessGetOnlineCount(sData: string);
    procedure SendKeepAlivePacket();
    { Private declarations }
  public
    procedure SendSocketMsg(wIdent: Word; sMsg: string);
    function CheckSession(sAccount, sIPaddr: string; nSessionID: Integer): Boolean;
    function CheckSessionLoadRcd(sAccount, sIPaddr: string; nSessionID: Integer; var boFoundSession: Boolean): Integer;
    function SetSessionSaveRcd(sAccount: string): Boolean;
    procedure SetGlobaSessionNoPlay(nSessionID: Integer);
    procedure SetGlobaSessionPlay(nSessionID: Integer);
    function GetGlobaSessionStatus(nSessionID: Integer): Boolean;
    procedure CloseSession(sAccount: string; nSessionID: Integer); //关闭全局会话
    procedure OpenConnect();
    procedure CloseConnect();
    function GetSession(sAccount, sIPaddr: string): Boolean;
    { Public declarations }
  end;

var
  FrmIDSoc: TFrmIDSoc;

implementation

uses HUtil32, UsrSoc, DBSMain;

{$R *.DFM}

procedure TFrmIDSoc.FormCreate(Sender: TObject);
begin
  GlobaSessionList := TList.Create;
  //FillChar(m_SocketArr, SizeOf(m_SocketArr), #0);
  m_sSockMsg := '';
  dwCheckIDSocTick := GetTickCount();
end;

procedure TFrmIDSoc.FormDestroy(Sender: TObject);
var
  i: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    Dispose(GlobaSessionInfo);
  end;
  GlobaSessionList.Free;
end;

procedure TFrmIDSoc.CheckTimerTimer(Sender: TObject);
//var
  //i                         : Integer;
begin
  {for i := Low(m_SocketArr) to High(m_SocketArr) do
    if (m_SocketArr[i].IDSocket.Address <> '') and not m_SocketArr[i].IDSocket.Active then
      m_SocketArr[i].IDSocket.Active := True; }
  if (IDSocket.Address <> '') and not IDSocket.Active then
    IDSocket.Active := True;
end;

procedure TFrmIDSoc.IDSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  m_sSockMsg := m_sSockMsg + Socket.ReceiveText;
  if Pos(')', m_sSockMsg) > 0 then
    ProcessSocketMsg();
end;

procedure TFrmIDSoc.ProcessSocketMsg();
var
  sScoketText: string;
  sData: string;
  sCode: string;
  sBody: string;
  nIdent: Integer;
begin
  sScoketText := m_sSockMsg;
  while (Pos(')', sScoketText) > 0) do
  begin
    sScoketText := ArrestStringEx(sScoketText, '(', ')', sData);
    if sData = '' then
      Break;
    sBody := GetValidStr3(sData, sCode, ['/']);
    nIdent := Str_ToInt(sCode, 0);
    case nIdent of
      SS_OPENSESSION:
        begin
          ProcessAddSession(sBody);
          dwCheckIDSocTimeMin := GetTickCount - dwCheckIDSocTick;
          if dwCheckIDSocTimeMax < dwCheckIDSocTimeMin then
            dwCheckIDSocTimeMax := dwCheckIDSocTimeMin;
          dwCheckIDSocTick := GetTickCount();
        end;
      SS_CLOSESESSION:
        begin
          ProcessDelSession(sBody);
          dwCheckIDSocTimeMin := GetTickCount - dwCheckIDSocTick;
          if dwCheckIDSocTimeMax < dwCheckIDSocTimeMin then
            dwCheckIDSocTimeMax := dwCheckIDSocTimeMin;
          dwCheckIDSocTick := GetTickCount();
        end;
      SS_KEEPALIVE: ProcessGetOnlineCount(sBody);
    end;
  end;
  m_sSockMsg := sScoketText;
end;

procedure TFrmIDSoc.SendSocketMsg(wIdent: Word; sMsg: string); //004A1C1C
var
  sSendText: string;
resourcestring
  sFormatMsg = '(%d/%s)';
begin
  sSendText := Format(sFormatMsg, [wIdent, sMsg]);
  if IDSocket.Socket.Connected then
    IDSocket.Socket.SendText(sSendText);
end;

function TFrmIDSoc.CheckSession(sAccount, sIPaddr: string; nSessionID: Integer): Boolean;
var
  i: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  //g_CheckCode.dwThread0 := 1001800;
  Result := False;
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then
    begin
      if (GlobaSessionInfo.sAccount = sAccount) and (GlobaSessionInfo.nSessionID = nSessionID) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
  //g_CheckCode.dwThread0 := 1001801;
end;

function TFrmIDSoc.CheckSessionLoadRcd(sAccount, sIPaddr: string; nSessionID: Integer; var boFoundSession: Boolean): Integer;
var
  i: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
resourcestring
  sHeroFlag = '@HERO@';
begin
  Result := -1;
  boFoundSession := False;
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then
    begin
      if (GlobaSessionInfo.sAccount = sAccount) and (GlobaSessionInfo.nSessionID = nSessionID) then
      begin
        boFoundSession := True;
        if sIPaddr = sHeroFlag then
          Result := 2
        else if not GlobaSessionInfo.boLoadRcd then
        begin
          GlobaSessionInfo.boLoadRcd := True;
          Result := 1;
        end;
        Break;
      end;
    end;
  end;
end;

function TFrmIDSoc.SetSessionSaveRcd(sAccount: string): Boolean;
var
  i: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  //g_CheckCode.dwThread0 := 1002500;
  Result := False;
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then
    begin
      if (GlobaSessionInfo.sAccount = sAccount) then
      begin
        GlobaSessionInfo.boLoadRcd := False;
        Result := True;
      end;
    end;
  end;
  //g_CheckCode.dwThread0 := 1002501;
end;

procedure TFrmIDSoc.SetGlobaSessionNoPlay(nSessionID: Integer);
var
  i: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  //g_CheckCode.dwThread0 := 1002300;
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then
    begin
      if (GlobaSessionInfo.nSessionID = nSessionID) then
      begin
        GlobaSessionInfo.boStartPlay := False;
        Break;
      end;
    end;
  end;
  //g_CheckCode.dwThread0 := 1002301;
end;

procedure TFrmIDSoc.SetGlobaSessionPlay(nSessionID: Integer);
var
  i: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  //g_CheckCode.dwThread0 := 1002400;
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then
    begin
      if (GlobaSessionInfo.nSessionID = nSessionID) then
      begin
        GlobaSessionInfo.boStartPlay := True;
        Break;
      end;
    end;
  end;
  //g_CheckCode.dwThread0 := 1002401;
end;

function TFrmIDSoc.GetGlobaSessionStatus(nSessionID: Integer): Boolean;
var
  i: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  Result := False;
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then
    begin
      if (GlobaSessionInfo.nSessionID = nSessionID) then
      begin
        Result := GlobaSessionInfo.boStartPlay;
        Break;
      end;
    end;
  end;
end;

procedure TFrmIDSoc.CloseSession(sAccount: string; nSessionID: Integer);
var
  i: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then
    begin
      if (GlobaSessionInfo.nSessionID = nSessionID) then
      begin
        if GlobaSessionInfo.sAccount = sAccount then
        begin
          Dispose(GlobaSessionInfo);
          GlobaSessionList.Delete(i);
          Break;
        end;
      end;
    end;
  end;
end;

procedure TFrmIDSoc.IDSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmIDSoc.ProcessAddSession(sData: string); //004A1A80
var
  s, sAccount, SessionID, sMode, sPayment, sIPaddr: string;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  s := sData;
  sData := GetValidStr3(sData, sAccount, ['/']);
  sData := GetValidStr3(sData, SessionID, ['/']);
  sData := GetValidStr3(sData, sMode, ['/']);
  sData := GetValidStr3(sData, sPayment, ['/']);
  sData := GetValidStr3(sData, sIPaddr, ['/']);
  New(GlobaSessionInfo);
  GlobaSessionInfo.sAccount := sAccount;
  GlobaSessionInfo.sIPaddr := sIPaddr;
  GlobaSessionInfo.nSessionID := Str_ToInt(SessionID, 0);
  //GlobaSessionInfo.nMode := Str_ToInt(sMode, 0);
  GlobaSessionInfo.boStartPlay := False;
  GlobaSessionInfo.boLoadRcd := False;
  GlobaSessionInfo.dwAddTick := GetTickCount();
  GlobaSessionInfo.dAddDate := Now();
  GlobaSessionList.Add(GlobaSessionInfo);
  //MainOutMessage('0: ' + s);
end;

procedure TFrmIDSoc.ProcessDelSession(sData: string); //004A1B84
var
  sAccount: string;
  i, nSessionID: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  sData := GetValidStr3(sData, sAccount, ['/']);
  nSessionID := Str_ToInt(sData, 0);
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then
    begin
      if (GlobaSessionInfo.nSessionID = nSessionID) and (GlobaSessionInfo.sAccount = sAccount) then
      begin
        Dispose(GlobaSessionInfo);
        GlobaSessionList.Delete(i);
        Break;
      end;
    end;
  end;
end;

procedure TFrmIDSoc.SendKeepAlivePacket;
begin
  if IDSocket.Socket.Connected then
  begin
    IDSocket.Socket.SendText('(' +
      IntToStr(SS_SERVERINFO) +
      '/' +
      sServerName +
      '/' +
      '99' +
      '/' +
      IntToStr(FrmUserSoc.GetUserCount) +
      ')');
  end;
end;

procedure TFrmIDSoc.CloseConnect;
begin
  KeepAliveTimer.Enabled := False;
  IDSocket.Active := False;
end;

function TFrmIDSoc.GetSession(sAccount, sIPaddr: string): Boolean;
var
  i: Integer;
  GlobaSessionInfo: pTGlobaSessionInfo;
begin
  Result := False;
  for i := 0 to GlobaSessionList.Count - 1 do
  begin
    GlobaSessionInfo := GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then
    begin
      if (GlobaSessionInfo.sAccount = sAccount) and (GlobaSessionInfo.sIPaddr = sIPaddr) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure TFrmIDSoc.OpenConnect;
begin
  KeepAliveTimer.Enabled := True;
  IDSocket.Active := False;
  IDSocket.Address := sIDServerAddr;
  IDSocket.Port := nIDServerPort;
  IDSocket.Active := True;
end;

procedure TFrmIDSoc.KeepAliveTimerTimer(Sender: TObject);
begin
  SendKeepAlivePacket();
end;

procedure TFrmIDSoc.ProcessGetOnlineCount(sData: string);
begin

end;

procedure TFrmIDSoc.IDSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
resourcestring
  sGateOpen = '登陆服务器[0](%s:%d)已打开...';
begin
  MainOutMessage(Format(sGateOpen, [Socket.LocalAddress, Socket.LocalPort]));
  dwCheckIDSocTick := GetTickCount();
  dwCheckIDSocTimeMin := 0;
  dwCheckIDSocTimeMax := 0;
  SendKeepAlivePacket();
end;

procedure TFrmIDSoc.IDSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //MainOutMessage('账号服务器未连接...');
end;

end.
