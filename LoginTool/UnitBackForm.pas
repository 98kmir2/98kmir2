unit UnitBackForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, OleCtrls, SHDocVw, RzBmpBtn, RzPrgres,
  RzCmboBx, RzLabel, RzButton, RzRadChk, LShare, MsgBox, D7ScktComp, Grobal2,
  EDcode, Mars, VMProtectSDK, ShellAPI, LNewAccount, IniFiles, IdHttp, MD5,
  IdHash, IdHashMessageDigest, Registry, HUtil32, UMirClient, UUIbRes,

  SechThread, StrUtils, Base64, UpgradeModule, SkinConfig,

  LGetBackPassword, LChgPassword, IdBaseComponent, IdAntiFreezeBase,
  IdAntiFreeze, Buttons, RzSpnEdt, RzTreeVw;

const
  WM_MYMOVEMSG = WM_USER + $200;

type
  LPDYNCODE = function(Ptr: PByte; Len: DWord): BOOL; stdcall;
  LPGETDYNCODE = function(ID: Integer): LPDYNCODE; stdcall;

type
  TBackForm = class(TForm)
    RzLabel4: TRzLabel;
    RzComboBox_ScrMode: TRzComboBox;
    RzLabel3: TRzLabel;
    RzLabelStatus: TRzLabel;
    RzLabel1: TRzLabel;
    ProgressBarCurDownload: TRzProgressBar;
    RzLabel2: TRzLabel;
    ProgressBarAll: TRzProgressBar;
    RzBmpButton3: TRzBmpButton;
    RzBmpButton1: TRzBmpButton;
    btnEditGame: TRzBmpButton;
    btnEditGameList: TRzBmpButton;
    btnGetBackPassword: TRzBmpButton;
    btnChangePassword: TRzBmpButton;
    btNewAccount: TRzBmpButton;
    ClientSocket: TClientSocket;
    rbRoute2: TRzRadioButton;
    rbRoute1: TRzRadioButton;
    ClientSocket2: TClientSocket;
    ServerSocket: TServerSocket;
    ClientSocket1: TClientSocket;
    btnMinSize: TRzBmpButton;
    btnColse: TRzBmpButton;
    ckWindowed: TRzCheckBox;
    btnStartGame: TRzBmpButton;
    TreeViewServerList: TRzTreeView;
    Panel1: TPanel;
    WebBrowser: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketLookup(Sender: TObject; Socket: TCustomWinSocket);

    procedure WebBrowserDownloadComplete(Sender: TObject);
    procedure RzBmpButton3Click(Sender: TObject);
    procedure RzBmpButton1Click(Sender: TObject);
    procedure btnEditGameClick(Sender: TObject);
    procedure btNewAccountClick(Sender: TObject);
    procedure btnStartGameClick(Sender: TObject);
    procedure btnGetBackPasswordClick(Sender: TObject);
    procedure btnEditGameListClick(Sender: TObject);
    procedure btnChangePasswordClick(Sender: TObject);
    procedure ClientSocket2Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket2Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormResize(Sender: TObject);
    procedure btnMinSizeClick(Sender: TObject);
    procedure btnColseClick(Sender: TObject);
    procedure RzComboBox_ScrModeChange(Sender: TObject);
    procedure ckWindowedClick(Sender: TObject);
    procedure ckWindowedEnter(Sender: TObject);
    procedure ckWindowedMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ckWindowedMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TreeViewServerListAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure TreeViewServerListClick(Sender: TObject);
    procedure RzLabel3DblClick(Sender: TObject);
    procedure RzLabel3Click(Sender: TObject);
  private
    { Private declarations }


    
    oldcrc: Cardinal;
    dwTreeViewServerListClick: LongWord;
    //SocStr: string;
    //testSocStr, testBufferStr: string;

    procedure DelAllDll;
    procedure SendTestConnnect();
    function DecodeGameList(content: string): string;

    procedure SendUrlCheckEx;

    procedure SendCSocket(sendstr: string);
    procedure ServerStatusFail();

  public
    { Public declarations }

 
    DCP_mars: TDCP_mars;

    FEncodeFunc: LPDYNCODE;
    FDecodeFunc: LPDYNCODE;
    FEndeBufLen: Integer;
    FEndeBuffer: array[0..16 * 1024 - 1] of Char;
    FTempBuffer: array[0..16 * 1024 - 1] of Char;
    FSendBuffer: array[0..16 * 1024 - 1] of Char;
  end;

var
  BackForm: TBackForm;



implementation

uses
  LMain, PEUnit, SlectDir;

{$R *.dfm}



