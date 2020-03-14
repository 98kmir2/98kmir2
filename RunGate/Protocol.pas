unit Protocol;

interface

uses
  Windows, Messages, SysUtils, Classes, IniFiles,
  SyncObj;

const
  _STR_GRID_INDEX = '网关';
  _STR_GRID_IP = '网关地址';
  _STR_GRID_PORT = '端口';
  _STR_GRID_CONNECT_STATUS = '连接状态';
  _STR_GRID_IO_SEND_BYTES = '发送';
  _STR_GRID_IO_RECV_BYTES = '接收';

  _STR_KEEP_ALIVE = '**';
  _STR_CMD_FILTER = '%s 此命令禁止使用！';

  _STR_LIB_MMSYSTEM = 'winmm.dll';
  _STR_LIB_KERNEL32 = 'kernel32.dll';

  _STR_CONFIG_FILE = '.\Config.ini';
  _STR_BLOCK_FILE = '.\BlockIPList.txt';
  _STR_BLOCK_AREA_FILE = '.\BlockIPAreaList.txt';
  _STR_CHAT_FILTER_FILE = '.\ChatFilter.txt';
  _STR_CHAT_CMD_FILTER_FILE = '.\CharCmdFilter.txt';
  _STR_PUNISH_USER_FILE = '.\PunishList.txt';

  _IDM_SERVERSOCK_MSG = WM_USER + 1000;
  _IDM_TIMER_STARTSERVICE = _IDM_SERVERSOCK_MSG + 1;
  _IDM_TIMER_STOPSERVICE = _IDM_SERVERSOCK_MSG + 2;
  _IDM_TIMER_KEEP_ALIVE = _IDM_SERVERSOCK_MSG + 3;
  _IDM_TIMER_THREAD_INFO = _IDM_SERVERSOCK_MSG + 4;
  _IDM_TIMER_BROADCAST_USER_ITEM_SPEED = _IDM_SERVERSOCK_MSG + 5;
  _IDM_TIMER_BROADCAST_CLIENT_ACTION_SPEED = _IDM_SERVERSOCK_MSG + 6;
  _IDM_TIMER_OPERATE_DELAY_MSG = _IDM_SERVERSOCK_MSG + 7;

  //ClientData
  RUNGATECODE = $AA55AA55 + $00450045;
  FIRST_PAKCET_MAX_LEN = 254;
  MAGIC_NUM = 0128;

  DELAY_BUFFER_LEN = 1024;

type
  TCmdPack = packed record
    case Integer of
      0: (UID: Integer; Cmd: Word; X: Word; Y: Word; Direct: Word);
      1: (ID1: Integer; Cmd1: Word; ID2: Integer);
      2: (PosX: Word; PosY: Word; Cmd2: Word; IDLo: Word; Magic: Word; IDHi: Word);
      3: (UID1: Integer; Cmd3: Word; b1: Byte; b2: Byte; b3: Byte; b4: Byte);
      4: (NID: Integer; Command: Word; Pos: Word; Dir: Word; WID: Word);
      5: (Head: DWord; Cmd4: Word; Zero1: Word; Tail: DWord);
      6: (Recog: Integer; ident: Word; param: Word; tag: Word; Series: Word);
  end;
  PCmdPack = ^TCmdPack;
  PTCmdPack = PCmdPack;
  TDefaultMessage = TCmdPack;
  pTDefaultMessage = ^TDefaultMessage;

  TSvrCmdPack = packed record
    Flag: DWord;
    SockID: DWord;
    Seq: Word;
    Cmd: Word;
    GGSock: Integer; // TClientThread;
    DataLen: Integer;
  end;
  PSvrcmdPack = ^TSvrCmdPack;

  PCmdHeader = ^_tagCmdHeader;

  _tagCmdHeader = packed record
    Header: DWord;
    Cmd: Word;
    Cmd1: Word;
    Tail: DWord;
  end;
  TCmdHeader = _tagCmdHeader;

  TMagic = packed record
    Reserved1: array[0..7] of Char;
    MagicID: Word;
    Reserved2: array[0..45] of Char;
    Delay: Word;
    Reserved3: array[0..25] of Char;
  end;
  PMagic = ^TMagic;

  TEnDeInfo = packed record
    Head: DWord;
    Cmd: Word;
    Cmd1: Word;
    Tail: DWord;
  end;
  PEnDeInfo = ^TEnDeInfo;

  TBlockIPMethod = (mDisconnect, mBlock, mBlockList);
  TPunishMethod = (ptTurnPack, ptDropPack, ptNullPack, ptDelaySend);
  TChatFilterMethod = (ctReplaceAll, ctReplaceOne, ctDropconnect);
  TOverSpeedMsgMethod = (ptSysmsg, ptMenuOK);
  TSockThreadStutas = (stConnecting, stConnected, stTimeOut);

  TDelayMsg = record
    dwDelayTime: DWord;
    nMag: Integer;
    nCmd: Integer;
    nDir: Integer;
    nBufLen: Integer;
    pBuffer: array[0..DELAY_BUFFER_LEN - 1] of Char;
  end;
  pTDelayMsg = ^TDelayMsg;

  TPerIPAddr = record
    IPaddr: LongInt;
    Count: Integer;
  end;
  pTPerIPAddr = ^TPerIPAddr;

  TIPArea = record
    Low: DWord;
    High: DWord;
  end;
  pTIPArea = ^TIPArea;

var
  g_hMainWnd: HWND;
  g_hStatusBar: HWND;
  g_fServiceStarted: Boolean = False;

implementation

end.
