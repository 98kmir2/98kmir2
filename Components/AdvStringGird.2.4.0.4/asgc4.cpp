//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("asgc4.res");
USEPACKAGE("vcl40.bpi");
USEUNIT("asgreg.pas");
USERES("asgreg.dcr");
USEUNIT("asgprnr.pas");
USERES("asgprnr.dcr");
USEUNIT("asgprvr.pas");
USERES("asgprvr.dcr");
USEUNIT("asghtmlr.pas");
USERES("asghtmlr.dcr");
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
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
