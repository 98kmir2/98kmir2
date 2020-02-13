unit FGIntRSA;

interface

uses Windows, SysUtils, Controls, FGInt;

procedure RSAEncrypt(P: string; var Exp, modb: TFGInt; var E: string);
procedure RSADecrypt(E: string; var Exp, modb, d_p, d_q, P, q: TFGInt; var D: string);
procedure RSASign(M: string; var D, n, dp, dq, P, q: TFGInt; var S: string);
procedure RSAVerify(M, S: string; var E, n: TFGInt; var valid: boolean);

implementation

{$H+}

// Encrypt a string with the RSA algorithm, P^exp mod modb = E

procedure RSAEncrypt(P: string; var Exp, modb: TFGInt; var E: string);
var
  i, j, modbits             : longint;
  PGInt, temp, zero         : TFGInt;
  tempstr1, tempstr2, tempstr3: string;
begin
  Base2StringToFGInt('0', zero);
  FGIntToBase2String(modb, tempstr1);
  modbits := Length(tempstr1);
  convertBase256to2(P, tempstr1);
  tempstr1 := '111' + tempstr1;
  j := modbits - 1;
  while (Length(tempstr1) mod j) <> 0 do tempstr1 := '0' + tempstr1;

  j := Length(tempstr1) div (modbits - 1);
  tempstr2 := '';
  for i := 1 to j do begin
    tempstr3 := Copy(tempstr1, 1, modbits - 1);
    while (Copy(tempstr3, 1, 1) = '0') and (Length(tempstr3) > 1) do Delete(tempstr3, 1, 1);
    Base2StringToFGInt(tempstr3, PGInt);
    Delete(tempstr1, 1, modbits - 1);
    if tempstr3 = '0' then FGIntCopy(zero, temp) else FGIntMontgomeryModExp(PGInt, Exp, modb, temp);
    FGIntDestroy(PGInt);
    tempstr3 := '';
    FGIntToBase2String(temp, tempstr3);
    while (Length(tempstr3) mod modbits) <> 0 do tempstr3 := '0' + tempstr3;
    tempstr2 := tempstr2 + tempstr3;
    FGIntDestroy(temp);
  end;

  while (tempstr2[1] = '0') and (Length(tempstr2) > 1) do Delete(tempstr2, 1, 1);
  ConvertBase2To256(tempstr2, E);
  FGIntDestroy(zero);
end;

// Decrypt a string with the RSA algorithm, E^exp mod modb = D
// provide nil for exp.Number if you want a speedup by using the chinese
// remainder theorem, modb = p*q, d_p*e mod (p-1) = 1 and
// d_q*e mod (q-1) where e is the encryption exponent used

procedure RSADecrypt(E: string; var Exp, modb, d_p, d_q, P, q: TFGInt; var D: string);
var
  i, j, modbits             : longint;
  EGInt, temp, temp1, temp2, temp3, ppinvq, qqinvp, zero: TFGInt;
  tempstr1, tempstr2, tempstr3: string;
