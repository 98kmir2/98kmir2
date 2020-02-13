unit ShareVar;

interface

uses
  Windows, SysUtils, Classes, IniFiles, SyncObjs, StrUtils, HashList, GList;

const
  g_sUserMsg                : array[0..7] of Char = '********';
  DEF_SEND_COUNT            = 5;
  SEND_TIME_OUT             = 62 * 1000;
  RUNLOGINCODE              = 0;
  RUNLOGINCODE2             = 1;

type
  TBlockIPMethod = (mDisconnect, mBlock, mBlockList);
  TSpeedHackPunish = (ptTurnPack, ptDropPack, ptNullPack, ptDelaySend);
  TSpeedHackWarning = (ptSysmsg, ptMenuOK);
  TCSState = (stConnecting, stConnected, stTimeOut);
  TFiltMsgMethod = (mReplaceAll, mReplaceOne, mDropconnect);

  //TPunishOverPackage = (tKick, tParalysis);

  TMagDelayList = array[0..127] of Integer;

  TGameGateList = record
    sServerAdress: string[15];
    nServerPort: Integer;
    nGatePort: Integer;
  end;
  PTGameGateList = ^TGameGateList;

  TRunGateCltMsg = record
    dwDelayTime: DWORD;
    nMagID: Integer;
    nIndex: Integer;
    nDirect: Integer;
    nBufLen: Integer;
    PBuffer: PChar;
  end;
  PTRunGateCltMsg = ^TRunGateCltMsg;

