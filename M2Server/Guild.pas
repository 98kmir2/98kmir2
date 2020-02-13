unit Guild;

interface

uses
  Windows, SysUtils, Classes, IniFiles, ObjBase, CnHashTable;

type
  TGuildRank = record
    nRankNo: Integer;
    sRankName: string;
    MemberList: TCnHashTableSmall;
  end;
  pTGuildRank = ^TGuildRank;

  TWarGuild = record
    Guild: TObject;
    dwWarTick: LongWord;
    dwWarTime: LongWord;
  end;
  pTWarGuild = ^TWarGuild;

  TGuild = class
    sGuildName: string; //0x04
    NoticeList: TStringList; //0x08
    m_GuildWarList: TCnHashTableSmall; //0x0C
    m_GuildAllList: TCnHashTableSmall; //0x10
    m_RankList: TList; //0x14 职位列表
    m_nContestPoint: Integer; //0x18
    boTeamFight: Boolean; //0x1C;
    TeamFightDeadList: TStringList; //0x20
    m_boEnableAuthAlly: Boolean; //0x24
    dwSaveTick: LongWord; //0x28
    boChanged: Boolean; //0x2C;
    m_DynamicVarList: TList;
    m_Territory: TObject;
  private
    m_Config: TIniFile;
    m_nBuildPoint: Integer; //建筑度
    m_nAurae: Integer; //人气度
    m_nStability: Integer; //安定度
    m_nFlourishing: Integer; //繁荣度
    m_nChiefItemCount: Integer; //行会领取装备数量
    function SetGuildInfo(sChief: string): Boolean;
    procedure ClearRank();
    procedure SaveGuildFile(sFileName: string);
    procedure SaveGuildConfig(sFileName: string);
    function GetMemberCount(): Integer;
    function GetMemgerIsFull(): Boolean;
    procedure SetAuraePoint(nPoint: Integer);
    procedure SetBuildPoint(nPoint: Integer);
    procedure SetStabilityPoint(nPoint: Integer);
    procedure SetFlourishPoint(nPoint: Integer);
    procedure SetChiefItemCount(nPoint: Integer);
  public
    constructor Create(sName: string);
    destructor Destroy; override;
    procedure SaveGuildInfoFile();
    function LoadGuild(): Boolean;
    function LoadGuildFile(sGuildFileName: string): Boolean;
    function LoadGuildConfig(sGuildFileName: string): Boolean;
    procedure UpdateGuildFile;
    procedure CheckSaveGuildFile;
    function IsMember(sName: string): Boolean;
    function IsAllyGuild(Guild: TGuild): Boolean;
    function IsWarGuild(Guild: TGuild): Boolean;
    function DelAllyGuild(Guild: TGuild): Boolean;
    procedure TeamFightWhoDead(sName: string);
    procedure TeamFightWhoWinPoint(sName: string; nPoint: Integer);
    procedure SendGuildMsg(sMsg: string; nColor: Integer = 0; fc: Integer = -1; bc: Integer = -1; sec: Integer = 0);
    procedure RefMemberName();
    function GetRankName(PlayObject: TPlayObject; var nRankNo: Integer): string;
    function DelMember(sHumName: string): Boolean;
    function UpdateRank(sRankData: string): Integer;
    function CancelGuld(sHumName: string): Boolean;
    function IsNotWarGuild(Guild: TGuild): Boolean;
    function AllyGuild(Guild: TGuild): Boolean;
    function AddMember(PlayObject: TPlayObject): Boolean;
    procedure DelHumanObj(PlayObject: TPlayObject);
    function GetChiefName(): string;
    procedure BackupGuildFile();
    procedure sub_499B4C(Guild: TGuild);
    function AddWarGuild(Guild: TGuild): pTWarGuild;
    procedure StartTeamFight();
    procedure EndTeamFight();
    procedure AddTeamFightMember(sHumanName: string);
    property Count: Integer read GetMemberCount;
    property IsFull: Boolean read GetMemgerIsFull;
    property nBuildPoint: Integer read m_nBuildPoint write SetBuildPoint;
    property nAurae: Integer read m_nAurae write SetAuraePoint;
    property nStability: Integer read m_nStability write SetStabilityPoint;
    property nFlourishing: Integer read m_nFlourishing write SetFlourishPoint;
    property nChiefItemCount: Integer read m_nChiefItemCount write SetChiefItemCount;
  end;

  TGuildManager = class
    GuildList: TCnHashTableSmall; //TList;
  public
    constructor Create();
    destructor Destroy; override;
    procedure LoadGuildInfo();
    procedure SaveGuildList();
    function MemberOfGuild(sName: string): TGuild;
    function AddGuild(sGuildName, sChief: string): Boolean;
    function FindGuild(sGuildName: string): TGuild;
    function DelGuild(sGuildName: string): Boolean;
    procedure ClearGuildInf();
    procedure Run();
  end;

implementation

uses M2Share, HUtil32, Grobal2;

{ TGuildManager }

function TGuildManager.AddGuild(sGuildName, sChief: string): Boolean;
var
  Guild: TGuild;
begin
  Result := False;
  if CheckGuildName(sGuildName) and (FindGuild(sGuildName) = nil) then
  begin
    Guild := TGuild.Create(sGuildName);
    Guild.SetGuildInfo(sChief);
    //GuildList.Add(Guild);
    GuildList.Put(sGuildName, Guild);
    SaveGuildList();
    Result := True;
  end;
end;

function TGuildManager.DelGuild(sGuildName: string): Boolean;
var
  i: Integer;
  Guild: TGuild;
