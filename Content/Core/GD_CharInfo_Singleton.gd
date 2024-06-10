extends Node

var intelligence : int
var charisma : int
var strength : int

var char_name : String

var char_list_dit = "user://chars/"

var character_list_example = {
	"characters": [
		{
			"name": "Starretri",
			"int": 3,
			"str": 1,
			"dex": 1,
			"hp": 3,
			"abilities": [],
			"exp": 0
		},
		{
			"name": "Starlo",
			"int": 1,
			"str": 3,
			"dex": 1,
			"hp": 3,
			"abilities": [],
			"exp": 0
		},
		{
			"name": "Starrletty",
			"int": 1,
			"str": 1,
			"dex": 3,
			"hp": 3,
			"abilities": [],
			"exp": 0
		},
	]
}

var current_char = character_list_example["characters"][0]


func get_chars():
	return character_list_example

func set_char(new_char):
	current_char = new_char
