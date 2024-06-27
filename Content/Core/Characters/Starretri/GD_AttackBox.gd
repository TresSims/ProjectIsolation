extends Area3D

func expire():
	queue_free()

func on_hit(area:Node3D):
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage()
