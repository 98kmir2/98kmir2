unit SecMan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;
{$IFDEF PATCHMAN}
procedure AddSection(const sStream: TMemoryStream; SecName: string; Buff1: Pointer; Size1: Integer; Buff2: Pointer; Size2: Integer);
procedure SetSectionAttrib(const fsWrite: TMemoryStream);
{$ENDIF}
var
  g_SecData                 : Integer;

implementation

//procedure AddSection(const sStream: TMemoryStream; SecName: string; SecSize: Integer); //打开exe文件,是否备份
{$IFDEF PATCHMAN}  
procedure AddSection(const sStream: TMemoryStream; SecName: string; Buff1: Pointer; Size1: Integer; Buff2: Pointer; Size2: Integer);
var
  ncode                     : Integer;
  //hFile                     : THandle;  //文件句柄
  ImageDosHeader            : IMAGE_DOS_HEADER; //DOS部首
  ImageNtHeaders            : IMAGE_NT_HEADERS; //映象头
  ImageSectionHeader        : IMAGE_SECTION_HEADER; //块表
  lPointerToRawData         : dword;    //指向文件中的偏移
  lVirtualAddress           : dword;    //指向内存中的偏移
  i                         : Integer;  //循环变量
  BytesRead, ByteSWrite     : Cardinal; //读写用参数
  AttachSize, AttachSize2   : dword;    //附加段大小
  AttachData, ChangeData    : Integer;  //附加段填充数据
  OEP                       : Integer;  //使用过程中用到的OEP
  lpBuffer                  : array of byte; {数据存储缓冲区}
  StartEN, SizeEN, StartCr  : dword;    //PE修改后的物理地址和大小
  ret                       : boolean;
