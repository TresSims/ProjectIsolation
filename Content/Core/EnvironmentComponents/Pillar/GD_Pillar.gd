@tool
extends ChangeableNode

@export var size := 1.0
var last_size = size

@onready var column = $ColumnMid
@onready var column_cap = $ColumnTop
@onready var column_collision = $Column/CollisionShape3D
@onready var cap_collision = $Column/Top/CollisionShape3D

func setup_part():
	super.setup_part()
	
	column.scale.y = size
	column_collision.scale.y = size
	column_cap.position.y = size-1
	cap_collision.position.y = size-1

func _process(_delta):
	if size != last_size:
		last_size = size
		setup_part()
	
	super._process(_delta)
