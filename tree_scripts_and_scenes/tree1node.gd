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
var disorig:int
var rarityarray:Array[int]=[0,30,15,5,0,0]
var is_origin:bool=false
var conn_orig=false
var connections:Array[Connector]
var connected_from:Array[BaseTreeNode]
var connected_to:Array[BaseTreeNode]
var branches:Array
var ability : TreeNodeType

func roll(unlockedTiles:Array[Tile],unlockedDecos:Array[Deco],notTile:bool=false):
	points=10+round(disorig/70)
	var names = Global.data.branches.map(func thingy(value): return value.name)
	while not ability or ability.point_cost > points:
		ability = Global.data.branches[names.find(branches[0])].abilityTypes.pick_random()
		#if not (notTile and (ability is TileOrDecoUnlock)): ability=null
	var newthing
	if ability is BasicAbility: 
		var temp_modifiers= ability.modifiers
		temp_modifiers=temp_modifiers.map(func uniquify(value): return value.duplicate())
		ability=ability.duplicate(true)
		ability.modifiers=temp_modifiers
		ability.gen_ability(points,unlockedTiles,unlockedDecos)
	elif ability is TileOrDecoUnlock: 
		ability=ability.duplicate(true)
		ability.gen_ability(points,unlockedTiles,unlockedDecos)
		if ability.new_tile_or_deco==null: 
			print("Fail")
			self.roll(unlockedTiles,unlockedDecos,true)
			return
		newthing=ability.new_tile_or_deco
	var nowUnlockedTiles=unlockedTiles.duplicate()
	var nowUnlockedDecos=unlockedDecos.duplicate()
	if newthing and newthing is Tile:
		nowUnlockedTiles.append(newthing)
	if newthing and newthing is Deco:
		nowUnlockedDecos.append(newthing)
	for node in connected_to:
		if not node.ability:
			node.roll(nowUnlockedTiles,nowUnlockedDecos)
	
	
var checked = false
func connect_check():
	checked=true
	for node in connected_to:
		for branch in branches:
			if branch not in node.branches:
				node.branches.append(branch)
		if not node.checked: node.connect_check()
	
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
	ability.bought()
	for node in connected_to: 
		var test = true
		for other_con in node.connected_from:
			if other_con.status!="bought":
				test=false
		if test: node.status="available"
	
