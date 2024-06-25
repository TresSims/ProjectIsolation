@tool
extends ChangeableNode

@export var size := 1.0
var last_size = size

func setup_part():
	super.setup_part()

func _process(_delta):
	if size != last_size:
		last_size = size
		setup_part()
	
	super._process(_delta)
