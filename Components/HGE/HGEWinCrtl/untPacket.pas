unit untPacket;

interface
uses Windows,Classes,SysUtils,PlayerObj,SocketStream,PacketDefine,Common;

const
  PACKET_HEADER_SIZE = 6;
type
  PacketID_t = WORD;
  PACKET_EXE =(
    PACKET_EXE_ERROR = 0 ,
    PACKET_EXE_BREAK ,
    PACKET_EXE_CONTINUE ,
    PACKET_EXE_NOTREMOVE ,
    PACKET_EXE_NOTREMOVE_ERROR);
    
  //消息头中包括：PacketID_t-2字节；UINT-4字节中高位一个字节为消息序列号，其余三个字节为消息长度
  //通过GET_PACKET_INDEX和GET_PACKET_LEN宏，可以取得UINT数据里面的消息序列号和长度
  //通过SET_PACKET_INDEX和SET_PACKET_LEN宏，可以设置UINT数据里面的消息序列号和长度
  TPacket = class
    m_Index     :Byte;
    m_Status    :Byte;
  public
    constructor Create;virtual;
    destructor  Destroy;override;
    procedure CleanUp( );virtual;
	  function Read(iStream:TSocketInputStream) :BOOL;virtual;abstract;
    function Write(oStream:TSocketOutputStream):BOOL;virtual;abstract;
    //返回值为：PACKET_EXE 中的内容；
    //PACKET_EXE_ERROR 表示出现严重错误，当前连接需要被强制断开
    //PACKET_EXE_BREAK 表示返回后剩下的消息将不在当前处理循环里处理
    //PACKET_EXE_CONTINUE 表示继续在当前循环里执行剩下的消息
    //PACKET_EXE_NOTREMOVE 表示继续在当前循环里执行剩下的消息,但是不回收当前消息
    function Execute(pPlayer:TPlayer) :UINT;virtual;abstract;
    function GetPacketID( ):PacketID_t;virtual;abstract;
    function GetPacketSize( ):UINT;virtual;abstract;
    function CheckPacket( ):BOOL;virtual;
    function GetPacketIndex( ):Byte;virtual;
    procedure SetPacketIndex(Index :Byte);
    function  GetPacketStatus( ):Byte;
    procedure SetPacketStatus( Status:Byte );
  end;
  TPacketFactory = class
  public
    destructor Destroy;override;
    function CreatePacket ():TPacket;virtual; abstract;
    function GetPacketID ():PacketID_t;virtual;abstract;
	  function GetPacketMaxSize ():UINT;virtual;abstract;
  end;

  TPacketFactoryManager = class
    m_pPacketAllocCount :array of UINT;
  private
    CriticalSection:TRTLCriticalSection;
    m_Factories :Array of TPacketFactory;
    m_Size      :UINT;
    procedure Lock;
    procedure UnLock;
  public
    constructor Create;
    destructor  Destroy;override;
    procedure AddFactory(pFactory:TPacketFactory) ;
    //根据消息类型取得对应消息的最大尺寸（允许多线程同时调用）
    function getPacketMaxSize(packetId:PacketID_t):Integer;
    //根据消息类型从内存里分配消息实体数据（允许多线程同时调用）
    function CreatePacket(packetId:PacketID_t):TPacket;
    //删除消息实体（允许多线程同时调用）
    procedure RemovePacket(var pPacket:TPacket);
    //初始化接口
    function init:BOOL;
  end;

  pTProcessPacket=^TProcessPacket;
  TProcessPacket=record
    dwDeliveryTime:DWORD;   //处理的时机，=0表示立即处理，其他为到达指定GetTickCount才处理
    boLateDelivery:Boolean; //是否是延迟处理的消息
    Packet:TPacket;
    BaseObject:TPlayer;     //目标对象
  end;

  function GET_PACKET_LEN(a:UINT):UINT;
  function SET_PACKET_LEN(var a:UINT;len:UINT):UINT;
  function GET_PACKET_INDEX(a:UINT):UINT;
  function SET_PACKET_INDEX(var a:UINT;index:UINT):UINT;
  function WriteDBUser(oStream:TSocketOutputStream;var Data:TDBUser):Boolean;
  function ReadDBUser(iStream:TSocketInputStream; var Data:TDBUser):Boolean;

var
  g_pPacketFactoryManager:TPacketFactoryManager=nil;
implementation

function GET_PACKET_LEN(a:UINT):UINT;
begin
  result:=a and $00FFFFFF;
end;

