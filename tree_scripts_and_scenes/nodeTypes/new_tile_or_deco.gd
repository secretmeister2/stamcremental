extends TreeNodeType
class_name TileOrDecoUnlock

var new_tile_or_deco: TilesAndDecos:
	set(value):
		new_tile_or_deco=value

var tiledecodef=preload("res://tileAndDecoDefs/tilesanddecosdef.tres")

func bought():
	if is_instance_of(new_tile_or_deco, Tile):
		Global.data.unlocked_tiles.append(new_tile_or_deco)
	elif is_instance_of(new_tile_or_deco, Deco):
		Global.data.unlocked_decos.append(new_tile_or_deco)

func gen_ability(points:int, currentTiles:Array[Tile], currentDecos:Array[Deco]):
	var validTiles = tiledecodef.tiles_rarities.keys().duplicate()
	for item in currentTiles:
		validTiles.erase(item)
	var validDecos = tiledecodef.decos_rarities.keys().duplicate()
	for deco in currentDecos:
		validDecos.erase(deco)
	var toerase:Array
	for deco in validDecos:
		var test = false
		for tile in deco.tilesChance.keys():
			if tile in currentTiles.map(func name(value):return value.name):
				test=true
		if not test: toerase.append(deco)
	for deco in toerase:
		validDecos.erase(deco)
	var valid_tecos:Array = []
	valid_tecos.append_array(validTiles)
	valid_tecos.append_array(validDecos)
	print(valid_tecos.map(func name(value):return value.name))
	valid_tecos.shuffle()
	var highest:TilesAndDecos
	for i in range(0,points):
		var test = valid_tecos.pick_random()
		if not highest or tiledecodef.combined_rarities.get(test) > tiledecodef.combined_rarities.get(highest):
			highest = test
	new_tile_or_deco=highest
	return highest

func parse()->String:
	print("ParseNewTile")
	return "Cost: \n This unlocks the " + new_tile_or_deco.parse()
