unit CRCUnit;

interface

uses
  SysUtils, Classes;

function CRC8(const s: string): Byte;
function CRC16(s: PByteArray; iCount: Integer; OldCRC: Word = 0): Word;
function CRC32(s: PByteArray; iCount: Integer; OldCRC: Cardinal = 0): Cardinal;

implementation

const
  TABLE_SIZE                = 256;

const
  CRC8Table                 : array[0..TABLE_SIZE - 1] of Byte = (
    $00, $07, $0E, $09, $1C, $1B, $12, $15,
    $38, $3F, $36, $31, $24, $23, $2A, $2D,
    $70, $77, $7E, $79, $6C, $6B, $62, $65,
    $48, $4F, $46, $41, $54, $53, $5A, $5D,
    $E0, $E7, $EE, $E9, $FC, $FB, $F2, $F5,
    $D8, $DF, $D6, $D1, $C4, $C3, $CA, $CD,
    $90, $97, $9E, $99, $8C, $8B, $82, $85,
    $A8, $AF, $A6, $A1, $B4, $B3, $BA, $BD,
    $C7, $C0, $C9, $CE, $DB, $DC, $D5, $D2,
    $FF, $F8, $F1, $F6, $E3, $E4, $ED, $EA,
    $B7, $B0, $B9, $BE, $AB, $AC, $A5, $A2,
    $8F, $88, $81, $86, $93, $94, $9D, $9A,
    $27, $20, $29, $2E, $3B, $3C, $35, $32,
    $1F, $18, $11, $16, $03, $04, $0D, $0A,
    $57, $50, $59, $5E, $4B, $4C, $45, $42,
    $6F, $68, $61, $66, $73, $74, $7D, $7A,
    $89, $8E, $87, $80, $95, $92, $9B, $9C,
    $B1, $B6, $BF, $B8, $AD, $AA, $A3, $A4,
    $F9, $FE, $F7, $F0, $E5, $E2, $EB, $EC,
    $C1, $C6, $CF, $C8, $DD, $DA, $D3, $D4,
    $69, $6E, $67, $60, $75, $72, $7B, $7C,
    $51, $56, $5F, $58, $4D, $4A, $43, $44,
    $19, $1E, $17, $10, $05, $02, $0B, $0C,
    $21, $26, $2F, $28, $3D, $3A, $33, $34,
    $4E, $49, $40, $47, $52, $55, $5C, $5B,
    $76, $71, $78, $7F, $6A, $6D, $64, $63,
    $3E, $39, $30, $37, $22, $25, $2C, $2B,
    $06, $01, $08, $0F, $1A, $1D, $14, $13,
    $AE, $A9, $A0, $A7, $B2, $B5, $BC, $BB,
    $96, $91, $98, $9F, $8A, $8D, $84, $83,
    $DE, $D9, $D0, $D7, $C2, $C5, $CC, $CB,
    $E6, $E1, $E8, $EF, $FA, $FD, $F4, $F3);

  CRC16Table                : array[0..TABLE_SIZE - 1] of Word = (
    $0000, $1021, $2042, $3063, $4084, $50A5, $60C6, $70E7,
    $8108, $9129, $A14A, $B16B, $C18C, $D1AD, $E1CE, $F1EF,
    $1231, $0210, $3273, $2252, $52B5, $4294, $72F7, $62D6,
    $9339, $8318, $B37B, $A35A, $D3BD, $C39C, $F3FF, $E3DE,
    $2462, $3443, $0420, $1401, $64E6, $74C7, $44A4, $5485,
    $A56A, $B54B, $8528, $9509, $E5EE, $F5CF, $C5AC, $D58D,
    $3653, $2672, $1611, $0630, $76D7, $66F6, $5695, $46B4,
    $B75B, $A77A, $9719, $8738, $F7DF, $E7FE, $D79D, $C7BC,
    $48C4, $58E5, $6886, $78A7, $0840, $1861, $2802, $3823,
    $C9CC, $D9ED, $E98E, $F9AF, $8948, $9969, $A90A, $B92B,
    $5AF5, $4AD4, $7AB7, $6A96, $1A71, $0A50, $3A33, $2A12,
    $DBFD, $CBDC, $FBBF, $EB9E, $9B79, $8B58, $BB3B, $AB1A,
    $6CA6, $7C87, $4CE4, $5CC5, $2C22, $3C03, $0C60, $1C41,
    $EDAE, $FD8F, $CDEC, $DDCD, $AD2A, $BD0B, $8D68, $9D49,
    $7E97, $6EB6, $5ED5, $4EF4, $3E13, $2E32, $1E51, $0E70,
    $FF9F, $EFBE, $DFDD, $CFFC, $BF1B, $AF3A, $9F59, $8F78,
    $9188, $81A9, $B1CA, $A1EB, $D10C, $C12D, $F14E, $E16F,
    $1080, $00A1, $30C2, $20E3, $5004, $4025, $7046, $6067,
    $83B9, $9398, $A3FB, $B3DA, $C33D, $D31C, $E37F, $F35E,
    $02B1, $1290, $22F3, $32D2, $4235, $5214, $6277, $7256,
    $B5EA, $A5CB, $95A8, $8589, $F56E, $E54F, $D52C, $C50D,
    $34E2, $24C3, $14A0, $0481, $7466, $6447, $5424, $4405,
    $A7DB, $B7FA, $8799, $97B8, $E75F, $F77E, $C71D, $D73C,
    $26D3, $36F2, $0691, $16B0, $6657, $7676, $4615, $5634,
    $D94C, $C96D, $F90E, $E92F, $99C8, $89E9, $B98A, $A9AB,
    $5844, $4865, $7806, $6827, $18C0, $08E1, $3882, $28A3,
    $CB7D, $DB5C, $EB3F, $FB1E, $8BF9, $9BD8, $ABBB, $BB9A,
    $4A75, $5A54, $6A37, $7A16, $0AF1, $1AD0, $2AB3, $3A92,
    $FD2E, $ED0F, $DD6C, $CD4D, $BDAA, $AD8B, $9DE8, $8DC9,
    $7C26, $6C07, $5C64, $4C45, $3CA2, $2C83, $1CE0, $0CC1,
    $EF1F, $FF3E, $CF5D, $DF7C, $AF9B, $BFBA, $8FD9, $9FF8,
    $6E17, $7E36, $4E55, $5E74, $2E93, $3EB2, $0ED1, $1EF0);

  Crc16Start                : Cardinal = $FFFF;
  Crc16Bytes                = 2;
  Crc16Bits                 = 16;

  Crc32Table                : array[0..255] of Cardinal = (
    $00000000, $04C11DB7, $09823B6E, $0D4326D9, $130476DC, $17C56B6B, $1A864DB2, $1E475005,
    $2608EDB8, $22C9F00F, $2F8AD6D6, $2B4BCB61, $350C9B64, $31CD86D3, $3C8EA00A, $384FBDBD,
    $4C11DB70, $48D0C6C7, $4593E01E, $4152FDA9, $5F15ADAC, $5BD4B01B, $569796C2, $52568B75,
    $6A1936C8, $6ED82B7F, $639B0DA6, $675A1011, $791D4014, $7DDC5DA3, $709F7B7A, $745E66CD,
    $9823B6E0, $9CE2AB57, $91A18D8E, $95609039, $8B27C03C, $8FE6DD8B, $82A5FB52, $8664E6E5,
    $BE2B5B58, $BAEA46EF, $B7A96036, $B3687D81, $AD2F2D84, $A9EE3033, $A4AD16EA, $A06C0B5D,
    $D4326D90, $D0F37027, $DDB056FE, $D9714B49, $C7361B4C, $C3F706FB, $CEB42022, $CA753D95,
    $F23A8028, $F6FB9D9F, $FBB8BB46, $FF79A6F1, $E13EF6F4, $E5FFEB43, $E8BCCD9A, $EC7DD02D,
    $34867077, $30476DC0, $3D044B19, $39C556AE, $278206AB, $23431B1C, $2E003DC5, $2AC12072,
    $128E9DCF, $164F8078, $1B0CA6A1, $1FCDBB16, $018AEB13, $054BF6A4, $0808D07D, $0CC9CDCA,
    $7897AB07, $7C56B6B0, $71159069, $75D48DDE, $6B93DDDB, $6F52C06C, $6211E6B5, $66D0FB02,
    $5E9F46BF, $5A5E5B08, $571D7DD1, $53DC6066, $4D9B3063, $495A2DD4, $44190B0D, $40D816BA,
    $ACA5C697, $A864DB20, $A527FDF9, $A1E6E04E, $BFA1B04B, $BB60ADFC, $B6238B25, $B2E29692,
    $8AAD2B2F, $8E6C3698, $832F1041, $87EE0DF6, $99A95DF3, $9D684044, $902B669D, $94EA7B2A,
    $E0B41DE7, $E4750050, $E9362689, $EDF73B3E, $F3B06B3B, $F771768C, $FA325055, $FEF34DE2,
    $C6BCF05F, $C27DEDE8, $CF3ECB31, $CBFFD686, $D5B88683, $D1799B34, $DC3ABDED, $D8FBA05A,
    $690CE0EE, $6DCDFD59, $608EDB80, $644FC637, $7A089632, $7EC98B85, $738AAD5C, $774BB0EB,
    $4F040D56, $4BC510E1, $46863638, $42472B8F, $5C007B8A, $58C1663D, $558240E4, $51435D53,
    $251D3B9E, $21DC2629, $2C9F00F0, $285E1D47, $36194D42, $32D850F5, $3F9B762C, $3B5A6B9B,
    $0315D626, $07D4CB91, $0A97ED48, $0E56F0FF, $1011A0FA, $14D0BD4D, $19939B94, $1D528623,
    $F12F560E, $F5EE4BB9, $F8AD6D60, $FC6C70D7, $E22B20D2, $E6EA3D65, $EBA91BBC, $EF68060B,
    $D727BBB6, $D3E6A601, $DEA580D8, $DA649D6F, $C423CD6A, $C0E2D0DD, $CDA1F604, $C960EBB3,
    $BD3E8D7E, $B9FF90C9, $B4BCB610, $B07DABA7, $AE3AFBA2, $AAFBE615, $A7B8C0CC, $A379DD7B,
    $9B3660C6, $9FF77D71, $92B45BA8, $9675461F, $8832161A, $8CF30BAD, $81B02D74, $857130C3,
    $5D8A9099, $594B8D2E, $5408ABF7, $50C9B640, $4E8EE645, $4A4FFBF2, $470CDD2B, $43CDC09C,
    $7B827D21, $7F436096, $7200464F, $76C15BF8, $68860BFD, $6C47164A, $61043093, $65C52D24,
    $119B4BE9, $155A565E, $18197087, $1CD86D30, $029F3D35, $065E2082, $0B1D065B, $0FDC1BEC,
    $3793A651, $3352BBE6, $3E119D3F, $3AD08088, $2497D08D, $2056CD3A, $2D15EBE3, $29D4F654,
    $C5A92679, $C1683BCE, $CC2B1D17, $C8EA00A0, $D6AD50A5, $D26C4D12, $DF2F6BCB, $DBEE767C,
    $E3A1CBC1, $E760D676, $EA23F0AF, $EEE2ED18, $F0A5BD1D, $F464A0AA, $F9278673, $FDE69BC4,
    $89B8FD09, $8D79E0BE, $803AC667, $84FBDBD0, $9ABC8BD5, $9E7D9662, $933EB0BB, $97FFAD0C,
    $AFB010B1, $AB710D06, $A6322BDF, $A2F33668, $BCB4666D, $B8757BDA, $B5365D03, $B1F740B4);

  Crc32Start                : Cardinal = $FFFFFFFF;
  Crc32Bits                 = 32;
  Crc32Bytes                = 4;