var
  //g_CSDynSendList           : TRTLCriticalSection;
  //g_DynSendListCnt          : Integer = 0;

  g_HitSpeedRate            : Integer = 0;
  g_MagSpeedRate            : Integer = 0;
  g_MoveSpeedRate           : Integer = 0;

  g_GameGateList            : array[1..32] of TGameGateList;
  g_bUpdate                 : BOOL;     //ȫ�ָ��±�־
  g_boStarted               : Boolean = False;
  g_boClose                 : Boolean = False;
  g_boServiceStart          : Boolean = False;
  g_boGateReady             : Boolean = False;
  g_sGateMain               : string = 'Main';
  g_sGateClass              : string = 'GameGate';
  g_sConfFile               : string;
  g_sGateName               : string = '��Ϸ����';
  g_sTitleName              : string = '��Ѫ����';
  g_IniConfig               : TIniFile;
  CS_MainLog                : TCriticalSection;
  g_MainLogMsgList          : TStringList;
  g_TempLogList             : TStringList;
  g_AbuseList               : TGStringList;
  //g_FilterGetMsgList        : TGStringList;

  g_BlockIPList             : THStringList;
  g_TempBlockIPList         : THStringList;
  g_SpeedHackUserList       : THStringList;

  g_boShowBite              : Boolean = False;
  g_IsUseEncode             : Boolean = True;
  g_nShowLogLevel           : Integer = 3;
  g_nGateCount              : Integer = 3;
  g_nMaxConnOfIPaddr        : Integer = 50;
  g_nMaxClientPacketSize    : Integer = 12000;
  g_nNomClientPacketSize    : Integer = 2000;
  g_nMaxClientMsgCount      : Integer = 15;
  g_bokickOverPacketSize    : Boolean = True;
  g_boNoNullConnect         : Boolean = False;
  g_BlockMethod             : TBlockIPMethod = mDisconnect;
  g_nClientSendBlockSize    : Integer = 8 * 1000;
  g_dwCheckServerTimeOutTime: LongWord = 62 * 1000;
  g_nPickUpItemInvTime      : Integer = 400;
  g_nEatItemInvTime         : Integer = 320;
  g_nSpaceMovePickUpInvTime : Integer = 600;
  g_sCmdMove                : string = 'move';

  g_SLMoveTime              : Integer = 0100;
  g_SLAttackTime            : Integer = 0100;
  g_SLMagicTime             : Integer = 0100;
  g_nKickUserOverPackCnt    : BOOL = True;

  B_MAX_PROCESS_MSG_TIME    : BOOL = False;
  MAX_PROCESS_MSG_TIME      : Integer = 120;
  MAX_ITEM_SPEED            : Integer = 60;
  MAX_ITEM_SPEED2           : Integer = 6;

  MOVE_INV_TIME             : Integer = 0640; //�ƶ����
  ATTACK_INV_TIME           : Integer = 0900; //�������
  TURN_INV_TIME             : Integer = 0380; //ת����
  DIG_INV_TIME              : Integer = 0450; //������
  MAX_SQUAT_TIME            : Integer = 0450; //�׵ļ��
  CHAT_INV_TIME             : Integer = 1000; //������

  COMPENSATE_MOVE_VALUE     : Integer = 4000; //�೤ʱ��ָ��ƶ���ʱ
  COMPENSATE_ATTACK_VALUE   : Integer = 4200; //�೤ʱ��ָ�������ʱ
  COMPENSATE_MAGIC_VALUE    : Integer = 4000; //�೤ʱ��ָ�ħ����ʱ

  PUNISH_MAX_TIME           : Integer = 20; //�Լ��ٵĳͷ�
  SpeedHackPunishRate       : Double = 1.00;

  MAX_ACTION_COMPENSATE     : Integer = 0280; //������ӵĲ��������100
  MAX_SPELL_COMPENSATE      : Integer = 0080; //������ӵĲ��������100

  ACTION_INV_TIME           : Integer = 0200; //�ͷŹ���Ҫͣ�೤ʱ����ܿ�ʼ�ƶ�
  NEXT_ACTION_TIME          : Integer = 0200; //������ħ���ļ��
  //NEXT_ACTION_TIME_LIMIT    : Integer = 0520; //����ǹ������͵�ħ��

  g_SpeedRateCtrl           : BOOL = False;
  g_NewHint                 : BOOL = True;
  g_synatcvalue             : BOOL = True;
  g_boAutoBlockIP           : BOOL = False;
  B_CMDFILTER               : BOOL = False;
  B_DEFENCE_CC              : BOOL = True;
  B_SPACEMOVE_INV_TIME      : BOOL = False;
  B_EAT_INV_TIME            : BOOL = True;
  B_PICKUP_INV_TIME         : BOOL = True;
  B_MOVE_INV_TIME           : BOOL = True;
  B_ATTACK_INV_TIME         : BOOL = True;
  B_TURN_INV_TIME           : BOOL = True;
  B_DIG_INV_TIME            : BOOL = True;
  B_MAX_SQUAT_TIME          : BOOL = True;
  B_CHAT_INV_TIME           : BOOL = True;
  B_MAGIC_INV_TIME          : BOOL = True;

  B_WARNING                 : BOOL = False;
  B_FILTER                  : BOOL = False;
  SPEED_HACK_WARNING        : string = '[��ʾ]���밮����Ϸ�������رռ���������µ�½��';
  PACKETERR_MSG             : string = '[����]����Ϸ���ӱ��Ͽ���ԭ��1-ʹ�÷Ƿ���� 2-�ͻ��˲����� 3-�����������Ŀͻ��������������µ�½������';
  g_VersionErrMsg           : string = '[��ʾ]��\�ͻ��˰汾�����µ�½�����أ�\http://www.�����վ.com\(CTRL+V ճ��)';
  FILTER_REPLACE_STR        : string = '˵�����ݱ�����';

  CMDFILTERMSG              : string = '%s �������ȷ����û���㹻��Ȩ�ޣ�';

  g_SpeedHackPunish         : TSpeedHackPunish = ptDelaySend;
  g_SpeedHackWarningType    : TSpeedHackWarning = ptMenuOK;
  g_FiltMsgMethod           : TFiltMsgMethod = mReplaceAll;

  MAIGIC_DELAY_ARRAY        : array[0..127] of BOOL = (True,
    True, True, True, True, True, True, False, True, True, True, True, False, //1~12
    True, True, True, True, True, True, True, True, True, True, True, True, //13~24
    False, False, False, True, True, True, True, True, True, True, False, True, //25~36
    True, True, True, False, False, False, False, True, True, True, True, True, //37~48
    True, True, True, True, True, True, False, False, True, True, False, False, //49~60
    False, False, False, False, False, False, True, True, True, True, True, True, //61~72
    True, True, True, True, True, True, True, True, True, True, True, True, //73~84
    True, True, True, True, True, True, True, True, True, True, True, True, //85~96
    True, True, True,                   //97~99
    True, True, True, True, True, True, True, True, True, True, True, True, //100..111
    True, True, False, False, True, True, False, False, False, //112~119
    False, False, False, False, False, False, False); //120~128

  MAIGIC_ATTACK_ARRAY       : array[0..127] of BOOL = (
    False,
    True,                               //С����
    False,                              //������
    False,                              //��������
    False,                              //������ս��
    True,                               //�����
    True,                               //ʩ����
    False, False,
    True,                               //��������
    True,                               //�����׹�
    True,                               //�׵���
    False,                              //12
    True,                               //������
    False, False, False, False, False, False, False, False,
    True,                               //��ǽ
    True,                               //���ѻ���
    True,                               //�����׹�
    False, False, False, False, False, False, False,
    True,                               //ʥ����
    True,                               //������
    False, False,
    True,                               //�����
    True,                               //ʨ�Ӻ� - Ⱥ���׵���
    True,                               //Ⱥ��ʩ����
    True,                               //���ض�
    False,                              //40
    True,                               //ʨ�Ӻ�
    False,
    False,
    True,                               //������
    True,                               //�����
    False,
    True,                               //��������
    False,                              //37~48
    False,                              //������
    False,                              //�޼�����
    True,                               //51
    True,                               //52
    True,                               //53
    True,                               //54
    False,                              //55
    False,                              //���ս���
    True,                               //��Ѫ��
    True,                               //���ǻ���
    False,                              //59
    False,                              //60
    False,                              //61
    False,                              //62
    False,                              //63
    False,                              //64
    False,                              //65
    False,                              //66
    False,                              //67
    False,
    False,
    False,
    True,                               //71������
    True, True, True, True, True, True, True, True, True, True, True, True,
    True, True, True, True, True, True, True, True, True, True, True, True, //84~95
    True, True, True, True,             //96..99
    True, True, True, True, True, True, True, True, True, True, True, True, //100~111
    True, True, True, True, True, True, True, True, //112
    True, True, True, True, True, True, True, True); //120~128

  //ħ�����ӳٱ�
  MAIGIC_DELAY_TIME_LIST2   : TMagDelayList;
  MAIGIC_DELAY_TIME_LIST    : TMagDelayList = (
    //MAIGIC_DELAY_TIME_LIST    : array[0..127] of Integer = (
    60000,
    {01}1110 + 60,                      //С����
    {02}1110 + 40,                      //������
    {03}1110,                           //��������
    {04}1110,                           //����ս��
    {05}1110 + 60,                      //�����
    {06}1110 + 40,                      //ʩ����
    {07}1110,                           //��ɱ����
    {08}1110 + 30,                      //���ܻ�
    {09}1110 + 60,                      //������
    {10}1110 + 100,                     //�����Ӱ
    {11}1110 + 100,                     //�׵���
    {12}1110,                           //��ɱ����
    {13}1110 + 60,                      //�����
    {14}1110 + 40,                      //�����
    {15}1110 + 40,                      //��ʥս����
    {16}1110 + 50,                      //��ħ��
    {17}1110 + 50,                      //�ٻ�����
    {18}1110 + 50,                      //������
    {19}1110 + 50,                      //����������
    {20}1110 + 60,                      //�ջ�֮��
    {21}1110 + 50,                      //˲Ϣ�ƶ�
    {22}1110 + 120,                     //��ǽ
    {23}1110 + 60,                      //���ѻ���
    {24}1110 + 60,                      //�����׹�
    {25}1110,                           //�����䵶
    {26}1110,                           //�һ𽣷�
    {27}1110,                           //Ұ����ײ
    {28}1110 + 40,                      //������ʾ
    {29}1110 + 40,                      //Ⱥ��������
    {30}1110 + 120,                     //�ٻ�����
    {31}1110,                           //ħ����
    {32}1320 - 90,                      //ʥ����
    {33}1260 - 90,                      //������
    {34}1240 - 90,                      //�ⶾ��
    {35}1260 - 90,                      //��ʨ�Ӻ�
    {36}1260 - 90,                      //�����
    {37}1320 - 90,                      //Ⱥ���׵���
    {38}1320 - 90,                      //Ⱥ��ʩ����
    {39}1320 - 90,                      //���ض�
    {40}1110,                           //˫��ն
    {41}1230 - 90,                      //ʨ�Ӻ�
    {42}1110,                           //��Ӱ����
    {43}1110,                           //��������
    {44}1260 - 90,                      //������
    {45}1260 - 90,                      //�����
    {46}1260 - 90,                      //�ٻ�Ӣ��
    {47}1260 - 90,                      //��������
    {48}1230 - 90,                      //������
    {49}1240 - 90,                      //������
    {50}1230 - 90,                      //�޼�����
    {51}1240 - 90,                      //쫷���
    {52}1240 - 90,                      //������
    {53}1240 - 90,                      //Ѫ��
    {54}1260 - 90,                      //������
    {55}1260 - 90,                      //
    {56}1110,                           //���ս���
    {57}1260 - 90,                      //��Ѫ��
    {58}1320 - 90,                      //���ǻ���
    {59}1300,                           //
    {60}200,                            //�ƻ�ն
    {61}200,                            //����ն
    {62}200,                            //����һ��
    {63}200,                            //�ɻ�����
    {64}200,                            //ĩ������
    {65}200,                            //��������
    {66}1500 - 90,                      //Ӣ�ۿ���ն
    {67}1800 - 90,                      //
    {68}1110,                           //
    {69}1110,                           //
    {70}1700 - 90,                      //�����ٻ�
    {71}1800 - 90,                      //Ӣ��������
    {72}1110,                           //
    {73}1110,                           //
    {74}100,                            //Ӣ�۷�����
    {75}100,                            //Ӣ�ۻ������
    {76}100,                            //
    {77}100,                            //
    {78}100,                            //
    {79}100,                            //
    {80}100,                            //
    {81}100,                            //
    {82}100,                            //
    {83}100,                            //
    {84}100,                            //
    {85}100,                            //
    {86}100,                            //
    {87}100,                            //
    100, 100, 100, 100,
    100, 100, 100, 100, 100, 100, 100, 100,
    350, 350, 350, 350, 350, 350, 350, 350, 350, 350, 350, 350, //100~111
    1300, 100, 100, 100, 100, 100, 100, 100, 100, 100,
    100, 100, 100, 100, 100, 100);

  MAIGIC_NAME_LIST          : array[0..127] of string = (
    '',
    '������',
    '������',
    '��������',
    '������ս��',
    '�����',
    'ʩ����',
    '��ɱ����',
    '���ܻ�',
    '������',
    '�����Ӱ',
    '�׵���',
    '��ɱ����',
    '�����',
    '�����',
    '��ʥս����',
    '��ħ��',
    '�ٻ�����',
    '������',
    '����������',
    '�ջ�֮��',
    '˲Ϣ�ƶ�',
    '��ǽ',
    '���ѻ���',
    '�����׹�',
    '�����䵶',
    '�һ𽣷�',
    'Ұ����ײ',
    '������ʾ',
    'Ⱥ��������',
    '�ٻ�����',
    'ħ����',
    'ʥ����',
    '������',
    '�ⶾ��',
    '��ʨ�Ӻ�',
    '�����',
    'Ⱥ���׵���',
    'Ⱥ��ʩ����',
    '���ض�',
    '˫��ն',
    'ʨ�Ӻ�',
    '��Ӱ����',
    '��������',
    '������',
    '�����',
    '�ٻ�Ӣ��',
    '��������',
    '������',
    '������',
    '�޼�����',
    '쫷���',
    '������',
    'Ѫ��',
    '������',
    '',
    '���ս���',
    '��Ѫ��',
    '���ǻ���',
    '',
    '�ƻ�ն',
    '����ն',
    '����һ��',
    '�ɻ�����',
    'ĩ������',
    '��������',
    '����ն',                        //66
    '���ؽ��',                     //67
    'Ψ�Ҷ���',                     //68
    '',
    'Ӣ�۳���',
    '������',                        //71
    '',
    '',
    '',
    '�������',
    '',
    '',
    '',                                 //78
    '',
    '',
    '',                                 //81
    '',
    '',                                 //83
    '',                                 //84
    '',
    '',
    '',                                 //87
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',                                 //99
    '׷�Ĵ�',
    '����ɱ',
    '����ն',
    '��ɨǧ��',
    '�����',
    '���ױ�',
    '����ѩ��',
    '˫����',
    '��Х��',
    '������',
    '������',
    '�������',
    '��ת�����',
    '�Ͽ�ն',
    '����ٵ�',
    'Ѫ��һ��(ս)',
    'Ѫ��һ��(��)',
    'Ѫ��һ��(��)',
    '', '', '', '',
    '', '', '', '', '', '');

