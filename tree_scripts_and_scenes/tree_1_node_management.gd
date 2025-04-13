extends Node2D
var hovered = false
var treeman
var node : BaseTreeNode:
	set(value):
		if is_instance_valid(value):
			node=value
			node.alpha_changed.connect(alpha_changed)

@onready var popup = $PopupPanel

func _ready() -> void:
	popup.popup()
	popup.hide()

func alpha_changed():
	$ColorShade.color=Color(0,0,0,node.alpha)

func _on_mouse_entered() -> void:
	hovered=true
	popup.show()

func _on_mouse_exited() -> void:
	hovered=false
	popup.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("click"):
		node.trybuy()
