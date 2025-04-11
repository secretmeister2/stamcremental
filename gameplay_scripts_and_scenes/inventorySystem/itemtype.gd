extends Resource
## Why you no worky
class_name ItemType

@export var name : String
@export var weight:float = 0
@export var tags : Array[String]

func _render(stack: ItemStack,parent: Control):
	pass

## creates an ItemStack with this type and given countw
func create_stack(count:int=1)->ItemStack:
	return ItemStack.new(self,count)