begin
  ncode := 0;
  try
    //定义附加段填充数据
    AttachData := 0;
    AttachSize := Size1 + Size2 + 4;
    //打开文件
    //hFile := CreateFile(PChar(lFileName), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

    //校验
    //if hFile = INVALID_HANDLE_VALUE then begin
    //  exit;
    //end;

    //确认备份
    //if lBackup then
    //  CopyFile(PChar(lFileName), PChar(lFileName + '.bak'), False);

    ret := False;
    try
      ncode := 1;
      //读取DOS部首到ImageDosHeader
      sStream.Seek(0, 0);
      ncode := 2;
      sStream.ReadBuffer(ImageDosHeader, SizeOf(ImageDosHeader));
      //ReadFile(hFile, ImageDosHeader, SizeOf(ImageDosHeader), BytesRead, nil);

      //校验
      if ImageDosHeader.e_magic <> IMAGE_DOS_SIGNATURE then begin
        //Form1.Memo1.Lines.Add('不是有效的PE文件！');
        exit;
      end;
      ncode := 3;
      //指向映象头
      //SetFilePointer(hFile, ImageDosHeader._lfanew, nil, FILE_BEGIN);
      sStream.Seek(ImageDosHeader._lfanew, 0);

      //读取映向头到ImageNtHeaders
      ncode := 4;
      //ReadFile(hFile, ImageNtHeaders, SizeOf(ImageNtHeaders), BytesRead, nil);
      sStream.ReadBuffer(ImageNtHeaders, SizeOf(ImageNtHeaders));

      //校验
      if ImageNtHeaders.Signature <> IMAGE_NT_SIGNATURE then begin
        //Form1.Memo1.Lines.Add('不是有效的PE文件！');
        exit;
      end;
      {********************************}
      {OEP=基址+原EP}
      OEP := ImageNtHeaders.OptionalHeader.ImageBase + ImageNtHeaders.OptionalHeader.AddressOfEntryPoint;

      {********************************}

        //计算加入块对齐后大小
      ncode := 5;
      //初始化文件中偏移和映象中偏移
      lPointerToRawData := 0;
      lVirtualAddress := 0;

      for i := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do begin

        //读取块表中信息
        //ReadFile(hFile, ImageSectionHeader, SizeOf(ImageSectionHeader), BytesRead, nil);
        ncode := 6;
        sStream.ReadBuffer(ImageSectionHeader, SizeOf(ImageSectionHeader));

        //Form1.Memo1.Lines.Add(format('SecName%d: %s', [i, StrPas(@ImageSectionHeader.Name[0])]));

        {********************************}
        {查找原EP所在区段(原EP所在区段)，记录物理偏移（初始地址），物理大小（长度）}
        if ImageNtHeaders.OptionalHeader.AddressOfEntryPoint > ImageSectionHeader.VirtualAddress then begin
          StartEN := ImageSectionHeader.PointerToRawData;
          g_SecData := StartEN;
          SizeEN := ImageSectionHeader.SizeOfRawData;
          StartCr := ImageNtHeaders.OptionalHeader.ImageBase + ImageSectionHeader.VirtualAddress;
        end;

        {********************************}

          //计算文件中偏移
        if lPointerToRawData < ImageSectionHeader.PointerToRawData + ImageSectionHeader.SizeOfRawData then
          lPointerToRawData := ImageSectionHeader.PointerToRawData + ImageSectionHeader.SizeOfRawData;

        //计算映象中偏移
        if lVirtualAddress < ImageSectionHeader.VirtualAddress + ImageSectionHeader.Misc.VirtualSize then
          lVirtualAddress := ImageSectionHeader.VirtualAddress + ImageSectionHeader.Misc.VirtualSize;
      end;

      {增加块,定义块各项属性}

      FillChar(ImageSectionHeader.Name, SizeOf(ImageSectionHeader.Name), 0);
      Move(SecName[1], ImageSectionHeader.Name[0], length(SecName));

      //设置初始属性
      ImageSectionHeader.Misc.VirtualSize := AttachSize;
      ImageSectionHeader.VirtualAddress := lVirtualAddress;
      ImageSectionHeader.SizeOfRawData := AttachSize;
      ImageSectionHeader.PointerToRawData := lPointerToRawData;
      ImageSectionHeader.PointerToRelocations := 0;
      ImageSectionHeader.PointerToLinenumbers := 0;
      ImageSectionHeader.NumberOfRelocations := 0;

      //校正新节物理偏移(物理区块对齐)
      if ImageSectionHeader.VirtualAddress mod ImageNtHeaders.OptionalHeader.SectionAlignment > 0 then
        ImageSectionHeader.VirtualAddress := (ImageSectionHeader.VirtualAddress div ImageNtHeaders.OptionalHeader.SectionAlignment + 1) * ImageNtHeaders.OptionalHeader.SectionAlignment;

      //校正新节映象偏移(映象中区块对齐)
      if ImageSectionHeader.Misc.VirtualSize mod ImageNtHeaders.OptionalHeader.SectionAlignment > 0 then
        ImageSectionHeader.Misc.VirtualSize := (ImageSectionHeader.Misc.VirtualSize div ImageNtHeaders.OptionalHeader.SectionAlignment + 1) * ImageNtHeaders.OptionalHeader.SectionAlignment;

      //设置区块属性
      ImageSectionHeader.Characteristics := $E00000E0;
      ncode := 7;
      //保存区块信息
      //WriteFile(hFile, ImageSectionHeader, SizeOf(ImageSectionHeader), ByteSWrite, nil);
      sStream.WriteBuffer(ImageSectionHeader, SizeOf(ImageSectionHeader));

      //校正内存映象大小
      ImageNtHeaders.OptionalHeader.SizeOfImage := ImageNtHeaders.OptionalHeader.SizeOfImage + ImageSectionHeader.Misc.VirtualSize;
      //更
        //校正块数目
      Inc(ImageNtHeaders.FileHeader.NumberOfSections);

      ncode := 8;
      //定位到映象头
      sStream.Seek(ImageDosHeader._lfanew, FILE_BEGIN);
      //SetFilePointer(hFile, ImageDosHeader._lfanew, nil, FILE_BEGIN);

      ncode := 9;
      //保存校正过的映象头
      //WriteFile(hFile, ImageNtHeaders, SizeOf(ImageNtHeaders), ByteSWrite, nil);
      sStream.WriteBuffer(ImageNtHeaders, SizeOf(ImageNtHeaders));

      ncode := 10;

      //定位到新节开始处
      {//SetFilePointer(hFile, ImageSectionHeader.PointerToRawData, nil, FILE_BEGIN);
      sStream.Seek(ImageSectionHeader.PointerToRawData, FILE_BEGIN);

      //用00数据填充满新节
      //Form1.Memo1.Lines.Add('AttachSize: ' + IntToStr(AttachSize));

      AttachSize2 := AttachSize div 4;
      AttachSize := AttachSize mod 4;
      for i := 1 to AttachSize2 do begin
        //WriteFile(hFile, PByte(@AttachData)^, 4, ByteSWrite, nil);
        sStream.WriteBuffer(PByte(@AttachData)^, 4);
      end;
      for i := 1 to AttachSize do begin
        //WriteFile(hFile, PByte(@AttachData)^, 1, ByteSWrite, nil);
        sStream.WriteBuffer(PByte(@AttachData)^, 1);
      end;}

      {填充自定义数据}
        //指向新节开始处
      //SetFilePointer(hFile, ImageSectionHeader.PointerToRawData, nil, FILE_BEGIN);
      sStream.Seek(ImageSectionHeader.PointerToRawData, FILE_BEGIN);

      //ShowMessage(inttohex(ImageSectionHeader.PointerToRawData, 8));

      //WriteFile(hFile, OEP, 4, ByteSWrite, nil); //跳回OEP
      sStream.WriteBuffer(OEP, 4);

      sStream.WriteBuffer(Buff1^, Size1);
      sStream.WriteBuffer(Buff2^, Size2);

      //没有异常,显示增加区块成功!
      //ShowMessage('增加区块成功!');
      //Form1.Memo1.Lines.Add('增加区块成功...');
    finally

      {8.退出}
         //关闭文件
      //CloseHandle(hFile);
    end;
  except
    on E: Exception do
      ShowMessage(inttostr(ncode) + ' : ' + PChar(E.Message));
  end;