function EncrypStr(Src, Key: string): string; //字符串加密函数
//对字符串加密(Src:源 Key:密匙)
var
  KeyLen: Integer;
  KeyPos: Integer;
  offset: Integer;
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
  offset := Random(Range);
  dest := Format('%1.2x', [offset]);
  for SrcPos := 1 to Length(Src) do begin
    SrcAsc := (Ord(Src[SrcPos]) + offset) mod 255;
    if KeyPos < KeyLen then KeyPos := KeyPos + 1
    else KeyPos := 1;
    SrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    dest := dest + Format('%1.2x', [SrcAsc]);
    offset := SrcAsc;
  end;
  Result := dest;
end;

function DecrypStr(Src, Key: string): string; //字符串解密函数
var
  KeyLen: Integer;
  KeyPos: Integer;
  offset: Integer;
  dest: string;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
begin
  KeyLen := Length(Key);
  if KeyLen = 0 then Key := VMProtectDecryptStringA('legendsoft');
  KeyPos := 0;
  offset := StrToInt('$' + Copy(Src, 1, 2));
  SrcPos := 3;
  repeat
    SrcAsc := StrToInt('$' + Copy(Src, SrcPos, 2));
    if KeyPos < KeyLen then KeyPos := KeyPos + 1
    else KeyPos := 1;
    TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
    if TmpSrcAsc <= offset then TmpSrcAsc := 255 + TmpSrcAsc - offset
    else TmpSrcAsc := TmpSrcAsc - offset;
    dest := dest + Chr(TmpSrcAsc);
    offset := SrcAsc;
    SrcPos := SrcPos + 2;
  until SrcPos >= Length(Src);
  Result := dest;
end;


function GetUrlCrc(pszurl: PChar; Len: Integer): Cardinal; stdcall;
var s: string;
  initdata: Cardinal;
begin
{$I '..\Common\Macros\VMPB.inc'}
  s := Copy(pszurl, 0, len);
  s := LowerCase(s);
  s := MD5Print(MD5String(s));
  initdata := $876545AB;
  Result := CRC32(Pointer(s), Length(s) * SizeOf(Char), initdata);

{$I '..\Common\Macros\VMPE.inc'}
end;



procedure TBackForm.DelAllDll;
var
  sr: TSearchRec;
  sPath, sFile: string;
begin

  sPath := g_sWorkDir;
  if FindFirst(sPath + '*.dll', faAnyFile, sr) = 0 then
  begin
    repeat
      sFile := Trim(sr.Name);
      if sFile = '.' then Continue;
      if sFile = '..' then Continue;
      if SameText(sFile, 'LoginDLL.dll') then Continue;
      sFile := sPath + sr.Name;
      if (sr.Attr and faDirectory) <> 0 then
        DeleteDir(sFile, True)
      else if (sr.Attr and faAnyFile) = sr.Attr then begin
        SysUtils.DeleteFile(sFile); //删除文件
      end;
    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;
end;


procedure TBackForm.SendTestConnnect;
var
  iLen: Integer;
  msg: TDefaultMessage;
  ss: string;
begin
{$I '..\Common\Macros\VMPB.inc'}
  msg := MakeDefaultMsg(CM_TESTCONNECT, 0, 0, 0, 0);
  if @FEncodeFunc <> nil then begin
    Move(msg, FTempBuffer[0], 12);
    FEncodeFunc(PByte(@FTempBuffer), 12);
    iLen := EncodeBuf(Integer(@FTempBuffer), 12, Integer(@FSendBuffer));
    SetLength(ss, iLen);
    Move(FSendBuffer[0], ss[1], iLen);
    SendCSocket(ss);
  end else
    ; // SendCSocket(EncodeMessage(msg) + EncodeString(sAccount + #9 + sPasswd + #9 + sNewPasswd));
{$I '..\Common\Macros\VMPE.inc'}

end;


function TBackForm.DecodeGameList(content: string): string;
var
  str, str2, str3: string;
  DCP_mars: TDCP_mars;
  l, r: Integer;
begin
  {.$I '..\Common\Macros\VMPB.inc'}
  DCP_mars := TDCP_mars.Create(nil);
  DCP_mars.InitStr(VMProtectDecryptStringA('blue dlg config'));
//  OutputDebugStringA(Pchar(content));
  str := content;
  l := Pos('[BLUE', str) + 5;
  if 5 = l then
  begin
    Result := content;
    Exit;
  end;
  r := Pos('EULB]', str);
  str := MidStr(str, l, r - l);
  str2 := Base64DecodeStr(str);
  str3 := DCP_mars.DecryptString(str2);
  //    OutputDebugStringA(Pchar(str3));
  Result := str3;
    {.$I '..\Common\Macros\VMPE.inc'}

end;




procedure TBackForm.SendUrlCheckEx;
var

  msg: TDefaultMessage;
  temp1, temp2, temp3: string;
  crc: Cardinal;
  sztoal: string;
