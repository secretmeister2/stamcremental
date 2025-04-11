@tool
extends Resource
## A modifier modifies a [Stat] based on [Condition]s.
class_name Modifier
##Array of conditions required for modifier to be active
@export var conditions: Array[Condition]:
	set(value):
		for condition in conditions:
			if not condition.updated.has_connections():
				condition.updated.connect(cons_updated)
##The stat that this modifier affects
@export var affected_stat: StatDef
## What type this stat is.
##[br][code]"Multiplier"[/code] indicates that this modifier multiplies a given [Stat]
##[br][code]"Additive"[/code] indicates that this modifier adds to a given [Stat]
##[br][code]"Replace"[/code] indicates that this modifier replaces a given [Stat]
##[br][code]"Scalar"[/code] indicates that this modifier scales one [Stat] based on the value of another [Stat]
@export_enum("Multiplier", "Additive", "Replace", "Scalar") var modify_type:String:
	set(new):
		modify_type=new
		notify_property_list_changed()
@export_group("Scalar")
## [Stat] that it scales off of
var dependentStat:StatDef
## The step that this stat should increase in
var step:float
## The amount to multiply the dependent [Stat] by before adding to this [Stat].
var multOfDep:float
@export_group("")
## What value this uses for the above
var value : float

func cons_updated():
	return

func _get_property_list() -> Array:
	var properties = []
	match modify_type:
		"Scalar":
			properties.append({
					"name" : "dependentStat",
					"type" : TYPE_OBJECT,
					"hint" : PROPERTY_HINT_RESOURCE_TYPE,
					"hint_string" : "StatDef",
					"usage" : PROPERTY_USAGE_EDITOR
			})
			properties.append({
					"name" : "step",
					"type" : TYPE_FLOAT,
					"usage" : PROPERTY_USAGE_EDITOR
			})
			properties.append({
					"name" : "multOfDep",
					"type" : TYPE_FLOAT,
					"usage" : PROPERTY_USAGE_EDITOR
			})
		_:
			properties.append({
					"name" : "value",
					"type" : TYPE_FLOAT,
					"usage" : PROPERTY_USAGE_EDITOR
			})
	return properties