begin
  Result := False;
  i := GuildList.ExistsPos(sGuildName);
  if i >= 0 then
  begin
    Guild := TGuild(GuildList.Values[GuildList.Keys[i]]);
    if Guild.m_RankList.Count <= 1 then
    begin
      Guild.BackupGuildFile();
      GuildList.Delete(GuildList.Keys[i]);
      SaveGuildList();
      Result := True;
    end;
  end;

  {for i := 0 to GuildList.Count - 1 do begin
    Guild := TGuild(GuildList.Items[i]);
    if CompareText(Guild.sGuildName, sGuildName) = 0 then begin
      if Guild.m_RankList.Count > 1 then
        Break;
      Guild.BackupGuildFile();
      GuildList.Delete(i);
      SaveGuildList();
      Result := True;
      Break;
    end;
  end;}
end;

procedure TGuildManager.ClearGuildInf;
var
  i: Integer;
begin
  for i := 0 to GuildList.Count - 1 do
    TGuild(GuildList.Values[GuildList.Keys[i]]).Free;
  GuildList.Clear;
end;

constructor TGuildManager.Create;
begin
  GuildList := TCnHashTableSmall.Create; //TList.Create;
end;

destructor TGuildManager.Destroy;
begin
  ClearGuildInf;
  GuildList.Free;
  inherited;
end;

function TGuildManager.FindGuild(sGuildName: string): TGuild;
begin
  Result := TGuild(GuildList.GetValues(sGuildName));

  {Result := nil;
  for i := 0 to GuildList.Count - 1 do begin
    if TGuild(GuildList.Items[i]).sGuildName = sGuildName then begin
      Result := TGuild(GuildList.Items[i]);
      Break;
    end;
  end;}
end;

procedure TGuildManager.LoadGuildInfo;
var
  LoadList: TStringList;
  Guild: TGuild;
  sGuildName: string;
  i: Integer;
begin
  if FileExists(g_Config.sGuildFile) then
  begin

    LoadList := TStringList.Create;
    LoadList.LoadFromFile(g_Config.sGuildFile);
    for i := 0 to LoadList.Count - 1 do
    begin
      sGuildName := Trim(LoadList.Strings[i]);
      if sGuildName <> '' then
      begin
        Guild := TGuild.Create(sGuildName);
        //GuildList.Add(Guild);
        GuildList.Add(sGuildName, TGuild(Guild));
      end;
    end;
    LoadList.Free;

    for i := GuildList.Count - 1 downto 0 do
    begin
      //Guild := GuildList.Items[i];
      Guild := TGuild(GuildList.Values[GuildList.Keys[i]]);
      if not Guild.LoadGuild() then
      begin
        MainOutMessageAPI(Guild.sGuildName + ' 读取出错');
        Guild.Free;
        GuildList.Delete(GuildList.Keys[i]);
        SaveGuildList();
      end;
    end;
    MainOutMessageAPI('已读取 ' + IntToStr(GuildList.Count) + '个行会信息...');
  end
  else
    MainOutMessageAPI('行会信息文件未找到');
end;

function TGuildManager.MemberOfGuild(sName: string): TGuild;
var
  i: Integer;
  Guild: TGuild;
begin
  Result := nil;
  for i := 0 to GuildList.Count - 1 do
  begin
    Guild := TGuild(GuildList.Values[GuildList.Keys[i]]);
    if Guild.IsMember(sName) then
    begin
      //if TGuild(GuildList.Items[i]).IsMember(sName) then begin
      Result := Guild;
      Break;
    end;
  end;
end;

procedure TGuildManager.SaveGuildList;
var
  i: Integer;
  SaveList: TStringList;
begin
  if g_nServerIndex <> 0 then
    Exit;
  SaveList := TStringList.Create;
  for i := 0 to GuildList.Count - 1 do
    //SaveList.Add(TGuild(GuildList.Items[i]).sGuildName);
    SaveList.Add(GuildList.Keys[i]);
  try
    SaveList.SaveToFile(g_Config.sGuildFile);
  except
    MainOutMessageAPI('行会信息保存失败');
  end;
  SaveList.Free;
end;

procedure TGuildManager.Run;
var
  i: Integer;
  ii: Integer;
  Guild: TGuild;
  boChanged: Boolean;
  WarGuild: pTWarGuild;
begin
  for i := 0 to GuildList.Count - 1 do
  begin
    //Guild := TGuild(GuildList.Items[i]);
    Guild := TGuild(GuildList.Values[GuildList.Keys[i]]);
    boChanged := False;
    for ii := Guild.m_GuildWarList.Count - 1 downto 0 do
    begin
      //WarGuild := pTWarGuild(Guild.m_GuildWarList.Objects[ii]);
      WarGuild := pTWarGuild(Guild.m_GuildWarList.Values[Guild.m_GuildWarList.Keys[ii]]);
      if (GetTickCount - WarGuild.dwWarTick) > WarGuild.dwWarTime then
      begin
        Guild.sub_499B4C(TGuild(WarGuild.Guild));
        //Guild.m_GuildWarList.Delete(ii);
        Guild.m_GuildWarList.Delete(Guild.m_GuildWarList.Keys[ii]);
        Dispose(WarGuild);
        boChanged := True;
        Break; //0626
      end;
    end;
    if boChanged then
      Guild.UpdateGuildFile();
    Guild.CheckSaveGuildFile;
  end;
end;

{ TGuild }

procedure TGuild.ClearRank;
var
  i: Integer;
  GuildRank: pTGuildRank;
begin
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    GuildRank.MemberList.Free;
    Dispose(GuildRank);
  end;
  m_RankList.Clear;
end;

constructor TGuild.Create(sName: string);
var
  sFileName: string;
begin
  sGuildName := sName;
  NoticeList := TStringList.Create;
  m_GuildWarList := TCnHashTableSmall.Create;
  m_GuildAllList := TCnHashTableSmall.Create;
  m_RankList := TList.Create;
  TeamFightDeadList := TStringList.Create;
  dwSaveTick := 0;
  boChanged := False;
  m_nContestPoint := 0;
  boTeamFight := False;
  m_boEnableAuthAlly := False;
  sFileName := g_Config.sGuildDir + sName + '.ini';
  m_Config := TIniFile.Create(sFileName);
  if not FileExists(sFileName) then
    m_Config.WriteString('Guild', 'GuildName', sName);
  m_nBuildPoint := 0;
  m_nAurae := 0;
  m_nStability := 0;
  m_nFlourishing := 0;
  m_nChiefItemCount := 0;
  m_DynamicVarList := TList.Create;
  //m_Territory := g_GuildTerritory.FindGuildTerritory(sGuildName);
