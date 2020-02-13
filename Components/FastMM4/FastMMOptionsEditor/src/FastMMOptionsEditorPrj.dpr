program FastMMOptionsEditorPrj;

uses
  FastMM4,
  Forms,
  FastMMOptionsEditorFrmU in 'FastMMOptionsEditorFrmU.pas' {frmFastMMOptionsEditor},
  FastMM4OptionsEditorU in 'FastMM4OptionsEditorU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFastMMOptionsEditor, frmFastMMOptionsEditor);
  Application.Run;
end.
