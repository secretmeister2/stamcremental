extends TreeNodeType
class_name ModifierAbility
## The modifiers that compose this ability
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "24/17:Modifier") var modifiers:Array

func bought():
	for mod in modifiers:
		var temp = Global.data.get_stat_or_null(mod.affected_stat).modifiers
		temp.append(mod)
		Global.data.get_stat_or_null(mod.affected_stat).modifiers=temp

func gen_ability(basepoints:int, currentTiles:Array[Tile], currentDecos:Array[Deco]):
	var points = basepoints
	points -= point_cost
	modifiers.shuffle()
	var array:Array[int]
	for mod in modifiers:
		array.append(0)
	for i in range(0,points):
		array.shuffle()
		array[0]+=1
	for mod in modifiers:
		mod.mod_randomize(array[modifiers.find(mod)], currentTiles,currentDecos)

func parse()->String:
	print("BaseAbilityParse")
	return ""
