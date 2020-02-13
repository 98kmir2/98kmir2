unit MakePlugDLL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, HUtil32,
  Dialogs, StdCtrls, XPMan, ExtCtrls, FileCtrl, ShellAPI, ImageHlp,
  OleCtrls, SHDocVw, Jpeg, ComCtrls, LocalDB, RzListVw, CheckLst, RzTreeVw, RzLstBox, RzGrids, Grids,
  BaseGrid, AdvGrid, VCLUnZip, VCLZip, RzPrgres, RzButton, RzRadChk, RzLabel, RzCmboBx, RzBmpBtn,
  SecMan, mars, Menus, SetBtnImage, PngImage, SkinConfig,math,md5,IniFiles, Spin;

  const
     FIX_OFFSET_TOP = 0; //修正皮肤读取整体偏移量
     DEFAULT_SKIN = 'default.98k_skn';
     DEFAULT_CFG = 'config.ini';
     PATCH_DIRNAME = '补丁';
     DEFAULT_UPDATELIST = 'update.txt';
     CAP_VER = '98K登录器生成器2019-12-27';
type
  TfrmMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    EditDBName: TEdit;
    btnLoadFromDB: TButton;
    btnSaveToFile: TButton;
    Label3: TLabel;
    Button1: TButton;
    AdvStringGrid1: TAdvStringGrid;
    CheckBox1: TCheckBox;
    OpenDlg: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    TabSheet3: TTabSheet;
    AdvStringGrid2: TAdvStringGrid;
    OpenDialog3: TOpenDialog;
    PopStartGame: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    PopWebSite: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    PopZhuangBei: TPopupMenu;
    PopContactUs: TPopupMenu;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    PopRegister: TPopupMenu;
    MenuItem1: TMenuItem;
    N12: TMenuItem;
    PopPass: TPopupMenu;
    MenuItem3: TMenuItem;
    N14: TMenuItem;
    PopFindPass: TPopupMenu;
    MenuItem5: TMenuItem;
    N16: TMenuItem;
    PopExit: TPopupMenu;
    MenuItem7: TMenuItem;
    N18: TMenuItem;
    PopMized: TPopupMenu;
    PopClose: TPopupMenu;
    N9: TMenuItem;
    N10: TMenuItem;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label1: TLabel;
    Edit1: TEdit;
    Panel3: TPanel;
    Memo1: TMemo;
    MemoPatchSvrIP: TMemo;
    Panel4: TPanel;
    route1: TEdit;
    route2: TEdit;
    Label4: TLabel;
    EdtWebSite: TEdit;
    Label5: TLabel;
    EdtGG: TEdit;
    Label6: TLabel;
    EdtMaster: TEdit;
    Label7: TLabel;
    EdtSlave: TEdit;
    Label8: TLabel;
    sknLoadDlg: TOpenDialog;
    sknSaveDlg: TSaveDialog;
    Panel1: TPanel;
    ButtonPic: TButton;
    Button8: TButton;
    Button9: TButton;
    btnCreatePlug: TButton;
    Label9: TLabel;
    EdtCount: TEdit;
    Label10: TLabel;
    pngLoadDlg: TOpenDialog;
    Button10: TButton;
    Label2: TLabel;
    EdtUpdate: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    EdtItems: TEdit;
    Label13: TLabel;
    EdtContactUs: TEdit;
    TabSheet6: TTabSheet;
    Panel5: TPanel;
    RadGFileLX: TRadioGroup;
    Button11: TButton;
    Button12: TButton;
    GroupBox1: TGroupBox;
    Label15: TLabel;
    EdtFileName: TEdit;
    Label16: TLabel;
    EdtFileCRC: TEdit;
    Button13: TButton;
    OpenFileDlg: TOpenDialog;
    Label17: TLabel;
    EdtFileDownURL: TEdit;
    ListView1: TListView;
    Label14: TLabel;
    Button15: TButton;
    Memo2: TMemo;
    Button14: TButton;
    OpenUpdateDlg: TOpenDialog;
    cmbFileSaveDir: TComboBox;
    ScrollBox1: TScrollBox;
    ImageMain: TImage;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabelStatus: TRzLabel;
    Panel2: TPanel;
    ckWindowed: TRzCheckBox;
    btnMinSize: TRzBmpButton;
    btnStartGame: TRzBmpButton;
    PanelProcessCur: TPanel;
    RzBmpButton1: TRzBmpButton;
    RzBmpButton3: TRzBmpButton;
    PanelWebBrowser: TPanel;
    PanelProcessMax: TPanel;
    PanelServerList: TPanel;
    btnGetBackPassword: TRzBmpButton;
    btnEditGameList: TRzBmpButton;
    btNewAccount: TRzBmpButton;
    btnEditGame: TRzBmpButton;
    btnChangePassword: TRzBmpButton;
    btnColse: TRzBmpButton;
    GroupBox2: TGroupBox;
    CheckBox5: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox3: TCheckBox;
    GroupBox3: TGroupBox;
    Label18: TLabel;
    EdtMicroAddress: TEdit;
    Label19: TLabel;
    Label20: TLabel;
    EdtMicroPort: TSpinEdit;
    Label21: TLabel;
    RadioGroup1: TRadioGroup;
    ChkCoreVersion: TCheckBox;

  //private


    procedure btnCreatePlugClick(Sender: TObject);
    procedure ButtonPicClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadFromDBClick(Sender: TObject);
    procedure btnSaveToFileClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

    procedure LoadClientPatchConfig(Sender: TObject);
    procedure PanelServerListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure AdvStringGrid2DblClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure AdvStringGrid2ButtonClick(Sender: TObject; ACol, ARow: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure N1Click(Sender: TObject);


    procedure InitSetBtnImgForm(Btn: TRzBmpButton);

    procedure DropMoveBtn(aHandle: THandle);
    procedure PrepareDrop;
    procedure Droping(btn: TRzBmpButton);
    procedure DropingLabel(l: TRzLabel);
    procedure DropOver;

    procedure BuildRagSkp(all: TMemoryStream);
    procedure DecodeSkn(skn, BackStream: TMemoryStream);
    
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure btnStartGameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzBmpButton3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzBmpButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEditGameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btNewAccountMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnChangePasswordMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnGetBackPasswordMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEditGameListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnStartGameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnStartGameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzBmpButton3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzBmpButton3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzBmpButton1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzBmpButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEditGameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnEditGameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btNewAccountMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btNewAccountMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnChangePasswordMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnChangePasswordMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnGetBackPasswordMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnGetBackPasswordMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnEditGameListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnEditGameListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ckWindowedMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel4MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabelStatusMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabelStatusMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabelStatusMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RzLabel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RzLabel2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure btnMinSizeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnMinSizeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnMinSizeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnColseMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnColseMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnColseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopStartGamePopup(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure PopWebSitePopup(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure PopZhuangBeiPopup(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure PopContactUsPopup(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure PopRegisterPopup(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure PopPassPopup(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure PopFindPassPopup(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure PopExitPopup(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure PanelProcessCurMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PanelProcessMaxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure cmbFileSaveDirExit(Sender: TObject);

  private  
  public
    FPoint: TPoint;
    FMouseDowned: Boolean;



    bShowStartGame,
    bShowWebSite,
    bShowZhuangBei,
    bShowContuctUs,
    bShowAccount,
    bShowChangePass,
    bShowGetBackPass,
    bShowEditGameList: Boolean;

    procedure ManipulateControl(Control: TControl; Shift: TShiftState; X, Y, Precision: Integer);

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  VMProtectSDK, Grobal2;

var
  sPath: string;
  //boBusy                    : boolean = False;
  mJpg: TMemoryStream;
  g_Buffer: array[0..16 * 1024] of Char;

function EncrypStr(Src, Key: string): string; //字符串加密函数
//对字符串加密(Src:源 Key:密匙)
var
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  dest: string;
  SrcPos: Integer;
  SrcAsc: Integer;
  Range: Integer;
begin
  KeyLen := Length(Key);
  if KeyLen = 0 then
    Key := VMProtectDecryptStringA('legendsoft');
  KeyPos := 0;
  Range := 256;
  Randomize;
  OffSet := 5; //Random(Range);
  dest := Format('%1.2x', [OffSet]);
  for SrcPos := 1 to Length(Src) do begin
    SrcAsc := (Ord(Src[SrcPos]) + OffSet) mod 255;
    if KeyPos < KeyLen then KeyPos := KeyPos + 1
    else KeyPos := 1;
    SrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    dest := dest + Format('%1.2x', [SrcAsc]);
    OffSet := SrcAsc;
  end;
  Result := dest;
end;

function DecrypStr(Src, Key: string): string; //字符串解密函数
var
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  dest: string;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
begin
  KeyLen := Length(Key);
  if KeyLen = 0 then Key := VMProtectDecryptStringA('legendsoft');
  KeyPos := 0;
  OffSet := StrToInt('$' + Copy(Src, 1, 2));
  SrcPos := 3;
  repeat
    SrcAsc := StrToInt('$' + Copy(Src, SrcPos, 2));
    if KeyPos < KeyLen then KeyPos := KeyPos + 1
    else KeyPos := 1;
    TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= OffSet then TmpSrcAsc := 255 + TmpSrcAsc - OffSet
    else TmpSrcAsc := TmpSrcAsc - OffSet;
    dest := dest + Chr(TmpSrcAsc);
    OffSet := SrcAsc;
    SrcPos := SrcPos + 2;
  until SrcPos >= Length(Src);
  Result := dest;
end;

function IsEmptyDir(sDir: String): Boolean;
var
  sr: TsearchRec;
begin
  Result := True;
  if Copy(sDir, Length(sDir) - 1, 1) <> '\' then sDir := sDir + '\';
  if FindFirst(sDir + '*.*', faAnyFile, sr) = 0 then
    repeat
    if (sr.Name <> '.') and (sr.Name <> '..') then
    begin
      Result := False;
      break;
    end;
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

function ZipDir(zipMode:Integer;MyZipName,MyZipDir:string):Boolean;
var zipTmp: TVCLZip;
  begin
    {压缩指定目录中的文件和文件夹，指定RootDir，否则连同指定目录本身一同压缩}
    Result:=False;
    zipTmp := TVCLZip.Create(nil);
    try
      with zipTmp do
      begin
        case zipMode of
          0:RootDir:='';   //指定压缩目录
          1:RootDir:=MyZipDir;
        end;
        OverwriteMode:=Always;//覆盖
        AddDirEntriesOnRecurse:=True;
        RelativePaths:=True;//相对路径
        Recurse:=True;//是否遍历
        RecreateDirs:=True;//创建目录
        StorePaths:=True;//保存路径，如RootDir不指定则保持完成路径（去除盘符外的，需要保持盘符路径设置StoreVolumes属性）
        ZipName:=MyZipName;
        FilesList.Add(MyZipDir+'\*.*');
        Zip;
        Result:=True;
      end;
    except
 
    end;
    zipTmp.Free;
  end;


procedure TFrmMain.DecodeSkn(skn, BackStream: TMemoryStream);
  procedure DecRzBmpButton(btnArray: array of TRzBmpButton; skn, dis, down, hot, up: TMemoryStream);
  var
    bc: BtnConf;
    tSize: Integer;
    i: Integer;
  begin
    for i := low(btnArray) to high(btnArray) do begin
      skn.Read(bc, Sizeof(bc));
      btnArray[i].Left := bc.Left;
      btnArray[i].Top := bc.Top + FIX_OFFSET_TOP;
      btnArray[i].Width := bc.Width;
      btnArray[i].Height := bc.Height;
      //btnArray[i].Visible := bc.bShow;

      dis.Clear; down.Clear; hot.Clear; up.Clear;
      skn.Read(tSize, Sizeof(Int64));
      dis.CopyFrom(skn, tSize);
      dis.Position := 0;
      btnArray[i].Bitmaps.Disabled.LoadFromStream(dis);

      skn.Read(tSize, Sizeof(Int64));
      down.CopyFrom(skn, tSize);
      down.Position := 0;
      btnArray[i].Bitmaps.Down.LoadFromStream(down);

      skn.Read(tSize, Sizeof(Int64));
      hot.CopyFrom(skn, tSize);
      hot.Position := 0;
      btnArray[i].Bitmaps.Hot.LoadFromStream(hot);

      skn.Read(tSize, Sizeof(Int64));
      up.CopyFrom(skn, tSize);
      up.Position := 0;
      btnArray[i].Bitmaps.Up.LoadFromStream(up);
    end;
  end;


var
  rc: RadioConf;
  lc: LabelConf;
  pc: PanelConf;
  bc: BtnConf;
  bSize, btnSize: Int64;
  downS, hotS, upS, disS: TMemoryStream;

  btnArr: Array[0..7] of TRzBmpButton;
begin
  btnArr[0] := btnStartGame;         btnArr[1] := RzBmpButton3;
  btnArr[2] := RzBmpButton1;         btnArr[3] := btnEditGame;
  btnArr[4] := btNewAccount;         btnArr[5] := btnChangePassword;
  btnArr[6] := btnGetBackPassword;   btnArr[7] := btnEditGameList;


  try
    downS := TMemoryStream.Create;
    hotS := TMemoryStream.Create;
    upS := TMemoryStream.Create;
    disS := TMemoryStream.Create;

    skn.Position := 0;
    skn.Read(rc, Sizeof(rc));
    ckWindowed.Left := rc.Left;
    ckWindowed.Top := rc.Top + FIX_OFFSET_TOP;
    ckWindowed.Checked := rc.bWindow;

    skn.Read(lc, Sizeof(lc));//屏幕分辨率标签
    RzLabel4.Left := lc.Left;
    RzLabel4.Top := lc.Top + FIX_OFFSET_TOP;

    skn.Read(lc, Sizeof(lc));//当前状态标签
    RzLabel3.Left := lc.Left;
    RzLabel3.Top := lc.Top + FIX_OFFSET_TOP;

    skn.Read(lc, Sizeof(lc));//请选择服务器登陆
    RzLabelStatus.Left := lc.Left;
    RzLabelStatus.Top := lc.Top + FIX_OFFSET_TOP;

    skn.Read(lc, Sizeof(lc));//当前文件
    
    RzLabel1.Left := lc.Left;
    RzLabel1.Top := lc.Top + FIX_OFFSET_TOP;

    skn.Read(lc, Sizeof(lc));//所有文件
    RzLabel2.Left := lc.Left;
    RzLabel2.Top := lc.Top + FIX_OFFSET_TOP;

    skn.Read(pc, Sizeof(pc));//服务器列表
    PanelServerList.Left := pc.Left;
    PanelServerList.Top := pc.Top + FIX_OFFSET_TOP;
    PanelServerList.Width := pc.Width;
    PanelServerList.Height := pc.Height;

    skn.Read(pc, Sizeof(pc));//网站公告
    {bf.WebBrowser.Left := pc.Left;
    bf.WebBrowser.Top := pc.Top;
    bf.WebBrowser.Width := pc.Width;
    bf.WebBrowser.Height := pc.Height;}

    PanelWebBrowser.Left := pc.Left;
    PanelWebBrowser.Top := pc.Top + FIX_OFFSET_TOP;
    PanelWebBrowser.Width := pc.Width;
    PanelWebBrowser.Height := pc.Height;

    skn.Read(pc, Sizeof(pc)); //游戏分辨率ComboBox
    Panel2.Left := pc.Left;
    Panel2.Top := pc.Top + FIX_OFFSET_TOP;
    Panel2.Width := pc.Width;
    Panel2.Height := pc.Height;

    skn.Read(pc, Sizeof(pc));//当前文件
    PanelProcessCur.Left := pc.Left;
    PanelProcessCur.Top := pc.Top + FIX_OFFSET_TOP;
    PanelProcessCur.Width := pc.Width;
    PanelProcessCur.Height := pc.Height;


    skn.Read(pc, Sizeof(pc)); //所有文件
    PanelProcessMax.Left := pc.Left;
    PanelProcessMax.Top := pc.Top + FIX_OFFSET_TOP;
    PanelProcessMax.Width := pc.Width;
    PanelProcessMax.Height := pc.Height;
    skn.Read(bSize, Sizeof(Int64));

    BackStream.CopyFrom(skn, bSize);
    BackStream.Position := 0;

    skn.Read(bc, Sizeof(bc)); //最小化按钮
    btnMinSize.Left := bc.Left;
    btnMinSize.Top := bc.Top + FIX_OFFSET_TOP;
    btnMinSize.Width := bc.Width;
    btnMinSize.Height := bc.Height;
   // btnMinSize.Visible := bc.bShow;

    ////////

    skn.Read(btnSize, Sizeof(Int64));
    downS.CopyFrom(skn, btnSize);
    downS.Position := 0;
    btnMinSize.Bitmaps.Down.LoadFromStream(downS);

    skn.Read(btnSize, Sizeof(Int64));
    hotS.CopyFrom(skn, btnSize);
    hotS.Position := 0;
    btnMinSize.Bitmaps.Hot.LoadFromStream(hotS);

    skn.Read(btnSize, Sizeof(Int64));
    upS.CopyFrom(skn, btnSize);
    upS.Position := 0;
    btnMinSize.Bitmaps.Up.LoadFromStream(upS);

    skn.Read(bc, Sizeof(bc)); //关闭按钮
    btnColse.Left := bc.Left;
    btnColse.Top := bc.Top + FIX_OFFSET_TOP;
    btnColse.Width := bc.Width;
    btnColse.Height := bc.Height;
    //btnColse.Visible := bc.bShow;

    downS.Clear; hotS.Clear; upS.Clear;
    skn.Read(btnSize, Sizeof(Int64));
    downS.CopyFrom(skn, btnSize);
    downS.Position := 0;
    btnColse.Bitmaps.Down.LoadFromStream(downS);

    skn.Read(btnSize, Sizeof(Int64));
    hotS.CopyFrom(skn, btnSize);
    hotS.Position := 0;
    btnColse.Bitmaps.Hot.LoadFromStream(hotS);

    skn.Read(btnSize, Sizeof(Int64));
    upS.CopyFrom(skn, btnSize);
    upS.Position := 0;
    btnColse.Bitmaps.Up.LoadFromStream(upS);
    DecRzBmpButton(btnArr, skn, disS, downS, hotS, upS);
     
  finally
    downS.Free;
    hotS.Free;
    upS.Free;
    disS.Free;
  end;


end;


procedure TfrmMain.ManipulateControl(Control: TControl; Shift: TShiftState; X, Y, Precision: Integer);
var
  sc_manipulate: word;
begin
  if (X <= Precision) and (Y > Precision) and (Y < Control.height - Precision) then begin
    sc_manipulate := $F001;
    Control.Cursor := crsizewe;
  end
  else if (X >= Control.width - Precision) and (Y > Precision) and (Y < Control.height - Precision) then begin
    sc_manipulate := $F002;
    Control.Cursor := crsizewe;
  end
  else if (X > Precision) and (X < Control.width - Precision) and (Y <= Precision) then begin
    sc_manipulate := $F003;
    Control.Cursor := crsizens;
  end
  else if (X <= Precision) and (Y <= Precision) then begin
    sc_manipulate := $F004;
    Control.Cursor := crsizenwse;
  end
  else if (X >= Control.width - Precision) and (Y <= Precision) then begin
    sc_manipulate := $F005;
    Control.Cursor := crsizenesw;
  end
  else if (X > Precision) and (X < Control.width - Precision) and (Y >= Control.height - Precision) then begin
    sc_manipulate := $F006;
    Control.Cursor := crsizens;
  end
  else if (X <= Precision) and (Y >= Control.height - Precision) then begin
    sc_manipulate := $F007;
    Control.Cursor := crsizenesw;
  end
  else if (X >= Control.width - Precision) and (Y >= Control.height - Precision) then begin
    sc_manipulate := $F008;
    Control.Cursor := crsizenwse;
  end
  //else if (X > 5) and (Y > 5) and (X < Control.width - 5) and (Y < Control.height - 5) then begin
  else if (X > 1) and (Y > 1) and (X < Control.width - 1) and (Y < Control.height - 1) then begin
    sc_manipulate := $F009;
    Control.Cursor := crsizeall;
  end
  else begin
    sc_manipulate := $F000;
    Control.Cursor := crdefault;
  end;
  if Shift = [ssleft] then begin
    ReleaseCapture;
    Control.perform(wm_syscommand, sc_manipulate, 0);
  end;
end;

procedure TfrmMain.MenuItem1Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtNewAccount);
end;

procedure TfrmMain.MenuItem3Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnChangePassWord);
end;

procedure TfrmMain.MenuItem5Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnGetBackPassWord);
end;

procedure TfrmMain.MenuItem7Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnEditGameList);
end;

procedure TfrmMain.N10Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnColse);
end;

procedure TfrmMain.N12Click(Sender: TObject);
begin
  N12.Checked := not n12.Checked;
  bShowAccount := n12.Checked;
end;

procedure TfrmMain.N14Click(Sender: TObject);
begin
  n14.Checked := not n14.Checked;
  bShowChangePass := n14.Checked;
end;

procedure TfrmMain.N16Click(Sender: TObject);
begin
  n16.Checked := not n16.Checked;
  bShowGetBackPass := n16.Checked;
end;

procedure TfrmMain.N18Click(Sender: TObject);
begin
  n18.Checked := not n18.Checked;
  bShowEditGameList := n18.Checked;
end;

procedure TfrmMain.N1Click(Sender: TObject);
var
  FrmSetBtn: TFrmSetBtnImage;
begin
  {FrmSetBtn := TFrmSetBtnImage.Create(Application);
  FrmSetBtn.Image1.Picture.Bitmap.Assign(BtnStartGame.Bitmaps.Up);
  FrmSetBtn.Image2.Picture.Bitmap.Assign(BtnStartGame.Bitmaps.Hot);
  FrmSetBtn.Image3.Picture.Bitmap.Assign(BtnStartGame.Bitmaps.Down);
  FrmSetBtn.Image4.Picture.Bitmap.Assign(BtnStartGame.Bitmaps.Disabled);
  FrmSetBtn.ShowModal(); }

  //if Sender is TRzBmpButton then ShowMessage((Sender as TRzBmpButton).Caption);
    InitSetBtnImgForm(BtnStartGame);
end;

procedure TfrmMain.N2Click(Sender: TObject);
begin
  n2.Checked := not n2.Checked;
  bShowStartGame := n2.Checked;
end;

procedure TfrmMain.N3Click(Sender: TObject);
begin
  InitSetBtnImgForm(RzBmpButton3);
end;

procedure TfrmMain.N4Click(Sender: TObject);
begin
  n4.Checked := not n4.Checked;
  bShowWebSite := n4.Checked;
end;

procedure TfrmMain.N5Click(Sender: TObject);
begin
  InitSetBtnImgForm(RzBmpButton1);
end;

procedure TfrmMain.N6Click(Sender: TObject);
begin
  n6.Checked := not n6.Checked;
  bShowZhuangBei := n6.Checked;
end;

procedure TfrmMain.N7Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnEditGame);
end;

procedure TfrmMain.N8Click(Sender: TObject);
begin
  n8.Checked := not n8.Checked;
  bShowContuctUs := n8.Checked;
end;

procedure TfrmMain.N9Click(Sender: TObject);
begin
  InitSetBtnImgForm(BtnMinSize);
end;

function SetResInfo(ResType, ResName, ResNewName: string): Boolean;
var
  PlugRes: TResourceStream;
begin
  try
    PlugRes := TResourceStream.Create(Hinstance, ResName, PChar(ResType));
    try
      PlugRes.SavetoFile(ResNewName);
      Result := true;
    finally
      PlugRes.Free;
    end;
  except
    Result := False;
  end;
end;

var
  g_ts: TStringList;

procedure TfrmMain.ListView1Click(Sender: TObject);
begin
  if ListView1.Items.Count>0 then
  begin
     if ListView1.Selected <> nil then
     begin
        RadGFileLX.ItemIndex := strtoint(ListView1.Selected.SubItems[0]);
        cmbFileSaveDir.Text := ListView1.Selected.SubItems[1];
        EdtFileName.Text := ListView1.Selected.SubItems[2];
        EdtFileCRC.Text := ListView1.Selected.SubItems[3];
        EdtFileDownURL.Text := ListView1.Selected.SubItems[4];
     end;
  end;
end;

procedure TfrmMain.LoadClientPatchConfig(Sender: TObject);
var
  nCount: Integer;
  hal: TCellHalign;
  Val: TCellValign;
  ls: TStringList;
  sLine, sFileName, sRadioIdx, scbState: string;
  i, nRadioIdx, ncbState: Integer;
begin
  AdvStringGrid2.Clear;
  AdvStringGrid2.ColCount := 6;
  frmMain.AdvStringGrid2.Cells[0, 0] := '集成补丁文件路径  (双击取消)';
  frmMain.AdvStringGrid2.Cells[1, 0] := '释放补丁到...';
  frmMain.AdvStringGrid2.Cells[2, 0] := '预留';
  frmMain.AdvStringGrid2.Cells[3, 0] := '预留';
  frmMain.AdvStringGrid2.Cells[4, 0] := '预留';
  frmMain.AdvStringGrid2.Cells[5, 0] := '预留';

  g_ts := TStringList.Create;
  g_ts.Add('传奇目录     ');
  g_ts.Add('传奇Data目录     ');
  g_ts.Add('登陆器目录');

  hal := haRight;
  Val := vaFull;

  for nCount := 1 to AdvStringGrid2.RowCount - 1 do begin
    frmMain.AdvStringGrid2.AddButton(0, nCount, 30, 23, IntToStr(nCount), hal, Val);
    frmMain.AdvStringGrid2.AddRadio(1, nCount, 1, 0, g_ts);
    //frmMain.AdvStringGrid2.AddProgress(2, nCount, clLime, clWhite);
    frmMain.AdvStringGrid2.AddCheckBox(2, nCount, False, False);
    frmMain.AdvStringGrid2.AddCheckBox(3, nCount, False, False);
    frmMain.AdvStringGrid2.AddCheckBox(4, nCount, False, False);
    frmMain.AdvStringGrid2.AddCheckBox(5, nCount, False, False);
  end;

  nCount := 0;
  ls := TStringList.Create;

  if FileExists('.\PatchServerInfo.txt') then begin
    ls.LoadFromFile('.\PatchServerInfo.txt');
    for i := 0 to ls.Count - 1 do
      if ls[i] <> '' then
        MemoPatchSvrIP.Lines.Add(ls[i]);
  end;

  ls.Clear;
  if FileExists('.\ClientPatch.txt') then
    ls.LoadFromFile('.\ClientPatch.txt');

  for i := 0 to ls.Count - 1 do begin
    sLine := ls[i];
    if sLine = '' then
      Continue;
    sLine := GetValidStr3(sLine, sFileName, ['|']);
    sLine := GetValidStr3(sLine, sRadioIdx, ['|']);
    sLine := GetValidStr3(sLine, scbState, ['|']);

    nRadioIdx := StrToInt(sRadioIdx);
    ncbState := StrToInt(scbState);

    AdvStringGrid2.Cells[0, i + 1] := sFileName;
    AdvStringGrid2.SetRadioIdx(1, i + 1, nRadioIdx);
    AdvStringGrid2.SetCheckBoxState(2, i + 1, ncbState = 1);
  end;
  ls.Free;

end;

procedure TfrmMain.AdvStringGrid2ButtonClick(Sender: TObject; ACol, ARow: Integer);
begin
  if not OpenDialog3.Execute then Exit;

  frmMain.AdvStringGrid2.Cells[ACol, ARow] := OpenDialog3.FileName;
end;

procedure TfrmMain.AdvStringGrid2DblClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if ARow <> 0 then
    frmMain.AdvStringGrid2.Cells[ACol, ARow] := '';
end;

procedure TfrmMain.btnChangePasswordMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btnChangePasswordMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Droping(btnChangePassword);
end;

procedure TfrmMain.btnChangePasswordMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnColseMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.btnColseMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btnColse);
end;

procedure TfrmMain.btnColseMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnCreatePlugClick(Sender: TObject);
var
  rPlugRes: TResourceStream;
  mStream: TMemoryStream;
  sStream: TMemoryStream;
  sSrcDir: string;
  pn: PInteger;
  cfg: TLoginToolConfig;//登陆器设置
  cmds: TCliCmdLines;
  i, ii, n: Integer;

  p: pTCItemRule;
  t: TCItemRule;
  ls: TStringList;
  b2, b3, b4: Boolean;
  aaa: array of TCItemRule;
  buffer, buffer2: Pointer;
  nn, nSize, nSize2: Integer;

  nSign: Integer;
  DosHeader: TImageDosHeader;//MZ格式的文件头
  NTHeader: TImageNtHeaders;
  nAddress: Integer;
  HeaderSum: DWORD;
  CheckSum: DWORD;

  fcbState: Boolean;
  sFileName, sFileNameOnly: string;
  Indexs: array of Integer;
  ClientPatch: TClientPatch;
  nCount, nOffset, nRadioIdx, nBuffSize, nBuffSize2: Integer;
  szIP, szPort, szLine: string;
  nPort: Integer;
  szParam: string;
  szRoute: string;
  fHandle: THandle;
  edHeader, EDHeader2: TedHeader;
  DCP_mars: TDCP_mars;
  pszBufPtr: PChar;
  pszBuffer: array[0..1024 * 16 - 1] of Char;
  dumpy: array[0..99] of byte;

  sf: string;
  nexe,patch,  skp: TMemoryStream;
 
  lensk: Int64;
  lensk2: Int64; // add 2019-10-12
  LoginData: TLoginData;
  tmpFileNamePatch: String;
  tmpFileNameMir: String;
  md5Count: Integer;
  md5Result: String;
  IniConfig: TIniFile;
begin
{$I VMPB.inc}


  if (Trim(Edit1.Text) = '') then begin
    Application.MessageBox('登陆器名字不能为空！', '错误信息', MB_ICONERROR + MB_OK);
    Exit;
  end;

  if ImageMain.Picture = nil then
  begin
    Application.MessageBox('背景图片不能为空！请选择一张背景图片或读取一套皮肤', '错误信息', MB_ICONERROR + MB_OK);
    Exit;
  end;

  scrollbox1.VertScrollBar.Position := 0;
  scrollbox1.HorzScrollBar.Position := 0;
  try
    IniConfig := TIniFile.Create(ExtractFilePath(application.ExeName) + DEFAULT_CFG);
    IniConfig.WriteString('SETTING','LOGIN_NAME',Edit1.text);
    IniConfig.WriteString('SETTING','MASTER_SERVER',EdtMaster.text);
    IniConfig.WriteString('SETTING','SLAVE_SERVER',EdtSlave.text);
    IniConfig.WriteString('SETTING','UPDATE_SERVER',EdtUpdate.text);
    IniConfig.WriteString('SETTING','WEB_SITE',EdtWebSite.text);
    IniConfig.WriteString('SETTING','WEB_NOTICE',EdtGG.text);
    IniConfig.WriteString('SETTING','VIP_ITEMS',EdtItems.text);
    IniConfig.WriteString('SETTING','CONTACT_US',EdtContactUs.text);
    IniConfig.WriteString('SETTING','CORE_COUNT',EdtCount.text);
    if CheckBox3.Checked then
    begin
      IniConfig.WriteBool('SETTING','WIS_CHECK',True);
    end
    else
    begin
      IniConfig.WriteBool('SETTING','WIS_CHECK',False);
    end;

    if CheckBox4.Checked then
    begin
      IniConfig.WriteBool('SETTING','WIL_CHECK',True);
    end
    else
    begin
      IniConfig.WriteBool('SETTING','WIL_CHECK',False);
    end;

    if CheckBox5.Checked then
    begin
      IniConfig.WriteBool('SETTING','WZL_CHECK',True);
    end
    else
    begin
      IniConfig.WriteBool('SETTING','WZL_CHECK',False);
    end;

  finally
    if IniConfig <> nil then IniConfig.Free;
  end;


  //登录器和登录网关被编译成资源，存在于登录配置器的资源段内，这里是根据资源名称
  //LoginTool，从登录配置器的资源段内读出登录器

    rPlugRes := TResourceStream.Create(Hinstance, 'ResData', 'LoginTool');
    if rPlugRes <> nil then begin
      sStream := TMemoryStream.Create;
      sStream.LoadFromStream(rPlugRes);//把登录器读入到sStream中
      //sStream.Free;
    end;

    //M2也被编译成资源，保存在登录配置器的资源段中，从资源段中，根据名字M2，读出M2.exe

    rPlugRes := TResourceStream.Create(Hinstance, 'ResData', 'Mir2');  // 2019-10-11

    if rPlugRes <> nil then begin
      mStream := TMemoryStream.Create;
      mStream.LoadFromStream(rPlugRes);//把M2.EXE读到mStream中
     // mStream.Free;
    end;
    

    sf := Trim(Edit1.Text) + '.exe';
    try
      skp := TMemoryStream.Create;
      patch := TMemoryStream.create;
      nexe := TMemoryStream.Create;

      LoginData.loginName := Edit1.Text;
      LoginData.urlMaster := EdtMaster.Text;
      LoginData.urlSlave :=  EdtSlave.Text;
      LoginData.urlUpdate := EdtUpdate.Text;
      LoginData.webSite := EdtWebSite.Text;
      LoginData.urlZB := EdtItems.Text;
      LoginData.urlKF := EdtContactUS.Text;
      LoginData.urlGG := EdtGG.Text;
      LoginData.OpenCount := min(StrToInt(EdtCount.Text),high(byte));

      LoginData.ResourceRead := 0;
      if CheckBox3.Checked then
        LoginData.ResourceRead := LoginData.ResourceRead or 1;//CheckBox3是读取Wis标志
      if CheckBox4.Checked then
        LoginData.ResourceRead := LoginData.ResourceRead or 2;//CheckBox4是读取Wil标志
      if CheckBox5.Checked then
        LoginData.ResourceRead := LoginData.ResourceRead or 4;//CheckBox是读取Wzl标志

      LoginData.MicroAddress := EdtMicroAddress.Text;
      LoginData.MicroPort := EdtMicroPort.Value;
      LoginData.MicroMode := RadioGroup1.ItemIndex;
      LoginData.showCoreVersion := ChkCoreVersion.Checked;

     

      md5Result := '';
      md5Result := Edit1.text;

      for md5Count := 0 to 9 do
      begin
        md5Result := MD5Print(MD5String(md5Result))  //MD5加密十次
      end;
      md5Result := copy(md5Result,1,9)+'A'+copy(md5Result,11,9)+'C'+copy(md5Result,21,12); //MD5十次之后，第十位替换成加密位A，第二十位替换成加密位C，判断程序是否破坏
      LoginData.CoreChkStr := VMProtectDecryptStringA(pchar(md5Result));


      BuildRagSkp(skp);


      nexe.Size := 0;
      nexe.Size := sStream.Size + mStream.Size + skp.Size + SizeOf(TLoginData);
      nexe.Position := 0;
      sStream.Position := 0;
      mStream.Position := 0;
      skp.Position := 0;

      LoginData.loginToolOffset := 0;
      LoginData.loginToolSize := sStream.size;
      nexe.copyFrom(sStream, sStream.Size);

      LoginData.mirOffset := nexe.Position;
      LoginData.mirSize := mStream.Size;
      nexe.copyFrom(mStream, mStream.Size);// add 2019-10-12

      LoginData.skinOffset := nexe.Position;
      LoginData.skinSize := skp.Size;
      nexe.CopyFrom(skp, skp.Size);
     
      if not DirectoryExists(extractFilePath(Application.ExeName) + PATCH_DIRNAME) then
      begin
        CreateDirectory(pchar(extractFilePath(Application.ExeName) + PATCH_DIRNAME),nil);//如果不存在补丁文件夹，则创建一个空的补丁文件夹
      end;

      if not IsEmptyDir(extractFilePath(Application.ExeName) + PATCH_DIRNAME) then
      begin
        tmpFileNamePatch := '_Patch' + inttostr(Random(999999999)) + '.zip';
        ZipDir(1,tmpFileNamePatch,PATCH_DIRNAME);  //补丁为固定目录名称
        patch.LoadFromFile(tmpFileNamePatch);
        deleteFile(tmpFileNamePatch);
        patch.Position := 0;
        LoginData.corePatchOffset := nexe.Position;
        LoginData.corePatchSize := patch.Size;
        //nexe.CopyFrom(patch,patch.Size);
        nexe.Write(patch.Memory^ , patch.Size); 
      end
      else
      begin
        LoginData.corePatchOffset := 0;
        LoginData.corePatchSize := 0;
      end;

      nexe.Write(LoginData,SizeOf(TLoginData)); 
      nexe.Position := 0;
      nexe.SaveToFile(sf);                              //如果Patch不存在则只写入LoginData,Offset=0,size=0
      //最后组成形式为 98K= LoginTool.exe+Mir2.exe+Skin+corePatch+SizeOf(TLoginData)
      Showmessage(sf+'已生成在本目录下');
    finally
      skp.Free;
      mStream.Free;
      sStream.Free;
      patch.Free;
      nexe.Free;
    end;


{$I VMPE.inc}
end;

procedure TfrmMain.btnEditGameListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btnEditGameListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Droping(btnEditGameList);
end;

procedure TfrmMain.btnEditGameListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnEditGameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btnEditGameMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btnEditGame);
end;

procedure TfrmMain.btnEditGameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btNewAccountMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btNewAccountMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btNewAccount);
end;

