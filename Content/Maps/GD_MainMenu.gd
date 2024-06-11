extends Control

@onready var continue_button = $MarginContainer/VBoxContainer/Continue

# Called when the node enters the scene tree for the first time.
func _ready():
	if Starmaps.save_exists():
		continue_button.disabled = false
