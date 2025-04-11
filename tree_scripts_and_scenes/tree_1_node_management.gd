extends Node2D
var hovered = false
var node : BaseTreeNode
func _on_area_2d_mouse_entered() -> void:
	hovered=true


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("ui_accept"):
		node.trybuy()


func _on_area_2d_mouse_exited() -> void:
	hovered=false
