extends NavButton


func _load_scene():
	Starmaps.load_starmap()
	CharacterInfo.read_char_file(Starmaps.current_starmap["character"])
	super._load_scene()
