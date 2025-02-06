extends Resource
class_name SkillTree
##The names of the branches in use for this tree
@export var branches: Array[String]
##The tree storage
@export var tree: Dictionary[Vector2,BaseTreeNode]
var amount:int
var furthest_of_branch:Dictionary[String,Vector2]
var origin:BaseTreeNode

func gen_tree():
	branches.shuffle()
	origin = BaseTreeNode.new(Global.rarity.rare, "origin")
	origin.is_origin=true
	tree[Vector2(0,0)]=origin
	for i in range(branches.size()):
		var vector:Vector2
		while Global.dist_to_nearest_node(vector, tree.keys()) < 60 or vector.distance_to(Vector2(0,0))>130:
			vector = 10*Vector2(randi_range(-20,20),randi_range(-20,20))
		var node=BaseTreeNode.new(Global.rarity.common, branches[i])
		connect_nodes(origin,node)
		tree[vector]=node
		furthest_of_branch[branches[i]]=vector
	while tree.size()<amount+1:
		var vector:Vector2
		while Global.dist_to_nearest_node(vector, tree.keys()) < 100 or Global.dist_to_nearest_node(vector, tree.keys()) >150:
			vector = (tree.size()+15)*Vector2(randi_range(-20,20),randi_range(-20,20))
		var node=BaseTreeNode.new(Global.rarity.common)
		tree[vector]=node
		var treeminself = tree.duplicate()
		treeminself.erase(vector)
		treeminself.erase(Vector2(0,0))
		for thing in node.connected_from:treeminself.erase(thing)
		var neighbour = Global.get_nearest_node(vector,treeminself)
		connect_nodes(neighbour,node)
	##Setting up branches
	for node in tree.values():
		var bannodes:Array[BaseTreeNode]=[node]
		for subnode in node.connected_from:
			##Synergy nodes should not have outgoing connections
			if subnode.branches.size()>1:
				print("Disconnect")
				disconnect_nodes(subnode,node)
				##If this makes a stranded node, fix it
				if node.connected_from.size()==0:
					var treeminussub=tree.duplicate()
					bannodes.append(subnode)
					for unnode in bannodes: 
						treeminussub.erase(tree.find_key(unnode))
					print("Reconnect")
					connect_nodes(Global.get_nearest_node(tree.find_key(node),treeminussub),node)
			else:
				node.branches.append_array(subnode.branches)

func connect_nodes(fromnode:BaseTreeNode,tonode:BaseTreeNode):
	if fromnode==tonode:print("huh")
	if not tonode in fromnode.connected_to:fromnode.connected_to.append(tonode)
	if not fromnode in tonode.connected_from:tonode.connected_from.append(fromnode)

func disconnect_nodes(node1:BaseTreeNode,node2:BaseTreeNode):
	if node1 in node2.connected_from:
		node2.connected_from.erase(node1)
		node1.connected_to.erase(node2)
	else: 
		node1.connected_from.erase(node2)
		node2.connected_to.erase(node1)

func _init(amount:int, branches:Array[String]):
	self.amount=amount
	self.branches=branches
	self.gen_tree()
