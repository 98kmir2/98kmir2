unit GameCommand;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Grids, ComCtrls, StdCtrls, Spin, Grobal2;

type
  TfrmGameCmd = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    StringGridGameCmd: TStringGrid;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditUserCmdName: TEdit;
    EditUserCmdPerMission: TSpinEdit;
    Label6: TLabel;
    EditUserCmdOK: TButton;
    LabelUserCmdFunc: TLabel;
    LabelUserCmdParam: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditUserCmdSave: TButton;
    StringGridGameMasterCmd: TStringGrid;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    LabelGameMasterCmdFunc: TLabel;
    LabelGameMasterCmdParam: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditGameMasterCmdName: TEdit;
    EditGameMasterCmdPerMission: TSpinEdit;
    EditGameMasterCmdOK: TButton;
    EditGameMasterCmdSave: TButton;
    StringGridGameDebugCmd: TStringGrid;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    LabelGameDebugCmdFunc: TLabel;
    LabelGameDebugCmdParam: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditGameDebugCmdName: TEdit;
    EditGameDebugCmdPerMission: TSpinEdit;
    EditGameDebugCmdOK: TButton;
    EditGameDebugCmdSave: TButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGridGameCmdClick(Sender: TObject);
    procedure EditUserCmdNameChange(Sender: TObject);
    procedure EditUserCmdPerMissionChange(Sender: TObject);
    procedure EditUserCmdOKClick(Sender: TObject);
    procedure EditUserCmdSaveClick(Sender: TObject);
    procedure StringGridGameMasterCmdClick(Sender: TObject);
    procedure EditGameMasterCmdNameChange(Sender: TObject);
    procedure EditGameMasterCmdPerMissionChange(Sender: TObject);
    procedure EditGameMasterCmdOKClick(Sender: TObject);
    procedure StringGridGameDebugCmdClick(Sender: TObject);
    procedure EditGameDebugCmdNameChange(Sender: TObject);
    procedure EditGameDebugCmdPerMissionChange(Sender: TObject);
    procedure EditGameDebugCmdOKClick(Sender: TObject);
    procedure EditGameMasterCmdSaveClick(Sender: TObject);
    procedure EditGameDebugCmdSaveClick(Sender: TObject);
  private
    nRefGameUserIndex: Integer;
    nRefGameMasterIndex: Integer;
    nRefGameDebugIndex: Integer;
    procedure RefUserCommand();
    procedure RefGameMasterCommand();
    procedure RefGameMasterCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);
    procedure RefDebugCommand();
    procedure RefGameDebugCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);
    procedure RefGameUserCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmGameCmd: TfrmGameCmd;

implementation

uses M2Share;

{$R *.dfm}

procedure TfrmGameCmd.FormCreate(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
  StringGridGameCmd.RowCount := 50;
  StringGridGameCmd.Cells[0, 0] := '��Ϸ����';
  StringGridGameCmd.Cells[1, 0] := '����Ȩ��';
  StringGridGameCmd.Cells[2, 0] := '�����ʽ';
  StringGridGameCmd.Cells[3, 0] := '����˵��';

  StringGridGameMasterCmd.RowCount := 105;
  StringGridGameMasterCmd.Cells[0, 0] := '��Ϸ����';
  StringGridGameMasterCmd.Cells[1, 0] := '����Ȩ��';
  StringGridGameMasterCmd.Cells[2, 0] := '�����ʽ';
  StringGridGameMasterCmd.Cells[3, 0] := '����˵��';

  StringGridGameDebugCmd.RowCount := 41;
  StringGridGameDebugCmd.Cells[0, 0] := '��Ϸ����';
  StringGridGameDebugCmd.Cells[1, 0] := '����Ȩ��';
  StringGridGameDebugCmd.Cells[2, 0] := '�����ʽ';
  StringGridGameDebugCmd.Cells[3, 0] := '����˵��';

end;

procedure TfrmGameCmd.Open;
begin
  RefUserCommand();
  RefGameMasterCommand();
  RefDebugCommand();
  ShowModal;
end;

procedure TfrmGameCmd.RefGameUserCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);
begin
  Inc(nRefGameUserIndex);
  if StringGridGameCmd.RowCount - 1 < nRefGameUserIndex then
  begin
    StringGridGameCmd.RowCount := nRefGameUserIndex + 1;
  end;

  StringGridGameCmd.Cells[0, nRefGameUserIndex] := GameCmd.sCmd;
  StringGridGameCmd.Cells[1, nRefGameUserIndex] := IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameCmd.Cells[2, nRefGameUserIndex] := sCmdParam;
  StringGridGameCmd.Cells[3, nRefGameUserIndex] := sDesc;
  StringGridGameCmd.Objects[0, nRefGameUserIndex] := TObject(GameCmd);
end;

//  StringGridGameCmd.Cells[3,12]:='δʹ��';
//  StringGridGameCmd.Cells[3,13]:='�ƶ���ͼָ������(��Ҫ������װ��)';
//  StringGridGameCmd.Cells[3,14]:='̽����������λ��(��Ҫ������װ��)';
//  StringGridGameCmd.Cells[3,15]:='������䴫��';
//  StringGridGameCmd.Cells[3,16]:='�������Ա���͵����(��Ҫ������ȫ��װ��)';
//  StringGridGameCmd.Cells[3,17]:='�����лᴫ��';
//  StringGridGameCmd.Cells[3,18]:='���л��Ա�������(��Ҫ���лᴫ��װ��)';
//  StringGridGameCmd.Cells[3,19]:='�����ֿ�������';
//  StringGridGameCmd.Cells[3,20]:='������¼������';
//  StringGridGameCmd.Cells[3,21]:='���ֿ���������';
//  StringGridGameCmd.Cells[3,22]:='���òֿ�����';
//  StringGridGameCmd.Cells[3,23]:='�޸Ĳֿ�����';
//  StringGridGameCmd.Cells[3,24]:='�������(�ȿ������������)';
//  StringGridGameCmd.Cells[3,25]:='δʹ��';
//  StringGridGameCmd.Cells[3,26]:='��ѯ����λ��';
//  StringGridGameCmd.Cells[3,27]:='������޴���';
//  StringGridGameCmd.Cells[3,28]:='���޽��Է����͵����';
//  StringGridGameCmd.Cells[3,29]:='��ѯʦͽλ��';
//  StringGridGameCmd.Cells[3,30]:='����ʦͽ����';
//  StringGridGameCmd.Cells[3,31]:='ʦ����ͽ���ٻ������';
//  StringGridGameCmd.Cells[3,32]:='��������ģʽ(�����Ҫ�޸�)';
//  StringGridGameCmd.Cells[3,33]:='��������״̬(�����Ҫ�޸�)';
//  StringGridGameCmd.Cells[3,34]:='�����ƺ�������';
//  StringGridGameCmd.Cells[3,35]:='����������';
//  StringGridGameCmd.Cells[3,36]:='';
//  StringGridGameCmd.Cells[3,37]:='����/�رյ�¼��';

