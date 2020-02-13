unit ThreadDownload;

interface
uses Windows,Classes,ScktComp,SysUtils,ComCtrls,ExtCtrls;
const
  MAXTHREADPERTASK=20;
type
  TThreadState=(ttsNone,ttsStart,ttsDownload,ttsPause,ttsComplete,ttsError);
  pTThreadInfo=^TThreadInfo;
  TThreadInfo=record
    Thread        :TThread;        //关联的线程
    StartPos      :integer;        //开始下载位置
    NeedSize      :integer;        //需要下载数据长度
    CompleteBytes :integer;        //已经完成的数据
    AvgSpeed      :integer;        //平均速度
    CurSpeed      :integer;        //当前速度
    MaxRetry      :integer;        //失败后重试次数
    ThreadState   :TThreadState;   //线程状态
  end;

  TTaskState=(tsNone,tsGetFileSize,tsCreateFile,tsRun,tsComplete,tsStop,tsPause,tsError);
  pTTaskInfo=^TTaskInfo;
  TTaskInfo=record
    URL           :string;      //下载的URL地址
    FileName      :String;      //保存的文件名，要求是绝对路径
    ThreadCount   :Integer;     //当前使用的线程数量
    CurThreadCount:integer;     //当前使用的线程数
    MaxThreadCount:integer;     //最多线程数量
    MaxRetry      :integer;     //每线程最大重试次数
    FileSize      :Int64;       //文件大小
    CompleteBytes :integer;     //完成数量
    CurSpeed      :Integer;     //下载速度，字节/秒
    AvgSpeed      :integer;     //平均下载速度
    UseTime       :Integer;     //已用时间，毫秒
    State         :TTaskState;  //当前状态
    boSendEvent   :Boolean;     //内部使用，外部不要改变此值
    Threads       :Array[0..MAXTHREADPERTASK-1] of TThreadInfo;
    FWriteLock    :TRTLCriticalSection;
    EchoMsg       :String;      //错误信息
  end;

  TOnWriteData=procedure (Sender:TObject;Position:Integer;Buf:PChar;Len:Integer) of Object;
  TDownloadThread=class(TThread)
    ClientSocket:TClientSocket;
    ThreadInfo:pTThreadInfo;
    MainThread:Boolean;
    FURL:String;
  private
    FOnWriteData:TOnWriteData;
    FRetryTime:Integer;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy;override;
    procedure Execute;override;
    property OnWriteData:TOnWriteData read FOnWriteData write FOnWriteData;
  end;

  TTaskThread=class(TThread)
  private
    ClientSocket:TClientSocket;
    FWriter:TFileStream;
    FTaskInfo:pTTaskInfo;
    procedure WriteData(Sender:TObject;Position:Integer;Buf:PChar;Len:Integer);
  protected
    function  CheckFileSize:Integer;
    function  CreateFile:Boolean;
    function  CreateDownloadThreads(MaxThread:integer):Integer;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy;override;
    procedure Execute;override;
    property TaskInfo:pTTaskInfo read FTaskInfo write FTaskInfo;
  end;

  TDownloadTaskEvent = procedure(Sender:TObject;ATaskInfo:pTTaskInfo) of object;
  TDownloadTaskManager=class(TComponent)  //下载任务管理器，对多个下载任务进行分配
  private
    FTasks:Array of TTaskInfo;
    FMaxThread:Integer;                   //同时允许的最多线程数
    FMaxRetry:integer;
    FTimer:TTimer;
    FOnTaskError: TDownloadTaskEvent;
    FOnTaskStart: TDownloadTaskEvent;
    FOnTaskComplete: TDownloadTaskEvent;
    FOnDownloading: TNotifyEvent;
    FStoped:Boolean;
    FNotifyInterval: Integer;
    function GetTaskCount: integer;
    procedure SetTaskCount(const Value: integer);
    function GetTask(Index: Integer): pTTaskInfo;
    procedure TimerOnTimer(Sender: TObject);
    procedure SetStoped(const Value: boolean);
    procedure SetNotifyInterval(const Value: Integer);
  public
    constructor Create(AOwner:TComponent);override;
    destructor  destroy;override;
    procedure AddTask(AURL:String;SavePath:String);
    procedure CleatTask;
    procedure Start;
    procedure Stop;
    function GetWebFileSize(sURL:String;var ResponseStr:String):Integer;  //获得网站上一个文件的大小，阻塞模式
    procedure RestartTask(ATaskInfo:pTTaskInfo);   //重新开始一个任务
    property TaskCount:integer read GetTaskCount write SetTaskCount;
    property Task[Index:Integer]:pTTaskInfo read GetTask;
    property Stoped:boolean read FStoped write SetStoped;
  published
    property MaxThread:Integer read FMaxThread write FMaxThread default 10;
    property MaxRetry:Integer read FMaxRetry write FMaxRetry default 0;
    property OnTaskError:TDownloadTaskEvent read FOnTaskError write FOnTaskError;
    property OnTaskStart:TDownloadTaskEvent read FOnTaskStart write FOnTaskStart;
    property OnTaskComplete:TDownloadTaskEvent read FOnTaskComplete write FOnTaskComplete;
    property OnDownloading:TNotifyEvent read FOnDownloading write FOnDownloading;
    property NotifyInterval:Integer read FNotifyInterval write SetNotifyInterval;
  end;

  Tbuf_char = array[0..4095] of char;
  Tbuf_byte = array[0..4095] of byte;
  function GetHost(in1: string;var port:WORD): string;
  function GetFileFromURL(in1: string): string;
  procedure Register;
