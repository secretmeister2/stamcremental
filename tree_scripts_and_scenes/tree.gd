extends Resource
class_name SkillTree
##The names of the branches in use for this tree
@export var branches: Array
##The tree storage
@export var tree: Dictionary[Vector2,BaseTreeNode]
var amount:int
var branch_nodes:Dictionary[String,Array]
var origin:BaseTreeNode

func gen_tree():
	branches=Global.data.branches
	branches=branches.map(func thingy(value): return value.name)
	branches.shuffle()
	origin = BaseTreeNode.new(Global.rarity.rare)
	origin.is_origin=true
	origin.status="bought"
	origin.ability=OriginAbility.new()
	tree[Vector2(0,0)]=origin
	for i in range(branches.size()):
		var vector:Vector2
		while Global.dist_to_nearest_node(vector, tree.keys()) < (100-(5*tree.size())) or vector.distance_to(Vector2(0,0))>130:
			vector = 20*Vector2(randi_range(-20,20),randi_range(-20,20))
		var node=BaseTreeNode.new(Global.rarity.common, branches[i])
		connect_nodes(origin,node)
		tree[vector]=node
		node.disorig=vector.distance_to(Vector2(0,0))
		node.status="available"
		var temp = branch_nodes.get_or_add(branches[i],[])
		temp.append(vector)
		branch_nodes.set(branches[i],temp)
	while tree.size()<amount+1:
		var valid_tree
		var branch
		if randf()*tree.size()<5:
			var newbranches: Dictionary[String,int]
			for branche in branch_nodes.keys(): newbranches[branche]=branch_nodes[branche].size()
			branch = newbranches.find_key(newbranches.values()[newbranches.values().find(newbranches.values().min())])
			valid_tree=branch_nodes[branch]
		else: valid_tree = tree.keys()
		
		var vector:Vector2
		var i = 0.0
		while Global.dist_to_nearest_node(vector, tree.keys()) < 105 or Global.dist_to_nearest_node(vector, valid_tree) >140:
			vector = (tree.size()+15)*Vector2(randi_range(-15,15),randi_range(-15,15))
			i+=0.5
		var node=BaseTreeNode.new(Global.rarity.common)
		if valid_tree != tree.keys():
			var temp = branch_nodes.get_or_add(branch,[])
			temp.append(vector)
			branch_nodes.set(branch,temp)
		tree[vector]=node
		node.disorig=vector.distance_to(Vector2(0,0))
		var treeminself = tree.duplicate()
		treeminself.erase(vector)
		treeminself.erase(Vector2(0,0))
		for thing in node.connected_from:treeminself.erase(thing)
		var neighbour = Global.get_nearest_node(vector,treeminself)
		#node.branches.append_array(neighbour.branches)
		connect_nodes(neighbour,node)
	##Setting up branches
	for node in tree.values():
		if node != origin: 
			var nodepos = tree.find_key(node)
			var validtree=tree.duplicate()
			validtree.erase(Vector2(0,0))
			validtree.erase(nodepos)
			for thing in node.connected_to+node.connected_from:
				validtree.erase(tree.find_key(thing))
			for thing in validtree:
				if thing.distance_to(nodepos) < 120:
					if randf()*tree[thing].connected_from.size()+node.connected_to.size() < 2 && not origin in tree[thing].connected_from:
						connect_nodes(node,tree[thing])
	origin.connect_check()
	for node in origin.connected_to:
		node.roll(Global.data.unlocked_tiles.duplicate(),Global.data.unlocked_decos.duplicate())
	
func connect_nodes(fromnode:BaseTreeNode,tonode:BaseTreeNode):
	if fromnode==tonode:printerr("Tried to connect node "+str(fromnode)+" to itself.")
	if not tonode in fromnode.connected_to:fromnode.connected_to.append(tonode)
	if not fromnode in tonode.connected_from:tonode.connected_from.append(fromnode)

func disconnect_nodes(node1:BaseTreeNode,node2:BaseTreeNode):
	if node1 in node2.connected_from:
		node2.connected_from.erase(node1)
		node1.connected_to.erase(node2)
	else: 
		node1.connected_from.erase(node2)
		node2.connected_to.erase(node1)

func _init(newamount:int):
	self.amount=newamount
	self.gen_tree()
