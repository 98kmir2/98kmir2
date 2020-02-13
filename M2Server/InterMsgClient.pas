unit InterMsgClient;

interface

uses
  Windows, Classes, Controls, Forms, D7ScktComp, EDcode, SysUtils;

type
  TFrmMsgClient = class(TForm)
    MsgClient: TClientSocket;
    procedure MsgClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure MsgClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure MsgClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure MsgClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  private
    m_dwStartTick: LongWord;
    SocData: string;
    procedure DecodeSocStr;
    { Private declarations }
  public
    procedure SendSocket(sMsg: string);
    procedure ConnectMsgServer();
    procedure Run();
    { Public declarations }
  end;

var
  FrmMsgClient: TFrmMsgClient;

implementation

uses M2Share, HUtil32, Grobal2, InterServerMsg;

{$R *.dfm}

{ TFrmMsgClient }

procedure TFrmMsgClient.ConnectMsgServer;
begin
  MsgClient.Active := False;
  MsgClient.Address := g_Config.sMsgSrvAddr;
  MsgClient.Port := g_Config.nMsgSrvPort;
  m_dwStartTick := GetTickCount();
end;

procedure TFrmMsgClient.Run;
begin
{$IF INTERSERVER = 1}
  if MsgClient.Socket.Connected then
    DecodeSocStr()
  else if GetTickCount - m_dwStartTick > 10 * 1000 then
  begin
    m_dwStartTick := GetTickCount();
    MsgClient.Active := True;
  end;
{$IFEND}
end;

procedure TFrmMsgClient.DecodeSocStr;
var
  BufStr, Str, Head, Body, sNumStr: string;
  Ident, sNum: Integer;
resourcestring
  sExceptionMsg = '[Exception] FrmIdSoc::DecodeSocStr';
begin
  if Pos(')', SocData) <= 0 then
    Exit;
  //////////////////////
  //MainOutMessageAPI('TFrmMsgClient.DecodeSocStr: ' + SocData);
  try
    BufStr := SocData;
    SocData := '';
    while Pos(')', BufStr) > 0 do
    begin
      BufStr := ArrestStringEx(BufStr, '(', ')', Str);
      if Str <> '' then
      begin
        Body := GetValidStr3(Str, Head, ['/']);
        Body := GetValidStr3(Body, sNumStr, ['/']);
        Ident := Str_ToInt(Head, 0);
        sNum := Str_ToInt(sNumStr, -1);
        case Ident of
          ISM_USERSERVERCHANGE: FrmSrvMsg.MsgGetUserServerChange(sNum, Body);
          ISM_CHANGESERVERRECIEVEOK: FrmSrvMsg.MsgGetUserChangeServerRecieveOk(sNum, Body);
          ISM_USERLOGON: FrmSrvMsg.MsgGetUserLogon(sNum, Body);
          ISM_USERLOGOUT: FrmSrvMsg.MsgGetUserLogout(sNum, Body);
          ISM_WHISPER: FrmSrvMsg.MsgGetWhisper(sNum, Body);
          ISM_GMWHISPER: FrmSrvMsg.MsgGetGMWhisper(sNum, Body);
          ISM_LM_WHISPER: FrmSrvMsg.MsgGetLoverWhisper(sNum, Body);
          ISM_SYSOPMSG: FrmSrvMsg.MsgGetSysopMsg(sNum, Body);
          ISM_ADDGUILD: FrmSrvMsg.MsgGetAddGuild(sNum, Body);
          ISM_DELGUILD: FrmSrvMsg.MsgGetDelGuild(sNum, Body);
          ISM_RELOADGUILD: FrmSrvMsg.MsgGetReloadGuild(sNum, Body);
          ISM_GUILDMSG: FrmSrvMsg.MsgGetGuildMsg(sNum, Body);
          ISM_GUILDWAR: FrmSrvMsg.MsgGetGuildWarInfo(sNum, Body);
          ISM_CHATPROHIBITION: FrmSrvMsg.MsgGetChatProhibition(sNum, Body);
          ISM_CHATPROHIBITIONCANCEL: FrmSrvMsg.MsgGetChatProhibitionCancel(sNum, Body);
          ISM_CHANGECASTLEOWNER: FrmSrvMsg.MsgGetChangeCastleOwner(sNum, Body);
          ISM_RELOADCASTLEINFO: FrmSrvMsg.MsgGetReloadCastleAttackers(sNum);
          ISM_RELOADADMIN: FrmSrvMsg.MsgGetReloadAdmin;
          ISM_MARKETOPEN: FrmSrvMsg.MsgGetMarketOpen(True);
          ISM_MARKETCLOSE: FrmSrvMsg.MsgGetMarketOpen(False);
          ISM_RELOADCHATLOG: FrmSrvMsg.MsgGetReloadChatLog;
          //ISM_LM_DELETE: FrmSrvMsg.MsgGetRelationShipDelete(snum, body);
          ISM_USER_INFO,
            ISM_FRIEND_INFO,
            ISM_FRIEND_DELETE,
            ISM_FRIEND_OPEN,
            ISM_FRIEND_CLOSE,
            ISM_FRIEND_RESULT,
            ISM_TAG_SEND,
            ISM_TAG_RESULT: FrmSrvMsg.MsgGetUserMgr(sNum, Body, Ident);
          ISM_RELOADMAKEITEMLIST: FrmSrvMsg.MsgGetReloadMakeItemList;
          ISM_GUILDMEMBER_RECALL: FrmSrvMsg.MsgGetGuildMemberRecall(sNum, Body);
          ISM_RELOADGUILDAGIT: FrmSrvMsg.MsgGetReloadGuildAgit(sNum, Body);
          ISM_LM_LOGIN: FrmSrvMsg.MsgGetLoverLogin(sNum, Body);
          ISM_LM_LOGOUT: FrmSrvMsg.MsgGetLoverLogout(sNum, Body);
          ISM_LM_LOGIN_REPLY: FrmSrvMsg.MsgGetLoverLoginReply(sNum, Body);
          ISM_LM_KILLED_MSG: FrmSrvMsg.MsgGetLoverKilledMsg(sNum, Body);
          ISM_RECALL: FrmSrvMsg.MsgGetRecall(sNum, Body);
          ISM_REQUEST_RECALL: FrmSrvMsg.MsgGetRequestRecall(sNum, Body);
          ISM_REQUEST_LOVERRECALL: FrmSrvMsg.MsgGetRequestLoverRecall(sNum, Body);
        end;
      end
      else
        Break;
    end;
    SocData := BufStr + SocData;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

procedure TFrmMsgClient.SendSocket(sMsg: string);
begin
  if MsgClient.Socket.Connected then
  begin
    MsgClient.Socket.SendText('(' + sMsg + ')');
    //MainOutMessageAPI('TFrmMsgClient.SendSocket: ' + '(' + sMsg + ')');
  end;
end;

procedure TFrmMsgClient.MsgClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  MainOutMessageAPI('连接主服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')成功...');
  SocData := '';
end;

procedure TFrmMsgClient.MsgClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmMsgClient.MsgClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  SocData := SocData + Socket.ReceiveText;
end;

procedure TFrmMsgClient.MsgClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //MainOutMessageAPI('后台服务器连接断开...');
end;

end.
