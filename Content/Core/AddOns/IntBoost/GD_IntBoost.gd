extends AddOn

@onready var lifetime = $Timer
@onready var fx = $GPUParticles3D

func expire():
	queue_free()

func _use():
	fx.emitting = true
	Starmaps.current_starmap["character"]["int"] += 1
