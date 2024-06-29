extends Node3D

@export var PowerUps:Array[PackedScene]

@onready var item_sprite = $ItemSprite
@onready var fx = $GPUParticles3D

var item
var item_scene
var cost
var sold_out = false

# Called when the node enters the scene tree for the first time.
func _ready():
	item_scene = PowerUps[Starmaps.rng.randi_range(0, len(PowerUps) - 1)]
	item = item_scene.instantiate()
	item_sprite.texture = item.texture
	cost = Starmaps.rng.randi_range(5, 10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_enter(body):
	if body.has_method("set_stall"):
		body.set_stall(self)

func on_leave(body):
	if body.has_method("set_stall"):
		body.set_stall(null)

func buy_item():
	sold_out = true
	item_sprite.queue_free()
	fx.emitting = true
	item.queue_free()
