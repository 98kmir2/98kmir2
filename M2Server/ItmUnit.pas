unit ItmUnit;

interface
uses
  Windows, Classes, SysUtils, Grobal2, MudUtil;
type
  TItemUnit = class
  private
    function GetRandomRange(nCount, nRate: Integer): Integer;
  public
    m_ItemNameList: TGList;
    constructor Create();
    destructor Destroy; override;
    procedure GetItemAddValue(UserItem: pTUserItem; var StdItem: TStdItem);
    procedure RandomUpgradeWeapon(UserItem: pTUserItem);
    procedure RandomUpgradeDress(UserItem: pTUserItem);
    procedure RandomUpgrade19(UserItem: pTUserItem);
    procedure RandomUpgrade202124(UserItem: pTUserItem);
    procedure RandomUpgrade26(UserItem: pTUserItem);
    procedure RandomUpgrade22(UserItem: pTUserItem);
    procedure RandomUpgrade23(UserItem: pTUserItem);
    procedure RandomUpgradeHelMet(UserItem: pTUserItem);

    procedure RandomRefineWeapon(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue);
    procedure RandomRefineDress(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue);
    procedure RandomRefine19(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue);
    procedure RandomRefine202124(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue);
    procedure RandomRefine26(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue);
    procedure RandomRefine22(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue);
    procedure RandomRefine23(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue);
    procedure RandomRefineHelMet(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue);

    function TreasureIdentify_Weapon(UserItem: pTUserItem): Integer;
    function TreasureIdentify_Wearing(UserItem: pTUserItem; stdMode: Integer): Integer;
    function TreasureIdentify_Common(UserItem: pTUserItem; n: Integer; var Abil: array of TEvaAbil): Integer;

    function SecretProperty_Weapon(UserItem: pTUserItem; bLevel: Integer): Integer;
    function SecretProperty_Wearing(UserItem: pTUserItem; stdMode: Integer; bLevel: Integer): Integer;
    function SecretProperty_Common(UserItem: pTUserItem; n: Integer; var Abil: array of TEvaAbil; bLevel: Integer): Integer;

    procedure UnknowHelmet(UserItem: pTUserItem);
    procedure UnknowRing(UserItem: pTUserItem);
    procedure UnknowNecklace(UserItem: pTUserItem);
    function LoadCustomItemName(): Boolean;
    function SaveCustomItemName(): Boolean;
    function AddCustomItemName(nMakeIndex, nItemIndex: Integer; sItemName: string): Boolean;
    function DelCustomItemName(nMakeIndex, nItemIndex: Integer): Boolean;
    function GetCustomItemName(nMakeIndex, nItemIndex: Integer): string;
    procedure Lock();
    procedure UnLock();
  end;

implementation

uses HUtil32, M2Share;

{ TItemUnit }

constructor TItemUnit.Create;
begin
  m_ItemNameList := TGList.Create;
end;

destructor TItemUnit.Destroy;
var
  i: Integer;
begin
  for i := 0 to m_ItemNameList.Count - 1 do
    Dispose(pTItemName(m_ItemNameList.Items[i]));
  m_ItemNameList.Free;
  inherited;
end;

function TItemUnit.GetRandomRange(nCount, nRate: Integer): Integer; //00494794
var
  i: Integer;
begin
  Result := 0;
  Randomize;
  for i := 0 to nCount - 1 do
  begin
    if Random(nRate) = 0 then
      Inc(Result);
  end;
end;

procedure TItemUnit.RandomUpgradeWeapon(UserItem: pTUserItem);
var
  nC, n10, n14: Integer;
  ps: pTStdItem;
begin
  if g_Config.boAddValEx then
  begin
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := _MIN(15, nC + 1) * 16 + UserItem.btValue[15] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := _MIN(15, nC + 1) * 16 + UserItem.btValue[16] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := _MIN(15, nC + 1) * 16 + UserItem.btValue[17] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nC + 1);
  end;

  nC := GetRandomRange(g_Config.nWeaponDCAddValueMaxLimit {12}, g_Config.nWeaponDCAddValueRate {15});
  if Random(15) = 0 then
    UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(g_Config.nWeaponMCAddValueMaxLimit {12}, g_Config.nWeaponMCAddValueRate {15});
  if Random(15) = 0 then
    UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(g_Config.nWeaponSCAddValueMaxLimit {12}, g_Config.nWeaponSCAddValueRate {15});
  if Random(15) = 0 then
    UserItem.btValue[2] := nC + 1;

  nC := GetRandomRange(12, 15); //Attack speed
  if Random(20) = 0 then
  begin
    ps := UserEngine.GetStdItem(UserItem.wIndex);
    if ps <> nil then
    begin
      n14 := (nC + 1) div 3;
      if n14 > 0 then
      begin
        if HiWord(ps.MAC) > 0 then
        begin
          if Random(5) = 0 then
            UserItem.btValue[6] := n14;
        end
        else
        begin
          if Random(3) <> 0 then
            UserItem.btValue[6] := n14
          else
            UserItem.btValue[6] := n14 + 10;
        end;
      end;
    end;
  end;

  nC := GetRandomRange(12, 15);
  if Random(24) = 0 then
    UserItem.btValue[5] := nC div 2 + 1;
  nC := GetRandomRange(12, 12);
  if Random(3) < 2 then
  begin
    n10 := (nC + 1) * 2000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
  nC := GetRandomRange(12, 15);
  if Random(10) = 0 then
    UserItem.btValue[7] := nC div 2 + 1;
end;

procedure TItemUnit.RandomUpgradeDress(UserItem: pTUserItem); //00494958
var
  nC, n10: Integer;
begin
  if g_Config.boAddValEx then
  begin
    nC := GetRandomRange(5, 40);
    if Random(55) = 0 then
      UserItem.btValue[15] := _MIN(15, nC + 1) * 16 + UserItem.btValue[15] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(55) = 0 then
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(55) = 0 then
      UserItem.btValue[16] := _MIN(15, nC + 1) * 16 + UserItem.btValue[16] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(55) = 0 then
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(55) = 0 then
      UserItem.btValue[17] := _MIN(15, nC + 1) * 16 + UserItem.btValue[17] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(55) = 0 then
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nC + 1);
  end;

  nC := GetRandomRange(6, 15);
  if Random(30) = 0 then
    UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 15);
  if Random(30) = 0 then
    UserItem.btValue[1] := nC + 1;

  nC := GetRandomRange(g_Config.nDressDCAddValueMaxLimit {6}, g_Config.nDressDCAddValueRate {20});
  if Random(g_Config.nDressDCAddRate {40}) = 0 then
    UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nDressMCAddValueMaxLimit {6}, g_Config.nDressMCAddValueRate {20});
  if Random(g_Config.nDressMCAddRate {40}) = 0 then
    UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nDressSCAddValueMaxLimit {6}, g_Config.nDressSCAddValueRate {20});
  if Random(g_Config.nDressSCAddRate {40}) = 0 then
    UserItem.btValue[4] := nC + 1;

  nC := GetRandomRange(6, 10);
  if Random(8) < 6 then
  begin
    n10 := (nC + 1) * 2000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgrade202124(UserItem: pTUserItem); //00494AB0
var
  nC, n10: Integer;
begin
  if g_Config.boAddValEx then
  begin
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := _MIN(15, nC + 1) * 16 + UserItem.btValue[15] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := _MIN(15, nC + 1) * 16 + UserItem.btValue[16] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := _MIN(15, nC + 1) * 16 + UserItem.btValue[17] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nC + 1);
  end;

  nC := GetRandomRange(6, 30);
  if Random(60) = 0 then
    UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 30);
  if Random(60) = 0 then
    UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace202124DCAddValueMaxLimit {6}, g_Config.nNeckLace202124DCAddValueRate {20});
  if Random(g_Config.nNeckLace202124DCAddRate {30}) = 0 then
    UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace202124MCAddValueMaxLimit {6}, g_Config.nNeckLace202124MCAddValueRate {20});
  if Random(g_Config.nNeckLace202124MCAddRate {30}) = 0 then
    UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace202124SCAddValueMaxLimit {6}, g_Config.nNeckLace202124SCAddValueRate {20});
  if Random(g_Config.nNeckLace202124SCAddRate {30}) = 0 then
    UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(20) < 15 then
  begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgrade26(UserItem: pTUserItem); //00494C08
var
  nC, n10: Integer;
begin
  if g_Config.boAddValEx then
  begin
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := _MIN(15, nC + 1) * 16 + UserItem.btValue[15] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := _MIN(15, nC + 1) * 16 + UserItem.btValue[16] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := _MIN(15, nC + 1) * 16 + UserItem.btValue[17] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nC + 1);
  end;

  nC := GetRandomRange(6, 20);
  if Random(20) = 0 then
    UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 20);
  if Random(20) = 0 then
    UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(g_Config.nArmRing26DCAddValueMaxLimit {6}, g_Config.nArmRing26DCAddValueRate {20});
  if Random(g_Config.nArmRing26DCAddRate {30}) = 0 then
    UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nArmRing26MCAddValueMaxLimit {6}, g_Config.nArmRing26MCAddValueRate {20});
  if Random(g_Config.nArmRing26MCAddRate {30}) = 0 then
    UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nArmRing26SCAddValueMaxLimit {6}, g_Config.nArmRing26SCAddValueRate {20});
  if Random(g_Config.nArmRing26SCAddRate {30}) = 0 then
    UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(20) < 15 then
  begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgrade19(UserItem: pTUserItem); //00494D60
var
  nC, n10: Integer;
