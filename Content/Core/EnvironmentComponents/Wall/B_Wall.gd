@tool
extends ChangeableNode

var hits = 5
var base_color
@onready var damage_timer = $DamageTimer
@export var audio_stream:AudioStream
var damage_time = 0.2


func _ready():
	super._ready()
	
	base_color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if hits <= 0:
		var sound_player = AudioStreamPlayer3D.new()
		sound_player.stream = audio_stream
		sound_player.position = self.position
		get_parent().add_child(sound_player)
		sound_player.play(.2)
		queue_free()

func take_damage():
	hits -= (Starmaps.current_starmap["character"]["str"])
	color = base_color + Color(0.3, 0, 0)
	damage_timer.start(damage_time)
	print_debug(hits)

func reset_color():
	color = base_color
