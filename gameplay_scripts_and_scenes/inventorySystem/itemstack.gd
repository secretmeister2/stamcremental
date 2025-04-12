@tool
extends Resource

class_name ItemStack
signal updated()

@export var type:ItemType:
	set(value):
		type = value
		updated.emit()
@export var count:int:
	set(value):
		count = value
		updated.emit()

func _init(type:ItemType=ItemType.new(),count:int=1):
	self.type = type
	self.count = count

func _render(parent: CanvasItem):
	if self.type:
		self.type._render(self,parent)

## add n to the stack size
func add(n:int=1):
	self.count += n
## subtract n from the stack size
func sub(n:int=1):
	self.count -= n
