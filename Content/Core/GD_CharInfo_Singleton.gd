extends Node

var intelligence : int
var charisma : int
var strength : int

var char_name : String

var CHAR_LIST_LOCATION = "user://chars/"

var character_list_example = {
	"characters": [
		{
			"id": 0,
			"name": "Starretri",
			"int": 3,
			"str": 1,
			"dex": 1,
			"hp": 3,
			"ability": "res://Content/Core/AddOns/Hint/B_Hint.tscn",
			"exp": 0,
			"level": 1,
			"locked": false,
		},
		{
			"id": 1,
			"name": "Starlo",
			"int": 1,
			"str": 3,
			"dex": 1,
			"hp": 3,
			"ability": "res://Content/Core/AddOns/WallBreak/B_WallBreak.tscn",
			"exp": 0,
			"level": 1,
			"locked": true,
		},
		{
			"id": 2,
			"name": "Starla",
			"int": 1,
			"str": 1,
			"dex": 3,
			"hp": 3,
			"ability": "res://Content/Core/AddOns/Dash/B_Dash.tscn",
			"exp": 0,
			"level": 1,
			"locked": true,
		},
	]
}

var current_char

func get_save_dir():
	var save_dir = DirAccess.open("user://")
	if not save_dir.dir_exists(CHAR_LIST_LOCATION):
		save_dir.make_dir(CHAR_LIST_LOCATION)
	
	save_dir = DirAccess.open(CHAR_LIST_LOCATION)
	return save_dir

func get_save_file(character_name, access_mode):
	get_save_dir()
	
	var character_file = CHAR_LIST_LOCATION + character_name + ".character"
	
	return FileAccess.open(character_file, access_mode)

func get_chars():
	var save_dir = get_save_dir()
	var saves = save_dir.get_files()
	if saves.size() == 0:
		for character in character_list_example["characters"]:
			save_char(character)
		
		saves = save_dir.get_files()
	
	var characters = {"characters": []}
	
	for save in saves:
		characters["characters"].append(read_char_file(save))
	
	return characters

func read_char_file(file):
	var load_char = get_save_file(file.get_slice(".",0), FileAccess.READ)
	
	var json = JSON.new()
	
	var json_string = load_char.get_line()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("Can't read character")
		return

	return json.get_data()

func save_char(character):
	var save_file = get_save_file(character["name"], FileAccess.WRITE)
	var json_string = JSON.stringify(character)
	
	save_file.store_line(json_string)

func set_char(new_char):
	current_char = new_char
	Starmaps.current_starmap["character"] = new_char["name"]
	Starmaps.save_starmap()
