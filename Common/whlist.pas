unit Whlist;

interface

uses
  Windows, Classes;

type
  pTWhnode = ^TWhnode;                  //定义节点指针
  TWhnode = record                      //定义节点结构体
    m_pData: Pointer;
    m_pPrev: pTWhnode;
    m_pNext: pTWhnode;
  end;

  TWhBaseList = class                   //双向键表...
  protected
    m_pHead: pTWhnode;
    m_pTail: pTWhnode;
    m_nCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearAll(bClearData: Boolean = True; bDeleteArray: Boolean = False);
    function Insert(pData: Pointer): Boolean; //尾插入节点数据
    function InsertHead(pData: Pointer): Boolean; //头插入
    function InsertAt(pNode: pTWhnode; pData: Pointer): Boolean; //某结点后插入

    function Remove(pKey: Pointer): Pointer; //由节点数据移去节点，返回下一节点的数据
    function RemoveNode(pNode: pTWhnode): pTWhnode; //移去节点，返回下一个节点
    function RemoveNode1(pNode: pTWhnode): Pointer; //移去节点，返回节点的数据
    function Search(pKey: Pointer): pTWhnode; //由节点数据找节点

    function GetHead(): pTWhnode; virtual; //得到头节点
    function GetTail(): pTWhnode;
    function GetPrev(pNode: pTWhnode): pTWhnode;
    function GetNext(pNode: pTWhnode): pTWhnode; virtual; //由节点找下一个节点
    function GetData(pNode: pTWhnode): Pointer; virtual; //由节点找节点的数据

    function GetCount(): Integer; virtual;
    function IsEmpty(): Boolean;

    procedure MoveToTail(pNode: pTWhnode);
  end;

  TWHList = class(TWhBaseList)          //带临界的双向键表
  public
    //m_cs: TRTLCriticalSection;
    constructor Create;
    destructor Destroy; override;
    function AddNewNode(lpData: Pointer): Boolean;
    function RemoveNodeByData(lpData: Pointer): Boolean;
    //function GetHead(): pTWhnode; override;
    //function GetNext(pNode: pTWhnode): pTWhnode; override;
    //function GetCount(): Integer; override;
    //function GetData(pNode: pTWhnode): Pointer; override;
    procedure Clear();
  end;

implementation

{ TWhBaseList }

constructor TWhBaseList.Create;
begin
  m_pHead := nil;
  m_pTail := nil;
  m_nCount := 0;
end;

destructor TWhBaseList.Destroy;
begin
  inherited;
end;

function TWhBaseList.Insert(pData: Pointer): Boolean;
var
  pNode                     : pTWhnode;
begin
  Result := False;
  if pData = nil then exit;
  if (m_pHead = nil) then begin         //当头节点未指定时....
    m_pHead := New(pTWhnode);           //头节点分配空间
    m_pHead^.m_pData := pData;          //头节点赋值
    m_pHead^.m_pNext := nil;
    m_pHead^.m_pPrev := m_pTail;
    m_pTail := m_pHead;                 //未节点=头节点
  end else begin
    pNode := New(pTWhnode);             //建立一个新节点空间
    pNode^.m_pData := pData;
    pNode^.m_pNext := nil;              //新节点的下一个节点为空
    pNode^.m_pPrev := m_pTail;          //新节点的上一个节点为未节点
    m_pTail^.m_pNext := pNode;
    m_pTail := pNode;                   //未节点=新节点
  end;
  Inc(m_nCount);
  Result := True;
end;

procedure TWhBaseList.MoveToTail(pNode: pTWhnode);
begin
  //
end;

function TWhBaseList.InsertHead(pData: Pointer): Boolean;
var
  pNode                     : pTWhnode;
begin
  Result := False;
  if (m_pHead = nil) then begin
    m_pHead := New(pTWhnode);
    m_pHead^.m_pData := pData;
    m_pHead^.m_pNext := nil;
    m_pHead^.m_pPrev := m_pTail;
    m_pTail := m_pHead;
  end else begin
    pNode := New(pTWhnode);
    pNode^.m_pData := pData;
    pNode^.m_pNext := m_pHead;
    m_pHead^.m_pPrev := pNode;
    m_pHead := pNode;
  end;
  Inc(m_nCount);
  Result := True;
