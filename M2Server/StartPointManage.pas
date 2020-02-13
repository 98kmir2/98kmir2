unit StartPointManage;

interface

uses
  Classes, Windows, SysUtils, Envir, Event, MudUtil;

type
  TStartPointManager = class
  public
    m_InfoList: TList;
    constructor Create();
    destructor Destroy; override;
    function Initialize(var s: string): Boolean;
    procedure CreateAureole();
  end;

implementation

uses M2Share, HUtil32, Grobal2,StrUtils;

constructor TStartPointManager.Create;
begin
  m_InfoList := TList.Create;
end;

destructor TStartPointManager.Destroy;
var
  i: Integer;
begin
  for i := 0 to m_InfoList.Count - 1 do
    Dispose(pTStartPointInfo(m_InfoList.Items[i]));
  m_InfoList.Free;
  inherited;
end;

function TStartPointManager.Initialize(var s: string): Boolean;
var
  I: Integer;
  sFileName, tStr, sMAP, sX, sY, sQuiz, sSize, sType, sPKZone, sPKFire: string;
  nSize: Integer;
  LoadList: TStringList;
  StartPointInfo: pTStartPointInfo;
  Envir: TEnvirnoment;
  sExistsComboKeys: String;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'StartPoint.txt';
  if not FileExists(sFileName) then Exit;

  for I := 0 to m_InfoList.Count - 1 do
  begin
    Dispose(pTStartPointInfo(m_InfoList.Items[i]));
  end;
  m_InfoList.Clear;


  LoadList := TStringList.Create;
  try
    LoadList.LoadFromFile(sFileName);
    sExistsComboKeys := '';
    for I := 0 to LoadList.Count - 1 do
    begin
      tStr := Trim(LoadList.Strings[I]);
      if (tStr <> '') and (tStr[1] <> ';') then
      begin
        tStr := GetValidStr3(tStr, sMAP, [' ', #9]);
        tStr := GetValidStr3(tStr, sX, [' ', #9]);
        tStr := GetValidStr3(tStr, sY, [' ', #9]);
        tStr := GetValidStr3(tStr, sQuiz, [' ', #9]);
        tStr := GetValidStr3(tStr, sSize, [' ', #9]);
        tStr := GetValidStr3(tStr, sType, [' ', #9]);
        tStr := GetValidStr3(tStr, sPKZone, [' ', #9]);
        tStr := GetValidStr3(tStr, sPKFire, [' ', #9]);
        try
          if (StrToInt(sSize) >= CUSTOM_SAFEZONE_CONTROLSTART_INX) and (StrToInt(sSize) <= CUSTOM_SAFEZONE_CONTROLEND_INX) then
          begin
            if Pos('[' + sMAP + ',' + sSize + '];',sExistsComboKeys) > 0 then
            begin
              MainOutMessageAPI('错误信息:在相同地图中不允许出现重复自定义异形安全区代码,本次将不加载该重复安全区数据...');
              Continue;
            end
            else
            begin
              sExistsComboKeys := sExistsComboKeys + '[' + sMAP + ',' + sSize + '];';
            end;
          end;

          if (sMAP <> '') and (sX <> '') and (sY <> '') then
          begin
            Envir := g_MapManager.FindMap(sMAP);
            if Envir = nil then Continue;
            New(StartPointInfo);
            StartPointInfo.Envir := Envir;
            StartPointInfo.sMapName := sMAP;
            StartPointInfo.nX := Str_ToInt(sX, 0);
            StartPointInfo.nY := Str_ToInt(sY, 0);
            StartPointInfo.boQUIZ := Str_ToInt(sQuiz, 0) = 1;
            nSize := Str_ToInt(sSize, 0);

            if nSize <= 0 then nSize := g_Config.nSafeZoneSize;

            StartPointInfo.nSize := nSize;
            StartPointInfo.nType := Str_ToInt(sType, 0);
            StartPointInfo.boPKZone := Str_ToInt(sPKZone, 0) = 1;
            StartPointInfo.boPKFire := Str_ToInt(sPKFire, 0) = 1;
            StartPointInfo.dwCrTick := GetTickCount();
            m_InfoList.Add(StartPointInfo);
            Result := True;
          end;
        except
          MainOutMessageAPI(format('startpoint.txt配置错误，行数：%d，内容：%s', [I + 1, LoadList.Strings[I]]));
        end
      end;
    end;
  finally
    LoadList.Free;
  end;
end;

procedure TStartPointManager.CreateAureole();
var
  I, J, nCount, Index, nCoordinate, nX, nY: Integer;
  StartPointInfo: pTStartPointInfo;
  AureoleEvent: TSafeZoneAureoleEvent;
  nStartX, nStartY, nEndX, nEndY: Integer;
  SL: TStringList;
  ps : array of TPoint;
  Rgn: HRGN;
  P: pTStartPointRegion;
  sTemp, sFileName: string;
begin
  SL := TStringList.create;
  try
    for I := 0 to m_InfoList.Count - 1 do
    begin
      StartPointInfo := m_InfoList.Items[I];
      nStartX := StartPointInfo.nX - StartPointInfo.nSize;
      nEndX := StartPointInfo.nX + StartPointInfo.nSize;
      nStartY := StartPointInfo.nY - StartPointInfo.nSize;
      nEndY := StartPointInfo.nY + StartPointInfo.nSize;

      if (StartPointInfo^.nSize >= CUSTOM_SAFEZONE_CONTROLSTART_INX) and (StartPointInfo^.nSize <= CUSTOM_SAFEZONE_CONTROLEND_INX) then
      begin
        sFileName := g_Config.sEnvirDir + 'StartPointExDir\' + IntToStr(StartPointInfo^.nSize) + '.txt';
        if not FileExists(sFileName) then Continue;
        SL.LoadFromFile(sFileName);

        SetLength(ps, SL.Count);
        nCount := 0;

        for J := 0 to SL.Count - 1 do
        begin
          sTemp := SL.Strings[J];
          Index := Pos(',', sTemp);
          if (Index > 0) then
          begin
            nX := StrToIntDef(Copy(sTemp, 1, Index - 1), -1);
            nY := StrToIntDef(Copy(sTemp, Index + 1, MaxInt), -1);
            if (nX >= 0) and (nY >= 0) then
            begin
              ps[nCount] := Point(nX, nY);
              AureoleEvent := TSafeZoneAureoleEvent.Create(StartPointInfo.Envir, nX, nY, StartPointInfo.nType);
              if not AureoleEvent.m_boAddToMap then
              begin
                AureoleEvent.Free;
              end;
              Inc(nCount);
            end;
          end;
        end;

        New(P);
        p^.nSizeCode := StartPointInfo^.nSize;
        p^.rgn := CreatePolygonRgn(ps[0], Length(ps), ALTERNATE);
        g_StartPointRegionList_Server.add(p);
      end
      else
      begin
        for nCoordinate := nStartX to nEndX do
        begin
          AureoleEvent := TSafeZoneAureoleEvent.Create(StartPointInfo.Envir, nCoordinate, nStartY, StartPointInfo.nType);
          if not AureoleEvent.m_boAddToMap then
          begin
            AureoleEvent.Free;
          end;

          AureoleEvent := TSafeZoneAureoleEvent.Create(StartPointInfo.Envir, nCoordinate, nEndY, StartPointInfo.nType);
          if not AureoleEvent.m_boAddToMap then
          begin
            AureoleEvent.Free;
          end;
        end;
        for nCoordinate := nStartY to nEndY do
        begin
          AureoleEvent := TSafeZoneAureoleEvent.Create(StartPointInfo.Envir, nStartX, nCoordinate, StartPointInfo.nType);
          if not AureoleEvent.m_boAddToMap then
          begin
            AureoleEvent.Free;
          end;

          AureoleEvent := TSafeZoneAureoleEvent.Create(StartPointInfo.Envir, nEndX, nCoordinate, StartPointInfo.nType);
          if not AureoleEvent.m_boAddToMap then
          begin
            AureoleEvent.Free;
          end;
        end;
      end;
    end;
  finally
    SL.Free;
  end;
end;

end.