function SET_PACKET_LEN(var a:UINT;len:UINT):UINT;
begin
  a:=(a and $FF000000)+len;
  result:=a;
end;

function GET_PACKET_INDEX(a:UINT):UINT;
begin
  result:=a shr 24;
end;

function SET_PACKET_INDEX(var a:UINT;index:UINT):UINT;
begin
  A:=(a and $00FFFFFF)+(index shl 24);
  result:=A;
end;

{ TPacketFactory }

destructor TPacketFactory.Destroy;
begin
  inherited;
end;

{ TPacketFactoryManager }

procedure TPacketFactoryManager.AddFactory(pFactory: TPacketFactory);
var
  s:String;
begin
  try
    if m_Factories[pFactory.GetPacketID]<>nil then begin
      s:='重复的包序号：'+inttostr(pFactory.GetPacketID);
      pFactory.Free;
      Assert(false,s);
      exit;
    end;
    m_Factories[pFactory.GetPacketID]:=pFactory;
  except
    on E:Exception do begin
       //Log.SaveLog(BILLING_LOGFILE,'TPacketFactoryManager.AddFactory Errors:'+E.message);
    end;
  end;
end;

constructor TPacketFactoryManager.Create;
var
  I:Integer;
begin
  InitializeCriticalSection(CriticalSection);
  m_Size:=integer(PACKET_MAX);
  SetLength(m_Factories,m_Size);
  SetLength(m_pPacketAllocCount,m_Size);
  for i:=0 to m_Size - 1 do begin
    m_Factories[i]          := nil;
    m_pPacketAllocCount[i]  := 0;
  end;
end;

function TPacketFactoryManager.CreatePacket(packetId: PacketID_t): TPacket;
var
  Packet:TPacket;
begin
  result:=nil;
  try
    if (packetId>=m_Size) or (m_Factories[packetID] =nil) then begin
      exit;
    end;
    Packet:=nil;
    Lock;
    try
      Packet:=m_Factories[packetId].CreatePacket;
      Inc(m_pPacketAllocCount[packetId]);
    finally
      UnLock;
    end;
    Result:=Packet;
  except
    on E:Exception do begin
       //Log.SaveLog(BILLING_LOGFILE,'TPacketFactoryManager.CreatePacket(PackedId ='+Inttostr(packetId)+') Errors:'+E.message);
       result:=nil;
    end;
  end;
end;

destructor TPacketFactoryManager.destroy;
var
  i:integer;
begin
  for i:=0 to m_Size -1 do begin
    if m_Factories[i]<>nil then TPacketFactory(m_Factories[i]).Free;
    m_Factories[i]:=nil;
  end;
  setLength(m_Factories,0);
  SetLength(m_pPacketAllocCount,0);
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

function TPacketFactoryManager.getPacketMaxSize(packetId: PacketID_t): Integer;
begin
  if( packetID>=m_Size) or (m_Factories[packetID]=nil ) then begin
    raise Exception.CreateFmt('PacketID= %d 消息没有注册到PacketFactoryManager上',[packetID]);
  end;
  Lock() ;
  try
    result := m_Factories[packetID].GetPacketMaxSize( ) ;
  finally
    unlock() ;
  end;
end;

function TPacketFactoryManager.init: BOOL;
begin
  //加入本服务器需要的处理工厂
  result:=true;
end;

procedure TPacketFactoryManager.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TPacketFactoryManager.RemovePacket(var pPacket: TPacket);
var
  packetID:PacketID_t;
begin
  if pPacket = nil then exit;
  packetID := pPacket.GetPacketID() ;
  if( packetID>=m_Size ) then begin
    Assert(FALSE) ;
    exit;
  end;
  Lock;
  try
    freeAndNil(pPacket);
    Dec(m_pPacketAllocCount[packetID]);
  finally
	  Unlock() ;
  end;
end;

procedure TPacketFactoryManager.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

{ TPacket }

function TPacket.CheckPacket: BOOL;
begin
  result:=true;
end;

procedure TPacket.CleanUp;
begin
;
end;

constructor TPacket.Create;
begin
  inherited;
end;

destructor TPacket.Destroy;
begin
  inherited;
end;

function TPacket.GetPacketIndex: Byte;
begin
  result:=m_Index;
end;

function TPacket.GetPacketStatus: Byte;
begin
 result:=m_Status;
end;


procedure TPacket.setPacketIndex(index: byte);
begin
  m_Index:=index;
end;

procedure TPacket.SetPacketStatus(Status: Byte);
begin
  m_Status:=Status;
