extends Button
class_name NavButton

@export var NextScene : PackedScene

func _load_scene():
	Starmaps.navigate_generic(NextScene)
