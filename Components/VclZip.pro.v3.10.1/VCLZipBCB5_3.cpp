//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("VCLZipBCB5_3.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("kpSFXCfg.pas");
USERES("kpSFXCfg.dcr");
USEUNIT("VCLUnZip.pas");
USERES("VCLUnZip.dcr");
USEUNIT("VCLZip.pas");
USERES("VCLZip.dcr");
USEPACKAGE("Vclx50.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