procedure LoadConfig();
procedure SaveConfig();
procedure LoadAbuseFile();
function FilterSayMsg(var sMsg: string): Boolean;
function KickUser(const sRemoteIP: string): Boolean;

implementation

uses
  main;

function KickUser(const sRemoteIP: string): Boolean;
begin
  Result := True;
  if g_bokickOverPacketSize then begin
    case g_BlockMethod of
      mDisconnect: begin
          Result := False;
        end;
      mBlock: begin
          g_TempBlockIPList.Add(sRemoteIP);
          frmMain.CloseIPConnect(sRemoteIP);
          Result := False;
        end;
      mBlockList: begin
          g_BlockIPList.Add(sRemoteIP);
          frmMain.CloseIPConnect(sRemoteIP);
          Result := False;
        end;
    end;
  end;
end;

function FilterSayMsg(var sMsg: string): Boolean;
var
  i, nLen                   : Integer;
  ft, rt                    : string;
begin
  Result := False;
  g_AbuseList.Lock;
  try
    for i := 0 to g_AbuseList.Count - 1 do begin
      ft := g_AbuseList.Strings[i];
      if AnsiContainsText(sMsg, ft) then begin
        case g_FiltMsgMethod of
          mReplaceAll: sMsg := FILTER_REPLACE_STR;
          mReplaceOne: begin
              rt := '';
              for nLen := 1 to Length(ft) do
                rt := rt + FILTER_REPLACE_STR;
              sMsg := AnsiReplaceText(sMsg, ft, rt);
            end;
          mDropconnect: Result := True;
        end;
        Break;
      end;
    end;
  finally
    g_AbuseList.UnLock;
  end;
