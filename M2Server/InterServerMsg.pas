unit InterServerMsg;

interface

uses
  SysUtils, Windows, Classes, Controls, Forms, ObjBase, D7ScktComp, Grobal2, Guild;

type
  TServerMsgInfo = record
    Socket: TCustomWinSocket;
    SocData: string;
  end;
  pTServerMsgInfo = ^TServerMsgInfo;

  TFrmSrvMsg = class(TForm)
    MsgServer: TServerSocket;
    procedure MsgServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure MsgServerClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure MsgServerClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure MsgServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    procedure DecodeSocStr(ps: pTServerMsgInfo);
  public
    m_PlayObject: TPlayObject;
    m_SrvArray: array[0..10 - 1] of TServerMsgInfo;
    constructor Create();
    destructor Destroy; override;
    procedure SendServerSocket(msgstr: string);
    procedure StartMsgServer();
    procedure SendSocket(Socket: TCustomWinSocket; sMsg: string);
    procedure MsgGetUserServerChange(sNum: Integer; Body: string);
    procedure MsgGetUserChangeServerRecieveOk(sNum: Integer; Body: string);
    procedure MsgGetUserLogon(sNum: Integer; Body: string);
    procedure MsgGetUserLogout(sNum: Integer; Body: string);
    procedure MsgGetWhisper(sNum: Integer; Body: string);
    procedure MsgGetGMWhisper(sNum: Integer; Body: string);
    procedure MsgGetLoverWhisper(sNum: Integer; Body: string);
    procedure MsgGetSysopMsg(sNum: Integer; Body: string);
    procedure MsgGetAddGuild(sNum: Integer; Body: string);
    procedure MsgGetDelGuild(sNum: Integer; Body: string);
    procedure MsgGetReloadGuild(sNum: Integer; Body: string);
    procedure MsgGetGuildMsg(sNum: Integer; Body: string);
    procedure MsgGetGuildWarInfo(sNum: Integer; Body: string);
    procedure MsgGetChatProhibition(sNum: Integer; Body: string);
    procedure MsgGetChatProhibitionCancel(sNum: Integer; Body: string);
    procedure MsgGetChangeCastleOwner(sNum: Integer; Body: string);
    procedure MsgGetReloadCastleAttackers(sNum: Integer);
    procedure MsgGetReloadAdmin;

    procedure MsgGetReloadChatLog;
    procedure MsgGetUserMgr(sNum: Integer; Body: string; Ident_: Integer);
    //procedure MsgGetRelationShipDelete(sNum: Integer; Body: string);

    procedure MsgGetReloadMakeItemList;

    procedure MsgGetGuildMemberRecall(sNum: Integer; Body: string);
    procedure MsgGetReloadGuildAgit(sNum: Integer; Body: string);

    procedure MsgGetLoverLogin(sNum: Integer; Body: string);
    procedure MsgGetLoverLogout(sNum: Integer; Body: string);
    procedure MsgGetLoverLoginReply(sNum: Integer; Body: string);
    procedure MsgGetLoverKilledMsg(sNum: Integer; Body: string);

    procedure MsgGetRecall(sNum: Integer; Body: string);
    procedure MsgGetRequestRecall(sNum: Integer; Body: string);
    procedure MsgGetRequestLoverRecall(sNum: Integer; Body: string);
    procedure MsgGetMarketOpen(WantOpen: Boolean);

    procedure Run();
    { Public declarations }
  end;

var
  FrmSrvMsg: TFrmSrvMsg;

implementation

uses M2Share, HUtil32, EDcode, LocalDB;

{$R *.dfm}

procedure TFrmSrvMsg.StartMsgServer;
resourcestring
  sExceptionMsg = '[Exception] TFrmSrvMsg::StartMsgServer';
begin
  try
    MsgServer.Active := False;
    MsgServer.Address := g_Config.sMsgSrvAddr;
    MsgServer.Port := g_Config.nMsgSrvPort;
    MsgServer.Active := True;
  except
    on E: Exception do
      MainOutMessageAPI(sExceptionMsg);
  end;
