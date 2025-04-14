@tool
extends Resource
## A modifier modifies a [Stat] based on [Condition]s.
class_name Modifier
signal valChanged()
##Array of conditions required for modifier to be active
@export var conditions: Array[Condition]:
	set(value):
		conditions=value
		for condition in conditions:
			if not condition.updated.has_connections():
				condition.updated.connect(cons_updated)
##The name of the stat that this modifier affects
@export var affected_stat: String
## What type this stat is.
##[br][code]"Multiplier"[/code] indicates that this modifier multiplies a given [Stat]
##[br][code]"Additive"[/code] indicates that this modifier adds to a given [Stat]
##[br][code]"Replace"[/code] indicates that this modifier replaces a given [Stat]
##[br][code]"Scalar"[/code] indicates that this modifier scales one [Stat] based on the value of another [Stat]
@export_enum("Multiplier", "Additive", "Replace", "Scalar") var modify_type:String:
	set(new):
		modify_type=new
		notify_property_list_changed()
## [Stat] that it scales off of
var dependentStat:StatDef:
	set(value):
		dependentStat=value
		var list=[]
		for conn in dependentStat.changed.get_connections(): list.append(conn.callable)
		if scal_val_changed not in list:
			dependentStat.changed.connect(scal_val_changed)
## The step that this stat should increase in
var step:float
## The amount to multiply the dependent [Stat] by before adding to this [Stat].
var multOfDep:float
## What value this uses for the above
@export
var useValue : float:
	set(newvalue):
		useValue=newvalue
		if conditions.is_empty(): truth=true
		valChanged.emit()
var truth : bool = false:
	set(value):
		truth=value
		valChanged.emit()
## Whether the modifier is good if it is lower or higher
@export var isGood :bool=true:
	set(value):
		isGood=value


func scal_val_changed():
	if modify_type=="Scalar":
		useValue=round(dependentStat.final_val*multOfDep*step)/step

func cons_updated():
	for con in conditions:
		if not con.truth: 
			truth=false
			return
	truth=true

func mod_randomize(basepoints:int, currentTiles:Array[Tile], currentDecos:Array[Deco]):
	var points=basepoints

	for con in conditions:
		points -= con.con_randomize(round(points*0.125), currentTiles, currentDecos)
	while points>0:
		if modify_type=="Additive" or modify_type=="Multiplier" or modify_type=="Replace":
			if isGood: useValue*=1.1
			else: useValue*=0.9
			points-=2
		elif modify_type == "Scalar":
			multOfDep*=1.1
			points-=4

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
		#_:
			#properties.append({
			#		"name" : "useValue",
			#		"type" : TYPE_FLOAT,
			#		"usage" : PROPERTY_USAGE_EDITOR
			#})
	return properties