procedure TfrmGameCmd.RefUserCommand;
begin
  EditUserCmdOK.Enabled := False;
  nRefGameUserIndex := 0;
  RefGameUserCmd(@g_GameCommand.Data, '@' + g_GameCommand.Data.sCmd, '�鿴��ǰ����������ʱ��');
  RefGameUserCmd(@g_GameCommand.PRVMSG, '@' + g_GameCommand.PRVMSG.sCmd, '��ָֹ�����﷢��˽����Ϣ');
  RefGameUserCmd(@g_GameCommand.ALLOWMSG, '@' + g_GameCommand.ALLOWMSG.sCmd, '��ֹ�������Լ���˽����Ϣ');
  //RefGameUserCmd(@g_GameCommand.ALLOWFRIEND, '@' + g_GameCommand.ALLOWFRIEND.sCmd, '�������������Լ�Ϊ����');
  //RefGameUserCmd(@g_GameCommand.NOTALLOWFRIEND, '@' + g_GameCommand.NOTALLOWFRIEND.sCmd, '��ֹ����������Լ�Ϊ����');
  RefGameUserCmd(@g_GameCommand.LETSHOUT, '@' + g_GameCommand.LETSHOUT.sCmd, '��ֹ�������������Ϣ');
  RefGameUserCmd(@g_GameCommand.LETTRADE, '@' + g_GameCommand.LETTRADE.sCmd, '��ֹ���׽�����Ʒ');
  RefGameUserCmd(@g_GameCommand.LETGUILD, '@' + g_GameCommand.LETGUILD.sCmd, '��������л�');
  RefGameUserCmd(@g_GameCommand.ENDGUILD, '@' + g_GameCommand.ENDGUILD.sCmd, '�˳���ǰ��������л�');
  RefGameUserCmd(@g_GameCommand.BANGUILDCHAT, '@' + g_GameCommand.BANGUILDCHAT.sCmd, '��ֹ�����л�������Ϣ');
  RefGameUserCmd(@g_GameCommand.AUTHALLY, '@' + g_GameCommand.AUTHALLY.sCmd, '���л��������');
  RefGameUserCmd(@g_GameCommand.AUTH, '@' + g_GameCommand.AUTH.sCmd, '��ʼ�����л�����');
  RefGameUserCmd(@g_GameCommand.AUTHCANCEL, '@' + g_GameCommand.AUTHCANCEL.sCmd, 'ȡ���л����˹�ϵ');
  //exit;

  //StringGridGameCmd.Cells[0, 12] := g_GameCommand.DIARY.sCmd;
  //StringGridGameCmd.Cells[1, 12] := IntToStr(g_GameCommand.DIARY.nPermissionMin);
  //StringGridGameCmd.Cells[2, 12] := '@' + g_GameCommand.DIARY.sCmd;
  //StringGridGameCmd.Objects[0, 12] := TObject(@g_GameCommand.DIARY);
  RefGameUserCmd(@g_GameCommand.DIARY, '@' + g_GameCommand.DIARY.sCmd, '�鿴����ʼ�');

  //StringGridGameCmd.Cells[0, 13] := g_GameCommand.USERMOVE.sCmd;
  //StringGridGameCmd.Cells[1, 13] := IntToStr(g_GameCommand.USERMOVE.nPermissionMin);
  //StringGridGameCmd.Cells[2, 13] := '@' + g_GameCommand.USERMOVE.sCmd;
  //StringGridGameCmd.Objects[0, 13] := TObject(@g_GameCommand.USERMOVE);
  RefGameUserCmd(@g_GameCommand.USERMOVE, '@' + g_GameCommand.USERMOVE.sCmd + 'X:Y', '���͵�ָ������(�����ͽ�ָ)');

  //StringGridGameCmd.Cells[0, 14] := g_GameCommand.SEARCHING.sCmd;
  //StringGridGameCmd.Cells[1, 14] := IntToStr(g_GameCommand.SEARCHING.nPermissionMin);
  //StringGridGameCmd.Cells[2, 14] := '@' + g_GameCommand.SEARCHING.sCmd;
  //StringGridGameCmd.Objects[0, 14] := TObject(@g_GameCommand.SEARCHING);
  RefGameUserCmd(@g_GameCommand.SEARCHING, '@' + g_GameCommand.SEARCHING.sCmd + '������', '̽��ָ��������λ��(��̽������)');

  //StringGridGameCmd.Cells[0, 15] := g_GameCommand.ALLOWGROUPCALL.sCmd;
  //StringGridGameCmd.Cells[1, 15] := IntToStr(g_GameCommand.ALLOWGROUPCALL.nPermissionMin);
  //StringGridGameCmd.Cells[2, 15] := '@' + g_GameCommand.ALLOWGROUPCALL.sCmd;
  //StringGridGameCmd.Objects[0, 15] := TObject(@g_GameCommand.ALLOWGROUPCALL);
  RefGameUserCmd(@g_GameCommand.ALLOWGROUPCALL, '@' + g_GameCommand.ALLOWGROUPCALL.sCmd, '�Ƿ�������غ�һ');

  //StringGridGameCmd.Cells[0, 16] := g_GameCommand.GROUPRECALLL.sCmd;
  //StringGridGameCmd.Cells[1, 16] := IntToStr(g_GameCommand.GROUPRECALLL.nPermissionMin);
  //StringGridGameCmd.Cells[2, 16] := '@' + g_GameCommand.GROUPRECALLL.sCmd;
  //StringGridGameCmd.Objects[0, 16] := TObject(@g_GameCommand.GROUPRECALLL);
  RefGameUserCmd(@g_GameCommand.GROUPRECALLL, '@' + g_GameCommand.GROUPRECALLL.sCmd, '��ϼ�����װʹ����غ�һ����');

  //StringGridGameCmd.Cells[0, 17] := g_GameCommand.ALLOWGUILDRECALL.sCmd;
  //StringGridGameCmd.Cells[1, 17] := IntToStr(g_GameCommand.ALLOWGUILDRECALL.nPermissionMin);
  //StringGridGameCmd.Cells[2, 17] := '@' + g_GameCommand.ALLOWGUILDRECALL.sCmd;
  //StringGridGameCmd.Objects[0, 17] := TObject(@g_GameCommand.ALLOWGUILDRECALL);
  RefGameUserCmd(@g_GameCommand.ALLOWGUILDRECALL, '@' + g_GameCommand.ALLOWGUILDRECALL.sCmd, '�Ƿ������л��һ');

  //StringGridGameCmd.Cells[0, 18] := g_GameCommand.GUILDRECALLL.sCmd;
  //StringGridGameCmd.Cells[1, 18] := IntToStr(g_GameCommand.GUILDRECALLL.nPermissionMin);
  //StringGridGameCmd.Cells[2, 18] := '@' + g_GameCommand.GUILDRECALLL.sCmd;
  //StringGridGameCmd.Objects[0, 18] := TObject(@g_GameCommand.GUILDRECALLL);
  RefGameUserCmd(@g_GameCommand.GUILDRECALLL, '@' + g_GameCommand.GUILDRECALLL.sCmd, 'ʹ���л��һ����');

  //StringGridGameCmd.Cells[0, 19] := g_GameCommand.UNLOCKSTORAGE.sCmd;
  //StringGridGameCmd.Cells[1, 19] := IntToStr(g_GameCommand.UNLOCKSTORAGE.nPermissionMin);
  //StringGridGameCmd.Cells[2, 19] := '@' + g_GameCommand.UNLOCKSTORAGE.sCmd;
  //StringGridGameCmd.Objects[0, 19] := TObject(@g_GameCommand.UNLOCKSTORAGE);
  RefGameUserCmd(@g_GameCommand.UNLOCKSTORAGE, '@' + g_GameCommand.UNLOCKSTORAGE.sCmd, '�ֿ����뿪������');

  //StringGridGameCmd.Cells[0, 20] := g_GameCommand.UnLock.sCmd;
  //StringGridGameCmd.Cells[1, 20] := IntToStr(g_GameCommand.UnLock.nPermissionMin);
  //StringGridGameCmd.Cells[2, 20] := '@' + g_GameCommand.UnLock.sCmd;
  //StringGridGameCmd.Objects[0, 20] := TObject(@g_GameCommand.UnLock);
  RefGameUserCmd(@g_GameCommand.UnLock, '@' + g_GameCommand.UnLock.sCmd, '�������ģʽ����(����ģʽ��ʹ��)');

  //StringGridGameCmd.Cells[0, 21] := g_GameCommand.Lock.sCmd;
  //StringGridGameCmd.Cells[1, 21] := IntToStr(g_GameCommand.Lock.nPermissionMin);
  //StringGridGameCmd.Cells[2, 21] := '@' + g_GameCommand.Lock.sCmd;
  //StringGridGameCmd.Objects[0, 21] := TObject(@g_GameCommand.Lock);
  RefGameUserCmd(@g_GameCommand.Lock, '@' + g_GameCommand.Lock.sCmd, '�����ֿ�����');

  //StringGridGameCmd.Cells[0, 22] := g_GameCommand.SETPASSWORD.sCmd;
  //StringGridGameCmd.Cells[1, 22] := IntToStr(g_GameCommand.SETPASSWORD.nPermissionMin);
  //StringGridGameCmd.Cells[2, 22] := '@' + g_GameCommand.SETPASSWORD.sCmd;
  //StringGridGameCmd.Objects[0, 22] := TObject(@g_GameCommand.SETPASSWORD);
  RefGameUserCmd(@g_GameCommand.SETPASSWORD, '@' + g_GameCommand.SETPASSWORD.sCmd, '���ñ���ϵͳ������');

  //StringGridGameCmd.Cells[0, 23] := g_GameCommand.CHGPASSWORD.sCmd;
  //StringGridGameCmd.Cells[1, 23] := IntToStr(g_GameCommand.CHGPASSWORD.nPermissionMin);
  //StringGridGameCmd.Cells[2, 23] := '@' + g_GameCommand.CHGPASSWORD.sCmd;
  //StringGridGameCmd.Objects[0, 23] := TObject(@g_GameCommand.CHGPASSWORD);
  RefGameUserCmd(@g_GameCommand.CHGPASSWORD, '@' + g_GameCommand.CHGPASSWORD.sCmd, '�޸ı���ϵͳ������');

  //StringGridGameCmd.Cells[0, 24] := g_GameCommand.UNPASSWORD.sCmd;
  //StringGridGameCmd.Cells[1, 24] := IntToStr(g_GameCommand.UNPASSWORD.nPermissionMin);
  //StringGridGameCmd.Cells[2, 24] := '@' + g_GameCommand.UNPASSWORD.sCmd;
  //StringGridGameCmd.Objects[0, 24] := TObject(@g_GameCommand.UNPASSWORD);
  RefGameUserCmd(@g_GameCommand.UNPASSWORD, '@' + g_GameCommand.UNPASSWORD.sCmd, '����Ѿ����õı���ϵͳ����');

  //StringGridGameCmd.Cells[0, 25] := g_GameCommand.MEMBERFUNCTION.sCmd;
  //StringGridGameCmd.Cells[1, 25] := IntToStr(g_GameCommand.MEMBERFUNCTION.nPermissionMin);
  //StringGridGameCmd.Cells[2, 25] := '@' + g_GameCommand.MEMBERFUNCTION.sCmd;
  //StringGridGameCmd.Objects[0, 25] := TObject(@g_GameCommand.MEMBERFUNCTION);
  RefGameUserCmd(@g_GameCommand.MEMBERFUNCTION, '@' + g_GameCommand.MEMBERFUNCTION.sCmd, '���������ڴ򿪻�Ա���ܴ���');

  //StringGridGameCmd.Cells[0, 26] := g_GameCommand.DEAR.sCmd;
  //StringGridGameCmd.Cells[1, 26] := IntToStr(g_GameCommand.DEAR.nPermissionMin);
  //StringGridGameCmd.Cells[2, 26] := '@' + g_GameCommand.DEAR.sCmd;
  //StringGridGameCmd.Objects[0, 26] := TObject(@g_GameCommand.DEAR);
  RefGameUserCmd(@g_GameCommand.DEAR, '@' + g_GameCommand.DEAR.sCmd, '��ѯ���µ���λ��');

  //StringGridGameCmd.Cells[0, 27] := g_GameCommand.ALLOWDEARRCALL.sCmd;
  //StringGridGameCmd.Cells[1, 27] := IntToStr(g_GameCommand.ALLOWDEARRCALL.nPermissionMin);
  //StringGridGameCmd.Cells[2, 27] := '@' + g_GameCommand.ALLOWDEARRCALL.sCmd;
  //StringGridGameCmd.Objects[0, 27] := TObject(@g_GameCommand.ALLOWDEARRCALL);
  RefGameUserCmd(@g_GameCommand.ALLOWDEARRCALL, '@' + g_GameCommand.ALLOWDEARRCALL.sCmd, '�Ƿ��������֮��Ĵ�������');

  //StringGridGameCmd.Cells[0, 28] := g_GameCommand.DEARRECALL.sCmd;
  //StringGridGameCmd.Cells[1, 28] := IntToStr(g_GameCommand.DEARRECALL.nPermissionMin);
  //StringGridGameCmd.Cells[2, 28] := '@' + g_GameCommand.DEARRECALL.sCmd;
  //StringGridGameCmd.Objects[0, 28] := TObject(@g_GameCommand.DEARRECALL);
  RefGameUserCmd(@g_GameCommand.DEARRECALL, '@' + g_GameCommand.DEARRECALL.sCmd, 'ʹ�ð���֮��Ĵ�������');

  //StringGridGameCmd.Cells[0, 29] := g_GameCommand.MASTER.sCmd;
  //StringGridGameCmd.Cells[1, 29] := IntToStr(g_GameCommand.MASTER.nPermissionMin);
  //StringGridGameCmd.Cells[2, 29] := '@' + g_GameCommand.MASTER.sCmd;
  //StringGridGameCmd.Objects[0, 29] := TObject(@g_GameCommand.MASTER);
  RefGameUserCmd(@g_GameCommand.Master, '@' + g_GameCommand.Master.sCmd, '��ѯʦͽ֮��ĵ���λ��');

  //StringGridGameCmd.Cells[0, 30] := g_GameCommand.ALLOWMASTERRECALL.sCmd;
  //StringGridGameCmd.Cells[1, 30] := IntToStr(g_GameCommand.ALLOWMASTERRECALL.nPermissionMin);
  //StringGridGameCmd.Cells[2, 30] := '@' + g_GameCommand.ALLOWMASTERRECALL.sCmd;
  //StringGridGameCmd.Objects[0, 30] := TObject(@g_GameCommand.ALLOWMASTERRECALL);
  RefGameUserCmd(@g_GameCommand.ALLOWMASTERRECALL, '@' + g_GameCommand.ALLOWMASTERRECALL.sCmd, '�Ƿ�����ʦͽ֮��Ĵ�������');

  //StringGridGameCmd.Cells[0, 31] := g_GameCommand.MASTERECALL.sCmd;
  //StringGridGameCmd.Cells[1, 31] := IntToStr(g_GameCommand.MASTERECALL.nPermissionMin);
  //StringGridGameCmd.Cells[2, 31] := '@' + g_GameCommand.MASTERECALL.sCmd;
  //StringGridGameCmd.Objects[0, 31] := TObject(@g_GameCommand.MASTERECALL);
  RefGameUserCmd(@g_GameCommand.MASTERECALL, '@' + g_GameCommand.MASTERECALL.sCmd, 'ʦ������ͽ�ܵ�����');

  //StringGridGameCmd.Cells[0, 32] := g_GameCommand.ATTACKMODE.sCmd;
  //StringGridGameCmd.Cells[1, 32] := IntToStr(g_GameCommand.ATTACKMODE.nPermissionMin);
  //StringGridGameCmd.Cells[2, 32] := '@' + g_GameCommand.ATTACKMODE.sCmd;
  //StringGridGameCmd.Objects[0, 32] := TObject(@g_GameCommand.ATTACKMODE);
  RefGameUserCmd(@g_GameCommand.ATTACKMODE, '@' + g_GameCommand.ATTACKMODE.sCmd, '�����Լ��Ĺ���ģʽ');

  //StringGridGameCmd.Cells[0, 33] := g_GameCommand.REST.sCmd;
  //StringGridGameCmd.Cells[1, 33] := IntToStr(g_GameCommand.REST.nPermissionMin);
  //StringGridGameCmd.Cells[2, 33] := '@' + g_GameCommand.REST.sCmd;
  //StringGridGameCmd.Objects[0, 33] := TObject(@g_GameCommand.REST);
  RefGameUserCmd(@g_GameCommand.REST, '@' + g_GameCommand.REST.sCmd, '���������Ĺ���״̬');

  //StringGridGameCmd.Cells[0, 34] := g_GameCommand.TAKEONHORSE.sCmd;
  //StringGridGameCmd.Cells[1, 34] := IntToStr(g_GameCommand.TAKEONHORSE.nPermissionMin);
  //StringGridGameCmd.Cells[2, 34] := '@' + g_GameCommand.TAKEONHORSE.sCmd;
  //StringGridGameCmd.Objects[0, 34] := TObject(@g_GameCommand.TAKEONHORSE);
  RefGameUserCmd(@g_GameCommand.TAKEONHORSE, '@' + g_GameCommand.TAKEONHORSE.sCmd, '����(��Ҫ�ͻ���֧��-����2)');

  //StringGridGameCmd.Cells[0, 35] := g_GameCommand.TAKEOFHORSE.sCmd;
  //StringGridGameCmd.Cells[1, 35] := IntToStr(g_GameCommand.TAKEOFHORSE.nPermissionMin);
  //StringGridGameCmd.Cells[2, 35] := '@' + g_GameCommand.TAKEOFHORSE.sCmd;
  //StringGridGameCmd.Objects[0, 35] := TObject(@g_GameCommand.TAKEOFHORSE);
  RefGameUserCmd(@g_GameCommand.TAKEOFHORSE, '@' + g_GameCommand.TAKEOFHORSE.sCmd, '����(��Ҫ�ͻ���֧��-����2)');

  //StringGridGameCmd.Cells[0, 36] := g_GameCommand.MEMBERFUNCTIONEX.sCmd;
  //StringGridGameCmd.Cells[1, 36] := IntToStr(g_GameCommand.MEMBERFUNCTIONEX.nPermissionMin);
  //StringGridGameCmd.Cells[2, 36] := '@' + g_GameCommand.MEMBERFUNCTIONEX.sCmd;
  //StringGridGameCmd.Objects[0, 36] := TObject(@g_GameCommand.MEMBERFUNCTIONEX);
  RefGameUserCmd(@g_GameCommand.MEMBERFUNCTIONEX, '@' + g_GameCommand.MEMBERFUNCTIONEX.sCmd, '��ѯ��������(δ���)');

  //StringGridGameCmd.Cells[0, 37] := g_GameCommand.LOCKLOGON.sCmd;
  //StringGridGameCmd.Cells[1, 37] := IntToStr(g_GameCommand.LOCKLOGON.nPermissionMin);
  //StringGridGameCmd.Cells[2, 37] := '@' + g_GameCommand.LOCKLOGON.sCmd;
  //StringGridGameCmd.Objects[0, 37] := TObject(@g_GameCommand.LOCKLOGON);
  RefGameUserCmd(@g_GameCommand.LOCKLOGON, '@' + g_GameCommand.LOCKLOGON.sCmd, '��������ģʽ(��½����)');

  //StringGridGameCmd.Cells[0, 38] := g_GameCommand.OFFLINE.sCmd;
  //StringGridGameCmd.Cells[1, 38] := IntToStr(g_GameCommand.OFFLINE.nPermissionMin);
  //StringGridGameCmd.Cells[2, 38] := '@' + g_GameCommand.OFFLINE.sCmd;
  //StringGridGameCmd.Objects[0, 38] := TObject(@g_GameCommand.OFFLINE);
  //RefGameUserCmd(@g_GameCommand.OFFLINE, '@' + g_GameCommand.OFFLINE.sCmd, '�����ѻ��ݵ㹦��');

