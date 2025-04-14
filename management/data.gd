extends Resource
class_name SaveData
signal updated(thing)

@export var modifiers:Array:
	set(value):
		modifiers = value
		updated.emit()
@export var unlocked_tiles:Array[Tile]:
	set(value):
		unlocked_tiles = value
		print("UpdatedDataTiles")
		updated.emit()
@export var unlocked_decos:Array[Deco]:
	set(value):
		unlocked_decos = value
		updated.emit()
@export var tree1:SkillTree:
	set(value):
		tree1 = value
		updated.emit()
@export var tree2:SkillTree:
	set(value):
		tree2 = value
		updated.emit()
@export var selected_slot:int:
	set(value):
		selected_slot = value
		updated.emit()

@export var branches : Array[Branch]

@export_group("Statistics")
@export var stats : Array[StatDef]

func get_stat_or_null(name:String)->StatDef:
	for stat in stats:
		if stat.name == name: 
			return stat
	return null