end;

procedure TFrmSrvMsg.DecodeSocStr(ps: pTServerMsgInfo);

  procedure SendOtherServer(msgstr: string);
  var
    i: Integer;
    ServerMsgInfo: pTServerMsgInfo;
  begin
    for i := Low(m_SrvArray) to High(m_SrvArray) do
    begin
      ServerMsgInfo := @m_SrvArray[i];
      if ServerMsgInfo.Socket <> nil then
      begin
        if ServerMsgInfo.Socket <> ps.Socket then
          SendSocket(ServerMsgInfo.Socket, msgstr);
      end;
    end;
  end;

var
  BufStr, Str, sNumStr, Head, Body: string;
  Ident, sNum: Integer;
resourcestring
  sExceptionMsg = '[Exception] TFrmSrvMsg::DecodeSocStr';
begin
  if Pos(')', ps.SocData) <= 0 then
    Exit;
  ////////////////////////////////
  //MainOutMessageAPI('TFrmSrvMsg::DecodeSocStr: ' + ps.SocData);
  try
    BufStr := ps.SocData;
    ps.SocData := '';
    while Pos(')', BufStr) > 0 do
    begin
      BufStr := ArrestStringEx(BufStr, '(', ')', Str);
      if Str <> '' then
      begin
        SendOtherServer(Str);
        Body := GetValidStr3(Str, Head, ['/']);
        Body := GetValidStr3(Body, sNumStr, ['/']);
        Ident := Str_ToInt(Head, 0);
        sNum := Str_ToInt(sNumStr, -1);
        case Ident of
          ISM_USERSERVERCHANGE: MsgGetUserServerChange(sNum, Body);
          ISM_CHANGESERVERRECIEVEOK: MsgGetUserChangeServerRecieveOk(sNum, Body);
          ISM_USERLOGON: MsgGetUserLogon(sNum, Body);
          ISM_USERLOGOUT: MsgGetUserLogout(sNum, Body);
          ISM_WHISPER: MsgGetWhisper(sNum, Body);
          ISM_GMWHISPER: MsgGetGMWhisper(sNum, Body);
          ISM_LM_WHISPER: MsgGetLoverWhisper(sNum, Body);
          ISM_SYSOPMSG: MsgGetSysopMsg(sNum, Body);
          ISM_ADDGUILD: MsgGetAddGuild(sNum, Body);
          ISM_DELGUILD: MsgGetDelGuild(sNum, Body);
          ISM_RELOADGUILD: MsgGetReloadGuild(sNum, Body);
          ISM_GUILDMSG: MsgGetGuildMsg(sNum, Body);
          ISM_GUILDWAR: MsgGetGuildWarInfo(sNum, Body);
          ISM_CHATPROHIBITION: MsgGetChatProhibition(sNum, Body);
          ISM_CHATPROHIBITIONCANCEL: MsgGetChatProhibitionCancel(sNum, Body);
          ISM_CHANGECASTLEOWNER: MsgGetChangeCastleOwner(sNum, Body);
          ISM_RELOADCASTLEINFO: MsgGetReloadCastleAttackers(sNum);
          ISM_RELOADADMIN: MsgGetReloadAdmin;
          ISM_MARKETOPEN: MsgGetMarketOpen(True);
          ISM_MARKETCLOSE: MsgGetMarketOpen(False);
          ISM_RELOADCHATLOG: MsgGetReloadChatLog;
          //ISM_LM_DELETE: MsgGetRelationShipDelete(sNum, Body);
          ISM_USER_INFO,
            ISM_FRIEND_INFO,
            ISM_FRIEND_DELETE,
            ISM_FRIEND_OPEN,
            ISM_FRIEND_CLOSE,
            ISM_FRIEND_RESULT,
            ISM_TAG_SEND,
            ISM_TAG_RESULT: MsgGetUserMgr(sNum, Body, Ident);
          ISM_RELOADMAKEITEMLIST: MsgGetReloadMakeItemList;
          ISM_GUILDMEMBER_RECALL: MsgGetGuildMemberRecall(sNum, Body);
          ISM_RELOADGUILDAGIT: MsgGetReloadGuildAgit(sNum, Body);
          ISM_LM_LOGIN: MsgGetLoverLogin(sNum, Body);
          ISM_LM_LOGOUT: MsgGetLoverLogout(sNum, Body);
          ISM_LM_LOGIN_REPLY: MsgGetLoverLoginReply(sNum, Body);
          ISM_LM_KILLED_MSG: MsgGetLoverKilledMsg(sNum, Body);
          ISM_RECALL: MsgGetRecall(sNum, Body);
          ISM_REQUEST_RECALL: MsgGetRequestRecall(sNum, Body);
          ISM_REQUEST_LOVERRECALL: MsgGetRequestLoverRecall(sNum, Body);
        end;
      end
      else
        Break;
    end;
    ps.SocData := BufStr + ps.SocData;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

