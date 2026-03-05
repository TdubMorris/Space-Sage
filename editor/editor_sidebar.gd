extends Control

signal sidebar_click(id : String)

var tiles = [-1, 2, 3, 4, 5, 6, 7, 8, 9]

func _ready():
	%Tiles.item_selected.connect(func(index: int): sidebar_click.emit("tile:%d" % tiles[index]))

func _process(delta):
	pass

func is_in(pos : Vector2) -> bool:
	return not %EditorTabs.get_global_rect().has_point(pos)
