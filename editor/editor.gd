extends Node2D

@onready var level = $EditedLevel
@onready var tilemap = $EditedLevel/TileMap
@onready var area = %EditorArea
@onready var camera = $Camera2D

func is_in(pos : Vector2) -> bool:
	return (area.global_position.x < pos.x and pos.x < area.global_position.x + area.size.x) and (area.global_position.y < pos.y and pos.y < area.global_position.y + area.size.y)

var touches := []

func _unhandled_input(event):
	camera_input(event)
	if event is InputEventScreenTouch and event.pressed:
		touches[event.index] = event.position
	if event is InputEventScreenTouch and not event.pressed:
		touches.erase(event.index)
	if event is InputEventScreenDrag:
		touches[event.index] = event.position
		print("test")

func _process(delta):
	tilemap_update()

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
	if touches.size() == 1:
		var tile_pos = tilemap.local_to_map(touches[0])
		BetterTerrain.set_cell(tilemap, tile_pos, 2)
		BetterTerrain.update_terrain_cell(tilemap, tile_pos)

#endregion
