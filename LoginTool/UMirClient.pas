unit UMirClient;

interface
uses
  Windows, SysUtils, Classes, VCLUnZip, StrUtils, hutil32;

procedure ReleaseMir(outmem: TMemoryStream);
implementation

{.$I ..\Release\MirClient\mir2.vmp.exe.inc}



procedure ReleaseMir(outmem: TMemoryStream);
var
  vcluzip: TVCLUnZip;
  //outmem: TMemoryStream;
  content: TMemoryStream;
begin
  vcluzip := TVCLUnZip.Create(nil);
  //outmem := TMemoryStream.Create;
  content := TMemoryStream.Create;
  try
    outmem.Clear;
    outmem.Position := 0;
   // content.SetSize(sizeof(arr_mir2));  // 2019-10-08
   //content.Write(arr_mir2, sizeof(arr_mir2));   // 2019-10-08 
    vcluzip.ArchiveStream := content;
    vcluzip.UnZipToStream(outmem, 'mir2.vmp.exe.encod')
  finally
    vcluzip.Free;
    //outmem.free;
    content.free;
  end;

end;


end.
