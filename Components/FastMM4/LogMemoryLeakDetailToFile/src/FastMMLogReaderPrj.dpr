program FastMMLogReaderPrj;

{$R 'MessageText.res' 'MessageText.rc'}

uses
  FastMM4,
  Forms,
  FastMMLogReaderMainFrmU in 'FastMMLogReaderMainFrmU.pas' {frmReaderMain},
  FastMMTextManagementU in 'FastMMTextManagementU.pas',
  FastMMLogParserU in 'FastMMLogParserU.pas',
  VirtualTreesUtils in 'VirtualTreesUtils.pas';

{$R *.res}

begin

  Application.Initialize;
  Application.CreateForm(TfrmReaderMain, frmReaderMain);
  Application.Run;
end.
