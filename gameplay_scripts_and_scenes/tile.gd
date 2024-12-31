extends Resource
class_name Tile
## The name of this tile
@export var name:String
## The color of this tile
@export var col:Color
## The size of this tile, 1 for full tile
@export var size:int
## A list of the required parameters for the tile to be placed
@export var placement_conditions:Array[TilePlaceCon]