function CRC8(const s: string): Byte;
var
  i, iLen, iStep            : Integer;
begin
  Result := 0;
  iLen := Length(s);
  if iLen < 32 then begin
    for i := 1 to iLen do begin
      Result := CRC8Table[Result xor Byte(s[i])];
    end;
  end
  else begin
    iStep := iLen div 32 + 1;
    i := 1;
    while i < iLen do begin
      Result := CRC8Table[Result xor Byte(s[i])];
      Inc(i, iStep);
    end;
  end;
end;

function CRC16(s: PByteArray; iCount: Integer; OldCRC: Word = 0): Word;
var
  I, Step, DecCount         : Integer;
begin
  Result := Crc16Start;
  if iCount < 32 then begin
    for I := 0 to iCount - 1 do begin
      Result := CRC16Table[Result shr (CRC16Bits - 8)] xor Word((Result shl 8)) xor s[I];
    end;
  end
  else begin
    Step := iCount div 32 + 1;
    I := 0;
    DecCount := iCount - 1;
    while I < DecCount do begin
      Result := CRC16Table[Result shr (CRC16Bits - 8)] xor Word((Result shl 8)) xor s[I];
      Inc(I, Step);
    end;
  end;
  for i := 0 to Crc16Bytes - 1 do begin
    Result := CRC16Table[Result shr (CRC16Bits - 8)] xor Word((Result shl 8)) xor (OldCRC shr (CRC16Bits - 8));
    OldCRC := Word(OldCRC shl 8);
  end;
end;

function CRC32(s: PByteArray; iCount: Integer; OldCRC: Cardinal = 0): Cardinal;
var
  I, Step, DecCount         : Integer;
begin
  Result := Crc32Start;
  if iCount < 32 then begin
    for I := 0 to iCount - 1 do begin
      Result := Crc32Table[Result shr (CRC32Bits - 8)] xor (Result shl 8) xor s[I];
    end;
  end
  else begin
    Step := iCount div 32 + 1;
    I := 0;
    DecCount := iCount - 1;
    while I < DecCount do begin
      Result := Crc32Table[Result shr (CRC32Bits - 8)] xor (Result shl 8) xor s[I];
      Inc(I, Step);
    end;
  end;
  for I := 0 to Crc32Bytes - 1 do begin
    Result := Crc32Table[Result shr (CRC32Bits - 8)] xor (Result shl 8) xor (OldCRC shr (CRC32Bits - 8));
    OldCRC := OldCRC shl 8;
  end;
end;

end.

