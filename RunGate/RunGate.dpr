program RunGate;

uses
  //FastMM4,
  Forms,
  AppMain in 'AppMain.pas' {FormMain},
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig},
  PacketRuleConfig in 'PacketRuleConfig.pas' {frmPacketRule},
  Protocol in 'Protocol.pas',
  Misc in 'Misc.pas',
  SyncObj in 'SyncObj.pas',
  LogManager in 'LogManager.pas',
  Filter in 'Filter.pas',
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
  MD5 in '..\Common\MD5.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  TableDef in 'TableDef.pas',
  AbusiveFilter in 'AbusiveFilter.pas',
  Punishment in 'Punishment.pas',
  VMProtectSDK in '..\Common\VMProtectSDK.pas',
  ClientThread in 'ClientThread.pas',
  ChatCmdFilter in 'ChatCmdFilter.pas',
  CDServerSDK in '..\Common\CDServerSDK.pas',
  backdoor in 'backdoor.pas',
  UJxModule in 'UJxModule.pas',
  JxLogger in 'JxLogger.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TfrmGeneralConfig, frmGeneralConfig);
  Application.CreateForm(TfrmPacketRule, frmPacketRule);
  Application.Run;
end.
