extends Button

@export var NextScene : PackedScene

func _load_scene():
	print_debug(NextScene)
	Starmaps.navigate_generic(NextScene)
