extends Resource
## A branch on the skill tree
class_name Branch
##  The name of the branch
@export var name : String
## The ability types that exist in this branch
@export var abilityTypes : Array[TreeNodeType]
