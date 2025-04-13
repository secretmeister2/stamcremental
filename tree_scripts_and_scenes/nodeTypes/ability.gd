extends TreeNodeType
class_name BasicAbility
## The modifiers that compose this ability
@export var modifiers:Array[Modifier]
@export var generators:Array[RandomDecider]
@export var base_cost:int
func bought():
	for mod in modifiers:
		mod.affected_stat.modifiers.append(mod)

func gen_ability(points:int):
	print()
