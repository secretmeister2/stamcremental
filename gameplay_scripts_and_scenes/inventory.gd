extends Resource

class_name Inventory
signal updated()

@export var size:int:
	set(value):
		size = value
		updated.emit()
@export var items:Dictionary[int,ItemStack]:
	set(value):
		items = value
		updated.emit()


## size:int is the size of the inventory being created
func _init(size:int):
	self.size = size
	self.items = {}

## places an item in the first avaliable slot
func add_item(stack:ItemStack) -> bool:
	for i in range(0,size-1):
		if !items.has(i):
			items.set(i,stack)
			return true
	return false

## sets a slot to the given ItemStack
func set_slot(slot:int,stack:ItemStack) -> bool:
	if slot == null || stack == null:
		return false
	if slot < size:
		items.set(slot,stack)
		return true
	else:
		return false

## transfers an item from another into this inventory
func transfer_item(fromslot:int, toslot:int , frominv:Inventory) -> bool:
	return set_slot(toslot,frominv.pop_item(fromslot))

## transfers an item to another inventory
func transfer_item_to(fromslot:int, toslot:int , frominv:Inventory) -> bool:
	return frominv.set_slot(toslot,pop_item(fromslot))

## transfers an item from another into this inventory but uses add_item rather than set_item
func transfer_item_fast(fromslot:int, frominv:Inventory) -> bool:
	return add_item(frominv.pop_item(fromslot))

## transfers an item to another inventory but uses add_item rather than set_item
func transfer_item_fast_to(fromslot:int, frominv:Inventory) -> bool:
	return frominv.add_item(pop_item(fromslot))


## removes the stack at the given slot from the inventory and returns it
func pop_item(slot:int) -> ItemStack:
	var stack: ItemStack = items.get(slot)
	items.erase(slot)
	return stack

## just returns the stack at the slot
func peek_item(slot:int) -> ItemStack:
	return items.get(slot)
