extends Node3D
class_name AddOn

@export var animation:Curve3D = null
@export var animation_time:float = 1
@export var cooldown_time:float = 1.5


# To Be overriden by children
func _use():
	pass
