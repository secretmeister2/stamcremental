extends Node2D
class_name Connector
@export var connectedto:Array[BaseTreeNode]

@export var length:int

func _process(delta: float) -> void:
	$Area2D/CollisionShape2D.shape.size=Vector2($ColorRect.custom_minimum_size)*1/2
	if not $Area2D.get_overlapping_areas().is_empty():
		for node in connectedto:
			node.connections.erase(self)
			var new=connectedto.duplicate()
			new.erase(node)
			node.connected_to.erase(new[0])
		self.queue_free()
