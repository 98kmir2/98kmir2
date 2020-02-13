unit SoundUtil;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DirectX, DXClass, Grobal2, ExtCtrls, HUtil32, EDcode, CnHashTable,
  HumanActor, Actor, DXSounds;

var
  CurVolume                 : Integer;

procedure LoadSoundList(flname: string);
procedure LoadBGMusicList(flname: string);
procedure PlaySound(idx: Integer; sx: Integer = -1; sy: Integer = -1); overload;
procedure PlaySound(s: string; sx: Integer = -1; sy: Integer = -1); overload;
procedure PlayActorWav(idx, sx, sy, Dx, Dy: Integer; lVolume: Integer = 100; bLooping: Boolean = False);
procedure PlaySoundName(s: string; sx: Integer = -1; sy: Integer = -1);
function PlayBGM(wavname: string): TDirectSoundBuffer;
procedure PlayMp3(wavname: string; boFlag: Boolean);
procedure ResumeMp3(wavname: string; boFlag: Boolean);
procedure SilenceSound;

procedure ItemClickSound(std: TClientStdItem);
procedure ItemUseSound(StdMode: Integer);

procedure PlayMapMusic(boFlag: Boolean);
procedure ResumeMapMusic(boFlag: Boolean);

type
  SoundInfo = record
    idx: Integer;
    Name: string;
  end;

  TDSoundStruct = packed record
    pszFileName: string[128];
    dwLaststTick: LongWord;
    pDirectSound: TDirectSoundBuffer;
  end;
  pTDSoundStruct = ^TDSoundStruct;

  TDXSoundManager = class(TCnHashTableSmall)
  private
    m_nPosition: Integer;
    m_dwCacheCheckTick: LongWord;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Run(dwCurTick: LongWord);
  end;

var
  g_DXSoundManager          : TDXSoundManager;

implementation

uses
  ClMain, MShare, DrawScrn;

procedure LoadSoundList(flname: string);
var
  i, k, idx, n              : Integer;
  strlist                   : TStringList;
  Str, data                 : string;
