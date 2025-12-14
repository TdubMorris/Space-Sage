@tool
extends Node2D

@onready var sprite_b : Sprite2D = $PointB
@onready var segment = $Line2D
@onready var collision = $Area2D/CollisionShape2D

@export_range(0, 200) var length: float = 100 : 
	set(value):
		length = value
		if segment == null:
			return
		segment.points[1].x = value
		sprite_b.position.x = value
		collision.shape.b.x = value

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
