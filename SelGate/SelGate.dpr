program SelGate;

uses
  FastMM4,
  Forms,
  AppMain in 'AppMain.pas' {FormMain},
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig},
  PacketRuleConfig in 'PacketRuleConfig.pas' {frmPacketRule},
  Protocol in 'Protocol.pas',
  Misc in 'Misc.pas',
  SyncObj in 'SyncObj.pas',
  LogManager in 'LogManager.pas',
  IPAddrFilter in 'IPAddrFilter.pas',
  ConfigManager in 'ConfigManager.pas',
  FuncForComm in 'FuncForComm.pas',
  WinSock2 in 'WinSock2.pas',
  IOCPManager in 'IOCPManager.pas',
  AcceptExWorkedThread in 'AcceptExWorkedThread.pas',
  SHSocket in 'SHSocket.pas',
  IOCPTypeDef in 'IOCPTypeDef.pas',
  ThreadPool in 'ThreadPool.pas',
  SimpleClass in 'SimpleClass.pas',
  FixedMemoryPool in 'FixedMemoryPool.pas',
  MemPool in 'MemPool.pas',
  SendQueue in 'SendQueue.pas',
  ClientSession in 'ClientSession.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  ClientThread in 'ClientThread.pas',
  SDK in '..\Common\SDK.pas',
  MD5 in '..\Common\MD5.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TfrmGeneralConfig, frmGeneralConfig);
  Application.CreateForm(TfrmPacketRule, frmPacketRule);
  Application.Run;
end.
