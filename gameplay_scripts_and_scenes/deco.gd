extends TilesAndDecos
## A class that describes objects to be placed on [Tile]s to be interacted with.
class_name Deco

## The size of this deco, [code]1[/code] to cover full [Tile]
@export_range(0,1,0.1) var size:float
## The chance of this deco being placed each valid [Tile]
@export_range(0,1,0.1) var place_chance:float
## The [Tile]s that this deco can be placed on.
@export var tiles : Array[String]
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
