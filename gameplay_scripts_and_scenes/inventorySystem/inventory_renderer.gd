extends Control

const renderer = preload("res://gameplay_scripts_and_scenes/inventorySystem/item_renderer.gd")
@onready var layout = $layout
func _draw() -> void:
	for i in layout.get_children():
		i.queue_free()
	for i in range(0,Inventory.size):
		var button = Button.new()
		button.name = "slot_"+str(i)
		button.mouse_filter = Control.MOUSE_FILTER_STOP
		button.custom_minimum_size = layout.custom_minimum_size
		button.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
		if i == Global.data.selected_slot:
			var style = StyleBoxFlat.new()
			style.bg_color = Color.DARK_GRAY
			button.add_theme_stylebox_override("normal",style)
		button.set_script(renderer)
		button.slot = i
		if Inventory.peek_item(i) && Inventory.peek_item(i).count > 1:
			var text = Label.new()
			text.text = str(Inventory.peek_item(i).count)
			text.position = Vector2(0,button.custom_minimum_size.y-text.get_line_height())
			button.add_child(text)
		layout.add_child(button)

func _ready() -> void:
	Inventory.updated.connect(queue_redraw.bind())
	queue_redraw()