end;

procedure TfrmGameCmd.StringGridGameCmdClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
begin
  nIndex := StringGridGameCmd.Row;
  GameCmd := pTGameCmd(StringGridGameCmd.Objects[0, nIndex]);
  if GameCmd <> nil then
  begin
    EditUserCmdName.Text := GameCmd.sCmd;
    EditUserCmdPerMission.Value := GameCmd.nPermissionMin;
    LabelUserCmdParam.Caption := StringGridGameCmd.Cells[2, nIndex];
    LabelUserCmdFunc.Caption := StringGridGameCmd.Cells[3, nIndex];
  end;
  EditUserCmdOK.Enabled := False;
end;

procedure TfrmGameCmd.EditUserCmdNameChange(Sender: TObject);
begin
  EditUserCmdOK.Enabled := True;
  EditUserCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditUserCmdPerMissionChange(Sender: TObject);
begin
  EditUserCmdOK.Enabled := True;
  EditUserCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditUserCmdOKClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
  sCmd: string;
  nPermission: Integer;
begin
  sCmd := Trim(EditUserCmdName.Text);
  nPermission := EditUserCmdPerMission.Value;
  if sCmd = '' then
  begin
    Application.MessageBox('�������Ʋ���Ϊ��', '��ʾ��Ϣ', MB_OK + MB_ICONERROR);
    EditUserCmdName.SetFocus;
    Exit;
  end;

  nIndex := StringGridGameCmd.Row;
  GameCmd := pTGameCmd(StringGridGameCmd.Objects[0, nIndex]);
  if GameCmd <> nil then
  begin
    GameCmd.sCmd := sCmd;
    GameCmd.nPermissionMin := nPermission;
  end;
  RefUserCommand();
