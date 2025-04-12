@tool
extends Node2D

@export var stack:ItemStack

func _ready():
	if Engine.is_editor_hint():
		set_process(true)

func _draw() -> void:
	#draw_circle(Vector2.ZERO,5,Color.AQUA,true)
	if stack:
		stack._render(self)

func _process(delta: float) -> void:
	queue_redraw()
