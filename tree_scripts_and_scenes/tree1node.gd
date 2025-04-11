extends Resource
class_name BaseTreeNode

var neighbours:Array[BaseTreeNode]

var alpha = 0
var color = Color(545454)
@export_enum("locked", "available", "bought") var status:String:
	set(value):
		status = value
		match value:
			"locked":
				if alpha:
					alpha=60
			"available":
				if alpha:
					alpha=0
			"bought":
				if alpha:
					alpha=85

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
var branches:Array[String]
var ability = TreeNodeType

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
	if is_origin: conn_orig = true
	if conn_orig: 
		for node in connected_to:
			if not node.conn_orig:
				var test = true
				for fromnode in node.connected_from:
					if not fromnode.conn_orig:
						test = false
				if test:
					node.conn_orig=true
					node.connect_check()

func _init(newrarity=-1, branch:String=""):
	if newrarity != -1: self.rarity=newrarity
	if branch != "": self.branches.append(branch)

func trybuy():
	pass
