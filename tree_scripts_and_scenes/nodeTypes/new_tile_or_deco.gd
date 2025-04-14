extends TreeNodeType
class_name TileOrDecoUnlock
@export var new_tile_or_deco: TilesAndDecos:
	set(value):
		new_tile_or_deco=value
var tiledecodef=preload("res://tileAndDecoDefs/tilesanddecosdefinition.tres")
func bought():
	if is_instance_of(new_tile_or_deco, Tile):
		Global.data.unlocked_tiles.append(new_tile_or_deco)
	elif is_instance_of(new_tile_or_deco, Deco):
		Global.data.unlocked_decos.append(new_tile_or_deco)
		
func gen_ability(points:int, currentTiles:Array[Tile], currentDecos:Array[Deco]) ->TilesAndDecos:
	if randf()<0.5 and tiledecodef.tiles_rarities.keys()!=currentTiles:
		var possibleTiles=tiledecodef.tiles_rarities.keys()
		for tile in currentTiles:
			possibleTiles.erase(tile)
		new_tile_or_deco=tiledecodef.choose_random(possibleTiles,currentTiles,points)
		if new_tile_or_deco==null: return null
	elif tiledecodef.decos_rarities.keys()!=currentDecos:
		var possibleDecos=tiledecodef.decos_rarities.keys()
		for deco in currentDecos:
			possibleDecos.erase(deco)
		new_tile_or_deco=tiledecodef.choose_random(possibleDecos,currentDecos,points)
		if new_tile_or_deco==null: return null
	return new_tile_or_deco
