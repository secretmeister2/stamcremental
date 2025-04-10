extends Resource

class_name ItemStack

@export var type:ItemType
@export var count:int

func _init(type:ItemType,count:int=1):
	self.type = type
	self.count = count

func _render(parent: Control):
	self.type._render(self,parent)
