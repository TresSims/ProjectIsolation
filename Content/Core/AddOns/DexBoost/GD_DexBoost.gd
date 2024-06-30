extends AddOn

@onready var lifetime = $Timer
@onready var fx = $GPUParticles3D
@onready var audio_player = $AudioStreamPlayer3D


func _use():
	fx.emitting = true
	Starmaps.current_starmap["character"]["dex"] += 14
	audio_player.stream = sfx
	audio_player.play(0)

func expire():
	queue_free()
