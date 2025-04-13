@tool
extends Resource

class_name ShapeDef

@export var shape: PackedVector2Array
@export var color: Color
@export var offset: Vector2
@export var rotation: float
@export var scale: Vector2

func _init():
	self.color = Color(1,1,1)
	self.scale = Vector2.ONE
	self.shape = []
	self.offset = Vector2.ZERO
	self.rotation = 0
