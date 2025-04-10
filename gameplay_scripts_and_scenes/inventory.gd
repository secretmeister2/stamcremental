extends Node

class_name Inventory

@export var size:int
@export var items:Dictionary[int,ItemStack]

func _init(size):
	self.size = size
	self.items = {}

func add_item(stack:ItemStack) -> bool:
	for i in range(0,size-1):
		if !items.has(i):
			items.set(i,stack)
			return true
	return false

func set_slot(slot:int,stack:ItemStack) -> bool:
	if slot == null || stack == null:
		return false
	if slot < size:
		items.set(slot,stack)
		return true
	else:
		return false

func transfer_item(fromslot:int, toslot:int , frominv:Inventory) -> bool:
	return set_slot(toslot,frominv.pop_item(fromslot))

func transfer_item_fast(fromslot:int, frominv:Inventory) -> bool:
	return add_item(frominv.pop_item(fromslot))

func pop_item(slot:int) -> ItemStack:
	var stack: ItemStack = items.get(slot)
	items.erase(slot)
	return stack
	
func peek_item(slot:int) -> ItemStack:
	return items.get(slot)