begin
   exit;
{$I '..\Common\Macros\VMPB.inc'}
  if (ClientSocket1.Active) then
  begin
    DCP_mars.InitStr(VMProtectDecryptStringA('GameList'));
    temp1 := DCP_mars.DecryptString(g_pRcHeader.GameList);
//    list1 := temp1;
    DCP_mars.InitStr(VMProtectDecryptStringA('GameList2'));
    temp2 := DCP_mars.DecryptString(g_pRcHeader.GameList2);
//    list2 := temp2;
    DCP_mars.InitStr(VMProtectDecryptStringA('sLuiName2'));
    temp3 := DCP_mars.DecryptString(g_pRcHeader.sLuiName2); //注册时间

    sztoal := Trim(temp1) + '|' + Trim(temp2) + '|' + Trim(temp3);
    crc := GetUrlCrc(PChar(sztoal), Length(sztoal));
    msg := MakeDefaultMsg(CM_SENDLIST, crc, Random(-1), Random(-1), Random(-1));
    sztoal := sztoal + '|' + IntToStr(oldcrc) + '|' + IntToStr(crc);
    ClientSocket1.Socket.SendText('#' + EncodeMessage(msg) + EncodeString(sztoal) + '!');
  end;
{$I '..\Common\Macros\VMPE.inc'}

end;


procedure TBackForm.btnChangePasswordClick(Sender: TObject);
begin

  if not g_boServerStatus then begin
    FrmMessageBox.Open('请先选择并连接帐号所在的服务器分区');
    Exit;
  end;
  frmChangePassword.Open;
end;

procedure TBackForm.btnColseClick(Sender: TObject);
begin
  halt;
end;

procedure TBackForm.btnEditGameClick(Sender: TObject);
begin
ShellExecute(Handle, nil, PChar(string(LoginData.urlKF)), nil, nil, SW_SHOW);
end;

procedure TBackForm.btnEditGameListClick(Sender: TObject);
begin
  halt;
end;

procedure TBackForm.btNewAccountClick(Sender: TObject);
begin
  FrmMain.MyNewAccount
end;


procedure TBackForm.btnGetBackPasswordClick(Sender: TObject);
begin

  if not g_boServerStatus then begin
    FrmMessageBox.Open('请先选择并连接帐号所在的服务器分区');
    Exit;
  end;
  frmGetBackPassword.Open;
end;

procedure TBackForm.btnMinSizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TBackForm.btnStartGameClick(Sender: TObject);
begin
 // Application.Minimize;
  FrmMain.MyStartGame;
 // Application.Terminate;
end;

procedure TBackForm.ckWindowedClick(Sender: TObject);
begin
  //ckWindowed.Checked := not ckWindowed.Checked;
  ckWindowed.SetFocus;
  FrmMain.CheckWindowState;


end;

procedure TBackForm.ckWindowedEnter(Sender: TObject);
begin
  //ckWindowed.SetFocus;
end;

procedure TBackForm.ckWindowedMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //ckWindowed.SetFocus;
end;

procedure TBackForm.ckWindowedMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//  ckWindowed.BringToFront;
 // ckWindowed.SetFocus;
end;

procedure TBackForm.SendCSocket(sendstr: string);
begin
  if ClientSocket.Socket.Connected then begin
    ClientSocket.Socket.SendText('#' + IntToStr(g_btCode) + sendstr + '!');
    Inc(g_btCode);
    if g_btCode >= 10 then
      g_btCode := 1;
  end;
end;


procedure TBackForm.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  {UserSocket := Socket;
  if g_SelGameZone <> nil then begin
    ClientSocket2.Address := g_SelGameZone.sGameIPaddr;
    ClientSocket2.Port := g_SelGameZone.nGameIPPort;
    ClientSocket2.Active := True;
  end;}
end;

procedure TBackForm.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  {UserSocket := nil;
  ClientSocket2.Active := False;
  ClientSocket2.Close;}
end;

procedure TBackForm.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  //Socket.Close;
  //ErrorCode := 0;
end;

procedure TBackForm.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
  sReviceMsg: string;
begin
  {sReviceMsg := Socket.ReceiveText;

  i := 0;
  while not ClientSocket2.Socket.Connected do begin
    Inc(i);
    Application.ProcessMessages;
    if Application.Terminated then Break;
    Sleep(1);
    if i > 1200 then
      Break;
  end;

  if ClientSocket2.Socket.Connected then begin
    ClientSocket2.Socket.SendText(sReviceMsg);
  end;}
end;

procedure TBackForm.ServerStatusFail();
begin
  btNewAccount.Enabled := False;
  btnChangePassword.Enabled := False;
  btnGetBackPassword.Enabled := False;
  btnStartGame.Enabled := False;
end;


procedure TBackForm.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  // 发送连接数据
  SendTestConnnect();
end;

