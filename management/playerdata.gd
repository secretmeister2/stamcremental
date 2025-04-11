extends Resource

class_name PlayerData
signal updated()

@export var inventory:Inventory:
	set(value):
		inventory = value
		updated.emit()

func _init(size:int=1):
	inventory = Inventory.new(size)
