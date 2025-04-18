extends Control
var deszoom:float = 1.0
var despos:Vector2 = Vector2(0,0)
@onready var label = $RichTextLabel
#@onready var panel = $RichTextLabel/Panel

func _process(_delta: float) -> void:
	if focused:
		despos += 10*Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		camera.position = lerp(camera.position,despos, 0.2)
		var zoom:float = lerpf(camera.zoom.x,deszoom,0.2)
		camera.zoom = Vector2(zoom,zoom)

func recenter():
	despos=Vector2(0,0)
	deszoom = 1.0

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var mouse = event as InputEventMouseMotion
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			despos -= mouse.relative/camera.zoom.x
			camera.position = despos
	elif event is InputEventMouseButton:
		var mouse = event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_WHEEL_UP:
			deszoom += 0.1*deszoom
			if deszoom ==  clamp(deszoom,0.1,10):
				despos += (mouse.position-Vector2(get_window().size)/2)/Vector2(get_window().size)*camera.get_viewport_rect().size*0.1/deszoom
		elif mouse.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			deszoom -= 0.1*deszoom
			if deszoom ==  clamp(deszoom,0.1,10):
				despos -= (mouse.position-Vector2(get_window().size)/2)/Vector2(get_window().size)*camera.get_viewport_rect().size*0.1/deszoom
		deszoom = clamp(deszoom,0.1,10)

var treenode = preload("res://tree_scripts_and_scenes/tree_1_node.tscn")
var connector = preload("res://tree_scripts_and_scenes/connector.tscn")
var focused = false
var locations:Dictionary[Vector2,Global.rarity]
@onready var nodes= $HBoxContainer/SubViewportContainer/SubViewport/Nodes
@onready var connects= $HBoxContainer/SubViewportContainer/SubViewport/Connects
@onready var camera = $HBoxContainer/SubViewportContainer/SubViewport/Camera2D

func locationsofrarity(rarity:Global.rarity)->Array[Vector2]:
	var array:Array[Vector2]
	for key in locations:
		if locations[key]==rarity: array.append(key)
	return array

var origin: BaseTreeNode

func _ready() -> void:
	var treee = SkillTree.new(floor(Global.data.get_stat_or_null("Tree1Size").final_val))
	construct_tree(treee)
	pass

func display_data(place:Node):
	label.text=(place.get_meta("node").parse())
	#label.position=place.position
	if not label.get_parent():
		place.add_child(label)
	else: label.reparent(place)

func undisplay_data(place:Node):
	if label.get_parent():
		label.get_parent().remove_child(label)

func construct_tree(tree:SkillTree):
	for place in tree.tree.keys():
		var nodedata=tree.tree[place]
		var node=treenode.instantiate()
		node.treeman=self
		node.global_position=place
		node.set_meta("node",nodedata)
		node.node=nodedata
		node.get_node("RarityColor").color = Global.raritycolors[nodedata.rarity]
		nodes.add_child(node)
		node.node.status=node.node.status
		node.hovered.connect(display_data.bind())
		node.unhovered.connect(undisplay_data.bind())
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



func _on_recenter_pressed() -> void:
	recenter()
