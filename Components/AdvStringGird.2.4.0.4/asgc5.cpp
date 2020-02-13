//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("asgc5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("asgreg.pas");
USERES("asgreg.dcr");
USEUNIT("ASGPRVR.PAS");
USERES("ASGPRVR.dcr");
USEUNIT("ASGHTMLR.PAS");
USERES("ASGHTMLR.dcr");
USEUNIT("ASGPRNR.PAS");
USERES("ASGPRNR.dcr");
USEUNIT("asgfindr.pas");
USERES("asgfindr.dcr");
USEUNIT("PictureContainerReg.pas");
USERES("PictureContainerReg.dcr");
USEUNIT("asgreplacer.pas");
USERES("asgreplacer.dcr");
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
