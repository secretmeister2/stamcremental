extends Node2D
signal hovered(node:Node)
signal unhovered(node:Node)
var currhovered = false:
	set(value):
		currhovered=value
		if currhovered: hovered.emit(self)
		else: unhovered.emit(self)
var treeman
var node : BaseTreeNode:
	set(value):
		if is_instance_valid(value):
			node=value
			node.alpha_changed.connect(alpha_changed)

func alpha_changed():
	$ColorShade.color=Color(0,0,0,node.alpha)

func _on_mouse_entered() -> void:
	currhovered=true

func _on_mouse_exited() -> void:
	currhovered=false

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("click"):
		node.trybuy()
