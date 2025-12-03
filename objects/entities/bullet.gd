extends Node2D
class_name Bullet

@onready var raycast = $RayCast2D
@export var velocity: Vector2
@export var shooter: Node

func _process(delta):
	raycast.target_position = to_local(position + velocity * delta)
	if raycast.is_colliding():
		collision_check(raycast.get_collider())
	position += velocity * delta

func collision_check(body : Node2D):
	if body == shooter:
		return
	if body.owner.has_method("hit"):
		body.owner.hit()
	queue_free()

func _on_area_2d_body_entered(body):
	collision_check(body)
