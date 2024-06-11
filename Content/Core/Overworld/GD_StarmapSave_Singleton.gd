extends Node

# startmap node types
const START = 0
const MAZE = 1
const STORE = 2
const GOAL = 3

const STARMAP_SAVE_LOCATION = "user://saves/"
const STARMAP_FILE_NAME = "current.starmap"

var current_starmap = {}
var current_node = -1

var starmap_scene = preload("res://Content/Maps/L_Overworld.tscn")
var you_win = preload("res://Content/Maps/L_YouWin.tscn")

var starmap_example = {
	"character": "Starretri",
	"seed": 1278491023,
	"nodes": [
		{
			"id": 0,
			"name": "Start Here!",
			"desc": "Your First Maze!",
			"type": START,
			"location_x": .10,
			"location_y": .10,
			"scene": "res://Content/Maps/mazes/L_Maze_1.tscn",
			"neighbors": [1],
			"completed": false,
			"current": false,
			"up_next": true,
		},
		{
			"id": 1,
			"name": "Complete me next!",
			"desc": "Your Second Maze!",
			"type": MAZE,
			"location_x": .50,
			"location_y": .60,
			"scene": "res://Content/Maps/mazes/L_Maze_1.tscn",
			"neighbors": [2],
			"completed": false,
			"current": false,
			"up_next": false,
		},
		{
			"id": 2,
			"name": "Finish Here!",
			"desc": "You're So Close!",
			"type": GOAL,
			"location_x": .90,
			"location_y": .90,
			"scene": "res://Content/Maps/mazes/L_Maze_1.tscn",
			"neighbors": [],
			"completed": false,
			"current": false,
			"up_next": false,
		}
	]
}

var rng : RandomNumberGenerator

const SYSTEM_NAMES = [
	"Sirius",
	"Altair",
	"Alpha Centauri",
	"Antares",
	"Polaris",
	"Rigel",
	"Castor"
]

const MAZE_SCENES_DIR = "res://Content/Maps/mazes/"
const STORE_SCENES_DIR = "res://Content/Maps/stores/"

# Only keep one active starmap
func get_save_file(access_mode):
	var save_dir = DirAccess.open("user://")
	if not save_dir.dir_exists(STARMAP_SAVE_LOCATION):
		save_dir.make_dir(STARMAP_SAVE_LOCATION)
	
	return FileAccess.open(STARMAP_SAVE_LOCATION + STARMAP_FILE_NAME, access_mode)

func save_starmap():
	var save_game = get_save_file(FileAccess.WRITE)
	var json_string = JSON.stringify(current_starmap)
	
	save_game.store_line(json_string)

func load_starmap():
	var load_game = get_save_file(FileAccess.READ)
	if !load_game:
		return 0

	
	var json = JSON.new()
	var json_string = load_game.get_line()
	var parse_result = json.parse(json_string)
	
	if not parse_result == OK:
		print("Scene corrupt.")
		return 0
	
	current_starmap = json.get_data()
	return 1

func save_exists():
	return FileAccess.file_exists(STARMAP_SAVE_LOCATION + STARMAP_FILE_NAME)