implementation
procedure Register;
begin
  RegisterComponents('Samples',[TDownloadTaskManager]);
end;
function SocketRecLine(Socket: TCustomWinSocket; Timeout: integer; crlf: string = #13#10): string;
var
  buf1: Tbuf_char;
  r1: integer;
  ts1: TStringStream;
  FSocketStream: TWinSocketStream;
begin
  ts1 := TStringStream.Create('');
  FSocketStream := TWinSocketStream.create(Socket, Timeout);
  while (Socket.Connected = true) do begin
    if not FSocketStream.WaitForData(timeout) then break;
    zeromemory(@buf1, sizeof(buf1));
    r1 := FsocketStream.Read(buf1, 1);
    if r1 = 0 then break;
    ts1.Write(buf1, r1);
    if pos(crlf, ts1.DataString) <> 0 then break;
  end;
  result := ts1.DataString;
  if pos(crlf, result) = 0 then result := '';
  ts1.Free;
  FSocketStream.Free;
end;

function GetHost(in1: string;var port:WORD): string;
var
  sp:String;
  I:Integer;
begin
  port:=80;
  in1 := trim(in1);
  I:=pos('http://', lowercase(in1));
  if I = 1 then in1 := copy(in1, Length('http://') + 1, length(in1));
  I:=pos('/', in1);
  if I <> 0 then  in1 := copy(in1, 1, I - 1);
  i:=Pos(':',in1);
  if I<>0 then begin
    sp:=Copy(in1,I+1,Length(in1));
    Delete(in1,I,Length(in1));
    port:=StrToInt(sp);
  end;
  result := in1;
end;

function GetFileFromURL(in1: string): string;
begin
  in1 := trim(in1);
  if pos('http://', lowercase(in1)) = 1 then
    in1 := copy(in1, length('http://') + 1, length(in1));
  if pos('/', in1) <> 0 then
    in1 := copy(in1, pos('/', in1) + 1, length(in1));
  result := in1;
end;

{ TDownloadThread }

constructor TDownloadThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  ClientSocket:=TClientSocket.Create(nil);
  ClientSocket.ClientType:=ctBlocking;
  MainThread:=False;
  ThreadInfo:=nil;
  FRetryTime:=0;
end;

destructor TDownloadThread.Destroy;
begin
  ClientSocket.Active:=False;
  ClientSocket.Free;
  inherited;
end;

procedure TDownloadThread.Execute;
const
  MaxRecvLen  = 8192;
  MaxWriteLen = 1048576;
var
  CmdStr,ServFileName,ServHost,Cmd,Value:string;
  I,J,K,BlockPerThread,RecvLen,rec:Integer;
  CanRecv:Boolean;
  RecvBuf: PChar;
  WriteBuf:PChar;
  WriteBufPos:integer;
  AllWritePos:integer;
  port:Word;
  StartTick,Tick,CurTick:Integer;
  OldBytes:Integer;
label doRetry,doError;
begin
  try
    ServFileName := GetFileFromURL(FURL);
    Servhost := GetHost(FURL,port);
    ClientSocket.Host := ServHost;
    ClientSocket.Port := port;
    GetMem(RecvBuf,MaxRecvLen);
    GetMem(WriteBuf,MaxWriteLen);
    Try
      doRetry:
      if ThreadInfo.ThreadState = ttsNone then goto doError;  //被中断
      //发送get请求，以得到实际的文件数据
      clientsocket.Active := false;
      clientsocket.Active := true;
      CmdStr := 'GET /' + ServFileName + ' HTTP/1.1'#13#10'Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*' + #13#10
              +'Pragma: no-cache'+#13#10'User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705)' + #13#10
              + 'RANGE: bytes=' + inttostr(ThreadInfo.StartPos) + '-' +inttostr(ThreadInfo.StartPos + Threadinfo.NeedSize)+ #13#10
              + 'Host: ' + ServHost + #13#10#13#10;
      ClientSocket.Socket.SendText(CmdStr);
      CanRecv:=False;
      while ClientSocket.Active do begin
        if ThreadInfo.ThreadState = ttsNone then goto doError;
        cmd := SocketRecLine(ClientSocket.Socket, 60 * 1000);
        if pos(lowercase('Content-Range:'), lowercase(cmd)) = 1 then CanRecv := true;
        if pos(lowercase('Content-Length: '), lowercase(cmd)) = 1 then begin  //计算要接收的长度
          value := copy(cmd, length('Content-Length: ') + 1, length(cmd));
          RecvLen := strtoint(trim(value));
        end;
        if cmd = #13#10 then break;  //头信息收完了
      end;
      if not CanRecv then begin
        Inc(FRetryTime);
        if FRetryTime>ThreadInfo.MaxRetry then begin  //重试次数达到最大值，出错
          ThreadInfo.ThreadState:=ttsError;
          goto doError;
        end;
        Sleep(5000);
        goto doRetry; //等待5秒再试
      end;

      ThreadInfo.ThreadState:=ttsDownload;
      WriteBufPos:=0;
      AllWritePos:=ThreadInfo.StartPos;
      ThreadInfo.CompleteBytes:=0;

      StartTick:=GetTickCount;
      CurTick:=GetTickCount;
      OldBytes:=0;
      while ClientSocket.Active = true do begin
        if ThreadInfo.ThreadState = ttsNone then goto doError;
        if not CanRecv then goto doError;
        zeromemory(RecvBuf, MaxRecvLen);
        try
          rec := ClientSocket.Socket.ReceiveBuf(RecvBuf^, MaxRecvLen);
        except
          rec:=-1;
        end;
        if rec<0 then begin  //出错了
          Inc(FRetryTime);
          if FRetryTime>ThreadInfo.MaxRetry then begin
            ThreadInfo.ThreadState:=ttsError;
            goto doError;
          end;
          Sleep(5000);  //等待5秒再试
          goto doRetry;
        end;
        if ThreadInfo.CompleteBytes+rec>ThreadInfo.NeedSize then  //防止多下载数据
          rec:=ThreadInfo.NeedSize - ThreadInfo.CompleteBytes;
        I:=MaxWriteLen - WriteBufPos;  //I=剩余写空间
        if ThreadInfo.ThreadState = ttsNone then goto doError;
        if I<=rec then begin  //剩余写空间不够，则填满写空间后，写数据，并把剩余数据写到写空间中
          Move(RecvBuf[0],WriteBuf[WriteBufPos],I);
          if Assigned(FOnWriteData) then  //正式写入数据
            FOnWriteData(Self,AllWritePos,@WriteBuf[0],MaxWriteLen);
          Inc(AllWritePos,MaxWriteLen);
          Move(RecvBuf[I],WriteBuf[0],rec - I);  //把剩余接收换从数据写到写缓冲
          WriteBufPos:=rec - I;                  //写缓冲当前位置
        end else begin
          Move(RecvBuf[0],WriteBuf[WriteBufPos],rec);
          Inc(WriteBufPos,rec);
        end;
        Inc(ThreadInfo.CompleteBytes,rec);

        Tick:=(GetTickCount - CurTick) div 1000;
        if Tick>0 then begin
          ThreadInfo.CurSpeed:=(ThreadInfo.CompleteBytes - OldBytes) div Tick;
          Tick:=(GetTickCount - StartTick) div 1000;
          ThreadInfo.AvgSpeed:=ThreadInfo.CompleteBytes div Tick;
          OldBytes:=ThreadInfo.CompleteBytes;
          CurTick:=GetTickCount;
        end;
        if ThreadInfo.CompleteBytes>=ThreadInfo.NeedSize then Break;
      end;
      if ThreadInfo.ThreadState = ttsNone then goto doError;
      if WriteBufPos>0 then begin
        if Assigned(FOnWriteData) then  //正式写入数据
          FOnWriteData(Self,AllWritePos,@WriteBuf[0],WriteBufPos);
      end;
      ThreadInfo.ThreadState:=ttsComplete;  //完成
      doError:;
    finally
      ClientSocket.Active := false;
      FreeMem(RecvBuf);
      FreeMem(WriteBuf);
    end;
  except
    ThreadInfo.ThreadState:=ttsError;
  end;
  ThreadInfo.Thread:=nil;
  Free;
end;


{ TTaskThread }

function TTaskThread.CheckFileSize: Integer;
var
  url,ServFileName,ServHost,Cmd,Value:string;
  port:Word;
begin
  ServHost:=GetHost(FTaskInfo.URL,port);
  ServFileName := GetFileFromURL(FTaskInfo.URL);
  FTaskInfo.EchoMsg:='';
  try
    ClientSocket.Active := false;
    ClientSocket.Host := ServHost;
    ClientSocket.Port := port;
    ClientSocket.Active := false;
    ClientSocket.Active := true;
    URL :='HEAD /' + ServFilename + ' HTTP/1.1'#13#10'Pragma: no-cache' + #13#10'Cache-Control: no-cache' + #13#10
         + 'User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705)' + #13#10'Host: ' + ServHost + #13#10#13#10;
    ClientSocket.Socket.SendText(URL);
    while ClientSocket.Active do begin
      if FTaskInfo.State=tsPause then break;
      FTaskInfo.EchoMsg:=FTaskInfo.EchoMsg + Cmd;
      if Pos('http/1.1 404 not found',LowerCase(Cmd))>0 then begin
        Result:=0;
        Break;
      end;
      Cmd := SocketRecLine(ClientSocket.Socket, 60 * 1000);
      if pos(lowercase('Content-Length: '), lowercase(Cmd)) = 1 then begin
        Value := copy(Cmd, length('Content-Length: ') + 1, length(Cmd));
        FTaskInfo.FileSize := strtoint(trim(Value));
      end;
      if Cmd = #13#10 then break;
    end;
    Result:=FTaskInfo.FileSize;
  except
    Result:=-1;
  end;
  if Result<=0 then FTaskInfo.State:=tsError;
end;

constructor TTaskThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  ClientSocket:=TClientSocket.Create(nil);
  ClientSocket.ClientType:=ctBlocking;
  FWriter:=nil;
end;

//创建下载进程并执行下载
function TTaskThread.CreateDownloadThreads(MaxThread: integer): Integer;
const
  BlockSize = 262144; //每个线程至少256K的任务
var
  I,J,K,BytesPerThread,FirstThreadBytes:Integer;
  DownThread:TDownloadThread;
begin
  Result:=0;
  if MaxThread<=0 then MaxThread:=1;
  if MaxThread>MAXTHREADPERTASK then MaxThread:=MAXTHREADPERTASK;
  FTaskInfo.ThreadCount:=FTaskInfo.FileSize div BlockSize;
  if FTaskInfo.ThreadCount=0 then FTaskInfo.ThreadCount:=1;
  if FTaskInfo.ThreadCount>MaxThread then FTaskInfo.ThreadCount:=MaxThread;  //实际需要的线程数
  BytesPerThread:=Round(FTaskInfo.FileSize / FTaskInfo.ThreadCount); //每线程计划下载数量
  FirstThreadBytes:=FTaskInfo.FileSize - (BytesPerThread * FTaskInfo.ThreadCount) + BytesPerThread;
  J:=0;
  FTaskInfo.CurThreadCount:=0;
  For I:=0 to FTaskInfo.ThreadCount -1 do begin  //创建线程
    DownThread:=TDownloadThread.Create(True);
    with DownThread do begin
      FURL:=FTaskInfo.URL;
      Inc(FTaskInfo.CurThreadCount);
      ThreadInfo:=@FTaskInfo.Threads[I];
      ThreadInfo.Thread:=DownThread;
      ThreadInfo.MaxRetry:=FTaskinfo.MaxRetry;
      OnWriteData:=WriteData;
      ThreadInfo.StartPos:=J;
      ThreadInfo.ThreadState:=ttsStart;
      if I=0 then begin
        ThreadInfo.NeedSize:=FirstThreadBytes;
        Inc(J,FirstThreadBytes);
      end else begin
        if J+BytesPerThread>FTaskInfo.FileSize then
          ThreadInfo.NeedSize:=FTaskInfo.FileSize - J
        else
          ThreadInfo.NeedSize:=BytesPerThread;
        Inc(J,BytesPerThread);
      end;
      if J>=FTaskInfo.FileSize then Break;
    end;
  end;
  if FTaskInfo.CurThreadCount=0 then exit;
  //启动下载线程
  for I:=0 to FTaskInfo.CurThreadCount -1 do begin
    FTaskInfo.Threads[i].Thread.Resume;
  end;
  Result:=FTaskInfo.CurThreadCount;
end;

function TTaskThread.CreateFile: Boolean;
begin
  Result:=False;
  if FTaskInfo.FileSize<=0 then Exit;
  if FWriter<>nil then FWriter.Free;
  try
    FWriter:=TFileStream.Create(FTaskInfo.FileName,fmCreate);
    FWriter.Size:=FTaskInfo.FileSize;
    Result:=True;
  except
    Result:=False;
  end;
end;

destructor TTaskThread.Destroy;
begin
  ClientSocket.Free;
  if FWriter<>nil then FWriter.Free;
  inherited;
end;

procedure TTaskThread.Execute;
var
  I,ErrCount,RunCount,CompleteCount,CompleteBytes,NewBytes:Integer;
  StartTick,Tick,CurTick:Integer;
  DownThread:TDownloadThread;
begin
  FTaskInfo.State:=tsGetFileSize;
  if CheckFileSize<=0 then begin
    FTaskInfo.State:=tsError;
    Exit;  //外面中断任务
  end;
  FTaskInfo.State:=tsCreateFile;
  if not CreateFile then begin
    FTaskInfo.State:=tsError;
    Exit;  //外面中断任务
  end;
  if FTaskInfo.State=tsPause then begin
    FTaskInfo.State:=tsError;
    Exit;  //外面中断任务
  end;
  if CreateDownloadThreads(FTaskInfo.MaxThreadCount)=0 then Exit;
  if FTaskInfo.State=tsPause then begin
    FTaskInfo.State:=tsStop;
    Exit;  //外面中断任务
  end;
  FTaskInfo.State:=tsRun;
  //监视下载进程，直到所有下载进程都完成。
  StartTick:=GetTickCount;
  CurTick:=GetTickCount;
  InitializeCriticalSection(FTaskInfo.FWriteLock);
  try
    while FTaskInfo.State=tsRun do begin
      ErrCount:=0;
      RunCount:=0;
      CompleteCount:=0;
      CompleteBytes:=0;
      For I:=0 to FTaskInfo.ThreadCount -1 do begin
        case FTaskInfo.Threads[i].ThreadState of
          ttsNone:;
          ttsStart:;
          ttsDownload:;
          ttsPause:;
          ttsComplete:Inc(CompleteCount);
          ttsError:Inc(ErrCount);
        end;
        Inc(CompleteBytes,FTaskInfo.Threads[i].CompleteBytes);  //统计完成数量
      end;
      FTaskInfo.CurThreadCount:=FTaskInfo.ThreadCount - CompleteCount;  //当前线程数

      NewBytes:=CompleteBytes - FTaskInfo.CompleteBytes;
      FTaskInfo.CompleteBytes:=CompleteBytes;
      Tick:=(GetTickCount - StartTick) div 1000;
      FTaskInfo.UseTime:=Tick;
      if Tick>0 then begin
        FTaskInfo.AvgSpeed:=CompleteBytes div Tick;
      end else begin
        FTaskInfo.AvgSpeed:=0;
      end;
      Tick:=(GetTickCount - CurTick) div 1000;
      if Tick>0 then begin
        FTaskInfo.CurSpeed:=NewBytes div Tick;
      end else begin
        FTaskInfo.CurSpeed:=0;
      end;
      CurTick:=GetTickCount;

      if CompleteCount>=FTaskInfo.ThreadCount then begin  //全部完成
        FTaskInfo.State:=tsComplete;
        break;
      end;
      if ErrCount>=FTaskInfo.ThreadCount then begin       //全部失败
        FTaskInfo.State:=tsError;
        Break;
      end;

      if (ErrCount>0) and (CompleteCount>0) then begin             //部分完成部分失败，则创建新的线程
        For I:=0 to FTaskInfo.ThreadCount-1 do begin
          if (FTaskInfo.Threads[i].ThreadState=ttsError) and (FTaskInfo.Threads[i].Thread=nil) then begin  //在错误的线程上创建新的线程
            DownThread:=TDownloadThread.Create(True);
            with DownThread do begin
              FURL:=FTaskInfo.URL;
              Inc(FTaskInfo.CurThreadCount);
              ThreadInfo:=@FTaskInfo.Threads[I];
              ThreadInfo.Thread:=DownThread;
              ThreadInfo.MaxRetry:=FTaskinfo.MaxRetry;
              ThreadInfo.CompleteBytes:=0;
              OnWriteData:=WriteData;
              ThreadInfo.ThreadState:=ttsStart;
            end;
            DownThread.Resume;
            Break;
          end;
        end;
      end;
      Sleep(500);
      if not (FTaskInfo.State in [tsRun,tsComplete]) then begin  //通知所有线程停止工作
        For I:=0 to FTaskInfo.ThreadCount-1 do begin
          FTaskInfo.Threads[i].ThreadState:=ttsNone;
        end;
      end;
    end;
    FTaskInfo.State:=tsComplete;
  except
    FTaskInfo.State:=tsError;
  end;
  DeleteCriticalSection(FTaskInfo.FWriteLock);
  Free;
end;

procedure TTaskThread.WriteData(Sender: TObject; Position:Integer; Buf: PChar; Len: Integer);
begin
  EnterCriticalSection(FTaskInfo.FWriteLock);
  try
    if Position<=0 then
      FWriter.Seek(Position,soBeginning)
    else
      FWriter.Seek(Position,soBeginning);
    FWriter.Write(Buf^,Len);
  finally
    LeaveCriticalSection(FTaskInfo.FWriteLock);
  end;
end;
{ TDownloadTaskManager }

procedure TDownloadTaskManager.AddTask(AURL, SavePath: String);
var
  I:Integer;
begin
  I:=Length(FTasks);
  SetLength(FTasks,I+1);
  with FTasks[i] do begin
    URL:=AURL;
    FileName:=SavePath;
    ThreadCount   :=0;
    CurThreadCount:=0;
    MaxThreadCount:=FMaxThread;
    MaxRetry      :=FMaxRetry;
    FileSize      :=0;
    CompleteBytes :=0;
    CurSpeed      :=0;
    AvgSpeed      :=0;
    UseTime       :=0;
    State         :=tsNone;
    boSendEvent   :=False;
  end;
end;

procedure TDownloadTaskManager.CleatTask;//不安全
var
  I:Integer;
  boNeedSleep:Boolean;
begin
  if not FStoped then raise Exception.Create('请先停止所有任务才能清理任务列表!');
  boNeedSleep:=False;
  for I:=0 to Length(FTasks)-1 do begin
    if FTasks[i].State in [tsGetFileSize,tsCreateFile,tsRun] then begin
      boNeedSleep:=True;
      FTasks[i].State:=tsPause;  //通知线程要求中断任务
    end;
  end;
  if boNeedSleep then begin //直到所有任务线程都已经结束
    repeat
      Sleep(100);
      boNeedSleep:=False;
      for I:=0 to Length(FTasks)-1 do begin
        if not (FTasks[i].State in [tsNone,tsComplete,tsError,tsStop]) then begin
          boNeedSleep:=True;
          Break;
        end;
      end;
    until not boNeedSleep;
  end;
  SetLength(FTasks,0);
end;

constructor TDownloadTaskManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  setLength(FTasks,0);
  FTimer:=TTimer.Create(nil);
  FTimer.Interval:=500;
  FTimer.Enabled:=False;
  FTimer.OnTimer:=TimerOnTimer;
  FMaxThread:=10;
  FMaxRetry:=0;
  FStoped:=True;
  FNotifyInterval:=100;
end;

destructor TDownloadTaskManager.destroy;
begin
  Stop;
  FTimer.Free;
  inherited;
end;

function TDownloadTaskManager.GetTask(Index: Integer): pTTaskInfo;
begin
  if (index>=0) and (index<Length(FTasks)) then
    Result:=@FTasks[Index]
  else
    Result:=nil;
end;

function TDownloadTaskManager.GetTaskCount: integer;
begin
  Result:=Length(FTasks);
end;

//当获取失败时，ResponseStr返回的是错误信息
function TDownloadTaskManager.GetWebFileSize(sURL: String;var ResponseStr:String): Integer;
var
  url,ServFileName,ServHost,Cmd,Value:string;
  port:Word;
  ClientSocket:TClientSocket;
begin
  Result:=0;
  ServHost:=GetHost(sURL,port);
  ServFileName := GetFileFromURL(sURL);
  ResponseStr:='';
  ClientSocket:=TClientSocket.Create(nil);
  try
    ClientSocket.ClientType:=ctBlocking;
    ClientSocket.Active := false;
    ClientSocket.Host := ServHost;
    ClientSocket.Port := port;
    ClientSocket.Active := false;
    ClientSocket.Active := true;
    URL :='HEAD /' + ServFilename + ' HTTP/1.1'#13#10'Pragma: no-cache' + #13#10'Cache-Control: no-cache' + #13#10
         + 'User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705)' + #13#10'Host: ' + ServHost + #13#10#13#10;
    ClientSocket.Socket.SendText(URL);
    while ClientSocket.Active do begin
      Cmd := SocketRecLine(ClientSocket.Socket, 60 * 1000);
      ResponseStr:=ResponseStr + Cmd;
      if Pos('http/1.1 404 not found',LowerCase(Cmd))>0 then begin
        Result:=0;
        Break;
      end;
      if pos(lowercase('Content-Length: '), lowercase(Cmd)) = 1 then begin
        Value := copy(Cmd, length('Content-Length: ') + 1, length(Cmd));
        Result := strtoint(trim(Value));
      end;
      if Cmd = #13#10 then break;
    end;
  except
    on e:Exception do begin
      ResponseStr:=e.Message;
      Result:=-1;
    end;
  end;
end;

procedure TDownloadTaskManager.RestartTask(ATaskInfo: pTTaskInfo);
var
  I,J:Integer;
begin
  //只有出错和完成了的任务才可以重新开始
  For I:=0 to Length(FTasks)-1 do begin
    if ATaskInfo = @FTasks[i] then begin
      if ATaskInfo.State in [tsComplete,tsStop,tsError] then begin
        ATaskInfo.boSendEvent:=False;
        ATaskInfo.State:=tsNone;
      end;
      Break;
    end;
  end;
end;

procedure TDownloadTaskManager.SetNotifyInterval(const Value: Integer);
begin
  if Value<=0 then
    FNotifyInterval := 1000
  else
    FNotifyInterval := Value;
  FTimer.Interval:=FNotifyInterval;
end;

procedure TDownloadTaskManager.SetStoped(const Value: boolean);
begin
  if Value then Stop else Start;
end;

procedure TDownloadTaskManager.SetTaskCount(const Value: integer);
begin
  setLength(FTasks,Value);
end;

procedure TDownloadTaskManager.Start;
begin
  if FStoped then begin
    FStoped:=False;
    FTimer.Enabled:=True;
  end;
end;

procedure TDownloadTaskManager.Stop;
begin
  if not FStoped then begin
    FStoped:=True;
    FTimer.Enabled:=False;
    CleatTask;
  end;
end;

procedure TDownloadTaskManager.TimerOnTimer(Sender: TObject);
var
  I,CurThreadCount:Integer;
  s:String;
  boAllComplete:Boolean;
begin
  CurThreadCount:=0;
  boAllComplete:=True;
  FTimer.Enabled:=False;
  Try
    For I:=0 to Length(FTasks)-1 do begin
      case FTasks[i].State of
        tsNone        :boAllComplete:=False;
        tsGetFileSize :begin
          boAllComplete:=False;
          CurThreadCount:=FMaxThread;   //任务还没正式开始，不能创建新的任务
        end;
        tsCreateFile  :begin
          boAllComplete:=false;
          CurThreadCount:=FMaxThread;   //任务还没正式开始，不能创建新的任务
        end;
        tsRun         :begin
          boAllComplete:=False;
          Inc(CurThreadCount,FTasks[i].CurThreadCount); //统计正在使用的线程数
        end;
        tsComplete    :if not FTasks[i].boSendEvent then begin
          FTasks[i].boSendEvent:=True;
          if Assigned(FOnTaskComplete) then FOnTaskComplete(Self,@FTasks[i]);  //任务完成
          if FStoped then Exit;
        end;
        tsStop        :;
        tsPause       :;
        tsError       :if not FTasks[i].boSendEvent then begin                 //任务出错
          FTasks[i].boSendEvent:=True;
          if Assigned(FOnTaskError) then FOnTaskError(Self,@FTasks[i]); //在这个事件中可以有机会重新下载
          if FStoped then Exit;
          if FTasks[i].State<>tsError then boAllComplete:=false;  //如果出错的任务重新开始了，则所有任务未完成。
        end;
      end;
    end;
    if CurThreadCount<FMaxThread then begin  //开始一个任务
      For I:=0 to Length(FTasks)-1 do begin
        if FTasks[i].State=tsNone then begin
          FTasks[i].MaxThreadCount:=FMaxThread;
          FTasks[i].MaxRetry:=FMaxRetry;
          s:=ExtractFilePath(FTasks[i].FileName);
          Try
            if s<>'' then ForceDirectories(s);
            with TTaskThread.Create(True) do begin
              TaskInfo:=@FTasks[I];
              Resume;
            end;
            if Assigned(FOnTaskStart) then FOnTaskStart(Self,@FTasks[I]);  //通知任务开始
            Break;
          except
            FTasks[i].State:=tsError;
          end;
        end;
      end;
    end;
    if FStoped then Exit;
    if Assigned(FOnDownloading) then
    try
      FOnDownloading(Self);
    except
      //下载失败报错
    end;
    if FStoped then Exit;
    if boAllComplete then begin
      if Assigned(FOnTaskComplete) then FOnTaskComplete(Self,nil); //全部任务完成
      Stop;
    end;
  finally
    if not FStoped then FTimer.Enabled:=True;
  end;
end;

end.
