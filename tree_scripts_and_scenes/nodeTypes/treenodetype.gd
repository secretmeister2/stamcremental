extends Resource
## Base type for all abilities of nodes
class_name TreeNodeType
## The base cost of this node type
@export var cost : int
## Override in derived classes
func bought():
	pass