procedure TfrmMain.btNewAccountMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnGetBackPasswordMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.btnGetBackPasswordMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  Droping(btnGetBackPassword);
end;

procedure TfrmMain.btnGetBackPasswordMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnLoadFromDBClick(Sender: TObject);
var
  nCount: Integer;
begin
  AdvStringGrid1.Clear;
  frmMain.AdvStringGrid1.Cells[0, 0] := '物品名称';
  frmMain.AdvStringGrid1.Cells[1, 0] := '物品类别';
  frmMain.AdvStringGrid1.Cells[2, 0] := '极品显示';
  frmMain.AdvStringGrid1.Cells[3, 0] := '自动拾取';
  frmMain.AdvStringGrid1.Cells[4, 0] := '显示名字';

  frmMain.AdvStringGrid1.Cells[0, 1] := '金币';
  frmMain.AdvStringGrid1.Cells[1, 1] := '其他类';
  frmMain.AdvStringGrid1.AddCheckBox(2, 1, False, False);
  frmMain.AdvStringGrid1.AddCheckBox(3, 1, true, False);
  frmMain.AdvStringGrid1.AddCheckBox(4, 1, true, False);

  if g_LocalDBE = nil then
    g_LocalDBE := TLocalDB.Create();
  g_LocalDBE.Query.DatabaseName := EditDBName.Text;

  g_LocalDBE.LoadFromItemsDB;

