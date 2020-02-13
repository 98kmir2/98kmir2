program GameCenter;

uses
  FastMM4,
  Forms,
  Windows,
  GMain in 'GMain.pas' {frmMain},
  GShare in 'GShare.pas',
  GLoginServer in 'GLoginServer.pas' {frmLoginServerConfig},
  Share in 'Share.pas',
  SDK in '..\Common\SDK.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  D7ScktComp in '..\Common\D7ScktComp.pas',
  EDcode in '..\Common\EDcode.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  MD5 in '..\Common\MD5.pas';

{$R *.res}
{$R MakeRes.RES}

begin
  Application.Initialize;
  Application.HintPause := 100;
  Application.HintShortPause := 100;
  Application.HintHidePause := 15000;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmLoginServerConfig, frmLoginServerConfig);
  Application.Run;
end.

