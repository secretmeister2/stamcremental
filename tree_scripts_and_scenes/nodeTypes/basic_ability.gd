extends TreeNodeType
class_name BasicAbility
signal valChanged()
## The modifiers that compose this ability
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "24/17:Modifier") var modifiers:Array
@export var modcost:Array[float]
@export var base_point_cost:int

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


##The name of the stat that this ability affects
@export var affected_stat: String
## What type this stat is.
##\n[code]"Multiplier"[/code] indicates that this ability multiplies a given [Stat]
##\n[code]"Additive"[/code] indicates that this ability adds to a given [Stat]
##\n[code]"Replace"[/code] indicates that this ability replaces a given [Stat]
@export_enum("Multiplier", "Additive", "Replace") var modify_type:String:
	set(new):
		modify_type=new
## The base value to be used for the ability
@export
var useValue : float:
	set(newvalue):
		useValue=newvalue
		valChanged.emit()
var truth : bool = false:
	set(value):
		truth=value
		valChanged.emit()
## Whether the ability is good if it is lower or higher
@export var isGood :bool=true:
	set(value):
		isGood=value
