extends Node
class_name MazeGenerator

var maze_dimensions:Vector3 = Vector3(2,2,2)
var goal_cell:Vector3
var start_cell:Vector3

@export var maze_cell_range := Vector2(3,6)

var wall_size = 3.5
var wall_thick = .5
@export var wall:PackedScene

var maze_graph:Array


# Called when the node enters the scene tree for the first time.
func _ready():
	maze_dimensions = Vector3(Starmaps.rng.randi_range(maze_cell_range.x, maze_cell_range.y),
							  Starmaps.rng.randi_range(maze_cell_range.x, maze_cell_range.y),
							  Starmaps.rng.randi_range(maze_cell_range.x, maze_cell_range.y)
							)
	goal_cell = Vector3(Starmaps.rng.randi_range(0, maze_dimensions.x), 
						Starmaps.rng.randi_range(0, maze_dimensions.y), 
						Starmaps.rng.randi_range(0, maze_dimensions.z)
						)
	
	# Initialize Empty Array
	for x in range(0, maze_dimensions.x):
		var n_slice = []
		
		for y in range(0, maze_dimensions.y):
			var n_row = []
			
			for z in range(0, maze_dimensions.z):
				var n_cell = {
								"up": false,
								"down": false,
								"left": false,
								"right": false,
								"front": false,
								"back": false
							}
				n_row.append(n_cell)
				build_cell_wall(n_cell, Vector3(x, y, z))
			
			n_slice.append(n_row)
		
		maze_graph.append(n_slice)

func build_cell_wall(cell, cell_position):
	print_debug(cell_position)
	var offset = 1
	var cell_x = (cell_position.x * wall_size) + offset 
	var cell_y = (cell_position.y * wall_size) + offset
	var cell_z = (cell_position.z * wall_size) + offset
	
	var n_x
	var n_y
	var n_z
	
	var n_wall
	
	if !cell["up"]:
		n_wall = wall.instantiate()
		n_wall.color = Color(0, .5, 0)
		n_x = cell_x
		n_y = cell_y + wall_size/2
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.rotation.x = deg_to_rad(90)
		add_child(n_wall)
	if !cell["down"]:
		n_wall = wall.instantiate()
		n_wall.color = Color(0, .5, 0)
		n_x = cell_x
		n_y = cell_y - wall_size/2
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.rotation.x = deg_to_rad(90)
		add_child(n_wall)
	if !cell["left"]:
		n_wall = wall.instantiate()
		n_wall.color = Color(.5, 0, 0)
		n_x = cell_x + wall_size/2
		n_y = cell_y
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.rotation.y = deg_to_rad(90)
		add_child(n_wall)
	if !cell["right"]:
		n_wall = wall.instantiate()
		n_wall.color = Color(.5, 0, 0)
		n_x = cell_x - wall_size/2
		n_y = cell_y
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.rotation.y = deg_to_rad(90)
		add_child(n_wall)
	if !cell["front"]:
		n_wall = wall.instantiate()
		n_wall.color = Color(0, 0, .5)
		n_x = cell_x
		n_y = cell_y
		n_z = cell_z + wall_size/2
		n_wall.position = Vector3(n_x, n_y, n_z)
		add_child(n_wall)
	if !cell["back"]:
		n_wall = wall.instantiate()
		n_wall.color = Color(0, 0, .5)
		n_x = cell_x
		n_y = cell_y
		n_z = cell_z - wall_size/2
		n_wall.position = Vector3(n_x, n_y, n_z)
		add_child(n_wall)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
