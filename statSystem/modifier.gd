@tool
extends Resource
## A modifier modifies a [Stat] based on [Condition]s.
class_name Modifier
##Array of conditions required for modifier to be active
@export var conditions: Array[Condition]
##The stat that this modifier affects
@export var affected_stat: Stat 
## What type this stat is.
##[br][code]"Multiplier"[/code] indicates tha this modifier multiplies a given [Stat]
##[br][code]"Additive"[/code] indicates tha this modifier adds to a given [Stat]
##[br][code]"Replace"[/code] indicates tha this modifier replaces a given [Stat]
##[br][code]"Scalar"[/code] indicates tha this modifier scales one [Stat] based on the value of another [Stat]
@export_enum("Multiplier", "Additive", "Replace", "Scalar") var modify_type:String:
	set(new):
		modify_type=new
		notify_property_list_changed()
@export_group("Scalar")
## [Stat] that it scales off of
var dependentStat

var step

var multOfDep
@export_group("")
## What value this uses for the above
var value : float

func _get_property_list() -> Array:
	var properties = []
	match modify_type:
		"Scalar":
			properties.append({
					"name" : "dependentStat",
					"type" : TYPE_OBJECT,
					"hint" : PROPERTY_HINT_RESOURCE_TYPE,
					"hint_string" : "Stat",
					"usage" : PROPERTY_USAGE_EDITOR
			})
		_:
			properties.append({
					"name" : "value",
					"type" : TYPE_FLOAT,
					"usage" : PROPERTY_USAGE_EDITOR
			})
	return properties