end;

function TWhBaseList.InsertAt(pNode: pTWhnode; pData: Pointer): Boolean;
var
  pNew                      : pTWhnode;
begin
  Result := False;
  pNew := New(pTWhnode);
  pNew^.m_pData := pData;
  pNew^.m_pPrev := pNode;
  pNew^.m_pNext := pNode^.m_pNext;
  if (pNode^.m_pNext <> nil) then pNode^.m_pNext^.m_pPrev := pNew;
  pNode^.m_pNext := pNew;
  if (pNew^.m_pNext = nil) then m_pTail := pNew;
  Result := True;
end;

function TWhBaseList.Remove(pKey: Pointer): Pointer;
var
  pTemp                     : pTWhnode;
begin
  Result := nil;
  pTemp := m_pHead;                     //指向头节点...
  if pTemp = nil then Exit;
  repeat begin
      if pTemp^.m_pData = pKey then begin
        if (m_pHead = pTemp) then begin //为头节点....
          m_pHead := m_pHead^.m_pNext;
          if (m_pHead <> nil) then      //有下节点...
            m_pHead^.m_pPrev := nil
          else
            m_pTail := nil;
        end else begin
          if (pTemp^.m_pPrev <> nil) then begin //有上节点..
            pTemp^.m_pPrev^.m_pNext := pTemp^.m_pNext;
            if (pTemp.m_pNext <> nil) then //有下节点...
              pTemp^.m_pNext^.m_pPrev := pTemp^.m_pPrev
            else
              m_pTail := pTemp^.m_pPrev;
          end;
        end;
        Dispose(pTemp);
        Dec(m_nCount);
        Break;
      end;
      pTemp := pTemp^.m_pNext;
    end;
  until (pTemp = nil);                  //值成立时退出....
  if pTemp <> nil then Result := pTemp^.m_pData; //wladd
end;

function TWhBaseList.GetCount: Integer;
begin
  Result := m_nCount;
end;

function TWhBaseList.IsEmpty: Boolean;
begin
  Result := m_nCount = 0;
end;

procedure TWhBaseList.ClearAll(bClearData, bDeleteArray: Boolean);
var
  pTemp                     : pTWhnode;
begin
  while (m_pHead <> nil) do begin
    if (bClearData) then Dispose(m_pHead^.m_pData);

    pTemp := m_pHead;
    m_pHead := m_pHead^.m_pNext;
    if (m_pHead <> nil) then m_pHead^.m_pPrev := nil;

    Dispose(pTemp);
  end;

  m_pHead := nil;
  m_pTail := nil;
  m_nCount := 0;
end;

function TWhBaseList.GetHead: pTWhnode;
begin
  Result := m_pHead;
end;

function TWhBaseList.GetNext(pNode: pTWhnode): pTWhnode;
begin
  Result := nil;
  if pNode = nil then Exit;
  Result := pNode.m_pNext;
end;

function TWhBaseList.GetPrev(pNode: pTWhnode): pTWhnode;
begin
  Result := nil;
  if pNode = nil then Exit;
  Result := pNode.m_pPrev;
end;

function TWhBaseList.GetTail: pTWhnode;
begin
  Result := m_pTail;
end;

function TWhBaseList.RemoveNode(pNode: pTWhnode): pTWhnode;
begin
  Result := nil;
  if pNode = nil then Exit;
  Result := pNode.m_pNext;
  if (m_pHead = pNode) then begin       //为头节点....
    m_pHead := pNode^.m_pNext;          //头节点下移一位....
    if (m_pHead <> nil) then            //下移成功....
      m_pHead^.m_pPrev := nil
    else
      m_pTail := nil;
  end else begin                        //非头节点....
    if (pNode^.m_pPrev <> nil) then     //前一个节点不为空
      pNode^.m_pPrev^.m_pNext := pNode^.m_pNext;
    if (pNode^.m_pNext <> nil) then     //后一个节点不空
      pNode^.m_pNext^.m_pPrev := pNode^.m_pPrev
    else
      m_pTail := pNode^.m_pPrev;
  end;
  Dispose(pNode);
  pNode := nil;
  Dec(m_nCount);
