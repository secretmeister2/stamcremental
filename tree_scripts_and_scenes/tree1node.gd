extends Resource
class_name BaseTreeNode

var neighbours:Array[BaseTreeNode]
signal alpha_changed()

var alpha = 0:
	set(value):
		alpha=value
		alpha_changed.emit()
var color = Color(545454)
@export_enum("locked", "available", "bought") var status:String="locked":
	set(value):
		status = value
		match status:
			"locked":
				alpha=0.4
			"available":
				alpha=0
			"bought":
				alpha=0.2

@export var rarity:Global.rarity=-1
#@export var preftags: Array[Global.basetags]
var points=0
##@export var type:nodetype
var distances={"origin" = 0, "epic"=0, "legendary"=0}
var rarityarray:Array[int]=[0,30,15,5,0,0]
var is_origin:bool=false
var conn_orig=false
var connections:Array[Connector]
var connected_from:Array[BaseTreeNode]
var connected_to:Array[BaseTreeNode]
var branches:Array
var ability : TreeNodeType

func roll():
	color=Global.raritycolors[rarity]
	match rarity:
		1: points = 20+distances["origin"]
		2: points = 30+distances["origin"]
		3: points = 45+distances["origin"]
		4: points = 60+distances["origin"]
		5: points = 80+distances["origin"]
##	match ceil(randf_range(0,5)*rarity):

func connect_check():
	for node in connected_to:
		for branch in branches:
			if branch not in node.branches:
				node.branches.append(branch)
		node.connect_check()
	
func _init(newrarity=-1, branch:String=""):
	if newrarity != -1: self.rarity=newrarity
	if branch != "": self.branches.append(branch)

func trybuy():
	if status!="available": return
	var test = true
	#for item in ability.cost.keys():
	#	if not Inventory.has_items(item, ability.cost[item]):
	#		test = false
	if test == true:
		buy()

func buy():
	status = "bought"
	#for item in  ability.cost.keys():
	#	Inventory.remove_items(item, ability.cost[item])
	#ability.bought()
	for node in connected_to: 
		var test = true
		for other_con in node.connected_from:
			if other_con.status!="bought":
				test=false
		if test: node.status="available"
	
