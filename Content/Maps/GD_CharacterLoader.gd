extends VBoxContainer

@export var character_button : PackedScene

@onready var button_list = $CharacterButtons

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in button_list.get_children():
		button_list.remove_child(child)
		child.queue_free()
	
	var characters = CharacterInfo.get_chars()
	for character in characters["characters"]:
		var new_button = character_button.instantiate()
		button_list.add_child(new_button)
		new_button.setup(character)
		
		# Initially select first character
		if character["id"] == 0:
			CharacterInfo.current_char = character


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
