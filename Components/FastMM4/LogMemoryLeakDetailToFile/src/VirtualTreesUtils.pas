{*------------------------------------------------------------------------------
  功能描述：对于 Virtual TreeView 的一些方法的包装
  创建日期：2008-03-07 22:46:54
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
  功能描述：为 TreeNode 设置相关联的 Object
  创建日期：2008-03-07 22:48:02
  @author bahb
  @param Node VirtualTreeView 上的节点
  @param Obj  与节点相关联的 Object
  @return
  @Comment
  @version
  @throws
  @todo
------------------------------------------------------------------------------*}
procedure SetVirtualTreeNodeObj(Node: PVirtualNode; Obj: TObject);

{*------------------------------------------------------------------------------
  功能描述：读取 TreeNode 相关联的 Object
  创建日期：2008-03-07 22:53:01
  @author bahb
  @param Node VirtualTreeView 上的节点
  @return     返回与节点相关联的 Object
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