end;

function TGuild.DelAllyGuild(Guild: TGuild): Boolean;
var
  i: Integer;
begin
  Result := False;
  if Guild = nil then
    Exit;
  i := m_GuildAllList.ExistsPos(Guild.sGuildName);
  if i >= 0 then
  begin
    Result := True;
    m_GuildAllList.Delete(m_GuildAllList.Keys[i]);
    SaveGuildInfoFile();
  end;
  {for i := 0 to m_GuildAllList.Count - 1 do begin
    AllyGuild := TGuild(m_GuildAllList.Objects[i]);
    if AllyGuild = Guild then begin
      m_GuildAllList.Delete(i);
      Result := True;
      Break;
    end;
  end;
  SaveGuildInfoFile();}
end;

destructor TGuild.Destroy;
var
  i: Integer;
begin
  NoticeList.Free;
  m_GuildWarList.Free;
  m_GuildAllList.Free;
  ClearRank();
  m_RankList.Free;
  TeamFightDeadList.Free;
  m_Config.Free;
  for i := 0 to m_DynamicVarList.Count - 1 do
    Dispose(pTDynamicVar(m_DynamicVarList.Items[i]));
  m_DynamicVarList.Free;
  inherited;
end;

function TGuild.IsAllyGuild(Guild: TGuild): Boolean;
begin
  Result := (Guild <> nil) and m_GuildAllList.Exists(Guild.sGuildName);
  {Result := False;
  for i := 0 to GuildAllList.Count - 1 do begin
    AllyGuild := TGuild(GuildAllList.Objects[i]);
    if AllyGuild = Guild then begin
      Result := True;
      Break;
    end;
  end;}
end;

function TGuild.IsMember(sName: string): Boolean;
var
  i: Integer;
  GuildRank: pTGuildRank;
begin
  Result := False;
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    if GuildRank.MemberList.Exists(sName) then
    begin
      Result := True;
      Exit;
    end;
    {for ii := 0 to GuildRank.MemberList.Count - 1 do begin
      if GuildRank.MemberList.Strings[ii] = sName then begin
        Result := True;
        Exit;
      end;
    end;}
  end;
end;

function TGuild.IsWarGuild(Guild: TGuild): Boolean;
begin
  Result := (Guild <> nil) and m_GuildWarList.Exists(Guild.sGuildName);
  {Result := False;
  for i := 0 to m_GuildWarList.Count - 1 do begin
    if pTWarGuild(m_GuildWarList.Objects[i]).Guild = Guild then begin
      Result := True;
      Break;
    end;
  end;}
end;

function TGuild.LoadGuild(): Boolean;
var
  sFileName: string;
begin
  sFileName := sGuildName + '.txt';
  Result := LoadGuildFile(sFileName);
  LoadGuildConfig(sGuildName + '.ini');
end;

function TGuild.LoadGuildConfig(sGuildFileName: string): Boolean;
begin
  m_nBuildPoint := m_Config.ReadInteger('Guild', 'BuildPoint', m_nBuildPoint);
  m_nAurae := m_Config.ReadInteger('Guild', 'Aurae', m_nAurae);
  m_nStability := m_Config.ReadInteger('Guild', 'Stability', m_nStability);
  m_nFlourishing := m_Config.ReadInteger('Guild', 'Flourishing', m_nFlourishing);
  m_nChiefItemCount := m_Config.ReadInteger('Guild', 'ChiefItemCount', m_nChiefItemCount);
  Result := True;
end;

function TGuild.LoadGuildFile(sGuildFileName: string): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  s18, s1C, s20, s24, sFileName: string;
  n28, n2C: Integer;
  GuildWar: pTWarGuild;
  GuildRank: pTGuildRank;
  Guild: TGuild;
