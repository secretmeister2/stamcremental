extends Resource
class_name StatDef
## The name of this stat
@export var name : String
## The default value of this stastic
@export var default_value : float
## All modifiers that affect this stat
var modifiers : Array[Modifier]
## Final calculated value of stat 
var final_val : float

func mods_updated():
	var mult = 1
	var add = 1
	for mod in modifiers:
		pass
