## Stuff for saving and loading levels


extends Node

## Loads a level of the given ID if it exists. [br][br]
## [param id] - the id of the level to load [br]
## returns bool - whether or not the level was loaded
func load_level(id: String) -> bool:
	var levelPath : String = ""
	if ResourceLoader.exists("res://levels/%s/level.scn" % id):
		levelPath = "res://levels/%s/level.scn" % id
	elif ResourceLoader.exists("user://levels/%s/level.scn" % id):
		levelPath = "user://levels/%s/level.scn" % id
	else:
		print("scene does not exist")
		return false
	
	var level = load(levelPath).instantiate()
	var game_screen = preload("res://objects/scenes/gamescreen.tscn").instantiate()
	game_screen.add_child(level)
	get_tree().change_scene_to_node(game_screen)
	RaceManager.current_id = id
	
	return true