begin
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    idx := 0;
    for i := 0 to strlist.Count - 1 do begin
      Str := strlist[i];
      if Str <> '' then begin
        if Str[1] = ';' then Continue;
        Str := Trim(GetValidStr3(Str, data, [':', ' ', #9]));
        n := Str_ToInt(data, 0);
        if n > idx then begin
          for k := 0 to n - g_SoundList.Count - 1 do
            g_SoundList.Add('');
          //g_SoundList.Add(Str);

          g_SoundList.AddObject(Trim(Str), TObject(Integer(FileExists(Str)))); //123456
          idx := n;
        end;
      end;
    end;
    strlist.Free;
  end;
end;

constructor TDXSoundManager.Create;
begin
  inherited Create(0);
  m_nPosition := 0;
  m_dwCacheCheckTick := GetTickCount();
end;

destructor TDXSoundManager.Destroy;
var
  i, ii                     : Integer;
  pfi                       : pTDSoundStruct;
  CnBucket                  : TCnBucket;
begin
  for i := Self.FBucketCount - 1 downto 0 do begin
    CnBucket := Self.Buckets[i];
    for ii := 0 to CnBucket.Count - 1 do begin
      pfi := pTDSoundStruct(CnBucket.Objects[ii]);
      FreeAndNil(pfi.pDirectSound);
      Dispose(pfi);
    end;
  end;
  inherited Destroy;
end;

procedure TDXSoundManager.Run(dwCurTick: LongWord);
var
  key, st                   : string;
  i, ii, c, L, n, M         : Integer;
  dwTime, dwRunTick         : LongWord;
  pfi                       : pTDSoundStruct;
  boProcessLimit            : Boolean;
begin
  if dwCurTick - m_dwCacheCheckTick > 10 * 1000 then begin
    m_dwCacheCheckTick := dwCurTick;

    dwRunTick := GetTickCount();
    boProcessLimit := False;
    for i := Self.Count - 1 downto m_nPosition do begin
      key := Keys[i];
      pfi := pTDSoundStruct(Values[key]);
      if dwCurTick - pfi.dwLaststTick > 10 * 1000 then begin
        if (pfi.pDirectSound <> nil) and not pfi.pDirectSound.Playing then begin
          FreeAndNil(pfi.pDirectSound);
          Dispose(pfi);
          Delete(key);
        end;
      end;
      if GetTickCount - dwRunTick > 4 then begin
        boProcessLimit := True;
        m_nPosition := i;
        Break;
      end;
    end;
    if not boProcessLimit then
      m_nPosition := 0;
  end;
end;

function CalsDistanceX(Src, Chr: TPOINT): float;
var
  l_Result                  : float;
begin
  l_Result := (Chr.x - Src.x) / 100 * 13;
  l_Result := (1.0 - Sqrt(1.0 - l_Result / 12.0)) * (-1.0);
  Result := l_Result;
end;

function CalsDistanceY(Src, Chr: TPOINT): float;
var
  l_Result                  : float;
begin
  l_Result := (Chr.y - Src.y) / 100 * 13;
  l_Result := (1.0 - Sqrt(1.0 - l_Result / 12.0)) * (-1.0);
  Result := l_Result;
end;

const
  _PI                       = 3.1415927;

function CalsPan(Dir, Dis: Integer): Integer;
begin
  Result := Dir * Round(2000.0 * (Sin(_PI * (Dis / 26.0))));
end;

function CalsDistance(Src, Chr: TPOINT): Integer;
begin
  Result := Round(Sqrt(Sqr(Src.x - Chr.x) + Sqr(Src.y - Chr.y)));
  //Result := _MAX(abs(Src.x - Chr.x), abs(Src.y - Chr.y));
end;

function CalsDirection(Src, Chr: TPOINT): Integer;
begin
  Result := 0;
  if Src.x > Chr.x then
    Result := 1
  else if Src.x < Chr.x then
    Result := -1;
end;

function CalsVolume(Dis: Integer): Integer;
var
  l_Result                  : Integer;
begin
  if (Dis <> 0) then begin
    l_Result := Round((Cos(_PI * (Dis / 26.0))) * 100);
    l_Result := (101 - l_Result);
    l_Result := -((68 - g_lWavMaxVol) * 40) + l_Result * (-12);
    Result := l_Result;
  end else
    Result := -((68 - g_lWavMaxVol) * 40);
end;

procedure PlayActorWav(idx, sx, sy, Dx, Dy: Integer; lVolume: Integer; bLooping: Boolean);
var
  Mon, Chr                  : TPOINT;
  nv, Dis, Dir              : Integer;
begin
  if (g_Sound <> nil) and g_boSound then begin
    if (idx >= 0) and (idx < g_SoundList.Count) then begin
      if g_SoundList[idx] <> '' then begin
        Mon.x := sx;
        Mon.y := sy;
        Chr.x := Dx;
        Chr.y := Dy;
        Dis := CalsDistance(Mon, Chr);
        Dir := CalsDirection(Mon, Chr);
        //if lVolume = 100 then
        //  nv := 1
        //else
        //  nv := (100 - lVolume) div 5;
        lVolume := CalsVolume(Dis);
        //DScreen.AddChatBoardString(format('pan:%d vol:%d', [CalsPan(Dir, Dis), lVolume]), clWhite, clBlack);
        g_Sound.EffectFile(g_SoundList[idx], False, False, g_SoundList.Objects[idx] <> nil, CalsPan(Dir, Dis), lVolume);
      end;
    end;
  end;
end;

procedure PlaySound(idx: Integer; sx: Integer; sy: Integer);
var
  Mon, Chr                  : TPOINT;
  nv, Dis, Dir, lVolume     : Integer;
begin
  if (g_Sound <> nil) and g_boSound then begin
    if (idx >= 0) and (idx < g_SoundList.Count) then begin
      if g_SoundList[idx] <> '' then
        if (sx <> -1) and (g_MySelf <> nil) then begin
          Mon.x := sx;
          Mon.y := sy;
          Chr.x := g_MySelf.m_nCurrX;
          Chr.y := g_MySelf.m_nCurrY;
          Dis := CalsDistance(Mon, Chr);
          Dir := CalsDirection(Mon, Chr);
          //if lVolume = 100 then
          //  nv := 1
          //else
          //  nv := (100 - lVolume) div 5;
          lVolume := CalsVolume(Dis);
          //DScreen.AddChatBoardString(format('pan:%d vol:%d', [CalsPan(Dir, Dis), lVolume]), clWhite, clBlack);
          g_Sound.EffectFile(g_SoundList[idx], False, False, g_SoundList.Objects[idx] <> nil, CalsPan(Dir, Dis), lVolume);
        end else begin
          g_Sound.EffectFile(g_SoundList[idx], False, False, g_SoundList.Objects[idx] <> nil, 0, CalsVolume(0));
        end;
    end;
  end;
end;

procedure PlaySound(s: string; sx: Integer; sy: Integer);
begin
  PlaySoundName(s, sx, sy);
end;

procedure PlaySoundName(s: string; sx: Integer; sy: Integer);
var
  Mon, Chr                  : TPOINT;
  nv, Dis, Dir, lVolume     : Integer;
begin
  if (g_Sound <> nil) and g_boSound then begin
    if s <> '' then begin
      if (sx <> -1) and (g_MySelf <> nil) then begin
        Mon.x := sx;
        Mon.y := sy;
        Chr.x := g_MySelf.m_nCurrX;
        Chr.y := g_MySelf.m_nCurrY;
        Dis := CalsDistance(Mon, Chr);
        Dir := CalsDirection(Mon, Chr);
        //if lVolume = 100 then
        //  nv := 1
        //else
        //  nv := (100 - lVolume) div 5;
        lVolume := CalsVolume(Dis);
        //DScreen.AddChatBoardString(format('pan:%d vol:%d', [CalsPan(Dir, Dis), lVolume]), clWhite, clBlack);
        g_Sound.EffectFile(s, False, False, FileExists(s), CalsPan(Dir, Dis), lVolume);
      end else
        g_Sound.EffectFile(s, False, False, FileExists(s), 0, CalsVolume(0));
    end;
  end;
end;

procedure ResumeMapMusic(boFlag: Boolean);
var
  sFileName                 : string;
  nIndex                    : Integer;
begin
  if (g_nLastMapMusic < 0) or (not boFlag) then begin
    PlayMp3('', False);
    Exit;
  end;
  sFileName := '.\Music\' + IntToStr(g_nLastMapMusic) + '.mp3';
  ResumeMp3(sFileName, boFlag);
end;

procedure PlayMapMusic(boFlag: Boolean);
var
  i                         : Integer;
  pFileName                 : ^string;
  sFileName                 : string;
  nIndex                    : Integer;
begin
  if (g_nLastMapMusic < 0) or (not boFlag) then begin
    PlayMp3('', False);
    Exit;
  end;
  sFileName := '.\Music\' + IntToStr(g_nLastMapMusic) + '.mp3';
  PlayMp3(sFileName, boFlag);
end;

procedure LoadBGMusicList(flname: string);
var
  strlist                   : TStringList;
  Str, sMapName, sFileName  : string;
  pFileName                 : ^string;
  i                         : Integer;
begin
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      Str := strlist[i];
      if (Str = '') or (Str[1] = ';') then Continue;
      Str := GetValidStr3(Str, sMapName, [':', ' ', #9]);
      Str := GetValidStr3(Str, sFileName, [':', ' ', #9]);
      sMapName := Trim(sMapName);
      sFileName := Trim(sFileName);

      if (sMapName <> '') and (sFileName <> '') then begin
        New(pFileName);
        pFileName^ := sFileName;
        BGMusicList.AddObject(sMapName, TObject(pFileName));
      end;
    end;
    strlist.Free;
  end;
end;

function PlayBGM(wavname: string): TDirectSoundBuffer;
begin
  Result := nil;                        //Jacky
  //if not g_boBGSound or not g_boSound then Exit;
  if not g_gcGeneral[12] then Exit;
  if g_Sound <> nil then begin
    if wavname <> '' then
    {//if FileExists(wavname) then begin}try
      SilenceSound;
      g_Sound.EffectFile(wavname, True, False, FileExists(wavname), 0, CalsVolume(0));
    except
    end;
    //end;
  end;
end;

procedure PlayMp3(wavname: string; boFlag: Boolean);
begin
  if MP3 <> nil then begin
    if not boFlag then begin
      MP3.Stop;
      Exit;
    end;
    //if not g_boBGSound or not g_boSound then Exit;
    if not g_gcGeneral[12] then Exit;
    if wavname <> '' then begin
      if FileExists(wavname) then begin
        try
          MP3.Stop;
          MP3.Play(wavname);
        except
        end;
      end;
    end;
  end;
end;

procedure ResumeMp3(wavname: string; boFlag: Boolean);
begin
  if MP3 <> nil then begin
    if not boFlag then begin
      MP3.Stop;
      Exit;
    end;
    //if not g_boBGSound or not g_boSound then Exit;
    if not g_gcGeneral[12] then Exit;
    if wavname <> '' then begin
      if FileExists(wavname) then begin
        try
          //MP3.Pause;
          MP3.Resume();
        except
        end;
      end;
    end;
  end;
end;

procedure SilenceSound;
begin
  if g_Sound <> nil then
    g_Sound.Clear;
  PlayMapMusic(False);
end;

procedure ItemClickSound(std: TClientStdItem);
begin
  case std.StdMode of
    0: PlaySound(s_click_drug);
    31: if std.AniCount in [1..3] then PlaySound(s_click_drug) else PlaySound(s_itmclick);
    5, 6: PlaySound(s_click_weapon);
    10, 11: PlaySound(s_click_armor);
    22, 23: PlaySound(s_click_ring);
    24, 26: begin
        if (Pos('ÊÖïí', std.Name) > 0) or (Pos('ÊÖÌ×', std.Name) > 0) then
          PlaySound(s_click_grobes)
        else
          PlaySound(s_click_armring);
      end;
    19, 20, 21: PlaySound(s_click_necklace);
    15, 16: PlaySound(s_click_helmet);
  else
    PlaySound(s_itmclick);
  end;
end;

procedure ItemUseSound(StdMode: Integer);
begin
  case StdMode of
    0: PlaySound(s_click_drug);
    1, 2: PlaySound(s_eat_drug);
  else
    PlaySound(s_itmclick);
  end;
end;

end.

