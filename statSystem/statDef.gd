extends Resource
class_name StatDef
signal val_changed
## The name of this stat
@export var name : String
## The default value of this stastic
@export var default_value : float:
	set(value):
		default_value=value
		mods_updated()
## All modifiers that affect this stat
var modifiers : Array[Modifier]:
	set(value):
		modifiers=value
		for mod in modifiers:
			if not mod.valChanged.has_connections():
				mod.valChanged.connect(mods_updated)
## Final calculated value of stat 
var final_val : float=default_value:
	set(value):
		final_val=value
		val_changed.emit()

func mods_updated():
	var mult = 1
	var add = 0
	for mod in modifiers:
		pass
	final_val = (default_value+add)*mult
