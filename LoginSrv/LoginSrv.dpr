program LoginSrv;

uses
  FastMM4,
  Forms,
  GateSet in 'GateSet.pas' {FrmGateSetting},
  MasSock in 'MasSock.pas' {FrmMasSoc},
  EditUserInfo in 'EditUserInfo.pas' {FrmUserInfoEdit},
  FrmFindId in 'FrmFindId.pas' {FrmFindUserId},
  FAccountView in 'FAccountView.pas' {FrmAccountView},
  LMain in 'LMain.pas' {FrmMain},
  MonSoc in 'MonSoc.pas' {FrmMonSoc},
  LSShare in 'LSShare.pas',
  Parse in 'Parse.pas',
  IDDB in 'IDDB.pas',
  GrobalSession in 'GrobalSession.pas' {frmGrobalSession},
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig},
  SDK in '..\Common\SDK.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  EDcode in '..\Common\EDcode.pas',
  __DESUnit in '..\Common\__DESUnit.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  MD5 in '..\Common\MD5.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  {$IFDEF SQLDB}
  FrmMain.Caption := 'ÕÊºÅÊý¾Ý¿â SQL°æ';
{$ELSE}
  FrmMain.Caption := 'ÕÊºÅÊý¾Ý¿â';
{$ENDIF}
  Application.CreateForm(TFrmMasSoc, FrmMasSoc);
  Application.CreateForm(TFrmUserInfoEdit, FrmUserInfoEdit);
  Application.CreateForm(TFrmFindUserId, FrmFindUserId);
  Application.CreateForm(TFrmAccountView, FrmAccountView);
  Application.CreateForm(TFrmMonSoc, FrmMonSoc);
  Application.CreateForm(TfrmGeneralConfig, frmGeneralConfig);
  Application.Run;
end.