func gen_starmap():
	# Set up rng
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Setup Empty Array for map
	var new_starmap = {
		"character": "Starretri",
		"seed": rng.randi(),
		"seed_state": -1,
		"nodes": []
	}
	
	rng.seed = new_starmap["seed"]
	new_starmap["seed_state"] = rng.state
	
	var first_node = gen_node(START)
	first_node["location_x"] = .1
	first_node["location_y"] = .5
	var generated_nodes = 0
	first_node["id"] = generated_nodes
	generated_nodes += 1
	
	var noise_scale = .1
	
	var zone_count = rng.randi_range(2, 3)
	var system_count = rng.randi_range(zone_count, zone_count * 3)
	var system_vector = [[first_node]]
	for z in range(1, zone_count):
		var zone_system_count = rng.randi_range(1, system_count/zone_count)
		system_count = system_count - zone_system_count
		if z == zone_count && system_count > 0:
			zone_system_count += system_count
		var x_loc = (0.7 / zone_count) * (z - 1) + .15
		var zone_systems = []
		for s in range(1, zone_system_count):
			var system_type = rng.randi_range(MAZE, STORE)
			var new_node = gen_node(system_type)
			new_node["location_x"] = x_loc + rng.randf_range(-noise_scale, noise_scale)
			new_node["location_y"] = .8 / zone_system_count + rng.randf_range(-noise_scale, noise_scale)
			new_node["id"] = generated_nodes
			generated_nodes += 1
			zone_systems.append(new_node)
		system_vector.append(zone_systems)
	
	var final_node = gen_node(GOAL)
	final_node["location_x"] = .9
	final_node["lozation_y"] = .5
	system_vector.append([final_node])
	
	for zone in range(0, len(system_vector)):
		if zone == zone_count:
			system_vector[zone][0]["children"] = []
			new_starmap["nodes"].append(system_vector[zone][0])
		else:
			for system in range(0, len(system_vector[zone])):
				system_vector[zone][system]["neighbors"] = []
				for o_system in system_vector[zone + 1]:
					system_vector[zone][system]["children"].append(system_vector[zone+1][o_system]["id"])
					new_starmap["nodes"].append(system_vector[zone][system])

	new_starmap["seed_state"] = rng.state
	current_starmap = new_starmap
	current_node = 0
	
	save_starmap()

func solve():
	var completed_map = current_starmap["nodes"][current_node]
	completed_map["completed"] = true
	for node in current_starmap["nodes"]:
		node["up_next"] = false
	
	for id in completed_map["neighbors"]:
		current_starmap["nodes"][id]["up_next"] = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	save_starmap()
	if completed_map["type"] == GOAL:
		navigate_to_win()
		CharacterInfo.save_char(CharacterInfo.current_char)
		clear_map()
	else:
		navigate_to_starmap()

func navigate_to_maze(maze, new_id):
	var next_scene = load(maze)
	get_tree().change_scene_to_packed(next_scene)
	current_node = new_id

func navigate_to_starmap():
	get_tree().change_scene_to_packed(starmap_scene)

func navigate_to_win():
	current_starmap = {}
	get_tree().change_scene_to_packed(you_win)

func navigate_generic(map):
	get_tree().change_scene_to_packed(map)

func quit():
	get_tree().quit()

func clear_map():
	var save_dir = DirAccess.open(STARMAP_SAVE_LOCATION)
	save_dir.remove(STARMAP_FILE_NAME)

func gen_node(type):
	var new_node = {}
	new_node["type"] = type
	new_node["name"] = SYSTEM_NAMES[rng.randi_range(0, len(SYSTEM_NAMES)-1)] + " " + str(rng.randi_range(1, 9))
	new_node["completed"] = false
	new_node["current"] = false
	new_node["up_next"] = false
	new_node["scene"] = get_maze_scene()
	
	match type:
		START:
			new_node["desc"] = "The starting point for your adventure!"
			new_node["up_next"] = true
		MAZE:
			new_node["desc"] = "A challenging maze! Earn rewards and experience"
		STORE:
			new_node["desc"] = "There's a store in this system! Buy supplies!"
			new_node["scene"] = get_store_scene()
		GOAL:
			new_node["desc"] = "You're almost there! You can do it!"
			
	
	return new_node

func get_maze_scene():
	var maze_dir = DirAccess.open(MAZE_SCENES_DIR)
	var mazes = maze_dir.get_files()
	print_debug(mazes)
	return MAZE_SCENES_DIR+mazes[rng.randi_range(0, len(mazes)-1)]

func get_store_scene():
	var store_dir = DirAccess.open(STORE_SCENES_DIR)
	var stores = store_dir.get_files()
	return STORE_SCENES_DIR+stores[rng.randi_range(0, len(stores)-1)]
