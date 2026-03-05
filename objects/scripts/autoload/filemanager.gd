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

## Loads a level from a level resource file
##
##
func load_from_resource(id: String) -> bool:
	var level : LevelResource
	if ResourceLoader.exists("res://levels/%s.res" % id):
		pass
	elif ResourceLoader.exists("user://levels/%s.res" % id):
		level = ResourceLoader.load("user://levels/%s.res" % id)
	else:
		print("level does not exist")
		return false
	
	var levelnode : Node = preload("res://editor/level_template.tscn").instantiate()
	var tilemap = levelnode.find_child("TileMapLayer") as TileMapLayer
	tilemap.tile_map_data = level.tile_map_data
	
	var game_screen = preload("res://objects/scenes/gamescreen.tscn").instantiate()
	game_screen.add_child(levelnode)
	get_tree().call_deferred("change_scene_to_node", game_screen)
	RaceManager.current_id = id
	
	return true