begin
  Result := False;
  GuildRank := nil;
  sFileName := g_Config.sGuildDir + sGuildFileName;
  if not FileExists(sFileName) then
    Exit;
  ClearRank();
  NoticeList.Clear;
  for i := 0 to m_GuildWarList.Count - 1 do
    Dispose(pTWarGuild(m_GuildWarList.Values[m_GuildWarList.Keys[i]]));
  //Dispose(pTWarGuild(m_GuildWarList.Objects[i]));
  m_GuildWarList.Clear;
  m_GuildAllList.Clear;
  n28 := 0;
  n2C := 0;
  s24 := '';
  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sFileName);
  for i := 0 to LoadList.Count - 1 do
  begin
    s18 := LoadList.Strings[i];
    if (s18 = '') or (s18[1] = ';') then
      Continue;
    if s18[1] <> '+' then
    begin
      if s18 = g_Config.sGuildNotice then
        n28 := 1;
      if s18 = g_Config.sGuildWar then
        n28 := 2;
      if s18 = g_Config.sGuildAll then
        n28 := 3;
      if s18 = g_Config.sGuildMember then
        n28 := 4;
      if s18[1] = '#' then
      begin
        s18 := Copy(s18, 2, Length(s18) - 1);
        s18 := GetValidStr3(s18, s1C, [' ', ',']);
        n2C := Str_ToInt(s1C, 0);
        s24 := Trim(s18);
        GuildRank := nil;
      end;
      Continue;
    end; //00497F68
    s18 := Copy(s18, 2, Length(s18) - 1);
    case n28 of //
      1: NoticeList.Add(s18);
      2:
        begin
          while (s18 <> '') do
          begin
            s18 := GetValidStr3(s18, s1C, [' ', ',']);
            if s1C = '' then
              Break;
            if not m_GuildWarList.Exists(s1C) then
            begin
              New(GuildWar);
              GuildWar.Guild := g_GuildManager.FindGuild(s1C);
              if GuildWar.Guild <> nil then
              begin
                GuildWar.dwWarTick := GetTickCount();
                GuildWar.dwWarTime := Str_ToInt(Trim(s20), 0);
                m_GuildWarList.Put(TGuild(GuildWar.Guild).sGuildName, TObject(GuildWar));
              end
              else
              begin
                Dispose(GuildWar);
              end;
            end;

          end;
        end;
      3:
        begin
          while (s18 <> '') do
          begin
            s18 := GetValidStr3(s18, s1C, [' ', ',']);
            s18 := GetValidStr3(s18, s20, [' ', ',']);
            if s1C = '' then
              Break;
            if not m_GuildAllList.Exists(s1C) then
            begin
              Guild := g_GuildManager.FindGuild(s1C);
              if Guild <> nil then
                m_GuildAllList.Put(s1C, Guild);
            end;
            //m_GuildAllList.AddObject(s1C, Guild);
          end;
        end;
      4:
        begin
          if (n2C > 0) and (s24 <> '') then
          begin
            if Length(s24) > 30 then
              s24 := Copy(s24, 1, g_Config.nGuildRankNameLen {30});

            if GuildRank = nil then
            begin
              New(GuildRank);
              GuildRank.nRankNo := n2C;
              GuildRank.sRankName := s24;
              GuildRank.MemberList := TCnHashTableSmall.Create;
              m_RankList.Add(GuildRank);
            end;
            while (s18 <> '') do
            begin
              s18 := GetValidStr3(s18, s1C, [' ', ',']);
              if s1C = '' then
                Break;
              if not GuildRank.MemberList.Exists(s1C) then
                GuildRank.MemberList.Put(s1C, nil);
            end;
          end;
        end;
    end;
  end;
  LoadList.Free;
  Result := True;
end;

procedure TGuild.RefMemberName;
var
  i, ii: Integer;
  GuildRank: pTGuildRank;
  BaseObject: TBaseObject;
begin
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    for ii := 0 to GuildRank.MemberList.Count - 1 do
    begin
      //BaseObject := TBaseObject(GuildRank.MemberList.Objects[ii]);
      BaseObject := TBaseObject(GuildRank.MemberList.GetValues(GuildRank.MemberList.Keys[ii]));
      if BaseObject <> nil then
        BaseObject.RefShowName;
    end;
  end;
end;

procedure TGuild.SaveGuildInfoFile;
begin
  if g_nServerIndex = 0 then
  begin
    SaveGuildFile(g_Config.sGuildDir + sGuildName + '.txt');
    SaveGuildConfig(g_Config.sGuildDir + sGuildName + '.ini');
  end
  else
  begin
    SaveGuildFile(g_Config.sGuildDir + sGuildName + '.' + IntToStr(g_nServerIndex));
    //SaveGuildConfig(g_Config.sGuildDir + sGuildName + '.' + IntToStr(g_nServerIndex));
  end;
end;

procedure TGuild.SaveGuildConfig(sFileName: string);
begin
  m_Config.WriteString('Guild', 'GuildName', sGuildName);
  m_Config.WriteInteger('Guild', 'BuildPoint', m_nBuildPoint);
  m_Config.WriteInteger('Guild', 'Aurae', m_nAurae);
  m_Config.WriteInteger('Guild', 'Stability', m_nStability);
  m_Config.WriteInteger('Guild', 'Flourishing', m_nFlourishing);
  m_Config.WriteInteger('Guild', 'ChiefItemCount', m_nChiefItemCount);
end;

procedure TGuild.SaveGuildFile(sFileName: string);
var
  SaveList: TStringList;
  i, ii: Integer;
  WarGuild: pTWarGuild;
  GuildRank: pTGuildRank;
  n14: Integer;
begin
  SaveList := TStringList.Create;
  SaveList.Add(g_Config.sGuildNotice);
  for i := 0 to NoticeList.Count - 1 do
  begin
    SaveList.Add('+' + NoticeList.Strings[i]);
  end;
  SaveList.Add(' ');
  SaveList.Add(g_Config.sGuildWar);
  for i := 0 to m_GuildWarList.Count - 1 do
  begin
    //WarGuild := pTWarGuild(m_GuildWarList.Objects[i]);
    WarGuild := pTWarGuild(m_GuildWarList.Values[m_GuildWarList.Keys[i]]);
    n14 := WarGuild.dwWarTime - (GetTickCount - WarGuild.dwWarTick);
    if n14 <= 0 then
      Continue;
    SaveList.Add('+' + m_GuildWarList.Keys[i] + ' ' + IntToStr(n14));
  end;
  SaveList.Add(' ');
  SaveList.Add(g_Config.sGuildAll);
  for i := 0 to m_GuildAllList.Count - 1 do
  begin
    SaveList.Add('+' + m_GuildAllList.Keys[i]);
  end;
  SaveList.Add(' ');
  SaveList.Add(g_Config.sGuildMember);
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    SaveList.Add('#' + IntToStr(GuildRank.nRankNo) + ' ' + GuildRank.sRankName);
    for ii := 0 to GuildRank.MemberList.Count - 1 do
    begin
      //SaveList.Add('+' + GuildRank.MemberList.Strings[ii]);
      SaveList.Add('+' + GuildRank.MemberList.Keys[ii]);
    end;
  end;
  try
    SaveList.SaveToFile(sFileName);
  except
    MainOutMessageAPI('保存行会信息失败！ ' + sFileName);
  end;
  SaveList.Free;
end;

procedure TGuild.SendGuildMsg(sMsg: string; nColor, fc, bc, sec: Integer); //???
var
  i: Integer;
  ii: Integer;
  GuildRank: pTGuildRank;
  BaseObject: TBaseObject;
