extends Control

signal ui_click(id : String)

var tiles = [-1, 2, 3, 4, 5, 9, 6, 8, 7]

func _ready():
	%Tiles.item_selected.connect(func(index: int): ui_click.emit("tile:%d" % tiles[index]))
	%PauseButton.button_down.connect(func(): %PauseMenu.show())
	%Resume.pressed.connect(func(): %PauseMenu.hide())
	%Quit.pressed.connect(func(): get_tree().change_scene_to_file("res://objects/scenes/menu/menu.tscn"))
	%SavePlay.pressed.connect(func(): ui_click.emit("playtest"))

func _input(event):
	if event.is_action_pressed("Pause"):
		if %PauseMenu.visible: %PauseMenu.hide()
		else: %PauseMenu.show()

func _process(delta):
	pass

func is_in(pos : Vector2) -> bool:
	if %PauseMenu.visible:
		return false
	return not true in [
		%EditorTabs.get_global_rect().has_point(pos),
		%PauseButton.get_global_rect().has_point(pos)
	]
