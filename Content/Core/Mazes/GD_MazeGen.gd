extends Node
class_name MazeGenerator

@export var load_progress:ProgressBar
@export var load_screen:Control
var done_nodes = 0
var total_nodes


var maze_dimensions:Vector3 = Vector3(2,2,2)
var goal_cell:Vector3 = Vector3(0, 0, 0)
var current_cell:Vector3
var start_cell:Vector3

@export var maze_cell_range := Vector2(3,6)

var wall_size = 18
var wall_thick = 2
var offset = 0
var maze_scale = Vector3(1.1, 1.1, 1)
@export var wall:PackedScene
@export var border_wall:PackedScene

var maze_graph:Array

@export var goal:PackedScene
@export var player:PackedScene


# Bit Masks
var WALL_ABOVE = 1
var WALL_BELOW = 2
var WALL_LEFT = 4
var WALL_RIGHT = 8
var WALL_FRONT = 16
var WALL_BACK = 32
var QUEUED = 64
var IN_MAZE = 128

# Needed variables
var x_dx
var y_dy
var z_dz
var n
	
# directional masks
var dx = [ 0, 0, -1, 1, 0, 0 ]
var dy = [ -1, 1, 0, 0, 0, 0 ]
var dz = [ 0, 0, 0, 0, -1, 1 ]
	
# Maze Todos
var todo = []
var todonum = 0

var done = false

var passBool = 1
var di

var x
var y
var z

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Generate Maze Dimensions and Starting Point
	maze_dimensions = Vector3(Starmaps.rng.randi_range(maze_cell_range.x, maze_cell_range.y),
							  Starmaps.rng.randi_range(maze_cell_range.x, maze_cell_range.y),
							  Starmaps.rng.randi_range(maze_cell_range.x, maze_cell_range.y)
							)
	total_nodes = maze_dimensions.x * maze_dimensions.y * maze_dimensions.z
	goal_cell = Vector3(Starmaps.rng.randi_range(0, maze_dimensions.x-1), 
						Starmaps.rng.randi_range(0, maze_dimensions.y-1), 
						Starmaps.rng.randi_range(0, maze_dimensions.z-1)
						)
	
	# Initialize Empty Array
	for x in range(0, maze_dimensions.x):
		var n_slice = []
		
		for y in range(0, maze_dimensions.y):
			var n_row = []
			
			for z in range(0, maze_dimensions.z):
				var n_cell = WALL_ABOVE + WALL_BELOW + WALL_LEFT + WALL_RIGHT + WALL_FRONT + WALL_BACK + QUEUED + IN_MAZE
				n_row.append(n_cell)
			
			n_slice.append(n_row)
		
		maze_graph.append(n_slice)
	
	# Mark starting square as connected to the maze
	current_cell = goal_cell
	maze_graph[current_cell.x][current_cell.y][current_cell.z] &= ~(QUEUED + IN_MAZE)
	
	# Remember the surrounding squares as we will...
	for d in range(0, 6):
		x_dx = current_cell.x + dx[d]
		y_dy = current_cell.y + dy[d]
		z_dz = current_cell.z + dz[d]
		if x_dx >= 0 && x_dx < maze_dimensions.x && y_dy >= 0 && y_dy < maze_dimensions.y && z_dz >= 0 && z_dz < maze_dimensions.z:
			if maze_graph[x_dx][y_dy][z_dz] & QUEUED != 0:
				# ... want to connec them to the maze
				todo.append(Vector3(x_dx, y_dy, z_dz))
				todonum += 1
				maze_graph[x_dx][y_dy][z_dz] &= ~QUEUED

