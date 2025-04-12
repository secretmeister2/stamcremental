extends Resource
class_name SaveData
signal updated(thing)

#@export var playerData:PlayerData:
#	set(value):
#		playerData = value
#		updated.emit()
@export var modifiers:Array:
	set(value):
		modifiers = value
		updated.emit()
@export var unlocked_tiles:Array[Tile]:
	set(value):
		unlocked_tiles = value
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

@export_group("Statistics")
@export var max_stam:float=10:
	set(value):
		max_stam = value
		updated.emit()
@export var move_cost_mult:float=1:
	set(value):
		move_cost_mult = value
		updated.emit()
@export var tree_1_size:int=15:
	set(value):
		tree_1_size = value
		updated.emit()
@export var branches:Array[String]:
	set(value):
		branches = value
		updated.emit()
