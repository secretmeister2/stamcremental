@tool
extends SyntaxElement
class_name SyntaxRandNum
## The minimum value (inclusive)
@export var min_val:float=0:
	set(value):
		min_val=step_size*round(value/step_size)
		if min_val > max_val: min_val = max_val-step_size
## The max value (inclusive)
@export var max_val:float=1:
	set(value):
		max_val=step_size*round(value/step_size)
		if min_val > max_val: max_val = min_val+step_size
## The step size for randomization
@export_range(0.01,100) var step_size:float=0.1
##The type of distribution to use. Low favors low values, and high favors higher values
@export_enum("low", "high") var dist_type:String="low"
## The scalar for distribution (range 0-1)
@export var dist_scalar:=0.8
@export_tool_button("Generate Value") var genval = gennval
func gennval():
	var nums = []
	for i in range(0,20):
		nums.append(gen_val())
	print(nums)

func gen_val()->float:
	var randnum = 0
	var num_array = range(int(min_val/step_size),int(max_val/step_size)+1).map(func stepfix(int)->float: return int*step_size)
	var dist_array = [10]
	var rng=RandomNumberGenerator.new()
	for i in range(0,num_array.size()-1):
		if dist_type == "high":
			dist_array.push_front(dist_array[0]*dist_scalar)
		else:
			dist_array.append(dist_array[i]*dist_scalar)
	randnum=num_array[rng.rand_weighted(dist_array)]
	return randnum
