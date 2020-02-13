unit FrnEngn;

interface

uses
  Windows, Classes, SysUtils, Grobal2, ObjBase, ObjectHero, Forms, MD5;

type
  TSaveRcd = record
    sAccount: string[10];
    sChrName: string[14];
    sMasterName: string[14];
    nHeroFlag: Integer;
    nSessionID: Integer;
    nReTryCount: Integer;
    //PlayObject: TPlayObject;
    HumanRcd: THumDataInfo;
  end;
  pTSaveRcd = ^TSaveRcd;

  TFrontEngine = class(TThread)
    m_UserCriticalSection: TRTLCriticalSection;
    m_LoadRcdList: TList;
    m_SaveRcdList: TList;
  private
    m_LoadRcdTempList: TList;
    m_SaveRcdTempList: TList;
    procedure GetGameTime();
    procedure ProcessGameData();
    function LoadHumFromDB(LoadUser: pTLoadDBInfo; var boReTry: Boolean): byte;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    function SaveListCount(): Integer;
    function IsIdle(): Boolean;
    function IsFull(): Boolean;
    function IsFull2(): Boolean;
    procedure DeleteHuman(nGateIndex, nSocket: Integer);
    function InSaveRcdList(sChrName: string): Boolean;
    procedure AddToLoadRcdList(sAccount, sChrName, sIPaddr: string;
      btFlag: byte; nSessionID: Integer; nPayMent, nPayMode, nSoftVersionDate, nSocket, nGSocketIdx, nGateIdx: Integer;
      sMasterName: string; xHWID: MD5.PMD5Digest);
    procedure AddToSaveRcdList(SaveRcd: pTSaveRcd; bSave: Boolean = False);
    procedure UpdateSaveRcdList(sChrName: string; nSessionID: Integer; HumanRcd: THumDataInfo);
    procedure AddToLoadIPList;
    procedure AddLevelRankToLoadList(nType, nPage: Integer; sName: string);
  end;

implementation

uses
  M2Share, RunDB, svMain, EDcode;

constructor TFrontEngine.Create(CreateSuspended: Boolean);
begin
  inherited;
  InitializeCriticalSection(m_UserCriticalSection);
  m_LoadRcdList := TList.Create;
  m_SaveRcdList := TList.Create;
  m_LoadRcdTempList := TList.Create;
  m_SaveRcdTempList := TList.Create;
  //FreeOnTerminate:=True;
  //AddToProcTable(@TFrontEngine.ProcessGameDate, 'TFrontEngine.ProcessGameDatea');
end;

destructor TFrontEngine.Destroy;
begin
  m_LoadRcdList.Free;
  m_SaveRcdList.Free;
  m_LoadRcdTempList.Free;
  m_SaveRcdTempList.Free;
  DeleteCriticalSection(m_UserCriticalSection);
  inherited;
end;

procedure TFrontEngine.Execute();
begin
  while not Terminated do
  begin
    try
      ProcessGameData();
      GetGameTime();
    except
      MainOutMessageAPI('[Exception] TFrontEngine::Execute');
    end;

    Sleep(1);
  end;
end;

function GetLTime: Single;
var
  SysTime: TSystemTime;
begin
  GetLocalTime(SysTime);
  //Result := SysTime.wSecond;
  //Result := SysTime.wMinute + (Result / 60);
  Result := SysTime.wHour;
end;

procedure TFrontEngine.GetGameTime;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Time, Hour, Min, Sec, MSec);
  case Hour of
    07..17: g_nGameTime := 1; //°×Ìì - 0
    06, 18: g_nGameTime := 2; //°øÍí - 3
    05, 19: g_nGameTime := 0; //Çå³¿ - 2
  else
    //04..16:
    g_nGameTime := 3; //ºÚÒ¹ - 1
  end;

  g_Time := GetLTime;
end;

function TFrontEngine.IsIdle: Boolean;
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    if m_SaveRcdList.Count = 0 then
      Result := True;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.SaveListCount: Integer;
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    Result := m_SaveRcdList.Count;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.ProcessGameData();
var
  i, ii, nCheckCode, nHeroFlag: Integer;
  TempList: TList;
  LoadDBInfo: pTLoadDBInfo;
  SaveRcd: pTSaveRcd;
  boReTryLoadDB: Boolean;
  UserSaveInfo: pTUserSaveInfo;
resourcestring
  sExceptionMsg = '[Exception] TFrontEngine::ProcessGameData Code:%d';