func build_cell_wall(cell, cell_position):
	var cell_x = (cell_position.x * wall_size) + offset 
	var cell_y = (cell_position.y * wall_size) + offset
	var cell_z = (cell_position.z * wall_size) + offset
	
	var n_x
	var n_y
	var n_z
	
	var n_wall
	
	if cell & WALL_ABOVE == 0:
		n_wall = wall.instantiate()
		n_wall.color = Color(0, .5, 0)
		n_x = cell_x
		n_y = cell_y + wall_size/2
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.rotation.x = deg_to_rad(90)
		n_wall.scale = maze_scale
		add_child(n_wall)
	if cell & WALL_BELOW == 0:
		n_wall = wall.instantiate()
		n_wall.color = Color(0, .5, 0)
		n_x = cell_x
		n_y = cell_y - wall_size/2
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.scale = maze_scale
		n_wall.rotation.x = deg_to_rad(90)
		add_child(n_wall)
	if cell & WALL_LEFT == 0:
		n_wall = wall.instantiate()
		n_wall.color = Color(.5, 0, 0)
		n_x = cell_x + wall_size/2
		n_y = cell_y
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.scale = maze_scale
		n_wall.rotation.y = deg_to_rad(90)
		add_child(n_wall)
	if cell & WALL_RIGHT == 0:
		n_wall = wall.instantiate()
		n_wall.color = Color(.5, 0, 0)
		n_x = cell_x - wall_size/2
		n_y = cell_y
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.scale = maze_scale
		n_wall.rotation.y = deg_to_rad(90)
		add_child(n_wall)
	if cell & WALL_FRONT == 0:
		n_wall = wall.instantiate()
		n_wall.color = Color(0, 0, .5)
		n_x = cell_x
		n_y = cell_y
		n_z = cell_z + wall_size/2
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.scale = maze_scale
		add_child(n_wall)
	if cell & WALL_BACK == 0:
		n_wall = wall.instantiate()
		n_wall.color = Color(0, 0, .5)
		n_x = cell_x
		n_y = cell_y
		n_z = cell_z - wall_size/2
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.scale = maze_scale
		add_child(n_wall)
	
	# Perimiter Walls
	if cell_position.x == 0:
		n_wall = border_wall.instantiate()
		n_x = cell_x - wall_size/2 - wall_thick
		n_y = cell_y
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.rotation.y = deg_to_rad(90)
		n_wall.scale = maze_scale
		add_child(n_wall)
	if cell_position.x == maze_dimensions.x-1:
		n_wall = border_wall.instantiate()
		n_x = cell_x + wall_size/2 + wall_thick
		n_y = cell_y
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.rotation.y = deg_to_rad(90)
		n_wall.scale = maze_scale
		add_child(n_wall)
	if cell_position.y == 0:
		n_wall = border_wall.instantiate()
		n_x = cell_x
		n_y = cell_y - wall_size/2 - wall_thick
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.rotation.x = deg_to_rad(90)
		n_wall.scale = maze_scale
		add_child(n_wall)
	if cell_position.y == maze_dimensions.y-1:
		n_wall = border_wall.instantiate()
		n_x = cell_x
		n_y = cell_y + wall_size/2 + wall_thick
		n_z = cell_z
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.rotation.x = deg_to_rad(90)
		n_wall.scale = maze_scale
		add_child(n_wall)
	if cell_position.z == maze_dimensions.z-1:
		n_wall = border_wall.instantiate()
		n_x = cell_x
		n_y = cell_y 
		n_z = cell_z + wall_size/2 + wall_thick
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.scale = maze_scale
		add_child(n_wall)
	if cell_position.z == 0:
		n_wall = border_wall.instantiate()
		n_x = cell_x
		n_y = cell_y 
		n_z = cell_z - wall_size/2 - wall_thick
		n_wall.position = Vector3(n_x, n_y, n_z)
		n_wall.scale = maze_scale
		add_child(n_wall)
		

func add_branch_to_cell(branch, cell_position):
	var cell_x = (cell_position.x * wall_size)
	var cell_y = (cell_position.y * wall_size)
	var cell_z = (cell_position.z * wall_size)
	
	var n_branch = branch.instantiate()
	n_branch.position = Vector3(cell_x, cell_y, cell_z)
	add_child(n_branch)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Iterate until the maze is done
	if todonum > 0:
		load_progress.value = done_nodes / total_nodes
		if passBool == 0:
			di = Starmaps.rng.randi_range(0, 5)
			x_dx = x + dx[di]
			y_dy = y + dy[di]
			z_dz = z + dz[di]
			if x_dx >= 0 && x_dx < maze_dimensions.x && y_dy >= 0 && y_dy < maze_dimensions.y && z_dz >= 0 && z_dz < maze_dimensions.z:
				if (maze_graph[x_dx][y_dy][z_dz] & IN_MAZE) == 0:
					passBool = 1
					maze_connect(x, y, z)
					done_nodes += 1
		else:
			n = Starmaps.rng.randi_range(0, todonum-1)
			x = todo[n].x
			y = todo[n].y
			z = todo[n].z
			
			# At the end of this step the cell will be connected, so remove it from the queue
			todo.remove_at(n)
			todonum -= 1
			
			passBool = 0
		
	elif not done:
		for x in range(0, len(maze_graph)):
			for y in range(0, len(maze_graph[x])):
				for z in range(0, len(maze_graph[x][y])):
					build_cell_wall(maze_graph[x][y][z], Vector3(x, y, z))
		
		add_branch_to_cell(goal, goal_cell)
		add_branch_to_cell(player, Vector3(
			Starmaps.rng.randi_range(0, maze_dimensions.x - 1 ),
			Starmaps.rng.randi_range(0, maze_dimensions.y - 1 ),
			Starmaps.rng.randi_range(0, maze_dimensions.z - 1 )
		))
		done = true
		load_screen.visible = false

func maze_connect(x, y, z):
	# Connect this square to the maze
	maze_graph[x][y][z] &= ~((1 << di) | IN_MAZE)
	maze_graph[x + dx[di]][y + dy[di]][z + dz[di]] &= ~(1 << (di  ^ 1))
		
	# Remember Surrounding Squares for Maze includion
	for d in range(0, 5):
		x_dx = x + dx[d]
		y_dy = y + dy[d]
		z_dz = z + dz[d]
		if x_dx >= 0 && x_dx < maze_dimensions.x && y_dy >= 0 && y_dy < maze_dimensions.y && z_dz >= 0 && z_dz < maze_dimensions.z:
			if maze_graph[x_dx][y_dy][z_dz] & QUEUED != 0:
				todo.append(Vector3(x_dx, y_dy, z_dz))
				todonum += 1
				maze_graph[x_dx][y_dy][z_dz] &= ~QUEUED
