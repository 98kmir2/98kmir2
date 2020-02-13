unit LocalDB;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls,
  Dialogs, M2Share, {$IF DBTYPE = BDE}DBTables{$ELSE}ADODB{$IFEND}, DB, HUtil32,
  Grobal2, ObjNpc, UsrEngn, Forms, ActiveX, IniFiles {, GuildTerritory};

type
  TDefineInfo = record
    sName: string;
    sText: string;
  end;
  pTDefineInfo = ^TDefineInfo;

  TQDDinfo = record
    n00: Integer;
    s04: string;
    sList: TStringList;
  end;
  pTQDDinfo = ^TQDDinfo;

  TGoodFileHeader = record
    nItemCount: Integer;
    Resv: array[0..251] of Integer;
  end;

  TFrmDB = class
  private
    procedure QMangeNPC;
    procedure QFunctionNPC;
    procedure QMapEventNPC;
    procedure RobotNPC();
    //procedure DeCodeStringList(StringList: TStringList);
    { Private declarations }
  public
{$IF DBTYPE = BDE}
    Query: TQuery;
{$ELSE}
    Query: TADOQuery;
{$IFEND}
    constructor Create();
    destructor Destroy; override;
    function LoadMonitems(MonName: string; var ItemList: TList): Integer;
    function LoadMonSpAbil(MonInfo: pTMonInfo): Integer;
    function LoadItemsDB(): Integer;
    function LoadMinMap(): Integer;
    function LoadMapInfo(): Integer;
    function InitMapNimbus(): Integer;

    function LoadMonsterDB(): Integer;
    function LoadMagicDB(): Integer;
    function LoadMonGen(): Integer;
    function LoadUnbindList(): Integer;
    function LoadMapQuest(): Integer;
    function LoadQuestDiary(): Integer;
    function LoadAdminList(): Boolean;
    function LoadMerchant(): Integer;
    function LoadGuardList(): Integer;
    function LoadNpcs(): Integer;
    function LoadMakeItem(): Integer;
    function LoadBoxItem(): Integer;
    function LoadRefineItem(): Integer;
    //function LoadStartPoint(): Integer;
    function LoadNpcScript(NPC: TNormNpc; sPatch, sScritpName: string): Integer;
    function LoadScriptFile(NPC: TNormNpc; sPatch, sScritpName: string; boFlag: Boolean): Integer;
    function LoadGoodRecord(NPC: TMerchant; sFile: string): Integer;
    function LoadGoodPriceRecord(NPC: TMerchant; sFile: string): Integer;
    function LoadSellOffRecord(NPC: TMerchant; sFile: string): Integer;
    function SaveSellOffRecord(NPC: TMerchant; sFile: string): Integer;
    function LoadSellGoldRecord(NPC: TMerchant; sFile: string): Integer;
    function SaveSellGoldRecord(NPC: TMerchant; sFile: string): Integer;
    function SaveGoodRecord(NPC: TMerchant; sFile: string): Integer;
    function SaveGoodPriceRecord(NPC: TMerchant; sFile: string): Integer;
    function LoadPostSellRecord(NPC: TMerchant; sFile: string): Integer;
    function SavePostSellRecord(NPC: TMerchant; sFile: string): Integer;
    function LoadPostGoldRecord(NPC: TMerchant; sFile: string): Integer;
    function SavePostGoldRecord(NPC: TMerchant; sFile: string): Integer;
    function LoadUpgradeWeaponRecord(sNPCName: string; DataList: TList): Integer;
    function SaveUpgradeWeaponRecord(sNPCName: string; DataList: TList): Integer;
    procedure ReLoadMerchants();
    procedure ReLoadNpc();

    {procedure LoadGT(Number, ListNumber: Integer);
    procedure SaveGT(GT: TTerritory);
    procedure SetupGT(GT: TTerritory);

    procedure LoadGTDecorations(GT: TTerritory);
    procedure SaveDeco(looks, GTNumber: Byte; x, y: Integer; mapname: string; starttime: dword);
    procedure DeleteDeco(GTNumber: Byte; x, y: Integer; mapname: string);
    function LoadDecorationList(): Integer;}

    { Public declarations }
  end;

var
  FrmDB: TFrmDB;
  nDeCryptString: Integer = -1;

implementation

uses ObjBase, Envir, svMain;