procedure TFrmSrvMsg.MsgGetUserServerChange(sNum: Integer; Body: string);
var
  ufilename: string;
  i, fHandle, CheckSum, FileCheckSum: Integer;
  psui: pTSwitchDataInfo;
resourcestring
  sExceptionMsg = '[Exception] TFrmSrvMsg::MsgGetUserServerChange';
begin
  ufilename := Body;
  psui := nil;
  if g_nServerIndex = sNum then
  begin
    try
      fHandle := FileOpen(g_Config.sBaseDir + ufilename, fmOpenRead or fmShareDenyNone);
      if fHandle > 0 then
      begin
        New(psui);
        FileRead(fHandle, psui^, SizeOf(TSwitchDataInfo));
        FileRead(fHandle, FileCheckSum, SizeOf(Integer));
        FileClose(fHandle);
        DeleteFile(PChar(g_Config.sBaseDir + ufilename));
        CheckSum := 0;
        for i := 0 to SizeOf(TSwitchDataInfo) - 1 do
          CheckSum := CheckSum + pByte(Integer(psui) + i)^;
        if CheckSum = FileCheckSum then
        begin
          UserEngine.AddSwitchData(psui);
          UserEngine.SendInterMsg(ISM_CHANGESERVERRECIEVEOK, g_nServerIndex, ufilename);
          //MainOutMessageAPI('DeleteFile: ' + g_Config.sBaseDir + ufilename);
        end
        else
          Dispose(psui);
      end;
    except
      MainOutMessageAPI(sExceptionMsg);
    end;
  end;
end;

procedure TFrmSrvMsg.SendSocket(Socket: TCustomWinSocket; sMsg: string);
begin
  if Socket.Connected then
    Socket.SendText('(' + sMsg + ')');
end;

procedure TFrmSrvMsg.SendServerSocket(msgstr: string);
var
  i: Integer;
  ServerMsgInfo: pTServerMsgInfo;
begin
  for i := Low(m_SrvArray) to High(m_SrvArray) do
  begin
    ServerMsgInfo := @m_SrvArray[i];
    if ServerMsgInfo.Socket <> nil then
      SendSocket(ServerMsgInfo.Socket, msgstr);
  end;
end;