begin
  //try
  if g_Config.boViewWhisper then
    MainOutMessageAPI(Format('[行会] %s', [sMsg]));
  if g_Config.boShowPreFixMsg then
    sMsg := g_Config.sGuildMsgPreFix + sMsg;
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    for ii := 0 to GuildRank.MemberList.Count - 1 do
    begin
      //BaseObject := TBaseObject(GuildRank.MemberList.Objects[ii]);
      BaseObject := TBaseObject(GuildRank.MemberList.Values[GuildRank.MemberList.Keys[ii]]);
      if (BaseObject = nil) or BaseObject.m_boGhost or ((BaseObject.m_btRaceServer = RC_PLAYOBJECT) and TPlayObject(BaseObject).m_boOffLineFlag) then //0710
        Continue;
      if BaseObject.m_boBanGuildChat then
      begin
        case nColor of
          1: BaseObject.SendMsg(BaseObject, RM_GUILDMESSAGE, 0, g_Config.btGreenMsgFColor, g_Config.btGreenMsgBColor, sec, sMsg);
          2: BaseObject.SendMsg(BaseObject, RM_GUILDMESSAGE, 0, g_Config.btBlueMsgFColor, g_Config.btBlueMsgBColor, sec, sMsg);
          3: BaseObject.SendMsg(BaseObject, RM_GUILDMESSAGE, 0, g_Config.btRedMsgFColor, g_Config.btRedMsgBColor, sec, sMsg);
          4: if fc >= 0 then
              BaseObject.SendMsg(BaseObject, RM_GUILDMESSAGE, 0, fc, bc, sec, sMsg)
            else
              BaseObject.SendMsg(BaseObject, RM_GUILDMESSAGE, 0, g_Config.btGuildMsgFColor, g_Config.btGuildMsgBColor, sec, sMsg);
        else
          BaseObject.SendMsg(BaseObject, RM_GUILDMESSAGE, 0, g_Config.btGuildMsgFColor, g_Config.btGuildMsgBColor, sec, sMsg);
        end;
      end;
    end;
  end;
  {except
    on E: Exception do begin
      MainOutMessageAPI('[Exceptiion] TGuild.SendGuildMsg CheckCode: ' + IntToStr(123) + ' GuildName = ' + sGuildName + ' Msg = ' + sMsg);
      MainOutMessageAPI(E.Message);
    end;
  end;}
end;

function TGuild.SetGuildInfo(sChief: string): Boolean; //00498984
var
  GuildRank: pTGuildRank;
begin
  if m_RankList.Count = 0 then
  begin
    New(GuildRank);
    GuildRank.nRankNo := 1;
    GuildRank.sRankName := g_Config.sGuildChief;
    GuildRank.MemberList := TCnHashTableSmall.Create;
    GuildRank.MemberList.Put(sChief, nil);
    m_RankList.Add(GuildRank);
    SaveGuildInfoFile();
  end;
  Result := True;
end;

function TGuild.GetRankName(PlayObject: TPlayObject; var nRankNo: Integer): string;
var
  i, ii: Integer;
  GuildRank: pTGuildRank;
begin
  Result := '';
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    ii := GuildRank.MemberList.ExistsPos(PlayObject.m_sCharName);
    if ii > -1 then
    begin
      GuildRank.MemberList.Values[GuildRank.MemberList.Keys[ii]] := PlayObject;
      nRankNo := GuildRank.nRankNo;
      Result := GuildRank.sRankName;
      //PlayObject.RefShowName();
      PlayObject.SendMsg(PlayObject, RM_CHANGEGUILDNAME, 0, 0, 0, 0, '');
      Exit;
    end;
    {for ii := 0 to GuildRank.MemberList.Count - 1 do begin
      if GuildRank.MemberList.Strings[ii] = PlayObject.m_sCharName then begin
        GuildRank.MemberList.Objects[ii] := PlayObject;
        nRankNo := GuildRank.nRankNo;
        Result := GuildRank.sRankName;
        //PlayObject.RefShowName();
        PlayObject.SendMsg(PlayObject, RM_CHANGEGUILDNAME, 0, 0, 0, 0, '');
        Exit;
      end;
    end;}
  end;
end;

function TGuild.GetChiefName: string; //00498928
var
  GuildRank: pTGuildRank;
begin
  Result := '';
  if m_RankList.Count <= 0 then
    Exit;
  GuildRank := m_RankList.Items[0];
  if GuildRank.MemberList.Count <= 0 then
    Exit;
  //Result := GuildRank.MemberList.Strings[0];
  Result := GuildRank.MemberList.Keys[0];
end;

procedure TGuild.CheckSaveGuildFile();
begin
  if boChanged and ((GetTickCount - dwSaveTick) > 30 * 1000) then
  begin
    boChanged := False;
    SaveGuildInfoFile();
  end;
end;

procedure TGuild.DelHumanObj(PlayObject: TPlayObject); //00498ECC
var
  i, ii: Integer;
  GuildRank: pTGuildRank;
begin
  CheckSaveGuildFile();
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    ii := GuildRank.MemberList.ExistsPos(PlayObject.m_sCharName);
    if ii > -1 then
    begin
      GuildRank.MemberList.Values[GuildRank.MemberList.Keys[ii]] := nil;
      Exit;
    end;

    {for ii := 0 to GuildRank.MemberList.Count - 1 do begin
      if TPlayObject(GuildRank.MemberList.Objects[ii]) = PlayObject then begin
        GuildRank.MemberList.Objects[ii] := nil;
        Exit;
      end;
    end;}
  end;
end;

procedure TGuild.TeamFightWhoDead(sName: string); //00499EC8
var
  i, n10: Integer;
begin
  if not boTeamFight then
    Exit;
  for i := 0 to TeamFightDeadList.Count - 1 do
  begin
    if TeamFightDeadList.Strings[i] = sName then
    begin
      n10 := Integer(TeamFightDeadList.Objects[i]);
      TeamFightDeadList.Objects[i] := TObject(MakeLong(LoWord(n10) + 1,
        HiWord(n10)));
    end;
  end;
