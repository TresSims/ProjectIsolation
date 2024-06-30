extends CharacterBody3D

const SEARCHING = 0
const FOUND = 1
const BUILD_UP = 2
const BOOM = 3
const DAMAGE = 4

var state = SEARCHING

const SPEED = 7
var player
var sighted = false
var can_hit = true
@onready var ray = $RayCast3D
@onready var model = $Darksol

@export var BuildUp:AudioStream
@export var Boom:AudioStream
@export var Oof:AudioStream

@onready var audio_player = $AudioStreamPlayer3D
@onready var fx = $GPUParticles3D
var material

func _ready():
	find_player()
	material = model.get_active_material(0).duplicate()
	model.set_surface_override_material(0, material)

func _physics_process(delta):
	
	if not player:
		find_player()
	else:
		match state:
			SEARCHING:
				look_at(player.global_position)
				if ray.is_colliding():
					var other = ray.get_collider()
					print_debug(other)
					if other.name == "Player":
						state = FOUND
			FOUND:
				velocity = (player.global_position - global_position).normalized() * SPEED
				look_at(player.position)
				move_and_slide()
				if (player.global_position - global_position).length() < 2 and can_hit:
					setup_build_up()
			BUILD_UP:
				rotation.y += deg_to_rad(30)
				model.position.y += .25 * delta
				material.albedo_color += Color(0.1, 0, 0)
				if audio_player.get_playback_position() >= 3.5:
					setup_boom()
			BOOM:
				if (self.global_position - player.global_position).length() < 7:
					if can_hit:
						hit_player(player)
						can_hit = false
				if audio_player.get_playback_position() >= 1:
					queue_free()
			DAMAGE:
				if audio_player.get_playback_position() >= 0.5:
					queue_free()

func setup_build_up():
	state = BUILD_UP
	audio_player.stream = BuildUp
	audio_player.play(0)

func setup_boom():
	state = BOOM
	audio_player.stream = Boom
	audio_player.play(0)
	model.visible = false
	fx.emitting = true

func find_player():
	player = get_node("../Player")

func take_damage():
	state = DAMAGE
	audio_player.stream = Oof
	audio_player.play(.2)

func hit_player(area):
	print_debug("player hit!")
	if area.has_method("hit_player"):
		area.hit_player()
