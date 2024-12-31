extends Node2D
class_name BaseTreeNode
enum nodetype{
	ability,
	passive,
	stat
}
var neighbours:Array[BaseTreeNode]
@export_enum("locked", "available", "bought") var status:String:
	set(value):
		status = value
		match value:
			"locked":
				if $ColorShade:
					$ColorShade.color=Color(0,0,0,60)
			"available":
				if $ColorShade:
					$ColorShade.color=Color(0,0,0,0)
			"bought":
				if $ColorShade:
					$ColorShade.color=Color(0,0,0,85)

@export var typecosts: Dictionary[nodetype,int]
@export var rarity:Global.rarity
#@export var preftags: Array[Global.basetags]
var points=0
@export var type:nodetype
@export var raritycolors: Array[Color]
var distances={"origin" = 0, "epic"=0, "legendary"=0}
var rarityarray:Array[int]=[0,30,15,5,0,0]
var is_origin:bool=false
var conn_orig=false
var connections:Array[Connector]
var connected_to:Array[BaseTreeNode]

func roll(disorig:int):
	$RarityColor.color=raritycolors[rarity]
	match rarity:
		1: points = 20+distances["origin"]
		2: points = 30+distances["origin"]
		3: points = 45+distances["origin"]
		4: points = 60+distances["origin"]
		5: points = 80+distances["origin"]
	match ceil(randf_range(0,5)*rarity):
		1-6: type=nodetype.stat
		7-10: type=nodetype.passive
		_: type=nodetype.ability
	points -= typecosts[type]

func _on_area_2d_mouse_entered() -> void:
	print("huhh")

func connect_check():
	if is_origin: conn_orig = true
	if conn_orig: 
		for node in connected_to:
			if not node.conn_orig:
				node.conn_orig=true
				node.connect_check()
