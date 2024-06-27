extends AddOn

@onready var lifetime = $Timer
@onready var fx = $GPUParticles3D

@export var hit_multiplier:int = 10

func _ready():
	lifetime.wait_time = animation_time
	lifetime.start(animation_time)
	fx.emitting = true

func expire():
	queue_free()

func _on_hit(area):
	
	if area.get_parent().has_method("take_damage"):
		for x in range(0, hit_multiplier):
			area.get_parent().take_damage()
