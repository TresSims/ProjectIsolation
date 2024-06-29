extends Node3D
class_name AddOn

@export var animation:Curve3D = null
@export var animation_time:float = 1
@export var cooldown_time:float = 1.5
@export var addon_name = "ChangeMe"
@export var cost = 5
@export var texture:Texture2D


# To Be overriden by children
func _use():
	pass
