extends PanelContainer

@onready var title = $MarginContainer/VBoxContainer/Label
@onready var label = $MarginContainer/VBoxContainer/RichTextLabel
@onready var button = $MarginContainer/VBoxContainer/Button
var load_scene = "res://Content/Maps/mazes/L_Maze_1.tscn"
var node_id = -1

func update(meta):
	title.text = meta["name"]
	label.text = meta["desc"]
	load_scene = meta["scene"]
	button.disabled = false
	node_id = meta["id"]

func _on_press():
	Starmaps.navigate_to_maze(load_scene, node_id)
