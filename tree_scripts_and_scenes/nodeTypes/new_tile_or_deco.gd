extends TreeNodeType
class_name TileOrDecoUnlock
@export var new_tile_or_deco: TilesAndDecos

func bought():
	if is_instance_of(new_tile_or_deco, Tile):
		Global.data.unlocked_tiles.append(new_tile_or_deco)
	elif is_instance_of(new_tile_or_deco, Deco):
		Global.data.unlocked_decos.append(new_tile_or_deco)
		
