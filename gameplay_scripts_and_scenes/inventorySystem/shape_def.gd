@tool
extends Resource

class_name ShapeDef

@export var shape: PackedVector2Array
@export var color: Color
@export var offset: Vector2
@export var rotation: float

func _init():
	self.color = Color(1,1,1)
	self.shape = []
	self.offset = Vector2(0,0)
	self.rotation = 0
