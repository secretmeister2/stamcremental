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

@onready var slotCountStat=Global.data.get_stat_or_null("SlotCount")

func _ready() -> void:
	size=slotCountStat.final_val
	slotCountStat.val_changed.connect(slot_count_updated)

func slot_count_updated():
	size=slotCountStat.final_val

## places an item in the first avaliable slot
func add_item(stack:ItemStack) -> bool:
	var added = false
	var maxweight = Global.data.get_stat_or_null("WeightPerSlot").final_val
	if not stack: return false
	if stack.type.weight >= maxweight: return false
	var currentTypes = items.values().map(func type(value): return value.type)
	if stack.type not in currentTypes && items.size()==size: return false
	print(stack.count)
	for i in range(0,stack.count):
		var test = true
		if stack.type in currentTypes:
			for itstack in items.values():
				if itstack.type == stack.type && (itstack.count+1)*stack.type.weight<=maxweight:
					itstack.add(1)
					updated.emit()
					test = false
					break
		if items.size()<size && test:
			for j in range(0,size):
				if j not in items.keys():
					var tempstack = stack.duplicate()
					tempstack.count=1
					set_slot(j,tempstack)
					break
	return true

func clear():
	updated.emit()
	items={}

## sets a slot to the given ItemStack
func set_slot(slot:int,stack:ItemStack) -> bool:
	if slot == null || stack == null:
		return false
	if stack.count*stack.type.weight > Global.data.get_stat_or_null("WeightPerSlot").final_val:
		return false
	if slot < size:
		items.set(slot,stack)
		updated.emit()
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
		var tempArr = items.values()
		tempArr.reverse()
		for v in tempArr:
			if v.type == type:
				var itmcount = v.count
				count -= v.sub(mini(v.count,count))
				if v.count == 0:
					items.erase(items.find_key(v))
				else:
					items.set(items.find_key(v),v)
				count -= itmcount
		updated.emit()
		return true
	return false

## removes the stack at the given slot from the inventory and returns it
func pop_item(slot:int) -> ItemStack:
	var stack: ItemStack = items.get(slot)
	items.erase(slot)
	updated.emit()
	return stack

## just returns the stack at the slot
func peek_item(slot:int) -> ItemStack:
	return items.get(slot)
