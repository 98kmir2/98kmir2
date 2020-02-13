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

//procedure AddSection(const sStream: TMemoryStream; SecName: string; SecSize: Integer); //��exe�ļ�,�Ƿ񱸷�
{$IFDEF PATCHMAN}  
procedure AddSection(const sStream: TMemoryStream; SecName: string; Buff1: Pointer; Size1: Integer; Buff2: Pointer; Size2: Integer);
var
  ncode                     : Integer;
  //hFile                     : THandle;  //�ļ����
  ImageDosHeader            : IMAGE_DOS_HEADER; //DOS����
  ImageNtHeaders            : IMAGE_NT_HEADERS; //ӳ��ͷ
  ImageSectionHeader        : IMAGE_SECTION_HEADER; //���
  lPointerToRawData         : dword;    //ָ���ļ��е�ƫ��
  lVirtualAddress           : dword;    //ָ���ڴ��е�ƫ��
  i                         : Integer;  //ѭ������
  BytesRead, ByteSWrite     : Cardinal; //��д�ò���
  AttachSize, AttachSize2   : dword;    //���Ӷδ�С
  AttachData, ChangeData    : Integer;  //���Ӷ��������
  OEP                       : Integer;  //ʹ�ù������õ���OEP
  lpBuffer                  : array of byte; {���ݴ洢������}
  StartEN, SizeEN, StartCr  : dword;    //PE�޸ĺ�������ַ�ʹ�С
  ret                       : boolean;
