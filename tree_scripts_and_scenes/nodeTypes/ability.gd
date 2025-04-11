extends TreeNodeType
class_name BasicAbility
## The modifiers that compose this ability
@export var modifiers:Array[Modifier]

func bought():
	for mod in modifiers:
		mod.affected_stat.modifiers.append(mod)