end;

function ReadDBUser(iStream:TSocketInputStream; var Data:TDBUser):Boolean;
var
  W:Word;
  I:Integer;
begin
  iStream.Read(@Data.ChrID,SizeOf(Integer));
  iStream.Read(@Data.DBChrID,SizeOf(Integer));       //2009-08-20 by PY
  iStream.ReadStr(Data.Account);
  iStream.ReadStr(Data.Password);
  iStream.ReadStr(Data.NikeName);
  iStream.Read(@Data.Sex,SizeOf(Byte));
  iStream.Read(@Data.Gold,SizeOf(Integer));
  iStream.Read(@Data.Silver,SizeOf(Integer));
  iStream.Read(@Data.GameData.Level,sizeof(Integer));
  iStream.Read(@Data.GameData.Exp,sizeof(DWord));
  iStream.Read(@Data.GameData.MaxExp,Sizeof(DWord));
  iStream.Read(@Data.GameData.WinCount,SizeOf(Integer));
  iStream.Read(@Data.GameData.LoseCount,SizeOf(Integer));
  iStream.Read(@Data.GameData.DogFall,SizeOf(Integer));
  iStream.Read(@Data.GameData.EscCount,SizeOf(Integer));
  {$IF PACKETVER >=4}
  iStream.Read(@Data.GameData.LogIdx,SizeOf(Integer));
  iStream.Read(@Data.GameData.P1,SizeOf(Integer));
  iStream.Read(@Data.GameData.P2,SizeOf(Integer));
  iStream.Read(@Data.GameData.P3,SizeOf(Integer));
  iStream.Read(@Data.GameData.P4,SizeOf(Integer));
  {$IFEND}
  iStream.Read(@W,Sizeof(Word));  if w>0 then iStream.Read(@Data.GameData.TaskData[0],W);
  Data.GameData.TaskData[W]:=#0;
  iStream.Read(@Data.nNativeCode,SizeOf(Integer));
  iStream.ReadStr(Data.sNativeName);
  iStream.Read(@Data.btPlayOrd,SizeOf(SmallInt));
  iStream.ReadStr(Data.Guild);
  iStream.ReadStr(Data.Rank);
  iStream.Read(@Data.btGmFlag,SizeOf(Byte));
  iStream.Read(@Data.nCharm,SizeOf(Integer));
  iStream.Read(@Data.Feature,SizeOf(TFeature));
  iStream.Read(@Data.boNewChr,SizeOf(Boolean));
  iStream.Read(@Data.GradeID,SizeOf(Word));
  iStream.Read(@Data.nItemCount,SizeOf(Byte));
  SetLength(Data.Items,Data.nItemCount);
  if Data.nItemCount>0 then iStream.Read(@Data.Items[0],SizeOf(TUserItem)*Data.nItemCount);
  iStream.Read(@Data.nRelations,SizeOf(Byte));
  SetLength(Data.Relations,Data.nRelations);
  if Data.nRelations>0 then for I:=0 to Data.nRelations-1 do begin
     iStream.Read(@Data.Relations[I].Account,21);
     iStream.ReadStr(Data.Relations[I].sWhere);
     iStream.Read(@Data.Relations[I].btFlag,SizeOf(Byte));
     iStream.ReadStr(Data.Relations[I].sGameName);
     {$IF PACKETVER >1}
     iStream.Read(@Data.Relations[i].ChrID1,SizeOf(Integer));
     iStream.Read(@Data.Relations[i].ChrID2,SizeOf(Integer));
     {$IFEND}
  end;
  iStream.Read(@Data.btRelationSet,Sizeof(Byte));
  iStream.Read(@Data.btLove,SizeOf(Byte));
  iStream.Read(@Data.dwCurLove,SizeOf(DWord));
  iStream.Read(@Data.dwMaxLove,SizeOf(DWord));
  {$IF PACKETVER >2}
  iStream.Read(@Data.nFHLeftSec,SizeOf(Integer));
  iStream.Read(@Data.nFTLeftSec,SizeOf(Integer));
  iStream.Read(@Data.dwCredit,SizeOf(DWord));
  iStream.ReadStr(Data.sTitle);
  iStream.Read(@Data.P1,SizeOf(Integer));
  iStream.Read(@Data.P2,SizeOf(Integer));
  iStream.Read(@Data.P3,SizeOf(Integer));
  iStream.Read(@Data.P4,SizeOf(Integer));
  {$IFEND}
  Result:=True;
