extends AddOn

@onready var lifetime = $Timer
@onready var fx = $GPUParticles3D
@onready var audio_player = $AudioStreamPlayer3D

func expire():
	queue_free()

func _use():
	fx.emitting = true
	Starmaps.current_starmap["character"]["int"] += 1
	audio_player.stream = sfx
	audio_player.play(0)
