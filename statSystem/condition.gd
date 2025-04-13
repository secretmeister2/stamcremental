@tool
extends Resource
## A condition that will have a [param truth] that is [code]true[/code] or [code]false[/code] based on game or stat events.
class_name Condition

signal updated()

## The type of condition.[br][code]"PlayerOnTileOrDeco"[/code] if player must be atop a specified [Tile] or [Deco].[br][code]"PlayerNearTileorDeco"[/code] if the player has to be near a specified [Tile] or [Deco].[br][code]"StatCompare"[/code] if one [Stat] is to be compared to another or a constant.
@export_enum("PlayerOnTileOrDeco", "StatCompare") 
var type :String:
	set(value):
		type=value
		notify_property_list_changed()
## The type of comparison for above
var comparator: String
## Whether to compare to a constant or another [Stat]
var constorstat : String
## The amount to compare against, if constant
var amount: float
## The stat to compare against if stat
var compStat : StatDef
var distance: int
## Whether the condition should check for [Tile]s or [Deco]s
var tileOrDeco:
	set(value):
		tileOrDeco=value
		notify_property_list_changed()
## The [Tile] this condition checks for
var tile: Tile
## The [Deco] this condition checks for
var deco: Deco
## Parameter keeping track of whether this condition is currently [code]true[/code] or [code]false[/code].
var truth = false:
	set(value):
		truth=value
		emit_changed()

func tile_on_updated(new_place):
	if (tileOrDeco == "Tile" && new_place.get_meta("tile") == tile) or (new_place.get_children()[0].get_meta("deco")==deco && tileOrDeco=="Deco"):
		truth=true
	else: truth=false

func _init() -> void:
	Global.player_moved_to.connect(tile_on_updated)

func _get_property_list() -> Array:
	var properties = []
	match type:
		"StatCompare":
			properties.append({
				"name" : "comparator",
				"type" : TYPE_STRING,
				"hint" : PROPERTY_HINT_ENUM,
				"hint_string" : "<,>,<=,>=,==",
				"usage" : PROPERTY_USAGE_EDITOR
			})
			properties.append({
				"name" : "amount",
				"type" : TYPE_FLOAT,
				"usage" : PROPERTY_USAGE_EDITOR
			})
		"PlayerNearTileorDeco":
			properties.append({
				"name" : "distance",
				"type" : TYPE_INT,
				"usage" : PROPERTY_USAGE_EDITOR
			})
			properties.append({
				"name" : "tileOrDeco",
				"type" : TYPE_STRING,
				"hint" : PROPERTY_HINT_ENUM,
				"hint_string" : "Tile,Deco",
				"usage" : PROPERTY_USAGE_EDITOR
			})
			match tileOrDeco:
				"Tile":
					properties.append({
					"name" : "tile",
					"type" : TYPE_OBJECT,
					"hint" : PROPERTY_HINT_RESOURCE_TYPE,
					"hint_string" : "Tile",
					"usage" : PROPERTY_USAGE_EDITOR
					})
				"Deco":
					properties.append({
					"name" : "deco",
					"type" : TYPE_OBJECT,
					"hint" : PROPERTY_HINT_RESOURCE_TYPE,
					"hint_string" : "Deco",
					"usage" : PROPERTY_USAGE_EDITOR
					})
		"PlayerOnTileOrDeco":
			properties.append({
				"name" : "tileOrDeco",
				"type" : TYPE_STRING,
				"hint" : PROPERTY_HINT_ENUM,
				"hint_string" : "Tile,Deco",
				"usage" : PROPERTY_USAGE_EDITOR
			})
			match tileOrDeco:
				"Tile":
					properties.append({
					"name" : "tile",
					"type" : TYPE_OBJECT,
					"hint" : PROPERTY_HINT_RESOURCE_TYPE,
					"hint_string" : "Tile",
					"usage" : PROPERTY_USAGE_EDITOR
					})
				"Deco":
					properties.append({
					"name" : "deco",
					"type" : TYPE_OBJECT,
					"hint" : PROPERTY_HINT_RESOURCE_TYPE,
					"hint_string" : "Deco",
					"usage" : PROPERTY_USAGE_EDITOR
					})
	return properties
