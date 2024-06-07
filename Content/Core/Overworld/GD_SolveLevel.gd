extends Area3D

@onready var Collider = $CollisionTrigger

func _body_entered(body):
	if body.get_name() == "Stary":
		Starmaps.solve()
