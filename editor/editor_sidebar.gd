extends Control

@onready var area = %EditorArea
@onready var modes = %EditModes


signal sidebar_click(id : String)

func _ready():
	modes.select(0)

func _process(delta):
	$HBoxContainer/Panel/Label.text = "FPS: %d" % [1/delta]

func is_in(pos : Vector2) -> bool:
	return (area.global_position.x < pos.x and pos.x < area.global_position.x + area.size.x) and (area.global_position.y < pos.y and pos.y < area.global_position.y + area.size.y)

func _on_item_list_item_selected(index):
	sidebar_click.emit("mode:%d" % [index])
