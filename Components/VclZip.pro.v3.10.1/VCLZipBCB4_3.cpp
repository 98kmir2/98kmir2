//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("VCLZipBCB4_3.res");
USEPACKAGE("vcl40.bpi");
USEUNIT("kpSFXCfg.pas");
USERES("kpSFXCfg.dcr");
USEUNIT("VCLUnZip.pas");
USERES("VCLUnZip.dcr");
USEUNIT("VCLZip.pas");
USERES("VCLZip.dcr");
USEPACKAGE("vclx40.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
