@tool
extends Node2D
class_name Checkpoint

@onready var sprite_b : Sprite2D = $PointB
@onready var segment = $Line2D
@onready var collision = $Area2D/CollisionShape2D

@export var point_b : Vector2 = Vector2(0, 0) : set = _set_point_b

var triggered : bool = false : set = _set_triggered

func _set_point_b(new_value):
	point_b = new_value
	if not sprite_b:
		return
	sprite_b.position = new_value
	segment.points[1] = new_value
	collision.shape.b = new_value

func _ready():
	_set_point_b(point_b)
	_set_triggered(triggered)

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		if TimeManager.currentLap == 0:
			return
		triggered = true

func _set_triggered(newVal : bool): 
	triggered = newVal
	if newVal:
		segment.hide()
	else:
		segment.show()
