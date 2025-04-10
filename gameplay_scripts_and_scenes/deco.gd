extends Resource
## A class that describes objects to be placed on [Tile]s to be interacted with.
class_name Deco
## The name of this tile
@export var name:String
## The [Color] of this tile
@export var col:Color
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
## The base stamina cost of moving to this tile. 
@export_range(1,10,0.1) var move_cost : float = 0.1