end;

procedure LoadAbuseFile();
var
  sFileName                 : string;
begin
  sFileName := '.\WordFilter.txt';
  if FileExists(sFileName) then begin
    g_AbuseList.Lock;
    try
      g_AbuseList.LoadFromFile(sFileName);
    finally
      g_AbuseList.UnLock;
    end;
    MainOutMessage('���ֹ�����Ϣ�������...', 6);
  end else begin
    g_AbuseList.Lock;
    try
      g_AbuseList.Add('��');
      g_AbuseList.Add('��');
      g_AbuseList.SaveToFile(sFileName);
    finally
      g_AbuseList.UnLock;
    end;
  end;
end;

procedure LoadConfig();
var
  i                         : Integer;
begin

  if g_IniConfig.ReadInteger(g_sGateMain, 'Count', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'Count', g_nGateCount);
  g_nGateCount := g_IniConfig.ReadInteger(g_sGateMain, 'Count', g_nGateCount);

  for i := 1 to g_nGateCount do begin
    if g_IniConfig.ReadString(g_sGateClass + IntToStr(i), 'ServerAddr', '') = '' then
      g_IniConfig.WriteString(g_sGateClass + IntToStr(i), 'ServerAddr', g_GameGateList[i].sServerAdress);
    g_GameGateList[i].sServerAdress := g_IniConfig.ReadString(g_sGateClass + IntToStr(i), 'ServerAddr', g_GameGateList[i].sServerAdress);

    if g_IniConfig.ReadInteger(g_sGateClass + IntToStr(i), 'ServerPort', -1) < 0 then
      g_IniConfig.WriteInteger(g_sGateClass + IntToStr(i), 'ServerPort', g_GameGateList[i].nServerPort);
    g_GameGateList[i].nServerPort := g_IniConfig.ReadInteger(g_sGateClass + IntToStr(i), 'ServerPort', g_GameGateList[i].nServerPort);

    if g_IniConfig.ReadInteger(g_sGateClass + IntToStr(i), 'GatePort', -1) < 0 then
      g_IniConfig.ReadInteger(g_sGateClass + IntToStr(i), 'GatePort', g_GameGateList[i].nGatePort);
    g_GameGateList[i].nGatePort := g_IniConfig.ReadInteger(g_sGateClass + IntToStr(i), 'GatePort', g_GameGateList[i].nGatePort);
  end;

  for i := 1 to High(MAIGIC_DELAY_TIME_LIST) do
    if MAIGIC_NAME_LIST[i] <> '' then begin
      if g_IniConfig.ReadInteger('MagicInvTime', MAIGIC_NAME_LIST[i], -1) < 0 then
        g_IniConfig.WriteInteger('MagicInvTime', MAIGIC_NAME_LIST[i], MAIGIC_DELAY_TIME_LIST[i]);
      MAIGIC_DELAY_TIME_LIST[i] := g_IniConfig.ReadInteger('MagicInvTime', MAIGIC_NAME_LIST[i], MAIGIC_DELAY_TIME_LIST[i]);
    end;

  if g_IniConfig.ReadString(g_sGateMain, 'Title', '') = '' then
    g_IniConfig.WriteString(g_sGateMain, 'Title', g_sTitleName);
  g_sTitleName := g_IniConfig.ReadString(g_sGateMain, 'Title', g_sTitleName);

  if g_IniConfig.ReadInteger(g_sGateMain, 'ShowBite', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'ShowBite', g_boShowBite);
  g_boShowBite := g_IniConfig.ReadBool(g_sGateMain, 'ShowBite', g_boShowBite);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CheckCmd', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CheckCmd', B_MAX_PROCESS_MSG_TIME);
  B_MAX_PROCESS_MSG_TIME := g_IniConfig.ReadBool(g_sGateMain, 'CheckCmd', B_MAX_PROCESS_MSG_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'UseDynCode', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'UseDynCode', g_IsUseEncode);
  g_IsUseEncode := g_IniConfig.ReadBool(g_sGateMain, 'UseDynCode', g_IsUseEncode);

  if g_IniConfig.ReadInteger(g_sGateMain, 'ShowLogLevel', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'ShowLogLevel', g_nShowLogLevel);
  g_nShowLogLevel := g_IniConfig.ReadInteger(g_sGateMain, 'ShowLogLevel', g_nShowLogLevel);

  if g_IniConfig.ReadInteger(g_sGateMain, 'ClientSendBlockSize', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'ClientSendBlockSize', g_nClientSendBlockSize);
  g_nClientSendBlockSize := g_IniConfig.ReadInteger(g_sGateMain, 'ClientSendBlockSize', g_nClientSendBlockSize);

  if g_IniConfig.ReadInteger(g_sGateMain, 'ServerCheckTimeOut', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'ServerCheckTimeOut', g_dwCheckServerTimeOutTime);
  g_dwCheckServerTimeOutTime := g_IniConfig.ReadInteger(g_sGateMain, 'ServerCheckTimeOut', g_dwCheckServerTimeOutTime);

  ///////////////////////////////
  if g_IniConfig.ReadInteger(g_sGateMain, 'MoveInvTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'MoveInvTime', MOVE_INV_TIME);
  MOVE_INV_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'MoveInvTime', MOVE_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CheckCmdTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'CheckCmdTime', MAX_PROCESS_MSG_TIME);
  MAX_PROCESS_MSG_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'CheckCmdTime', MAX_PROCESS_MSG_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'ItemSpeed', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'ItemSpeed', MAX_ITEM_SPEED);
  MAX_ITEM_SPEED := g_IniConfig.ReadInteger(g_sGateMain, 'ItemSpeed', MAX_ITEM_SPEED);

  if g_IniConfig.ReadInteger(g_sGateMain, 'MaxItemSpeed', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'MaxItemSpeed', MAX_ITEM_SPEED2);
  MAX_ITEM_SPEED2 := g_IniConfig.ReadInteger(g_sGateMain, 'MaxItemSpeed', MAX_ITEM_SPEED2);

  if g_IniConfig.ReadInteger(g_sGateMain, 'PickUpItemInvTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'PickUpItemInvTime', g_nPickUpItemInvTime);
  g_nPickUpItemInvTime := g_IniConfig.ReadInteger(g_sGateMain, 'PickUpItemInvTime', g_nPickUpItemInvTime);

  if g_IniConfig.ReadInteger(g_sGateMain, 'HitSpeedRate', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'HitSpeedRate', g_HitSpeedRate);
  g_HitSpeedRate := g_IniConfig.ReadInteger(g_sGateMain, 'HitSpeedRate', g_HitSpeedRate);

  if g_IniConfig.ReadInteger(g_sGateMain, 'MagSpeedRate', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'MagSpeedRate', g_MagSpeedRate);
  g_MagSpeedRate := g_IniConfig.ReadInteger(g_sGateMain, 'MagSpeedRate', g_MagSpeedRate);

  if g_IniConfig.ReadInteger(g_sGateMain, 'MoveSpeedRate', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'MoveSpeedRate', g_MoveSpeedRate);
  g_MoveSpeedRate := g_IniConfig.ReadInteger(g_sGateMain, 'MoveSpeedRate', g_MoveSpeedRate);

  if g_IniConfig.ReadInteger(g_sGateMain, 'SLMoveTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'SLMoveTime', g_SLMoveTime);
  g_SLMoveTime := g_IniConfig.ReadInteger(g_sGateMain, 'SLMoveTime', g_SLMoveTime);

  if g_IniConfig.ReadInteger(g_sGateMain, 'SLAttackTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'SLAttackTime', g_SLAttackTime);
  g_SLAttackTime := g_IniConfig.ReadInteger(g_sGateMain, 'SLAttackTime', g_SLAttackTime);

  if g_IniConfig.ReadInteger(g_sGateMain, 'SLMagicTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'SLMagicTime', g_SLMagicTime);
  g_SLMagicTime := g_IniConfig.ReadInteger(g_sGateMain, 'SLMagicTime', g_SLMagicTime);

  if g_IniConfig.ReadInteger(g_sGateMain, 'EatItemInvTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'EatItemInvTime', g_nEatItemInvTime);
  g_nEatItemInvTime := g_IniConfig.ReadInteger(g_sGateMain, 'EatItemInvTime', g_nEatItemInvTime);

  if g_IniConfig.ReadInteger(g_sGateMain, 'SpaceMovePickUpInvTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'SpaceMovePickUpInvTime', g_nSpaceMovePickUpInvTime);
  g_nSpaceMovePickUpInvTime := g_IniConfig.ReadInteger(g_sGateMain, 'SpaceMovePickUpInvTime', g_nSpaceMovePickUpInvTime);

  if g_IniConfig.ReadString(g_sGateMain, 'CmdMove', '') = '' then
    g_IniConfig.WriteString(g_sGateMain, 'CmdMove', g_sCmdMove);
  g_sCmdMove := g_IniConfig.ReadString(g_sGateMain, 'CmdMove', g_sCmdMove);

  if g_IniConfig.ReadInteger(g_sGateMain, 'AttackInvTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'AttackInvTime', ATTACK_INV_TIME);
  ATTACK_INV_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'AttackInvTime', ATTACK_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'TurnInvTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'TurnInvTime', TURN_INV_TIME);
  TURN_INV_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'TurnInvTime', TURN_INV_TIME);

  i := g_IniConfig.ReadInteger(g_sGateMain, 'DigInvTime', -1);
  if (i < 150) or (i > 650) then
    g_IniConfig.WriteInteger(g_sGateMain, 'DigInvTime', DIG_INV_TIME);
  DIG_INV_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'DigInvTime', DIG_INV_TIME);

  i := g_IniConfig.ReadInteger(g_sGateMain, 'SitdownInvTime', -1);
  if (i < 150) or (i > 650) then
    g_IniConfig.WriteInteger(g_sGateMain, 'SitdownInvTime', MAX_SQUAT_TIME);
  MAX_SQUAT_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'SitdownInvTime', MAX_SQUAT_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'ChatInvTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'ChatInvTime', CHAT_INV_TIME);
  CHAT_INV_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'ChatInvTime', CHAT_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CompensateMoveValue', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'CompensateMoveValue', COMPENSATE_MOVE_VALUE);
  COMPENSATE_MOVE_VALUE := g_IniConfig.ReadInteger(g_sGateMain, 'CompensateMoveValue', COMPENSATE_MOVE_VALUE);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CompensateAttackValue', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'CompensateAttackValue', COMPENSATE_ATTACK_VALUE);
  COMPENSATE_ATTACK_VALUE := g_IniConfig.ReadInteger(g_sGateMain, 'CompensateAttackValue', COMPENSATE_ATTACK_VALUE);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CompensateMagicValue', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'CompensateMagicValue', COMPENSATE_MAGIC_VALUE);
  COMPENSATE_MAGIC_VALUE := g_IniConfig.ReadInteger(g_sGateMain, 'CompensateMagicValue', COMPENSATE_MAGIC_VALUE);

  if g_IniConfig.ReadInteger(g_sGateMain, 'SpeedHackPunishMaxTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'SpeedHackPunishMaxTime', PUNISH_MAX_TIME);
  PUNISH_MAX_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'SpeedHackPunishMaxTime', PUNISH_MAX_TIME);

  if g_IniConfig.ReadFloat(g_sGateMain, 'SpeedHackPunishRate', 0.00) < 0.10 then
    g_IniConfig.WriteFloat(g_sGateMain, 'SpeedHackPunishRate', SpeedHackPunishRate);
  SpeedHackPunishRate := g_IniConfig.ReadFloat(g_sGateMain, 'SpeedHackPunishRate', SpeedHackPunishRate);

  if g_IniConfig.ReadInteger(g_sGateMain, 'ActionInvTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'ActionInvTime', ACTION_INV_TIME);
  ACTION_INV_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'ActionInvTime', ACTION_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'NextActionTime', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'NextActionTime', NEXT_ACTION_TIME);
  NEXT_ACTION_TIME := g_IniConfig.ReadInteger(g_sGateMain, 'NextActionTime', NEXT_ACTION_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'NextActionCompensate', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'NextActionCompensate', MAX_ACTION_COMPENSATE);
  MAX_ACTION_COMPENSATE := g_IniConfig.ReadInteger(g_sGateMain, 'NextActionCompensate', MAX_ACTION_COMPENSATE);

  if g_IniConfig.ReadInteger(g_sGateMain, 'NextSpellCompensate', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'NextSpellCompensate', MAX_SPELL_COMPENSATE);
  MAX_SPELL_COMPENSATE := g_IniConfig.ReadInteger(g_sGateMain, 'NextSpellCompensate', MAX_SPELL_COMPENSATE);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CheckMove', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CheckMove', B_MOVE_INV_TIME);
  B_MOVE_INV_TIME := g_IniConfig.ReadBool(g_sGateMain, 'CheckMove', B_MOVE_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'PickUpCtr', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'PickUpCtr', B_PICKUP_INV_TIME);
  B_PICKUP_INV_TIME := g_IniConfig.ReadBool(g_sGateMain, 'PickUpCtr', B_PICKUP_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'EatCtr', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'EatCtr', B_EAT_INV_TIME);
  B_EAT_INV_TIME := g_IniConfig.ReadBool(g_sGateMain, 'EatCtr', B_EAT_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'SpaceMoveCtr', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'SpaceMoveCtr', B_SPACEMOVE_INV_TIME);
  B_SPACEMOVE_INV_TIME := g_IniConfig.ReadBool(g_sGateMain, 'SpaceMoveCtr', B_SPACEMOVE_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'KickUser_OverPack', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'KickUser_OverPack', g_nKickUserOverPackCnt);
  g_nKickUserOverPackCnt := g_IniConfig.ReadBool(g_sGateMain, 'KickUser_OverPack', g_nKickUserOverPackCnt);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CCDefence', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CCDefence', B_DEFENCE_CC);
  B_DEFENCE_CC := g_IniConfig.ReadBool(g_sGateMain, 'CCDefence', B_DEFENCE_CC);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CmdFilter', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CmdFilter', B_CMDFILTER);
  B_CMDFILTER := g_IniConfig.ReadBool(g_sGateMain, 'CmdFilter', B_CMDFILTER);

  if g_IniConfig.ReadInteger(g_sGateMain, 'NewClientShowHint', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'NewClientShowHint', g_NewHint);
  g_NewHint := g_IniConfig.ReadBool(g_sGateMain, 'NewClientShowHint', g_NewHint);

  if g_IniConfig.ReadInteger(g_sGateMain, 'SpeedRateCtrl', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'SpeedRateCtrl', g_SpeedRateCtrl);
  g_SpeedRateCtrl := g_IniConfig.ReadBool(g_sGateMain, 'SpeedRateCtrl', g_SpeedRateCtrl);

  if g_IniConfig.ReadInteger(g_sGateMain, 'synatcvalue', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'synatcvalue', g_synatcvalue);
  g_synatcvalue := g_IniConfig.ReadBool(g_sGateMain, 'synatcvalue', g_synatcvalue);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CheckAttack', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CheckAttack', B_ATTACK_INV_TIME);
  B_ATTACK_INV_TIME := g_IniConfig.ReadBool(g_sGateMain, 'CheckAttack', B_ATTACK_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CheckTurn', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CheckTurn', B_TURN_INV_TIME);
  B_TURN_INV_TIME := g_IniConfig.ReadBool(g_sGateMain, 'CheckTurn', B_TURN_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CheckDig', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CheckDig', B_DIG_INV_TIME);
  B_DIG_INV_TIME := g_IniConfig.ReadBool(g_sGateMain, 'CheckDig', B_DIG_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CheckSitdown', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CheckSitdown', B_MAX_SQUAT_TIME);
  B_MAX_SQUAT_TIME := g_IniConfig.ReadBool(g_sGateMain, 'CheckSitdown', B_MAX_SQUAT_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CheckChat', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CheckChat', B_CHAT_INV_TIME);
  B_CHAT_INV_TIME := g_IniConfig.ReadBool(g_sGateMain, 'CheckChat', B_CHAT_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'CheckMagicInvTime', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'CheckMagicInvTime', B_MAGIC_INV_TIME);
  B_MAGIC_INV_TIME := g_IniConfig.ReadBool(g_sGateMain, 'CheckMagicInvTime', B_MAGIC_INV_TIME);

  if g_IniConfig.ReadInteger(g_sGateMain, 'SpeedHackWarning', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'SpeedHackWarning', B_WARNING);
  B_WARNING := g_IniConfig.ReadBool(g_sGateMain, 'SpeedHackWarning', B_WARNING);

  if g_IniConfig.ReadInteger(g_sGateMain, 'FilterChar', -1) < 0 then
    g_IniConfig.WriteBool(g_sGateMain, 'FilterChar', B_FILTER);
  B_FILTER := g_IniConfig.ReadBool(g_sGateMain, 'FilterChar', B_FILTER);

  if g_IniConfig.ReadString(g_sGateMain, 'SpeedHackWarningMsg', '') = '' then
    g_IniConfig.WriteString(g_sGateMain, 'SpeedHackWarningMsg', SPEED_HACK_WARNING);
  SPEED_HACK_WARNING := g_IniConfig.ReadString(g_sGateMain, 'SpeedHackWarningMsg', SPEED_HACK_WARNING);

  if g_IniConfig.ReadString(g_sGateMain, 'PacketErrMsg', '') = '' then
    g_IniConfig.WriteString(g_sGateMain, 'PacketErrMsg', PACKETERR_MSG);
  PACKETERR_MSG := g_IniConfig.ReadString(g_sGateMain, 'PacketErrMsg', PACKETERR_MSG);

  if g_IniConfig.ReadString(g_sGateMain, 'VersionErrMsg', '') = '' then
    g_IniConfig.WriteString(g_sGateMain, 'VersionErrMsg', g_VersionErrMsg);
  g_VersionErrMsg := g_IniConfig.ReadString(g_sGateMain, 'VersionErrMsg', g_VersionErrMsg);

  if g_IniConfig.ReadString(g_sGateMain, 'FilterReplaceStr', '') = '' then
    g_IniConfig.WriteString(g_sGateMain, 'FilterReplaceStr', FILTER_REPLACE_STR);
  FILTER_REPLACE_STR := g_IniConfig.ReadString(g_sGateMain, 'FilterReplaceStr', FILTER_REPLACE_STR);

  if g_IniConfig.ReadInteger(g_sGateMain, 'SpeedHackPunishTpye', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'SpeedHackPunishTpye', Integer(g_SpeedHackPunish));
  g_SpeedHackPunish := TSpeedHackPunish(g_IniConfig.ReadInteger(g_sGateMain, 'SpeedHackPunishTpye', Integer(g_SpeedHackPunish)));

  if g_IniConfig.ReadInteger(g_sGateMain, 'SpeedHackPunishWarningTpye', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'SpeedHackPunishWarningTpye', Integer(g_SpeedHackWarningType));
  g_SpeedHackWarningType := TSpeedHackWarning(g_IniConfig.ReadInteger(g_sGateMain, 'SpeedHackPunishWarningTpye', Integer(g_SpeedHackWarningType)));

  if g_IniConfig.ReadInteger(g_sGateMain, 'FiltMsgMethod', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'FiltMsgMethod', Integer(g_FiltMsgMethod));
  g_FiltMsgMethod := TFiltMsgMethod(g_IniConfig.ReadInteger(g_sGateMain, 'FiltMsgMethod', Integer(g_FiltMsgMethod)));

  if g_IniConfig.ReadInteger(g_sGateMain, 'BlockMethod', -1) < 0 then
    g_IniConfig.WriteInteger(g_sGateMain, 'BlockMethod', Integer(g_BlockMethod));
  g_BlockMethod := TBlockIPMethod(g_IniConfig.ReadInteger(g_sGateMain, 'BlockMethod', Integer(g_BlockMethod)));

  g_nMaxConnOfIPaddr := g_IniConfig.ReadInteger(g_sGateMain, 'MaxConnOfIPaddr', g_nMaxConnOfIPaddr);
  g_BlockMethod := TBlockIPMethod(g_IniConfig.ReadInteger(g_sGateMain, 'BlockMethod', Integer(g_BlockMethod)));
  g_nMaxClientPacketSize := g_IniConfig.ReadInteger(g_sGateMain, 'MaxClientPacketSize', g_nMaxClientPacketSize);
  g_nNomClientPacketSize := g_IniConfig.ReadInteger(g_sGateMain, 'NomClientPacketSize', g_nNomClientPacketSize);
  g_nMaxClientMsgCount := g_IniConfig.ReadInteger(g_sGateMain, 'MaxClientMsgCount', g_nMaxClientMsgCount);
  g_bokickOverPacketSize := g_IniConfig.ReadBool(g_sGateMain, 'kickOverPacket', g_bokickOverPacketSize);
  g_boNoNullConnect := g_IniConfig.ReadBool(g_sGateMain, 'LimitConnect', g_boNoNullConnect);
  g_bUpdate := g_IniConfig.ReadBool(g_sGateMain, 'UpdateDynCode', False);

  g_boAutoBlockIP := g_IniConfig.ReadBool(g_sGateMain, 'AutoBlockIP', g_boAutoBlockIP);

  LoadAbuseFile();
  g_TempBlockIPList.Clear;
  MainOutMessage('������Ϣ�������...', 3);
end;

procedure SaveConfig();
var
  i                         : Integer;
begin
  if g_IniConfig = nil then Exit;

  for i := 1 to g_nGateCount do begin
    g_IniConfig.WriteString(g_sGateClass + IntToStr(i), 'ServerAddr', g_GameGateList[i].sServerAdress);
    g_IniConfig.WriteInteger(g_sGateClass + IntToStr(i), 'ServerPort', g_GameGateList[i].nServerPort);
    g_IniConfig.WriteInteger(g_sGateClass + IntToStr(i), 'GatePort', g_GameGateList[i].nGatePort);
  end;
  for i := 1 to High(MAIGIC_DELAY_TIME_LIST) do begin
    if MAIGIC_NAME_LIST[i] <> '' then
      g_IniConfig.WriteInteger('MagicInvTime', MAIGIC_NAME_LIST[i], MAIGIC_DELAY_TIME_LIST[i]);
  end;

  g_IniConfig.WriteBool(g_sGateMain, 'CheckCmd', B_MAX_PROCESS_MSG_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'ShowBite', g_boShowBite);
  g_IniConfig.WriteBool(g_sGateMain, 'UseDynCode', g_IsUseEncode);
  g_IniConfig.WriteBool(g_sGateMain, 'PickUpCtr', B_PICKUP_INV_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'EatCtr', B_EAT_INV_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'SpaceMoveCtr', B_SPACEMOVE_INV_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'KickUser_OverPack', g_nKickUserOverPackCnt);

  g_IniConfig.WriteBool(g_sGateMain, 'CmdFilter', B_CMDFILTER);
  g_IniConfig.WriteBool(g_sGateMain, 'NewClientShowHint', g_NewHint);
  g_IniConfig.WriteBool(g_sGateMain, 'SpeedRateCtrl', g_SpeedRateCtrl);
  g_IniConfig.WriteBool(g_sGateMain, 'synatcvalue', g_synatcvalue);

  g_IniConfig.WriteBool(g_sGateMain, 'CCDefence', B_DEFENCE_CC);
  g_IniConfig.WriteBool(g_sGateMain, 'CheckMove', B_MOVE_INV_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'CheckAttack', B_ATTACK_INV_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'CheckTurn', B_TURN_INV_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'CheckDig', B_DIG_INV_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'CheckSitdown', B_MAX_SQUAT_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'CheckChat', B_CHAT_INV_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'CheckMagicInvTime', B_MAGIC_INV_TIME);
  g_IniConfig.WriteBool(g_sGateMain, 'SpeedHackWarning', B_WARNING);
  g_IniConfig.WriteBool(g_sGateMain, 'FilterChar', B_FILTER);
  g_IniConfig.WriteBool(g_sGateMain, 'kickOverPacket', g_bokickOverPacketSize);
  g_IniConfig.WriteBool(g_sGateMain, 'LimitConnect', g_boNoNullConnect);
  g_IniConfig.WriteBool(g_sGateMain, 'UpdateDynCode', False);

  g_IniConfig.WriteString(g_sGateMain, 'Title', g_sTitleName);
  g_IniConfig.WriteString(g_sGateMain, 'SpeedHackWarningMsg', SPEED_HACK_WARNING);
  g_IniConfig.WriteString(g_sGateMain, 'PacketErrMsg', PACKETERR_MSG);
  g_IniConfig.WriteString(g_sGateMain, 'VersionErrMsg', g_VersionErrMsg);
  g_IniConfig.WriteString(g_sGateMain, 'FilterReplaceStr', FILTER_REPLACE_STR);
  g_IniConfig.WriteString(g_sGateMain, 'CmdMove', g_sCmdMove);

  g_IniConfig.WriteInteger(g_sGateMain, 'CheckCmdTime', MAX_PROCESS_MSG_TIME);
  g_IniConfig.WriteInteger(g_sGateMain, 'ItemSpeed', MAX_ITEM_SPEED);
  g_IniConfig.WriteInteger(g_sGateMain, 'MaxItemSpeed', MAX_ITEM_SPEED2);
  g_IniConfig.WriteInteger(g_sGateMain, 'PickUpItemInvTime', g_nPickUpItemInvTime);
  g_IniConfig.WriteInteger(g_sGateMain, 'EatItemInvTime', g_nEatItemInvTime);
  g_IniConfig.WriteInteger(g_sGateMain, 'SpaceMovePickUpInvTime', g_nSpaceMovePickUpInvTime);

  g_IniConfig.WriteInteger(g_sGateMain, 'SLMoveTime', g_SLMoveTime);
  g_IniConfig.WriteInteger(g_sGateMain, 'SLAttackTime', g_SLAttackTime);
  g_IniConfig.WriteInteger(g_sGateMain, 'SLMagicTime', g_SLMagicTime);

  g_IniConfig.WriteInteger(g_sGateMain, 'HitSpeedRate', g_HitSpeedRate);
  g_IniConfig.WriteInteger(g_sGateMain, 'MagSpeedRate', g_MagSpeedRate);
  g_IniConfig.WriteInteger(g_sGateMain, 'MoveSpeedRate', g_MoveSpeedRate);

  g_IniConfig.WriteInteger(g_sGateMain, 'Count', g_nGateCount);
  g_IniConfig.WriteInteger(g_sGateMain, 'ShowLogLevel', g_nShowLogLevel);
  g_IniConfig.WriteInteger(g_sGateMain, 'ServerCheckTimeOut', g_dwCheckServerTimeOutTime);
  g_IniConfig.WriteInteger(g_sGateMain, 'ClientSendBlockSize', g_nClientSendBlockSize);
  g_IniConfig.WriteInteger(g_sGateMain, 'MoveInvTime', MOVE_INV_TIME);
  g_IniConfig.WriteInteger(g_sGateMain, 'AttackInvTime', ATTACK_INV_TIME);
  g_IniConfig.WriteInteger(g_sGateMain, 'TurnInvTime', TURN_INV_TIME);
  g_IniConfig.WriteInteger(g_sGateMain, 'DigInvTime', DIG_INV_TIME);
  g_IniConfig.WriteInteger(g_sGateMain, 'SitdownInvTime', MAX_SQUAT_TIME);
  g_IniConfig.WriteInteger(g_sGateMain, 'ChatInvTime', CHAT_INV_TIME);
  g_IniConfig.WriteInteger(g_sGateMain, 'CompensateMoveValue', COMPENSATE_MOVE_VALUE);
  g_IniConfig.WriteInteger(g_sGateMain, 'CompensateAttackValue', COMPENSATE_ATTACK_VALUE);
  g_IniConfig.WriteInteger(g_sGateMain, 'CompensateMagicValue', COMPENSATE_MAGIC_VALUE);
  g_IniConfig.WriteInteger(g_sGateMain, 'SpeedHackPunishMaxTime', PUNISH_MAX_TIME);
  g_IniConfig.WriteFloat(g_sGateMain, 'SpeedHackPunishRate', SpeedHackPunishRate);
  g_IniConfig.WriteInteger(g_sGateMain, 'ActionInvTime', ACTION_INV_TIME);
  g_IniConfig.WriteInteger(g_sGateMain, 'NextActionTime', NEXT_ACTION_TIME);
  g_IniConfig.WriteInteger(g_sGateMain, 'NextActionCompensate', MAX_ACTION_COMPENSATE);
  g_IniConfig.WriteInteger(g_sGateMain, 'NextSpellCompensate', MAX_SPELL_COMPENSATE);

  g_IniConfig.WriteInteger(g_sGateMain, 'SpeedHackPunishTpye', Integer(g_SpeedHackPunish));
  g_IniConfig.WriteInteger(g_sGateMain, 'SpeedHackPunishWarningTpye', Integer(g_SpeedHackWarningType));
  g_IniConfig.WriteInteger(g_sGateMain, 'FiltMsgMethod', Integer(g_FiltMsgMethod));
  g_IniConfig.WriteInteger(g_sGateMain, 'BlockMethod', Integer(g_BlockMethod));
  g_IniConfig.WriteInteger(g_sGateMain, 'MaxConnOfIPaddr', g_nMaxConnOfIPaddr);
  g_IniConfig.WriteInteger(g_sGateMain, 'BlockMethod', Integer(g_BlockMethod));
  g_IniConfig.WriteInteger(g_sGateMain, 'MaxClientPacketSize', g_nMaxClientPacketSize);
  g_IniConfig.WriteInteger(g_sGateMain, 'NomClientPacketSize', g_nNomClientPacketSize);
  g_IniConfig.WriteInteger(g_sGateMain, 'MaxClientMsgCount', g_nMaxClientMsgCount);

  g_IniConfig.WriteBool(g_sGateMain, 'AutoBlockIP', g_boAutoBlockIP);
  MainOutMessage('������Ϣ����ɹ�...', 3);
end;

initialization
  MAIGIC_DELAY_TIME_LIST2 := MAIGIC_DELAY_TIME_LIST;

finalization

end.

