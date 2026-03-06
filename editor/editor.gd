extends Node2D

@onready var level = $EditedLevel
@onready var tilemap = $EditedLevel/TileMap
@onready var camera = $Camera2D
@onready var editor_ui = %EditorUI

var uuid : String = ""

enum EditMode {
	TILES,
	ENTITIES,
}

enum BrushType {
	PAINT,
	RECT,
	FILL
}


var selected_tile : int = -1
var selected_entity : int = 0
var current_brush : BrushType = BrushType.PAINT

var mode := EditMode.TILES

func _ready():
	editor_ui.connect("ui_click", UIClick)

#region - Helper Methods

func screen_to_global(pos : Vector2) -> Vector2:
	return (pos-get_viewport_rect().size/2)/camera.zoom + camera.position

#endregion

#region - Input Handeling

var touches := {}
var mm := {} #used for middle mouse panning

func _process(delta: float):
	for touch in touches:
		touches[touch]["time"] += delta
	tilemap_update()
	
	#middle mouse camera pan
	if Input.is_action_pressed("Pan") and editor_ui.is_in(get_viewport().get_mouse_position()):
		if mm.size() == 2:
			var movement = mm["cur"]-mm["prev"]
			camera.position -= movement/camera.zoom.x
			clamp_camera()
			mm["prev"] = mm["cur"]
			mm["cur"] = get_viewport().get_mouse_position()
		elif mm.size() == 1:
			mm["prev"] = mm["cur"]
			mm["cur"] = get_viewport().get_mouse_position()
		elif mm.size() == 0:
			mm["cur"] = get_viewport().get_mouse_position()
	else:
		mm = {}

func _input(event):
	if (event is InputEventScreenTouch or event is InputEventScreenDrag) and !editor_ui.is_in(event.position):
		touches.erase(event.index)
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			touches[event.index] = {"start": event.position, "current": event.position, "previous": event.position, "time": 0}
			for touch in touches:
				touches[touch]["time"] = 0
		else:
			for touch in touches:
				touches[touch]["time"] = 0
			touches.erase(event.index)
	elif event is InputEventScreenDrag:
		if touches.has(event.index):
			touches[event.index]["previous"] = touches[event.index]["current"]
			touches[event.index]["current"] = event.position
		else:
			touches[event.index] = {"start": event.position, "current": event.position, "previous": event.position, "time": 0}
			for touch in touches:
				touches[touch]["time"] = 0
		camera_input()
	
	if event.is_action_pressed("Scroll Up") and editor_ui.is_in(get_viewport().get_mouse_position()):
		zoom_camera(1.1,get_global_mouse_position())
		clamp_camera()
	
	if event.is_action_pressed("Scroll Down") and editor_ui.is_in(get_viewport().get_mouse_position()):
		zoom_camera(0.9,get_global_mouse_position())
		clamp_camera()

#endregion

#region - Sidebar Handeling

func UIClick(id : String):
	match id:
		"mode:0":
			mode = EditMode.TILES
		"mode:1":
			mode = EditMode.ENTITIES
		"playtest":
			playtest()
		"brush:0":
			current_brush = BrushType.PAINT
		"brush:1":
			current_brush = BrushType.FILL
	
	var splitId = id.split(":")
	if splitId[0] == "tile":
		selected_tile = int(splitId[1])

#endregion

#region - Camera Control

var max_zoom : float = 4
var min_zoom : float = 0.5

func zoom_camera(factor: float, target_position : Vector2):
	factor = clamp(factor, 0.25/camera.zoom.x, 4/camera.zoom.x)
	camera.zoom *= factor
	var offset = (target_position - camera.position)/factor + camera.position
	camera.position += target_position - offset

func midpoint(type:String = "current"):
	if touches.size() == 0:
		return null
	var mid := Vector2(0,0)
	for i in touches.values():
		mid += i[type]
	mid /= touches.size()
	return mid

func radius(type:String = "current"):
	if touches.size() == 0:
		return null
	var mid : Vector2 = midpoint(type)
	var rad : float = 0
	for i in touches.values():
		rad += mid.distance_to(i[type])
	rad /= touches.size()
	return rad

func camera_input():
	
	if touches.size() <= 1:
		return
	
	var mid : Vector2 = midpoint()
	var prev_mid : Vector2 = midpoint("previous")
	
	var rad : float = radius("current")
	var prev_rad : float = radius("previous")
	
	var movement : Vector2 = mid - prev_mid
	camera.position -= movement/(camera.zoom.x * touches.size())
	
	if touches.size() > 1:
		zoom_camera(rad/prev_rad, screen_to_global(mid))
	
	clamp_camera()
	

func clamp_camera():
	camera.global_position.x = clamp(camera.global_position.x, -4000, 4000)
	camera.global_position.y = clamp(camera.global_position.y, -4000, 4000)

#endregion

#region - Tilemap Editing

func tilemap_update():
	if mode != EditMode.TILES:
		return
	if touches.size() != 1 or touches[touches.keys()[0]]["time"] < 0.05:
		return
	
	for i in touches:
		var tile_pos_start = tilemap.local_to_map(screen_to_global(touches[i]["previous"]))
		var tile_pos_end = tilemap.local_to_map(screen_to_global(touches[i]["current"]))
		var cells = plotLine(tile_pos_start.x,tile_pos_start.y,tile_pos_end.x,tile_pos_end.y)
		BetterTerrain.set_cells(tilemap, cells.filter(
			func(cell): return cell.x >= -250 and cell.x <= 250 and cell.y >= -250 and cell.y <= 250
		), selected_tile)
		BetterTerrain.update_terrain_cells(tilemap, cells)

#Bresnham's Line Algorithm
#ok yes im lazy, this helper function was made by ChatGPT, sue me or something (please dont)
func plotLine(x0: int, y0: int, x1: int, y1: int) -> Array[Vector2i]:
	var points: Array[Vector2i] = []
	var dx : int = abs(x1 - x0)
	var dy : int = abs(y1 - y0)
	var sx := 1 if x0 < x1 else -1
	var sy := 1 if y0 < y1 else -1
	var err : int = dx - dy
	while true:
		points.append(Vector2i(x0, y0))
		if x0 == x1 and y0 == y1:
			break
		var e2 := err * 2
		if e2 > -dy:
			err -= dy
			x0 += sx
		if e2 < dx:
			err += dx
			y0 += sy
	return points

#Floodfill algorithm
func fill(pos: Vector2i) -> Array[Vector2i]:
	var stack = []
	return stack

#endregion

#region - Level Saving

func playtest():
	save_level()
	FileManager.load_from_resource("test")

func save_level():
	var leveldata = LevelResource.new()
	leveldata.tile_map_data = tilemap.tile_map_data
	leveldata.uuid = uuid
	if not DirAccess.dir_exists_absolute("user://levels"):
		DirAccess.make_dir_absolute("user://levels")
	print(ResourceSaver.save(leveldata, "user://levels/%s.res" % "test", ResourceSaver.FLAG_COMPRESS))
	print(OS.get_user_data_dir())

#endregion
