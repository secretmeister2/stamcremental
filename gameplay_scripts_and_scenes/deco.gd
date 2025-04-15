extends TilesAndDecos
## A class that describes objects to be placed on [Tile]s to be interacted with.
class_name Deco

## The size of this deco, [code]1[/code] to cover full [Tile]
@export_range(0,1,0.1) var size:float
## The [Tile]s that this deco can be placed on, and the corresponding place chance
@export var tilesChance : Dictionary[String,float]
## Any [TilePlaceCon]s for this deco. All must return true for this deco to be placed.
@export var cons : Array[TilePlaceCon]
## Any other [Deco]s that CAN share a tile.
@export var shared : Array[Deco]
## The stack collected from this tile
@export var stack : ItemStack 
## Collection Cost
@export var cost : float
## Consume deco upon collection
@export var consume : bool
func parse()->String:
	var chancestring:String
	var array = tilesChance.keys()
	var stackstring=""
	array.map(func named(value): return value + "with a chance of "+str(tilesChance[value]))
	chancestring=",".join(array)
	var consumestring = " not"
	if consume: 
		consumestring=""
	var sharestring="no other decorations."
	if shared:
		sharestring = ",".join(shared.map(func named(value): return value.name))
	if stack:
		stackstring="This decoration gives "+str(stack.count)+" "+stack.type.name+". It is"+consumestring+" consumed. This costs "+str(cost) +" stamina\n"
	print("decoration "+name+"\nThis decoration can be found in "+chancestring+".\n"+stackstring+"It can share its location with "+sharestring)
	return "decoration "+name+"\nThis decoration can be found in "+chancestring+".\n"+stackstring+"It can share its location with "+sharestring
