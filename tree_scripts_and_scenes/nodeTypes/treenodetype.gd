extends Resource
## Base type for all abilities of nodes
class_name TreeNodeType
## The base point cost of this node type for randomization
@export var point_cost : int
## A multiplier of how many items the ability should cost
@export var item_cost_mult : float
## A dictionary of stacks that the ability costs
var item_cost:Dictionary
