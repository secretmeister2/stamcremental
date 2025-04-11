extends Control

func _process(_delta: float) -> void:
	if focused:
		camera.position += 10*Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var mouse = event as InputEventMouseMotion
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			camera.position -= mouse.relative/camera.zoom.x
	elif event is InputEventMouseButton:
		var mouse = event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom += Vector2(0.1,0.1)*camera.zoom.x
		elif mouse.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom -= Vector2(0.1,0.1)*camera.zoom.x

var treenode = preload("res://tree_scripts_and_scenes/tree_1_node.tscn")
var connector = preload("res://tree_scripts_and_scenes/connector.tscn")
var focused = false
var locations:Dictionary[Vector2,Global.rarity]
@onready var nodes= $Nodes
@onready var connects= $Connects
@onready var camera = $Camera2D

func locationsofrarity(rarity:Global.rarity)->Array[Vector2]:
	var array:Array[Vector2]
	for key in locations:
		if locations[key]==rarity: array.append(key)
	return array

var origin: BaseTreeNode

func _ready() -> void:
	var treee = SkillTree.new(15, ["Fire", "Earth", "Water", "Air"])
	construct_tree(treee)
	pass

func construct_tree(tree:SkillTree):
	for place in tree.tree.keys():
		var nodedata=tree.tree[place]
		var node=treenode.instantiate()
		node.global_position=place
		node.set_meta("node",nodedata)
		node.node=nodedata
		node.get_node("RarityColor").color = Global.raritycolors[nodedata.rarity]
		nodes.add_child(node)
	for node in nodes.get_children():
		var nodedata=node.get_meta("node")
		for tonode in nodedata.connected_to:
			var tonodepos = tree.tree.find_key(tonode)
			var connection = connector.instantiate()
			var place = node.global_position
			connection.get_node("ColorRect").custom_minimum_size = Vector2(5,tonodepos.distance_to(place))
			connection.connectedto=[nodedata,tonode] as Array[BaseTreeNode]
			connection.rotation=place.angle_to_point(tonodepos)-PI/2
			connection.global_position=place.lerp(tonodepos, 0.5)
			connects.add_child(connection)

func connectnodes(node1:BaseTreeNode, node2:BaseTreeNode):
	if not node2 in node1.connected_to:
		var connection = connector.instantiate()
		connects.add_child(connection)
		connection.get_node("ColorRect").custom_minimum_size = Vector2(5,node2.global_position.distance_to(node1.global_position))
		connection.connectedto=[node1,node2] as Array[BaseTreeNode]
		connection.rotation=node1.global_position.angle_to_point(node2.global_position)-PI/2
		connection.global_position=node1.global_position.lerp(node2.global_position, 0.5)
		node2.connections.append(connection)
		node1.connections.append(connection)
		node2.connected_to.append(node1)
		node1.connected_to.append(node2)
