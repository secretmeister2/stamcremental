extends Resource

class_name PlayerData
signal update()

@export_group("Inventory")
@export var Inventory:Array[ItemStack]
