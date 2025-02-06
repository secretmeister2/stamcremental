extends Node2D

var grid_size: Vector2
var max_stam: float=10
var stam: float=max_stam
var unlocked_base_tiles:Array[Tile]
var unlocked_decos:Array[Tile]
var tile_rarities:Dictionary[Tile,int]
var deco_rarities:Dictionary[Tile,int]

func get_relative(tile:ColorRect, offset:Vector2)->ColorRect:
	var current_y=tile.get_parent().name.right(1)
	var targetrow=$RowContainer.get_node_or_null("Row_" + str(int(current_y)+offset.y))
	if targetrow==null:return null
	return targetrow.get_node_or_null("Tile_"+str(int(current_y)+offset.y)+"_"+str(int(tile.name.right(1))+offset.x))

func gen():
	for i in range(1,grid_size[0]):
		var row = HBoxContainer.new()
		row.name = "Row_"+str(i)
		$RowContainer.add_child(row)
		for j in range(1,grid_size[1]):
			var rect = ColorRect.new()
			rect.name = "Tile_"+str(i)+"_"+str(j)
			row.add_child(rect)
			var tiletype = unlocked_base_tiles[0]
			rect.set_meta("tile", tiletype)
