unit AdaptersInfo;

interface

const
  MAX_HOSTNAME_LEN          = 128;
  MAX_DOMAIN_NAME_LEN       = 128;
  MAX_SCOPE_ID_LEN          = 256;
  MAX_ADAPTER_NAME_LENGTH   = 256;
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_ADDRESS_LENGTH = 8;

type
  TIPAddressString = array[0..4 * 4 - 1] of Char;

  PIPAddrString = ^TIPAddrString;
  TIPAddrString = record
    Next: PIPAddrString;
    IPAddress: TIPAddressString;
    IPMask: TIPAddressString;
    Context: Integer;
  end;

  PFixedInfo = ^TFixedInfo;
  TFixedInfo = record                   { FIXED_INFO }
    HostName: array[0..MAX_HOSTNAME_LEN + 3] of Char;
    DomainName: array[0..MAX_DOMAIN_NAME_LEN + 3] of Char;
    CurrentDNSServer: PIPAddrString;
    DNSServerList: TIPAddrString;
    NodeType: Integer;
    ScopeId: array[0..MAX_SCOPE_ID_LEN + 3] of Char;
    EnableRouting: Integer;
    EnableProxy: Integer;
    EnableDNS: Integer;
  end;

  PIPAdapterInfo = ^TIPAdapterInfo;
  TIPAdapterInfo = record               { IP_ADAPTER_INFO }
    Next: PIPAdapterInfo;
    ComboIndex: Integer;
    AdapterName: array[0..MAX_ADAPTER_NAME_LENGTH + 3] of Char;
    Description: array[0..MAX_ADAPTER_DESCRIPTION_LENGTH + 3] of Char;
    AddressLength: Integer;
    Address: array[1..MAX_ADAPTER_ADDRESS_LENGTH] of Byte;
    Index: Integer;
    _Type: Integer;
    DHCPEnabled: Integer;
    CurrentIPAddress: PIPAddrString;
    IPAddressList: TIPAddrString;
    GatewayList: TIPAddrString;
    DHCPServer: TIPAddrString;
    HaveWINS: Bool;
    PrimaryWINSServer: TIPAddrString;
    SecondaryWINSServer: TIPAddrString;
    LeaseObtained: Integer;
    LeaseExpires: Integer;
  end;

type
  TGetAdaptersInfo = function(AI: PIPAdapterInfo; var BufLen: Integer): Integer; StdCall;

var
  GetAdaptersInfo           : TGetAdaptersInfo;
  h                         : hModule;

implementation

function Loadiphlpapidll: Boolean;      //��̬����iphlpapi.dll�е�GetAdaptersInfo
begin
  if h > 0 then Exit;
  h := LoadLibrary('iphlpapi.dll');
  if h > 0 then
    GetAdaptersInfo := GetProcAddress(h, 'GetAdaptersInfo');
  Result := Assigned(GetAdaptersInfo);
end;

function GetWanIP: string;              //��ȡ����IP
var
  AI, Work                  : PIPAdapterInfo;
  Size                      : Integer;
  Res                       : Integer;
  Description               : string;
  WanIP                     : string;
  function GetAddrString(Addr: PIPAddrString): string;
  begin
    Result := '';
    while (Addr <> nil) do begin
      Result := Result + 'A: ' + Addr^.IPAddress + ' M: ' + Addr^.IPMask + #13;
      Addr := Addr^.Next;
    end;
  end;
begin
  Result := '';
  if not Loadiphlpapidll then Exit;
  Size := 5120;
  GetMem(AI, Size);
  Res := GetAdaptersInfo(AI, Size);
  if (Res <> ERROR_SUCCESS) then begin
    //MessageBoxA(0, '��ȡ����IPʧ��', '����', MB_OK or MB_ICONERROR);
    Exit;
  end;
  Work := AI;
  repeat
    Description := StrPas(Work^.Description);
    if Pos('WAN', Description) > 0 then begin
      WanIP := GetAddrString(@Work^.IPAddressList);
      //���ﷵ�ص�WanIP�����ָ�ʽ A: 222.111.25.32 M: 255.255.255.0������A��M�м��������IP��
      WanIP := Copy(WanIP, Pos(':', WanIP) + 1, Pos('M', WanIP) - Pos(':', WanIP) - 2);
      Result := Trim(WanIP);            //����������յ�����IP��
      Exit;
    end;
    Work := Work^.Next;
  until (Work = nil);
  FreeMem(AI);
end;

end.

