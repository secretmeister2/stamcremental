extends Node2D
var hovered = false
var node : BaseTreeNode
@onready var popup = $PopupPanel

func _on_mouse_entered() -> void:
	hovered=true
	popup.popup()

func _on_mouse_exited() -> void:
	hovered=false

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("click"):
		node.trybuy()
