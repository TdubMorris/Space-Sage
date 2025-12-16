extends Node2D

@onready var level = $EditedLevel
@onready var tilemap = $EditedLevel/TileMap
@onready var area = %EditorArea
@onready var camera = $Camera2D

enum EditMode {
	CAMERA,
	TILES,
	PLACE_ENTITIES,
	EDIT_ENTITIES
}

var mode := EditMode.TILES

#region helper methods
func is_in(pos : Vector2) -> bool:
	return (area.global_position.x < pos.x and pos.x < area.global_position.x + area.size.x) and (area.global_position.y < pos.y and pos.y < area.global_position.y + area.size.y)

func camera_local(pos : Vector2) -> Vector2:
	return (pos-get_viewport_rect().size/2)/camera.zoom + camera.position

#endregion

var touches := {}

func _input(event):
	if (event is InputEventScreenTouch or event is InputEventScreenDrag) and !is_in(event.position):
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
	
	tilemap_update()
	camera_input(event)

#region camera control

func zoom_camera(amount: float, target_position : Vector2):
	var factor = 1 + amount/camera.zoom.x
	camera.zoom *= factor
	var offset = (target_position - camera.position)/factor + camera.position
	camera.position += target_position - offset

func camera_input(event: InputEvent):
	if event.is_action_pressed("Scroll Up"):
		zoom_camera(0.05, get_global_mouse_position())
	if event.is_action_pressed("Scroll Down"):
		zoom_camera(-0.05, get_global_mouse_position())

#endregion

#region tilemap editing

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
			var tile_pos_start = tilemap.local_to_map(camera_local(touches[0]["previous"]))
			var tile_pos_end = tilemap.local_to_map(camera_local(touches[0]["current"]))
			var cells = plotLine(tile_pos_start.x,tile_pos_start.y,tile_pos_end.x,tile_pos_end.y)
			BetterTerrain.set_cells(tilemap, cells, 2)
			BetterTerrain.update_terrain_cells(tilemap, cells)

#Bresnham's Line Algorithm
#ok yes im lazy, this helper function was made by ChatGPT, sue me
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
