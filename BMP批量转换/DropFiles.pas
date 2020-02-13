unit DropFiles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ActiveX, ShellAPI,
  ShlObj, ComObj;

type
  TDropFilesEvent = procedure (Sender: TObject; Files: TStrings; X, Y: Integer) of object;
  TDropFiles = class(TComponent)
  private
    FResolveLinks: Boolean;
    FTarget: TWinControl;
    FOldWindowProc: TWndMethod;
    FOnDropFiles: TDropFilesEvent;
    procedure SetTarget(const ATarget: TWinControl);
    procedure WindowProc(var Message: TMessage);
    procedure WMDropFiles(var Message: TMessage);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ResolveLinks: Boolean read FResolveLinks write FResolveLinks default True;
    property Target: TWinControl read FTarget write SetTarget;
    property OnDropFiles: TDropFilesEvent read FOnDropFiles write FOnDropFiles;
  end;

  procedure Register;

implementation

const
  IID_IPersistFile: TGUID = (
    D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

procedure Register;
begin
  RegisterComponents('hgPack', [TDropFiles]);
end;

function IsShortcutExtension(const Extension: string): Boolean;
begin
  Result := SameText(Extension, '.lnk');
end;

function GetFileLinkTarget(const FileName: string): string;
var
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
  FileNameW: array[0..MAX_PATH] of WideChar;
  FindData: TWIN32FINDDATA;
begin
  try
    CoInitialize(nil);
    try
      OleCheck(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_SERVER,
        IID_IShellLinkA, ShellLink));
      try
        OleCheck(ShellLink.QueryInterface(IID_IPersistFile, PersistFile));
        try
          MultiByteToWideChar(CP_ACP, 0, PAnsiChar(FileName), -1, FileNameW, MAX_PATH);
          OleCheck(PersistFile.Load(FileNameW, STGM_READ or STGM_SHARE_DENY_WRITE));
          SetLength(Result, MAX_PATH);
          ShellLink.GetPath(PChar(Result), MAX_PATH, FindData, 0);
          SetLength(Result, StrLen(PChar(Result)));
        finally
          PersistFile := nil;
        end;
      finally
        ShellLink := nil;
      end;
    finally
      CoUninitialize;
    end;
  except
    Result := FileName;
  end;
end;

{ TDropFiles }

constructor TDropFiles.Create(AOwner: TComponent);
begin
  inherited;
  FResolveLinks := True;
end;

procedure TDropFiles.SetTarget(const ATarget: TWinControl);
begin
  if FTarget <> ATarget then
  begin
    if not ((csDesigning in ComponentState) or (csDestroying in ComponentState)) then
    begin
      if ATarget = nil then
      begin
        FTarget.WindowProc := FOldWindowProc;
        FOldWindowProc := nil;
        DragAcceptFiles(FTarget.Handle, False);
      end
      else
      begin
        FOldWindowProc := ATarget.WindowProc;
        ATarget.WindowProc := WindowProc;
        DragAcceptFiles(ATarget.Handle, True);
        ATarget.FreeNotification(Self);
      end;
    end;

    FTarget := ATarget;
  end;
end;

procedure TDropFiles.WindowProc(var Message: TMessage);
begin
  if Message.Msg = WM_DROPFILES then
    WMDropFiles(Message)
  else
    FOldWindowProc(Message);
end;

procedure TDropFiles.WMDropFiles(var Message: TMessage);
var
  hDrop, Count, Size, I: Integer;
  FileName: string;
  DropPoint: TPoint;
  Files: TStrings;
begin
  inherited;
  hDrop := Message.WParam;
  Count := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);
  Files := TStringList.Create;
  try
    for I := 0 to Count - 1 do
    begin
      Size := DragQueryFile(hDrop, I, nil, 0) + 1;
      SetLength(FileName, Size);
      DragQueryFile(hDrop, I, PChar(FileName), Size);
      if FResolveLinks and
        IsShortcutExtension(ExtractFileExt(PChar(FileName))) then
        Files.Add(GetFileLinkTarget(PChar(FileName)))
      else
        Files.Add(PChar(FileName));
    end;
    DragQueryPoint(hDrop, DropPoint);
    if Assigned(OnDropFiles) then
      OnDropFiles(Self, Files, DropPoint.X, DropPoint.Y);
  finally
    DragFinish(hDrop);
    Files.Free;
  end;
end;

procedure TDropFiles.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (FTarget <> nil) and (AComponent = Target) then
    Target := nil;
end;

end.
