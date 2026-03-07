## Stuff for saving and loading levels
extends Node

## Loads a level of the given ID if it exists. [br][br]
## [param id] - the id of the level to load [br]
## returns bool - whether or not the level was loaded
func load_level(id: String) -> bool:
	var levelPath : String = ""
	if ResourceLoader.exists("res://levels/%s.scn" % id):
		levelPath = "res://levels/%s.scn" % id
	elif ResourceLoader.exists("user://levels/%s.scn" % id):
		levelPath = "user://levels/%s.scn" % id
	else:
		print("scene does not exist")
		return false
	
	var level = load(levelPath).instantiate()
	var game_screen = preload("res://objects/scenes/gamescreen.tscn").instantiate()
	game_screen.add_child(level)
	get_tree().change_scene_to_node(game_screen)
	RaceManager.current_id = id
	
	return true

## Loads a level from a level resource file [br]
## [param id] - the name of the resource file
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

#region UUID stuff

const BYTE_MASK: int = 0b11111111

static func uuidbin():
	# 16 random bytes with the bytes on index 6 and 8 modified
	return [
		randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK,
		randi() & BYTE_MASK, randi() & BYTE_MASK, ((randi() & BYTE_MASK) & 0x0f) | 0x40, randi() & BYTE_MASK,
		((randi() & BYTE_MASK) & 0x3f) | 0x80, randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK,
		randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK, randi() & BYTE_MASK,
	]

static func v4():
# 16 random bytes with the bytes on index 6 and 8 modified
	var b = uuidbin()
	return '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x' % [
		# low
		b[0], b[1], b[2], b[3],
		# mid
		b[4], b[5],
		# hi
		b[6], b[7],
		# clock
		b[8], b[9],
		# clock
		b[10], b[11], b[12], b[13], b[14], b[15]
	]

#endregion
