program mir2;

uses
  Forms,
  Windows,
  SysUtils,
  Dialogs,
  ClMain in 'ClMain.pas' {frmMain},
  DrawScrn in 'DrawScrn.pas',
  IntroScn in 'IntroScn.pas',
  PlayScn in 'PlayScn.pas',
  MapUnit in 'MapUnit.pas',
  FState in 'FState.pas' {FrmDlg},
  ClFunc in 'ClFunc.pas',
  cliUtil in 'cliUtil.pas',
  DWinCtl in 'DWinCtl.pas',
  WIL in 'WIL.pas',
  magiceff in 'magiceff.pas',
  SoundUtil in 'SoundUtil.pas',
  Actor in 'Actor.pas',
  HerbActor in 'HerbActor.pas',
  AxeMon in 'AxeMon.pas',
  clEvent in 'clEvent.pas',
  MShare in 'MShare.pas',
  wmUtil in 'wmUtil.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  EDcode in '..\Common\EDcode.pas',
  MirEffect in 'MirEffect.pas',
  MaketSystem in 'MaketSystem.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  frmWebBroser in 'frmWebBroser.pas' {frmWebBrowser},
  HashList in '..\Common\HashList.pas',
  HumanActor in 'HumanActor.pas',
  HeroActor in 'HeroActor.pas',
  VMProtectSDK in '..\Common\VMProtectSDK.pas',
  DxHint in 'DxHint.pas',
  MirThread in 'MirThread.pas',
  StallSystem in '..\Common\StallSystem.pas',
  PatchUnit in 'PatchUnit.pas',
  MD5 in '..\Common\MD5.pas',
  CDClientSDK in '..\Common\CDClientSDK.pas',
  uSMBIOS in '..\Common\uSMBIOS.pas',
  uDiskSN in '..\Common\uDiskSN.pas',
  uThreadEx in 'uThreadEx.pas',
  MemLibrary in 'MemLibrary.pas',
  uFrmCaptcha in 'uFrmCaptcha.pas' {frmCaptcha},
{$IFDEF TEST}
  uFrmLogin in 'uFrmLogin.pas' {FrmLogin},
{$ENDIF}
  uDep in 'uDep.pas';

{$R *.RES}
begin
  if HasMMX then
  begin
    Application.Initialize;
{$IFDEF TEST}
    if not ShowFrmLogin then Exit;
{$ENDIF}
    Application.CreateForm(TfrmMain, frmMain);
    Application.CreateForm(TFrmDlg, FrmDlg);
    Application.CreateForm(TfrmWebBrowser, frmWebBrowser);
    Application.CreateForm(TfrmCaptcha, frmCaptcha);
    InitObj();
    //  OutputDebugStringA('mir2');
    Application.Run;
  end
  else
  begin
    MessageBox(0, '您的电脑配置太低不能运行本游戏！', '提示', MB_ICONWARNING + MB_OK);
    ExitProcess(0);
  end;
end.

