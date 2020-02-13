unit uFrmCaptcha;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, pngimage, Buttons;

type
  TfrmCaptcha = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    Edit1: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Button2: TBitBtn;
    Label2: TLabel;
    Timer2: TTimer;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    m_timeout: Integer;
    m_timereresidue: Integer;
    m_lasttime: Integer;
    m_bIsWin10: Boolean;
  public
    { Public declarations }
    procedure ShowCaptcha(pszbuff: Pointer; blen: Integer; timeout: Integer);
    procedure OnCaptchaRes(sucess: Integer; time: Integer);
    procedure AskAgain(time: Integer);
    procedure AnswerOk();
    procedure AnswerErr();
    procedure QueryOSVer;
    procedure CancelCap;
  end;

var
  frmCaptcha: TfrmCaptcha;

implementation

uses ClMain, MShare;

{$R *.dfm}

{ TfrmCaptcha }

procedure TfrmCaptcha.AnswerErr;
begin
  Label2.Font.Color := clBlue;
  Label2.Caption := '验证码回答错误!!';
  Timer2.Enabled := True;
end;

procedure TfrmCaptcha.AnswerOk;
begin
  Label2.Font.Color := clBlue;
  Label2.Caption := '验证码回答正确.';
  Timer2.Enabled := True;
end;

procedure TfrmCaptcha.AskAgain(time: Integer);
begin
  if not Visible then
    Show;
  if (time > 0) and (time < 10) then
  begin

    Timer1.Enabled := True;
//    Position := poMainFormCenter;
    m_timereresidue := m_timeout;
    Button2.Enabled := True;

    Button2.Font.Color := clBlue;
    Button2.Caption := '提交';
    m_lasttime := time;
    Label2.Font.Color := clRed;
    Edit1.SetFocus;
    Edit1.Text := '';
//    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
    Label2.Caption := Format('回答错误，你还有%d机会', [time]);
  end;
end;

procedure TfrmCaptcha.Button2Click(Sender: TObject);
var s: string;
begin
  s := Edit1.Text;
  if s = '' then
  begin
    Edit1.SetFocus;
    Exit;
  end;
  Button2.Enabled := False;
  Timer1.Enabled := False;
  frmMain.SendCaptchaRes(s);
//  hide;
end;

procedure TfrmCaptcha.CancelCap;
begin
  Timer1.Enabled := False;
  Timer2.Enabled := False;
  Hide;
end;

procedure TfrmCaptcha.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    Button2Click(nil);
end;

procedure TfrmCaptcha.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure TfrmCaptcha.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := False;
  Timer2.Enabled := False;
  m_bIsWin10 := False;
  QueryOSVer;
end;

procedure TfrmCaptcha.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    //      if key = VK_RETURN then
//              Button2Click(nil);
end;

procedure TfrmCaptcha.OnCaptchaRes(sucess, time: Integer);
var log: string;
begin

  log := Format('OnCaptchaRes %d,%d', [sucess, time]);
  //OutputDebugString(pchar(log));
  if 0 = sucess then
    AnswerOk
  else
  begin
    if 0 = time then
      AnswerErr
    else
      AskAgain(time);
  end;

end;

procedure TfrmCaptcha.QueryOSVer;
var ver: TOSVersionInfo;
begin
  ZeroMemory(@ver, sizeof(TOSVersionInfo));
  ver.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(ver);
  m_bIsWin10 := ver.dwMajorVersion >= 9;
end;

procedure TfrmCaptcha.ShowCaptcha(pszbuff: Pointer; blen: Integer; timeout: Integer);
var mm: TMemoryStream;
  png: TPNGObject;
begin
  Timer1.Enabled := True;
  Button2.Enabled := True;

  Timer2.Enabled := False;
//  Position := poMainFormCenter;
  if m_bIsWin10 then
    Left := frmMain.Left + frmMain.Width
  else
    Left := frmMain.Left + frmMain.Width - Width;
  top := frmMain.Top + frmMain.Height - Height;

  m_timeout := timeout;
  m_timereresidue := m_timeout;
  m_lasttime := 3;


  Button2.Font.Color := clBlue;
  Button2.Caption := '提交';
//  Timer1.Enabled := True;
//  Edit1.SetFocus;
  try
    png := TPNGObject.Create;
    mm := TMemoryStream.Create;
    mm.Write(pszbuff^, blen);

    mm.Position := 0;
    png.LoadFromStream(mm);

    Image1.Picture.Bitmap.Assign(png);

    FreeAndNil(mm);
    FreeAndNil(png);

  except
    //OutputDebugString('except');
  end;

  if g_boFullScreen then
  begin
    Parent := frmMain;
    BorderStyle := bsSizeToolWin;
    Position := poMainFormCenter;
  end
  else
  begin
    Parent := nil;
    BorderStyle := bsDialog;
//    Position := poDesigned;
  end;

  Show;
  Edit1.SetFocus;
  Edit1.Text := '';
  Label2.Caption := '';
  SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TfrmCaptcha.Timer1Timer(Sender: TObject);
begin
  Dec(m_timereresidue);
  if m_timereresidue < 5 then
    Button2.Font.Color := clRed
  else
    Button2.Font.Color := clBlue;

  Button2.Caption := Format('提交(%d)', [m_timereresidue]);
  if (0 = m_timereresidue) then
  begin
//    Button2Click(nil);
    Button2.Enabled := False;
    Timer1.Enabled := False;
    frmMain.SendCaptchaRes('z');
//    if 1 = m_lasttime then
//    begin
//      Timer2.Enabled := True;
//    end;
  end;
  if m_timereresidue < 0 then
  begin
    Timer1.Enabled := False;
    Hide;
  end;

end;

procedure TfrmCaptcha.Timer2Timer(Sender: TObject);
begin
  Hide;
  Timer2.Enabled := False;
end;

end.
