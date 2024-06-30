extends CharacterBody3D


const SPEED = 7
var player
var sighted = false
var can_hit = true
@onready var ray = $RayCast3D
@onready var model = $Darksol

func _ready():
	find_player()

func _physics_process(delta):
	if not player:
		find_player()
	else:
		look_at(player.global_position)
		if ray.is_colliding():
			var other = ray.get_collider()
			print_debug(other)
			if other.name == "Player":
				sighted = true
	
	if sighted:
		velocity = (player.global_position - global_position).normalized() * SPEED
		look_at(player.position)
	
	move_and_slide()
	if (player.global_position - global_position).length() < 2 and can_hit:
		hit_player(player)
		can_hit = false

func find_player():
	player = get_node("../Player")

func take_damage():
	queue_free()

func hit_player(area):
	print_debug("player hit!")
	if area.has_method("hit_player"):
		area.hit_player()
		queue_free()
