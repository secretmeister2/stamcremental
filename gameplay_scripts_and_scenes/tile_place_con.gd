extends Resource
class_name TilePlaceCon
## The tiles or decos that this condition requires
@export var req_tiles:Array[String]
## The number for the con to return true
@export var req_num:int
## Whether the result is inverted (only true if less than req num found)
@export var inverted:bool=false