end;

procedure TGuild.TeamFightWhoWinPoint(sName: string; nPoint: Integer); //00499DE4
var
  i, n14: Integer;
begin
  if not boTeamFight then
    Exit;
  Inc(m_nContestPoint, nPoint);
  for i := 0 to TeamFightDeadList.Count - 1 do
  begin
    if TeamFightDeadList.Strings[i] = sName then
    begin
      n14 := Integer(TeamFightDeadList.Objects[i]);
      TeamFightDeadList.Objects[i] := TObject(MakeLong(LoWord(n14), HiWord(n14) + nPoint));
    end;
  end;
end;

procedure TGuild.UpdateGuildFile();
begin
  boChanged := True;
  dwSaveTick := GetTickCount();
  SaveGuildInfoFile();
end;

procedure TGuild.BackupGuildFile;
var
  i, ii: Integer;
  PlayObject: TPlayObject;
  GuildRank: pTGuildRank;
begin
  if g_nServerIndex = 0 then
    SaveGuildFile(g_Config.sGuildDir + sGuildName + '.' + IntToStr(GetTickCount) + '.bak');
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    for ii := 0 to GuildRank.MemberList.Count - 1 do
    begin
      PlayObject := TPlayObject(GuildRank.MemberList.Values[GuildRank.MemberList.Keys[ii]]);
      if PlayObject <> nil then
      begin
        PlayObject.m_MyGuild := nil;
        PlayObject.RefRankInfo(0, '');
        PlayObject.RefShowName();
      end;
    end;
    GuildRank.MemberList.Free;
    Dispose(GuildRank);
  end;
  m_RankList.Clear;
  NoticeList.Clear;
  for i := 0 to m_GuildWarList.Count - 1 do
  begin
    Dispose(pTWarGuild(m_GuildWarList.Values[m_GuildWarList.Keys[i]]));
  end;
  m_GuildWarList.Clear;
  m_GuildAllList.Clear;
  SaveGuildInfoFile();
end;

function TGuild.AddMember(PlayObject: TPlayObject): Boolean; //00498CA8
var
  i: Integer;
  GuildRank: pTGuildRank;
  GuildRank18: pTGuildRank;
  nRankNo: Integer;
begin
  Result := False;
  if IsFull {or (g_Config.nRegCheckCode <= 0)} then
    Exit;
  nRankNo := 99;
  GuildRank18 := nil;
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    if GuildRank.nRankNo = nRankNo then
    begin
      GuildRank18 := GuildRank;
      Break;
    end;
  end;
  if GuildRank18 = nil then
  begin
    New(GuildRank18);
    GuildRank18.nRankNo := nRankNo;
    GuildRank18.sRankName := g_Config.sGuildMemberRank;
    GuildRank18.MemberList := TCnHashTableSmall.Create;
    m_RankList.Add(GuildRank18);
  end;
  //GuildRank18.MemberList.AddObject(PlayObject.m_sCharName, TObject(PlayObject));
  if not GuildRank18.MemberList.Exists(PlayObject.m_sCharName) then
    GuildRank18.MemberList.Put(PlayObject.m_sCharName, TObject(PlayObject));
  UpdateGuildFile();
  Result := True;
end;

function TGuild.DelMember(sHumName: string): Boolean; //00498DCC
var
  i, ii: Integer;
  GuildRank: pTGuildRank;
begin
  Result := False;
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    ii := GuildRank.MemberList.ExistsPos(sHumName);
    if ii >= 0 then
    begin
      GuildRank.MemberList.Delete(GuildRank.MemberList.Keys[ii]);
      Result := True;
      Break;
    end;

    {for ii := 0 to GuildRank.MemberList.Count - 1 do begin
      if GuildRank.MemberList.Strings[ii] = sHumName then begin
        GuildRank.MemberList.Delete(ii);
        Result := True;
        Break;
      end;
    end;
    if Result then
      Break;}
  end;
  if Result then
    UpdateGuildFile;
end;

function TGuild.CancelGuld(sHumName: string): Boolean; //00498A50
var
  GuildRank: pTGuildRank;
begin
  Result := False;
  if m_RankList.Count <> 1 then
    Exit;
  GuildRank := m_RankList.Items[0];
  if GuildRank.MemberList.Count <> 1 then
    Exit;
  if GuildRank.MemberList.Keys[0] = sHumName then
  begin
    BackupGuildFile();
    Result := True;
  end;
  {if GuildRank.MemberList.Strings[0] = sHumName then begin
    BackupGuildFile();
    Result := True;
  end;}
end;

function TGuild.UpdateRank(sRankData: string): Integer; //00499140

  procedure ClearRankList(var RankList: TList); //004990DC
  var
    i: Integer;
    GuildRank: pTGuildRank;
  begin
    for i := 0 to RankList.Count - 1 do
    begin
      GuildRank := RankList.Items[i];
      GuildRank.MemberList.Free;
      Dispose(GuildRank);
    end;
    RankList.Free;
  end;

var
  i: Integer;
  ii: Integer;
  III: Integer;
  GuildRankList: TList;
  GuildRank: pTGuildRank;
  NewGuildRank: pTGuildRank;
  sRankInfo: string;
  sRankNo: string;
  sRankName: string;
  sMemberName: string;
  n28: Integer;
  n2C: Integer;
  n30: Integer;
  boCheckChange: Boolean;
  PlayObject: TPlayObject;
