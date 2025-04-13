extends Node

signal player_moved_to(place:ColorRect)
signal stat_changed(stat:StatDef)

## Global reference to the save data
var data:SaveData:
	set(value):
		data=value
		for stat in data.stats:
			if not stat.val_changed.has_connections():
				stat.val_changed.connect(stat_changed_func.bind())

func stat_changed_func(stat:StatDef):
	stat_changed.emit(stat)

func _init() -> void:
	data = load("res://savedata/save.tres")

# Vars used for tree
enum rarity{
	common=1,
	uncommon=2,
	rare=3,
	epic=4,
	legend=5
}
@export var raritycolors: Array[Color]=[Color(0),Color(949494),Color(0.419, 0.495, 0.775),Color(0.671, 0.429, 0.895)]

# Functions for use in tree management
##Finds the nearest vector in the list to the given one
func dist_to_nearest_node(place: Vector2, array:Array) -> int:
	## Dynamic tracker of closest spot so far
	var nearest= place.distance_to(Vector2(0,0))
	for dist in array:
		if dist.distance_to(place) < nearest: nearest = dist.distance_to(place)
	return nearest
##Gets the nearest variant in the list to the given one
func get_nearest_node(place: Vector2, dict:Dictionary[Vector2,BaseTreeNode]) -> BaseTreeNode:
	## Dynamic tracker of closest spot so far
	var nearest= 100000000
	var near_thing
	for dist in dict.keys():
		if dist.distance_to(place) < nearest: 
			nearest = dist.distance_to(place)
			near_thing=dict[dist]
	return near_thing