constructor TFrmSrvMsg.Create;
begin
  FillChar(m_SrvArray, SizeOf(m_SrvArray), #0);
  m_PlayObject := TPlayObject.Create;
end;

destructor TFrmSrvMsg.Destroy;
begin
  m_PlayObject.Free;
  inherited;
end;

procedure TFrmSrvMsg.MsgServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: Integer;
  ServerMsgInfo: pTServerMsgInfo;
begin
  for i := Low(m_SrvArray) to High(m_SrvArray) do
  begin
    ServerMsgInfo := @m_SrvArray[i];
    if ServerMsgInfo.Socket = nil then
    begin
      ServerMsgInfo.Socket := Socket;
      ServerMsgInfo.SocData := '';
      //Socket.Data := Pointer(i);
      Socket.nIndex := i;
      MainOutMessageAPI('连接从服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')成功...');
      Break;
    end;
  end;
end;

procedure TFrmSrvMsg.MsgServerClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  i: Integer;
  ServerMsgInfo: pTServerMsgInfo;
begin
  for i := Low(m_SrvArray) to High(m_SrvArray) do
  begin
    ServerMsgInfo := @m_SrvArray[i];
    if ServerMsgInfo.Socket = Socket then
    begin
      ServerMsgInfo.Socket := nil;
      ServerMsgInfo.SocData := '';
      MainOutMessageAPI('断开从服务器(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')成功...');
      Break;
    end;
  end;
end;

procedure TFrmSrvMsg.Run;
var
  i: Integer;
  ps: pTServerMsgInfo;
resourcestring
  sExceptionMsg = '[Exception] TFrmSrvMsg::Run';
begin
  try
    for i := Low(m_SrvArray) to High(m_SrvArray) do
    begin
      ps := @m_SrvArray[i];
      if ps.Socket <> nil then
        DecodeSocStr(ps);
    end;
  except
    MainOutMessageAPI(sExceptionMsg);
  end;
end;

procedure TFrmSrvMsg.MsgServerClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

procedure TFrmSrvMsg.MsgServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  nIndex: Integer;
begin
  nIndex := Socket.nIndex; //Integer(Socket.Data);
  if (nIndex in [0..9]) and (m_SrvArray[nIndex].Socket = Socket) then
  begin
    m_SrvArray[nIndex].SocData := m_SrvArray[nIndex].SocData + Socket.ReceiveText;
  end;
end;

procedure TFrmSrvMsg.MsgGetUserChangeServerRecieveOk(sNum: Integer; Body: string);
var
  ufilename: string;
begin
  ufilename := Body;
  //////////////////////
  //MainOutMessageAPI('TFrmSrvMsg.MsgGetUserChangeServerRecieveOk');
  UserEngine.GetISMChangeServerReceive(ufilename);
end;

procedure TFrmSrvMsg.MsgGetUserLogon(sNum: Integer; Body: string);
var
  uname: string;
begin
  uname := Body;
  UserEngine.OtherServerUserLogon(sNum, uname);
end;

procedure TFrmSrvMsg.MsgGetUserLogout(sNum: Integer; Body: string);
var
  uname: string;
begin
  uname := Body;
  UserEngine.OtherServerUserLogout(sNum, uname);
end;

procedure TFrmSrvMsg.MsgGetWhisper(sNum: Integer; Body: string);
var
   Str, uname: string;
  hum: TPlayObject;
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    hum := UserEngine.GetPlayObject(uname);
    if hum <> nil then
    begin
      if not hum.m_boHearWhisper then
        hum.WhisperRe(Str, 1);
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetGMWhisper(sNum: Integer; Body: string);
var
  Str, uname: string;
  hum: TPlayObject;
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    hum := UserEngine.GetPlayObject(uname);
    if hum <> nil then
    begin
      if not hum.m_boHearWhisper then
        hum.WhisperRe(Str, 0);
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetLoverWhisper(sNum: Integer; Body: string);
var
  Str, uname: string;
  hum: TPlayObject;
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    hum := UserEngine.GetPlayObject(uname);
    if hum <> nil then
    begin
      if not hum.m_boHearWhisper then
        hum.WhisperRe(Str, 2);
    end;
  end;
end;

{procedure TFrmSrvMsg.MsgGetRelationShipDelete(sNum: Integer; Body: string);
var
  msgstr, Str, uname, ReqType: string;
  hum                       : TPlayObject;
begin
  if sNum = g_nServerIndex then begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    Str := GetValidStr3(Str, ReqType, ['/']);
    hum := UserEngine.GetPlayObject(uname);
    if hum <> nil then begin
      hum.RelationShipDeleteOther(Str_ToInt(ReqType, 0), uname);
    end;
  end;
end;}

procedure TFrmSrvMsg.MsgGetSysopMsg(sNum: Integer; Body: string);
begin
  UserEngine.SendBroadCastMsg(Body, t_System)
end;

procedure TFrmSrvMsg.MsgGetAddGuild(sNum: Integer; Body: string);
var
  gname, mname: string;
begin
  Body := Body;
  mname := GetValidStr3(Body, gname, ['/']);
  g_GuildManager.AddGuild(gname, mname);
end;

procedure TFrmSrvMsg.MsgGetDelGuild(sNum: Integer; Body: string);
var
  gname: string;
begin
  gname := Body;
  g_GuildManager.DelGuild(gname);
end;

procedure TFrmSrvMsg.MsgGetReloadGuild(sNum: Integer; Body: string);
var
  gname: string;
  g: TGuild;
begin
  gname := Body;
  if sNum = 0 then
  begin
    g := g_GuildManager.FindGuild(gname);
    if g <> nil then
    begin
      g.LoadGuild;
      UserEngine.GuildMemberReGetRankName(g);
    end;
  end
  else if g_nServerIndex <> sNum then
  begin
    g := g_GuildManager.FindGuild(gname);
    if g <> nil then
    begin
      g.LoadGuildFile(gname + '.' + IntToStr(sNum));
      UserEngine.GuildMemberReGetRankName(g);
      g.SaveGuildInfoFile;
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetGuildMsg(sNum: Integer; Body: string);
var
  Str, gname: string;
  g: TGuild;
begin
  Str := Body;
  Str := GetValidStr3(Str, gname, ['/']);
  if (gname <> '') then
  begin
    g := g_GuildManager.FindGuild(gname);
    if g <> nil then
      g.SendGuildMsg(Str);
  end;
end;

procedure TFrmSrvMsg.MsgGetGuildWarInfo(sNum: Integer; Body: string);
var
  Str, gname, warguildname, StartTime, remaintime: string;
  g, WarGuild: TGuild;
  pgw: pTWarGuild;
  i: Integer;
  currenttick: LongWord;
begin
  if sNum = 0 then
  begin
    Str := Body;
    Str := GetValidStr3(Str, gname, ['/']);
    Str := GetValidStr3(Str, warguildname, ['/']);
    Str := GetValidStr3(Str, StartTime, ['/']);
    remaintime := Str;
    if (gname <> '') and (warguildname <> '') then
    begin
      g := g_GuildManager.FindGuild(gname);
      WarGuild := g_GuildManager.FindGuild(warguildname);
      if (g <> nil) and (WarGuild <> nil) then
      begin
        currenttick := GetTickCount;
        if g_nServerTickDifference = 0 then
          g_nServerTickDifference := StrToInt64(StartTime) - Int64(currenttick);
        pgw := nil;
        for i := 0 to g.m_GuildWarList.Count - 1 do
        begin
          //if pTWarGuild(g.m_GuildWarList.Objects[i]).Guild = WarGuild then begin
          pgw := pTWarGuild(g.m_GuildWarList.GetValues(g.m_GuildWarList.Keys[i]));
          if pgw <> nil then
          begin
            if pgw.Guild = WarGuild then
            begin
              //pgw := pTWarGuild(g.m_GuildWarList.Objects[i]);
              pgw.Guild := WarGuild;
              pgw.dwWarTick := StrToInt64(StartTime) - Int64(g_nServerTickDifference);
              pgw.dwWarTime := StrToInt64(remaintime);
              MainOutMessageAPI('[行会战] ' + g.sGuildName + '<->' + WarGuild.sGuildName + ', 开战: ' + StartTime + ', 持久: ' + remaintime + ', 现在: ' + IntToStr(pgw.dwWarTick) + ', 时差: ' + IntToStr(g_nServerTickDifference));
              Break;
            end;
          end;
        end;
        if pgw = nil then
        begin
          if not g.m_GuildWarList.Exists(WarGuild.sGuildName) then
          begin
            New(pgw);
            pgw.Guild := WarGuild;
            pgw.dwWarTick := StrToInt64(StartTime) - Int64(g_nServerTickDifference);
            pgw.dwWarTime := StrToInt64(remaintime);
            //g.m_GuildWarList.AddObject(WarGuild.sGuildName, TObject(pgw));
            g.m_GuildWarList.Put(WarGuild.sGuildName, TObject(pgw));
          end;
          MainOutMessageAPI('[行会战] ' + g.sGuildName + '<->' + WarGuild.sGuildName + ', 开战: ' + StartTime + ', 持久: ' + remaintime + ', 现在: ' + IntToStr(StrToInt64(StartTime) - Int64(g_nServerTickDifference)) + ', 时差: ' + IntToStr(g_nServerTickDifference));
        end;
        g.RefMemberName();
        g.UpdateGuildFile();
      end;
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetChatProhibition(sNum: Integer; Body: string);
var
  obtPermission: byte;
  Str, whostr, minstr: string;
begin
  Str := Body;
  Str := GetValidStr3(Str, whostr, ['/']);
  Str := GetValidStr3(Str, minstr, ['/']);
  if whostr <> '' then
  begin
    obtPermission := m_PlayObject.m_btPermission;
    m_PlayObject.m_btPermission := 10;
    m_PlayObject.CmdShutup(@g_GameCommand.SHUTUP, whostr, minstr);
    m_PlayObject.m_btPermission := obtPermission;
  end;
end;

procedure TFrmSrvMsg.MsgGetChatProhibitionCancel(sNum: Integer; Body: string);
var
  obtPermission: byte;
  whostr: string;
begin
  whostr := Body;
  if whostr <> '' then
  begin
    obtPermission := m_PlayObject.m_btPermission;
    m_PlayObject.m_btPermission := 10;
    m_PlayObject.CmdShutup(@g_GameCommand.SHUTUP, whostr, '');
    m_PlayObject.m_btPermission := obtPermission;
  end;
end;

procedure TFrmSrvMsg.MsgGetChangeCastleOwner(sNum: Integer; Body: string);
var
  obtPermission: byte;
  gldstr: string;
begin
  gldstr := Body;
  obtPermission := m_PlayObject.m_btPermission;
  m_PlayObject.m_btPermission := 10;
  m_PlayObject.CmdChangeSabukLord(@g_GameCommand.CHANGESABUKLORD, g_Config.sCASTLENAME, gldstr, False);
  m_PlayObject.m_btPermission := obtPermission;
end;

procedure TFrmSrvMsg.MsgGetReloadCastleAttackers(sNum: Integer);
begin
  g_CastleManager.Initialize;
end;

procedure TFrmSrvMsg.MsgGetReloadAdmin;
begin
  FrmDB.LoadAdminList;
end;

procedure TFrmSrvMsg.MsgGetReloadChatLog;
begin
  //FrmDB.LoadChatLogFiles;
end;

procedure TFrmSrvMsg.MsgGetUserMgr(sNum: Integer; Body: string; Ident_: Integer);
var
  UserName: string;
  msgbody: string;
  Str: string;
begin
  Str := Body;
  msgbody := GetValidStr3(Str, UserName, ['/']);
  //UserMgrEngine.OnExternInterMsg(sNum, Ident_, UserName, msgbody);
end;

procedure TFrmSrvMsg.MsgGetReloadMakeItemList;
begin
  //FrmDB.LoadMakeItemList;
end;

procedure TFrmSrvMsg.MsgGetGuildMemberRecall(sNum: Integer; Body: string);
var
  hum: TPlayObject;
  dx, dy: Integer;
  dxstr, dystr, Str, uname: string;
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    Str := GetValidStr3(Str, dxstr, ['/']);
    Str := GetValidStr3(Str, dystr, ['/']);
    dx := Str_ToInt(dxstr, 0);
    dy := Str_ToInt(dystr, 0);
    hum := UserEngine.GetPlayObject(uname);
    if hum <> nil then
    begin
      if hum.m_boAllowGuildReCall then
      begin
        hum.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
        hum.SpaceMove(Str, dx, dy, 0);
      end;
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetReloadGuildAgit(sNum: Integer; Body: string);
begin
  //GuildAgitMan.ClearGuildAgitList;
  //GuildAgitMan.LoadGuildAgitList;
end;

procedure TFrmSrvMsg.MsgGetLoverLogin(sNum: Integer; Body: string);
var
  humlover: TPlayObject;
  Str, uname, lovername: string;
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    Str := GetValidStr3(Str, lovername, ['/']);
    humlover := UserEngine.GetPlayObject(lovername);
    if humlover <> nil then
    begin
      //humlover.SysMsg(uname + '丛捞 ' + Str + '俊 甸绢坷继嚼聪促.', 6);
      //if UserEngine.FindOtherServerUser(uname, svidx) then
      //  UserEngine.SendInterMsg(ISM_LM_LOGIN_REPLY, svidx, lovername + '/' + uname + '/' + humlover.penvir.MapTitle);
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetLoverLogout(sNum: Integer; Body: string);
var
  hum: TPlayObject;
  Str, uname, lovername: string;
resourcestring
  sLoverFindYouMsg = '正在找你...';
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    lovername := Str;
    hum := UserEngine.GetPlayObject(lovername);
    if hum <> nil then
      hum.SysMsg(uname + sLoverFindYouMsg, c_Red, t_Hint);
  end;
end;

procedure TFrmSrvMsg.MsgGetLoverLoginReply(sNum: Integer; Body: string);
begin
  {if sNum = g_nServerIndex then begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    Str := GetValidStr3(Str, lovername, ['/']);
    humlover := UserEngine.GetPlayObject(lovername);
    if humlover <> nil then begin
      //humlover.SysMsg(uname + '丛捞 ' + Str + '俊 拌绞聪促.', 6);
    end;
  end; }
end;

procedure TFrmSrvMsg.MsgGetLoverKilledMsg(sNum: Integer; Body: string);
var
  hum: TPlayObject;
  Str, uname: string;
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    hum := UserEngine.GetPlayObject(uname);
    if hum <> nil then
    begin
      hum.SysMsg(Str, c_Red, t_Hint);
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetRecall(sNum: Integer; Body: string);
var
  hum: TPlayObject;
  dx, dy: Integer;
  dxstr, dystr, Str, uname: string;
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    Str := GetValidStr3(Str, dxstr, ['/']);
    Str := GetValidStr3(Str, dystr, ['/']);
    dx := Str_ToInt(dxstr, 0);
    dy := Str_ToInt(dystr, 0);
    hum := UserEngine.GetPlayObject(uname);
    if hum <> nil then
    begin
      hum.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
      hum.SpaceMove(Str, dx, dy, 0); //傍埃捞悼
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetRequestRecall(sNum: Integer; Body: string);
var
  hum: TPlayObject;
  Str, uname: string;
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    hum := UserEngine.GetPlayObject(uname);
    if hum <> nil then
    begin
      hum.RecallHuman(Str);
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetRequestLoverRecall(sNum: Integer; Body: string);
var
  hum: TPlayObject;
  Str, uname: string;
begin
  if sNum = g_nServerIndex then
  begin
    Str := Body;
    Str := GetValidStr3(Str, uname, ['/']);
    hum := UserEngine.GetPlayObject(uname);
    if hum <> nil then
    begin
      if not hum.m_PEnvir.m_MapFlag.boNORECALL then
        hum.RecallHuman(Str);
    end;
  end;
end;

procedure TFrmSrvMsg.MsgGetMarketOpen(WantOpen: Boolean);
begin
  //SQLEngine.Open(WantOpen);
end;

end.