begin
  GuildRankList := TList.Create;
  GuildRank := nil;
  while (True) do
  begin
    if sRankData = '' then
      Break;
    sRankData := GetValidStr3(sRankData, sRankInfo, [#13]);
    sRankInfo := Trim(sRankInfo);
    if sRankInfo = '' then
      Continue;
    if sRankInfo[1] = '#' then
    begin
      sRankInfo := Copy(sRankInfo, 2, Length(sRankInfo) - 1);
      sRankInfo := GetValidStr3(sRankInfo, sRankNo, [' ', '<']);
      sRankInfo := GetValidStr3(sRankInfo, sRankName, ['<', '>']);
      if Length(sRankName) > 30 then
        sRankName := Copy(sRankName, 1, 30);
      if IsInGuildRankNameFilterList(sRankName) then
      begin
        Result := -15;
        Exit;
      end;
      if GuildRank <> nil then
        GuildRankList.Add(GuildRank);
      New(GuildRank);
      GuildRank.nRankNo := Str_ToInt(sRankNo, 99);
      GuildRank.sRankName := Trim(sRankName);
      GuildRank.MemberList := TCnHashTableSmall.Create;
      Continue;
    end;

    if GuildRank = nil then
      Continue;
    i := 0;
    while (True) do
    begin
      if sRankInfo = '' then
        Break;
      sRankInfo := GetValidStr3(sRankInfo, sMemberName, [' ', ',']);
      if (sMemberName <> '') {and not GuildRank.MemberList.Exists(sMemberName)} then //0710
        GuildRank.MemberList.Put(sMemberName, nil);
      //GuildRank.MemberList.Add(sMemberName);
      Inc(i);
      if i >= 10 then
        Break;
    end;
  end;

  if GuildRank <> nil then
  begin
    GuildRankList.Add(GuildRank);
  end;

  if m_RankList.Count = GuildRankList.Count then
  begin
    boCheckChange := True;
    for i := 0 to m_RankList.Count - 1 do
    begin
      GuildRank := m_RankList.Items[i];
      NewGuildRank := GuildRankList.Items[i];
      if (GuildRank.nRankNo = NewGuildRank.nRankNo) and
        (GuildRank.sRankName = NewGuildRank.sRankName) and
        (GuildRank.MemberList.Count = NewGuildRank.MemberList.Count) then
      begin
        for ii := 0 to GuildRank.MemberList.Count - 1 do
        begin
          if GuildRank.MemberList.Keys[ii] <> NewGuildRank.MemberList.Keys[ii] then
          begin
            boCheckChange := False;
            Break;
          end;
        end;
      end
      else
      begin
        boCheckChange := False;
        Break;
      end;
    end;
    if boCheckChange then
    begin
      Result := -1;
      ClearRankList(GuildRankList);
      Exit;
    end;
  end;

  Result := -2;
  if (GuildRankList.Count > 0) then
  begin
    GuildRank := GuildRankList.Items[0];
    if GuildRank.nRankNo = 1 then
    begin
      if GuildRank.sRankName <> '' then
      begin
        Result := 0;
      end
      else
        Result := -3;
    end;
  end;

  if Result = 0 then
  begin
    GuildRank := GuildRankList.Items[0];
    if GuildRank.MemberList.Count <= 2 then
    begin
      n28 := GuildRank.MemberList.Count;
      for i := 0 to GuildRank.MemberList.Count - 1 do
      begin
        if UserEngine.GetPlayObject(GuildRank.MemberList.Keys[i]) = nil then
        begin
          Dec(n28);
          Break;
        end;
      end;
      if n28 <= 0 then
        Result := -5;
    end
    else
      Result := -4;
  end;

  if Result = 0 then
  begin
    n2C := 0;
    n30 := 0;
    for i := 0 to m_RankList.Count - 1 do
    begin
      GuildRank := m_RankList.Items[i];
      boCheckChange := True;
      for ii := 0 to GuildRank.MemberList.Count - 1 do
      begin
        boCheckChange := False;
        sMemberName := GuildRank.MemberList.Keys[ii];
        Inc(n2C);
        for III := 0 to GuildRankList.Count - 1 do
        begin
          NewGuildRank := GuildRankList.Items[III];
          {for n28 := 0 to NewGuildRank.MemberList.Count - 1 do begin
            if NewGuildRank.MemberList.Keys[n28] = sMemberName then begin
              boCheckChange := True;
              Break;
            end;
          end;}
          if NewGuildRank.MemberList.Exists(sMemberName) then
          begin
            boCheckChange := True;
            Break;
          end;
          //if boCheckChange then
          //  Break;
        end;

        if not boCheckChange then
        begin
          Result := -6;
          Break;
        end;
      end;
      if not boCheckChange then
        Break;
    end;

    for i := 0 to GuildRankList.Count - 1 do
    begin
      GuildRank := GuildRankList.Items[i];
      boCheckChange := True;
      for ii := 0 to GuildRank.MemberList.Count - 1 do
      begin
        boCheckChange := False;
        sMemberName := GuildRank.MemberList.Keys[ii];
        Inc(n30);
        for III := 0 to GuildRankList.Count - 1 do
        begin
          NewGuildRank := GuildRankList.Items[III];
          {for n28 := 0 to NewGuildRank.MemberList.Count - 1 do begin
            if NewGuildRank.MemberList.Keys[n28] = sMemberName then begin
              boCheckChange := True;
              Break;
            end;
          end;}
          if NewGuildRank.MemberList.Exists(sMemberName) then
          begin
            boCheckChange := True;
            Break;
          end;
          //if boCheckChange then
          //  Break;
        end;
        if not boCheckChange then
        begin
          Result := -6; //$FFFFFFFA
          Break;
        end;
      end;
      if not boCheckChange then
        Break;
    end;
    if (Result = 0) and (n2C <> n30) then
    begin
      Result := -6;
    end;
  end; //0049976A

  if Result = 0 then
  begin //检查职位号是否重复及非法
    for i := 0 to GuildRankList.Count - 1 do
    begin
      n28 := pTGuildRank(GuildRankList.Items[i]).nRankNo;
      for III := i + 1 to GuildRankList.Count - 1 do
      begin
        if (pTGuildRank(GuildRankList.Items[III]).nRankNo = n28) or (n28 <= 0)
          or (n28 > 99) then
        begin
          Result := -7; //$FFFFFFF9
          Break;
        end;
      end;
      if Result <> 0 then
        Break;
    end;
  end; //004997E9

  if Result = 0 then
  begin
    ClearRankList(m_RankList);
    m_RankList := GuildRankList;
    //更新在线人物职位表
    for i := 0 to m_RankList.Count - 1 do
    begin
      GuildRank := m_RankList.Items[i];
      for III := 0 to GuildRank.MemberList.Count - 1 do
      begin
        PlayObject := UserEngine.GetPlayObject(GuildRank.MemberList.Keys[III]);
        if PlayObject <> nil then
        begin
          GuildRank.MemberList.Values[GuildRank.MemberList.Keys[III]] := TObject(PlayObject);
          PlayObject.RefRankInfo(GuildRank.nRankNo, GuildRank.sRankName);
          PlayObject.RefShowName();
        end;
      end;
    end;
    UpdateGuildFile();
  end
  else
    ClearRankList(GuildRankList);
end;

function TGuild.IsNotWarGuild(Guild: TGuild): Boolean; //00499C98
begin
  Result := (Guild = nil) or not m_GuildWarList.Exists(Guild.sGuildName);
  {Result := False;
  for i := 0 to m_GuildWarList.Count - 1 do begin
    if pTWarGuild(m_GuildWarList.Objects[i]).Guild = Guild then begin
      Exit;
    end;
  end;
  Result := True;}
end;

function TGuild.AllyGuild(Guild: TGuild): Boolean; //00499C2C
begin
  Result := False;
  if (Guild <> nil) and not m_GuildAllList.Exists(Guild.sGuildName) then
  begin
    m_GuildAllList.Put(Guild.sGuildName, Guild);
    SaveGuildInfoFile();
    Result := True;
  end;
  {Result := False;
  for i := 0 to GuildAllList.Count - 1 do begin
    if GuildAllList.Objects[i] = Guild then begin
      Exit;
    end;
  end;
  GuildAllList.AddObject(Guild.sGuildName, Guild);
  SaveGuildInfoFile();
  Result := True;}
end;

function TGuild.AddWarGuild(Guild: TGuild): pTWarGuild;
var
  WarGuild: pTWarGuild;
begin
  Result := nil;
  if Guild <> nil then
  begin
    if not IsAllyGuild(Guild) then
    begin
      {WarGuild := nil;
      for i := 0 to m_GuildWarList.Count - 1 do begin
        if pTWarGuild(m_GuildWarList.Objects[i]).Guild = Guild then begin
          WarGuild := pTWarGuild(m_GuildWarList.Objects[i]);
          WarGuild.dwWarTick := GetTickCount();
          WarGuild.dwWarTime := g_Config.dwGuildWarTime;
          SendGuildMsg(Format('***' + Guild.sGuildName + '行会战争将持续%d分钟', [g_Config.dwGuildWarTime div (60 * 1000)]));
          Break;
        end;
      end;}

      WarGuild := pTWarGuild(m_GuildWarList.GetValues(Guild.sGuildName));
      if WarGuild <> nil then
      begin
        WarGuild.dwWarTick := GetTickCount();
        WarGuild.dwWarTime := g_Config.dwGuildWarTime;
        SendGuildMsg(Format('***' + Guild.sGuildName + '行会战争将持续%d分钟', [g_Config.dwGuildWarTime div (60 * 1000)]));
      end;
      if WarGuild = nil then
      begin
        if not m_GuildWarList.Exists(Guild.sGuildName) then
        begin
          New(WarGuild);
          WarGuild.Guild := Guild;
          WarGuild.dwWarTick := GetTickCount();
          WarGuild.dwWarTime := g_Config.dwGuildWarTime {10800000};
          m_GuildWarList.Put(Guild.sGuildName, TObject(WarGuild));
        end;
        SendGuildMsg(Format('***' + Guild.sGuildName + '行会战争开始(%d分钟)', [g_Config.dwGuildWarTime div (60 * 1000)]));
      end;
      Result := WarGuild;
    end;
  end;
  RefMemberName();
  UpdateGuildFile();
end;

procedure TGuild.sub_499B4C(Guild: TGuild); //00499B4C
begin
  SendGuildMsg('***' + Guild.sGuildName + '行会战争结束');
end;

function TGuild.GetMemberCount: Integer;
var
  i: Integer;
  GuildRank: pTGuildRank;
begin
  Result := 0;
  for i := 0 to m_RankList.Count - 1 do
  begin
    GuildRank := m_RankList.Items[i];
    Inc(Result, GuildRank.MemberList.Count);
  end;
end;

function TGuild.GetMemgerIsFull: Boolean;
begin
  Result := False;
  if GetMemberCount >= g_Config.nGuildMemberMaxLimit then
  begin
    Result := True;
  end;
end;

procedure TGuild.StartTeamFight;
begin
  m_nContestPoint := 0;
  boTeamFight := True;
  TeamFightDeadList.Clear;
end;

procedure TGuild.EndTeamFight;
begin
  boTeamFight := False;
end;

procedure TGuild.AddTeamFightMember(sHumanName: string);
begin
  TeamFightDeadList.Add(sHumanName);
end;

procedure TGuild.SetAuraePoint(nPoint: Integer);
begin
  m_nAurae := nPoint;
  boChanged := True;
end;

procedure TGuild.SetBuildPoint(nPoint: Integer);
begin
  m_nBuildPoint := nPoint;
  boChanged := True;
end;

procedure TGuild.SetFlourishPoint(nPoint: Integer);
begin
  m_nFlourishing := nPoint;
  boChanged := True;
end;

procedure TGuild.SetStabilityPoint(nPoint: Integer);
begin
  m_nStability := nPoint;
  boChanged := True;
end;

procedure TGuild.SetChiefItemCount(nPoint: Integer);
begin
  m_nChiefItemCount := nPoint;
  boChanged := True;
end;

end.
