extends Button

@export var slot:int

func _ready():
	Inventory.updated.connect(queue_redraw.bind())
	queue_redraw()

func _draw() -> void:
	if Inventory.peek_item(slot):
		Inventory.peek_item(slot)._render(self)

func _pressed() -> void:
	Global.data.selected_slot = slot
	Inventory.updated.emit()

func _process(_delta: float) -> void:
	#queue_redraw()
	pass
