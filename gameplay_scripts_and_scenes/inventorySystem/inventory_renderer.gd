extends Control

@export var slot_bg_color: Color

func _init() -> void:
	Inventory.size = 10
	Inventory.set_slot(0,load("res://gameplay_scripts_and_scenes/inventorySystem/items/rock.tres").create_stack(2))
	Inventory.set_slot(1,load("res://gameplay_scripts_and_scenes/inventorySystem/items/stick.tres").create_stack(3))
	Inventory.set_slot(5,load("res://gameplay_scripts_and_scenes/inventorySystem/items/rock.tres").create_stack(5))

func _process(delta: float) -> void:
	for i in $layout.get_children():
		i.queue_free()
	for i in range(0,Inventory.size):
		var rect = ColorRect.new()
		rect.color = slot_bg_color
		rect.name = "slot_"+str(i)
		rect.anchor_left = 0.5
		rect.anchor_right = 0.5
		rect.anchor_top = 0.5
		rect.anchor_bottom = 0.5
		rect.custom_minimum_size = $layout.custom_minimum_size
		if Inventory.peek_item(i):
			var renderer = Control.new();
			renderer.position = rect.custom_minimum_size/2
			renderer.set_script(load("res://gameplay_scripts_and_scenes/inventorySystem/item_renderer.gd"))
			renderer.stack = Inventory.peek_item(i)
			rect.add_child(renderer)
			if renderer.stack.count > 1:
				var text = Label.new()
				text.text = str(renderer.stack.count)
				text.position = Vector2(0,rect.custom_minimum_size.y-text.get_line_height())
				rect.add_child(text)
		$layout.add_child(rect)
	
	
	
