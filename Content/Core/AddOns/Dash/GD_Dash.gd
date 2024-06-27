extends AddOn

var player
var new_speed
var base_speed

@onready var lifetime = $Timer
@onready var fx = $GPUParticles3D

func _ready():
	player = get_parent()
	base_speed = player.SPEED
	new_speed = base_speed + 10
	lifetime.wait_time = animation_time
	lifetime.start(animation_time)
	fx.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ratio = lifetime.time_left / lifetime.wait_time
	player.SPEED = base_speed + (new_speed - base_speed) * ratio

func expire():
	player.SPEED = base_speed
	queue_free()
