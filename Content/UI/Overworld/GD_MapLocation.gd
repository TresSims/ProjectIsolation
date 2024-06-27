extends TextureButton

var meta = {
	"id": 0,
	"name": "Start Here!",
	"desc": "Your First Maze!",
	"type": Starmaps.START,
	"location_x": 50,
	"location_y": 500,
	"scene": "res://Content/Maps/mazes/L_Maze_1.tscn",
	"neighbors": [1],
	"completed": false,
}

var box : Node

func setup(locations, maze_box):
	self.position.x = locations.size.x * meta["location_x"]
	self.position.y = locations.size.y - locations.size.y * meta["location_y"]
	
	if meta["up_next"]:
		self.disabled = false
	else:
		self.disabled = true
		self.modulate = Color(.5, .5, .5, .5)
	
	self.texture_normal = load(meta["button_texture"])
	#self.material.set_shader_parameter("gradient", load(meta["planet_theme"]))
	
	box = maze_box

func _write_meta():
	box.update(meta)
	on_click()

func _on_hover():
	if !self.disabled:
		self.modulate = Color(.95, .95, .95)

func on_click():
	if !self.disabled:
		self.modulate = Color(1, 1, 1)

func _goto_default():
	if !self.disabled:
		self.modulate = Color(.9, .9, .9)
