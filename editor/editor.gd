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

func is_in(pos : Vector2) -> bool:
	return (area.global_position.x < pos.x and pos.x < area.global_position.x + area.size.x) and (area.global_position.y < pos.y and pos.y < area.global_position.y + area.size.y)

var touches := {}

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touches[event.index] = event.position
		else:
			touches.erase(event.index)
	elif event is InputEventScreenDrag:
		touches[event.index] = event.position
	
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

func tilemap_update():
	if mode != EditMode.TILES:
		return
	if touches.size() > 0:
		for i in touches:
			var touch_pos = (touches[i]-get_viewport_rect().size/2)/camera.zoom + camera.position
			var tile_pos = tilemap.local_to_map(touch_pos)
			BetterTerrain.set_cell(tilemap, tile_pos, 2)
			BetterTerrain.update_terrain_cell(tilemap, tile_pos)

#endregion
