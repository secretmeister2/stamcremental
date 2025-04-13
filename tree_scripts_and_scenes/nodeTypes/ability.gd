extends TreeNodeType
class_name BasicAbility
## The modifiers that compose this ability
@export var modifiers:Array[Modifier]
@export var modcost:Array[float]
@export var base_cost:int
func bought():
	for mod in modifiers:
		mod.affected_stat.modifiers.append(mod)

func gen_ability(basepoints:int, currentTiles:Array[Tile], currentDecos:Array[Deco]):
	var points = basepoints
	points -= base_cost
	modifiers.shuffle()
	var array:Array[int]
	for mod in modifiers:
		array.append(0)
	for i in range(0,points):
		array.shuffle()
		array[0]+=1
	for mod in modifiers:
		mod.randomize(array[modifiers.find(mod)], currentTiles,currentDecos)
