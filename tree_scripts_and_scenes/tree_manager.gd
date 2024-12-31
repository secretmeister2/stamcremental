extends Node2D

func _process(delta: float) -> void:
	$Camera2D.position += 10*Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

var treenode = preload("res://tree_scripts_and_scenes/tree_1_node.tscn")
var connector = preload("res://tree_scripts_and_scenes/connector.tscn")

var locations:Dictionary[Vector2,Global.rarity]

func dist_to_nearest_node(place: Vector2, array:Array[Vector2]) -> int:
	var nearest= place.distance_to(Vector2(0,0))
	for dist in array:
		if dist.distance_to(place) < nearest: nearest = dist.distance_to(place)
	return nearest

func locationsofrarity(rarity:Global.rarity)->Array[Vector2]:
	var array:Array[Vector2]
	for key in locations:
		if locations[key]==rarity: array.append(key)
	return array

var origin: BaseTreeNode

func _ready() -> void:
	gen_board(30)

func gen_board(amount:int):
	var j = 0
	while j < amount:
		if j==0: 
			locations[Vector2(0,0)]=3
		else: 
			var vector:Vector2
			while dist_to_nearest_node(vector, locations.keys()) < 100 or dist_to_nearest_node(vector, locations.keys())>150:
				vector = (j+10)*Vector2(randi_range(-20,20),randi_range(-20,20))
			var distfromorig = Vector2(0,0).distance_to(vector)
			var disttoepic = dist_to_nearest_node(vector, locationsofrarity(4))
			var disttoleg = dist_to_nearest_node(vector, locationsofrarity(5))
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
	for node:BaseTreeNode in $Nodes.get_children():
		var neighbours: Array[BaseTreeNode]
		for subnode:BaseTreeNode in $Nodes.get_children():
			if subnode == node: break
			if node.global_position.distance_to(subnode.global_position)<160:
				neighbours.append(subnode)
		for connection in $Connects.get_children():
			if node in connection.connectedto:
				neighbours.erase(connection.connectedto[0])
				neighbours.erase(connection.connectedto[1])
		for neighbour in neighbours:
			if node.connections.size() <1 or randf_range(node.connections.size(),2)<1.4:
				var connection = connector.instantiate()
				$Connects.add_child(connection)
				connection.get_node("ColorRect").custom_minimum_size = Vector2(5,neighbour.global_position.distance_to(node.global_position))
				connection.connectedto=[node,neighbour] as Array[BaseTreeNode]
				connection.rotation=node.global_position.angle_to_point(neighbour.global_position)-PI/2
				connection.global_position=node.global_position.lerp(neighbour.global_position, 0.5)
				neighbour.connections.append(connection)
				node.connections.append(connection)
				neighbour.connected_to.append(node)
				node.connected_to.append(neighbour)
	origin.connect_check()
	for node in $Nodes.get_children():
		if not node.conn_orig:
			var locs = locations.keys().duplicate()
			locs.erase(node)
			dist_to_nearest_node(node.global_position, locs)
	origin.status="available"
