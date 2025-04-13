extends Control

@onready var gameplay = $TabContainer/Gameplay
@onready var skilltree = $TabContainer/TreeManager

func _on_tab_container_tab_changed(tab: int) -> void:
	if is_node_ready():
		refocus()

func refocus():
	if $TabContainer.get_tab_control($TabContainer.get_previous_tab()) == null: return
	if $TabContainer.get_current_tab_control() == null: return
	if is_instance_of($TabContainer.get_current_tab_control().get_children()[0], SubViewportContainer):
		skilltree.focused=true
	else: $TabContainer.get_current_tab_control().focused = true
	if is_instance_of($TabContainer.get_tab_control($TabContainer.get_previous_tab()).get_children()[0], SubViewportContainer):
		skilltree.focused=false
	else:
		$TabContainer.get_tab_control($TabContainer.get_previous_tab()).focused = false