begin
  if g_Config.boAddValEx then
  begin
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := _MIN(15, nC + 1) * 16 + UserItem.btValue[15] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := _MIN(15, nC + 1) * 16 + UserItem.btValue[16] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := _MIN(15, nC + 1) * 16 + UserItem.btValue[17] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nC + 1);
  end;

  nC := GetRandomRange(6, 20);
  if Random(40) = 0 then
    UserItem.btValue[0] := nC + 1;

  nC := GetRandomRange(g_Config.nNeckLace19LuckAddValueMaxLimit {6}, g_Config.nNeckLace19LuckAddValueRate {20});
  if Random(g_Config.nNeckLace19LuckAddRate {40}) = 0 then
    UserItem.btValue[1] := nC + 1;

  nC := GetRandomRange(g_Config.nNeckLace19DCAddValueMaxLimit {6}, g_Config.nNeckLace19DCAddValueRate {20});
  if Random(g_Config.nNeckLace19DCAddRate {30}) = 0 then
    UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace19MCAddValueMaxLimit {6}, g_Config.nNeckLace19MCAddValueRate {20});
  if Random(g_Config.nNeckLace19MCAddRate {30}) = 0 then
    UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nNeckLace19SCAddValueMaxLimit {6}, g_Config.nNeckLace19SCAddValueRate {20});
  if Random(g_Config.nNeckLace19SCAddRate {30}) = 0 then
    UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 10);
  if Random(4) < 3 then
  begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgrade22(UserItem: pTUserItem); //00494EB8
var
  nC, n10: Integer;
begin
  if g_Config.boAddValEx then
  begin
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := _MIN(15, nC + 1) * 16 + UserItem.btValue[15] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := _MIN(15, nC + 1) * 16 + UserItem.btValue[16] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := _MIN(15, nC + 1) * 16 + UserItem.btValue[17] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nC + 1);
  end;

  nC := GetRandomRange(g_Config.nRing22DCAddValueMaxLimit {6}, g_Config.nRing22DCAddValueRate {20});
  if Random(g_Config.nRing22DCAddRate {30}) = 0 then
    UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nRing22MCAddValueMaxLimit {6}, g_Config.nRing22MCAddValueRate {20});
  if Random(g_Config.nRing22MCAddRate {30}) = 0 then
    UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nRing22SCAddValueMaxLimit {6}, g_Config.nRing22SCAddValueRate {20});
  if Random(g_Config.nRing22SCAddRate {30}) = 0 then
    UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(4) < 3 then
  begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.RandomUpgrade23(UserItem: pTUserItem); //00494FB8
var
  nC, n10: Integer;
begin
  if g_Config.boAddValEx then
  begin
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := _MIN(15, nC + 1) * 16 + UserItem.btValue[15] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := _MIN(15, nC + 1) * 16 + UserItem.btValue[16] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := _MIN(15, nC + 1) * 16 + UserItem.btValue[17] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nC + 1);
  end;

  nC := GetRandomRange(6, 20);
  if Random(40) = 0 then
    UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 20);
  if Random(40) = 0 then
    UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(g_Config.nRing23DCAddValueMaxLimit {6}, g_Config.nRing23DCAddValueRate {20});
  if Random(g_Config.nRing23DCAddRate {30}) = 0 then
    UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nRing23MCAddValueMaxLimit {6}, g_Config.nRing23MCAddValueRate {20});
  if Random(g_Config.nRing23MCAddRate {30}) = 0 then
    UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nRing23SCAddValueMaxLimit {6}, g_Config.nRing23SCAddValueRate {20});
  if Random(g_Config.nRing23SCAddRate {30}) = 0 then
    UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(4) < 3 then
  begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.RandomUpgradeHelMet(UserItem: pTUserItem); //00495110
var
  nC, n10: Integer;
begin
  if g_Config.boAddValEx then
  begin
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := _MIN(15, nC + 1) * 16 + UserItem.btValue[15] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[15] := UserItem.btValue[15] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := _MIN(15, nC + 1) * 16 + UserItem.btValue[16] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[16] := UserItem.btValue[16] div 16 * 16 + _MIN(15, nC + 1);

    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := _MIN(15, nC + 1) * 16 + UserItem.btValue[17] mod 16;
    nC := GetRandomRange(5, 40);
    if Random(45) = 0 then
      UserItem.btValue[17] := UserItem.btValue[17] div 16 * 16 + _MIN(15, nC + 1);
  end;

  nC := GetRandomRange(6, 20);
  if Random(40) = 0 then
    UserItem.btValue[0] := nC + 1;
  nC := GetRandomRange(6, 20);
  if Random(30) = 0 then
    UserItem.btValue[1] := nC + 1;
  nC := GetRandomRange(g_Config.nHelMetDCAddValueMaxLimit {6}, g_Config.nHelMetDCAddValueRate {20});
  if Random(g_Config.nHelMetDCAddRate {30}) = 0 then
    UserItem.btValue[2] := nC + 1;
  nC := GetRandomRange(g_Config.nHelMetMCAddValueMaxLimit {6}, g_Config.nHelMetMCAddValueRate {20});
  if Random(g_Config.nHelMetMCAddRate {30}) = 0 then
    UserItem.btValue[3] := nC + 1;
  nC := GetRandomRange(g_Config.nHelMetSCAddValueMaxLimit {6}, g_Config.nHelMetSCAddValueRate {20});
  if Random(g_Config.nHelMetSCAddRate {30}) = 0 then
    UserItem.btValue[4] := nC + 1;
  nC := GetRandomRange(6, 12);
  if Random(4) < 3 then
  begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.UnknowHelmet(UserItem: pTUserItem); //00495268 神秘头盔
var
  nC, nRandPoint, n14: Integer;
begin
  nRandPoint := GetRandomRange(g_Config.nUnknowHelMetACAddValueMaxLimit {4}, g_Config.nUnknowHelMetACAddRate {20});
  if nRandPoint > 0 then
    UserItem.btValue[0] := nRandPoint;
  n14 := nRandPoint;
  nRandPoint := GetRandomRange(g_Config.nUnknowHelMetMACAddValueMaxLimit {4}, g_Config.nUnknowHelMetMACAddRate {20});
  if nRandPoint > 0 then
    UserItem.btValue[1] := nRandPoint;
  Inc(n14, nRandPoint);
  nRandPoint := GetRandomRange(g_Config.nUnknowHelMetDCAddValueMaxLimit {3}, g_Config.nUnknowHelMetDCAddRate {30});
  if nRandPoint > 0 then
    UserItem.btValue[2] := nRandPoint;
  Inc(n14, nRandPoint);
  nRandPoint := GetRandomRange(g_Config.nUnknowHelMetMCAddValueMaxLimit {3}, g_Config.nUnknowHelMetMCAddRate {30});
  if nRandPoint > 0 then
    UserItem.btValue[3] := nRandPoint;
  Inc(n14, nRandPoint);
  nRandPoint := GetRandomRange(g_Config.nUnknowHelMetSCAddValueMaxLimit {3}, g_Config.nUnknowHelMetSCAddRate {30});
  if nRandPoint > 0 then
    UserItem.btValue[4] := nRandPoint;
  Inc(n14, nRandPoint);
  nRandPoint := GetRandomRange(6, 30);
  if nRandPoint > 0 then
  begin
    nC := (nRandPoint + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nC);
    UserItem.Dura := _MIN(65000, UserItem.Dura + nC);
  end;
  if Random(30) = 0 then
    UserItem.btValue[7] := 1;
  //UserItem.btValue[8] := 1;
  if n14 >= 3 then
  begin
    if UserItem.btValue[0] >= 5 then
    begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[0] * 3 + 25;
      Exit;
    end;
    if UserItem.btValue[2] >= 2 then
    begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[2] * 4 + 35;
      Exit;
    end;
    if UserItem.btValue[3] >= 2 then
    begin
      UserItem.btValue[5] := 2;
      UserItem.btValue[6] := UserItem.btValue[3] * 2 + 18;
      Exit;
    end;
    if UserItem.btValue[4] >= 2 then
    begin
      UserItem.btValue[5] := 3;
      UserItem.btValue[6] := UserItem.btValue[4] * 2 + 18;
      Exit;
    end;
    UserItem.btValue[6] := n14 * 2 + 18;
  end;

end;

procedure TItemUnit.UnknowRing(UserItem: pTUserItem); //00495500 神秘戒指
var
  nC, n10, n14: Integer;
begin
  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + }
    GetRandomRange(g_Config.nUnknowRingACAddValueMaxLimit {6},
    g_Config.nUnknowRingACAddRate {20});
  if n10 > 0 then
    UserItem.btValue[0] := n10;
  n14 := n10;
  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + }
    GetRandomRange(g_Config.nUnknowRingMACAddValueMaxLimit {6},
    g_Config.nUnknowRingMACAddRate {20});
  if n10 > 0 then
    UserItem.btValue[1] := n10;
  Inc(n14, n10);
  // 以上二项为增加项，增加防，及魔防

  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + }
    GetRandomRange(g_Config.nUnknowRingDCAddValueMaxLimit {6},
    g_Config.nUnknowRingDCAddRate {20});
  if n10 > 0 then
    UserItem.btValue[2] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + }
    GetRandomRange(g_Config.nUnknowRingMCAddValueMaxLimit {6},
    g_Config.nUnknowRingMCAddRate {20});
  if n10 > 0 then
    UserItem.btValue[3] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(4,3) + GetRandomRange(4,8) + }
    GetRandomRange(g_Config.nUnknowRingSCAddValueMaxLimit {6},
    g_Config.nUnknowRingSCAddRate {20});
  if n10 > 0 then
    UserItem.btValue[4] := n10;
  Inc(n14, n10);
  n10 := GetRandomRange(6, 30);
  if n10 > 0 then
  begin
    nC := (n10 + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nC);
    UserItem.Dura := _MIN(65000, UserItem.Dura + nC);
  end;
  if Random(30) = 0 then
    UserItem.btValue[7] := 1;
  //UserItem.btValue[8] := 1;
  if n14 >= 3 then
  begin
    if UserItem.btValue[2] >= 3 then
    begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[2] * 3 + 25;
      Exit;
    end;
    if UserItem.btValue[3] >= 3 then
    begin
      UserItem.btValue[5] := 2;
      UserItem.btValue[6] := UserItem.btValue[3] * 2 + 18;
      Exit;
    end;
    if UserItem.btValue[4] >= 3 then
    begin
      UserItem.btValue[5] := 3;
      UserItem.btValue[6] := UserItem.btValue[4] * 2 + 18;
      Exit;
    end;
    UserItem.btValue[6] := n14 * 2 + 18;
  end;

end;

