extends Node

var intelligence : int
var charisma : int
var strength : int

var char_name : String

var char_list_dit = "user://chars/"

var character_list_example = {
	"characters": [
		{
			"id": 0,
			"name": "Starretri",
			"int": 3,
			"str": 1,
			"dex": 1,
			"hp": 3,
			"abilities": [],
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
			"abilities": [],
			"exp": 0,
			"level": 1,
			"locked": true,
		},
		{
			"id": 2,
			"name": "Starrletty",
			"int": 1,
			"str": 1,
			"dex": 3,
			"hp": 3,
			"abilities": [],
			"exp": 0,
			"level": 1,
			"locked": true,
		},
	]
}

var current_char = character_list_example["characters"][0]


func get_chars():
	return character_list_example

func set_char(new_char):
	current_char = new_char
