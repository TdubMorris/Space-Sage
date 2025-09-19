class_name InterfaceTouchButton
extends Control

@export var input_action : StringName
@export var touchscreen_only := false

var touch_index := 0
var released := true

func _init():
	if touchscreen_only and not DisplayServer.is_touchscreen_available():
		hide()

func press():
	var event = InputEventAction.new()
	event.action = input_action
	event.pressed = true
	Input.parse_input_event(event)
	released = false

func release():
	var event = InputEventAction.new()
	event.action = input_action
	event.pressed = false
	Input.parse_input_event(event)
	released = true

func is_in(pos : Vector2) -> bool:
	return (global_position.x < pos.x and pos.x < global_position.x + size.x) and (global_position.y < pos.y and pos.y < global_position.y + size.y)

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed and is_in(event.position):
			if released:
				touch_index = event.index
			if touch_index == event.index:
				press()
			else:
				release()
		if touch_index == event.index and not event.pressed:
			release()
