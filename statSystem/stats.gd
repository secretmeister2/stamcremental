@tool
extends Control
## The script that handles the rendering of [Stat]s
class_name Stats

var data: SaveData:
	set(value):
		data = value
var focused = false