procedure TBackForm.ClientSocket2Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  //Socket.Close;
  //ErrorCode := 0;
end;

procedure TBackForm.ClientSocket2Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //if UserSocket <> nil then
    //UserSocket.SendText(Socket.ReceiveText);
end;

procedure TBackForm.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  s: string;
  dMsg: TDefaultMessage;
begin
  {g_boClose := True;
  RzLabelStatus.Font.Color := clLime;
  RzLabelStatus.Caption := '服务器状态良好...';
  g_SelGameZone.sGameIPaddr := Socket.RemoteAddress;
  g_boServerStatus := True;}
  //ServerStatusOK();
{$I '..\Common\Macros\VMPB.inc'}
  {dMsg := MakeDefaultMsg(CM_QUERYDYNCODE, 0, 0, 1, 0);

  DCP_mars.InitStr(VMProtectDecryptStringA('sWebSite'));
  s := DCP_mars.DecryptString(g_pRcHeader.sWebSite);
  DCP_mars.InitStr(s);
  s := DCP_mars.EncryptString(s);
  SendCSocket(EncodeMessage(dMsg) + EncodeString(s));}

{$I '..\Common\Macros\VMPE.inc'}
  //DCP_mars.DecryptString(g_pRcHeader.sWebSite) + ' ' + DCP_mars.DecryptString(g_pRcHeader.sWebSite);
end;

procedure TBackForm.ClientSocketConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //RzLabelStatus.Caption := '正在连接服务器...';
end;

procedure TBackForm.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  {RzLabelStatus.Font.Color := clRed;
  RzLabelStatus.Caption := '连接服务器已断开...';
  g_boServerStatus := False;
  g_boQueryDynCode := False;
  ServerStatusFail;}
end;

procedure TBackForm.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  {g_boClose := False;
  ErrorCode := 0;
  Socket.Close;
  g_boServerStatus := False;
  g_boQueryDynCode := False;}
end;

procedure TBackForm.ClientSocketLookup(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //RzLabelStatus.Caption := '正在解释服务器地址...';
end;


procedure TBackForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  action.Free;
end;

procedure TBackForm.FormCreate(Sender: TObject);
begin
  Color := clGray;
  TransparentColor := True;
  TransparentColorValue := clGray;
  BorderStyle := bsNone;

  frmMain.EnumDisplayMode(RzComboBox_ScrMode);
end;

procedure TBackForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//  ckWindowed.BringToFront;
 // ckWindowed.SetFocus;
end;

procedure TBackForm.FormResize(Sender: TObject);
begin
  //Application.Restore;

end;

procedure TBackForm.RzBmpButton1Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(string(LoginData.urlZB)), nil, nil, SW_SHOW);
end;

procedure TBackForm.RzBmpButton3Click(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(string(LoginData.webSite)), nil, nil, SW_SHOW);
end;

procedure TBackForm.RzComboBox_ScrModeChange(Sender: TObject);
begin
  FrmMain.SetDisplayMode(RzComboBox_ScrMode);
end;

procedure TBackForm.RzLabel3Click(Sender: TObject);
begin
   if FrmMAIN.idhttpupdate.Socket.Connected then
   begin
      if Application.MessageBox('是否中断文件更新下载升级', '信息提示', MB_ICONQUESTION + MB_YESNO) = ID_YES then
      begin
        FrmMain.IdHTTPUpdate.Disconnect;

      end;
   end;
end;

procedure TBackForm.RzLabel3DblClick(Sender: TObject);
begin
   if FrmMAIN.idhttpupdate.Socket.Connected then
   begin
      if Application.MessageBox('是否中断文件更新下载升级', '信息提示', MB_ICONQUESTION + MB_YESNO) = ID_YES then
      begin
        FrmMain.IdHTTPUpdate.Disconnect;
      end;
   end;
end;

procedure TBackForm.TreeViewServerListAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
Var
  ACanvas: TCanvas;
  ARect: TRect;
Begin
  Inherited;
  ACanvas := TreeViewServerList.Canvas;
  ARect := Node.DisplayRect(True);

  If node.Selected Then
    ACanvas.Brush.Color := clMaroon;  //clSkyBlue;

  ACanvas.Font.Assign(TreeViewServerList.Font);
  ACanvas.FillRect(ARect);
  DrawText(ACanvas.Handle, PChar(Node.Text), -1,
  ARect, DT_SINGLELINE Or DT_VCENTER Or DT_SINGLELINE);
End;

procedure TBackForm.TreeViewServerListClick(Sender: TObject);
begin
  frmMain.SelAndLoadServer;
end;

procedure TBackForm.WebBrowserDownloadComplete(Sender: TObject);
begin
  g_boWebBrowserShow := True;
  g_dwWebBrowserShow := GetTickCount;
end;

end.