function TFrmDB.LoadAdminList(): Boolean;
var
  sFileName: string;
  sLineText: string;
  sIPaddr: string;
  sCharName: string;
  sData: string;
  LoadList: TStringList;
  AdminInfo: pTAdminInfo;
  i: Integer;
  nLv: Integer;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'AdminList.txt';
  if not FileExists(sFileName) then
    Exit;
  UserEngine.m_AdminList.Lock;
  try
    UserEngine.m_AdminList.Clear;
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      sLineText := LoadList.Strings[i];
      nLv := -1;
      if (sLineText <> '') and (sLineText[1] <> ';') then
      begin
        if sLineText[1] = '*' then
          nLv := 10
        else if sLineText[1] = '1' then
          nLv := 9
        else if sLineText[1] = '2' then
          nLv := 8
        else if sLineText[1] = '3' then
          nLv := 7
        else if sLineText[1] = '4' then
          nLv := 6
        else if sLineText[1] = '5' then
          nLv := 5
        else if sLineText[1] = '6' then
          nLv := 4
        else if sLineText[1] = '7' then
          nLv := 3
        else if sLineText[1] = '8' then
          nLv := 2
        else if sLineText[1] = '9' then
          nLv := 1;
        if nLv > 0 then
        begin
          sLineText := GetValidStrCap(sLineText, sData, ['/', '\', ' ', #9]);
          sLineText := GetValidStrCap(sLineText, sCharName, ['/', '\', ' ', #9]);
          sLineText := GetValidStrCap(sLineText, sIPaddr, ['/', '\', ' ', #9]);
{$IF VEROWNER = WL}
          if (sCharName <= '') or (sIPaddr = '') then
            Continue;
{$IFEND}
          New(AdminInfo);
          AdminInfo.nLv := nLv;
          AdminInfo.sChrName := sCharName;
          AdminInfo.sIPaddr := sIPaddr;
          UserEngine.m_AdminList.Add(AdminInfo);
        end;
      end;
    end;
    LoadList.Free;
  finally
    UserEngine.m_AdminList.UnLock;
  end;
  Result := True;
end;

function TFrmDB.LoadGuardList(): Integer;
var
  sFileName, s14, s1C, s20, s24, s28, s2C: string;
  tGuardList: TStringList;
  i: Integer;
  tGuard: TBaseObject;
begin
  Result := -1;
  sFileName := g_Config.sEnvirDir + 'GuardList.txt';
  if FileExists(sFileName) then
  begin
    tGuardList := TStringList.Create;
    tGuardList.LoadFromFile(sFileName);
    for i := 0 to tGuardList.Count - 1 do
    begin
      s14 := tGuardList.Strings[i];
      if (s14 <> '') and (s14[1] <> ';') then
      begin
        s14 := GetValidStrCap(s14, s1C, [' ']);
        if (s1C <> '') and (s1C[1] = '"') then
          ArrestStringEx(s1C, '"', '"', s1C);
        s14 := GetValidStr3(s14, s20, [' ']);
        s14 := GetValidStr3(s14, s24, [' ', ',']);
        s14 := GetValidStr3(s14, s28, [' ', ',', ':']);
        s14 := GetValidStr3(s14, s2C, [' ', ':']);
        if (s1C <> '') and (s20 <> '') and (s2C <> '') then
        begin
          tGuard := UserEngine.RegenMonsterByName(s20, Str_ToInt(s24, 0), Str_ToInt(s28, 0), s1C);
          if tGuard <> nil then
            tGuard.m_btDirection := Str_ToInt(s2C, 0);
        end;
      end;
    end;
    tGuardList.Free;
    Result := 1;
  end;
end;

function TFrmDB.LoadItemsDB: Integer;
var
  i,  Idx: Integer;
  fUseItem: Boolean;
  StdItem: pTStdItem;
resourcestring
  sSQLString = 'select * from StdItems';
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    try
      LoadDisableTreasureIdentifyList();

      UserEngine.TitleList.Clear;

      for i := 0 to UserEngine.StdItemList.Count - 1 do
        Dispose(pTStdItem(UserEngine.StdItemList.Items[i]));
      UserEngine.StdItemList.Clear;

      Result := -1;
      Query.SQL.Clear;
      Query.SQL.Add(sSQLString);
      try
        Query.Open;
      finally
        Result := -2;
      end;

      for i := 0 to Query.RecordCount - 1 do
      begin
        New(StdItem);
        FillChar(StdItem^, SizeOf(TStdItem), #0);
        Idx := Query.FieldByName('Idx').AsInteger;
        StdItem.Name := Query.FieldByName('Name').AsString;
        StdItem.StdMode := Query.FieldByName('StdMode').AsInteger;
        StdItem.Shape := Query.FieldByName('Shape').AsInteger;
        StdItem.Weight := Query.FieldByName('Weight').AsInteger;
        StdItem.AniCount := Query.FieldByName('AniCount').AsInteger;
        StdItem.Source := Query.FieldByName('Source').AsInteger;
        StdItem.Reserved := Query.FieldByName('Reserved').AsInteger;
        StdItem.looks := Query.FieldByName('Looks').AsInteger;
        StdItem.DuraMax := Word(Query.FieldByName('DuraMax').AsInteger);
        StdItem.AC := MakeLong(Round(Query.FieldByName('Ac').AsInteger * (g_Config.nItemsACPowerRate / 10)), Round(Query.FieldByName('Ac2').AsInteger * (g_Config.nItemsACPowerRate / 10)));
        StdItem.MAC := MakeLong(Round(Query.FieldByName('Mac').AsInteger * (g_Config.nItemsACPowerRate / 10)), Round(abs(Query.FieldByName('MAc2').AsInteger) * (g_Config.nItemsACPowerRate / 10)));
        StdItem.DC := MakeLong(Round(Query.FieldByName('Dc').AsInteger * (g_Config.nItemsPowerRate / 10)), Round(Query.FieldByName('Dc2').AsInteger * (g_Config.nItemsPowerRate / 10)));
        StdItem.MC := MakeLong(Round(Query.FieldByName('Mc').AsInteger * (g_Config.nItemsPowerRate / 10)), Round(Query.FieldByName('Mc2').AsInteger * (g_Config.nItemsPowerRate / 10)));
        StdItem.SC := MakeLong(Round(Query.FieldByName('Sc').AsInteger * (g_Config.nItemsPowerRate / 10)), Round(Query.FieldByName('Sc2').AsInteger * (g_Config.nItemsPowerRate / 10)));
        StdItem.Need := Query.FieldByName('Need').AsInteger;
        StdItem.NeedLevel := Query.FieldByName('NeedLevel').AsInteger;
        StdItem.Price := Query.FieldByName('Price').AsInteger;
        StdItem.SvrSet.nGetRate := Query.FieldByName('Stock').AsInteger;
        StdItem.NeedIdentify := GetGameLogItemNameList(StdItem.Name);
        StdItem.Overlap := Query.FieldByName('Overlap').AsInteger;
        {
        StdItem.UniqueItem := Query.FieldByName('UniqueItem').AsInteger;

        StdItem.ItemType := Query.FieldByName('ItemType').AsInteger;
        //StdItem.ItemSet := Query.FieldByName('ItemSet').AsInteger;
        StdItem.SvrSet.nBind := Query.FieldByName('Bind').AsInteger;
        StdItem.reserve[3] := Query.FieldByName('Shine').AsInteger;

        //1001
        //StdItem.Reference := Query.FieldByName('Reference').AsString;

        StdItem.ItemSet := MakeWord(Query.FieldByName('Smite').AsInteger, Query.FieldByName('DropRate').AsInteger);

        v1 := Query.FieldByName('IgnDef').AsInteger; //忽视
        v2 := Query.FieldByName('DamAdd').AsInteger; //增伤
        v3 := Query.FieldByName('DamReb').AsInteger; //反射
        v4 := Query.FieldByName('DcRedu').AsInteger; //物减
        v5 := Query.FieldByName('McRedu').AsInteger; //魔减
        v6 := Query.FieldByName('ExpAdd').AsInteger; //附加

        StdItem.reserve[0] := _MIN(15, v1) * 16 + _MIN(15, v2);
        StdItem.reserve[1] := _MIN(15, v3) * 16 + _MIN(15, v4);
        StdItem.reserve[2] := _MIN(15, v5) * 16 + _MIN(15, v6);
        }
        StdItem.SvrSet.boHeroPickup := IsInPetPickItemList(StdItem.Name);
        fUseItem := (StdItem.StdMode in [5, 6, 10..13, 15..24, 26..30, 51..54, 62..64]);
        if g_Config.tiOpenSystem and fUseItem then
        begin
          if not g_DisTIList.Exists(StdItem.Name) then
            StdItem.Eva.EvaTimesMax := 3;
        end;

        if fUseItem then
        begin
          StdItem.reserve[7] := Query.FieldByName('HP').AsInteger;
          StdItem.reserve[8] := Query.FieldByName('MP').AsInteger;
        end;

        FillChar(StdItem.SvrSet.aSuiteWhere, SizeOf(TSuiteIndex), $FF);
        StdItem.SvrSet.btRefSuiteCount := 0;
        GetSuiteItems(StdItem);

        if StdItem.StdMode = 51 then
        begin
          if UserEngine.TitleList.Count = StdItem.Shape - 1 then
          begin
            UserEngine.TitleList.Add(StdItem);
          end
          else
          begin
            g_MainMemo.Lines.Add(Format('加载称号(Idx:%d Name:%s)数据失败，物品Shape请保持连续(1~128)', [Idx, StdItem.Name]));
            Result := -100;
            Break;
          end;
        end;

        if UserEngine.StdItemList.Count = Idx then
        begin
          UserEngine.StdItemList.Add(StdItem);
          Result := 1;
        end
        else
        begin
          g_MainMemo.Lines.Add(Format('加载物品(Idx:%d Name:%s)数据失败', [Idx, StdItem.Name]));
          Result := -100;
          Break;
        end;
        Query.Next;
      end;
      g_boGameLogGold := GetGameLogItemNameList(sSTRING_GOLDNAME) = 1;
      g_boGameLogHumanDie := GetGameLogItemNameList(g_sHumanDieEvent) = 1;
      g_boGameLogGameGold := GetGameLogItemNameList(g_Config.sGameGoldName) = 1;
      g_boGameLogGamePoint := GetGameLogItemNameList(g_Config.sGamePointName) = 1;
      g_boHeroPickupGold := IsInPetPickItemList(sSTRING_GOLDNAME);
    finally
      Query.Close;
    end;

    if UserEngine.TitleList.Count > 0 then
    begin
      MakeTitleSendBuffer();
    end;

  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TFrmDB.LoadMagicDB(): Integer;
var
  i, ii: Integer;
  Magic: pTMagic;
resourcestring
  sSQLString = 'select * from Magic';
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    UserEngine.SwitchMagicList();
    Query.SQL.Clear;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      Result := -2;
    end;
    for i := 0 to Query.RecordCount - 1 do
    begin
      New(Magic);
      Magic.wMagicId := Query.FieldByName('MagId').AsInteger;
      Magic.sMagicName := Query.FieldByName('MagName').AsString;
      Magic.btEffectType := Query.FieldByName('EffectType').AsInteger;
      Magic.btEffect := Query.FieldByName('Effect').AsInteger;
      Magic.wSpell := Query.FieldByName('Spell').AsInteger;
      Magic.wPower := Query.FieldByName('Power').AsInteger;
      Magic.wMaxPower := Query.FieldByName('MaxPower').AsInteger;
      Magic.btJob := Query.FieldByName('Job').AsInteger;
      for ii := Low(Magic.TrainLevel) to High(Magic.TrainLevel) do
        Magic.TrainLevel[ii] := Query.FieldByName(Format('NeedL%d', [ii + 1])).AsInteger;

      for ii := Low(Magic.MaxTrain) to High(Magic.MaxTrain) do
        Magic.MaxTrain[ii] := Query.FieldByName(Format('L%dTrain', [ii + 1])).AsInteger;

      Magic.btTrainLv := _MIN(15, Query.FieldByName('MaxTrainLv').AsInteger); //MAXMAGICLV  + 3; //3;
      Magic.dwDelayTime := Query.FieldByName('Delay').AsInteger;
      Magic.btDefSpell := Query.FieldByName('DefSpell').AsInteger;
      Magic.btDefPower := Query.FieldByName('DefPower').AsInteger;
      Magic.btDefMaxPower := Query.FieldByName('DefMaxPower').AsInteger;
      Magic.sDescr := Query.FieldByName('Descr').AsString;

      Magic.btClass := 0;
      //if CompareText(Magic.sDescr, g_sHeroName) = 0 then
      //  Magic.btClass := 0
      //else
      if CompareText(Magic.sDescr, '怒之') = 0 then
        Magic.btClass := 1
      else if CompareText(Magic.sDescr, '静之') = 0 then
        Magic.btClass := 2;

      if Magic.wMagicId in [1..255] then
        UserEngine.m_MagicList.Add(Magic)
      else
        Dispose(Magic);

      Result := 1;
      Query.Next;
    end;
    Query.Close;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TFrmDB.LoadMakeItem(): Integer;
var
  i, n14: Integer;
  s18, s20, s24: string;
  LoadList: TStringList;
  sFileName: string;
  List28: TStringList;
begin
  Result := -1;
  sFileName := g_Config.sEnvirDir + 'MakeItem.txt';
  if FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    List28 := nil;
    s24 := '';
    for i := 0 to LoadList.Count - 1 do
    begin
      s18 := Trim(LoadList.Strings[i]);
      if (s18 <> '') and (s18[1] <> ';') then
      begin
        if s18[1] = '[' then
        begin
          if List28 <> nil then
            g_MakeItemList.AddObject(s24, List28);
          List28 := TStringList.Create;
          ArrestStringEx(s18, '[', ']', s24);
        end
        else
        begin
          if List28 <> nil then
          begin
            s18 := GetValidStr3(s18, s20, [' ', #9]);
            n14 := Str_ToInt(Trim(s18), 1);
            List28.AddObject(s20, TObject(n14));
          end;
        end;
      end;
    end;
    if List28 <> nil then
      g_MakeItemList.AddObject(s24, List28);
    LoadList.Free;
    Result := 1;
  end;
end;

function TFrmDB.LoadRefineItem(): Integer;
var
  i, ii, nIxd: Integer;
  sFileName: string;
  sLine, sRefine, sR, sRMax: string;
  List: TList;
  LoadList: TStringList;
  sItemName, sSucessRate, sRandomAddValue, sAddValueRate, sDelCrystal, sRevertRate: string;
  pRefineItem: pTRefineItem;
begin
  sFileName := g_Config.sEnvirDir + 'RefineItem.txt';
  if g_RefineItemList.Count > 0 then
  begin
    for i := 0 to g_RefineItemList.Count - 1 do
    begin
      List := TList(g_RefineItemList.Objects[i]);
      for ii := 0 to List.Count - 1 do
        Dispose(pTBoxItem(List.Items[ii]));
      List.Free;
    end;
    g_RefineItemList.Clear;
  end;
  if not FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.Add(';淬炼物品设置列表');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Result := 1;
    Exit;
  end;
  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sFileName);
  List := nil;
  sRefine := '';
  for i := 0 to LoadList.Count - 1 do
  begin
    sLine := Trim(LoadList.Strings[i]);
    if (sLine <> '') and (sLine[1] <> ';') then
    begin
      if sLine[1] = '[' then
      begin
        if List <> nil then
          g_RefineItemList.AddObject(sRefine, List);
        List := TList.Create;
        ArrestStringEx(sLine, '[', ']', sRefine);
      end
      else if List <> nil then
      begin
        sLine := GetValidStr3(sLine, sItemName, [' ', #9]);
        sLine := GetValidStr3(sLine, sSucessRate, [' ', #9]);
        sLine := GetValidStr3(sLine, sRevertRate, [' ', #9]);
        sLine := GetValidStr3(sLine, sDelCrystal, [' ', #9]);
        sLine := GetValidStr3(sLine, sAddValueRate, [' ', #9]);
        sLine := GetValidStr3(sLine, sRandomAddValue, [' ', #9]);
        if (sAddValueRate <> '') and (sRandomAddValue <> '') then
        begin
          New(pRefineItem);
          FillChar(pRefineItem^, SizeOf(TRefineItem), #0);
          pRefineItem.sUpItemName := sItemName;
          pRefineItem.nSucessRate := Str_ToInt(sSucessRate, 30);
          pRefineItem.nRevertRate := Str_ToInt(sRevertRate, 30);
          pRefineItem.bDelCrystal := Str_ToInt(sDelCrystal, 00) <> 0;
          pRefineItem.RamAddValue.nAddValueRate := Str_ToInt(sAddValueRate, 30);
          for nIxd := Low(pRefineItem.RamAddValue.abAddValueRate) to High(pRefineItem.RamAddValue.abAddValueRate) do
          begin
            sRandomAddValue := GetValidStr3(sRandomAddValue, sLine, [',']);
            sR := GetValidStr3(sLine, sRMax, ['-']);
            pRefineItem.RamAddValue.abAddValueRate[nIxd] := Str_ToInt(Trim(sR), 5);
            pRefineItem.RamAddValue.abAddValueMaxLimit[nIxd] := Str_ToInt(Trim(sRMax), 4);
            if sRandomAddValue = '' then
              Break;
          end;
          List.Add(pRefineItem);
        end;
      end;
    end;
  end;
  if List <> nil then
    g_RefineItemList.AddObject(sRefine, List);
  LoadList.Free;
  Result := 1;
end;

function TFrmDB.LoadBoxItem(): Integer;
var
  i, ii: Integer;
  sFileName: string;
  sLine, sBox: string;
  List: TList;
  LoadList: TStringList;
  sItemName, sItemCount, sGetItemRate: string;
  pBoxItem: pTBoxItem;
begin
  sFileName := g_Config.sEnvirDir + 'BoxItem.txt';
  if g_BoxItemList.Count > 0 then
  begin
    for i := 0 to g_BoxItemList.Count - 1 do
    begin
      List := TList(g_BoxItemList.Objects[i]);
      for ii := 0 to List.Count - 1 do
        Dispose(pTBoxItem(List.Items[ii]));
      List.Free;
    end;
    g_BoxItemList.Clear;
  end;
  if not FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.Add(';宝箱物品设置列表');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Result := 1;
    Exit;
  end;
  LoadList := TStringList.Create;
  LoadList.LoadFromFile(sFileName);
  List := nil;
  sBox := '';
  for i := 0 to LoadList.Count - 1 do
  begin
    sLine := Trim(LoadList.Strings[i]);
    if (sLine <> '') and (sLine[1] <> ';') then
    begin
      if sLine[1] = '[' then
      begin
        if List <> nil then
          g_BoxItemList.AddObject(sBox, List);
        List := TList.Create;
        ArrestStringEx(sLine, '[', ']', sBox);
      end
      else if List <> nil then
      begin
        sLine := GetValidStr3(sLine, sItemName, [' ', #9]);
        sLine := GetValidStr3(sLine, sItemCount, [' ', #9]);
        sLine := GetValidStr3(sLine, sGetItemRate, [' ', #9]);
        if (sItemName <> '') and (sItemCount <> '') and (sGetItemRate <> '') then
        begin
          New(pBoxItem);
          FillChar(pBoxItem^, SizeOf(TBoxItem), #0);
          pBoxItem.sName := Trim(sItemName);
          pBoxItem.nNumber := Str_ToInt(Trim(sItemCount), 1);
          pBoxItem.btRate := Str_ToInt(Trim(sGetItemRate), 9);
          List.Add(pBoxItem);
        end;
      end;
    end;
  end;
  if List <> nil then
    g_BoxItemList.AddObject(sBox, List);
  LoadList.Free;
  Result := 1;
end;

function TFrmDB.InitMapNimbus: Integer;
begin
  Result := 0;
end;

function TFrmDB.LoadMapInfo: Integer;

  function LoadMapQuest(sName: string): TMerchant;
  var
    QuestNPC: TMerchant;
  begin
    QuestNPC := TMerchant.Create;
    QuestNPC.m_sMapName := '0';
    QuestNPC.m_nCurrX := 0;
    QuestNPC.m_nCurrY := 0;
    QuestNPC.m_sCharName := sName;
    QuestNPC.m_sFCharName := FilterCharName(sName);
    QuestNPC.m_nFlag := 0;
    QuestNPC.m_wAppr := 0;
    QuestNPC.m_sFilePath := 'MapQuest_def\';
    QuestNPC.m_boIsHide := True;
    QuestNPC.m_boIsQuest := False;
    UserEngine.QuestNPCList.Add(QuestNPC);
    Result := QuestNPC;
  end;

  procedure LoadSubMapInfo(LoadList: TStringList; sFileName: string);
  var
    i: Integer;
    sFilePatchName, sFileDir: string;
    LoadMapList: TStringList;
  begin
    sFileDir := g_Config.sEnvirDir + 'MapInfo\';
    if not DirectoryExists(sFileDir) then
      CreateDir(sFileDir);
    sFilePatchName := sFileDir + sFileName;
    if FileExists(sFilePatchName) then
    begin
      LoadMapList := TStringList.Create;
      LoadMapList.LoadFromFile(sFilePatchName);
      for i := 0 to LoadMapList.Count - 1 do
        LoadList.Add(LoadMapList.Strings[i]);
      LoadMapList.Free;
    end;
  end;
var
  i, ii, iidx: Integer;
  pm: pTMagic;
  sFileName, sCaption: string;
  LoadList, sList: TStringList;
  s30, s34, s38, sMapName, s44, sMapDesc, s4C, sReConnectMap: string;
  n14, n18, n1C, n20: Integer;
  nServerIndex: Integer;
  MapFlag: TMapFlag;
  QuestNPC: TMerchant;
  sMapInfoFile: string;
  pDigItemLists: PTDigItemLists;
  Envir: TEnvirnoment;
begin
  Result := -1;
  sCaption := FrmMain.Caption;
  sFileName := g_Config.sEnvirDir + 'MapInfo.txt';
  if FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    if LoadList.Count <= 0 then
    begin
      LoadList.Free;
      Exit;
    end;
    sList := TStringList.Create;
    i := 0;
    while (True) do
    begin
      if i >= LoadList.Count then
        Break;
      if CompareLStr('loadmapinfo', LoadList.Strings[i], Length('loadmapinfo')) then
      begin
        sMapInfoFile := GetValidStr3(LoadList.Strings[i], s30, [' ', #9]);
        LoadList.Delete(i);
        if sMapInfoFile <> '' then
          LoadSubMapInfo(LoadList, sMapInfoFile);
      end;
      Inc(i);
    end;

    Result := LoadList.Count;
    for i := 0 to LoadList.Count - 1 do
    begin
      s30 := LoadList.Strings[i];
      if (s30 <> '') and (s30[1] = '[') then
      begin
        //sMapName := '';
        s30 := ArrestStringEx(s30, '[', ']', sMapName);
        sMapDesc := GetValidStrCap(sMapName, sMapName, [' ', ',', #9]);
        if sMapName = '' then
          Continue;
        if (sMapDesc <> '') and (sMapDesc[1] = '"') then
          ArrestStringEx(sMapDesc, '"', '"', sMapDesc);
        s4C := Trim(GetValidStr3(sMapDesc, sMapDesc, [' ', ',', #9]));
        nServerIndex := Str_ToInt(s4C, 0);
        FrmMain.Caption := Format('%s[正在初始化地图文件(%d/%d)]', [sCaption, i + 1, LoadList.Count]);
        QuestNPC := nil;
        FillChar(MapFlag, SizeOf(TMapFlag), #0);
        MapFlag.nL := 1;
        MapFlag.nNEEDSETONFlag := -1;
        MapFlag.nNeedONOFF := -1;
        MapFlag.nMUSICID := -1;
        //MapFlag.PCollectExp := nil;
        //MapFlag.nGuildTerritory := -1;
        while (True) do
        begin
          if s30 = '' then
            Break;
          s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
          if s34 = '' then
            Break;
          if CompareText(s34, 'SAFE') = 0 then
          begin
            MapFlag.boSAFE := True;
            Continue;
          end;
          if CompareText(s34, 'DARK') = 0 then
          begin
            MapFlag.boDARK := True;
            Continue;
          end;
          if CompareText(s34, 'FIGHT') = 0 then
          begin
            MapFlag.boFIGHTZone := True;
            Continue;
          end;
          if CompareText(s34, 'FIGHT2') = 0 then
          begin
            MapFlag.boFIGHT2Zone := True;
            Continue;
          end;
          if CompareText(s34, 'FIGHT3') = 0 then
          begin
            MapFlag.boFIGHT3Zone := True;
            Continue;
          end;
          if CompareText(s34, 'DAY') = 0 then
          begin
            MapFlag.boDAY := True;
            Continue;
          end;
          if CompareText(s34, 'QUIZ') = 0 then
          begin
            MapFlag.boQUIZ := True;
            Continue;
          end;
          if CompareLStr(s34, 'NORECONNECT', Length('NORECONNECT')) then
          begin
            MapFlag.boNORECONNECT := True;
            ArrestStringEx(s34, '(', ')', sReConnectMap);
            MapFlag.sReConnectMap := sReConnectMap;
            if MapFlag.sReConnectMap = '' then
              Result := -11;
            Continue;
          end;
          if CompareLStr(s34, 'CHECKQUEST', Length('CHECKQUEST')) then
          begin
            ArrestStringEx(s34, '(', ')', s38);
            QuestNPC := LoadMapQuest(s38);
            Continue;
          end;
          if CompareLStr(s34, 'NEEDSET_ON', Length('NEEDSET_ON')) then
          begin
            MapFlag.nNeedONOFF := 1;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nNEEDSETONFlag := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'NEEDSET_OFF', Length('NEEDSET_OFF')) then
          begin
            MapFlag.nNeedONOFF := 0;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nNEEDSETONFlag := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'MUSIC', Length('MUSIC')) then
          begin
            MapFlag.boMUSIC := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nMUSICID := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'EXPRATE', Length('EXPRATE')) then
          begin
            MapFlag.boEXPRATE := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nEXPRATE := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'PKWINLEVEL', Length('PKWINLEVEL')) then
          begin
            MapFlag.boPKWINLEVEL := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPKWINLEVEL := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'PKWINEXP', Length('PKWINEXP')) then
          begin
            MapFlag.boPKWINEXP := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPKWINEXP := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'PKLOSTLEVEL', Length('PKLOSTLEVEL')) then
          begin
            MapFlag.boPKLOSTLEVEL := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPKLOSTLEVEL := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'PKLOSTEXP', Length('PKLOSTEXP')) then
          begin
            MapFlag.boPKLOSTEXP := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nPKLOSTEXP := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'DECHP', Length('DECHP')) then
          begin
            MapFlag.boDECHP := True;
            ArrestStringEx(s34, '(', ')', s38);

            MapFlag.nDECHPPOINT := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nDECHPTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'INCHP', Length('INCHP')) then
          begin
            MapFlag.boINCHP := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nINCHPPOINT := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nINCHPTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'COLLECTEXP', Length('COLLECTEXP')) then
          begin
            //New(MapFlag.PCollectExp);

            ArrestStringEx(s34, '(', ')', s38);
            s38 := GetValidStr3(s38, s44, ['/']);
            s38 := GetValidStr3(s38, s4C, ['/']);
            MapFlag.PCollectExp.nCollectExp := Str_ToInt(s44, -1);
            MapFlag.PCollectExp.nCollectIPExp := Str_ToInt(s4C, -1);

            s38 := GetValidStr3(s38, s44, ['/']);
            s38 := GetValidStr3(s38, s4C, ['/']);
            MapFlag.PCollectExp.nCollectRate := Str_ToInt(s44, 80);
            MapFlag.PCollectExp.nGainExpPayment := Str_ToInt(s4C, 1);

            s38 := GetValidStr3(s38, s4C, ['/']);
            MapFlag.PCollectExp.nCollectExpTime := Str_ToInt(s4C, 30);

            s38 := GetValidStr3(s38, s44, ['/']);
            s38 := GetValidStr3(s38, s4C, ['/']);
            ii := 1;
            while True do
            begin
              if s44 = '' then
                Break;
              s44 := GetValidStr3(s44, s38, ['|']);
              MapFlag.PCollectExp.dwCollectExps[ii] := Str_ToInt(s38, 600 * 1000 * ii);
              Inc(ii);
              if ii > 4 then
                Break;
            end;

            ii := 1;
            while True do
            begin
              if s4C = '' then
                Break;
              s4C := GetValidStr3(s4C, s38, ['|']);
              MapFlag.PCollectExp.dwCollectIPExps[ii] := Str_ToInt(s38, 240 * 1000 * ii);
              Inc(ii);
              if ii > 4 then
                Break;
            end;
            Continue;
          end;
          if CompareLStr(s34, 'DECGAMEGOLD', Length('DECGAMEGOLD')) then
          begin
            MapFlag.boDECGAMEGOLD := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nDECGAMEGOLD := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nDECGAMEGOLDTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'INCGAMEGOLD', Length('INCGAMEGOLD')) then
          begin
            MapFlag.boINCGAMEGOLD := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nINCGAMEGOLD := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nINCGAMEGOLDTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'INCGAMEPOINT', Length('INCGAMEPOINT')) then
          begin
            MapFlag.boINCGAMEPOINT := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nINCGAMEPOINT := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nINCGAMEPOINTTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'DECGAMEPOINT', Length('DECGAMEPOINT')) then
          begin
            MapFlag.boDECGAMEPOINT := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nDECGAMEPOINT := Str_ToInt(GetValidStr3(s38, s38, ['/']), -1);
            MapFlag.nDECGAMEPOINTTIME := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareText(s34, 'RUNHUMAN') = 0 then
          begin
            MapFlag.boRUNHUMAN := True;
            Continue;
          end;
          if CompareText(s34, 'RUNMON') = 0 then
          begin
            MapFlag.boRUNMON := True;
            Continue;
          end;
          if CompareText(s34, 'NEEDHOLE') = 0 then
          begin
            MapFlag.boNEEDHOLE := True;
            Continue;
          end;
          if CompareText(s34, 'NORECALL') = 0 then
          begin
            MapFlag.boNORECALL := True;
            Continue;
          end;
          if CompareText(s34, 'CANRIDE') = 0 then
          begin
            MapFlag.boCANRIDE := True;
            Continue;
          end;
          if CompareText(s34, 'CANBAT') = 0 then
          begin
            MapFlag.boCANBAT := True;
            Continue;
          end;
          if CompareText(s34, 'NOGUILDRECALL') = 0 then
          begin
            MapFlag.boNOGUILDRECALL := True;
            Continue;
          end;
          if CompareText(s34, 'NODEARRECALL') = 0 then
          begin
            MapFlag.boNODEARRECALL := True;
            Continue;
          end;
          if CompareText(s34, 'NOMASTERRECALL') = 0 then
          begin
            MapFlag.boNOMASTERRECALL := True;
            Continue;
          end;
          if CompareText(s34, 'NORANDOMMOVE') = 0 then
          begin
            MapFlag.boNORANDOMMOVE := True;
            Continue;
          end;
          if CompareText(s34, 'NODRUG') = 0 then
          begin
            MapFlag.boNODRUG := True;
            Continue;
          end;
          if CompareText(s34, 'NOMANNOMON') = 0 then
          begin
            MapFlag.boNoManNoMon := True;
            Continue;
          end;
          if CompareText(s34, 'MINE') = 0 then
          begin
            MapFlag.boMINE := True;
            Continue;
          end;
          if CompareText(s34, 'NOPOSITIONMOVE') = 0 then
          begin
            MapFlag.boNOPOSITIONMOVE := True;
            Continue;
          end;
          if CompareText(s34, 'NOTAGMAPINFO') = 0 then
          begin
            MapFlag.boNoTagMapInfo := True;
            Continue;
          end;
          if CompareLStr(s34, 'KILLFUNC', Length('KILLFUNC')) then
          begin
            MapFlag.boKILLFUNC := True;
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nKILLFUNCNO := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'NOTALLOWUSEITEMS', Length('NOTALLOWUSEITEMS')) then
          begin
            MapFlag.boNotAllowUseItems := True;
            ArrestStringEx(s34, '(', ')', s38);
            //MapFlag.sNotAllowUseItems := s38;
            if s38 <> '' then
            begin
              if MapFlag.sNotAllowUseItems = nil then
                MapFlag.sNotAllowUseItems := TList.Create;
              sList.Text := AnsiReplaceText(s38, '|', #13);
              for ii := 0 to sList.Count - 1 do
              begin
                iidx := UserEngine.GetStdItemIdx(sList[ii]);
                if iidx > 0 then
                  MapFlag.sNotAllowUseItems.Add(Pointer(iidx));
              end;
            end;
            Continue;
          end;
          if CompareLStr(s34, 'NOTALLOWUSEMAGIC', Length('NOTALLOWUSEMAGIC')) then
          begin
            MapFlag.boNotAllowUseMag := True;
            ArrestStringEx(s34, '(', ')', s38);
            //MapFlag.sNotAllowUseMag := s38;
            if s38 <> '' then
            begin
              if MapFlag.sNotAllowUseMag = nil then
                MapFlag.sNotAllowUseMag := TList.Create;
              sList.Text := AnsiReplaceText(s38, '|', #13);
              for ii := 0 to sList.Count - 1 do
              begin
                pm := UserEngine.FindMagic(sList[ii]);
                if pm <> nil then
                  MapFlag.sNotAllowUseMag.Add(Pointer(pm.wMagicId));
              end;
            end;
            Continue;
          end;
          if CompareText(s34, 'NORECALLHERO') = 0 then
          begin
            MapFlag.boNoRecallHero := True;
            Continue;
          end;
          if CompareText(s34, 'NOTHROWITEM') = 0 then
          begin
            MapFlag.boNOTHROWITEM := True;
            Continue;
          end;
          if CompareText(s34, 'STALL') = 0 then
          begin
            MapFlag.boStall := True;
            Continue;
          end;
          if CompareText(s34, 'NOSWITCHATTACKMODE') = 0 then
          begin
            MapFlag.boNoSwitchAttackMode := True;
            Continue;
          end;
          if CompareText(s34, 'NODEAL') = 0 then
          begin
            MapFlag.boNODEAL := True;
            Continue;
          end;
          if CompareLStr(s34, 'THUNDER', Length('THUNDER')) then
          begin
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nThunder := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'GREATTHUNDER', Length('GREATTHUNDER')) then
          begin
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nGreatThunder := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'LAVA', Length('LAVA')) then
          begin
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nLava := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'SPURT', Length('SPURT')) then
          begin
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nSpurt := Str_ToInt(s38, -1);
            Continue;
          end;
          if CompareLStr(s34, 'DIGITEM', Length('DIGITEM')) then
          begin
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nDigItem := Str_ToInt(s38, -1);
            s4C := '';
            if Pos('|', sMapName) > 0 then
            begin
              GetValidStr3(sMapName, s4C, ['|']);
            end
            else if Pos('>', sMapName) > 0 then
            begin
              s4C := ArrestStringEx(sMapName, '<', '>', s38);
            end;

            pDigItemLists := nil;
            if s4C <> '' then
              pDigItemLists := GetDigItemByName(s4C);
            if pDigItemLists = nil then
              pDigItemLists := GetDigItemByName(sMapName);

            if pDigItemLists <> nil then
              MapFlag.pDigItemList := pDigItemLists
            else
              MapFlag.nDigItem := 0;
            Continue;
          end;
          if CompareLStr(s34, 'SECRET', Length('SECRET')) then
          begin
            ArrestStringEx(s34, '(', ')', s38);
            if s38 <> '' then
            begin
              s38 := GetValidStr3(s38, s44, ['|']);
              MapFlag.nSecret := Str_ToInt(s44, 0);

              s38 := GetValidStr3(s38, s44, ['|']);
              MapFlag.nSecretShowName := s44;

              s38 := GetValidStr3(s38, s44, ['|']);
              MapFlag.nSecretClothShape := Str_ToInt(s44, 0);

              s38 := GetValidStr3(s38, s44, ['|']);
              MapFlag.nSecretWeaponShape := Str_ToInt(s44, 0);
            end;
            Continue;
          end;

          {if CompareLStr(s34, 'NIMBUS', Length('NIMBUS')) then begin
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nNimbus := Str_ToInt(s38, 0);
            Continue;
          end;}

          {if CompareLStr(s34, 'GT', Length('GT')) then begin
            ArrestStringEx(s34, '(', ')', s38);
            MapFlag.nGuildTerritory := Str_ToInt(s38, -1);
            if g_GuildTerritory.FindGuildTerritory(MapFlag.nGuildTerritory) = nil then
              g_GuildTerritory.AddEmptyGT(MapFlag.nGuildTerritory);
            Continue;
          end;}
          if (s34[1] = 'L') then
            MapFlag.nL := Str_ToInt(Copy(s34, 2, Length(s34) - 1), 1);
        end;

        Envir := g_MapManager.AddMapInfo(sMapName, sMapDesc, nServerIndex, @MapFlag, QuestNPC);
        if Envir = nil then
        begin
          Result := -10;
          LoadList.Free;
          sList.Free;
          Exit;
        end;
      end;
    end;
    FrmMain.Caption := sCaption;
    //加载地图连接点
    for i := 0 to LoadList.Count - 1 do
    begin
      s30 := LoadList.Strings[i];
      if (s30 <> '') and (s30[1] <> '[') and (s30[1] <> ';') then
      begin
        s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
        sMapName := s34;
        s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
        n14 := Str_ToInt(s34, 0);
        s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
        n18 := Str_ToInt(s34, 0);
        s30 := GetValidStr3(s30, s34, [' ', ',', '-', '>', #9]);
        s44 := s34;
        s30 := GetValidStr3(s30, s34, [' ', ',', #9]);
        n1C := Str_ToInt(s34, 0);
        s30 := GetValidStr3(s30, s34, [' ', ',', ';', #9]);
        n20 := Str_ToInt(s34, 0);
        g_MapManager.AddMapRoute(sMapName, n14, n18, s44, n1C, n20);
      end;
    end;
    LoadList.Free;
    sList.Free;
  end;
end;

procedure TFrmDB.QFunctionNPC;
var
  sScriptFile: string;
  sScritpDir: string;
  SaveList: TStringList;
  sShowFile: string;
begin
  try
    sScriptFile := g_Config.sEnvirDir + sMarket_Def + 'QFunction-0.txt';
    sShowFile := ReplaceChar(sScriptFile, '\', '/');
    sScritpDir := g_Config.sEnvirDir + sMarket_Def;
    if not DirectoryExists(sScritpDir) then
      MkDir(PChar(sScritpDir));
    if not FileExists(sScriptFile) then
    begin
      SaveList := TStringList.Create;
      SaveList.Add(';此脚为功能脚本，用于实现各种与脚本有关的功能');
      SaveList.SaveToFile(sScriptFile);
      SaveList.Free;
    end;
    if FileExists(sScriptFile) then
    begin
      g_FunctionNPC := TMerchant.Create;
      g_FunctionNPC.m_sMapName := '0';
      g_FunctionNPC.m_nCurrX := 0;
      g_FunctionNPC.m_nCurrY := 0;
      g_FunctionNPC.m_sCharName := 'QFunction';
      g_FunctionNPC.m_sFCharName := FilterCharName(g_FunctionNPC.m_sCharName);
      g_FunctionNPC.m_nFlag := 0;
      g_FunctionNPC.m_wAppr := 0;
      g_FunctionNPC.m_sFilePath := sMarket_Def;
      g_FunctionNPC.m_sScript := 'QFunction';
      g_FunctionNPC.m_boIsHide := True;
      g_FunctionNPC.m_boIsQuest := False;
      UserEngine.AddMerchant(g_FunctionNPC);
      //UserEngine.QuestNPCList.Add(g_FunctionNPC);
    end
    else
      g_FunctionNPC := nil;
  except
    g_FunctionNPC := nil;
  end;
end;

procedure TFrmDB.QMapEventNPC;
var
  sScriptFile: string;
  sScritpDir: string;
  SaveList: TStringList;
  sShowFile: string;
begin
  try
    sScriptFile := g_Config.sEnvirDir + sMarket_Def + 'QMapEvent-0.txt';
    sShowFile := ReplaceChar(sScriptFile, '\', '/');
    sScritpDir := g_Config.sEnvirDir + sMarket_Def;
    if not DirectoryExists(sScritpDir) then
      MkDir(PChar(sScritpDir));
    if not FileExists(sScriptFile) then
    begin
      SaveList := TStringList.Create;
      SaveList.Add(';此为地图事件功能脚本，用于实现各种与脚本有关的功能');
      SaveList.SaveToFile(sScriptFile);
      SaveList.Free;
    end;
    if FileExists(sScriptFile) then
    begin
      g_MapEventNPC := TMerchant.Create;
      g_MapEventNPC.m_sMapName := '0';
      g_MapEventNPC.m_nCurrX := 0;
      g_MapEventNPC.m_nCurrY := 0;
      g_MapEventNPC.m_sCharName := 'QMapEvent';
      g_MapEventNPC.m_sFCharName := FilterCharName(g_MapEventNPC.m_sCharName);
      g_MapEventNPC.m_nFlag := 0;
      g_MapEventNPC.m_wAppr := 0;
      g_MapEventNPC.m_sFilePath := sMarket_Def;
      g_MapEventNPC.m_sScript := 'QMapEvent';
      g_MapEventNPC.m_boIsHide := True;
      g_MapEventNPC.m_boIsQuest := False;
      UserEngine.AddMerchant(g_MapEventNPC);
    end
    else
      g_MapEventNPC := nil;
  except
    g_MapEventNPC := nil;
  end;
end;

procedure TFrmDB.QMangeNPC();
var
  sScriptFile: string;
  sScritpDir: string;
  SaveList: TStringList;
  sShowFile: string;
begin
  try
    sScriptFile := g_Config.sEnvirDir + 'MapQuest_def\' + 'QManage.txt';
    sShowFile := ReplaceChar(sScriptFile, '\', '/');
    sScritpDir := g_Config.sEnvirDir + 'MapQuest_def\';
    if not DirectoryExists(sScritpDir) then
      MkDir(PChar(sScritpDir));

    if not FileExists(sScriptFile) then
    begin
      SaveList := TStringList.Create;
      SaveList.Add(';此脚为登录脚本，人物每次登录时都会执行此脚本，所有人物初始设置都可以放在此脚本中');
      SaveList.Add(';修改脚本内容，可用@ReloadManage命令重新加载该脚本，不须重启程序');
      SaveList.Add('[@Login]');
      SaveList.Add('#IF');
      SaveList.Add('#ACT');
      SaveList.Add(';设置10倍杀怪经验');
      SaveList.Add(';CANGETEXP 1 10');
      SaveList.Add('#say');
      SaveList.Add('98KM2传奇登录脚本运行成功，欢迎进入本游戏！\ \');
      SaveList.Add('<关闭/@exit> \ \');
      SaveList.Add('登录脚本文件位于: \');
      SaveList.Add(sShowFile + '\');
      SaveList.Add('脚本内容请自行按自己的要求修改');
      SaveList.SaveToFile(sScriptFile);
      SaveList.Free;
    end;
    if FileExists(sScriptFile) then
    begin
      g_ManageNPC := TMerchant.Create;
      g_ManageNPC.m_sMapName := '0';
      g_ManageNPC.m_nCurrX := 0;
      g_ManageNPC.m_nCurrY := 0;
      g_ManageNPC.m_sCharName := 'QManage';
      g_ManageNPC.m_sFCharName := FilterCharName(g_ManageNPC.m_sCharName);
      g_ManageNPC.m_nFlag := 0;
      g_ManageNPC.m_wAppr := 0;
      g_ManageNPC.m_sFilePath := 'MapQuest_def\';
      g_ManageNPC.m_boIsHide := True;
      g_ManageNPC.m_boIsQuest := False;
      UserEngine.QuestNPCList.Add(g_ManageNPC);
    end
    else
      g_ManageNPC := nil;
  except
    g_ManageNPC := nil;
  end;
end;

procedure TFrmDB.RobotNPC();
var
  sScriptFile: string;
  sScritpDir: string;
  tSaveList: TStringList;
begin
  try
    sScriptFile := g_Config.sEnvirDir + 'Robot_def\' + 'RobotManage.txt';
    sScritpDir := g_Config.sEnvirDir + 'Robot_def\';
    if not DirectoryExists(sScritpDir) then
      MkDir(PChar(sScritpDir));

    if not FileExists(sScriptFile) then
    begin
      tSaveList := TStringList.Create;
      tSaveList.Add(';此脚为机器人专用脚本，用于机器人处理功能用的脚本');
      tSaveList.SaveToFile(sScriptFile);
      tSaveList.Free;
    end;
    if FileExists(sScriptFile) then
    begin
      g_RobotNPC := TMerchant.Create;
      g_RobotNPC.m_sMapName := '0';
      g_RobotNPC.m_nCurrX := 0;
      g_RobotNPC.m_nCurrY := 0;
      g_RobotNPC.m_sCharName := 'RobotManage';
      g_RobotNPC.m_sFCharName := FilterCharName(g_RobotNPC.m_sCharName);
      g_RobotNPC.m_nFlag := 0;
      g_RobotNPC.m_wAppr := 0;
      g_RobotNPC.m_sFilePath := 'Robot_def\';
      g_RobotNPC.m_boIsHide := True;
      g_RobotNPC.m_boIsQuest := False;
      UserEngine.QuestNPCList.Add(g_RobotNPC);
    end
    else
      g_RobotNPC := nil;
  except
    g_RobotNPC := nil;
  end;
end;

function TFrmDB.LoadMapQuest(): Integer;
var
  sFileName, tStr: string;
  tMapQuestList: TStringList;
  i: Integer;
  s18, s1C, s20, s24, s28, s2C, s30, s34: string;
  n38, n3C: Integer;
  boGrouped: Boolean;
  Map: TEnvirnoment;
begin
  Result := 1;
  sFileName := g_Config.sEnvirDir + 'MapQuest.txt';
  if FileExists(sFileName) then
  begin
    tMapQuestList := TStringList.Create;
    tMapQuestList.LoadFromFile(sFileName);
    for i := 0 to tMapQuestList.Count - 1 do
    begin
      tStr := tMapQuestList.Strings[i];
      if (tStr <> '') and (tStr[1] <> ';') then
      begin
        tStr := GetValidStr3(tStr, s18, [' ', #9]);
        tStr := GetValidStr3(tStr, s1C, [' ', #9]);
        tStr := GetValidStr3(tStr, s20, [' ', #9]);
        tStr := GetValidStr3(tStr, s24, [' ', #9]);

        if (s24 <> '') and (s24[1] = '"') then
          ArrestStringEx(s24, '"', '"', s24);
        tStr := GetValidStr3(tStr, s28, [' ', #9]);
        if (s28 <> '') and (s28[1] = '"') then
          ArrestStringEx(s28, '"', '"', s28);
        tStr := GetValidStr3(tStr, s2C, [' ', #9]);
        tStr := GetValidStr3(tStr, s30, [' ', #9]);

        if (s18 <> '') and (s24 <> '') and (s2C <> '') then
        begin
          Map := g_MapManager.FindMap(s18);
          if Map <> nil then
          begin
            ArrestStringEx(s1C, '[', ']', s34);
            n38 := Str_ToInt(s34, 0);
            n3C := Str_ToInt(s20, 0);
            if CompareLStr(s30, 'GROUP', Length('GROUP')) then
              boGrouped := True
            else
              boGrouped := False;
            if not Map.CreateQuest(n38, n3C, s24, s28, s2C, boGrouped) then
              Result := -i;
          end
          else
            Result := -i;
        end
        else
          Result := -i;
      end;
    end;
    tMapQuestList.Free;
  end;
  QMangeNPC();
  QFunctionNPC();
  QMapEventNPC;
  RobotNPC();
end;

function TFrmDB.LoadMerchant(): Integer;
var
  sFileName, sLineText, sScript, sMapName, sX, sY, sName, sFlag,
    sAppr, sIsCalste, sCanMove, sMoveTime, sChgColor, sChgColorTime: string;
  tMerchantList: TStringList;
  tMerchantNPC: TMerchant;
  i, n, nColor: Integer;
begin
  sFileName := g_Config.sEnvirDir + 'Merchant.txt';
  if FileExists(sFileName) then
  begin
    tMerchantList := TStringList.Create;
    tMerchantList.LoadFromFile(sFileName);
    for i := 0 to tMerchantList.Count - 1 do
    begin
      sLineText := Trim(tMerchantList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then
      begin
        sLineText := GetValidStr3(sLineText, sScript, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sMapName, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sX, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sY, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sName, [' ', #9]);
        if (sName <> '') and (sName[1] = '"') then
          ArrestStringEx(sName, '"', '"', sName);
        sLineText := GetValidStr3(sLineText, sFlag, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sAppr, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sIsCalste, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sCanMove, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sMoveTime, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sChgColor, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sChgColorTime, [' ', #9]);

        if (sScript <> '') and (sMapName <> '') and (sAppr <> '') then
        begin
          tMerchantNPC := TMerchant.Create;
          tMerchantNPC.m_sScript := sScript;
          tMerchantNPC.m_sMapName := sMapName;
          tMerchantNPC.m_nCurrX := Str_ToInt(sX, 0);
          tMerchantNPC.m_nCurrY := Str_ToInt(sY, 0);
          tMerchantNPC.m_sCharName := sName;
          tMerchantNPC.m_sFCharName := FilterCharName(tMerchantNPC.m_sCharName);
          tMerchantNPC.m_nFlag := Str_ToInt(sFlag, 0);
          tMerchantNPC.m_btDirection := tMerchantNPC.m_nFlag;
          tMerchantNPC.m_wAppr := Str_ToInt(sAppr, 0);
          tMerchantNPC.m_dwMoveTime := Str_ToInt(sMoveTime, 0);
          tMerchantNPC.m_boCastle := Str_ToInt(sIsCalste, 0) <> 0;
          tMerchantNPC.m_boCanMove := False;
          if (Str_ToInt(sCanMove, 0) <> 0) and (tMerchantNPC.m_dwMoveTime > 0) then
            tMerchantNPC.m_boCanMove := True;
          nColor := Str_ToInt(sChgColorTime, 0);
          if nColor >= 0 then
          begin
            n := Str_ToInt(sChgColor, 0);
            if (n = 1) then
            begin
              tMerchantNPC.m_boAutoChangeColor := True;
              tMerchantNPC.m_dwAutoChangeColorTime := nColor * 500;
            end
            else if (n = 2) then
            begin
              tMerchantNPC.m_boFixColor := True;
              tMerchantNPC.m_nFixColorIdx := nColor;
            end;
          end;
          UserEngine.AddMerchant(tMerchantNPC);
        end;
      end;
    end;
    tMerchantList.Free;
  end;
  Result := 1;
end;

function TFrmDB.LoadMinMap: Integer;
var
  sFileName, tStr, sMapNO, sMapIdx: string;
  tMapList: TStringList;
  i, nIdx: Integer;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'MiniMap.txt';
  if FileExists(sFileName) then
  begin
    MiniMapList.Clear;
    tMapList := TStringList.Create;
    tMapList.LoadFromFile(sFileName);
    for i := 0 to tMapList.Count - 1 do
    begin
      tStr := tMapList.Strings[i];
      if (tStr <> '') and (tStr[1] <> ';') then
      begin
        tStr := GetValidStr3(tStr, sMapNO, [' ', #9]);
        tStr := GetValidStr3(tStr, sMapIdx, [' ', #9]);
        nIdx := Str_ToInt(sMapIdx, 0);
        if nIdx > 0 then
          MiniMapList.AddObject(sMapNO, TObject(nIdx));
      end;
    end;
    tMapList.Free;
  end;
end;

function TFrmDB.LoadMonGen(): Integer;

  procedure LoadMapGen(MonGenList: TStringList; sFileName: string);
  var
    i: Integer;
    sFilePatchName: string;
    sFileDir: string;
    LoadList: TStringList;
  begin
    sFileDir := g_Config.sEnvirDir + 'MonGen\';
    if not DirectoryExists(sFileDir) then
      CreateDir(sFileDir);
    sFilePatchName := sFileDir + sFileName;
    if FileExists(sFilePatchName) then
    begin
      LoadList := TStringList.Create;
      LoadList.LoadFromFile(sFilePatchName);
      for i := 0 to LoadList.Count - 1 do
        MonGenList.Add(LoadList.Strings[i]);
      LoadList.Free;
    end;
  end;
var
  sFileName, sLineText, sData: string;
  MonGenInfo: pTMonGenInfo;
  LoadList: TStringList;
  sMapGenFile: string;
  i: Integer;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'MonGen.txt';
  if FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    i := 0;
    while (True) do
    begin
      if i >= LoadList.Count then
        Break;
      if CompareLStr('loadgen', LoadList.Strings[i], Length('loadgen')) then
      begin
        sMapGenFile := GetValidStr3(LoadList.Strings[i], sLineText, [' ', #9]);
        LoadList.Delete(i);
        if sMapGenFile <> '' then
        begin
          LoadMapGen(LoadList, sMapGenFile);
        end;
      end;
      Inc(i);
    end;
    for i := 0 to LoadList.Count - 1 do
    begin
      sLineText := LoadList.Strings[i];
      if (sLineText <> '') and (sLineText[1] <> ';') then
      begin
        New(MonGenInfo);
        sLineText := GetValidStr3(sLineText, sData, [' ', #9]);
        MonGenInfo.sMapName := sData;

        sLineText := GetValidStr3(sLineText, sData, [' ', #9]);
        MonGenInfo.nX := Str_ToInt(sData, 0);

        sLineText := GetValidStr3(sLineText, sData, [' ', #9]);
        MonGenInfo.nY := Str_ToInt(sData, 0);

        sLineText := GetValidStrCap(sLineText, sData, [' ', #9]);
        if (sData <> '') and (sData[1] = '"') then
          ArrestStringEx(sData, '"', '"', sData);
        MonGenInfo.sMonName := sData;

        sLineText := GetValidStr3(sLineText, sData, [' ', #9]);
        MonGenInfo.nRange := Str_ToInt(sData, 0);

        sLineText := GetValidStr3(sLineText, sData, [' ', #9]);
        MonGenInfo.nCount := Str_ToInt(sData, 0);

        sLineText := GetValidStr3(sLineText, sData, [' ', #9]);
        MonGenInfo.dwZenTime := Str_ToInt(sData, -1) * 60 * 1000;

        sLineText := GetValidStr3(sLineText, sData, [' ', #9]);
        MonGenInfo.nMissionGenRate := Str_ToInt(sData, 0);

        if (MonGenInfo.sMapName <> '') and (MonGenInfo.sMonName <> '') and (MonGenInfo.dwZenTime <> 0) and (g_MapManager.GetMapInfo(g_nServerIndex, MonGenInfo.sMapName) <> nil) then
        begin
          MonGenInfo.dwStartTick := 0;
          MonGenInfo.CertList := TList.Create;
          MonGenInfo.Envir := g_MapManager.FindMap(MonGenInfo.sMapName);
          MonGenInfo.nActiveCount := 0;
          if MonGenInfo.Envir <> nil then
            UserEngine.m_MonGenList.Add(MonGenInfo)
          else
            Dispose(MonGenInfo);
        end
        else
          Dispose(MonGenInfo); //0415  List index out of bounds
      end;
    end;
    New(MonGenInfo);
    MonGenInfo.sMapName := '';
    MonGenInfo.sMonName := '';
    MonGenInfo.CertList := TList.Create;
    MonGenInfo.Envir := nil;
    MonGenInfo.nActiveCount := 0;
    UserEngine.m_MonGenList.Add(MonGenInfo);
    LoadList.Free;
    Result := 1;
  end;
end;

function TFrmDB.LoadMonsterDB(): Integer;
var
  i: Integer;
  sName: string;
  Monster: pTMonInfo;
resourcestring
  sSQLString = 'select * from Monster';
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    UserEngine.LoadMonSpAbil();

    for i := 0 to UserEngine.MonsterList.Count - 1 do
{$IF USEHASHLIST = 1}
      Dispose(pTMonInfo(UserEngine.MonsterList.GetValues(UserEngine.MonsterList.Keys[i])));
{$ELSE}
    Dispose(pTMonInfo(UserEngine.MonsterList[i]));
{$IFEND}
    UserEngine.MonsterList.Clear;

    Query.SQL.Clear;
    Query.SQL.Add(sSQLString);
    try
      Query.Open;
    finally
      Result := -1;
    end;

    for i := 0 to Query.RecordCount - 1 do
    begin
      sName := Trim(Query.FieldByName('NAME').AsString);
{$IF USEHASHLIST = 1}
      if UserEngine.MonsterList.Exists(sName) then
      begin
        MainOutMessageAPI('Monster.DB 怪物重复: ' + sName);
        Query.Next;
        Continue;
      end;
{$IFEND}

      New(Monster);
      FillChar(Monster^, SizeOf(Monster^), 0);

      Monster.sName := Trim(Query.FieldByName('NAME').AsString);
      Monster.btRace := Query.FieldByName('Race').AsInteger;
      Monster.btRaceImg := Query.FieldByName('RaceImg').AsInteger;
      Monster.wAppr := Query.FieldByName('Appr').AsInteger;
      Monster.wLevel := Query.FieldByName('Lvl').AsInteger;
      Monster.btLifeAttrib := Query.FieldByName('Undead').AsInteger;
      Monster.wCoolEye := Query.FieldByName('CoolEye').AsInteger;
      Monster.dwExp := Query.FieldByName('Exp').AsInteger;
      if Monster.btRace in [110, 111] then
        Monster.wHP := Query.FieldByName('HP').AsInteger
      else
        Monster.wHP := Round(Query.FieldByName('HP').AsInteger * (g_Config.nMonsterPowerRate / 10));
      Monster.wMP := Query.FieldByName('MP').AsInteger;
      Monster.wAC := Round(Query.FieldByName('AC').AsInteger * (g_Config.nMonsterPowerRate / 10));
      Monster.wMAC := Round(Query.FieldByName('MAC').AsInteger * (g_Config.nMonsterPowerRate / 10));
      Monster.wDC := Round(Query.FieldByName('DC').AsInteger * (g_Config.nMonsterPowerRate / 10));
      Monster.wMaxDC := Round(Query.FieldByName('DCMAX').AsInteger * (g_Config.nMonsterPowerRate / 10));
      Monster.wMC := Round(Query.FieldByName('MC').AsInteger * (g_Config.nMonsterPowerRate / 10));
      Monster.wSC := Round(Query.FieldByName('SC').AsInteger * (g_Config.nMonsterPowerRate / 10));
      Monster.wSpeed := Query.FieldByName('SPEED').AsInteger;
      Monster.wHitPoint := Query.FieldByName('HIT').AsInteger;
      Monster.wWalkSpeed := _MAX(200, Query.FieldByName('WALK_SPD').AsInteger);
      Monster.wWalkStep := _MAX(1, Query.FieldByName('WalkStep').AsInteger);
      Monster.wWalkWait := Query.FieldByName('WalkWait').AsInteger;
      Monster.wAttackSpeed := Query.FieldByName('ATTACK_SPD').AsInteger;
      if Monster.wWalkSpeed < 200 then
        Monster.wWalkSpeed := 200;
      if Monster.wAttackSpeed < 200 then
        Monster.wAttackSpeed := 200;

      Monster.ItemList := nil;
      LoadMonitems(Monster.sName, Monster.ItemList);

      LoadMonSpAbil(Monster);

{$IF USEHASHLIST = 1}
      UserEngine.MonsterList.Put(sName, TObject(Monster));
{$ELSE}
      UserEngine.MonsterList.Add(Monster);
{$IFEND}
      Result := 1;
      Query.Next;
    end;
    Query.Close;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TFrmDB.LoadMonSpAbil(MonInfo: pTMonInfo): Integer;
var
  MonSpAbil: pTMonSpAbil;
begin
  Result := 0;
  MonSpAbil := pTMonSpAbil(UserEngine.MonSpAbilList.GetValues(MonInfo.sName));
  if MonSpAbil <> nil then
  begin
    MonInfo.spMonAbil := MonSpAbil^;
    {MainOutMessageAPI(MonInfo.sName + Format(' 2 %d %d %d %d %d', [MonInfo.spMonAbil.btIgnoreTagDefence,
      MonInfo.spMonAbil.btDamageAddOn,
        MonInfo.spMonAbil.btDamageRebound,
        MonInfo.spMonAbil.btACDamageReduction,
        MonInfo.spMonAbil.btMCDamageReduction]));}
  end;
end;

function TFrmDB.LoadMonitems(MonName: string; var ItemList: TList): Integer;
var
  i: Integer;
  s24: string;
  LoadList: TStringList;
  MonItem: pTMonItemInfo;
  s28, s2C, s30: string;
  n18, n1C, n20: Integer;
begin
  Result := 0;
  s24 := g_Config.sEnvirDir + 'MonItems\' + MonName + '.txt';
  if FileExists(s24) then
  begin
    if ItemList <> nil then
    begin
      for i := 0 to ItemList.Count - 1 do
        Dispose(pTMonItemInfo(ItemList.Items[i]));
      ItemList.Clear;
    end;
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(s24);
    for i := 0 to LoadList.Count - 1 do
    begin
      s28 := LoadList.Strings[i];
      if (s28 <> '') and (s28[1] <> ';') then
      begin
        s28 := GetValidStr3(s28, s30, [' ', '/', #9]);
        n18 := Str_ToInt(s30, -1);
        s28 := GetValidStr3(s28, s30, [' ', '/', #9]);
        n1C := Str_ToInt(s30, -1);
        s28 := GetValidStr3(s28, s30, [' ', #9]);
        if s30 <> '' then
        begin
          if s30[1] = '"' then
            ArrestStringEx(s30, '"', '"', s30);
        end;
        s2C := s30;
        s28 := GetValidStr3(s28, s30, [' ', #9]);
        n20 := Str_ToInt(s30, 1);
        if (n18 > 0) and (n1C > 0) and (s2C <> '') then
        begin
          if ItemList = nil then
            ItemList := TList.Create;
          New(MonItem);
          MonItem.SelPoint := n18 - 1;
          MonItem.MaxPoint := n1C;
          MonItem.ItemName := s2C;
          MonItem.Count := n20;
          MonItem.IsGold := CompareText(s2C, sSTRING_GOLDNAME) = 0;
          ItemList.Add(MonItem);
          Inc(Result);
        end;
      end;
    end;
    LoadList.Free;
  end;
end;

function TFrmDB.LoadNpcs(): Integer;
var
  sFileName, s18, { s1C, } s20, s24, s28, s2C, s30, s34, s38: string;
  LoadList: TStringList;
  NPC: TNormNpc;
  i: Integer;
begin
  sFileName := g_Config.sEnvirDir + 'Npcs.txt';
  if FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      s18 := Trim(LoadList.Strings[i]);
      if (s18 <> '') and (s18[1] <> ';') then
      begin
        s18 := GetValidStrCap(s18, s20, [' ', #9]);
        if (s20 <> '') and (s20[1] = '"') then
          ArrestStringEx(s20, '"', '"', s20);

        s18 := GetValidStr3(s18, s24, [' ', #9]);
        s18 := GetValidStr3(s18, s28, [' ', #9]);
        s18 := GetValidStr3(s18, s2C, [' ', #9]);
        s18 := GetValidStr3(s18, s30, [' ', #9]);
        s18 := GetValidStr3(s18, s34, [' ', #9]);
        s18 := GetValidStr3(s18, s38, [' ', #9]);
        if (s20 <> '') and (s28 <> '') and (s38 <> '') then
        begin
          NPC := nil;
          case Str_ToInt(s24, 0) of
            0: NPC := TMerchant.Create;
            1: NPC := TGuildOfficial.Create;
            2: NPC := TCastleOfficial.Create;
          end;
          if NPC <> nil then
          begin
            NPC.m_sMapName := s28;
            NPC.m_nCurrX := Str_ToInt(s2C, 0);
            NPC.m_nCurrY := Str_ToInt(s30, 0);
            NPC.m_sCharName := s20;
            NPC.m_sFCharName := FilterCharName(NPC.m_sCharName);
            NPC.m_nFlag := Str_ToInt(s34, 0);
            NPC.m_btDirection := NPC.m_nFlag;
            NPC.m_wAppr := Str_ToInt(s38, 0);
            UserEngine.QuestNPCList.Add(NPC);
          end;
        end;
      end;
    end;
    LoadList.Free;
  end;
  Result := 1;
end;

function TFrmDB.LoadQuestDiary(): Integer;

  function GetNumber(nIndex: Integer): string;
  begin
    if nIndex >= 1000 then
    begin
      Result := IntToStr(nIndex);
      Exit;
    end;
    if nIndex >= 100 then
    begin
      Result := IntToStr(nIndex) + '0';
      Exit;
    end;
    Result := IntToStr(nIndex) + '00';
  end;
var
  i, ii: Integer;
  QDDinfoList: TList;
  QDDinfo: pTQDDinfo;
  s14, s18, s1C, s20: string;
  bo2D: Boolean;
  nC: Integer;
  LoadList: TStringList;
begin
  Result := 1;
  for i := 0 to QuestDiaryList.Count - 1 do
  begin
    QDDinfoList := QuestDiaryList.Items[i];
    for ii := 0 to QDDinfoList.Count - 1 do
    begin
      QDDinfo := QDDinfoList.Items[ii];
      QDDinfo.sList.Free;
      Dispose(QDDinfo);
    end;
    QDDinfoList.Free;
  end;
  QuestDiaryList.Clear;
  bo2D := False;
  nC := 1;
  while (True) do
  begin
    QDDinfoList := nil;
    s14 := 'QuestDiary\' + GetNumber(nC) + '.txt';
    if FileExists(s14) then
    begin
      s18 := '';
      QDDinfo := nil;
      LoadList := TStringList.Create;
      LoadList.LoadFromFile(s14);
      for i := 0 to LoadList.Count - 1 do
      begin
        s1C := LoadList.Strings[i];
        if (s1C <> '') and (s1C[1] <> ';') then
        begin
          if (s1C[1] = '[') and (Length(s1C) > 2) then
          begin
            if s18 = '' then
            begin
              ArrestStringEx(s1C, '[', ']', s18);
              QDDinfoList := TList.Create;
              New(QDDinfo);
              QDDinfo.n00 := nC;
              QDDinfo.s04 := s18;
              QDDinfo.sList := TStringList.Create;
              QDDinfoList.Add(QDDinfo);
              bo2D := True;
            end
            else
            begin
              if s1C[1] <> '@' then
              begin
                s1C := GetValidStr3(s1C, s20, [' ', #9]);
                ArrestStringEx(s20, '[', ']', s20);
                New(QDDinfo);
                QDDinfo.n00 := Str_ToInt(s20, 0);
                QDDinfo.s04 := s1C;
                QDDinfo.sList := TStringList.Create;
                QDDinfoList.Add(QDDinfo);
                bo2D := True;
              end
              else
                bo2D := False;
            end;
          end
          else if bo2D then
            QDDinfo.sList.Add(s1C);
        end;
      end;
      LoadList.Free;
    end;
    if QDDinfoList <> nil then
      QuestDiaryList.Add(QDDinfoList)
    else
      QuestDiaryList.Add(nil);
    Inc(nC);
    if nC >= 105 then
      Break;
  end;
end;
{
function TFrmDB.LoadStartPoint(): Integer;
var
  sFileName, tStr, s18, s1C, s20: string;
  LoadList                  : TStringList;
  i                         : Integer;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'StartPoint.txt';
  if FileExists(sFileName) then begin
    try
      g_StartPointList.Lock;
      g_StartPointList.Clear;
      LoadList := TStringList.Create;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do begin
        tStr := Trim(LoadList.Strings[i]);
        if (tStr <> '') and (tStr[1] <> ';') then begin
          tStr := GetValidStr3(tStr, s18, [' ', #9]);
          tStr := GetValidStr3(tStr, s1C, [' ', #9]);
          tStr := GetValidStr3(tStr, s20, [' ', #9]);
          if (s18 <> '') and (s1C <> '') and (s20 <> '') then begin
            g_StartPointList.AddObject(s18, TObject(MakeLong(Str_ToInt(s1C, 0),
              Str_ToInt(s20, 0))));
            Result := 1;
          end;
        end;
      end;
      LoadList.Free;
    finally
      g_StartPointList.UnLock;
    end;
  end;
end;
}

function TFrmDB.LoadUnbindList(): Integer;
var
  sFileName, tStr, sData, s20: string;
  LoadList: TStringList;
  i: Integer;
  n10: Integer;
begin
  Result := 0;
  sFileName := g_Config.sEnvirDir + 'UnbindList.txt';
  if FileExists(sFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      tStr := LoadList.Strings[i];
      if (tStr <> '') and (tStr[1] <> ';') then
      begin
        tStr := GetValidStr3(tStr, sData, [' ', #9]);
        tStr := GetValidStrCap(tStr, s20, [' ', #9]);
        if (s20 <> '') and (s20[1] = '"') then
          ArrestStringEx(s20, '"', '"', s20);
        n10 := Str_ToInt(sData, 0);
        if n10 > 0 then
          g_UnbindList.AddObject(s20, TObject(n10))
        else
        begin
          Result := -i; //需要取负数
          Break;
        end;
      end;
    end;
    LoadList.Free;
  end;
end;

function TFrmDB.LoadNpcScript(NPC: TNormNpc; sPatch, sScritpName: string): Integer; //0048C4D8
begin
  if sPatch = '' then
    sPatch := sNpc_def;
  Result := LoadScriptFile(NPC, sPatch, sScritpName, False);
end;

function TFrmDB.LoadScriptFile(NPC: TNormNpc; sPatch, sScritpName: string; boFlag: Boolean): Integer; //0048B684
var
  nQuestIdx, i, n1C, n20, n24, nItemType, nPriceRate, n6C, n70: Integer;
  sScritpFileName, s30, s34, s38, s3C, s40, s44, s48, s4C, s50: string;
  LoadList: TStringList;
  DefineList: TList;
  s54, s58, s5C, s74: string;
  DefineInfo: pTDefineInfo;
  bo8D: Boolean;
  Script: pTScript;
  SayingRecord: pTSayingRecord;
  SayingProcedure: pTSayingProcedure;
  QuestConditionInfo: pTQuestConditionInfo;
  QuestActionInfo: pTQuestActionInfo;
  Goods: pTGoods;

  nDest: Integer;
  sLine: string;
  Dest: array[0..1024] of Char;

  function LoadCallScript(sFileName, sLabel: string; List: TStringList): Boolean;
  var
    i, nDest: Integer;
    LoadStrList: TStringList;
    bo1D: Boolean;
    s18: string;
    sLine: string;
    Dest: array[0..1024] of Char;
  begin
    Result := False;
    if FileExists(sFileName) then
    begin
      LoadStrList := TStringList.Create;
      LoadStrList.LoadFromFile(sFileName);
      {.$I '..\Common\Macros\VMPBM.inc'}
      if LoadStrList.Count > 0 then
      begin
        sLine := LoadStrList.Strings[0];
        if CompareLStr(sLine, sENCYPTSCRIPTFLAG, Length(sENCYPTSCRIPTFLAG)) then
        begin
          for i := 0 to LoadStrList.Count - 1 do
          begin
            sLine := LoadStrList.Strings[i];
            if sLine = '' then
              Continue;
            if (nDeCryptString >= 0) and Assigned(PlugProcArray[nDeCryptString].nProcAddr) then
            begin
              FillChar(Dest, SizeOf(Dest), #0);
              TDeCryptString(PlugProcArray[nDeCryptString].nProcAddr)(@sLine[1], @Dest, Length(sLine), nDest);
              LoadStrList.Strings[i] := StrPas(PChar(@Dest));
            end;
          end;
        end;
      end;
      {.$I '..\Common\Macros\VMPE.inc'}

            //DeCodeStringList(LoadStrList);
      sLabel := '[' + sLabel + ']';
      bo1D := False;
      for i := 0 to LoadStrList.Count - 1 do
      begin
        s18 := Trim(LoadStrList.Strings[i]);
        if s18 <> '' then
        begin
          if not bo1D then
          begin
            if (s18[1] = '[') and (CompareText(s18, sLabel) = 0) then
            begin
              bo1D := True;
              List.Add(s18);
            end;
          end
          else
          begin
            if s18[1] <> '{' then
            begin
              if s18[1] = '}' then
              begin
                Result := True;
                Break;
              end
              else
                List.Add(s18);
            end;
          end;
        end;
      end;
      LoadStrList.Free;
      if not bo1D then
        MainOutMessageAPI('#CALL 脚本错误，找不到: ' + sLabel + '，文件名: ' + sFileName)
      else if not Result then
        MainOutMessageAPI('#CALL 脚本错误，没有}号，文件名: ' + sFileName);
    end
    else
      MainOutMessageAPI('#CALL 文件不存在: ' + sFileName);
  end;

  function LoadScriptCall(LoadList: TStringList): Boolean;
  var
    i: Integer;
    s14, s18, s1C, s20, s34: string;
  begin
    Result := False;
    for i := 0 to LoadList.Count - 1 do
    begin
      s14 := Trim(LoadList.Strings[i]);
      if (s14 <> '') and (s14[1] = '#') and (CompareLStr(s14, '#CALL', Length('#CALL'))) then
      begin
        s14 := ArrestStringEx(s14, '[', ']', s1C);
        s20 := Trim(s1C); // File
        s18 := Trim(s14); // Label
        s34 := g_Config.sEnvirDir + 'QuestDiary\' + s20;
        if LoadCallScript(s34, s18, LoadList) then
        begin
          LoadList.Strings[i] := '#ACT';
          LoadList.Insert(i + 1, 'GOTO ' + s18);
        end
        else
        begin
          Result := False;
          Exit;
        end;
      end
      else
        Continue;
      Result := True;
    end;
  end;

  function LoadDefineInfo(LoadList: TStringList; List: TList): string; //0048B35C
  var
    i: Integer;
    s14, s28, s1C, s20, s24: string;
    DefineInfo: pTDefineInfo;
    LoadStrList: TStringList;
  begin
    for i := 0 to LoadList.Count - 1 do
    begin
      s14 := Trim(LoadList.Strings[i]);
      if (s14 <> '') and (s14[1] = '#') then
      begin
        if CompareLStr(s14, '#SETHOME', Length('#SETHOME')) then
        begin
          Result := Trim(GetValidStr3(s14, s1C, [' ', #9]));
          LoadList.Strings[i] := '';
        end;
        if CompareLStr(s14, '#DEFINE', Length('#DEFINE')) then
        begin
          s14 := (GetValidStr3(s14, s1C, [' ', #9]));
          s14 := (GetValidStr3(s14, s20, [' ', #9]));
          s14 := (GetValidStr3(s14, s24, [' ', #9]));
          New(DefineInfo);
          DefineInfo.sName := UpperCase(s20);
          DefineInfo.sText := s24;
          List.Add(DefineInfo);
          LoadList.Strings[i] := '';
        end;
        if CompareLStr(s14, '#INCLUDE', Length('#INCLUDE')) then
        begin
          s28 := Trim(GetValidStr3(s14, s1C, [' ', #9]));
          s28 := g_Config.sEnvirDir + 'Defines\' + s28;
          if FileExists(s28) then
          begin
            LoadStrList := TStringList.Create;
            LoadStrList.LoadFromFile(s28);
            Result := LoadDefineInfo(LoadStrList, List);
            LoadStrList.Free;
          end
          else
            MainOutMessageAPI('script error, load fail: ' + s28);
          LoadList.Strings[i] := '';
        end;
      end;
    end;
  end;

  function MakeNewScript(): pTScript;
  var
    ScriptInfo: pTScript;
  begin
    New(ScriptInfo);
    ScriptInfo.boQuest := False;
    FillChar(ScriptInfo.QuestInfo, SizeOf(TQuestInfo) * 10, #0);
    nQuestIdx := 0;
    ScriptInfo.RecordList := TList.Create;
    NPC.m_ScriptList.Add(ScriptInfo);
    Result := ScriptInfo;
  end;

  function QuestCondition(sText: string; QuestConditionInfo: pTQuestConditionInfo): Boolean;
  var
    sActName, sCmd, sParam1, sParam2, sParam3, sParam4, sParam5, sParam6: string;
    nCMDCode: Integer;
  label
    L001;
  begin
    Result := False;
    sText := GetValidStrCap(sText, sCmd, [' ', #9]);
    sText := GetValidStrCap(sText, sParam1, [' ', #9]);
    sText := GetValidStrCap(sText, sParam2, [' ', #9]);
    sText := GetValidStrCap(sText, sParam3, [' ', #9]);
    sText := GetValidStrCap(sText, sParam4, [' ', #9]);
    sText := GetValidStrCap(sText, sParam5, [' ', #9]);
    sText := GetValidStrCap(sText, sParam6, [' ', #9]);
    sCmd := UpperCase(sCmd);
    if Pos('.', sCmd) > 0 then
    begin
      sCmd := GetValidStrCap(sCmd, sActName, ['.']);
      if sActName <> '' then
      begin
        QuestConditionInfo.sOpName := sActName;
        if Pos('.', sCmd) > 0 then
        begin
          sCmd := GetValidStrCap(sCmd, sActName, ['.']);
          if sActName = 'H' then
            QuestConditionInfo.sOpHName := 'H';
        end;
      end;
    end;
    nCMDCode := 0;
    if sCmd = sCHECK then
    begin
      nCMDCode := nCHECK;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then
        nCMDCode := 0;
      if not IsStringNumber(sParam2) then
        nCMDCode := 0;
      goto L001;
    end;
    if sCmd = sCHECKOPEN then
    begin
      nCMDCode := nCHECKOPEN;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then
        nCMDCode := 0;
      if not IsStringNumber(sParam2) then
        nCMDCode := 0;
      goto L001;
    end;
    if sCmd = sCHECKUNIT then
    begin
      nCMDCode := nCHECKUNIT;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then
        nCMDCode := 0;
      if not IsStringNumber(sParam2) then
        nCMDCode := 0;
      goto L001;
    end;
    if sCmd = sCHECKPKPOINT then
    begin
      nCMDCode := nCHECKPKPOINT;
      goto L001;
    end;
    if sCmd = sCHECKGOLD then
    begin
      nCMDCode := nCHECKGOLD;
      goto L001;
    end;
    if sCmd = sCHECKLEVEL then
    begin
      nCMDCode := nCHECKLEVEL;
      goto L001;
    end;
    if sCmd = sCHECKJOB then
    begin
      nCMDCode := nCHECKJOB;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROJOB then
    begin
      nCMDCode := nSC_CHECKHEROJOB;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROPKPOINT then
    begin
      nCMDCode := nSC_CHECKHEROPKPOINT;
      goto L001;
    end;
    if sCmd = sRANDOM then
    begin //00489FB2
      nCMDCode := nRANDOM;
      goto L001;
    end;
    if sCmd = sCHECKITEM then
    begin
      nCMDCode := nCHECKITEM;
      goto L001;
    end;
    if sCmd = sGENDER then
    begin
      nCMDCode := nGENDER;
      goto L001;
    end;
    if sCmd = sCHECKBAGGAGE then
    begin
      nCMDCode := nCHECKBAGGAGE;
      goto L001;
    end;
    if sCmd = sCHECKNAMELIST then
    begin
      nCMDCode := nCHECKNAMELIST;
      goto L001;
    end;
    if sCmd = sSC_HASGUILD then
    begin
      nCMDCode := nSC_HASGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISONCASTLEWAR then
    begin
      nCMDCode := nSC_ISONCASTLEWAR;
      goto L001;
    end;
    if sCmd = sSC_ISGUILDMASTER then
    begin
      nCMDCode := nSC_ISGUILDMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKCASTLEMASTER then
    begin
      nCMDCode := nSC_CHECKCASTLEMASTER;
      goto L001;
    end;
    if sCmd = sSC_ISNEWHUMAN then
    begin
      nCMDCode := nSC_ISNEWHUMAN;
      goto L001;
    end;
    if sCmd = sSC_CHECKMEMBERTYPE then
    begin
      nCMDCode := nSC_CHECKMEMBERTYPE;
      goto L001;
    end;
    if sCmd = sSC_CHECKMEMBERLEVEL then
    begin
      nCMDCode := nSC_CHECKMEMBERLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKGAMEGOLD then
    begin
      nCMDCode := nSC_CHECKGAMEGOLD;
      goto L001;
    end;
    if sCmd = sSC_CHECKNIMBUS then
    begin
      nCMDCode := nSC_CHECKNIMBUS;
      goto L001;
    end;
    if sCmd = sSC_CHECKATTACKMODE then
    begin
      nCMDCode := nSC_CHECKATTACKMODE;
      goto L001;
    end;
    if sCmd = sSC_CHECKESCORTINNEAR then
    begin
      nCMDCode := nSC_CHECKESCORTINNEAR;
      goto L001;
    end;
    if sCmd = sSC_IsEscortIng then
    begin
      nCMDCode := nSC_IsEscortIng;
      goto L001;
    end;

    if sCmd = sSC_CHECKGAMEPOINT then
    begin
      nCMDCode := nSC_CHECKGAMEPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKNAMELISTPOSITION then
    begin
      nCMDCode := nSC_CHECKNAMELISTPOSITION;
      goto L001;
    end;
    if sCmd = sSC_CHECKGUILDLIST then
    begin
      nCMDCode := nSC_CHECKGUILDLIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKRENEWLEVEL then
    begin
      nCMDCode := nSC_CHECKRENEWLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKSLAVELEVEL then
    begin
      nCMDCode := nSC_CHECKSLAVELEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKSLAVENAME then
    begin
      nCMDCode := nSC_CHECKSLAVENAME;
      goto L001;
    end;
    if sCmd = sSC_CHECKCREDITPOINT then
    begin
      nCMDCode := nSC_CHECKCREDITPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKOFGUILD then
    begin
      nCMDCode := nSC_CHECKOFGUILD;
      goto L001;
    end;
    if sCmd = sSC_CHECKPAYMENT then
    begin
      nCMDCode := nSC_CHECKPAYMENT;
      goto L001;
    end;

    if sCmd = sSC_CHECKUSEITEM then
    begin
      nCMDCode := nSC_CHECKUSEITEM;
      goto L001;
    end;
    if sCmd = sSC_CHECKBAGSIZE then
    begin
      nCMDCode := nSC_CHECKBAGSIZE;
      goto L001;
    end;
    if sCmd = sSC_CHECKLISTCOUNT then
    begin
      nCMDCode := nSC_CHECKLISTCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKDC then
    begin
      nCMDCode := nSC_CHECKDC;
      goto L001;
    end;
    if sCmd = sSC_CHECKMC then
    begin
      nCMDCode := nSC_CHECKMC;
      goto L001;
    end;
    if sCmd = sSC_CHECKSC then
    begin
      nCMDCode := nSC_CHECKSC;
      goto L001;
    end;
    if sCmd = sSC_CHECKHP then
    begin
      nCMDCode := nSC_CHECKHP;
      goto L001;
    end;
    if sCmd = sSC_CHECKMP then
    begin
      nCMDCode := nSC_CHECKMP;
      goto L001;
    end;
    if sCmd = sSC_CHECKITEMTYPE then
    begin
      nCMDCode := nSC_CHECKITEMTYPE;
      goto L001;
    end;
    if sCmd = sSC_CHECKITEMLUCK then
    begin
      nCMDCode := nSC_CHECKITEMLUCK;
      goto L001;
    end;
    if sCmd = sSC_CHECKEXP then
    begin
      nCMDCode := nSC_CHECKEXP;
      goto L001;
    end;
    if sCmd = sSC_CHECKCASTLEGOLD then
    begin
      nCMDCode := nSC_CHECKCASTLEGOLD;
      goto L001;
    end;
    if sCmd = sSC_PASSWORDERRORCOUNT then
    begin
      nCMDCode := nSC_PASSWORDERRORCOUNT;
      goto L001;
    end;
    if sCmd = sSC_ISLOCKPASSWORD then
    begin
      nCMDCode := nSC_ISLOCKPASSWORD;
      goto L001;
    end;
    if sCmd = sSC_ISLOCKSTORAGE then
    begin
      nCMDCode := nSC_ISLOCKSTORAGE;
      goto L001;
    end;
    if sCmd = sSC_CHECKBUILDPOINT then
    begin
      nCMDCode := nSC_CHECKBUILDPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKAURAEPOINT then
    begin
      nCMDCode := nSC_CHECKAURAEPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKSTABILITYPOINT then
    begin
      nCMDCode := nSC_CHECKSTABILITYPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKFLOURISHPOINT then
    begin
      nCMDCode := nSC_CHECKFLOURISHPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKCONTRIBUTION then
    begin
      nCMDCode := nSC_CHECKCONTRIBUTION;
      goto L001;
    end;
    if sCmd = sSC_CHECKRANGEMONCOUNT then
    begin
      nCMDCode := nSC_CHECKRANGEMONCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKRANGEMONCOUNTEX then
    begin
      nCMDCode := nSC_CHECKRANGEMONCOUNTEX;
      goto L001;
    end;
    if sCmd = sSC_CHECKSTRINGLIST then
    begin
      nCMDCode := nSC_CHECKSTRINGLIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKMISSION then
    begin
      nCMDCode := nSC_CHECKMISSION;
      goto L001;
    end;
    if sCmd = sSC_CHECKTITLE then
    begin
      nCMDCode := nSC_CHECKTITLE;
      goto L001;
    end;

    if sCmd = sSC_CHECKITEMADDVALUE then
    begin
      nCMDCode := nSC_CHECKITEMADDVALUE;
      goto L001;
    end;
    if sCmd = sSC_CHECKINMAPRANGE then
    begin
      nCMDCode := nSC_CHECKINMAPRANGE;
      goto L001;
    end;
    if sCmd = sSC_CASTLECHANGEDAY then
    begin
      nCMDCode := nSC_CASTLECHANGEDAY;
      goto L001;
    end;
    if sCmd = sSC_CASTLEWARDAY then
    begin
      nCMDCode := nSC_CASTLEWARDAY;
      goto L001;
    end;
    if sCmd = sSC_ONLINELONGMIN then
    begin
      nCMDCode := nSC_ONLINELONGMIN;
      goto L001;
    end;
    if sCmd = sSC_CHECKGUILDCHIEFITEMCOUNT then
    begin
      nCMDCode := nSC_CHECKGUILDCHIEFITEMCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKNAMEDATELIST then
    begin
      nCMDCode := nSC_CHECKNAMEDATELIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKMAPHUMANCOUNT then
    begin
      nCMDCode := nSC_CHECKMAPHUMANCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKMAPMONCOUNT then
    begin
      nCMDCode := nSC_CHECKMAPMONCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKVAR then
    begin
      nCMDCode := nSC_CHECKVAR;
      goto L001;
    end;
    if sCmd = sSC_CHECKSERVERNAME then
    begin
      nCMDCode := nSC_CHECKSERVERNAME;
      goto L001;
    end;
    if sCmd = sSC_ISATTACKGUILD then
    begin
      nCMDCode := nSC_ISATTACKGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISDEFENSEGUILD then
    begin
      nCMDCode := nSC_ISDEFENSEGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISATTACKALLYGUILD then
    begin
      nCMDCode := nSC_ISATTACKALLYGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISDEFENSEALLYGUILD then
    begin
      nCMDCode := nSC_ISDEFENSEALLYGUILD;
      goto L001;
    end;
    if sCmd = sSC_ISCASTLEGUILD then
    begin
      nCMDCode := nSC_ISCASTLEGUILD;
      goto L001;
    end;
    if sCmd = sSC_CHECKCASTLEDOOR then
    begin
      nCMDCode := nSC_CHECKCASTLEDOOR;
      goto L001;
    end;
    if sCmd = sSC_ISSYSOP then
    begin
      nCMDCode := nSC_ISSYSOP;
      goto L001;
    end;
    if sCmd = sSC_ISADMIN then
    begin
      nCMDCode := nSC_ISADMIN;
      goto L001;
    end;
    if sCmd = sSC_CHECKGROUPCOUNT then
    begin
      nCMDCode := nSC_CHECKGROUPCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKGAMEGOLDDEAL then
    begin
      nCMDCode := nSC_CHECKGAMEGOLDDEAL;
      goto L001;
    end;
    if sCmd = sSC_CHECKGAMEDIAMOND then
    begin
      nCMDCode := nSC_CHECKGAMEDIAMOND;
      goto L001;
    end;
    if sCmd = sSC_CHECKGAMEGIRD then
    begin
      nCMDCode := nSC_CHECKGAMEGIRD;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROCREDITPOINT then
    begin
      nCMDCode := nSC_CHECKHEROCREDITPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKDLGITEMTYPE then
    begin
      nCMDCode := nSC_CHECKDLGITEMTYPE;
      goto L001;
    end;
    if sCmd = sSC_CHECKDLGITEMNAME then
    begin
      nCMDCode := nSC_CHECKDLGITEMNAME;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSDLGITEMNAME then
    begin
      nCMDCode := nSC_CHECKPOSDLGITEMNAME;
      goto L001;
    end;
    if sCmd = sSC_GIVEOK then
    begin
      nCMDCode := nSC_GIVEOK;
      goto L001;
    end;
    if sCmd = SSC_UNWRAPNIMBUSITEM then
    begin
      nCMDCode := nSC_UNWRAPNIMBUSITEM;
      goto L001;
    end;
    if sCmd = SSC_CHECKNIMBUSITEMCOUNT then
    begin
      nCMDCode := nSC_CHECKNIMBUSITEMCOUNT;
      goto L001;
    end;

    if sCmd = SSC_CHECKMAPNIMBUSCOUNT then
    begin
      nCMDCode := nSC_CHECKMAPNIMBUSCOUNT;
      goto L001;
    end;
    if sCmd = SSC_CHECKVENATIONLEVEL then
    begin
      nCMDCode := nSC_CHECKVENATIONLEVEL;
      goto L001;
    end;

    if sCmd = sSC_CHECKMAPRANGEHUMANCOUNT then
    begin
      nCMDCode := nSC_CHECKMAPRANGEHUMANCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKDLGITEMADDVALUE then
    begin
      nCMDCode := nSC_CHECKDLGITEMADDVALUE;
      goto L001;
    end;

    if sCmd = sSC_CHECKMASTERONLINE then
    begin
      nCMDCode := nSC_CHECKMASTERONLINE;
      goto L001;
    end;
    if sCmd = sSC_CHECKDEARONLINE then
    begin
      nCMDCode := nSC_CHECKDEARONLINE;
      goto L001;
    end;
    if sCmd = sSC_CHECKMASTERONMAP then
    begin
      nCMDCode := nSC_CHECKMASTERONMAP;
      goto L001;
    end;
    if sCmd = sSC_CHECKDEARONMAP then
    begin
      nCMDCode := nSC_CHECKDEARONMAP;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEISPRENTICE then
    begin
      nCMDCode := nSC_CHECKPOSEISPRENTICE;
      goto L001;
    end;

    if sCmd = sCHECKACCOUNTLIST then
    begin
      nCMDCode := nCHECKACCOUNTLIST;
      goto L001;
    end;
    if sCmd = sCHECKIPLIST then
    begin
      nCMDCode := nCHECKIPLIST;
      goto L001;
    end;
    if sCmd = sCHECKBBCOUNT then
    begin
      nCMDCode := nCHECKBBCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKCURRENTDATE then
    begin
      nCMDCode := nSC_CHECKCURRENTDATE;
      goto L001;
    end;

    {if sCmd = sCHECKCREDITPOINT then
     begin
       nCMDCode := nCHECKCREDITPOINT;
       goto L001;
     end;}
    if sCmd = sDAYTIME then
    begin
      nCMDCode := nDAYTIME;
      goto L001;
    end;
    if sCmd = sCHECKITEMW then
    begin
      nCMDCode := nCHECKITEMW;
      goto L001;
    end;
    if sCmd = sISTAKEITEM then
    begin
      nCMDCode := nISTAKEITEM;
      goto L001;
    end;
    if sCmd = sCHECKDURA then
    begin
      nCMDCode := nCHECKDURA;
      goto L001;
    end;
    if sCmd = sCHECKDURAEVA then
    begin
      nCMDCode := nCHECKDURAEVA;
      goto L001;
    end;
    if sCmd = sDAYOFWEEK then
    begin
      nCMDCode := nDAYOFWEEK;
      goto L001;
    end;
    if sCmd = sHOUR then
    begin
      nCMDCode := nHOUR;
      goto L001;
    end;
    if sCmd = sMIN then
    begin
      nCMDCode := nMIN;
      goto L001;
    end;
    if sCmd = sCHECKLUCKYPOINT then
    begin
      nCMDCode := nCHECKLUCKYPOINT;
      goto L001;
    end;
    if sCmd = sCHECKMONMAP then
    begin
      nCMDCode := nCHECKMONMAP;
      goto L001;
    end;
    if sCmd = sCHECKMONAREA then
    begin
      nCMDCode := nCHECKMONAREA;
      goto L001;
    end;
    if sCmd = sCHECKHUM then
    begin
      nCMDCode := nCHECKHUM;
      goto L001;
    end;
    if sCmd = sEQUAL then
    begin
      nCMDCode := nEQUAL;
      goto L001;
    end;
    if sCmd = sLARGE then
    begin
      nCMDCode := nLARGE;
      goto L001;
    end;
    if sCmd = sSMALL then
    begin
      nCMDCode := nSMALL;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEDIR then
    begin
      nCMDCode := nSC_CHECKPOSEDIR;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSELEVEL then
    begin
      nCMDCode := nSC_CHECKPOSELEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEGENDER then
    begin
      nCMDCode := nSC_CHECKPOSEGENDER;
      goto L001;
    end;
    if sCmd = sSC_CHECKLEVELEX then
    begin
      nCMDCode := nSC_CHECKLEVELEX;
      goto L001;
    end;
    if sCmd = sSC_CHECKIPLEVEL then
    begin
      nCMDCode := nSC_CHECKIPLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROLEVEL then
    begin
      nCMDCode := nSC_CHECKHEROLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHECKBONUSPOINT then
    begin
      nCMDCode := nSC_CHECKBONUSPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHECKMARRY then
    begin
      nCMDCode := nSC_CHECKMARRY;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEMARRY then
    begin
      nCMDCode := nSC_CHECKPOSEMARRY;
      goto L001;
    end;
    if sCmd = sSC_CHECKMARRYCOUNT then
    begin
      nCMDCode := nSC_CHECKMARRYCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKMASTER then
    begin
      nCMDCode := nSC_CHECKMASTER;
      goto L001;
    end;
    if sCmd = sSC_HAVEMASTER then
    begin
      nCMDCode := nSC_HAVEMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEMASTER then
    begin
      nCMDCode := nSC_CHECKPOSEMASTER;
      goto L001;
    end;
    if sCmd = sSC_POSEHAVEMASTER then
    begin
      nCMDCode := nSC_POSEHAVEMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKISMASTER then
    begin
      nCMDCode := nSC_CHECKISMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKPOSEISMASTER then
    begin
      nCMDCode := nSC_CHECKPOSEISMASTER;
      goto L001;
    end;
    if sCmd = sSC_CHECKNAMEIPLIST then
    begin
      nCMDCode := nSC_CHECKNAMEIPLIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKACCOUNTIPLIST then
    begin
      nCMDCode := nSC_CHECKACCOUNTIPLIST;
      goto L001;
    end;
    if sCmd = sSC_CHECKSLAVECOUNT then
    begin
      nCMDCode := nSC_CHECKSLAVECOUNT;
      goto L001;
    end;
    if (sCmd = sSC_CHECKMAGICNAME) or (sCmd = 'CheckSkill') then
    begin
      nCMDCode := nSC_CHECKMAGICNAME;
      goto L001;
    end;
    if sCmd = sSC_CHECKMAGICLEVEL then
    begin
      nCMDCode := nSC_CHECKMAGICLEVEL;
      goto L001;
    end;
    if sCmd = sCHECKUSERDATE then
    begin
      nCMDCode := nCHECKUSERDATE;
      goto L001;
    end;
    if sCmd = sCheckCodeList then
    begin
      nCMDCode := nCheckCodeList;
      goto L001;
    end;
    if sCmd = sSC_CHECKRANDOMNO then
    begin
      nCMDCode := nSC_CHECKRANDOMNO;
      goto L001;
    end;
    if sCmd = sADDUSERDATE then
    begin
      nCMDCode := nADDUSERDATE;
      goto L001;
    end;
    if sCmd = sSc_checkcastlewar then
    begin
      nCMDCode := nSc_checkcastlewar;
      goto L001;
    end;
    if sCmd = sYCCALLMOB then
    begin
      nCMDCode := nYCCALLMOB;
      goto L001;
    end;
    if sCmd = sCheckDiemon then
    begin
      nCMDCode := nCheckDiemon;
      goto L001;
    end;
    if sCmd = scheckkillplaymon then
    begin
      nCMDCode := ncheckkillplaymon;
      goto L001;
    end;
    if sCmd = sSC_CHEckISGROUPMASTER then
    begin
      nCMDCode := nSC_CHEckISGROUPMASTER;
      goto L001;
    end;
    if (sCmd = sSC_CHECKISONMAP) or (sCmd = sSC_CHECKMAPNAME) then
    begin
      nCMDCode := nSC_CHECKISONMAP;
      goto L001;
    end;
    if sCmd = sSC_IsSameGuildOnMap then
    begin
      nCMDCode := nSC_IsSameGuildOnMap;
      goto L001;
    end;
    if sCmd = sSC_ISHIGH then
    begin
      nCMDCode := nSC_ISHIGH;
      goto L001;
    end;
    if sCmd = sSC_ISDUPMODE then
    begin
      nCMDCode := nSC_ISDUPMODE;
      goto L001;
    end;
    if sCmd = sSC_INSAFEZONE then
    begin
      nCMDCode := nSC_INSAFEZONE;
      goto L001;
    end;
    if sCmd = sSC_KILLBYHUM then
    begin
      nCMDCode := nSC_KILLBYHUM;
      goto L001;
    end;
    if sCmd = sSC_KILLBYMON then
    begin
      nCMDCode := nSC_KILLBYMON;
      goto L001;
    end;
    if sCmd = sSC_CHECKSIGNMAP then
    begin
      nCMDCode := nSC_CHECKSIGNMAP;
      goto L001;
    end;
    if sCmd = sSC_CHECKONLINE then
    begin
      nCMDCode := nSC_CHECKONLINE;
      goto L001;
    end;
    if sCmd = sSC_OFFLINEPLAYERCOUNT then
    begin
      nCMDCode := nSC_OFFLINEPLAYERCOUNT;
      goto L001;
    end;
    if sCmd = sSC_CHECKHEROONLINE then
    begin
      nCMDCode := nSC_CHECKHEROONLINE;
      goto L001;
    end;
    if sCmd = sSC_HAVEHERO then
    begin
      nCMDCode := nSC_HAVEHERO;
      goto L001;
    end;
    if sCmd = sSC_CHECKINISECTIONEXISTS then
    begin
      nCMDCode := nSC_CHECKINISECTIONEXISTS;
      goto L001;
    end;
    if sCmd =  sSC_CHECKACTIVETITLE then
    begin
      nCMDCode := nSC_CHECKACTIVETITLE;
      goto L001;
    end;
    {
    if @Engine_SetScriptConditionCmd <> nil then begin
      nCMDCode := Engine_SetScriptConditionCmd(PChar(sCmd));
      goto L001;
    end;
    }

    L001:
    if nCMDCode > 0 then
    begin
      QuestConditionInfo.nCMDCode := nCMDCode;
      //if sActName <> '' then QuestConditionInfo.sActChr := sActName;
      if (sParam1 <> '') and (sParam1[1] = '"') then
        ArrestStringEx(sParam1, '"', '"', sParam1);
      if (sParam2 <> '') and (sParam2[1] = '"') then
        ArrestStringEx(sParam2, '"', '"', sParam2);
      if (sParam3 <> '') and (sParam3[1] = '"') then
        ArrestStringEx(sParam3, '"', '"', sParam3);
      if (sParam4 <> '') and (sParam4[1] = '"') then
        ArrestStringEx(sParam4, '"', '"', sParam4);
      if (sParam5 <> '') and (sParam5[1] = '"') then
        ArrestStringEx(sParam5, '"', '"', sParam5);
      if (sParam6 <> '') and (sParam6[1] = '"') then
        ArrestStringEx(sParam6, '"', '"', sParam6);
      QuestConditionInfo.sParam1 := sParam1;
      QuestConditionInfo.sParam2 := sParam2;
      QuestConditionInfo.sParam3 := sParam3;
      QuestConditionInfo.sParam4 := sParam4;
      QuestConditionInfo.sParam5 := sParam5;
      QuestConditionInfo.sParam6 := sParam6;
      if IsStringNumber(sParam1) then
        QuestConditionInfo.nParam1 := Str_ToInt(sParam1, 0);
      if IsStringNumber(sParam2) then
        QuestConditionInfo.nParam2 := Str_ToInt(sParam2, 0);
      if IsStringNumber(sParam3) then
        QuestConditionInfo.nParam3 := Str_ToInt(sParam3, 0);
      if IsStringNumber(sParam4) then
        QuestConditionInfo.nParam4 := Str_ToInt(sParam4, 0);
      if IsStringNumber(sParam5) then
        QuestConditionInfo.nParam5 := Str_ToInt(sParam5, 0);
      if IsStringNumber(sParam6) then
        QuestConditionInfo.nParam6 := Str_ToInt(sParam6, 0);
      Result := True;
    end;

  end;

  function QuestAction(sText: string; QuestActionInfo: pTQuestActionInfo): Boolean;
  var
    sActName, sCmd, sParam1, sParam2, sParam3, sParam4, sParam5, sParam6, sParam7, sParam8, sParam9, sParam10: string;
    nCMDCode: Integer;
  label
    L001;
  begin
    Result := False;
    sText := GetValidStrCap(sText, sCmd, [' ', #9]);
    sText := GetValidStrCap(sText, sParam1, [' ', #9]);
    sText := GetValidStrCap(sText, sParam2, [' ', #9]);
    sText := GetValidStrCap(sText, sParam3, [' ', #9]);
    sText := GetValidStrCap(sText, sParam4, [' ', #9]);
    sText := GetValidStrCap(sText, sParam5, [' ', #9]);
    sText := GetValidStrCap(sText, sParam6, [' ', #9]);
    sText := GetValidStrCap(sText, sParam7, [' ', #9]);
    sText := GetValidStrCap(sText, sParam8, [' ', #9]);
    sText := GetValidStrCap(sText, sParam9, [' ', #9]);
    sText := GetValidStrCap(sText, sParam10, [' ', #9]);

    if Pos('.', sCmd) > 0 then
    begin
      sCmd := GetValidStrCap(sCmd, sActName, ['.']);
      if sActName <> '' then
      begin
        QuestActionInfo.sOpName := sActName;
        if Pos('.', sCmd) > 0 then
        begin
          sCmd := GetValidStrCap(sCmd, sActName, ['.']);
          if UpperCase(sActName) = 'H' then
            QuestActionInfo.sOpHName := 'H';
        end;
      end;
    end;

    sCmd := UpperCase(sCmd);
    nCMDCode := 0;
    if sCmd = sSET then
    begin
      nCMDCode := nSet;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then
        nCMDCode := 0;
      if not IsStringNumber(sParam2) then
        nCMDCode := 0;
      goto L001;
    end;
    if sCmd = sRESET then
    begin
      nCMDCode := nRESET;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then
        nCMDCode := 0;
      if not IsStringNumber(sParam2) then
        nCMDCode := 0;
      goto L001;
    end;
    if sCmd = sSETOPEN then
    begin
      nCMDCode := nSETOPEN;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then
        nCMDCode := 0;
      if not IsStringNumber(sParam2) then
        nCMDCode := 0;
      goto L001;
    end;
    if sCmd = sSETUNIT then
    begin
      nCMDCode := nSETUNIT;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then
        nCMDCode := 0;
      if not IsStringNumber(sParam2) then
        nCMDCode := 0;
      goto L001;
    end;
    if sCmd = sRESETUNIT then
    begin
      nCMDCode := nRESETUNIT;
      ArrestStringEx(sParam1, '[', ']', sParam1);
      if not IsStringNumber(sParam1) then
        nCMDCode := 0;
      if not IsStringNumber(sParam2) then
        nCMDCode := 0;
      goto L001;
    end;
    if sCmd = sTAKE then
    begin
      nCMDCode := nTAKE;
      goto L001;
    end;
    if sCmd = sSC_GIVE then
    begin
      nCMDCode := nSC_GIVE;
      goto L001;
    end;
    if sCmd = sSC_GIVEEX then
    begin
      nCMDCode := nSC_GIVEEX;
      goto L001;
    end;
    if sCmd = sSC_CONFERTITLE then
    begin
      nCMDCode := nSC_CONFERTITLE;
      goto L001;
    end;
    if sCmd = sSC_DEPRIVETITLE then
    begin
      nCMDCode := nSC_DEPRIVETITLE;
      goto L001;
    end;
    if sCmd = sSC_PLAYSOUND then
    begin
      nCMDCode := nSC_PLAYSOUND;
      goto L001;
    end;
    if sCmd = sCLOSE then
    begin
      nCMDCode := nCLOSE;
      goto L001;
    end;
    if sCmd = sBREAK then
    begin
      nCMDCode := nBREAK;
      goto L001;
    end;
    if sCmd = sGOTO then
    begin
      nCMDCode := nGOTO;
      goto L001;
    end;
    if sCmd = sADDNAMELIST then
    begin
      nCMDCode := nADDNAMELIST;
      goto L001;
    end;
    if sCmd = sDELNAMELIST then
    begin
      nCMDCode := nDELNAMELIST;
      goto L001;
    end;
    if sCmd = sADDGUILDLIST then
    begin
      nCMDCode := nADDGUILDLIST;
      goto L001;
    end;
    if sCmd = sDELGUILDLIST then
    begin
      nCMDCode := nDELGUILDLIST;
      goto L001;
    end;
    if sCmd = sSC_MAPTING then
    begin
      nCMDCode := nSC_MAPTING;
      goto L001;
    end;
    if sCmd = sSC_LINEMSG then
    begin
      nCMDCode := nSC_LINEMSG;
      goto L001;
    end;
    if sCmd = sADDACCOUNTLIST then
    begin
      nCMDCode := nADDACCOUNTLIST;
      goto L001;
    end;
    if sCmd = sDELACCOUNTLIST then
    begin
      nCMDCode := nDELACCOUNTLIST;
      goto L001;
    end;
    if sCmd = sADDIPLIST then
    begin
      nCMDCode := nADDIPLIST;
      goto L001;
    end;
    if sCmd = sDELIPLIST then
    begin
      nCMDCode := nDELIPLIST;
      goto L001;
    end;
    if sCmd = sSC_SENDMSG then
    begin
      nCMDCode := nSC_SENDMSG;
      goto L001;
    end;
    if sCmd = sCHANGEMODE then
    begin
      nCMDCode := nCHANGEMODE;
      goto L001;
    end;
    if sCmd = sPKPOINT then
    begin
      nCMDCode := nPKPOINT;
      goto L001;
    end;
    if sCmd = sCHANGEXP then
    begin
      nCMDCode := nCHANGEXP;
      goto L001;
    end;
    if sCmd = sSC_RECALLMOB then
    begin
      nCMDCode := nSC_RECALLMOB;
      goto L001;
    end;
    if sCmd = sSC_RECALLMOBEX then
    begin
      nCMDCode := nSC_RECALLMOBEX;
      goto L001;
    end;
    if sCmd = sSC_READRANDOMSTR then
    begin
      nCMDCode := nSC_READRANDOMSTR;
      goto L001;
    end;
    if sCmd = sSC_CHANGERANGEMONPOS then
    begin
      nCMDCode := nSC_CHANGERANGEMONPOS;
      goto L001;
    end;
    if sCmd = sSC_READRANDOMLINE then
    begin
      nCMDCode := nSC_READRANDOMLINE;
      goto L001;
    end;
    if sCmd = sSC_SENDSCROLLMSG then
    begin
      nCMDCode := nSC_SENDSCROLLMSG;
      goto L001;
    end;
    if sCmd = sSC_SETMERCHANTDLGIMGNAME then
    begin
      nCMDCode := nSC_SETMERCHANTDLGIMGNAME;
      goto L001;
    end;

    if sCmd = sKICK then
    begin
      nCMDCode := nKICK;
      goto L001;
    end;
    if sCmd = sTAKEW then
    begin
      nCMDCode := nTAKEW;
      goto L001;
    end;
    if sCmd = sTIMERECALL then
    begin
      nCMDCode := nTIMERECALL;
      goto L001;
    end;
    if sCmd = sSC_PARAM1 then
    begin
      nCMDCode := nSC_PARAM1;
      goto L001;
    end;
    if sCmd = sSC_PARAM2 then
    begin
      nCMDCode := nSC_PARAM2;
      goto L001;
    end;
    if sCmd = sSC_PARAM3 then
    begin
      nCMDCode := nSC_PARAM3;
      goto L001;
    end;
    if sCmd = sSC_PARAM4 then
    begin
      nCMDCode := nSC_PARAM4;
      goto L001;
    end;
    if sCmd = sSC_EXEACTION then
    begin
      nCMDCode := nSC_EXEACTION;
      goto L001;
    end;
    if sCmd = sSC_WEBBROWSER then
    begin
      nCMDCode := nSC_WEBBROWSER;
      goto L001;
    end;
    if sCmd = sSC_OPENSTORAGEVIEW then
    begin
      nCMDCode := nSC_OPENSTORAGEVIEW;
      goto L001;
    end;
    if sCmd = sSC_TAKEON then
    begin
      nCMDCode := nSC_TAKEON;
      goto L001;
    end;
    if sCmd = sMAPMOVE then
    begin
      nCMDCode := nMAPMOVE;
      goto L001;
    end;
    if sCmd = sMAP then
    begin
      nCMDCode := nMAP;
      goto L001;
    end;
    if sCmd = sTAKECHECKITEM then
    begin
      nCMDCode := nTAKECHECKITEM;
      goto L001;
    end;
    if sCmd = sMONGEN then
    begin
      nCMDCode := nMONGEN;
      goto L001;
    end;
    if sCmd = sMONCLEAR then
    begin
      nCMDCode := nMONCLEAR;
      goto L001;
    end;
    if sCmd = sMOV then
    begin
      nCMDCode := nMOV;
      goto L001;
    end;
    if sCmd = sINC then
    begin
      nCMDCode := nINC;
      goto L001;
    end;
    if sCmd = sDEC then
    begin
      nCMDCode := nDEC;
      goto L001;
    end;
    if sCmd = sSUM then
    begin
      nCMDCode := nSUM;
      goto L001;
    end;
    if sCmd = sBREAKTIMERECALL then
    begin
      nCMDCode := nBREAKTIMERECALL;
      goto L001;
    end;
    if sCmd = sSC_SETSCTIMER then
    begin
      nCMDCode := nSC_SETSCTIMER;
      goto L001;
    end;
    if sCmd = sSC_KILLSCTIMER then
    begin
      nCMDCode := nSC_KILLSCTIMER;
      goto L001;
    end;
    if sCmd = sSC_DIV then
    begin
      nCMDCode := nSC_DIV;
      goto L001;
    end;
    if sCmd = sSC_MUL then
    begin
      nCMDCode := nSC_MUL;
      goto L001;
    end;
    if sCmd = sSC_PERCENT then
    begin
      nCMDCode := nSC_PERCENT;
      goto L001;
    end;
    if sCmd = sMOVR then
    begin
      nCMDCode := nMOVR;
      goto L001;
    end;
    if sCmd = sMOVREX then
    begin
      nCMDCode := nMOVREX;
      goto L001;
    end;
    if sCmd = sSC_DROPITEMMAP then
    begin
      nCMDCode := nSC_DROPITEMMAP;
      goto L001;
    end;
    if sCmd = sEXCHANGEMAP then
    begin
      nCMDCode := nEXCHANGEMAP;
      goto L001;
    end;
    if sCmd = sRECALLMAP then
    begin
      nCMDCode := nRECALLMAP;
      goto L001;
    end;
    if sCmd = sADDBATCH then
    begin
      nCMDCode := nADDBATCH;
      goto L001;
    end;
    if sCmd = sBATCHDELAY then
    begin
      nCMDCode := nBATCHDELAY;
      goto L001;
    end;
    if sCmd = sBATCHMOVE then
    begin
      nCMDCode := nBATCHMOVE;
      goto L001;
    end;
    if sCmd = sPLAYDICE then
    begin
      nCMDCode := nPLAYDICE;
      goto L001;
    end;
    if sCmd = sGOQUEST then
    begin
      nCMDCode := nGOQUEST;
      goto L001;
    end;
    if sCmd = sENDQUEST then
    begin
      nCMDCode := nENDQUEST;
      goto L001;
    end;
    if sCmd = sSC_HAIRCOLOR then
    begin
      nCMDCode := nSC_HAIRCOLOR;
      goto L001;
    end;
    if sCmd = sSC_WEARCOLOR then
    begin
      nCMDCode := nSC_WEARCOLOR;
      goto L001;
    end;
    if sCmd = sSC_HAIRSTYLE then
    begin
      nCMDCode := nSC_HAIRSTYLE;
      goto L001;
    end;
    if sCmd = sSC_MONRECALL then
    begin
      nCMDCode := nSC_MONRECALL;
      goto L001;
    end;
    if sCmd = sSC_HORSECALL then
    begin
      nCMDCode := nSC_HORSECALL;
      goto L001;
    end;
    if sCmd = sSC_HAIRRNDCOL then
    begin
      nCMDCode := nSC_HAIRRNDCOL;
      goto L001;
    end;
    if sCmd = sSC_KILLHORSE then
    begin
      nCMDCode := nSC_KILLHORSE;
      goto L001;
    end;
    if sCmd = sSC_RANDSETDAILYQUEST then
    begin
      nCMDCode := nSC_RANDSETDAILYQUEST;
      goto L001;
    end;
    if sCmd = sSC_OPENGAMEGOLDDEAL then
    begin
      nCMDCode := nSC_OPENGAMEGOLDDEAL;
      goto L001;
    end;
    if sCmd = sSC_QUERYGAMEGOLDDEAL then
    begin
      nCMDCode := nSC_QUERYGAMEGOLDDEAL;
      goto L001;
    end;
    if sCmd = sSC_QUERYGAMEGOLDSELL then
    begin
      nCMDCode := nSC_QUERYGAMEGOLDSELL;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEROLEVEL then
    begin
      nCMDCode := nSC_CHANGEHEROLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHANGELEVEL then
    begin
      nCMDCode := nSC_CHANGELEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHANGEIPLEVEL then
    begin
      nCMDCode := nSC_CHANGEIPLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHANGETRANPOINT then
    begin
      nCMDCode := nSC_CHANGETRANPOINT;
      goto L001;
    end;
    if sCmd = sSC_TAKEDLGITEM then
    begin
      nCMDCode := nSC_TAKEDLGITEM;
      goto L001;
    end;
    if sCmd = sSC_ADDLINELIST then
    begin
      nCMDCode := nSC_ADDLINELIST;
      goto L001;
    end;
    if sCmd = sSC_DELLINELIST then
    begin
      nCMDCode := nSC_DELLINELIST;
      goto L001;
    end;
    if sCmd = SSC_CREATEMAPNIMBUS then
    begin
      nCMDCode := NSC_CREATEMAPNIMBUS;
      goto L001;
    end;
    if sCmd = sSC_KILLSLAVENAME then
    begin
      nCMDCode := nSC_KILLSLAVENAME;
      goto L001;
    end;

    if sCmd = sSC_CLEARMAPITEM then
    begin
      nCMDCode := NSC_CLEARMAPITEM;
      goto L001;
    end;
    if sCmd = sSC_ADDMAPROUTE then
    begin
      nCMDCode := nSC_ADDMAPROUTE;
      goto L001;
    end;
    if sCmd = sSC_DELMAPROUTE then
    begin
      nCMDCode := nSC_DELMAPROUTE;
      goto L001;
    end;

    if sCmd = sSC_MARRY then
    begin
      nCMDCode := nSC_MARRY;
      goto L001;
    end;
    if sCmd = sSC_UNMARRY then
    begin
      nCMDCode := nSC_UNMARRY;
      goto L001;
    end;
    if sCmd = sSC_GETMARRY then
    begin
      nCMDCode := nSC_GETMARRY;
      goto L001;
    end;
    if sCmd = sSC_GETMASTER then
    begin
      nCMDCode := nSC_GETMASTER;
      goto L001;
    end;
    if sCmd = sSC_CLEARSKILL then
    begin
      nCMDCode := nSC_CLEARSKILL;
      goto L001;
    end;
    if sCmd = sSC_DELNOJOBSKILL then
    begin
      nCMDCode := nSC_DELNOJOBSKILL;
      goto L001;
    end;
    if sCmd = sSC_DELSKILL then
    begin
      nCMDCode := nSC_DELSKILL;
      goto L001;
    end;
    if sCmd = sSC_ADDSKILL then
    begin
      nCMDCode := nSC_ADDSKILL;
      goto L001;
    end;
    if sCmd = sSC_SKILLLEVEL then
    begin
      nCMDCode := nSC_SKILLLEVEL;
      goto L001;
    end;
    if sCmd = sSC_HEROSKILLLEVEL then
    begin
      nCMDCode := nSC_HEROSKILLLEVEL;
      goto L001;
    end;

    if sCmd = sSC_CHANGEPKPOINT then
    begin
      nCMDCode := nSC_CHANGEPKPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEROPKPOINT then
    begin
      nCMDCode := nSC_CHANGEHEROPKPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEROEXP then
    begin
      nCMDCode := nSC_CHANGEHEROEXP;
      goto L001;
    end;
    if sCmd = sSC_CHANGEEXP then
    begin
      nCMDCode := nSC_CHANGEEXP;
      goto L001;
    end;
    if sCmd = sSC_CHANGEIPEXP then
    begin
      nCMDCode := nSC_CHANGEIPEXP;
      goto L001;
    end;

    if sCmd = sSC_CHANGEJOB then
    begin
      nCMDCode := nSC_CHANGEJOB;
      goto L001;
    end;
    if sCmd = sSC_CHANGEHEROJOB then
    begin
      nCMDCode := nSC_CHANGEHEROJOB;
      goto L001;
    end;
    if sCmd = sSC_CLEARHEROSKILL then
    begin
      nCMDCode := nSC_CLEARHEROSKILL;
      goto L001;
    end;
    if sCmd = sSC_MISSION then
    begin
      nCMDCode := nSC_MISSION;
      goto L001;
    end;
    if sCmd = sSC_MOBPLACE then
    begin
      nCMDCode := nSC_MOBPLACE;
      goto L001;
    end;
    if sCmd = sSC_SETMEMBERTYPE then
    begin
      nCMDCode := nSC_SETMEMBERTYPE;
      goto L001;
    end;
    if sCmd = sSC_SETMEMBERLEVEL then
    begin
      nCMDCode := nSC_SETMEMBERLEVEL;
      goto L001;
    end;
    if sCmd = sSC_GAMEGOLD then
    begin
      nCMDCode := nSC_GAMEGOLD;
      goto L001;
    end;
    if sCmd = sSC_NIMBUS then
    begin
      nCMDCode := nSC_NIMBUS;
      goto L001;
    end;
    if sCmd = sSC_ABILITYADD then
    begin
      nCMDCode := nSC_ABILITYADD;
      goto L001;
    end;

    if sCmd = sSC_GAMEPOINT then
    begin
      nCMDCode := nSC_GAMEPOINT;
      goto L001;
    end;
    if sCmd = sSC_PKZONE then
    begin
      nCMDCode := nSC_PKZONE;
      goto L001;
    end;
    if sCmd = sSC_RESTBONUSPOINT then
    begin
      nCMDCode := nSC_RESTBONUSPOINT;
      goto L001;
    end;
    if sCmd = sSC_TAKECASTLEGOLD then
    begin
      nCMDCode := nSC_TAKECASTLEGOLD;
      goto L001;
    end;
    if sCmd = sSC_HUMANHP then
    begin
      nCMDCode := nSC_HUMANHP;
      goto L001;
    end;
    if sCmd = sSC_HUMANMP then
    begin
      nCMDCode := nSC_HUMANMP;
      goto L001;
    end;
    if sCmd = sSC_BUILDPOINT then
    begin
      nCMDCode := nSC_BUILDPOINT;
      goto L001;
    end;
    if sCmd = sSC_AURAEPOINT then
    begin
      nCMDCode := nSC_AURAEPOINT;
      goto L001;
    end;
    if sCmd = sSC_STABILITYPOINT then
    begin
      nCMDCode := nSC_STABILITYPOINT;
      goto L001;
    end;
    if sCmd = sSC_FLOURISHPOINT then
    begin
      nCMDCode := nSC_FLOURISHPOINT;
      goto L001;
    end;
    if sCmd = sSC_OPENMAGICBOX then
    begin
      nCMDCode := nSC_OPENMAGICBOX;
      goto L001;
    end;
    if sCmd = sSC_SETRANKLEVELNAME then
    begin
      nCMDCode := nSC_SETRANKLEVELNAME;
      goto L001;
    end;
    if sCmd = sSC_GMEXECUTE then
    begin
      nCMDCode := nSC_GMEXECUTE;
      goto L001;
    end;
    if sCmd = sSC_GUILDCHIEFITEMCOUNT then
    begin
      nCMDCode := nSC_GUILDCHIEFITEMCOUNT;
      goto L001;
    end;
    if sCmd = sSC_ADDNAMEDATELIST then
    begin
      nCMDCode := nSC_ADDNAMEDATELIST;
      goto L001;
    end;
    if sCmd = sSC_DELNAMEDATELIST then
    begin
      nCMDCode := nSC_DELNAMEDATELIST;
      goto L001;
    end;
    if sCmd = sSC_MOBFIREBURN then
    begin
      nCMDCode := nSC_MOBFIREBURN;
      goto L001;
    end;
    if sCmd = sSC_MESSAGEBOX then
    begin
      nCMDCode := nSC_MESSAGEBOX;
      goto L001;
    end;
    if sCmd = sSC_SETSCRIPTFLAG then
    begin
      nCMDCode := nSC_SETSCRIPTFLAG;
      goto L001;
    end;
    if sCmd = sSC_SETAUTOGETEXP then
    begin
      nCMDCode := nSC_SETAUTOGETEXP;
      goto L001;
    end;
    if sCmd = sSC_VAR then
    begin
      nCMDCode := nSC_VAR;
      goto L001;
    end;
    if sCmd = sSC_LOADVAR then
    begin
      nCMDCode := nSC_LOADVAR;
      goto L001;
    end;
    if sCmd = sSC_SAVEVAR then
    begin
      nCMDCode := nSC_SAVEVAR;
      goto L001;
    end;
    if sCmd = sSC_CALCVAR then
    begin
      nCMDCode := nSC_CALCVAR;
      goto L001;
    end;
    if sCmd = sSC_AUTOADDGAMEGOLD then
    begin
      nCMDCode := nSC_AUTOADDGAMEGOLD;
      goto L001;
    end;
    if sCmd = sSC_AUTOSUBGAMEGOLD then
    begin
      nCMDCode := nSC_AUTOSUBGAMEGOLD;
      goto L001;
    end;
    if sCmd = sSC_GROUPMAPTING then
    begin
      nCMDCode := nSC_GROUPMAPTING;
      goto L001;
    end;

    if sCmd = sSC_RECALLGROUPMEMBERS then
    begin
      nCMDCode := nSC_RECALLGROUPMEMBERS;
      goto L001;
    end;
    if sCmd = sSC_CLEARNAMELIST then
    begin
      nCMDCode := nSC_CLEARNAMELIST;
      goto L001;
    end;
    if sCmd = sSC_CHANGENAMECOLOR then
    begin
      nCMDCode := nSC_CHANGENAMECOLOR;
      goto L001;
    end;
    if sCmd = sSC_CLEARPASSWORD then
    begin
      nCMDCode := nSC_CLEARPASSWORD;
      goto L001;
    end;
    if sCmd = sSC_RENEWLEVEL then
    begin
      nCMDCode := nSC_RENEWLEVEL;
      goto L001;
    end;
    if sCmd = sSC_KILLMONEXPRATE then
    begin
      nCMDCode := nSC_KILLMONEXPRATE;
      goto L001;
    end;
    if sCmd = sSC_POWERRATE then
    begin
      nCMDCode := nSC_POWERRATE;
      goto L001;
    end;
    if sCmd = sSC_SETRANDOMNO then
    begin
      nCMDCode := nSC_SETRANDOMNO;
      goto L001;
    end;
    if sCmd = sSC_DETOXIFCATION then
    begin
      nCMDCode := nSC_DETOXIFCATION;
      goto L001;
    end;
    if sCmd = sSC_NAMECOLOR then
    begin
      nCMDCode := nSC_NAMECOLOR;
      goto L001;
    end;
    if sCmd = sSC_STATUSRATE then
    begin
      nCMDCode := nSC_STATUSRATE;
      goto L001;
    end;
    if sCmd = sSC_CHANGEMODE then
    begin
      nCMDCode := nSC_CHANGEMODE;
      goto L001;
    end;
    if sCmd = sSC_CHANGEPERMISSION then
    begin
      nCMDCode := nSC_CHANGEPERMISSION;
      goto L001;
    end;
    if sCmd = sSC_KILL then
    begin
      nCMDCode := nSC_KILL;
      goto L001;
    end;
    if (sCmd = sSC_KICK) or (sCmd = 'KICKOFFLINE') then
    begin
      nCMDCode := nSC_KICK;
      goto L001;
    end;
    if sCmd = sSC_BONUSPOINT then
    begin
      nCMDCode := nSC_BONUSPOINT;
      goto L001;
    end;
    if sCmd = sSC_RESTRENEWLEVEL then
    begin
      nCMDCode := nSC_RESTRENEWLEVEL;
      goto L001;
    end;
    if sCmd = sSC_DELMARRY then
    begin
      nCMDCode := nSC_DELMARRY;
      goto L001;
    end;
    if sCmd = sSC_DELMASTER then
    begin
      nCMDCode := nSC_DELMASTER;
      goto L001;
    end;
    if sCmd = sSC_MASTER then
    begin
      nCMDCode := nSC_MASTER;
      goto L001;
    end;
    if sCmd = sSC_UNMASTER then
    begin
      nCMDCode := nSC_UNMASTER;
      goto L001;
    end;
    if sCmd = sSC_CREDITPOINT then
    begin
      nCMDCode := nSC_CREDITPOINT;
      goto L001;
    end;
    if sCmd = sSC_HEROCREDITPOINT then
    begin
      nCMDCode := nSC_HEROCREDITPOINT;
      goto L001;
    end;
    if sCmd = sSC_CHANGEATTACKMODE then
    begin
      nCMDCode := nSC_CHANGEATTACKMODE;
      goto L001;
    end;
    if sCmd = sSC_SETMISSION then
    begin
      nCMDCode := nSC_SETMISSION;
      goto L001;
    end;
    if sCmd = sSC_CLEARMISSION then
    begin
      nCMDCode := nSC_CLEARMISSION;
      goto L001;
    end;

    if sCmd = sSC_CLEARNEEDITEMS then
    begin
      nCMDCode := nSC_CLEARNEEDITEMS;
      goto L001;
    end;
    if sCmd = sSC_CLEARMAKEITEMS then
    begin
      nCMDCode := nSC_CLEARMAEKITEMS;
      goto L001;
    end;

    if sCmd = sSC_SETSENDMSGFLAG then
    begin
      nCMDCode := nSC_SETSENDMSGFLAG;
      goto L001;
    end;
    if sCmd = sSC_UPGRADEITEMS then
    begin
      nCMDCode := nSC_UPGRADEITEMS;
      goto L001;
    end;
    if sCmd = sSC_UPGRADEITEMSEX then
    begin
      nCMDCode := nSC_UPGRADEITEMSEX;
      goto L001;
    end;
    if sCmd = sSC_MONGENEX then
    begin
      nCMDCode := nSC_MONGENEX;
      goto L001;
    end;
    if sCmd = sSC_MONGENEX2 then
    begin
      nCMDCode := nSC_MONGENEX2;
      goto L001;
    end;
    if sCmd = sSC_MoveToEscort then
    begin
      nCMDCode := nSC_MoveToEscort;
      goto L001;
    end;
    if sCmd = sSC_EscortFinish then
    begin
      nCMDCode := NSC_EscortFinish;
      goto L001;
    end;
    if sCmd = sSC_GiveUpEscort then
    begin
      nCMDCode := NSC_GiveUpEscort;
      goto L001;
    end;

    if sCmd = sSC_CLEARMAPMON then
    begin
      nCMDCode := nSC_CLEARMAPMON;
      goto L001;
    end;
    if sCmd = sSC_SETMAPMODE then
    begin
      nCMDCode := nSC_SETMAPMODE;
      goto L001;
    end;
    if sCmd = sSC_KILLSLAVE then
    begin
      nCMDCode := nSC_KILLSLAVE;
      goto L001;
    end;
    if sCmd = sSC_CHANGEGENDER then
    begin
      nCMDCode := nSC_CHANGEGENDER;
      goto L001;
    end;
    if sCmd = sSC_MAPTING then
    begin
      nCMDCode := nSC_MAPTING;
      goto L001;
    end;
    if sCmd = sADDUSERDATE then
    begin
      nCMDCode := nADDUSERDATE;
      goto L001;
    end;
    if sCmd = sDELUSERDATE then
    begin
      nCMDCode := nDELUSERDATE;
      goto L001;
    end;
    if sCmd = sClearCodeList then
    begin
      nCMDCode := nClearCodeList;
      goto L001;
    end;
    if sCmd = sYCCALLMOB then
    begin
      nCMDCode := nYCCALLMOB;
      goto L001;
    end;
    if (sCmd = sgroupmapmove) or (sCmd = sSC_GROUPMOVE) then
    begin
      nCMDCode := ngroupmapmove;
      goto L001;
    end;
    if sCmd = sthroughhum then
    begin
      nCMDCode := nthroughhum;
      goto L001;
    end;
    if sCmd = sSC_CLEAREctype then
    begin
      nCMDCode := nSC_CLEAREctype;
      goto L001;
    end;
    if (sCmd = sSC_OFFLINE) or (sCmd = 'OFFLINEPLAY') then
    begin
      nCMDCode := nSC_OFFLINE;
      goto L001;
    end;
    if (sCmd = sSC_OFFLINEPLAY) then
    begin
      nCMDCode := nSC_OFFLINEPLAY;
      goto L001;
    end;
    if sCmd = sSC_QUERYBINDITEM then
    begin
      nCMDCode := nSC_QUERYBINDITEM;
      goto L001;
    end;
    if sCmd = sSC_BINDRESUME then
    begin
      nCMDCode := nSC_BINDRESUME;
      goto L001;
    end;
    if sCmd = sSC_UNBINDRESUME then
    begin
      nCMDCode := nSC_UNBINDRESUME;
      goto L001;
    end;

    if sCmd = sSC_SETOFFLINE then
    begin
      nCMDCode := nSC_SETOFFLINE;
      goto L001;
    end;
    if sCmd = sSC_STARTTAKEGOLD then
    begin
      nCMDCode := nSC_STARTTAKEGOLD;
      goto L001;
    end;
    if sCmd = sSC_DELAYCALL then
    begin
      nCMDCode := nSC_DELAYCALL;
      goto L001;
    end;
    if sCmd = sSC_DELAYGOTO then
    begin
      nCMDCode := nSC_DELAYGOTO;
      goto L001;
    end;
    if sCmd = sSC_CLEARDELAYGOTO then
    begin
      nCMDCode := nSC_CLEARDELAYGOTO;
      goto L001;
    end;
    if sCmd = sSC_CHATCOLOR then
    begin
      nCMDCode := nSC_CHATCOLOR;
      goto L001;
    end;
    if sCmd = sSC_CHATFONT then
    begin
      nCMDCode := nSC_CHATFONT;
      goto L001;
    end;
    if (sCmd = sSC_GUILDMAPMOVE) or (sCmd = 'GUILDMOVE') then
    begin
      nCMDCode := nSC_GUILDMAPMOVE;
      goto L001;
    end;
    if sCmd = sSC_RECALLPNEUMA then
    begin
      nCMDCode := nSC_RECALLPNEUMA;
      goto L001;
    end;
    if sCmd = sSC_RECALLHeroEX then
    begin
      nCMDCode := nSC_RECALLHeroEX;
      goto L001;
    end;
    if sCmd = sSC_ADDGUILD then
    begin
      nCMDCode := nSC_ADDGUILD;
      goto L001;
    end;
    if sCmd = sSC_REPAIRALL then
    begin
      nCMDCode := nSC_REPAIRALL;
      goto L001;
    end;
    if sCmd = sSC_SETOFFLINEFUNC then
    begin
      nCMDCode := nSC_SETOFFLINEFUNC;
      goto L001;
    end;
    if sCmd = sSC_GAMEDIAMOND then
    begin
      nCMDCode := nSC_GAMEDIAMOND;
      goto L001;
    end;
    if sCmd = sSC_GAMEGIRD then
    begin
      nCMDCode := nSC_GAMEGIRD;
      goto L001;
    end;
    if sCmd = sSC_BONUSABIL then
    begin
      nCMDCode := nSC_BONUSABIL;
      goto L001;
    end;
    if sCmd = sSC_CREATEHERO then
    begin
      nCMDCode := nSC_CREATEHERO;
      goto L001;
    end;
    if sCmd = sSC_CREATEHEROEX then
    begin
      nCMDCode := nSC_CREATEHEROEX;
      goto L001;
    end;
    if sCmd = sSC_DELETEHERO then
    begin
      nCMDCode := nSC_DELETEHERO;
      goto L001;
    end;
    if sCmd = sSC_OPENBOX then
    begin
      nCMDCode := nSC_OPENBOX;
      goto L001;
    end;
    if sCmd = sSC_QUERYREFINEITEM then
    begin
      nCMDCode := nSC_QUERYREFINEITEM;
      goto L001;
    end;
    if sCmd = sSC_AFFILIATEGUILD then
    begin
      nCMDCode := nSC_AFFILIATEGUILD;
      goto L001;
    end;
    if sCmd = sSC_SETTARGETXY then
    begin
      nCMDCode := nSC_SETTARGETXY;
      goto L001;
    end;
    if sCmd = sSC_MAPMOVEHUMAN then
    begin
      nCMDCode := nSC_MAPMOVEHUMAN;
      goto L001;
    end;

    if sCmd = sSC_QUERYVALUE then
    begin
      nCMDCode := nSC_QUERYVALUE;
      goto L001;
    end;
    if sCmd = sSC_RELEASECOLLECTEXP then
    begin
      nCMDCode := nSC_RELEASECOLLECTEXP;
      goto L001;
    end;
    if sCmd = sSC_RESETCOLLECTEXPSTATE then
    begin
      nCMDCode := nSC_RESETCOLLECTEXPSTATE;
      goto L001;
    end;
    if sCmd = sSC_GETSTRLENGTH then
    begin
      nCMDCode := nSC_GETSTRLENGTH;
      goto L001;
    end;

    if sCmd = sSC_CHANGEVENATIONLEVEL then
    begin
      nCMDCode := nSC_CHANGEVENATIONLEVEL;
      goto L001;
    end;
    if sCmd = sSC_CHANGEVENATIONPOINT then
    begin
      nCMDCode := nSC_CHANGEVENATIONPOINT;
      goto L001;
    end;
    if sCmd = sSC_CLEARVENATIONDATA then
    begin
      nCMDCode := nSC_CLEARVENATIONDATA;
      goto L001;
    end;
    if sCmd = sSC_CONVERTSKILL then
    begin
      nCMDCode := nSC_CONVERTSKILL;
      goto L001;
    end;

    if sCmd = sSC_QUERYITEMDLG then
    begin
      nCMDCode := nSC_QUERYITEMDLG;
      goto L001;
    end;
    if sCmd = sSC_GETDLGITEMVALUE then
    begin
      nCMDCode := nSC_GETDLGITEMVALUE;
      goto L001;
    end;
    if sCmd = sSC_UPGRADEDLGITEM then
    begin
      nCMDCode := nSC_UPGRADEDLGITEM;
      goto L001;
    end;

    if sCmd = sSC_OPENBOOK then
    begin
      nCMDCode := nSC_OPENBOOK;
      goto L001;
    end;
    if sCmd = sSC_TAGMAPINFO then
    begin
      nCMDCode := nSC_TAGMAPINFO;
      goto L001;
    end;
    if sCmd = sSC_TAGMAPMOVE then
    begin
      nCMDCode := nSC_TAGMAPMOVE;
      goto L001;
    end;
    if sCmd = sSC_RECALLPLAYER then
    begin
      nCMDCode := nSC_RECALLPLAYER;
      goto L001;
    end;
    if sCmd = sSC_RECALLHERO then
    begin
      nCMDCode := nSC_RECALLHERO;
      goto L001;
    end;
    if sCmd = sSC_GETPOSENAME then
    begin
      nCMDCode := nSC_GETPOSENAME;
      goto L001;
    end;

    if sCmd = sSC_QUERYBAGITEMS then
    begin
      nCMDCode := nSC_QUERYBAGITEMS;
      goto L001;
    end;
    if sCmd = sSC_SETATTRIBUTE then
    begin
      nCMDCode := nSC_SETATTRIBUTE;
      goto L001;
    end;
    if sCmd = sSC_READINITEXT then
    begin
      nCMDCode := nSC_READINITEXT;
      goto L001;
    end;
    if sCmd = sSC_WRITEINITEXT then
    begin
      nCMDCode := nSC_WRITEINITEXT;
      goto L001;
    end;

    if sCmd = sSC_AUTOMOVE then
    begin
      nCMDCode := nSC_AUTOMOVE;
      goto L001;
    end;
    if sCmd = sSC_GETTITLESCOUNT then
    begin
      nCMDCode := nSC_GETTITLESCOUNT;
      goto L001;
    end;
    {
    if @Engine_SetScriptActionCmd <> nil then begin
      nCMDCode := Engine_SetScriptActionCmd(PChar(sCmd));
      goto L001;
    end;
    }

    L001:
    if nCMDCode > 0 then
    begin
      QuestActionInfo.nCMDCode := nCMDCode;
      //if sActName <> '' then QuestActionInfo.sActChr := sActName;
      if (sParam1 <> '') and (sParam1[1] = '"') then
        ArrestStringEx(sParam1, '"', '"', sParam1);
      if (sParam2 <> '') and (sParam2[1] = '"') then
        ArrestStringEx(sParam2, '"', '"', sParam2);
      if (sParam3 <> '') and (sParam3[1] = '"') then
        ArrestStringEx(sParam3, '"', '"', sParam3);
      if (sParam4 <> '') and (sParam4[1] = '"') then
        ArrestStringEx(sParam4, '"', '"', sParam4);
      if (sParam5 <> '') and (sParam5[1] = '"') then
        ArrestStringEx(sParam5, '"', '"', sParam5);
      if (sParam6 <> '') and (sParam6[1] = '"') then
        ArrestStringEx(sParam6, '"', '"', sParam6);
      if (sParam7 <> '') and (sParam7[1] = '"') then
        ArrestStringEx(sParam7, '"', '"', sParam7);
      if (sParam8 <> '') and (sParam8[1] = '"') then
        ArrestStringEx(sParam8, '"', '"', sParam8);
      if (sParam9 <> '') and (sParam9[1] = '"') then
        ArrestStringEx(sParam9, '"', '"', sParam9);
      if (sParam10 <> '') and (sParam10[1] = '"') then
        ArrestStringEx(sParam10, '"', '"', sParam10);
      QuestActionInfo.sParam1 := sParam1;
      QuestActionInfo.sParam2 := sParam2;
      QuestActionInfo.sParam3 := sParam3;
      QuestActionInfo.sParam4 := sParam4;
      QuestActionInfo.sParam5 := sParam5;
      QuestActionInfo.sParam6 := sParam6;
      QuestActionInfo.sParam7 := sParam7;
      QuestActionInfo.sParam8 := sParam8;
      QuestActionInfo.sParam9 := sParam9;
      QuestActionInfo.sParam10 := sParam10;
      if IsStringNumber(sParam1) then
        QuestActionInfo.nParam1 := Str_ToInt(sParam1, 0);
      if IsStringNumber(sParam2) then
        QuestActionInfo.nParam2 := Str_ToInt(sParam2, 0);  
      if IsStringNumber(sParam3) then
        QuestActionInfo.nParam3 := Str_ToInt(sParam3, 0); 
      if IsStringNumber(sParam4) then
        QuestActionInfo.nParam4 := Str_ToInt(sParam4, 0);
      if IsStringNumber(sParam5) then
        QuestActionInfo.nParam5 := Str_ToInt(sParam5, 0);
      if IsStringNumber(sParam6) then
        QuestActionInfo.nParam6 := Str_ToInt(sParam6, 0);
      if IsStringNumber(sParam7) then
        QuestActionInfo.nParam7 := Str_ToInt(sParam7, 0);
      if IsStringNumber(sParam8) then
        QuestActionInfo.nParam8 := Str_ToInt(sParam8, 0);
      if IsStringNumber(sParam9) then
        QuestActionInfo.nParam9 := Str_ToInt(sParam9, 0);
      if IsStringNumber(sParam10) then
        QuestActionInfo.nParam10 := Str_ToInt(sParam10, 0);
      Result := True;
    end;
  end;
begin
  n6C := 0;
  n70 := 0;
  sScritpFileName := g_Config.sEnvirDir + sPatch + sScritpName + '.txt';
  if FileExists(sScritpFileName) then
  begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sScritpFileName);
    {.$I '..\Common\Macros\VMPBM.inc'}
        //DeCodeStringList(LoadList);
    if LoadList.Count > 0 then
    begin
      sLine := LoadList.Strings[0];
      if CompareLStr(sLine, sENCYPTSCRIPTFLAG, Length(sENCYPTSCRIPTFLAG)) then
      begin
        for i := 0 to LoadList.Count - 1 do
        begin
          sLine := LoadList.Strings[i];
          if sLine = '' then
            Continue;
          if (nDeCryptString >= 0) and Assigned(PlugProcArray[nDeCryptString].nProcAddr) then
          begin
            FillChar(Dest, SizeOf(Dest), #0);
            TDeCryptString(PlugProcArray[nDeCryptString].nProcAddr)(@sLine[1], @Dest, Length(sLine), nDest);
            LoadList.Strings[i] := StrPas(PChar(@Dest));
          end;
        end;
      end;
    end;

    i := 0;
    while (True) do
    begin
      if not LoadScriptCall(LoadList) then
        Break;
      Inc(i);
      if i >= 99 then
        Break;
    end;
    {.$I '..\Common\Macros\VMPE.inc'}

    DefineList := TList.Create;
    s54 := LoadDefineInfo(LoadList, DefineList);
    New(DefineInfo);
    DefineInfo.sName := '@HOME';
    if s54 = '' then
      s54 := '@main';
    DefineInfo.sText := s54;
    DefineList.Add(DefineInfo);
    for i := 0 to LoadList.Count - 1 do
    begin
      s34 := Trim(LoadList.Strings[i]);
      if (s34 <> '') then
      begin
        if (s34[1] = '[') then
          bo8D := False
        else if (s34[1] = '#') and (CompareLStr(s34, '#IF', Length('#IF')) or CompareLStr(s34, '#ACT', Length('#ACT')) or CompareLStr(s34, '#ELSEACT', Length('#ELSEACT'))) then
          bo8D := True
        else if bo8D then
        begin
          for n20 := 0 to DefineList.Count - 1 do
          begin
            DefineInfo := DefineList.Items[n20];
            n1C := 0;
            while (True) do
            begin
              n24 := Pos(DefineInfo.sName, UpperCase(s34));
              if n24 <= 0 then
                Break;
              s58 := Copy(s34, 1, n24 - 1);
              s5C := Copy(s34, Length(DefineInfo.sName) + n24, 256);
              s34 := s58 + DefineInfo.sText + s5C;
              LoadList.Strings[i] := s34;
              Inc(n1C);
              if n1C >= 10 then
                Break;
            end;
          end;
        end;
      end;
    end;
    for i := 0 to DefineList.Count - 1 do
      Dispose(pTDefineInfo(DefineList.Items[i]));
    DefineList.Free;

    Script := nil;
    SayingRecord := nil;
    nQuestIdx := 0;
    for i := 0 to LoadList.Count - 1 do
    begin
      s34 := Trim(LoadList.Strings[i]);
      if (s34 = '') or (s34[1] = ';') or (s34[1] = '/') then
        Continue;
      if (n6C = 0) and (boFlag) then
      begin
        //物品价格倍率
        if s34[1] = '%' then
        begin
          s34 := Copy(s34, 2, Length(s34) - 1);
          nPriceRate := Str_ToInt(s34, -1);
          if nPriceRate >= 55 then
            TMerchant(NPC).m_nPriceRate := nPriceRate;
          Continue;
        end;
        //物品交易类型
        if s34[1] = '+' then
        begin
          s34 := Copy(s34, 2, Length(s34) - 1);
          nItemType := Str_ToInt(s34, -1);
          if nItemType >= 0 then
            TMerchant(NPC).m_ItemTypeList.Add(Pointer(nItemType));
          Continue;
        end;
        //增加处理NPC可执行命令设置
        if s34[1] = '(' then
        begin
          ArrestStringEx(s34, '(', ')', s34);
          if s34 <> '' then
          begin
            while (s34 <> '') do
            begin
              s34 := GetValidStr3(s34, s30, [' ', ',', #9]);
              if CompareText(s30, sBUY) = 0 then
              begin
                TMerchant(NPC).m_boBuy := True;
                Continue;
              end;
              if CompareText(s30, sSELL) = 0 then
              begin
                TMerchant(NPC).m_boSell := True;
                Continue;
              end;
              if CompareText(s30, sMAKEDURG) = 0 then
              begin
                TMerchant(NPC).m_boMakeDrug := True;
                Continue;
              end;
              if CompareText(s30, sPRICES) = 0 then
              begin
                TMerchant(NPC).m_boPrices := True;
                Continue;
              end;
              if CompareText(s30, sSTORAGE) = 0 then
              begin
                TMerchant(NPC).m_boStorage := True;
                Continue;
              end;
              if CompareText(s30, sGETBACK) = 0 then
              begin
                TMerchant(NPC).m_boGetback := True;
                Continue;
              end;
              if CompareText(s30, sUPGRADENOW) = 0 then
              begin
                TMerchant(NPC).m_boUpgradenow := True;
                Continue;
              end;
              if CompareText(s30, sGETBACKUPGNOW) = 0 then
              begin
                TMerchant(NPC).m_boGetBackupgnow := True;
                Continue;
              end;
              if CompareText(s30, sREPAIR) = 0 then
              begin
                TMerchant(NPC).m_boRepair := True;
                Continue;
              end;
              if CompareText(s30, sSUPERREPAIR) = 0 then
              begin
                TMerchant(NPC).m_boS_repair := True;
                Continue;
              end;
              if CompareText(s30, sSL_SENDMSG) = 0 then
              begin
                TMerchant(NPC).m_boSendmsg := True;
                Continue;
              end;
              if CompareText(s30, sUSEITEMNAME) = 0 then
              begin
                TMerchant(NPC).m_boUseItemName := True;
                Continue;
              end;
              if CompareText(s30, sDEALGOLD) = 0 then
              begin
                TMerchant(NPC).m_boDealGold := True;
                Continue;
              end;
              if CompareText(s30, sOFFLINEMSG) = 0 then
              begin
                TMerchant(NPC).m_boOffLineMsg := True;
                Continue;
              end;
              if CompareText(s30, sMAKEPEUMA) = 0 then
              begin
                TMerchant(NPC).m_boMakeHero := True;
                Continue;
              end;
              if CompareText(s30, sCERATEHERO) = 0 then
              begin
                TMerchant(NPC).m_boCreateHero := True;
                Continue;
              end;
              if CompareText(s30, sINPUTINTEGER) = 0 then
              begin
                TMerchant(NPC).m_boInputInteger := True;
                Continue;
              end;
              if CompareText(s30, sINPUTSTRING) = 0 then
              begin
                TMerchant(NPC).m_boInputString := True;
                Continue;
              end;
              if CompareText(s30, sYBDEAL) = 0 then
              begin
                TMerchant(NPC).m_boYBDeal := True;
                Continue;
              end;
              if CompareText(s30, sITEMMARKET) = 0 then
              begin
                TMerchant(NPC).m_boItemMarket := True;
                Continue;
              end;
              if CompareLStr(s30, sMDlgImgName, Length(sMDlgImgName)) then
              begin
                TMerchant(NPC).m_sMDlgImgName := Copy(s30, Length(sMDlgImgName) + 1, Length(s30));
                Continue;
              end;

            end;
          end;
          Continue;
        end
          //增加处理NPC可执行命令设置
      end;

      if s34[1] = '{' then
      begin
        if CompareLStr(s34, '{Quest', Length('{Quest')) then
        begin
          s38 := GetValidStr3(s34, s3C, [' ', '}', #9]);
          GetValidStr3(s38, s3C, [' ', '}', #9]);
          n70 := Str_ToInt(s3C, 0);
          Script := MakeNewScript();
          Script.nQuest := n70;
          Inc(n70);
        end;
        if CompareLStr(s34, '{~Quest', Length('{~Quest')) then
          Continue;
      end;

      if (n6C = 1) and (Script <> nil) and (s34[1] = '#') then
      begin
        s38 := GetValidStr3(s34, s3C, ['=', ' ', #9]);
        Script.boQuest := True;
        if CompareLStr(s34, '#IF', Length('#IF')) then
        begin
          ArrestStringEx(s34, '[', ']', s40);
          Script.QuestInfo[nQuestIdx].wFlag := Str_ToInt(s40, 0);
          GetValidStr3(s38, s44, ['=', ' ', #9]);
          n24 := Str_ToInt(s44, 0);
          if n24 <> 0 then
            n24 := 1;
          Script.QuestInfo[nQuestIdx].btValue := n24;
        end;
        if CompareLStr(s34, '#RAND', Length('#RAND')) then
          Script.QuestInfo[nQuestIdx].nRandRage := Str_ToInt(s44, 0);
        Continue;
      end;

      if s34[1] = '[' then
      begin
        n6C := 10;
        if Script = nil then
        begin
          Script := MakeNewScript();
          Script.nQuest := n70;
        end;
        if CompareText(s34, '[goods]') = 0 then
        begin
          n6C := 20;
          Continue;
        end;

        s34 := ArrestStringEx(s34, '[', ']', s74);
        New(SayingRecord);
        SayingRecord.ProcedureList := TList.Create;
        SayingRecord.sLabel := s74;
        s34 := GetValidStrCap(s34, s74, [' ', #9]);
        if CompareText(s74, 'TRUE') = 0 then
          SayingRecord.boExtJmp := True
        else
          SayingRecord.boExtJmp := False;

        New(SayingProcedure);
        SayingRecord.ProcedureList.Add(SayingProcedure);
        SayingProcedure.ConditionList := TList.Create;
        SayingProcedure.ActionList := TList.Create;
        SayingProcedure.sSayMsg := '';
        SayingProcedure.ElseActionList := TList.Create;
        SayingProcedure.sElseSayMsg := '';
        Script.RecordList.Add(SayingRecord);
        Continue;
      end; //0048BE05
      if (Script <> nil) and (SayingRecord <> nil) then
      begin
        if (n6C >= 10) and (n6C < 20) and (s34[1] = '#') then
        begin
          if CompareText(s34, '#IF') = 0 then
          begin
            if (SayingProcedure.ConditionList.Count > 0) or (SayingProcedure.sSayMsg <> '') or (SayingProcedure.ActionList.Count > 0) then
            begin //0048BE53
              New(SayingProcedure);
              SayingRecord.ProcedureList.Add(SayingProcedure);
              SayingProcedure.ConditionList := TList.Create;
              SayingProcedure.ActionList := TList.Create;
              SayingProcedure.sSayMsg := '';
              SayingProcedure.ElseActionList := TList.Create;
              SayingProcedure.sElseSayMsg := '';
            end; //0048BECE
            n6C := 11;
          end; //0048BED5
          if CompareText(s34, '#ACT') = 0 then
            n6C := 12;
          if CompareText(s34, '#SAY') = 0 then
            n6C := 10;
          if CompareText(s34, '#ELSEACT') = 0 then
            n6C := 13;
          if CompareText(s34, '#ELSESAY') = 0 then
            n6C := 14;
          Continue;
        end;

        if (n6C = 10) and (SayingProcedure <> nil) then
          SayingProcedure.sSayMsg := SayingProcedure.sSayMsg + s34;

        if (n6C = 11) then
        begin
          New(QuestConditionInfo);
          //FillCharSafe(QuestConditionInfo^, SizeOf(TQuestConditionInfo), #0);
          FillChar(QuestConditionInfo^, SizeOf(TQuestConditionInfo), #0);
          if QuestCondition(Trim(s34), QuestConditionInfo) then
            SayingProcedure.ConditionList.Add(QuestConditionInfo)
          else
          begin
            Dispose(QuestConditionInfo);
            MainOutMessageAPI('脚本错误 第:' + IntToStr(i) + ' 行: ' + sScritpFileName);
          end;
        end;

        if (n6C = 12) then
        begin
          New(QuestActionInfo);
          FillChar(QuestActionInfo^, SizeOf(TQuestActionInfo), #0);
          if QuestAction(Trim(s34), QuestActionInfo) then
            SayingProcedure.ActionList.Add(QuestActionInfo)
          else
          begin
            Dispose(QuestActionInfo);
            MainOutMessageAPI('脚本错误 第:' + IntToStr(i) + ' 行: ' + sScritpFileName);
          end;
        end;

        if (n6C = 13) then
        begin
          New(QuestActionInfo);
          FillChar(QuestActionInfo^, SizeOf(TQuestActionInfo), #0);
          if QuestAction(Trim(s34), QuestActionInfo) then
            SayingProcedure.ElseActionList.Add(QuestActionInfo)
          else
          begin
            Dispose(QuestActionInfo);
            MainOutMessageAPI('脚本错误 第:' + IntToStr(i) + ' 行: ' + sScritpFileName);
          end;
        end;
        if (n6C = 14) then
          SayingProcedure.sElseSayMsg := SayingProcedure.sElseSayMsg + s34;
      end;
      if (n6C = 20) and boFlag then
      begin
        s34 := GetValidStrCap(s34, s48, [' ', #9]);
        s34 := GetValidStrCap(s34, s4C, [' ', #9]);
        s34 := GetValidStrCap(s34, s50, [' ', #9]);
        if (s48 <> '') and (s50 <> '') then
        begin
          New(Goods);
          if (s48 <> '') and (s48[1] = '"') then
            ArrestStringEx(s48, '"', '"', s48);
          Goods.sItemName := s48;
          Goods.nCount := Str_ToInt(s4C, 0);
          Goods.dwRefillTime := Str_ToInt(s50, 0);
          Goods.dwRefillTick := 0;
          TMerchant(NPC).m_RefillGoodsList.Add(Goods);
        end;
      end;
    end;
    LoadList.Free;
  end
  else
    MainOutMessageAPI('脚本文件未找到: ' + sScritpFileName);
  Result := 1;
end;

function TFrmDB.SaveGoodRecord(NPC: TMerchant; sFile: string): Integer;
var
  i, ii: Integer;
  sFileName: string;
  FileHandle: Integer;
  UserItem: pTUserItem;
  List: TList;
  Header420: TGoodFileHeader;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Saved\' + sFile + '.sav';
  if FileExists(sFileName) then
    FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone)
  else
    FileHandle := FileCreate(sFileName);
  if FileHandle > 0 then
  begin
    FillChar(Header420, SizeOf(TGoodFileHeader), #0);
    for i := 0 to NPC.m_GoodsList.Count - 1 do
    begin
      List := TList(NPC.m_GoodsList.Items[i]);
      Inc(Header420.nItemCount, List.Count);
    end;
    FileWrite(FileHandle, Header420, SizeOf(TGoodFileHeader));
    for i := 0 to NPC.m_GoodsList.Count - 1 do
    begin
      List := TList(NPC.m_GoodsList.Items[i]);
      for ii := 0 to List.Count - 1 do
      begin
        UserItem := List.Items[ii];
        FileWrite(FileHandle, UserItem^, SizeOf(TUserItem));
      end;
    end;
    FileClose(FileHandle);
    Result := 1;
  end;
end;

function TFrmDB.SaveGoodPriceRecord(NPC: TMerchant; sFile: string): Integer;
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  ItemPrice: pTItemPrice;
  Header420: TGoodFileHeader;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Prices\' + sFile + '.prc';
  if FileExists(sFileName) then
    FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone)
  else
    FileHandle := FileCreate(sFileName);
  if FileHandle > 0 then
  begin
    FillChar(Header420, SizeOf(TGoodFileHeader), #0);
    Header420.nItemCount := NPC.m_ItemPriceList.Count;
    FileWrite(FileHandle, Header420, SizeOf(TGoodFileHeader));
    for i := 0 to NPC.m_ItemPriceList.Count - 1 do
    begin
      ItemPrice := NPC.m_ItemPriceList.Items[i];
      FileWrite(FileHandle, ItemPrice^, SizeOf(TItemPrice));
    end;
    FileClose(FileHandle);
    Result := 1;
  end;
end;

procedure TFrmDB.ReLoadNpc;
begin

end;

procedure TFrmDB.ReLoadMerchants;
var
  i, ii, nX, nY: Integer;
  sLineText, sFileName, sScript, sMapName, sX, sY, sCharName, sFlag, sAppr, sCastle, sCanMove, sMoveTime: string;
  Merchant: TMerchant;
  LoadList: TStringList;
  boNewNpc: Boolean;
begin
  sFileName := g_Config.sEnvirDir + 'Merchant.txt';
  if not FileExists(sFileName) then
    Exit;
  UserEngine.m_MerchantList.Lock;
  try
    for i := 0 to UserEngine.m_MerchantList.Count - 1 do
    begin
      Merchant := TMerchant(UserEngine.m_MerchantList.Items[i]);
      if Merchant.m_boIsHide then
        Continue; //By Blue
      Merchant.m_nFlag := -1;
    end;
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do
    begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then
      begin
        sLineText := GetValidStr3(sLineText, sScript, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sMapName, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sX, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sY, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sCharName, [' ', #9]);
        if (sCharName <> '') and (sCharName[1] = '"') then
          ArrestStringEx(sCharName, '"', '"', sCharName);
        sLineText := GetValidStr3(sLineText, sFlag, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sAppr, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sCastle, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sCanMove, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sMoveTime, [' ', #9]);
        nX := Str_ToInt(sX, 0);
        nY := Str_ToInt(sY, 0);
        boNewNpc := True;
        for ii := 0 to UserEngine.m_MerchantList.Count - 1 do
        begin
          Merchant := TMerchant(UserEngine.m_MerchantList.Items[ii]);
          if Merchant.m_boIsHide then
            Continue; //By Blue
          if (Merchant.m_sMapName = sMapName) and (Merchant.m_nCurrX = nX) and (Merchant.m_nCurrY = nY) then
          begin
            boNewNpc := False;
            Merchant.m_sScript := sScript;
            Merchant.m_sCharName := sCharName;
            Merchant.m_sFCharName := FilterCharName(Merchant.m_sCharName);
            Merchant.m_nFlag := Str_ToInt(sFlag, 0);
            Merchant.m_btDirection := Merchant.m_nFlag;
            Merchant.m_wAppr := Str_ToInt(sAppr, 0);
            Merchant.m_dwMoveTime := Str_ToInt(sMoveTime, 0);
            if Str_ToInt(sCastle, 0) <> 1 then
              Merchant.m_boCastle := True
            else
              Merchant.m_boCastle := False;

            if (Str_ToInt(sCanMove, 0) <> 0) and (Merchant.m_dwMoveTime > 0) then
              Merchant.m_boCanMove := True;
            Break;
          end;
        end;
        if boNewNpc and not Merchant.m_boIsHide then
        begin //By Blue
          Merchant := TMerchant.Create;
          Merchant.m_sMapName := sMapName;
          Merchant.m_PEnvir := g_MapManager.FindMap(Merchant.m_sMapName);
          if Merchant.m_PEnvir <> nil then
          begin
            Merchant.m_sScript := sScript;
            Merchant.m_nCurrX := nX;
            Merchant.m_nCurrY := nY;
            Merchant.m_sCharName := sCharName;
            Merchant.m_sFCharName := FilterCharName(Merchant.m_sCharName);
            Merchant.m_nFlag := Str_ToInt(sFlag, 0);
            Merchant.m_btDirection := Merchant.m_nFlag;
            Merchant.m_wAppr := Str_ToInt(sAppr, 0);
            Merchant.m_dwMoveTime := Str_ToInt(sMoveTime, 0);
            if Str_ToInt(sCastle, 0) <> 1 then
              Merchant.m_boCastle := True
            else
              Merchant.m_boCastle := False;
            if (Str_ToInt(sCanMove, 0) <> 0) and (Merchant.m_dwMoveTime > 0) then
              Merchant.m_boCanMove := True;
            Merchant.OnEnvirnomentChanged();
            UserEngine.m_MerchantList.Add(Merchant);
            Merchant.Initialize;
          end
          else
            Merchant.Free;
        end;
      end;
    end;
    LoadList.Free;
    for i := UserEngine.m_MerchantList.Count - 1 downto 0 do
    begin
      Merchant := TMerchant(UserEngine.m_MerchantList.Items[i]);
      if Merchant.m_boIsHide then
        Continue;
      if Merchant.m_nFlag = -1 then
      begin
        Merchant.m_boGhost := True;
        Merchant.m_dwGhostTick := GetTickCount();
        //UserEngine.MerchantList.Delete(I);
      end;
    end;
  finally
    UserEngine.m_MerchantList.UnLock;
  end;
end;

function TFrmDB.LoadUpgradeWeaponRecord(sNPCName: string; DataList: TList): Integer;
var
  i: Integer;
  FileHandle: Integer;
  sFileName: string;
  UpgradeInfo: pTUpgradeInfo;
  UpgradeRecord: TUpgradeInfo;
  nRecordCount: Integer;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Upg\' + sNPCName + '.upg';
  if FileExists(sFileName) then
  begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then
    begin
      FileRead(FileHandle, nRecordCount, SizeOf(Integer));

      for i := 0 to nRecordCount - 1 do
      begin
        if FileRead(FileHandle, UpgradeRecord, SizeOf(TUpgradeInfo)) = SizeOf(TUpgradeInfo) then
        begin
          New(UpgradeInfo);
          UpgradeInfo^ := UpgradeRecord;
          UpgradeInfo.dwGetBackTick := 0;
          DataList.Add(UpgradeInfo);
        end;
      end;
      FileClose(FileHandle);
      Result := 1;
    end;
  end;
end;

function TFrmDB.SaveUpgradeWeaponRecord(sNPCName: string; DataList: TList): Integer;
var
  i: Integer;
  FileHandle: Integer;
  sFileName: string;
  UpgradeInfo: pTUpgradeInfo;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Upg\' + sNPCName + '.upg';
  if FileExists(sFileName) then
    FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone)
  else
    FileHandle := FileCreate(sFileName);
  if FileHandle > 0 then
  begin
    FileWrite(FileHandle, DataList.Count, SizeOf(Integer));
    for i := 0 to DataList.Count - 1 do
    begin
      UpgradeInfo := DataList.Items[i];
      FileWrite(FileHandle, UpgradeInfo^, SizeOf(TUpgradeInfo));
    end;
    FileClose(FileHandle);
    Result := 1;
  end;
end;

function TFrmDB.LoadGoodRecord(NPC: TMerchant; sFile: string): Integer;
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  UserItem: pTUserItem;
  List: TList;
  Header420: TGoodFileHeader;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Saved\' + sFile + '.sav';
  if FileExists(sFileName) then
  begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    List := nil;
    if FileHandle > 0 then
    begin
      if FileRead(FileHandle, Header420, SizeOf(TGoodFileHeader)) = SizeOf(TGoodFileHeader) then
      begin
        for i := 0 to Header420.nItemCount - 1 do
        begin
          New(UserItem);
          if FileRead(FileHandle, UserItem^, SizeOf(TUserItem)) = SizeOf(TUserItem) then
          begin
            if List = nil then
            begin
              List := TList.Create;
              List.Add(UserItem)
            end
            else
            begin
              if pTUserItem(List.Items[0]).wIndex = UserItem.wIndex then
              begin
                List.Add(UserItem);
              end
              else
              begin
                NPC.m_GoodsList.Add(List);
                List := TList.Create;
                List.Add(UserItem);
              end;
            end;
          end;
        end;
        if List <> nil then
          NPC.m_GoodsList.Add(List);
        FileClose(FileHandle);
        Result := 1;
      end;
    end;
  end;
end;

function TFrmDB.LoadGoodPriceRecord(NPC: TMerchant; sFile: string): Integer;
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  ItemPrice: pTItemPrice;
  Header420: TGoodFileHeader;
begin
  Result := -1;
  sFileName := '.\Envir\Market_Prices\' + sFile + '.prc';
  if FileExists(sFileName) then
  begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then
    begin
      if FileRead(FileHandle, Header420, SizeOf(TGoodFileHeader)) = SizeOf(TGoodFileHeader) then
      begin
        for i := 0 to Header420.nItemCount - 1 do
        begin
          New(ItemPrice);
          if FileRead(FileHandle, ItemPrice^, SizeOf(TItemPrice)) = SizeOf(TItemPrice) then
            NPC.m_ItemPriceList.Add(ItemPrice)
          else
          begin
            Dispose(ItemPrice);
            Break;
          end;
        end;
      end;
      FileClose(FileHandle);
      Result := 1;
    end;
  end;
end;

{function DecodeString(sSrc: string): string;
var
  Dest                      : array[0..1024] of Char;
  nDest                     : Integer;
begin
  if sSrc = '' then
    Exit;
  if (nDeCryptString >= 0) and Assigned(PlugProcArray[nDeCryptString].nProcAddr) then begin
    FillChar(Dest, SizeOf(Dest), #0);
    TDeCryptString(PlugProcArray[nDeCryptString].nProcAddr)(@sSrc[1], @Dest, Length(sSrc), nDest);
    Result := StrPas(PChar(@Dest));
    Exit;
  end;
  Result := sSrc;
end;}

(*procedure TFrmDB.DeCodeStringList(StringList: TStringList);
var
  i, nDest                  : Integer;
  sLine                     : string;
  Dest                      : array[0..1024] of Char;
begin
{$I '..\Common\Macros\VMPB.inc'}
  if StringList.Count > 0 then begin
    sLine := StringList.Strings[0];
    if CompareLStr(sLine, sENCYPTSCRIPTFLAG, Length(sENCYPTSCRIPTFLAG)) then begin
      for i := 0 to StringList.Count - 1 do begin
        sLine := StringList.Strings[i];
        if sLine = '' then Continue;
        if (nDeCryptString >= 0) and Assigned(PlugProcArray[nDeCryptString].nProcAddr) then begin
          FillChar(Dest, SizeOf(Dest), #0);
          TDeCryptString(PlugProcArray[nDeCryptString].nProcAddr)(@sLine[1], @Dest, Length(sLine), nDest);
          StringList.Strings[i] := StrPas(PChar(@Dest));
        end;
      end;
    end;
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;*)

constructor TFrmDB.Create();
begin
  CoInitialize(nil);
{$IF DBTYPE = BDE}
  Query := TQuery.Create(nil);
{$ELSE}
  Query := TADOQuery.Create(nil);
{$IFEND}
end;

destructor TFrmDB.Destroy;
begin
  Query.Free;
  CoUnInitialize;
  inherited;
end;

function TFrmDB.LoadPostSellRecord(NPC: TMerchant; sFile: string): Integer;
var
  i, nCount: Integer;
  sFileName: string;
  FileHandle: Integer;
  PostSell: pTPostSell;
begin
  Result := 0;
  if not NPC.m_boYBDeal then
    Exit;
  sFileName := g_Config.sUserDataDir + sFile + '.esi';
  if FileExists(sFileName) then
  begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then
    begin
      if FileRead(FileHandle, nCount, SizeOf(Integer)) = SizeOf(Integer) then
      begin
        for i := 0 to nCount - 1 do
        begin
          New(PostSell);
          if FileRead(FileHandle, PostSell^, SizeOf(TPostSell)) = SizeOf(TPostSell) then
            NPC.m_PostSellList.Add(PostSell)
          else
          begin
            Dispose(PostSell);
            Break;
          end;
        end;
      end;
      FileClose(FileHandle);
      Result := NPC.m_PostSellList.Count;
    end;
  end;
end;

function TFrmDB.SavePostSellRecord(NPC: TMerchant; sFile: string): Integer;
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  PostSell: pTPostSell;
begin
  Result := 0;
  if not NPC.m_boYBDeal then
    Exit;
  sFileName := g_Config.sUserDataDir + sFile + '.esi';
  if FileExists(sFileName + '.bak') then
    DeleteFile(sFileName + '.bak');
  RenameFile(sFileName, sFileName + '.bak');
  FileHandle := FileCreate(sFileName);
  if FileHandle > 0 then
  begin
    FileWrite(FileHandle, NPC.m_PostSellList.Count, SizeOf(Integer));
    for i := 0 to NPC.m_PostSellList.Count - 1 do
    begin
      PostSell := pTPostSell(NPC.m_PostSellList.Items[i]);
      FileWrite(FileHandle, PostSell^, SizeOf(TPostSell));
      Inc(Result);
    end;
    FileClose(FileHandle);
  end;
end;

function TFrmDB.LoadPostGoldRecord(NPC: TMerchant; sFile: string): Integer;
var
  i, nCount: Integer;
  sFileName: string;
  FileHandle: Integer;
  PostGold: pTPostGold;
begin
  Result := 0;
  if not NPC.m_boYBDeal then
    Exit;
  sFileName := g_Config.sUserDataDir + sFile + '.esg';
  if FileExists(sFileName) then
  begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then
    begin
      if FileRead(FileHandle, nCount, SizeOf(Integer)) = SizeOf(Integer) then
      begin
        for i := 0 to nCount - 1 do
        begin
          New(PostGold);
          if FileRead(FileHandle, PostGold^, SizeOf(TPostGold)) = SizeOf(TPostGold) then
            NPC.m_PostGoldList.Add(PostGold)
          else
          begin
            Dispose(PostGold);
            Break;
          end;
        end;
      end;
      FileClose(FileHandle);
      Result := NPC.m_PostGoldList.Count;
    end;
  end;
end;

function TFrmDB.SavePostGoldRecord(NPC: TMerchant; sFile: string): Integer;
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  PostGold: pTPostGold;
begin
  Result := 0;
  if not NPC.m_boYBDeal then
    Exit;
  sFileName := g_Config.sUserDataDir + sFile + '.esg';
  if FileExists(sFileName + '.bak') then
    DeleteFile(sFileName + '.bak');
  RenameFile(sFileName, sFileName + '.bak');
  FileHandle := FileCreate(sFileName);
  if FileHandle > 0 then
  begin
    FileWrite(FileHandle, NPC.m_PostGoldList.Count, SizeOf(Integer));
    for i := 0 to NPC.m_PostGoldList.Count - 1 do
    begin
      PostGold := pTPostGold(NPC.m_PostGoldList.Items[i]);
      FileWrite(FileHandle, PostGold^, SizeOf(TPostGold));
      Inc(Result);
    end;
    FileClose(FileHandle);
  end;
end;

function TFrmDB.LoadSellOffRecord(NPC: TMerchant; sFile: string): Integer;
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  SellOff: pSellOff;
  Count: Integer;
  List: TList;
begin
  Result := -1;
  sFileName := g_Config.sEnvirDir + 'Market_SellOff\' + sFile + '.sell';
  if FileExists(sFileName) then
  begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then
    begin
      if FileRead(FileHandle, Count, SizeOf(Integer)) = SizeOf(Integer) then
      begin
        List := nil;
        for i := 0 to Count - 1 do
        begin
          New(SellOff);
          if FileRead(FileHandle, SellOff^, SizeOf(TSellOff)) = SizeOf(TSellOff) then
          begin
            if List = nil then
            begin
              List := TList.Create;
              List.Add(SellOff)
            end
            else
            begin
              if pSellOff(List.Items[0])^.item.wIndex = SellOff.item.wIndex then
              begin
                List.Add(SellOff);
              end
              else
              begin
                NPC.m_SellOffList.Add(List);
                List := TList.Create;
                List.Add(SellOff);
              end;
            end;
          end
          else
          begin
            Dispose(SellOff);
            Break;
          end;
        end;
        if List <> nil then
          NPC.m_SellOffList.Add(List);
      end;
      FileClose(FileHandle);
      Result := 1;
    end;
  end;
end;

function TFrmDB.SaveSellOffRecord(NPC: TMerchant; sFile: string): Integer;
var
  i, ii: Integer;
  sFileName: string;
  FileHandle: Integer;
  SellOff: pSellOff;
  nCount: Integer;
  List: TList;
begin
  Result := -1;
  sFileName := '.\Envir\Market_SellOff\' + sFile + '.sell';
  if NPC.m_SellOffList = nil then
    Exit;
  if FileExists(sFileName) then
    FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone)
  else
    FileHandle := FileCreate(sFileName);
  if FileHandle > 0 then
  begin
    nCount := 0;
    for i := 0 to NPC.m_SellOffList.Count - 1 do
      nCount := nCount + TList(NPC.m_SellOffList[i]).Count;
    FileWrite(FileHandle, nCount, SizeOf(Integer));
    for i := 0 to NPC.m_SellOffList.Count - 1 do
    begin
      List := TList(NPC.m_SellOffList[i]);
      for ii := 0 to List.Count - 1 do
      begin
        SellOff := pSellOff(List[ii]);
        FileWrite(FileHandle, SellOff^, SizeOf(TSellOff));
      end;
    end;
    FileClose(FileHandle);
    Result := 1;
  end;
end;

function TFrmDB.LoadSellGoldRecord(NPC: TMerchant; sFile: string): Integer;
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  SellOff: pSellOff;
  Count: Integer;
begin
  Result := -1;
  sFileName := '.\Envir\Market_SellOff\' + sFile + '.gold';
  if FileExists(sFileName) then
  begin
    FileHandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
    if FileHandle > 0 then
    begin
      if FileRead(FileHandle, Count, 4) = 4 then
      begin
        for i := 0 to Count - 1 do
        begin
          New(SellOff);
          if FileRead(FileHandle, SellOff^, SizeOf(TSellOff)) = SizeOf(TSellOff) then
          begin
            NPC.m_SellgoldList.Add(SellOff);
          end
          else
          begin
            Dispose(SellOff);
            Break;
          end;
        end;
      end;
      FileClose(FileHandle);
      Result := 1;
    end;
  end;
end;

function TFrmDB.SaveSellGoldRecord(NPC: TMerchant; sFile: string): Integer;
var
  i: Integer;
  sFileName: string;
  FileHandle: Integer;
  SellOff: pSellOff;
  Count: Integer;
begin
  Result := -1;
  sFileName := '.\Envir\Market_SellOff\' + sFile + '.gold';
  if NPC.m_SellOffList = nil then
    Exit;
  if FileExists(sFileName) then
    FileHandle := FileOpen(sFileName, fmOpenWrite or fmShareDenyNone)
  else
    FileHandle := FileCreate(sFileName);
  if FileHandle > 0 then
  begin
    Count := NPC.m_SellgoldList.Count;
    FileWrite(FileHandle, Count, 4);
    for i := 0 to Count - 1 do
    begin
      SellOff := pSellOff(NPC.m_SellgoldList[i]);
      FileWrite(FileHandle, SellOff^, SizeOf(TSellOff));
    end;
    FileClose(FileHandle);
    Result := 1;
  end;
end;

{procedure TFrmDB.LoadGT(Number, ListNumber: Integer);
var
  GT                        : TTerritory;
  sSQLString                : string;
  nerror                    : Integer;
begin
  nerror := 0;
  sSQLString := 'SELECT * FROM TBL_GTList WHERE(TerritoryNumber=' + IntToStr(Number) + ')';
  UseSQL();
  Query.SQL.Clear;
  Query.SQL.Add(sSQLString);
  try
    Query.Open;
  except
  end;
  GT := g_GuildTerritory.GTList[ListNumber];
  try
    if Query.RecordCount = 1 then begin //if theres a record
      GT.TerritoryNumber := Number;
      GT.GuildName := Query.FieldByName('FLD_GuildName').AsString;
      GT.RegDate := UnixToDateTime(StrToInt(Query.FieldByName('FLD_RegDate').AsString));
      GT.RegEnd := UnixToDateTime(StrToInt(Query.FieldByName('FLD_RegEnd').AsString));
      if GetBoolean(Query, 'FLD_ForSale') then
        GT.ForSale := True
      else
        GT.ForSale := False;
      GT.ForSaleEnd := UnixToDateTime(StrToInt(Query.FieldByName('FLD_ForSaleEnd').AsString));
      GT.ForSaleGold := StrToInt(Query.FieldByName('FLD_ForSaleGold').AsString);
      GT.BuyerGName := Query.FieldByName('FLD_Buyer').AsString;
      Query.Close;
    end else begin
      Query.Close;
      GT.TerritoryNumber := Number;
      GT.GuildName := '';
      GT.RegDate := Now();
      GT.RegEnd := Now();
      GT.ForSale := True;
      GT.ForSaleEnd := Now();
      GT.ForSaleGold := 10000000;
      GT.BuyerGName := '';
      SetupGT(GT);
    end;
  except
    if nerror = 0 then nerror := 2;
  end;
  if nerror <> 0 then Exit;             //technicaly should add error report here
  LoadGTDecorations(GT);
end;}

{procedure TFrmDB.LoadGTDecorations(GT: TTerritory);
var
  sSQLString                : string;
  nerror, i, ii             : Integer;
  Decoration                : pTGTDecoration;
  MapItem                   : pTMapItem;
  UserItem                  : pTUserItem;
  LastMapName               : string;
  Envir                     : TEnvirnoment;
begin
  nerror := 0;
  sSQLString := 'SELECT * FROM TBL_GTObjects WHERE(TerritoryNumber=' + IntToStr(GT.TerritoryNumber) + ') ORDER BY FLD_MapName';
  //UseSQL();
  Query.SQL.Clear;
  Query.SQL.Add(sSQLString);
  try
    Query.Open;
  except
  end;
  LastMapName := '';
  try
    for i := 0 to Query.RecordCount - 1 do begin
      New(Decoration);
      Decoration.appr := Query.FieldByName('FLD_Appr').AsInteger;
      Decoration.x := StrToInt(Query.FieldByName('FLD_X').AsString);
      Decoration.y := StrToInt(Query.FieldByName('FLD_Y').AsString);
      Decoration.starttime := StrToInt(Query.FieldByName('FLD_StartTime').AsString);
      if LastMapName <> Query.FieldByName('FLD_MapName').AsString then begin
        for ii := 0 to g_MapManager.Count - 1 do begin
          Envir := g_MapManager.Items[ii];
          if (Envir.m_sMapName = Query.FieldByName('FLD_MapName').AsString) and (TTerritory(Envir.m_GuildTerritory).TerritoryNumber = GT.TerritoryNumber) then
            Break;
        end;
      end;
      Decoration.Map := Envir;
      //first we make our new useritem
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(g_Config.sGTDeco, UserItem) = False then begin
        if nerror = 0 then nerror := 1;
        Continue;
      end;
      UserItem.MakeIndex := GetItemNumberEx();
      UserItem.btValue[0] := GT.TerritoryNumber;
      UserItem.btValue[5] := LoByte(Decoration.appr);
      UserItem.btValue[6] := HiByte(Decoration.appr);
      UserItem.btValue[1] := LoByte(LoWord(Decoration.starttime));
      UserItem.btValue[2] := HiByte(LoWord(Decoration.starttime));
      UserItem.btValue[3] := LoByte(HiWord(Decoration.starttime));
      UserItem.btValue[4] := HiByte(HiWord(Decoration.starttime));
      //now make the actual mapitem (the one that goes onto the floor)
      New(MapItem);
      MapItem.UserItem := UserItem^;
      MapItem.looks := Decoration.appr + 10000;
      MapItem.Name := GetDecoName(Decoration.appr) + '[7]';
      MapItem.AniCount := 0;
      MapItem.Reserved := 0;
      MapItem.Count := 1;
      MapItem.OfBaseObject := nil;
      MapItem.dwCanPickUpTick := GetTickCount();
      MapItem.DropBaseObject := nil;
      if Envir.AddToMap(Decoration.x, Decoration.y, OS_ITEMOBJECT, TObject(MapItem)) = nil then begin
        Dispose(MapItem);
        if nerror = 0 then nerror := 3;
      end;
      GT.NewDecoration(@MapItem.UserItem, Decoration.x, Decoration.y, Envir, False);
      Dispose(UserItem);
      Query.Next;
    end;
  except
    if nerror = 0 then nerror := 2;
  end;
  Query.Close;
end;}

{procedure TFrmDB.SaveGT(GT: TTerritory);
var
  sSQLString                : string;
  nerror                    : Integer;
  sForSale                  : string;
begin
  nerror := 0;
  UseSQL();
  sForSale := 'FALSE';
  try
    if GT.ForSale then
      sForSale := 'TRUE';
    sSQLString := 'UPDATE TBL_GTList Set FLD_GuildName=''' + GT.GuildName + ''', ' +
      'FLD_RegDate=' + IntToStr(DateTimeToUnix(GT.RegDate)) + ', FLD_RegEnd=' + IntToStr(DateTimeToUnix(GT.RegEnd)) + ', ' +
      'FLD_ForSaleEnd=' + IntToStr(DateTimeToUnix(GT.ForSaleEnd)) + ', FLD_ForSaleGold=' + IntToStr(GT.ForSaleGold) + ', ' +
      'FLD_ForSale=' + sForSale + ', FLD_Buyer=''' + GT.BuyerGName + '''' +
      ' Where TerritoryNumber=' + IntToStr(GT.TerritoryNumber);
    QueryCommand.CommandText := sSQLString;
    QueryCommand.Execute;
  except
    if nerror <> 0 then nerror := 2;
  end;
end;}

{procedure TFrmDB.SetupGT(GT: TTerritory);
var
  sSQLString                : string;
  nerror                    : Integer;
begin
  nerror := 0;
  UseSQL();
  try
    sSQLString := 'INSERT INTO TBL_GTList (FLD_GuildName, FLD_RegDate, FLD_RegEnd, FLD_ForSaleEnd, FLD_ForSaleGold' +
      ',  FLD_ForSale, FLD_Buyer, TerritoryNumber) values (' +
      '''' + GT.GuildName + ''', ' + IntToStr(DateTimeToUnix(GT.RegDate)) + ',' + IntToStr(DateTimeToUnix(GT.RegEnd)) + ',' +
      IntToStr(DateTimeToUnix(GT.ForSaleEnd)) + ',' + IntToStr(GT.ForSaleGold) + ',TRUE, ''' + GT.BuyerGName + ''',' +
      IntToStr(GT.TerritoryNumber) + ')';
    QueryCommand.CommandText := sSQLString;
    QueryCommand.Execute;
  except
    if nerror <> 0 then nerror := 2;
  end;
end; }

{procedure TFrmDB.SaveDeco(looks, GTNumber: Byte; x, y: Integer; mapname: string; starttime: dword);
var
  sSQLString                : string;
  nerror                    : Integer;
begin
  nerror := 0;
  UseSQL();
  try
    sSQLString := 'INSERT INTO TBL_GTObjects (TerritoryNumber, FLD_Appr, FLD_x, FLD_Y, FLD_MapName, FLD_StartTime) values (' +
      IntToStr(GTNumber) + ',' + IntToStr(looks) + ',' + IntToStr(x) + ',' + IntToStr(y)
      + ',''' + mapname + ''',' + IntToStr(starttime) + ')';
    QueryCommand.CommandText := sSQLString;
    QueryCommand.Execute;
  except
    if nerror <> 0 then nerror := 2;
  end;
end;}

{procedure TFrmDB.DeleteDeco(GTNumber: Byte; x, y: Integer; mapname: string);
var
  sSQLString                : string;
  nerror                    : Integer;
begin
  nerror := 0;
  try
    sSQLString := 'Delete * FROM TBL_GTObjects WHERE('
      + '(TerritoryNumber=' + IntToStr(GTNumber) + ') AND (FLD_X=' + IntToStr(x) + ') AND (FLD_Y=' + IntToStr(y) + ') AND (FLD_MapName=''' + mapname + '''))';
    QueryCommand.CommandText := sSQLString;
    QueryCommand.Execute;
  except
    if nerror <> 0 then nerror := 2;
  end;
end;}

{function TFrmDB.LoadDecorationList(): Integer; //00488CDC
var
  i, n14                    : Integer;
  s18, s20, s24             : string;
  LoadList                  : TStringList;
  sFileName                 : string;
  Decoration                : pTDecoItem;
begin
  Result := -1;
  sFileName := g_Config.sEnvirDir + 'DecoItem.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    s24 := '';
    for i := 0 to LoadList.Count - 1 do begin
      s18 := Trim(LoadList.Strings[i]);
      if (s18 <> '') and (s18[1] <> ';') then begin
        New(Decoration);
        s18 := GetValidStr3(s18, s20, [' ', #9]);
        n14 := Str_ToInt(Trim(s20), 0);
        Decoration.appr := n14;
        s18 := GetValidStr3(s18, s20, [' ', #9]);
        Decoration.Name := s20;
        s18 := GetValidStr3(s18, s20, [' ', #9]);
        n14 := Str_ToInt(Trim(s20), 0);
        Decoration.Location := n14;
        n14 := Str_ToInt(Trim(s18), 0);
        Decoration.Price := n14;
        g_DecorationList.Add(Decoration);
      end;
    end;                                // for
    LoadList.Free;
    Result := 1;
  end;
end;}

initialization
  nDeCryptString := AddToPulgProcTable('DeCryptString');
finalization

end.