begin
  try
    nCheckCode := 100;
    EnterCriticalSection(m_UserCriticalSection);
    try
      for i := 0 to m_SaveRcdList.Count - 1 do
        m_SaveRcdTempList.Add(m_SaveRcdList.Items[i]);
      TempList := m_LoadRcdTempList;
      m_LoadRcdTempList := m_LoadRcdList;
      m_LoadRcdList := TempList;
    finally
      LeaveCriticalSection(m_UserCriticalSection);
    end;

    for i := 0 to m_SaveRcdTempList.Count - 1 do
    begin
      SaveRcd := m_SaveRcdTempList.Items[i];
      nHeroFlag := SaveRcd.nHeroFlag;
      if SaveHumRcdToDB(SaveRcd.sAccount, SaveRcd.sChrName, SaveRcd.nSessionID, SaveRcd.HumanRcd, nHeroFlag) or (SaveRcd.nReTryCount > 16) then
      begin //0625
        if SaveRcd.sChrName <> '' then
        begin
          New(UserSaveInfo);
          UserSaveInfo.bNewHero := False;
          UserSaveInfo.RcdSaved := True;
          UserSaveInfo.sChrName := SaveRcd.sChrName;
          if (nHeroFlag >= 0) and (SaveRcd.nReTryCount <= 50) then
          begin
            UserSaveInfo.bNewHero := True;
            UserSaveInfo.HeroFlag := nHeroFlag;
            UserSaveInfo.sChrName := SaveRcd.sMasterName;
          end;
          UserEngine.AddUserSaveInfo(UserSaveInfo);
        end;

        EnterCriticalSection(m_UserCriticalSection);
        try
          for ii := 0 to m_SaveRcdList.Count - 1 do
          begin
            if m_SaveRcdList.Items[ii] = SaveRcd then
            begin
              m_SaveRcdList.Delete(ii);
              Dispose(SaveRcd);
              Break;
            end;
          end;
        finally
          LeaveCriticalSection(m_UserCriticalSection);
        end;
      end
      else
        Inc(SaveRcd.nReTryCount);
    end;
    m_SaveRcdTempList.Clear;

    //retry ???
    try
      for i := 0 to m_LoadRcdTempList.Count - 1 do
      begin
        LoadDBInfo := m_LoadRcdTempList.Items[i];
        if LoadDBInfo.btQueryMsg = 1 then
        begin
{$IF USEWLSDK > 0}
          if SendDBRegInfo() then
            boReTryLoadDB := False
          else
            boReTryLoadDB := True;
{$IFEND}
        end
        else if LoadHumFromDB(LoadDBInfo, boReTryLoadDB) = 0 then
        begin
          RunSocket.CloseUser(LoadDBInfo.nGateIdx, LoadDBInfo.nSocket);
        end;

        if not boReTryLoadDB then //0625
          Dispose(LoadDBInfo)
        else
        begin
          EnterCriticalSection(m_UserCriticalSection);
          try
            m_LoadRcdList.Add(LoadDBInfo);
          finally
            LeaveCriticalSection(m_UserCriticalSection);
          end;
        end;
      end;
    finally
      m_LoadRcdTempList.Clear;
    end;
  except
    on E: Exception do
    begin
      MainOutMessageAPI(Format(sExceptionMsg, [nCheckCode]));
      MainOutMessageAPI(E.Message);
    end;
  end;
end;

function TFrontEngine.IsFull(): Boolean;
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    if m_SaveRcdList.Count >= 4000 then
      Result := True;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.IsFull2(): Boolean;
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    if m_SaveRcdList.Count >= 1000 then
      Result := True;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.AddToLoadIPList;