end;

function WriteDBUser(oStream:TSocketOutputStream;var Data:TDBUser):Boolean;
var
  W:Word;
  I:Integer;
begin
  oStream.Write(@Data.ChrID,SizeOf(Integer));
  oStream.Write(@Data.DBChrID,SizeOf(Integer));     //2009-08-20 by PY
  oStream.WriteStr(Data.Account);
  oStream.WriteStr(Data.Password);
  oStream.WriteStr(Data.NikeName);
  oStream.Write(@Data.Sex,SizeOf(Byte));
  oStream.Write(@Data.Gold,SizeOf(Integer));
  oStream.Write(@Data.Silver,SizeOf(Integer));
  oStream.Write(@Data.GameData.Level,sizeof(Integer));
  oStream.Write(@Data.GameData.Exp,sizeof(DWord));
  oStream.Write(@Data.GameData.MaxExp,Sizeof(DWord));
  oStream.Write(@Data.GameData.WinCount,SizeOf(Integer));
  oStream.Write(@Data.GameData.LoseCount,SizeOf(Integer));
  oStream.Write(@Data.GameData.DogFall,SizeOf(Integer));
  oStream.Write(@Data.GameData.EscCount,SizeOf(Integer));
  {$IF PACKETVER >=4}
  oStream.Write(@Data.GameData.LogIdx,SizeOf(Integer));
  oStream.Write(@Data.GameData.P1,SizeOf(Integer));
  oStream.Write(@Data.GameData.P2,SizeOf(Integer));
  oStream.Write(@Data.GameData.P3,SizeOf(Integer));
  oStream.Write(@Data.GameData.P4,SizeOf(Integer));
  {$IFEND}
  W:=Length(string(Data.GameData.TaskData));
  oStream.Write(@W,Sizeof(Word));
  oStream.Write(@Data.GameData.TaskData[0],W);
  oStream.Write(@Data.nNativeCode,SizeOf(Integer));
  oStream.WriteStr(Data.sNativeName);
  oStream.Write(@Data.btPlayOrd,SizeOf(SmallInt));
  oStream.WriteStr(Data.Guild);
  oStream.WriteStr(Data.Rank);
  oStream.Write(@Data.btGmFlag,SizeOf(Byte));
  oStream.Write(@Data.nCharm,SizeOf(Integer));
  oStream.Write(@Data.Feature,SizeOf(TFeature));
  oStream.Write(@Data.boNewChr,SizeOf(Boolean));
  oStream.Write(@Data.GradeID,SizeOf(Word));
  oStream.Write(@Data.nItemCount,SizeOf(Byte));
  if Data.nItemCount>0 then oStream.Write(@Data.Items[0],SizeOf(TUserItem)*Data.nItemCount);
  oStream.Write(@Data.nRelations,SizeOf(Byte));
  if Data.nRelations>0 then for I:=0 to Data.nRelations-1 do begin
     oStream.Write(@Data.Relations[I].Account,21);
     oStream.WriteStr(Data.Relations[I].sWhere);
     oStream.Write(@Data.Relations[I].btFlag,SizeOf(Byte));
     oStream.WriteStr(Data.Relations[I].sGameName);
     {$IF PACKETVER >1}
     oStream.Write(@Data.Relations[i].ChrID1,SizeOf(Integer));
     oStream.Write(@Data.Relations[i].ChrID2,SizeOf(Integer));
     {$IFEND}
  end;
  oStream.Write(@Data.btRelationSet,Sizeof(Byte));
  oStream.Write(@Data.btLove,SizeOf(Byte));
  oStream.Write(@Data.dwCurLove,SizeOf(DWord));
  oStream.Write(@Data.dwMaxLove,SizeOf(DWord));
  {$IF PACKETVER >2}
  oStream.Write(@Data.nFHLeftSec,SizeOf(Integer));
  oStream.Write(@Data.nFTLeftSec,SizeOf(Integer));
  oStream.Write(@Data.dwCredit,SizeOf(DWord));
  oStream.WriteStr(Data.sTitle);
  oStream.Write(@Data.P1,SizeOf(Integer));
  oStream.Write(@Data.P2,SizeOf(Integer));
  oStream.Write(@Data.P3,SizeOf(Integer));
  oStream.Write(@Data.P4,SizeOf(Integer));
  {$IFEND}
  Result:=True;
end;
initialization
  g_pPacketFactoryManager:=TPacketFactoryManager.Create;
finalization
  g_pPacketFactoryManager.Free;
end.
