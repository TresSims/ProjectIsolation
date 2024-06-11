extends Button

@export var NextScene : PackedScene

func _load_scene():
	Starmaps.navigate_generic(NextScene)
