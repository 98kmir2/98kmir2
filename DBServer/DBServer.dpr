program DBServer;

uses
  FastMM4,
  Forms,
  viewrcd in 'viewrcd.pas' {FrmFDBViewer},
  newchr in 'newchr.pas' {FrmNewChr},
  frmcpyrcd in 'frmcpyrcd.pas' {FrmCopyRcd},
  CreateChr in 'CreateChr.pas' {FrmCreateChr},
  FIDHum in 'FIDHum.pas' {FrmIDHum},
  IDSocCli in 'IDSocCli.pas' {FrmIDSoc},
  UsrSoc in 'UsrSoc.pas' {FrmUserSoc},
  FDBexpl in 'FDBexpl.pas' {FrmFDBExplore},
  DBSMain in 'DBSMain.pas' {FrmDBSrv},
  HumDB in 'HumDB.pas',
  DBShare in 'DBShare.pas',
  DBTools in 'DBTools.pas' {frmDBTool},
  EditRcd in 'EditRcd.pas' {frmEditRcd},
  TestSelGate in 'TestSelGate.pas' {frmTestSelGate},
  RouteManage in 'RouteManage.pas' {frmRouteManage},
  RouteEdit in 'RouteEdit.pas' {frmRouteEdit},
  Grobal2 in '..\Common\Grobal2.pas',
  LocalDB in 'LocalDB.pas',
  SDK in '..\Common\SDK.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  D7ScktComp in '..\Common\D7ScktComp.pas',
  EDcode in '..\Common\EDcode.pas',
  frmConfig in 'frmConfig.pas' {frmSetup},
  __DESUnit in '..\Common\__DESUnit.pas',
  RecSendUnit in 'RecSendUnit.pas',
  MudUtil in 'MudUtil.pas',
  ipinfo_dll in 'ipinfo_dll.pas',
  AddrEdit in 'AddrEdit.pas' {FrmEditAddr},
  HashList in '..\Common\HashList.pas',
  MD5 in '..\Common\MD5.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFrmDBSrv, FrmDBSrv);
  Application.CreateForm(TFrmFDBViewer, FrmFDBViewer);
  Application.CreateForm(TFrmNewChr, FrmNewChr);
  Application.CreateForm(TFrmCopyRcd, FrmCopyRcd);
  Application.CreateForm(TFrmCreateChr, FrmCreateChr);
  Application.CreateForm(TFrmIDHum, FrmIDHum);
  Application.CreateForm(TFrmIDSoc, FrmIDSoc);
  Application.CreateForm(TFrmUserSoc, FrmUserSoc);
  Application.CreateForm(TFrmFDBExplore, FrmFDBExplore);
  Application.CreateForm(TFrmCreateChr, FrmCreateChr);
  Application.CreateForm(TfrmDBTool, frmDBTool);
  Application.CreateForm(TfrmEditRcd, frmEditRcd);
  Application.CreateForm(TfrmRouteManage, frmRouteManage);
  Application.CreateForm(TfrmRouteEdit, frmRouteEdit);
  Application.CreateForm(TfrmSetup, frmSetup);
  Application.CreateForm(TFrmEditAddr, FrmEditAddr);
  Application.Run;
end.

