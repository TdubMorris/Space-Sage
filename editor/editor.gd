extends Node2D

@onready var level = $EditedLevel
@onready var tilemap = $EditedLevel/TileMap
@onready var camera = $Camera2D
@onready var sidebar = %Sidebar

enum EditMode {
	CAMERA,
	TILES,
	ENTITIES,
}

var mode := EditMode.CAMERA

func _ready():
	sidebar.connect("sidebar_click", SidebarClick)

#region - Helper Methods

func screen_to_global(pos : Vector2) -> Vector2:
	return (pos-get_viewport_rect().size/2)/camera.zoom + camera.position

#endregion

#region - Input Handeling

var touches := {}

func _input(event):
	if (event is InputEventScreenTouch or event is InputEventScreenDrag) and !sidebar.is_in(event.position):
		touches.erase(event.index)
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			touches[event.index] = {"start": event.position, "current": event.position, "previous": event.position}
		else:
			touches.erase(event.index)
	elif event is InputEventScreenDrag:
		if touches.has(event.index):
			touches[event.index]["previous"] = touches[event.index]["current"]
			touches[event.index]["current"] = event.position
		else:
			touches[event.index] = {"start": event.position, "current": event.position, "previous": event.position}
		camera_input()
	
	tilemap_update()
#endregion

#region - Sidebar Handeling

func SidebarClick(id : String):
	match id:
		"mode:0":
			mode = EditMode.CAMERA
		"mode:1":
			mode = EditMode.TILES
		"mode:2":
			mode = EditMode.ENTITIES

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
	if mode != EditMode.CAMERA or touches.size() == 0:
		return
	
	var mid : Vector2 = midpoint()
	var prev_mid : Vector2 = midpoint("previous")
	
	var rad : float = radius("current")
	var prev_rad : float = radius("previous")
	
	var movement : Vector2 = mid - prev_mid
	camera.position -= movement/(camera.zoom.x * touches.size())
	
	if touches.size() > 1:
		zoom_camera(rad/prev_rad, screen_to_global(mid))
	

#endregion

#region - Tilemap Editing

enum BrushType {
	PAINT,
	SQUARE,
	FILL
}

func tilemap_update():
	if mode != EditMode.TILES:
		return
	if touches.size() > 0:
		for i in touches:
			var tile_pos_start = tilemap.local_to_map(screen_to_global(touches[i]["previous"]))
			var tile_pos_end = tilemap.local_to_map(screen_to_global(touches[i]["current"]))
			var cells = plotLine(tile_pos_start.x,tile_pos_start.y,tile_pos_end.x,tile_pos_end.y)
			BetterTerrain.set_cells(tilemap, cells, 2)
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


#endregion
