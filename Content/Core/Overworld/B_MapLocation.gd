extends Button

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
	
	box = maze_box

func _write_meta():
	box.update(meta)
