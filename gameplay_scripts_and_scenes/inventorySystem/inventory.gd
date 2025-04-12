extends Node

signal updated()

@export var size:int = 1:
	set(value):
		size = value
		updated.emit()
@export var items:Dictionary[int,ItemStack] = {}:
	set(value):
		items = value
		updated.emit()

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

## checks if the player has a certain number of items of a type in their inventory
func has_items(type:ItemType,count:int=1) -> bool:
	var accum:int = 0
	for v in items.values():
		if v.type == type:
			accum += v.count
	return accum >= count

## checks if the player has a certain number of items of a type in their inventory and if they do remove them
func remove_items(type:ItemType,count:int=1) -> bool:
	if has_items(type,count):
		for v in items.values():
			if v.type == type:
				var itmcount = v.count
				count -= v.sub(mini(v.count,count))
				if v.count == 0:
					items.erase(items.find_key(v))
				else:
					items.set(items.find_key(v),v)
				count -= itmcount
		return true
	return false

## removes the stack at the given slot from the inventory and returns it
func pop_item(slot:int) -> ItemStack:
	var stack: ItemStack = items.get(slot)
	items.erase(slot)
	return stack

## just returns the stack at the slot
func peek_item(slot:int) -> ItemStack:
	return items.get(slot)
