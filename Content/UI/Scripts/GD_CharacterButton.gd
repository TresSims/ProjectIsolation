extends PanelContainer

var char_info = {
	"name": "Starretri",
	"int": 3,
	"str": 1,
	"dex": 1,
	"hp": 3,
	"abilities": [],
	"exp": 0,
	"level": 1,
	"locked": false,
}

@onready var profile_image = $MarginContainer/VBox/CenterContainer/Profile
@onready var locked_image = $MarginContainer/VBox/CenterContainer/Profile/Locked
@onready var char_name = $MarginContainer/VBox/Name
@onready var int_stat = $MarginContainer/VBox/Int
@onready var str_stat = $MarginContainer/VBox/Str
@onready var dex_stat = $MarginContainer/VBox/Dex
@onready var level_stat = $MarginContainer/VBox/Level
@onready var select_button = $Select

func setup(character_info):
	char_info = character_info
	char_name.text = char_info["name"]
	int_stat.text = str(char_info["int"])
	str_stat.text = str(char_info["str"])
	dex_stat.text = str(char_info["dex"])
	level_stat.text = str(char_info["level"])
	
	var locked = char_info["locked"]
	locked_image.visible = locked
	select_button.disabled = locked

func _select():
	CharacterInfo.current_char = char_info