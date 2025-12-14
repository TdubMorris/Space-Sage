@tool
extends Node2D
class_name Checkpoint

@onready var sprite_b : Sprite2D = $PointB
@onready var segment = $Line2D
@onready var collision = $Area2D/CollisionShape2D

@export_range(0,200) var length: float = 100 : set = set_length

func set_length(value):
	length = value
	if segment == null:
		return
	segment.points[1].x = value
	sprite_b.position.x = value
	collision.shape.b.x = value

var triggered : bool = false : set = _set_triggered


func _ready():
	set_length(length)
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