end;

procedure TfrmMain.btnMinSizeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.btnMinSizeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btnMinSize);
end;

procedure TfrmMain.btnMinSizeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.btnSaveToFileClick(Sender: TObject);
var
  i, n: Integer;
  p: pTCItemRule;
  ls: TStringList;
  b2, b3, b4: Boolean;
begin
  //if SaveDialog1.Execute then begin
  ls := TStringList.Create;
  for i := 1 to (AdvStringGrid1.RowCount - 1) do begin
    //AdvStringGrid1.SavetoFile('.\lsDefaultItemFilter.txt');
    if CompareText(AdvStringGrid1.Cells[1, i], '服装类') = 0 then
      n := 0
    else if CompareText(AdvStringGrid1.Cells[1, i], '武器类') = 0 then
      n := 1
    else if CompareText(AdvStringGrid1.Cells[1, i], '首饰类') = 0 then
      n := 2
    else if CompareText(AdvStringGrid1.Cells[1, i], '药品类') = 0 then
      n := 3
    else
      n := 4;

    b2 := False;
    b3 := False;
    b4 := False;
    AdvStringGrid1.GetCheckBoxState(2, i, b2);
    AdvStringGrid1.GetCheckBoxState(3, i, b3);
    AdvStringGrid1.GetCheckBoxState(4, i, b4);

    ls.Add(Format('%s,%d,%d,%d,%d', [
      AdvStringGrid1.Cells[0, i],
        n,
        Byte(b2),
        Byte(b3),
        Byte(b4)
        ]));
  end;
  ls.SavetoFile('.\lsDefaultItemFilter.txt');
  ls.Free;
  Application.MessageBox('lsDefaultItemFilter.tx 已生成在本目录下！', '信息', MB_ICONINFORMATION + MB_OK);
  //end;
