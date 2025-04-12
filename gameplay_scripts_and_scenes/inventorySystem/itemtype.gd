@tool
extends Resource

class_name ItemType

@export var name : String
@export var weight:float = 0
@export var tags : Array[String]
@export var renders : Dictionary[int,RenderDef]

func _init():
	pass

func _render(stack: ItemStack,parent: CanvasItem):
	for i in renders:
		if i <= stack.count:
			renders.get(i).render(parent)

## creates an ItemStack with this type and given countw
func create_stack(count:int=1)->ItemStack:
	return ItemStack.new(self,count)