end;

procedure TfrmGameCmd.EditUserCmdSaveClick(Sender: TObject);
begin
  EditUserCmdSave.Enabled := False;
{$IF SoftVersion <> VERDEMO}
  CommandConf.WriteString('Command', 'Date', g_GameCommand.Data.sCmd);
  CommandConf.WriteString('Command', 'PrvMsg', g_GameCommand.PRVMSG.sCmd);
  CommandConf.WriteString('Command', 'ALLOWMSG', g_GameCommand.ALLOWMSG.sCmd);
  //CommandConf.WriteString('Command', 'ALLOWFRIEND', g_GameCommand.ALLOWFRIEND.sCmd);
  //CommandConf.WriteString('Command', 'NOTALLOWFRIEND', g_GameCommand.NOTALLOWFRIEND.sCmd);
  CommandConf.WriteString('Command', 'LetShout', g_GameCommand.LETSHOUT.sCmd);
  CommandConf.WriteString('Command', 'LetTrade', g_GameCommand.LETTRADE.sCmd);
  CommandConf.WriteString('Command', 'LeTGUild', g_GameCommand.LETGUILD.sCmd);
  CommandConf.WriteString('Command', 'EndGuild', g_GameCommand.ENDGUILD.sCmd);
  CommandConf.WriteString('Command', 'BanGuildChat', g_GameCommand.BANGUILDCHAT.sCmd);
  CommandConf.WriteString('Command', 'AuthAlly', g_GameCommand.AUTHALLY.sCmd);
  CommandConf.WriteString('Command', 'Auth', g_GameCommand.AUTH.sCmd);
  CommandConf.WriteString('Command', 'AuthCancel', g_GameCommand.AUTHCANCEL.sCmd);
  CommandConf.WriteString('Command', 'ViewDiary', g_GameCommand.DIARY.sCmd);
  CommandConf.WriteString('Command', 'UserMove', g_GameCommand.USERMOVE.sCmd);
  CommandConf.WriteString('Command', 'Searching', g_GameCommand.SEARCHING.sCmd);
  CommandConf.WriteString('Command', 'AllowGroupCall', g_GameCommand.ALLOWGROUPCALL.sCmd);
  CommandConf.WriteString('Command', 'GroupCall', g_GameCommand.GROUPRECALLL.sCmd);
  CommandConf.WriteString('Command', 'AllowGuildReCall', g_GameCommand.ALLOWGUILDRECALL.sCmd);
  CommandConf.WriteString('Command', 'GuildReCall', g_GameCommand.GUILDRECALLL.sCmd);
  CommandConf.WriteString('Command', 'StorageUnLock', g_GameCommand.UNLOCKSTORAGE.sCmd);
  CommandConf.WriteString('Command', 'PasswordUnLock', g_GameCommand.UnLock.sCmd);
  CommandConf.WriteString('Command', 'StorageLock', g_GameCommand.Lock.sCmd);
  CommandConf.WriteString('Command', 'StorageSetPassword', g_GameCommand.SETPASSWORD.sCmd);
  CommandConf.WriteString('Command', 'StorageChgPassword', g_GameCommand.CHGPASSWORD.sCmd);
  //CommandConf.WriteString('Command','StorageClearPassword',g_GameCommand.CLRPASSWORD.sCmd)
  //CommandConf.WriteInteger('Permission','StorageClearPassword', g_GameCommand.CLRPASSWORD.nPermissionMin)
  CommandConf.WriteString('Command', 'StorageUserClearPassword', g_GameCommand.UNPASSWORD.sCmd);
  CommandConf.WriteString('Command', 'MemberFunc', g_GameCommand.MEMBERFUNCTION.sCmd);
  //CommandConf.WriteString('Command', 'Offline', g_GameCommand.OFFLINE.sCmd);
  CommandConf.WriteString('Command', 'Dear', g_GameCommand.DEAR.sCmd);
  CommandConf.WriteString('Command', 'Master', g_GameCommand.Master.sCmd);
  CommandConf.WriteString('Command', 'DearRecall', g_GameCommand.DEARRECALL.sCmd);
  CommandConf.WriteString('Command', 'MasterRecall', g_GameCommand.MASTERECALL.sCmd);
  CommandConf.WriteString('Command', 'AllowDearRecall', g_GameCommand.ALLOWDEARRCALL.sCmd);
  CommandConf.WriteString('Command', 'AllowMasterRecall', g_GameCommand.ALLOWMASTERRECALL.sCmd);
  CommandConf.WriteString('Command', 'AttackMode', g_GameCommand.ATTACKMODE.sCmd);
  CommandConf.WriteString('Command', 'Rest', g_GameCommand.REST.sCmd);
  CommandConf.WriteString('Command', 'TakeOnHorse', g_GameCommand.TAKEONHORSE.sCmd);
  CommandConf.WriteString('Command', 'TakeOffHorse', g_GameCommand.TAKEOFHORSE.sCmd);
  CommandConf.WriteInteger('Permission', 'Date', g_GameCommand.Data.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'PrvMsg', g_GameCommand.PRVMSG.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ALLOWMSG', g_GameCommand.ALLOWMSG.nPermissionMin);
  //CommandConf.WriteInteger('Permission', 'ALLOWFRIEND', g_GameCommand.ALLOWFRIEND.nPermissionMin);
  //CommandConf.WriteInteger('Permission', 'NOTALLOWFRIEND', g_GameCommand.NOTALLOWFRIEND.nPermissionMin);
{$IFEND}
end;

procedure TfrmGameCmd.RefGameMasterCmd(GameCmd: pTGameCmd; sCmdParam, sDesc:
  string);
begin
  Inc(nRefGameMasterIndex);
  if StringGridGameMasterCmd.RowCount - 1 < nRefGameMasterIndex then
  begin
    StringGridGameMasterCmd.RowCount := nRefGameMasterIndex + 1;
  end;
  StringGridGameMasterCmd.Cells[0, nRefGameMasterIndex] := GameCmd.sCmd;
  StringGridGameMasterCmd.Cells[1, nRefGameMasterIndex] := IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameMasterCmd.Cells[2, nRefGameMasterIndex] := sCmdParam;
  StringGridGameMasterCmd.Cells[3, nRefGameMasterIndex] := sDesc;
  StringGridGameMasterCmd.Objects[0, nRefGameMasterIndex] := TObject(GameCmd);
end;

procedure TfrmGameCmd.RefGameMasterCommand;
begin
  EditGameMasterCmdOK.Enabled := False;
  nRefGameMasterIndex := 0;
  RefGameMasterCmd(@g_GameCommand.CLRPASSWORD, '@' + g_GameCommand.CLRPASSWORD.sCmd + ' ��������', '�������ֿ�/��¼����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.WHO, '@' + g_GameCommand.WHO.sCmd, '�鿴��ǰ��������������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.TOTAL, '@' + g_GameCommand.TOTAL.sCmd, '�鿴���з�������������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.GAMEMASTER, '@' + g_GameCommand.GAMEMASTER.sCmd, '����/�˳�����Աģʽ(����ģʽ�󲻻��ܵ��κν�ɫ����)(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.OBSERVER, '@' + g_GameCommand.OBSERVER.sCmd, '����/�˳�����ģʽ(����ģʽ����˿������Լ�)(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SUEPRMAN, '@' + g_GameCommand.SUEPRMAN.sCmd, '����/�˳��޵�ģʽ(����ģʽ�����ﲻ������)(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.MAKE, '@' + g_GameCommand.MAKE.sCmd + ' ��Ʒ���� ����', '����ָ����Ʒ(֧��Ȩ�޷��䣬С�����Ȩ����������ֹ�����б�����)');
  RefGameMasterCmd(@g_GameCommand.SMAKE, '@' + g_GameCommand.SMAKE.sCmd + ' �������ʹ��˵��', '�����Լ����ϵ���Ʒ����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.Move, '@' + g_GameCommand.Move.sCmd + ' ��ͼ��', '�ƶ���ָ����ͼ(֧��Ȩ�޷��䣬С�����Ȩ�����ܽ�ֹ���͵�ͼ�б�����)');
  RefGameMasterCmd(@g_GameCommand.POSITIONMOVE, '@' + g_GameCommand.POSITIONMOVE.sCmd + ' ��ͼ�� X Y', '�ƶ���ָ����ͼ(֧��Ȩ�޷��䣬С�����Ȩ�����ܽ�ֹ���͵�ͼ�б�����)');
  RefGameMasterCmd(@g_GameCommand.RECALL, '@' + g_GameCommand.RECALL.sCmd + ' ��������', '��ָ�������ٻ������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.REGOTO, '@' + g_GameCommand.REGOTO.sCmd + ' ��������', '����ָ������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.TING, '@' + g_GameCommand.TING.sCmd + ' ��������', '��ָ�������������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SUPERTING, '@' + g_GameCommand.SUPERTING.sCmd + ' �������� ��Χ��С', '��ָ���������ָ����Χ�ڵ������������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.MAPMOVE, '@' + g_GameCommand.MAPMOVE.sCmd + ' Դ��ͼ�� Ŀ���ͼ��', '��������ͼ�е������ƶ���������ͼ��(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.INFO, '@' + g_GameCommand.INFO.sCmd + ' ��������', '��������Ϣ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.HUMANLOCAL, '@' + g_GameCommand.HUMANLOCAL.sCmd + ' ��ͼ��', '��ѯ����IP���ڵ���(�����IP������ѯ���)(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.VIEWWHISPER, '@' + g_GameCommand.VIEWWHISPER.sCmd + ' ��������', '�鿴ָ�������˽����Ϣ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.MOBLEVEL, '@' + g_GameCommand.MOBLEVEL.sCmd, '�鿴��߽�ɫ��Ϣ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.MOBCOUNT, '@' + g_GameCommand.MOBCOUNT.sCmd + ' ��ͼ��', '�鿴��ͼ�й�������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.HUMANCOUNT, '@' + g_GameCommand.HUMANCOUNT.sCmd, '�鿴�������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.Map, '@' + g_GameCommand.Map.sCmd, '��ʾ��ǰ���ڵ�ͼ�����Ϣ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.Level, '@' + g_GameCommand.Level.sCmd, '�����Լ��ĵȼ�(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.KICK, '@' + g_GameCommand.KICK.sCmd + ' ��������', '��ָ������������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.ReAlive, '@' + g_GameCommand.ReAlive.sCmd + ' ��������', '��ָ�����︴��(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.KILL, '@' + g_GameCommand.KILL.sCmd + '��������', '��ָ����������ɱ��(ɱ����ʱ����Թ���)(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.CHANGEJOB, '@' + g_GameCommand.CHANGEJOB.sCmd + ' �������� ְҵ����(Warr Wizard Taos)', '���������ְҵ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.FREEPENALTY, '@' + g_GameCommand.FREEPENALTY.sCmd + ' ��������', '���ָ�������PKֵ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.PKPOINT, '@' + g_GameCommand.PKPOINT.sCmd + ' ��������', '�鿴ָ�������PKֵ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.IncPkPoint, '@' + g_GameCommand.IncPkPoint.sCmd + ' �������� ����', '����ָ�������PKֵ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.CHANGEGENDER, '@' + g_GameCommand.CHANGEGENDER.sCmd + ' �������� �Ա�(�С�Ů)', '����������Ա�(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.HAIR, '@' + g_GameCommand.HAIR.sCmd + ' ����ֵ', '����ָ�������ͷ������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.BonusPoint, '@' + g_GameCommand.BonusPoint.sCmd + ' �������� ���Ե���', '������������Ե���(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DELBONUSPOINT, '@' + g_GameCommand.DELBONUSPOINT.sCmd + ' ��������', 'ɾ����������Ե���(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.RESTBONUSPOINT, '@' + g_GameCommand.RESTBONUSPOINT.sCmd + ' ��������', '����������Ե������·���(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SETPERMISSION, '@' + g_GameCommand.SETPERMISSION.sCmd + ' �������� Ȩ�޵ȼ�(0 - 10)', '���������Ȩ�޵ȼ������Խ���ͨ������ΪGMȨ��(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.RENEWLEVEL, '@' + g_GameCommand.RENEWLEVEL.sCmd + ' �������� ����(Ϊ����鿴)', '�����鿴�����ת���ȼ�(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DELGOLD, '@' + g_GameCommand.DELGOLD.sCmd + ' �������� ����', 'ɾ������ָ�������Ľ��(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.ADDGOLD, '@' + g_GameCommand.ADDGOLD.sCmd + ' �������� ����', '��������ָ�������Ľ��(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.GAMEGOLD, '@' + g_GameCommand.GAMEGOLD.sCmd + ' �������� ���Ʒ�(+ - =) ����', '���������' + g_Config.sGameGoldName + '����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.GAMEPOINT, '@' + g_GameCommand.GAMEPOINT.sCmd + ' �������� ���Ʒ�(+ - =) ����', '�����������Ϸ������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.CREDITPOINT, '@' + g_GameCommand.CREDITPOINT.sCmd + ' �������� ���Ʒ�(+ - =) ����', '�����������������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.REFINEWEAPON, '@' + g_GameCommand.REFINEWEAPON.sCmd + ' ������ ħ���� ���� ׼ȷ��', '����������������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.ADJUESTLEVEL, '@' + g_GameCommand.ADJUESTLEVEL.sCmd + ' �������� �ȼ�', '����ָ������ĵȼ�(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.ADJUESTEXP, '@' + g_GameCommand.ADJUESTEXP.sCmd + ' �������� ����ֵ', '����ָ������ľ���ֵ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.CHANGEDEARNAME, '@' + g_GameCommand.CHANGEDEARNAME.sCmd + ' �������� ��ż����(���Ϊ �� �����)', '����ָ���������ż����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.CHANGEMASTERNAME, '@' + g_GameCommand.CHANGEMASTERNAME.sCmd + ' �������� ʦͽ����(���Ϊ �� �����)', '����ָ�������ʦͽ����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.RECALLMOB, '@' + g_GameCommand.RECALLMOB.sCmd + ' �������� ���� �ٻ��ȼ�', '�ٻ�ָ������Ϊ����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.TRAINING, '@' + g_GameCommand.TRAINING.sCmd + ' ��������  �������� �����ȼ�(0-3)', '��������ļ��������ȼ�(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.TRAININGSKILL, '@' + g_GameCommand.TRAININGSKILL.sCmd + ' ��������  �������� �����ȼ�(0-3)', '��ָ���������Ӽ���(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DELETESKILL, '@' + g_GameCommand.DELETESKILL.sCmd + ' �������� ��������(All)', 'ɾ������ļ��ܣ�All����ɾ��ȫ������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DELETEITEM, '@' + g_GameCommand.DELETEITEM.sCmd + ' �������� ��Ʒ���� ����', 'ɾ����������ָ������Ʒ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.CLEARMISSION, '@' + g_GameCommand.CLEARMISSION.sCmd + ' ��������', '�������������־(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.AddGuild, '@' + g_GameCommand.AddGuild.sCmd + ' �л����� ������', '�½�һ���л�(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DelGuild, '@' + g_GameCommand.DelGuild.sCmd + ' �л�����', 'ɾ��һ���л�(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.CHANGESABUKLORD, '@' + g_GameCommand.CHANGESABUKLORD.sCmd + ' �л�����', '���ĳǱ������л�(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.FORCEDWALLCONQUESTWAR, '@' + g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd, 'ǿ�п�ʼ/ֹͣ����ս(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.CONTESTPOINT, '@' + g_GameCommand.CONTESTPOINT.sCmd + ' �л�����', '�鿴�л��������÷����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.STARTCONTEST, '@' + g_GameCommand.STARTCONTEST.sCmd, '��ʼ�л�������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.ENDCONTEST, '@' + g_GameCommand.ENDCONTEST.sCmd, '�����л�������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.ANNOUNCEMENT, '@' + g_GameCommand.ANNOUNCEMENT.sCmd, '(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.MOB, '@' + g_GameCommand.MOB.sCmd + ' �������� ����', '����߷���ָ�����������Ĺ���(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.Mission, '@' + g_GameCommand.Mission.sCmd + ' X  Y', '���ù���ļ��е�(���й��﹥����)(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.MobPlace, '@' + g_GameCommand.MobPlace.sCmd + ' X  Y �������� ��������', '�ڵ�ǰ��ͼָ��XY���ù���(֧��Ȩ�޷���(�ȱ������ù���ļ��е�)�����õĹ�����������ṥ����Щ����');
  RefGameMasterCmd(@g_GameCommand.CLEARMON, '@' + g_GameCommand.CLEARMON.sCmd + ' ��ͼ��(* Ϊ����) ��������(* Ϊ����) ����Ʒ(0,1)', '�����ͼ�еĹ���(֧��Ȩ�޷���'')');
  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSG, '@' + g_GameCommand.DISABLESENDMSG.sCmd + ' ��������', '��ָ��������뷢�Թ����б������б���Լ����������Լ����Կ����������˿�����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.ENABLESENDMSG, '@' + g_GameCommand.ENABLESENDMSG.sCmd, '��ָ������ӷ��Թ����б���ɾ��(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSGLIST, '@' + g_GameCommand.DISABLESENDMSGLIST.sCmd, '�鿴���Թ����б��е�����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SHUTUP, '@' + g_GameCommand.SHUTUP.sCmd + ' ��������', '��ָ���������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.RELEASESHUTUP, '@' + g_GameCommand.RELEASESHUTUP.sCmd + ' ��������', '��ָ������ӽ����б���ɾ��(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SHUTUPLIST, '@' + g_GameCommand.SHUTUPLIST.sCmd, '�鿴�����б��е�����(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SABUKWALLGOLD, '@' + g_GameCommand.SABUKWALLGOLD.sCmd, '�鿴�Ǳ������(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.STARTQUEST, '@' + g_GameCommand.STARTQUEST.sCmd, '��ʼ���ʹ��ܣ���Ϸ��������ͬʱ�������ⴰ��(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DENYIPLOGON, '@' + g_GameCommand.DENYIPLOGON.sCmd + ' IP��ַ �Ƿ����÷�(0,1)', '��ָ��IP��ַ�����ֹ��¼�б�����ЩIP��¼���û����޷�������Ϸ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DENYACCOUNTLOGON, '@' + g_GameCommand.DENYACCOUNTLOGON.sCmd + ' ��¼�ʺ� �Ƿ����÷�(0,1)', '��ָ����¼�ʺż����ֹ��¼�б��Դ��ʺŵ�¼���û����޷�������Ϸ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DENYCHARNAMELOGON, '@' + g_GameCommand.DENYCHARNAMELOGON.sCmd + ' �������� �Ƿ����÷�(0,1)', '��ָ���������Ƽ����ֹ��¼�б������ｫ�޷�������Ϸ(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DELDENYIPLOGON, '@' + g_GameCommand.DELDENYIPLOGON.sCmd, '(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DELDENYACCOUNTLOGON, '@' + g_GameCommand.DELDENYACCOUNTLOGON.sCmd, '(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.DELDENYCHARNAMELOGON, '@' + g_GameCommand.DELDENYCHARNAMELOGON.sCmd, '(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SHOWDENYIPLOGON, '@' + g_GameCommand.SHOWDENYIPLOGON.sCmd, '(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SHOWDENYACCOUNTLOGON, '@' + g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd, '(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SHOWDENYCHARNAMELOGON, '@' + g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd, '(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.SetMapMode, '@' + g_GameCommand.SetMapMode.sCmd, '���õ�ͼģʽ');
  RefGameMasterCmd(@g_GameCommand.SHOWMAPMODE, '@' + g_GameCommand.SHOWMAPMODE.sCmd, '��ʾ��ͼģʽ');
  RefGameMasterCmd(@g_GameCommand.Attack, '@' + g_GameCommand.Attack.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.LUCKYPOINT, '@' + g_GameCommand.LUCKYPOINT.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.CHANGELUCK, '@' + g_GameCommand.CHANGELUCK.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.HUNGER, '@' + g_GameCommand.HUNGER.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.NameColor, '@' + g_GameCommand.NameColor.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.TRANSPARECY, '@' + g_GameCommand.TRANSPARECY.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.LEVEL0, '@' + g_GameCommand.LEVEL0.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.CHANGEITEMNAME, '@' + g_GameCommand.CHANGEITEMNAME.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.ADDTOITEMEVENT, '@' + g_GameCommand.ADDTOITEMEVENT.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.ADDTOITEMEVENTASPIECES, '@' + g_GameCommand.ADDTOITEMEVENTASPIECES.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.ItemEventList, '@' + g_GameCommand.ItemEventList.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.STARTINGGIFTNO, '@' + g_GameCommand.STARTINGGIFTNO.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.DELETEALLITEMEVENT, '@' + g_GameCommand.DELETEALLITEMEVENT.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.STARTITEMEVENT, '@' + g_GameCommand.STARTITEMEVENT.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.ITEMEVENTTERM, '@' + g_GameCommand.ITEMEVENTTERM.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.OPDELETESKILL, '@' + g_GameCommand.OPDELETESKILL.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.CHANGEWEAPONDURA, '@' + g_GameCommand.CHANGEWEAPONDURA.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.SBKDOOR, '@' + g_GameCommand.SBKDOOR.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.SPIRIT, '@' + g_GameCommand.SPIRIT.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.SPIRITSTOP, '@' + g_GameCommand.SPIRITSTOP.sCmd, '');
  RefGameMasterCmd(@g_GameCommand.SignMove, '@' + g_GameCommand.SignMove.sCmd, '�ƶ����ϴ������ĵ�ͼλ��(֧��Ȩ�޷���)');
  RefGameMasterCmd(@g_GameCommand.INITSABUK, '@' + g_GameCommand.INITSABUK.sCmd, '���³�ʼ��ɳ�Ϳ�������Ϣ(���ڹ�ɳ�쳣��֧��Ȩ�޷���)');
end;

procedure TfrmGameCmd.RefGameDebugCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);
begin
  Inc(nRefGameDebugIndex);
  if StringGridGameMasterCmd.RowCount - 1 < nRefGameDebugIndex then
  begin
    StringGridGameDebugCmd.RowCount := nRefGameDebugIndex + 1;
  end;
  StringGridGameDebugCmd.Cells[0, nRefGameDebugIndex] := GameCmd.sCmd;
  StringGridGameDebugCmd.Cells[1, nRefGameDebugIndex] := IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameDebugCmd.Cells[2, nRefGameDebugIndex] := sCmdParam;
  StringGridGameDebugCmd.Cells[3, nRefGameDebugIndex] := sDesc;
  StringGridGameDebugCmd.Objects[0, nRefGameDebugIndex] := TObject(GameCmd);
end;

procedure TfrmGameCmd.RefDebugCommand;
var
  GameCmd: pTGameCmd;
begin
  EditGameDebugCmdOK.Enabled := False;
  //  StringGridGameDebugCmd.RowCount:=41;
  GameCmd := @g_GameCommand.SHOWFLAG;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.SETFLAG;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.SHOWOPEN;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.SETOPEN;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.SHOWUNIT;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.SETUNIT;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.MOBNPC;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.DELNPC;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.LOTTERYTICKET;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.RELOADADMIN;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼��ع���Ա�б�');
  GameCmd := @g_GameCommand.ReLoadNpc;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼���NPC�ű�');
  GameCmd := @g_GameCommand.RELOADMANAGE;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼��ص�¼�ű�');
  GameCmd := @g_GameCommand.RELOADROBOTMANAGE;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼��ػ���������');
  GameCmd := @g_GameCommand.RELOADROBOT;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼��ػ����˽ű�');
  GameCmd := @g_GameCommand.RELOADMONITEMS;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼��ع��ﱬ������');
  GameCmd := @g_GameCommand.RELOADDIARY;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, 'δʹ��');
  GameCmd := @g_GameCommand.RELOADITEMDB;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼�����Ʒ���ݿ�');
  GameCmd := @g_GameCommand.RELOADMAGICDB;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, 'δʹ��');
  GameCmd := @g_GameCommand.RELOADMONSTERDB;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼��ع������ݿ�');
  GameCmd := @g_GameCommand.RELOADMINMAP;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼���С��ͼ����');
  GameCmd := @g_GameCommand.RELOADGUILD;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.RELOADGUILDALL;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.RELOADLINENOTICE;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼�����Ϸ������Ϣ');
  //GameCmd := @g_GameCommand.RELOADBANNERNOTICE;
  //RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼�����Ϸ������Ϣ');
  GameCmd := @g_GameCommand.RELOADABUSE;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '���¼����໰��������');
  GameCmd := @g_GameCommand.BACKSTEP;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.RECONNECTION;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '��ָ�����������л���������');
  GameCmd := @g_GameCommand.DISABLEFILTER;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '�����໰���˹���');
  GameCmd := @g_GameCommand.CHGUSERFULL;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.CHGZENFASTSTEP;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.OXQUIZROOM;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.BALL;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.FIREBURN;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.TESTFIRE;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.TESTSTATUS;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.TESTGOLDCHANGE;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.GSA;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.TESTGA;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '');
  GameCmd := @g_GameCommand.MAPINFO;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '��ʾ��ͼ��Ϣ');
  GameCmd := @g_GameCommand.CLEARBAG;
  RefGameDebugCmd(GameCmd, '@' + GameCmd.sCmd, '�������ȫ����Ʒ');
end;

procedure TfrmGameCmd.StringGridGameMasterCmdClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
begin
  nIndex := StringGridGameMasterCmd.Row;
  GameCmd := pTGameCmd(StringGridGameMasterCmd.Objects[0, nIndex]);
  if GameCmd <> nil then
  begin
    EditGameMasterCmdName.Text := GameCmd.sCmd;
    EditGameMasterCmdPerMission.Value := GameCmd.nPermissionMin;
    LabelGameMasterCmdParam.Caption := StringGridGameMasterCmd.Cells[2, nIndex];
    LabelGameMasterCmdFunc.Caption := StringGridGameMasterCmd.Cells[3, nIndex];
  end;
  EditGameMasterCmdOK.Enabled := False;
end;

procedure TfrmGameCmd.EditGameMasterCmdNameChange(Sender: TObject);
begin
  EditGameMasterCmdOK.Enabled := True;
  EditGameMasterCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameMasterCmdPerMissionChange(Sender: TObject);
begin
  EditGameMasterCmdOK.Enabled := True;
  EditGameMasterCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameMasterCmdOKClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
  sCmd: string;
  nPermission: Integer;
begin

  sCmd := Trim(EditGameMasterCmdName.Text);
  nPermission := EditGameMasterCmdPerMission.Value;
  if sCmd = '' then
  begin
    Application.MessageBox('�������Ʋ���Ϊ��', '��ʾ��Ϣ', MB_OK + MB_ICONERROR);
    EditGameMasterCmdName.SetFocus;
    Exit;
  end;

  nIndex := StringGridGameMasterCmd.Row;
  GameCmd := pTGameCmd(StringGridGameMasterCmd.Objects[0, nIndex]);
  if GameCmd <> nil then
  begin
    GameCmd.sCmd := sCmd;
    GameCmd.nPermissionMin := nPermission;
  end;
  RefGameMasterCommand();
end;

procedure TfrmGameCmd.EditGameMasterCmdSaveClick(Sender: TObject);
begin
  EditGameMasterCmdSave.Enabled := False;
{$IF SoftVersion <> VERDEMO}
  CommandConf.WriteString('Command', 'ObServer', g_GameCommand.OBSERVER.sCmd);
  CommandConf.WriteString('Command', 'GameMaster', g_GameCommand.GAMEMASTER.sCmd);
  CommandConf.WriteString('Command', 'SuperMan', g_GameCommand.SUEPRMAN.sCmd);
  CommandConf.WriteString('Command', 'StorageClearPassword', g_GameCommand.CLRPASSWORD.sCmd);
  CommandConf.WriteString('Command', 'Who', g_GameCommand.WHO.sCmd);
  CommandConf.WriteString('Command', 'Total', g_GameCommand.TOTAL.sCmd);
  CommandConf.WriteString('Command', 'Make', g_GameCommand.MAKE.sCmd);
  CommandConf.WriteString('Command', 'PositionMove', g_GameCommand.POSITIONMOVE.sCmd);
  CommandConf.WriteString('Command', 'Move', g_GameCommand.Move.sCmd);
  CommandConf.WriteString('Command', 'Recall', g_GameCommand.RECALL.sCmd);
  CommandConf.WriteString('Command', 'ReGoto', g_GameCommand.REGOTO.sCmd);
  CommandConf.WriteString('Command', 'Ting', g_GameCommand.TING.sCmd);
  CommandConf.WriteString('Command', 'SuperTing', g_GameCommand.SUPERTING.sCmd);
  CommandConf.WriteString('Command', 'MapMove', g_GameCommand.MAPMOVE.sCmd);
  CommandConf.WriteString('Command', 'Info', g_GameCommand.INFO.sCmd);
  CommandConf.WriteString('Command', 'HumanLocal', g_GameCommand.HUMANLOCAL.sCmd);
  CommandConf.WriteString('Command', 'ViewWhisper', g_GameCommand.VIEWWHISPER.sCmd);
  CommandConf.WriteString('Command', 'MobLevel', g_GameCommand.MOBLEVEL.sCmd);
  CommandConf.WriteString('Command', 'MobCount', g_GameCommand.MOBCOUNT.sCmd);
  CommandConf.WriteString('Command', 'HumanCount', g_GameCommand.HUMANCOUNT.sCmd);
  CommandConf.WriteString('Command', 'Map', g_GameCommand.Map.sCmd);
  CommandConf.WriteString('Command', 'Level', g_GameCommand.Level.sCmd);
  CommandConf.WriteString('Command', 'Kick', g_GameCommand.KICK.sCmd);
  CommandConf.WriteString('Command', 'ReAlive', g_GameCommand.ReAlive.sCmd);
  CommandConf.WriteString('Command', 'Kill', g_GameCommand.KILL.sCmd);
  CommandConf.WriteString('Command', 'ChangeJob', g_GameCommand.CHANGEJOB.sCmd);
  CommandConf.WriteString('Command', 'FreePenalty', g_GameCommand.FREEPENALTY.sCmd);
  CommandConf.WriteString('Command', 'PkPoint', g_GameCommand.PKPOINT.sCmd);
  CommandConf.WriteString('Command', 'IncPkPoint', g_GameCommand.IncPkPoint.sCmd);
  CommandConf.WriteString('Command', 'ChangeGender', g_GameCommand.CHANGEGENDER.sCmd);
  CommandConf.WriteString('Command', 'Hair', g_GameCommand.HAIR.sCmd);
  CommandConf.WriteString('Command', 'BonusPoint', g_GameCommand.BonusPoint.sCmd);
  CommandConf.WriteString('Command', 'DelBonuPoint', g_GameCommand.DELBONUSPOINT.sCmd);
  CommandConf.WriteString('Command', 'RestBonuPoint', g_GameCommand.RESTBONUSPOINT.sCmd);
  CommandConf.WriteString('Command', 'SetPermission', g_GameCommand.SETPERMISSION.sCmd);
  CommandConf.WriteString('Command', 'ReNewLevel', g_GameCommand.RENEWLEVEL.sCmd);
  CommandConf.WriteString('Command', 'DelGold', g_GameCommand.DELGOLD.sCmd);
  CommandConf.WriteString('Command', 'AddGold', g_GameCommand.ADDGOLD.sCmd);
  CommandConf.WriteString('Command', 'GameGold', g_GameCommand.GAMEGOLD.sCmd);
  CommandConf.WriteString('Command', 'GamePoint', g_GameCommand.GAMEPOINT.sCmd);
  CommandConf.WriteString('Command', 'CreditPoint', g_GameCommand.CREDITPOINT.sCmd);
  CommandConf.WriteString('Command', 'RefineWeapon', g_GameCommand.REFINEWEAPON.sCmd);
  CommandConf.WriteString('Command', 'AdjuestTLevel', g_GameCommand.ADJUESTLEVEL.sCmd);
  CommandConf.WriteString('Command', 'AdjuestExp', g_GameCommand.ADJUESTEXP.sCmd);
  CommandConf.WriteString('Command', 'ChangeDearName', g_GameCommand.CHANGEDEARNAME.sCmd);
  CommandConf.WriteString('Command', 'ChangeMasterrName', g_GameCommand.CHANGEMASTERNAME.sCmd);
  CommandConf.WriteString('Command', 'RecallMob', g_GameCommand.RECALLMOB.sCmd);
  CommandConf.WriteString('Command', 'Training', g_GameCommand.TRAINING.sCmd);
  CommandConf.WriteString('Command', 'OpTraining', g_GameCommand.TRAININGSKILL.sCmd);
  CommandConf.WriteString('Command', 'DeleteSkill', g_GameCommand.DELETESKILL.sCmd);
  CommandConf.WriteString('Command', 'DeleteItem', g_GameCommand.DELETEITEM.sCmd);
  CommandConf.WriteString('Command', 'ClearMission', g_GameCommand.CLEARMISSION.sCmd);
  CommandConf.WriteString('Command', 'AddGuild', g_GameCommand.AddGuild.sCmd);
  CommandConf.WriteString('Command', 'DelGuild', g_GameCommand.DelGuild.sCmd);
  CommandConf.WriteString('Command', 'ChangeSabukLord', g_GameCommand.CHANGESABUKLORD.sCmd);
  CommandConf.WriteString('Command', 'ForcedWallConQuestWar', g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd);
  CommandConf.WriteString('Command', 'ContestPoint', g_GameCommand.CONTESTPOINT.sCmd);
  CommandConf.WriteString('Command', 'StartContest', g_GameCommand.STARTCONTEST.sCmd);
  CommandConf.WriteString('Command', 'EndContest', g_GameCommand.ENDCONTEST.sCmd);
  CommandConf.WriteString('Command', 'Announcement', g_GameCommand.ANNOUNCEMENT.sCmd);
  CommandConf.WriteString('Command', 'MobLevel', g_GameCommand.MOBLEVEL.sCmd);
  CommandConf.WriteString('Command', 'Mission', g_GameCommand.Mission.sCmd);
  CommandConf.WriteString('Command', 'MobPlace', g_GameCommand.MobPlace.sCmd);
  CommandConf.WriteString('Command', 'ClearMon', g_GameCommand.CLEARMON.sCmd);
  CommandConf.WriteString('Command', 'SignMove', g_GameCommand.SignMove.sCmd);
  CommandConf.WriteString('Command', 'InitSabuk', g_GameCommand.SignMove.sCmd);

  CommandConf.WriteInteger('Permission', 'GameMaster', g_GameCommand.GAMEMASTER.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ObServer', g_GameCommand.OBSERVER.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'SuperMan', g_GameCommand.SUEPRMAN.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'StorageClearPassword', g_GameCommand.CLRPASSWORD.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Who', g_GameCommand.WHO.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Total', g_GameCommand.TOTAL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'MakeMin', g_GameCommand.MAKE.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'MakeMax', g_GameCommand.MAKE.nPermissionMax);
  CommandConf.WriteInteger('Permission', 'PositionMoveMin', g_GameCommand.POSITIONMOVE.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'PositionMoveMax', g_GameCommand.POSITIONMOVE.nPermissionMax);
  CommandConf.WriteInteger('Permission', 'MoveMin', g_GameCommand.Move.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'MoveMax', g_GameCommand.Move.nPermissionMax);
  CommandConf.WriteInteger('Permission', 'Recall', g_GameCommand.RECALL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ReGoto', g_GameCommand.REGOTO.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Ting', g_GameCommand.TING.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'SuperTing', g_GameCommand.SUPERTING.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'MapMove', g_GameCommand.MAPMOVE.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Info', g_GameCommand.INFO.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'HumanLocal', g_GameCommand.HUMANLOCAL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ViewWhisper', g_GameCommand.VIEWWHISPER.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'MobLevel', g_GameCommand.MOBLEVEL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'MobCount', g_GameCommand.MOBCOUNT.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'HumanCount', g_GameCommand.HUMANCOUNT.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Map', g_GameCommand.Map.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Level', g_GameCommand.Level.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Kick', g_GameCommand.KICK.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ReAlive', g_GameCommand.ReAlive.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Kill', g_GameCommand.KILL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ChangeJob', g_GameCommand.CHANGEJOB.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'FreePenalty', g_GameCommand.FREEPENALTY.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'PkPoint', g_GameCommand.PKPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'IncPkPoint', g_GameCommand.IncPkPoint.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ChangeGender', g_GameCommand.CHANGEGENDER.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Hair', g_GameCommand.HAIR.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'BonusPoint', g_GameCommand.BonusPoint.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'DelBonuPoint', g_GameCommand.DELBONUSPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'RestBonuPoint', g_GameCommand.RESTBONUSPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'SetPermission', g_GameCommand.SETPERMISSION.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ReNewLevel', g_GameCommand.RENEWLEVEL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'DelGold', g_GameCommand.DELGOLD.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'AddGold', g_GameCommand.ADDGOLD.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'GameGold', g_GameCommand.GAMEGOLD.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'GamePoint', g_GameCommand.GAMEPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'CreditPoint', g_GameCommand.CREDITPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'RefineWeapon', g_GameCommand.REFINEWEAPON.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'AdjuestTLevel', g_GameCommand.ADJUESTLEVEL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'AdjuestExp', g_GameCommand.ADJUESTEXP.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ChangeDearName', g_GameCommand.CHANGEDEARNAME.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ChangeMasterName', g_GameCommand.CHANGEMASTERNAME.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'RecallMob', g_GameCommand.RECALLMOB.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Training', g_GameCommand.TRAINING.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'OpTraining', g_GameCommand.TRAININGSKILL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'DeleteSkill', g_GameCommand.DELETESKILL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'DeleteItem', g_GameCommand.DELETEITEM.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ClearMission', g_GameCommand.CLEARMISSION.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'AddGuild', g_GameCommand.AddGuild.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'DelGuild', g_GameCommand.DelGuild.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ChangeSabukLord', g_GameCommand.CHANGESABUKLORD.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ForcedWallConQuestWar', g_GameCommand.FORCEDWALLCONQUESTWAR.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ContestPoint', g_GameCommand.CONTESTPOINT.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'StartContest', g_GameCommand.STARTCONTEST.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'EndContest', g_GameCommand.ENDCONTEST.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Announcement', g_GameCommand.ANNOUNCEMENT.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'MobLevel', g_GameCommand.MOBLEVEL.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'Mission', g_GameCommand.Mission.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'MobPlace', g_GameCommand.MobPlace.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'ClearMon', g_GameCommand.CLEARMON.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'SignMoveMin', g_GameCommand.SignMove.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'SignMoveMax', g_GameCommand.SignMove.nPermissionMax);
  CommandConf.WriteInteger('Permission', 'InitSabukMin', g_GameCommand.INITSABUK.nPermissionMin);
  CommandConf.WriteInteger('Permission', 'InitSabukMax', g_GameCommand.INITSABUK.nPermissionMax);

{$IFEND}
end;

procedure TfrmGameCmd.StringGridGameDebugCmdClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
begin
  nIndex := StringGridGameDebugCmd.Row;
  GameCmd := pTGameCmd(StringGridGameDebugCmd.Objects[0, nIndex]);
  if GameCmd <> nil then
  begin
    EditGameDebugCmdName.Text := GameCmd.sCmd;
    EditGameDebugCmdPerMission.Value := GameCmd.nPermissionMin;
    LabelGameDebugCmdParam.Caption := StringGridGameDebugCmd.Cells[2, nIndex];
    LabelGameDebugCmdFunc.Caption := StringGridGameDebugCmd.Cells[3, nIndex];
  end;
  EditGameDebugCmdOK.Enabled := False;
end;

procedure TfrmGameCmd.EditGameDebugCmdNameChange(Sender: TObject);
begin
  EditGameDebugCmdOK.Enabled := True;
  EditGameDebugCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameDebugCmdPerMissionChange(Sender: TObject);
begin
  EditGameDebugCmdOK.Enabled := True;
  EditGameDebugCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameDebugCmdOKClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
  sCmd: string;
  nPermission: Integer;
begin
  sCmd := Trim(EditGameDebugCmdName.Text);
  nPermission := EditGameDebugCmdPerMission.Value;
  if sCmd = '' then
  begin
    Application.MessageBox('�������Ʋ���Ϊ��', '��ʾ��Ϣ', MB_OK + MB_ICONERROR);
    EditGameDebugCmdName.SetFocus;
    Exit;
  end;

  nIndex := StringGridGameDebugCmd.Row;
  GameCmd := pTGameCmd(StringGridGameDebugCmd.Objects[0, nIndex]);
  if GameCmd <> nil then
  begin
    GameCmd.sCmd := sCmd;
    GameCmd.nPermissionMin := nPermission;
  end;
  RefDebugCommand();
end;

procedure TfrmGameCmd.EditGameDebugCmdSaveClick(Sender: TObject);
begin
  EditGameDebugCmdSave.Enabled := False;
end;

end.
