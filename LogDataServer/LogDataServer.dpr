program LogDataServer;

uses
  FastMM4,
  Forms,
  LogDataMain in 'LogDataMain.pas' {FrmLogData},
  LDShare in 'LDShare.pas',
  Grobal2 in 'Grobal2.pas',
  HUtil32 in 'HUtil32.pas',
  SDK in '..\Common\SDK.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogData, FrmLogData);
  Application.Run;
end.
