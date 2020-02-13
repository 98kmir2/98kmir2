{*------------------------------------------------------------------------------
  �������������� Virtual TreeView ��һЩ�����İ�װ
  �������ڣ�2008-03-07 22:46:54
  @author bahb
  @comment
  @version
  @todo
------------------------------------------------------------------------------*}
unit VirtualTreesUtils;

interface

uses
  VirtualTrees;

{*------------------------------------------------------------------------------
  ����������Ϊ TreeNode ����������� Object
  �������ڣ�2008-03-07 22:48:02
  @author bahb
  @param Node VirtualTreeView �ϵĽڵ�
  @param Obj  ��ڵ�������� Object
  @return
  @Comment
  @version
  @throws
  @todo
------------------------------------------------------------------------------*}
procedure SetVirtualTreeNodeObj(Node: PVirtualNode; Obj: TObject);

{*------------------------------------------------------------------------------
  ������������ȡ TreeNode ������� Object
  �������ڣ�2008-03-07 22:53:01
  @author bahb
  @param Node VirtualTreeView �ϵĽڵ�
  @return     ������ڵ�������� Object
  @Comment
  @version  
  @throws
  @todo  
------------------------------------------------------------------------------*}
function GetVirtualTreeNodeObj(Node: PVirtualNode): TObject;

implementation

type

  TInternalVirtualTree = class(TBaseVirtualTree);

function GetVTFromNode(Node: PVirtualNode): TInternalVirtualTree;
begin
  Result := TInternalVirtualTree(TreeFromNode(Node));
end;


procedure SetNodeDataSize(Node: PVirtualNode; Size: Integer);
var
  aTree: TInternalVirtualTree;
begin
  aTree := GetVTFromNode(Node);
  if aTree <> nil then aTree.NodeDataSize := Size;
end;


procedure SetVirtualTreeNodeObj(Node: PVirtualNode; Obj: TObject);
var
  aTree: TInternalVirtualTree;
begin
  aTree := GetVTFromNode(Node);
  if aTree <> nil then TObject(aTree.GetNodeData(Node)^) := Obj;
end;


function GetVirtualTreeNodeObj(Node: PVirtualNode): TObject;
var
  aTree: TInternalVirtualTree;
begin
  aTree := GetVTFromNode(Node);
  if aTree <> nil then Result := TObject(aTree.GetNodeData(Node)^)
  else Result := nil;
end;

end.
