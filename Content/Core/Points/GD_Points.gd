extends Area3D

@export var value = 1

# Called when the node enters the scene tree for the first time.
func _on_hit(body):
	if body.has_method("get_points"):
		body.get_points(value)
		queue_free()
