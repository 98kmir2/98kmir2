unit SyncObj;

interface

uses
  Windows;

type
  TSyncObj = class
  private
    FCSAccess: TRTLCriticalSection;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Lock();
    procedure Unlock();
  end;

implementation

constructor TSyncObj.Create;
begin
  inherited;
  InitializeCriticalSection(FCSAccess);
end;

destructor TSyncObj.Destroy;
begin
  DeleteCriticalSection(FCSAccess);
  inherited;
end;

procedure TSyncObj.Lock();
begin
  EnterCriticalSection(FCSAccess);
end;

procedure TSyncObj.Unlock();
begin
  LeaveCriticalSection(FCSAccess);
end;

end.
