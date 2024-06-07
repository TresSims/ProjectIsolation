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
	
	var json = JSON.new()
	var json_string = load_game.get_line()
	var parse_result = json.parse(json_string)
	
	if not parse_result == OK:
		print("Scene corrupt.")
		return
	
	current_starmap = json.get_data()

func gen_starmap():
	current_starmap = starmap_example
	current_node = 0

func solve():
	print_debug("Level Solved!")
	var completed_map = current_starmap["nodes"][current_node]
	print_debug(completed_map)
	completed_map["completed"] = true
	for node in current_starmap["nodes"]:
		node["up_next"] = false
	
	for id in completed_map["neighbors"]:
		print_debug(id)
		current_starmap["nodes"][id]["up_next"] = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if completed_map["type"] == GOAL:
		navigate_to_win()
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
	