procedure TItemUnit.UnknowNecklace(UserItem: pTUserItem); //00495704 神秘腰带
var
  nC, n10, n14: Integer;
begin
  n10 := {GetRandomRange(3,5) + }
    GetRandomRange(g_Config.nUnknowNecklaceACAddValueMaxLimit {5},
    g_Config.nUnknowNecklaceACAddRate {20});
  if n10 > 0 then
    UserItem.btValue[0] := n10;
  n14 := n10;
  n10 := {GetRandomRange(3,5) + }
    GetRandomRange(g_Config.nUnknowNecklaceMACAddValueMaxLimit {5},
    g_Config.nUnknowNecklaceMACAddRate {20});
  if n10 > 0 then
    UserItem.btValue[1] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(3,15) + }
    GetRandomRange(g_Config.nUnknowNecklaceDCAddValueMaxLimit {5},
    g_Config.nUnknowNecklaceDCAddRate {30});
  if n10 > 0 then
    UserItem.btValue[2] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(3,15) + }
    GetRandomRange(g_Config.nUnknowNecklaceMCAddValueMaxLimit {5},
    g_Config.nUnknowNecklaceMCAddRate {30});
  if n10 > 0 then
    UserItem.btValue[3] := n10;
  Inc(n14, n10);
  n10 := {GetRandomRange(3,15) + }
    GetRandomRange(g_Config.nUnknowNecklaceSCAddValueMaxLimit {5},
    g_Config.nUnknowNecklaceSCAddRate {30});
  if n10 > 0 then
    UserItem.btValue[4] := n10;
  Inc(n14, n10);
  n10 := GetRandomRange(6, 30);
  if n10 > 0 then
  begin
    nC := (n10 + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + nC);
    UserItem.Dura := _MIN(65000, UserItem.Dura + nC);
  end;
  if Random(30) = 0 then
    UserItem.btValue[7] := 1;
  //UserItem.btValue[8] := 1;
  if n14 >= 2 then
  begin
    if UserItem.btValue[0] >= 3 then
    begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[0] * 3 + 25;
      Exit;
    end;
    if UserItem.btValue[2] >= 2 then
    begin
      UserItem.btValue[5] := 1;
      UserItem.btValue[6] := UserItem.btValue[2] * 3 + 30;
      Exit;
    end;
    if UserItem.btValue[3] >= 2 then
    begin
      UserItem.btValue[5] := 2;
      UserItem.btValue[6] := UserItem.btValue[3] * 2 + 20;
      Exit;
    end;
    if UserItem.btValue[4] >= 2 then
    begin
      UserItem.btValue[5] := 3;
      UserItem.btValue[6] := UserItem.btValue[4] * 2 + 20;
      Exit;
    end;
    UserItem.btValue[6] := n14 * 2 + 18;
  end;
end;

procedure TItemUnit.GetItemAddValue(UserItem: pTUserItem; var StdItem: TStdItem);
var
  i: Integer;
  vlo, vhi: Byte;
  vlo1, vhi1: Byte;
  vlo2, vhi2: Byte;
label
  lab;
begin
  case StdItem.stdMode of
    2:
      begin
        case StdItem.Shape of
          12:
            begin
              StdItem.Reserved := UserItem.btValue[0];
              if UserItem.Dura = UserItem.DuraMax then
                Inc(StdItem.looks);
              if StdItem.Reserved > 0 then
                Inc(StdItem.looks, 1);
            end;
          18:
            begin
              StdItem.AC := MakeLong(UserItem.btValue[0], UserItem.btValue[1]);
              StdItem.MAC := MakeLong(UserItem.btValue[2], UserItem.btValue[3]);
            end;
          51:
            begin
              StdItem.AC := MakeLong(UserItem.btValue[0], UserItem.btValue[1]);
              StdItem.MAC := MakeLong(UserItem.btValue[2], UserItem.btValue[3]);
              StdItem.DC := UserItem.btValue[4];
              StdItem.MC := MakeLong(UserItem.btValue[5], UserItem.btValue[6]);
            end;
        end;
      end;
    56:
      begin
        case StdItem.Shape of
          0:
            begin
              StdItem.AC := UserItem.btValue[0];
              StdItem.MAC := PWord(@UserItem.btValue[1])^;
              StdItem.looks := StdItem.looks + _MIN(3, StdItem.AC - 1);
            end;
        end;
      end;
    5, 6:
      begin
        StdItem.DC := MakeLong(LoWord(StdItem.DC), HiWord(StdItem.DC) + UserItem.btValue[0]);
        StdItem.MC := MakeLong(LoWord(StdItem.MC), HiWord(StdItem.MC) + UserItem.btValue[1]);
        StdItem.SC := MakeLong(LoWord(StdItem.SC), HiWord(StdItem.SC) + UserItem.btValue[2]);
        StdItem.AC := MakeLong(LoWord(StdItem.AC) + UserItem.btValue[3], HiWord(StdItem.AC) + UserItem.btValue[5]);
        StdItem.MAC := MakeLong(LoWord(StdItem.MAC) + UserItem.btValue[4], HiWord(StdItem.MAC) + UserItem.btValue[6]);
        if Byte(UserItem.btValue[7] - 1) < 10 then //神圣
          StdItem.Source := UserItem.btValue[7];
        if UserItem.btValue[10] <> 0 then
          StdItem.Reserved := StdItem.Reserved or 1;
        goto lab;
      end;
    10..13:
      begin
        StdItem.AC := MakeLong(LoWord(StdItem.AC), HiWord(StdItem.AC) + UserItem.btValue[0]);
        StdItem.MAC := MakeLong(LoWord(StdItem.MAC), HiWord(StdItem.MAC) + UserItem.btValue[1]);
        StdItem.DC := MakeLong(LoWord(StdItem.DC), HiWord(StdItem.DC) + UserItem.btValue[2]);
        StdItem.MC := MakeLong(LoWord(StdItem.MC), HiWord(StdItem.MC) + UserItem.btValue[3]);
        StdItem.SC := MakeLong(LoWord(StdItem.SC), HiWord(StdItem.SC) + UserItem.btValue[4]);
        goto lab;
      end;
    15..24, 26, 27, 28, 29, 30, 51, 52, 53, 54, 62, 63, 64:
      begin
        StdItem.AC := MakeLong(LoWord(StdItem.AC), HiWord(StdItem.AC) + UserItem.btValue[0]);
        StdItem.MAC := MakeLong(LoWord(StdItem.MAC), HiWord(StdItem.MAC) + UserItem.btValue[1]);
        StdItem.DC := MakeLong(LoWord(StdItem.DC), HiWord(StdItem.DC) + UserItem.btValue[2]);
        StdItem.MC := MakeLong(LoWord(StdItem.MC), HiWord(StdItem.MC) + UserItem.btValue[3]);
        StdItem.SC := MakeLong(LoWord(StdItem.SC), HiWord(StdItem.SC) + UserItem.btValue[4]);
        if UserItem.btValue[5] > 0 then
          StdItem.Need := UserItem.btValue[5];
        if UserItem.btValue[6] > 0 then
          StdItem.NeedLevel := UserItem.btValue[6];

        lab:
        StdItem.ItemSet := MakeWord(LoByte(StdItem.ItemSet) + UserItem.btValue[8], HiByte(StdItem.ItemSet) + UserItem.btValue[9]);
        for i := 0 to 2 do
        begin
          if (StdItem.reserve[0 + i] > 0) or (UserItem.btValue[15 + i] > 0) then
          begin
            vlo1 := StdItem.reserve[0 + i] div 16;
            vhi1 := StdItem.reserve[0 + i] mod 16;

            vlo2 := UserItem.btValue[15 + i] div 16;
            vhi2 := UserItem.btValue[15 + i] mod 16;

            vlo := _MIN(15, vlo1 + vlo2);
            vhi := _MIN(15, vhi1 + vhi2);
            StdItem.reserve[0 + i] := vlo * 16 + vhi;
          end;
        end;

      end;
  end;

  if StdItem.Eva.EvaTimesMax > 0 then
  begin
    GetItemEvaInfo(UserItem, StdItem.Eva);
  end;

  Move(UserItem.btValue, StdItem.AddOn, SizeOf(StdItem.AddOn));
end;

function TItemUnit.GetCustomItemName(nMakeIndex, nItemIndex: Integer): string;
var
  i: Integer;
  ItemName: pTItemName;
begin
  Result := '';
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do
    begin
      ItemName := m_ItemNameList.Items[i];
      if (ItemName.nMakeIndex = nMakeIndex) and (ItemName.nItemIndex = nItemIndex) then
      begin
        Result := ItemName.sItemName;
        Break;
      end;
    end;
  finally
    m_ItemNameList.UnLock;
  end;
end;

function TItemUnit.AddCustomItemName(nMakeIndex, nItemIndex: Integer; sItemName: string): Boolean;
var
  i: Integer;
  ItemName: pTItemName;
begin
  Result := False;
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do
    begin
      ItemName := m_ItemNameList.Items[i];
      if (ItemName.nMakeIndex = nMakeIndex) and (ItemName.nItemIndex = nItemIndex) then
      begin
        Exit;
      end;
    end;
    New(ItemName);
    ItemName.nMakeIndex := nMakeIndex;
    ItemName.nItemIndex := nItemIndex;
    ItemName.sItemName := sItemName;
    m_ItemNameList.Add(ItemName);
    Result := True;
  finally
    m_ItemNameList.UnLock;
  end;
end;

function TItemUnit.DelCustomItemName(nMakeIndex, nItemIndex: Integer): Boolean;
var
  i: Integer;
  ItemName: pTItemName;
begin
  Result := False;
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do
    begin
      ItemName := m_ItemNameList.Items[i];
      if (ItemName.nMakeIndex = nMakeIndex) and (ItemName.nItemIndex = nItemIndex) then
      begin
        Dispose(ItemName);
        m_ItemNameList.Delete(i);
        Result := True;
        Exit;
      end;
    end;
  finally
    m_ItemNameList.UnLock;
  end;
end;

function TItemUnit.LoadCustomItemName: Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText: string;
  sMakeIndex: string;
  sItemIndex: string;
  nMakeIndex: Integer;
  nItemIndex: Integer;
  sItemName: string;
  ItemName: pTItemName;
