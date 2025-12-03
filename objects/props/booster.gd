extends Node2D


func _ready():
	$AnimatedSprite2D.play("default")

func _on_area_2d_body_entered(body):
	if body is Racer:
		body.apply_impulse(Vector2(0,-500).rotated(rotation))