begin
  Base2StringToFGInt('0', zero);
  FGIntToBase2String(modb, tempstr1);
  modbits := Length(tempstr1);
  convertBase256to2(E, tempstr1);
  while Copy(tempstr1, 1, 1) = '0' do Delete(tempstr1, 1, 1);
  while (Length(tempstr1) mod modbits) <> 0 do tempstr1 := '0' + tempstr1;
  if Exp.Number = nil then begin
    FGIntModInv(q, P, temp1);
    FGIntMul(q, temp1, qqinvp);
    FGIntDestroy(temp1);
    FGIntModInv(P, q, temp1);
    FGIntMul(P, temp1, ppinvq);
    FGIntDestroy(temp1);
  end;

  j := Length(tempstr1) div modbits;
  tempstr2 := '';
  for i := 1 to j do begin
    tempstr3 := Copy(tempstr1, 1, modbits);
    while (Copy(tempstr3, 1, 1) = '0') and (Length(tempstr3) > 1) do Delete(tempstr3, 1, 1);
    Base2StringToFGInt(tempstr3, EGInt);
    Delete(tempstr1, 1, modbits);
    if tempstr3 = '0' then FGIntCopy(zero, temp) else begin
      if Exp.Number <> nil then FGIntMontgomeryModExp(EGInt, Exp, modb, temp) else begin
        FGIntMontgomeryModExp(EGInt, d_p, P, temp1);
        FGIntMul(temp1, qqinvp, temp3);
        FGIntCopy(temp3, temp1);
        FGIntMontgomeryModExp(EGInt, d_q, q, temp2);
        FGIntMul(temp2, ppinvq, temp3);
        FGIntCopy(temp3, temp2);
        FGIntAddMod(temp1, temp2, modb, temp);
        FGIntDestroy(temp1);
        FGIntDestroy(temp2);
      end;
    end;
    FGIntDestroy(EGInt);
    tempstr3 := '';
    FGIntToBase2String(temp, tempstr3);
    while (Length(tempstr3) mod (modbits - 1)) <> 0 do tempstr3 := '0' + tempstr3;
    tempstr2 := tempstr2 + tempstr3;
    FGIntDestroy(temp);
  end;

  if Exp.Number = nil then begin
    FGIntDestroy(ppinvq);
    FGIntDestroy(qqinvp);
  end;
  while (not (Copy(tempstr2, 1, 3) = '111')) and (Length(tempstr2) > 3) do Delete(tempstr2, 1, 1);
  Delete(tempstr2, 1, 3);
  ConvertBase2To256(tempstr2, D);
  FGIntDestroy(zero);
end;

// Sign strings with the RSA algorithm, M^d mod n = S
// provide nil for exp.Number if you want a speedup by using the chinese
// remainder theorem, n = p*q, dp*e mod (p-1) = 1 and
// dq*e mod (q-1) where e is the encryption exponent used

procedure RSASign(M: string; var D, n, dp, dq, P, q: TFGInt; var S: string);
var
  MGInt, SGInt, temp, temp1, temp2, temp3, ppinvq, qqinvp: TFGInt;
begin
  Base256StringToFGInt(M, MGInt);
  if D.Number <> nil then FGIntMontgomeryModExp(MGInt, D, n, SGInt) else begin
    FGIntModInv(P, q, temp);
    FGIntMul(P, temp, ppinvq);
    FGIntDestroy(temp);
    FGIntModInv(q, P, temp);
    FGIntMul(q, temp, qqinvp);
    FGIntDestroy(temp);
    FGIntMontgomeryModExp(MGInt, dp, P, temp1);
    FGIntMul(temp1, qqinvp, temp2);
    FGIntCopy(temp2, temp1);
    FGIntMontgomeryModExp(MGInt, dq, q, temp2);
    FGIntMul(temp2, ppinvq, temp3);
    FGIntCopy(temp3, temp2);
    FGIntAddMod(temp1, temp2, n, SGInt);
    FGIntDestroy(temp1);
    FGIntDestroy(temp2);
    FGIntDestroy(ppinvq);
    FGIntDestroy(qqinvp);
  end;
  FGIntToBase256String(SGInt, S);
  FGIntDestroy(MGInt);
  FGIntDestroy(SGInt);
end;

// Verify digitally signed strings with the RSA algorihthm,
// If M = S^e mod n then ok:=true else ok:=false

procedure RSAVerify(M, S: string; var E, n: TFGInt; var valid: boolean);
var
  MGInt, SGInt, temp        : TFGInt;
begin
  Base256StringToFGInt(S, SGInt);
  Base256StringToFGInt(M, MGInt);
  FGIntMod(MGInt, n, temp);
  FGIntCopy(temp, MGInt);
  FGIntMontgomeryModExp(SGInt, E, n, temp);
  FGIntCopy(temp, SGInt);
  valid := (FGIntCompareAbs(SGInt, MGInt) = Eq);
  FGIntDestroy(SGInt);
  FGIntDestroy(MGInt);
end;

end.