begin
  Result := False;
  sFileName := g_Config.sEnvirDir + 'ItemNameList.txt';
  LoadList := TStringList.Create;
  if FileExists(sFileName) then
  begin
    m_ItemNameList.Lock;
    try
      m_ItemNameList.Clear;
      LoadList.LoadFromFile(sFileName);
      for i := 0 to LoadList.Count - 1 do
      begin
        sLineText := Trim(LoadList.Strings[i]);
        sLineText := GetValidStr3(sLineText, sMakeIndex, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sItemIndex, [' ', #9]);
        sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
        nMakeIndex := Str_ToInt(sMakeIndex, -1);
        nItemIndex := Str_ToInt(sItemIndex, -1);
        if (nMakeIndex >= 0) and (nItemIndex >= 0) then
        begin
          New(ItemName);
          ItemName.nMakeIndex := nMakeIndex;
          ItemName.nItemIndex := nItemIndex;
          ItemName.sItemName := sItemName;
          m_ItemNameList.Add(ItemName);
        end;
      end;
      Result := True;
    finally
      m_ItemNameList.UnLock;
    end;
  end
  else
    LoadList.SaveToFile(sFileName);
  LoadList.Free;
end;

function TItemUnit.SaveCustomItemName: Boolean;
var
  i: Integer;
  SaveList: TStringList;
  sFileName: string;
  ItemName: pTItemName;
begin
  sFileName := g_Config.sEnvirDir + 'ItemNameList.txt';
  SaveList := TStringList.Create;
  m_ItemNameList.Lock;
  try
    for i := 0 to m_ItemNameList.Count - 1 do
    begin
      ItemName := m_ItemNameList.Items[i];
      SaveList.Add(IntToStr(ItemName.nMakeIndex) + #9 +
        IntToStr(ItemName.nItemIndex) + #9 + ItemName.sItemName);
    end;
  finally
    m_ItemNameList.UnLock;
  end;
  SaveList.SaveToFile(sFileName);
  SaveList.Free;
  Result := True;
end;

procedure TItemUnit.Lock;
begin
  m_ItemNameList.Lock;
end;

procedure TItemUnit.UnLock;
begin
  m_ItemNameList.UnLock;
end;

procedure TItemUnit.RandomRefineWeapon(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue);
var
  nC, n10, n14: Integer;
begin
  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[0], RandomAddValue.abAddValueRate[0]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[0] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[1], RandomAddValue.abAddValueRate[1]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[1] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[2], RandomAddValue.abAddValueRate[2]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[2] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[3], RandomAddValue.abAddValueRate[3]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[3] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[4], RandomAddValue.abAddValueRate[4]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[4] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[5], RandomAddValue.abAddValueRate[5]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[5] := nC div 2;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[6], RandomAddValue.abAddValueRate[6]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
  begin
    n14 := (nC + 1) div 3;
    if n14 > 0 then
    begin
      if Random(3) <> 0 then
        UserItem.btValue[6] := n14
      else
        UserItem.btValue[6] := n14 + 10;
    end;
  end;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[7], RandomAddValue.abAddValueRate[7]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[7] := nC div 2;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[8], RandomAddValue.abAddValueRate[8]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[8] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[9], RandomAddValue.abAddValueRate[9]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[9] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[10], RandomAddValue.abAddValueRate[10]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[10] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[11], RandomAddValue.abAddValueRate[11]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[11] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[12], RandomAddValue.abAddValueRate[12]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[12] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[13], RandomAddValue.abAddValueRate[13]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[13] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[14], RandomAddValue.abAddValueRate[14]);
  if Random(3) < 2 then
  begin
    n10 := nC * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.RandomRefineDress(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue); //00494958
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[0], RandomAddValue.abAddValueRate[0]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[0] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[1], RandomAddValue.abAddValueRate[1]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[1] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[2], RandomAddValue.abAddValueRate[2]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[2] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[3], RandomAddValue.abAddValueRate[3]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[3] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[4], RandomAddValue.abAddValueRate[4]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[4] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[5], RandomAddValue.abAddValueRate[5]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[5] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[6], RandomAddValue.abAddValueRate[6]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[6] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[7], RandomAddValue.abAddValueRate[7]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[7] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[8], RandomAddValue.abAddValueRate[8]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[8] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[9], RandomAddValue.abAddValueRate[9]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[9] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[10], RandomAddValue.abAddValueRate[10]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[10] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[11], RandomAddValue.abAddValueRate[11]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[11] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[12], RandomAddValue.abAddValueRate[12]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[12] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[13], RandomAddValue.abAddValueRate[13]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[13] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[14], RandomAddValue.abAddValueRate[14]);
  if Random(3) < 2 then
  begin
    n10 := nC * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.RandomRefine202124(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue); //00494AB0
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[0], RandomAddValue.abAddValueRate[0]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[0] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[1], RandomAddValue.abAddValueRate[1]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[1] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[2], RandomAddValue.abAddValueRate[2]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[2] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[3], RandomAddValue.abAddValueRate[3]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[3] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[4], RandomAddValue.abAddValueRate[4]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[4] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[5], RandomAddValue.abAddValueRate[5]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[5] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[6], RandomAddValue.abAddValueRate[6]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[6] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[7], RandomAddValue.abAddValueRate[7]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[7] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[8], RandomAddValue.abAddValueRate[8]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[8] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[9], RandomAddValue.abAddValueRate[9]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[9] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[10], RandomAddValue.abAddValueRate[10]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[10] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[11], RandomAddValue.abAddValueRate[11]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[11] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[12], RandomAddValue.abAddValueRate[12]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[12] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[13], RandomAddValue.abAddValueRate[13]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[13] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[14], RandomAddValue.abAddValueRate[14]);
  if Random(3) < 2 then
  begin
    n10 := nC * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.RandomRefine26(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue); //00494C08
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[0], RandomAddValue.abAddValueRate[0]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[0] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[1], RandomAddValue.abAddValueRate[1]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[1] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[2], RandomAddValue.abAddValueRate[2]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[2] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[3], RandomAddValue.abAddValueRate[3]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[3] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[4], RandomAddValue.abAddValueRate[4]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[4] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[5], RandomAddValue.abAddValueRate[5]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[5] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[6], RandomAddValue.abAddValueRate[6]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[6] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[7], RandomAddValue.abAddValueRate[7]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[7] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[8], RandomAddValue.abAddValueRate[8]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[8] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[9], RandomAddValue.abAddValueRate[9]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[9] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[10], RandomAddValue.abAddValueRate[10]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[10] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[11], RandomAddValue.abAddValueRate[11]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[11] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[12], RandomAddValue.abAddValueRate[12]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[12] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[13], RandomAddValue.abAddValueRate[13]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[13] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[14], RandomAddValue.abAddValueRate[14]);
  if Random(3) < 2 then
  begin
    n10 := nC * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.RandomRefine19(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue); //00494D60
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[0], RandomAddValue.abAddValueRate[0]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[0] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[1], RandomAddValue.abAddValueRate[1]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[1] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[2], RandomAddValue.abAddValueRate[2]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[2] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[3], RandomAddValue.abAddValueRate[3]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[3] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[4], RandomAddValue.abAddValueRate[4]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[4] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[5], RandomAddValue.abAddValueRate[5]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[5] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[6], RandomAddValue.abAddValueRate[6]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[6] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[7], RandomAddValue.abAddValueRate[7]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[7] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[8], RandomAddValue.abAddValueRate[8]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[8] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[9], RandomAddValue.abAddValueRate[9]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[9] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[10], RandomAddValue.abAddValueRate[10]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[10] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[11], RandomAddValue.abAddValueRate[11]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[11] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[12], RandomAddValue.abAddValueRate[12]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[12] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[13], RandomAddValue.abAddValueRate[13]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[13] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[14], RandomAddValue.abAddValueRate[14]);
  if Random(3) < 2 then
  begin
    n10 := nC * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.RandomRefine22(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue); //00494EB8
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[0], RandomAddValue.abAddValueRate[0]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[0] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[1], RandomAddValue.abAddValueRate[1]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[1] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[2], RandomAddValue.abAddValueRate[2]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[2] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[3], RandomAddValue.abAddValueRate[3]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[3] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[4], RandomAddValue.abAddValueRate[4]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[4] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[5], RandomAddValue.abAddValueRate[5]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[5] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[6], RandomAddValue.abAddValueRate[6]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[6] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[7], RandomAddValue.abAddValueRate[7]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[7] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[8], RandomAddValue.abAddValueRate[8]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[8] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[9], RandomAddValue.abAddValueRate[9]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[9] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[10], RandomAddValue.abAddValueRate[10]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[10] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[11], RandomAddValue.abAddValueRate[11]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[11] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[12], RandomAddValue.abAddValueRate[12]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[12] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[13], RandomAddValue.abAddValueRate[13]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[13] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[14], RandomAddValue.abAddValueRate[14]);
  if Random(3) < 2 then
  begin
    n10 := nC * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.RandomRefine23(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue); //00494FB8
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[0], RandomAddValue.abAddValueRate[0]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[0] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[1], RandomAddValue.abAddValueRate[1]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[1] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[2], RandomAddValue.abAddValueRate[2]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[2] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[3], RandomAddValue.abAddValueRate[3]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[3] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[4], RandomAddValue.abAddValueRate[4]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[4] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[5], RandomAddValue.abAddValueRate[5]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[5] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[6], RandomAddValue.abAddValueRate[6]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[6] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[7], RandomAddValue.abAddValueRate[7]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[7] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[8], RandomAddValue.abAddValueRate[8]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[8] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[9], RandomAddValue.abAddValueRate[9]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[9] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[10], RandomAddValue.abAddValueRate[10]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[10] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[11], RandomAddValue.abAddValueRate[11]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[11] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[12], RandomAddValue.abAddValueRate[12]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[12] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[13], RandomAddValue.abAddValueRate[13]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[13] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[14], RandomAddValue.abAddValueRate[14]);
  if Random(3) < 2 then
  begin
    n10 := nC * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