begin
{$IF USEWLSDK > 0}
  boAddTo := True;
  New(LoadRcdInfo);
  FillChar(LoadRcdInfo^, SizeOf(TLoadDBInfo), #0);
  LoadRcdInfo.btQueryMsg := 1;
  EnterCriticalSection(m_UserCriticalSection);
  try
    for i := 0 to m_LoadRcdList.Count - 1 do
    begin
      LoadRcd := pTLoadDBInfo(m_LoadRcdList.Items[i]);
      if LoadRcd.btQueryMsg = 1 then
      begin
        boAddTo := False;
        Break;
      end;
    end;
    if boAddTo then
      m_LoadRcdList.Add(LoadRcdInfo)
    else
      Dispose(LoadRcdInfo);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
{$IFEND}
end;

procedure TFrontEngine.AddLevelRankToLoadList(nType, nPage: Integer; sName: string);
var
  LoadRcdInfo: pTLoadDBInfo;
begin
  New(LoadRcdInfo);
  FillChar(LoadRcdInfo^, SizeOf(TLoadDBInfo), #0);
  LoadRcdInfo.btQueryMsg := 2;
  LoadRcdInfo.nLRType := nType;
  LoadRcdInfo.nLRPage := nPage;
  LoadRcdInfo.btClinetFlag := 3;
  LoadRcdInfo.sCharName := sName;
  EnterCriticalSection(m_UserCriticalSection);
  try
    m_LoadRcdList.Add(LoadRcdInfo);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.AddToLoadRcdList(sAccount, sChrName, sIPaddr: string;
  btFlag: byte;
  nSessionID, nPayMent, nPayMode, nSoftVersionDate, nSocket, nGSocketIdx, nGateIdx: Integer;
  sMasterName: string; xHWID: MD5.PMD5Digest);
var
  LoadRcdInfo: pTLoadDBInfo;
begin
  New(LoadRcdInfo);
  FillChar(LoadRcdInfo^, SizeOf(TLoadDBInfo), #0);
  LoadRcdInfo.sAccount := sAccount;
  LoadRcdInfo.sCharName := sChrName;
  LoadRcdInfo.sMasterName := sMasterName;
  LoadRcdInfo.sIPaddr := sIPaddr;
  LoadRcdInfo.btClinetFlag := btFlag;
  LoadRcdInfo.nSessionID := nSessionID;
  LoadRcdInfo.nSoftVersionDate := nSoftVersionDate;
  LoadRcdInfo.nPayMent := nPayMent;
  LoadRcdInfo.nPayMode := nPayMode;
  LoadRcdInfo.nSocket := nSocket;
  LoadRcdInfo.nGSocketIdx := nGSocketIdx;
  LoadRcdInfo.nGateIdx := nGateIdx;
  LoadRcdInfo.dwNewUserTick := GetTickCount();
  LoadRcdInfo.nReLoadCount := 0;
  LoadRcdInfo.btQueryMsg := 0;
  if xHWID <> nil then
    LoadRcdInfo.xHWID := xHWID^;
  EnterCriticalSection(m_UserCriticalSection);
  try
    m_LoadRcdList.Add(LoadRcdInfo);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.LoadHumFromDB(LoadUser: pTLoadDBInfo; var boReTry: Boolean): byte; //in ThreadMode
var
  boOffLine: Boolean;
  PlayObject: TPlayObject;
  HumanRcd: THumDataInfo;
  HerosInfo: THerosInfo;
  UserOpenInfo: pTUserOpenInfo;
  LR: string;
  HLR: string;
begin
  Result := 0;
  boReTry := False;
  case LoadUser.btClinetFlag of
    0: if LoadUser.sMasterName <> '' then
      begin //Load Hero Rcd
        PlayObject := UserEngine.GetPlayObjectCS_Name(LoadUser.sMasterName);
        if PlayObject <> nil then
        begin
          //¸´ÖÆ£¿
          if InSaveRcdList(LoadUser.sCharName) then
          begin
            boReTry := True;
            Exit;
          end;
          if LoadHumRcdFromDB(LoadUser.sAccount, LoadUser.sCharName, LoadUser.sIPaddr, HumanRcd, {HerosInfo,} LoadUser.nSessionID) then
          begin
            HumanRcd.Data.sHeroMasterName := LoadUser.sMasterName;
            New(UserOpenInfo);
            UserOpenInfo.LoadType := tHeroDat;
            UserOpenInfo.LoadUser := LoadUser^;
            UserOpenInfo.HumanRcd := HumanRcd;
            UserEngine.AddUserOpenInfo(UserOpenInfo);
          end
          else
          begin
            New(UserOpenInfo);
            UserOpenInfo.LoadType := tLoadFail;
            UserOpenInfo.LoadUser := LoadUser^;
            UserEngine.AddUserOpenInfo(UserOpenInfo);
          end;
          Result := 2;
        end;
      end;
    1:
      begin //Load Human Rcd
        PlayObject := UserEngine.GetPlayObjectCS_IdName(LoadUser.sCharName, LoadUser.sAccount, boOffLine);
        if PlayObject <> nil then
        begin
          if boOffLine then
          begin
            New(UserOpenInfo);
            UserOpenInfo.LoadType := tResume;
            UserOpenInfo.LoadUser := LoadUser^;
            UserEngine.AddUserOpenInfo(UserOpenInfo);
            Result := 1;
            Exit;
          end
          else
          begin
            UserEngine.KickPlayer(LoadUser.sCharName);
            boReTry := True;
            Exit;
          end;
        end;

        if UserEngine.GetHeroObjectCS_IdName(LoadUser.sAccount, LoadUser.sCharName) <> nil then
        begin
          UserEngine.KickPlayer(LoadUser.sCharName);
          boReTry := True;
          Exit;
        end;

        {if UserEngine.GetHeroObjectCS(LoadUser.sCharName) <> nil then begin
          UserEngine.KickPlayer(LoadUser.sCharName);
          boReTry := True;
          Exit;
        end;}

        if InSaveRcdList(LoadUser.sCharName) then
        begin
          boReTry := True;
          Exit;
        end;

{$IF V_TEST = 1}
{$I '..\Common\Macros\VMPB.inc'}
        if (UserEngine.m_PlayObjectList.Count > 10) or not LoadHumRcdFromDB(LoadUser.sAccount, LoadUser.sCharName, LoadUser.sIPaddr, HumanRcd, {HerosInfo,} LoadUser.nSessionID) then
          RunSocket.SendOutConnectMsg(LoadUser.nGateIdx, LoadUser.nSocket, LoadUser.nGSocketIdx)
        else
        begin
          New(UserOpenInfo);
          UserOpenInfo.LoadType := tHumDat;
          UserOpenInfo.LoadUser := LoadUser^;
          UserOpenInfo.HumanRcd := HumanRcd;
          //UserOpenInfo.HerosInfo := HerosInfo;
          UserEngine.AddUserOpenInfo(UserOpenInfo);
          Result := 1;
        end;
{$I '..\Common\Macros\VMPE.inc'}
{$ELSE}
        if not LoadHumRcdFromDB(LoadUser.sAccount, LoadUser.sCharName, LoadUser.sIPaddr, HumanRcd, {HerosInfo,} LoadUser.nSessionID) then
          RunSocket.SendOutConnectMsg(LoadUser.nGateIdx, LoadUser.nSocket, LoadUser.nGSocketIdx)
        else
        begin
          New(UserOpenInfo);
          UserOpenInfo.LoadType := tHumDat;
          UserOpenInfo.LoadUser := LoadUser^;
          UserOpenInfo.HumanRcd := HumanRcd;
          //UserOpenInfo.HerosInfo := HerosInfo;
          UserEngine.AddUserOpenInfo(UserOpenInfo);
          Result := 1;
        end;
{$IFEND V_TEST}
      end;
    2:
      begin //Load "recall player" Rcd
        PlayObject := UserEngine.GetPlayObjectCS_Name(LoadUser.sMasterName);
        if PlayObject <> nil then
        begin
          if LoadHumRcdFromDB(LoadUser.sAccount, LoadUser.sCharName, LoadUser.sIPaddr, HumanRcd, {HerosInfo,} LoadUser.nSessionID) then
          begin
            HumanRcd.Data.sHeroMasterName := LoadUser.sMasterName;
            New(UserOpenInfo);
            UserOpenInfo.LoadType := tHeroDat;
            UserOpenInfo.LoadUser := LoadUser^;
            UserOpenInfo.HumanRcd := HumanRcd;
            UserEngine.AddUserOpenInfo(UserOpenInfo);
          end
          else
          begin
            New(UserOpenInfo);
            UserOpenInfo.LoadType := tLoadFail;
            UserOpenInfo.LoadUser := LoadUser^;
            UserEngine.AddUserOpenInfo(UserOpenInfo);
          end;
          Result := 3;
        end;
      end;
    3:
      begin
        Result := 4;
        //PlayObject := UserEngine.GetPlayObjectCS_Name(LoadUser.sCharName); //not ghost
        //if PlayObject <> nil then begin
        LoadUser.nLRResult := QueryLevelRank(LoadUser.nLRType, LoadUser.nLRPage, LoadUser.sCharName, LR, HLR);
        if (LoadUser.nLRResult <> -3) then
        begin
          New(UserOpenInfo);
          UserOpenInfo.RankData := '';
          UserOpenInfo.LoadType := tLvRank;
          UserOpenInfo.LoadUser := LoadUser^;
          if LoadUser.nLRType in [4..7] then
            UserOpenInfo.RankData := HLR
          else
            UserOpenInfo.RankData := LR;
          UserEngine.AddUserOpenInfo(UserOpenInfo);
        end;
        //end;
      end;

    4:
      begin //Load Human Rcd
        PlayObject := UserEngine.GetPlayObjectCS_IdName(LoadUser.sCharName, LoadUser.sAccount, boOffLine);
        if PlayObject <> nil then
        begin
          if boOffLine then
          begin
            New(UserOpenInfo);
            UserOpenInfo.LoadType := tResume;
            UserOpenInfo.LoadUser := LoadUser^;
            UserEngine.AddUserOpenInfo(UserOpenInfo);
            Result := 1;
            Exit;
          end
          else
          begin
            UserEngine.KickPlayer(LoadUser.sCharName);
            boReTry := True;
            Exit;
          end;
        end;

        if UserEngine.GetHeroObjectCS_IdName(LoadUser.sAccount, LoadUser.sCharName) <> nil then
        begin
          UserEngine.KickPlayer(LoadUser.sCharName);
          boReTry := True;
          Exit;
        end;

        {if UserEngine.GetHeroObjectCS(LoadUser.sCharName) <> nil then begin
          UserEngine.KickPlayer(LoadUser.sCharName);
          boReTry := True;
          Exit;
        end;}

        if InSaveRcdList(LoadUser.sCharName) then
        begin
          boReTry := True;
          Exit;
        end;
        try
          if not LoadHumRcdFromDB(LoadUser.sAccount, LoadUser.sCharName, LoadUser.sIPaddr, HumanRcd, {HerosInfo,} LoadUser.nSessionID) then
          begin
            //RunSocket.SendOutConnectMsg(LoadUser.nGateIdx, LoadUser.nSocket, LoadUser.nGSocketIdx);
          end
          else
          begin
            New(UserOpenInfo);
            UserOpenInfo.LoadType := tHumDat2;
            UserOpenInfo.LoadUser := LoadUser^;
            UserOpenInfo.HumanRcd := HumanRcd;
            UserEngine.AddUserOpenInfo(UserOpenInfo);
            Result := 1;
          end;
        except
          on E: Exception do
          begin
            MainOutMessageAPI(E.Message);
          end;
        end;
      end;

    5:
      begin
        Result := 4;
        if LoadHerosFromDB(LoadUser.sAccount, LoadUser.sCharName, LoadUser.sIPaddr, HerosInfo, LoadUser.nSessionID) then
        begin
          New(UserOpenInfo);
          UserOpenInfo.LoadType := tSendMyHeros;
          UserOpenInfo.LoadUser := LoadUser^;
          //UserOpenInfo.HerosInfo := HerosInfo;
          Move(HerosInfo, UserOpenInfo.HumanRcd, SizeOf(THerosInfo));
          UserEngine.AddUserOpenInfo(UserOpenInfo);
          Result := 1;
        end;
      end;

  end;
end;

function TFrontEngine.InSaveRcdList(sChrName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    for i := 0 to m_SaveRcdList.Count - 1 do
    begin
      if CompareText(pTSaveRcd(m_SaveRcdList.Items[i]).sChrName, sChrName) = 0 then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.AddToSaveRcdList(SaveRcd: pTSaveRcd; bSave: Boolean); //0720
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    m_SaveRcdList.Add(SaveRcd);
    {if not bSave then
      m_SaveRcdList.Add(SaveRcd)
    else begin
      b := False;
      if m_SaveRcdList.Count > 50 then begin
        for i := 0 to m_SaveRcdList.Count - 1 do begin
          p := m_SaveRcdList[i];
          if (CompareText(p.sChrName, SaveRcd.sChrName) = 0) and (p.nSessionID = SaveRcd.nSessionID) then begin
            b := True;
            Move(SaveRcd.HumanRcd, p.HumanRcd, SizeOf(THumDataInfo));
            Dispose(SaveRcd);
            Break;
          end;
        end;
      end;
      if not b then
        m_SaveRcdList.Add(SaveRcd);
    end;}
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.UpdateSaveRcdList(sChrName: string; nSessionID: Integer; HumanRcd: THumDataInfo);
var
  i: Integer;
  p: pTSaveRcd;
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    for i := 0 to m_SaveRcdList.Count - 1 do
    begin
      p := m_SaveRcdList[i];
      if (CompareText(p.sChrName, sChrName) = 0) and (p.nSessionID = nSessionID) then
      begin
        p.HumanRcd := HumanRcd;
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.DeleteHuman(nGateIndex, nSocket: Integer);
var
  i: Integer;
  LoadRcdInfo: pTLoadDBInfo;
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    for i := 0 to m_LoadRcdList.Count - 1 do
    begin
      LoadRcdInfo := m_LoadRcdList.Items[i];
      if (LoadRcdInfo.nGateIdx = nGateIndex) and (LoadRcdInfo.nSocket = nSocket) then
      begin
        Dispose(LoadRcdInfo);
        m_LoadRcdList.Delete(i);
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

end.
