extends Panel

const map_elem = preload("res://Content/Core/Overworld/B_MapLocation.tscn")

@onready var lines = $MapLines
@onready var locations = $MapLocations
@onready var meta = $MazeBox

func read_starmap():
	# If starmap is empty, create a new one
	if not Starmaps.save_exists():
		Starmaps.gen_starmap()
	else:
		Starmaps.load_starmap()
	
	var map = Starmaps.current_starmap
	
	for n in lines.get_children():
		lines.remove_child(n)
		n.queue_free()
		
	for n in locations.get_children():
		locations.remove_child(n)
		n.queue_free()
	
	for node in map["nodes"]:
		var new_elem = map_elem.instantiate()
		new_elem.meta = node
		new_elem.setup(locations, meta)
		
		locations.add_child(new_elem)
		
		for n in node["neighbors"]:
			var neighbor = map["nodes"][n]
			var new_line = Line2D.new()
		
			new_line.add_point(Vector2(locations.size.x * node["location_x"] + new_elem.size.x/2, locations.size.y - (locations.size.y * node["location_y"]) + new_elem.size.y/2))
			new_line.add_point(Vector2(locations.size.x * neighbor["location_x"] + new_elem.size.x/2, locations.size.y - (locations.size.y * neighbor["location_y"]) + new_elem.size.y/2))
			lines.add_child(new_line)

# Called when the node enters the scene tree for the first time.
func _ready():
	read_starmap()
