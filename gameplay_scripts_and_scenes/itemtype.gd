extends Resource

class_name ItemType

const weight:float = 0

func _render(stack: ItemStack,parent: Control):
	pass

## creates an ItemStack with this type and given countw
func create_stack(count:int=1)->ItemStack:
	return ItemStack.new(self,count)
