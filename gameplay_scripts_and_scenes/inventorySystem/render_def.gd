@tool
extends Resource

class_name RenderDef

@export var shapes: Array[ShapeDef]

func _init():
	self.shapes = []

func render(parent: CanvasItem):
	for shape in self.shapes:
		parent.draw_set_transform(shape.offset,shape.rotation,shape.scale)
		parent.draw_colored_polygon(shape.shape,shape.color)
		parent.draw_set_transform(Vector2.ZERO)