begin
  ncode := 0;
  try
    //���帽�Ӷ��������
    AttachData := 0;
    AttachSize := Size1 + Size2 + 4;
    //���ļ�
    //hFile := CreateFile(PChar(lFileName), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

    //У��
    //if hFile = INVALID_HANDLE_VALUE then begin
    //  exit;
    //end;

    //ȷ�ϱ���
    //if lBackup then
    //  CopyFile(PChar(lFileName), PChar(lFileName + '.bak'), False);

    ret := False;
    try
      ncode := 1;
      //��ȡDOS���׵�ImageDosHeader
      sStream.Seek(0, 0);
      ncode := 2;
      sStream.ReadBuffer(ImageDosHeader, SizeOf(ImageDosHeader));
      //ReadFile(hFile, ImageDosHeader, SizeOf(ImageDosHeader), BytesRead, nil);

      //У��
      if ImageDosHeader.e_magic <> IMAGE_DOS_SIGNATURE then begin
        //Form1.Memo1.Lines.Add('������Ч��PE�ļ���');
        exit;
      end;
      ncode := 3;
      //ָ��ӳ��ͷ
      //SetFilePointer(hFile, ImageDosHeader._lfanew, nil, FILE_BEGIN);
      sStream.Seek(ImageDosHeader._lfanew, 0);

      //��ȡӳ��ͷ��ImageNtHeaders
      ncode := 4;
      //ReadFile(hFile, ImageNtHeaders, SizeOf(ImageNtHeaders), BytesRead, nil);
      sStream.ReadBuffer(ImageNtHeaders, SizeOf(ImageNtHeaders));

      //У��
      if ImageNtHeaders.Signature <> IMAGE_NT_SIGNATURE then begin
        //Form1.Memo1.Lines.Add('������Ч��PE�ļ���');
        exit;
      end;
      {********************************}
      {OEP=��ַ+ԭEP}
      OEP := ImageNtHeaders.OptionalHeader.ImageBase + ImageNtHeaders.OptionalHeader.AddressOfEntryPoint;

      {********************************}

        //�������������С
      ncode := 5;
      //��ʼ���ļ���ƫ�ƺ�ӳ����ƫ��
      lPointerToRawData := 0;
      lVirtualAddress := 0;

      for i := 0 to ImageNtHeaders.FileHeader.NumberOfSections - 1 do begin

        //��ȡ�������Ϣ
        //ReadFile(hFile, ImageSectionHeader, SizeOf(ImageSectionHeader), BytesRead, nil);
        ncode := 6;
        sStream.ReadBuffer(ImageSectionHeader, SizeOf(ImageSectionHeader));

        //Form1.Memo1.Lines.Add(format('SecName%d: %s', [i, StrPas(@ImageSectionHeader.Name[0])]));

        {********************************}
        {����ԭEP��������(ԭEP��������)����¼����ƫ�ƣ���ʼ��ַ���������С�����ȣ�}
        if ImageNtHeaders.OptionalHeader.AddressOfEntryPoint > ImageSectionHeader.VirtualAddress then begin
          StartEN := ImageSectionHeader.PointerToRawData;
          g_SecData := StartEN;
          SizeEN := ImageSectionHeader.SizeOfRawData;
          StartCr := ImageNtHeaders.OptionalHeader.ImageBase + ImageSectionHeader.VirtualAddress;
        end;

        {********************************}

          //�����ļ���ƫ��
        if lPointerToRawData < ImageSectionHeader.PointerToRawData + ImageSectionHeader.SizeOfRawData then
          lPointerToRawData := ImageSectionHeader.PointerToRawData + ImageSectionHeader.SizeOfRawData;

        //����ӳ����ƫ��
        if lVirtualAddress < ImageSectionHeader.VirtualAddress + ImageSectionHeader.Misc.VirtualSize then
          lVirtualAddress := ImageSectionHeader.VirtualAddress + ImageSectionHeader.Misc.VirtualSize;
      end;

      {���ӿ�,������������}

      FillChar(ImageSectionHeader.Name, SizeOf(ImageSectionHeader.Name), 0);
      Move(SecName[1], ImageSectionHeader.Name[0], length(SecName));

      //���ó�ʼ����
      ImageSectionHeader.Misc.VirtualSize := AttachSize;
      ImageSectionHeader.VirtualAddress := lVirtualAddress;
      ImageSectionHeader.SizeOfRawData := AttachSize;
      ImageSectionHeader.PointerToRawData := lPointerToRawData;
      ImageSectionHeader.PointerToRelocations := 0;
      ImageSectionHeader.PointerToLinenumbers := 0;
      ImageSectionHeader.NumberOfRelocations := 0;

      //У���½�����ƫ��(�����������)
      if ImageSectionHeader.VirtualAddress mod ImageNtHeaders.OptionalHeader.SectionAlignment > 0 then
        ImageSectionHeader.VirtualAddress := (ImageSectionHeader.VirtualAddress div ImageNtHeaders.OptionalHeader.SectionAlignment + 1) * ImageNtHeaders.OptionalHeader.SectionAlignment;

      //У���½�ӳ��ƫ��(ӳ�����������)
      if ImageSectionHeader.Misc.VirtualSize mod ImageNtHeaders.OptionalHeader.SectionAlignment > 0 then
        ImageSectionHeader.Misc.VirtualSize := (ImageSectionHeader.Misc.VirtualSize div ImageNtHeaders.OptionalHeader.SectionAlignment + 1) * ImageNtHeaders.OptionalHeader.SectionAlignment;

      //������������
      ImageSectionHeader.Characteristics := $E00000E0;
      ncode := 7;
      //����������Ϣ
      //WriteFile(hFile, ImageSectionHeader, SizeOf(ImageSectionHeader), ByteSWrite, nil);
      sStream.WriteBuffer(ImageSectionHeader, SizeOf(ImageSectionHeader));

      //У���ڴ�ӳ���С
      ImageNtHeaders.OptionalHeader.SizeOfImage := ImageNtHeaders.OptionalHeader.SizeOfImage + ImageSectionHeader.Misc.VirtualSize;
      //��
        //У������Ŀ
      Inc(ImageNtHeaders.FileHeader.NumberOfSections);

      ncode := 8;
      //��λ��ӳ��ͷ
      sStream.Seek(ImageDosHeader._lfanew, FILE_BEGIN);
      //SetFilePointer(hFile, ImageDosHeader._lfanew, nil, FILE_BEGIN);

      ncode := 9;
      //����У������ӳ��ͷ
      //WriteFile(hFile, ImageNtHeaders, SizeOf(ImageNtHeaders), ByteSWrite, nil);
      sStream.WriteBuffer(ImageNtHeaders, SizeOf(ImageNtHeaders));

      ncode := 10;

      //��λ���½ڿ�ʼ��
      {//SetFilePointer(hFile, ImageSectionHeader.PointerToRawData, nil, FILE_BEGIN);
      sStream.Seek(ImageSectionHeader.PointerToRawData, FILE_BEGIN);

      //��00����������½�
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

      {����Զ�������}
        //ָ���½ڿ�ʼ��
      //SetFilePointer(hFile, ImageSectionHeader.PointerToRawData, nil, FILE_BEGIN);
      sStream.Seek(ImageSectionHeader.PointerToRawData, FILE_BEGIN);

      //ShowMessage(inttohex(ImageSectionHeader.PointerToRawData, 8));

      //WriteFile(hFile, OEP, 4, ByteSWrite, nil); //����OEP
      sStream.WriteBuffer(OEP, 4);

      sStream.WriteBuffer(Buff1^, Size1);
      sStream.WriteBuffer(Buff2^, Size2);

      //û���쳣,��ʾ��������ɹ�!
      //ShowMessage('��������ɹ�!');
      //Form1.Memo1.Lines.Add('��������ɹ�...');
    finally

      {8.�˳�}
         //�ر��ļ�
      //CloseHandle(hFile);
    end;
  except
    on E: Exception do
      ShowMessage(inttostr(ncode) + ' : ' + PChar(E.Message));
  end;

end;
{*************************end*********************************}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//�����ļ��������ζε�����Ϊ����+д+��ִ��

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//procedure SetSectionAttrib(strFileName: string; StartEN: Integer);

procedure SetSectionAttrib(const fsWrite: TMemoryStream);
var
  dwBuffer                  : dword;    {�ļ���ȡ������}
  pe_header                 : IMAGE_NT_HEADERS; {PE�ļ�ͷָ��}
  iNumberOfSections         : Integer;  {����������Ŀ}
  dwSecTableBase            : dword;    {��������ͷ�ļ���ַ}
  dwPEHeaderBase            : dword;    {����PE�ļ�ͷ�ļ���ַ}
  iLoop                     : Integer;  {ѭ������}
  pSectionTable             : IMAGE_SECTION_HEADER; {����������ָ��}
  dwSectionAttrib           : dword;    {���������}
  //fsWrite                   : TFileStream; {д�ļ��ļ���}
begin
  try
    {�Զ�д��ʽ�����ļ���}
    //fsWrite := TFileStream.Create(strFileName, fmOpenReadWrite or fmShareDenyNone);

    {�ļ���ָ���ƶ�����EXEͷ���ֶ�}
    fsWrite.Seek($3C, soFromBeginning);
    dwBuffer := 0;

    {��ȡPE�ļ�ͷ�ļ���ַ}
    fsWrite.ReadBuffer(dwBuffer, 4);
    dwPEHeaderBase := dwBuffer;
    {�ļ�ָ��ָ��PE �ļ�ͷ}
    fsWrite.Seek(dwBuffer, soFromBeginning);
    {����pe�ļ�ͷ���ڴ�}
    fsWrite.ReadBuffer(pe_header, SizeOf(IMAGE_NT_HEADERS));
    {ȡ������Ŀ}
    iNumberOfSections := pe_header.FileHeader.NumberOfSections;
    {��ȡ�����ͷ�ļ���ַ:}
    dwSecTableBase := dwPEHeaderBase + SizeOf(IMAGE_NT_HEADERS);
    {�ֱ��ȡ�����������Ϣ���ڴ�}
    for iLoop := 0 to iNumberOfSections - 1 do begin
      {�ļ�ָ��ָ���iLoop�����}
      fsWrite.Seek(dwSecTableBase, soFromBeginning);
      {�����������Ϣ}
      fsWrite.ReadBuffer(pSectionTable, SizeOf(IMAGE_SECTION_HEADER));
      {��ȡ���������ļ���ַ}
      if pSectionTable.PointerToRawData = g_SecData then begin

        fsWrite.Seek(dwSecTableBase + 36, soFromBeginning);
        dwSectionAttrib := $E00000E0;
        fsWrite.WriteBuffer(dwSectionAttrib, SizeOf(dword));
        //ShowMessage('�޸��������Գɹ�');
        //Form1.Memo1.Lines.Add('�޸��������Գɹ�...');
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