procedure TItemUnit.RandomRefineHelMet(UserItem: pTUserItem; var RandomAddValue: TRandomAddValue); //00495110
var
  nC, n10: Integer;
begin
  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[0], RandomAddValue.abAddValueRate[0]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[0] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[1], RandomAddValue.abAddValueRate[1]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[1] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[2], RandomAddValue.abAddValueRate[2]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[2] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[3], RandomAddValue.abAddValueRate[3]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[3] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[4], RandomAddValue.abAddValueRate[4]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[4] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[5], RandomAddValue.abAddValueRate[5]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[5] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[6], RandomAddValue.abAddValueRate[6]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[6] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[7], RandomAddValue.abAddValueRate[7]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[7] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[8], RandomAddValue.abAddValueRate[8]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[8] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[9], RandomAddValue.abAddValueRate[9]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[9] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[10], RandomAddValue.abAddValueRate[10]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[10] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[11], RandomAddValue.abAddValueRate[11]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[11] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[12], RandomAddValue.abAddValueRate[12]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[12] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[13], RandomAddValue.abAddValueRate[13]);
  if RandomAddValue.nAddValueRate >= (Random(100) + 1) then
    UserItem.btValue[13] := nC;

  nC := GetRandomRange(RandomAddValue.abAddValueMaxLimit[14], RandomAddValue.abAddValueRate[14]);
  if Random(3) < 2 then
  begin
    n10 := nC * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;

end;

//==================================================================

function TItemUnit.TreasureIdentify_Common(UserItem: pTUserItem; n: Integer; var Abil: array of TEvaAbil): Integer;
var
  i, r, nC: Integer;
  Eva: TEvaluation;
