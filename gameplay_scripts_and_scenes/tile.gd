extends TilesAndDecos
## A resource describing a tile to be placed in the grid for gameplay. [br][pararm col] describes the color the tile will appear as. [br][param blob_size] descirbes how large the groups of the tile will be. This scales based on grid size.[br][param max_blobs] describes the maximum number of seperate blocs to generate. [br][param move_cost] defines the stamina cost to move to this tile.
class_name Tile

## The target size of a blob
@export var blob_size:float
## Max blobs
@export var max_blobs:int
