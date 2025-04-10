extends Control

@onready var gameplay = $TabContainer/Gameplay
@onready var skilltree = $TabContainer/Control/SkillTree/SubViewport/TreeManager

var is_run = false

func _on_tab_container_tab_changed(tab: int) -> void:
	if $TabContainer.get_tab_title(tab) == "Gameplay":
		gameplay.playing = is_run
	else: 
		if gameplay.playing: is_run=true
		else: is_run = false
		gameplay.playing=false

func _on_button_pressed() -> void:
	skilltree.camera.position = Vector2(0,0)
