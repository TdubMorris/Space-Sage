extends Node2D
class_name Bullet

@export var velocity: Vector2
@export var shooter: Node

func _process(delta):
	position += velocity * delta

func _on_area_2d_body_entered(body):
	if body != shooter:
		if body.owner.has_method("hit"):
			body.owner.hit()
		queue_free()
