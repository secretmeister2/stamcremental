extends Control

var focused = false

var tilesize : int = 30
## The size of the play grid
@export var grid_size: Vector2
## The maximum stamina in current scope
var max_stam: float=10
## Counter of current stamina
var stam: float=max_stam:
	set(value):
		stam=value
		if round(stam * 100) / 100.0 <= 0:
			playing=false
			gameready = false
		if is_instance_valid(stam_label):
			stam_label.text=str(round(stam * 100) / 100.0)

## The base tiles that are currently unlocked
@export var unlocked_base_tiles:Array[Tile]
## The list of decorations that are unlocked
@export var unlocked_decos:Array[Deco]


## Maps the nodes to the data
var tiles:Dictionary[ColorRect,Tile]
## Maps data to lists of nodes
var tile_dict:Dictionary
## Maps name of tile type to tile type
var name_to_tile:Dictionary

## Whether a run is currently in session
var playing = false
## Whether the game is ready
var gameready = false
## Reference to the player
@onready var player : ColorRect = $Player
@onready var stam_label = $VBoxContainer/HBoxContainer/Label2
@onready var row_container = $VBoxContainer/RowContainer

## Start the game
func start():
	move_player(tile_dict.get(unlocked_base_tiles[0]).pick_random())
	stam=max_stam
	playing=true
	stam_label.text=str(round(stam * 100) / 100.0)

## Clear prior game
func clear():
	tiles.clear()
	tile_dict.clear()
	player.get_parent().remove_child(player)
	for row in row_container.get_children():
		row.free()
	stam = -1
	gameready = false

## Handle movement
func _process(_delta: float) -> void:
	if playing && focused:
		if Input.is_action_just_pressed("ui_down"):
			move_player(get_relative(player.get_parent(), Vector2(0,1)))
		if Input.is_action_just_pressed("ui_up"):
			move_player(get_relative(player.get_parent(), Vector2(0,-1)))
		if Input.is_action_just_pressed("ui_left"):
			move_player(get_relative(player.get_parent(), Vector2(-1,0)))
		if Input.is_action_just_pressed("ui_right"):
			move_player(get_relative(player.get_parent(), Vector2(1,0)))
## Move the player
func move_player(place:ColorRect):
	if place:
		if player.get_parent():
			player.get_parent().remove_child(player)
		place.add_child(player)
		if place.get_children().size()==1:
			player.pivot_offset=player.size/2
			player.set_anchors_preset(Control.PRESET_CENTER, true)
		else:
			player.pivot_offset=2*player.size
			player.set_anchors_preset(Control.PRESET_TOP_LEFT, true)
		Global.player_moved_to.emit(place)
		if place.get_child(0):
			if place.get_child(0).get_meta("deco"):
				Inventory.add_item(place.get_child(0).get_meta("deco").stack)
				place.get_child(0).queue_free()
		if playing == true: stam -= place.get_meta("tile").move_cost

## Get a relative node from a node and offset
func get_relative(tile:ColorRect, offset:Vector2)->ColorRect:
	var current_y=tile.get_parent().name.right(1)
	var targetrow=row_container.get_node_or_null("Row_" + str(int(current_y)+int(offset.y)))
	if targetrow==null:
		return null
	return targetrow.get_node_or_null("Tile_"+str(int(current_y)+int(offset.y))+"_"+str(int(tile.name.right(1))+int(offset.x)))

## Generate the base layer from the first entry in unlocked base tiles
func gen_base_tiles():
	for i in range(1,grid_size[0]):
		var row = HBoxContainer.new()
		row.name = "Row_"+str(i)
		row_container.add_child(row)
		for j in range(1,grid_size[1]):
			var rect = ColorRect.new()
			rect.name = "Tile_"+str(i)+"_"+str(j)
			rect.size_flags_horizontal = Control.SIZE_EXPAND
			row.add_child(rect)
			var tiletype = unlocked_base_tiles[0]
			rect.set_meta("tile", tiletype)
			rect.custom_minimum_size = Vector2(30,30)
			tiles[rect]=tiletype
			rect.color=tiletype.col
			var temp =tile_dict.get_or_add(tiletype, [])
			temp.append(rect)
			tile_dict.set(tiletype, temp)
	name_to_tile[unlocked_base_tiles[0].name]=unlocked_base_tiles[0]

