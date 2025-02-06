extends Node2D

func _process(delta: float) -> void:
	$Camera2D.position += 10*Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

var treenode = preload("res://tree_scripts_and_scenes/tree_1_node.tscn")
var connector = preload("res://tree_scripts_and_scenes/connector.tscn")

var locations:Dictionary[Vector2,Global.rarity]


func locationsofrarity(rarity:Global.rarity)->Array[Vector2]:
	var array:Array[Vector2]
	for key in locations:
		if locations[key]==rarity: array.append(key)
	return array

var origin: BaseTreeNode

func _ready() -> void:
	var treee = SkillTree.new(15, ["Fire", "Earth"])
	construct_tree(treee)

func gen_board(amount:int):
	var j = 0
	while j < amount:
		if j==0: 
			locations[Vector2(0,0)]=3
		else: 
			var vector:Vector2
			while Global.dist_to_nearest_node(vector, locations.keys()) < 100 or Global.dist_to_nearest_node(vector, locations.keys())>150:
				vector = (j+10)*Vector2(randi_range(-20,20),randi_range(-20,20))
			var distfromorig = Vector2(0,0).distance_to(vector)
			var disttoepic = Global.dist_to_nearest_node(vector, locationsofrarity(4))
			var disttoleg = Global.dist_to_nearest_node(vector, locationsofrarity(5))
			match ceil(randf_range(0.5,2)+(disttoleg/250)+(disttoepic/200)+(distfromorig/150)):
				1.0: locations[vector]=Global.rarity.common
				2.0: locations[vector]=Global.rarity.common
				3.0: locations[vector]=Global.rarity.common
				4.0: locations[vector]=Global.rarity.uncommon
				5.0: locations[vector]=Global.rarity.uncommon
				6.0: locations[vector]=Global.rarity.rare
				7.0: locations[vector]=Global.rarity.rare
				8.0: locations[vector]=Global.rarity.epic
				_: locations[vector]=Global.rarity.legend
		j+=1
	for key in locations:
		var newnode=treenode.instantiate()
		if key == Vector2(0,0): 
			newnode.is_origin=true
			origin=newnode
		newnode.rarity=locations[key]
		newnode.global_position=key
		newnode.roll(Vector2(0,0).distance_to(newnode.global_position))
		$Nodes.add_child(newnode)
	for node in $Nodes.get_children():
		var neighbours: Array[BaseTreeNode]
		for subnode in $Nodes.get_children():
			if subnode == node: break
			if node.global_position.distance_to(subnode.global_position)<160:
				neighbours.append(subnode)
		for connection in $Connects.get_children():
			if node in connection.connectedto:
				neighbours.erase(connection.connectedto[0])
				neighbours.erase(connection.connectedto[1])
		#for neighbour in neighbours:
			#if node.connections.size() <1 or randf_range(node.connections.size(),2)<1.4:
				#connectnodes(node, neighbour)

	origin.connect_check()
	for node in $Nodes.get_children():
		if not node.conn_orig:
			var locs = locations.keys().duplicate()
			locs.erase(node)
			Global.dist_to_nearest_node(node.global_position, locs)
	origin.status="available"

func construct_tree(tree:SkillTree):
	for place in tree.tree.keys():
		var nodedata=tree.tree[place]
		var node=treenode.instantiate()
		node.global_position=place
		node.set_meta("node",nodedata)
		node.get_node("RarityColor").color = Global.raritycolors[nodedata.rarity]
		$Nodes.add_child(node)
	for node in $Nodes.get_children():
		var nodedata=node.get_meta("node")
		for tonode in nodedata.connected_to:
			var tonodepos = tree.tree.find_key(tonode)
			var connection = connector.instantiate()
			var place = node.global_position
			connection.get_node("ColorRect").custom_minimum_size = Vector2(5,tonodepos.distance_to(place))
			connection.connectedto=[nodedata,tonode] as Array[BaseTreeNode]
			connection.rotation=place.angle_to_point(tonodepos)-PI/2
			connection.global_position=place.lerp(tonodepos, 0.5)
			$Connects.add_child(connection)

func connectnodes(node1:BaseTreeNode, node2:BaseTreeNode):
	if not node2 in node1.connected_to:
		var connection = connector.instantiate()
		$Connects.add_child(connection)
		connection.get_node("ColorRect").custom_minimum_size = Vector2(5,node2.global_position.distance_to(node1.global_position))
		connection.connectedto=[node1,node2] as Array[BaseTreeNode]
		connection.rotation=node1.global_position.angle_to_point(node2.global_position)-PI/2
		connection.global_position=node1.global_position.lerp(node2.global_position, 0.5)
		node2.connections.append(connection)
		node1.connections.append(connection)
		node2.connected_to.append(node1)
		node1.connected_to.append(node2)
