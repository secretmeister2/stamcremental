extends Resource
## Base class for tile and decos, DO NOT USE ALONE
class_name TilesAndDecos
## The name of this object
@export var name:String
## The [Color] of this object
@export var col:Color
## The base movement cost of moving to this location
@export_range(0,10,0.1) var move_cost : float = 0.1
