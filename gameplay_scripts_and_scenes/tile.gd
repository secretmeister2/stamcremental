extends Resource
class_name Tile
## The name of this tile
@export var name:String
## The color of this tile
@export var col:Color
## The size of this tile, 1 for full tile
@export var size:int
## The size of a blob
@export var blob_size:PackedInt32Array
## Max blobs
