extends AddOn

var player
var new_speed
var base_speed

@onready var lifetime = $Timer
@onready var fx = $GPUParticles3D
@onready var sound_player = $AudioStreamPlayer3D

func _use():
	player = get_parent()
	base_speed = player.SPEED
	new_speed = base_speed + 10
	lifetime.wait_time = animation_time
	lifetime.start(animation_time)
	fx.emitting = true
	sound_player.stream = sfx
	sound_player.play(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ratio = lifetime.time_left / lifetime.wait_time
	player.SPEED = base_speed + (new_speed - base_speed) * ratio

func expire():
	player.SPEED = base_speed
	queue_free()
