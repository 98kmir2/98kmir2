unit LShare;

interface

uses
  Classes, IniFiles, SysUtils, Grobal2;

const
  COMP1024 = False;
  g_LoginTool_Exe = 'LoginTool.exe';
  g_LoginTool_Bin = 'LoginTool.bin';

type
  TUpgradeStep = (uGetUpgrade, uDownLoadUpgrade, uNoNewSoft, uOver);
  TDownSoft = record
    sFileName: string;
    sDownSite: string;
  end;
  pTDownSoft = ^TDownSoft;

  TGameZone = record
    sGameName: string;
    sServerName: string;
    sGameIPaddr: string;
    sGameDomain: string;
    sLoginKey: string;
    nGameIPPort: Integer;
    //nClientVersion: Integer;
    boOpened: Boolean;
    boIsOnServer: Boolean;

    szFireWallAddress: string;
    nFireWallPort: Integer;
    nFireWallMode: Integer;
    nFireWallKey: Integer;
  end;
  pTGameZone = ^TGameZone;

  //TShortStr = string[255];
  //PTShortStr = ^TShortStr;

var
  g_pRcHeader: pTRcHeader = nil;
  g_bLoginKey: PBoolean;
  g_sSiteUrl: PString = nil;
  g_sWebUrl: PString = nil;
  g_boQueryDynCode: Boolean = False;
  g_boWebBrowserShow: Boolean = False;
  g_dwWebBrowserShow: LongWord;
  g_sUpgList: TStringList;
  g_GameList: TStringList;
  g_DriversList: TStringList;
  g_boRestart: Boolean = False;
  g_ftpIni: TIniFile;
  g_mirIni: TIniFile;
  g_sIniFtpFile: string = '.\Ftp.ini';
  g_sIniMirFile: string = '.\lscfg.ini';
  g_sRegKeyName: string = 'Software\MicroSoft\Windows\CurrentVersion\Explorer';
  g_sMakeNewAccount: string;
  g_sDownLoadUrl: string;
  g_sSecFileName: string;
  g_btCode: byte = 1;
  g_nServerListCount: Integer;
  g_SelGameZone: pTGameZone = nil;
  g_boClose: Boolean = True;
  g_boServerStatus: Boolean = False;
  g_boMakeGroup: Boolean = True;
  g_boFMakeOnDesktop: Boolean = True;
  g_boFMakeOnStarTMenu: Boolean = True;
  g_boAlphaBlendValue: Boolean = False;
  g_boSearchDir: Boolean = False;
  g_boGameUpgrade: Boolean;
  g_boCheck: Boolean;
  g_boSecCheck: Boolean;
  g_boSecFinded: Boolean;
  g_dwStartGameTick: LongWord;
  g_dwStartGameTick1: LongWord;
  g_UpgradeStep: TUpgradeStep = uOver;
  g_sOldWorkDir: string;
  g_sWorkDir: string = '';
  g_sLoginTool: string;
  g_sLoginTool_Bin: string;

procedure UnLoadGameConf();
//procedure LoadServerGameList(LoadList: TStringList {var lStream: TStream});
function ExtractRes(ResType, ResName, ResNewName: string): Boolean;

implementation

uses HUtil32, EDcode {, __DESUnit};

function ExtractRes(ResType, ResName, ResNewName: string): Boolean;
var
  Res: TResourceStream;
  boChanged: Boolean;
  attr: Integer;
begin
{$I '..\Common\Macros\VMPB.inc'}
  try
    Res := TResourceStream.Create(Hinstance, ResName, PChar(ResType));
    if Res = nil then begin
      Result := False;
      Exit;
    end;
    if FileExists(ResNewName) then begin
      boChanged := False;
      attr := FileGetAttr(ResNewName);
      if attr and faReadOnly = faReadOnly then begin
        attr := attr xor faReadOnly;
        boChanged := True;
      end;
      if attr and faSysFile = faSysFile then begin
        attr := attr xor faSysFile;
        boChanged := True;
      end;
      if attr and faHidden = faHidden then begin
        attr := attr xor faHidden;
        boChanged := True;
      end;
      if boChanged then
        FileSetAttr(ResNewName, attr);
    end;
    Res.SavetoFile(ResNewName);
    Result := True;
    Res.Free;
  except
    Result := False;
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;

procedure UnLoadGameConf();
var
  i: Integer;
  GameZone: pTGameZone;
begin
  for i := 0 to g_GameList.Count - 1 do begin
    GameZone := pTGameZone(g_GameList.Objects[i]);
    Dispose(GameZone);
  end;
  g_GameList.Clear;
end;

(*procedure LoadServerGameList(LoadList: TStringList {var lStream: TStream});
var
  i                         : Integer;
  //LoadList                  : TStringList;
  GameZone                  : pTGameZone;
  sContType, sLineText,
    sGameName, sServerName,
    sGameAddr, sGamePort,
    sLoginKey, sClientVer   : string;
  nGamePort, nClientVer     : Integer;
begin
  for i := 0 to LoadList.Count - 1 do begin
    sLineText := Trim(LoadList.Strings[i]);
    if (sLineText <> '') and (sLineText[1] <> ';') then begin
      sLineText := GetValidStr3(sLineText, sContType, [' ', #9, '|']);
      sLineText := GetValidStr3(sLineText, sGameName, [' ', #9, '|']);
      sLineText := GetValidStr3(sLineText, sServerName, [' ', #9, '|']);
      sLineText := GetValidStr3(sLineText, sGameAddr, [' ', #9, '|']);
      sLineText := GetValidStr3(sLineText, sGamePort, [' ', #9, '|']);
      sLineText := GetValidStr3(sLineText, sLoginKey, [' ', #9, '|']);
      sLineText := GetValidStr3(sLineText, sClientVer, [' ', #9, '|']);
      nClientVer := Str_ToInt(sClientVer, 0);
      nGamePort := Str_ToInt(sGamePort, -1);
      if (sGameName <> '') and ((nGamePort > 0) and (nGamePort <= 65535)) then begin
        New(GameZone);
        GameZone.sGameName := sGameName;
        GameZone.sServerName := sServerName;
        GameZone.nGameIPPort := nGamePort;
        if IsIpAddr(sGameAddr) then begin
          GameZone.sGameIPaddr := sGameAddr;
          GameZone.sGameDomain := '';
        end else begin
          GameZone.sGameIPaddr := '';
          GameZone.sGameDomain := sGameAddr;
        end;
        GameZone.boOpened := False;
        GameZone.nClientVersion := nClientVer;
        GameZone.sLoginKey := '';       //__En__(sLoginKey, g_pRcHeader.sWebSite);
        GameZone.boIsOnServer := True;
        g_GameList.AddObject(sContType, TObject(GameZone));
      end;
    end;
  end;
end; *)

initialization
  //g_GameListStream := TMemoryStream.Create();
{$I '..\Common\Macros\VMPBM.inc'}
  g_sUpgList := TStringList.Create;
  g_GameList := TStringList.Create;
  g_ftpIni := TIniFile.Create(g_sIniFtpFile);
  g_mirIni := TIniFile.Create(g_sIniMirFile);
  g_DriversList := TStringList.Create;
  New(g_pRcHeader);
  New(g_bLoginKey);
  g_sSiteUrl := NewStr('111');
  g_sWebUrl := NewStr('222');
{$I '..\Common\Macros\VMPE.inc'}

finalization
  g_sUpgList.Free;
  //g_GameList.Free;
  //g_GameListStream.Free;
  g_ftpIni.Free;
  g_mirIni.Free;
  g_DriversList.Free;

end.
