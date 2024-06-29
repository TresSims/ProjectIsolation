extends Node3D
class_name StoreGen

var stall_size = 10
@export var stall:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var stores = Starmaps.rng.randi_range(2, 4)
	
	for store in range(0, stores):
		var n_stall = stall.instantiate()
		n_stall.position.x = stall_size * store
		add_child(n_stall)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
