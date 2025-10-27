@tool
extends Node2D

@onready var sprite_b : Sprite2D = $PointB
@onready var segment = $Line2D
@onready var collision = $Area2D/CollisionShape2D

@export var point_b : Vector2 = Vector2(0, 0) : set = _set_point_b

func _set_point_b(new_value):
	point_b = new_value
	if not sprite_b:
		return
	sprite_b.position = new_value
	segment.points[1] = new_value
	collision.shape.b = new_value

func _ready():
	_set_point_b(point_b)

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		if TimeManager.currentLap == 0:
			TimeManager.start()
			TimeManager.lap()
			return
		
		
		var checkpoints : Array[Checkpoint] = []
		for node in get_tree().get_nodes_in_group("Checkpoint"):
			if node is Checkpoint:
				checkpoints.append(node)
		
		for node in checkpoints:
			if node.triggered == false:
				return
		
		if TimeManager.currentLap == TimeManager.maxLaps:
			segment.hide()
			TimeManager.lap()
			return
		
		TimeManager.lap()
		
		for node in checkpoints:
				node.triggered = false
		pass