end;

procedure TfrmMain.btnStartGameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //ReleaseCapture();
  //SendMessage((Sender as TRzBmpButton).Handle{btnStartGame.Handle}, WM_SYSCOMMAND, $F012, 0);
  //DropMoveBtn((Sender as TRzBmpButton).Handle);

  PrepareDrop;
end;

procedure TfrmMain.btnStartGameMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(btnStartGame);
end;

procedure TfrmMain.btnStartGameMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.Button10Click(Sender: TObject);
var all: TMemoryStream;
begin
  if ImageMain.Picture.Graphic <> nil then begin
    try
      all := TMemoryStream.Create;
      BuildRagSkp(all);
      all.Position := 0;
      all.SaveToFile(ExtractFilePath(Application.ExeName)+DEFAULT_SKIN);
      Application.MessageBox('保存默认皮肤完成！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
    finally
      all.Free;
    end;
  end
  else
    Application.MessageBox('请选择一幅背景图片！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain.Button11Click(Sender: TObject);
 var TItem: TListItem;
begin
  TItem := ListView1.Items.Add;
  TItem.Caption := inttoStr(ListView1.Items.Count);
  TItem.SubItems.Add(intToStr(RadGFileLX.ItemIndex));
  TItem.SubItems.Add(cmbFileSaveDir.Text);
  TItem.SubItems.Add(EdtFileName.Text);
  TItem.SubItems.Add(EdtFileCRC.Text);
  TItem.SubItems.Add(EdtFileDownURL.Text);
end;

procedure TfrmMain.Button13Click(Sender: TObject);
begin
  if openFileDlg.Execute() then
  begin
    EdtFileName.Text := ExtractFileName(openFileDlg.FileName);
    EdtFileCRC.text := IntToHex(CalcFileCRC(openFileDlg.FileName),8);
  end;
end;

procedure TfrmMain.Button14Click(Sender: TObject);
var
  i:Integer;
  s,s0,s1,s2,s3,s4:String;
  StringList: TStringList;
  TItem: TListItem;
begin
  StringList := TStringList.Create;
  if openUpdateDlg.Execute then
  begin
     StringList.LoadFromFile(openUpdateDlg.FileName);
     if StringList.Count >0 then
     begin
        ListView1.Clear;
     end;
        
     for i := 0 to StringList.Count - 1 do
     begin
       s := StringList[i];
       s := GetValidStr3(s, s0, [#9]);
       s := GetValidStr3(s, s1, [#9]);
       s := GetValidStr3(s, s2, [#9]);
       s := GetValidStr3(s, s3, [#9]);
       s := GetValidStr3(s, s4, [#9]);
       TItem := ListView1.Items.Add;
       TItem.Caption := inttoStr(ListView1.Items.Count);
       TItem.SubItems.Add(s0);
       TItem.SubItems.Add(s1);
       TItem.SubItems.Add(s2);
       TItem.SubItems.Add(s3);
       TItem.SubItems.Add(s4);
     end;  
  end;
  StringList.Free;
end;

procedure TfrmMain.Button15Click(Sender: TObject);
var i:Integer;
    StringList: TStringList;
    sLine: String;
begin
  StringList := TStringList.Create;
  for I := 0 to ListView1.Items.Count - 1 do
  begin
    sLine := '';
    sLine := sLine + ListView1.Items[i].SubItems[0] + #9;
    sLine := sLine + ListView1.Items[i].SubItems[1] + #9;
    sLine := sLine + ListView1.Items[i].SubItems[2] + #9;
    sLine := sLine + ListView1.Items[i].SubItems[3] + #9;
    sLine := sLine + ListView1.Items[i].SubItems[4] ;
    StringList.Add(sLine)
  end;
  StringList.SaveToFile(ExtractFilePath(application.ExeName) + DEFAULT_UPDATELIST);
  StringList.Free;
  Application.MessageBox(DEFAULT_UPDATELIST+'更新列表文件保存完成！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
  i, n: Integer;
  s, s0, s1, s2, s3, s4: string;
  st: string;
  p: pTCItemRule;
  ls: TStringList;
begin
  //if SaveDialog1.Execute then begin
  OpenDlg.InitialDir := ExtractFilePath(Application.ExeName);
  if not OpenDlg.Execute(Handle) then Exit;

  ls := TStringList.Create;
  ls.LoadFromFile(OpenDlg.FileName);
  AdvStringGrid1.RowCount := ls.Count + 1;

  for i := 0 to ls.Count - 1 do begin
    s := ls[i];
    s := GetValidStr3(s, s0, [',']);
    s := GetValidStr3(s, s1, [',']);
    s := GetValidStr3(s, s2, [',']);
    s := GetValidStr3(s, s3, [',']);
    s := GetValidStr3(s, s4, [',']);

    if s1 = '0' then
      st := '服装类'
    else if s1 = '1' then
      st := '武器类'
    else if s1 = '2' then
      st := '首饰类'
    else if s1 = '3' then
      st := '药品类'
    else if s1 = '4' then
      st := '其他类';

    AdvStringGrid1.Cells[0, i + 1] := s0;
    AdvStringGrid1.Cells[1, i + 1] := st;
    AdvStringGrid1.AddCheckBox(2, i + 1, s2 = '1', False);
    AdvStringGrid1.AddCheckBox(3, i + 1, s3 = '1', False);
    AdvStringGrid1.AddCheckBox(4, i + 1, s4 = '1', False);

  end;
  ls.Free;
  Application.MessageBox('导入完成！', '信息', MB_ICONINFORMATION + MB_OK);
  //end;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  i, n, nn: Integer;
  b: Boolean;
begin
  if Sender = Button2 then begin
    n := 2;
    b := true;
  end else if Sender = Button3 then begin
    n := 3;
    b := true;
  end else if Sender = Button4 then begin
    n := 4;
    b := true;
  end else if Sender = Button5 then begin
    n := 2;
    b := False;
  end else if Sender = Button6 then begin
    n := 3;
    b := False;
  end else if Sender = Button7 then begin
    n := 4;
    b := False;
  end;

  nn := AdvStringGrid1.RowCount - 1;
  for i := 1 to nn do begin
    AdvStringGrid1.SetCheckBoxState(n, i, b);
  end;
end;

procedure TfrmMain.Button8Click(Sender: TObject);
var
   sknStream : TMemoryStream;
   bgImgStream: TMemoryStream;
   tmpRnd: Integer;
begin
   sknStream := TMemoryStream.Create;
   bgImgStream := TMemoryStream.Create;
   if sknLoadDlg.Execute() then
   begin
     sknStream.LoadFromFile(sknLoadDlg.FileName);
     sknStream.Position := 0;
     DecodeSkn(sknStream,bgImgStream); //恢复皮肤
     bgImgStream.Position := 0;
     tmpRnd := Random(999999999);
     bgImgStream.SaveToFile('_Temp' + inttostr(tmpRnd)+'.png');
     ImageMain.Picture.LoadFromFile('_Temp' + inttostr(tmpRnd)+'.png');
     deleteFile('_Temp' + inttostr(tmpRnd)+'.png');
     btnCreatePlug.Enabled := true;
     button9.Enabled := True;
     button10.Enabled := True;
   end;
   sknStream.Free;
   bgImgStream.Free;
end;

procedure TfrmMain.Button9Click(Sender: TObject);
var
  all: TMemoryStream;
begin

  if ImageMain.Picture.Graphic <> nil then begin
    try
      all := TMemoryStream.Create;
      BuildRagSkp(all);
      all.Position := 0;
      if sknSaveDlg.execute then
      begin
        all.SaveToFile(sknSaveDlg.FileName);
        Application.MessageBox('皮肤另存为完成！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
      end;
    finally
      all.Free;
    end;
  end
  else
    Application.MessageBox('请选择一幅背景图片！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmMain.BuildRagSkp(all: TMemoryStream);
  procedure AddRzBmpButton(btnArray: array of TRzBmpButton; showArray: array of Boolean;
    All, dis, down, hot, up: TMemoryStream);
  var
    bc: BtnConf;
    tSize: Integer;
    i: Integer;
  begin
    for I := low(btnArray) to high(btnArray) do begin

      {bc.Left := btnStartGame.Left;
      bc.Top := btnStartGame.Top - Panel1.Height;
      bc.Width := btnStartGame.Width;
      bc.Height := btnStartGame.Height;
      bc.bShow := bShowStartGame;//这个参数的值从皮肤文件中读出，通过按钮右键菜单上设置}

      bc.Left := btnArray[i].Left;
      bc.Top := btnArray[i].Top;
      bc.Width := btnArray[i].Width;
      bc.Height := btnArray[i].Height;
      bc.bShow := showArray[i];//这个参数的值从皮肤文件中读出，通过按钮右键菜单上设置


      All.Write(bc, Sizeof(bc));

      dis.Clear; down.Clear; hot.Clear; up.Clear;
      {btnStartGame.Bitmaps.Disabled.SaveToStream(dis);
      btnStartGame.Bitmaps.Down.SaveToStream(down);
      btnStartGame.Bitmaps.Hot.SaveToStream(hot);
      btnStartGame.Bitmaps.Up.SaveToStream(up);}

      btnArray[i].Bitmaps.Disabled.SaveToStream(dis);
      btnArray[i].Bitmaps.Down.SaveToStream(down);
      btnArray[i].Bitmaps.Hot.SaveToStream(hot);
      btnArray[i].Bitmaps.Up.SaveToStream(up);

      tSize := dis.Size;
      All.Write(tSize, Sizeof(Int64));
      dis.Position := 0;
      All.CopyFrom(dis, dis.Size);

      tSize := down.Size;
      All.Write(tSize, Sizeof(Int64));
      down.Position := 0;
      All.CopyFrom(down, down.Size);

      tSize := hot.Size;
      All.Write(tSize, Sizeof(Int64));
      hot.Position := 0;
      All.CopyFrom(hot, hot.Size);

      tSize := up.Size;
      All.Write(tSize, Sizeof(Int64));
      up.Position := 0;
      All.CopyFrom(up, up.Size);
    end;
  end;

var
  //AllStream: TMemoryStream;
  BackStream: TMemoryStream;//保存背景图片
  TStream: TMemoryStream;//临时内存流

  disStream: TMemoryStream; //按钮的禁用图片
  downStream: TMemoryStream;//按钮的按下图片
  hotStream: TMemoryStream; //按钮的鼠标划过图片
  upStream: TMemoryStream; //按钮的弹起图片

  rc: RadioConf;
  lc, tc: LabelConf;
  pc, tpc: PanelConf;
  bc, tbc: BtnConf;
  bSize, tSize: Int64;

  btnArr: Array[0..7] of TRzBmpButton;
  showArr: Array[0..7] of Boolean;
begin
  btnArr[0] := btnStartGame;         btnArr[1] := RzBmpButton3;
  btnArr[2] := RzBmpButton1;         btnArr[3] := btnEditGame;
  btnArr[4] := btNewAccount;         btnArr[5] := btnChangePassword;
  btnArr[6] := btnGetBackPassword;   btnArr[7] := btnEditGameList;

  showArr[0] := bShowStartGame;      showArr[1] := bShowWebSite;
  showArr[2] := bShowZhuangBei;      showArr[3] := bShowContuctUs;
  showArr[4] := bShowAccount;        showArr[5] := bShowChangePass;
  showArr[6] := bShowGetBackPass;    showArr[7] := bShowEditGameList;  

  try
    //AllStream := TMemoryStream.Create;
    BackStream := TMemoryStream.Create;
    TStream := TMemoryStream.Create;
    disStream := TMemoryStream.Create;
    downStream := TMemoryStream.Create;
    hotStream := TMemoryStream.Create;
    upStream := TMemoryStream.Create;

    ImageMain.Picture.Graphic.SaveToStream(BackStream); //保存背景图片

    rc.Left := ckWindowed.Left; //是否窗口状态  这是RadioBox
    rc.Top := ckWindowed.Top;
    rc.bWindow := ckWindowed.Checked;
    all.Write(rc, Sizeof(rc));

    lc.Left := RzLabel4.Left;  //游戏分辨率
    lc.Top := RzLabel4.Top ;
    all.Write(lc, Sizeof(lc));

    lc.Left := RzLabel3.Left;  //当前状态
    lc.Top := RzLabel3.Top;
    all.Write(lc, Sizeof(lc));

    lc.Left := RzLabelStatus.Left; //请选择服务器登陆
    lc.Top := RzLabelStatus.Top;
    all.Write(lc, Sizeof(lc));

    lc.Left := RzLabel1.Left;    //当前文件
    lc.Top := RzLabel1.Top ;
    all.Write(lc, Sizeof(lc));

    lc.Left := RzLabel2.Left;  //所有文件
    lc.Top := RzLabel2.Top;
    all.Write(lc, Sizeof(lc));

    //保存Panel面板的参数
    pc.Left := PanelServerList.Left;   //服务器列表
    pc.Top := PanelServerList.Top;
    pc.Width := PanelServerList.Width;
    pc.Height := PanelServerList.Height;
    all.Write(pc, Sizeof(pc));

    pc.Left := PanelWebBrowser.Left;   //网站公告
    pc.Top := panelWebBrowser.Top;
    pc.Width := PanelWebBrowser.Width;
    pc.Height := PanelWebBrowser.Height;
    all.Write(pc, Sizeof(pc));

    pc.Left := Panel2.Left;         //游戏分辨率
    pc.Top := Panel2.Top;
    pc.Width := Panel2.Width;
    pc.Height := Panel2.Height;
    all.Write(pc, Sizeof(pc));

    pc.Left := PanelProcessCur.Left; //当前文件
    pc.Top := PanelProcessCur.Top;
    pc.Width := PanelProcessCur.Width;
    pc.Height := PanelProcessCur.Height;
    all.Write(pc, Sizeof(pc));

    pc.Left := PanelProcessMax.Left; //所有文件
    pc.Top := PanelProcessMax.Top;
    pc.Width := PanelProcessMax.Width;
    pc.Height := PanelProcessMax.Height;
    all.Write(pc, Sizeof(pc));

    tSize := BackStream.Size; //背景图片Size
    all.Write(tSize, Sizeof(Int64));//把背景图片的Size写入总内存流
    BackStream.Position := 0;
    all.CopyFrom(BackStream, BackStream.Size);//把背景图片读入总内存流
    
    
    //这里开始保存最小化，这个按钮状态有三个图片
    bc.Left := btnMinSize.Left;
    bc.Top := btnMinSize.Top;
    bc.Width := btnMinSize.Width;
    bc.Height := btnMinSize.Height;
    bc.bShow := True;
    all.Write(bc, Sizeof(bc));


    btnMinSize.Bitmaps.Down.SaveToStream(downStream);
    btnMinSize.Bitmaps.Hot.SaveToStream(hotStream);
    btnMinSize.Bitmaps.Up.SaveToStream(upStream);

    tSize := downStream.Size;
    all.Write(tSize, Sizeof(Int64));
    downStream.Position := 0;
    all.CopyFrom(downStream, downStream.Size);

    tSize := hotStream.Size;
    all.Write(tSize, Sizeof(Int64));
    hotStream.Position := 0;
    all.CopyFrom(hotStream, hotStream.Size);

    tSize := upStream.Size;
    all.Write(tSize, Sizeof(Int64));
    upStream.Position := 0;
    all.CopyFrom(upStream, upStream.Size);

    ////这里开始保存关闭按钮，这两个按钮状态有三个图片
    bc.Left := btnColse.Left;
    bc.Top := btnColse.Top;
    bc.Width := btnColse.Width;
    bc.Height := btnColse.Height;
    bc.bShow := True;
    all.Write(bc, Sizeof(bc));

    downStream.Clear; hotStream.Clear; upStream.Clear;
    btnColse.Bitmaps.Down.SaveToStream(downStream);
    btnColse.Bitmaps.Hot.SaveToStream(hotStream);
    btnColse.Bitmaps.Up.SaveToStream(upStream);

    tSize := downStream.Size;
    all.Write(tSize, Sizeof(Int64));
    downStream.Position := 0;
    all.CopyFrom(downStream, downStream.Size);

    tSize := hotStream.Size;
    all.Write(tSize, Sizeof(Int64));
    hotStream.Position := 0;
    all.CopyFrom(hotStream, hotStream.Size);

    tSize := upStream.Size;
    all.Write(tSize, Sizeof(Int64));
    upStream.Position := 0;
    all.CopyFrom(upStream, upStream.Size);

    //8个功能按钮
    AddRzBmpButton(btnArr, showArr, all, disStream, downStream, hotStream, upStream);


    {all.Position :=  Sizeof(lc) * 5 + Sizeof(pc) * 5 + Sizeof(rc);
    all.Read(bSize, Sizeof(Int64));
    ShowMessage(InttoStr(bSize));

    TStream.Clear;
    TStream.CopyFrom(all, bSize);
    TStream.SaveToFile('F:\Main.png');}

  finally
    //AllStream.Free;
    BackStream.Free;
    TStream.Free;
    disStream.Free;
    downStream.Free;
    hotStream.Free;
    upStream.Free;
  end;
end;




procedure TfrmMain.ButtonPicClick(Sender: TObject);
var
  s, Dir: string;
  Folder: WideString;
  //Jpg: TJpegImage;
begin

  if PngLoadDlg.Execute then begin

    if FileExists(PngLoadDlg.FileName) then begin
      //Jpg := TJpegImage.Create;
      try
        try
          mJpg.Clear;   //mJph是MemoryStream
          mJpg.LoadFromFile(PngLoadDlg.FileName);
          //Jpg.LoadFromFile(s);
          //ImageMain.Picture.Graphic := Jpg;

          ImageMain.Picture.LoadFromFile(PngLoadDlg.FileName);
        except

        end;
      finally
        //Jpg.Free;
      end;
      btnCreatePlug.Enabled := true;
      button9.Enabled := True;
      button10.Enabled := True;
    end else
      MessageBox(0, PChar('请选择png背景图片文件！'), '错误', MB_ICONERROR + MB_OK);
  end;
end;

procedure TfrmMain.ckWindowedMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //ManipulateControl(TControl(Sender), Shift, X, Y, 5);
  ManipulateControl(TControl(Sender), Shift, 6, 6, 5);
end;

procedure TfrmMain.cmbFileSaveDirExit(Sender: TObject);
begin
  if trim(cmbFileSaveDir.Text)='' then
  begin
    Application.MessageBox('存放目录不能为空！', '错误信息', MB_ICONERROR + MB_OK);
    cmbFileSaveDir.SetFocus;
  end;
end;

procedure TfrmMain.PrepareDrop;
begin
  GetCursorPos(FPoint);
  FMouseDowned := True;
end;

procedure TfrmMain.Droping(btn: TRzBmpButton);
var
  P: TPoint;
begin
  if FMouseDowned then
  begin
    GetCursorPos(P);
    btn.Top := btn.Top + P.Y - FPoint.Y;
    btn.Left := btn.Left + P.X - FPoint.X;
    FPoint := P;
  end;
end;

procedure TfrmMain.DropingLabel(l: TRzLabel);
var
  P: TPoint;
begin
  if FMouseDowned then
  begin
    GetCursorPos(P);
    l.Top := l.Top + P.Y - FPoint.Y;
    l.Left := l.Left + P.X - FPoint.X;
    FPoint := P;
  end;
end;

procedure TfrmMain.DropOver;
begin
  FMouseDowned := FALSE;
end;

procedure TfrmMain.DropMoveBtn(aHandle: THandle);
begin
  ReleaseCapture();
  SendMessage(aHandle{btnStartGame.Handle}, WM_SYSCOMMAND, $F012, 0);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var IniConfig: TIniFile;
begin
    randomize;
  Caption := CAP_VER;
  frmMain.AdvStringGrid1.Cells[0, 0] := '物品名称';
  frmMain.AdvStringGrid1.Cells[1, 0] := '物品类别';
  frmMain.AdvStringGrid1.Cells[2, 0] := '极品显示';
  frmMain.AdvStringGrid1.Cells[3, 0] := '自动拾取';
  frmMain.AdvStringGrid1.Cells[4, 0] := '显示名字';
  LoadClientPatchConfig(nil);
  PageControl1.ActivePageIndex := 0;
{$IFNDEF PATCHMAN}
  TabSheet3.Visible := False;
  TabSheet3.Caption := '集成补丁(屏蔽)';
{$ENDIF}

  PageControl1.ActivePage := TabSheet1;

  //用于保存按钮是否可见
  bShowStartGame := True;
  bShowWebSite := True;
  bShowZhuangBei := True;
  bShowContuctUs := True;
  bShowAccount := True;
  bShowChangePass := True;
  bShowGetBackPass := True;
  bShowEditGameList := True;
  ListView1.Items.Clear;
  try
    IniConfig := TIniFile.Create(ExtractFilePath(application.ExeName) + DEFAULT_CFG);
    Edit1.text := IniConfig.ReadString('SETTING','LOGIN_NAME','98K');
    EdtMaster.text := IniConfig.ReadString('SETTING','MASTER_SERVER','http://www.98km2.com/liebiao.txt');
    EdtSlave.text := IniConfig.ReadString('SETTING','SLAVE_SERVER','http://www.98km2.com/liebiao.txt');
    EdtUpdate.text := IniConfig.ReadString('SETTING','UPDATE_SERVER','http://www.98km2.com/update.txt');
    EdtWebSite.text := IniConfig.ReadString('SETTING','WEB_SITE','http://www.98km2.com/');
    EdtGG.text := IniConfig.ReadString('SETTING','WEB_NOTICE','http://www.98km2.com/gg.html');
    EdtItems.text := IniConfig.ReadString('SETTING','VIP_ITEMS','http://www.98km2.com/vipitems.html');
    EdtContactUs.text := IniConfig.ReadString('SETTING','CONTACT_US','http://www.98km2.com/contact.html');
    EdtCount.Text  := IniConfig.ReadString('SETTING','CORE_COUNT','2');
    CheckBox3.Checked := IniConfig.ReadBool('SETTING','WIS_CHECK',False);
    CheckBox4.Checked := IniConfig.ReadBool('SETTING','WIL_CHECK',True);
    CheckBox5.Checked := IniConfig.ReadBool('SETTING','WZL_CHECK',True);
  finally
    if IniConfig <> nil then IniConfig.Free;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
   sknStream : TMemoryStream;
   bgImgStream: TMemoryStream;
   tmpRnd: Integer;
begin
   sknStream := TMemoryStream.Create;
   bgImgStream := TMemoryStream.Create;
   tmpRnd := Random(999999999);
   try
     sknStream.LoadFromFile(ExtractFilePath(Application.ExeName)+DEFAULT_SKIN);
     sknStream.Position := 0;
     DecodeSkn(sknStream,bgImgStream); //恢复皮肤
     bgImgStream.Position := 0;
     bgImgStream.SaveToFile('_Temp' + inttostr(tmpRnd)+'.png');
     ImageMain.Picture.LoadFromFile('_Temp' + inttostr(tmpRnd)+'.png');
     deleteFile('_Temp' + inttostr(tmpRnd)+'.png');
     btnCreatePlug.Enabled := true;
     button9.Enabled := True;
     button10.Enabled := True;
   except
   end;
     deleteFile('_Temp' + inttostr(tmpRnd)+'.png');
     sknStream.Free;
     bgImgStream.Free;
end;

procedure TfrmMain.InitSetBtnImgForm(Btn: TRzBmpButton);
var
  FrmSetBtn: TFrmSetBtnImage;
begin
  //if Btn = BtnStartGame then begin
    FrmSetBtn := TFrmSetBtnImage.Create(Application);
    with FrmSetBtn do begin
      Image1.Picture.Bitmap.Assign(Btn.Bitmaps.Up);
      Image2.Picture.Bitmap.Assign(Btn.Bitmaps.Hot);
      Image3.Picture.Bitmap.Assign(Btn.Bitmaps.Down);
      Image4.Picture.Bitmap.Assign(Btn.Bitmaps.Disabled);

      if ShowModal() = mrOK then begin
        Btn.Bitmaps.Up.Assign(Image1.Picture.Bitmap);
        Btn.Bitmaps.Hot.Assign(Image2.Picture.Bitmap);
        Btn.Bitmaps.Down.Assign(Image3.Picture.Bitmap);
        Btn.Bitmaps.Disabled.Assign(Image4.Picture.Bitmap);
      end;
    end;

  //end;
end;

procedure TfrmMain.PageControl1Change(Sender: TObject);
begin
  
{$IFNDEF PATCHMAN}
  TabSheet3.Visible := False;
  TabSheet3.Caption := '集成补丁(屏蔽)';
{$ENDIF}
end;

procedure TfrmMain.PanelProcessCurMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ManipulateControl(TControl(Sender), Shift, X, Y, 2);
end;

procedure TfrmMain.PanelProcessMaxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  ManipulateControl(TControl(Sender), Shift, X, Y, 2);
end;

procedure TfrmMain.PanelServerListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ManipulateControl(TControl(Sender), Shift, X, Y, 5);
end;

procedure TfrmMain.PopContactUsPopup(Sender: TObject);
begin
  n8.Checked := bShowContuctUs;
end;

procedure TfrmMain.PopExitPopup(Sender: TObject);
begin
  n18.Checked := bShowEditGameList;
end;

procedure TfrmMain.PopFindPassPopup(Sender: TObject);
begin
  n16.Checked := bShowGetBackPass;
end;

procedure TfrmMain.PopPassPopup(Sender: TObject);
begin
  n14.Checked := bShowChangePass;
end;

procedure TfrmMain.PopRegisterPopup(Sender: TObject);
begin
  N12.Checked := bShowAccount;
end;

procedure TfrmMain.PopStartGamePopup(Sender: TObject);
begin
  n2.Checked := bShowStartGame;
end;

procedure TfrmMain.PopWebSitePopup(Sender: TObject);
begin
  n4.Checked := bShowWebSite;
end;

procedure TfrmMain.PopZhuangBeiPopup(Sender: TObject);
begin
  n6.Checked := bShowZhuangBei;
end;

procedure TfrmMain.RzBmpButton1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.RzBmpButton1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(RzBmpButton1);
end;

procedure TfrmMain.RzBmpButton1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzBmpButton3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //DropMoveBtn((Sender as TRzBmpButton).Handle);
  PrepareDrop;
end;

procedure TfrmMain.RzBmpButton3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Droping(RzBmpButton3);
end;

procedure TfrmMain.RzBmpButton3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DropingLabel(RzLabel1);
end;

procedure TfrmMain.RzLabel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabel2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DropingLabel(RzLabel2);
end;

procedure TfrmMain.RzLabel2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabel3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabel3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DropingLabel(RzLabel3);
end;

procedure TfrmMain.RzLabel3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabel4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabel4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //ManipulateControl(TControl(Sender), Shift, 6, 6, 5);
  DropingLabel(RzLabel4);
end;

procedure TfrmMain.RzLabel4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.RzLabelStatusMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PrepareDrop;
end;

procedure TfrmMain.RzLabelStatusMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  DropingLabel(RzLabelStatus);
end;

procedure TfrmMain.RzLabelStatusMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DropOver;
end;

procedure TfrmMain.Button12Click(Sender: TObject);
begin
  if listview1.Items.Count > 0 then listview1.DeleteSelected;
end;

initialization
  sPath := ExtractFilePath(Application.ExeName);
  mJpg := TMemoryStream.Create();

finalization
  if mJpg <> nil then mJpg.Free;

end.

