@tool
extends ChangeableNode

var hits = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hits <= 0:
		queue_free()

func take_damage():
	hits -= (Starmaps.current_starmap["character"]["str"])
	print_debug(hits)