end;

function TWhBaseList.RemoveNode1(pNode: pTWhnode): Pointer;
var
  pData                     : Pointer;
begin
  Result := nil;
  if pNode = nil then Exit;
  pData := pNode^.m_pData;
  if (m_pHead = pNode) then begin
    m_pHead := pNode^.m_pNext;
    if (m_pHead <> nil) then
      m_pHead^.m_pPrev := nil
    else
      m_pTail := nil;
  end else begin
    if (pNode^.m_pPrev <> nil) then
      pNode^.m_pPrev^.m_pNext := pNode^.m_pNext;
    if (pNode^.m_pNext <> nil) then
      pNode^.m_pNext^.m_pPrev := pNode^.m_pPrev
    else
      m_pTail := pNode^.m_pPrev;
  end;
  Dispose(pNode);
  pNode := nil;                         //wladd
  Dec(m_nCount);
  Result := pData;
end;

function TWhBaseList.Search(pKey: Pointer): pTWhnode;
var
  pTemp                     : pTWhnode;
begin
  Result := nil;

  pTemp := m_pHead;

  if pTemp = nil then Exit;

  repeat begin
      if (pKey = pTemp^.m_pData) then Result := pTemp;
      pTemp := pTemp^.m_pNext;
    end;
  until (pTemp = nil);
end;

function TWhBaseList.GetData(pNode: pTWhnode): Pointer;
begin
  if (pNode <> nil) then
    Result := pNode.m_pData
  else
    Result := nil;
end;

{ TWHList }

constructor TWHList.Create;
begin
  inherited Create;
  //InitializeCriticalSection(m_cs);
end;

destructor TWHList.Destroy;
begin
  //DeleteCriticalSection(m_cs);
  inherited Destroy;
end;

function TWHList.AddNewNode(lpData: Pointer): Boolean;
begin
  Result := False;

  //EnterCriticalSection(m_cs);
  //try
  Result := Insert(lpData);
  //finally
  //  LeaveCriticalSection(m_cs);
  //end;
end;

function TWHList.RemoveNodeByData(lpData: Pointer): Boolean;
begin
  Result := False;

  //EnterCriticalSection(m_cs);
  //try
  Remove(lpData);
  Result := True;
  //finally
  //  LeaveCriticalSection(m_cs);
  //end;
end;

{function TWHList.GetCount: Integer;
begin
  //try
  //  EnterCriticalSection(m_cs);
  Result := inherited GetCount;
  //finally
  //  LeaveCriticalSection(m_cs);
  //end;
end;

function TWHList.GetHead: pTWhnode;
begin
  //try
  //  EnterCriticalSection(m_cs);
  Result := inherited GetHead;
  //finally
  //  LeaveCriticalSection(m_cs);
  //end;
end;

function TWHList.GetNext(pNode: pTWhnode): pTWhnode;
begin
  //try
  //  EnterCriticalSection(m_cs);
  Result := inherited GetNext(pNode);
  //finally
  //  LeaveCriticalSection(m_cs);
  //end;
end;

function TWHList.GetData(pNode: pTWhnode): Pointer;
begin
  //try
  //  EnterCriticalSection(m_cs);
  Result := inherited GetData(pNode);
  //finally
  //  LeaveCriticalSection(m_cs);
  //end;
end;}

procedure TWHList.Clear;
var
  lpNode                    : pTWhnode;
begin
  //try
  //  EnterCriticalSection(m_cs);
  lpNode := GetHead;
  while (lpNode <> nil) do lpNode := RemoveNode(lpNode);
  //finally
  //  LeaveCriticalSection(m_cs);
  //end;
end;

end.
 
