@tool
extends Node
class_name ChangeableNode

@export var color := Color(1, 1, 1)
var last_col = color

@export var colorizable_objects:Array[MeshInstance3D]

func _ready():
	setup_part()
	
	for object in colorizable_objects:
		object.mesh.resource_local_to_scene = true

func setup_part():
	var material = colorizable_objects[0].mesh.surface_get_material(0).duplicate()
	material.albedo_color = color
	material.emission = color
	for object in colorizable_objects:
		object.mesh.surface_set_material(0, material)
	

func _process(_delta):
	if last_col != color:
		last_col = color
		setup_part()
