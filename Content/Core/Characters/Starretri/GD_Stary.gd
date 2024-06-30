extends CharacterBody3D


var SPEED = 10.0

var sensitivity = 0.3
var look_rot = Vector2(0, 0)

var working = false
var cooldown_time = 1.5
@onready var cooldown_timer = $CooldownTimer
var work_curve:Curve3D

@onready var work_timer = $WorkTimer
var char_body
@export var attack_curve:Curve3D
@export var hit_scene:PackedScene
var attack_time = .3
var attack_cooldown = 1.5
var attack_mag = 1

@onready var cooldown_label = $Control/MarginContainer/VBoxContainer/HBoxContainer/Count
@onready var cooldown_bar = $Control/MarginContainer/VBoxContainer/HBoxContainer/Progress
@onready var ability_texture = $Control/MarginContainer/VBoxContainer/HBoxContainer2/AbilityTexture
@onready var ability_name =$Control/MarginContainer/VBoxContainer/HBoxContainer2/AbilityName
@onready var my_item_name = $Control/MarginContainer/VBoxContainer/HBoxContainer3/ItemName
@onready var my_item_texture = $Control/MarginContainer/VBoxContainer/HBoxContainer3/ItemTexture
@export var none_tex:Texture

@onready var point_label = $Points/MarginContainer/HBoxContainer/PointValue
@onready var hp_bar = $Control/MarginContainer/VBoxContainer/HBoxContainer4/HPBar

var stall
@onready var stall_dialogue = $StallDialogue
@onready var item_name = $StallDialogue/MarginContainer/PanelContainer/MarginContainer2/VBoxContainer/ItemName
@onready var item_cost = $StallDialogue/MarginContainer/PanelContainer/MarginContainer2/VBoxContainer/ItemCost


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var the_ability = load(Starmaps.current_starmap["character"]["ability"]).instantiate()
	ability_texture.texture = the_ability.texture
	ability_name.text = "[SHIFT] %s" % the_ability.addon_name
	
	point_label.text = "%d" % Starmaps.current_starmap["character"]["exp"]
	update_item()
	
	hp_bar.value = Starmaps.current_starmap["character"]["hp"]
	
	char_body = load(Starmaps.current_starmap["character"]["body"]).instantiate()
	add_child(char_body)

func update_item():
	print_debug("We're updating our item!")
	if Starmaps.current_starmap["character"].has("item") and Starmaps.current_starmap["character"]["item"] != "":
		var the_item = load(Starmaps.current_starmap["character"]["item"]).instantiate()
		my_item_name.text = "[CTRL] %s" % the_item.addon_name
		my_item_texture.texture = the_item.texture
		add_child(the_item)
		the_item.queue_free()
	else:
		my_item_name.text = "N/A"

func _input(event):
	if event is InputEventMouseMotion:
		look_rot.x = clamp(look_rot.x - (event.relative.y * sensitivity), -60, 60)
		look_rot.y -= (event.relative.x * sensitivity)
	
	if not working and cooldown_timer.time_left == 0:
		if event.is_action_pressed("attack"):
			attack()
		
		if event.is_action_pressed("ability"):
			use_ability()
		
		if event.is_action_pressed("item"):
			use_item()
		
		if event.is_action_pressed("yes"):
			yes()
			
func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var float_dir = Input.get_axis("down", "up")

	var direction = (transform.basis * Vector3(input_dir.x, float_dir, input_dir.y)).normalized()
	if direction:
		velocity = direction * SPEED * Starmaps.current_starmap["character"]["dex"]
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	self.rotation_degrees.x = look_rot.x
	self.rotation_degrees.y = look_rot.y
	
	if working and work_curve:
		var ratio = ( (work_timer.wait_time - work_timer.time_left) / work_timer.wait_time)
		var work_length = attack_curve.get_baked_length()
		var sample_point = ratio * work_length
		char_body.position = work_curve.sample_baked(sample_point) * attack_mag
	
	cooldown_label.text = "%3.1f" % cooldown_timer.time_left
	var ratio = (cooldown_timer.time_left) / (cooldown_timer.wait_time)
	cooldown_bar.value = ratio

func work(curve, time):
	working = true
	work_timer.wait_time = time
	work_timer.start(time)
	work_curve = curve

func end_working():
	working = false
	var cooldown_time_actual = cooldown_time / Starmaps.current_starmap["character"]["int"]
	cooldown_timer.start(cooldown_time_actual)
	work_curve = null

func attack(): 
	work(attack_curve, attack_time)
	var n_hs = hit_scene.instantiate()
	add_child(n_hs)
	cooldown_time = attack_cooldown

func yes():
	if stall:
		if not stall.sold_out and Starmaps.current_starmap["character"]["exp"] >= stall.cost:
			Starmaps.current_starmap["character"]["item"] = stall.item_scene.resource_path
			get_points(-stall.cost)
			stall.buy_item()
			update_item()

func set_stall(body):
	stall = body
	if stall:
		stall_dialogue.visible = true
		item_name.text = stall.item.addon_name
		item_cost.text = "$%d" % stall.cost
		if stall.cost > Starmaps.current_starmap["character"]["exp"]:
			item_cost.add_theme_color_override("font_color", Color(1, 0, 0))
		else:
			item_cost.add_theme_color_override("font_color", Color(1, 1, 1))
	else:
		stall_dialogue.visible = false

func use_ability():
	var n_ability_scene = load(Starmaps.current_starmap["character"]["ability"]).instantiate()
	add_child(n_ability_scene)
	n_ability_scene._use()
	work(n_ability_scene.animation, n_ability_scene.animation_time)
	cooldown_time = n_ability_scene.cooldown_time

func use_item():
	if Starmaps.current_starmap["character"].has("item") and Starmaps.current_starmap["character"]["item"] != "":
		var n_ability_scene = load(Starmaps.current_starmap["character"]["item"]).instantiate()
		add_child(n_ability_scene)
		n_ability_scene._use()
		work(n_ability_scene.animation, n_ability_scene.animation_time)
		cooldown_time = n_ability_scene.cooldown_time
		Starmaps.current_starmap["character"].erase("item")
		my_item_texture.texture = none_tex
		update_item()

func get_points(points):
	Starmaps.current_starmap["character"]["exp"] += points
	point_label.text = "%d" % Starmaps.current_starmap["character"]["exp"]

func hit_player():
	Starmaps.current_starmap["character"]["hp"] -= 1
	hp_bar.value = Starmaps.current_starmap["character"]["hp"]
	if Starmaps.current_starmap["character"]["hp"] <= 0:
		Starmaps.navigate_to_lose()