end;
{*************************end*********************************}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//设置文件的新区段段的属性为；读+写+可执行

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//procedure SetSectionAttrib(strFileName: string; StartEN: Integer);

procedure SetSectionAttrib(const fsWrite: TMemoryStream);
var
  dwBuffer                  : dword;    {文件读取缓冲区}
  pe_header                 : IMAGE_NT_HEADERS; {PE文件头指针}
  iNumberOfSections         : Integer;  {保存区块数目}
  dwSecTableBase            : dword;    {保存区块头文件首址}
  dwPEHeaderBase            : dword;    {保存PE文件头文件首址}
  iLoop                     : Integer;  {循环变量}
  pSectionTable             : IMAGE_SECTION_HEADER; {保存各区块表指针}
  dwSectionAttrib           : dword;    {保存段属性}
  //fsWrite                   : TFileStream; {写文件文件流}
begin
  try
    {以读写方式建立文件流}
    //fsWrite := TFileStream.Create(strFileName, fmOpenReadWrite or fmShareDenyNone);

    {文件流指针移动到新EXE头部字段}
    fsWrite.Seek($3C, soFromBeginning);
    dwBuffer := 0;

    {读取PE文件头文件地址}
    fsWrite.ReadBuffer(dwBuffer, 4);
    dwPEHeaderBase := dwBuffer;
    {文件指针指向PE 文件头}
    fsWrite.Seek(dwBuffer, soFromBeginning);
    {读入pe文件头到内存}
    fsWrite.ReadBuffer(pe_header, SizeOf(IMAGE_NT_HEADERS));
    {取区块数目}
    iNumberOfSections := pe_header.FileHeader.NumberOfSections;
    {获取区块表头文件地址:}
    dwSecTableBase := dwPEHeaderBase + SizeOf(IMAGE_NT_HEADERS);
    {分别读取各个区块的信息到内存}
    for iLoop := 0 to iNumberOfSections - 1 do begin
      {文件指针指向第iLoop区块表}
      fsWrite.Seek(dwSecTableBase, soFromBeginning);
      {读入区块表信息}
      fsWrite.ReadBuffer(pSectionTable, SizeOf(IMAGE_SECTION_HEADER));
      {读取区块数据文件地址}
      if pSectionTable.PointerToRawData = g_SecData then begin

        fsWrite.Seek(dwSecTableBase + 36, soFromBeginning);
        dwSectionAttrib := $E00000E0;
        fsWrite.WriteBuffer(dwSectionAttrib, SizeOf(dword));
        //ShowMessage('修改区段属性成功');
        //Form1.Memo1.Lines.Add('修改区段属性成功...');
        break;
      end;
    end;
    //fsWrite.Free;
  except
    on E: Exception do
      ShowMessage('2: ' + PChar(E.Message));
  end;
end;
{$ENDIF}
end.

