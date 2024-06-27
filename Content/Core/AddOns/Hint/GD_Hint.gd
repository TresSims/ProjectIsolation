extends AddOn

var hint_scene = "res://Content/Core/AddOns/Hint/B_Hint.tscn"
var goal
@onready var mesh = $MeshInstance3D 

@onready var timer = $Timer

func _ready():
	timer.start(animation_time)
	goal = get_node("../../GoalPortal")
	print_debug(goal)
	

func _process(delta):
	look_at(goal.position)
	var ratio = timer.time_left / animation_time
	mesh.get_active_material(0).albedo_color = Color(0, .8, .8, ratio)

func expire():
	queue_free()
