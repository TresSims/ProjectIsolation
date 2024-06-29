extends AddOn

@onready var lifetime = $Timer
@onready var fx = $GPUParticles3D

func _use():
	fx.emitting = true
	Starmaps.current_starmap["character"]["dex"] += 1

func expire():
	queue_free()