begin
  Result := n;

  FillChar(Eva, SizeOf(Eva), 0);
  GetItemEvaInfo(UserItem, Eva);

  for i := 0 to 15 do
  begin
    r := Random(16);
    case r of
      0: if (g_Config.tiAbilTagDropAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilTagDropAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilTagDropAddValueMaxLimit, _Max(1, g_Config.tiAbilTagDropAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 15; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      1: if (g_Config.tiAbilPreDropAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPreDropAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilPreDropAddValueMaxLimit, _Max(1, g_Config.tiAbilPreDropAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 16; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      2: if (g_Config.tiAbilSuckAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilSuckAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilSuckAddValueMaxLimit, _Max(1, g_Config.tiAbilSuckAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 17; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      3: if (g_Config.tiAbilIpRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpRecoverAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilIpRecoverAddValueMaxLimit, _Max(1, g_Config.tiAbilIpRecoverAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 18; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      4: if (g_Config.tiAbilIpExAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpExAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilIpExAddValueMaxLimit, _Max(1, g_Config.tiAbilIpExAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 19; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      5: if (g_Config.tiAbilIpDamAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpDamAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilIpDamAddValueMaxLimit, _Max(1, g_Config.tiAbilIpDamAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 20; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      6: if (g_Config.tiAbilIpReduceAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpReduceAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilIpReduceAddValueMaxLimit, _Max(1, g_Config.tiAbilIpReduceAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 21; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      7: if (g_Config.tiAbilIpDecAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpDecAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilIpDecAddValueMaxLimit, _Max(1, g_Config.tiAbilIpDecAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 22; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      8: if (g_Config.tiAbilBangAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilBangAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilBangAddValueMaxLimit, _Max(1, g_Config.tiAbilBangAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 23; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      9: if (g_Config.tiAbilGangUpAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilGangUpAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilGangUpAddValueMaxLimit, _Max(1, g_Config.tiAbilGangUpAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 24; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      10: if (g_Config.tiAbilPalsyReduceAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPalsyReduceAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilPalsyReduceAddValueMaxLimit, _Max(1, g_Config.tiAbilPalsyReduceAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 25; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      11: if (g_Config.tiAbilHPExAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilHPExAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilHPExAddValueMaxLimit, _Max(1, g_Config.tiAbilHPExAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 26; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      12: if (g_Config.tiAbilMPExAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilMPExAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilMPExAddValueMaxLimit, _Max(1, g_Config.tiAbilMPExAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 27; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      13: if (g_Config.tiAbilCCAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilCCAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilCCAddValueMaxLimit, _Max(1, g_Config.tiAbilCCAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 28; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      14: if (g_Config.tiAbilPoisonReduceAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPoisonReduceAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilPoisonReduceAddValueMaxLimit, _Max(1, g_Config.tiAbilPoisonReduceAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 29; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

      15: if (g_Config.tiAbilPoisonRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPoisonRecoverAddRate - Eva.EvaTimes)) = 0) then
        begin
          nC := GetRandomRange(g_Config.tiAbilPoisonRecoverAddValueMaxLimit, _Max(1, g_Config.tiAbilPoisonRecoverAddValueRate - Eva.EvaTimes));
          if nC > 0 then
          begin
            Abil[Result].btType := 30; //mob
            Abil[Result].btValue := nC;
            Inc(Result);
            if g_Config.tiPutAbilOnce or (Result > 3) then
              Exit;
          end;
        end;

    end;
  end;
end;

function TItemUnit.TreasureIdentify_Weapon(UserItem: pTUserItem): Integer;
var
  i,  n, nC, n10, rr: Integer;
  Eva: TEvaluation;
  Abil: array[0..3] of TEvaAbil;
begin
  Result := 0;
  n := 0;
  FillChar(Abil, SizeOf(Abil), 0);
  FillChar(Eva, SizeOf(Eva), 0);
  GetItemEvaInfo(UserItem, Eva);
  try
    for i := 0 to 7 do
    begin
      rr := Random(110);
      case rr of
        0..19: if (g_Config.tiWeaponDCAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponDCAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWeaponDCAddValueMaxLimit, _Max(1, g_Config.tiWeaponDCAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 1; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        20..39: if (g_Config.tiWeaponMCAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponMCAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWeaponMCAddValueMaxLimit, _Max(1, g_Config.tiWeaponMCAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 2; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        40..59: if (g_Config.tiWeaponSCAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponSCAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWeaponSCAddValueMaxLimit, _Max(1, g_Config.tiWeaponSCAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 3; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        100..109: if (g_Config.tiWeaponLuckAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponLuckAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWeaponLuckAddValueMaxLimit, _Max(1, g_Config.tiWeaponLuckAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 9; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        60..69: if (g_Config.tiWeaponCurseAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponCurseAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWeaponCurseAddValueMaxLimit, _Max(1, g_Config.tiWeaponCurseAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 10; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        70..79: if (g_Config.tiWeaponHitAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponHitAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWeaponHitAddValueMaxLimit, _Max(1, g_Config.tiWeaponHitAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 6; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        80..89: if (g_Config.tiWeaponHitSpdAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponHitSpdAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWeaponHitSpdAddValueMaxLimit, _Max(1, g_Config.tiWeaponHitSpdAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 11; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        90..99: if (g_Config.tiWeaponHolyAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponHolyAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWeaponHolyAddValueMaxLimit, _Max(1, g_Config.tiWeaponHolyAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 12; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;
      end;
    end;

    //神秘
    if (g_Config.tiSecretPropertyAddRate <> 0) and (Random(_Max(1, g_Config.tiSecretPropertyAddRate - Eva.EvaTimes)) = 0) then
    begin
      nC := GetRandomRange(g_Config.tiSecretPropertyAddValueMaxLimit, _Max(1, g_Config.tiSecretPropertyAddValueRate - Eva.EvaTimes * 2));
      if nC > 0 then
      begin
        SetItemEvaInfo(UserItem, t_AdvAbilMax, nC, Abil);
        Result := 2;
        Exit; //2222222222
      end;
    end;

    //灵媒
    if (g_Config.tiSpiritAddRate <> 0) and (Random(_Max(1, g_Config.tiSpiritAddRate - Eva.EvaTimes)) = 0) then
    begin
      nC := GetRandomRange(255, _Max(1, g_Config.tiSpiritAddValueRate - Eva.EvaTimes * 2));
      if nC > 0 then
      begin
        SetItemEvaInfo(UserItem, t_SpiritQ, nC, Abil);

        n10 := _MIN(255, nC + Random(10));
        SetItemEvaInfo(UserItem, t_Spirit, n10, Abil);
        SetItemEvaInfo(UserItem, t_SpiritMax, n10, Abil);
        Result := 3;
        Exit;
      end;
    end;
  finally
    if n < 3 then
    begin
      if not g_Config.tiPutAbilOnce or (n = 0) then
      begin
        rr := TreasureIdentify_Common(UserItem, n, Abil);
        if rr <> n then
        begin
          Result := 1;
          n := rr;
        end;
      end;
    end;
    if n > 0 then
      SetItemEvaInfo(UserItem, t_BaseAbil, 0, Abil);
  end;
end;

function TItemUnit.TreasureIdentify_Wearing(UserItem: pTUserItem; stdMode: Integer): Integer;
var
  i, ii,  n,  rr, rrr, nC, n10: Integer;
  Eva: TEvaluation;
  Abil: array[0..3] of TEvaAbil;
begin
  Result := 0;
  n := 0;
  FillChar(Abil, SizeOf(Abil), 0);
  FillChar(Eva, SizeOf(Eva), 0);
  GetItemEvaInfo(UserItem, Eva);
  try
    for i := 0 to 3 do
    begin
      rr := Random(100);
      case rr of
        0..29: if (g_Config.tiWearingDCAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingDCAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWearingDCAddValueMaxLimit, _Max(1, g_Config.tiWearingDCAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 1; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        30..59: if (g_Config.tiWearingMCAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingMCAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWearingMCAddValueMaxLimit, _Max(1, g_Config.tiWearingMCAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 2; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        60..89: if (g_Config.tiWearingSCAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingSCAddRate - Eva.EvaTimes)) = 0) then
          begin
            nC := GetRandomRange(g_Config.tiWearingSCAddValueMaxLimit, _Max(1, g_Config.tiWearingSCAddValueRate - Eva.EvaTimes * 2));
            if nC > 0 then
            begin
              Abil[n].btType := 3; //mob
              Abil[n].btValue := nC;
              Inc(n);
              if g_Config.tiPutAbilOnce or (n > High(Abil)) then
              begin
                Result := 1;
                Exit;
              end;
            end;
          end;

        90..99: if stdMode in [19, 20, 21, 23, 24] then
          begin //特殊首饰
            if stdMode = 19 then
            begin
              for ii := 0 to 1 do
              begin
                rrr := Random(2);
                case rrr of
                  0: if (g_Config.tiWearingAntiMagicAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingAntiMagicAddRate - Eva.EvaTimes)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingAntiMagicAddValueMaxLimit, _Max(1, g_Config.tiWearingAntiMagicAddValueRate - Eva.EvaTimes * 2));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 8; //mob
                        Abil[n].btValue := nC;
                        Inc(n);
                        if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                        begin
                          Result := 1;
                          Exit;
                        end;
                      end;
                    end;

                  1: if (g_Config.tiWearingLuckAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingLuckAddRate - Eva.EvaTimes)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingLuckAddValueMaxLimit, _Max(1, g_Config.tiWearingLuckAddValueRate - Eva.EvaTimes * 2));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 9; //mob
                        Abil[n].btValue := nC;
                        Inc(n);
                        if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                        begin
                          Result := 1;
                          Exit;
                        end;
                      end;
                    end;
                end;
              end;
            end
            else if stdMode in [20, 24] then
            begin
              for ii := 0 to 1 do
              begin
                rrr := Random(2);
                case rrr of
                  0: if (g_Config.tiWearingHitAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingHitAddRate - Eva.EvaTimes)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingHitAddValueMaxLimit, _Max(1, g_Config.tiWearingHitAddValueRate - Eva.EvaTimes * 2));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 6; //mob
                        Abil[n].btValue := nC;
                        Inc(n);
                        if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                        begin
                          Result := 1;
                          Exit;
                        end;
                      end;
                    end;

                  1: if (g_Config.tiWearingSpeedAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingSpeedAddRate - Eva.EvaTimes)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingSpeedAddValueMaxLimit, _Max(1, g_Config.tiWearingSpeedAddValueRate - Eva.EvaTimes * 2));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 7; //mob
                        Abil[n].btValue := nC;
                        Inc(n);
                        if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                        begin
                          Result := 1;
                          Exit;
                        end;
                      end;
                    end;
                end;
              end;
            end
            else if stdMode in [21] then
            begin
              for ii := 0 to 1 do
              begin
                rrr := Random(2);
                case rrr of
                  0: if (g_Config.tiWearingHealthRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingHealthRecoverAddRate - Eva.EvaTimes)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingHealthRecoverAddValueMaxLimit, _Max(1, g_Config.tiWearingHealthRecoverAddValueRate - Eva.EvaTimes * 2));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 13; //mob
                        Abil[n].btValue := nC;
                        Inc(n);
                        if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                        begin
                          Result := 1;
                          Exit;
                        end;
                      end;
                    end;

                  1: if (g_Config.tiWearingSpellRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingSpellRecoverAddRate - Eva.EvaTimes)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingSpellRecoverAddValueMaxLimit, _Max(1, g_Config.tiWearingSpellRecoverAddValueRate - Eva.EvaTimes * 2));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 14; //mob
                        Abil[n].btValue := nC;
                        Inc(n);
                        if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                        begin
                          Result := 1;
                          Exit;
                        end;
                      end;
                    end;
                end;
              end;
            end
            else if stdMode in [23] then
            begin
              for ii := 0 to 1 do
              begin
                rrr := Random(2);
                case rrr of
                  0: if (g_Config.tiWearingHealthRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingHealthRecoverAddRate - Eva.EvaTimes)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingHealthRecoverAddValueMaxLimit, _Max(1, g_Config.tiWearingHealthRecoverAddValueRate - Eva.EvaTimes * 2));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 13; //mob
                        Abil[n].btValue := nC;
                        Inc(n);
                        if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                        begin
                          Result := 29;
                          Exit;
                        end;
                      end;
                    end;

                  1: if (g_Config.tiWearingSpellRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingSpellRecoverAddRate - Eva.EvaTimes)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingSpellRecoverAddValueMaxLimit, _Max(1, g_Config.tiWearingSpellRecoverAddValueRate - Eva.EvaTimes * 2));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 30; //mob
                        Abil[n].btValue := nC;
                        Inc(n);
                        if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                        begin
                          Result := 1;
                          Exit;
                        end;
                      end;
                    end;
                end;
              end;
            end;
          end
          else
          begin //普通首饰
            for ii := 0 to 1 do
            begin
              rrr := Random(2);
              case rrr of
                0: if (g_Config.tiWearingACAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingACAddRate - Eva.EvaTimes)) = 0) then
                  begin
                    nC := GetRandomRange(g_Config.tiWearingACAddValueMaxLimit, _Max(1, g_Config.tiWearingACAddValueRate - Eva.EvaTimes * 2));
                    if nC > 0 then
                    begin
                      Abil[n].btType := 4; //mob
                      Abil[n].btValue := nC;
                      Inc(n);
                      if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                      begin
                        Result := 1;
                        Exit;
                      end;
                    end;
                  end;

                1: if (g_Config.tiWearingMACAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingMACAddRate - Eva.EvaTimes)) = 0) then
                  begin
                    nC := GetRandomRange(g_Config.tiWearingMACAddValueMaxLimit, _Max(1, g_Config.tiWearingMACAddValueRate - Eva.EvaTimes * 2));
                    if nC > 0 then
                    begin
                      Abil[n].btType := 5; //mob
                      Abil[n].btValue := nC;
                      Inc(n);
                      if g_Config.tiPutAbilOnce or (n > High(Abil)) then
                      begin
                        Result := 1;
                        Exit;
                      end;
                    end;
                  end;
              end;
            end;
          end;
      end;
    end;

    //神秘
    if (g_Config.tiSecretPropertyAddRate <> 0) and (Random(_Max(1, g_Config.tiSecretPropertyAddRate - Eva.EvaTimes)) = 0) then
    begin
      nC := GetRandomRange(g_Config.tiSecretPropertyAddValueMaxLimit, _Max(1, g_Config.tiSecretPropertyAddValueRate - Eva.EvaTimes * 2));
      if nC > 0 then
      begin
        SetItemEvaInfo(UserItem, t_AdvAbilMax, nC, Abil);
        Result := 2;
        Exit; //2222222222
      end;
    end;

    //灵媒
    if (g_Config.tiSpiritAddRate <> 0) and (Random(_Max(1, g_Config.tiSpiritAddRate - Eva.EvaTimes)) = 0) then
    begin
      nC := GetRandomRange(255, _Max(1, g_Config.tiSpiritAddValueRate - Eva.EvaTimes * 2));
      if nC > 0 then
      begin
        SetItemEvaInfo(UserItem, t_SpiritQ, nC, Abil);

        n10 := _MIN(255, nC + Random(10));
        SetItemEvaInfo(UserItem, t_Spirit, n10, Abil);
        SetItemEvaInfo(UserItem, t_SpiritMax, n10, Abil);
        Result := 3;
      end;
    end;
  finally
    if n < 3 then
    begin
      if not g_Config.tiPutAbilOnce or (n = 0) then
      begin
        rr := TreasureIdentify_Common(UserItem, n, Abil);
        if rr <> n then
        begin
          Result := 1;
          n := rr;
        end;
      end;
    end;
    if n > 0 then
      SetItemEvaInfo(UserItem, t_BaseAbil, 0, Abil);
  end;
end;

//==================================================================

function TItemUnit.SecretProperty_Common(UserItem: pTUserItem; n: Integer; var Abil: array of TEvaAbil; bLevel: Integer): Integer;
var
  i, t, r, nC, n10, n14: Integer;
  btAdvAbil: Byte;
label
  lab1, lab2;
begin
  Result := 0;
  if g_Config.tiSpMagicAddAtFirst then
  begin
    btAdvAbil := UserItem.btValueEx[18];
    try
      for i := 0 to 7 - G_SpSkillRet do
      begin
        r := Random(8 - G_SpSkillRet);
        if (btAdvAbil and (1 shl r) <> 0) then
          Break;
        case r of
          0: if (g_Config.tiSpMagicAddRate1 <> 0) and (Random(g_Config.tiSpMagicAddRate1) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 100;
              Exit;
            end;
          1: if (g_Config.tiSpMagicAddRate2 <> 0) and (Random(g_Config.tiSpMagicAddRate2) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 101;
              Exit;
            end;
          2: if (g_Config.tiSpMagicAddRate3 <> 0) and (Random(g_Config.tiSpMagicAddRate3) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 102;
              Exit;
            end;
          3: if (g_Config.tiSpMagicAddRate4 <> 0) and (Random(g_Config.tiSpMagicAddRate4) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 103;
              Exit;
            end;
          4: if (g_Config.tiSpMagicAddRate5 <> 0) and (Random(g_Config.tiSpMagicAddRate5) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 104;
              Exit;
            end;
          5: if (g_Config.tiSpMagicAddRate6 <> 0) and (Random(g_Config.tiSpMagicAddRate6) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 105;
              Exit;
            end;
          6: if (g_Config.tiSpMagicAddRate7 <> 0) and (Random(g_Config.tiSpMagicAddRate7) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 106;
              Exit;
            end;
          7: if (g_Config.tiSpMagicAddRate8 <> 0) and (Random(g_Config.tiSpMagicAddRate8) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 107;
              Exit;
            end;
        end;
      end;
    finally
      if Result > 0 then
      begin
        UserItem.btValueEx[18] := btAdvAbil;
      end;
    end;
    if Result > 0 then
      Exit;

    n := -1;
    for i := 0 to 3 do
    begin
      if Abil[i].btValue = 0 then
      begin
        n := i;
        Break;
      end;
    end;

    if n >= 0 then
    begin
      for i := 0 to 15 do
      begin
        r := Random(16);
        case r of
          0: if (g_Config.tiAbilTagDropAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilTagDropAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilTagDropAddValueMaxLimit, _Max(1, g_Config.tiAbilTagDropAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 15; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          1: if (g_Config.tiAbilPreDropAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPreDropAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilPreDropAddValueMaxLimit, _Max(1, g_Config.tiAbilPreDropAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 16; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          2: if (g_Config.tiAbilSuckAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilSuckAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilSuckAddValueMaxLimit, _Max(1, g_Config.tiAbilSuckAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 17; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          3: if (g_Config.tiAbilIpRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpRecoverAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpRecoverAddValueMaxLimit, _Max(1, g_Config.tiAbilIpRecoverAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 18; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          4: if (g_Config.tiAbilIpExAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpExAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpExAddValueMaxLimit, _Max(1, g_Config.tiAbilIpExAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 19; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          5: if (g_Config.tiAbilIpDamAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpDamAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpDamAddValueMaxLimit, _Max(1, g_Config.tiAbilIpDamAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 20; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          6: if (g_Config.tiAbilIpReduceAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpReduceAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpReduceAddValueMaxLimit, _Max(1, g_Config.tiAbilIpReduceAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 21; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          7: if (g_Config.tiAbilIpDecAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpDecAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpDecAddValueMaxLimit, _Max(1, g_Config.tiAbilIpDecAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 22; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          8: if (g_Config.tiAbilBangAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilBangAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilBangAddValueMaxLimit, _Max(1, g_Config.tiAbilBangAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 23; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          9: if (g_Config.tiAbilGangUpAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilGangUpAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilGangUpAddValueMaxLimit, _Max(1, g_Config.tiAbilGangUpAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 24; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          10: if (g_Config.tiAbilPalsyReduceAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPalsyReduceAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilPalsyReduceAddValueMaxLimit, _Max(1, g_Config.tiAbilPalsyReduceAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 25; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          11: if (g_Config.tiAbilHPExAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilHPExAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilHPExAddValueMaxLimit, _Max(1, g_Config.tiAbilHPExAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 26; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          12: if (g_Config.tiAbilMPExAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilMPExAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilMPExAddValueMaxLimit, _Max(1, g_Config.tiAbilMPExAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 27; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          13: if (g_Config.tiAbilCCAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilCCAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilCCAddValueMaxLimit, _Max(1, g_Config.tiAbilCCAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 28; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          14: if (g_Config.tiAbilPoisonReduceAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPoisonReduceAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilPoisonReduceAddValueMaxLimit, _Max(1, g_Config.tiAbilPoisonReduceAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 29; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          15: if (g_Config.tiAbilPoisonRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPoisonRecoverAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilPoisonRecoverAddValueMaxLimit, _Max(1, g_Config.tiAbilPoisonRecoverAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 30; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;
        end;
      end;
    end;

    if Result > 0 then  Exit;
    btAdvAbil := UserItem.btValueEx[1];
    try
      for i := 0 to 6 do
      begin
        r := Random(7);
        if (btAdvAbil and (1 shl r) <> 0) then
          Break;
        case r of
          0: if (g_Config.tiSpecialSkills1AddRate <> 0) and (Random(g_Config.tiSpecialSkills1AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          1: if (g_Config.tiSpecialSkills2AddRate <> 0) and (Random(g_Config.tiSpecialSkills2AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          2: if (g_Config.tiSpecialSkills3AddRate <> 0) and (Random(g_Config.tiSpecialSkills3AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          3: if (g_Config.tiSpecialSkills4AddRate <> 0) and (Random(g_Config.tiSpecialSkills4AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          4: if (g_Config.tiSpecialSkills5AddRate <> 0) and (Random(g_Config.tiSpecialSkills5AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          5: if (g_Config.tiSpecialSkills6AddRate <> 0) and (Random(g_Config.tiSpecialSkills6AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          6: if (g_Config.tiSpecialSkills7AddRate <> 0) and (Random(g_Config.tiSpecialSkills7AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
        end;
      end;
    finally
      if Result > 0 then
      begin
        UserItem.btValueEx[1] := btAdvAbil;
      end;
    end;
    if Result > 0 then
      Exit;
  end
  else
  begin //////////////
    n := -1;
    for i := 0 to 3 do
    begin
      if Abil[i].btValue = 0 then
      begin
        n := i;
        Break;
      end;
    end;

    if n >= 0 then
    begin
      for i := 0 to 15 do
      begin
        r := Random(16);
        case r of
          0: if (g_Config.tiAbilTagDropAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilTagDropAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilTagDropAddValueMaxLimit, _Max(1, g_Config.tiAbilTagDropAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 15; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          1: if (g_Config.tiAbilPreDropAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPreDropAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilPreDropAddValueMaxLimit, _Max(1, g_Config.tiAbilPreDropAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 16; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          2: if (g_Config.tiAbilSuckAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilSuckAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilSuckAddValueMaxLimit, _Max(1, g_Config.tiAbilSuckAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 17; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          3: if (g_Config.tiAbilIpRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpRecoverAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpRecoverAddValueMaxLimit, _Max(1, g_Config.tiAbilIpRecoverAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 18; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          4: if (g_Config.tiAbilIpExAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpExAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpExAddValueMaxLimit, _Max(1, g_Config.tiAbilIpExAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 19; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          5: if (g_Config.tiAbilIpDamAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpDamAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpDamAddValueMaxLimit, _Max(1, g_Config.tiAbilIpDamAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 20; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          6: if (g_Config.tiAbilIpReduceAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpReduceAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpReduceAddValueMaxLimit, _Max(1, g_Config.tiAbilIpReduceAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 21; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          7: if (g_Config.tiAbilIpDecAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilIpDecAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilIpDecAddValueMaxLimit, _Max(1, g_Config.tiAbilIpDecAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 22; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          8: if (g_Config.tiAbilBangAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilBangAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilBangAddValueMaxLimit, _Max(1, g_Config.tiAbilBangAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 23; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          9: if (g_Config.tiAbilGangUpAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilGangUpAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilGangUpAddValueMaxLimit, _Max(1, g_Config.tiAbilGangUpAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 24; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          10: if (g_Config.tiAbilPalsyReduceAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPalsyReduceAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilPalsyReduceAddValueMaxLimit, _Max(1, g_Config.tiAbilPalsyReduceAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 25; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          11: if (g_Config.tiAbilHPExAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilHPExAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilHPExAddValueMaxLimit, _Max(1, g_Config.tiAbilHPExAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 26; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          12: if (g_Config.tiAbilMPExAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilMPExAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilMPExAddValueMaxLimit, _Max(1, g_Config.tiAbilMPExAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 27; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          13: if (g_Config.tiAbilCCAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilCCAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilCCAddValueMaxLimit, _Max(1, g_Config.tiAbilCCAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 28; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          14: if (g_Config.tiAbilPoisonReduceAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPoisonReduceAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilPoisonReduceAddValueMaxLimit, _Max(1, g_Config.tiAbilPoisonReduceAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 29; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          15: if (g_Config.tiAbilPoisonRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiAbilPoisonRecoverAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiAbilPoisonRecoverAddValueMaxLimit, _Max(1, g_Config.tiAbilPoisonRecoverAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 30; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;
        end;
      end;
    end;

    if Result > 0 then Exit;

    btAdvAbil := UserItem.btValueEx[1];
    try
      for i := 0 to 6 do
      begin
        r := Random(7);
        if (btAdvAbil and (1 shl r) <> 0) then
          Break;
        case r of
          0: if (g_Config.tiSpecialSkills1AddRate <> 0) and (Random(g_Config.tiSpecialSkills1AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          1: if (g_Config.tiSpecialSkills2AddRate <> 0) and (Random(g_Config.tiSpecialSkills2AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          2: if (g_Config.tiSpecialSkills3AddRate <> 0) and (Random(g_Config.tiSpecialSkills3AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          3: if (g_Config.tiSpecialSkills4AddRate <> 0) and (Random(g_Config.tiSpecialSkills4AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          4: if (g_Config.tiSpecialSkills5AddRate <> 0) and (Random(g_Config.tiSpecialSkills5AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          5: if (g_Config.tiSpecialSkills6AddRate <> 0) and (Random(g_Config.tiSpecialSkills6AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
          6: if (g_Config.tiSpecialSkills7AddRate <> 0) and (Random(g_Config.tiSpecialSkills7AddRate) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Inc(Result);
              Exit;
            end;
        end;
      end;
    finally
      if Result > 0 then
      begin
        UserItem.btValueEx[1] := btAdvAbil;
      end;
    end;
    if Result > 0 then  Exit;

    btAdvAbil := UserItem.btValueEx[18];
    try
      for i := 0 to 7 - G_SpSkillRet do
      begin
        r := Random(8 - G_SpSkillRet);
        if (btAdvAbil and (1 shl r) <> 0) then
          Break;
        case r of
          0: if (g_Config.tiSpMagicAddRate1 <> 0) and (Random(g_Config.tiSpMagicAddRate1) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 100;
              Exit;
            end;
          1: if (g_Config.tiSpMagicAddRate2 <> 0) and (Random(g_Config.tiSpMagicAddRate2) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 101;
              Exit;
            end;
          2: if (g_Config.tiSpMagicAddRate3 <> 0) and (Random(g_Config.tiSpMagicAddRate3) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 102;
              Exit;
            end;
          3: if (g_Config.tiSpMagicAddRate4 <> 0) and (Random(g_Config.tiSpMagicAddRate4) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 103;
              Exit;
            end;
          4: if (g_Config.tiSpMagicAddRate5 <> 0) and (Random(g_Config.tiSpMagicAddRate5) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 104;
              Exit;
            end;
          5: if (g_Config.tiSpMagicAddRate6 <> 0) and (Random(g_Config.tiSpMagicAddRate6) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 105;
              Exit;
            end;
          6: if (g_Config.tiSpMagicAddRate7 <> 0) and (Random(g_Config.tiSpMagicAddRate7) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 106;
              Exit;
            end;
          7: if (g_Config.tiSpMagicAddRate8 <> 0) and (Random(g_Config.tiSpMagicAddRate8) = 0) then
            begin
              btAdvAbil := btAdvAbil or (1 shl r);
              Result := 107;
              Exit;
            end;
        end;
      end;
    finally
      if Result > 0 then
      begin
        UserItem.btValueEx[18] := btAdvAbil;
      end;
    end;
  end;
end;

//function GetItemSecretProperty(UserItem: pTUserItem; var array of TEvaAbil): Byte;

function TItemUnit.SecretProperty_Weapon(UserItem: pTUserItem; bLevel: Integer): Integer;
var
  i,  n, nC,rr: Integer;
  //Eva                       : TEvaluation;
  Abil: array[0..3] of TEvaAbil;
begin

  Result := 0;
  FillChar(Abil, SizeOf(Abil), 0);
  GetItemSecretProperty(UserItem, Abil);

  n := -1;
  for i := 0 to 3 do
  begin
    if Abil[i].btValue = 0 then
    begin
      n := i;
      Break;
    end;
  end;

  try
    if n >= 0 then
    begin
      for i := 0 to 7 do
      begin
        rr := Random(100);
        case rr of
          0..17: if (g_Config.tiWeaponDCAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponDCAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWeaponDCAddValueMaxLimit, _Max(1, g_Config.tiWeaponDCAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 1; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          18..33: if (g_Config.tiWeaponMCAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponMCAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWeaponMCAddValueMaxLimit, _Max(1, g_Config.tiWeaponMCAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 2; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          34..49: if (g_Config.tiWeaponSCAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponSCAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWeaponSCAddValueMaxLimit, _Max(1, g_Config.tiWeaponSCAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 3; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          50..59: if (g_Config.tiWeaponLuckAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponLuckAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWeaponLuckAddValueMaxLimit, _Max(1, g_Config.tiWeaponLuckAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 9; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          60..69: if (g_Config.tiWeaponCurseAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponCurseAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWeaponCurseAddValueMaxLimit, _Max(1, g_Config.tiWeaponCurseAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 10; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          70..79: if (g_Config.tiWeaponHitAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponHitAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWeaponHitAddValueMaxLimit, _Max(1, g_Config.tiWeaponHitAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 6; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          80..89: if (g_Config.tiWeaponHitSpdAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponHitSpdAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWeaponHitSpdAddValueMaxLimit, _Max(1, g_Config.tiWeaponHitSpdAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 11; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          90..99: if (g_Config.tiWeaponHolyAddRate <> 0) and (Random(_Max(1, g_Config.tiWeaponHolyAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWeaponHolyAddValueMaxLimit, _Max(1, g_Config.tiWeaponHolyAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 12; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;
        end;
      end;
    end;
  finally
    if Result = 0 then
      Result := SecretProperty_Common(UserItem, n, Abil, bLevel);
    if Result > 0 then
    begin
      SetItemEvaInfo(UserItem, t_MystAbil, 0, Abil);
    end;
  end;
end;

function TItemUnit.SecretProperty_Wearing(UserItem: pTUserItem; stdMode: Integer; bLevel: Integer): Integer;
var
  i, ii,  n,  rr, rrr, nC: Integer;
  //Eva                       : TEvaluation;
  Abil: array[0..3] of TEvaAbil;
begin
  n := -1;
  Result := 0;
  FillChar(Abil, SizeOf(Abil), 0);
  GetItemSecretProperty(UserItem, Abil);

  for i := 0 to 3 do
  begin
    if Abil[i].btValue = 0 then
    begin
      n := i;
      Break;
    end;
  end;

  try
    if n >= 0 then
    begin
      for i := 0 to 3 do
      begin
        rr := Random(100);
        case rr of
          0..29: if (g_Config.tiWearingDCAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingDCAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWearingDCAddValueMaxLimit, _Max(1, g_Config.tiWearingDCAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 1; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          30..59: if (g_Config.tiWearingMCAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingMCAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWearingMCAddValueMaxLimit, _Max(1, g_Config.tiWearingMCAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 2; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          60..89: if (g_Config.tiWearingSCAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingSCAddRate - bLevel)) = 0) then
            begin
              nC := GetRandomRange(g_Config.tiWearingSCAddValueMaxLimit, _Max(1, g_Config.tiWearingSCAddValueRate - bLevel));
              if nC > 0 then
              begin
                Abil[n].btType := 3; //mob
                Abil[n].btValue := nC;
                Inc(Result);
              end;
              Exit;
            end;

          90..99: if stdMode in [19, 20, 21, 23, 24] then
            begin //特殊首饰
              if stdMode = 19 then
              begin
                for ii := 0 to 1 do
                begin
                  rrr := Random(2);
                  case rrr of
                    0: if (g_Config.tiWearingAntiMagicAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingAntiMagicAddRate - bLevel)) = 0) then
                      begin
                        nC := GetRandomRange(g_Config.tiWearingAntiMagicAddValueMaxLimit, _Max(1, g_Config.tiWearingAntiMagicAddValueRate - bLevel));
                        if nC > 0 then
                        begin
                          Abil[n].btType := 8; //mob
                          Abil[n].btValue := nC;
                          Inc(Result);
                        end;
                        Exit;
                      end;

                    1: if (g_Config.tiWearingLuckAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingLuckAddRate - bLevel)) = 0) then
                      begin
                        nC := GetRandomRange(g_Config.tiWearingLuckAddValueMaxLimit, _Max(1, g_Config.tiWearingLuckAddValueRate - bLevel));
                        if nC > 0 then
                        begin
                          Abil[n].btType := 9; //mob
                          Abil[n].btValue := nC;
                          Inc(Result);
                        end;
                        Exit;
                      end;
                  end;
                end;
              end
              else if stdMode in [20, 24] then
              begin
                for ii := 0 to 1 do
                begin
                  rrr := Random(2);
                  case rrr of
                    0: if (g_Config.tiWearingHitAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingHitAddRate - bLevel)) = 0) then
                      begin
                        nC := GetRandomRange(g_Config.tiWearingHitAddValueMaxLimit, _Max(1, g_Config.tiWearingHitAddValueRate - bLevel));
                        if nC > 0 then
                        begin
                          Abil[n].btType := 6; //mob
                          Abil[n].btValue := nC;
                          Inc(Result);
                        end;
                        Exit;
                      end;

                    1: if (g_Config.tiWearingSpeedAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingSpeedAddRate - bLevel)) = 0) then
                      begin
                        nC := GetRandomRange(g_Config.tiWearingSpeedAddValueMaxLimit, _Max(1, g_Config.tiWearingSpeedAddValueRate - bLevel));
                        if nC > 0 then
                        begin
                          Abil[n].btType := 7; //mob
                          Abil[n].btValue := nC;
                          Inc(Result);
                        end;
                        Exit;
                      end;
                  end;
                end;
              end
              else if stdMode in [21] then
              begin
                for ii := 0 to 1 do
                begin
                  rrr := Random(2);
                  case rrr of
                    0: if (g_Config.tiWearingHealthRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingHealthRecoverAddRate - bLevel)) = 0) then
                      begin
                        nC := GetRandomRange(g_Config.tiWearingHealthRecoverAddValueMaxLimit, _Max(1, g_Config.tiWearingHealthRecoverAddValueRate - bLevel));
                        if nC > 0 then
                        begin
                          Abil[n].btType := 13; //mob
                          Abil[n].btValue := nC;
                          Inc(Result);
                        end;
                        Exit;
                      end;

                    1: if (g_Config.tiWearingSpellRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingSpellRecoverAddRate - bLevel)) = 0) then
                      begin
                        nC := GetRandomRange(g_Config.tiWearingSpellRecoverAddValueMaxLimit, _Max(1, g_Config.tiWearingSpellRecoverAddValueRate - bLevel));
                        if nC > 0 then
                        begin
                          Abil[n].btType := 14; //mob
                          Abil[n].btValue := nC;
                          Inc(Result);
                        end;
                        Exit;
                      end;
                  end;
                end;
              end
              else if stdMode in [23] then
              begin
                for ii := 0 to 1 do
                begin
                  rrr := Random(2);
                  case rrr of
                    0: if (g_Config.tiWearingHealthRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingHealthRecoverAddRate - bLevel)) = 0) then
                      begin
                        nC := GetRandomRange(g_Config.tiWearingHealthRecoverAddValueMaxLimit, _Max(1, g_Config.tiWearingHealthRecoverAddValueRate - bLevel));
                        if nC > 0 then
                        begin
                          Abil[n].btType := 13; //mob
                          Abil[n].btValue := nC;
                          Inc(Result);
                        end;
                        Exit;
                      end;

                    1: if (g_Config.tiWearingSpellRecoverAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingSpellRecoverAddRate - bLevel)) = 0) then
                      begin
                        nC := GetRandomRange(g_Config.tiWearingSpellRecoverAddValueMaxLimit, _Max(1, g_Config.tiWearingSpellRecoverAddValueRate - bLevel));
                        if nC > 0 then
                        begin
                          Abil[n].btType := 30; //mob
                          Abil[n].btValue := nC;
                          Inc(Result);
                        end;
                        Exit;
                      end;
                  end;
                end;
              end;
            end
            else
            begin //普通首饰
              for ii := 0 to 1 do
              begin
                rrr := Random(2);
                case rrr of
                  0: if (g_Config.tiWearingACAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingACAddRate - bLevel)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingACAddValueMaxLimit, _Max(1, g_Config.tiWearingACAddValueRate - bLevel));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 4; //mob
                        Abil[n].btValue := nC;
                        Inc(Result);
                      end;
                      Exit;
                    end;

                  1: if (g_Config.tiWearingMACAddRate <> 0) and (Random(_Max(1, g_Config.tiWearingMACAddRate - bLevel)) = 0) then
                    begin
                      nC := GetRandomRange(g_Config.tiWearingMACAddValueMaxLimit, _Max(1, g_Config.tiWearingMACAddValueRate - bLevel));
                      if nC > 0 then
                      begin
                        Abil[n].btType := 5; //mob
                        Abil[n].btValue := nC;
                        Inc(Result);
                      end;
                      Exit;
                    end;
                end;
              end;
            end;
        end;
      end;
    end;
  finally
    if Result = 0 then
      Result := SecretProperty_Common(UserItem, n, Abil, bLevel);
    if Result > 0 then
    begin
      SetItemEvaInfo(UserItem, t_MystAbil, 0, Abil);
    end;
  end;
end;

end.
