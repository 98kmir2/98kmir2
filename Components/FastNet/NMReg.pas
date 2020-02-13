unit NMReg;

interface

procedure Register;

implementation

uses Windows, ShellAPI, Classes, StdCtrls, ExtCtrls, Forms,
  DesignIntf, DesignEditors,
  NMFngr, NMUUE, NMURL, NMUDP, NMTime,
  NMSMTP, NMPOP3, NMSTRM, NMNNTP, NMHTTP, NMFTP, NMEcho, PSock, NMDayTim, NMMSG, NMConst, NMICMP;

{$R NMShow.DFM}

 type
   TNMPropEd                               = class(TPropertyEditor)
   public
      procedure Edit; override;
      function GetValue: string; override;
      function GetAttributes: TPropertyAttributes; override;
   end; {_ TNMPropEd                               = class(TPropertyEditor) _}

   TNMShow = class(TForm)
      OKBtn: TButton;
      Image1: TImage;
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      Label4: TLabel;
      Label5: TLabel;
      Label6: TLabel;
      Label7: TLabel;
      Label8: TLabel;
      Label9: TLabel;
      Label10: TLabel;
      procedure Label8Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure Button5Click(Sender: TObject);
      procedure Button1Click(Sender: TObject);
      procedure Button4Click(Sender: TObject);
   private
      { Private declarations }
   public
      { Public declarations }
   end; {_ TNMShow = class(TForm) _}

procedure TNMShow.Label8Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,'open','http://www.netmastersllc.com',
               nil, nil, SW_SHOW);
end;

procedure TNMShow.Button3Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,'open','http://www.vcls.com/fastnet/versioncheck',
               nil, nil, SW_SHOW);
end;

procedure TNMShow.Button2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,'open','http://www.vcls.com/fastnet/mailinglist',
               nil, nil, SW_SHOW);
end;

procedure TNMShow.Button5Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,'open','http://www.vcls.com/fastnet/sourcecode',
               nil, nil, SW_SHOW);
end;

procedure TNMShow.Button1Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,'open','http://www.vcls.com/fastnet/knownbugs',
               nil, nil, SW_SHOW);
end;

procedure TNMShow.Button4Click(Sender: TObject);
begin
  ShellExecute(Application.Handle,'open','http://www.vcls.com/fastnet/bugreport',
               nil, nil, SW_SHOW);
end;


procedure TNMPropEd.Edit;
var Fm2: TNMShow;
begin
   Fm2 := TNMShow.Create(Application);
   try
      Fm2.ShowModal;
   finally
      Fm2.Free;
   end; {_ try _}
end; {_ procedure TNMPropEd.Edit; _}

function TNMPropEd.GetValue: string;
begin
   Result := 'Component';
end; {_ function TNMPropEd.GetValue: string; _}

function TNMPropEd.GetAttributes: TPropertyAttributes;
begin
   Result := [paDialog]; // This is a dialog-based property editorend;
end; {_ function TNMPropEd.GetAttributes: TPropertyAttributes; _}

//Component Registration

procedure Register;
begin
  RegisterComponents(Cons_Palette_Inet, [TNMDayTime]);
  RegisterComponents(Cons_Palette_Inet,[TNMMsg, TNMMSGServ]);
  RegisterComponents(Cons_Palette_Inet,[TNMEcho]);
  RegisterComponents(Cons_Palette_Inet,[TNMFTP]);
  RegisterComponents(Cons_Palette_Inet,[TNMHTTP]);
  RegisterComponents(Cons_Palette_Inet,[TNMNNTP]);
  RegisterComponents(Cons_Palette_Inet,[TNMStrm, TNMStrmServ]);
  RegisterComponents(Cons_Palette_Inet,[TNMPOP3]);
  RegisterComponents(Cons_Palette_Inet,[TNMSMTP]);
  RegisterComponents(Cons_Palette_Inet,[TNMTime]);
  RegisterComponents(Cons_Palette_Inet,[TNMUDP]); 
  RegisterComponents(Cons_Palette_Inet,[TNMURL]);
  RegisterComponents(Cons_Palette_Inet, [TNMUUProcessor]);
  RegisterComponents(Cons_Palette_Inet,[TPowersock, TNMGeneralServer]);
  RegisterComponents(Cons_Palette_Inet,[TNMFinger]);
  RegisterComponents(Cons_Palette_Inet,[TNMPing, TNMTracert]);
  RegisterPropertyEditor(TypeInfo(TNMReg), nil, '', TNMPropEd);
end;

end.
