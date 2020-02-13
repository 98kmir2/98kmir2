unit UUibRes;

interface
uses
  Windows, SysUtils, Classes, Dialogs, VCLUnZip, StrUtils, hutil32;


procedure ReleaseRes;
procedure Releasebasedll;


implementation
{.$I .\ClientBin\res\uibres.inc }

{.$I .\ClientBin\res\ubase.inc }




procedure Releasebasedll;
var
  vcluzip: TVCLUnZip;
  outmem: TMemoryStream;
  content: TMemoryStream;
  i: Integer;

  procedure ExtractRes(name1, nam2, name3: string);
  var
    s: string;
    i: Integer;
  begin
    try
      s := StrRScan(pchar(name3), '\') + 1;
      vcluzip.UnZipToStream(outmem, s);
      outmem.SaveToFile(name3);
      outmem.Clear;
    except
      outmem.Clear;
    end;
  end;
begin
  vcluzip := TVCLUnZip.Create(nil);
  outmem := TMemoryStream.Create;
  content := TMemoryStream.Create;
  try


    outmem.Clear;
    outmem.Position := 0;
   {
    content.SetSize(sizeof(arr_base));
    content.Write(arr_base, sizeof(arr_base));
    }
    vcluzip.ArchiveStream := content;

    ExtractRes('Bass', 'Data2', '.\bass.dll');

{$IFDEF CD}
    ExtractRes('CDCLIENT', 'Data2', '.\CDClient.dll');
{$ENDIF}
  finally
    vcluzip.Free;
    outmem.free;
    content.free;
  end;
end;

procedure ReleaseRes;
var
  vcluzip: TVCLUnZip;
  outmem: TMemoryStream;
  content: TMemoryStream;
  i: Integer;

  procedure ExtractRes(name1, nam2, name3: string);
  var
    s: string;
    i: Integer;
  begin
    try
      s := StrRScan(pchar(name3), '\') + 1;
      vcluzip.UnZipToStream(outmem, s);
      if outmem.Size > 0 then
        outmem.SaveToFile(name3);
      outmem.Clear;
    except
      outmem.Clear;
    end;
  end;
  
begin
  vcluzip := TVCLUnZip.Create(nil);
  outmem := TMemoryStream.Create;
  content := TMemoryStream.Create;
  try
    outmem.Clear;
    outmem.Position := 0;

    {content.SetSize(sizeof(arr_uibres));
    content.Write(arr_uibres, sizeof(arr_uibres)); }
    vcluzip.ArchiveStream := content;


    ExtractRes('ClientUib', 'Data', '.\Data\ui\blue.uib');
    ExtractRes('ItemBag', 'Data', '.\Data\ui\ItemBag.uib');
    ExtractRes('HeroItemBag1', 'Data', '.\Data\ui\HeroItemBag1.uib');
    ExtractRes('HeroItemBag2', 'Data', '.\Data\ui\HeroItemBag2.uib');
    ExtractRes('HeroItemBag3', 'Data', '.\Data\ui\HeroItemBag3.uib');
    ExtractRes('HeroItemBag4', 'Data', '.\Data\ui\HeroItemBag4.uib');
    ExtractRes('HeroItemBag5', 'Data', '.\Data\ui\HeroItemBag5.uib');
    ExtractRes('HeroStateWin', 'Data', '.\Data\ui\HeroStateWin.uib');
    ExtractRes('StateWindowHumanB', 'Data', '.\Data\ui\StateWindowHumanB.uib');
    ExtractRes('StateWindowHumanC', 'Data', '.\Data\ui\StateWindowHumanC.uib');
    ExtractRes('soundlst', 'Data', '.\Wav\sound2.lst');

    ExtractRes('gcbkd', 'Data', '.\Data\ui\gcbkd.uib');
    ExtractRes('gcpage1', 'Data', '.\Data\ui\gcpage1.uib');
    ExtractRes('gcpage2', 'Data', '.\Data\ui\gcpage2.uib');
    ExtractRes('gcclose1', 'Data', '.\Data\ui\gcclose1.uib');
    ExtractRes('gcclose2', 'Data', '.\Data\ui\gcclose2.uib');
    ExtractRes('gccheckbox1', 'Data', '.\Data\ui\gccheckbox1.uib');
    ExtractRes('gccheckbox2', 'Data', '.\Data\ui\gccheckbox2.uib');

    ExtractRes('WStall', 'Data', '.\Data\ui\WStall.uib');
    ExtractRes('WStallPrice', 'Data', '.\Data\ui\WStallPrice.uib');
    ExtractRes('PStallPrice0', 'Data', '.\Data\ui\PStallPrice0.uib');
    ExtractRes('PStallPrice1', 'Data', '.\Data\ui\PStallPrice1.uib');
    ExtractRes('StallBot0', 'Data', '.\Data\ui\StallBot0.uib');
    ExtractRes('StallBot1', 'Data', '.\Data\ui\StallBot1.uib');
    for i := 7 to 18 do
      ExtractRes('StallLooks' + IntToStr(i), 'Data', '.\Data\ui\StallLooks' + IntToStr(i) + '.uib');

    ExtractRes('DscStart0', 'Data', '.\Data\ui\DscStart0.uib');
    ExtractRes('DscStart1', 'Data', '.\Data\ui\DscStart1.uib');
  finally
    vcluzip.Free;
    outmem.free;
    content.free;
  end;
end;


end.

