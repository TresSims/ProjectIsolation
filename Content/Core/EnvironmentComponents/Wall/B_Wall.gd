@tool
extends ChangeableNode

var hits = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hits == 0:
		queue_free()

func take_damage():
	hits -= (CharacterInfo.current_char["str"])