## Code to generate the other tile types
func gen_tile_type(type:Tile):
		name_to_tile[type.name]=type
		for i in range(0,type.max_blobs):
			if randf()+(0.15*i)<0.9:
				var blobtiles:Array
				var matchtiles=tile_dict[unlocked_base_tiles[0]]
				blobtiles.append(matchtiles.pick_random())
				matchtiles.erase(blobtiles[0])
				blobtiles[0].set_meta("tile", type)
				blobtiles[0].color=type.col
				var j = 1.0
				while randf_range(0,j*1.4)<type.blob_size*0.2*grid_size.length() and j+1<matchtiles.size():
					var attempt = matchtiles.pick_random()
					for neighbour in get_neighbours(attempt, "4"):
						if neighbour in blobtiles:
							attempt.set_meta("tile", type)
							matchtiles.erase(attempt)
							blobtiles.append(attempt)
							attempt.color=type.col
							var temp =tile_dict.get_or_add(type, [])
							temp.append(attempt)
							tile_dict.set(type, temp)
							j+=1.0
							break
					j+=0.1
					if j >= 100: break

## Master function to generate grid
func gen():
	gen_base_tiles()
	var base_tiles = unlocked_base_tiles.duplicate()
	base_tiles.erase(unlocked_base_tiles[0])
	for type in base_tiles:
		gen_tile_type(type)
	common_fix()
	for decoration in unlocked_decos:
		place_decoration(decoration)

## Smoothes out array by finding anything that has 5 common neighbours and changed it to that
func common_fix():
	for tile in tiles:
		var types : Array
		for neighbour in get_neighbours(tile).filter(func iff(value): return value != null):
			types.append(neighbour.get_meta("tile"))
		var mostcommon=null
		types.erase(tile.get_meta("tile"))
		for type in types:
			if types.count(type)>types.count(mostcommon):mostcommon=type
		## If the tile has more than 6 neighbours of a different type, change to that type
		if types.count(mostcommon) > 5:
			var temp = tile_dict.get_or_add(tile.get_meta("tile"), [])
			temp.erase(tile)
			tile_dict.set(tile.get_meta("tile"), temp)
				
			tile.set_meta("tile", mostcommon)
			tile.color=mostcommon.col
			
			temp =tile_dict.get_or_add(mostcommon, [])
			temp.append(tile)
			tile_dict.set(mostcommon, temp)

## Find and place a decoration
func place_decoration(decoration:Deco):
		for tiletype in decoration.tiles:
			var arraay = tile_dict.get(name_to_tile[tiletype])
			if arraay != null && arraay != []:
				var test = true
				for tile in arraay:
					for child in tile.get_children(): 
						if child not in decoration.shared: 
							test = false
					if randf()<=decoration.place_chance && test && test_cons(decoration.cons,tile):
						place_deco(decoration, tile)

## Test conditions for a decoration
func test_cons(cons:Array[TilePlaceCon], tile:ColorRect) -> bool:
	var final = true
	var neighbours = get_neighbours(tile)
	for con in cons:
		var count = 0
		for neighbour in neighbours:
			if neighbour and neighbour.get_meta("tile").name in con.req_tiles:
				count +=1
			elif not neighbour and con.inverted:
				count +=1
			if neighbour:
				for deco in neighbour.get_children():
					if deco.name in con.req_tiles:
						count +=1
		if count >= con.req_num: 
			if con.inverted:
				final = false
		elif not con.inverted:
			final = false
	return final

## Add a decoration to a tile
func place_deco(decoration:Deco, tile: ColorRect):
	var deco = ColorRect.new()
	deco.color = decoration.col
	tile.add_child(deco)
	deco.size=Vector2(30,30)
	deco.pivot_offset=deco.size/2
	deco.scale=decoration.size*Vector2(1,1)
	deco.set_meta("deco", decoration)
	player.set_anchors_preset(Control.PRESET_CENTER, true)

## Get neighbouring tiles of [param rect], [param type] can be [code]4[/code] for direct adjacencies or [code]8[/code] for all
func get_neighbours(rect:ColorRect,type:String="8")->Array:
	var array : Array
	if type == "8":
		for i in range(3):
			for j in range(3):
				if not (i == 1 and j == 1): 
					array.append(get_relative(rect,Vector2(i-1,j-1)))
	elif type == "4":
		array.append(get_relative(rect,Vector2(-1,0)))
		array.append(get_relative(rect,Vector2(1,0)))
		array.append(get_relative(rect,Vector2(0,1)))
		array.append(get_relative(rect,Vector2(0,-1)))
	return array

func _on_button_pressed() -> void:
	clear()
	gen()
	start()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("inputt")
