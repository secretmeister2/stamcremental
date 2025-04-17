@tool
extends Resource
class_name TilesAndDecosDefinition
@export var tiles_rarities: Dictionary[Tile,int]:
	set(value):
		tiles_rarities=value
		print("Combine")
		combined_rarities={}
		combined_rarities.merge(tiles_rarities)
		combined_rarities.merge(decos_rarities)
@export var decos_rarities: Dictionary[Deco,int]:
	set(value):
		decos_rarities=value
		print("Combine")
		combined_rarities={}
		combined_rarities.merge(tiles_rarities)
		combined_rarities.merge(decos_rarities)
var combined_rarities: Dictionary[TilesAndDecos,int]

func choose_random(fromlist:Array,notlist:Array,points:int)->TilesAndDecos:
	if fromlist.is_empty(): return null
	var validDict:Dictionary
	if notlist[0] is Tile:
		validDict=tiles_rarities
	else:
		validDict=decos_rarities
		for key in validDict.keys():
			if key.tiles:
				pass
	for item in notlist:
		validDict.erase(item)
	var highest:TilesAndDecos
	for i in range(0,points):
		var test = fromlist.pick_random()
		if not highest or validDict[test]>validDict[highest]:
			highest=test
	return highest
