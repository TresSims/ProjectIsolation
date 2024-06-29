extends AddOn

@onready var lifetime = $Timer
@onready var fx = $GPUParticles3D

func _ready():
	fx.emitting = true
	Starmaps.current_starmap["character"]["str"] += 1

func expire():
	queue_free()
